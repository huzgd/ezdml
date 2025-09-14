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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    FBrowseMode: Boolean;
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
    procedure actExecSqlExecute(Sender: TObject);
    procedure actBriefModeExecute(Sender: TObject);
    procedure actCopyDmlTextExecuteEx(Sender: TObject);   
    procedure actDBGenSqlExecuteEx(Sender: TObject);

    procedure actBatAddFieldsExecute(Sender: TObject);
    procedure actBatRemoveFieldsExecute(Sender: TObject);

    procedure DMLGraphViewChangedEx(Sender: TObject);

    procedure DoExportHtmlDoc(tfn: string);     
    procedure DoExportMarkdown(tfn: string);
    procedure DoExecScript(fn, tfn: string);

    {$ifdef EZDML_LITE}
    procedure DoExecPsLite(fn, tfn: string);
    {$endif}

    procedure CheckDmlTableFieldProps(ctb: TCtMetaTable; obj: TDMLTableObj);
    function GetLocationDesc(Obj: TDMLObj): string;
    procedure SetLocationDesc(Obj: TDMLObj; Des: string);

    procedure _OnObjsMoved(Sender: TObject);
    //Act: 1-add 2-remove
    function _OnObjAddOrRemove(Obj: TDMLObj; Act: integer): boolean;
    function _OnLinkObj(Obj1, Obj2: TDMLObj): integer;
    procedure _DoCapitalize(sType: string);
    procedure _SetPubType(iType: Integer);
    procedure _DoBatCopy(sType: string);
    procedure _OnSelChanged;
    procedure _OnObjColorChanged(Obj: TDMLObj; cl: Integer);      
    function _GetObjPropVal(Obj: TDMLObj; prop, def: string): string;

    function GetPubFlag(tb: TCtMetaTable): Integer;

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
    procedure CheckActEnbs;
    procedure CheckSaveView;
    procedure ShowModelProps(mdl: TCtDataModelGraph; bGraph: Boolean);
    function CountSelectedTables(tbs: TCtMetaTableList = nil): Integer;
    function GetSelectedTable: TCtMetaTable;
    function GetSelectedCtObj: TCtMetaObject;
    function LocToCtObj(obj: TCtMetaObject): boolean;
    procedure ReloadTbInfo(tb: TCtMetaTable);     
    function SelectRelateLink(tb1, tb2: TCtMetaTable; bFkOnly: Boolean): boolean;
    procedure RewriteGraphDesc;
    procedure RearrangeAll;
    procedure ReassignActionList;
    property MetaTableModel: TCtDataModelGraph read FMetaTableModel;
    property BrowseMode: Boolean read FBrowseMode write FBrowseMode;
  end;

implementation

uses
  CTMetaData, uFormAddTbLink, dmlstrs, ezdmlstrs, CtObjJsonSerial, ClipBrd,
  DmlScriptPublic, ImgView, uDMLSqlEditor, uFormDmlSearch,
  {$ifndef EZDML_LITE} ide_editor, {$else} DmlPasScriptLite, {$endif}
  AutoNameCapitalize, uFormGenSql, Toolwin, uWaitWnd;

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

  if bCanCancel then
    FCurMetaTableModel := FTempMetaTableModel
  else
    FCurMetaTableModel := FMetaTableModel;
  InitDML(FCurMetaTableModel);
  CheckActEnbs;
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

function TfrmCtDML.SelectRelateLink(tb1, tb2: TCtMetaTable; bFkOnly: Boolean): boolean;
var
  lnk: TDMLLinkObj;
  bFound: Boolean;
  J: integer;
begin
  Result := False;
  if tb1 = nil then
    Exit;          
  if tb2 = nil then
    Exit;   
  if tb1 = tb2 then
    Exit;


  with FFrameCtDML.DMLGraph.DMLObjs do
    for J := 0 to Count - 1 do
      if Items[J] is TDMLLinkObj then
      begin
        lnk:= TDMLLinkObj(Items[J]);
        if bFkOnly then
          if not (lnk.LinkType in [dmllFKNormal, dmllFKUnique]) then
            Continue;
        if not (lnk.Obj1.UserObject is TCtMetaTable) then
          Continue;
        if not (lnk.Obj2.UserObject is TCtMetaTable) then
          Continue;
        bFound := False;
        if TCtMetaTable(lnk.Obj1.UserObject).Name = tb1.Name then
        begin      
          if TCtMetaTable(lnk.Obj2.UserObject).Name = tb2.Name then
            bFound := True;
        end
        else if TCtMetaTable(lnk.Obj1.UserObject).Name = tb2.Name then
          if TCtMetaTable(lnk.Obj2.UserObject).Name = tb1.Name then
            bFound := True;
        if not bFound then
          Continue;

        FFrameCtDML.DMLGraph.DMLObjs.ClearSelection;
        lnk.Selected:=True;
        Result := True;
        Break;
      end;

  if Result then
    FFrameCtDML.DMLGraph.Reset;
end;

procedure TfrmCtDML.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
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
  FFrameCtDML.Proc_SetPubType := _SetPubType;
  FFrameCtDML.Proc_DoBatCopy := _DoBatCopy;     
  FFrameCtDML.Proc_OnObjColorChanged := _OnObjColorChanged;  
  FFrameCtDML.Proc_GetObjPropVal := _GetObjPropVal;
  FFrameCtDML.Proc_DoSelectChanged := _OnSelChanged;

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

  FFrameCtDML.actBatAddFields.OnExecute := actBatAddFieldsExecute;      
  FFrameCtDML.actBatRemoveFields.OnExecute := actBatRemoveFieldsExecute;
                                                 
  FFrameCtDML.actExecSql.OnExecute := actExecSqlExecute;

  FFrameCtDML.DMLGraph.OnViewChanged := DMLGraphViewChangedEx;

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
  FFrameCtDML.actNewGroupBox.Visible := True;
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
  begin
    Result := False;

    FGlobeDataModelList.CurDataModel.Param['ShowPhyFieldName'] :=
      IntToStr(FFrameCtDML.DMLGraph.DMLDrawer.ShowPhyFieldName);
    FGlobeDataModelList.CurDataModel.Param['DatabaseEngine'] :=
      FFrameCtDML.DMLGraph.DMLDrawer.DatabaseEngine;

    CheckSelectedTb;

    tb := GetSelectedTable;
    {$ifndef EZDML_LITE}
    if not Assigned(scriptIdeEditor) then
      Application.CreateForm(TfrmScriptIDE, scriptIdeEditor);
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
    {$else}
    raise Exception.Create(srEzdmlLiteNotSupportFun);
    {$endif}
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

procedure TfrmCtDML.actExecSqlExecute(Sender: TObject);
var
  Sql, pk: String;
  ob: TDMLObj;
  pkd, fd: TCtMetaField;
  tb, tb2: TCtMetaTable;
  C: Integer;
