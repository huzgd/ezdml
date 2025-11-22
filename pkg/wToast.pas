unit wToast;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmToast }

  TfrmToast = class(TForm)
    LabelMsg: TLabel;
    TimerHide: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure TimerHideTimer(Sender: TObject);
  private

  public

  end;
     
procedure ShowToastForm(Owner: TComponent; msg, title: string; closeTimeMs: Integer);

implementation

uses
  WindowFuncs;

{$R *.lfm}
             
procedure ShowToastForm(Owner: TComponent; msg, title: string; closeTimeMs: Integer);
begin
  if Owner = nil then
    Owner := Application.MainForm;
  with TfrmToast.Create(Owner) do
  begin
    Caption := title;
    LabelMsg.Caption := msg;
    Left := Application.MainForm.Left+Application.MainForm.Width-Width-ScaleDPISize(6);
    Top := Application.MainForm.Top+Application.MainForm.Height-Height-ScaleDPISize(16);
    if closeTimeMs > 0 then
    begin
      TimerHide.Interval := closeTimeMs;
      TimerHide.Enabled := True;
    end;
    Show;
    Update;
  end;
end;

{ TfrmToast }

procedure TfrmToast.TimerHideTimer(Sender: TObject);
begin
  TimerHide.Enabled := False;
  Self.Close;
end;

procedure TfrmToast.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

end.

