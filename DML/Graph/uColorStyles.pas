unit uColorStyles;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, ColorBox;

type

  { TfrmColorStyles }

  TfrmColorStyles = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    ckbIndependPosForOverviewMode: TCheckBox;
    Label23: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet2: TTabSheet;
    Label15: TLabel;
    clbExKey: TColorBox;
    btnExKey: TButton;
    Label16: TLabel;
    Label9: TLabel;
    Label3: TLabel;
    clbTitle: TColorBox;
    btnTitle: TButton;
    Bevel1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    clbFill: TColorBox;
    btnFill: TButton;
    Label12: TLabel;
    Label18: TLabel;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label11: TLabel;
    Label17: TLabel;
    edtWorkspaceWidth: TEdit;
    edtWorkspaceHeight: TEdit;
    chlShowFieldType: TCheckBox;
    clbBackGround: TColorBox;
    btnBackGround: TButton;
    Bevel5: TBevel;
    Label13: TLabel;
    Label14: TLabel;
    Bevel2: TBevel;
    clbSelect: TColorBox;
    btnSelect: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Bevel6: TBevel;
    clbBorderColor: TColorBox;
    btnBorderColor: TButton;
    Label6: TLabel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Label7: TLabel;
    chlShowFieldIcon: TCheckBox;
    TabSheet3: TTabSheet;
    Label10: TLabel;
    Bevel9: TBevel;
    combDbEngine: TComboBox;
    Label8: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Bevel10: TBevel;
    clbPrimaryKey: TColorBox;
    btnPK: TButton;
    Label21: TLabel;
    Label22: TLabel;
    Bevel11: TBevel;
    clbLineColor: TColorBox;
    btnLinkLine: TButton;
    procedure btnBorderColorClick(Sender: TObject);
    procedure btnLinkLineClick(Sender: TObject);
    procedure btnPKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdtRegionBorderWidthChange(Sender: TObject);
    procedure edtWorkspaceWidthChange(Sender: TObject);
    procedure edtWorkspaceHeightChange(Sender: TObject);
    procedure btnFillClick(Sender: TObject);
    procedure btnBackGroundClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnTitleClick(Sender: TObject);
    procedure btnExKeyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure doSelectColor(clb: TColorBox);
  public
    procedure SetColor(ctrlid: integer; colorval: TColor);
    function GetColor(ctrlid: integer): TColor;
    procedure SetWorkSpaceWidth(vwidth: integer);
    procedure SetWorkSpaceHeight(vHeight: integer);
    function GetWorkSpaceWidth: integer;
    function GetWorkSpaceHeight: integer;
    procedure SetShowFieldType(vb: boolean);
    function GetShowFieldType: boolean;
    procedure SetDbEngine(dbe: string);
    function GetDbEngine: string;
    procedure SetShowFieldIcon(vb: boolean);
    function GetShowFieldIcon: boolean;
    { Public declarations }
  end;

var
  frmColorStyles: TfrmColorStyles;

implementation

{$R *.lfm}

procedure TfrmColorStyles.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  clbTitle.AddItem('clCustom', TObject(clWhite));
  clbFill.AddItem('clCustom', TObject(clWhite));
  clbBackGround.AddItem('clCustom', TObject(clWhite));
  clbSelect.AddItem('clCustom', TObject(clWhite));
  clbExKey.AddItem('clCustom', TObject(clWhite));
end;

function TfrmColorStyles.GetColor(ctrlid: integer): TColor;
begin
  result := clWhite;
  case ctrlid of
    1:
      begin
        result := clbTitle.Selected;
      end;
    2:
      begin
        //result := clbText.Selected;
      end;
    3:
      begin
        result := clbFill.Selected;
      end;
    4:
      begin
        result := clbBorderColor.Selected;
      end;
    5:
      begin
        result := clbBackGround.Selected;
      end;
    6:
      begin
        result := clbSelect.Selected;
      end;
    7:
      begin
        result := clbExKey.Selected;
      end;
    8:
      Result := clbPrimaryKey.Selected;
    9:
      Result := clbLineColor.selected;
  end;

