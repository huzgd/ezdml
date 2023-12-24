unit uFrameUISheet;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  Buttons;

type

  { TFrameUIPrvSheet }

  TFrameUIPrvSheet = class(TFrame)
    PanelSheetEdit: TPanel;
    PanelSheetView: TPanel;
    ScrollBoxSheetEdit: TScrollBox;
    ScrollBoxSheetView: TScrollBox;
    TimerResize: TTimer;
    procedure FrameResize(Sender: TObject);
    procedure TimerResizeTimer(Sender: TObject);
  private
    FActivePage: integer;
    FOnHide: TNotifyEvent;
    FOnSheetResized: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FPosInitCounter: integer;
    FSizeCounter: integer;
    FViewType: string;
    procedure SetActivePage(AValue: integer);
  protected
    procedure SetVisible(Value: Boolean); override;
  public        
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init;
    procedure ReCalSizes;
    property OnSheetResized: TNotifyEvent read FOnSheetResized write FOnSheetResized;
    property ActivePage: integer read FActivePage write SetActivePage;
    property ViewType: string read FViewType write FViewType;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;      
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
  end;

implementation

{$R *.lfm}

{ TFrameUIPrvSheet }


procedure TFrameUIPrvSheet.TimerResizeTimer(Sender: TObject);
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

procedure TFrameUIPrvSheet.SetActivePage(AValue: integer);
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

procedure TFrameUIPrvSheet.SetVisible(Value: Boolean);
var
  bVis: Boolean;
begin
  bVis := Visible;
  inherited SetVisible(Value);
  if bVis <> Visible then
  begin
    if not bVis then
    begin
      if Assigned(FOnShow) then
        FOnShow(Self);
    end
    else
    begin  
      if Assigned(FOnHide) then
        FOnHide(Self);
    end;
  end;
end;

constructor TFrameUIPrvSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FViewType := 'modify';
end;

destructor TFrameUIPrvSheet.Destroy;
begin
  inherited Destroy;
end;

procedure TFrameUIPrvSheet.ReCalSizes;
begin
  FSizeCounter := 3;
  TimerResizeTimer(nil);
end;

procedure TFrameUIPrvSheet.Init;
begin
end;

procedure TFrameUIPrvSheet.FrameResize(Sender: TObject);
begin
  if FPosInitCounter > 2 then
    ReCalSizes;
end;

end.
