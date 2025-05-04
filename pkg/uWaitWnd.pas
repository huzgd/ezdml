{
  等待进度窗口. 适用于主线程调用
  create by huz(huz0123@21cn.com) 2005-4

  示例代码:

  pfww := TfrmWaitWnd.Create(Self);
  try
    pfww.Init('测试测试', '正在进行测试...#PERCENT  用时 #TIMEUSED, 剩余 #TIMELEFT',
        '确定要中止测试吗?');
    pfww.SetVirtualProgressRef(5, 1000, True, 100);

    for I := 0 to 20 do
    begin
      pfww.SetPercentMsg(I / 20 * 100, '', True);
      if pfww.Canceled then
        Break;
      for J:=1 to 10 do
      begin
        pfww.ProcessMessages;
        Sleep(150);
      end;
    end;
  finally
    pfww.Release;
  end;
}
unit uWaitWnd;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type

  TWaitingProcedure = procedure(Sender: TObject; var bSuccess: Boolean) of object;

  TfrmWaitWnd = class(TForm)
    LabelPrompt: TLabel;
    btnCancel: TButton;
    ProgressBar1: TProgressBar;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCancelPrompt: string;
    FPercent: Double;
    FPrompt: string;

    FCanceled: Boolean;
    FDisableCancel: Boolean;

    FLastPercentTick: Int64;
    FLastChkAbtTick: Int64;
    FChkAbtCounter: Integer;
    FChkPrgCounter: Integer;

    FFWindowList: TList;
    FFSaveFocusSt: TFocusState;
    FFSaveCursor: TCursor;
    FFActiveWindow: HWnd;
    FModalInited: Boolean;

    FAllIncStep: Double;
    FAllIncTime: Double;
    FAllIncStepFake: Double;
    FAllIncTimeFake: Double;
    FDefIncStep: Double;
    FDefIncTime: Double;
    FAutoRep: Boolean;
    FTimerInt: LongInt;
    FTimerTick: Int64;
    FAllowClose: Boolean;
    FSkipCTime: Integer;

    procedure CheckRefresh;
    procedure TimerProcRefTimer(Sender: TObject);
    function GetVirtualProgress(CurT, StepT, StepP, DivPercent: Double): Double;
    function GetPromptPer(APercent: Double): string;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  public
    FPaused: Boolean;
    FLastTickCount: Int64;

    destructor Destroy; override; 
    procedure Release; reintroduce;

    //阻止焦点落到本窗口的控件上
    function SetFocusedControl(Control: TWinControl): Boolean; override;

    //初始化, ACancelPrompt='[DISABLED]'表示不允许取消
    procedure Init(const ATitle, APrompt, ACancelPrompt: string);
    //清理, 关闭时会自动调用, 也可以手工调用
    procedure Fina;

    //必须经常检查消息. 设置进度和检查取消时, 会自动调用它检查消息
    procedure ProcessMessages;
    //是否需要更新进度. 一般100毫秒更新一次, 本函数在距上一次更新超过100毫秒时返回TRUE
    function NeedProgress(SkipCount: Integer): Boolean;
    //设置进度和显示消息, 进度为-1或消息为空时, 只刷新界面, 不更改进度消息
    //bCheckAbort为TRUE时, 会调用CHECKABORT方法检查中止.
    procedure SetPercentMsg(APercent: Double; const APrompt: string; bCheckAbort: Boolean = False);

    //设置进度参考值
    //ADefIncStep:缺省步进值, ADefIncTime:缺省步进时间
    //bAutoRep:根据实际情况自动校正步进时间, iTimerInt:定时器的时间间隔(ms)
    procedure SetVirtualProgressRef(ADefIncStep, ADefIncTime: Double;
      bAutoRep: Boolean; iTimerInt: DWord);
    //如果设置了进度参考值, 建议使用本函数来显示提示框, 或参考本函数写法, 以保证计时正确
    function MessageBoxR(const AText, ACaption: string; AFlags: Longint = MB_OK): Integer;

    //检查是否取消
    function CheckCanceled: Boolean;
    //检查用户是否按了取消, 如果用户要求中止, 则ABORT.
    procedure CheckAbort;
    //内置了一个计数器, 每调用一次加1, 当达到SkipCount时才调用CheckAbort
    procedure CheckAbortEx(SkipCount: Integer);
    //CheckAbort
    procedure NotifyAbort(Sender: TObject);

    property Canceled: Boolean read FCanceled;
    property SkipCTime: Integer read FSkipCTime write FSkipCTime;
  end;

  TWaitingThread = class(TfrmWaitWnd)
  private
    FTitle, FPrompt, FCancelPrompt: string;
    FWaitProc: TWaitingProcedure;
    FPar2: string;
    FPar3: string;
    FPar1: string;
    FObj2: TObject;
    FObj3: TObject;
    FObj1: TObject;
  public
    constructor Create(const ATitle, APrompt, ACancelPrompt: string;
      const AWaitProc: TWaitingProcedure); reintroduce;
    function WaitEx: Boolean;
    //兼容旧的线程等待命令
    class function Wait(const ATitle, APrompt, ACancelPrompt: string;
      const AWaitProc: TWaitingProcedure; APreWaitTime: DWord = 0): Boolean;
    function Terminated: Boolean;

    property Obj1: TObject read FObj1 write FObj1;
    property Obj2: TObject read FObj2 write FObj2;
    property Obj3: TObject read FObj3 write FObj3;
    property Par1: string read FPar1 write FPar1;
    property Par2: string read FPar2 write FPar2;
    property Par3: string read FPar3 write FPar3;
  end;