begin
  CheckSelectedTb;
  C := FFrameCtDML.DMLGraph.DMLObjs.SelectedCount;
  Sql := '';
  if C=1 then
  begin                                                   
    tb := GetSelectedTable;
    ob := FFrameCtDML.DMLGraph.DMLObjs.GetSelectedItem(0);
    if ob is TDMLTableObj then
    begin
      tb := TCtMetaTable(ob.UserObject);
      if tb <> nil then
      begin
        pkd := tb.GetPrimaryKeyField;
        if pkd<>nil then
        begin
          pk := pkd.Name;
          Sql := 'select t.*'#13#10'  from '+tb.RealTableName+' t'#13#10' where 1=1'#13#10'-- and t.'+pk+'='#13#10'-- order by t.'+pk+' desc';
        end
        else
          Sql := 'select t.*'#13#10'  from '+tb.RealTableName+' t'#13#10' where 1=1'#13#10'-- and t'#13#10'-- order by t desc';
      end;
    end
    else if (ob is TDMLLinkObj) and (ob.UserObject is TCtMetaField) then
    begin
      fd := (ob.UserObject as TCtMetaField);
      tb := fd.OwnerTable;
      tb2 := fd.GetRelateTableObj;
      if (tb <> nil) and (tb2 <> nil) then
      begin         
        pkd := tb.GetPrimaryKeyField;
        if pkd<>nil then
        begin
          pk := pkd.Name;
          Sql := 'select a.*, b.*'#13#10'  from '+tb.RealTableName+' a, '+tb2.RealTableName+' b'#13#10' where a.'
           +fd.Name+' = b.'+fd.RelateField+#13#10'-- and a.'+pk+'='#13#10'-- order by a.'+pk+' desc';
        end
        else
          Sql := 'select a.*, b.*'#13#10'  from '+tb.RealTableName+' a, '+tb2.RealTableName+' b'#13#10' where a.'
           +fd.Name+' = b.'+fd.RelateField+#13#10'-- and a'#13#10'-- order by a desc';
      end;
    end;
  end;

  ShowSqlEditor(sql);
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
    {$ifndef EZDML_LITE}
    if not DMLGraph.DMLObjs.BriefMode then
      CheckAllLinks;
    {$endif}
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
  ShowModelProps(FCurMetaTableModel, True);
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
    CountSelectedTables(tbs);

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

procedure TfrmCtDML.actBatAddFieldsExecute(Sender: TObject);
var
  I, C, fid: integer;
  fd, fdn: TCtMetaField;
  tb: TCtMetaTable;
  S: string;
begin
  CheckCanEditMeta;
  C := 0;   
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLTableObj then
        begin
          tb := TCtMetaTable(Items[I].UserObject);
          if tb.IsTable then
            Inc(C);
        end;

  if C <= 1 then
    raise Exception.Create(srBatchTablesNotSelected);

  fd := TCtMetaField.Create;
  try
    fd.CreateDate := Now;
    fd.DataType := cfdtString;
    fd.MetaModified := True;
    if not Proc_ShowCtFieldProp(fd, False) then
      Exit;

    C := 0;       
    with FFrameCtDML.DMLGraph.DMLObjs do
      for I := 0 to Count - 1 do
        if Items[I].Selected then
          if Items[I] is TDMLTableObj then
          begin
            tb := TCtMetaTable(Items[I].UserObject);
            if tb.IsTable then
            begin
              if tb.MetaFields.FieldByName(fd.Name) = nil then
              begin
                fdn := tb.MetaFields.NewMetaField;
                fid := fdn.Id;
                fdn.AssignFrom(fd);
                fdn.ID := fid;
                DoTablePropsChanged(tb);
                Inc(C);
              end;
            end;
          end;

    FFrameCtDML.actRefresh.Execute;
    S := srBatchAddFields + ': ' + Format(srBatchOpResultFmt, [C]);
    Application.MessageBox(PChar(S), PChar(Application.Title), MB_OK or
      MB_ICONINFORMATION);
  finally
    fd.Free;
  end;
end;

procedure TfrmCtDML.actBatRemoveFieldsExecute(Sender: TObject);
var
  I, C: integer;
  fd: TCtMetaField;
  tb: TCtMetaTable;
  S: string;
begin
  CheckCanEditMeta;
  C := 0;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLTableObj then
        begin
          tb := TCtMetaTable(Items[I].UserObject);
          if tb.IsTable then
            Inc(C);
        end;
  if C <= 1 then
    raise Exception.Create(srBatchTablesNotSelected);

  S := InputBox(srBatchRemoveFields, srBatchRemoveFieldNamePrompt, '');
  if S = '' then
    Exit;

  C := 0;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLTableObj then
        begin
          tb := TCtMetaTable(Items[I].UserObject);
          if tb.IsTable then
          begin
            fd := tb.MetaFields.FieldByName(S);
            if fd <> nil then
            begin
              tb.MetaFields.Remove(fd);
              DoTablePropsChanged(tb);
              Inc(C);
            end;
          end;
        end;

  FFrameCtDML.actRefresh.Execute;

  S := srBatchRemoveFields + ': ' + Format(srBatchOpResultFmt, [C]);
  Application.MessageBox(PChar(S), PChar(Application.Title), MB_OK or
    MB_ICONINFORMATION);
end;

procedure TfrmCtDML.DMLGraphViewChangedEx(Sender: TObject);
begin
  FFrameCtDML.DMLGraphViewChanged(Sender);
  CheckSaveView;
end;

procedure TfrmCtDML.actCopyExecute(Sender: TObject);
var
  I, C: integer;
  o: TDMLEntityObj;
  vTb, tb: TCtMetaTable;
  vTempTbs: TCtMetaTableList;
  fs: TCtObjMemJsonSerialer;
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
  fs := TCtObjMemJsonSerialer.Create(False);
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
    fs.EndJsonWrite;
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
  function GetRealTable(tb: TCtMetaTable): TCtMetaTable;
  begin
    //对于嵌入表属性里的只读浏览的临时模型图，应调用全局列表中的表属性
    Result := tb;
    if not BrowseMode then
      Exit;
    if Self.Parent = nil then
      Exit;
    if tb=nil then
      Exit;

    Result := FGlobeDataModelList.GetTableOfName(tb.Name);
    if Result = nil then
      Result := tb
    else if Result.SketchyDescribe <> tb.SketchyDescribe then
      Result := tb;
  end;
  function DoExecEditTbLink(tb1, tb2: TCtMetaTable; var cf: TCtMetaField): boolean;
  begin
    Result := ExecEditTbLink(tb1, tb2, cf, FReadOnlyMode or BrowseMode);
  end;
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
  bRes, bViewMode, cAb: boolean;
