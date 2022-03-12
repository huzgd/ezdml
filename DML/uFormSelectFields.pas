unit uFormSelectFields;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst,
  CtMetaTable;

type

  { TfrmSelectFields }

  TfrmSelectFields = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    cklbFields: TCheckListBox;
    ckbSelAll: TCheckBox;
    procedure cklbFieldsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ckbSelAllClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOrginalCaption: string;
    FTemplateTb: TCtMetaTable;      
    FSelectedData: TStringList;
  public
    { Public declarations }
    procedure Init(ADesc, ASelected, opt: string);
    function SelectedResult: string;
  end;

function CtSelectFields(desc, defs, opt: string): string;

implementation

uses CTMetaData;

{$R *.lfm}

function CtSelectFields(desc, defs, opt: string): string;
begin
  with TfrmSelectFields.Create(Application) do
  try
    Init(desc, defs, opt);
    if ShowModal = mrOk then
      Result := SelectedResult
    else
      Result := '';
  finally
    Free;
  end;
end;


procedure TfrmSelectFields.ckbSelAllClick(Sender: TObject);
var
  I, C: Integer;
begin
  C := 0;                                        
  for I := 0 to cklbFields.Items.Count - 1 do
    if cklbFields.Selected[I] then
      Inc(C);
  if C > 1 then
  begin
    for I := 0 to cklbFields.Items.Count - 1 do
      if cklbFields.Selected[I] then
        cklbFields.Checked[I] := ckbSelAll.Checked;
  end
  else
    for I := 0 to cklbFields.Items.Count - 1 do
      cklbFields.Checked[I] := ckbSelAll.Checked;
end;

procedure TfrmSelectFields.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  I: Integer;
begin
  if ModalResult = mrOk then
  begin
    CanClose := False;
    for I := 0 to cklbFields.Items.Count - 1 do
      if cklbFields.Checked[I] then
        CanClose := True;
  end;
end;

procedure TfrmSelectFields.FormCreate(Sender: TObject);
begin                    
  FSelectedData:=TStringList.Create;
  FOrginalCaption := Caption;
  cklbFields.Items.Clear;
end;

procedure TfrmSelectFields.FormDestroy(Sender: TObject);
begin
  if FTemplateTb <> nil then
    FreeAndNil(FTemplateTb); 
  FSelectedData.Free;
end;

procedure TfrmSelectFields.cklbFieldsClick(Sender: TObject);
begin
  SelectedResult;
end;

procedure TfrmSelectFields.Init(ADesc, ASelected, opt: string);
  function IsSelected(fdn: string): Boolean;
  begin
    if Pos(',' + UpperCase(fdn) + ',', ',' + UpperCase(ASelected) + ',') > 0 then
      Result := True
    else
      Result := False;
  end;
var
  I: TCtKeyFieldType;
  K, V: Integer;
  fd: TCtMetaField;
begin
  if FTemplateTb = nil then
    FTemplateTb := TCtMetaTable.Create;
  FTemplateTb.Describe := ADesc;

  if Pos('[CAN_SELECT_ALL]', opt)>0 then
    ckbSelAll.Visible := True;

  if FTemplateTb.MetaFields.Count = 0 then
  begin
    for I := cfktId to cfktOrderNo do
    begin
      fd := FTemplateTb.MetaFields.NewMetaField;
      fd.Name := DEF_CTMETAFIELD_KEYFIELD_NAMES_ENG[I];
      fd.DisplayName := DEF_CTMETAFIELD_KEYFIELD_NAMES_CHN[I];
      fd.KeyFieldType := I;
      fd.DataType := DEF_CTMETAFIELD_KEYFIELD_TYPES[I];
    end;
  end;

  FOrginalCaption := Caption;
  cklbFields.Items.Clear;
  for K := 0 to FTemplateTb.MetaFields.Count - 1 do
  begin
    fd := FTemplateTb.MetaFields.Items[K];
    V := cklbFields.Items.AddObject(fd.NameCaption, fd);
    if IsSelected(fd.Name) then
      cklbFields.Checked[V] := True
    else
      cklbFields.Checked[V] := False;
  end;
end;

function TfrmSelectFields.SelectedResult: string;
var
  I: Integer;
  S: String;
  fd: TCtMetaField;
begin
  Result := '';
  for I := 0 to cklbFields.Items.Count - 1 do
  begin
    fd := TCtMetaField(cklbFields.Items.Objects[I]);
    S := fd.Name;
    if cklbFields.Checked[I] then
    begin
      if FSelectedData.IndexOf(S) < 0 then
        FSelectedData.Add(S);
    end
    else if FSelectedData.IndexOf(S) >= 0 then
      FSelectedData.Delete(FSelectedData.IndexOf(S));
  end;

  Result := Trim(FSelectedData.CommaText);
end;

end.

