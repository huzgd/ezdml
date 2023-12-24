unit uFormGenData;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, DB,
  Dialogs, ComCtrls, StdCtrls, CheckLst, Menus, StrUtils,
  ExtCtrls, ActnList, StdActns, Buttons,
  CtMetaTable, CTMetaData, uJson;

type

  { TfrmCtGenData }

  TfrmCtGenData = class(TForm)
    Bevel1: TBevel;
    btnDBLogon: TButton;
    btnListMenu: TBitBtn;
    btnSelDbType: TButton;
    ckbProcOracleSeqs: TCheckBox;
    ckbSkipDbSyncError: TCheckBox;
    ckbUpdateFKFields: TCheckBox;
    cklbDbObjs: TCheckListBox;
    combDBUser: TComboBox;
    edtGenRowCount: TEdit;
    edtDBLinkInfo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MN_ModelTableInfo: TMenuItem;
    MN_DBTableInfo: TMenuItem;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    MN_CheckAll: TMenuItem;
    MN_CheckSelected: TMenuItem;
    MN_InverseSel: TMenuItem;
    N1: TMenuItem;
    MnShowPhyName: TMenuItem;
    Panel1: TPanel;
    LabelProg: TLabel;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    Panel2: TPanel;
    Splitter1: TSplitter;
    tpgAction: TPageControl;
    tbsResSQL: TTabSheet;
    memSQL: TMemo;
    tbsExecSQL: TTabSheet;
    memExecSQL: TMemo;
    tbsResError: TTabSheet;
    memError: TMemo;
    chkPause: TCheckBox;
    btnCancel: TButton;
    btnBuildSQL: TButton;
    btnExecSQL: TButton;
    btnResum: TButton;
    TimerInit: TTimer;
    OpenDialog1: TOpenDialog;
    PopupMenuSelDefDbType: TPopupMenu;
    MN_DefDbType_Standard: TMenuItem;
    MN_DefDbType_ORACLE: TMenuItem;
    MN_DefDbType_MYSQL: TMenuItem;
    MN_DefDbType_SQLSERVER: TMenuItem;
    OpenDialogDml: TOpenDialog;
    combModels: TComboBox;
    procedure btnListMenuClick(Sender: TObject);
    procedure cklbDbObjsDblClick(Sender: TObject);
    procedure cklbDbObjsResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure MN_ModelTableInfoClick(Sender: TObject);
    procedure MN_DBTableInfoClick(Sender: TObject);
    procedure TimerInitTimer(Sender: TObject);
    procedure btnDBLogonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MN_CheckAllClick(Sender: TObject);
    procedure MN_CheckSelectedClick(Sender: TObject);
    procedure MN_InverseSelClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure MnShowPhyNameClick(Sender: TObject);
    procedure btnBuildSQLClick(Sender: TObject);
    procedure btnExecSQLClick(Sender: TObject);
    procedure btnResumClick(Sender: TObject);
    procedure MN_DefDbType_StandardClick(Sender: TObject);
    procedure btnSelDbTypeClick(Sender: TObject);
    procedure combModelsChange(Sender: TObject);
    procedure combDBUserChange(Sender: TObject);
  private
    FShowPhyFieldName: boolean;
    FLinkDbNo: integer;
    FCtMetaDatabase: TCtMetaDatabase;
    FAborted: boolean;

    FCtDataModelList: TCtDataModelGraphList;
    FMetaObjList: TCtMetaObjectList;  
    FAllTbGraph: TCtDataModelGraph;
    FLastAutoSelDBUser: string;
              
    //不知为何，Memo内容较多时，再次显示窗体时会报错，只好先保存再恢复
    FSave_memSQL: string;
    FSave_memExecSQL: string;
    FSave_memError: string;

    FPreloadPKs: TJSONObject;   
    FPreloadFKs: TJSONObject;

    procedure SetCtDataModelList(const Value: TCtDataModelGraphList);
    procedure SetMetaObjList(const Value: TCtMetaObjectList);

  protected
    FDefaultDbType: string;

    function GenSQL: TStringList;

    procedure ExecCommands;

  public
    procedure RefreshDbInfo;
    procedure InitListObj;
    procedure InitTbList;

    property ShowPhyFieldName: boolean read FShowPhyFieldName write FShowPhyFieldName;
    property MetaObjList: TCtMetaObjectList read FMetaObjList write SetMetaObjList;
    property CtDataModelList: TCtDataModelGraphList
      read FCtDataModelList write SetCtDataModelList;
  end;

var
  frmCtGenData: TfrmCtGenData;

implementation

uses
  uFormCtDbLogon, WindowFuncs, dmlstrs;

{$R *.lfm}

procedure TfrmCtGenData.btnDBLogonClick(Sender: TObject);
var
  I: integer;
begin
  I := ExecCtDbLogon;
  if I >= 0 then
    FLinkDbNo := I;
  RefreshDbInfo;
end;

procedure TfrmCtGenData.FormCreate(Sender: TObject);

  procedure AddDbTypeMenu(db: string);
  var
    mn: TMenuItem;
  begin
    mn := TMenuItem.Create(Self);
    mn.Caption := db;
    mn.OnClick := MN_DefDbType_StandardClick;
    PopupMenuSelDefDbType.Items.Add(mn);
  end;

var
  I: integer;
begin            
  FPreloadPKs:= TJSONObject.create;
  FPreloadFKs:= TJSONObject.create;

  cklbDbObjs.MultiSelect := True;
  FLinkDbNO := -1;
  FShowPhyFieldName := True;
       

  FAllTbGraph:= TCtDataModelGraph.Create;
  FAllTbGraph.Name:='('+srdmlall+')';
  FAllTbGraph.Tables.AutoFree:=False;

  PopupMenuSelDefDbType.Items.Clear;
  for I := 0 to High(CtMetaDBRegs) do
    AddDbTypeMenu(CtMetaDBRegs[I].DbEngineType);
  AddDbTypeMenu('STANDARD');
  AddDbTypeMenu('EZDMLFILE');
  RefreshDbInfo;
