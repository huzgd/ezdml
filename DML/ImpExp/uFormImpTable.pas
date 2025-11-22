unit uFormImpTable;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CheckLst, Menus, CtMetaTable, ExtCtrls;

type

  { TfrmImportCtTable }

  TfrmImportCtTable = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    ckbCheckAll: TCheckBox;
    lbTbCount: TLabel;
    MenuItemDbConn: TMenuItem;
    MenuItemDedicatedConn: TMenuItem;
    MN_TableProps: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    MN_CheckAll: TMenuItem;
    MN_CheckSelected: TMenuItem;
    MN_InverseSel: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtDBLinkInfo: TEdit;
    btnDBLogon: TButton;
    combDBUser: TComboBox;
    cklbDbObjs: TCheckListBox;
    PopupMenuDbConn: TPopupMenu;
    ProgressBar1: TProgressBar;
    combObjFilter: TComboBox;
    LabelProg: TLabel;
    TimerInit: TTimer;
    ckbAutoCapitalize: TCheckBox;
    ckbComments2DisplayName: TCheckBox;
    ckbImportDbTypeNames: TCheckBox;
    SaveDialog1: TSaveDialog;
    ckbOverwriteExists: TCheckBox;
    procedure ckbCheckAllChange(Sender: TObject);
    procedure cklbDbObjsDblClick(Sender: TObject);
    procedure MenuItemDbConnClick(Sender: TObject);
    procedure MenuItemDedicatedConnClick(Sender: TObject);
    procedure MN_TablePropsClick(Sender: TObject);
    procedure TimerInitTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDBLogonClick(Sender: TObject);
    procedure MN_CheckAllClick(Sender: TObject);
    procedure MN_CheckSelectedClick(Sender: TObject);
    procedure MN_InverseSelClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure combDBUserChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure combObjFilterChange(Sender: TObject);
  private
    { Private declarations }
    FLinkDbNo: Integer;
    FCtMetaDatabase: TCtMetaDatabase;    
    FCloneMetaDb: TCtMetaDatabase;
    FAborted: Boolean;
    FOrigObjs: TStrings;
    FOptStr: string;
    FWorkMode: Integer; //0导入模型 1备份数据

    FCurTipMessage: string;
    FImpTotalRowCount: Integer;
    FImpCurRowCount: Integer;
    FImpCurTbRows: Integer;
    FLastMsgTick: DWord;
    FLastAutoSelDBUser: string;

    procedure RefreshDbInfo;
    procedure RefreshDbInfoEx;
    procedure RefreshObjList;
    function ImportObj(db, obj: string): Boolean;
    function AutoRenameObj(AName: string): string;

    procedure WriteDatabaseBakFile(fn: string);
    procedure _OnWritingDsProgress(Sender: TObject);
  public
    { Public declarations }
    FCtMetaObjList: TCtMetaObjectList;
    procedure SetWorkMode(AWorkMode: Integer);
  end;

implementation

uses
  uFormCtDbLogon, WindowFuncs, dmlstrs, AutoNameCapitalize, CtObjSerialer, ezdmlstrs,
  CTMetaData, DB, CtMetaTbUtil{$ifndef EZDML_LITE}, CtDataSetFile{$endif};

{$R *.lfm}

procedure TfrmImportCtTable.FormCreate(Sender: TObject);
begin
  FOrigObjs := TStringList.Create;
  cklbDbObjs.MultiSelect := True;
  FLinkDbNo := -1;
  RefreshDbInfo;
end;

procedure TfrmImportCtTable.btnDBLogonClick(Sender: TObject);   
var
  p: TPoint;
begin
  p.X := 0;
  p.Y := btnDBLogon.Height;
  p := btnDBLogon.ClientToScreen(p);
  PopupMenuDbConn.Popup(p.X, p.Y);
end;

procedure TfrmImportCtTable.MN_CheckAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := MN_CheckAll.Checked;
end;

procedure TfrmImportCtTable.MN_CheckSelectedClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    if cklbDbObjs.Selected[I] then
      cklbDbObjs.Checked[I] := MN_CheckSelected.Checked;
end;

