{
  ****************************************************************

  DMLGraph
  模型图控件

  By HUZZZ (huz0123@21cn.com)
  Date: 2005-10-01
  Guangzhou China

  从TImageView继承，实现模型图的缓冲绘制和平移缩放等操作

  *****************************************************************
}
unit DMLGraph;
         
{$IFDEF FPC}
{$MODE Delphi}
{$WARN 5057 off : Local variable "$1" does not seem to be initialized}   
{$ENDIF}

interface

uses              
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Variants, Classes,
  Graphics, Controls, ImgList, ExtCtrls,
  DMLObjs, ImgView, Forms, IniFiles;

type
  TOnLinkObjSelectedEvent = procedure(Sender: TObject; Obj1, Obj2: TDMLObj) of object;

  { TDMLGraph }

  TDMLGraph = class(TImageView)
  private
    FImages: TImageList;
    FOnSelectObj: TNotifyEvent;
    FSelectLinkingObj: Boolean; //添加连接时专用
    FOnLinkObjSelected: TOnLinkObjSelectedEvent;
    FModified: Boolean;
    FOnMoveObj: TNotifyEvent;
    FObjsMoved: Boolean;
    FSelectPanning: Boolean;
    FIsSelPanMoved: Boolean;
    //FMouseWheeling: Boolean;
    FDelayRefreshTimer: TTimer;
    FLastRefreshCx, FLastRefreshCy, FLastRefreshSc: Double;
    function GetBufmap: TBitmap;
    procedure SetSelectLinkingObj(const Value: Boolean);
    procedure SetModified(const Value: Boolean);
    { Private declarations }
  protected
    FDMLObjs: TDMLObjList;
    FDMLDrawer: TDMLDrawer;
                    
