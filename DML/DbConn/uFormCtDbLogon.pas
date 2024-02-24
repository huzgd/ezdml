unit uFormCtDbLogon;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, Menus;

type

  { TfrmLogonCtDB }

  TfrmLogonCtDB = class(TForm)
    btnHelp: TButton;
    btnSettings: TButton;
    Label1: TLabel;
    combDbType: TComboBox;
    Label2: TLabel;
    edtUserName: TEdit;
    lbConnectingTip: TLabel;
    Label_Pwd: TLabel;
    edtPassword: TEdit;
    Label4: TLabel;
    combDBName: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnDBCfg: TButton;
    ckbSavePwd: TCheckBox;
    ckbAutoLogin: TCheckBox;
    PanelAutoLoginTip: TPanel;
    TimerAutoLogin: TTimer;
    btnLogonHist: TButton;
    PopupMenuLogonHist: TPopupMenu;
    procedure btnCancelClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure combDBNameCloseUp(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure combDbTypeChange(Sender: TObject);
    procedure btnDBCfgClick(Sender: TObject);
    procedure Label_PwdDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbConnectingTipClick(Sender: TObject);
    procedure TimerAutoLoginTimer(Sender: TObject);
    procedure ckbSavePwdClick(Sender: TObject);
    procedure btnLogonHistClick(Sender: TObject);
  private
    { Private declarations }
    FLogonHistories: TStringList;
    FCurConnDbNames: string;
    procedure _OnLogonHistMenuItemClicked(Sender: TObject);  
    procedure DoConnectDb(bForceReConnect: Boolean);
    procedure DisableAutoLogin;
    procedure RegenCombDbDropdownList;
  public
    { Public declarations }
    procedure GetLastDbLogonInfo(dbTypeNeeded: Boolean);
    procedure AddLogonHistory(his: string);
    procedure SetLogonHistoryToDb(his: string; adb: TObject);
  end;

function ExecCtDbLogon: Integer;
function DoExecCtDbLogon(DbType, database, username, password: String;
  bSavePwd, bAutoLogin, bShowDialog: Boolean; opt: String): String;
function GetLastCtDbConn(bMustConnected: Boolean = True): Integer;
function GetLastCtDbType: string;
function GetLastCtDbIdentStr: string;
function ExtractFileDbIdentStr(fn: string): string;
function CanAutoShowLogin: Boolean;  
function IsCtDbConnected: Boolean;
function DoExecSql(sql, opts: string): TDataSet;

var
  frmLogonCtDB: TfrmLogonCtDB;
  F_DbAutoLogonDone: Boolean = False;

implementation

uses CtMetaTable, IniFiles, WindowFuncs, dmlstrs, ezdmlstrs;

{$R *.lfm}

const
  c1 = 53147;
  c2 = 24016;

function EncryptStr(const S: string; Key: Word): string;
var
  I: Integer;
  P: Word;
  L: Int64;
  W: PWord;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    P := Word(S[I]) xor ((Key shr 8) and 127);
    Result := Result + IntToHex(P, 2);

    L := P + Key;
    L := L * c1 + c2;
    W := @L;
    Key := W^;
  end;
end;

function DecryptStr(const S: string; Key: Word): string;
var
  I, N: Integer;
  P, Q: Word;
  L: Int64;
  W: PWord;
begin
  Result := '';
  N := Length(S) div 2;
  for I := 1 to N do
  begin
    P := StrToIntDef('$' + Copy(S, I * 2 - 1, 2), 0);
    Q := P xor ((Key shr 8) and 127);
    Result := Result + Char(Q);

    L := P + Key;
    L := L * c1 + c2;
    W := @L;
    Key := W^;
  end;
end;

function ExecCtDbLogon: Integer;
begin
  if not Assigned(frmLogonCtDB) then
    frmLogonCtDB := TfrmLogonCtDB.Create(Application);
  frmLogonCtDB.GetLastDbLogonInfo(False);
  if frmLogonCtDB.ShowModal = mrOk then
    Result := frmLogonCtDB.combDBType.ItemIndex
  else
    Result := -1;
end;
  
function DoExecCtDbLogon(DbType, database, username, password: String;
  bSavePwd, bAutoLogin, bShowDialog: Boolean; opt: String): String;
var
  bForceReconn: Boolean;
begin
  Result := '';
  if not Assigned(frmLogonCtDB) then
    frmLogonCtDB := TfrmLogonCtDB.Create(Application);
  frmLogonCtDB.GetLastDbLogonInfo(False);

  bForceReconn := False;

  if DbType <> '' then
    with frmLogonCtDB do
    begin
      combDbType.ItemIndex := combDbType.Items.IndexOf(DbType);
      combDBName.Text := database;
      edtUserName.Text := username;
      edtPassword.Text := password;
      ckbSavePwd.Checked := bSavePwd;
      ckbAutoLogin.Checked := bAutoLogin;
      bForceReconn := True;
    end;
  if Pos('[FORCE_RECONNECT]', opt) > 0 then
    bForceReconn := True;
  if not bShowDialog then
    frmLogonCtDB.DoConnectDb(bForceReconn)
  else if frmLogonCtDB.ShowModal = mrOk then
    Result := GetLastCtDbType;
end;

function GetLastCtDbConn(bMustConnected: Boolean): Integer;
var
  I: Integer;
begin
  Result := -1;

  if not Assigned(frmLogonCtDB) then
    frmLogonCtDB := TfrmLogonCtDB.Create(Application);

  frmLogonCtDB.GetLastDbLogonInfo(False);

  I := frmLogonCtDB.combDbType.ItemIndex;
  if I < 0 then
    Exit;

  if CtMetaDBRegs[i].DbImpl = nil then
    Exit;

  if bMustConnected then
    if not CtMetaDBRegs[i].DbImpl.Connected then
      Exit;

  Result := i;
end;

function GetLastCtDbType: string;
var
  idx: Integer;
begin
  idx := GetLastCtDbConn(False);
  if idx >= 0 then
    Result := CtMetaDBRegs[idx].DbImpl.EngineType
  else
    Result := '';
end;
           
function GetLastCtDbIdentStr: string;
var
  idx: Integer;
begin
  idx := GetLastCtDbConn(False);
  if idx >= 0 then
    Result := CtMetaDBRegs[idx].DbImpl.GetIdentStr
  else
    Result := '';
end;

function ExtractFileDbIdentStr(fn: string): string;
var
  po: Integer;
begin
  Result := '';
  if Pos('db://', fn) <> 1 then
    Exit;
  fn := Copy(fn, 6, Length(fn));
  po := Pos('/', fn);
  if po>0 then
  begin
    Result := Copy(fn, 1, po-1);
  end;
end;

function CanAutoShowLogin: Boolean;
var
  ini: TIniFile;
begin
  Result := False;
  if Assigned(FGlobeDataModelList) then
  begin
    ini := TIniFile.Create(GetConfFileOfApp);
    try
      Result := ini.ReadBool('DbConn', 'AutoLogin', False);
    finally
      ini.Free;
    end;
  end;
end;

function IsCtDbConnected: Boolean;
begin
  if GetLastCtDbConn < 0 then
    Result := False
  else
    Result := True;
end;

function DoExecSql(sql, opts: string): TDataSet;
var
  I: Integer;
  db: TCtMetaDatabase;
begin
  Result := nil;
  I := GetLastCtDbConn;
  if (I < 0) then
    I := ExecCtDbLogon;
  if I >= 0 then
  begin
    db := CtMetaDBRegs[I].DbImpl;
    Result := db.OpenTable(sql, '[ISSQL]' + opts);
  end;
end;

procedure TfrmLogonCtDB.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FLogonHistories := TStringList.Create;
  with combDbType.Items do
  begin
    Clear;
    for I := 0 to High(CtMetaDBRegs) do
      Add(CtMetaDBRegs[I].DbEngineType);

    GetLastDbLogonInfo(True);

    if (Count > 0) and (combDbType.ItemIndex < 0) then
      combDbType.ItemIndex := 0;

    combDbTypeChange(nil);
  end;
end;

procedure TfrmLogonCtDB.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLogonHistories);
  if frmLogonCtDB = Self then
    frmLogonCtDB := nil;
