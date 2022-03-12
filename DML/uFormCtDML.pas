unit uFormCtDML;

{$MODE Delphi}

{$WARN 5057 off : Local variable "$1" does not seem to be initialized}
interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  CtMetaTable, uFrameDML, DMLObjs, WindowFuncs;

type

  { TfrmCtDML }

  TfrmCtDML = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { Private declarations }
    FReadOnlyMode: boolean;
    FMetaTableModel: TCtDataModelGraph;
    FCurMetaTableModel: TCtDataModelGraph;
    FTempMetaTableModel: TCtDataModelGraph;
    FLastLinkField: TCtMetaField;
    FCtDmlRefreshing: boolean;
    FLastRefreshTick: int64;

    procedure InitDML(mdl: TCtDataModelGraph);
    procedure actDMLObjPropExecuteEx(Sender: TObject);
    procedure actRearrangeExecuteEx(Sender: TObject);
    procedure actColorStylesExecute(Sender: TObject);
    procedure actExportXlsExecute(Sender: TObject);
    procedure actShowPhyViewExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actPasteUpdate(Sender: TObject);
    procedure actFindObjectExeucte(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actBatchOpsExecute(Sender: TObject);
    procedure actBriefModeExecute(Sender: TObject);
    procedure actCopyDmlTextExecuteEx(Sender: TObject);   
    procedure actDBGenSqlExecuteEx(Sender: TObject);

    procedure DoExportHtmlDoc(tfn: string);     
    procedure DoExportMarkdown(tfn: string);
    procedure DoExecScript(fn, tfn: string);

    procedure CheckDmlTableFieldProps(ctb: TCtMetaTable; obj: TDMLTableObj);
    function GetLocationDesc(Obj: TDMLObj): string;
    procedure SetLocationDesc(Obj: TDMLObj; Des: string);

    procedure _OnObjsMoved(Sender: TObject);
    //Act: 1-add 2-remove
    function _OnObjAddOrRemove(Obj: TDMLObj; Act: integer): boolean;
    function _OnLinkObj(Obj1, Obj2: TDMLObj): integer;
    procedure _DoCapitalize(sType: string);
    procedure _DoBatCopy(sType: string);

    procedure CheckAllLinks;
    procedure ResortToolBtns;
    procedure ResetCtFieldTextColor;
  public
    { Public declarations }
    //tp: 0=Obj1.Prop,1=move,2=Obj1.Child
    Proc_OnPropChange:
    procedure(Tp: integer; Obj1, Obj2: TCtMetaObject; param: string) of object;
    Proc_OnRefresh:
    procedure(Sender: TObject) of object;
    Proc_OnCanNotShowObjProp:
    procedure(Sender: TObject) of object;
    Proc_OnCanNotCopyDmlText:
    procedure(Sender: TObject) of object;

    FFrameCtDML: TFrameDML;

    procedure Init(mdl: TCtDataModelGraph; bReadOnly, bCanCancel: boolean);
    procedure CheckSelectedTb;
    function GetSelectedTable: TCtMetaTable;
    function GetSelectedCtObj: TCtMetaObject;
    function LocToCtObj(obj: TCtMetaObject): boolean;
    procedure ReloadTbInfo(tb: TCtMetaTable);
    procedure RewriteGraphDesc;
    procedure RearrangeAll;
    procedure ReassignActionList;
    property MetaTableModel: TCtDataModelGraph read FMetaTableModel;
  end;

implementation

uses
  CTMetaData, uFormAddTbLink, dmlstrs, ezdmlstrs, CtObjXmlSerial, ClipBrd,
  DmlScriptPublic, ImgView, ide_editor, AutoNameCapitalize, uFormGenSql;

{$R *.lfm}


procedure TfrmCtDML.Init(mdl: TCtDataModelGraph; bReadOnly, bCanCancel: boolean);
begin
  ResortToolBtns;
  FReadOnlyMode := bReadOnly;
  FMetaTableModel := mdl;
  if FMetaTableModel = nil then
  begin
    FReadOnlyMode := True;
    if Assigned(FTempMetaTableModel) then
      FreeAndNil(FTempMetaTableModel);
  end
  else if not bCanCancel then
  begin
    if Assigned(FTempMetaTableModel) then
      FreeAndNil(FTempMetaTableModel);
  end
  else
  begin
    if FTempMetaTableModel = nil then
      FTempMetaTableModel := TCtDataModelGraph.Create;
    FTempMetaTableModel.AssignFrom(FMetaTableModel);
  end;

  FFrameCtDML.ToolBar1.Visible := not FReadOnlyMode or bCanCancel;
  FFrameCtDML.StatusBar1.Visible := False;
  FFrameCtDML.actNewObj.Visible := not FReadOnlyMode;
  FFrameCtDML.actNewText.Visible := not FReadOnlyMode;      
  FFrameCtDML.actAddLink.Visible := not FReadOnlyMode;
  FFrameCtDML.actDeleteObj.Visible := not FReadOnlyMode;
  FFrameCtDML.actSetEntityColor.Visible := not FReadOnlyMode;      
  FFrameCtDML.actResetObjLinks.Visible := not FReadOnlyMode;

  FFrameCtDML.actDMLObjProp.Visible := Assigned(mdl);
  FFrameCtDML.actCopyImage.Visible := Assigned(mdl);
  FFrameCtDML.actCopyDmlText.Visible := Assigned(mdl);      
  FFrameCtDML.actSelectAll.Visible := Assigned(mdl);
  FFrameCtDML.actExportXls.Visible := Assigned(mdl);         
  FFrameCtDML.actDBGenSql.Visible := Assigned(mdl);
  FFrameCtDML.actFindObject.Visible := Assigned(mdl);

  if bCanCancel then
    FCurMetaTableModel := FTempMetaTableModel
  else
    FCurMetaTableModel := FMetaTableModel;
  InitDML(FCurMetaTableModel);
end;

procedure TfrmCtDML.ReloadTbInfo(tb: TCtMetaTable);
var
  S: string;
  I, J: integer;
  tmpList: TList;
  DMLObjList: TDMLObjList;
  obj2: TDMLObj;
  tb2: TCtMetaTable;
  lnk: TDMLLinkObj;
begin
  if not Assigned(tb) then
    Exit;

  if FReadOnlyMode then
    Exit;

  S := tb.Name;
  DMLObjList := FFrameCtDML.DMLGraph.DMLObjs;
  tmpList := TList.Create;
  try
    for I := 0 to DMLObjList.Count - 1 do
    begin
      if DMLObjList[I] is TDMLTableObj then
        if (TDMLTableObj(DMLObjList[I]).Name = S) or
          (TDMLTableObj(DMLObjList[I]).PhyTbName = S)
          or (DMLObjList[I].UserObject = tb) then
        begin
          tmpList.Add(DMLObjList[I]);
        end;
    end;
    for I := 0 to tmpList.Count - 1 do
    begin
      obj2 := tmpList[I];
      tb2 := TCtMetaTable(TDMLTableObj(obj2).UserObject);
      TDMLTableObj(obj2).Describe := tb2.Describe;
      CheckDmlTableFieldProps(tb2, TDMLTableObj(obj2));
      TDMLTableObj(obj2).CheckResize;
      TDMLTableObj(obj2).FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs);
    end;
    CheckAllLinks;
    for I := 0 to tmpList.Count - 1 do
    begin
      obj2 := tmpList[I]; //增删字段后，需要重新计算连线起止点
      TDMLTableObj(obj2).CheckPositions;

      tb2 := TCtMetaTable(TDMLTableObj(obj2).UserObject);
      tb2.GraphDesc := Self.GetLocationDesc(obj2);

      if not DMLObjList.BriefMode then
      begin
        for J := 0 to DMLObjList.Count - 1 do
          if DMLObjList.Items[J] is TDMLLinkObj then
          begin
            lnk := TDMLLinkObj(DMLObjList.Items[J]);
            if lnk.UserObject is TCtMetaField then
            begin
              if (lnk.Obj1 = obj2) or (lnk.Obj2 = obj2) then
              begin
                TCtMetaField(lnk.UserObject).GraphDesc := Self.GetLocationDesc(lnk);
              end;
            end;
          end;
      end;
    end;
  finally
    tmpList.Free;
  end;
  FFrameCtDML.DMLGraph.Refresh;
end;

procedure TfrmCtDML.FormCreate(Sender: TObject);
begin
  FFrameCtDML := TFrameDML.Create(Self);
  FFrameCtDML.Name := 'FrameCtDML';
  FFrameCtDML.Parent := Self;
  FFrameCtDML.Align := alClient;
  //FFrameCtDML.DMLGraph.DMLDrawer.HideSelectedField := True;
  FFrameCtDML.DMLGraph.OnMoveObj := _OnObjsMoved;
  FFrameCtDML.Proc_OnObjAddOrRemove := _OnObjAddOrRemove;
  FFrameCtDML.Proc_OnLinkObj := _OnLinkObj;
  FFrameCtDML.Proc_DoCapitalize := _DoCapitalize;
  FFrameCtDML.Proc_DoBatCopy := _DoBatCopy;

  FFrameCtDML.actDMLObjProp.OnExecute := actDMLObjPropExecuteEx;
  FFrameCtDML.actRearrange.OnExecute := actRearrangeExecuteEx;
  FFrameCtDML.actColorStyles.OnExecute := actColorStylesExecute;
  FFrameCtDML.actExportXls.OnExecute := actExportXlsExecute;
  FFrameCtDML.actShowPhyView.OnExecute := actShowPhyViewExecute;
  FFrameCtDML.actCopy.OnExecute := actCopyExecute;
  FFrameCtDML.actPaste.OnExecute := actPasteExecute;
  FFrameCtDML.actPaste.OnUpdate := actPasteUpdate;
  FFrameCtDML.actFindObject.OnExecute := actFindObjectExeucte;
  FFrameCtDML.actRefresh.OnExecute := actRefreshExecute;
  FFrameCtDML.actBriefMode.OnExecute := actBriefModeExecute;
  FFrameCtDML.actCopyDmlText.OnExecute := actCopyDmlTextExecuteEx;      
  FFrameCtDML.actDBGenSql.OnExecute := actDBGenSqlExecuteEx;

  FFrameCtDML.actBatchOps.OnExecute := actBatchOpsExecute;
  FFrameCtDML.actBatchOps.Visible := True;

  {FFrameCtDML.actFileNew.Visible := False;
  FFrameCtDML.actFileNew.Enabled := False;
  FFrameCtDML.actFileOpen.Visible := False;
  FFrameCtDML.actFileOpen.Enabled := False;
  FFrameCtDML.actFileSave.Visible := False;
  FFrameCtDML.actFileSave.Enabled := False;}

  FFrameCtDML.actCheckFKLinks.Visible := False;
  FFrameCtDML.actImportDB.Visible := False;
  //FFrameCtDML.actDBGenSql.Visible := False;
  FFrameCtDML.actCopy.Visible := True;
  FFrameCtDML.actPaste.Visible := True;
  FFrameCtDML.actNewFlowObj.Visible := False;
  FFrameCtDML.actNewText.Visible := True;
  FFrameCtDML.actShowHideProps.Visible := False;
  FFrameCtDML.actAutoA.Visible := False;
  FFrameCtDML.ToolButtonDMLsp1.Visible := False;
  FFrameCtDML.ToolButtonDMLsp3.Visible := False;

  FFrameCtDML.actShowHideProps.Checked := False;
  FFrameCtDML.splProperty.Hide;
  FFrameCtDML.pnlProperty.Hide;

  ResortToolBtns;
