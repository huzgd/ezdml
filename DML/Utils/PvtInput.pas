unit PvtInput;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls;

type
  TPvtmb = (pmbOK, pmbCancel);

  TpiMemo = class(TMemo)
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  end;

{ Input dialog }

function PvtInputBox(const ACaption, APrompt, ADefault: string): string;
function PvtInputQuery(const ACaption, APrompt: string;
  var Value: string): Boolean;
procedure PvtShowMessage(const AMsg: string);

function PvtMemoQuery(const ACaption, APrompt: string;
  var Value: string; bReadOnly: Boolean): Boolean;    
function PvtChoiceQuery(const ACaption, APrompt: string;
  var Value: string; qs: string; opt: string): Boolean;

implementation

uses dmlstrs, ezdmlstrs;

{ Message dialog }

function GetAveCharSize(Canvas: TCanvas): TPoint;
begin
  Result.X := 10;
  Result.Y := 16;
end;

procedure PvtShowMessage(const AMsg: string);
begin
  Application.MessageBox(PChar(AMsg), PChar(Application.Title), MB_OK or MB_ICONINFORMATION);
  //MessageBox(Application.Handle, PChar(AMsg), PChar(Application.Title), MB_OK or MB_ICONINFORMATION);
end;

{ Input dialog }

function PvtInputQuery(const ACaption, APrompt: string;
  var Value: string): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
  try
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    BorderStyle := bsDialog;
    Caption := ACaption;
    ClientWidth := MulDiv(180, DialogUnits.X, 4);
    Position := poScreenCenter;
    Prompt := TLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      Caption := APrompt;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
      WordWrap := True;
    end;
    Edit := TEdit.Create(Form);
    with Edit do
    begin
      Parent := Form;
      Left := Prompt.Left;
      Top := Prompt.Top + Prompt.Height + 5;
      Width := MulDiv(164, DialogUnits.X, 4);
      MaxLength := 255;
      if Value='*****' then
      begin
        PasswordChar := '*';
        Value := '';
      end;
      Text := Value;
      SelectAll;
    end;
    ButtonTop := Edit.Top + Edit.Height + 15;
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := srCapOk;
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
        ButtonHeight);
    end;
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := srCapCancel;
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
        ButtonWidth, ButtonHeight);
      Form.ClientHeight := Top + Height + 13;
    end;
    if ShowModal = mrOk then
    begin
      Value := Edit.Text;
      Result := True;
    end;
  finally
    Form.Free;
  end;
end;

function PvtMemoQuery(const ACaption, APrompt: string;
  var Value: string; bReadOnly: Boolean): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Memo: TMemo;
  DialogUnits: TPoint;
  C, ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
  try
    with Font do
    begin
      Name := srEzdmlDefaultFontName;
      //Charset := srDefaultFontCharset;
      //Font.Size := srDefaultFontSize;
    end;
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    BorderStyle := bsDialog;
    Caption := ACaption;
    ClientWidth := MulDiv(240, DialogUnits.X, 4);
    Position := poScreenCenter;
    Prompt := TLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      Caption := APrompt;
      Left := MulDiv(4, DialogUnits.X, 4);
      Top := MulDiv(4, DialogUnits.Y, 8);                  
      Width := MulDiv(224, DialogUnits.X, 4);
      Constraints.MaxWidth := MulDiv(224, DialogUnits.X, 4);
      if Length(APrompt)>128 then
        Height := Height * 2;
      Anchors := [akTop, akLeft, akRight];
      WordWrap := True;
      AutoSize := True;
    end;

    Memo := TpiMemo.Create(Form);
    with Memo do
    begin
      Parent := Form;
      Left := Prompt.Left;
      Top := Prompt.Top + Prompt.Height + 5;
      Width := MulDiv(232, DialogUnits.X, 4);
      Height := MulDiv(40, DialogUnits.X, 4);
      MaxLength := 0;
      if bReadOnly then
      begin
        ReadOnly := True;
        ParentColor := True;
      end;
      WantReturns := True;
      WantTabs := True;
      Lines.Text := Value;
      C := Lines.Count;
      if C > 5 then
      begin
        if C > 16 then
          C := 16;
        Height := MulDiv(40 + (C - 5) * 8, DialogUnits.X, 4);
      end;   
      if Lines.Count > 16 then
      begin
        ScrollBars:=ssVertical;
      end;
      SelectAll;
    end;

    ButtonTop := Memo.Top + Memo.Height + 8;
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
    if bReadOnly then
    begin
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := srCapOk;
        ModalResult := mrCancel;
        Cancel := True;
        Default := True;
        SetBounds(MulDiv(96, DialogUnits.X, 4), Memo.Top + Memo.Height + 8,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 6;
      end;
    end
    else
    begin
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := srCapOk;
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(72, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := srCapCancel;
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(126, DialogUnits.X, 4), ButtonTop,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 6;
      end;
    end;
    if ShowModal = mrOk then
    begin
      if not bReadOnly then
        Value := Memo.Lines.Text;
      Result := True;
    end;
  finally
    Form.Free;
  end;
end;

function PvtInputBox(const ACaption, APrompt, ADefault: string): string;
begin
  Result := ADefault;
  PvtInputQuery(ACaption, APrompt, Result);
end;
           
function PvtChoiceQuery(const ACaption, APrompt: string;
  var Value: string; qs: string; opt: string): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TWinControl;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
  try
    with Font do
    begin
      Name := '宋体';
      Charset := DEFAULT_CHARSET;
      Font.Size := 9;
    end;
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    BorderStyle := bsDialog;
    Caption := ACaption;
    ClientWidth := MulDiv(180, DialogUnits.X, 4);
    Position := poScreenCenter;
    Prompt := TLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      Caption := APrompt;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
      WordWrap := True;
    end;

    if Pos('[COMBOBOX]', opt) = 0 then
    begin
      Edit := TListBox.Create(Form);
      with TListBox(Edit) do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        Items.Text :=qs;
        if Items.Count>10 then
          Height := 10*15
        else
          Height := Items.Count * 15;
        if Value<>'' then
          ItemIndex := Items.IndexOf(Value)
        else if Items.Count>0 then
          ItemIndex := 0;
      end;
    end
    else
    begin
      Edit := TComboBox.Create(Form);
      with TComboBox(Edit) do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Items.Text :=qs;
        DropDownCount := 32;
        Text := Value;
        try
          SelectAll;
        except
        end;
      end;
    end;

    ButtonTop := Edit.Top + Edit.Height + 15;
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := '确定';
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
        ButtonHeight);
    end;
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := '取消';
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
        ButtonWidth, ButtonHeight);
      Form.ClientHeight := Top + Height + 13;
    end;
    if ShowModal = mrOk then
    begin
      if qs<>'' then
      begin
        if Edit is TListBox then
        begin
          with TListBox(Edit) do
            if ItemIndex >= 0 then
              Value := Items[ItemIndex]
            else
              Value := '';
        end
        else
          Value := TComboBox(Edit).Text
      end
      else
        Value := TEdit(Edit).Text;
      Result := True;
    end;
  finally
    Form.Free;
  end;
end;

{ TpiMemo }

procedure TpiMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      if GetParentForm(Self) is TForm then
      begin
        GetParentForm(Self).ModalResult := mrCancel;
        Key := 0;
        Exit;
      end;
    Ord('a'), Ord('A'):
      if ssCtrl in Shift then
      begin
        SelectAll;
        Key := 0;
        Exit;
      end;
  end;

  inherited;
end;

end.

