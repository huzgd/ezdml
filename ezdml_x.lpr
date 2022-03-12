program ezdml_x;

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
  CtObjSerialer in 'DML\Ctobj\CtObjSerialer.pas',
  CTMetaData in 'DML\Ctobj\CTMetaData.pas',
  WindowFuncs in 'DML\Ctobj\WindowFuncs.pas',
  wDmlHelp in 'wDmlHelp.pas' {frmHelpAbout},
  CtObjXmlSerial in 'DML\Ctobj\CtObjXmlSerial.pas',
  ezdmlstrs in 'ezdmlstrs.pas',
  CtObjJsonSerial in 'DML\Ctobj\CtObjJsonSerial.pas',
  CtMetaEzdmlFakeDb in 'DML\CtMetaEzdmlFakeDb.pas',
  CtMetaTable in 'DML\CtMetaTable.pas',
  dmlstrs in 'DML\dmlstrs.pas',
  uColorStyles in 'DML\uColorStyles.pas' {frmColorStyles},
  uDMLSqlEditor in 'DML\uDMLSqlEditor.pas' {frmDmlSqlEditor},
  uFormAddCtFields in 'DML\uFormAddCtFields.pas' {frmAddCtFields},
  uFormAddTbLink in 'DML\uFormAddTbLink.pas' {frmAddTbLink},
  uFormCtDbLogon in 'DML\uFormCtDbLogon.pas' {frmLogonCtDB},
  uFormCtDML in 'DML\uFormCtDML.pas' {frmCtDML},      
  uFormDmlSearch in 'DML\uFormDmlSearch.pas' {frmDmlSearch},
  uFormCtFieldProp in 'DML\uFormCtFieldProp.pas' {frmCtMetaFieldProp},
  uFormCtTableProp in 'DML\uFormCtTableProp.pas' {frmCtTableProp},
  uFormGenCode in 'DML\uFormGenCode.pas' {frmCtGenCode},
  uFormGenSql in 'DML\uFormGenSql.pas' {frmCtGenSQL},
  uFormImpTable in 'DML\uFormImpTable.pas' {frmImportCtTable},
  uFrameCtFieldDef in 'DML\uFrameCtFieldDef.pas' {FrameCtFieldDef: TFrame},
  uFrameCtTableDef in 'DML\uFrameCtTableDef.pas' {FrameCtTableDef: TFrame},
  uFrameCtTableList in 'DML\uFrameCtTableList.pas' {FrameCtTableList: TFrame},
  uFrameCtTableProp in 'DML\uFrameCtTableProp.pas' {FrameCtTableProp: TFrame},
  uFrameDML in 'DML\uFrameDML.pas' {FrameDML: TFrame},
  uWaitWnd in 'DML\uWaitWnd.pas' {frmWaitWnd},
  XLSfile in 'DML\XLSfile.pas',
  uJSON in 'pkg\uJSON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := srEzdmlAppTitle;
  CheckAppStart;
  Application.CreateForm(TfrmMainDml, frmMainDml);
  Application.Run;
end.
