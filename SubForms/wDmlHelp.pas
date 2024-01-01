unit wDmlHelp;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, StdActns;

type
  TfrmHelpAbout = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadFile(fn: string);
  end;

var
  frmHelpAbout: TfrmHelpAbout;

implementation

uses ezdmlstrs, dmlstrs, CtMetaTable, WindowFuncs;

{$R *.lfm}

procedure TfrmHelpAbout.FormShow(Sender: TObject);
begin
  Memo1.WordWrap := True;
end;

procedure TfrmHelpAbout.LoadFile(fn: string);
begin
  if fn = '' then
  begin
    fn := GetFolderPathOfAppExe;
    fn := FolderAddFileName(fn, 'readme.txt');
    fn := GetConfigFile_OfLang(fn);
  end;
  //Memo1.Lines[0] := Format(Memo1.Lines[0], [srEzdmlVersionNum]);
  if FileExists(fn) then
    Memo1.Lines.LoadFromFile(fn)
  else
    Memo1.Lines.Text := 'Help file not found:'#10+fn;
end;

procedure TfrmHelpAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