end;

procedure TfrmCtDML.FormDestroy(Sender: TObject);
begin
  if Assigned(FTempMetaTableModel) then
    FreeAndNil(FTempMetaTableModel);
end;

procedure TfrmCtDML.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOk then
    if not FReadOnlyMode and Assigned(FTempMetaTableModel) then
      FMetaTableModel.AssignFrom(FTempMetaTableModel);
end;

procedure TfrmCtDML.actBatchOpsExecute(Sender: TObject);

  function EditScriptFile: boolean;
  var
    tb: TCtMetaTable;
    I: integer;
  begin
    Result := False;
    if not Assigned(scriptIdeEditor) then
      Application.CreateForm(TfrmScriptIDE, scriptIdeEditor);

    FGlobeDataModelList.CurDataModel.Param['ShowPhyFieldName'] :=
      IntToStr(FFrameCtDML.DMLGraph.DMLDrawer.ShowPhyFieldName);
    FGlobeDataModelList.CurDataModel.Param['DatabaseEngine'] :=
      FFrameCtDML.DMLGraph.DMLDrawer.DatabaseEngine;

    CheckSelectedTb;

    tb := nil;
    with FFrameCtDML.DMLGraph.DMLObjs do
      for I := 0 to Count - 1 do
        if Items[I].Selected then
          if Items[I] is TDMLTableObj then
          begin
            tb := TCtMetaTable(Items[I].UserObject);
            if tb = nil then
              Continue;
            Break;
          end;

    with scriptIdeEditor do
    begin
      DmlScInit('', tb, nil, nil);
      ed.ClearAll;
      //New.Execute;
      TryLoadLastFile;
      FileModified := ed.Modified;
      ShowModal;
      Result := FileModified;
    end;
  end;

begin
  EzdmlMenuActExecuteEvt('Model_ExecScript');
 (*
var
  fn: String;
  with TOpenDialog.Create(Self) do
  try
    Filter := 'Pascal script file(*.pas)|*.pas';
    //Options := Options + [ofFileMustExist];
    DefaultExt := 'pas';
    if Execute then
      fn := FileName
    else
      Exit;
  finally
    Free;
  end;  *)
  EditScriptFile;
end;

procedure TfrmCtDML.actBriefModeExecute(Sender: TObject);
var
  cx, cy: double;
begin
  with FFrameCtDML do
  begin
    cx := DMLGraph.ScreenToImageX(DMLGraph.Width div 2);
    cy := DMLGraph.ScreenToImageY(DMLGraph.Height div 2);
    DMLGraph.DMLObjs.BriefMode := not DMLGraph.DMLObjs.BriefMode;
    if not DMLGraph.DMLObjs.BriefMode then
      CheckAllLinks;
    //DMLGraph.Refresh;    
    if DMLGraph.DMLObjs.BriefMode then
    begin
      cx := cx / 2;
      cy := cy / 2;
    end
    else
    begin
      cx := cx * 2;
      cy := cy * 2;
    end;
    cx := cx - DMLGraph.DMLDrawer.DrawerWidth / 2;
    cy := cy - DMLGraph.DMLDrawer.DrawerHeight / 2;
    DMLGraph.SetViewXYSc(cx, cy, DMLGraph.ViewScale);
  end;
end;

procedure TfrmCtDML.actColorStylesExecute(Sender: TObject);
begin
  CheckCanEditMeta;
  EzdmlMenuActExecuteEvt('Model_ColorStyles');
  FFrameCtDML.actColorStylesExecute(Sender);
  if FReadOnlyMode then
    Exit;
  ResetCtFieldTextColor;
  if FCurMetaTableModel <> nil then
  begin
    FCurMetaTableModel.ConfigStr := FFrameCtDML.DMLGraph.DMLDrawer.GetConfigStr;
  end;
end;

procedure TfrmCtDML.actCopyDmlTextExecuteEx(Sender: TObject);
begin
  if not FFrameCtDML.DMLGraph.CanFocus then
  begin
    if Assigned(Proc_OnCanNotCopyDmlText) then
      Proc_OnCanNotCopyDmlText(Self);
    Exit;
  end;
  FFrameCtDML.actCopyDmlTextExecute(Sender);
end;

procedure TfrmCtDML.actDBGenSqlExecuteEx(Sender: TObject);
var
  I: integer;
  tbs: TCtMetaTableList;
begin
  tbs := TCtMetaTableList.Create;
  try
    tbs.AutoFree := False;     
    with FFrameCtDML.DMLGraph.DMLObjs do
      for I := 0 to Count - 1 do
        if Items[I].Selected then
          if (Items[I] <> nil) and (Items[I].UserObject is TCtMetaTable) then  
            if TCtMetaTable(Items[I].UserObject).IsTable then
            begin
              tbs.Add(TCtMetaTable(Items[I].UserObject));
            end;

    if not Assigned(frmCtGenSQL) then
      frmCtGenSQL := TfrmCtGenSQL.Create(Self);
    if tbs.Count > 0 then
      frmCtGenSQL.MetaObjList := tbs
    else
      frmCtGenSQL.CtDataModelList := FGlobeDataModelList;
    frmCtGenSQL.SetWorkMode(0);

    if frmCtGenSQL.ShowModal = mrOk then
    begin
    end;
    frmCtGenSQL.CtDataModelList := FGlobeDataModelList;
  finally
    tbs.Free;
  end;
end;

procedure TfrmCtDML.actCopyExecute(Sender: TObject);
var
  I, C: integer;
  o: TDMLEntityObj;
  vTb, tb: TCtMetaTable;
  vTempTbs: TCtMetaTableList;
  fs: TCtObjMemXmlStream;
  ss: TStringList;
begin
  C := 0;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLEntityObj then
        begin
          Inc(C);
        end;
  if C = 0 then
    Exit;

  vTempTbs := TCtMetaTableList.Create;
  fs := TCtObjMemXmlStream.Create(False);
  ss := TStringList.Create;
  Screen.Cursor := crAppStart;
  try

    with FFrameCtDML.DMLGraph.DMLObjs do
      for I := 0 to Count - 1 do
        if Items[I].Selected then
          if Items[I] is TDMLEntityObj then
          begin
            o := TDMLEntityObj(Items[I]);
            tb := TCtMetaTable(o.UserObject);
            if tb = nil then
              Continue;

            vTb := vTempTbs.NewTableItem;
            vTb.AssignFrom(tb);
          end;
    fs.RootName := 'Tables';
    vTempTbs.SaveToSerialer(fs);
    fs.Stream.Seek(0, soFromBeginning);
    ss.LoadFromStream(fs.Stream);
    Clipboard.AsText := ss.Text;
  finally
    vTempTbs.Free;
    fs.Free;
    ss.Free;
    Screen.Cursor := crDefault;
  end;
  Exit;
end;

procedure TfrmCtDML.actDMLObjPropExecuteEx(Sender: TObject);
var
  obj, obj2: TDMLObj;
  tb, tb2: TCtMetaTable;
  cf: TCtMetaField;
  f: TDMLField;
  S, oName: string;
  olnk, lnk: TDMLLinkObj;
  I, J: integer;
  DMLObjList: TDMLObjList;
  tmpList: TList;
  bRes: boolean;