end;

function TfrmColorStyles.GetDbEngine: string;
begin
  Result := combDbEngine.Text;
end;


function TfrmColorStyles.GetWorkSpaceHeight: integer;
begin
  result := strtoint(trim(edtWorkspaceHeight.Text));
end;

function TfrmColorStyles.GetWorkSpaceWidth: integer;
begin
  result := strtoint(trim(edtWorkspaceWidth.Text));
end;

procedure TfrmColorStyles.SetColor(ctrlid: integer; colorval: TColor);
var
  clCustom: integer;
begin
  case ctrlid of
    1: //clbtitle
      begin
        if (clbTitle.Items.IndexOfObject(TObject(colorval)) = -1) then
        begin
          clCustom := clbTitle.Items.IndexOf('clCustom');
          clbTitle.Items.Objects[clCustom] := Tobject(colorval);
        end;
        clbTitle.Selected := colorval;
      end;
    2: //clbText
      begin
      end;
    3: //clbFill
      begin
        if (clbFill.Items.IndexOfObject(TObject(colorval)) = -1) then
        begin
          clCustom := clbFill.Items.IndexOf('clCustom');
          clbFill.Items.Objects[clCustom] := Tobject(colorval);
        end;
        clbFill.Selected := colorval;
      end;
    4: //clbBorder
      begin
        if (clbBorderColor.Items.IndexOfObject(TObject(colorval)) = -1) then
        begin
          clCustom := clbBorderColor.Items.IndexOf('clCustom');
          clbBorderColor.Items.Objects[clCustom] := Tobject(colorval);
        end;
        clbBorderColor.Selected := colorval;
      end;
    5: //clbBackGround
      begin
        if (clbBackGround.Items.IndexOfObject(TObject(colorval)) = -1) then
        begin
          clCustom := clbbackground.Items.IndexOf('clCustom');
          clbBackGround.Items.Objects[clCustom] := Tobject(colorval);
        end;
        clbBackGround.Selected := colorval;
      end;
    6: //clbSelect
      begin
        if (clbSelect.Items.IndexOfObject(TObject(colorval)) = -1) then
        begin
          clCustom := clbSelect.Items.IndexOf('clCustom');
          clbSelect.Items.Objects[clCustom] := Tobject(colorval);
        end;
        clbSelect.Selected := colorval;
      end;
    7: //clbExkey
      begin
        if (clbExkey.Items.IndexOfObject(TObject(colorval)) = -1) then
        begin
          clCustom := clbExkey.Items.IndexOf('clCustom');
          clbExkey.Items.Objects[clCustom] := Tobject(colorval);
        end;
        clbExkey.Selected := colorval;
      end;
    8: //clbPrimaryKey
      begin
        if (clbPrimaryKey.Items.IndexOfObject(TObject(colorval)) = -1) then
        begin
          clCustom := clbPrimaryKey.Items.IndexOf('clCustom');
          clbPrimaryKey.Items.Objects[clCustom] := Tobject(colorval);
        end;
        clbPrimaryKey.Selected := colorval;
      end;
    9: //clbLinkLine
      begin
        if (clbLineColor.Items.IndexOfObject(TObject(colorval)) = -1) then
        begin
          clCustom := clbLineColor.Items.IndexOf('clCustom');
          clbLineColor.Items.Objects[clCustom] := Tobject(colorval);
        end;
        clbLineColor.Selected := colorval;
      end;
  end;
end;

procedure TfrmColorStyles.SetDbEngine(dbe: string);
begin
  combDbEngine.ItemIndex := combDbEngine.Items.IndexOf(dbe);
end;


procedure TfrmColorStyles.SetWorkSpaceHeight(vHeight: integer);
begin
  edtWorkspaceHeight.Text := inttostr(vHeight);
