unit wSqlServerDBConfig;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  { TfrmSqlSvrDBConfig }

  TfrmSqlSvrDBConfig = class(TForm)
    btnHelp: TButton;
    btnBrowseDsn: TButton;
    edtDbName: TEdit;
    edtDsnName: TEdit;
    Label1: TLabel;
    edtPort: TEdit;
    Label2: TLabel;
    edtInstName: TEdit;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    combAddr: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbOdbcTip: TLabel;
    MemoOdbcConnStr: TMemo;
    rdbIPAddr: TRadioButton;
    rbdOdbcDsn: TRadioButton;
    rdbOdbcConnStr: TRadioButton;
    procedure btnBrowseDsnClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure rdbIPAddrChange(Sender: TObject);
  private
    { Private declarations }
    procedure SetOdbcEnabled(bEnb: Boolean);
    function GenResult: string;
    procedure CheckControlReadOnly;
  public
    { Public declarations }
    class function DoDBConfig(AString: string; bEnbODBC: Boolean): string;
  end;

var
  frmSqlSvrDBConfig: TfrmSqlSvrDBConfig;

implementation

uses
  CtMetaTable, uFormWindowsOdbcCfg, WindowFuncs, dmlstrs, ezdmlstrs;

{$R *.lfm}

{ TForm1 }

procedure TfrmSqlSvrDBConfig.CheckControlReadOnly;
begin
  if not rdbIPAddr.Checked then
  begin     
    combAddr.ParentColor := True;
    combAddr.Enabled := False;

    edtPort.ParentColor := True;
    edtPort.Enabled := False;

    edtInstName.ParentColor := True;
    edtInstName.Enabled := False;

    edtDbName.ParentColor := True;
    edtDbName.Enabled := False;
  end
  else
  begin               
    combAddr.Color := clWindow;
    combAddr.Enabled := True;

    edtPort.Color := clWindow;
    edtPort.Enabled := True;

    edtInstName.Color := clWindow;
    edtInstName.Enabled := True;

    edtDbName.Color := clWindow;
    edtDbName.Enabled := True;
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

class function TfrmSqlSvrDBConfig.DoDBConfig(AString: string; bEnbODBC: Boolean): string;       
var
  po: Integer;
  V: String;
begin
  with TfrmSqlSvrDBConfig.Create(nil) do
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
      rdbIPAddr.Checked := True;

      V := AString;
      po := Pos('@',V);
      if po > 0 then
      begin
        edtDbName.Text := Copy(V,po+1,Length(V));
        V:=Copy(AString, 1, po-1);
      end
      else
        edtDbName.Text := '';

      po := Pos('\',V);
      if po > 0 then
      begin
        edtInstName.Text := Copy(V,po+1,Length(V));
        V:=Copy(AString, 1, po-1);
      end
      else
         edtInstName.Text := '';
           
      po := Pos(':',V);
      if po > 0 then
      begin
        edtPort.Text := Copy(V,po+1,Length(V));
        V:=Copy(AString, 1, po-1);
      end
      else
         edtPort.Text := '';

      combAddr.Text:=V;
    end;

    SetOdbcEnabled(bEnbODBC);
    CheckControlReadOnly;
    if ShowModal = mrOk then
      Result := GenResult
    else
      Result := '';
  finally
    Free;
  end;
end;

function TfrmSqlSvrDBConfig.GenResult: string;
begin
  Result := '';
  if rdbIPAddr.Checked then
  begin
    if Trim(combAddr.Text) = '' then
      Exit;
    Result := Trim(combAddr.Text);
    if Trim(edtPort.Text) <> '' then
      Result := Result + ':'+ Trim(edtPort.Text);      
    if Trim(edtInstName.Text) <> '' then
      Result := Result + '\'+ Trim(edtInstName.Text);   
    if Trim(edtDbName.Text) <> '' then
      Result := Result + '@'+ Trim(edtDbName.Text);
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


procedure TfrmSqlSvrDBConfig.btnHelpClick(Sender: TObject);
var
  S, V: string;
begin
  if not LangIsChinese then
    S := 'ezdml.com/doc/dblogon.html'
  else
    S := 'ezdml.com/doc/dblogon_cn.html';
  S:=S+'?db=SQLSERVER';
  V := Format(srEzdmlConfirmOpenUrlFmt, [S]);

  if Application.MessageBox(PChar(V),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;

  S := 'http://www.'+S;
  CtOpenDoc(PChar(S));
end;

procedure TfrmSqlSvrDBConfig.btnBrowseDsnClick(Sender: TObject);
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

procedure TfrmSqlSvrDBConfig.rdbIPAddrChange(Sender: TObject);
begin
  CheckControlReadOnly;
end;


procedure TfrmSqlSvrDBConfig.SetOdbcEnabled(bEnb: Boolean);
begin
  if bEnb then
    Exit;
  lbOdbcTip.Visible := True;
  MemoOdbcConnStr.Visible := False;
  rdbOdbcConnStr.Enabled:=False;         
  rbdOdbcDsn.Enabled:=False;
  rdbIPAddr.Checked := True;
end;

end.

 