end;

procedure TfrmLogonCtDB.FormShow(Sender: TObject);
var
  I: Integer;
begin
  if not ckbAutoLogin.Checked then
    Exit;
  if not ckbSavePwd.Checked then
    Exit;

  if (GetKeyState(VK_SHIFT) and $80) <> 0 then
    Exit;

  I := combDbType.ItemIndex;
  if I < 0 then
    Exit;
  if CtMetaDBRegs[I].DbImpl = nil then
    Exit;  
  if F_DbAutoLogonDone then
    Exit;

  with CtMetaDBRegs[I].DbImpl do
  begin
    if Connected then
      Exit;
    if Database = '' then
      Exit;
    if User = '' then
      Exit;
  end;

  btnOK.Enabled := False;
  PanelAutoLoginTip.Visible:=True;
  ckbSavePwd.Visible := False;

  TimerAutoLogin.Enabled := True;
  F_DbAutoLogonDone := True;
end;

procedure TfrmLogonCtDB.lbConnectingTipClick(Sender: TObject);
begin
  FormClick(nil);
end;

procedure TfrmLogonCtDB.GetLastDbLogonInfo(dbTypeNeeded: Boolean);
var
  I, J, C: Integer;
  S: string;
  db: TCtMetaDatabase;
  ini: TIniFile;