const
  DEF_PERCENT_ID = '#PERCENT'; //在显示消息中, 用来显示进度百分比
  DEF_TIMEUSED_ID = '#TIMEUSED'; //在显示消息中, 用来显示已用时间
  DEF_TIMELEFT_ID = '#TIMELEFT'; //在显示消息中, 用来显示估计剩余时间
  DEF_TIMENEED_ID = '#TIMENEED'; //在显示消息中, 用来显示估计总共需要时间
  DEF_PAUSE_SLEEPTIME = 100;

var
  pfww: TfrmWaitWnd;

implementation

uses
  Math, dmlstrs;

{$R *.lfm}

{ TfrmThreadWait }


procedure TfrmWaitWnd.btnCancelClick(Sender: TObject);
begin
  if not FDisableCancel then
    Close;
end;

procedure TfrmWaitWnd.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Tm: Int64;
begin
  if FAllowClose then
    Exit;

  Canclose := False;
  Tm := GetTickCount64;
  if csDestroying in ComponentState then
    Exit;
  if FDisableCancel then
  begin
    Exit;
  end;
  FPaused := True;
  try
    if FCancelPrompt <> '' then
    try
      //Animate1.Active := False;
      if Application.MessageBox(PChar(FCancelPrompt), PChar(Application.Title),
        MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) <> IDYES then
      begin
        Exit;
      end;
    finally
     // Animate1.Active := True;
    end;

    FCanceled := True;
  finally
    FPaused := False;
    FLastTickCount := FLastTickCount + (Int64(GetTickCount64) - Tm);
  end;
end;

procedure TfrmWaitWnd.SetPercentMsg(APercent: Double; const APrompt: string;
  bCheckAbort: Boolean = False);
begin
  if APrompt <> '' then
    FPrompt := APrompt;
  if APercent >= 0 then
  begin
    //if FTimerInt > 0 then
    if APercent = 0 then
    begin
      FAllIncStep := 0;
      FAllIncTime := 0;
      FAllIncStepFake := 0;
      FAllIncTimeFake := 0;
    end
    else
    begin
      FAllIncStep := FAllIncStep + Abs(APercent - FPercent);
      FAllIncTime := FAllIncTime + Abs(Int64(GetTickCount64) - FLastTickCount);
      FAllIncStepFake := FAllIncStep;
      FAllIncTimeFake := FAllIncTime;
    end;
    FLastTickCount := GetTickCount64;
    FPercent := APercent;
  end;
  FLastPercentTick := GetTickCount64;
  CheckRefresh;

  ProcessMessages;
  if bCheckAbort then
    CheckAbort;
end;

procedure TfrmWaitWnd.FormShow(Sender: TObject);
begin
  //Exclude(FFormState, fsModal);
 // Animate1.Active := True;
end;

