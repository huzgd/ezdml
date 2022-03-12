unit ThreadWait;

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ActnList, Buttons
  {$IFDEF WINDOWS}, Windows{$ENDIF};
        
const
  WMZ_CLOSE = WM_USER + $1031;
type

  { TfrmThreadWait }

  TfrmThreadWait = class(TForm)
    LabelPrompt: TLabel;
    btnCancel: TButton;
    Image1: TImage;
    ActionList1: TActionList;
    actCancel: TAction;
    TimerAfterShow: TTimer;
    ProgressBarMain: TProgressBar;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actCancelExecute(Sender: TObject);
    procedure TimerAfterShowTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FOnCancel: TNotifyEvent;
    FCanClose: Boolean;
    FCancelPrompt: string;
    FAfterShow: TNotifyEvent;
    FCloseWhenCanceled: Boolean;  
    procedure _WMZ_CLOSE(var msg: TMessage); message WMZ_CLOSE;
  public
    procedure SetClose;

    property CancelPrompt: string read FCancelPrompt write FCancelPrompt;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property AfterShow: TNotifyEvent read FAfterShow write FAfterShow;
    property CloseWhenCanceled: Boolean read FCloseWhenCanceled write FCloseWhenCanceled;
  end;


  TWaitResult = (wrWaiting, wrFailed, wrSuccess, wrCanceled);
  TWaitProcedure = procedure(var bSuccess: Boolean) of object;

  TWaitThread = class(TThread)
  private
    FfrmWait: TfrmThreadWait;
    FWaitResult: TWaitResult;
    FWaitProc: TWaitProcedure;
    FErrorMsg: string;
                     
    {$IFDEF WINDOWS}
    function GetFinished: Boolean; 
    {$ENDIF}

  protected
    procedure Execute; override;
    procedure On_Cancel(Sender: TObject);

    function CreateWaitform: TfrmThreadWait; virtual;
  public
    CustWaitProc: procedure(var bSuccess: Boolean);
    constructor Create(const ATitle, APrompt, ACancelPrompt: string;
      const AWaitProc: TWaitProcedure); virtual;
    destructor Destroy; override;

    function WaitEx(TicksBeforeShow: Integer): Boolean;
    //线程执行完自动FREE
    procedure AutoFree;
    class function Wait(const ATitle, APrompt, ACancelPrompt: string;
      const AWaitProc: TWaitProcedure; TicksBeforeShow: Integer; const AOnShowProc: TNotifyEvent;
      bShowBtns: Boolean): Boolean;
    {$IFDEF WINDOWS}
    property Finished: Boolean read GetFinished;
    {$ENDIF}
    property WaitResult: TWaitResult read FWaitResult;
    property frmWait: TfrmThreadWait read FfrmWait;
    property ErrorMsg: string read FErrorMsg write FErrorMsg;
  end;

var
  FLastShowingWaitForm: TfrmThreadWait;

function IsWaitingShowing: Boolean;

implementation

{$R *.dfm}

function IsWaitingShowing: Boolean;
begin
  Result := False;
  if FLastShowingWaitForm <> nil then
    if FLastShowingWaitForm.Showing then
      Result := True;
end;


{ TWaitThread }

constructor TWaitThread.Create(const ATitle, APrompt, ACancelPrompt: string;
  const AWaitProc: TWaitProcedure);
begin
  inherited Create(True);

  FfrmWait := CreateWaitform;
  FfrmWait.FCloseWhenCanceled := True;

  if ATitle <> '' then
    FfrmWait.Caption := ATitle;

  if APrompt <> '' then
    FfrmWait.LabelPrompt.Caption := APrompt
  else
  begin

  end;

  FfrmWait.OnCancel := On_Cancel;
  FfrmWait.CancelPrompt := ACancelPrompt;

  FWaitProc := AWaitProc;
  //FreeOnTerminate := True;
  FWaitResult := wrWaiting;
  Resume;
end;

function TWaitThread.CreateWaitform: TfrmThreadWait;
begin
  Result := TfrmThreadWait.Create(nil);
end;

destructor TWaitThread.Destroy;
begin
  FfrmWait.Release;
  FfrmWait := nil;

  inherited;
end;

procedure TWaitThread.Execute;
var
  bWaitResult: Boolean;
