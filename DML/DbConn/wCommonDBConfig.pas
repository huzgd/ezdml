unit wCommonDBConfig;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  { TfrmCommDBConfig }

  TfrmCommDBConfig = class(TForm)
    btnBrowseDsn: TButton;
    btnHelp: TButton;
    btnSettings: TButton;
    combSveIp: TComboBox;
    edtDsnName: TEdit;
    Label1: TLabel;
    edtPort: TEdit;
    Label2: TLabel;
    edtDbName: TEdit;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    Label6: TLabel;
    MemoOdbcConnStr: TMemo;
    MemoJdbcConnStr: TMemo;
    rbdOdbcDsn: TRadioButton;
    rdbIPAddr: TRadioButton;
    rdbOdbcConnStr: TRadioButton;
    rdbJdbcConnStr: TRadioButton;
    procedure btnBrowseDsnClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure rdbIPAddrChange(Sender: TObject);
  private
    { Private declarations }
    FDBType: string;
    function GenResult: string;
    procedure CheckControlReadOnly;
  public
    { Public declarations }
    class function DoDBConfig(AString, ADbType: string): string;
  end;

var
  frmCommDBConfig: TfrmCommDBConfig;

implementation

uses
  CtMetaTable, uFormWindowsOdbcCfg, WindowFuncs, dmlstrs, ezdmlstrs;

{$R *.lfm}

{ TForm1 }

class function TfrmCommDBConfig.DoDBConfig(AString, ADbType: string): string;
var
  po: Integer;
  S,V: String;
begin
  with TfrmCommDBConfig.Create(nil) do
  try
    FDBType :=ADbType;
    if FDBType = 'MYSQL' then
    begin                                
      MemoJdbcConnStr.Lines.Text := 'url=jdbc:mysql://192.168.1.1:3306/dbname;';
      MemoOdbcConnStr.Lines.Text := 'Driver=MySQL ODBC 8.0 Driver;Server=MyDbServer;Port=3306;Database={database_name};';
    end
    else if FDBType = 'POSTGRESQL' then
    begin                    
      MemoJdbcConnStr.Lines.Text := 'url=jdbc:postgresql://localhost:5432/dbname;';
      MemoOdbcConnStr.Lines.Text := 'Driver=PostgreSQL Unicode;Server=MyDbServer;Port=5432;Database={database_name};';
    end;
    if Copy(AString, 1,4)='DSN:' then
    begin
      rbdOdbcDsn.Checked := True;
      edtDsnName.Text := Copy(AString, 5, Length(AString));
    end 
    else if Copy(AString, 1, 5)='JDBC:' then
    begin
      rdbJdbcConnStr.Checked := True;
      S := Copy(AString, 6, Length(AString));
      if S<>'' then
        if (Pos(';', S)=0) and (Pos('url=', S)=0) then
        begin
          S:='url='+S;
          if Copy(S, Length(S), 1)<>';' then
            S:=S+';';
        end;
      MemoJdbcConnStr.Lines.Text := S;
    end
    else if Copy(AString, 1, 5)='ODBC:' then
    begin
      rdbOdbcConnStr.Checked := True;
      MemoOdbcConnStr.Lines.Text := Copy(AString, 6, Length(AString));
    end
    else
    begin
      rdbIPAddr.Checked := True;
      if AString <> '' then
      begin
        po := Pos(':',AString);
        if po>0 then
        begin
          combSveIp.Text:=Copy(AString, 1, po-1);
          V:=Copy(AString, po+1, Length(AString));
          po := Pos('@', V);
          if po >0 then
          begin
            edtPort.Text := Copy(V,1,po-1);
            edtDbName.Text := Copy(V,po+1,Length(V));
          end
          else
          begin
            edtPort.Text := V;
            edtDbName.Text := '';
          end;
        end
        else
        begin
          edtPort.Text := '';
          po := Pos('@', AString);
          if po >0 then
          begin
            combSveIp.Text := Copy(AString,1,po-1);
            edtDbName.Text := Copy(AString,po+1,Length(AString));
          end
          else
          begin
            combSveIp.Text := AString;
            edtDbName.Text := '';
          end;
        end;

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

procedure TfrmCommDBConfig.FormCloseQuery(Sender: TObject; var CanClose: boolean
  );
begin
  if ModalResult = mrOk then
    if GenResult = ''  then
      CanClose := False;
end;

procedure TfrmCommDBConfig.rdbIPAddrChange(Sender: TObject);
begin
  CheckControlReadOnly;
end;