begin
  if Assigned(FGlobeDataModelList) then
  begin

    ini := TIniFile.Create(GetConfFileOfApp);
    try
      CtCurMetaDbName := ini.ReadString('DbConn', 'CtCurMetaDbName', '');
      ckbSavePwd.Checked := ini.ReadBool('DbConn', 'SavePwd', False);
      ckbAutoLogin.Checked := ini.ReadBool('DbConn', 'AutoLogin', False);
      ckbAutoLogin.Enabled := ckbSavePwd.Checked;

      if dbTypeNeeded then
      begin
        S := '';
        if Assigned(FGlobeDataModelList.CurDataModel) then
          S := FGlobeDataModelList.CurDataModel.DbConnectStr;
        if S = '' then
          S := CtCurMetaDbName;
        if S <> '' then
        begin
          for I := 0 to High(CtMetaDBRegs) do
            if (CtMetaDBRegs[I].DbImpl <> nil) and (CtMetaDBRegs[I].DbImpl.ClassName = S) then
            begin
              combDbType.ItemIndex := I;
              Break;
            end;
        end;
      end;

      for J := 0 to High(CtMetaDBRegs) do
      begin
        db := CtMetaDBRegs[J].DbImpl;
        if db = nil then
          Continue;
        if db.Database <> '' then
          Continue;

        S := Ini.ReadString('DbConn', db.ClassName, '');
        SetLogonHistoryToDb(S, db);
      end;

      FLogonHistories.Clear;
      C := ini.ReadInteger('DbLogonHistory', 'Count', 0);
      for I := 0 to C - 1 do
      begin
        S := ini.ReadString('DbLogonHistory', 'Item' + IntToStr(I), '');
        if Trim(S) <> '' then
          FLogonHistories.Add(S);
      end;

    finally
      ini.Free;
    end;
  end;
end;

procedure TfrmLogonCtDB.Label_PwdDblClick(Sender: TObject);
begin
  edtPassword.Text := edtUserName.Text;
end;

