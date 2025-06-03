unit uFormGenSql;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, CheckLst, Menus, StrUtils,
  ExtCtrls, ActnList, StdActns, Buttons,
  CtMetaTable, CTMetaData, CtMetaEzdmlFakeDb;

type

  { TfrmCtGenSQL }

  TfrmCtGenSQL = class(TForm)
    Bevel1: TBevel;
    btnDBLogon: TButton;
    btnListMenu: TBitBtn;
    ckbCreateForeignkeys: TCheckBox;
    ckbGenDBComments: TCheckBox;
    ckbProcOracleSeqs: TCheckBox;
    ckbSketchMode: TCheckBox;
    cklbDbObjs: TCheckListBox;
    combDBUser: TComboBox;
    edtDBLinkInfo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    MN_DefDbType_Standard: TMenuItem;
    MenuItem_VirtualDbs: TMenuItem;
    MenuItemDbConn: TMenuItem;
    MenuItemDedicatedConn: TMenuItem;
    MN_ModelTableInfo: TMenuItem;
    MN_DBTableInfo: TMenuItem;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    MN_CheckAll: TMenuItem;
    MN_CheckSelected: TMenuItem;
    MN_InverseSel: TMenuItem;
    N1: TMenuItem;
    Panel1: TPanel;
    LabelProg: TLabel;
    PopupMenuDbConn: TPopupMenu;
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
    ckbRecreateTable: TCheckBox;
    OpenDialogDml: TOpenDialog;
    combModels: TComboBox;
    procedure btnListMenuClick(Sender: TObject);
    procedure ckbCreateForeignkeysChange(Sender: TObject);
    procedure ckbGenDBCommentsChange(Sender: TObject);
    procedure cklbDbObjsDblClick(Sender: TObject);
    procedure cklbDbObjsResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItemDbConnClick(Sender: TObject);
    procedure MenuItemDedicatedConnClick(Sender: TObject);
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
    procedure btnBuildSQLClick(Sender: TObject);
    procedure btnExecSQLClick(Sender: TObject);
    procedure btnResumClick(Sender: TObject);
    procedure MN_DefDbType_StandardClick(Sender: TObject);
    procedure combModelsChange(Sender: TObject);
    procedure combDBUserChange(Sender: TObject);
    procedure ckbProcOracleSeqsClick(Sender: TObject);
    procedure ckbSketchModeClick(Sender: TObject);
  private
    FLinkDbNo: integer;
    FCtMetaDatabase: TCtMetaDatabase;
    FAborted: boolean;

    FRestoreFileName: string;
    FRestoreFileSeek: longint;
    FCurTipMessage: string;
    FLastMsgTick: DWord;
    FImpTotalRowCount: integer;
    FImpCurRowCount: integer;
    FCtDataModelList: TCtDataModelGraphList;
    FMetaObjList: TCtMetaObjectList;
    FAllTbGraph: TCtDataModelGraph;
    FLastAutoSelDBUser: string;

    //不知为何，Memo内容较多时，再次显示窗体时会报错，只好先保存再恢复
    FSave_memSQL: string;
    FSave_memExecSQL: string;
    FSave_memError: string;

    procedure SetCtDataModelList(const Value: TCtDataModelGraphList);
    procedure SetMetaObjList(const Value: TCtMetaObjectList);

  protected
    FWorkMode: integer; //0导入模型 1恢复数据
    FRestoringTbList: TCtMetaTableList;
    FDefaultDbType: string;
    FCmpEzdmlFakeDb: TCtMetaEzdmlFakeDb;   
    FCloneMetaDb: TCtMetaDatabase;

    function GenSQL: TStringList;
    function DBgenSQL: TStringList;

    procedure ExecCommands;

    procedure ReadDatabaseBakFile;
    procedure _OnReadingDsProgress(Sender: TObject);
  public
    procedure RefreshDbInfo;
    procedure InitListObj;
    procedure InitTbList;
    procedure SetWorkMode(AWorkMode: integer);
    function LoadDbBackFile: boolean;
    procedure LoadCompareDml(fn: string);

    property MetaObjList: TCtMetaObjectList read FMetaObjList write SetMetaObjList;
    property CtDataModelList: TCtDataModelGraphList
      read FCtDataModelList write SetCtDataModelList;
  end;

var
  frmCtGenSQL: TfrmCtGenSQL;

implementation

uses
  uFormCtDbLogon, WindowFuncs, dmlstrs, CtObjSerialer, DB, ezdmlstrs,
  {$ifndef EZDML_LITE}CtDataSetFile,{$endif} CtObjXmlSerial;

{$R *.lfm}

procedure TfrmCtGenSQL.btnDBLogonClick(Sender: TObject); 
var
  p: TPoint;
begin
  p.X := 0;
  p.Y := btnDBLogon.Height;
  p := btnDBLogon.ClientToScreen(p);
  PopupMenuDbConn.Popup(p.X, p.Y);