{$IFnDEF FPC}
    FMouseWheeling: Boolean;
    //Lazarus会在其它消息里重复触发鼠标滚轮，要禁止处理
    procedure CMMouseWheel(var Message: TCMMouseWheel); message CM_MOUSEWHEEL;
{$ENDIF}

    procedure GetDrawInfo;
    procedure BufDraw; override;
    procedure ResetView; override;
    procedure CheckViewChanged; override;

    procedure DrawRectLine(X, Y: Integer; bClearLast: Boolean); override;
    //接管选择模式下的鼠标事件（按下、移动、松开）
    procedure DoRectSelectMD(X, Y: Integer; Shift: TShiftState); override;
    procedure DoRectSelectMV(X, Y: Integer; Shift: TShiftState); override;
    function DoRectSelectMU(X1, Y1, X2, Y2: Integer; Shift: TShiftState): Boolean;
      override;
    procedure DoSelectObj; virtual;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: char); override;

    function CanPopupMenu(X, Y: Integer): Boolean; override;
    procedure CheckActCursor; override;
    procedure _OnDelayRefreshTimer(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function HasGraphic: Boolean; override;
    function GraphWidth: Integer; override;
    function GraphHeight: Integer; override;
    procedure AutoCheckGraphSize; virtual;

    procedure FitSelection; virtual;
    function IsBestFitScale: Boolean; override;
    function IsBestFit: Boolean; override;
    procedure BestFit; override;
    procedure MakeObjVisible(obj: TDMLObj); virtual; 
    procedure Refresh; override;
    procedure ResetRefreshTimer; virtual;

    procedure LoadFromFile(fn: string);
    procedure SaveToFile(fn: string);

    procedure Save(Ini: TCustomIniFile; Sec: string); virtual;
    procedure Load(Ini: TCustomIniFile; Sec: string); virtual;
    procedure SaveIniStream(AStream: TStream); virtual;
    procedure LoadIniStream(AStream: TStream); virtual;

    procedure SaveToStream(AStream: TStream); virtual;
    procedure LoadFromStream(AStream: TStream); virtual;

    function ImageToScreenX2(X: Double): Integer; virtual;
    function ImageToScreenY2(Y: Double): Integer; virtual;

    procedure ExportImage(Cnv: TCanvas; rLeft, rTop, rWidth, rHeight: Double); virtual;

    property DMLObjs: TDMLObjList read FDMLObjs;
    property DMLDrawer: TDMLDrawer read FDMLDrawer;
    property BufferBitmap: TBitmap read GetBufmap;
    property SelectLinkingObj: Boolean read FSelectLinkingObj write SetSelectLinkingObj;
    property Modified: Boolean read FModified write SetModified;
  published
    property Images: TImageList read FImages write FImages;
    property OnSelectObj: TNotifyEvent read FOnSelectObj write FOnSelectObj;
    property OnMoveObj: TNotifyEvent read FOnMoveObj write FOnMoveObj;
    property OnLinkObjSelected: TOnLinkObjSelectedEvent
      read FOnLinkObjSelected write FOnLinkObjSelected;
  end;

implementation

{ TDMLGraph }

constructor TDMLGraph.Create(AOwner: TComponent);
begin
  inherited;
  Color := clWhite;
  FDMLObjs := TDMLObjList.Create;
  FDMLDrawer := TDMLDrawer.Create;
  FDMLObjs.DMLDrawer := FDMLDrawer;
  FHookTopLeft := True;
  FScrollbars := True;
  FDelayRefreshTimer := TTImer.Create(Self);
  FDelayRefreshTimer.OnTimer := Self._OnDelayRefreshTimer;
  ResetView;
end;

destructor TDMLGraph.Destroy;
begin
  FDMLObjs.Free;
  FDMLDrawer.Free;
  inherited;
end;

procedure TDMLGraph.BufDraw;
var
  FWidth, FHeight: Integer;
begin
  if FUpdateCounter > 0 then
    Exit;
  CheckDragOutSize;

  FWidth := Width;
  FHeight := Height;
  if Width = 0 then
    Exit;
  if Height = 0 then
    Exit;
  if FBufmap = nil then
    Exit;

  if RotateAngle in [ra90, ra270] then
  begin
    if FWidth < Height then
      FWidth := Height;
    FHeight := FWidth;
  end;

  FBufmap.Width := FWidth;
  FBufmap.Height := FHeight;

  with FBufmap.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color;
    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Color := Color;
    Rectangle(0, 0, FWidth, FHeight);
  end;

  GetDrawInfo;

  with FBufmap.Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Color := RGB(233, 233, 233);
  end;
  if not FDMLDrawer.HideBoundRect then
    FDMLDrawer.DrawRectLine(ImageToScreenX(0), ImageToScreenY(0),
      ImageToScreenX(FDMLDrawer.DrawerWidth), ImageToScreenY(FDMLDrawer.DrawerHeight));

  FDMLObjs.PaintAll;  
  FLastRefreshCx := FViewCenterX;
  FLastRefreshCy := FViewCenterY;
  FLastRefreshSc := FViewScale;
end;

procedure TDMLGraph.DoRectSelectMD(X, Y: Integer; Shift: TShiftState);
var
  I, K: Integer;
  xx, yy: Double;
  obj1: TDMLObj;
begin
  FObjsMoved := False;
  FSelectPanning := False;
  FIsSelPanMoved := False;
  xx := ScreenToImageX(X);
  yy := ScreenToImageY(Y);
  I := FDMLObjs.FindItemAt(xx, yy);
  if ssCtrl in Shift then
  begin
    //按住CTRL键：永远做框选
    FSelDragging := False;
  end
  else if ssAlt in Shift then
  begin
    //按住Alt键：永远做平移
    FSelDragging := False;
    FSelectPanning := True;
  end
  else if (I >= 0) then //点中了对象，准备做对象移动
  begin
    FSelDragging := True;
    if FSelectLinkingObj then //添加连接时专用
    begin
      try
        obj1 := FDMLObjs.SelectedObj;
        FDMLObjs.Items[I].Selected := True;
        FDMLObjs.Items[I].SetClickPoint(xx, yy, FDMLDrawer);
        DoSelectObj;
        Refresh;
        if Assigned(FOnLinkObjSelected) then
          FOnLinkObjSelected(Self, obj1, FDMLObjs.Items[I]);
      finally
        SelectLinkingObj := False;
      end;
    end
    else if not (ssShift in Shift) then
    begin
      if not FDMLObjs.Items[I].Selected then
      begin
        FDMLObjs.ClearSelection;
        FDMLObjs.Items[I].Selected := True;
        FDMLObjs.Items[I].SetClickPoint(xx, yy, FDMLDrawer);
        DoSelectObj;
        Refresh;
      end
      else
      begin
        if FDMLObjs.Items[I] is TDMLTableObj then
        begin
          K := TDMLTableObj(FDMLObjs.Items[I]).SelectedFieldIndex;
          FDMLObjs.Items[I].SetClickPoint(xx, yy, FDMLDrawer);
          if K <> TDMLTableObj(FDMLObjs.Items[I]).SelectedFieldIndex then
          begin
            DoSelectObj;
            Refresh;
          end;
        end
        else
        begin
          FDMLObjs.Items[I].SetClickPoint(xx, yy, FDMLDrawer);
          DoSelectObj;
          Refresh;
        end;
      end;
    end
    else
    begin
      FDMLObjs.Items[I].Selected := not FDMLObjs.Items[I].Selected;
      if FDMLObjs.Items[I].Selected and (FDMLObjs.SelectedCount = 2) then
      begin
        if FDMLObjs.Items[I] is TDMLTableObj then
        begin
          FDMLObjs.Items[I].SetClickPoint(xx, yy, FDMLDrawer);
        end;
      end;
      DoSelectObj;
      Refresh;
    end;
  end
  else if FSelectLinkingObj then //选中了连线，准备做连线移动
    FSelDragging := True
  else
  begin
    //点在空地上，准备做屏幕移动
    FSelDragging := False;
    FSelectPanning := True;
    CheckActCursor;
    {if FDMLObjs.SelectedCount > 0 then
    begin
      FDMLObjs.ClearSelection;
      DoSelectObj;
      Refresh;
    end;}
  end;
end;

function TDMLGraph.DoRectSelectMU(X1, Y1, X2, Y2: Integer; Shift: TShiftState): Boolean;
var
  bCtrl, bPanning, bMoved: Boolean;
  o: TDMLObj;
  I: Integer;
begin
  bMoved := FObjsMoved;
  if FObjsMoved then
    if Assigned(FOnMoveObj) then
      FOnMoveObj(Self);
  FObjsMoved := False;
  bPanning := FSelectPanning;
  FSelectPanning := False;
  if not (ssAlt in Shift) then
    if not FIsSelPanMoved then
      bPanning := False;

  if not bPanning then
  begin

    if FSelDragging or FSelectLinkingObj then
    begin
      o := FDMLObjs.SelectedObj;
      if bMoved and (o is TDMLLinkObj) then
      begin
        TDMLLinkObj(o).CheckLineAlign;
        TDMLLinkObj(o).CheckPosition;
        if Assigned(FOnMoveObj) then
          FOnMoveObj(Self);
        Refresh;
      end;
      Result := True;
      Exit;
    end;

    for I := 0 to FDMLObjs.Count - 1 do
      if FDMLObjs.Items[I] is TDMLLinkObj then
        if TDMLLinkObj(FDMLObjs.Items[I]).ClickPos <> 0 then
        begin
          TDMLLinkObj(FDMLObjs.Items[I]).ClickPos := 0;
          TDMLLinkObj(FDMLObjs.Items[I]).CheckPosition;
        end;

    bCtrl := (ssShift in Shift);
    if (Abs(X1 - X2) <= 3) and (Abs(Y1 - Y2) <= 3) then
      FDMLObjs.SelectItemAt(ScreenToImageX(X1), ScreenToImageY(Y1), bCtrl)
    else
      FDMLObjs.RectSelect(ScreenToImageX(X1), ScreenToImageY(Y1),
        ScreenToImageX(X2), ScreenToImageY(Y2), bCtrl);
    DoSelectObj;
  end
  else
    CheckActCursor;
  Refresh;
  Result := True;
end;

procedure TDMLGraph.DoRectSelectMV(X, Y: Integer; Shift: TShiftState);
begin
  if (Abs(X - FOldMouseP.X) > 3) or (Abs(Y - FOldMouseP.Y) > 3) then
  begin
    if FSelectPanning then
    begin
      if Cursor <> crPanDown then
      begin
        Cursor := crPanDown;
      end;
      FIsSelPanMoved := True;

      FViewCenterX := FViewCenterX - (X - FOldMouseP.X) / FViewScale;
      FViewCenterY := FViewCenterY - (Y - FOldMouseP.Y) / FViewScale;
      Refresh;

      FOldMouseP := Point(X, Y);
    end
    else if FSelDragging and not FSelectLinkingObj then
    begin
      FDMLObjs.MoveSelected((X - FOldMouseP.X) / FViewScale,
        (Y - FOldMouseP.Y) / FViewScale);
      FObjsMoved := True;
      Refresh;
      FOldMouseP := Point(X, Y);
    end;
  end;
end;

procedure TDMLGraph.DoSelectObj;
begin
  if (FDMLObjs.SelectedCount < 1) or (FDMLObjs.SelectedCount > 2) then
    FDMLObjs.ClearFieldSelection
  else if FDMLObjs.SelectedCount = 2 then
  begin                         
    if FDMLObjs.GetSelectedItem(0) is TDMLTableObj then
      TDMLTableObj(FDMLObjs.GetSelectedItem(0)).SelectedFieldIndex := -1;
  end;
  if Assigned(FOnSelectObj) then
    FOnSelectObj(Self);
end;

procedure TDMLGraph.ExportImage(Cnv: TCanvas; rLeft, rTop, rWidth, rHeight: Double);
var
  l, t, w, h: Integer;
  cx, cy, x1, y1, x2, y2: Double;
begin
  cx := FViewCenterX;
  cy := FViewCenterY;
  try

    x1 := rLeft;
    x2 := rLeft + rWidth;
    y1 := rTop;
    y2 := rTop + rHeight;

    X1 := X1 - FDMLDrawer.DrawerWidth / 2;
    X2 := X2 - FDMLDrawer.DrawerWidth / 2;
    Y1 := Y1 - FDMLDrawer.DrawerHeight / 2;
    Y2 := Y2 - FDMLDrawer.DrawerHeight / 2;

    FViewCenterX := (X1 + X2) / 2;
    FViewCenterY := (Y1 + Y2) / 2;

    FDMLDrawer.CenterX := ViewCenterX;
    FDMLDrawer.CenterY := ViewCenterY;

    l := ImageToScreenX(rLeft);
    t := ImageToScreenY(rTop);
    w := ImageToScreenX(rLeft + rWidth) - l;
    h := ImageToScreenY(rTop + rHeight) - t;

    with Cnv do
    begin
      Brush.Style := bsSolid;
      Brush.Color := Color;
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := Color;
      Rectangle(0, 0, w, h);
    end;

    GetDrawInfo;


    FDMLDrawer.Canvas := Cnv;
    FDMLDrawer.BoundLeft := rLeft;
    FDMLDrawer.BoundTop := rTop;
    FDMLDrawer.BoundWidth := rWidth;
    FDMLDrawer.BoundHeight := rHeight;
    FDMLDrawer.ControlWidth := w;
    FDMLDrawer.ControlHeight := h;
    FDMLDrawer.GetX := ImageToScreenX2;
    FDMLDrawer.GetY := ImageToScreenY2;

    with Cnv do
    begin
      Pen.Style := psSolid;
      Pen.Width := 1;
      Pen.Color := RGB(233, 233, 233);
    end;

    FDMLDrawer.SkipDrawSelected := True;
    FDMLObjs.PaintAll;
  finally
    FViewCenterX := cx;
    FViewCenterY := cy;
    FDMLDrawer.SkipDrawSelected := False;
    GetDrawInfo;
  end;
end;

procedure TDMLGraph.FitSelection;
var
  X1, Y1, X2, Y2: Double;
  W, H: Double;
begin
  if FDMLObjs.GetSelectedFitRect(X1, Y1, X2, Y2) then
  begin
    X1 := X1 - FDMLDrawer.DrawerWidth / 2;
    X2 := X2 - FDMLDrawer.DrawerWidth / 2;
    Y1 := Y1 - FDMLDrawer.DrawerHeight / 2;
    Y2 := Y2 - FDMLDrawer.DrawerHeight / 2;

    FViewCenterX := (X1 + X2) / 2;
    FViewCenterY := (Y1 + Y2) / 2;
    W := Abs(X2 - X1);
    H := Abs(Y2 - Y1);
    if Width / Height < W / H then
      FViewScale := Width / W
    else
      FViewScale := Height / H;
    FViewScale := FViewScale * 0.9;
    if (FViewScale > 1) and (FViewScale < 1.5) then
      FViewScale := 1;
    Refresh;
  end;
end;

function TDMLGraph.GetBufmap: TBitmap;
begin
  Result := FBufmap;
end;

procedure TDMLGraph.GetDrawInfo;
begin
  FDMLDrawer.Canvas := FBufmap.Canvas;
  FDMLDrawer.Scale := ViewScale;
  FDMLDrawer.CenterX := ViewCenterX;
  FDMLDrawer.CenterY := ViewCenterY;
  FDMLDrawer.BoundLeft := ScreenToImageX(0);
  FDMLDrawer.BoundTop := ScreenToImageY(0);
  FDMLDrawer.BoundWidth := ScreenToImageD(Width);
  FDMLDrawer.BoundHeight := ScreenToImageD(Height);
  FDMLDrawer.ControlWidth := Width;
  FDMLDrawer.ControlHeight := Height;
  FDMLDrawer.Images := FImages;

  FDMLDrawer.GetX := ImageToScreenX;
  FDMLDrawer.GetY := ImageToScreenY;
end;

function TDMLGraph.GraphHeight: Integer;
begin
  Result := FDMLDrawer.DrawerHeight;
end;

function TDMLGraph.GraphWidth: Integer;
begin
  Result := FDMLDrawer.DrawerWidth;
end;

function TDMLGraph.HasGraphic: Boolean;
begin
  Result := Assigned(FDMLDrawer);
end;

function TDMLGraph.ImageToScreenX2(X: Double): Integer;
var
  cx, CW: Double;
begin
  CW := GraphWidth / 2;
  cx := FDMLDrawer.ControlWidth / 2;
  if VE(FViewScale, 1) then
    Result := Round(X) - Round(CW) - Round(FViewCenterX) + Round(cx)
  else
    Result := Round((X - CW - FViewCenterX) * FViewScale + cx);
end;

function TDMLGraph.ImageToScreenY2(Y: Double): Integer;
var
  cy, Ch: Double;
begin
  Ch := GraphHeight / 2;
  cy := FDMLDrawer.ControlHeight / 2;
  if VE(FViewScale, 1) then
    Result := Round(Y) - Round(Ch) - Round(FViewCenterY) + Round(cy)
  else
    Result := Round((Y - Ch - FViewCenterY) * FViewScale + cy);
end;

function TDMLGraph.IsBestFit: Boolean;
var
  vx, vy, vs, X1, Y1, X2, Y2: Double;
  W, H: Double;
begin
  if FDMLObjs.GetAllObjsRect(X1, Y1, X2, Y2) then
  begin
    if X1 > 0 then
      X1 := 0;
    if FDMLObjs.Count = 0 then
      if X2 < FDMLDrawer.DrawerWidth then
        X2 := FDMLDrawer.DrawerWidth;
    if Y1 > 0 then
      Y1 := 0;
    if FDMLObjs.Count = 0 then
      if Y2 < FDMLDrawer.DrawerHeight then
        Y2 := FDMLDrawer.DrawerHeight;

    if (X1 = 0) and (Y1 = 0) and (X2 = FDMLDrawer.DrawerWidth) and
      (Y2 = FDMLDrawer.DrawerHeight) then
    begin
      Result := inherited IsBestFit;
      Exit;
    end;

    X1 := X1 - FDMLDrawer.DrawerWidth / 2;
    X2 := X2 - FDMLDrawer.DrawerWidth / 2;
    Y1 := Y1 - FDMLDrawer.DrawerHeight / 2;
    Y2 := Y2 - FDMLDrawer.DrawerHeight / 2;

    vx := (X1 + X2) / 2;
    vy := (Y1 + Y2) / 2;
    W := Abs(X2 - X1);
    H := Abs(Y2 - Y1);
    if Width / Height < W / H then
      vs := Width / W
    else
      vs := Height / H;
    vs := vs * 0.9;
    if (vs > 1) and (vs < 1.5) then
      vs := 1;
    if VE(vx, FViewCenterX) and VE(vy, FViewCenterY) and VE(vs, FViewScale) then
      Result := True
    else
      Result := False;
  end
  else
    Result := inherited IsBestFit;
end;

function TDMLGraph.IsBestFitScale: Boolean;
var
  vs, X1, Y1, X2, Y2: Double;
  W, H: Double;
begin
  if FDMLObjs.GetAllObjsRect(X1, Y1, X2, Y2) then
  begin
    if X1 > 0 then
      X1 := 0;
    if FDMLObjs.Count = 0 then
      if X2 < FDMLDrawer.DrawerWidth then
        X2 := FDMLDrawer.DrawerWidth;
    if Y1 > 0 then
      Y1 := 0;
    if FDMLObjs.Count = 0 then
      if Y2 < FDMLDrawer.DrawerHeight then
        Y2 := FDMLDrawer.DrawerHeight;

    if (X1 = 0) and (Y1 = 0) and (X2 = FDMLDrawer.DrawerWidth) and
      (Y2 = FDMLDrawer.DrawerHeight) then
    begin
      Result := inherited IsBestFitScale;
      Exit;
    end;

    X1 := X1 - FDMLDrawer.DrawerWidth / 2;
    X2 := X2 - FDMLDrawer.DrawerWidth / 2;
    Y1 := Y1 - FDMLDrawer.DrawerHeight / 2;
    Y2 := Y2 - FDMLDrawer.DrawerHeight / 2;

    W := Abs(X2 - X1);
    H := Abs(Y2 - Y1);
    if Width / Height < W / H then
      vs := Width / W
    else
      vs := Height / H;
    vs := vs * 0.9;
    if (vs > 1) and (vs < 1.5) then
      vs := 1;
    if VE(vs, FViewScale) then
      Result := True
    else
      Result := False;
  end
  else
    Result := inherited IsBestFitScale;
end;

procedure TDMLGraph.KeyPress(var Key: char);
begin
  inherited;
  if KeyActions then
    case Key of
      'f', 'F':
        if FDMLObjs.SelectedCount > 0 then
          FitSelection
        else
          BestFit;
    end;
end;

procedure TDMLGraph.ResetView;
var
  X1, Y1, X2, Y2: Double;
begin
  if not Assigned(FDMLDrawer) then
  begin
    inherited;
    Exit;
  end;
  FViewCenterX := -FDMLDrawer.DrawerWidth div 2 + Width div 2 * 96 div Screen.PixelsPerInch  - 4;
  FViewCenterY := -FDMLDrawer.DrawerHeight div 2 + Height div 2 * 96 div Screen.PixelsPerInch - 4;
  FHookX := -4;
  FHookY := -4;
  if FDMLObjs.SelectedCount > 0 then
  begin
    if FDMLObjs.GetSelectedFitRect(X1, Y1, X2, Y2) then
    begin
      FViewCenterX := (X1 + X2) / 2 - FDMLDrawer.DrawerWidth div 2;
      FViewCenterY := (Y1 + Y2) / 2 - FDMLDrawer.DrawerHeight div 2;
    end;
  end;
  FViewScale := Forms.Screen.PixelsPerInch/96;
end;

procedure TDMLGraph.AutoCheckGraphSize;
var
  X1, Y1, X2, Y2: Double;
  bResized: Boolean;
begin
  bResized := False;
  if FDMLObjs.GetAllObjsRect(X1, Y1, X2, Y2) then
  begin
    while X2 > FDMLDrawer.DrawerWidth do
    begin
      Inc(FDMLDrawer.DrawerWidth, 200);
      bResized := True;
    end;
    while Y2 > FDMLDrawer.DrawerHeight do
    begin
      Inc(FDMLDrawer.DrawerHeight, 500);
      bResized := True;
    end;
  end;
  if bResized then
  begin
    RecreateScrollbars;
    Refresh;
  end;
end;

procedure TDMLGraph.BestFit;
var
  X1, Y1, X2, Y2: Double;
  W, H: Double;
begin
  if FDMLObjs.GetAllObjsRect(X1, Y1, X2, Y2) then
  begin
    if X1 > 0 then
      X1 := 0;
    if FDMLObjs.Count = 0 then
      if X2 < FDMLDrawer.DrawerWidth then
        X2 := FDMLDrawer.DrawerWidth;
    if Y1 > 0 then
      Y1 := 0;
    if FDMLObjs.Count = 0 then
      if Y2 < FDMLDrawer.DrawerHeight then
        Y2 := FDMLDrawer.DrawerHeight;

    if (X1 = 0) and (Y1 = 0) and (X2 = FDMLDrawer.DrawerWidth) and
      (Y2 = FDMLDrawer.DrawerHeight) then
    begin
      inherited;
      Exit;
    end;

    X1 := X1 - FDMLDrawer.DrawerWidth / 2;
    X2 := X2 - FDMLDrawer.DrawerWidth / 2;
    Y1 := Y1 - FDMLDrawer.DrawerHeight / 2;
    Y2 := Y2 - FDMLDrawer.DrawerHeight / 2;

    FViewCenterX := (X1 + X2) / 2;
    FViewCenterY := (Y1 + Y2) / 2;
    W := Abs(X2 - X1);
    H := Abs(Y2 - Y1);
    if Width / Height < W / H then
      FViewScale := Width / W
    else
      FViewScale := Height / H;
    FViewScale := FViewScale * 0.9;
    if (FViewScale > 1) and (FViewScale < 1.5) then
      FViewScale := 1;
    Refresh;
  end
  else
    inherited;
end;

procedure TDMLGraph.KeyDown(var Key: Word; Shift: TShiftState);
var
  dir: Integer;
begin
  if (ssCtrl in Shift) and not (ssShift in Shift) and not (ssAlt in Shift) then
  begin
    dir := 0;
    if KeyActions then
      case Key of
        VK_LEFT: dir := 1;
        VK_RIGHT: dir := 2;
        VK_UP: dir := 3;
        VK_DOWN: dir := 4;
      end;
    if dir > 0 then
    begin
      FDMLObjs.SelectEntityByDir(dir, ViewCenterX, ViewCenterY);
      MakeObjVisible(FDMLObjs.SelectedObj);
      DoSelectObj;
      Refresh;
      Exit;
    end;
  end;
  inherited;
  if KeyActions then
    case Key of
      VK_PRIOR:
        ViewCenterY := ViewCenterY - ScreenToImageD(Height * 4 div 5);
      VK_NEXT:
        ViewCenterY := ViewCenterY + ScreenToImageD(Height * 4 div 5);
      Ord('a'), Ord('A'):
        if ssCtrl in Shift then
        begin
          FDMLObjs.SelectAll(False);
          DoSelectObj;
          Refresh;
        end;
      VK_ESCAPE:
        if SelectLinkingObj then
          SelectLinkingObj := False;
    end;
end;

procedure TDMLGraph.MakeObjVisible(obj: TDMLObj);
var
  X1, Y1, X2, Y2: Double;
begin
  if not Assigned(obj) then
    Exit;
  X1 := ScreenToImageX(0);
  X2 := ScreenToImageX(Width);
  Y1 := ScreenToImageY(0);
  Y2 := ScreenToImageY(Height);
  if (obj.Left > X1) and (obj.Left + obj.Width < X2) and (obj.Top > Y1) and
    (obj.Top + obj.Height < Y2) then
    Exit;
  FViewCenterX := obj.Left + obj.Width / 2 - FDMLDrawer.DrawerWidth / 2;
  FViewCenterY := obj.Top + obj.Height / 2 - FDMLDrawer.DrawerHeight / 2;
  Refresh;
end;

procedure TDMLGraph.Refresh;
begin
  if FUpdateCounter > 0 then
    Exit;
  if FViewScale < 0.5 then
  begin
    FDMLDrawer.FFastDrawMode := True;   
    if VE(FLastRefreshCx, FViewCenterX) and VE(FLastRefreshCy, FViewCenterY)
       and VE(FLastRefreshSc, FViewScale) then
    begin
      if FSelDragging and FObjsMoved then
        inherited Refresh;
    end
    else
        inherited Refresh;
    ResetRefreshTimer;
  end
  else
  begin
    FDMLDrawer.FFastDrawMode := False;
    inherited Refresh;
  end;
end;

procedure TDMLGraph.ResetRefreshTimer;
begin
  if FDelayRefreshTimer.Enabled then
  begin
    FDelayRefreshTimer.Enabled:=False;
    FDelayRefreshTimer.Interval:= 800;
    FDelayRefreshTimer.Enabled:=True;
  end
  else
  begin
    FDelayRefreshTimer.Interval:= 400;
    FDelayRefreshTimer.Enabled:=True;
  end;
end;

procedure TDMLGraph.LoadFromFile(fn: string);
var
  f: TIniFile;
  Sec: string;
  fs: TStream;
begin
  if LowerCase(ExtractFileExt(fn)) = '.dmh' then
  begin
    fs := TFileStream.Create(fn, fmOpenRead);
    try
      LoadFromStream(fs);
    finally
      fs.Free;
      Refresh;
    end;
    Exit;
  end;

  f := TIniFile.Create(fn);
  with f do
    try
      Sec := 'DMLGraph';
      Load(f, Sec);
    finally
      Free;
      Refresh;
    end;
end;

procedure TDMLGraph.SaveToFile(fn: string);
var
  f: TIniFile;
  Sec: string;
  fs: TStream;
begin
  if LowerCase(ExtractFileExt(fn)) = '.dmh' then
  begin
    fs := TFileStream.Create(fn, fmCreate);
    try
      SaveToStream(fs);
    finally
      fs.Free;
      Refresh;
    end;
    Exit;
  end;

  if FileExists(fn) then
    DeleteFile(fn);
  f := TIniFile.Create(fn);
  with f do
    try
      GetDrawInfo;

      Sec := 'DMLGraph';
      Save(f, Sec);
    finally
      Free;
    end;
end;

procedure TDMLGraph.SetSelectLinkingObj(const Value: Boolean);
begin
  FSelectLinkingObj := Value;
  if Value then
  begin
    MouseAction := vaRectSelect;
    Cursor := crSelectLink;
  end
  else
  begin
    if MouseAction = vaRectSelect then
    begin
      Cursor := crDefault;
    end;
    FSelDragging := False;
    FMouseDowned := False;
  end;
end;

procedure TDMLGraph.Load(Ini: TCustomIniFile; Sec: string);
begin
  FViewCenterX := Ini.ReadFloat(Sec, 'ViewCenterX', ViewCenterX);
  FViewCenterY := Ini.ReadFloat(Sec, 'ViewCenterY', ViewCenterY);
  FViewScale := Ini.ReadFloat(Sec, 'ViewScale', ViewScale);
  FHookX := Ini.ReadFloat(Sec, 'HookX', FHookX);
  FHookY := Ini.ReadFloat(Sec, 'HookY', FHookY);
  FHookTopLeft := Ini.ReadBool(Sec, 'HookTopLeft', FHookTopLeft);
  FDMLDrawer.Load(Ini, 'Drawer');
  FDMLObjs.Load(Ini, 'Objs');
  if FHookTopLeft and (Abs(FViewScale - 1) <= 0.0001) then
  begin
    FViewCenterX := FViewCenterX + FHookX - ScreenToImageX(0);
    FViewCenterY := FViewCenterY + FHookY - ScreenToImageY(0);
  end;
  Modified := False;
end;

procedure TDMLGraph.LoadFromStream(AStream: TStream);
begin
  Stream_ReadFloat(AStream, FViewCenterX);
  Stream_ReadFloat(AStream, FViewCenterY);
  Stream_ReadFloat(AStream, FViewScale);
  Stream_ReadFloat(AStream, FHookX);
  Stream_ReadFloat(AStream, FHookY);
  Stream_ReadBool(AStream, FHookTopLeft);
  FDMLDrawer.LoadFromStream(AStream);
  FDMLObjs.LoadFromStream(AStream);
  if FHookTopLeft and (Abs(FViewScale - 1) <= 0.0001) then
  begin
    FViewCenterX := FViewCenterX + FHookX - ScreenToImageX(0);
    FViewCenterY := FViewCenterY + FHookY - ScreenToImageY(0);
  end;
  GetDrawInfo;
  Modified := False;
end;

procedure TDMLGraph.Save(Ini: TCustomIniFile; Sec: string);
begin
  Ini.WriteFloat(Sec, 'ViewCenterX', ViewCenterX);
  Ini.WriteFloat(Sec, 'ViewCenterY', ViewCenterY);
  Ini.WriteFloat(Sec, 'ViewScale', ViewScale);
  Ini.WriteFloat(Sec, 'HookX', FHookX);
  Ini.WriteFloat(Sec, 'HookY', FHookY);
  Ini.WriteBool(Sec, 'HookTopLeft', FHookTopLeft);
  GetDrawInfo;
  FDMLDrawer.Save(Ini, 'Drawer');
  FDMLObjs.Save(Ini, 'Objs');
end;

procedure TDMLGraph.SaveToStream(AStream: TStream);
begin
  Stream_WriteFloat(AStream, FViewCenterX);
  Stream_WriteFloat(AStream, FViewCenterY);
  Stream_WriteFloat(AStream, FViewScale);
  Stream_WriteFloat(AStream, FHookX);
  Stream_WriteFloat(AStream, FHookY);
  Stream_WriteBool(AStream, FHookTopLeft);
  GetDrawInfo;
  FDMLDrawer.SaveToStream(AStream);
  FDMLObjs.SaveToStream(AStream);
end;

function TDMLGraph.CanPopupMenu(X, Y: Integer): Boolean;
var
  idx:Integer;
begin
  Result := True;
  if Self.SelectLinkingObj then
  begin
    Self.SelectLinkingObj := False;
    Result := False;
  end;
  if Result then
  begin
    idx:= FDMLObjs.FindItemAt(ScreenToImageX(X), ScreenToImageY(Y));
    if idx>=0 then
      if not FDMLObjs[idx].Selected then
      begin
        FDMLObjs.ClearSelection;
        FDMLObjs.Items[idx].Selected := True;
        FDMLObjs.Items[idx].SetClickPoint(x, y, FDMLDrawer);
        DoSelectObj;
        Refresh;
      end;
  end;
end;

procedure TDMLGraph.CheckActCursor;
begin
  if Self.FSelectPanning then
  begin
    Exit;
  end
  else
    inherited CheckActCursor;
end;

procedure TDMLGraph._OnDelayRefreshTimer(Sender: TObject);
begin      
  FDelayRefreshTimer.Enabled:=False;
  
  FDMLDrawer.FFastDrawMode := False;
  inherited Refresh;
end;

procedure TDMLGraph.CheckViewChanged;
begin
  inherited;
  AutoCheckGraphSize;
end;

procedure TDMLGraph.DrawRectLine(X, Y: Integer; bClearLast: Boolean);
begin
  if not FIsSelPanMoved then
    inherited;
end;
            
{$IFnDEF FPC}
procedure TDMLGraph.CMMouseWheel(var Message: TCMMouseWheel);
var
  W: Integer;
  t, px, py: integer;
  pt: TPoint;
begin
  if FMouseWheeling then
    Exit;
  FMouseWheeling := True;
  try
    with Message do
    begin
      Result := 1;
      W := Abs(WheelDelta);
      if WheelDelta < 0 then
      begin
        if (GetKeyState(VK_CONTROL) and $80) <> 0 then
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
              ViewCenterY + py * ScreenToImageD(t), ViewScale / 1.18);
          end
          else
            ViewScale := ViewScale / 1.18;
        end
        else if (GetKeyState(VK_SHIFT) and $80) <> 0 then
          ViewCenterX := ViewCenterX + ScreenToImageD(W) //(Width div 20)
        else
          ViewCenterY := ViewCenterY + ScreenToImageD(W) //(Height div 20);
      end
      else
      begin
        if (GetKeyState(VK_CONTROL) and $80) <> 0 then
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
        end
        else if (GetKeyState(VK_SHIFT) and $80) <> 0 then
          ViewCenterX := ViewCenterX - ScreenToImageD(W) //(Width div 20)
        else
          ViewCenterY := ViewCenterY - ScreenToImageD(W) //(Height div 20);
      end;
    end;
  finally
    FMouseWheeling := False;
  end;
end;   
{$ENDIF}

procedure TDMLGraph.SetModified(const Value: Boolean);
begin
  FModified := Value;
end;

procedure TDMLGraph.LoadIniStream(AStream: TStream);
var
  Ini: TMemIniFile;
  SS: TStrings;
begin
  Ini := TMemIniFile.Create('dml');
  SS := TStringList.Create;
  try
    SS.LoadFromStream(AStream);
    Ini.SetStrings(SS);
    Load(Ini, 'DMLGraph');
  finally
    SS.Free;
    Ini.Free;
  end;
end;

procedure TDMLGraph.SaveIniStream(AStream: TStream);
var
  Ini: TMemIniFile;
  SS: TStrings;
begin
  Ini := TMemIniFile.Create('dml');
  SS := TStringList.Create;
  try
    Save(Ini, 'DMLGraph');
    Ini.GetStrings(SS);
    SS.SaveToStream(AStream);
  finally
    SS.Free;
    Ini.Free;
  end;
end;

end.
