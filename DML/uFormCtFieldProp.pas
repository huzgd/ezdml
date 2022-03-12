unit uFormCtFieldProp;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  CtMetaTable, uFrameCtFieldDef, ActnList, StdActns;

type

  { TfrmCtMetaFieldProp }

  TfrmCtMetaFieldProp = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    Panel2: TPanel;
    procedure btnCancelClick(Sender: TObject);
    procedure EditBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FReadOnlyMode: Boolean;
    FMetaField: TCtMetaField;
    FTempMetaField: TCtMetaField;
    FFrameCtFieldDef: TFrameCtFieldDef;
    FOrginalCaption: string;

    procedure _sbtnSearchFieldsClick(Sender: TObject);
  public
    { Public declarations }
    procedure Init(AField: TCtMetaField; bReadOnly: Boolean);
  end;

function ShowCtMetaFieldDialog(AField: TCtMetaField; bReadOnly: Boolean): Boolean;

var
  FfrmCtMetaFieldProp: TfrmCtMetaFieldProp;

implementation

uses
  dmlstrs, WindowFuncs;

{$R *.lfm}

function ShowCtMetaFieldDialog(AField: TCtMetaField; bReadOnly: Boolean): Boolean;
var
  frm: TfrmCtMetaFieldProp;
begin
  if FfrmCtMetaFieldProp = nil then
    FfrmCtMetaFieldProp := TfrmCtMetaFieldProp.Create(Application);
  if FfrmCtMetaFieldProp.Showing or bReadOnly then
    frm := TfrmCtMetaFieldProp.Create(Application)
  else
    frm := FfrmCtMetaFieldProp;
  with frm do
  try  
    if not bReadOnly then
      BeginTbPropUpdate(AField.OwnerTable);
    Init(AField, bReadOnly);
    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('FIELD_PROP_DIALOG', 'SHOW', '', AField, frm);
    end;   
    if bReadOnly then
    begin
      FormStyle := fsStayOnTop;
      Position := poDefaultPosOnly;
      Show;
      Result := False;
    end
    else
      Result := (ShowModal = mrOk);
  finally           
    if not bReadOnly then
    begin
      EndTbPropUpdate(AField.OwnerTable);
      if frm <> FfrmCtMetaFieldProp then
        frm.Free;
    end;
  end;
end;


{ TfrmCtMetaFieldProp }

procedure TfrmCtMetaFieldProp.Init(AField: TCtMetaField;
  bReadOnly: Boolean);
var
  S: string;
begin
  FReadOnlyMode := bReadOnly;
  FMetaField := AField;
  if FMetaField = nil then
  begin
    FReadOnlyMode := True;
    if Assigned(FTempMetaField) then
      FreeAndNil(FTempMetaField);
  end
  else
  begin
    if FTempMetaField = nil then
      FTempMetaField := TCtMetaField.Create;
    FTempMetaField.AssignFrom(AField);
  end;
  if FReadOnlyMode then
  begin
    btnOk.Visible := False;
    btnCancel.Caption := srCapClose;
  end;

  S := FOrginalCaption;
  if Assigned(AField) then
  begin
    if Assigned(AField.OwnerTable) then
      S := S + ' - ' + AField.OwnerTable.Name + '.' + AField.Name
    else
      S := S + ' - ' + AField.Name;
  end;
  Caption := S;
                         
  FFrameCtFieldDef.SelTable := FMetaField.OwnerTable;
  FFrameCtFieldDef.Init(FTempMetaField, FReadOnlyMode);
end;

procedure TfrmCtMetaFieldProp._sbtnSearchFieldsClick(Sender: TObject);
var
  res: TCtMetaObjectList;
  I: Integer;
  tb_dst: TCtMetaTable;
  bFirst: Boolean;
  fld: TCtMetaField;
  procedure AddAField(Afld: TCtMetaField);
  begin
    if bFirst then
    begin
      fld := FMetaField;
      bFirst := False;
      fld.AssignFrom(Afld);
      FTempMetaField.AssignFrom(Afld);
    end
    else
    begin
      fld := tb_dst.MetaFields.NewMetaField;
      fld.AssignFrom(Afld);
    end;
  end;
begin
  if not Assigned(Proc_ShowCtDmlSearch) then
    raise Exception.Create('Proc_ShowCtDmlSearch not defined');

  res := TCtMetaObjectList.Create;
  try
    Proc_ShowCtDmlSearch(FGlobeDataModelList, res);
    if FMetaField.OwnerTable = nil then
      Exit;
    if res.Count = 0 then
      Exit;

    tb_dst := FMetaField.OwnerTable;
    bFirst := True;
    for I := 0 to res.Count - 1 do
    begin
      if res[I] is TCtMetaField then
      begin
        AddAField(res[I] as TCtMetaField);
      end;
    end;
    FFrameCtFieldDef.Init(FTempMetaField, FReadOnlyMode);
    if res.Count > 1 then
      ModalResult := mrOk;
  finally
    res.Free;
  end;
end;

procedure TfrmCtMetaFieldProp.FormCreate(Sender: TObject);
begin
  FFrameCtFieldDef := TFrameCtFieldDef.Create(Self);
  FFrameCtFieldDef.Parent := Self;
  FFrameCtFieldDef.Align := alClient;
  FOrginalCaption := Caption;
  FFrameCtFieldDef.sbtnSearchFields.OnClick := _sbtnSearchFieldsClick;
  FFrameCtFieldDef.edtName.OnKeyDown := EditBoxKeyDown;         
  FFrameCtFieldDef.edtDisplayName.OnKeyDown := EditBoxKeyDown;
  CheckFormScaleDPI(Self);
end;

procedure TfrmCtMetaFieldProp.FormDestroy(Sender: TObject);
begin
  if Assigned(FTempMetaField) then
    FreeAndNil(FTempMetaField);
end;

procedure TfrmCtMetaFieldProp.FormShow(Sender: TObject);
begin
  try
    btnCancel.Left := Panel1.Width - btnCancel.Width - 20;
    btnOk.Left:= btnCancel.Left - btnOk.Width - 10;
    if FFrameCtFieldDef.edtName.CanFocus then
    begin
      FFrameCtFieldDef.edtName.SetFocus;
      FFrameCtFieldDef.edtName.SelectAll;
    end;
  except
  end;
end;

procedure TfrmCtMetaFieldProp.EditBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then
    if btnOk.Visible then
      ModalResult := mrOk;
end;

procedure TfrmCtMetaFieldProp.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCtMetaFieldProp.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  S1, S2: string;
begin
  if ModalResult = mrOk then
    if not FReadOnlyMode then
    begin
      try
        btnOk.SetFocus;
      except
      end;
      S1 := FMetaField.JsonStr;
      S2 := FTempMetaField.JsonStr;
      if S1 <> S2 then
      begin
        FMetaField.AssignFrom(FTempMetaField);
        DoTablePropsChanged(FMetaField.OwnerTable);
      end;
      if Assigned(GProc_OnEzdmlCmdEvent) then
      begin
        GProc_OnEzdmlCmdEvent('FIELD_PROP_DIALOG', 'HIDE', 'SAVE', FMetaField, Self);
      end;
      Exit;
    end;
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('FIELD_PROP_DIALOG', 'HIDE', '', FMetaField, Self);
  end;
end;

initialization
  Proc_ShowCtFieldProp := ShowCtMetaFieldDialog;

end.

