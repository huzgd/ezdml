unit wOracleDBConfig;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  { TfrmOraDBConfig }

  TfrmOraDBConfig = class(TForm)
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
    rdbNetSvc: TRadioButton;
    rdbSvcParam: TRadioButton;
    procedure combNetSvcNameDropDown(Sender: TObject);
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
  CtMetaTable, WindowFuncs;

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
  end
  else
  begin
    combNetSvcName.ParentColor := True;
    combNetSvcName.Enabled := False;
    edtIP.Color := clWindow;
    edtIP.Enabled := True;
    edtPort.Color := clWindow;
    edtPort.Enabled := True;
    edtSvcName.Color := clWindow;
    edtSvcName.Enabled := True;
  end;
end;

class function TfrmOraDBConfig.DoOracleNetConfig(AString: string): string;
begin
  with TfrmOraDBConfig.Create(nil) do
  try
    combNetSvcName.Text := AString;
    edtIP.Text := ExtractCompStr(AString, '(HOST = ', ')', True, '');
    edtPort.Text := ExtractCompStr(AString, '(PORT = ', ')', True, edtPort.Text);
    edtSvcName.Text := ExtractCompStr(AString, '(SERVICE_NAME = ', ')', True);
    if edtIP.Text <> '' then
      rdbSvcParam.Checked := True;
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
  if rdbNetSvc.Checked then
    Result := combNetSvcName.Text
  else                       
    Result := edtIP.Text + ':' + edtPort.Text + '/' + edtSvcName.Text;
   // Result := '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ' +
     // edtIP.Text + ')(PORT = ' + edtPort.Text + ')) ) (CONNECT_DATA = (SERVICE_NAME = ' + edtSvcName.Text + ') ) )';
end;

procedure TfrmOraDBConfig.combNetSvcNameDropDown(Sender: TObject);
begin
  if combNetSvcName.Items.Count = 0 then
    if GetCtMetaDBReg('ORACLE') <> nil then
      if GetCtMetaDBReg('ORACLE').DbImpl <> nil then
        combNetSvcName.Items.Text := GetCtMetaDBReg('ORACLE').DbImpl.GetDbNames;
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

 
