unit wHttpJdbcConfig;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  { TfrmHttpJdbcConfig }

  TfrmHttpJdbcConfig = class(TForm)
    btnHelp: TButton;
    btnSettings: TButton;
    btnStartHttpSv: TButton;
    ckbShowJdbcConsole: TCheckBox;
    combDbType: TComboBox;
    edtDriver: TEdit;
    edtJdbcUrl: TEdit;
    edtHttpUrl: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    rdbHttp: TRadioButton;
    rdbJdbc: TRadioButton;
    procedure btnHelpClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnStartHttpSvClick(Sender: TObject);
    procedure combDbTypeCloseUp(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure rdbHttpChange(Sender: TObject);
  private
    { Private declarations }
    function GenResult: string;
    procedure CheckControlReadOnly;
  public
    { Public declarations }
    class function DoDBConfig(AString: string): string;
  end;

var
  frmHttpJdbcConfig: TfrmHttpJdbcConfig;

implementation

uses          
  {$ifdef EZDML_LITE}DmlPasScriptLite, {$endif}
  CtMetaTable, WindowFuncs, EzJdbcConn, DmlScriptPublic, dmlstrs, ezdmlstrs;

{$R *.lfm}


class function TfrmHttpJdbcConfig.DoDBConfig(AString: string): string;
var
  S,drv, dbT,url: String;
begin
  //注意：JDBC需要安装java运行环境，数据库驱动的相关jar包要放入EZDML/jdbc/lib目录。
  with TfrmHttpJdbcConfig.Create(nil) do
  try                
    ckbShowJdbcConsole.Checked := G_ShowJdbcConsole;
    if Copy(AString, 1, 5)='JDBC:' then
    begin
      rdbJdbc.Checked := True;
      S := Copy(AString, 6, Length(AString));
      if Pos(';', S)=0 then
      begin
        combDbType.Text := GetDefaultDbTypeOfUrl(S);          
        edtDriver.Text := GetDefaultDbDriverOfUrl(S);
        edtJdbcUrl.Text := S;
      end
      else
      begin           
        url := ExtractJdbcProp(S, 'url');
        dbt := ExtractJdbcProp(S, 'db');
        if dbt='' then
          dbt := GetDefaultDbTypeOfUrl(url);
        drv := ExtractJdbcProp(S, 'driver');
        if drv='' then
          drv:= GetDefaultDbDriverOfUrl(S);   
        combDbType.Text := dbt;
        edtDriver.Text := drv;
        edtJdbcUrl.Text := url;
      end;
    end
    else
    begin
      rdbHttp.Checked := True;
      if AString <> '' then
      begin
        edtHttpUrl.Text := AString;
      end;
    end;
    CheckControlReadOnly;

    if ShowModal = mrOk then
      Result := GenResult
    else
      Result := '';
  finally
    Free;
  end;
end;

procedure TfrmHttpJdbcConfig.FormCloseQuery(Sender: TObject; var CanClose: boolean
  );
begin
  if ModalResult = mrOk then
    if GenResult = ''  then
      CanClose := False;
end;

procedure TfrmHttpJdbcConfig.FormCreate(Sender: TObject);    
  function GetCtJdbcDropDownItems(items: string): string;
  var
    ss: TStringList;
    S: string;
    I, po: Integer;
  begin
    if Pos('=', items)=0 then
    begin
      Result := items;
      Exit;
    end;

    ss:= TStringList.create;
    try
      ss.Text := items;
      for I:=0 to ss.Count - 1 do
      begin
        S:=ss[I];
        po := Pos('=', S);
        if po>0 then
          ss[I] := Copy(S, 1, po-1);
      end;
      Result := ss.Text;
    finally
      ss.Free;
    end;
  end;
begin
  combDbType.Items.Text := GetCtJdbcDropDownItems(srEzJdbcDriverList);
end;

procedure TfrmHttpJdbcConfig.rdbHttpChange(Sender: TObject);
begin
  CheckControlReadOnly;
end;

procedure TfrmHttpJdbcConfig.btnHelpClick(Sender: TObject);
var
  S, V: string;
begin
  if not LangIsChinese then
    S := 'ezdml.com/doc/dblogon.html'
  else
    S := 'ezdml.com/doc/dblogon_cn.html';
  S:=S+'?db=HTTP_JDBC';
  V := Format(srEzdmlConfirmOpenUrlFmt, [S]);

  if Application.MessageBox(PChar(V),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;

  S := 'http://www.'+S;
  CtOpenDoc(PChar(S));
end;

procedure TfrmHttpJdbcConfig.btnSettingsClick(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 10, 4);
end;

procedure TfrmHttpJdbcConfig.btnStartHttpSvClick(Sender: TObject); 
  function GetJdbcCmdFn: string;
  begin
    Result := GetFolderPathOfAppExe('CustomTools');
    Result:=FolderAddFileName(Result, 'JDBC server.pas');
  end;

  procedure ExecDmlScriptFile();
  var
    FileTxt, AOutput: TStrings;
    fn, S: string;
    bUtf8: Boolean;
    cTb: TCtMetaTable;
  {$ifdef EZDML_LITE}
    ScLt : TDmlPasScriptorLite;
  {$endif}
  begin

  {$ifdef EZDML_LITE}
    ScLt := CreatePsLiteScriptor('JDBC server', 'Tool');
    if ScLt <> nil then
    begin
      AOutput := TStringList.Create;
      try
        with ScLt do
        begin
          Init('DML_SCRIPT', nil, AOutput, nil);
          Exec('DML_SCRIPT', '');
        end;
      finally
        AOutput.Free;
        ScLt.Free;
      end;
      Exit;
    end;
  {$endif}
    fn := GetJdbcCmdFn;
    if not FileExists(fn) then
      raise Exception.Create('Script file not found: ' + fn);

    cTb := nil;

    FileTxt := TStringList.Create;
    AOutput := TStringList.Create;
    with CreateScriptForFile(fn) do
    try
      ActiveFile := fn;
      FileTxt.LoadFromFile(fn);
      S := FileTxt.Text;
      bUtf8 := False;
      if Length(S) > 3 then
        if (Ord(S[1]) = $EF) and (Ord(S[2]) = $BB) and (Ord(S[3]) = $BF) then
        begin
          S := Copy(S, 4, Length(S));
          bUtf8 := True;
        end;
      if not bUtf8 then
        if Pos('UTF-8', UpperCase(S)) >= 0 then
          bUtf8 := True;
      if bUtf8 then
      begin
        S := Utf8Decode(S);
      end;

      Init('DML_SCRIPT', cTb, AOutput, nil);
      Exec('DML_SCRIPT', FileTxt.Text);
    finally
      FileTxt.Free;
      AOutput.Free;
      Free;
    end;
  end;

begin
  ExecDmlScriptFile();
end;

procedure TfrmHttpJdbcConfig.combDbTypeCloseUp(Sender: TObject);
var
  ss: TStringList;
  items, citem, S, res: string;
  I, po: Integer;
begin
  citem := combDbType.Text;
  if citem = '' then
    Exit;
  items := srEzJdbcDriverList;

  res := '';
  ss:= TStringList.create;
  try
    ss.Text := items;
    for I:=0 to ss.Count - 1 do
    begin
      S:=ss[I];
      po := Pos('=', S);
      if po>0 then
        if citem=Copy(S, 1, po-1) then
        begin
          res := Copy(S, po+1,Length(S));
          Break;
        end;
    end;
  finally
    ss.Free;
  end;
  if res='' then
    Exit;
  edtDriver.Text := ExtractJdbcProp(res, 'driver');
  edtJdbcUrl.Text := ExtractJdbcProp(res, 'url');
end;

function TfrmHttpJdbcConfig.GenResult: string;
var
  S, drv, dbTp: String;
begin                 
  Result := '';
  if rdbHttp.Checked then
  begin
    Result := Trim(edtHttpUrl.Text);
  end    
  else if rdbJdbc.Checked then
  begin           
    G_ShowJdbcConsole := ckbShowJdbcConsole.Checked;
    S := Trim(edtJdbcUrl.Text);
    dbTp := GetDefaultDbTypeOfUrl(S);
    drv := GetDefaultDbDriverOfUrl(S);
    if Trim(combDbType.Text)<>'' then
      if dbTp <> Trim(combDbType.Text) then
        Result := Result+'db='+Trim(combDbType.Text)+';'; 
    if Trim(edtDriver.Text)<>'' then
      if drv <> Trim(edtDriver.Text) then
        Result := Result+'driver='+Trim(edtDriver.Text)+';';

    if Result='' then
      Result := S
    else
      Result := Result+'url='+S;
    Result := 'JDBC:'+Result;
  end;
end;

procedure TfrmHttpJdbcConfig.CheckControlReadOnly;
begin
  if not rdbHttp.Checked then
  begin
    btnStartHttpSv.Enabled := False;

    edtHttpUrl.ParentColor := True;
    edtHttpUrl.Enabled := False;
  end
  else
  begin
    btnStartHttpSv.Enabled := True;

    edtHttpUrl.Color := clWindow;
    edtHttpUrl.Enabled := True;
  end;
        
  {$ifdef EZDML_LITE}
  rdbJdbc.Enabled:=False;
  if rdbJdbc.Checked then
    rdbJdbc.Checked := False;
  {$endif}
  if not rdbJdbc.Checked then
  begin
    combDbType.Enabled := False;
    edtDriver.ParentColor := True;
    edtDriver.Enabled := False;
    edtJdbcUrl.ParentColor := True;
    edtJdbcUrl.Enabled := False; 
    ckbShowJdbcConsole.Enabled := False;
  end
  else
  begin
    combDbType.Enabled := True;
    edtDriver.Color := clWindow;
    edtDriver.Enabled := True;
    edtJdbcUrl.Color := clWindow;
    edtJdbcUrl.Enabled := True;
    ckbShowJdbcConsole.Enabled := True;
  end;

end;


end.

 
