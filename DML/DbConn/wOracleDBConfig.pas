unit wOracleDBConfig;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  { TfrmOraDBConfig }

  TfrmOraDBConfig = class(TForm)
    btnBrowseDsn: TButton;
    btnHelp: TButton;
    btnSettings: TButton;
    edtDsnName: TEdit;
    Label1: TLabel;
    edtIP: TEdit;
    edtPort: TEdit;
    Label2: TLabel;
    edtSvcName: TEdit;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    combNetSvcName: TComboBox;
    Label4: TLabel;
    Label6: TLabel;
    MemoOdbcConnStr: TMemo;
    rbdOdbcDsn: TRadioButton;
    rdbNetSvc: TRadioButton;
    rdbOdbcConnStr: TRadioButton;
    rdbSvcParam: TRadioButton;
    procedure btnBrowseDsnClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure rdbNetSvcClick(Sender: TObject);
    procedure rdbSvcParamClick(Sender: TObject);
  private
    { Private declarations }
    function GenResult: string;
    procedure CheckControlReadOnly;
  public
    { Public declarations }
    class function DoOracleNetConfig(AString: string): string;
  end;

var
  frmOraDBConfig: TfrmOraDBConfig;

implementation

uses
  CtMetaTable, uFormWindowsOdbcCfg, WindowFuncs, dmlstrs, ezdmlstrs;

{$R *.lfm}

{ TForm1 }

procedure TfrmOraDBConfig.CheckControlReadOnly;
begin
  if rdbNetSvc.Checked then
  begin
    combNetSvcName.Color := clWindow;
    combNetSvcName.Enabled := True;
    edtIP.ParentColor := True;
    edtIP.Enabled := False;
    edtPort.ParentColor := True;
    edtPort.Enabled := False;
    edtSvcName.ParentColor := True;
    edtSvcName.Enabled := False;
    Label4.Enabled := True;
  end
  else if rdbSvcParam.Checked then
  begin
    combNetSvcName.ParentColor := True;
    combNetSvcName.Enabled := False;
    edtIP.Color := clWindow;
    edtIP.Enabled := True;
    edtPort.Color := clWindow;
    edtPort.Enabled := True;
    edtSvcName.Color := clWindow;
    edtSvcName.Enabled := True;    
    Label4.Enabled := True;
  end
  else
  begin
    combNetSvcName.ParentColor := True;
    combNetSvcName.Enabled := False; 
    edtIP.ParentColor := True;
    edtIP.Enabled := False;
    edtPort.ParentColor := True;
    edtPort.Enabled := False;
    edtSvcName.ParentColor := True;
    edtSvcName.Enabled := False; 
    Label4.Enabled := False;
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

class function TfrmOraDBConfig.DoOracleNetConfig(AString: string): string;
var
  po: Integer;
  V: string;
begin
  with TfrmOraDBConfig.Create(nil) do
  try                    
    if Copy(AString, 1,4)='DSN:' then
    begin
      rbdOdbcDsn.Checked := True;
      edtDsnName.Text := Copy(AString, 5, Length(AString));
    end
    else if Copy(AString, 1, 5)='ODBC:' then
    begin
      rdbOdbcConnStr.Checked := True;
      MemoOdbcConnStr.Lines.Text := Copy(AString, 6, Length(AString));
    end
    else
    begin
      combNetSvcName.Text := AString;
      edtIP.Text := ExtractCompStr(AString, '(HOST = ', ')', True, '');
      edtPort.Text := ExtractCompStr(AString, '(PORT = ', ')', True, edtPort.Text);
      edtSvcName.Text := ExtractCompStr(AString, '(SERVICE_NAME = ', ')', True);
      if edtIP.Text <> '' then
        rdbSvcParam.Checked := True
      else if (Pos('(HOST', AString)=0) and (Pos('/', AString)>0) then
      begin
        V := AString;
        po := Pos('/', V);
        if po>0 then
        begin
          edtSvcName.Text := Copy(V, po+1, Length(V));
          V:= Copy(V,1,po-1);
        end;
        po := Pos(':', V);
        if po>0 then
        begin
          edtPort.Text := Copy(V, po+1, Length(V));
          V:= Copy(V,1,po-1);
        end;
        edtIP.Text := V;
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

function TfrmOraDBConfig.GenResult: string;
begin
  Result := '';

  if rdbNetSvc.Checked then
    Result := combNetSvcName.Text
  else if rdbSvcParam.Checked then
  begin
    Result := edtIP.Text + ':' + edtPort.Text + '/' + edtSvcName.Text;
   // Result := '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ' +
     // edtIP.Text + ')(PORT = ' + edtPort.Text + ')) ) (CONNECT_DATA = (SERVICE_NAME = ' + edtSvcName.Text + ') ) )';
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


procedure TfrmOraDBConfig.FormCloseQuery(Sender: TObject; var CanClose: boolean
  );
begin
  if ModalResult = mrOk then
    if GenResult = ''  then
      CanClose := False;
end;

procedure TfrmOraDBConfig.btnHelpClick(Sender: TObject);
var
  S, V: string;
begin
  if not LangIsChinese then
    S := 'ezdml.com/doc/dblogon.html'
  else
    S := 'ezdml.com/doc/dblogon_cn.html';
  S:=S+'?db=ORACLE';
  V := Format(srEzdmlConfirmOpenUrlFmt, [S]);

  if Application.MessageBox(PChar(V),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;

  S := 'http://www.'+S;
  CtOpenDoc(PChar(S));
end;

procedure TfrmOraDBConfig.btnBrowseDsnClick(Sender: TObject);
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

procedure TfrmOraDBConfig.btnSettingsClick(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 10, 4);
end;

procedure TfrmOraDBConfig.rdbNetSvcClick(Sender: TObject);
begin
  CheckControlReadOnly;
end;

procedure TfrmOraDBConfig.rdbSvcParamClick(Sender: TObject);
begin
  CheckControlReadOnly;
end;

end.

 