begin
  if not FFrameCtDML.DMLGraph.CanFocus then
  begin
    if Assigned(Proc_OnCanNotShowObjProp) then
      Proc_OnCanNotShowObjProp(Self);
    Exit;
  end;
  if FFrameCtDML.DMLGraph.DMLObjs.SelectedCount = 0 then
  begin
    if not FBrowseMode then
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
        if DoExecEditTbLink(olnk.Obj1.UserObject as TCtMetaTable,
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
          FLastRefreshTick := GetTickCount;
        end;
        Exit;
      end;
    Exit;
  end;


  if (obj is TDMLTableObj) and
    (TDMLTableObj(obj).UserObject is TCtMetaTable) then
  begin
    tb := GetRealTable(TCtMetaTable(TDMLTableObj(obj).UserObject));
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
            FLastRefreshTick := GetTickCount;
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
    bViewMode := FReadOnlyMode or IsTbPropDefViewMode;
    if not bViewMode then
    begin
      for I:=Screen.FormCount - 1 downto 0 do
      begin
        if LowerCase(Screen.Forms[I].ClassName) = LowerCase('TfrmCtTableProp') then
        begin
          bViewMode := True;
          Break;
        end;
      end;
    end;
    tb.UserObject['SIZE_DMLENTITY'] := TDMLTableObj(obj);
    if Assigned(cf) and Assigned(Proc_ShowCtTableOfField) then
      bRes := Proc_ShowCtTableOfField(tb, cf, bViewMode, False, False)
    else
      bRes := Proc_ShowCtTableProp(tb, bViewMode, False);     
    tb.UserObject['SIZE_DMLENTITY'] := nil;  
    if FReadOnlyMode then
      Exit;      
    cAb := G_SkipCheckAbort;
    if bRes then
    try       
      G_SkipCheckAbort := True;
      _OnObjsMoved(nil);
      //SaveToTb(tb);
      //DoTablePropsChanged 表属性保存时会自动调用
      S := tb.Name;
      TDMLTableObj(obj).Name := S;
      TDMLTableObj(obj).PubFlag:=GetPubFlag(tb);
      if tb.BgColor > 0 then
      begin
        obj.UserPars := AddOrModifyCompStr(obj.UserPars, '1', '[CUSTOM_BKCOLOR=', ']');
        obj.FillColor := tb.BgColor;
      end
      else  
        obj.UserPars := AddOrModifyCompStr(obj.UserPars, '0', '[CUSTOM_BKCOLOR=', ']');
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
      FLastRefreshTick := GetTickCount;
      if Assigned(Proc_OnPropChange) then
        Proc_OnPropChange(2, tb, nil, '');
      if oName <> tb.Name then
      begin
        FFrameCtDML.actRefresh.Execute;
      end;

    finally 
      G_SkipCheckAbort := cAb;
    end;
    Exit;
  end;

  if (obj is TDMLTextObj) and
    (TDMLTextObj(obj).UserObject is TCtMetaTable) then
  begin
    tb := GetRealTable(TCtMetaTable(TDMLTextObj(obj).UserObject));
    if not Assigned(Proc_ShowCtTableProp) then
      raise Exception.Create('Proc_ShowCtTableProp not defined'); 
    tb.UserObject['SIZE_DMLENTITY'] := TDMLTextObj(obj);
    if Proc_ShowCtTableProp(tb, FReadOnlyMode or IsTbPropDefViewMode, False) then
    begin          
      tb.UserObject['SIZE_DMLENTITY'] := nil;
      if FReadOnlyMode then
        Exit;
      cAb := G_SkipCheckAbort;
      try              
        G_SkipCheckAbort := True;
        _OnObjsMoved(nil);
        //SaveToTb(tb);
        TDMLTextObj(obj).Comment := tb.Memo;
        TDMLTextObj(obj).CheckResize;
        FFrameCtDML.DMLGraph.Refresh;
        FLastRefreshTick := GetTickCount;    
      finally  
        G_SkipCheckAbort := cAb;
      end;
      if Assigned(Proc_OnPropChange) then
        Proc_OnPropChange(2, tb, nil, '');
    end;
    tb.UserObject['SIZE_DMLENTITY'] := nil;
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
    {$ifdef EZDML_LITE}
      Filter :=
        'Word file(*.doc)|*.doc|Excel file(*.xls)|*.xls'
        + '|Bitmap Image file(*.bmp)|*.bmp|JPEG Image file(*.jpg)|*.jpg'
        + '|Portable Network Image file(*.png)|*.png';
    {$else}
      Filter :=
        'Markdown file(*.md)|*.md|Word file(*.doc)|*.doc|Excel file(*.xls)|*.xls|Mht file(*.mht)|*.mht|Html file(*.html)|*.html'
        + '|Bitmap Image file(*.bmp)|*.bmp|JPEG Image file(*.jpg)|*.jpg'
        + '|Portable Network Image file(*.png)|*.png';//|Meta Image file(*.wmf)|*.wmf';
    {$endif}
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
  {$ifndef EZDML_LITE}
  //by huz: 引入markdown后，导出excel也改用脚本实现，方便用户自定义
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
  {$else}
  if (S = '.doc') then
  begin
    DoExecPsLite('Word_html', fn);
    Exit;
  end;
  if (S = '.xls') then
  begin
    DoExecPsLite('Excel_html', fn);
    //removed by huz：旧版导出EXCEL，转到lazarus后导出格式错误，估计跟编码之类的有关
    //FFrameCtDML.ExportToExcel(fn);
    Exit;
  end;
  {$endif}
  if (S = '.png') or (S = '.bmp') or (S = '.jpg') or (S = '.wmf') then
  begin
    FFrameCtDML.SaveDmlImage(fn);  
    if Application.MessageBox(PChar(srConfirmOpenXlsAfterExport),
      PChar(Application.Title), MB_OKCANCEL) = IDOK then
       CtOpenDoc(PChar(fn));
    Exit;
  end;

  raise Exception.Create('Not supported format: ' + s);
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

  procedure CheckHasDiffTb(tb: TCtMetaTable);
  var
    ctb: TCtMetaTable;   
    n: integer;
  begin
    //如果本模型中没有，但其它模型有，且内容不一样：1 覆盖 2 改名
    ctb := FGlobeDataModelList.GetTableOfName(tb.Name);
    if ctb = nil then
      Exit;
    if ctb.MaybeSame(tb) then
      Exit;
    case Application.MessageBox(PChar(Format(srDmlPasteExistsTableFmt,[tb.Name])),
      PChar(Application.Title), MB_YESNOCANCEL or MB_ICONWARNING) of
      IDYES:
        Exit;
      IDNO:
        begin
          n := 1;
          while HasSameNameTables(tb, tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n))) do
            Inc(n);
          tb.Name := tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));   
          if tb.Caption <> '' then
             tb.Caption :=  tb.Caption + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));
        end;
      else
        Abort;
    end;
  end;

  procedure RenameTbIfExists(tb: TCtMetaTable);
  var
    n: integer;
  begin           
    if Sender = nil then
      Exit;

    if tb.IsTable then
      if FCurMetaTableModel.Tables.ItemByName(tb.Name) = nil then
      begin
        CheckHasDiffTb(tb);
        Exit;
      end;
    if not HasSameNameTables(tb, tb.Name) then
      Exit;

    n := 1;
    while HasSameNameTables(tb, tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n))) do
      Inc(n);
    tb.Name := tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));
    if tb.Caption <> '' then
       tb.Caption :=  tb.Caption + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));
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
      if tb.Caption <> '' then
         tb.Caption :=  tb.Caption + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));

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
  fs: TCtObjMemJsonSerialer;
  ss: TStringList;
  S: string;
  tb: TCtMetaTable;   
  vTempFlds: TCtMetaFieldList;  
  fd: TCtMetaField;
  cto: TCtMetaObject;
  obj2: TDMLObj;
  sc: double;
  bInd: Boolean;
  lastPos: TPoint;
  cx, cy, x0, y0, x1, y1, dx, dy: double;
