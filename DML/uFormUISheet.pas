unit uFormUISheet;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  Buttons;

type

  { TfrmUIPrvSheet }

  TfrmUIPrvSheet = class(TForm)
    PanelSheetEdit: TPanel;
    PanelSheetView: TPanel;
    ScrollBoxSheetEdit: TScrollBox;
    ScrollBoxSheetView: TScrollBox;
    TimerResize: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure TimerResizeTimer(Sender: TObject);
  private
    FActivePage: integer;
    FOnSheetResized: TNotifyEvent;
    FPosInitCounter: integer;
    FSizeCounter: integer;
    FViewType: string;
    procedure SetActivePage(AValue: integer);
  public
    procedure Init;
    procedure ReCalSizes;
    property OnSheetResized: TNotifyEvent read FOnSheetResized write FOnSheetResized;
    property ActivePage: integer read FActivePage write SetActivePage;
    property ViewType: string read FViewType write FViewType;
  end;

implementation

{$R *.lfm}

{ TfrmUIPrvSheet }


procedure TfrmUIPrvSheet.TimerResizeTimer(Sender: TObject);
begin
  TimerResize.Enabled := False;
  PanelSheetView.Width := ScrollBoxSheetView.ClientWidth - 2;
  PanelSheetEdit.Width := ScrollBoxSheetEdit.ClientWidth - 2;
  if Assigned(OnSheetResized) then
    OnSheetResized(Sender);
                       
  if FPosInitCounter <= 2 then
    if Parent <> nil then
    begin
      if FSizeCounter = 2 then
        Parent.Width := Parent.Width + 1
      else if FSizeCounter = 1 then
        Parent.Width := Parent.Width - 1;
      Inc(FPosInitCounter);
    end;

  Dec(FSizeCounter);
  if FSizeCounter > 0 then
    TimerResize.Enabled := True;
end;

procedure TfrmUIPrvSheet.SetActivePage(AValue: integer);
begin
  if FActivePage = AValue then
    Exit;
  FActivePage := AValue;
  if FActivePage = 1 then
  begin
    ScrollBoxSheetView.Visible := True;
    ScrollBoxSheetEdit.Visible := False;
  end
  else
  begin
    ScrollBoxSheetEdit.Visible := True;
    ScrollBoxSheetView.Visible := False;
  end;
end;

procedure TfrmUIPrvSheet.ReCalSizes;
begin
  FSizeCounter := 3;
  TimerResizeTimer(nil);
end;

procedure TfrmUIPrvSheet.Init;
begin
end;


procedure TfrmUIPrvSheet.FormCreate(Sender: TObject);
begin
  FViewType := 'modify';
end;

procedure TfrmUIPrvSheet.FormResize(Sender: TObject);
begin
  if FPosInitCounter > 2 then
    ReCalSizes;
end;

procedure TfrmUIPrvSheet.FormWindowStateChange(Sender: TObject);
begin
  ReCalSizes;
end;

end.