end;

procedure TfrmCtGenSQL.FormCreate(Sender: TObject);

  procedure AddDbTypeMenu(db: string);
  var
    mn: TMenuItem;
  begin
    mn := TMenuItem.Create(Self);
    mn.Caption := db;
    mn.OnClick := MN_DefDbType_StandardClick;
    MenuItem_VirtualDbs.Add(mn);
  end;

var
  I: integer;
begin
  cklbDbObjs.MultiSelect := True;
  FLinkDbNO := -1;
  
  FAllTbGraph:= TCtDataModelGraph.Create;
  FAllTbGraph.Name:='('+srdmlall+')';
  FAllTbGraph.Tables.AutoFree:=False;

  MenuItem_VirtualDbs.Clear;
  for I := 0 to High(CtMetaDBRegs) do
  begin
    if CtMetaDBRegs[I].DbEngineType = 'ODBC' then
      Continue;
    if CtMetaDBRegs[I].DbEngineType = 'HTTP_JDBC' then
      Continue;
    AddDbTypeMenu(CtMetaDBRegs[I].DbEngineType);
  end;

  AddDbTypeMenu('HIVE');
  AddDbTypeMenu('STANDARD');
  AddDbTypeMenu('EZDMLFILE');
  RefreshDbInfo;
end;

procedure TfrmCtGenSQL.FormDestroy(Sender: TObject);
begin
  FRestoringTbList.Free;
  FAllTbGraph.Free;
  FreeAndNil(FCmpEzdmlFakeDb);    
  if Assigned(FCloneMetaDb) then
    FreeAndNil(FCloneMetaDb);
end;

procedure TfrmCtGenSQL.MenuItemDbConnClick(Sender: TObject);
var
  I: integer;
begin
  I := ExecCtDbLogon;
  if I >= 0 then
  begin
    FLinkDbNo := I;
    if Assigned(FCloneMetaDb) then
      FreeAndNil(FCloneMetaDb);
  end;
  RefreshDbInfo;
end;

procedure TfrmCtGenSQL.MenuItemDedicatedConnClick(Sender: TObject);
var
  db: TCtMetaDatabase;
begin
  db := ExecDedicatedDbLogon(Self, FCloneMetaDb);
  if db = nil then
    Exit;

  if Assigned(FCloneMetaDb) then
    FreeAndNil(FCloneMetaDb);
  FCloneMetaDb := db;
  RefreshDbInfo;
end;

procedure TfrmCtGenSQL.cklbDbObjsDblClick(Sender: TObject);
begin
  MN_DBTableInfoClick(nil);
end;

procedure TfrmCtGenSQL.cklbDbObjsResize(Sender: TObject);
begin
  btnListMenu.Left := cklbDbObjs.Width - 22 - btnListMenu.Width;
end;

procedure TfrmCtGenSQL.btnListMenuClick(Sender: TObject);
begin
  PopupMenu1.PopUp;
end;

procedure TfrmCtGenSQL.ckbCreateForeignkeysChange(Sender: TObject);
begin
  G_CreateForeignkeys := ckbCreateForeignkeys.Checked;
end;

procedure TfrmCtGenSQL.ckbGenDBCommentsChange(Sender: TObject);
begin
  G_GenDBComments := ckbGenDBComments.Checked;
end;

procedure TfrmCtGenSQL.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin      
  //不知为何，Memo内容较多时，再次显示窗体时会报错，只好先保存再恢复
  FSave_memSQL := memSQL.Lines.Text;
  memSQL.Lines.Clear;

  FSave_memExecSQL := memExecSQL.Lines.Text;
  memExecSQL.Lines.Clear;

  FSave_memError := memError.Lines.Text;
  memError.Lines.Clear;

  combModels.Items.Clear;
  FAllTbGraph.Tables.Clear;
end;

procedure TfrmCtGenSQL.MN_ModelTableInfoClick(Sender: TObject);
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

procedure TfrmCtGenSQL.MN_DBTableInfoClick(Sender: TObject);
var
  o: TCtMetaObject;
  I, po: Integer;
  S, db, obj: string;
begin
  I := cklbDbObjs.ItemIndex;
  if I<0 then
    Exit;

  if (FCtMetaDatabase = nil) or not FCtMetaDatabase.Connected then
    MenuItemDbConnClick(nil);
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

procedure TfrmCtGenSQL.MN_CheckAllClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := MN_CheckAll.Checked;
end;

procedure TfrmCtGenSQL.MN_CheckSelectedClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    if cklbDbObjs.Selected[I] then
      cklbDbObjs.Checked[I] := MN_CheckSelected.Checked;
end;


procedure TfrmCtGenSQL.MN_DefDbType_StandardClick(Sender: TObject);
var
  S: string;