begin       
  if FReadOnlyMode then
    Exit;
  S := Clipboard.AsText;
  if S = '' then
    Exit;
  if Copy(S, 1, 1) <> '{' then
    Exit;
  CheckCanEditMeta;
  lastPos := Self.FFrameCtDML.DMLGraph.LastMouseDownPos;

  I := Pos('"RootName": "Tables"', S);
  if I=0 then   
    I := Pos('"RootName":"Tables"', S);
  if (I > 0) and (I < 100) then
  begin
    ///LockWindowUpdate(Self.Handle);
    vTempTbs := TCtMetaTableList.Create;
    fs := TCtObjMemJsonSerialer.Create(True);
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
        DoTablePropsChanged(tb);
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
        bInd := FFrameCtDML.DMLGraph.DMLDrawer.IndependPosForOverviewMode;
        FFrameCtDML.DMLGraph.DMLDrawer.IndependPosForOverviewMode := False;
        try
          FFrameCtDML.DMLGraph.DMLObjs.MoveSelected(dx, dy);
        finally
          FFrameCtDML.DMLGraph.DMLDrawer.IndependPosForOverviewMode := bInd;
        end;
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


  I := Pos('"RootName": "Fields"', S);
  if I=0 then
    I := Pos('"RootName":"Fields"', S);
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
    fs := TCtObjMemJsonSerialer.Create(True);
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

      if obj2<>nil then
      begin
        TDMLTableObj(obj2).Describe := tb.Describe;
        TDMLTableObj(obj2).IsView := not tb.GenDatabase;
        CheckDmlTableFieldProps(tb, TDMLTableObj(obj2));
        TDMLTableObj(obj2).CheckResize;
        TDMLTableObj(obj2).FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs);
      end;

      CheckAllLinks; //添加缺失的连线

      FFrameCtDML.DMLGraph.Refresh;
      DoTablePropsChanged(tb);
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
    if Copy(S, 1, 1) <> '{' then
    begin
      FFrameCtDML.actPaste.Enabled := False;
      FFrameCtDML.actPasteAsCopy.Enabled := False;
    end
    else
    begin
      I := Pos('"RootName": "Tables"', S);    
      if I=0 then
        I := Pos('"RootName":"Tables"', S);
      if (I > 0) and (I < 100) then
      begin
        FFrameCtDML.actPasteAsCopy.Enabled := True;
        FFrameCtDML.actPaste.Enabled := True;
      end
      else
      begin          
        FFrameCtDML.actPasteAsCopy.Enabled := False;
                        
        I := Pos('"RootName": "Fields"', S);  
        if I=0 then
          I := Pos('"RootName":"Fields"', S);
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
  for I := obj.FieldCount - 1 downto 0 do
  begin
    f := obj.Field[I];
    S := f.Get_PhyName;
    if S = '' then
      Continue;
    cf := TCtMetaField(ctb.MetaFields.ItemByName(S));
    if cf = nil then
      Continue;    
    if cf.FieldWeight <= -9 then
      if not (cf.KeyFieldType in [cfktRid, cfktId]) then
      begin
        obj.DeleteField(I);
        if Pos('[HAS_MORE_FIELDS]', obj.UserPars) = 0 then
          obj.UserPars := obj.UserPars + '[HAS_MORE_FIELDS]';
        Continue;
      end;
    f.FieldTypeName := cf.DataTypeName;
    f.IndexType := integer(cf.IndexType);
    f.ExOptions := '';
    if cf.FieldWeight <> 0 then
      f.ExOptions:=f.ExOptions + '[WEIGHT:' + IntToStr(cf.FieldWeight) + ']';
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

procedure TfrmCtDML.CheckActEnbs;
begin
  //FFrameCtDML.ToolBar1.Visible := not FReadOnlyMode or bCanCancel;
  with FFrameCtDML do
  begin   
    StatusBar1.Visible := False;
    actNewObj.Visible := not FReadOnlyMode;
    actNewText.Visible := not FReadOnlyMode;
    actAddLink.Visible := not FReadOnlyMode;   
    actNewGroupBox.Visible := not FReadOnlyMode;
    actDeleteObj.Visible := not FReadOnlyMode; 
    actDeleteObj.Enabled := not FReadOnlyMode;
    actSetEntityColor.Visible := not FReadOnlyMode;
    actResetObjLinks.Visible := not FReadOnlyMode;

    actDMLObjProp.Visible := Assigned(FCurMetaTableModel);
    actCopyImage.Visible := Assigned(FCurMetaTableModel);
    actCopyDmlText.Visible := Assigned(FCurMetaTableModel);
    actSelectAll.Visible := Assigned(FCurMetaTableModel);
    actExportXls.Visible := Assigned(FCurMetaTableModel);
    actFindObject.Visible := Assigned(FCurMetaTableModel);

    ToolButtonRun.Visible := Assigned(FCurMetaTableModel);

    actFileNew.Visible := not FBrowseMode;         
    actFileOpen.Visible := not FBrowseMode;
    actFileSave.Visible := not FBrowseMode;

    actFindObject.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);       
    actExportXls.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);
    actBatchOps.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);        
    actDBGenSql.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);
    MN_GenCode.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);
    MN_Capitalize.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);      
    MN_PublishType.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);
    actFullTableView.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);
    {$ifdef EZDML_LITE}
    actChatGPT.Visible := False;
    MNRun_GenData.Visible:=False;
    MNRun_GenCode.Visible:=False;     
    MN_GenCode.Visible:=False;
    actBatchOps.Visible:=False;
    actCnWordSegment.Visible:=False;
    {$else}          
    {$ifdef WIN32} 
    actChatGPT.Visible := False;   
    {$else}
    actChatGPT.Visible := not FBrowseMode and not FReadOnlyMode;// and (actChatGPT.Tag=2);
    {$endif}
    {$endif}           
    ToolButtonAI.Visible := actChatGPT.Visible;        
    MenuItem_AI.Visible := actChatGPT.Visible;
    actRun.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);
    actColorStyles.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);
    btnShowInGraph.Visible := not FBrowseMode;
                                     
    actRearrange.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);

    actBatAddFields.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);
    actBatRemoveFields.Visible := not FBrowseMode and Assigned(FCurMetaTableModel);  
    actOpenURL.Visible := False;//not FBrowseMode;
    actShareFile.Visible := False;//not FBrowseMode;

    if FBrowseMode then
    begin
      ToolButtonDMLSp0.Visible := False;
      ToolButtonDMLSp1.Visible := False;
      ToolButtonDMLsp2.Visible := False;
      ToolButtonDMLsp3.Visible := False;    
      ToolButtonRun.Visible := False;
      //ToolBar1.Align := alLeft;
      //ToolBar1.EdgeBorders:=[ebRight];
    end
    else
      ToolButtonDMLsp2.Visible := not FReadOnlyMode;

    SortToolBtns;
  end;