end;

procedure TfrmColorStyles.SetWorkSpaceWidth(vwidth: integer);
begin
  edtWorkspaceWidth.Text := inttostr(vWidth);
end;

procedure TfrmColorStyles.EdtRegionBorderWidthChange(Sender: TObject);
var
  itmp: integer;
begin
  if (Sender as TEdit).Text <> '' then
  try
    itmp := StrToInt((Sender as TEdit).Text);
    if (itmp > 100) then
      (Sender as TEdit).Text := inttostr(100);
  except
    on E: EConvertError do
    begin
      (Sender as TEdit).Undo();
      //(Sender as TEdit).ClearUndo();
    end;
  end;
end;

procedure TfrmColorStyles.edtWorkspaceWidthChange(Sender: TObject);

begin
  if (Sender as TEdit).Text <> '' then
  try
    StrToInt((Sender as TEdit).Text);

  except
    on E: EConvertError do
    begin
      (Sender as TEdit).Undo();
      //(Sender as TEdit).ClearUndo();
    end;
  end;
end;



procedure TfrmColorStyles.edtWorkspaceHeightChange(Sender: TObject);
begin
  if (Sender as TEdit).Text <> '' then
  try
    StrToInt((Sender as TEdit).Text);
  except
    on E: EConvertError do
    begin
      (Sender as TEdit).Undo();
      //(Sender as TEdit).ClearUndo();
    end;
  end;
end;

function TfrmColorStyles.GetShowFieldIcon: boolean;
begin
  result := chlShowFieldIcon.Checked;
end;

function TfrmColorStyles.GetShowFieldType: boolean;
begin
  result := chlShowFieldType.Checked;
end;

procedure TfrmColorStyles.SetShowFieldIcon(vb: boolean);
begin
  chlShowFieldIcon.Checked := vb;
end;

procedure TfrmColorStyles.SetShowFieldType(vb: boolean);
begin
  chlShowFieldType.Checked := vb;
end;

procedure TfrmColorStyles.btnFillClick(Sender: TObject);
begin
  doSelectColor(clbFill);
end;

procedure TfrmColorStyles.btnLinkLineClick(Sender: TObject);
begin
  doSelectColor(clbLineColor);
end;

procedure TfrmColorStyles.btnPKClick(Sender: TObject);
begin
  doSelectColor(clbPrimaryKey);
end;

procedure TfrmColorStyles.btnBackGroundClick(Sender: TObject);
begin
  doSelectColor(clbBackGround);
end;

procedure TfrmColorStyles.btnSelectClick(Sender: TObject);
begin
  doSelectColor(clbSelect);
end;


procedure TfrmColorStyles.btnTitleClick(Sender: TObject);
begin
  doSelectColor(clbTitle);
end;

procedure TfrmColorStyles.doSelectColor(clb: TColorBox);
var
  clDlg: TColorDialog;
  clCustom: integer;
begin
  clDlg := TColorDialog.Create(self);
  clDlg.Color := clb.Selected;

  if (clDlg.Execute) then
    if (clb.Items.IndexOfObject(TObject(clDlg.Color)) <> -1) then
      clb.Selected := clDlg.Color
    else
    begin
      clCustom := clb.Items.IndexOf('clCustom');
      if clCustom < 0 then
        clCustom := clb.Items.Add('clCustom');
      clb.Items.Objects[clCustom] := Tobject(clDlg.Color);
      clb.Selected := clDlg.Color;
    end;

  clDlg.Free;
end;

procedure TfrmColorStyles.btnBorderColorClick(Sender: TObject);
begin
  doSelectColor(clbBorderColor);
end;

procedure TfrmColorStyles.btnExKeyClick(Sender: TObject);
begin
  doSelectColor(clbExKey);
end;

procedure TfrmColorStyles.FormShow(Sender: TObject);
begin
  btnOk.Left:= btnCancel.Left - btnOk.Width - 10;
end;

end.