function TfrmWaitWnd.GetPromptPer(APercent: Double): string;
  function GetTimeStr(tick: Double): string;
  var
    S: string;
    tT, tD, tH, tM, tS: Integer;
  begin
    tT := Round(tick / 1000);
    tS := tT;
    tM := Floor(tS / 60);
    tH := Floor(tM / 60);
    tD := Floor(tH / 24);
    S := '';
    if tD > 0 then
    begin
      S := IntToStr(tD) + srDays;
      tH := tH - tD * 24;
      tM := tM - tD * 24 * 60;
      tS := tS - tD * 24 * 60 * 60;
    end;
    if tH > 0 then
    begin
      S := S + IntToStr(tH) + srHours;
      tM := tM - tH * 60;
      tS := tS - tH * 60 * 60;
    end;
    if tM > 0 then
    begin
      S := S + IntToStr(tM) + srMinutes;
      tS := tS - tM * 60;
    end;
    if tS >= 0 then
    begin
      S := S + IntToStr(tS) + srSeconds;
    end;
    Result := S;
  end;
var
  S: string;
begin
  Result := FPrompt;
  if Pos(DEF_PERCENT_ID, Result) > 0 then
  begin
    S := Format('%d%%', [Round(APercent)]);
    Result := StringReplace(Result, DEF_PERCENT_ID, S, [rfReplaceAll]);
  end;
  if Pos(DEF_TIMEUSED_ID, Result) > 0 then
  begin
    if FAllIncTime > 500 then
      S := GetTimeStr(FAllIncTime + Abs(Int64(GetTickCount64) - FLastTickCount))
    else if FAllIncTimeFake > 500 then
      S := GetTimeStr(FAllIncTimeFake)
    else
      S := '0'+srSeconds;
    Result := StringReplace(Result, DEF_TIMEUSED_ID, S, [rfReplaceAll]);
  end;
  if Pos(DEF_TIMELEFT_ID, Result) > 0 then
  begin
    if (FTimerInt > 0) and (FAllIncTimeFake > 500) and (FAllIncStepFake > 0) and (FAllIncStep > 0) then
      S := GetTimeStr(FAllIncTimeFake / FAllIncStepFake * 100 - FAllIncTimeFake)
    else if (FAllIncTime > 500) and (FAllIncStep > 0) then
      S := GetTimeStr(FAllIncTime / FAllIncStep * 100 - FAllIncTime)
    else
      S := srEstimating;
    Result := StringReplace(Result, DEF_TIMELEFT_ID, S, [rfReplaceAll]);
  end;
  if Pos(DEF_TIMENEED_ID, Result) > 0 then
  begin
    if (FTimerInt > 0) and (FAllIncTimeFake > 500) and (FAllIncStepFake > 0) and (FAllIncStep > 0) then
      S := GetTimeStr(FAllIncTimeFake / FAllIncStepFake * 100)
    else if (FAllIncTime > 500) and (FAllIncStep > 0) then
      S := GetTimeStr(FAllIncTime / FAllIncStep * 100)
    else
      S := srEstimating;
    Result := StringReplace(Result, DEF_TIMENEED_ID, S, [rfReplaceAll]);
  end;
end;

procedure TfrmWaitWnd.Init(const ATitle, APrompt, ACancelPrompt: string);
begin
  Caption := ATitle;
  FPrompt := APrompt;
  FCancelPrompt := ACancelPrompt;
  FDisableCancel := (FCancelPrompt = '[DISABLED]');
  FPercent := 0;

  FAllIncStep := 0;
  FAllIncTime := 0;

  btnCancel.Visible := not FDisableCancel;
  LabelPrompt.Caption := GetPromptPer(FPercent);
  ProgressBar1.Position := Round(FPercent * 10);
  FLastPercentTick := GetTickCount64;

  FLastTickCount := FLastPercentTick;

  if FModalInited then
    Exit;
  CancelDrag;
  if Visible or not Enabled or (fsModal in FFormState) or
    (FormStyle = fsMDIChild) then
    raise EInvalidOperation.Create(srCanInitWaitWnd);
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  ReleaseCapture;

  Application.ModalStarted;

  FModalInited := True;
  //Include(FFormState, fsModal);

  FFActiveWindow := GetActiveWindow;
  FFSaveFocusSt := SaveFocusState;
  FFSaveCursor := Screen.Cursor;
  Screen.Cursor := crAppStart;
  //FFWindowList := DisableTaskWindows(0);
        FFWindowList := Screen.DisableForms(Self);
  Show;
  SendMessage(Handle, CM_ACTIVATE, 0, 0);
end;