end;

procedure TfrmCtGenData.FormDestroy(Sender: TObject);
begin              
  FPreloadPKs.Free;
  FPreloadFKs.Free;  
  FAllTbGraph.Free;
end;

procedure TfrmCtGenData.cklbDbObjsDblClick(Sender: TObject);
begin
  MN_DBTableInfoClick(nil);
end;

procedure TfrmCtGenData.cklbDbObjsResize(Sender: TObject);
begin
  btnListMenu.Left := cklbDbObjs.Width - 22 - btnListMenu.Width;
end;

procedure TfrmCtGenData.btnListMenuClick(Sender: TObject);
begin
  PopupMenu1.PopUp;
end;

procedure TfrmCtGenData.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  //不知为何，Memo内容较多时，再次显示窗体时会报错，只好先保存再恢复
  FSave_memSQL := memSQL.Lines.Text;  
  memSQL.Lines.Clear;

  FSave_memExecSQL := memExecSQL.Lines.Text; 
  memExecSQL.Lines.Clear;

  FSave_memError := memError.Lines.Text;  
  memError.Lines.Clear;
end;

procedure TfrmCtGenData.MN_ModelTableInfoClick(Sender: TObject);
var
  idx: Integer;
  tb: TCtMetaTable;
begin
  idx := cklbDbObjs.ItemIndex;
  if idx < 0 then
    Exit;
  tb := TCtMetaTable(cklbDbObjs.Items.Objects[idx]);   
  if not Assigned(Proc_ShowCtTableOfField) then
    raise Exception.Create('Proc_ShowCtTableOfField not assigned');
  Proc_ShowCtTableOfField(tb, nil, True, False, True);
end;

procedure TfrmCtGenData.MN_DBTableInfoClick(Sender: TObject);
var
  o: TCtMetaObject;
  I, po: Integer;
  S, db, obj: string;
begin
  I := cklbDbObjs.ItemIndex;
  if I<0 then
    Exit;

  if (FCtMetaDatabase = nil) or not FCtMetaDatabase.Connected then
    btnDBLogonClick(nil);
  if (FCtMetaDatabase = nil) or not FCtMetaDatabase.Connected then
    Exit;

  obj := cklbDbObjs.Items[I];
  db := combDBUser.Text;

  S := '';
  if db = '' then
  begin
    po := Pos('.', obj);
    if po > 0 then
    begin
      db := Copy(obj, 1, po - 1);
      obj := Copy(obj, po + 1, Length(obj));
    end;
  end;
  o := FCtMetaDatabase.GetObjInfos(db, obj, S);
  if o=nil then
    raise Exception.Create(srDmlSearchNotFound+' - '+obj);
  try
    if not Assigned(Proc_ShowCtTableOfField) then
      raise Exception.Create('Proc_ShowCtTableOfField not assigned');
    Proc_ShowCtTableOfField(TCtMetaTable(o), nil, True, False, True);
  finally
    o.Free;
  end;
end;

procedure TfrmCtGenData.MN_CheckAllClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := MN_CheckAll.Checked;
end;

procedure TfrmCtGenData.MN_CheckSelectedClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    if cklbDbObjs.Selected[I] then
      cklbDbObjs.Checked[I] := MN_CheckSelected.Checked;
end;


procedure TfrmCtGenData.MN_DefDbType_StandardClick(Sender: TObject);
var
  S: string;
begin
  S := TMenuItem(Sender).Caption;
  S := StringReplace(S, '&', '', [rfReplaceAll]);
  FLinkDbNo := -1;
  FDefaultDbType := S;
  RefreshDbInfo;
end;

procedure TfrmCtGenData.MN_InverseSelClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := not cklbDbObjs.Checked[I];
end;

procedure TfrmCtGenData.PopupMenu1Popup(Sender: TObject);
var
  I: integer;
begin
  I := cklbDbObjs.ItemIndex;
  if I > 0 then
    if cklbDbObjs.Selected[I] then
    begin
      MN_CheckSelected.Checked := cklbDbObjs.Checked[I];
      MN_CheckAll.Checked := cklbDbObjs.Checked[I];
      Exit;
    end;
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    if cklbDbObjs.Selected[I] then
    begin
      MN_CheckSelected.Checked := cklbDbObjs.Checked[I];
      MN_CheckAll.Checked := cklbDbObjs.Checked[I];
      Exit;
    end;
end;


procedure TfrmCtGenData.RefreshDbInfo;
var
  I: integer;
begin

  if FLastAutoSelDBUser = combDBUser.Text then
  begin
    combDBUser.Text := '';
    FLastAutoSelDBUser := '';
  end;

  if FLinkDbNo < 0 then
    FCtMetaDatabase := nil
  else
    FCtMetaDatabase := CtMetaDBRegs[FLinkDbNo].DbImpl;
  if not Assigned(FCtMetaDatabase) or not FCtMetaDatabase.Connected then
  begin
    combDBUser.Items.Clear;
    combDBUser.Enabled := False;
    combDBUser.ParentColor := True;
    if FDefaultDbType = '' then
      edtDBLinkInfo.Text := ''
    else
      edtDBLinkInfo.Text := '[' + FDefaultDbType + ']';
  end
  else
  begin
    edtDBLinkInfo.Text := FCtMetaDatabase.Database;
    Self.Refresh;
    combDBUser.Items.Text := FCtMetaDatabase.GetDbUsers;
    combDBUser.Enabled := True;
    combDBUser.Color := clWindow;
    FDefaultDbType := '';
    edtDBLinkInfo.Text := '[' + FCtMetaDatabase.EngineType + ']' +
      FCtMetaDatabase.Database;
  end;
  if Assigned(FCtMetaDatabase) and (combDBUser.Text = '') then
  begin
    for I := 0 to combDBUser.Items.Count - 1 do
      if UpperCase(combDBUser.Items[I]) = UpperCase(FCtMetaDatabase.User) then
      begin
        combDBUser.ItemIndex := I;
        FLastAutoSelDBUser := combDBUser.Text;
        Break;
      end;
  end;

  ckbSkipDbSyncError.Visible := Assigned(FCtMetaDatabase);
  if Assigned(FCtMetaDatabase) and (FCtMetaDatabase.EngineType = 'ORACLE') then
    ckbProcOracleSeqs.Visible := True
  else if FDefaultDbType = 'ORACLE' then
    ckbProcOracleSeqs.Visible := True
  else
    ckbProcOracleSeqs.Visible := False;
