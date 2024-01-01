program ezdml_lite;

{$MODE Delphi}

{%File 'dict.txt'}
{%File 'readme.txt'}
{%File 'readme_CHS.txt'}

uses    
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Forms, Interfaces,
  wMainDml in 'wMainDml.pas' {frmMainDml},     
  ezdmlstrs in 'ezdmlstrs.pas',
  uJSON in 'pkg\uJSON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := srEzdmlAppTitle;
  CheckAppStart;
  Application.CreateForm(TfrmMainDml, frmMainDml);
  Application.Run;
end.
