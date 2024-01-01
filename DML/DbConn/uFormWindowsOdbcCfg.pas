unit uFormWindowsOdbcCfg;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmWindowsOdbcConfg }

  TfrmWindowsOdbcConfg = class(TForm)
    btnConfigDSN: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    ckbSystemDSN: TRadioButton;
    Label1: TLabel;
    ckbUserDSN: TRadioButton;
    ListBoxDSNs: TListBox;
    lbErrorMsg: TStaticText;
    procedure btnConfigDSNClick(Sender: TObject);
    procedure ckbSystemDSNChange(Sender: TObject);
    procedure ckbUserDSNChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private

  public
    procedure RefreshDSNs;
    function GetSelectedDSN: string;
  end;

implementation

{$R *.lfm}

uses
  DmlScriptPublic, Registry;

{ TfrmWindowsOdbcConfg }

procedure TfrmWindowsOdbcConfg.btnConfigDSNClick(Sender: TObject);
const
  DEF_ODBC_CONF_PS =
    'function DLLSQLManageDataSources(IntPtr: hwnd): Boolean; external ''SQLManageDataSources@odbccp32.dll stdcall'';' + #13#10 +
    'begin' + #13#10 +
    '  DLLSQLManageDataSources(Screen.ActiveForm.Handle);' + #13#10 +
    'end.';
begin
  with CreateScriptForFile('odbc_dlg.pas') do
    try
      try
        Init('DML_SCRIPT', nil, nil, nil);
        Exec('DML_SCRIPT', DEF_ODBC_CONF_PS);
      except
        on E: Exception do
          raise Exception.Create('ODBC config Script Error: ' +
            E.Message);
      end;
    finally
      Free;
    end;
  RefreshDSNs;
end;

procedure TfrmWindowsOdbcConfg.ckbSystemDSNChange(Sender: TObject);
begin
  RefreshDSNs;
end;

procedure TfrmWindowsOdbcConfg.ckbUserDSNChange(Sender: TObject);
begin
  RefreshDSNs;
end;

procedure TfrmWindowsOdbcConfg.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOk then
    if GetSelectedDSN = '' then
      CanClose := False;
end;

procedure TfrmWindowsOdbcConfg.RefreshDSNs;
var
  Reg: TRegIniFile;
const
  REG_ODBC_KEY = '\Software\ODBC\ODBC.INI\ODBC Data Sources';
begin
  ListBoxDSNs.Items.Clear;
  lbErrorMsg.Visible := False;

  Reg := TRegIniFile.Create;
  try
    Reg.Access := KEY_READ;
    if ckbSystemDSN.Checked then
      Reg.RootKey := HKEY_LOCAL_MACHINE
    else
      Reg.RootKey := HKEY_CURRENT_USER;

    if not Reg.OpenKey(REG_ODBC_KEY, False) then
    begin
      //lbErrorMsg.Text := '';   
      lbErrorMsg.Visible := True;
      lbErrorMsg.BringToFront;
      Exit;
    end;
    Reg.GetValueNames(ListBoxDSNs.Items);
  finally
    Reg.Free;
  end;
end;

function TfrmWindowsOdbcConfg.GetSelectedDSN: string;
var
  I: Integer;
begin
  Result:='';
  I:=ListBoxDSNs.ItemIndex;
  if I<0 then
    Exit;
  Result := ListBoxDSNs.Items[I];
end;

end.