begin
  S := TMenuItem(Sender).Caption;
  S := StringReplace(S, '&', '', [rfReplaceAll]);
  if S = 'EZDMLFILE' then
  begin
    if FDefaultDbType = '' then
      FDefaultDbType := 'STANDARD';
    //raise Exception.Create(srNeedEngineType);
    if not OpenDialogDml.Execute then
    begin
      if FCmpEzdmlFakeDb <> nil then
        if Application.MessageBox(PChar(srClearCompareDmlPrompt),
          PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) = idOk then
        begin
          FreeAndNil(FCmpEzdmlFakeDb);
          RefreshDbInfo;
        end;
      Exit;
    end;
    LoadCompareDml(OpenDialogDml.FileName);
    Exit;
  end;
  FLinkDbNo := -1;
  FDefaultDbType := S;
  RefreshDbInfo;
end;

procedure TfrmCtGenSQL.MN_InverseSelClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := not cklbDbObjs.Checked[I];
end;

procedure TfrmCtGenSQL.PopupMenu1Popup(Sender: TObject);
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

procedure TfrmCtGenSQL.ReadDatabaseBakFile;

  function ReadDataSet(ds: TDataSet; stream: TStream): integer;
  begin
    {$ifndef EZDML_LITE}
    with TCtDataSetFile.Create do
      try
        DataSet := ds;
        FakeLoad := (ds = nil);
        OnProgress := _OnReadingDsProgress;
        LoadFromStream(stream);
        FImpCurRowCount := FImpCurRowCount + WorkingMaxRowCount;
        Result := WorkingCounter;
      finally
        Free;
      end;
    {$else}
      raise Exception.Create(srEzdmlLiteNotSupportFun);
    {$endif}
  end;

  function IsTableSelected(tb: string): boolean;
  var
    I: integer;
  begin
    Result := False;
    for I := 0 to cklbDbObjs.Items.Count - 1 do
      if UpperCase(cklbDbObjs.Items[I]) = UpperCase(tb) then
      begin
        if cklbDbObjs.Checked[I] then
          Result := True;
        Exit;
      end;
  end;

var
  fs: TFileStream;
  I, C, L: integer;
  S, tbn: string;
  ds: TDataSet;
begin
  fs := TFileStream.Create(FRestoreFileName, fmOpenRead or fmShareDenyNone);
  try
    fs.Seek(FRestoreFileSeek, soFromBeginning);
    fs.ReadBuffer(L, Sizeof(L));
    SetLength(S, L);
    fs.ReadBuffer(Pointer(S)^, L);
    if S <> '[DML_DATAFILE_START]' then
      raise Exception.Create('read data file error');
    fs.ReadBuffer(FImpTotalRowCount, Sizeof(FImpTotalRowCount));

    C := MetaObjList.Count;
    memExecSQL.Lines.Add('-- Disable constraints');
    for I := 0 to C - 1 do
    begin
      tbn := TCtMetaTable(MetaObjList.Items[I]).RealTableName;
      if IsTableSelected(MetaObjList.Items[I].Name) then
      begin
        memExecSQL.Lines.Add('   Disable constraints of ' + tbn);
        S := '';
        try
          S := FCtMetaDatabase.ExecCmd('DISABLE_CONSTRAINTS', tbn, '');
        except
          on E: Exception do
            S := 'Error: ' + E.Message;
        end;
        if S <> '' then
          memExecSQL.Lines.Add('     ' + S)
        else
          memExecSQL.Lines.Add('     failed with not response');
      end;
    end;
    memExecSQL.Lines.Add('');

    for I := 0 to C - 1 do
    begin
      tbn := TCtMetaTable(MetaObjList.Items[I]).RealTableName;

      ProgressBar1.Position := (FImpCurRowCount + 1) * 100 div (FImpTotalRowCount + 1);
      FCurTipMessage := Format(srReadingDataFmt, [I + 1, C, tbn]);
      LabelProg.Caption := FCurTipMessage;
      Application.ProcessMessages;
      if FAborted then
        Break;
      CheckAbort(' ');

      fs.ReadBuffer(L, Sizeof(L));
      SetLength(S, L);
      fs.ReadBuffer(Pointer(S)^, L);
      if S <> '[DML_DATASET ' + tbn + ']' then
        raise Exception.Create('read table ' + tbn + ' error');
      try
        if IsTableSelected(MetaObjList.Items[I].Name) then
        begin
          memExecSQL.Lines.Add('-- Restore data of ' + tbn);
          memExecSQL.Lines.Add('   Deleting old rows...');
          S := 'delete from ' + tbn;
          try
            FCtMetaDatabase.ExecSql(S);

            S := tbn;
            ds := FCtMetaDatabase.OpenTable(S, '[EDITABLE][FORWARD_CURSOR]');
            try
              if ds = nil then
                raise Exception.Create('Error getting DataSet - ' + tbn);
              memExecSQL.Lines.Add('   Restoring data...');
              L := ReadDataSet(ds, fs);
              memExecSQL.Lines.Add('   ' + IntToStr(L) + ' rows restored.');
              memExecSQL.Lines.Add('');
            finally
              ds.Free;
            end;
          except
            try
              ReadDataSet(nil, fs);
            except
            end;
            raise;
          end;
        end
        else
        begin
          ds := nil;
          memExecSQL.Lines.Add('-- Skip data of ' + tbn);
          ReadDataSet(ds, fs);
          memExecSQL.Lines.Add('');
        end;
      except
        on EA: EAbort do
          ;
        on E: Exception do
        begin
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

    memExecSQL.Lines.Add('-- Enable constraints');
    for I := 0 to C - 1 do
    begin
      tbn := TCtMetaTable(MetaObjList.Items[I]).RealTableName;
      if IsTableSelected(MetaObjList.Items[I].Name) then
      begin
        memExecSQL.Lines.Add('   Enable constraints of ' + tbn);
        S := '';
        try
          S := FCtMetaDatabase.ExecCmd('ENABLE_CONSTRAINTS', tbn, '');
        except
          on E: Exception do
            S := 'Error: ' + E.Message;
        end;
        if S <> '' then
          memExecSQL.Lines.Add('     ' + S)
        else
          memExecSQL.Lines.Add('     failed with not response');
      end;
    end;
    memExecSQL.Lines.Add('');

  finally
    fs.Free;
  end;