procedure TfrmCommDBConfig.btnHelpClick(Sender: TObject);
var
  S, V: string;
begin
  if not LangIsChinese then
    S := 'ezdml.com/doc/dblogon.html'
  else
    S := 'ezdml.com/doc/dblogon_cn.html';
  if FDBType <> '' then
    S:=S+'?db='+FDBType;
  V := Format(srEzdmlConfirmOpenUrlFmt, [S]);

  if Application.MessageBox(PChar(V),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;

  S := 'http://www.'+S;
  CtOpenDoc(PChar(S));
end;

procedure TfrmCommDBConfig.btnBrowseDsnClick(Sender: TObject);
begin
  {$IFDEF Windows}
    with TfrmWindowsOdbcConfg.create(nil) do
    try
      RefreshDSNs;
      if ShowModal = mrOk then
      begin
        edtDsnName.Text := GetSelectedDSN;
      end;
    finally
      Free;
    end;
  {$ELSE}
    ShowMessage('Enter User_or_System_DSN_Name');
  {$ENDIF}
end;

procedure TfrmCommDBConfig.btnSettingsClick(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 10, 4);
end;

function TfrmCommDBConfig.GenResult: string;
var
  S: String;
begin                 
  Result := '';
  if rdbIPAddr.Checked then
  begin
    Result := Trim(combSveIp.Text);
    if Result='' then
      Exit;
    if Trim(edtPort.Text)<>'' then
      Result :=  Result + ':' + Trim(edtPort.Text);
    if Trim(edtDbName.Text)<>'' then
      Result :=  Result + '@' + Trim(edtDbName.Text);
  end    
  else if rdbJdbcConnStr.Checked then
  begin
    if Trim(MemoJdbcConnStr.Lines.Text) = '' then
      Exit;
    S := Trim(MemoJdbcConnStr.Lines.Text); 
    while Copy(S, Length(S),1)=';' do
      Delete(S, Length(S), 1);
    if Copy(S, 1,4)='url=' then
    begin
      if Pos(';', S)=0 then
        S := Copy(S, 5, Length(S));
    end;        
    S:=StringReplace(S, #13#10, ';', [rfReplaceAll]);
    S:=StringReplace(S, #10, ';', [rfReplaceAll]);
    Result := 'JDBC:'+S;
  end
  else if rbdOdbcDsn.Checked then
  begin
    if Trim(edtDsnName.Text) = '' then
      Exit;
    Result := 'DSN:'+Trim(edtDsnName.Text);
  end
  else if rdbOdbcConnStr.Checked then
  begin
    if Trim(MemoOdbcConnStr.Lines.Text) = '' then
      Exit;
    Result := 'ODBC:'+Trim(MemoOdbcConnStr.Lines.Text);
  end;
end;

procedure TfrmCommDBConfig.CheckControlReadOnly;
begin
  if not rdbIPAddr.Checked then
  begin
    combSveIp.ParentColor := True;
    combSveIp.Enabled := False;

    edtPort.ParentColor := True;
    edtPort.Enabled := False;

    edtDbName.ParentColor := True;
    edtDbName.Enabled := False;
  end
  else
  begin
    combSveIp.Color := clWindow;
    combSveIp.Enabled := True;

    edtPort.Color := clWindow;
    edtPort.Enabled := True;

    edtDbName.Color := clWindow;
    edtDbName.Enabled := True;
  end;

  {$ifdef EZDML_LITE}
  rdbJdbcConnStr.Enabled:=False;
  if rdbJdbcConnStr.Checked then
    rdbJdbcConnStr.Checked := False;
  {$endif}
  if not rdbJdbcConnStr.Checked then
  begin
    MemoJdbcConnStr.ParentColor := True;
    MemoJdbcConnStr.Enabled := False;
  end
  else
  begin
    MemoJdbcConnStr.Color := clWindow;
    MemoJdbcConnStr.Enabled := True;
  end;

  if not rbdOdbcDsn.Checked then
  begin
    btnBrowseDsn.Enabled := False;

    edtDsnName.ParentColor := True;
    edtDsnName.Enabled := False;
  end
  else
  begin
    btnBrowseDsn.Enabled := True;

    edtDsnName.Color := clWindow;
    edtDsnName.Enabled := True;
  end;

  if not rdbOdbcConnStr.Checked then
  begin
    MemoOdbcConnStr.ParentColor := True;
    MemoOdbcConnStr.Enabled := False;
  end
  else
  begin
    MemoOdbcConnStr.Color := clWindow;
    MemoOdbcConnStr.Enabled := True;
  end;
end;


end.

 