begin
  if not FFrameCtDML.DMLGraph.CanFocus then
  begin
    if Assigned(Proc_OnCanNotShowObjProp) then
      Proc_OnCanNotShowObjProp(Self);
    Exit;
  end;
  if FFrameCtDML.DMLGraph.DMLObjs.SelectedCount = 0 then
  begin
    FFrameCtDML.actColorStyles.Execute;
    Exit;
  end;
  if FFrameCtDML.DMLGraph.DMLObjs.SelectedCount <> 1 then
    Exit;
  obj := FFrameCtDML.DMLGraph.DMLObjs.SelectedObj;
  EzdmlMenuActExecuteEvt('Model_ShowProp', obj);
  if (obj is TDMLLinkObj) and (obj.UserObject is TCtMetaField) then
  begin
    olnk := TDMLLinkObj(obj);
    if (olnk.Obj1.UserObject is TCtMetaTable) then
      if (olnk.Obj2.UserObject is TCtMetaTable) then
      begin
        cf := (obj.UserObject as TCtMetaField);
        if ExecEditTbLink(olnk.Obj1.UserObject as TCtMetaTable,
          olnk.Obj2.UserObject as TCtMetaTable,
          cf) then
        begin
          obj := olnk.Obj2;
          olnk.UserObject := cf;
          tb := TDMLTableObj(olnk.Obj2).UserObject as TCtMetaTable;
          if obj is TDMLTableObj then
          begin
            TDMLTableObj(obj).Describe := tb.Describe;
            CheckDmlTableFieldProps(tb, TDMLTableObj(obj));
            olnk.ResetRelateTbFieldSelected;
            TDMLTableObj(obj).CheckResize;
            TDMLTableObj(obj).FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs);
          end
          else
          begin
            olnk.Obj1Field := '';
            olnk.Obj2Field := '';
            olnk.ResetRelateTbFieldSelected;
            obj.CheckResize;
          end;
          CheckAllLinks;
          FFrameCtDML.DMLGraph.Refresh;
        end;
        Exit;
      end;
    Exit;
  end;


  if (obj is TDMLTableObj) and
    (TDMLTableObj(obj).UserObject is TCtMetaTable) then
  begin
    tb := TCtMetaTable(TDMLTableObj(obj).UserObject);
    cf := nil;
    if (TDMLTableObj(obj).SelectedFieldIndex > 0) and not
      FFrameCtDML.DMLGraph.DMLDrawer.HideSelectedField then
    begin
      f := TDMLTableObj(obj).Field[TDMLTableObj(obj).SelectedFieldIndex - 1];
      S := f.Get_PhyName;
      if S <> '' then
      begin
        cf := TCtMetaField(tb.MetaFields.ItemByName(S));
        if (cf <> nil) and not Assigned(Proc_ShowCtTableOfField) then
        begin
          if not Assigned(Proc_ShowCtFieldProp) then
            raise Exception.Create('Proc_ShowCtFieldProp not defined');
          if Proc_ShowCtFieldProp(cf, FReadOnlyMode or IsEditingMeta) then
          begin
            if FReadOnlyMode then
              Exit;
            TDMLTableObj(obj).Describe := tb.Describe;
            CheckDmlTableFieldProps(tb, TDMLTableObj(obj));
            TDMLTableObj(obj).CheckResize;
            TDMLTableObj(obj).FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs);
            CheckAllLinks;
            FFrameCtDML.DMLGraph.Refresh;
            if Assigned(Proc_OnPropChange) then
              Proc_OnPropChange(2, tb, nil, '');
          end;
          Exit;
        end;
      end;
    end;

    if not Assigned(Proc_ShowCtTableProp) then
      raise Exception.Create('Proc_ShowCtTableProp not defined');
    oName := tb.Name;
    if Assigned(cf) and Assigned(Proc_ShowCtTableOfField) then
      bRes := Proc_ShowCtTableOfField(tb, cf, FReadOnlyMode or
        IsTbPropDefViewMode, False, False)
    else
      bRes := Proc_ShowCtTableProp(tb, FReadOnlyMode or IsTbPropDefViewMode, False);
    if bRes then
    begin
      if FReadOnlyMode then
        Exit;
      //SaveToTb(tb);
      S := tb.Name;
      TDMLTableObj(obj).Name := S;
      DMLObjList := FFrameCtDML.DMLGraph.DMLObjs;
      tmpList := TList.Create;
      try
        for I := 0 to DMLObjList.Count - 1 do
        begin
          if DMLObjList[I] is TDMLTableObj then
            if (TDMLTableObj(DMLObjList[I]).Name = S) or
              (TDMLTableObj(DMLObjList[I]).PhyTbName = S) then
            begin
              tmpList.Add(DMLObjList[I]);
            end;
        end;
        for I := 0 to tmpList.Count - 1 do
        begin
          obj2 := tmpList[I];
          tb2 := TCtMetaTable(TDMLTableObj(obj2).UserObject);
          TDMLTableObj(obj2).Describe := tb2.Describe;  
          TDMLTableObj(obj2).IsView := not tb2.GenDatabase;
          CheckDmlTableFieldProps(tb2, TDMLTableObj(obj2));
          TDMLTableObj(obj2).CheckResize;
          TDMLTableObj(obj2).FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs);
        end;
        CheckAllLinks; //添加缺失的连线
        for I := 0 to tmpList.Count - 1 do
        begin
          obj2 := tmpList[I]; //增删字段后，需要重新计算连线起止点
          TDMLTableObj(obj2).CheckPositions;

          tb2 := TCtMetaTable(TDMLTableObj(obj2).UserObject);
          tb2.GraphDesc := Self.GetLocationDesc(obj2);

          if not DMLObjList.BriefMode then
          begin
            for J := 0 to DMLObjList.Count - 1 do
              if DMLObjList.Items[J] is TDMLLinkObj then
              begin
                lnk := TDMLLinkObj(DMLObjList.Items[J]);
                if lnk.UserObject is TCtMetaField then
                begin
                  if (lnk.Obj1 = obj2) or (lnk.Obj2 = obj2) then
                  begin
                    TCtMetaField(lnk.UserObject).GraphDesc := Self.GetLocationDesc(lnk);
                  end;
                end;
              end;

          end;

        end;
      finally
        tmpList.Free;
      end;

      FFrameCtDML.DMLGraph.Refresh;
      if Assigned(Proc_OnPropChange) then
        Proc_OnPropChange(2, tb, nil, '');
      if oName <> tb.Name then
      begin
        FFrameCtDML.actRefresh.Execute;
      end;
    end;
    Exit;
  end;

  if (obj is TDMLTextObj) and
    (TDMLTextObj(obj).UserObject is TCtMetaTable) then
  begin
    tb := TCtMetaTable(TDMLTextObj(obj).UserObject);
    if not Assigned(Proc_ShowCtTableProp) then
      raise Exception.Create('Proc_ShowCtTableProp not defined');
    if Proc_ShowCtTableProp(tb, FReadOnlyMode or IsTbPropDefViewMode, False) then
    begin
      if FReadOnlyMode then
        Exit;
      //SaveToTb(tb);
      TDMLTextObj(obj).Comment := tb.Memo;
      TDMLTextObj(obj).CheckResize;
      FFrameCtDML.DMLGraph.Refresh;
      if Assigned(Proc_OnPropChange) then
        Proc_OnPropChange(2, tb, nil, '');
    end;
    Exit;
  end;
end;

procedure TfrmCtDML.actExportXlsExecute(Sender: TObject);
var
  I, C: integer;
  fn, S: string;
begin
  EzdmlMenuActExecuteEvt('Model_Export');

  C := 0;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLTableObj then
        begin
          Inc(C);
        end;
  //bAll := False;
  //if C = 0 then
  //  bAll := True; //raise Exception.Create(srCannotExportEmptySelection);

  with TSaveDialog.Create(Self) do
    try
      Filter :=
        'Markdown file(*.md)|*.md|Word file(*.doc)|*.doc|Excel file(*.xls)|*.xls|Mht file(*.mht)|*.mht|Html file(*.html)|*.html'
        + '|Bitmap Image file(*.bmp)|*.bmp|JPEG Image file(*.jpg)|*.jpg'
        + '|Portable Network Image file(*.png)|*.png';//|Meta Image file(*.wmf)|*.wmf';
      Options := Options + [ofOverwritePrompt];
      DefaultExt := 'xls';
      if C > 0 then
        FileName := Self.FCurMetaTableModel.Name
      else
        FileName := ChangeFileExt(ExtractFileName(FCurDmlFileName), '');
      if Execute then
        fn := FileName
      else
        Exit;
    finally
      Free;
    end;

  S := LowerCase(ExtractFileExt(fn));    
  if (S = '.md') then
  begin
    DoExportMarkdown(fn);
    Exit;
  end;
  if (S = '.xls') or (S = '.doc') or (s = '.html') or (s = '.mht') then
  begin
    DoExportHtmlDoc(fn);
    Exit;
  end;
  if (S = '.png') or (S = '.bmp') or (S = '.jpg') or (S = '.wmf') then
  begin
    FFrameCtDML.SaveDmlImage(fn);
    Exit;
  end;

  raise Exception.Create('Not supported format: ' + s);
  //FFrameCtDML.ExportToExcel(fn);
end;

procedure TfrmCtDML.actFindObjectExeucte(Sender: TObject);
var
  res: TCtMetaObjectList;
  tb: TCtMetaTable;
  I, J: integer;
begin
  if not Assigned(Proc_ShowCtDmlSearch) then
    raise Exception.Create('Proc_ShowCtDmlSearch not defined');

  res := TCtMetaObjectList.Create;
  try
  {
  dm: TCtDataModelGraphList;
  dm := TCtDataModelGraphList.Create;
    dm.AutoFree := False;
    dm.Add(FCurMetaTableModel);
    dm.Free;
    }
    if not Proc_ShowCtDmlSearch(FGlobeDataModelList, res) then
      Exit;
    if res.Count = 0 then
      Exit;
    if res.Count = 1 then
    begin
      Self.LocToCtObj(TCtMetaObject(res[0]));
      Exit;
    end;
    FFrameCtDML.DMLGraph.DMLObjs.ClearSelection;
    for I := 0 to res.Count - 1 do
      if res[I] is TCtMetaField then
      begin
        tb := TCtMetaField(res[I]).OwnerTable;
        with FFrameCtDML.DMLGraph.DMLObjs do
          for J := 0 to Count - 1 do
            if Items[J] is TDMLTableObj then
              if tb = TCtMetaTable(Items[J].UserObject) then
              begin
                Items[J].Selected := True;
                if I = 0 then
                  FFrameCtDML.DMLGraph.MakeObjVisible(Items[J]);
              end;
      end;
    FFrameCtDML.DMLGraph.Refresh;
  finally
    res.Free;
  end;
end;

