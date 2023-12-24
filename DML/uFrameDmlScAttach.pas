unit uFrameDmlScAttach;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Buttons, Dialogs, ExtCtrls;

type

  { TFrameDmlScAttach }

  TFrameDmlScAttach = class(TFrame)
    FlowPanel1: TFlowPanel;
    OpenDialog1: TOpenDialog;
    sbtnAdd: TSpeedButton;
    sbtnFile1: TSpeedButton;
    sbtnFile2: TSpeedButton;
    procedure sbtnAddClick(Sender: TObject);
  private
    FReadOnlyMode: Boolean;
    procedure SetReadOnlyMode(AValue: Boolean);

  public   
    constructor Create(TheOwner: TComponent); override;
    procedure CheckAutoHeight;
    property ReadOnlyMode: Boolean read FReadOnlyMode write SetReadOnlyMode;
  end;

implementation

{$R *.lfm}

uses
  WindowFuncs;

{ TFrameDmlScAttach }

procedure TFrameDmlScAttach.sbtnAddClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    ;//AddFile(OpenDialog1.FileName);
end;

procedure TFrameDmlScAttach.SetReadOnlyMode(AValue: Boolean);
begin
  if FReadOnlyMode=AValue then Exit;
  FReadOnlyMode:=AValue;
  sbtnAdd.Visible := not FReadOnlyMode;
end;

constructor TFrameDmlScAttach.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FReadOnlyMode := False;
end;

procedure TFrameDmlScAttach.CheckAutoHeight;
begin
  if sbtnAdd.Visible then
    Self.Height := sbtnAdd.Top + sbtnAdd.Height + sbtnFile1.Top
  else
    Self.Height := sbtnFile2.Top + sbtnFile2.Height + sbtnFile1.Top;
end;

end.

