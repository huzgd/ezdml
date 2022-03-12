unit uFormAddTbLink;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls, CtMetaTable;

type

  { TfrmAddTbLink }

  TfrmAddTbLink = class(TForm)
    ckbCreateNewField: TCheckBox;
    edtNewFieldName: TEdit;
    Label1: TLabel;
    combLinkType: TComboBox;
    Label4: TLabel;
    combMasterField: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    edtMasterTb: TEdit;
    Label3: TLabel;
    combRelateField: TComboBox;
    Label5: TLabel;
    edtDetailTb: TEdit;
    lbLinkInfo: TLabel;
    procedure ckbCreateNewFieldChange(Sender: TObject);
    procedure combRelateFieldChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure combLinkTypeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    Ftb1, Ftb2: TCtMetaTable;
    FCf: TCtMetaField;

    FResultField: TCtMetaField;
    procedure RefreshLinkInfo;
  public
    { Public declarations }
    procedure Init(tb1, tb2: TCtMetaTable; cf: TCtMetaField);
    procedure SaveFK;
  end;

function ExecAddTbLink(tb1, tb2: TCtMetaTable; var cf: TCtMetaField; fdef: string): boolean;
function ExecEditTbLink(tb1, tb2: TCtMetaTable; var cf: TCtMetaField): boolean;

var
  frmAddTbLink: TfrmAddTbLink;

implementation

uses
  CTMetaData, dmlstrs;


{$R *.lfm}

function ExecAddTbLink(tb1, tb2: TCtMetaTable; var cf: TCtMetaField; fdef: string): boolean;
begin
  if not Assigned(frmAddTbLink) then
    frmAddTbLink := TfrmAddTbLink.Create(Application);
  frmAddTbLink.Init(tb1, tb2, nil);
  if fdef <> '' then
    with frmAddTbLink.combRelateField do
      if items.IndexOf(fdef) >= 0 then
      begin
        ItemIndex := items.IndexOf(fdef);
        frmAddTbLink.RefreshLinkInfo;
      end;
  if frmAddTbLink.ShowModal = mrOk then
  begin
    Result := True;
    cf := frmAddTbLink.FResultField;
  end
  else
    Result := False;
end;

function ExecEditTbLink(tb1, tb2: TCtMetaTable; var cf: TCtMetaField): boolean;
begin
  if not Assigned(frmAddTbLink) then
    frmAddTbLink := TfrmAddTbLink.Create(Application);
  frmAddTbLink.Init(tb1, tb2, cf);
  if frmAddTbLink.ShowModal = mrOk then
  begin
    Result := True;
    cf := frmAddTbLink.FResultField;
  end
  else
    Result := False;
end;

procedure TfrmAddTbLink.FormDestroy(Sender: TObject);
begin
  if frmAddTbLink = Self then
    frmAddTbLink := nil;
end;

procedure TfrmAddTbLink.Init(tb1, tb2: TCtMetaTable; cf: TCtMetaField);
var
  S: string;
  I: integer;
begin
  combLinkType.Items.Text := srDmlLinkTypeNames;
  Ftb1 := tb1;
  Ftb2 := tb2;
  Fcf := cf;
  if cf = nil then
    Caption := srDmlAddLink
  else
    Caption := srDmlEditLink;

  edtMasterTb.Text := tb1.Name;
  if tb1.Caption <> '' then
    if tb1.Caption <> tb1.Name then
      edtMasterTb.Text := tb1.Name + '(' + tb1.Caption + ')';
  combMasterField.Items.Clear;
  with tb1.MetaFields do
    for I := 0 to Count - 1 do
      if Items[I].DataLevel <> ctdlDeleted then
        combMasterField.Items.AddObject(Items[I].Name, Items[I]);
  S := tb1.KeyFieldName;
  if cf <> nil then
    S := cf.RelateField;
  if S <> '' then
    combMasterField.ItemIndex := combMasterField.Items.IndexOf(S)
  else
    combMasterField.ItemIndex := -1;

  edtDetailTb.Text := tb2.Name;
  if tb2.Caption <> '' then
    if tb2.Caption <> tb2.Name then
      edtDetailTb.Text := tb2.Name + '(' + tb2.Caption + ')';
  combRelateField.Items.Clear;
  with tb2.MetaFields do
    for I := 0 to Count - 1 do
      if Items[I].DataLevel <> ctdlDeleted then
        combRelateField.Items.AddObject(Items[I].Name, Items[I]);

  if cf <> nil then
  begin
    S := cf.Name;
    combRelateField.ItemIndex := combRelateField.Items.IndexOf(S);
    if cf.RelateField = '{Link:Line}' then
      combLinkType.ItemIndex := 1
    else if cf.RelateField = '{Link:Direct}' then
      combLinkType.ItemIndex := 2     
    else if cf.RelateField = '{Link:OppDirect}' then
      combLinkType.ItemIndex := 3
    else if tb1.IsText then
      combLinkType.ItemIndex := 1
    else
      combLinkType.ItemIndex := 0;    
    ckbCreateNewField.Visible := False;
  end
  else if tb1.IsText then
  begin
    combRelateField.ItemIndex := -1;
    combLinkType.ItemIndex := 1;  
    ckbCreateNewField.Visible := True;
  end
  else
  begin
    combRelateField.ItemIndex := -1;
    combLinkType.ItemIndex := 0;
    ckbCreateNewField.Visible := True;
  end;  
  edtNewFieldName.Text := '';
  ckbCreateNewField.Checked := False;
  edtNewFieldName.Visible := False; 
  combRelateField.Visible := True;
  RefreshLinkInfo;
end;

procedure TfrmAddTbLink.SaveFK;
begin

end;