end;

procedure TfrmCtGenSQL.RefreshDbInfo;
var
  I: integer;
  dbs: string;
begin

  if FLastAutoSelDBUser = combDBUser.Text then
  begin
    combDBUser.Text := '';
    FLastAutoSelDBUser := '';
  end;

  if FCloneMetaDb <> nil then    
    FCtMetaDatabase := FCloneMetaDb
  else if FLinkDbNo < 0 then
    FCtMetaDatabase := nil
  else
    FCtMetaDatabase := CtMetaDBRegs[FLinkDbNo].DbImpl;
  if not Assigned(FCtMetaDatabase) or not FCtMetaDatabase.Connected then
  begin
    combDBUser.Items.Clear;
    combDBUser.Enabled := False;
    combDBUser.ParentColor := True;
    if FDefaultDbType = '' then
      dbs := ''
    else
      dbs := '[' + FDefaultDbType + ']';
    if FCmpEzdmlFakeDb <> nil then
      //if FDefaultDbType <> 'STANDARD' then
      dbs := dbs + '[EZDMLFILE]';
    edtDBLinkInfo.Text := dbs;
  end
  else
  begin
    dbs := FCtMetaDatabase.Database;
    try
      Self.Refresh;
      combDBUser.Items.Text := FCtMetaDatabase.GetDbUsers;
      combDBUser.Enabled := True;
      combDBUser.Color := clWindow;
      dbs := '[' + FCtMetaDatabase.EngineType + ']' +
        FCtMetaDatabase.Database;      
      if FCloneMetaDb <> nil then
        dbs := '('+srDedicatedConn+')' + dbs;
    finally
      edtDBLinkInfo.Text := dbs;
    end;
  end;
  if Assigned(FCtMetaDatabase) and (combDBUser.Text = '') and (G_LastMetaDbSchema<>'') then
  begin
    for I := 0 to combDBUser.Items.Count - 1 do
      if UpperCase(combDBUser.Items[I]) = UpperCase(G_LastMetaDbSchema) then
      begin
        combDBUser.ItemIndex := I;
        FLastAutoSelDBUser := combDBUser.Text;
        Break;
      end;
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

  if Assigned(FCtMetaDatabase) and (FCtMetaDatabase.EngineType = 'ORACLE') then
    ckbProcOracleSeqs.Show
  else if FDefaultDbType = 'ORACLE' then
    ckbProcOracleSeqs.Show
  else
    ckbProcOracleSeqs.Hide;
end;

procedure TfrmCtGenSQL.SetCtDataModelList(const Value: TCtDataModelGraphList);
begin
  FCtDataModelList := Value;
  if FCtDataModelList <> nil then
    FMetaObjList := FCtDataModelList.CurDataModel.Tables;
end;

procedure TfrmCtGenSQL.SetMetaObjList(const Value: TCtMetaObjectList);
begin
  FMetaObjList := Value;
  if FMetaObjList <> nil then
    FCtDataModelList := nil;
end;


procedure TfrmCtGenSQL.SetWorkMode(AWorkMode: integer);
begin
  FWorkMode := AWorkMode;
  if FWorkMode = 0 then
    Caption := srGenerateSql
  else
    Caption := srRestoreDatabase;
end;

procedure TfrmCtGenSQL.TimerInitTimer(Sender: TObject);  
var
  I: integer;
