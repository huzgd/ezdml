unit MessageBoxOnTop;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmMessageBoxOnTop }

  TfrmMessageBoxOnTop = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lbMessage: TLabel;
  private

  public

  end;

function ShowMessageOnTop(AMessage, ATitle: string): Integer;

implementation

{$R *.lfm}

function ShowMessageOnTop(AMessage, ATitle: string): Integer;   
var
  frm: TfrmMessageBoxOnTop;
begin                      
  frm:= TfrmMessageBoxOnTop.Create(nil);
  try
    frm.lbMessage.Caption:=AMessage;
    frm.Caption := ATitle;
    Result := frm.ShowModal;
  finally
    frm.Close;
  end;
end;

end.

