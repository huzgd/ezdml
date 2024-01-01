unit wAbout;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    btnOk: TButton;
    Image1: TImage;
    lbAcknowledgements: TLabel;
    lbVersion: TLabel;
    lbTitle: TLabel;
    memoAcks: TMemo;
    memoAuthor: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

implementation

uses
  ezdmlstrs;

{$R *.lfm}

{ TfrmAbout }

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lbTitle.Caption := srEzdmlAppTitleOS;
  lbVersion.Caption := Format('V%s %s (Freeware)', [srEzdmlVersionNum, srEzdmlVersionDate]);
  memoAuthor.Lines.Text := 'http://www.ezdml.com'#13#10'huzzz@163.com'#13#10'QQ group: 344282607'#13#10'http://www.ezdml.com/blog/';
end;

end.