end;

procedure TfrmCtDML.CheckSaveView;      
var
  S: String;
  obj: TDMLObj;
begin
  if FCurMetaTableModel = nil then //保存视图
    Exit;
  if FCurMetaTableModel.Tables.Count = 0 then
    Exit;

  S := Format('DVS:%f,%f,%f', [FFrameCtDML.DMLGraph.ViewCenterX,FFrameCtDML.DMLGraph.ViewCenterY,FFrameCtDML.DMLGraph.ViewScale]);
  if FFrameCtDML.DMLGraph.DMLObjs.BriefMode then
  begin
    S := S +',1';
  end
  else
    S := S +',0';
  obj := FFrameCtDML.DMLGraph.DMLObjs.SelectedObj;
  if Assigned(obj) and Assigned(obj.UserObject) and (obj.UserObject is TCtMetaTable) then
  begin
    S := S +','+ TCtMetaTable(obj.UserObject).Name;
  end
  else if Assigned(obj) and Assigned(obj.UserObject) and (obj is TDMLLinkObj)
    and (obj.UserObject is TCtMetaField) and Assigned(TCtMetaField(obj.UserObject).OwnerTable) then
  begin
    S := S +','+TCtMetaField(obj.UserObject).OwnerTable.Name+'.'+ TCtMetaField(obj.UserObject).Name;
  end
  else
  begin
    S := S +',';
  end;
  FCurMetaTableModel.CustomAttr1 := S;
end;

procedure TfrmCtDML.ShowModelProps(mdl: TCtDataModelGraph; bGraph: Boolean);
var
  oName: string;
  pt: Integer;
begin
  CheckCanEditMeta;
  EzdmlMenuActExecuteEvt('Model_ColorStyles');

  if mdl <> nil then
  begin
    with FFrameCtDML.DMLGraph.DMLDrawer do
    begin
      ModelName:=mdl.Name;
      ModelCaption:=mdl.Caption;
      ModelMemo:=mdl.Memo;
      ModelExProps:=mdl.ExtraProps;
      ModelPubType:=Integer(mdl.PublishType);
      ModelPurviewRoles:=mdl.PurviewRoles;
    end;
  end
  else
    with FFrameCtDML.DMLGraph.DMLDrawer do
    begin
      ModelName:='';
      ModelCaption:='';
      ModelMemo:='';
      ModelExProps:='';
      ModelPubType:=0;
      ModelPurviewRoles:='';
    end;
  pt := FFrameCtDML.DMLGraph.DMLDrawer.ModelPubType;


  FFrameCtDML.ShowColorStyleProps(bGraph);
  ResetCtFieldTextColor;
  if mdl <> nil then
  begin
    oName := mdl.NameCaption;
    with FFrameCtDML.DMLGraph.DMLDrawer do
    begin
      mdl.Name:=ModelName;
      mdl.Caption:=ModelCaption;
      mdl.Memo:=ModelMemo;
      mdl.ExtraProps:=ModelExProps;
      mdl.PublishType:=TCtModulePublishType(ModelPubType);
      mdl.PurviewRoles:=ModelPurviewRoles;
    end;
    if bGraph then
      mdl.ConfigStr := FFrameCtDML.DMLGraph.DMLDrawer.GetConfigStr;
    if (oName <> mdl.NameCaption) or (pt <> FFrameCtDML.DMLGraph.DMLDrawer.ModelPubType) then
    begin
      FFrameCtDML.actRefresh.Execute;
    end;
  end;
end;

function TfrmCtDML.CountSelectedTables(tbs: TCtMetaTableList): Integer;
var
  I: integer;
  tb: TCtMetaTable;
begin
  Result := 0;
  with FFrameCtDML.DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if (Items[I] <> nil) and (Items[I].UserObject is TCtMetaTable) then
          if TCtMetaTable(Items[I].UserObject).IsTable then
          begin
            tb := TCtMetaTable(Items[I].UserObject);
            if tb <> nil then
            begin
              Inc(Result);
              if tbs <> nil then
                tbs.Add(tb);
            end;
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
                                          
{$ifdef EZDML_LITE}
procedure TfrmCtDML.DoExecPsLite(fn, tfn: string);
var             
  ScLt : TDmlPasScriptorLite;
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
           
  ScLt := CreatePsLiteScriptor(fn);
  if ScLt = nil then
    raise Exception.Create('PasLite not found: ' + fn);

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

  AOutput := TStringList.Create;
  with ScLt do
    try
      Init('DML_SCRIPT', tb, AOutput, nil);
      Exec('DML_SCRIPT', '');
      AOutput.SaveToFile(tfn);
    finally
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
{$endif}