procedure TfrmImportCtTable.MN_InverseSelClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := not cklbDbObjs.Checked[I];
end;

procedure TfrmImportCtTable.PopupMenu1Popup(Sender: TObject);
var
  I: Integer;
begin
  I := cklbDbObjs.ItemIndex;
  MN_TableProps.Enabled := I>=0;
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

  I := cklbDbObjs.Items.Count - 1;
  if I > 0 then
  begin
    MN_CheckSelected.Checked := cklbDbObjs.Checked[I];
    MN_CheckAll.Checked := cklbDbObjs.Checked[I];
    Exit;
  end;
end;

procedure TfrmImportCtTable.RefreshDbInfoEx;
var
  I: Integer;
  dbs, dbus: String;
begin
  cklbDbObjs.Enabled := True;
  cklbDbObjs.Color := clWindow;
  cklbDbObjs.Items.Text := srRefreshingPrompt;
  Refresh;

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
  if not Assigned(FCtMetaDatabase) then
  begin       
    edtDBLinkInfo.Text := '';

    combDBUser.Items.Clear;
    combDBUser.Enabled := False;
    combDBUser.ParentColor := True;

    combObjFilter.Enabled := False;
    combObjFilter.ParentColor := True;
  end
  else
  begin                  
    dbs := '[' + FCtMetaDatabase.EngineType + ']' + FCtMetaDatabase.Database; 
    if FCloneMetaDb <> nil then
      dbs := '('+srDedicatedConn+')' + dbs;
    edtDBLinkInfo.Text := dbs;

    combDBUser.Items.Text := FCtMetaDatabase.GetDbUsers;
    combDBUser.Enabled := True;
    combDBUser.Color := clWindow;

    combObjFilter.Enabled := True;
    combObjFilter.Color := clWindow;
  end;

  if Assigned(FCtMetaDatabase) and (combDBUser.Text = '') then
  begin
    dbus := G_LastMetaDbSchema;
    for I := 0 to combDBUser.Items.Count - 1 do
      if UpperCase(combDBUser.Items[I]) = UpperCase(dbus) then
      begin
        combDBUser.ItemIndex := I;
        FLastAutoSelDBUser := combDBUser.Text;
        RefreshObjList;
        Exit;
      end;

    dbus := FCtMetaDatabase.DbSchema;
    if dbus = '' then
      dbus := FCtMetaDatabase.User;
    for I := 0 to combDBUser.Items.Count - 1 do
      if UpperCase(combDBUser.Items[I]) = UpperCase(dbus) then
      begin
        combDBUser.ItemIndex := I;
        FLastAutoSelDBUser := combDBUser.Text;
        RefreshObjList;
        Exit;
      end;
  end;

  RefreshObjList;
end;

procedure TfrmImportCtTable.RefreshDbInfo;
begin
  try
    RefreshDbInfoEx;
  except
    Application.HandleException(Self);
  end;
end;

procedure TfrmImportCtTable.RefreshObjList;
var
  SS: TStrings;
  I: Integer;
begin
  cklbDbObjs.Enabled := True;
  cklbDbObjs.Color := clWindow;
  cklbDbObjs.Items.Text := srRefreshingPrompt;
  Refresh;
  if not Assigned(FCtMetaDatabase) then
    SS := nil
  else
    SS := FCtMetaDatabase.GetDbObjs(combDBUser.Text);
  if not Assigned(SS) then
  begin
    FOrigObjs.Clear;
    cklbDbObjs.Items.Clear;
    cklbDbObjs.Enabled := False;
    cklbDbObjs.ParentColor := True;
  end
  else
  begin
    FOrigObjs.Text := SS.Text;
    cklbDbObjs.Items.Text := FOrigObjs.Text;
    cklbDbObjs.Enabled := True;
    cklbDbObjs.Color := clWindow;
  end;
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := True;
  MN_CheckAll.Checked := True;     
  lbTbCount.Caption := Format(srTbCountFmt, [cklbDbObjs.Items.Count]);
  if combDBUser.Text <> '' then
    G_LastMetaDbSchema := combDBUser.Text;
end;