procedure TfrmLogonCtDB.SetLogonHistoryToDb(his: string; adb: TObject);
var
  po: Integer;
  S, U, P: string;
  db: TCtMetaDatabase;
begin
  if Trim(his) = '' then
    Exit;
  S := his;

  po := Pos('@', S);
  if po > 0 then
  begin
    U := Copy(S, 1, po - 1);
    S := Copy(S, po + 1, Length(S));
  end
  else
  begin
    U := '';
  end;
  po := Pos('||', S);
  if po > 0 then
  begin
    P := Copy(S, po + 2, Length(S));
    S := Copy(S, 1, po - 1);
  end
  else
  begin
    po := Pos('/', U);
    if po = 0 then
    begin
      P := '';
    end
    else
    begin
      P := Copy(U, po + 1, Length(U));
      U := Copy(U, 1, po - 1);
    end;
  end;

  if P <> '' then
  begin
    P := WindowFuncs.WideCodeNarrow(P);
    P := DecryptStr(P, 8915);
    P := Copy(P, 5, Length(P));
  end;
  if S <> '' then
  begin
    if adb <> nil then
    begin    
      db := TCtMetaDatabase(adb);
      db.Database := S;
      db.User := U;
      db.Password := P;
    end
    else
    begin
      if combDBName.Text <> S then
      begin
        combDBName.Text := S;
      end;
      edtUserName.Text := U;
      edtPassword.Text := P;
    end;
  end;
end;

procedure TfrmLogonCtDB.TimerAutoLoginTimer(Sender: TObject);
var
  I: Integer;
begin
  TimerAutoLogin.Enabled := False;
  try

    if not ckbAutoLogin.Checked then
      Exit;
    if not ckbSavePwd.Checked then
      Exit;

    if (GetKeyState(VK_SHIFT) and $80) <> 0 then
      Exit;

    I := combDbType.ItemIndex;
    if I < 0 then
      Exit;
    if CtMetaDBRegs[I].DbImpl = nil then
      Exit;

    with CtMetaDBRegs[I].DbImpl do
    begin
      if Connected then
        Exit;
      if Database = '' then
        Exit;
      if User = '' then
        Exit;
    end;
                     
    ckbSavePwd.Visible := False;
    PanelAutoLoginTip.Show;
    PanelAutoLoginTip.BringToFront;
    Self.btnOKClick(nil);
  finally                  
    ckbSavePwd.Visible := True;
    PanelAutoLoginTip.Visible := False;
    if ModalResult <> mrOk then
    begin
      btnOK.Enabled := True;
    end;
  end;
end;

procedure TfrmLogonCtDB._OnLogonHistMenuItemClicked(Sender: TObject);
var
  I, po: Integer;
  S, sDb: string;
begin
  if Sender = nil then
    Exit;
  I := TComponent(Sender).Tag;
  if (I >= 0) and (I < FLogonHistories.Count) then
  begin
    S := FLogonHistories[I];
    po := Pos(':', S);
    if po = 0 then
      Exit;
    sDb := Copy(S, 1, po - 1);
    S := Copy(S, po + 1, Length(S));

    for I := 0 to High(CtMetaDBRegs) do
      if (CtMetaDBRegs[I].DbImpl <> nil) and (CtMetaDBRegs[I].DbImpl.OrigEngineType = sDb) then
      begin
        SetLogonHistoryToDb(S, CtMetaDBRegs[I].DbImpl);
        combDbType.ItemIndex := I;
        combDbTypeChange(nil);
        Break;
      end;

  end;
end;

procedure TfrmLogonCtDB.DoConnectDb(bForceReConnect: Boolean);
var
  I: Integer;
  ini: TIniFile;
  S, P, his: string;
