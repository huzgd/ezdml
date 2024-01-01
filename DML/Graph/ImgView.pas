{
  ****************************************************************

  ImageView Control 1.0
  图形查看控件。

  By HUZZZ (huz0123@21cn.com)
  Date: 2001-12-07
  Guangzhou China

  Key Property:
    MouseAction: 鼠标操作（无、漫游、放大、缩小、自动）
      自动：左键拉框放大（从左到右）或复位（从右到左拉框），右键漫游
    Image, Graphic;
    ViewScale, ViewCenterX, ViewCenterY;
    MaxViewScale: 最大放大倍数。

  Methods:
    procedure Reset;
    procedure FullExtent; 缩放到全图。
    procedure Repaint;
    procedure BestFit; 图形小则100%，太大则缩小适应屏幕。

  HISTORY：
    2001-12-07 Huzzz 测试通过：Win2000 Delphi6.0
    2002-03-XX Huzzz : 修改了比例中心的设置代码，使漫游时视图可以限制在图形范围内

  缺省安装在Sample页。

  修改请保留说明信息。

  *****************************************************************
}

unit ImgView;

{$MODE Delphi}

{.$DEFINE USE_GISRES}
{.$DEFINE USE_IMAGEUTIL}

interface

uses
  LCLIntf, LCLType, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  ExtCtrls, Menus;

const
  DEF_INIT_LAST_IMGV_MOUSE_POS_X = 8;
  DEF_INIT_LAST_IMGV_MOUSE_POS_Y = 8;

