unit uFrameDmlScAttach;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Buttons, Dialogs, ExtCtrls;

type

  { TFrameDmlScAttach }

  TFrameDmlScAttach = class(TFrame)
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    sbtnAdd: TSpeedButton;
    sbtnFile1: TSpeedButton;
    sbtnFile2: TSpeedButton;
    procedure sbtnAddClick(Sender: TObject);
  private

  public   
    constructor Create(TheOwner: TComponent); override;

  end;

implementation

{$R *.lfm}

{ TFrameDmlScAttach }

procedure TFrameDmlScAttach.sbtnAddClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    ;//AddFile(OpenDialog1.FileName);
end;

constructor TFrameDmlScAttach.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

end.