begin
  I := combDbType.ItemIndex;
  if I < 0 then
    Exit;
  if CtMetaDBRegs[I].DbImpl = nil then
    raise Exception.Create('Not supported connection type');
  if not bForceReConnect then
    if CtMetaDBRegs[I].DbImpl.Connected then
      Exit;
                                   
  CtCurMetaDbConn := nil;
  try
    CtMetaDBRegs[I].DbImpl.Connected := False;
  except
    //Application.HandleException(Self);
  end;
  CtMetaDBRegs[I].DbImpl.Database := combDBName.Text;
  CtMetaDBRegs[I].DbImpl.User := edtUserName.Text;
  CtMetaDBRegs[I].DbImpl.Password := edtPassword.Text;
  if Assigned(FGlobeDataModelList) then
  begin
    FGlobeDataModelList.CurDataModel.DefDbEngine := CtMetaDBRegs[I].DbImpl.EngineType;
    CtCurMetaDbName := CtMetaDBRegs[I].DbImpl.ClassName;
    FGlobeDataModelList.CurDataModel.DbConnectStr := CtCurMetaDbName;
  end;
  try   
    CtMetaDBRegs[I].DbImpl.Connected := True;
  finally
    if not CtMetaDBRegs[I].DbImpl.Connected then
      DisableAutoLogin;
  end;
  CtCurMetaDbConn := CtMetaDBRegs[I].DbImpl;

  his := '';
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    if ckbSavePwd.Checked then
    begin
      P := WindowFuncs.WideCodeNarrow(Copy(CtGenGUID, 2, 8));
      P := EncryptStr(P + edtPassword.Text, 8915);
      P := WindowFuncs.StringExtToWideCode(P);
      if P <> '' then
        P := '||' + P;
    end
    else
      P := '';
    S := CtMetaDBRegs[I].DbImpl.User + '@' + CtMetaDBRegs[I].DbImpl.Database + P;
    his := CtMetaDBRegs[I].DbImpl.OrigEngineType + ':' + S;

    Ini.WriteString('DbConn', CtMetaDBRegs[I].DbImpl.ClassName, S);
    ini.WriteString('DbConn', 'CtCurMetaDbName', CtCurMetaDbName);
    ini.WriteBool('DbConn', 'SavePwd', ckbSavePwd.Checked);
    ini.WriteBool('DbConn', 'AutoLogin', ckbAutoLogin.Checked);
  finally
    ini.Free;
  end;
  if his<>'' then
    AddLogonHistory(his);
  ModalResult := mrOk;
end;

procedure TfrmLogonCtDB.DisableAutoLogin;
var
  ini: TIniFile;
begin
  ckbAutoLogin.Checked := False;
  ini := TIniFile.Create(GetConfFileOfApp);
  try                                       
    if ini.ReadBool('DbConn', 'AutoLogin', False) then
      ini.WriteBool('DbConn', 'AutoLogin', False);
  finally
    ini.Free;
  end;
end;

procedure TfrmLogonCtDB.RegenCombDbDropdownList;

  procedure AddHistDsCombo;
  var
    I, po: Integer;
    Db, S: String;
  begin
    db := combDbType.Text;
    if db='' then
      Exit;
    for I := 0 to FLogonHistories.Count - 1 do
    begin
      S := FLogonHistories[I];
      if Trim(S) <> '' then
      begin
        po := Pos('||', S);
        if po > 0 then
        begin
          S := Copy(S, 1, po - 1);
        end;
        if Trim(S) <> '' then
          if Pos(db+':', S)=1 then
          begin
            S := Copy(S, Length(db+':')+1, Length(S));
            po := Pos('@', S);
            if po=1 then
              S := Copy(S, po+1, Length(S));
            combDBName.Items.AddObject(S, TObject(PtrInt(10000+I)));
          end;
      end;
    end;
  end;

var
  ss: TStringList;
  I: Integer;
  S: String;