procedure TfrmCtDML.actPasteExecute(Sender: TObject);
var
  vTempTbs: TCtMetaTableList;

  procedure RenameTbIfExists(tb: TCtMetaTable);
  var
    n: integer;
  begin           
    if Sender = nil then
      Exit;

    if tb.IsTable then
      if FCurMetaTableModel.Tables.ItemByName(tb.Name) = nil then
        Exit;
    if not HasSameNameTables(tb, tb.Name) then
      Exit;

    n := 1;
    while HasSameNameTables(tb, tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n))) do
      Inc(n);
    tb.Name := tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));
  end;
      
  procedure RenameAllTbs;
  var
    n, I, J, K: integer;
    tb, vtb: TCtMetaTable;
    AOldName: string;
  begin
    for I:=0 to vTempTbs.Count - 1 do
    begin
      tb := vTempTbs[I];  
      AOldName := tb.Name;

      n := 1;
      while HasSameNameTables(tb, tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n))) do
        Inc(n);
      tb.Name := tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));

      for J:=0 to vTempTbs.Count - 1 do
      begin
        vtb := vTempTbs[J];
        for K := 0 to vtb.MetaFields.Count - 1 do
          if UpperCase(vtb.MetaFields[K].RelateTable) = UpperCase(AOldName) then
          begin
            vtb.MetaFields[K].RelateTable := tb.Name;
          end;
      end;

    end;
  end;

var
  I, J, K, idx: integer;
  fs: TCtObjMemXmlStream;
  ss: TStringList;
  S: string;
  tb: TCtMetaTable;   
  vTempFlds: TCtMetaFieldList;  
  fd: TCtMetaField;
  cto: TCtMetaObject;
  obj2: TDMLObj;
  sc: double;
  lastPos: TPoint;
  cx, cy, x0, y0, x1, y1, dx, dy: double;
begin       
  if FReadOnlyMode then
    Exit;
  S := Clipboard.AsText;
  if S = '' then
    Exit;
  if Copy(S, 1, 5) <> '<?xml' then
    Exit;
  CheckCanEditMeta;
  lastPos := Self.FFrameCtDML.DMLGraph.LastMouseDownPos;

  I := Pos('<Tables>', S);
  if (I > 0) and (I < 100) then
  begin
    ///LockWindowUpdate(Self.Handle);
    vTempTbs := TCtMetaTableList.Create;
    fs := TCtObjMemXmlStream.Create(True);
    ss := TStringList.Create;
    Screen.Cursor := crAppStart;
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(991, nil, nil, '');
    try
      ss.Text := S;
      ss.SaveToStream(fs.Stream);
      fs.Stream.Seek(0, soFromBeginning);
      fs.RootName := 'Tables';
      vTempTbs.LoadFromSerialer(fs);
      K := FCurMetaTableModel.Tables.Count;
      if Sender = nil then
        RenameAllTbs;
      for I := 0 to vTempTbs.Count - 1 do
      begin
        RenameTbIfExists(vTempTbs[I]);
        tb := FCurMetaTableModel.Tables.NewTableItem;
        tb.AssignFrom(vTempTbs[I]);
        {tb.GraphDesc := '';
        for J := 0 to tb.MetaFields.Count - 1 do
          tb.MetaFields[J].GraphDesc := '';}
        if Assigned(Proc_OnPropChange) then
          Proc_OnPropChange(0, tb, nil, '');
      end;
      FCurMetaTableModel.Tables.SaveCurrentOrder;
      sc := FFrameCtDML.DMLGraph.ViewScale;
      cx := FFrameCtDML.DMLGraph.ViewCenterX;
      cy := FFrameCtDML.DMLGraph.ViewCenterY;
      InitDML(FCurMetaTableModel);
      FFrameCtDML.DMLGraph.SetViewXYSc(cx, cy, sc);
      Self.FFrameCtDML.DMLGraph.LastMouseDownPos :=
        Point(lastPos.X + 160, lastPos.Y + 80);

      for I := K to FCurMetaTableModel.Tables.Count - 1 do
      begin
        tb := FCurMetaTableModel.Tables.Items[I];
        with FFrameCtDML.DMLGraph.DMLObjs do
          for J := 0 to Count - 1 do
            if Items[J] is TDMLEntityObj then
              if tb = TCtMetaTable(Items[J].UserObject) then
              begin
                Items[J].Selected := True;
              end;
      end;
      if FFrameCtDML.DMLGraph.DMLObjs.GetSelectionRect(x0, y0, x1, y1) then
      begin
        dx := lastPos.x - x0;
        dy := lastPos.y - y0;
        FFrameCtDML.DMLGraph.DMLObjs.MoveSelected(dx, dy);
        _OnObjsMoved(nil);
      end;
      FFrameCtDML.DMLGraph.Refresh;
    finally
      vTempTbs.Free;
      fs.Free;
      ss.Free;
      ///LockWindowUpdate(0);
      Screen.Cursor := crDefault;
      if Assigned(Proc_OnPropChange) then
        Proc_OnPropChange(992, nil, nil, '');
    end;
    Exit;
  end;


  I := Pos('<Fields>', S);
  if (I > 0) and (I < 100) then
  begin
    tb := GetSelectedTable;
    if tb=nil then
      Exit;            
    tb.MetaFields.Pack;

    cto := GetSelectedCtObj;
    idx := -1;
    if cto <> nil then
      if cto is TCtMetaField then
      begin
        idx := tb.MetaFields.IndexOf(cto);
      end;

    vTempFlds := TCtMetaFieldList.Create;
    fs := TCtObjMemXmlStream.Create(True);
    ss := TStringList.Create;
    try
      ss.Text := S;
      ss.SaveToStream(fs.Stream);
      fs.Stream.Seek(0, soFromBeginning);
      fs.RootName := 'Fields';
      vTempFlds.LoadFromSerialer(fs);

      for I := 0 to vTempFlds.Count - 1 do
      begin
        fd := tb.MetaFields.FieldByName(vTempFlds[I].Name);
        if fd = nil then
          Continue;
        J := 1;
        while tb.MetaFields.FieldByName(vTempFlds[I].Name + '_'+srPasteCopySuffix+IfElse(J=1, '', IntToStr(J))) <> nil do
          Inc(J);
        vTempFlds[I].Name := vTempFlds[I].Name + '_'+srPasteCopySuffix+IfElse(J=1, '', IntToStr(J));
      end;

      for I := 0 to vTempFlds.Count - 1 do
      begin
        fd := tb.MetaFields.NewMetaField;
        fd.AssignFrom(vTempFlds[I]);
        fd.GraphDesc := '';
        if idx >= 0 then
        begin
          Inc(idx);
          if idx < tb.MetaFields.Count - 1 then
          begin
            tb.MetaFields.Move(tb.MetaFields.Count - 1, idx);
          end;
        end;
      end;
      tb.MetaFields.SaveCurrentOrder;

      S := tb.Name;

      obj2 := nil;
      with FFrameCtDML.DMLGraph.DMLObjs do
        for I := 0 to Count - 1 do
          if Items[I].Selected then
            if Items[I] is TDMLTableObj then
              if Items[I].UserObject = tb then
              begin
                obj2 := Items[I];
                Break;
              end;

      if obj2=nil then
        Exit;

      TDMLTableObj(obj2).Describe := tb.Describe;
      TDMLTableObj(obj2).IsView := not tb.GenDatabase;
      CheckDmlTableFieldProps(tb, TDMLTableObj(obj2));
      TDMLTableObj(obj2).CheckResize;
      TDMLTableObj(obj2).FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs);

      CheckAllLinks; //添加缺失的连线

      FFrameCtDML.DMLGraph.Refresh;
      if Assigned(Proc_OnPropChange) then
        Proc_OnPropChange(2, tb, nil, '');

    finally
      vTempFlds.Free;
      fs.Free;
      ss.Free;
    end;
  end;
end;