procedure TfrmWaitWnd.ProcessMessages;
begin
  TimerProcRefTimer(nil);

  FAllowClose := False;
  try
    Application.ProcessMessages;
  finally
    FAllowClose := True;
  end;
end;

function TfrmWaitWnd.NeedProgress(SkipCount: Integer): Boolean;
var
  tm: Int64;
begin
  if SkipCount > 0 then
  begin
    Inc(FChkPrgCounter);
    if FChkPrgCounter >= SkipCount then
    begin
      FChkPrgCounter := 0;
    end
    else
    begin
      Result := False;
      Exit;
    end;
  end;
  tm := GetTickCount64;
  Result := Abs(tm - FLastPercentTick) > FSkipCTime;
  if Result then
  begin
    FLastPercentTick := tm;
    ProcessMessages;
  end;
end;

procedure TfrmWaitWnd.Fina;
begin
  FDisableCancel := False;
  if FModalInited then
  try
    try
      SendMessage(Handle, CM_DEACTIVATE, 0, 0);
      //if GetActiveWindow <> Handle then
      //  FFActiveWindow := 0;
    finally
      Hide;
      if Screen.Cursor = crAppStart then
        Screen.Cursor := FFSaveCursor;
     // EnableTaskWindows(FFWindowList);  
        Screen.EnableForms(FFWindowList);
      if FFActiveWindow <> 0 then
      begin
        SetActiveWindow(FFActiveWindow);
        //InvalidateRect(FFActiveWindow, nil, False);
      end;
      RestoreFocusState(FFSaveFocusSt);
      FModalInited := False;
      //Exclude(FFormState, fsModal);
    end;
  finally
    Application.ModalFinished;
  end;
end;

destructor TfrmWaitWnd.Destroy;
begin
  if pfww = Self then
    pfww := nil;
  FDisableCancel := False;
  if FModalInited then
    Fina;

  inherited;
end;

procedure TfrmWaitWnd.CheckAbort;
var
  tm: Int64;
begin
  if FCanceled then
  begin
    PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 12, 0);
    Abort;
  end;
  tm := GetTickCount64;
  if Abs(tm - FLastChkAbtTick) > FSkipCTime then
  begin
    FLastChkAbtTick := tm;
    ProcessMessages;

    if FCanceled then
    begin
      PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 12, 0);
      Abort;
    end;
  end;
end;

procedure TfrmWaitWnd.NotifyAbort(Sender: TObject);
begin
  CheckAbort;
end;

procedure TfrmWaitWnd.CMShowingChanged(var Message: TMessage);
begin
  if Showing then
  begin
    inherited;
    Exit;
  end;
  if FModalInited then
    Include(FFormState, fsModal);
  inherited;
  if FModalInited then
    Exclude(FFormState, fsModal);
end;

procedure TfrmWaitWnd.CheckAbortEx(SkipCount: Integer);
begin
  Inc(FChkAbtCounter);
  if FChkAbtCounter > SkipCount then
  begin
    FChkAbtCounter := 0;
    CheckAbort;
  end;
end;

function TfrmWaitWnd.GetVirtualProgress(CurT, StepT,
  StepP, DivPercent: Double): Double;
var
  StP, CurP, StC, CurC: Double;
  I: Integer;
begin
  if CurT = 0 then
    Result := 0
  else
  begin
    StP := 0;
    StC := 0;
    CurC := StepT;
    CurP := DivPercent; //DEF_DIVPERCENT;
    I := 0;
    while CurT > StC + CurC do
    begin
      Inc(I);
      if I > 1000 then
        Break;
      StP := StP + CurP;
      CurP := (1 - StP) * DivPercent; //DEF_DIVPERCENT;
      StC := StC + CurC;
      CurC := StepT * (1 shl I);
    end;

    if (CurC = 0) or (CurP = 0) then
      Result := 0
    else
      Result := (StP + (CurT - StC) / CurC * CurP) * StepP;
  end;
end;

procedure TfrmWaitWnd.SetVirtualProgressRef(ADefIncStep, ADefIncTime: Double;
  bAutoRep: Boolean; iTimerInt: DWord);
begin
  FDefIncStep := aDefIncStep;
  FDefIncTime := aDefIncTime;
  FTimerInt := iTimerInt;
  FAutoRep := bAutoRep;

  FAllIncStep := 0;
  FAllIncTime := 0;
  FLastTickCount := GetTickCount64;
  FTimerTick := GetTickCount64;

  CheckRefresh;