procedure TfrmAddTbLink.combLinkTypeChange(Sender: TObject);
begin
  RefreshLinkInfo;
end;

procedure TfrmAddTbLink.FormShow(Sender: TObject);
begin
  btnOk.Left:= btnCancel.Left - btnOk.Width - 10;
end;

procedure TfrmAddTbLink.RefreshLinkInfo;
var
  cf: TCtMetaField;
begin
  if Ftb1.IsText then
    combMasterField.Enabled := False
  else if combLinkType.ItemIndex > 0 then
    combMasterField.Enabled := False
  else
    combMasterField.Enabled := True;

  cf := nil;
  if combRelateField.ItemIndex >= 0 then
    cf := TCtMetaField(combRelateField.Items.Objects[combRelateField.ItemIndex]);

  if cf = nil then
    lbLinkInfo.Hide
  else if combLinkType.ItemIndex > 0 then
    lbLinkInfo.Hide
  else
  begin
    if cf.KeyFieldType = cfktId then
      lbLinkInfo.Caption := srLink_OneToOne
    else if cf.IndexType = cfitUnique then
      lbLinkInfo.Caption := srLink_OneToOne
    else
      lbLinkInfo.Caption := srLink_OneToMany;
    lbLinkInfo.Show;
  end;
end;

procedure TfrmAddTbLink.combRelateFieldChange(Sender: TObject);
begin
  RefreshLinkInfo;
end;

procedure TfrmAddTbLink.ckbCreateNewFieldChange(Sender: TObject);
var
  I: Integer;
  S: String;
begin
  edtNewFieldName.Visible:=ckbCreateNewField.Checked;            
  combRelateField.Visible:=not ckbCreateNewField.Checked;
  if edtNewFieldName.Visible and (edtNewFieldName.Text='') then
  begin
    if Ftb1.IsTable then
    begin
      S := Ftb1.Name+'_'+Ftb1.KeyFieldName;
      I:=1;
      while Ftb2.MetaFields.FieldByName(S) <> nil do
      begin
        Inc(I);
        S := Ftb1.Name+'_'+Ftb1.KeyFieldName+IntToStr(I);
      end;
      edtNewFieldName.Text := S;
    end
    else
    begin
      I := Ftb2.MetaFields.Count;
      S := Format(srNewFieldNameFmt, [I]);
      while Ftb2.MetaFields.FieldByName(S) <> nil do
      begin
        Inc(I);
        S := Format(srNewFieldNameFmt, [I]);
      end;
      edtNewFieldName.Text := S;
    end;
  end;
end;

procedure TfrmAddTbLink.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
  function HasRelateFieldSelected: Boolean;
  begin
    Result := False;
    if combRelateField.Visible then
    begin
      if combRelateField.ItemIndex = -1 then
        Exit;
    end else
    begin
      if Trim(edtNewFieldName.Text)= '' then
        Exit;
    end;   
    Result := True;
  end;
var
  mf, cf: TCtMetaField;
begin
  if ModalResult = mrOk then
  begin
    if combLinkType.ItemIndex < 0 then
    begin
      CanClose := False;
      Exit;
    end;
    if combLinkType.ItemIndex = 0 then
    begin
      if Ftb1.IsText then
      begin
        CanClose := False;
        Exit;
      end;
      if (combMasterField.ItemIndex = -1) then
      begin
        CanClose := False;
        Exit;
      end;
    end;
    if not HasRelateFieldSelected then
    begin
      CanClose := False;
      Exit;
    end;
                           
    if combRelateField.Visible then
      cf := TCtMetaField(combRelateField.Items.Objects[combRelateField.ItemIndex])
    else
    begin
      cf := Ftb2.MetaFields.NewMetaField;
      cf.Name := Trim(edtNewFieldName.Text);   
      if combLinkType.ItemIndex = 0 then
      begin        
        mf := TCtMetaField(combMasterField.Items.Objects[combMasterField.ItemIndex]);
        cf.DataType:=mf.DataType;    
        cf.DataTypeName:=mf.DataTypeName;     
        cf.DataLength:=mf.DataLength;
        cf.DataScale:=mf.DataScale;
      end
      else
      begin
        cf.DataType := cfdtFunction; 
        cf.DataTypeName:='{Link}';
      end;
    end;
    if cf.RelateTable <> '' then
      if (Fcf = nil) or (Fcf <> cf) then
        if Application.MessageBox(PChar(Format(srDmlConfirmEditLinkFmt, [cf.Name, cf.RelateTable])),
          PChar(Self.Caption), MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES then
        begin
          CanClose := False;
          Exit;
        end;
    if Fcf <> nil then
      if Fcf <> cf then
      begin
        if Fcf.KeyFieldType = cfktRid then
          Fcf.KeyFieldType := cfktNormal;
        Fcf.RelateTable := '';
        Fcf.RelateField := '';
        Fcf.GraphDesc := '';
      end;
    if combLinkType.ItemIndex = 0 then
    begin
      if cf.KeyFieldType <> cfktId then
        cf.KeyFieldType := cfktRid;
      cf.RelateField := combMasterField.Text;
    end
    else if combLinkType.ItemIndex = 2 then
    begin
      cf.KeyFieldType := cfktNormal;
      cf.RelateField := '{Link:Direct}';
    end   
    else if combLinkType.ItemIndex = 3 then
    begin
      cf.KeyFieldType := cfktNormal;
      cf.RelateField := '{Link:OppDirect}';
    end
    else
    begin
      cf.KeyFieldType := cfktNormal;
      cf.RelateField := '{Link:Line}';
    end;
    cf.RelateTable := Ftb1.Name;
    cf.GraphDesc := '';
    FResultField := cf;
  end;
end;

end.