end;

procedure TfrmCtGenData.SetCtDataModelList(const Value: TCtDataModelGraphList);
begin
  FCtDataModelList := Value;
  if FCtDataModelList <> nil then
    FMetaObjList := FCtDataModelList.CurDataModel.Tables;
end;

procedure TfrmCtGenData.SetMetaObjList(const Value: TCtMetaObjectList);
begin
  FMetaObjList := Value;
  if FMetaObjList <> nil then
    FCtDataModelList := nil;
end;


procedure TfrmCtGenData.TimerInitTimer(Sender: TObject);
var
  I: integer;
begin
  TimerInit.Enabled := False;
  if not Assigned(FCtMetaDatabase) then
  begin
    I := GetLastCtDbConn(True);
    if I >= 0 then
    begin
      FLinkDbNo := I;
      RefreshDbInfo;
    end
    else
    begin
      //if CanAutoShowLogin then
      btnDBLogonClick(nil);
    end;
  end;
end;

procedure TfrmCtGenData.FormShow(Sender: TObject);
begin
  btnResum.Left := btnCancel.Left - btnResum.Width - 10;
  btnExecSQL.Left := btnResum.Left - btnExecSQL.Width - 10;
  btnBuildSQL.Left := btnExecSQL.Left - btnBuildSQL.Width - 10;
  ProgressBar1.Width := btnBuildSQL.Left - ProgressBar1.Left - 10;

  chkPause.Left := Panel2.Width - chkPause.Width - 8;

  ProgressBar1.Position := 0;
  InitListObj;

  memSQL.Lines.Text:=FSave_memSQL ;
  memExecSQL.Lines.Text:=FSave_memExecSQL ;
  memError.Lines.Text:=FSave_memError ;

  MnShowPhyName.Checked := FShowPhyFieldName;
  if (FCtMetaDatabase = nil) and (FDefaultDbType = '') then
    TimerInit.Enabled := True;

end;

procedure TfrmCtGenData.btnCancelClick(Sender: TObject);
begin
  if btnCancel.Caption = srCapCancel then
  begin
    if MessageBox(Handle, PChar(srConfirmAbort),
      PChar(Application.Title), MB_YESNO or MB_ICONQUESTION) = idYes then
      FAborted := True;
  end
  else
    Close;
end;

procedure TfrmCtGenData.InitListObj;   
  procedure CheckAddTbs(tbs: TCtMetaTableList);
  var
    I: Integer;
  begin
    for I:=0 to tbs.Count - 1 do
    begin
      if FAllTbGraph.Tables.ItemByName(tbs[I].Name) = nil then
        FAllTbGraph.Tables.Add(tbs[I]);
    end;
  end;
var
  i: integer;
  S: string;
begin
  combModels.Tag := 0;
  combModels.Items.Clear; 
  FAllTbGraph.Tables.Clear;
  if Assigned(FCtDataModelList) then
  begin
    for i := 0 to FCtDataModelList.Count - 1 do
    begin
      S := FCtDataModelList[I].Name;
      if FCtDataModelList[I].Caption <> '' then
        S := S + '(' + FCtDataModelList[I].Caption + ')';
      combModels.Items.AddObject(S, FCtDataModelList[I]);
      CheckAddTbs(FCtDataModelList[I].Tables);
    end;         
    combModels.Items.AddObject(FAllTbGraph.Name, FAllTbGraph);
    combModels.Enabled := True;
    combModels.ItemIndex := FCtDataModelList.IndexOf(FCtDataModelList.CurDataModel);
    combModels.Tag := 1;
  end
  else
    combModels.Enabled := False;

  InitTbList;
end;

procedure TfrmCtGenData.InitTbList;
var
  i: integer;
  S: string;
begin
  cklbDbObjs.Clear;
  for i := 0 to MetaObjList.Count - 1 do
    if MetaObjList[i] is TCtMetaTable then
      if TCtMetaTable(MetaObjList[i]).GenDatabase then
        if MetaObjList[i].DataLevel <> ctdlDeleted then
        begin
          if not TCtMetaTable(MetaObjList[i]).IsTable then
            Continue;
          if ShowPhyFieldName then
            S := TCtMetaTable(MetaObjList[i]).Name
          else
            S := TCtMetaTable(MetaObjList[i]).DisplayText;
          cklbDbObjs.Items.AddObject(S, TObject((MetaObjList[i])));
        end;

  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := True;
  MN_CheckAll.Checked := True;
end;


procedure TfrmCtGenData.MnShowPhyNameClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
  FShowPhyFieldName := (Sender as TMenuItem).Checked;
  InitListObj;
end;