end;

procedure TfrmWaitWnd.CheckRefresh;
begin
  LabelPrompt.Caption := GetPromptPer(FPercent);
  ProgressBar1.Position := Round(FPercent * 10);
  FLastTickCount := GetTickCount64;
  Refresh;
end;

procedure TfrmWaitWnd.TimerProcRefTimer(Sender: TObject);
var
  TM: Int64;
  StepT, Pos, Divp: Double;
const
  DEF_DIVPERCENT = 0.618;
begin
  if FCanceled then
    Exit;
  if FTimerInt <= 0 then
    Exit;
  try
    Tm := GetTickCount64;
    if Abs(Tm - FTimerTick) < FTimerInt then
      Exit;
    StepT := FDefIncTime / 2;
    Divp := DEF_DIVPERCENT;
    if FAutoRep and (FAllIncStep > 0) and (FAllIncTime > FDefIncTime / 3) then
    begin
      StepT := FAllIncTime / FAllIncStep * FDefIncStep;
      Divp := 0.95;
      if FPercent + FDefIncStep >= 99 then
      begin
        Divp := 0.9999;
        StepT := StepT * 0.9;
      end;
    end;
    //StepT := StepT / 2;
    Pos := GetVirtualProgress((Tm - FLastTickCount), StepT, FDefIncStep, Divp);
    {if (Pos / FDefIncStep) < 0.05 then
    begin
      Sleep(10);
    end;}
    Pos := FPercent + Pos;
    if Pos > 99 then
      Pos := 99;
    if Pos < FPercent then
      Pos := FPercent;
    {if Pos < ProgressBar1.Position / 10 then
      Pos := ProgressBar1.Position / 10;}
    if Pos > FPercent + FDefIncStep then
      Pos := FPercent + FDefIncStep;

    FAllIncStepFake := Pos;
    FAllIncTimeFake := FAllIncTime + Tm - FLastTickCount;
    ProgressBar1.Position := Round(Pos * 10);
    LabelPrompt.Caption := GetPromptPer(Pos);
  except
  end;
end;

function TfrmWaitWnd.SetFocusedControl(Control: TWinControl): Boolean;
begin
  if Assigned(Control) then
    Control.ControlState := [csFocusing];
  Result := inherited SetFocusedControl(Control);
end;

function TfrmWaitWnd.MessageBoxR(const AText, ACaption: string;
  AFlags: Integer): Integer;
var
  Tm: Int64;
begin
  Tm := GetTickCount64;
  FPaused := True;
  try
    //Animate1.Active := False;
    Result := Application.MessageBox(PChar(AText), PChar(ACaption), AFlags);
    //Animate1.Active := True;
  finally
    FPaused := False;
    FLastTickCount := FLastTickCount + (Int64(GetTickCount64) - Tm);
  end;
end;

procedure TfrmWaitWnd.FormCreate(Sender: TObject);
begin
  FAllowClose := True;
  FSkipCTime := 50;
end;

function TfrmWaitWnd.CheckCanceled: Boolean;
begin
  ProcessMessages;
  Result := FCanceled;
end;

{ TWaitingThread }

constructor TWaitingThread.Create(const ATitle, APrompt,
  ACancelPrompt: string; const AWaitProc: TWaitingProcedure);
begin
  inherited Create(nil);
  FTitle := ATitle;
  FPrompt := APrompt;
  FCancelPrompt := ACancelPrompt;
  FWaitProc := AWaitProc;
end;

function TWaitingThread.Terminated: Boolean;
begin
  Result := CheckCanceled;
end;

class function TWaitingThread.Wait(const ATitle, APrompt,
  ACancelPrompt: string; const AWaitProc: TWaitingProcedure;
  APreWaitTime: DWord): Boolean;
var
  fww: TWaitingThread;
begin
  fww := TWaitingThread.Create(ATitle, APrompt, ACancelPrompt, AWaitProc);
  try
    Result := fww.WaitEx;
  finally
    fww.Release;
  end;
end;

function TWaitingThread.WaitEx: Boolean;
begin
  Init(FTitle, FPrompt, FCancelPrompt);
  repeat
    Result := False;
    if Assigned(FWaitProc) then
      FWaitProc(Self, Result);
  until Result or Canceled;
end;

procedure TfrmWaitWnd.Release;
begin
  Free;
end;

end.