begin
  combDBName.Items.Clear;
  AddHistDsCombo; 
  ss:= TStringList.Create;
  try
    ss.Text := FCurConnDbNames;
    for I:=0 to ss.Count - 1 do
    begin
      S := ss[I];
      if S<>'' then
      begin
        if combDBName.Items.IndexOf(S)<0 then
          combDBName.Items.Add(S);
      end;
    end;
  finally
    ss.Free;
  end;
end;

procedure TfrmLogonCtDB.btnLogonHistClick(Sender: TObject);
var
  I, po: Integer;
  S: string;
  mn: TMenuItem;
  pt: TPoint;
begin        
  FormClick(nil);
  PopupMenuLogonHist.Items.Clear;
  for I := 0 to FLogonHistories.Count - 1 do
  begin
    S := FLogonHistories[I];
    if Trim(S) <> '' then
    begin
      po := Pos('||', S);
      if po > 0 then
      begin
        S := Copy(S, 1, po - 1);
      end;
      if Trim(S) <> '' then
      begin
        if Length(S) > 64 then
          S := Copy(S, 1, 62) + '..';
        mn := TMenuItem.Create(PopupMenuLogonHist);
        mn.Caption := S;
        mn.Tag := I;
        mn.OnClick := Self._OnLogonHistMenuItemClicked;
        PopupMenuLogonHist.Items.Add(mn);
      end;
    end;
  end;

  pt := btnLogonHist.ClientToScreen(Point(0, btnLogonHist.Height));
  PopupMenuLogonHist.Popup(pt.X, pt.Y);
end;

procedure TfrmLogonCtDB.ckbSavePwdClick(Sender: TObject);
begin
  ckbAutoLogin.Enabled := ckbSavePwd.Checked;
end;

procedure TfrmLogonCtDB.combDbTypeChange(Sender: TObject);
var
  I: Integer;
begin
  I := combDbType.ItemIndex;
  if (I >= 0) and (CtMetaDBRegs[I].DbImpl <> nil) then
  begin
    combDBName.Enabled := True;
    combDBName.Color := clWindow;
    edtUserName.Color := clWindow;
    edtUserName.ReadOnly := False;
    edtPassword.Color := clWindow;
    edtPassword.ReadOnly := False;

    combDBName.Text := CtMetaDBRegs[I].DbImpl.Database;
    edtUserName.Text := CtMetaDBRegs[I].DbImpl.User;
    edtPassword.Text := CtMetaDBRegs[I].DbImpl.Password;
    if edtPassword.Text <> '' then
      ckbSavePwd.Checked := True
    else
      ckbSavePwd.Checked := False;
         
    try
      FCurConnDbNames := CtMetaDBRegs[I].DbImpl.GetDbNames;
    except
    end;
    RegenCombDbDropdownList;
  end
  else
  begin
    combDBName.Enabled := False;
    combDBName.ParentColor := True;
    edtUserName.ParentColor := True;
    edtUserName.ReadOnly := True;
    edtPassword.ParentColor := True;
    edtPassword.ReadOnly := True;
  end;
end;

procedure TfrmLogonCtDB.FormClick(Sender: TObject);
begin                             
  if TimerAutoLogin.Enabled then
    DisableAutoLogin;

  TimerAutoLogin.Enabled := False;
  ckbSavePwd.Visible := True;
  PanelAutoLoginTip.Visible := False;
  btnOK.Enabled := True;
end;

procedure TfrmLogonCtDB.btnOKClick(Sender: TObject);
var
  I: Integer;
  S: String;
begin
  I := combDbType.ItemIndex;
  if I < 0 then
    Exit;
  if CtMetaDBRegs[I].DbImpl = nil then
    raise Exception.Create('Not supported connection type')
  else
  begin
    btnOK.Enabled := False;
    btnCancel.Enabled := False;
    S := Caption;
    try
      Caption := lbConnectingTip.Caption;
      DoConnectDb(True);
    finally                    
      Caption := S;
      btnOK.Enabled := True;
      btnCancel.Enabled := True;
    end;
  end;
end;