function TfrmCtGenData.GenSQL: TStringList;           
  function ImportObjFromDB(db, obj: string): TCtMetaTable;
  var
    O: TCtMetaObject;
  begin
    o:=FCtMetaDatabase.GetObjInfos(db, obj, '');
    if o is TCtMetaTable then
      Result := TCtMetaTable(o)
    else
      Result := nil;
  end;
      
  procedure AddErr(msg: string);
  begin
    memError.Lines.Add(msg);
  end;

  function CompareTbSkDesc(tb, dbtb: TCtMetaTable): Boolean;
  var
    I: Integer;
    fd, dbFd: TCtMetaField;
  begin
    Result := False;
    for I:=0 to tb.MetaFields.Count - 1 do
    begin
      fd := tb.MetaFields[I];
      if not fd.IsPhysicalField then
        Continue;
      dbfd := dbtb.MetaFields.FieldByName(fd.Name);
      if dbfd=nil then
      begin
        AddErr('DB field not exists: ' + tb.RealTableName+'.'+ fd.Name);
        Exit;
      end;
      if fd.DataType in [cfdtInteger, cfdtBool, cfdtEnum] then
        if dbfd.DataType in [cfdtInteger, cfdtBool, cfdtEnum] then
          Continue;
      if fd.GetLogicDataTypeName <> dbfd.GetLogicDataTypeName then
      begin
        AddErr('Field type not match: ' + tb.RealTableName+'.'+fd.Name);
        AddErr('DML: ' + fd.GetLogicDataTypeName);
        AddErr('DB:  ' + dbfd.GetLogicDataTypeName);
        Exit;
      end;
    end; 
    Result := True;
  end;
       
  function GetQuotName(AName: string): string;
  var
    dbType: String;
  begin                     
    if Assigned(FCtMetaDatabase) and (FDefaultDbType = '') then
      dbType := FCtMetaDatabase.EngineType
    else
      dbType := FDefaultDbType;
    Result := GetDbQuotName(AName, dbType);
  end;

var
  I, J, idx, A, C, TbC, rowI, rowC: integer;
  MetaObjListDB: TCtMetaTableList; //从数据库中导出数据生成的临时列表
  tb, dmlobjtmp: TCtMetaTable; //生成的临时对象
  ResTbSQL: TStringList; //生成表的sql语句
  ResFKSQL: TStringList; //创建外键的SQL         
  resSS: TStringList; //创建外键的SQL
  dmlLsTbObj: TCtMetaTable;
  fd: TCtMetaField;
  strtmp, dbu, S, opt: string;
  bConnDB, bRecheck, bPkBySeq: Boolean;
  dbos: TStringList;
