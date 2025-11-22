unit uFormAddCtFields;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst,
  CtMetaTable;

type

  { TfrmAddCtFields }

  TfrmAddCtFields = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    cklbFields: TCheckListBox;
    ckbSelAll: TCheckBox;
    rdbFNameTp1: TRadioButton;
    rdbFNameTp2: TRadioButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rdgFNameTpClick(Sender: TObject);
    procedure ckbSelAllClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOrginalCaption: string;
    FTemplateTb: TCtMetaTable;
  public
    { Public declarations }
    procedure LoadFromTb(tb: TCtMetaTable);
    procedure SaveToTb(tb: TCtMetaTable);
  end;

implementation

uses CTMetaData, WindowFuncs;

{$R *.lfm}


procedure TfrmAddCtFields.rdgFNameTpClick(Sender: TObject);
var
  K: Integer;
  S: string;
  fd: TCtMetaField;
begin
  for K := 0 to FTemplateTb.MetaFields.Count - 1 do
  begin
    fd := FTemplateTb.MetaFields.Items[K];
    if rdbFNameTp1.Checked then
      S := fd.Name
    else
    begin
      S := fd.DisplayName;
      if S = '' then
        S := fd.Name;
    end;
    cklbFields.Items.Strings[K] := S;
  end;
end;

procedure TfrmAddCtFields.ckbSelAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to cklbFields.Items.Count - 1 do
    cklbFields.Checked[I] := ckbSelAll.Checked;
end;

procedure TfrmAddCtFields.LoadFromTb(tb: TCtMetaTable);
begin
  Caption := FOrginalCaption + ' - ' + tb.DisplayText;
end;

procedure TfrmAddCtFields.SaveToTb(tb: TCtMetaTable);
var
  I, K: Integer;
  S: string;
  fd: TCtMetaField;
begin
  if not Assigned(tb) then
    Exit;
  for I := 0 to cklbFields.Items.Count - 1 do
    if cklbFields.Checked[I] then
    begin
      S := cklbFields.Items[I];
      if tb.MetaFields.FieldByName(S) <> nil then
        Continue;
      K := Integer(cklbFields.Items.Objects[i]);
      fd := FTemplateTb.MetaFields.Items[K];
      with tb.MetaFields.NewMetaField do
      begin
        Name := fd.Name;
        DisplayName := fd.DisplayName;
        if rdbFNameTp2.Checked then
          if fd.DisplayName <> '' then
          begin
            Name := fd.DisplayName;
            DisplayName := fd.Name;
          end;
        KeyFieldType := fd.KeyFieldType;
        DataType := fd.DataType;
        DataLength := fd.DataLength;
        DataScale := fd.DataScale;
        Nullable := fd.Nullable;
        IndexType := fd.IndexType;
        DefaultValue := fd.DefaultValue;
        S := fd.Memo;
        if Pos('[DefSelected]', S) > 0 then
          S := StringReplace(S, '[DefSelected]', '', []);
        Memo := S;
      end;
    end;
end;

procedure TfrmAddCtFields.FormCloseQuery(Sender: TObject;
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

procedure TfrmAddCtFields.FormCreate(Sender: TObject);
const
  DEF_SELECTED_FIELD: array[0..8] of TCtKeyFieldType = (
    cfktId,
    cfktRid,
    cfktCaption,
    cfktComment,
    cfktOrgId,
    cfktDeptId,
    cfktCreatorId,
    cfktCreateDate,
    cfktDataLevel);
  function KeyDefSelected(K: TCtKeyFieldType): Boolean;
  var
    x: Integer;
  begin
    for x := 0 to 7 do
      if K = DEF_SELECTED_FIELD[x] then
      begin
        Result := True;
        Exit;
      end;
    Result := False;
  end;
var
  I: TCtKeyFieldType;
  K, V: Integer;
  fn, S: string;
  ss: TStrings;
  fd: TCtMetaField;
begin
  FTemplateTb := TCtMetaTable.Create;
  fn := GetFolderPathOfAppExe('Templates');
  fn := FolderAddFileName(fn, 'add_system_fields.txt');
  fn := GetConfigFile_OfLang(fn);
  if FileExists(fn) then
  begin
    ss := TStringList.Create;
    try
      ss.LoadFromFile(fn);     
      S := ss.Text;
      if Copy(S, 1, 2) = #$FE#$FF then
        Delete(S, 1, 2)
      else if Copy(S, 1, 2) = #$FE#$FE then
        Delete(S, 1, 2)
      else if Copy(S, 1, 3) = #$EF#$BB#$BF then
        Delete(S, 1, 3);
      FTemplateTb.Describe := S;
    finally
      ss.Free;
    end;
  end;

  if FTemplateTb.MetaFields.Count = 0 then
  begin
    for I := cfktId to cfktOrderNo do
    begin
      fd := FTemplateTb.MetaFields.NewMetaField;
      fd.Name := DEF_CTMETAFIELD_KEYFIELD_NAMES_ENG[I];
      fd.DisplayName := DEF_CTMETAFIELD_KEYFIELD_NAMES_CHN[I];
      fd.KeyFieldType := I;
      fd.DataType := DEF_CTMETAFIELD_KEYFIELD_TYPES[I];
      if KeyDefSelected(I) then
        fd.Memo := '[DefSelected]';
    end;

  end;

  FOrginalCaption := Caption;
  cklbFields.Items.Clear;
  for K := 0 to FTemplateTb.MetaFields.Count - 1 do
  begin
    fd := FTemplateTb.MetaFields.Items[K];
    if rdbFNameTp1.Checked then
      V := cklbFields.Items.AddObject(fd.Name, TObject(K))
    else
    begin
      S := fd.DisplayName;
      if S = '' then
        S := fd.Name;
      V := cklbFields.Items.AddObject(S, TObject(K));
    end;
    if Pos('[DefSelected]', fd.Memo) > 0 then
      cklbFields.Checked[V] := True
    else
      cklbFields.Checked[V] := False;
  end;
  rdbFNameTp1.Checked := True;
end;

procedure TfrmAddCtFields.FormDestroy(Sender: TObject);
begin
  FTemplateTb.Free;
end;

procedure TfrmAddCtFields.FormShow(Sender: TObject);
begin
  btnOk.Left:= btnCancel.Left - btnOk.Width - 10;
end;

end.