procedure TfrmCtDML.InitDML(mdl: TCtDataModelGraph);
var
  o: TDMLEntityObj;
  tb: TCtMetaTable;
  FLastObjX, FLastObjY, dv, vCenterX, vCenterY, vScale: double;
  DMLObjList: TDMLObjList;
  obj: TDMLObj;
  I, po, idx, prcI, prcAll: integer;
  tbs: TCtMetaTableList;
  bfMode: boolean;
  selStr, S, T: string;
  frWait: TfrmWaitWnd;
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
    frWait := TfrmWaitWnd.Create(Self);
    DMLObjList.DMLDrawer.FIsHugeMode := True;
  end
  else
  begin
    frWait := nil;     
    Screen.Cursor := crAppStart;
    DMLObjList.DMLDrawer.FIsHugeMode := False;
  end;
  try   
    if Assigned(frWait) then
      frWait.Init(srRendering+' '+mdl.NameCaption, srProcessing, srConfirmAbort);
    prcI := 0;
    prcAll := tbs.Count;

    //先输出有位置信息的
    for I := 0 to tbs.Count - 1 do
      if tbs.Items[I].DataLevel <> ctdlDeleted then
        if tbs.Items[I].GraphDesc <> '' then
        begin       
          tb := tbs.Items[I];
          if tb.IsGroup then
          begin
            o := TDMLGroupBoxObj.Create;
            o.UserObject := tb;
            o.Comment := tb.Memo;
            o.Name := tb.Name;
          end
          else if tb.IsText then
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
            TDMLTableObj(o).PubFlag:=GetPubFlag(tb);
            CheckDmlTableFieldProps(tb, TDMLTableObj(o));
          end;
          o.CheckResize;

          o.ID := DMLObjList.GetNextObjID;
          DMLObjList.Add(o);
          SetLocationDesc(o, tb.GraphDesc);
          if tb.BgColor > 0 then
          begin
            o.UserPars := AddOrModifyCompStr(o.UserPars, '1', '[CUSTOM_BKCOLOR=', ']');
            o.FillColor := tb.BgColor;
          end;

          Inc(prcI);
          if Assigned(frWait) and ((prcI mod 50)=0) then
            frWait.SetPercentMsg(prcI * 100 / prcAll, Format('%d/%d ', [prcI, prcAll])+tb.Name, True);

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

                     
    //再输出无位置信息的（自动分配位置）
    for I := 0 to tbs.Count - 1 do
      if tbs.Items[I].DataLevel <> ctdlDeleted then
        if tbs.Items[I].GraphDesc = '' then
        begin
          tb := tbs.Items[I];

          if tb.IsGroup then
          begin
            o := TDMLGroupBoxObj.Create;
            o.UserObject := tb;
            o.Comment := tb.Memo;
          end
          else if tb.IsText then
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
            TDMLTableObj(o).PubFlag:=GetPubFlag(tb);
            CheckDmlTableFieldProps(tb, TDMLTableObj(o));
          end;
          o.CheckResize;  
          if tb.BgColor > 0 then
          begin
            o.UserPars := AddOrModifyCompStr(o.UserPars, '1', '[CUSTOM_BKCOLOR=', ']');
            o.FillColor := tb.BgColor;
          end;

          o.ID := DMLObjList.GetNextObjID;
          idx := DMLObjList.Add(o);
          DMLObjList.FindSpaceEx(o, FLastObjX, FLastObjY, 100, idx);
          //tb.GraphDesc := GetLocationDesc(o);
          FLastObjX := o.Left;
          FLastObjY := o.Top;

          Inc(prcI);
          if Assigned(frWait) and ((prcI mod 50)=0) then
            frWait.SetPercentMsg(prcI * 100 / prcAll, Format('%d/%d ', [prcI, prcAll])+tb.Name, True);
        end;

    for I := 0 to DMLObjList.Count - 1 do
      FFrameCtDML.DMLGraph.DMLDrawer.SetDefaultProps(DMLObjList[I]);

    CheckAllLinks;

  finally
    DMLObjList.FindNewSpace := True; 
    if Assigned(frWait) then
      frWait.Release;
    Screen.Cursor := crDefault;
  end;
  if bfMode then
    DMLObjList.BriefMode := True;
  FFrameCtDML.DMLGraph.AutoCheckGraphSize;
  if not FCtDmlRefreshing and (Abs(int64(GetTickCount) - FLastRefreshTick) > 600) then
  begin                      
    S := Trim(mdl.CustomAttr1);
    if not BrowseMode and (Copy(S,1,4)='DVS:') then //恢复视图
    begin
      S := Copy(S, 5, Length(S));
      vCenterX := ReadCornerNumber(S, S, FFrameCtDML.DMLGraph.ViewCenterX);
      vCenterY := ReadCornerNumber(S, S, FFrameCtDML.DMLGraph.ViewCenterY);
      vScale := ReadCornerNumber(S, S, FFrameCtDML.DMLGraph.ViewScale);
      DMLObjList.BriefMode := ReadCornerStr(S, S)='1';
      selStr := ReadCornerStr(S, S);
      if selStr<>'' then  //恢复选中内容
      begin
        po := Pos('.', selStr);
        if po=0 then
        begin
          obj:=DMLObjList.ItemByName(selStr);
          if Assigned(obj) then
            obj.Selected := True;
        end
        else
        begin
          T := Copy(selStr, 1, po-1);
          selStr := Copy(selStr, po+1, Length(selStr));
          for I := 0 to DMLObjList.Count - 1 do
          begin
            obj := DMLObjList[I];
            if (obj is TDMLLinkObj) and Assigned(obj.UserObject) and (obj.UserObject is TCtMetaField) then
            begin
              if TCtMetaField(obj.UserObject).Name=selStr then
                if TCtMetaField(obj.UserObject).OwnerTable <> nil then
                  if TCtMetaField(obj.UserObject).OwnerTable.Name=T then
                  begin
                    obj.Selected:=True;
                    Break;
                  end;
            end;
          end;
        end;
      end;
      FFrameCtDML.DMLGraph.SetViewXYSc(vCenterX, vCenterY, vScale);
    end
    else
    begin
      DMLObjList.BriefMode := False;
      FFrameCtDML.actRestore.Execute;
      if DMLObjList.Count > 0 then
        with FFrameCtDML.DMLGraph do
          if DMLObjList.FindEntityInRect(ScreenToImageX(0), ScreenToImageY(0),
            ScreenToImageX(Width * 2 div 3), ScreenToImageY(Height * 2 div 3)) < 0 then
          begin
            FFrameCtDML.actBestFit.Execute;
          end;
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
    if (Abs(Obj.BLeft)<0.0001) and (Abs(Obj.BTop)<0.0001) then
      Result := Format('Left=%f'#13#10'Top=%f', [Obj.OLeft, Obj.OTop])
    else
      Result := Format('Left=%f'#13#10'Top=%f'#13#10'BLeft=%f'#13#10'BTop=%f',
        [Obj.OLeft, Obj.OTop, Obj.BLeft, Obj.BTop]);
    if not Obj.AutoSize then
    begin
      Result := Result+Format(#13#10'Width=%f'#13#10'Height=%f'#13#10'AutoSize=0', [Obj.OWidth, Obj.OHeight]);
      if Obj is TDMLGroupBoxObj then         
        Result := Result+Format(#13#10'BWidth=%f'#13#10'BHeight=%f', [Obj.BWidth, Obj.BHeight]);
    end;

    //if Pos('[CUSTOM_BKCOLOR=1]', Obj.UserPars) > 0 then
    //  Result := Result + #13#10'BkColor=' + IntToStr(Obj.FillColor);

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

    S1 := ExtractCompStr(Des, #10'AutoSize=', #10);
    if S1='0' then
    begin
      Obj.AutoSize:=False;
      S1 := ExtractCompStr(Des, #10'Width=', #10);
      S2 := ExtractCompStr(Des, #10'Height=', #10);
      if (S1 <> '') and (S2 <> '') then
      begin
        Obj.OWidth := StrToFloatDef(S1, Obj.OWidth);
        Obj.OHeight := StrToFloatDef(S2, Obj.OHeight);
      end;    
      if Obj is TDMLGroupBoxObj then
      begin
        S1 := ExtractCompStr(Des, #10'BWidth=', #10);
        S2 := ExtractCompStr(Des, #10'BHeight=', #10);
        if (S1 <> '') and (S2 <> '') then
        begin
          Obj.BWidth := StrToFloatDef(S1, Obj.BWidth);
          Obj.BHeight := StrToFloatDef(S2, Obj.BHeight);
        end;
      end;
    end;

    //S2 := ExtractCompStr(Des, #10'BkColor=', #10);
    //if S2 <> '' then
    //begin
    //  Obj.UserPars := AddOrModifyCompStr(Obj.UserPars, '1', '[CUSTOM_BKCOLOR=', ']');
    //  Obj.FillColor := StrToIntDef(S2, clWhite);
    //end;
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
  //if FReadOnlyMode then  //removed by huz 20220416: 只读时允许记录位置
  //  Exit;
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

          if Sender <> nil then  //sender为nil时，表字段可能已经删除，不可以访问
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
        if Sender <> nil then
        if not FFrameCtDML.DMLGraph.DMLObjs.BriefMode then
          if Items[I] is TDMLLinkObj then
            if TDMLLinkObj(Items[I]).UserObject is TCtMetaField then
              TCtMetaField(Items[I].UserObject).GraphDesc :=
                Self.GetLocationDesc(Items[I]);
      end;
  end;
                             
  if Sender <> nil then
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
  //if FReadOnlyMode then //removed by huz 20220416: 只读时允许记录位置
  //  Exit;
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
  tb1, tb2, tb: TCtMetaTable; 
  obj: TDMLTableObj;
  fd: TDMLField;
  rfn, S, desc1, relDesc: string;
  cAb: Boolean;
begin
  Result := -1;
  if Self.FReadOnlyMode then
    Exit;
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
  relDesc := '';
  if ExecAddTbLink(tb1, tb2, FLastLinkField, S, relDesc) then
  begin
    Result := 1;
  end;

  if (FLastLinkField=nil) and (relDesc<>'') then
  begin      
    Result := -1;
    tb := FCurMetaTableModel.Tables.NewTableItem;
    tb.Describe := relDesc;
    if Assigned(Proc_ShowCtTableProp) then
    begin
      if not Proc_ShowCtTableProp(tb, False, True) then
      begin
        Exit;
      end;
    end;
          
    cAb := G_SkipCheckAbort;
    try
      G_SkipCheckAbort := True;
      Obj := TDMLTableObj(FFrameCtDML.DMLGraph.DMLObjs.CreateDMLObj(''));
      Obj.Describe := tb.Describe;
      CheckDmlTableFieldProps(tb, obj);
      obj.CheckResize;
      obj.FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs);
      Obj.UserObject := tb;
      Obj.Left := (Obj1.Left + Obj2.Left) / 2;
      Obj.Top := (Obj1.Top + Obj2.Top) / 2;
      tb.GraphDesc := Self.GetLocationDesc(obj);

      FFrameCtDML.DMLGraph.DMLObjs.ClearSelection;
      Obj.Selected:=True;
      FFrameCtDML.DMLGraphSelectObj(nil);
      FFrameCtDML.DMLGraph.Refresh;
      FLastRefreshTick := GetTickCount; 
    finally
      G_SkipCheckAbort := cAb;
    end;
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, tb, nil, '');
    Exit;
  end;

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
              DoTablePropsChanged(tb);
              if Assigned(Proc_OnPropChange) then
                Proc_OnPropChange(2, tb, nil, '');
              bChg := True;
            end;
          end;

  finally
    if bChg then
      FFrameCtDML.actRefresh.Execute;
  end;
end;

procedure TfrmCtDML._SetPubType(iType: Integer);
var
  I: integer;
  o: TDMLEntityObj;
  tb: TCtMetaTable;
  bChg: boolean;
begin
  bChg := False;
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
            if not tb.IsTable then
              Continue;

            if iType <> Integer(tb.PublishType) then
            begin
              tb.PublishType := TCtModulePublishType(iType);
              DoTablePropsChanged(tb);
              if Assigned(Proc_OnPropChange) then
                Proc_OnPropChange(2, tb, nil, '');
              bChg := True;
            end;
          end;
  finally
    if bChg then
      FFrameCtDML.actRefresh.Execute;
  end;
end;

procedure TfrmCtDML._DoBatCopy(sType: string);
var
  jtbs: TList;
  function GetJoinWhere(tb: TCtMetaTable; bAlias: String): string;
  var
    I: Integer;
    aAlias, S: String;
  begin
    Result := '';
    for I:=0 to jtbs.Count - 1 do
    begin
      aAlias := char(Ord('a') + I);
      S := TCtMetaTable(jtbs[I]).GenJoinSqlWhere(tb, aAlias, bAlias, True);
      if S <> '' then
      begin
        if Result <> '' then
          Result := Result +' and ';
        Result := Result + S;
      end;
    end;
  end;
  function LPadStr(str, pd: string): string;
  var
    ts: TStringList;
    I: Integer;
  begin
    ts:= TStringList.Create;
    try
      ts.Text := str;
      for I:=1 to ts.Count - 1 do
      begin
        if Trim(ts[I])<>'' then
          ts[I] := pd+ts[I];
      end;
      Result:=TrimRight(ts.Text);
    finally
      ts.Free;
    end;
  end;
var
  I, J, SC, C, showTp: integer;
  ob: TDMLObj;
  o: TDMLEntityObj;
  tb: TCtMetaTable;
  field: TCTMetaField;
  S, dbType, t, fldJoin, tbJoin, sWhere: string;
  ss: TStringList;
begin
  if FFrameCtDML.DMLGraph.DMLObjs.SelectedCount = 0 then
    Exit;
  showTp := FFrameCtDML.DMLGraph.DMLDrawer.ShowPhyFieldName;
  dbType := FFrameCtDML.DMLGraph.DMLDrawer.DatabaseEngine;
  ss := TStringList.Create;  
  jtbs:= TList.Create;
  try
    C := 0;
    fldJoin := '';
    tbJoin := '';
    sWhere := '';
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
      else if not tb.IsTable then
        Continue
      else if sType = 'CreateSQL' then
      begin
        s := tb.GenSql(dbType);
        ss.Add(s);
        ss.Add('');
      end                    
      else if sType = 'DropSQL' then
      begin
        s := tb.GenDropSql(dbType);
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'SelectSQL' then
      begin
        s := tb.GenSelectSql(20, dbType);
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'ExplicitJoinSelectSQL' then
      begin
        t := char(Ord('a') + C);
        Inc(C);
        S := '';
        for J := 0 to tb.MetaFields.Count - 1 do
        begin
          field := tb.MetaFields[J];
          if not field.IsPhysicalField then
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
        begin
          S := GetJoinWhere(tb, t);
          if S <> '' then
            S := ' on '+S;
          tbJoin := tbJoin + #13#10'join ' + tb.Name + ' ' + t + S;
        end;
        jtbs.Add(tb);
      end       
      else if sType = 'ImplicitJoinSelectSQL' then
      begin
        t := char(Ord('a') + C);
        Inc(C);
        S := '';
        for J := 0 to tb.MetaFields.Count - 1 do
        begin
          field := tb.MetaFields[J];
          if not field.IsPhysicalField then
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
          tbJoin := tbJoin + ', ' + tb.Name + ' ' + t;

        S := GetJoinWhere(tb, t);
        if S <> '' then
        begin
          if sWhere = '' then
            sWhere := S
          else
            sWhere := sWhere + #13#10'and '+S;
        end;

        jtbs.Add(tb);
      end
      else if sType = 'InsertSQL' then
      begin
        s := tb.GenDqlDmlSql(dbType, 'insert'); 
        if SC>1 then
          s:=Trim(s)+';'#13#10;
        ss.Add(s);
        ss.Add('');
      end
      else if sType = 'UpdateSQL' then
      begin
        s := tb.GenDqlDmlSql(dbType, 'update'); 
        if SC>1 then
          s:=Trim(s)+';'#13#10;
        ss.Add(s);
        ss.Add('');
      end             
      else if sType = 'DeleteSQL' then
      begin
        s := tb.GenDqlDmlSql(dbType, 'delete');
        if SC>1 then
          s:=Trim(s)+';'#13#10;
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
    if sType = 'ExplicitJoinSelectSQL' then
    begin
      if tbJoin = '' then
        Exit;
      ss.Add('select');
      ss.Add('');
      ss.Add('  '+LPadStr(fldJoin,'  '));
      ss.Add('');
      ss.Add(' from '+LPadStr(tbJoin, ' '));
      ss.Add('');
      ss.Add('where 1=1');
    end;         
    if sType = 'ImplicitJoinSelectSQL' then
    begin
      if tbJoin = '' then
        Exit;
      ss.Add('select');
      ss.Add('');
      ss.Add('  '+LPadStr(fldJoin,'  '));
      ss.Add('');
      ss.Add(' from '+tbJoin);   
      ss.Add('');
      if sWhere = '' then
        ss.Add('where 1=1')
      else
        ss.Add('where '+LPadStr(sWhere,'  '));
    end;
    ClipBoard.AsText := Trim(ss.Text);
  finally
    ss.Free;
    jtbs.Free;
  end;
end;

procedure TfrmCtDML._OnSelChanged;
begin
  CheckSaveView;
end;

procedure TfrmCtDML._OnObjColorChanged(Obj: TDMLObj; cl: Integer);
var
  tb: TCtMetaTable;
begin
  if (Obj is TDMLTableObj) or (Obj is TDMLTextObj) then
  begin
    tb := TCtMetaTable(Obj.UserObject);
    if tb = nil then
      Exit;
    tb.BgColor:= cl;
    DoTablePropsChanged(tb);
  end;
end;

function TfrmCtDML._GetObjPropVal(Obj: TDMLObj; prop, def: string): string;
var     
  tb: TCtMetaTable;
begin
  Result := def;
  if prop='FieldCount' then
  begin
    if obj=nil then
      Exit;
    if not (obj is TDMLTableObj) then
      Exit;
    tb := TCtMetaTable(TDMLTableObj(obj).UserObject);
    if tb=nil then
      Exit;
    Result := IntToStr(tb.MetaFields.ValidItemCount);
  end;
end;

function TfrmCtDML.GetPubFlag(tb: TCtMetaTable): Integer;
var
  pt: TCtModulePublishType;
begin        
  //0=none 1=green 2=blue 3=red 4=g2 5=b2 6=r2 -1=auto
  Result := 0;
  pt := tb.PublishType;
  if pt=cmptFunction then
    Result := 1
  else if pt=cmptModule then
    Result := 2
  else if pt=cmptMenu then
    Result := 3
  else if pt=cmptAuto then
  begin
    pt := tb.GetInhPublishType;
    if pt=cmptFunction then
      Result := 4
    else if pt=cmptModule then
      Result := 5
    else if pt=cmptMenu then
      Result := 6
    else
      Result := -1;
  end;
end;

function TfrmCtDML._OnObjAddOrRemove(Obj: TDMLObj; Act: integer): boolean;
var
  tb: TCtMetaTable;
  fdn: string;
  df: TDMLField; 
  cAb: Boolean;
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
      if Obj is TDMLGroupBoxObj then
      begin
        tb := FCurMetaTableModel.Tables.NewTableItem('GROUP');
        tb.Memo := tb.Name;
        tb.BgColor:= Obj.FillColor;
      end
      else if Obj is TDMLTextObj then
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
        tb.UserObject['SIZE_DMLENTITY'] := TDMLTableObj(obj);
        if not Proc_ShowCtTableProp(tb, False, True) then
        begin
          Result := False;
          FCurMetaTableModel.Tables.Remove(tb);
          Exit;
        end; 
        tb.UserObject['SIZE_DMLENTITY'] := nil;
        if tb.BgColor>0 then
          Obj.FillColor := tb.BgColor;
        if (Obj is TDMLTableObj) then
        begin   
          cAb := G_SkipCheckAbort;
          try
            G_SkipCheckAbort := True;          
            TDMLTableObj(obj).PubFlag:=GetPubFlag(tb);
            TDMLTableObj(Obj).Describe := tb.Describe;
            CheckDmlTableFieldProps(tb, TDMLTableObj(obj));
            TDMLTableObj(obj).CheckResize;
            TDMLTableObj(obj).FindFKLinks(FFrameCtDML.DMLGraph.DMLObjs); 
          finally
            G_SkipCheckAbort := cAb;
          end;
        end
        else if (Obj is TDMLTextObj) then
        begin
          TDMLTextObj(obj).Name := tb.Name;
          TDMLTextObj(obj).Comment := tb.Memo;
        end;
        tb.GraphDesc := Self.GetLocationDesc(obj);
      end;
      Obj.UserObject := tb;
      FLastRefreshTick := GetTickCount;
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