type
  TMouseViewAction = (vaNone, vaPan, vaZoomIn, vaZoomOut, vaAuto, vaRectSelect);
  TRotateAngle = (raZero, ra90, ra180, ra270);

  { TImageView }

  TImageView = class(TCustomControl)
  private
    FScaleStep: double;
  protected
    FMouseDowned: boolean;
    FZooming: boolean;
    FTmpPanning: boolean;
    FOldMouseP: TPoint;
    FLastMouseP: TPoint;
    FLastMouseDownPos: TPoint;
    FGraphic: TGraphic;
    FImage: TImage;
    FViewCenterY: double;
    FViewCenterX: double;
    FViewScale: double;
    FOnPaint: TNotifyEvent;
    FBufmap: TBitmap;
    FBufmapB: TBitmap;
    FMouseAction: TMouseViewAction;
    FMaxViewScale: double;
    FCanDragOutOfSize: boolean;
    FRotateAngle: TRotateAngle;
    FKeyActions: boolean;
    FImgPopupMenu: TPopupMenu;
    FLastPopupTick: int64;
    FLastPopupPoint: TPoint;
    FOnViewChanged: TNotifyEvent;

    FSelRect: TRect;
    FSelDragging: boolean;
    FSkipOneClick: boolean;

    FHookTopLeft: boolean;
    FHookLastWidth, FHookLastHeight: integer;
    FHookX, FHookY: double;
    FLastVX, FLastVY, FLastVS: double;

    FScrollbars: boolean;
    FSkipResizing: boolean;

    procedure SetScrollbars(const Value: boolean); virtual;
    procedure SetGraphic(const Value: TGraphic); virtual;
    procedure SetImage(const Value: TImage); virtual;
    procedure SetViewCenterX(const Value: double); virtual;
    procedure SetViewCenterY(const Value: double); virtual;
    procedure SetViewScale(const Value: double); virtual;
    function GetGraphic: TGraphic; virtual;
    procedure SetMouseAction(const Value: TMouseViewAction); virtual;
    procedure SetMaxViewScale(const Value: double); virtual;
    procedure SetCanDragOutOfSize(const Value: boolean); virtual;
    procedure SetRotateAngle(const Value: TRotateAngle); virtual;
  protected
    FUpdateCounter: Integer;
    procedure Paint; override;

    procedure BufDraw; virtual;
    procedure DrawRectLine(X, Y: integer; bClearLast: boolean); virtual;
    procedure DrawImgRect; virtual;

    procedure ResetView; virtual;
    procedure CheckDragOutSize; virtual;
    procedure CheckActCursor; virtual;
    procedure CheckViewChanged; virtual;

    procedure Resize; override;
    procedure RecreateScrollbars; virtual;

    procedure DoRectSelectMD(X, Y: integer; Shift: TShiftState); virtual;
    procedure DoRectSelectMV(X, Y: integer; Shift: TShiftState); virtual;
    function DoRectSelectMU(X1, Y1, X2, Y2: integer; Shift: TShiftState): boolean;
      virtual;

    procedure DoCustMD(Button: TMouseButton; X, Y: integer; Shift: TShiftState); virtual;
    procedure DoCustMV(X, Y: integer; Shift: TShiftState); virtual;
    procedure DoCustMU(Button: TMouseButton; X, Y: integer; Shift: TShiftState); virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
    procedure KeyUp(var Key: word; Shift: TShiftState); override;
    procedure KeyPress(var Key: char); override;
    procedure DblClick; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelLeft(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelRight(Shift: TShiftState; MousePos: TPoint): boolean;
      override;
    function DoCMMouseWheel(Shift: TShiftState; dx, dy: integer): boolean; virtual;

    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;     
    procedure WmEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;

    function CanPopupMenu(X, Y: integer): boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Reset; virtual;
    procedure FullExtent; virtual;
    function IsBestFitScale: boolean; virtual;
    function IsBestFit: boolean; virtual;
    procedure BestFit; virtual;
    procedure FitRect(X1, Y1, X2, Y2: double); virtual;
    procedure Repaint; override;
    procedure Refresh; virtual;
    procedure SetViewXYSc(CenterX, CenterY, Scale: double); virtual;

    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;

    function HasGraphic: boolean; virtual;
    function GraphWidth: integer; virtual;
    function GraphHeight: integer; virtual;

    function ScreenToImageD(D: integer): double; virtual;
    function ScreenToImageX(X: integer): double; virtual;
    function ScreenToImageY(Y: integer): double; virtual;

    function ImageToScreenD(D: double): integer; virtual;
    function ImageToScreenX(X: double): integer; virtual;
    function ImageToScreenY(Y: double): integer; virtual;
                                                
    function GetStepScale(vs: double; ds: integer): double; virtual;

    property Graphic: TGraphic read GetGraphic write SetGraphic;
    property Canvas;
    property MouseDowned: boolean read FMouseDowned;
    property ImgPopupMenu: TPopupMenu read FImgPopupMenu write FImgPopupMenu;
    property SelRect: TRect read FSelRect write FSelRect;
    property LastPopupPoint: TPoint read FLastPopupPoint;
    property LastMouseDownPos: TPoint read FLastMouseDownPos write FLastMouseDownPos;
  published
    property Image: TImage read FImage write SetImage;
    property ViewScale: double read FViewScale write SetViewScale;
    property ScaleStep: double read FScaleStep write FScaleStep;
    property ViewCenterX: double read FViewCenterX write SetViewCenterX;
    property ViewCenterY: double read FViewCenterY write SetViewCenterY;
    property MouseAction: TMouseViewAction read FMouseAction write SetMouseAction;
    property KeyActions: boolean read FKeyActions write FKeyActions;
    property MaxViewScale: double read FMaxViewScale write SetMaxViewScale;
    property CanDragOutOfSize: boolean read FCanDragOutOfSize
      write SetCanDragOutOfSize default True;
    property RotateAngle: TRotateAngle
      read FRotateAngle write SetRotateAngle default raZero;
    property Scrollbars: boolean read FScrollbars write SetScrollbars;

    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnViewChanged: TNotifyEvent read FOnViewChanged write FOnViewChanged;

    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

const
  crZoomIn = crSizeNESW;
  crZoomOut = crSizeNWSE;
  crPan = crSizeAll;
  crPanDown = crSizeAll;
  crSelectA = crDefault;
  crZoomRect = crSizeNESW;
  crSelectLink = crDrag;

  DEF_IMGV_SCROLL_DIST = 40;

procedure Register;
function VE(const Value1, Value2: double): boolean;

implementation

uses
{$IFDEF USE_IMAGEUTIL}ImageUtil, {$ENDIF}Forms, Types;

procedure Register;
begin
  RegisterComponents('Samples', [TImageView]);
end;

function VE(const Value1, Value2: double): boolean;
var
  D1: double;
begin
  D1 := Value2 - Value1;
  if (D1 > -0.000000001) and (D1 < 0.000000001) then
    Result := True
  else
    Result := False;
end;

{ TImageView }

procedure TImageView.BestFit;
begin
  FViewCenterX := 0;
  FViewCenterY := 0;
  if HasGraphic then
  begin
    if FRotateAngle in [raZero, ra180] then
    begin
      if Width / Height < GraphWidth / GraphHeight then
        FViewScale := Width / GraphWidth
      else
        FViewScale := Height / GraphHeight;
      if FViewScale > 1 then
        FViewScale := 1;
    end
    else
    begin
      if Width / Height < GraphHeight / GraphWidth then
        FViewScale := Width / GraphHeight
      else
        FViewScale := Height / GraphWidth;
      if FViewScale > 1 then
        FViewScale := 1;
    end;
  end
  else
    FViewScale := 1;
  Refresh;
end;

procedure TImageView.BufDraw;
var
  R: TRect;
  cx, cy, CW, Ch: double;
  FWidth, FHeight: integer;
begin
  if FUpdateCounter > 0 then
    Exit;
  CheckDragOutSize;

  FWidth := Width;
  FHeight := Height;
  if FRotateAngle in [ra90, ra270] then
  begin
    if FWidth < Height then
      FWidth := Height;
    FHeight := FWidth;
  end;

  FBufmap.Width := FWidth;
  FBufmap.Height := FHeight;

  with FBufmap.Canvas do
  begin
    if Assigned(Graphic) then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      R := Rect(0, 0, FWidth, FHeight);
      FillRect(R);

      if Graphic is TBitmap then
      begin
        CW := FWidth / 2 / FViewScale;
        Ch := FHeight / 2 / FViewScale;
        cx := GraphWidth / 2 + FViewCenterX;
        cy := GraphHeight / 2 + FViewCenterY;

        StretchBlt(FBufmap.Canvas.Handle, 0, 0, FWidth, FHeight,
          TBitmap(FGraphic).Canvas.Handle,
          Round(cx - CW),
          Round(cy - Ch),
          Round(CW * 2),
          Round(Ch * 2), SRCCOPY);
      end
      else if (FGraphic is TJpegImage) or (FGraphic is TIcon) then
      begin
        if FViewScale <= 1 then
        begin
          CW := GraphWidth / 2;
          Ch := GraphHeight / 2;
          cx := FWidth / 2;
          cy := FHeight / 2;
          R.Left := Round(cx - CW * FViewScale - FViewCenterX * FViewScale);
          R.Right := Round(cx + CW * FViewScale - FViewCenterX * FViewScale);
          R.Top := Round(cy - Ch * FViewScale - FViewCenterY * FViewScale);
          R.Bottom := Round(cy + Ch * FViewScale - FViewCenterY * FViewScale);
          StretchDraw(R, FGraphic);
        end
        else
        begin
          CW := FWidth / 2 / FViewScale;
          Ch := FHeight / 2 / FViewScale;
          cx := GraphWidth / 2 + FViewCenterX;
          cy := GraphHeight / 2 + FViewCenterY;

          FBufmapB.Width := FBufmap.Width;
          FBufmapB.Height := FBufmap.Height;
          with FBufmapB.Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := Self.Color;
            R := Rect(0, 0, Width, Height);
            FillRect(R);
          end;
          FBufmapB.Canvas.Draw(-Round(cx - CW), -Round(cy - Ch), FGraphic);

          StretchBlt(FBufmap.Canvas.Handle, 0, 0, FWidth, FHeight,
            FBufmapB.Canvas.Handle,
            0,
            0,
            Round(CW * 2),
            Round(Ch * 2), SRCCOPY);
        end;
      end
      else
      begin
        CW := GraphWidth / 2;
        Ch := GraphHeight / 2;
        cx := FWidth / 2;
        cy := FHeight / 2;
        R.Left := Round(cx - CW * FViewScale - FViewCenterX * FViewScale);
        R.Right := Round(cx + CW * FViewScale - FViewCenterX * FViewScale);
        R.Top := Round(cy - Ch * FViewScale - FViewCenterY * FViewScale);
        R.Bottom := Round(cy + Ch * FViewScale - FViewCenterY * FViewScale);
        StretchDraw(R, FGraphic);
      end;
    end
    else
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      R := Rect(0, 0, FWidth, FHeight);
      FillRect(R);
    end;
  end;
end;

function TImageView.CanPopupMenu(X, Y: integer): boolean;
begin
  Result := True;
end;

procedure TImageView.CheckActCursor;
var
  cur: TCursor;
begin

  if ((GetKeyState(VK_MENU) and $80) <> 0) or FTmpPanning then
  begin
    if FMouseDowned then
      cur := crPanDown
    else
      cur := crPan;
  end
  else
    case FMouseAction of
      vaPan:
        if FMouseDowned then
          cur := crPanDown
        else
          cur := crPan;
      vaZoomIn:
        if (GetKeyState(VK_SHIFT) and $80) = 0 then
        begin
          cur := crZoomIn;
        end
        else
        begin
          cur := crZoomOut;
        end;
      vaZoomOut:
      begin
        if (GetKeyState(VK_SHIFT) and $80) <> 0 then
        begin
          cur := crZoomIn;
        end
        else
        begin
          cur := crZoomOut;
        end;
      end;
      vaAuto:
        cur := crSelectA;
      else
        cur := crDefault;
    end;

  if Cursor <> cur then
  begin
    Cursor := cur;
  end;
end;

procedure TImageView.CheckDragOutSize;
var
  MinScaleX, MinScaleY, cx, cy, CW, Ch, XX, YY: double;
begin
  if not CanDragOutOfSize and HasGraphic then
  begin
    MinScaleX := Width / GraphWidth;
    MinScaleY := Height / GraphHeight;

    CW := GraphWidth / 2;
    Ch := GraphHeight / 2;
    cx := Width / 2;
    cy := Height / 2;

    XX := (cx - CW * FViewScale) / FViewScale;
    YY := (cy - Ch * FViewScale) / FViewScale;

    if FViewScale < MinScaleX then
      FViewCenterX := 0
    else
    begin
      if (FViewCenterX < XX) and (FViewCenterX > -XX) then
        FViewCenterX := 0
      else if FViewCenterX < XX then
        FViewCenterX := XX
      else if FViewCenterX > -XX then
        FViewCenterX := -XX;
    end;

    if FViewScale < MinScaleY then
      FViewCenterY := 0
    else
    begin
      if (FViewCenterY < YY) and (FViewCenterY > -YY) then
        FViewCenterY := 0
      else if FViewCenterY < YY then
        FViewCenterY := YY
      else if FViewCenterY > -YY then
        FViewCenterY := -YY;
    end;

  end;
end;

procedure TImageView.CheckViewChanged;
begin
  if VE(FViewCenterX, FLastVX) and VE(FViewCenterY, FLastVY) and
    VE(FViewScale, FLastVS) then
    Exit;
  FLastVX := FViewCenterX;
  FLastVY := FViewCenterY;
  FLastVS := FViewScale;
  if Assigned(FOnViewChanged) then
    FOnViewChanged(Self);
  RecreateScrollbars;
end;

function TImageView.DoCMMouseWheel(Shift: TShiftState; dx, dy: integer): boolean;
var
  t, px, py: integer;
  pt: TPoint;
begin
  Result := True;
  if ssShift in Shift then
  begin
    //注意：仅WIN需要转换SHIFT状态，苹果MAC系统不需要
    t := dx;
    dx := dy;
    dy := t;
  end;

  if ssCtrl in Shift then
  begin
    if dx + dy > 0 then
    begin
      pt := Point(0, 0);
      if GetCursorPos(pt) then
      begin
        pt := ScreenToClient(pt);
        px := pt.X - Width div 2;
        py := pt.Y - Height div 2;
        t := Height div 8;
        if t = 0 then
          t := 20;
        py := py div t;
        t := Width div 8;
        if t = 0 then
          t := 20;
        px := px div t;
        t := t div 2;
        Self.SetViewXYSc(ViewCenterX + px * ScreenToImageD(t),
          ViewCenterY + py * ScreenToImageD(t), ViewScale / 1.18);
      end
      else
        ViewScale := ViewScale / 1.18;
    end
    else if dx + dy < 0 then
    begin
      if GetCursorPos(pt) then
      begin
        pt := ScreenToClient(pt);
        px := pt.X - Width div 2;
        py := pt.Y - Height div 2;
        t := Height div 8;
        if t = 0 then
          t := 20;
        py := py div t;
        t := Width div 8;
        if t = 0 then
          t := 20;
        px := px div t;
        t := t div 2;
        Self.SetViewXYSc(ViewCenterX + px * ScreenToImageD(t),
          ViewCenterY + py * ScreenToImageD(t), ViewScale * 1.18);
      end
      else
        ViewScale := ViewScale * 1.18;
    end;
  end
  else
  begin
    if dx <> 0 then
      ViewCenterX := ViewCenterX + dx * ScreenToImageD(Width div 20);
    if dy <> 0 then
      ViewCenterY := ViewCenterY + dy * ScreenToImageD(Height div 20);
  end;

end;

constructor TImageView.Create(AOwner: TComponent);
begin
  inherited;
  //  ControlStyle := ControlStyle + [csReplicatable];
  Width := 105;
  Height := 105;
  FMaxViewScale := 200;
  FCanDragOutOfSize := True;
  FRotateAngle := raZero;
  FKeyActions := True;
  FScaleStep := 1.5;

  FHookLastWidth := Width;
  FHookLastHeight := Height;

  Self.FLastMouseDownPos.X := DEF_INIT_LAST_IMGV_MOUSE_POS_X;
  Self.FLastMouseDownPos.Y := DEF_INIT_LAST_IMGV_MOUSE_POS_Y;
  FBufmap := TBitmap.Create;
  FBufmapB := TBitmap.Create;
  ResetView;
  TabStop := True;
end;

procedure TImageView.DblClick;
begin
  FMouseDowned := False;
  FSelDragging := False;
  //FSkipOneClick := True;
  inherited;
end;

function TImageView.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean;
begin
  Result := DoCMMouseWheel(Shift, 0, 1);
end;

function TImageView.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean;
begin
  Result := DoCMMouseWheel(Shift, 0, -1);
end;

function TImageView.DoMouseWheelLeft(Shift: TShiftState; MousePos: TPoint): boolean;
begin
  Result := DoCMMouseWheel(Shift, -1, 0);
end;

function TImageView.DoMouseWheelRight(Shift: TShiftState; MousePos: TPoint): boolean;
begin
  Result := DoCMMouseWheel(Shift, 1, 0);
end;

destructor TImageView.Destroy;
begin
  FBufmap.Free;
  FBufmapB.Free;
  inherited;
end;

procedure TImageView.DoCustMD(Button: TMouseButton; X, Y: integer; Shift: TShiftState);
begin
end;

procedure TImageView.DoCustMU(Button: TMouseButton; X, Y: integer; Shift: TShiftState);
begin
end;

procedure TImageView.DoCustMV(X, Y: integer; Shift: TShiftState);
begin
end;

procedure TImageView.DoRectSelectMD(X, Y: integer; Shift: TShiftState);
begin
end;

function TImageView.DoRectSelectMU(X1, Y1, X2, Y2: integer; Shift: TShiftState): boolean;
begin
  Result := False;
end;

procedure TImageView.DoRectSelectMV(X, Y: integer; Shift: TShiftState);
begin
end;

procedure TImageView.DrawImgRect;
var
  R: TRect;
begin
  if not HasGraphic then
    Exit;

  Exit;
  if (RotateAngle = raZero) then
  begin
    R.Left := ImageToScreenX(0) - 1;
    R.Right := ImageToScreenX(GraphWidth) + 1;
    R.Top := ImageToScreenY(0) - 1;
    R.Bottom := ImageToScreenY(GraphHeight) + 1;
  end
  else
  begin
    Exit;
  end;

  with Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    Pen.Mode := pmCopy;

    Rectangle(R);
  end;
end;

procedure TImageView.DrawRectLine(X, Y: integer; bClearLast: boolean);
begin
  if FTmpPanning then
    Exit;
  with Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Color := clFuchsia;
    Pen.Style := psDot;
    Pen.Mode := pmNotXor;

    if bClearLast then
      Rectangle(FOldMouseP.X, FOldMouseP.Y, FLastMouseP.X, FLastMouseP.Y);

    FLastMouseP := Point(X, Y);
    Rectangle(FOldMouseP.X, FOldMouseP.Y, FLastMouseP.X, FLastMouseP.Y);
  end;
end;

procedure TImageView.FitRect(X1, Y1, X2, Y2: double);
var
  W, H: double;
begin
  FViewCenterX := (X1 + X2) / 2;
  FViewCenterY := (Y1 + Y2) / 2;
  W := Abs(X2 - X1);
  H := Abs(Y2 - Y1);
  if Width / Height < W / H then
    FViewScale := Width / W
  else
    FViewScale := Height / H;
  Refresh;
end;

procedure TImageView.FullExtent;
begin
  FViewCenterX := 0;
  FViewCenterY := 0;
  if HasGraphic then
  begin
    if Width / Height < GraphWidth / GraphHeight then
      FViewScale := Width / GraphWidth
    else
      FViewScale := Height / GraphHeight;
  end
  else
    FViewScale := 1;
  Refresh;
end;

function TImageView.IsBestFitScale: boolean;
var
  vs: double;
begin
  if HasGraphic then
  begin
    if FRotateAngle in [raZero, ra180] then
    begin
      if Width / Height < GraphWidth / GraphHeight then
        vs := Width / GraphWidth
      else
        vs := Height / GraphHeight;
      if vs > 1 then
        vs := 1;
    end
    else
    begin
      if Width / Height < GraphHeight / GraphWidth then
        vs := Width / GraphHeight
      else
        vs := Height / GraphWidth;
      if vs > 1 then
        vs := 1;
    end;
  end
  else
    vs := 1;
  if VE(vs, FViewScale) then
    Result := True
  else
    Result := False;
end;

function TImageView.GetGraphic: TGraphic;
begin
  try
    if Assigned(FImage) then
    begin
      if FGraphic <> FImage.Picture.Graphic then
        FGraphic := FImage.Picture.Graphic;
    end;
  except
    FImage := nil;
    FGraphic := nil;
  end;
  Result := FGraphic;
end;

function TImageView.GraphHeight: integer;
begin
  if not Assigned(Graphic) then
    Result := Height
  else
    Result := Graphic.Height;
end;

function TImageView.GraphWidth: integer;
begin
  if not Assigned(Graphic) then
    Result := Width
  else
    Result := Graphic.Width;
end;

function TImageView.HasGraphic: boolean;
begin
  Result := Assigned(Graphic);
end;

function TImageView.ImageToScreenD(D: double): integer;
begin
  Result := Round(D * FViewScale);
end;

function TImageView.ImageToScreenX(X: double): integer;
var
  cx, CW: double;
begin
  CW := GraphWidth / 2;
  cx := Width / 2;
  if VE(FViewScale, 1) then
    Result := Round(X) - Round(CW) - Round(FViewCenterX) + Round(cx)
  else
    Result := Round((X - CW - FViewCenterX) * FViewScale + cx);
end;

function TImageView.ImageToScreenY(Y: double): integer;
var
  cy, Ch: double;
begin
  Ch := GraphHeight / 2;
  cy := Height / 2;
  if VE(FViewScale, 1) then
    Result := Round(Y) - Round(Ch) - Round(FViewCenterY) + Round(cy)
  else
    Result := Round((Y - Ch - FViewCenterY) * FViewScale + cy);
end;

function TImageView.IsBestFit: boolean;
var
  vx, vy, vs: double;
begin
  vx := 0;
  vy := 0;
  if HasGraphic then
  begin
    if FRotateAngle in [raZero, ra180] then
    begin
      if Width / Height < GraphWidth / GraphHeight then
        vs := Width / GraphWidth
      else
        vs := Height / GraphHeight;
      if vs > 1 then
        vs := 1;
    end
    else
    begin
      if Width / Height < GraphHeight / GraphWidth then
        vs := Width / GraphHeight
      else
        vs := Height / GraphWidth;
      if vs > 1 then
        vs := 1;
    end;
  end
  else
    vs := 1;
  if VE(vx, FViewCenterX) and VE(vy, FViewCenterY) and VE(vs, FViewScale) then
    Result := True
  else
    Result := False;
end;

procedure TImageView.KeyDown(var Key: word; Shift: TShiftState);
begin
  inherited;
  if KeyActions then    
  if not (ssCtrl in Shift) and not (ssShift in Shift) and not (ssAlt in Shift) then
    case Key of
      VK_LEFT:
        ViewCenterX := ViewCenterX - ScreenToImageD(Width div 5);
      VK_RIGHT:
        ViewCenterX := ViewCenterX + ScreenToImageD(Width div 5);
      VK_UP:
        ViewCenterY := ViewCenterY - ScreenToImageD(Height div 5);
      VK_DOWN:
        ViewCenterY := ViewCenterY + ScreenToImageD(Height div 5);
    end;
  CheckActCursor;
end;

procedure TImageView.KeyPress(var Key: char);
begin
  inherited;
  if KeyActions then
    case Key of
      '+', '=':
        ViewScale := GetStepScale(ViewScale * Self.ScaleStep, 1);
      '-', '_':
        ViewScale := GetStepScale(ViewScale / Self.ScaleStep, -1);
      '/', 'f', 'F':
        BestFit;
      'r', 'R':
        Reset;
      'z', 'Z':
        MouseAction := vaZoomIn;
      'x', 'X':
        MouseAction := vaZoomOut;
      'h', 'H':
        MouseAction := vaPan;
      'a', 'A':
        MouseAction := vaAuto;
      's', 'S':
        MouseAction := vaRectSelect;
    end;
end;

function TImageView.GetStepScale(vs: double; ds: integer): double;
const
  DEF_SCALE_FACTS: array[0..13] of integer = (10, 25, 50, 70, 80, 90, 100, 125, 150, 175, 200, 250, 300, 400);
var
  I: integer;
  d1, d2, d3: double;
begin
  Result := vs;
  for I := 0 to High(DEF_SCALE_FACTS) do
  begin
    if VE(FViewScale, DEF_SCALE_FACTS[I] / 100) then
    begin
      if (ds = 1) and (I < High(DEF_SCALE_FACTS)) then
        Result := DEF_SCALE_FACTS[I + 1] / 100
      else if (ds = -1) and (I > 0) then
        Result := DEF_SCALE_FACTS[I - 1] / 100
      else if ds = 0 then
        Result := DEF_SCALE_FACTS[I] / 100;
      Exit;
    end;
  end;

  for I := 0 to High(DEF_SCALE_FACTS) do
  begin
    d1 := DEF_SCALE_FACTS[I] / 100;
    if I < High(DEF_SCALE_FACTS) then
      d3 := DEF_SCALE_FACTS[I + 1] / 100
    else
      d3 := d1 * 1.5;
    d2 := (d1 + d3) / 2;
    if (FViewScale > d1) and (FViewScale < d3) then
    begin
      if ds = 1 then
        Result := d3
      else if ds = 0 then
        Result := d2
      else if ds = -1 then
        Result := d1
      else
        Result := d2;
      Exit;
    end;
  end;
end;

procedure TImageView.KeyUp(var Key: word; Shift: TShiftState);
begin
  inherited;
  CheckActCursor;
end;

procedure TImageView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  bSaveMD: boolean;
  pt: TPoint;
begin
  FLastMouseDownPos.X := Round(Self.ScreenToImageX(X));
  FLastMouseDownPos.Y := Round(Self.ScreenToImageY(Y));
  if FSkipOneClick then
  begin
    FSkipOneClick := False;
    Exit;
  end;
  if CanFocus then
    SetFocus;
  FLastPopupPoint := Point(0, 0);
  if FLastPopupTick <> 0 then
  begin
    if Abs(int64(GetTickCount64) - FLastPopupTick) < 100 then
    begin
      FLastPopupTick := 0;
      Exit;
    end;
    FLastPopupTick := 0;
  end;
  bSaveMD := FMouseDowned;

  FTmpPanning := False;
  if ssAlt in Shift then
  begin
    if Button = mbLeft then
    begin
      FMouseDowned := True;
      FTmpPanning := True;
      FOldMouseP := Point(X, Y);
      Cursor := crPanDown;
    end
    else
    begin
      FMouseDowned := False;
      Cursor := crPan;
    end;
    Exit;
  end;

  case FMouseAction of
    vaPan:
      if Button = mbLeft then
      begin
        FMouseDowned := True;
        FOldMouseP := Point(X, Y);
        Cursor := crPanDown;
      end
      else
      begin
        FMouseDowned := False;
        Cursor := crPan;
      end;
    vaZoomIn, vaZoomOut:
      if Button = mbLeft then
      begin
        FMouseDowned := True;
        FOldMouseP := Point(X, Y);
        DrawRectLine(X, Y, False);
      end
      else if FMouseDowned then
      begin
        FMouseDowned := False;
        DrawRectLine(X, Y, True);
        DrawRectLine(X, Y, False);
      end;
    vaRectSelect:
    begin
      if Button = mbLeft then
      begin
        FSelDragging := False;
        FMouseDowned := True;
        FOldMouseP := Point(X, Y);
        DoRectSelectMD(X, Y, Shift);
        if not FSelDragging then
          DrawRectLine(X, Y, False);
      end
      else if FMouseDowned then
      begin
        FMouseDowned := False;
        if not FSelDragging then
        begin
          DrawRectLine(X, Y, True);
          DrawRectLine(X, Y, False);
        end;
        FSelDragging := False;
      end
      else
        FSelDragging := False;
    end;
    vaAuto:
    begin
      if not FMouseDowned then
      begin
        FMouseDowned := True;
        if Button = mbLeft then
        begin
          FZooming := True;
          FOldMouseP := Point(X, Y);
          DrawRectLine(X, Y, False);
        end
        else
        begin
          FZooming := False;
          FOldMouseP := Point(X, Y);
        end;
      end
      else
      begin
        if FZooming then
        begin
          if Button <> mbLeft then
          begin
            FMouseDowned := False;
            DrawRectLine(X, Y, True);
            DrawRectLine(X, Y, False);
          end;
        end;
      end;
    end;
  end;
  DoCustMD(Button, X, Y, Shift);
  inherited;
  if not bSaveMD and (Button = mbRight) then
    if CanPopupMenu(X, Y) then
      if Assigned(FImgPopupMenu) then
      begin
        FMouseDowned := False;
        pt := Point(X, Y);
        pt := ClientToScreen(pt);
        FLastPopupPoint := pt;
        FImgPopupMenu.Popup(pt.x, pt.y);
        FLastPopupTick := GetTickCount64;
      end;
end;

procedure TImageView.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  CheckActCursor;
  if FTmpPanning then
  begin
    if FMouseDowned then
      if (Abs(X - FOldMouseP.X) > 3) or (Abs(Y - FOldMouseP.Y) > 3) then
      begin
        begin
          FViewCenterX := FViewCenterX - (X - FOldMouseP.X) / FViewScale;
          FViewCenterY := FViewCenterY - (Y - FOldMouseP.Y) / FViewScale;
        end;
        Refresh;

        FOldMouseP := Point(X, Y);
      end;
    Exit;
  end;

  case FMouseAction of
    vaPan:
      if FMouseDowned then
        if (Abs(X - FOldMouseP.X) > 3) or (Abs(Y - FOldMouseP.Y) > 3) then
        begin
          {if FRotateAngle = ra90 then
          begin
            FViewCenterY := FViewCenterY - (X - FOldMouseP.X) / FViewScale;
            FViewCenterX := FViewCenterX - (Y - FOldMouseP.Y) / FViewScale;
          end
          else}
          begin
            FViewCenterX := FViewCenterX - (X - FOldMouseP.X) / FViewScale;
            FViewCenterY := FViewCenterY - (Y - FOldMouseP.Y) / FViewScale;
          end;
          Refresh;

          FOldMouseP := Point(X, Y);
        end;
    vaZoomIn, vaZoomOut:
      if FMouseDowned then
        DrawRectLine(X, Y, True);
    vaRectSelect:
      if FMouseDowned then
      begin
        DoRectSelectMV(X, Y, Shift);
        if not FSelDragging then
          DrawRectLine(X, Y, True);
      end;
    vaAuto:
    begin
      if FZooming then
      begin
        if FMouseDowned then
          DrawRectLine(X, Y, True);
      end
      else
      begin
        if FMouseDowned then
          if (Abs(X - FOldMouseP.X) > 3) or (Abs(Y - FOldMouseP.Y) > 3) then
          begin
            FViewCenterX := FViewCenterX - (X - FOldMouseP.X) / FViewScale;
            FViewCenterY := FViewCenterY - (Y - FOldMouseP.Y) / FViewScale;
            Refresh;

            FOldMouseP := Point(X, Y);
          end;
      end;
    end;
  end;
  DoCustMV(X, Y, Shift);
  inherited;
end;

procedure TImageView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  cx, cy: integer;
  SvMouseDown: boolean;
begin
  SvMouseDown := FMouseDowned;
  FMouseDowned := False;

  if FTmpPanning then
  begin
    FTmpPanning := False;
    CheckActCursor;
    Exit;
  end;
  CheckActCursor;


  case FMouseAction of
    vaZoomIn:
      if SvMouseDown then
      begin
        if (GetKeyState(VK_SHIFT) and $80) <> 0 then
        begin
          DrawRectLine(X, Y, True);
          DrawRectLine(X, Y, False);
          if Abs(FLastMouseP.X - FOldMouseP.X) > 8 then
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewScale := FViewScale / (Width / Abs(FLastMouseP.X - FOldMouseP.X));
            FViewCenterX := FViewCenterX - (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY - (cy - Height div 2) / FViewScale;
            Refresh;
          end
          else
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewCenterX := FViewCenterX + (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY + (cy - Height div 2) / FViewScale;
            FViewScale := FViewScale / Self.ScaleStep;
            Refresh;
          end;
        end
        else
        begin
          DrawRectLine(X, Y, True);
          DrawRectLine(X, Y, False);
          if Abs(FLastMouseP.X - FOldMouseP.X) > 8 then
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewCenterX := FViewCenterX + (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY + (cy - Height div 2) / FViewScale;
            FViewScale := FViewScale * (Width / Abs(FLastMouseP.X - FOldMouseP.X));
            if (FViewScale > FMaxViewScale) and (FMaxViewScale <> 0) then
              FViewScale := FMaxViewScale;
            Refresh;
          end
          else
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewCenterX := FViewCenterX + (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY + (cy - Height div 2) / FViewScale;
            FViewScale := FViewScale * Self.ScaleStep;
            if (FViewScale > FMaxViewScale) and (FMaxViewScale <> 0) then
              FViewScale := FMaxViewScale;
            Refresh;
          end;
        end;
      end;
    vaZoomOut:
      if SvMouseDown then
      begin
        if (GetKeyState(VK_SHIFT) and $80) <> 0 then
        begin
          DrawRectLine(X, Y, True);
          DrawRectLine(X, Y, False);
          if Abs(FLastMouseP.X - FOldMouseP.X) > 8 then
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewScale := FViewScale / (Width / Abs(FLastMouseP.X - FOldMouseP.X));
            FViewCenterX := FViewCenterX - (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY - (cy - Height div 2) / FViewScale;
            Refresh;
          end
          else
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewCenterX := FViewCenterX + (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY + (cy - Height div 2) / FViewScale;
            FViewScale := FViewScale / Self.ScaleStep;
            Refresh;
          end;
        end
        else
        begin
          DrawRectLine(X, Y, True);
          DrawRectLine(X, Y, False);
          if Abs(FLastMouseP.X - FOldMouseP.X) > 8 then
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewScale := FViewScale / (Width / Abs(FLastMouseP.X - FOldMouseP.X));
            FViewCenterX := FViewCenterX - (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY - (cy - Height div 2) / FViewScale;
            Refresh;
          end
          else
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewCenterX := FViewCenterX + (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY + (cy - Height div 2) / FViewScale;
            FViewScale := FViewScale / Self.ScaleStep;
            Refresh;
          end;
        end;
      end;
    vaRectSelect:
      if SvMouseDown then
      begin
        if not FSelDragging then
        begin
          DrawRectLine(X, Y, True);
          DrawRectLine(X, Y, False);
        end;

        if not DoRectSelectMU(FOldMouseP.X, FOldMouseP.Y, X, Y, Shift) then
          if Abs(FLastMouseP.X - FOldMouseP.X) > 8 then
          begin
            FSelRect.Left := Round(ScreenToImageX(FOldMouseP.X));
            FSelRect.Top := Round(ScreenToImageY(FOldMouseP.Y));
            FSelRect.Right := Round(ScreenToImageX(FLastMouseP.X));
            FSelRect.Bottom := Round(ScreenToImageY(FLastMouseP.Y));
            if FSelRect.Left > FSelRect.Right then
            begin
              cx := FSelRect.Left;
              FSelRect.Left := FSelRect.Right;
              FSelRect.Right := cx;
            end;
            if FSelRect.Top > FSelRect.Bottom then
            begin
              cy := FSelRect.Top;
              FSelRect.Top := FSelRect.Bottom;
              FSelRect.Bottom := cy;
            end;
            Refresh;
          end
          else
          begin
            FSelRect := Rect(0, 0, 0, 0);
            Refresh;
          end;

      end;
    vaAuto:
      if FZooming and SvMouseDown then
      begin
        DrawRectLine(X, Y, True);
        DrawRectLine(X, Y, False);
        if Abs(FLastMouseP.X - FOldMouseP.X) > 8 then
        begin
          if FLastMouseP.X < FOldMouseP.X then
            BestFit
          else
          begin
            cx := (FLastMouseP.X + FOldMouseP.X) div 2;
            cy := (FLastMouseP.Y + FOldMouseP.Y) div 2;
            FViewCenterX := FViewCenterX + (cx - Width div 2) / FViewScale;
            FViewCenterY := FViewCenterY + (cy - Height div 2) / FViewScale;
            FViewScale := FViewScale * (Width / Abs(FLastMouseP.X - FOldMouseP.X));
            if (FViewScale > FMaxViewScale) and (FMaxViewScale <> 0) then
              FViewScale := FMaxViewScale;
            Refresh;
          end;
        end;
      end;
    vaPan:
    begin
      Cursor := crPan;
    end;
  end;

  FMouseDowned := SvMouseDown;
  try
    DoCustMU(Button, X, Y, Shift);
  finally
    FMouseDowned := False;
  end;


  inherited;
end;

procedure TImageView.Paint;
{$IFDEF USE_IMAGEUTIL}
const
  cAngle: array[TRotateAngle] of integer = (0, 90, 180, 270);
{$ENDIF}
var
  FTmpBitmap: TBitmap;
begin
  if (FBufmap.Width <> Width) or (FBufmap.Height <> Height) then
    try
      BufDraw;
    except
    end;

  Canvas.Font := Font;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;

  if FRotateAngle = raZero then
    BitBlt(Canvas.Handle, 0, 0, Width, Height,
      FBufmap.Canvas.Handle, 0, 0, SRCCOPY)
  else
  begin
    FTmpBitmap := TBitmap.Create;
    try
{$IFDEF USE_IMAGEUTIL}
      BitmapRotate(FBufmap, FTmpBitmap, cAngle[FRotateAngle]);
{$ENDIF}

      BitBlt(Canvas.Handle, 0, 0, Width, Height,
        FTmpBitmap.Canvas.Handle, (FTmpBitmap.Width - Width) div 2,
        (FtmpBitmap.Height - Height) div 2, SRCCOPY);
    finally
      FTmpBitmap.Free;
    end;
  end;

  DrawImgRect;

  case FMouseAction of
    vaZoomIn, vaZoomOut:
      if FMouseDowned then
        DrawRectLine(FLastMouseP.X, FLastMouseP.Y, False);
    vaRectSelect:
      if FMouseDowned then
        if not FSelDragging then
          DrawRectLine(FLastMouseP.X, FLastMouseP.Y, False);
  end;
  if FMouseAction = vaRectSelect then
    if (FSelRect.Left <> 0) or (FSelRect.Right <> 0) then
      with Canvas do
      begin
        Brush.Style := bsClear;
        Pen.Color := clFuchsia;
        Pen.Style := psDot;
        Pen.Mode := pmCopy; //NotXor;

        Rectangle(ImageToScreenX(FSelRect.Left), ImageToScreenY(FSelRect.Top),
          ImageToScreenX(FSelRect.Right) + 1, ImageToScreenY(FSelRect.Bottom) + 1);
        Pen.Style := psSolid;
        Pen.Mode := pmXor;
        Rectangle(ImageToScreenX(FSelRect.Left), ImageToScreenY(FSelRect.Top),
          ImageToScreenX(FSelRect.Right) + 1, ImageToScreenY(FSelRect.Bottom) + 1);
        Pen.Style := psDot;
      end;

  if Assigned(FOnPaint) then
    FOnPaint(Self);
end;

procedure TImageView.RecreateScrollbars;
var
  AScrInfo: tagSCROLLINFO;
begin
  if not Visible then
    exit;
  if not HandleAllocated then
    Exit;

  FSkipResizing := True;
  try
    ShowScrollBar(Self.Handle, SB_BOTH, FScrollBars);
    if FScrollBars then
    begin
      with AScrInfo do
      begin
        cbSize := SizeOf(AScrInfo);
        fMask := SIF_POS + SIF_PAGE + SIF_RANGE;
        nMin := 0;
        nMax := GraphWidth;
        nPage := Round(ScreenToImageD(ClientWidth));
        nPos := Round(ScreenToImageX(0));
        if nPos < 0 then
          nPos := 0
        else if nPos > nMax then
          nPos := nMax;
        SetScrollInfo(Self.Handle, SB_HORZ, AScrInfo, True);

        nMax := GraphHeight;
        nPage := Round(ScreenToImageD(ClientHeight));
        nPos := Round(ScreenToImageY(0));
        if nPos < 0 then
          nPos := 0
        else if nPos > nMax then
          nPos := nMax;
        SetScrollInfo(Self.Handle, SB_VERT, AScrInfo, True);
      end;
    end;
  finally
    FSkipResizing := False;
  end;
end;

procedure TImageView.Refresh;
begin      
  if FUpdateCounter > 0 then
    Exit;
  CheckViewChanged;
  GetGraphic;
  Repaint;
  FHookX := ScreenToImageX(0);
  FHookY := ScreenToImageY(0);
end;

procedure TImageView.Repaint;
begin
  if FUpdateCounter > 0 then
    Exit;
  if csLoading in ComponentState then
    Exit;
  if not HandleAllocated then
    Exit;
  BufDraw;
  inherited;
end;

procedure TImageView.Reset;
begin
  ResetView;
  Refresh;
end;

procedure TImageView.ResetView;
begin
  FViewCenterX := 0;
  FViewCenterY := 0;
  FViewScale := 1;
end;

procedure TImageView.Resize;
begin
  inherited;
  if FHookTopLeft and (Abs(FViewScale - 1) <= 0.0001) and not FSkipResizing then
  begin
    if (Width <> FHookLastWidth) or (Height <> FHookLastHeight) then
    begin
      FHookLastWidth := Width;
      FHookLastHeight := Height;
      FViewCenterX := FViewCenterX + FHookX - ScreenToImageX(0);
      FViewCenterY := FViewCenterY + FHookY - ScreenToImageY(0);
      Refresh;
    end;
  end;
end;

function TImageView.ScreenToImageD(D: integer): double;
begin
  Result := D / FViewScale;
end;

function TImageView.ScreenToImageX(X: integer): double;
var
  cx, CW: double;
begin
  CW := GraphWidth / 2;
  cx := Width / 2;
  Result := CW + (X - cx) / FViewScale + FViewCenterX;
end;

function TImageView.ScreenToImageY(Y: integer): double;
var
  cy, Ch: double;
begin
  Ch := GraphHeight / 2;
  cy := Height / 2;
  Result := Ch + (Y - cy) / FViewScale + FViewCenterY;
end;

procedure TImageView.SetCanDragOutOfSize(const Value: boolean);
begin
  if FCanDragOutOfSize <> Value then
  begin
    FCanDragOutOfSize := Value;
    Refresh;
  end;
end;

procedure TImageView.SetGraphic(const Value: TGraphic);
begin
  if FGraphic <> Value then
  begin
    FGraphic := Value;
    FImage := nil;
    Refresh;
  end;
end;

procedure TImageView.SetImage(const Value: TImage);
begin
  if FImage <> Value then
  begin
    FImage := Value;
    if Assigned(FImage) then
      FGraphic := FImage.Picture.Graphic
    else
      FGraphic := nil;
    Refresh;
  end;
end;

procedure TImageView.SetMaxViewScale(const Value: double);
begin
  FMaxViewScale := Value;
  if FMaxViewScale < 0 then
    FMaxViewScale := 0;
  if (FViewScale > FMaxViewScale) and (FMaxViewScale <> 0) then
  begin
    FViewScale := FMaxViewScale;
    Refresh;
  end;
end;

procedure TImageView.SetMouseAction(const Value: TMouseViewAction);
begin
  if FMouseAction <> Value then
  begin
    FMouseAction := Value;
    CheckActCursor;
    Refresh;
  end;
end;

procedure TImageView.SetRotateAngle(const Value: TRotateAngle);
begin
  if FRotateAngle <> Value then
  begin
    FRotateAngle := Value;
    Repaint;
  end;
end;

procedure TImageView.SetScrollbars(const Value: boolean);
begin
  if FScrollbars <> Value then
  begin
    FScrollbars := Value;
    RecreateScrollbars;
  end;
end;

procedure TImageView.SetViewCenterX(const Value: double);
begin
  if FViewCenterX <> Value then
  begin
    FViewCenterX := Value;
    Refresh;
  end;
end;

procedure TImageView.SetViewCenterY(const Value: double);
begin
  if FViewCenterY <> Value then
  begin
    FViewCenterY := Value;
    Refresh;
  end;
end;

procedure TImageView.SetViewScale(const Value: double);
begin
  if FViewScale <> Value then
  begin
    FViewScale := Value;
    if (FViewScale > FMaxViewScale) and (FMaxViewScale <> 0) then
      FViewScale := FMaxViewScale;
    Refresh;
  end;
end;

procedure TImageView.SetViewXYSc(CenterX, CenterY, Scale: double);
begin
  FViewCenterX := CenterX;
  FViewCenterY := CenterY;
  FViewScale := Scale - 0.0001;
  ViewScale := Scale;
end;

procedure TImageView.BeginUpdate;
begin
  Inc(FUpdateCounter);
end;

procedure TImageView.EndUpdate;
begin     
  Dec(FUpdateCounter);
  if FUpdateCounter = 0 then
    Refresh;
end;

procedure TImageView.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  inherited;
  Msg.Result := Msg.Result or DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

procedure TImageView.WMHScroll(var Message: TWMHScroll);
var
  E: double;
begin
  case Message.ScrollCode of
    SB_LINEUP:
    begin
      //向前滚动
      E := ScreenToImageD(DEF_IMGV_SCROLL_DIST);
      ViewCenterX := ViewCenterX - E;
    end;
    SB_LINEDOWN:
    begin
      //向后滚动
      E := ScreenToImageD(DEF_IMGV_SCROLL_DIST);
      ViewCenterX := ViewCenterX + E;
    end;
    SB_PAGEUP:
    begin
      //向前翻页
      E := ScreenToImageD(ClientWidth div 2);
      ViewCenterX := ViewCenterX - E;
    end;
    SB_PAGEDOWN:
    begin
      //向后翻页
      E := ScreenToImageD(ClientWidth div 2);
      ViewCenterX := ViewCenterX + E;
    end;
    SB_THUMBPOSITION, SB_THUMBTRACK:
    begin
      if Message.Pos <= 0 then
        E := 0
      else if Message.Pos > GraphWidth then
        E := GraphWidth
      else
        E := Message.Pos;
      ViewCenterX := E + ScreenToImageD(ClientWidth div 2) - (GraphWidth div 2);
    end;
  end;
end;

procedure TImageView.WMVScroll(var Message: TWMVScroll);
var
  E: double;
begin
  case Message.ScrollCode of
    SB_LINEUP:
    begin
      //向前滚动
      E := ScreenToImageD(DEF_IMGV_SCROLL_DIST);
      ViewCenterY := ViewCenterY - E;
    end;
    SB_LINEDOWN:
    begin
      //向后滚动
      E := ScreenToImageD(DEF_IMGV_SCROLL_DIST);
      ViewCenterY := ViewCenterY + E;
    end;
    SB_PAGEUP:
    begin
      //向前翻页
      E := ScreenToImageD(ClientHeight div 2);
      ViewCenterY := ViewCenterY - E;
    end;
    SB_PAGEDOWN:
    begin
      //向后翻页
      E := ScreenToImageD(ClientHeight div 2);
      ViewCenterY := ViewCenterY + E;
    end;
    SB_THUMBPOSITION, SB_THUMBTRACK:
    begin
      if Message.Pos <= 0 then
        E := 0
      else if Message.Pos > GraphHeight then
        E := GraphHeight
      else
        E := Message.Pos;
      ViewCenterY := E + ScreenToImageD(ClientHeight div 2) - (GraphHeight div 2);
    end;
  end;
end;

procedure TImageView.WmEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

{$IFDEF USE_GISRES}
{$R ImgvCursors.res}

initialization
  Screen.Cursors[crSelectLink] := LoadCursor(HInstance, 'IG_SELECTLINK');
  Screen.Cursors[crZoomIn] := LoadCursor(HInstance, 'IG_ZOOMIN');
  Screen.Cursors[crZoomOut] := LoadCursor(HInstance, 'IG_ZOOMOUT');
  Screen.Cursors[crPan] := LoadCursor(HInstance, 'IG_PAN');
  Screen.Cursors[crZoomRect] := LoadCursor(HInstance, 'IG_ZOOMRECT');
  Screen.Cursors[crPanDown] := LoadCursor(HInstance, 'IG_PANDOWN');
{$ENDIF}

end.