begin
  TimerInit.Enabled := False;
  if not Assigned(FCtMetaDatabase) then
  begin        
    if Assigned(FCloneMetaDb) then
      RefreshDbInfo
    else
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
        MenuItemDbConnClick(nil);
      end;
    end;
  end
  else if FDefaultDbType='' then
    RefreshDbInfo;
end;

procedure TfrmCtGenSQL._OnReadingDsProgress(Sender: TObject);
var
  tm: Dword;
begin
  tm := GetTickCount64;
  if (tm - FLastMsgTick) < 200 then
    Exit;

  FLastMsgTick := tm;
  {$ifndef EZDML_LITE}
  ProgressBar1.Position := (FImpCurRowCount + TCtDataSetFile(Sender).WorkingCounter +
    1) * 100 div (FImpTotalRowCount + 1);
  LabelProg.Caption := FCurTipMessage + ' ' +
    IntToStr(TCtDataSetFile(Sender).WorkingCounter) + '/' +
    IntToStr(TCtDataSetFile(Sender).WorkingMaxRowCount);
  {$endif}
  Application.ProcessMessages;
  if FAborted then
    Abort;
end;

procedure TfrmCtGenSQL.FormShow(Sender: TObject);
begin
  btnResum.Left := btnCancel.Left - btnResum.Width - 10;
  btnExecSQL.Left := btnResum.Left - btnExecSQL.Width - 10;
  btnBuildSQL.Left := btnExecSQL.Left - btnBuildSQL.Width - 10;
  ProgressBar1.Width := btnBuildSQL.Left - ProgressBar1.Left - 10;

  chkPause.Left := Panel2.Width - chkPause.Width - 8;
  ckbRecreateTable.Left := chkPause.Left - ckbRecreateTable.Width - 8;

  CtSetFixWidthFont(memSQL);

  ProgressBar1.Position := 0;
  InitListObj;
           
  memSQL.Lines.Text:=FSave_memSQL ;
  memExecSQL.Lines.Text:=FSave_memExecSQL ;
  memError.Lines.Text:=FSave_memError ;

  ckbProcOracleSeqs.Checked := G_CreateSeqForOracle; 
  ckbGenDBComments.Checked := G_GenDBComments;
  ckbCreateForeignkeys.Checked := G_CreateForeignkeys;
  if Assigned(FCtMetaDatabase) and (FCtMetaDatabase.EngineType = 'ORACLE') then
    ckbProcOracleSeqs.Show
  else if FDefaultDbType = 'ORACLE' then
    ckbProcOracleSeqs.Show
  else
    ckbProcOracleSeqs.Hide;
  //if (FCtMetaDatabase = nil) and (FDefaultDbType = '') then
  TimerInit.Enabled := True;
end;

procedure TfrmCtGenSQL.btnCancelClick(Sender: TObject);
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

procedure TfrmCtGenSQL.InitListObj;
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
      S := FCtDataModelList[I].NameCaption;
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

procedure TfrmCtGenSQL.InitTbList;
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
          S := TCtMetaTable(MetaObjList[i]).NameCaption;
          cklbDbObjs.Items.AddObject(S, TObject((MetaObjList[i])));
        end;

  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := True;
  MN_CheckAll.Checked := True;
end;

procedure TfrmCtGenSQL.LoadCompareDml(fn: string);
var
  fs: TCtObjSerialer;
  gs: TCtMetaEzdmlFakeDb;
begin
  if FileExists(fn) then
  begin
    fs := Proc_CreateCtObjSerialer(fn, False);
    //    if (LowerCase(ExtractFileExt(fn)) = '.dmx') or (LowerCase(ExtractFileExt(fn)) = '.xml') then
    //      fs := TCtObjXmlSerialer.Create(fn, fmOpenRead or fmShareDenyNone)
    //    else
    //      fs := TCtObjFileStream.Create(fn, fmOpenRead or fmShareDenyNone);
    Screen.Cursor := crHourGlass;
    gs := nil;
    try
      fs.RootName := 'DataModels';
      FreeAndNil(FCmpEzdmlFakeDb);
      gs := TCtMetaEzdmlFakeDb.Create;
      gs.DataModelList.LoadFromSerialer(fs);
      FCmpEzdmlFakeDb := gs;
      gs := nil;
      RefreshDbInfo;
    finally
      Screen.Cursor := crDefault;
      if Assigned(gs) then
        gs.Free;
      fs.Free;
    end;
  end;
end;

function TfrmCtGenSQL.LoadDbBackFile: boolean;
var
  fs: TCtObjSerialer;