begin
  Result := nil;
  resSS := TStringList.Create;
  ResTbSQL := TStringList.Create;
  ResFKSQL := TStringList.Create;

  btnDBLogon.Enabled := False;
  combDBUser.Enabled := False;

  btnBuildSQL.Enabled := False;
  btnExecSQL.Enabled := False;

  cklbDbObjs.Enabled := False;

  //btnOk.Enabled := False;
  btnCancel.Caption := srCapCancel;
  FAborted := False;    
  MetaObjListDB := TCtMetaTableList.Create(); 
  dbos:= TStringList.Create;
  try
    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('FORM_GEN_TESTDATA', 'GEN_TESTDATA_SQL', 'BEGIN', cklbDbObjs, resSS);
    end;
              
    bConnDB := Assigned(FCtMetaDatabase) and FCtMetaDatabase.Connected;

    rowC := StrToIntDef(edtGenRowCount.Text, 0);
    if rowC <= 0 then
      rowC := 20;

    C := 0;
    for I := 0 to cklbDbObjs.Items.Count - 1 do
      if cklbDbObjs.Checked[I] then
        Inc(C);
    if C = 0 then
      for I := 0 to cklbDbObjs.Items.Count - 1 do
        if cklbDbObjs.Selected[I] then
        begin
          cklbDbObjs.Checked[I] := True;
          Inc(C);
        end;
    if C = 0 then
      Exit;

    A := 0;
    try

      TbC := 0;
      if bConnDB then //如果连接了数据库，要求模型已同步到数据库
      begin
        TbC := C;
        dbu := combDBUser.Text;
        if dbu <> '' then
          FCtMetaDatabase.DbSchema := GetDbQuotName(dbu, FCtMetaDatabase.EngineType);
                     
        bPkBySeq := ckbProcOracleSeqs.Visible and ckbProcOracleSeqs.Checked;
        //获取数据库现有对象信息
        for I := 0 to cklbDbObjs.Items.Count - 1 do
          if cklbDbObjs.Checked[I] then
          begin
            Inc(A);
            ProgressBar1.Position := A * 100 div (C * rowC + TbC);
            LabelProg.Caption := Format(srCheckingDataFmt, [A, C * rowC + TbC, cklbDbObjs.Items[I]]);
            Application.ProcessMessages;
            if FAborted then
              Abort;
            CheckAbort(' ');
            if not TCtMetaTable(cklbDbObjs.Items.Objects[I]).IsTable then
              Continue;
            S := TCtMetaTable(cklbDbObjs.Items.Objects[I]).RealTableName;
            dmlobjtmp := ImportObjFromDB(dbu, S);
            if (dmlobjtmp = nil) then
            begin                  
              AddErr(Format(srDBObjectNotExists,[S]));
              if not ckbSkipDbSyncError.Checked then
                raise Exception.Create(Format(srDBObjectNotExists,[S]));
            end;
            if not CompareTbSkDesc(TCtMetaTable(cklbDbObjs.Items.Objects[I]), dmlobjtmp) then
            begin
              AddErr(Format(srDBObjectNotSynced,[S]));
              AddErr('DML object:');
              AddErr(TCtMetaTable(cklbDbObjs.Items.Objects[I]).SketchyDescribe);    
              AddErr('DB object:');
              AddErr(dmlobjtmp.SketchyDescribe);  
              if not ckbSkipDbSyncError.Checked then
                raise Exception.Create(Format(srDBObjectNotSynced,[S]));
            end;
            if bPkBySeq then
              if FCtMetaDatabase.ObjectExists(dbu, 'SEQ_'+UpperCase(S)) then
                dbos.Add('SEQ_'+UpperCase(S));
            FreeAndNil(dmlobjtmp);
          end;
      end;

      //创建临时列表
      for I := 0 to cklbDbObjs.Items.Count - 1 do
        if cklbDbObjs.Checked[I] then      
        begin
          dmlLsTbObj := TCtMetaTable(cklbDbObjs.Items.Objects[I]);
          if dmlLsTbObj.IsTable then
          begin
            dmlobjtmp := TCtMetaTable.Create;
            dmlobjtmp.AssignFrom(dmlLsTbObj);
            MetaObjListDB.Add(dmlobjtmp);
          end;
        end;

      //按引用关系进行排序（被非空外键引用的表要先生成数据）
      I:=0;
      while I < MetaObjListDB.Count do
      begin
        dmlLsTbObj := MetaObjListDB.Items[I];
        bRecheck := False;
        for J:=0 to dmlLsTbObj.MetaFields.Count - 1 do
        begin
          fd:=dmlLsTbObj.MetaFields[J];
          if not fd.IsFK then
          begin
            Continue;
          end;
          tb := MetaObjListDB.TableByName(Trim(fd.RelateTable));     
          if tb = nil then
          begin
            Continue;
          end;
          if LowerCase(tb.RealTableName)=LowerCase(dmlLsTbObj.RealTableName) then
            Continue;
          idx := MetaObjListDB.IndexOf(tb);
          if idx > I then
          begin
            MetaObjListDB.Move(idx, I);
            AddErr('Table '+tb.NameCaption+' to index '+ IntToStr(I)+' as referenced by '+dmlLsTbObj.NameCaption+'.'+fd.NameCaption);
            bRecheck := True;
            Break;
          end;
        end;
        if not bRecheck then
          Inc(I);
      end;

      opt := '';
      if ckbUpdateFKFields.Checked then
        opt := opt + '[REF_FK_VALUES]';

      for I := 0 to MetaObjListDB.Count - 1 do
      begin
        dmlLsTbObj := MetaObjListDB.Items[I];

        strtmp := dmlLsTbObj.RealTableName;
        ResTBSQL.Add('-- ' + strtmp);

        bPkBySeq := ckbProcOracleSeqs.Visible and ckbProcOracleSeqs.Checked;
        if FCtMetaDatabase <> nil then
          if bPkBySeq and FCtMetaDatabase.Connected then
            if dbos.IndexOf('SEQ_'+UpperCase(strtmp)) < 0 then
              bPkBySeq := False;
        if bPkBySeq then
          opt := opt + '[GEN_PK_BY_SEQ]';
                      
        if not bPkBySeq then
          for J:=0 to dmlLsTbObj.MetaFields.Count - 1 do
          begin
            fd:=dmlLsTbObj.MetaFields[J];
            if not fd.IsPhysicalField then
              Continue;
            if fd.KeyFieldType <> cfktId then
              Continue;
            if fd.DataType <> cfdtInteger then
              Continue;
            if Trim(fd.DefaultValue) = DEF_VAL_auto_increment then
              Continue;
            S := 'select max('+GetQuotName(fd.Name)+') as maxval from '+GetQuotName(dmlLsTbObj.RealTableName)+' where '+GetQuotName(fd.Name)+' is not null;';
            S := '/*PRE_LOAD_PK:'+dmlLsTbObj.RealTableName+'.'+fd.Name+'*/ '+ S;    
            ResTbSQL.Add(S);
          end;
                                
        if ckbUpdateFKFields.Checked then
          for J:=0 to dmlLsTbObj.MetaFields.Count - 1 do
          begin
            fd:=dmlLsTbObj.MetaFields[J];
            if not fd.IsFK then
              Continue;
            if Trim(fd.RelateTable) = '' then
              Continue;
            if Trim(fd.RelateField) = '' then
              Continue;
            if Assigned(FCtMetaDatabase) and (FDefaultDbType = '') then
              S := dmlLsTbObj.GenSelectRandRelateKeySql(fd, rowC div 3, FCtMetaDatabase.EngineType, '', FCtMetaDatabase)
            else
              S := dmlLsTbObj.GenSelectRandRelateKeySql(fd, rowC div 3, FDefaultDbType,'', nil);
            S := '/*PRE_LOAD_FK:'+dmlLsTbObj.RealTableName+'.'+fd.Name+'*/ '+ S +';';
            ResTbSQL.Add(S);
          end;

        for rowI:=0 to rowC-1 do
        begin
          Inc(A);
          ProgressBar1.Position := A * 100 div (C * rowC+ TbC);
          LabelProg.Caption := Format(srGeneratingSqlFmt, [A, (C * rowC + TbC), cklbDbObjs.Items[I]]);
          Application.ProcessMessages;
          if FAborted then
            Abort;
          CheckAbort(' ');
          if Assigned(FCtMetaDatabase) and (FDefaultDbType = '') then
            S := dmlLsTbObj.GenTestDataInsertSql(rowI, FCtMetaDatabase.EngineType, opt, FCtMetaDatabase)
          else
            S := dmlLsTbObj.GenTestDataInsertSql(rowI, FDefaultDbType,opt, nil);
          ResTbSQL.Add(S);
        end;         
        ResTBSQL.Add('commit;');
        ResTBSQL.Add('');
        //resFKSQL.Add(dmlLsTbObj.GenSqlEx(False, True, FDefaultDbType));

      end;

    except
      on E:EAbort do
      ;
    else
      raise;
    end;
         
    resSS.AddStrings(resTBSQL);
    resSS.AddStrings(resFKSQL);

    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('FORM_GEN_TESTDATA', 'GEN_TESTDATA_SQL', 'END', cklbDbObjs, resSS);
    end;

    Result := resSS;
    resSS := nil;

  finally
    dbos.Free;
    btnDBLogon.Enabled := True;
    combDBUser.Enabled := True;
    cklbDbObjs.Enabled := True;
    //btnOk.Enabled := True;      
    btnBuildSQL.Enabled := True;
    btnExecSQL.Enabled := True;

    btnCancel.Caption := srCapClose;
    MetaObjListDB.Free;       
    resTBSQL.Free;
    resFKSQL.Free;
    if resSS <> nil then
    begin
      resSS.Free;
      tpgAction.ActivePage := tbsResError;
    end;
  end;