procedure TfrmCtDML.actPasteUpdate(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  if FReadOnlyMode then
  begin
    FFrameCtDML.actPaste.Enabled := False;
    FFrameCtDML.actPasteAsCopy.Enabled := False;
  end
  else
  begin
    S := Clipboard.AsText;
    if Copy(S, 1, 5) <> '<?xml' then
    begin
      FFrameCtDML.actPaste.Enabled := False;
      FFrameCtDML.actPasteAsCopy.Enabled := False;
    end
    else
    begin
      I := Pos('<Tables>', S);
      if (I > 0) and (I < 100) then
      begin
        FFrameCtDML.actPasteAsCopy.Enabled := True;
        FFrameCtDML.actPaste.Enabled := True;
      end
      else
      begin          
        FFrameCtDML.actPasteAsCopy.Enabled := False;

        I := Pos('<Fields>', S);
        if (I > 0) and (I < 100) then
        begin
          FFrameCtDML.actPaste.Enabled := (GetSelectedTable <> nil);
        end
        else
        begin
          FFrameCtDML.actPaste.Enabled := False;
        end;
      end;
    end;
  end;
end;

procedure TfrmCtDML.CheckDmlTableFieldProps(ctb: TCtMetaTable; obj: TDMLTableObj);
var
  I: integer;
  S, rfn: string;
  cf: TCtMetaField;
  f: TDMLField;
begin
  obj.RemoveLinks(FFrameCtDML.DMLGraph.DMLObjs);
  for I := 0 to obj.FieldCount - 1 do
  begin
    f := obj.Field[I];
    S := f.Get_PhyName;
    if S = '' then
      Continue;
    cf := TCtMetaField(ctb.MetaFields.ItemByName(S));
    if cf = nil then
      Continue;
    f.FieldTypeName := cf.DataTypeName;
    f.IndexType := integer(cf.IndexType);
    f.FieldTypeEx := '';
    if cf.RelateTable = '' then
      Continue;
    rfn := cf.RelateField;
    if (Pos('{Link:', rfn) = 1) or (cf.KeyFieldType in [cfktRid, cfktId]) then
    begin
      if rfn <> '' then
        rfn := '.' + rfn;
      f.FieldTypeEx := cf.RelateTable + rfn;
    end;
  end;
end;

procedure TfrmCtDML.CheckSelectedTb;
var
  I, J: integer;
  md: TCtDataModelGraph;
begin
  for I := 0 to FGlobeDataModelList.Count - 1 do //遍历所有模型图
  begin
    md := FGlobeDataModelList.Items[I];
    for J := 0 to md.Tables.Count - 1 do //遍历所有表
    begin
      md.Tables.Items[J].IsSelected := False;
    end;
  end;

  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if (Items[I] <> nil) and (Items[I].UserObject is TCtMetaTable) then
        begin
          TCtMetaTable(Items[I].UserObject).IsSelected := True;
        end;
end;

procedure TfrmCtDML.DoExportHtmlDoc(tfn: string);

  function GetHtmlDmlScriptDir: string;
  begin
    Result := GetFolderPathOfAppExe('Templates');
  end;

var
  pf, fn: string;
begin
  pf := 'export_doc_html';
  if LowerCase(ExtractFileExt(tfn)) = '.xls' then
    pf := 'export_xls';
  fn := FolderAddFileName(GetHtmlDmlScriptDir, pf + '.js_');
  fn := GetConfigFile_OfLang(fn);
  if not FileExists(fn) then
  begin
    fn := FolderAddFileName(GetHtmlDmlScriptDir, pf + '.ps_');
    fn := GetConfigFile_OfLang(fn);
  end;
  DoExecScript(fn, tfn);
end;

procedure TfrmCtDML.DoExportMarkdown(tfn: string);
  function GetHtmlDmlScriptDir: string;
  begin
    Result := GetFolderPathOfAppExe('Templates');
  end;

var
  pf, fn: string;
begin
  pf := 'export_markdown';
  fn := FolderAddFileName(GetHtmlDmlScriptDir, pf + '.js_');
  fn := GetConfigFile_OfLang(fn);
  if not FileExists(fn) then
  begin
    fn := FolderAddFileName(GetHtmlDmlScriptDir, pf + '.ps_');
    fn := GetConfigFile_OfLang(fn);
  end;
  DoExecScript(fn, tfn);
end;

procedure TfrmCtDML.DoExecScript(fn, tfn: string);
var
  FileTxt, AOutput: TStrings;
  S,T, afn, bfn: string;
  tb: TCtMetaTable;
  I: integer;
  ss: TStringList;
begin
  FGlobeDataModelList.CurDataModel.Param['ShowPhyFieldName'] :=
    IntToStr(FFrameCtDML.DMLGraph.DMLDrawer.ShowPhyFieldName);
  FGlobeDataModelList.CurDataModel.Param['DatabaseEngine'] :=
    FFrameCtDML.DMLGraph.DMLDrawer.DatabaseEngine;
  FGlobeDataModelList.CurDataModel.Param['ExportFileName'] := tfn;

  if not FileExists(fn) then
    raise Exception.Create('Template file not found: ' + fn);

  CheckSelectedTb;
  tb := nil;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if (Items[I] <> nil) and (Items[I].UserObject is TCtMetaTable) then
        begin
          if tb = nil then
            tb := TCtMetaTable(Items[I].UserObject);
          Break;
        end;

  FileTxt := TStringList.Create;
  AOutput := TStringList.Create;
  with CreateScriptForFile(fn) do
    try
      FileTxt.LoadFromFile(fn);
      ActiveFile := fn;
      S := FileTxt.Text;
      if IsSPRule(S) then
      begin
        S := PreConvertSP(S);
        FileTxt.Text := S;
      end;

      Init('DML_SCRIPT', tb, AOutput, nil);
      Exec('DML_SCRIPT', FileTxt.Text);
      AOutput.SaveToFile(tfn);
    finally
      FileTxt.Free;
      AOutput.Free;
      Free;
    end;

  if Application.MessageBox(PChar(srConfirmOpenXlsAfterExport),
    PChar(Application.Title), MB_OKCANCEL) = idOk then
  begin         
    if LowerCase(ExtractFileExt(tfn)) = '.md' then
    begin
      afn := FolderAddFileName(GetDmlScriptDir, 'MarkdownPreview.html');
      if not FileExists(afn) then
        raise Exception.Create(Format(srEzdmlFileNotFoundFmt, [afn]));
      ss := TStringList.Create;
      try               
        ss.LoadFromFile(tfn); 
        T := ss.Text;
        ss.LoadFromFile(afn);
        S := ss.Text;
        if Pos('%MARKDOWN_TEXT%', S) > 0 then
          S := StringReplace(S, '%MARKDOWN_TEXT%', T, [rfReplaceAll]);
        ss.Text := S;
        bfn := FolderAddFileName(GetAppDefTempPath, 'MarkdownPreview.html');
        ss.SaveToFile(bfn);
        CtOpenDoc(PChar(bfn));
      finally
        ss.Free;
      end;
      Exit;
    end;

    CtOpenDoc(PChar(tfn)); { *Converted from ShellExecute* }
  end;
end;

procedure TfrmCtDML.InitDML(mdl: TCtDataModelGraph);
var
  o: TDMLEntityObj;
  tb: TCtMetaTable;
  FLastObjX, FLastObjY, dv: double;
  DMLObjList: TDMLObjList;
  I: integer;
  tbs: TCtMetaTableList;
  bfMode: boolean;
  selStr: string;
begin
  FLastObjX := 0;
  FLastObjY := 0;

  FFrameCtDML.DMLGraph.LastMouseDownPos :=
    Point(DEF_INIT_LAST_IMGV_MOUSE_POS_X, DEF_INIT_LAST_IMGV_MOUSE_POS_Y);
  DMLObjList := FFrameCtDML.DMLGraph.DMLObjs;
  selStr := DMLObjList.SelectedNames;
  bfMode := DMLObjList.BriefMode;
  DMLObjList.Clear;
  DMLObjList.FindNewSpace := False;
  if mdl = nil then
    tbs := nil
  else
    tbs := mdl.Tables;

  FFrameCtDML.DMLGraph.DMLDrawer.ResetConfig;
  if Screen.Width > FFrameCtDML.DMLGraph.DMLDrawer.DrawerWidth then
  begin
    FFrameCtDML.DMLGraph.DMLDrawer.DrawerWidth := Screen.Width;
    if FFrameCtDML.DMLGraph.DMLDrawer.DrawerWidth > 1500 then
      FFrameCtDML.DMLGraph.DMLDrawer.DrawerWidth := 1500;
    FFrameCtDML.DMLGraph.DMLDrawer.DrawerHeight := Screen.Width * 4 div 3;
  end;
  if mdl <> nil then
  begin
    FFrameCtDML.DMLGraph.DMLDrawer.SetConfigStr(mdl.ConfigStr);
    FFrameCtDML.DMLGraph.Color := FFrameCtDML.DMLGraph.DMLDrawer.WorkAreaColor;
  end;
  CurrentDmlDbEngine := FFrameCtDML.DMLGraph.DMLDrawer.DatabaseEngine;
  ResetCtFieldTextColor;
  if tbs = nil then
  begin
    FFrameCtDML.actRestore.Execute;
    Exit;
  end;
  if Assigned(mdl) and mdl.IsHuge then
  begin
    Screen.Cursor := crAppStart;
    DMLObjList.DMLDrawer.FIsHugeMode := True;
  end
  else
    DMLObjList.DMLDrawer.FIsHugeMode := False;
  try
    for I := 0 to tbs.Count - 1 do
      if tbs.Items[I].DataLevel <> ctdlDeleted then
        if tbs.Items[I].GraphDesc <> '' then
        begin
          tb := tbs.Items[I];

          if tb.IsText then
          begin
            o := TDMLTextObj.Create;
            o.UserObject := tb;
            o.Comment := tb.Memo;
            o.Name := tb.Name;
          end
          else
          begin
            o := TDMLTableObj.Create;
            o.UserObject := tb;
            TDMLTableObj(o).Describe := tb.Describe;
            if not tb.GenDatabase then
              TDMLTableObj(o).IsView := True;
            CheckDmlTableFieldProps(tb, TDMLTableObj(o));
          end;
          o.CheckResize;

          o.ID := DMLObjList.GetNextObjID;
          DMLObjList.Add(o);
          SetLocationDesc(o, tb.GraphDesc);

          dv := o.Top + o.Height + 100;
          if FLastObjY < dv then
            FLastObjY := dv;
          dv := o.Left + o.Width + 100;
          if FLastObjX < dv then
            FLastObjX := dv;
        end;

    if DMLObjList.DMLDrawer.DrawerWidth < FLastObjX then
      DMLObjList.DMLDrawer.DrawerWidth := Round(FLastObjX);

    FLastObjX := 0;


    for I := 0 to tbs.Count - 1 do
      if tbs.Items[I].DataLevel <> ctdlDeleted then
        if tbs.Items[I].GraphDesc = '' then
        begin
          tb := tbs.Items[I];

          if tb.IsText then
          begin
            o := TDMLTextObj.Create;
            o.UserObject := tb;
            o.Comment := tb.Memo;
          end
          else
          begin
            o := TDMLTableObj.Create;
            o.UserObject := tb;
            TDMLTableObj(o).Describe := tb.Describe;
            CheckDmlTableFieldProps(tb, TDMLTableObj(o));
          end;
          o.CheckResize;

          o.ID := DMLObjList.GetNextObjID;
          DMLObjList.Add(o);
          DMLObjList.FindSpaceEx(o, FLastObjX, FLastObjY, 100);
          //tb.GraphDesc := GetLocationDesc(o);
          FLastObjX := o.Left;
          FLastObjY := o.Top;
        end;

    for I := 0 to DMLObjList.Count - 1 do
      FFrameCtDML.DMLGraph.DMLDrawer.SetDefaultProps(DMLObjList[I]);

    CheckAllLinks;

  finally
    DMLObjList.FindNewSpace := True;
    Screen.Cursor := crDefault;
  end;
  if bfMode then
    DMLObjList.BriefMode := True;
  FFrameCtDML.DMLGraph.AutoCheckGraphSize;
  if not FCtDmlRefreshing and (Abs(int64(GetTickCount) - FLastRefreshTick) > 600) then
  begin
    FFrameCtDML.actRestore.Execute;
    if DMLObjList.Count > 0 then
      with FFrameCtDML.DMLGraph do
        if DMLObjList.FindEntityInRect(ScreenToImageX(0), ScreenToImageY(0),
          ScreenToImageX(Width * 2 div 3), ScreenToImageY(Height * 2 div 3)) < 0 then
        begin
          FFrameCtDML.actBestFit.Execute;
        end;
  end
  else
  begin
    DMLObjList.SelectedNames := selStr;
    FFrameCtDML.DMLGraph.Refresh;
  end;
  FFrameCtDML.DMLGraphViewChanged(nil);
  FFrameCtDML.ShowDMLInfoStatusMsg();
end;

function TfrmCtDML.LocToCtObj(obj: TCtMetaObject): boolean;
var
  tb: TCtMetaTable;
  dEt: TDMLEntityObj;
  dTb: TDMLTableObj;
  dFd: TDMLField;
  J, K: integer;
  fdName: string;
begin
  Result := False;
  if obj = nil then
    Exit;

  fdName := '';
  FFrameCtDML.DMLGraph.DMLObjs.ClearSelection;

  if obj is TCtMetaField then
  begin
    tb := TCtMetaField(obj).OwnerTable;
    fdName := TCtMetaField(obj).Name;
  end
  else if obj is TCtMetaTable then
    tb := TCtMetaTable(obj)
  else
    Exit;

  with FFrameCtDML.DMLGraph.DMLObjs do
    for J := 0 to Count - 1 do
      if Items[J] is TDMLEntityObj then
        if tb.Name = TCtMetaTable(Items[J].UserObject).Name then
        begin
          dEt := TDMLEntityObj(Items[J]);
          dEt.Selected := True;
          if (fdName <> '') and (dEt is TDMLTableObj) then
          begin
            dTb := TDMLTableObj(Items[J]);
            for K := 0 to dTb.FieldCount - 1 do
            begin
              dFd := dTb.Field[K];
              if (dFd.PhyName = fdName) or (dFd.Name = fdName) then
              begin
                dTb.SelectedFieldIndex := K + 1;
                Break;
              end;
            end;
          end;
          if FFrameCtDML.DMLGraph.ViewScale < 0.9 then
            FFrameCtDML.DMLGraph.ViewScale := 1;
          FFrameCtDML.DMLGraph.MakeObjVisible(Items[J]);
          Result := True;
          Break;
        end;

  if Result then
    FFrameCtDML.DMLGraph.Refresh;
end;

procedure TfrmCtDML.RearrangeAll;
begin
  actRearrangeExecuteEx(nil);
end;

procedure TfrmCtDML.ReassignActionList;
begin
  Self.Notification(FFrameCtDML.ActionList2, opInsert);
end;

procedure TfrmCtDML.RewriteGraphDesc;
var
  I: integer;
begin
  if FReadOnlyMode then
    Exit;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
    begin
      if Items[I] is TDMLEntityObj then
        if Items[I].UserObject is TCtMetaTable then
          TCtMetaTable(Items[I].UserObject).GraphDesc := Self.GetLocationDesc(Items[I]);
      if Items[I] is TDMLLinkObj then
        if TDMLLinkObj(Items[I]).UserObject is TCtMetaField then
          TCtMetaField(Items[I].UserObject).GraphDesc := Self.GetLocationDesc(Items[I]);
    end;
end;

function TfrmCtDML.GetLocationDesc(Obj: TDMLObj): string;
begin
  Result := '';
  if Obj is TDMLEntityObj then
  begin
    Result := Format('Left=%f'#13#10'Top=%f'#13#10'BLeft=%f'#13#10'BTop=%f',
      [Obj.OLeft, Obj.OTop, Obj.BLeft, Obj.BTop]);

    if Pos('[CUSTOM_BKCOLOR=1]', Obj.UserPars) > 0 then
      Result := Result + #13#10'BkColor=' + IntToStr(Obj.FillColor);

  end
  else if Obj is TDMLLinkObj then
    with Obj as TDMLLinkObj do
      Result := Format('P1=%f,%f'#13#10'P2=%f,%f'#13#10'P3=%f,%f'#13#10'P4=%f,%f' +
        #13#10'HookP1=%f,%f'#13#10'HookP2=%f,%f' +
        #13#10'Mod_OP1=%d'#13#10'Mod_OP2=%d'#13#10'Mod_CP=%d' +
        #13#10'Horz1=%d'#13#10'Horz2=%d',
        [P1.X, P1.Y, P2.X, P2.Y, P3.X, P3.Y, P4.X, P4.Y,
        FHookP1.X, FHookP1.Y, FHookP2.X, FHookP2.Y,
        integer(FPMod_OP1), integer(FPMod_OP2), integer(FPMod_CP),
        integer(FHorz1), integer(FHorz2)
        ]);
end;

function TfrmCtDML.GetSelectedCtObj: TCtMetaObject;
var
  I: integer;
  tb: TCtMetaTable;
  cf: TCtMetaField;
  f: TDMLField;
  S: string;
begin
  Result := nil;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLEntityObj then
        begin
          tb := TCtMetaTable(Items[I].UserObject);
          if tb <> nil then
          begin
            Result := tb;
            if (Items[I] is TDMLTableObj) and
              (TDMLTableObj(Items[I]).SelectedFieldIndex > 0) and not
              FFrameCtDML.DMLGraph.DMLDrawer.HideSelectedField then
            begin
              f := TDMLTableObj(Items[I]).Field[TDMLTableObj(Items[I]).SelectedFieldIndex - 1];
              S := f.Get_PhyName;
              if S <> '' then
              begin
                cf := TCtMetaField(tb.MetaFields.ItemByName(S));
                if cf <> nil then
                  Result := cf;
              end;
            end;
            Exit;
          end;
        end;
end;

function TfrmCtDML.GetSelectedTable: TCtMetaTable;
var
  I: integer;
begin
  Result := nil;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLTableObj then
        begin
          Result := TCtMetaTable(Items[I].UserObject);
          if Result <> nil then
            Exit;
        end;
end;

procedure TfrmCtDML.SetLocationDesc(Obj: TDMLObj; Des: string);

  function StrToPoint(S: string; def: TDMLPoint): TDMLPoint;
  var
    po: integer;
    SX, SY: string;
  begin
    Result := def;
    po := Pos(',', S);
    if po = 0 then
      Exit;
    SX := Copy(S, 1, po - 1);
    SY := Copy(S, po + 1, Length(S));
    Result.X := StrToFloatDef(SX, Result.X);
    Result.Y := StrToFloatDef(SY, Result.Y);
  end;

var
  S1, S2, S3, S4, S: string;
begin
  if Obj = nil then
    Exit;
  if Trim(Des) = '' then
    Exit;
  Des := #10 + Des + #10;
  Des := StringReplace(Des, #13, #10, [rfReplaceAll]);
  if Obj is TDMLEntityObj then
  begin
    S1 := ExtractCompStr(Des, #10'Left=', #10);
    S2 := ExtractCompStr(Des, #10'Top=', #10);
    if (S1 <> '') and (S2 <> '') then
    begin
      Obj.OLeft := StrToFloatDef(S1, Obj.OLeft);
      Obj.OTop := StrToFloatDef(S2, Obj.OTop);
    end;
    S1 := ExtractCompStr(Des, #10'BLeft=', #10);
    S2 := ExtractCompStr(Des, #10'BTop=', #10);
    if (S1 <> '') and (S2 <> '') then
    begin
      Obj.BLeft := StrToFloatDef(S1, Obj.BLeft);
      Obj.BTop := StrToFloatDef(S2, Obj.BTop);
    end;

    S2 := ExtractCompStr(Des, #10'BkColor=', #10);
    if S2 <> '' then
    begin
      Obj.UserPars := AddOrModifyCompStr(Obj.UserPars, '1', '[CUSTOM_BKCOLOR=', ']');
      Obj.FillColor := StrToIntDef(S2, clWhite);
    end;
  end
  else if Obj is TDMLLinkObj then
  begin
    S1 := ExtractCompStr(Des, #10'P1=', #10);
    S2 := ExtractCompStr(Des, #10'P2=', #10);
    S3 := ExtractCompStr(Des, #10'P3=', #10);
    S4 := ExtractCompStr(Des, #10'P4=', #10);
    with Obj as TDMLLinkObj do
    begin
      if (S1 <> '') and (S2 <> '') and (S3 <> '') and (S4 <> '') then
        FPosInfoLoaded := True;
      P1 := StrToPoint(S1, P1);
      P2 := StrToPoint(S2, P2);
      P3 := StrToPoint(S3, P3);
      P4 := StrToPoint(S4, P4);
      S := ExtractCompStr(Des, #10'HookP1=', #10);
      FHookP1 := StrToPoint(S, FHookP1);
      S := ExtractCompStr(Des, #10'HookP2=', #10);
      FHookP2 := StrToPoint(S, FHookP2);
      S := ExtractCompStr(Des, #10'Mod_OP1=', #10);
      if S <> '' then
        FPMod_OP1 := S = '1';
      S := ExtractCompStr(Des, #10'Mod_OP2=', #10);
      if S <> '' then
        FPMod_OP2 := S = '1';
      S := ExtractCompStr(Des, #10'Mod_CP=', #10);
      if S <> '' then
        FPMod_CP := S = '1';
      S := ExtractCompStr(Des, #10'Horz1=', #10);
      if S <> '' then
        FHorz1 := S = '1';
      S := ExtractCompStr(Des, #10'Horz2=', #10);
      if S <> '' then
        FHorz2 := S = '1';
    end;
  end;
end;

procedure TfrmCtDML._OnObjsMoved(Sender: TObject);
var
  I, J: integer;
  lnk: TDMLLinkObj;
begin
  if FReadOnlyMode then
    Exit;
  with FFrameCtDML.DMLGraph.DMLObjs do
  begin
    if not Self.FCurMetaTableModel.IsHuge then
      CheckSelectedLinks;
    for I := 0 to Count - 1 do
      if Items[I].Selected then
      begin
        if (Items[I] is TDMLTableObj) or (Items[I] is TDMLTextObj) then
        begin
          if Items[I].UserObject is TCtMetaTable then
            TCtMetaTable(Items[I].UserObject).GraphDesc :=
              Self.GetLocationDesc(Items[I]);

          if not FFrameCtDML.DMLGraph.DMLObjs.BriefMode then
          begin
            for J := 0 to Count - 1 do
              if Items[J] is TDMLLinkObj then
              begin
                lnk := TDMLLinkObj(Items[J]);
                if lnk.UserObject is TCtMetaField then
                begin
                  if (lnk.Obj1 = Items[I]) or (lnk.Obj2 = Items[I]) then
                  begin
                    TCtMetaField(lnk.UserObject).GraphDesc := Self.GetLocationDesc(lnk);
                  end;
                end;
              end;

          end;
        end;
        if not FFrameCtDML.DMLGraph.DMLObjs.BriefMode then
          if Items[I] is TDMLLinkObj then
            if TDMLLinkObj(Items[I]).UserObject is TCtMetaField then
              TCtMetaField(Items[I].UserObject).GraphDesc :=
                Self.GetLocationDesc(Items[I]);
      end;
  end;

  if not FFrameCtDML.DMLGraph.DMLObjs.BriefMode then
    with FFrameCtDML.DMLGraph.DMLObjs.FAutoCheckedLinks do
      for I := 0 to Count - 1 do
        //移动表过程中，被表遮挡的线也有处理，需要保存
      begin
        lnk := TDMLLinkObj(Items[I]);
        if FFrameCtDML.DMLGraph.DMLObjs.IndexOf(lnk) >= 0 then
          if lnk.UserObject is TCtMetaField then
          begin
            TCtMetaField(lnk.UserObject).GraphDesc := Self.GetLocationDesc(lnk);
          end;
      end;
  FFrameCtDML.DMLGraph.DMLObjs.FAutoCheckedLinks.Clear;
  FFrameCtDML.DMLGraph.Refresh;
end;

procedure TfrmCtDML.actRearrangeExecuteEx(Sender: TObject);
var
  I: integer;
begin
  FFrameCtDML.actRearrangeExecute(Sender);
  if FReadOnlyMode then
    Exit;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
    begin
      if Items[I] is TDMLEntityObj then
        if Items[I].UserObject is TCtMetaTable then
          TCtMetaTable(Items[I].UserObject).GraphDesc := Self.GetLocationDesc(Items[I]);
      if Items[I] is TDMLLinkObj then
        if TDMLLinkObj(Items[I]).UserObject is TCtMetaField then
          TCtMetaField(Items[I].UserObject).GraphDesc := Self.GetLocationDesc(Items[I]);
    end;
  if FCurMetaTableModel <> nil then
  begin
    FCurMetaTableModel.ConfigStr := FFrameCtDML.DMLGraph.DMLDrawer.GetConfigStr;
  end;
end;

procedure TfrmCtDML.actRefreshExecute(Sender: TObject);
begin
  if FCtDmlRefreshing then
    Exit;
  FCtDmlRefreshing := True;
  try
    InitDML(FCurMetaTableModel);
    FFrameCtDML.DMLGraph.Refresh;
    if Assigned(Proc_OnRefresh) then
      Proc_OnRefresh(Self);
    FLastRefreshTick := GetTickCount;
  finally
    FCtDmlRefreshing := False;
  end;
end;

procedure TfrmCtDML.actShowPhyViewExecute(Sender: TObject);
begin
  FFrameCtDML.actShowPhyViewExecute(Sender);
  if FReadOnlyMode then
    Exit;
  if FCurMetaTableModel <> nil then
  begin
    FCurMetaTableModel.ConfigStr := FFrameCtDML.DMLGraph.DMLDrawer.GetConfigStr;
  end;
end;

procedure TfrmCtDML.CheckAllLinks;
var
  o: TDMLEntityObj;
  lnk: TDMLLinkObj;
  tb: TCtMetaTable;
  fd: TCtMetaField;
  DMLObjList: TDMLObjList;
  I, oLV: integer;
  S: string;
begin
  DMLObjList := FFrameCtDML.DMLGraph.DMLObjs;
  oLV := DMLObjList.DMLDrawer.FLinkOptimizeLevel;
  DMLObjList.DMLDrawer.FLinkOptimizeLevel := 0;
  DMLObjList.BeginUpdateLinks;
  try
    for I := 0 to DMLObjList.Count - 1 do
      if DMLObjList[I] is TDMLLinkObj then
        TDMLLinkObj(DMLObjList[I]).FPosInfoLoaded := False;

    DMLObjList.FindAllFKLinks;
    {for I := 0 to DMLObjList.Count - 1 do
    begin
      if DMLObjList[I] is TDMLTableObj then
        TDMLTableObj(DMLObjList[I]).FindFKLinks(DMLObjList);
    end;}

    FFrameCtDML.CheckLinkLines;

    for I := 0 to DMLObjList.Count - 1 do
      if DMLObjList[I] is TDMLLinkObj then
      begin
        lnk := TDMLLinkObj(DMLObjList[I]);
        if lnk.Comment <> '' then
          if lnk.Obj2 is TDMLTableObj then
          begin
            o := TDMLTableObj(lnk.Obj2);
            S := lnk.Comment;
            if S <> '' then
              if o.UserObject is TCtMetaTable then
              begin
                tb := TCtMetaTable(o.UserObject);
                fd := tb.MetaFields.FieldByName(S);
                if fd <> nil then
                begin
                  lnk.UserObject := fd;
                  SetLocationDesc(lnk, fd.GraphDesc);
                end;
              end;
          end;
      end;


  finally
    DMLObjList.DMLDrawer.FLinkOptimizeLevel := 1;
    DMLObjList.EndUpdateLinks;
    DMLObjList.DMLDrawer.FLinkOptimizeLevel := oLV;
  end;

  try
    DMLObjList.DMLDrawer.FLinkOptimizeLevel := 9;
    DMLObjList.CheckLinkOptiTick(True);
    //进行计时，如果处理超过200毫秒，将降低优化级别
    for I := 0 to DMLObjList.Count - 1 do
      if DMLObjList[I] is TDMLLinkObj then
        if not TDMLLinkObj(DMLObjList[I]).FPosInfoLoaded then
        begin
          if DMLObjList.DMLDrawer.FLinkOptimizeLevel < 1 then
            DMLObjList.DMLDrawer.FLinkOptimizeLevel := 1;
          TDMLLinkObj(DMLObjList[I]).CheckPosition;
          DMLObjList.CheckLinkOptiTick;
        end;
  finally
    DMLObjList.DMLDrawer.FLinkOptimizeLevel := oLV;
  end;
end;

procedure TfrmCtDML.ResortToolBtns;
var
  I, k: integer;
begin
  k := 1;
  with Self.FFrameCtDML.ToolBar1 do
    for I := 0 to ControlCount - 1 do
    begin
      if Controls[I].Visible then
      begin
        Controls[I].Left := k;
        k := k + Controls[I].Width;
      end;
    end;
end;

procedure TfrmCtDML.ResetCtFieldTextColor;
begin
  CtFieldTextColor_Id := FFrameCtDML.DMLGraph.DMLDrawer.DefaultPKColor;
  CtFieldTextColor_Rid := FFrameCtDML.DMLGraph.DMLDrawer.DefaultFKColor;
end;

function TfrmCtDML._OnLinkObj(Obj1, Obj2: TDMLObj): integer;
  procedure RefreshTb2;
  begin
    if (Obj2.UserObject is TCtMetaTable) then
    begin
      TDMLTableObj(obj2).Describe := TCtMetaTable(TDMLTableObj(obj2).UserObject).Describe;
      TDMLTableObj(obj2).CheckResize;
    end;
  end;
var
  tb1, tb2: TCtMetaTable;
  fd: TDMLField;
  rfn, S, desc1: string;
begin
  Result := -1;
  if not (obj1 is TDMLEntityObj) or
    not (TDMLEntityObj(obj1).UserObject is TCtMetaTable) then
    Exit;
  if not (obj2 is TDMLTableObj) or
    not (TDMLTableObj(obj2).UserObject is TCtMetaTable) then
    Exit;
  CheckCanEditMeta;

  tb1 := TCtMetaTable(TDMLEntityObj(obj1).UserObject);
  tb2 := TCtMetaTable(TDMLTableObj(obj2).UserObject);
  FLastLinkField := nil;

  S := '';
  if (TDMLTableObj(obj2).SelectedFieldIndex > 0) and not
    FFrameCtDML.DMLGraph.DMLDrawer.HideSelectedField then
  begin
    fd := TDMLTableObj(obj2).Field[TDMLTableObj(obj2).SelectedFieldIndex - 1];
    S := fd.Get_PhyName;
  end;
  desc1 := tb2.Describe;
  if ExecAddTbLink(tb1, tb2, FLastLinkField, S) then
    Result := 1;

  if FLastLinkField <> nil then
  begin
    if desc1 <> tb2.Describe then
    begin
      RefreshTb2;
    end;

    fd := TDMLTableObj(obj2).FindDMLField(FLastLinkField.Name);
    if fd = nil then
      Exit;

    rfn := FLastLinkField.RelateField;
    S := rfn;
    if S <> '' then
      S := '.' + S;
    fd.FieldTypeEx := FLastLinkField.RelateTable + S;

    if rfn = '{Link:Line}' then
    begin
      Result := 3;
      if fd.ExtraKeyType = 2 then
        fd.ExtraKeyType := 3;
    end
    else if rfn = '{Link:Direct}' then
    begin
      Result := 4;
      if fd.ExtraKeyType = 2 then
        fd.ExtraKeyType := 3;
    end
    else if rfn = '{Link:OppDirect}' then
    begin
      Result := 5;
      if fd.ExtraKeyType = 2 then
        fd.ExtraKeyType := 3;
    end
    else if rfn <> '' then
    begin
      if fd.ExtraKeyType = 1 then
        Result := 2
      else
      begin
        Result := 1;
        fd.ExtraKeyType := 2;
      end;
    end;
  end;
end;

procedure TfrmCtDML._DoCapitalize(sType: string);
var
  I, J: integer;
  o: TDMLEntityObj;
  tb: TCtMetaTable;
  field: TCTMetaField;
  S: string;
  bChg: boolean;
begin
  bChg := False;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLEntityObj then
        begin
          o := TDMLEntityObj(Items[I]);
          tb := TCtMetaTable(o.UserObject);
          if tb = nil then
            Continue;

          S := tb.Describe;
          DoAutoCapProcess(tb, sType);
          with tb.MetaFields do
            for J := 0 to Count - 1 do
            begin
              field := Items[J];
              DoAutoCapProcess(field, sType);
            end;
          if S <> tb.Describe then
          begin
            if Assigned(Proc_OnPropChange) then
              Proc_OnPropChange(2, tb, nil, '');
            bChg := True;
          end;
        end;

  if bChg then
    FFrameCtDML.actRefresh.Execute;
end;

procedure TfrmCtDML._DoBatCopy(sType: string);
var
  I, J, SC, C, showTp: integer;
  ob: TDMLObj;
  o: TDMLEntityObj;
  tb: TCtMetaTable;
  field: TCTMetaField;
  S, dbType, t, fldJoin, tbJoin: string;
  ss: TStringList;
begin
  if FFrameCtDML.DMLGraph.DMLObjs.SelectedCount = 0 then
    Exit;
  showTp := FFrameCtDML.DMLGraph.DMLDrawer.ShowPhyFieldName;
  dbType := FFrameCtDML.DMLGraph.DMLDrawer.DatabaseEngine;
  ss := TStringList.Create;
  try
    C := 0;
    fldJoin := '';
    tbJoin := '';
    SC := FFrameCtDML.DMLGraph.DMLObjs.SelectedCount;
    for I := 0 to SC - 1 do
    begin
      ob := FFrameCtDML.DMLGraph.DMLObjs.GetSelectedItem(I);
      if ob = nil then
        Continue;
      if not ob.Selected then
        Continue;
      if not (ob is TDMLEntityObj) then
        Continue;

      o := TDMLEntityObj(ob);
      tb := TCtMetaTable(o.UserObject);
      if tb = nil then
        Continue;

      if sType = 'TableName' then
      begin
        case showTp of
          0: s := tb.DisplayText;
          1: s := tb.Name;
          else
            s := tb.NameCaption;
        end;
        ss.Add(s);
      end
      else if sType = 'DescText' then
      begin
        s := tb.Describe;
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'ExcelText' then
      begin
        s := tb.ExcelText;
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'CreateSQL' then
      begin
        s := tb.GenSql(dbType);
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'SelectSQL' then
      begin
        s := tb.GenSelectSql(20, dbType);
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'JoinSelectSQL' then
      begin
        t := char(Ord('a') + C);
        Inc(C);
        S := '';
        for J := 0 to tb.MetaFields.Count - 1 do
        begin
          field := tb.MetaFields[J];
          if field.DataLevel = ctdlDeleted then
            Continue;
          if S <> '' then
            S := S + ','#13#10;
          S := S + t + '.' + field.Name;
        end;
        if fldJoin <> '' then
          fldJoin := fldJoin + ','#13#10#13#10;
        fldJoin := fldJoin + S;
        if tbJoin = '' then
          tbJoin := tb.Name + ' ' + t
        else
          tbJoin := tbJoin + ','#13#10'left join ' + tb.Name + ' ' + t;
      end
      else if sType = 'InsertSQL' then
      begin
        s := tb.GenDqlDmlSql(dbType, 'insert');
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'UpdateSQL' then
      begin
        s := tb.GenDqlDmlSql(dbType, 'update');
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'FieldNameComma' then
      begin
        ss.Add(tb.Name);
        ss.Add('---------------');
        S := '';
        for J := 0 to tb.MetaFields.Count - 1 do
        begin
          field := tb.MetaFields[J];
          if field.DataLevel = ctdlDeleted then
            Continue;
          if S <> '' then
            s := s + ','#13#10;
          S := S + field.Name;
        end;
        ss.Add(s);
        ss.Add('');
      end
      else if (sType = 'FieldName') or (sType = 'FieldAndType') then
      begin
        case showTp of
          0: s := tb.DisplayText;
          1: s := tb.Name;
          else
            s := tb.NameCaption;
        end;
        ss.Add(s);
        ss.Add('---------------');
        for J := 0 to tb.MetaFields.Count - 1 do
        begin
          field := tb.MetaFields[J];
          if field.DataLevel = ctdlDeleted then
            Continue;
          case showTp of
            0:
            begin
              s := field.DisplayName;
              if s = '' then
                s := field.Name;
            end;
            1: s := field.Name;
            else
              s := field.NameCaption;
          end;
          if sType = 'FieldAndType' then
          begin
            s := s + #9;
            case showTp of
              0: s := S + field.GetLogicDataTypeName;
              1: s := S + field.GetPhyDataTypeName(FFrameCtDML.DMLGraph.DMLObjs.DMLDrawer.DatabaseEngine);
              else
                s := S + field.GetLogicDataTypeName + #9 +
                  field.GetPhyDataTypeName(dbType);
            end;
          end;
          ss.Add(s);
        end;
        ss.Add('');
      end;
    end;
    if sType = 'JoinSelectSQL' then
    begin
      if tbJoin = '' then
        Exit;
      ss.Add('select');
      ss.Add('');
      ss.Add(fldJoin);
      ss.Add('');
      ss.Add('from');
      ss.Add(tbJoin);
      ss.Add('');
      ss.Add('where 1=1');
    end;
    ClipBoard.AsText := Trim(ss.Text);
  finally
    ss.Free;
  end;
end;

function TfrmCtDML._OnObjAddOrRemove(Obj: TDMLObj; Act: integer): boolean;
var
  tb: TCtMetaTable;
  fdn: string;
  df: TDMLField;
begin
  Result := True;
  if Obj = nil then
  begin
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(Act, nil, nil, '');
    Exit;
  end;

  if not Assigned(FCurMetaTableModel) then
    Exit;
  if FReadOnlyMode then
    Exit;

  try
    CheckCanEditMeta;
  except
    on E: Exception do
    begin
      Application.HandleException(Self);
      Result := False;
      Exit;
    end;
  end;

  if Obj is TDMLLinkObj then
  begin
    if Act = 1 then
    begin
      if FLastLinkField <> nil then
      begin
        TDMLLinkObj(Obj).UserObject := FLastLinkField;
        if FLastLinkField.KeyFieldType = cfktRid then
        begin
          TDMLLinkObj(Obj).Obj1Field := FLastLinkField.RelateField;
          TDMLLinkObj(Obj).Obj2Field := FLastLinkField.Name;
        end;
      end;
      FLastLinkField := nil;
      if TDMLLinkObj(Obj).Obj2 is TDMLTableObj then
        DoTablePropsChanged(TCtMetaTable(
          TDMLTableObj(TDMLLinkObj(Obj).Obj2).UserObject));
      Exit;
    end;
    if Act = 2 then
    begin
      fdn := '';
      if TDMLLinkObj(Obj).UserObject is TCtMetaField then
        with TDMLLinkObj(Obj).UserObject as TCtMetaField do
        begin
          if KeyFieldType = cfktRid then
            KeyFieldType := cfktNormal;
          RelateTable := '';
          RelateField := '';
          fdn := Name;
        end;
      if fdn <> '' then
        if TDMLLinkObj(Obj).Obj2 is TDMLTableObj then
          with TDMLLinkObj(Obj).Obj2 as TDMLTableObj do
          begin
            df := FindDMLField(fdn);
            if df <> nil then
              with df do
              begin
                if FieldType = dmlfFK then
                  FieldType := dmlfInteger;
                if ExtraKeyType = 2 then
                  ExtraKeyType := 0;
                FieldTypeEx := '';
              end;
          end;

      if TDMLLinkObj(Obj).Obj2 is TDMLTableObj then
        DoTablePropsChanged(TCtMetaTable(
          TDMLTableObj(TDMLLinkObj(Obj).Obj2).UserObject));
    end;
  end
  else if (Obj is TDMLTableObj) or (Obj is TDMLTextObj) then
  begin
    if Act = 1 then
    begin
      if Obj is TDMLTextObj then
        tb := FCurMetaTableModel.Tables.NewTableItem('TEXT')
      else
        tb := FCurMetaTableModel.Tables.NewTableItem;
      if Obj.BriefMode then
      begin
        Obj.OLeft := 0;
        Obj.OTop := 0;
      end;
      //tb.Describe := TDMLTableObj(Obj).Describe;
      //tb.GraphDesc := GetLocationDesc(Obj);
      if Assigned(Proc_ShowCtTableProp) then
      begin
        if not Proc_ShowCtTableProp(tb, False, True) then
        begin
          Result := False;
          FCurMetaTableModel.Tables.Remove(tb);
          Exit;
        end;
        if (Obj is TDMLTableObj) then
        begin
          TDMLTableObj(Obj).Describe := tb.Describe;
          CheckDmlTableFieldProps(tb, TDMLTableObj(obj));
          TDMLTableObj(obj).CheckResize;
          TDMLTableObj(obj).FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs);
        end
        else if (Obj is TDMLTextObj) then
        begin
          TDMLTextObj(obj).Name := tb.Name;
          TDMLTextObj(obj).Comment := tb.Memo;
        end;
        tb.GraphDesc := Self.GetLocationDesc(obj);
      end;
      Obj.UserObject := tb;
      if Assigned(Proc_OnPropChange) then
        Proc_OnPropChange(0, tb, nil, '');
    end
    else if Act = 2 then
    begin
      if Obj.UserObject is TCtMetaTable then
      begin
        tb := TCtMetaTable(Obj.UserObject);
        tb.DataLevel := ctdlDeleted;
        if Assigned(Proc_OnPropChange) then
          Proc_OnPropChange(0, tb, nil, '');
      end;
    end;
  end;
end;

end.