begin
  Result := False;
  if FWorkMode = 1 then
  begin
    TimerInit.Enabled := False;
    if not OpenDialog1.Execute then
      Exit;
    FRestoringTbList := TCtMetaTableList.Create;

    FRestoreFileName := OpenDialog1.FileName;
    fs := TCtObjFileStream.Create(FRestoreFileName, fmOpenRead or fmShareDenyNone);
    try
      fs.RootName := 'DataModels';
      FRestoringTbList.LoadFromSerialer(fs);
      FRestoreFileSeek := TCtObjFileStream(fs).Stream.Position;
    finally
      fs.Free;
    end;
    MetaObjList := FRestoringTbList;
    Result := True;
  end;
end;

function TfrmCtGenSQL.GenSQL: TStringList;
var
  I, A, C: integer;
  bTbFound: boolean;
  ResTbSQL: TStringList; //生成表的sql语句
  ResFKSQL: TStringList; //创建外键的SQL
  dmlLsTbObj, dmlDBTbObj: TCtMetaTable;
  dmobj: TCtMetaObject;
  strtmp, dbu: string;
begin
  Result := TStringList.Create;
  ResTbSQL := TStringList.Create;
  ResFKSQL := TStringList.Create;

  if Assigned(FCmpEzdmlFakeDb) then
    FCmpEzdmlFakeDb.SetFakeEngineType(FDefaultDbType);

  btnDBLogon.Enabled := False;        
  btnBuildSQL.Enabled := False;
  btnExecSQL.Enabled := False;
  combDBUser.Enabled := False;

  cklbDbObjs.Enabled := False;
  dbu := ''; //combDBUser.Text;

  //btnOk.Enabled := False;
  btnCancel.Caption := srCapCancel;
  FAborted := False;
  try
    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('FORM_GEN_SQL', 'GEN_SQL', 'BEGIN', cklbDbObjs, Result);
    end;
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
      for I := 0 to cklbDbObjs.Items.Count - 1 do
        if cklbDbObjs.Checked[I] then
        begin
          Inc(A);
          ProgressBar1.Position := A * 100 div C;
          LabelProg.Caption := Format(srGeneratingSqlFmt, [A, C, cklbDbObjs.Items[I]]);
          Application.ProcessMessages;
          if FAborted then
            Exit;
          CheckAbort(' ');
          dmlLsTbObj := TCtMetaTable(cklbDbObjs.Items.Objects[I]);
          if dmlLsTbObj.IsTable then
          begin
            bTbFound := False;
            strtmp := dmlLsTbObj.RealTableName;
            ResTBSQL.Add('-- ' + strtmp);
            if Assigned(FCmpEzdmlFakeDb) then
            begin
              dmobj := FCmpEzdmlFakeDb.GetObjInfos(dbu, strtmp, '');
              if Assigned(dmobj) and (dmobj is TCtMetaTable) then
              begin
                dmlDBTbObj := dmobj as TCtMetaTable;
                if AnsiSameText(dmlDBTbObj.RealTableName, strtmp) then
                begin
                  //数据库有对应表的处理
                  if ckbRecreateTable.Checked then
                  begin
                    //自动改名
                    if FCmpEzdmlFakeDb.EngineType = 'SQLSERVER' then
                      ResTbSQL.Add('exec   sp_rename ''' + IfElse(FCmpEzdmlFakeDb.DbSchema='','dbo',FCmpEzdmlFakeDb.DbSchema) +'.'+strtmp +
                        ''', ''' + strtmp + '_' + IntToStr(Round(Now * 100000) mod 100000) + ''';')
                    else if FCmpEzdmlFakeDb.EngineType = 'ORACLE' then
                      ResTbSQL.Add('rename ' + strtmp + ' to ' + strtmp +
                        '_' + IntToStr(Round(Now * 100000) mod 100000) + ';')
                    else
                      ResTbSQL.Add('rename table ' + strtmp + ' to ' +
                        strtmp + '_' + IntToStr(Round(Now * 100000) mod 100000) + ';');
                  end
                  else
                  begin
                    bTbFound := True;
                    ResTbSQL.Add(FCmpEzdmlFakeDb.GenObjSql(dmlLsTbObj, dmlDBTbObj, 1));
                    ResFKSQL.Add(FCmpEzdmlFakeDb.GenObjSql(dmlLsTbObj, dmlDBTbObj, 2));
                  end;
                end;
              end;
            end;
            //没有该表则创建
            if not bTbFound then
            begin
              ResTbSQL.Add(dmlLsTbObj.GenSqlEx(True, False, FDefaultDbType));
              resFKSQL.Add(dmlLsTbObj.GenSqlEx(False, True, FDefaultDbType));
            end;
          end
          else if dmlLsTbObj.IsSqlText then
          begin
            resFKSQL.Add(dmlLsTbObj.Memo);
          end;
        end;
      except
        on E:EAbort do
        ;
      else
        raise;
      end;

  finally
    btnDBLogon.Enabled := True;
    combDBUser.Enabled := True;
    cklbDbObjs.Enabled := True;
    //btnOk.Enabled := True;
    btnBuildSQL.Enabled := True;
    btnExecSQL.Enabled := True;
    btnCancel.Caption := srCapClose;
  end;

  Result.AddStrings(resTBSQL);
  Result.AddStrings(resFKSQL);
  resTBSQL.Free;
  resFKSQL.Free;

  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('FORM_GEN_SQL', 'GEN_SQL', 'END', cklbDbObjs, Result);
  end;
end;

function TfrmCtGenSQL.DBGenSQL: TStringList;

  function ImportObjFromDB(db, obj: string): TCtMetaObject;
  begin
    Result := FCtMetaDatabase.GetObjInfos(db, obj, '');
  end;

var
  I, J, C, A: integer;
  MetaObjListDB: TCtMetaObjectList; //从数据库中导出数据生成的临时列表
  dmlobjtmp: TCtMetaObject; //生成的临时对象
  strtmp: string; //临时变量
  ResTbSQL: TStringList; //生成表的sql语句
  ResFKSQL: TStringList; //创建外键的SQL
  dmlDBTbObj: TCtMetaTable;
  dmlLsTbObj: TCtMetaTable;
  dbu: string;
  bTbFound: boolean;
begin
  Result := TStringList.Create;
  btnDBLogon.Enabled := False;
  combDBUser.Enabled := False;

  cklbDbObjs.Enabled := False;
  //btnOk.Enabled := False;
  btnBuildSQL.Enabled := False;
  btnExecSQL.Enabled := False;
  btnCancel.Caption := srCapCancel;
  FAborted := False;
  try

    if not Assigned(FCtMetaDatabase) then
      Exit;

    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('FORM_GEN_SQL', 'GEN_SQL_DB', 'BEGIN', cklbDbObjs, Result);
    end;

    if combDBUser.Text <> '' then
      FCtMetaDatabase.DbSchema := GetDbQuotName(combDBUser.Text, FCtMetaDatabase.EngineType);

    MetaObjListDB := TCtMetaObjectList.Create();
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

    dbu := combDBUser.Text;
    //获取数据库现有对象信息
    for I := 0 to cklbDbObjs.Items.Count - 1 do
      if cklbDbObjs.Checked[I] then
      begin
        Inc(A);
        ProgressBar1.Position := A * 100 div (C + C);
        LabelProg.Caption := Format(srCheckingDataFmt, [A, C, cklbDbObjs.Items[I]]);
        Application.ProcessMessages;
        if FAborted then
          Exit;
        CheckAbort(' ');
        if not TCtMetaTable(cklbDbObjs.Items.Objects[I]).IsTable then
          Continue;
        dmlobjtmp := ImportObjFromDB(dbu,
          TCtMetaTable(cklbDbObjs.Items.Objects[I]).RealTableName);
        if (dmlobjtmp <> nil) then
          MetaObjListDB.Add(dmlobjtmp);
      end;

    //开始生成sql
    A := 0;
    ResTbSQL := TStringList.Create;
    ResFKSQL := TStringList.Create;
    try

      for I := 0 to cklbDbObjs.Items.Count - 1 do
        if cklbDbObjs.Checked[I] then
        begin
          Inc(A);
          ProgressBar1.Position := 50 + A * 100 div (C + C);
          LabelProg.Caption := Format(srGeneratingSqlFmt, [A, C, cklbDbObjs.Items[I]]);
          Application.ProcessMessages;
          if FAborted then
            Break;
          CheckAbort(' ');

          dmlLsTbObj := TCtMetaTable(cklbDbObjs.Items.Objects[I]);
          strtmp := dmlLsTbObj.RealTableName;
          ResTBSQL.Add('-- ' + strtmp);

          bTbFound := False;
          if dmlLsTbObj.IsTable then
            for J := 0 to MetaObjListDB.Count - 1 do
            begin
              dmlDBTbObj := TCtMetaTable(MetaObjListDb[J]);
              if AnsiSameText(dmlDBTbObj.RealTableName, strtmp) then
              begin
                //数据库有对应表的处理
                if ckbRecreateTable.Checked then
                begin
                  //自动改名
                  if FCtMetaDatabase.EngineType = 'SQLSERVER' then
                    ResTbSQL.Add('exec   sp_rename ''' + IfElse(FCtMetaDatabase.DbSchema='','dbo',FCtMetaDatabase.DbSchema) +'.' + strtmp +
                      ''', ''' + strtmp + '_' + IntToStr(Round(Now * 100000) mod 100000) + ''';')
                  else if FCtMetaDatabase.EngineType = 'ORACLE' then
                    ResTbSQL.Add('rename ' + strtmp + ' to ' + strtmp +
                      '_' + IntToStr(Round(Now * 100000) mod 100000) + ';')
                  else
                    ResTbSQL.Add('rename table ' + strtmp + ' to ' +
                      strtmp + '_' + IntToStr(Round(Now * 100000) mod 100000) + ';');
                end
                else
                begin
                  bTbFound := True;
                  ResTbSQL.Add(FCtMetaDatabase.GenObjSql(dmlLsTbObj, dmlDBTbObj, 1));
                  ResFKSQL.Add(FCtMetaDatabase.GenObjSql(dmlLsTbObj, dmlDBTbObj, 2));
                end;
                Break;
              end;
            end;
          //没有该表则创建
          if not bTbFound then
          begin
            ResTbSQL.Add(FCtMetaDatabase.GenObjSql(dmlLsTbObj, nil, 1));
            ResFKSQL.Add(FCtMetaDatabase.GenObjSql(dmlLsTbObj, nil, 2));
          end;
        end;     
    except
      on E:EAbort do
      ;
    else
      raise;
    end;

    Result.AddStrings(ResTBSQL);
    Result.AddStrings(ResFKSQL);
    MetaObjListDB.Free;
    ResTbSQL.Free;
    ResFKSQL.Free;

  finally
    btnDBLogon.Enabled := True;
    combDBUser.Enabled := True;
    cklbDbObjs.Enabled := True;
    btnBuildSQL.Enabled := True;
    btnExecSQL.Enabled := True;
    btnCancel.Caption := srCapClose;
  end;

  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('FORM_GEN_SQL', 'GEN_SQL_DB', 'END', cklbDbObjs, Result);
  end;
  // ModalResult := mrOk;
end;

procedure TfrmCtGenSQL.btnBuildSQLClick(Sender: TObject);
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
    if not Assigned(FCtMetaDatabase) or not FCtMetaDatabase.Connected then
    begin
      sqlst := GenSQL;
      if sqlst = nil then
        Exit;
      memSQL.Text := sqlst.Text;
    end
    else
    begin
      sqlst := DBGenSQL;  
      if sqlst = nil then
        Exit;
      memSQL.Text := sqlst.Text;
    end;
    if not FAborted then
      if FWorkMode = 1 then
        memSQL.Lines.Add('-- Restore data');
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

procedure TfrmCtGenSQL.btnExecSQLClick(Sender: TObject);
var
  bFinish: boolean;
  S: string;
begin
  if FWorkMode = 0 then
    S := srModifyDatabaseWarning
  else
    S := srRestoreDatabaseWarning;
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
    (*if (FCtMetaDatabase is TCtMetaOracleDb) then
    begin
      OracleScript1.Session := TCtMetaOracleDb(FCtMetaDatabase).Session;
      OracleScript1.Lines := memSQL.Lines;
      TCtMetaOracleDbUtf8(FCtMetaDatabase).EncodeStrs(OracleScript1.Lines);

      btnExecSQL.Enabled := false;
      btnBuildSQL.Enabled := false;
      btnCancel.Caption := srCapCancel;
      try
        if OracleScript1.Commands.Count > 0 then
          OracleScript1.Execute;
        if not FAborted then
          if FWorkMode = 1 then
            ReadDatabaseBakFile;
        if not FAborted then
        begin
          bFinish := True;
          ProgressBar1.Position := 100;
          memExecSQL.Lines.Add(srStrFinished);
        end;

      finally
        btnExecSQL.Enabled := true;
        btnBuildSQL.Enabled := true;
        btnCancel.Caption := srCapClose;
      end;
      Exit;
    end;  *)

    btnExecSQL.Enabled := False;
    btnBuildSQL.Enabled := False;
    btnCancel.Caption := srCapCancel;
    try
      if Pos(';', memSQL.Text) > 0 then
        ExecCommands;
      if not FAborted then
        if FWorkMode = 1 then
          ReadDatabaseBakFile;
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
    FCtMetaDatabase.ExecCmd('commit', '', '');
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

procedure TfrmCtGenSQL.ExecCommands;
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

      memExecSQL.Lines.Add(ASql);
      if Trim(RemoveCtSQLComment(ASql)) <> '' then
        FCtMetaDatabase.ExecSql(ASql);
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


procedure TfrmCtGenSQL.btnResumClick(Sender: TObject);
begin
  btnResum.Enabled := False;
end;

procedure TfrmCtGenSQL.ckbSketchModeClick(Sender: TObject);
begin
  G_GenSqlSketchMode := ckbSketchMode.Checked;
end;

procedure TfrmCtGenSQL.ckbProcOracleSeqsClick(Sender: TObject);
begin
  G_CreateSeqForOracle := ckbProcOracleSeqs.Checked;
end;

procedure TfrmCtGenSQL.combDBUserChange(Sender: TObject);
begin
  FLastAutoSelDBUser := '';
  if combDBUser.Text <> '' then
    G_LastMetaDbSchema := combDBUser.Text;
end;

procedure TfrmCtGenSQL.combModelsChange(Sender: TObject);
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