end;

procedure TfrmCtGenData.btnBuildSQLClick(Sender: TObject);
var
  sqlst: TStringList;
  bFinish: boolean;
begin
  tpgAction.TabIndex := 0;
  bFinish := False;
  sqlst := nil;
  try
    memSQL.Lines.Clear;
    Self.Refresh;

    sqlst := GenSQL;
    if sqlst = nil then
      Exit;
    memSQL.Text := sqlst.Text;

    while Pos(#13#10#13#10#13#10, memSQL.Text) > 0 do
      memSQL.Text := StringReplace(memSQL.Text, #13#10#13#10#13#10,
        #13#10#13#10, [rfReplaceAll]);
    if not FAborted then
      bFinish := True;
  finally
    if bFinish then
      LabelProg.Caption := LabelProg.Caption + ' ' + srStrFinished
    else
      LabelProg.Caption := LabelProg.Caption + ' ' + srStrAborted;
    if sqlst <> nil then
      sqlst.Free;
  end;
end;

procedure TfrmCtGenData.btnExecSQLClick(Sender: TObject);
var
  bFinish: boolean;
  S: string;
begin
  S := srModifyDatabaseWarning ;
  if MessageBox(Handle, PChar(S),
    PChar(Application.Title), MB_YESNO or MB_ICONWARNING) <> idYes then
    Exit;

  tpgAction.TabIndex := 1;
  bFinish := False;

  try
    FAborted := False;
    if (FCtMetaDatabase = nil) or (not FCtMetaDatabase.Connected) then
      exit;
    FCtMetaDatabase.DbSchema := GetDbQuotName(combDBUser.Text, FCtMetaDatabase.EngineType);
                    
    FPreloadPKs.clean;
    FPreloadFKs.clean;

    btnExecSQL.Enabled := False;
    btnBuildSQL.Enabled := False;
    btnCancel.Caption := srCapCancel;
    try
      if Pos(';', memSQL.Text) > 0 then
        ExecCommands;
      if not FAborted then
      begin
        ProgressBar1.Position := 100;
        memExecSQL.Lines.Add(srStrFinished);
      end;
    finally
      btnExecSQL.Enabled := True;
      btnBuildSQL.Enabled := True;
      btnCancel.Caption := srCapClose;
    end;
    if not FAborted then
      bFinish := True;
  finally
    if bFinish then
      LabelProg.Caption := LabelProg.Caption + ' ' + srStrFinished
    else
      LabelProg.Caption := LabelProg.Caption + ' ' + srStrAborted;
  end;
end;

// Remove SQL Comment from a string
function RemoveSQLComment(const ASQL: WideString; KeepHints: boolean): WideString;
var
  i, l, rl: integer;
  c1, c2, c3, Mode: widechar;
begin
  SetLength(Result, Length(ASQL));
  rl := 0;
  l := Length(ASQL);
  i := 1;
  Mode := 'N';
  while i <= l do
  begin
    c1 := ASQL[i];
    if c1 = '''' then
    begin
      if Mode = 'Q' then
        Mode := 'N'
      else if Mode = 'N' then
        Mode := 'Q';
    end;
    if Mode = 'Q' then
    begin
      Inc(rl);
      Result[rl] := c1;
    end;
    if i < l then
      c2 := ASQL[i + 1]
    else
      c2 := #0;
    if i + 1 < l then
      c3 := ASQL[i + 2]
    else
      c3 := #0;
    if Mode = 'N' then
    begin
      if (c1 = '/') and (c2 = '*') then
        Mode := '*';
      if (c1 = '-') and (c2 = '-') then
        Mode := '-';
      if KeepHints and (Mode <> 'N') and (c3 = '+') then
        Mode := 'N';
      if Mode = 'N' then
      begin
        Inc(rl);
        Result[rl] := c1;
      end;
    end;
    if ((Mode = '*') and (c1 = '*') and (c2 = '/')) or
      ((Mode = '-') and (c1 = #13) and (c2 = #10)) then
    begin
      Mode := 'N';
      Inc(i);
    end;
    Inc(i);
  end;
  SetLength(Result, rl);
  Result := Trim(Result);
end;

type
  TCommandType = (ctSQL, ctPLSQL, ctNonSQL);

procedure TfrmCtGenData.ExecCommands;   
  function CheckReplaceKeysEx(var ASql: string; kw: string): boolean;
  var
    S, K,V, s1, s2: String;
    ls:TJSONArray;
    IV: Integer;
  begin
    Result := False;
    S:=ASql;
    s1 := '/*'+kw+':';
    s2 := '*/';
    if Pos(s1, S)=0 then
      Exit;
    K:=ExtractCompStr(S,s1,s2);
    V := '';
    if kw='_PK' then
    begin
      V:='+'+IntToStr(FPreloadPKs.optInt(K));
    end
    else if kw='_FK' then
    begin
      if FPreloadFKs.has(K) then
      begin        
        ls := FPreloadFKs.getList(K);
        if (ls<>nil) and (ls.Count>0) then
        begin
          IV:=Random(ls.Count);
          V:=ls.getString(IV);
          if not TryStrToInt(V, IV) then
            V := '''' + V + '''';
        end;
      end;
    end;
    S:=ModifyCompStr(S, 'XXX', S1, S2);
    if (kw='_FK') and (V<>'') then      
      S:=StringReplace(S,S1+'XXX'+S2+'null',V,[])
    else
      S:=StringReplace(S,S1+'XXX'+S2,V,[]);
    ASql := S;
    Result := True;
  end;

  function CheckReplaceKeys(ASql: string): string;
  var
    I: Integer;
  begin
    Result:=ASql;
    I:=0;
    while CheckReplaceKeysEx(Result,'_PK') do
    begin
      Inc(I);
      if I>256 then
        raise Exception.Create('CheckReplaceKeys _PK dead loop - '+ASql);
    end;       
    I:=0;
    while CheckReplaceKeysEx(Result,'_FK') do
    begin
      Inc(I);
      if I>256 then
        raise Exception.Create('CheckReplaceKeys _FK dead loop - '+ASql);
    end;
  end;
  procedure ReadPreloadData(ASql: string);
  var
    DS: TDataSet;
    tp: Integer;
    S,V: string;
    ls: TJSONArray;
  begin
    DS := FCtMetaDatabase.OpenTable(ASql,'');
    if DS=nil then
      Exit;
    try
      if DS.eof then
        Exit;
      tp := 0;
      if (Pos('/*PRE_LOAD_PK:', ASql)>0) then
      begin
        S := Trim(ExtractCompStr(ASql,'/*PRE_LOAD_PK:','*/'));
        tp := 1;
      end
      else if(Pos('/*PRE_LOAD_FK:', ASql)>0) then
      begin
        S := Trim(ExtractCompStr(ASql,'/*PRE_LOAD_FK:','*/'));
        tp := 2;
      end
      else
        S := '';

      if S='' then
        Exit;
      if tp=1 then
      begin
        V:=Ds.fields[0].AsString;
        FPreloadPKs.put(S,V);  
        memExecSQL.Lines.Add(S+' result: '+ V);
      end
      else if tp=2 then
      begin
        if FPreloadFKs.has(S) then
          FPreloadFKs.remove(S);
        ls:= TJSONArray.create;
        FPreloadFKs.put(S, ls);
        while not DS.EOF do
        begin
          V:=Ds.fields[0].AsString;
          ls.put(V);
          DS.Next;
        end;    
        memExecSQL.Lines.Add(S+' result: '+ ls.toString);
      end;
    finally
      DS.Free;
    end;
  end;
var
  i: integer;
  EndChar: char;
  S, Command, XCommand: string;
  ValidSQL: boolean;
  WordList: TStringList;
  FLines: TStrings;
  AAA, CCC: integer;

  procedure execSql(ASql: string);
  begin
    try

      ProgressBar1.Position := (AAA + 1) * 100 div (CCC + 1);
      LabelProg.Caption := Format(srExecutingSqlFmt, [AAA, CCC, '']);
      Application.ProcessMessages;
      if FAborted then
        Exit;
      CheckAbort(' ');
                          
      if (Pos('/*_PK:', ASql)>0) or (Pos('/*_FK:', ASql)>0) then
        ASql := CheckReplaceKeys(ASql);
      memExecSQL.Lines.Add(ASql);
      if Trim(RemoveCtSQLComment(ASql)) <> '' then
      begin
        if (Pos('/*PRE_LOAD_PK:', ASql)>0) or (Pos('/*PRE_LOAD_FK:', ASql)>0) then
        begin
          ReadPreloadData(ASql);
        end
        else
          FCtMetaDatabase.ExecSql(ASql);
      end;
      memExecSQL.Lines.Add('');
    except
      on E: Exception do
      begin
        memError.Lines.Add(ASql);
        memError.Lines.Add('');
        memError.Lines.Add(E.Message);
        memExecSQL.Lines.Add(E.Message);
        memError.Lines.Add('-----------------------------------------');
        memError.Lines.Add('');
        if chkPause.Checked then
        begin
          if Application.MessageBox(PChar(Format(srConfirmSkipErrorFmt, [E.Message])),
            PChar(Application.Title), MB_OKCANCEL or MB_ICONERROR) <> idOk then
          begin
            memExecSQL.Lines.Add(srStrAborted);
            LabelProg.Caption := LabelProg.Caption + '.' + srStrAborted;
            Abort;
          end;
        end;
      end;
    end;
  end;

  // Return the first word of the command
  function FirstWord: string;
  begin
    Result := '';
    if (WordList <> nil) and (WordList.Count > 0) then
      Result := WordList[0];
  end;
  // Return the second word of the command

  function SecondWord: string;
  begin
    Result := '';
    if (WordList <> nil) and (WordList.Count > 1) then
      Result := WordList[1];
  end;

  function NotInString(S: string): boolean;
  var
    i: integer;
  begin
    Result := True;
    S := RemoveSQLComment(S, False);
    for i := 1 to Length(S) do
      if S[i] = '''' then
        Result := not Result;
  end;

  function CommandEnd(S, Line: string; C: char): boolean;
  begin
    Result := (Trim(Line) = '/') and NotInString(S);
    if (not Result) and (C = ';') then
      Result := (S[Length(S)] = ';');
  end;
  // Add a command to the collection

  procedure AddCommand;
  var
    CType: TCommandType;
  begin
    // Determine Command Type (SQL, PL/SQL or ...)
    if not ValidSQL then
      CType := ctNonSQL
    else
    if EndChar = '/' then
      CType := ctPLSQL
    else
      CType := ctSQL;
    // Strip terminating character
    if ValidSQL and (Length(Command) > 1) and
      (Command[Length(Command) - 1] = #10) and
      (Command[Length(Command)] = '/') then
    begin
      SetLength(Command, Length(Command) - 1);
      Command := TrimRight(Command);
    end
    else
    begin
      if (CType = ctSQL) and (Command <> '') and (Command[Length(Command)] = ';') then
      begin
        SetLength(Command, Length(Command) - 1);
        Command := TrimRight(Command);
      end;
    end;
    // If there is a command, add it to the list
    if Command = '' then
      Exit;
    execSql(Command);
  end;

  function GetWords(S: string): TStringList;
  var
    i: integer;
    W: string;
  const
    Identifiers = ['a'..'z', 'A'..'Z', '0'..'9', '_', '#', '$', '.',
      '"', '@', #128..#255];
  begin
    Result := TStringList.Create;
    W := '';
    S := UpperCase(Trim(S)) + ' ';
    for i := 1 to Length(S) do
    begin
      if S[i] in Identifiers then
      begin
        W := W + UpperCase(S[i]);
      end
      else
      begin
        if W <> '' then
        begin
          Result.Add(W);
          W := '';
        end;
      end;
    end;
  end;

  function SQLCommand(const S1, S2: string): boolean;
  begin
    Result := (S1 = 'ALTER') or (S1 = 'ANALYZE') or (S1 = 'AUDIT') or
      (S1 = 'COMMIT') or (S1 = 'COMMENT') or (S1 = 'CREATE') or
      (S1 = 'DELETE') or (S1 = 'DROP') or (S1 = 'GRANT') or
      (S1 = 'INSERT') or (S1 = 'LOCK') or (S1 = 'RENAME') or
      (S1 = 'SAVEPOINT') or (S1 = 'SELECT') or (S1 = 'ROLLBACK') or
      (S1 = 'TRUNCATE') or (S1 = 'NOAUDIT') or (S1 = 'REVOKE') or
      (S1 = 'UPDATE') or (S1 = 'BEGIN') or (S1 = 'DECLARE') or
      (S1 = 'EXPLAIN') or (S1 = 'ASSOCIATE') or (S1 = 'DISASSOCIATE') or
      (S1 = 'CALL') or (S1 = 'EXEC') or (S1 = 'EXECUTE');
    if (not Result) and (S1 = 'SET') then
    begin
      Result :=
        (S2 = 'ROLE') or
        (S2 = 'TRANSACTION') or
        (S2 = 'CONSTRAINT') or
        (S2 = 'CONSTRAINTS');
    end;
  end;

  function PLSQLBlock(const FirstWord, S: string): boolean;
  var
    L: TStringList;
    ObjectIndex, BodyIndex: integer;

    function word(Index: integer): string;
    begin
      Result := '';
      if Index < L.Count then
        Result := L[Index];
    end;

  begin
    Result := (FirstWord = 'BEGIN') or (FirstWord = 'DECLARE');
    if (not Result) and (FirstWord = 'CREATE') then
    begin
      L := GetWords(S);
      ObjectIndex := 1;
      BodyIndex := 2;
      if (word(1) = 'OR') and (word(2) = 'REPLACE') then
      begin
        Inc(ObjectIndex, 2);
        Inc(BodyIndex, 2);
      end;
      Result := word(ObjectIndex) = 'FUNCTION';
      if (not Result) then
        Result := word(ObjectIndex) = 'PROCEDURE';
      if (not Result) then
        Result := word(ObjectIndex) = 'PACKAGE';
      if (not Result) then
        Result := word(ObjectIndex) = 'TRIGGER';

      if (not Result) and (word(ObjectIndex) = 'TYPE') then
        Result := word(BodyIndex) = 'BODY';
      L.Free;
    end;
  end;

begin
  EndChar := ';';
  WordList := nil;
  Command := '';
  // Make sure Lines.Count is correct (add or append can cause problems)
  FLines := memSQL.Lines;
  AAA := 0;
  CCC := FLines.Count;
  try
    for i := 0 to FLines.Count - 1 do
    begin
      if FAborted then
        Break;
      AAA := i + 1;
      S := TrimRight(FLines[i]);
      // Remove Comment after /
      if (S <> '') and (S[1] = '/') and (RemoveSQLComment(S, False) = '/') then
        S := '/';
      // Add a line to the 'command'
      if Command = '' then
      begin
        Command := S;
      end
      else
      begin
        s := #13#10 + s;
        Command := Command + s;
      end;
      // Separate the first couple of words of the command
      if (WordList = nil) or (WordList.Count < 4) then
      begin
        if WordList <> nil then
          WordList.Free;
        // XCommand will contain the command without comment
        XCommand := RemoveSQLComment(Command, False);
        WordList := GetWords(XCommand);
        ValidSQL := SQLCommand(FirstWord, SecondWord);
      end;
      // Is it a valid SQL command or PL/SQL Block?
      if ValidSQL and (EndChar <> '/') and PLSQLBlock(FirstWord, XCommand) then
        EndChar := '/';
      if (Trim(XCommand) <> '') and (CommandEnd(Command, S, EndChar) or
        (not ValidSQL)) then
      begin
        // Found a complete command, add it to the list
        Command := Trim(Command);
        AddCommand;
        EndChar := ';';
        Command := '';
        WordList.Clear;
      end;
    end;
    Command := Trim(Command);
    if Command <> '' then
      AddCommand;
    LabelProg.Caption := Format(srExecutingSqlFmt, [CCC, CCC, '']);
  finally
    if WordList <> nil then
      WordList.Free;
  end;

end;


procedure TfrmCtGenData.btnResumClick(Sender: TObject);
begin
  btnResum.Enabled := False;
end;

procedure TfrmCtGenData.btnSelDbTypeClick(Sender: TObject);
var
  p: TPoint;
begin
  p.X := 0;
  p.Y := btnSelDbType.Height;
  p := btnSelDbType.ClientToScreen(p);
  PopupMenuSelDefDbType.Popup(p.X, p.Y);
end;

procedure TfrmCtGenData.combDBUserChange(Sender: TObject);
begin
  FLastAutoSelDBUser := '';
end;

procedure TfrmCtGenData.combModelsChange(Sender: TObject);
var
  idx: integer;
  obj: TObject;
begin
  if combModels.Tag <> 1 then
    Exit;
  idx := combModels.ItemIndex;
  if idx < 0 then
    Exit;
  obj := combModels.Items.Objects[idx];
  if obj = nil then
    Exit;
  if not (obj is TCtDataModelGraph) then
    Exit;

  FMetaObjList := TCtDataModelGraph(obj).Tables;
  InitTbList;
end;

end.