begin
  try
    bWaitResult := False;
    if Assigned(FWaitProc) then
      FWaitProc(bWaitResult)
    else if Assigned(CustWaitProc) then
      CustWaitProc(bWaitResult);
    if bWaitResult then
    begin
      FWaitResult := wrSuccess;
      FfrmWait.SetClose;
    end
    else
    begin
      if FWaitResult <> wrCanceled then
        FWaitResult := wrFailed;
      FfrmWait.SetClose;
    end;
  except
    on E: Exception do
    begin
      ErrorMsg := E.Message;
      FWaitResult := wrFailed;
      FfrmWait.SetClose;
    end;
  end;
end;

{$IFDEF WINDOWS}
function TWaitThread.GetFinished: Boolean;
begin
  Result := (WaitforSingleObject(Handle, 0) = WAIT_OBJECT_0);
end;  
{$ENDIF}

procedure TWaitThread.On_Cancel(Sender: TObject);
begin
  FWaitResult := wrCanceled;
  Terminate;
end;

class function TWaitThread.Wait(const ATitle, APrompt, ACancelPrompt: string;
  const AWaitProc: TWaitProcedure; TicksBeforeShow: Integer;
  const AOnShowProc: TNotifyEvent; bShowBtns: Boolean): Boolean;
begin
  with TWaitThread.Create(ATitle, APrompt, ACancelPrompt, AWaitProc) do
  try
    FfrmWait.btnCancel.Visible := bShowBtns;
    FfrmWait.AfterShow := AOnShowProc;
    Result := WaitEx(TicksBeforeShow);
  finally
    Free;
  end;
end;

procedure TWaitThread.AutoFree;
begin
  if Finished then
    Free
  else
    Self.FreeOnTerminate := True;
end;

function TWaitThread.WaitEx(TicksBeforeShow: Integer): Boolean;
var
  I, tm: Integer;
begin
  if TicksBeforeShow > 0 then
  begin
    tm := TicksBeforeShow div 100;
    for I := 0 to tm do
    begin
      Sleep(100);
      if WaitResult <> wrWaiting then
      begin
        Break;
      end;
    end;
  end;
  if WaitResult = wrWaiting then
    FfrmWait.ShowModal;
  Result := (WaitResult = wrSuccess);
  if ErrorMsg <> '' then
    raise Exception.Create(ErrorMsg);
end;

{ TfrmThreadWait }


procedure TfrmThreadWait.btnCancelClick(Sender: TObject);
begin
  actCancel.Execute;
end;

procedure TfrmThreadWait.SetClose;
begin
  FCanClose := True;
  if HandleAllocated and Visible then
    PostMessage(Handle, WMZ_CLOSE, 0, 0);
end;

procedure TfrmThreadWait.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;
  if not FCanClose then
    actCancel.Execute;
  if FCanClose then
    if FLastShowingWaitForm = Self then
      FLastShowingWaitForm := nil;
end;

procedure TfrmThreadWait.actCancelExecute(Sender: TObject);
begin
  if FCancelPrompt <> '' then
    if Application.MessageBox(PChar(FCancelPrompt), PChar(Application.Title),
      MB_YESNO + MB_ICONQUESTION) <> IDYES then
      Exit;

  if Assigned(FOnCancel) then
    FOnCancel(Sender);
  if FCloseWhenCanceled then
    SetClose;
end;

procedure TfrmThreadWait.TimerAfterShowTimer(Sender: TObject);
begin
  TimerAfterShow.Enabled := False;
  if Assigned(FAfterShow) then
    FAfterShow(Self);
end;

procedure TfrmThreadWait.FormDestroy(Sender: TObject);
begin
  TimerAfterShow.Enabled := False;
  if FLastShowingWaitForm = Self then
    FLastShowingWaitForm := nil;
end;

procedure TfrmThreadWait.FormHide(Sender: TObject);
begin
  if FLastShowingWaitForm = Self then
    FLastShowingWaitForm := nil;
end;

procedure TfrmThreadWait.FormShow(Sender: TObject);
begin
  FLastShowingWaitForm := Self;
end;

procedure TfrmThreadWait._WMZ_CLOSE(var msg: TMessage);
begin
  Close;
end;

end.

