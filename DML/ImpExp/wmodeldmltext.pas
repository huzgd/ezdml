unit wModelDMLText;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, Menus, CtMetaTable;

type

  { TfrmModelDMLText }

  TfrmModelDMLText = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lbTxtTip: TLabel;
    MemoTxt: TMemo;
    PanelBT: TPanel;
    PanelMain: TPanel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private           
    FCtTbList: TCtMetaTableList;
  public      
    procedure Init(ATbList: TCtMetaTableList);
  end;


implementation

{$R *.lfm}

uses
  dmlstrs, WindowFuncs, uJson, AutoNameCapitalize,
  CtMetaTbUtil;

{ TfrmModelDMLText }

procedure TfrmModelDMLText.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmModelDMLText.btnOkClick(Sender: TObject);
begin
  if Trim(MemoTxt.Lines.Text)='' then
    Exit;
  btnOk.Enabled := False;
  try
    if FCtTbList.ImportDMLText(MemoTxt.Lines.Text) > 0 then
    begin              
      GenRandBgColors(FCtTbList);
      ModalResult := mrOk;
    end;
  finally
    btnOk.Enabled := True;
  end;
end;


procedure TfrmModelDMLText.Init(ATbList: TCtMetaTableList);
begin
  CtSetFixWidthFont(MemoTxt);
  FCtTbList := ATbList;
  MemoTxt.Lines.Text := FCtTbList.Describe;
end;


end.