procedure TfrmImportCtTable.SetWorkMode(AWorkMode: Integer);
begin
  FWorkMode := AWorkMode;
  if FWorkMode = 0 then
  begin
    Caption := srImportDatabase;
    ckbAutoCapitalize.Visible := True;
    ckbComments2DisplayName.Visible := True;
  end
  else
  begin
    Caption := srBackupDatabase;
    ckbAutoCapitalize.Visible := False;
    ckbComments2DisplayName.Visible := False;
  end;
end;

procedure TfrmImportCtTable.TimerInitTimer(Sender: TObject);
var
  I: Integer;
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
      MenuItemDbConnClick(nil);
  end
  else
    RefreshDbInfo;
end;

procedure TfrmImportCtTable.MN_TablePropsClick(Sender: TObject);
var
  o: TCtMetaObject;
  I, po: Integer;
  S, db, obj: string;
begin
  I := cklbDbObjs.ItemIndex;
  if I<0 then
    Exit;
  obj := cklbDbObjs.Items[I];
  db := combDBUser.Text;

  if ckbImportDbTypeNames.Checked then
    S := '[DBTYPENAMES]'
  else
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
  o := FCtMetaDatabase.GetObjInfos(db, obj, FOptStr + S);
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

procedure TfrmImportCtTable.cklbDbObjsDblClick(Sender: TObject);
begin
  MN_TablePropsClick(nil);
end;

procedure TfrmImportCtTable.MenuItemDbConnClick(Sender: TObject);
var
  I: Integer;
begin
  I := ExecCtDbLogon;
  if I >= 0 then
  begin
    FLinkDbNo := I;
    if Assigned(FCloneMetaDb) then
      FreeAndNil(FCloneMetaDb);
    RefreshDbInfo;
  end;
end;

procedure TfrmImportCtTable.MenuItemDedicatedConnClick(Sender: TObject);
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

