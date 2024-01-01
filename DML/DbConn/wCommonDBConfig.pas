unit wCommonDBConfig;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  { TfrmCommDBConfig }

  TfrmCommDBConfig = class(TForm)
    btnHelp: TButton;
    combSveIp: TComboBox;
    Label1: TLabel;
    edtPort: TEdit;
    Label2: TLabel;
    edtDbName: TEdit;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnHelpClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { Private declarations }
    FDBType: string;
    function GenResult: string;
  public
    { Public declarations }
    class function DoDBConfig(AString, ADbType: string): string;
  end;

var
  frmCommDBConfig: TfrmCommDBConfig;

implementation

uses
  CtMetaTable, WindowFuncs, dmlstrs, ezdmlstrs;

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

function TfrmCommDBConfig.GenResult: string;
begin
  Result := Trim(combSveIp.Text);
  if Result='' then
    Exit;
  if Trim(edtPort.Text)<>'' then
    Result :=  Result + ':' + Trim(edtPort.Text);    
  if Trim(edtDbName.Text)<>'' then
    Result :=  Result + '@' + Trim(edtDbName.Text);
end;


end.

 