procedure TfrmLogonCtDB.btnSettingsClick(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 10, 4);
end;

procedure TfrmLogonCtDB.combDBNameCloseUp(Sender: TObject);
var
  I, po: Integer;
  S: string;
  obj: TObject;
begin
  I := combDBName.ItemIndex;
  if I=-1 then
    Exit;
  Obj := combDBName.Items.Objects[I];
  if Obj=nil then
    Exit;
  I := Integer(Obj);
  if I<10000 then
    Exit;
  I := I-10000;
  if I>= FLogonHistories.Count then
    Exit;

  S := FLogonHistories[I];
  po := Pos(':', S);
  if po = 0 then
    Exit;
  S := Copy(S, po + 1, Length(S));

  SetLogonHistoryToDb(S, nil);

end;

procedure TfrmLogonCtDB.btnHelpClick(Sender: TObject);
var
  S, V: string;
begin
  if not LangIsChinese then
    S := 'ezdml.com/doc/dblogon.html'
  else
    S := 'ezdml.com/doc/dblogon_cn.html';
  S:=S+'?db='+combDbType.Text;
  V := Format(srEzdmlConfirmOpenUrlFmt, [S]);

  if Application.MessageBox(PChar(V),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;

  S := 'http://www.'+S;
  CtOpenDoc(PChar(S)); { *Converted from ShellExecute* }
end;

procedure TfrmLogonCtDB.btnCancelClick(Sender: TObject);
begin
  if TimerAutoLogin.Enabled then
  begin
    FormClick(nil);
  end else
  begin
    ModalResult := mrCancel;
  end;
end;


procedure TfrmLogonCtDB.AddLogonHistory(his: string);
var
  I, C, po: Integer;
  ini: TIniFile;
  S1, S2: string;
begin
  if Trim(his) = '' then
    Exit;

  S1 := his;
  po := Pos('||', S1);
  if po > 0 then
    S1 := Copy(S1, 1, po - 1);

  C := FLogonHistories.Count;
  for I := C - 1 downto 0 do
  begin

    S2 := FLogonHistories[I];
    po := Pos('||', S2);
    if po > 0 then
      S2 := Copy(S2, 1, po - 1);

    if LowerCase(S1) = LowerCase(S2) then
      FLogonHistories.Delete(I);
  end;

  FLogonHistories.Insert(0, his);

  ini := TIniFile.Create(GetConfFileOfApp);
  try
    C := FLogonHistories.Count;
    ini.WriteInteger('DbLogonHistory', 'Count', C);
    for I := 0 to C - 1 do
    begin
      ini.WriteString('DbLogonHistory', 'Item' + IntToStr(I), FLogonHistories[I]);
    end;
  finally
    ini.Free;
  end;
  RegenCombDbDropdownList;
end;

procedure TfrmLogonCtDB.btnDBCfgClick(Sender: TObject);
var
  I: Integer;
begin
  FormClick(nil);
  I := combDbType.ItemIndex;
  if (I >= 0) and (CtMetaDBRegs[I].DbImpl <> nil) then
  begin
    if combDBName.Text <> '' then
      CtMetaDBRegs[I].DbImpl.Database := combDBName.Text;
    if CtMetaDBRegs[I].DbImpl.ShowDBConfig(System.THandle(Self.Handle)) then
    begin
      combDBName.Text := CtMetaDBRegs[I].DbImpl.Database;
      if CtMetaDBRegs[I].DbImpl.User <> '' then
        edtUserName.Text := CtMetaDBRegs[I].DbImpl.User;
      if CtMetaDBRegs[I].DbImpl.Password <> '' then
        edtPassword.Text := CtMetaDBRegs[I].DbImpl.Password;
    end;
  end;
end;


initialization
  Proc_GetLastCtDbType := GetLastCtDbType; 
  Proc_ExecCtDbLogon := DoExecCtDbLogon;
  Proc_ExecSql := DoExecSql;

end.