procedure TfrmImportCtTable.ckbCheckAllChange(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := ckbCheckAll.Checked;
end;

procedure TfrmImportCtTable.WriteDatabaseBakFile(fn: string);
  procedure WriteDataSet(ds: TDataSet; stream: TStream);
  begin
    {$ifndef EZDML_LITE}
    with TCtDataSetFile.Create do
    try
      DataSet := ds;
      OnProgress := _OnWritingDsProgress;
      WorkingMaxRowCount := FImpCurTbRows;
      SaveToStream(stream);
    finally
      Free;
    end;
    {$else}
    raise Exception.Create(srEzdmlLiteNotSupportFun);
    {$endif}
  end;
var
  fs: TCtObjStream;
  I, C: Integer;
  S, tbn: string;
  ds: TDataSet;
begin
  fs := TCtObjFileStream.Create(fn, fmCreate);
  try
    fs.RootName := 'DataModels';
    FCtMetaObjList.Pack;
    FCtMetaObjList.SaveToSerialer(fs);
    S := '[DML_DATAFILE_START]';
    fs.WriteString('A', S);
    C := FCtMetaObjList.Count;
    FImpTotalRowCount := 0;
    FImpCurRowCount := 0;
    for I := 0 to C - 1 do
    begin
      tbn := FCtMetaObjList.Items[I].Name;
      Application.ProcessMessages;
      if FAborted then
        Exit;
      CheckAbort(' ');

      ds := FCtMetaDatabase.OpenTable('select count(*) from ' + tbn, '[ISSQL]');
      if ds <> nil then
      begin
        FImpTotalRowCount := FImpTotalRowCount + ds.Fields[0].AsInteger;
        FCtMetaObjList.Items[I].Param['ROW_COUNT'] := ds.Fields[0].AsString;
        ds.Free;
      end;
    end;
    fs.WriteInteger('C', FImpTotalRowCount);

    for I := 0 to C - 1 do
    begin
      tbn := FCtMetaObjList.Items[I].Name;
      FImpCurTbRows := StrToIntDef(FCtMetaObjList.Items[I].Param['ROW_COUNT'], 0);

      ProgressBar1.Position := (FImpCurRowCount + 1) * 100 div (FImpTotalRowCount + 1);
      FCurTipMessage := Format(srWritingDataFmt, [I + 1, C, tbn]);
      LabelProg.Caption := FCurTipMessage;
      Application.ProcessMessages;
      if FAborted then
        Exit;
      CheckAbort(' ');

      S := '[DML_DATASET ' + tbn + ']';
      fs.WriteString('B', S);
      ds := FCtMetaDatabase.OpenTable('select * from ' + tbn, '[FORWARD_CURSOR][ISSQL]');
      try
        if ds = nil then
          raise Exception.Create('Error getting DataSet - ' + tbn);
        WriteDataSet(ds, fs.Stream);
      finally
        ds.Free;
      end;
      FImpCurRowCount := FImpCurRowCount + FImpCurTbRows;
    end;
  finally
    fs.Free;
  end;
end;

procedure TfrmImportCtTable._OnWritingDsProgress(Sender: TObject);
var
  tm: Dword;
begin
  tm := GetTickCount64;
  if (tm - FLastMsgTick) < 200 then
    Exit;

  FLastMsgTick := tm;
  {$ifndef EZDML_LITE}
  ProgressBar1.Position := (FImpCurRowCount + TCtDataSetFile(Sender).WorkingCounter + 1) * 100 div (FImpTotalRowCount + 1);
  LabelProg.Caption := FCurTipMessage + ' ' + IntToStr(TCtDataSetFile(Sender).WorkingCounter) + '/' + IntToStr(FImpCurTbRows);
  {$endif}
  Application.ProcessMessages;
  if FAborted then
    Abort;
end;

procedure TfrmImportCtTable.combDBUserChange(Sender: TObject);
begin
  RefreshObjList;
  FLastAutoSelDBUser := '';
end;


procedure TfrmImportCtTable.btnOKClick(Sender: TObject);
var
  I, C, A: Integer;
  faketb: TCtMetaTable;
  S: String;
begin
  //ShowMessage(AutoRenameObj('ct_jg_g3examsheet'));
  btnDBLogon.Enabled := False;
  combDBUser.Enabled := False;
  combObjFilter.Enabled := False;
  cklbDbObjs.Enabled := False;
  btnOk.Enabled := False;
  btnCancel.Caption := srCapCancel;
  FAborted := False;
  if FWorkMode = 1 then
    FCtMetaObjList := nil;
  try

    if not Assigned(FCtMetaDatabase) then
      Exit;

    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('FORM_IMP_TABLE', 'IMP_TABLE', 'BEGIN', cklbDbObjs, FCtMetaObjList);
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
    if FWorkMode = 1 then
    begin
      if not SaveDialog1.Execute then
        Exit;
      FCtMetaObjList := TCtMetaTableList.Create;
    end;

    A := 0;
    FCtMetaObjList.Pack;
    faketb := TCtMetaTable.Create;
    faketb.Name := '';
    for I := 0 to cklbDbObjs.Items.Count - 1 do
      if cklbDbObjs.Checked[I] then
      begin
        Inc(A);
        ProgressBar1.Position := A * 100 div C;
        LabelProg.Caption := Format(srImportingObjsFmt, [A, C, cklbDbObjs.Items[I]]);
        Application.ProcessMessages;
        if FAborted then
          Exit;
        CheckAbort(' ');
        faketb.Name := CtGenGUID;
        if FWorkMode <> 1 then
          if not ckbOverwriteExists.Checked then   
            if HasSameNameTables(faketb, cklbDbObjs.Items[I]) then
            begin
              S := Format(srRenameToExistsError, [cklbDbObjs.Items[I]]);
              if Application.MessageBox(PChar(S), PChar(Application.Title),
                MB_OKCANCEL or MB_ICONERROR) <> IDOK then
                Abort;
              //if not CheckCanRenameTable(faketb, cklbDbObjs.Items[I], False) then
              Continue;
            end;
        if ImportObj(combDBUser.Text, cklbDbObjs.Items[I]) then
        begin
          if FWorkMode = 0 then
            cklbDbObjs.Checked[I] := False;
        end;
      end;
    FCtMetaObjList.SaveCurrentOrder;
    if FCtMetaObjList is TCtMetaTableList then
      GenRandBgColors(TCtMetaTableList(FCtMetaObjList));
    if FWorkMode = 1 then
      WriteDatabaseBakFile(SaveDialog1.FileName);
    LabelProg.Caption := LabelProg.Caption + '.' + srStrFinished;

    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('FORM_IMP_TABLE', 'IMP_TABLE', 'END', cklbDbObjs, FCtMetaObjList);
    end;
  finally
    if FWorkMode = 1 then
      FreeAndNil(FCtMetaObjList);
    btnDBLogon.Enabled := True;
    combDBUser.Enabled := True;
    combObjFilter.Enabled := True;
    cklbDbObjs.Enabled := True;
    btnOk.Enabled := True;
    btnCancel.Caption := srCapClose;
  end;

  ModalResult := mrOk;
end;

function TfrmImportCtTable.ImportObj(db, obj: string): Boolean;
var
  o: TCtMetaObject;
  exo: TCtObject;
  I, po: Integer;
  S: string;
  field: TCTMetaField;
begin
  Result := False;
  if not Assigned(FCtMetaObjList) then
    raise Exception.Create('FCtMetaObjList not assigned');
  if ckbImportDbTypeNames.Checked then
    S := '[DBTYPENAMES]'
  else
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
  o := FCtMetaDatabase.GetObjInfos(db, obj, FOptStr + S);
  if Assigned(o) then
  begin
    Result := True;

    if ckbComments2DisplayName.Checked and ckbComments2DisplayName.Visible then
      if o is TCtMetaTable then
        with TCtMetaTable(o) do
        begin
          S := Caption;
          if S = '' then
          begin
            S := Memo;
            Caption := TryExtractLogicNameFromMemo(o, S);
            Memo := S;
          end
          else
          begin
            Caption := Memo;
            Memo := S;
          end;
          with MetaFields do
            for I := 0 to Count - 1 do
            begin
              field := Items[I];
              S := field.DisplayName;
              if S = '' then
              begin
                S := field.Memo;
                field.DisplayName := TryExtractLogicNameFromMemo(field, S);
                field.Memo := S;
              end
              else
              begin
                field.DisplayName := field.Memo;
                field.Memo := S;
              end;
            end;
        end;
                             
    exo := FCtMetaObjList.ItemByName(o.Name);

    if ckbAutoCapitalize.Checked and ckbAutoCapitalize.Visible then
    begin
      o.Name := AutoRenameObj(o.Name);
      if o is TCtMetaTable then
        with TCtMetaTable(o).MetaFields do
          for I := 0 to Count - 1 do
            Items[I].Name := AutoRenameObj(Items[I].Name);
    end;

    if Assigned(exo) and ckbOverwriteExists.Checked then
    begin
      if (exo is TCtMetaTable) or (o is TCtMetaTable) then
      begin
        S := TCtMetaTable(exo).GraphDesc;
        TCtMetaTable(exo).AssignFrom(o);
        TCtMetaTable(exo).GraphDesc := S;
        DoMetaPropsChanged(exo, cmctModify);
      end
      else
      begin
        FCtMetaObjList.Remove(exo);
        DoMetaPropsChanged(exo, cmctRemove);
        FCtMetaObjList.Add(o);     
        DoMetaPropsChanged(o, cmctNew);
      end;
    end
    else
    begin
      FCtMetaObjList.Add(o);
      DoMetaPropsChanged(o, cmctNew);
    end;

    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('AFTER_IMP_A_TABLE', db, obj, o, FCtMetaObjList);
    end;
  end;
end;

procedure TfrmImportCtTable.FormShow(Sender: TObject);
begin
  ProgressBar1.Position := 0;
  //if FCtMetaDatabase = nil then
    TimerInit.Enabled := True;
end;

function TfrmImportCtTable.AutoRenameObj(AName: string): string;
begin
  Result := CheckAutoCapitalize(AName);
end;

procedure TfrmImportCtTable.btnCancelClick(Sender: TObject);
begin
  if btnCancel.Caption = srCapCancel then
  begin
    if MessageBox(Handle, PChar(srConfirmAbort),
      PChar(Application.Title), MB_YESNO or MB_ICONQUESTION) = IDYES then
      FAborted := True;
  end
  else
    Close;
end;

procedure TfrmImportCtTable.FormDestroy(Sender: TObject);
begin
  FOrigObjs.Free;
  if Assigned(FCloneMetaDb) then
    FreeAndNil(FCloneMetaDb);
end;

procedure TfrmImportCtTable.combObjFilterChange(Sender: TObject);
  function ObjExistsInDML(tbn: string): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    if tbn = '' then
      Exit;
    for I := FCtMetaObjList.Count - 1 downto 0 do
      if FCtMetaObjList.Items[I].DataLevel <> ctdlDeleted then
        if UpperCase(FCtMetaObjList.Items[I].Name) = UpperCase(tbn) then
        begin
          Result := True;
          Exit;
        end;
  end;

  function CheckKeyword(keyword, aname: string): Boolean;
  begin
    Result := False;    
    if Copy(keyword,1,1)='*' then      
      if Copy(keyword, Length(keyword), 1)='*' then   
        keyword := Copy(keyword, 2, Length(keyword)-2);
    if Copy(keyword,1,1)='*' then
    begin
      keyword := Copy(keyword, 2, Length(keyword));  
      if keyword = Copy(aname, Length(aname)-Length(keyword)+1,Length(keyword)) then
        Result := True;
    end
    else if Copy(keyword, Length(keyword), 1)='*' then
    begin
      keyword := Copy(keyword, 1, Length(keyword)-1);  
      if Pos(keyword, aname)=1 then
        Result := True;
    end
    else if Pos(keyword, aname)>0 then
      Result := True;
  end;

  function FilterMatched(filter, aname: string): Boolean;
  var
    k1, k2: string;
    po: Integer;
  begin
    Result := True;
    k1 := Trim(filter);
    while k1 <> '' do
    begin
      po := Pos(' ', k1);
      if po > 0 then
      begin
        k2 := Trim(Copy(k1, 1, po - 1));
        k1 := Trim(Copy(k1, po + 1, Length(k1)));
      end
      else
      begin
        k2 := Trim(k1);
        k1 := '';
      end;
      if k2='' then
        Continue;
      if Copy(k2,1,1)='-' then
      begin
        k2 := Copy(k2,2,Length(k2));
        if k2='' then
          Continue;      
        if k2='*' then
          Continue;
        if CheckKeyword(k2,aname) then
        begin
          Result := False;
          Exit;
        end;
      end
      else if not CheckKeyword(k2, aname) then
      begin
        Result := False;
        Exit;
      end;
    end;
  end;
  procedure doFilter;
  var
    S: string;
    I: Integer;
  begin
    cklbDbObjs.Items.Text := FOrigObjs.Text;
    S := Trim(LowerCase(combObjFilter.Text));
    if S = '' then
      Exit;
    if combObjFilter.Text = combObjFilter.Items[0] then
      Exit;

    if combObjFilter.Text = combObjFilter.Items[1] then
    begin
      for I := cklbDbObjs.Items.Count - 1 downto 0 do
        if ObjExistsInDML(cklbDbObjs.Items[I]) then
          cklbDbObjs.Items.Delete(I);
      Exit;
    end;

    if combObjFilter.Text = combObjFilter.Items[2] then
    begin
      for I := cklbDbObjs.Items.Count - 1 downto 0 do
        if not ObjExistsInDML(cklbDbObjs.Items[I]) then
          cklbDbObjs.Items.Delete(I);
      Exit;
    end;

    for I := cklbDbObjs.Items.Count - 1 downto 0 do
      if not FilterMatched(S, LowerCase(cklbDbObjs.Items[I])) then
        cklbDbObjs.Items.Delete(I);
    for I := cklbDbObjs.Items.Count - 1 downto 0 do
      cklbDbObjs.Checked[I] := True;
  end;
begin
  cklbDbObjs.Items.BeginUpdate;
  try
    doFilter;
  finally
    cklbDbObjs.Items.EndUpdate;
  end;
  lbTbCount.Caption := Format(srTbCountFmt, [cklbDbObjs.Items.Count]);
end;

end.

