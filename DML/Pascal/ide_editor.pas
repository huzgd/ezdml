//Version: 31Jan2005

unit ide_editor;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, ComCtrls,
  SynEdit, SynEditTypes, SynHighlighterPas, SynHighlighterJava,
  uPSRuntime, uPSDisassembly, uPSUtils,
  uPSComponent, uPSDebugger,
  //SynEditRegexSearch, SynEditSearch,
  SynEditMarks,
  SynEditMiscClasses, SynEditHighlighter, ActnList,
  ImgList, CtMetaTable, DmlScriptPublic;

type

  { TfrmScriptIDE }

  TfrmScriptIDE = class(TForm)
    actSwitchLayout: TAction;
    MenuItem1: TMenuItem;
    MN_SwitchLayout: TMenuItem;
    PopupMenu1: TPopupMenu;
    BreakPointMenu: TMenuItem;
    MainMenu1: TMainMenu;
    MN_File: TMenuItem;
    MN_Run: TMenuItem;
    MN_StepOver: TMenuItem;
    MN_StepInto: TMenuItem;
    N1: TMenuItem;
    MN_Reset: TMenuItem;
    N2: TMenuItem;
    MN_DoRun: TMenuItem;
    MN_Exit1: TMenuItem;
    SplitterRes: TSplitter;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    N3: TMenuItem;
    N4: TMenuItem;
    MN_New1: TMenuItem;
    MN_Open1: TMenuItem;
    MN_Save1: TMenuItem;
    MN_Saveas1: TMenuItem;
    StatusBar: TStatusBar;
    MN_Decompile: TMenuItem;
    N5: TMenuItem;
    MN_Pause: TMenuItem;
    MN_Search: TMenuItem;
    MN_Find1: TMenuItem;
    MN_Replace1: TMenuItem;
    MN_Searchagain1: TMenuItem;
    N6: TMenuItem;
    MN_Gotolinenumber1: TMenuItem;
    MN_Syntaxcheck: TMenuItem;
    ImageList1: TImageList;
    ActionList1: TActionList;
    actNew: TAction;
    actOpen: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actSyntaxcheck: TAction;
    actDecompile: TAction;
    actStepOver: TAction;
    actStepInto: TAction;
    actPause: TAction;
    actReset: TAction;
    actRun: TAction;
    actBreakPoint: TAction;
    actExit: TAction;
    TimerInit: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton17: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton18: TToolButton;
    ToolButton20: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    MN_BreakPoint: TMenuItem;
    actFind: TAction;
    actReplace: TAction;
    actSearchAgain: TAction;
    actGoto: TAction;
    PanelRes: TPanel;
    MemoRes: TMemo;
    Messages: TListBox;
    TabSetRes: TTabControl;
    actCut: TAction;
    actCopy: TAction;
    actPaste: TAction;
    actSelectAll: TAction;
    actUndo: TAction;
    actRedo: TAction;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N7: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    N8: TMenuItem;
    SelectAll1: TMenuItem;
    N9: TMenuItem;
    Find2: TMenuItem;
    Replace2: TMenuItem;
    Searchagain2: TMenuItem;
    N10: TMenuItem;
    actClearBrkpoints: TAction;
    MN_ClearBreakPoints: TMenuItem;
    ClearBreakPoints2: TMenuItem;
    TimerHint: TTimer;
    actHelp: TAction;
    MN_Help: TMenuItem;
    pmSpecCopy: TMenuItem;
    pmCopyAsJava: TMenuItem;
    pmCopyAsCSharp: TMenuItem;
    pmCopyAsCpp: TMenuItem;
    pmCopyAsC: TMenuItem;
    pmCopyAsDelphi: TMenuItem;
    pmCopyAsPLSql: TMenuItem;
    actShowTempFile: TAction;
    MnShowTemporaryfile1: TMenuItem;
    actShowInExplorer: TAction;
    MN_ShowInExplorer1: TMenuItem;
    MN_Recentfiles: TMenuItem;
    N11: TMenuItem;
    procedure actShowInExplorerExecute(Sender: TObject);
    procedure actShowTempFileExecute(Sender: TObject);
    procedure actSwitchLayoutExecute(Sender: TObject);
    procedure TimerHintTimer(Sender: TObject);
    procedure actClearBrkpointsExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: boolean);
    procedure actRedoExecute(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure TabSetResChange(Sender: TObject);
    procedure actGotoExecute(Sender: TObject);
    procedure actSearchAgainExecute(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actBreakPointExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actResetExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure actStepIntoExecute(Sender: TObject);
    procedure actStepOverExecute(Sender: TObject);
    procedure actDecompileExecute(Sender: TObject);
    procedure actSyntaxcheckExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edSpecialLineColors(Sender: TObject; Line: integer;
      var Special: boolean; var FG, BG: TColor);
    procedure ceLineInfo(Sender: TObject; const FileName: string;
      Position, Row, Col: cardinal);
    procedure ceIdle(Sender: TObject);
    procedure ceExecute(Sender: TPSScript);
    procedure ceAfterExecute(Sender: TPSScript);
    procedure ceCompile(Sender: TPSScript);
    function ceNeedFile(Sender: TObject; const OrginFileName: string;
      var FileName, Output: string): boolean;
    procedure ceBreakpoint(Sender: TObject; const FileName: string;
      Position, Row, Col: cardinal);
    procedure messagesDblClick(Sender: TObject);
    procedure edDropFiles(Sender: TObject; X, Y: integer;
      AFiles: TStrings);
    procedure actHelpExecute(Sender: TObject);
    procedure pmCopyAsJavaClick(Sender: TObject);
    procedure pmCopyAsCClick(Sender: TObject);
    procedure pmCopyAsCSharpClick(Sender: TObject);
    procedure pmCopyAsCppClick(Sender: TObject);
    procedure pmCopyAsDelphiClick(Sender: TObject);
    procedure pmCopyAsPLSqlClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerInitTimer(Sender: TObject);
  private
    //FSearchFromCaret: boolean;
    FActiveLine: longint;
    FResume: boolean;
    FActiveFile: string;
    FOrgFormCaption: string;
    FMouseX, FMouseY: integer;
    FTempSpScript: string;
    FRecentFiles: TStringList;
    FEnablePasDbg: boolean;
    FLastEvalVarName: string;

    procedure CheckRestoreTempPsp;
    procedure ForceRestoreTempPsp;
    procedure CheckSpRunMode;

    function Compile: boolean;
    function Execute: boolean;

    procedure LoadIni;
    procedure SaveIni;
    procedure RecreateRecentMn;
    procedure _OnRecentFileClick(Sender: TObject);

    procedure SetActiveFile(const Value: string);
    function GetLastFile(var forceFile: string): string;
    procedure SetLastFile(const scFile, forceFile: string);

    procedure DoSearchReplaceText(AReplace: boolean; ABackwards: boolean);
    procedure ShowSearchReplaceDialog(AReplace: boolean);

    procedure edStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure SynEditGutterClick(Sender: TObject; X, Y, Line: integer;
      Mark: TSynEditMark);
    procedure edMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);

    procedure CheckActionsEnable;

    procedure PopupMenuEdPopup(Sender: TObject);
    procedure CopyTextAs(tp: string);

    function IsTmpFile(fn: string): boolean;
    function GetTmpDirForFile(fn: string): string;
    function GetLastTmpFileName(fn: string): string; //最后一次的临时文件名
    function GetNewTmpFileName(fn: string): string;
    function GetFileNameForcely: string;
    procedure SaveToTempFile;
  public
    ce: TPSScriptDebugger;
    ed: TSynEdit;
    pashighlighter: TSynPasSyn;
    jshighlighter: TSynJavaSyn;
    //SynEditSearch: TSynEditSearch;
    //SynEditRegexSearch: TSynEditRegexSearch;
    HintWin: THintWindow;
    FDmlBaseScriptor: TDmlBaseScriptor;

    FileModified: boolean;
    procedure DmlScInit(const AFileName: string; ACtObj: TCtMetaObject;
      AResout: TStrings; ACtrlList: TObject);
    procedure DmlScReInit(const AFileName: string; bForce: boolean = False);
    procedure DmlScLoadFromFile(fn: string);
    procedure DmlScSaveToFile(fn: string);

    procedure SwitchResLayout;

    function SaveCheck(bIsExiting, bIsBakForRun: boolean): boolean;
    procedure TryLoadLastFile;
    property ActiveFile: string read FActiveFile write SetActiveFile;
  end;

var
  scriptIdeEditor: TfrmScriptIDE;

implementation

uses
  DmlPasScript, dmlstrs, ClipBrd, WindowFuncs,
  SynExportHTML, IniFiles, StrUtils;

{$R *.lfm}

const
  isRunningOrPaused = [isRunning, isPaused];

// options - to be saved to the registry
{var
  gbSearchBackwards: boolean;
  gbSearchCaseSensitive: boolean;
  gbSearchFromCaret: boolean;
  gbSearchSelectionOnly: boolean;
  gbSearchTextAtCaret: boolean;
  gbSearchWholeWords: boolean;
  gbSearchRegex: boolean;
  gsSearchText: string;
  gsSearchTextHistory: string;
  gsReplaceText: string;
  gsReplaceTextHistory: string;   }

resourcestring
  //STR_TEXT_NOTFOUND = 'Text not found: ';
  STR_UNNAMED = 'Unnamed';
  STR_SUCCESSFULLY_COMPILED = 'Succesfully compiled';
  STR_PS_EXECUTING = 'Executing...';
  STR_SUCCESSFULLY_EXECUTED = 'Succesfully executed';
  STR_RUNTIME_ERROR = '[Runtime error] %s(%d:%d), bytecode(%d:%d): %s'; //Birb
  //STR_FORM_TITLE = 'Editor';
  //STR_FORM_TITLE_RUNNING = 'Editor - Running';
  //STR_INPUTBOX_TITLE = 'Script';
  STR_NEWWARN_NOTSAVED =
    'Warning: Script content is not saved and will be lost. Are you sure to continue?';

const
  STR_DEFAULT_PROGRAM_JS = '//Java Script' + #10 +
    '//This example shows how to traverse all Models, Tables and Fields with javascript (click New again will switch to PascalScript)'
    + #10 +
    '//本示例演示如何编写JavaScript脚本（再次新建可切换为PascalScript）遍历所有模型、表和字段'
    + #10 +
    '' + #10 +
    'for(var i=0; i<allModels.count; i++)' + #10 +
    '//if(allModels.getItem(i) == allModels.curDataModel)' + #10 +
    '{' + #10 +
    '  var md=allModels.getItem(i);' + #10 +
    '  curOut.add(''Model''+i+'': ''+md.nameCaption);' + #10 +
    '' + #10 +
    '  for(var j=0; j<md.tables.count; j++)' + #10 +
    '  //if(md.tables.getItem(j).isSelected)' + #10 +
    '  //if(curTable && md.tables.getItem(j).name == curTable.name)' + #10 +
    '  {' + #10 +
    '    var tb = md.tables.getItem(j);' + #10 +
    '    curOut.add(''  Table''+j+'': ''+tb.nameCaption);' + #10 +
    '' + #10 +
    '    for(var k=0; k<tb.metaFields.count; k++)' + #10 +
    '    {' + #10 +
    '      var fd = tb.metaFields.getItem(k);' + #10 +
    '      curOut.add(''    Field''+k+'': ''+fd.nameCaption);' + #10 +
    '    }' + #10 +
    '  }' + #10 +
    '  //release memory' + #10 +
    '  //JS占内存高，必要时要手工释放内存' + #10 +
    '  _gc();' + #10 +
    '}' + #10 +
    '' + #10 +
    '' + #10 +
    '/*' + #10 +
    '<%' + #10 +
    '//This example shows how to write script-page template' + #10 +
    '//以下示例演示如何编写脚本页面模板' + #10 +
    'var md=curModel;' + #10 +
    '%>' + #10 +
    '<html>' + #10 +
    '<body>' + #10 +
    '<% for(var i=0; i<md.tables.count; i++) {' + #10 +
    '  var tb = md.tables.getItem(i); %>' + #10 +
    '<div class="container eztable">' + #10 +
    '  <dl class="eztable">' + #10 +
    '    <dt class="tb_header" href="http://xxx/showtb/">${tb.name}</dt>' + #10 +
    '    <% for(var k=0; k<tb.metaFields.count; k++) {' + #10 +
    '      var fd = tb.metaFields.getItem(k); %>' + #10 +
    '    <dd>' + #10 +
    '      <a href="javascript:;">${k+1}. ${fd.name}</a>' + #10 +
    '    </dd>' + #10 +
    '    <% } %>' + #10 +
    '  </dl>' + #10 +
    '</div>' + #10 +
    '<% } %>' + #10 +
    '</body>' + #10 +
    '</html>' + #10 +
    '*/' + #10 +
    '' + #10 +
    '' + #10 +
    '/*' + #10 +
    '//The following example shows how to process Text file' + #10 +
    '//以下示例演示如何编写脚本处理文本文件' + #10 +
    'var ts = new TStringList();' + #10 +
    '//tx.text := ''xxxx'';' + #10 +
    'curOut.add(''start...'');' + #10 +
    'ts.loadFromFile(''C:\\a.txt'');' + #10 +
    'for(var i=ts.count -1;i>=0;i--)' + #10 +
    '{' + #10 +
    '  var s = ts.getString(i);' + #10 +
    '  if(s.indexOf(''test'')>=0)' + #10 +
    '    ts.delete(i);' + #10 +
    '  if(s.indexOf(''hello'')>=0)' + #10 +
    '    ts.setString(i,_stringReplace(s, ''hello!'', ''hi!'', ''rfReplaceAll, rfIgnoreCase''));'
    + #10 +
    '  curOut.add(_format(''Add(\''%s\'');'',s));' + #10 +
    '}' + #10 +
    'ts.saveToFile(''C:\\a1.txt'');' + #10 +
    'curOut.add(''done!'');' + #10 +
    '*/' + #10 +
    '' + #10 +
    '/*' + #10 +
    '//The following example shows how to iterate properties of an object' + #10 +
    '//以下示例演示如何编写脚本遍历对象属性' + #10 +
    'var obj=curTable;' + #10 +
    'if(!obj){' + #10 +
    '  curOut.add(''no table selected'');' + #10 +
    '  _abort();' + #10 +
    '}' + #10 +
    'var keys = Object.getOwnPropertyNames(obj);' + #10 +
    'curOut.add("class: "+obj._className);' + #10 +
    'curOut.add("keys:");' + #10 +
    'curOut.add(keys);' + #10 +
    'curOut.add("-----------------------");' + #10 +
    'curOut.add("props:");' + #10 +
    'curOut.add("-----------------------");' + #10 +
    'Object.keys(obj).forEach(function(key){' + #10 +
    '' + #9 + 'curOut.add(key+":"+obj[key]);' + #10 +
    '});' + #10 +
    '*/' + #10 +
    '' + #10 +
    '/*' + #10 +
    '//The following example shows how to run a PascalScript in js' + #10 +
    '//以下示例演示如何在JS脚本中混合调用Pascal脚本' + #10 +
    'var s="function Dll_MsgBox(hWnd: HWND; lpText, lpCaption: PChar; uType: Integer): Integer; external ''MessageBoxA@user32.dll stdcall'';\n" +' + #10 +
    '"var\n" +' + #10 +
    '"  res:Integer;\n" +' + #10 +
    '"begin\n" +' + #10 +
    '"  res := Dll_MsgBox(0, ''hello from user32.dll'', Application.Title, MB_OKCANCEL);\n" +'
    + #10 +
    '"  SetGParamValue(''G_DLL_MSG_RES'', IntToStr(res));\n" +' + #10 +
    '"end.";' + #10 +
    '_runDmlScript(''a.pas'',s);' + #10 +
    'alert(''dll result for pascal: ''+_getGParamValue(''G_DLL_MSG_RES''));' + #10 +
    '*/';

  STR_DEFAULT_PROGRAM_PAS = '//Pascal Script' + #10 +
    '//This example shows how to traverse all Models, Tables and Fields with PascalScript'
    + #10 + // (click actNew again will switch to javascript)
    '//本示例演示如何编写PascalScript脚本遍历所有模型、表和字段' +
    #10 + //（再次新建可切换为JavaScript）
    'var' + #10 +
    '  I, J, K: Integer;' + #10 +
    '  md: TCtDataModelGraph;' + #10 +
    '  tb: TCtMetaTable;' + #10 +
    '  fd: TCtMetaField;' + #10 +
    'begin' + #10 +
    '  for I:=0 to AllModels.Count-1 do' + #10 +
    '  //if AllModels.Items[I] = AllModels.CurDataModel then' + #10 +
    '  begin' + #10 +
    '    md := AllModels.Items[I];' + #10 +
    '    CurOut.Add(''Model''+IntToStr(I)+'': ''+md.NameCaption);' + #10 +
    '    ' + #10 +
    '    for J:=0 to md.Tables.Count-1 do' + #10 +
    '    //if md.Tables.Items[J].IsSelected then' + #10 +
    '    //if CurTable <> nil then if md.Tables.Items[J].Name = CurTable.Name then'
    + #10 +
    '    begin' + #10 +
    '      tb := md.Tables.Items[J];' + #10 +
    '      CurOut.Add(''  Table''+IntToStr(J)+'': ''+tb.NameCaption);' + #10 +
    '    ' + #10 +
    '      for K:=0 to tb.MetaFields.Count -1 do' + #10 +
    '      begin' + #10 +
    '        fd := tb.MetaFields.Items[K];' + #10 +
    '        CurOut.Add(''    Field''+IntToStr(K)+'': ''+fd.NameCaption);' + #10 +
    '      end;' + #10 +
    '    end;' + #10 +
    '  end;' + #10 +
    'end.' + #10 +
    '' + #10 +
    '(*' + #10 +
    '<%' + #10 +
    '//This example shows how to write script-page template' + #10 +
    '//以下示例演示如何编写脚本页面模板' + #10 +
    'var md:TCtDataModelGraph;' + #10 +
    'begin' + #10 +
    'md:=curModel;' + #10 +
    '%>' + #10 +
    '<html>' + #10 +
    '<body>' + #10 +
    '<% gvar I, K: Integer;' + #10 +
    ' for I:=0 to md.Tables.Count-1 do' + #10 +
    ' begin' + #10 +
    '   gvar tb: TCtMetaTable;' + #10 +
    '   gvar fd: TCtMetaField;' + #10 +
    '   tb := md.Tables.Items[I]; %>' + #10 +
    '<div class="container eztable">' + #10 +
    '  <dl class="eztable">' + #10 +
    '    <dt class="tb_header" href="xxx/showtb/">${tb.Name}</dt>' + #10 +
    '    <% for K:=0 to tb.MetaFields.Count-1 do' + #10 +
    '       begin' + #10 +
    '         fd := tb.MetaFields.Items[K]; %>' + #10 +
    '    <dd>' + #10 +
    '      <a href="javascript:;">${K+1}. ${fd.Name}</a>' + #10 +
    '    </dd>' + #10 +
    '    <% end; %>' + #10 +
    '  </dl>' + #10 +
    '</div>' + #10 +
    '<% end; %>' + #10 +
    '</body>' + #10 +
    '</html>' + #10 +
    '<% end. %>' + #10 +
    '*)' + #10 +
    '' + #10 +
    '(*' + #10 +
    '//The following example shows how to process Text file' + #10 +
    '//以下示例演示如何编写脚本处理文本' + #10 +
    'var' + #10 +
    '  I: Integer;' + #10 +
    '  ts: TStringList;' + #10 +
    '  S: String;' + #10 +
    'begin' + #10 +
    '  ts:= TStringList.Create;' + #10 +
    '  try' + #10 +
    '    //tx.Text := ''xxxx'';' + #10 +
    '    CurOut.Add(''start...'');' + #10 +
    '    ts.LoadFromFile(''C:\a.txt'');' + #10 +
    '    for I:=ts.Count -1 downto 0 do' + #10 +
    '    begin' + #10 +
    '      S:= ts[I];' + #10 +
    '      if Pos(''test'', S)>0 then' + #10 +
    '        ts.Delete(I);' + #10 +
    '      if Pos(''hello!'', S)>0 then' + #10 +
    '        ts[I] := StringReplace(S, ''hello!'', ''hi!'', [rfReplaceAll, rfIgnoreCase]);'
    + #10 +
    '      CurOut.Add(Format(''Add(''''%s'''');'',[S]));' + #10 +
    '    end;' + #10 +
    '    ts.SaveToFile(''C:\a1.txt'');' + #10 +
    '    CurOut.Add(''done!'');' + #10 +
    '  finally' + #10 +
    '    ts.Free;' + #10 +
    '  end;' + #10 +
    'end.' + #10 +
    '*)' + #10 +
    '' + #10 +
    '(*' + #10 +
    '//The following example shows how to import function from external DLL' + #10 +
    '//以下示例演示如何编写脚本引用外部DLL' + #10 +
    '//引入DLL函数' + #10 +
    'function Dll_MsgBox(hWnd: HWND; lpText, lpCaption: PChar; uType: Integer): Integer; external ''MessageBoxA@user32.dll stdcall'';'
    + #10 +
    'begin' + #10 +
    '  //调用DLL函数' + #10 +
    '  Dll_MsgBox(0, ''hello from user32.dll'', Application.Title, 0);' + #10 +
    'end.' + #10 +
    '*)' + #10 +
    '';


procedure TfrmScriptIDE.DoSearchReplaceText(AReplace: boolean; ABackwards: boolean);
begin(*
var
  Options: TSynSearchOptions;
begin
  Statusbar.SimpleText := '';
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if gbSearchRegex then
    ed.SearchEngine := SynEditRegexSearch
  else
    ed.SearchEngine := SynEditSearch;
  if ed.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    Application.MessageBox(PChar(STR_TEXT_NOTFOUND + ' ' + gsSearchText),
      PChar(Application.Title), MB_OK or MB_ICONINFORMATION);
    Statusbar.SimpleText := STR_TEXT_NOTFOUND;
    if ssoBackwards in Options then
      ed.BlockEnd := ed.BlockBegin
    else
      ed.BlockBegin := ed.BlockEnd;
    ed.CaretXY := ed.BlockBegin;
  end;

  //if ConfirmReplaceDialog <> nil then
  //  ConfirmReplaceDialog.Free;       *)
end;

procedure TfrmScriptIDE.ShowSearchReplaceDialog(AReplace: boolean);
begin(*
var
  dlg: TTextSearchDialog;
begin
  Statusbar.SimpleText := '';
  if AReplace then
    dlg := TTextReplaceDialog.Create(Self)
  else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do try
    // assign search options
    SearchBackwards := gbSearchBackwards;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchFromCursor := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;
    // start with last search text
    SearchText := gsSearchText;
    if gbSearchTextAtCaret then begin
      // if something is selected search for that text
      if ed.SelAvail and (ed.BlockBegin.Line = ed.BlockEnd.Line) //Birb (fix at SynEdit's SearchReplaceDemo)
        then
        SearchText := ed.SelText
      else
        SearchText := ed.GetWordAtRowCol(ed.CaretXY);
    end;
    SearchTextHistory := gsSearchTextHistory;
    if AReplace then with dlg as TTextReplaceDialog do begin
        ReplaceText := gsReplaceText;
        ReplaceTextHistory := gsReplaceTextHistory;
      end;
    SearchWholeWords := gbSearchWholeWords;
    if ShowModal = mrOK then begin
      gbSearchBackwards := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret := SearchFromCursor;
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchWholeWords := SearchWholeWords;
      gbSearchRegex := SearchRegularExpression;
      gsSearchText := SearchText;
      gsSearchTextHistory := SearchTextHistory;
      if AReplace then with dlg as TTextReplaceDialog do begin
          gsReplaceText := ReplaceText;
          gsReplaceTextHistory := ReplaceTextHistory;
        end;
      fSearchFromCaret := gbSearchFromCaret;
      if gsSearchText <> '' then begin
        DoSearchReplaceText(AReplace, gbSearchBackwards);
        fSearchFromCaret := TRUE;
      end;
    end;
  finally
    dlg.Free;
  end;     *)
end;

procedure TfrmScriptIDE.edSpecialLineColors(Sender: TObject; Line: integer;
  var Special: boolean; var FG, BG: TColor);
begin
  if ce.HasBreakPoint(ce.MainFileName, Line) then
  begin
    Special := True;
    if Line = FActiveLine then
    begin
      BG := clBlue;
      FG := clRed;
    end
    else
    begin
      FG := clWhite;
      BG := clRed;
    end;
  end
  else
  if Line = FActiveLine then
  begin
    Special := True;
    FG := clWhite;
    bg := clBlue;
  end
  else
    Special := False;
end;

procedure TfrmScriptIDE.actCopyExecute(Sender: TObject);
var
  htmlexp: TSynExporterHTML;
  st: TMemoryStream;
  ss: TStringList;
  S: string;
begin
  if (GetKeyState(VK_SHIFT) and $80) <> 0 then
  begin
    htmlexp := TSynExporterHTML.Create(nil);
    st := TMemoryStream.Create;
    ss := TStringList.Create;
    try
      with htmlexp do
      begin
        ExportAsText := False;
        //FConvertUtf8 := TRUE;
        //CreateHTMLFragment := True;
        Highlighter := ed.Highlighter;
        //if SynEditor.SelAvail then
        //  ExportRange(SynEditor.Lines, SynEditor.BlockBegin, SynEditor.BlockEnd)
        //else
        ExportAll(ed.Lines);
        SaveToStream(st);
        st.Seek(0, soFromBeginning);
        ss.LoadFromStream(st);
        S := ss.Text;
        Clipboard.SetAsHtml(S, ed.Lines.Text);
      end;
    finally
      ss.Free;
      st.Free;
      htmlexp.Free;
    end;
  end
  else
    ed.CopyToClipboard;
end;

procedure TfrmScriptIDE.actCutExecute(Sender: TObject);
begin
  ed.CutToClipboard;
end;

procedure TfrmScriptIDE.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmScriptIDE.actFindExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(False);
end;

procedure TfrmScriptIDE.actGotoExecute(Sender: TObject);
begin
  (*
  with TfrmGotoLine.Create(self) do
  try
    Char := ed.CaretX;
    Line := ed.CaretY;
    ShowModal;
    if ModalResult = mrOK then
      ed.CaretXY := CaretXY;
  finally
    Free;
    ed.SetFocus;
  end;   *)
end;

procedure TfrmScriptIDE.actHelpExecute(Sender: TObject);
var
  fn: string;
begin
  fn := GetFolderPathOfAppExe('Templates');
  fn := FolderAddFileName(fn, 'pas_api.txt');
  CtOpenDoc(fn);
  //ShellExecute(0, 'open', PChar(fn), nil, nil, SW_SHOW);
end;

procedure TfrmScriptIDE.ActionList1Update(Action: TBasicAction; var Handled: boolean);
begin
  CheckActionsEnable;
end;

procedure TfrmScriptIDE.actPasteExecute(Sender: TObject);
begin
  ed.PasteFromClipboard;
end;

procedure TfrmScriptIDE.actRedoExecute(Sender: TObject);
begin
  ed.Redo;
end;

procedure TfrmScriptIDE.actReplaceExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(True);
end;

procedure TfrmScriptIDE.actSearchAgainExecute(Sender: TObject);
begin
  {if gsSearchText = '' then
    ShowSearchReplaceDialog(False)
  else
    DoSearchReplaceText(FALSE, FALSE); }
end;

procedure TfrmScriptIDE.actSelectAllExecute(Sender: TObject);
begin
  if ActiveControl = nil then
    Exit;
  if ActiveControl = ed then
    ed.SelectAll
  else if ActiveControl is TCustomEdit then
    TCustomEdit(ActiveControl).SelectAll;
end;

procedure TfrmScriptIDE.actShowInExplorerExecute(Sender: TObject);
var
  S, fn: string;
begin
  fn := Self.ActiveFile;
  if (fn = '') or not FileExists(fn) then
    fn := Application.ExeName;
{$ifdef WINDOWS}
  S := 'Explorer /select, "' + fn + '"';
  ShellCmd(S);
{$else}
  S := ExtractFilePath(fn);
  CtOpenDoc(S);
{$endif}
end;

procedure TfrmScriptIDE.actShowTempFileExecute(Sender: TObject);
var
  S, dir, fn: string;
begin
  fn := GetFileNameForcely;

  dir := GetTmpDirForFile(fn);
  if not DirectoryExists(dir) then
  begin
    dir := GetAppDefTempPath;
  end;
  if not DirectoryExists(dir) then
    ForceDirectories(dir);
{$ifdef WINDOWS}
  S := 'Explorer "' + dir + '"';
  ShellCmd(S);
{$else}
  S := dir;
  CtOpenDoc(S);
{$endif}
end;

procedure TfrmScriptIDE.actSwitchLayoutExecute(Sender: TObject);
begin
  SwitchResLayout;
  SaveIni;
end;

procedure TfrmScriptIDE.actUndoExecute(Sender: TObject);
begin
  ed.Undo;
end;

procedure TfrmScriptIDE.actBreakPointExecute(Sender: TObject);
var
  Line: longint;
begin
  if not FEnablePasDbg then
    Exit;
  CheckSpRunMode;
  Line := Ed.CaretY;
  if ce.HasBreakPoint(ce.MainFileName, Line) then
    ce.ClearBreakPoint(ce.MainFileName, Line)
  else
    ce.SetBreakPoint(ce.MainFileName, Line);
  ed.Refresh;
end;

procedure TfrmScriptIDE.ceLineInfo(Sender: TObject; const FileName: string;
  Position, Row,
  Col: cardinal);
begin
  if ce.Exec.DebugMode <> dmRun then
  begin
    FActiveLine := Row;
    if (FActiveLine < ed.TopLine + 2) or (FActiveLine > Ed.TopLine +
      Ed.LinesInWindow - 2) then
    begin
      Ed.TopLine := FActiveLine - (Ed.LinesInWindow div 2);
    end;
    ed.CaretY := FActiveLine;
    ed.CaretX := 1;

    ed.Refresh;
  end
  else
    Application.ProcessMessages;
end;

procedure TfrmScriptIDE.actStepOverExecute(Sender: TObject);
begin
  if not FEnablePasDbg then
    Exit;
  if ce.Exec.Status in isRunningOrPaused then
    ce.StepOver
  else if FDmlBaseScriptor is TDmlPasScriptor then
  begin
    if Compile then
    begin
      ce.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScriptIDE.actStepIntoExecute(Sender: TObject);
begin
  if not FEnablePasDbg then
    Exit;
  if ce.Exec.Status in isRunningOrPaused then
    ce.StepInto
  else if FDmlBaseScriptor is TDmlPasScriptor then
  begin
    if Compile then
    begin
      ce.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScriptIDE.actPauseExecute(Sender: TObject);
begin
  if not FEnablePasDbg then
    Exit;
  if ce.Exec.Status = isRunning then
  begin
    ce.Pause;
    ce.StepInto;
  end;
end;

procedure TfrmScriptIDE.pmCopyAsCClick(Sender: TObject);
begin
  CopyTextAs('C');
end;

procedure TfrmScriptIDE.pmCopyAsCppClick(Sender: TObject);
begin
  CopyTextAs('CPP');
end;

procedure TfrmScriptIDE.pmCopyAsCSharpClick(Sender: TObject);
begin
  CopyTextAs('CSHARP');
end;

procedure TfrmScriptIDE.pmCopyAsDelphiClick(Sender: TObject);
begin
  CopyTextAs('DELPHI');
end;

procedure TfrmScriptIDE.pmCopyAsJavaClick(Sender: TObject);
begin
  CopyTextAs('JAVA');
end;

procedure TfrmScriptIDE.pmCopyAsPLSqlClick(Sender: TObject);
begin
  CopyTextAs('PLSQL');
end;

procedure TfrmScriptIDE.PopupMenuEdPopup(Sender: TObject);
begin
  pmSpecCopy.Enabled := ed.SelText <> '';
end;

procedure TfrmScriptIDE.RecreateRecentMn;
var
  mn: TMenuItem;
  I: integer;
  fn: string;
begin
  MN_Recentfiles.Clear;
  for I := 0 to FRecentFiles.Count - 1 do
  begin
    fn := FRecentFiles[I];
    mn := TMenuItem.Create(Self);
    mn.Caption := ExtractFileName(fn);
    mn.Hint := fn;
    mn.Tag := I;
    mn.OnClick := _OnRecentFileClick;
    MN_Recentfiles.Add(mn);
  end;
end;

procedure TfrmScriptIDE.actResetExecute(Sender: TObject);
begin
  if not FEnablePasDbg then
    Exit;
  if ce.Exec.Status in isRunningOrPaused then
    ce.Stop;
  CheckRestoreTempPsp;
end;

procedure TfrmScriptIDE.CheckActionsEnable;
var
  bActive, bSel, bEmpty: boolean;
begin
  bActive := ed.Focused;
  bEmpty := ed.Lines.Count <= 1;
  if bEmpty then
    if ed.Lines.Count = 1 then
      bEmpty := ed.Lines[0] = '';
  if bActive then
  begin
    bSel := ed.SelAvail;
    actCut.Enabled := bSel;
    actCopy.Enabled := bSel;
    actPaste.Enabled := ed.CanPaste;
    actUndo.Enabled := ed.CanUndo;
    actRedo.Enabled := ed.CanRedo;
    //actFind.Enabled := not bEmpty;
    //actSearchAgain.Enabled := not bEmpty;
    //actReplace.Enabled := not bEmpty;
    //actSelectAll.Enabled := not bEmpty;
  end
  else
  begin
    actCut.Enabled := False;
    actCopy.Enabled := False;
    actPaste.Enabled := False;
    actUndo.Enabled := False;
    actRedo.Enabled := False;
    actFind.Enabled := False;
    actSearchAgain.Enabled := False;
    actReplace.Enabled := False;
    //actSelectAll.Enabled := False;
  end;


  if bEmpty then
  begin
    actStepOver.Enabled := False;
    actStepInto.Enabled := False;
    actRun.Enabled := False;
    actSyntaxcheck.Enabled := False;
    actDecompile.Enabled := False;
    actPause.Enabled := False;
    if FTempSpScript <> '' then
      actReset.Enabled := True
    else
      actReset.Enabled := False;
    actBreakPoint.Enabled := False;
  end
  else
  begin
    actStepOver.Enabled := FEnablePasDbg;//true;
    actStepInto.Enabled := FEnablePasDbg;//true;
    actBreakPoint.Enabled := FEnablePasDbg;//true;

    if not FEnablePasDbg then
    begin
      actRun.Enabled := True;
      actSyntaxcheck.Enabled := True;
      actDecompile.Enabled := False;
      actPause.Enabled := False;
      if FTempSpScript <> '' then
        actReset.Enabled := True
      else
        actReset.Enabled := False;
      Exit;
    end;

    case ce.Exec.DebugMode of
      dmStepOver, dmStepInto, dmPaused:
      begin
        actRun.Enabled := True;
        actSyntaxcheck.Enabled := False;
        actDecompile.Enabled := False;
        actPause.Enabled := False;
        actReset.Enabled := True;
        Exit;
      end;
    end;

    case (ce.Exec.Status) of
      isRunning:
      begin
        actRun.Enabled := False;
        actSyntaxcheck.Enabled := False;
        actDecompile.Enabled := False;
        actPause.Enabled := True;
        actReset.Enabled := True;
      end;
      isPaused:
      begin
        actRun.Enabled := True;
        actSyntaxcheck.Enabled := False;
        actDecompile.Enabled := False;
        actPause.Enabled := False;
        actReset.Enabled := True;
      end;
      else
        actRun.Enabled := True;
        actSyntaxcheck.Enabled := True;
        actDecompile.Enabled := True;
        actPause.Enabled := False;
        if FTempSpScript <> '' then
          actReset.Enabled := True
        else
          actReset.Enabled := False;
    end;
  end;
end;

procedure TfrmScriptIDE.CheckSpRunMode;
var
  S: string;
begin
  if (FTempSpScript = '') and Assigned(FDmlBaseScriptor) then
  begin
    S := ed.Lines.Text;
    if FDmlBaseScriptor.IsSpRule(S) or FDmlBaseScriptor.HasIncludes(S) then
    begin
      FTempSpScript := S;
      if FDmlBaseScriptor.IsSpRule(S) then
        S := FDmlBaseScriptor.PreConvertSP(S);
      if FDmlBaseScriptor.HasIncludes(S) then
        S := FDmlBaseScriptor.ProcessIncludes(S);
      ed.Lines.Text := S;
      ed.Color := clInfoBk;
      ed.ReadOnly := True;
    end;
  end;
end;

procedure TfrmScriptIDE.CheckRestoreTempPsp;
begin
  if FTempSpScript <> '' then
  begin
    ed.Lines.Text := FTempSpScript;
    FTempSpScript := '';
    ed.Color := clWindow;
    ed.ReadOnly := False;
  end;
end;

procedure TfrmScriptIDE.actClearBrkpointsExecute(Sender: TObject);
begin
  CheckSpRunMode;
  ce.ClearBreakPoints;
  ed.Refresh;
end;

function TfrmScriptIDE.Compile: boolean;

  procedure CheckPasNeedBeginEnd;
  var
    I, po, p2: integer;
    S, V: string;
  begin
    if not (FDmlBaseScriptor is TDmlPasScriptor) then
      Exit;
    S := ' ' + ed.Lines.Text + ' ';
    S := StringReplace(S, #13, ' ', [rfReplaceAll]);
    S := StringReplace(S, #10, ' ', [rfReplaceAll]);
    S := StringReplace(S, #9, ' ', [rfReplaceAll]);
    S := StringReplace(S, ';', ' ', [rfReplaceAll]);
    V := S;
    S := StringReplace(S, '.', ' ', [rfReplaceAll]);
    //找到最后一个end
    po := LastPos(' end ', S);
    if po > 0 then
    begin
      V := Copy(V, po + 4, Length(V));
      V := Trim(V);
      if V <> '' then
        if V[1] = '.' then
          Exit;
    end;
    case Application.MessageBox(PChar(srPasBeginEndNeededTip),
        PChar(Self.Caption), MB_YESNOCANCEL) of
      idYes:
      begin
        ed.Lines.Insert(0, 'begin');
        ed.Lines.Add('end.');
      end;
      idNo: ;
      else
        Abort;
    end;
  end;

var
  i: longint;
  S: string;
begin
  Result := False;
  FDmlBaseScriptor.StdOutPut := Self.Messages.Items;
  FDmlBaseScriptor.CurOut := Self.MemoRes.Lines;

  SaveCheck(False, True);

  TabSetRes.TabIndex := 0;
  CheckSpRunMode;

  Messages.Clear;
  CheckPasNeedBeginEnd;

  S := ed.Lines.Text;
  //if FDmlBaseScriptor.UTF8Needed then
  //  S := UTF8Encode(S);
  if FEnablePasDbg and (FDmlBaseScriptor is TDmlPasScriptor) then
  begin
    ce.Script.Text := S;
    Result := ce.Compile;
    for i := 0 to ce.CompilerMessageCount - 1 do
    begin
      Messages.Items.Add(ce.CompilerMessages[i].MessageToString);
    end;
    if ce.ExecErrorToString <> '' then
      Messages.Items.Add(ce.ExecErrorToString);
  end
  else if Assigned(FDmlBaseScriptor) then
  begin
    Result := FDmlBaseScriptor.Compile('DML_SCRIPT', S);
  end;
  if Result then
    Messages.Items.Add(STR_SUCCESSFULLY_COMPILED + ' ' + TimeToStr(Now));
end;

procedure TfrmScriptIDE.CopyTextAs(tp: string);
var
  txt: string;
begin
  ed.CopyToClipboard;
  txt := ClipBrd.Clipboard.AsText;
  txt := CopyTextAsLan(txt, tp);
  if txt <> '' then
    ClipBrd.Clipboard.AsText := txt;
end;

procedure TfrmScriptIDE.ceIdle(Sender: TObject);
begin
  CheckActionsEnable;
  Application.ProcessMessages;
  //Birb: don't use Application.HandleMessage here, else GUI will be unrensponsive if you have a tight loop and won't be able to use actRun/actReset menu action
  if FResume then
  begin
    FResume := False;
    ce.Resume;
    FActiveLine := 0;
    ed.Refresh;
  end;
end;

procedure TfrmScriptIDE.actRunExecute(Sender: TObject);
begin
  if FEnablePasDbg and (FDmlBaseScriptor is TDmlPasScriptor) then
  begin
    if CE.Running then
    begin
      FResume := True;
    end
    else
    begin
      if Compile then
        Execute;
    end;
  end
  else
  begin
    if Compile then
      Execute;
  end;
end;

procedure TfrmScriptIDE.ceExecute(Sender: TPSScript);
begin
  //Caption := STR_FORM_TITLE_RUNNING;
end;

procedure TfrmScriptIDE.ceAfterExecute(Sender: TPSScript);
begin
  //Caption := STR_FORM_TITLE;
end;

function TfrmScriptIDE.Execute: boolean;
var
  S: string;
begin
  Result := False;
  TabSetRes.TabIndex := 0;
  MemoRes.Lines.Clear;
  FCtscriptStdOutPut.Clear;
  Messages.Items.Add(STR_PS_EXECUTING);

  if FEnablePasDbg and (FDmlBaseScriptor is TDmlPasScriptor) then
  begin
    if CE.Execute then
    begin
      Messages.Items.Add(STR_SUCCESSFULLY_EXECUTED + ' ' + TimeToStr(Now));
      if MemoRes.Lines.Count > 0 then
        TabSetRes.TabIndex := 1
      else
        TabSetRes.TabIndex := 0;
      TabSetResChange(nil);
      Result := True;
    end
    else
    begin
      Messages.Items.Add(Format(STR_RUNTIME_ERROR,
        [extractFileName(ActiveFile), ce.ExecErrorRow, ce.ExecErrorCol,
        ce.ExecErrorProcNo, ce.ExecErrorByteCodePosition, ce.ExecErrorToString])); //Birb
      TabSetRes.TabIndex := 0;
      TabSetResChange(nil);
    end;
    if ce.Exec.Status in isRunningOrPaused then
      ce.Stop;
  end
  else if Assigned(FDmlBaseScriptor) then
  begin
    try
      S := ed.Lines.Text;
      //if FDmlBaseScriptor.UTF8Needed then
      //  S := UTF8Encode(S);

      FDmlBaseScriptor.Exec('DML_SCRIPT', S);
      Messages.Items.Add(STR_SUCCESSFULLY_EXECUTED);
      if MemoRes.Lines.Count > 0 then
        TabSetRes.TabIndex := 1
      else
        TabSetRes.TabIndex := 0;
      TabSetResChange(nil);
      Result := True;
    except
      on E: Exception do
      begin
        Messages.Items.Add('[Runtime error]' + E.Message + ' ' + TimeToStr(Now));
        TabSetRes.TabIndex := 0;
        TabSetResChange(nil);
      end;
    end;
  end;

  CheckRestoreTempPsp;
  FActiveLine := 0;
  ed.Refresh;
end;

procedure TfrmScriptIDE.ceCompile(Sender: TPSScript);
begin

end;

procedure TfrmScriptIDE.actNewExecute(Sender: TObject);
var
  S: string;
begin
  if SaveCheck(False, False) then //check if script changed and not yet saved
  begin
    if ce.Exec.Status in isRunningOrPaused then
      ce.Stop;
    CheckRestoreTempPsp;
    S := ed.Lines.Text;
    S := StringReplace(S, #13#10, #10, [rfReplaceAll]);
    S := Trim(S);
    if S <> Trim(STR_DEFAULT_PROGRAM_JS) then
    begin
      if (FDmlBaseScriptor <> nil) and (FDmlBaseScriptor.ScriptType = 'pas')
        and (S <> Trim(STR_DEFAULT_PROGRAM_PAS)) then
      begin
        ed.ClearAll;
        ed.Lines.Text := STR_DEFAULT_PROGRAM_PAS;
        ed.Modified := False;
        DmlScReInit('a.pas');
        ActiveFile := '';
      end
      else
      begin
        ed.ClearAll;
        ed.Lines.Text := STR_DEFAULT_PROGRAM_JS;
        ed.Modified := False;
        DmlScReInit('a.js');
        ActiveFile := '';
      end;
    end
    else
    begin
      ed.ClearAll;
      ed.Lines.Text := STR_DEFAULT_PROGRAM_PAS;
      ed.Modified := False;
      DmlScReInit('a.pas');
      ActiveFile := '';
    end;
  end;
end;

procedure TfrmScriptIDE.actOpenExecute(Sender: TObject);
begin
  if SaveCheck(False, False) then //check if script changed and not yet saved
  begin
    if OpenDialog1.Execute then
    begin
      ed.ClearAll;
      DmlScLoadFromFile(OpenDialog1.FileName);
      ed.Modified := False;
      ActiveFile := OpenDialog1.FileName;
    end;
  end;
end;

procedure TfrmScriptIDE.actSaveAsExecute(Sender: TObject);
begin
  ForceRestoreTempPsp;
  if (FDmlBaseScriptor = nil) or (FDmlBaseScriptor.ScriptType <> 'pas') then
  begin
    SaveDialog1.Filter := 'Java Script Files (*.js)|*.js';
    SaveDialog1.DefaultExt := 'js';
  end
  else
  begin
    SaveDialog1.Filter := 'Pascal Script Files (*.pas)|*.pas';
    SaveDialog1.DefaultExt := 'pas';
  end;
  if SaveDialog1.Execute then
  begin
    ActiveFile := SaveDialog1.FileName;
    DmlScSaveToFile(ActiveFile);
    FileModified := True;
    ed.Modified := False;
    SaveToTempFile;
  end;
end;

//check if script changed and not yet saved//

function TfrmScriptIDE.SaveCheck(bIsExiting, bIsBakForRun: boolean): boolean;
var
  S: string;
begin
  if ed.Modified then
  begin
    s := Trim(ed.Lines.Text);
    if (S = '') or (S = Trim(STR_DEFAULT_PROGRAM_JS)) or
      (S = Trim(STR_DEFAULT_PROGRAM_JS)) then
    begin
      Result := True;
      Exit;
    end;

    SaveToTempFile;
    if bIsBakForRun then
    begin
      Result := True;
      ed.Modified := True;
      Exit;
    end;
    if bIsExiting then
    begin
      if (Self.ActiveFile = '') then
      begin
        Result := True;
        Exit;
      end;
    end;
    if MessageDlg(STR_NEWWARN_NOTSAVED, mtWarning, mbOKCancel, 0) = idOk then
      Result := True
    else
    begin
      ed.Modified := True;
      Result := False;
    end;
  end
  else
    Result := True;
end;

procedure TfrmScriptIDE.actSaveExecute(Sender: TObject);
begin
  ForceRestoreTempPsp;
  if ActiveFile <> '' then
  begin
    DmlScSaveToFile(ActiveFile);
    ed.Modified := False;
    FileModified := True;
    SaveToTempFile;
  end
  else
    actSaveAs.Execute;
end;

procedure TfrmScriptIDE.SaveIni;
var
  ini: TIniFile;
  I: integer;
begin
  try
    ini := TIniFile.Create(GetConfFileOfApp);
    try
      ini.EraseSection('RecentScriptFiles');
      for I := 0 to FRecentFiles.Count - 1 do
        ini.WriteString('RecentScriptFiles', IntToStr(I + 1), FRecentFiles[I]);
      if PanelRes.Align <> alBottom then
        ini.WriteBool('Options', 'SwitchLayout', True);
    finally
      ini.Free;
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TfrmScriptIDE.SaveToTempFile;
var
  fn, ofn, S: string;
  ss: TStringList;
begin
  S := Trim(ed.Lines.Text);

  ForceRestoreTempPsp;

  fn := GetFileNameForcely;

  ofn := GetLastTmpFileName(fn);
  if ofn <> '' then
    if FileExists(ofn) then
    begin
      ss := TStringList.Create;
      try
        ss.LoadFromFile(ofn);
        if S = Trim(ss.Text) then
        begin
          Exit;
        end;
      finally
        ss.Free;
      end;
    end;

  fn := GetNewTmpFileName(fn);
  if fn = '' then
    raise Exception.Create('Can not save temp file');
  DmlScSaveToFile(fn);
  ed.Modified := False;
  FileModified := True;

  Self.SetLastFile(Self.ActiveFile, GetFileNameForcely);
end;

procedure TfrmScriptIDE.edStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  StatusBar.SimpleText := IntToStr(ed.CaretY) + ':' + IntToStr(ed.CaretX);
end;

procedure TfrmScriptIDE.actDecompileExecute(Sender: TObject);
var
  s: string;
begin
  TabSetRes.TabIndex := 0;
  TabSetResChange(nil);
  if Compile then
  begin
    if FEnablePasDbg and (FDmlBaseScriptor is TDmlPasScriptor) then
    begin
      S := '';
      ce.GetCompiled(s);
      IFPS3DataToText(s, s);
      MemoRes.Lines.Text := s;
      TabSetRes.TabIndex := 1;
    end;
  end;
end;

procedure TfrmScriptIDE.DmlScInit(const AFileName: string; ACtObj: TCtMetaObject;
  AResout: TStrings; ACtrlList: TObject);
var
  fn: string;
begin
  fn := AFileName;
  if fn = '' then
    fn := 'a.js';
  if Assigned(FDmlBaseScriptor) then
    FreeAndNil(FDmlBaseScriptor);
  FDmlBaseScriptor := CreateScriptForFile(fn);
  if FEnablePasDbg and (FDmlBaseScriptor is TDmlPasScriptor) then
  begin
    TDmlPasScriptor(FDmlBaseScriptor).InitAnotherPS(ce);
  end;
  if AResout = nil then
    AResout := FCtscriptStdOutPut;// Self.MemoRes.Lines;
  FDmlBaseScriptor.Init('DML_SCRIPT', ACtObj, AResout, ACtrlList);
  FDmlBaseScriptor.StdOutPut := FCtscriptStdOutPut;//Self.messages.Items;

  if FDmlBaseScriptor.ScriptType = 'js' then
    ed.Highlighter := jshighlighter
  else
    ed.Highlighter := pashighlighter;
end;

procedure TfrmScriptIDE.DmlScLoadFromFile(fn: string);
begin
  if not FileExists(fn) then
    raise Exception.Create('File not found: ' + fn);

  DmlScReInit(fn, False);

  ed.Lines.LoadFromFile(fn);
  //if FDmlBaseScriptor.UTF8Needed then
  //  ed.Lines.Text := UTF8Decode(ed.Lines.Text);
  FDmlBaseScriptor.ActiveFile := fn;
  if FDmlBaseScriptor.ScriptType = 'js' then
    ed.Highlighter := jshighlighter
  else
    ed.Highlighter := pashighlighter;
end;

procedure TfrmScriptIDE.DmlScReInit(const AFileName: string; bForce: boolean);
var
  sc: TDmlBaseScriptor;
  tp: string;
begin
  if not Assigned(FDmlBaseScriptor) then
    raise Exception.Create('Scriptor not assgined');

  tp := GetDmlScriptType(AFileName);
  if bForce or (tp <> FDmlBaseScriptor.ScriptType) then
  begin
    sc := FDmlBaseScriptor;
    FDmlBaseScriptor := CreateScriptForFile(AFileName);
    if FEnablePasDbg and (FDmlBaseScriptor is TDmlPasScriptor) then
    begin
      TDmlPasScriptor(FDmlBaseScriptor).InitAnotherPS(ce);
    end;
    FDmlBaseScriptor.Init('DML_SCRIPT', sc.CurCtObj, FCtscriptStdOutPut, sc.CtrlList);
    FDmlBaseScriptor.StdOutPut := FCtscriptStdOutPut;
    sc.Free;
  end;

  if FDmlBaseScriptor.ScriptType = 'js' then
    ed.Highlighter := jshighlighter
  else
    ed.Highlighter := pashighlighter;
end;

procedure TfrmScriptIDE.DmlScSaveToFile(fn: string);
{var
  ss: TStringList;}
begin
  //if (FDmlBaseScriptor = nil) or not FDmlBaseScriptor.UTF8Needed then
  begin
    ed.Lines.SaveToFile(fn);
    Exit;
  end;

  //ss := TStringList.Create;
  //try
  //  ss.Assign(ed.Lines);
  //  ss.Text := UTF8Encode(ss.Text);
  //  ss.SaveToFile(fn);
  //finally
  //  ss.Free;
  //end;
end;

procedure TfrmScriptIDE.SwitchResLayout;
begin
  if PanelRes.Align = alBottom then
  begin
    PanelRes.Align := alRight;
    PanelRes.Width := Self.ClientWidth * 2 div 5;
    SplitterRes.Align := alNone;
    SplitterRes.Width := 5;
    SplitterRes.Left := Self.ClientWidth - PanelRes.Width - 20;
    SplitterRes.Align := alRight;
  end
  else
  begin
    PanelRes.Align := alBottom;
    PanelRes.Height := Self.ClientHeight * 1 div 3;
    SplitterRes.Align := alNone;
    SplitterRes.Height := 5;
    SplitterRes.Top := Self.ClientHeight - PanelRes.Height - 20;
    SplitterRes.Align := alBottom;
  end;
end;

function TfrmScriptIDE.ceNeedFile(Sender: TObject; const OrginFileName: string;
  var FileName, Output: string): boolean;
begin
  if Assigned(FDmlBaseScriptor) then
    Result := FDmlBaseScriptor._OnNeedFile(Sender, OrginFileName, FileName, Output)
  else
    Result := False;
end;

procedure TfrmScriptIDE.ceBreakpoint(Sender: TObject; const FileName: string;
  Position, Row,
  Col: cardinal);
begin
  FActiveLine := Row;
  if (FActiveLine < ed.TopLine + 2) or (FActiveLine > Ed.TopLine +
    Ed.LinesInWindow - 2) then
  begin
    Ed.TopLine := FActiveLine - (Ed.LinesInWindow div 2);
  end;
  ed.CaretY := FActiveLine;
  ed.CaretX := 1;

  ed.Refresh;
end;

procedure TfrmScriptIDE.SetActiveFile(const Value: string);
var
  fn, ofn: string;
begin
  if FOrgFormCaption = '' then
    FOrgFormCaption := Self.Caption;
  ofn := FActiveFile;
  FActiveFile := Value;
  if Assigned(FDmlBaseScriptor) then
    FDmlBaseScriptor.ActiveFile := Value;
  ce.MainFileName := ExtractFileName(FActiveFile);
  if Ce.MainFileName = '' then
    Ce.MainFileName := STR_UNNAMED;
  if FActiveFile = '' then
  begin
    if (FDmlBaseScriptor = nil) or (FDmlBaseScriptor.ScriptType <> 'pas') then
      Self.Caption := FOrgFormCaption + ' - [JavaScript]'
    else
      Self.Caption := FOrgFormCaption + ' - [PascalScript]';
  end
  else
    Self.Caption := FOrgFormCaption + ' - ' + FActiveFile;

  if not IsTmpFile(FActiveFile) then
  begin
    fn := GetFileNameForcely;
    if ofn <> FActiveFile then
      SetLastFile(FActiveFile, fn);
  end;
end;

procedure TfrmScriptIDE.SetLastFile(const scFile, forceFile: string);
var
  ini: TIniFile;
  I: integer;
  S, fn: string;
begin
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    //ini.EraseSection('RecentScripts');
    ini.WriteString('RecentScripts', 'LastActiveFile', scFile);
    ini.WriteString('RecentScripts', 'LastActvieFileForcely', forceFile);
  finally
    ini.Free;
  end;

  fn := scFile;
  if fn = '' then
    Exit;
  if IsTmpFile(fn) then
    Exit;
  S := LowerCase(fn);
  for I := 0 to FRecentFiles.Count - 1 do
    if LowerCase(FRecentFiles[I]) = S then
    begin
      FRecentFiles.Delete(I);
      Break;
    end;
  FRecentFiles.Insert(0, fn);
  SaveIni;
  RecreateRecentMn;
end;

function GetErrorRowCol(const inStr: string): TPoint;
var
  Row: string;
  Col: string;
  p1, p2, p3: integer;
begin
  p1 := Pos('(', inStr);
  p2 := Pos(':', inStr);
  p3 := Pos(')', inStr);
  if (p1 > 0) and (p2 > p1) and (p3 > p2) then
  begin
    Row := Copy(inStr, p1 + 1, p2 - p1 - 1);
    Col := Copy(inStr, p2 + 1, p3 - p2 - 1);
    Result.X := StrToInt(Trim(Col));
    Result.Y := StrToInt(Trim(Row));
  end
  else
  begin
    Result.X := 1;
    Result.Y := 1;
  end;
end;

procedure TfrmScriptIDE.messagesDblClick(Sender: TObject);
begin
  //if Copy(messages.Items[messages.ItemIndex],1,7)= '[Error]' then
  //begin
  if Messages.ItemIndex >= 0 then
  begin
    ed.CaretXY := GetErrorRowCol(Messages.Items[Messages.ItemIndex]);
    ed.SetFocus;
  end;
  //end;
end;

procedure TfrmScriptIDE.ForceRestoreTempPsp;
begin
  if FTempSpScript <> '' then
  begin
    if ce.Exec.Status in isRunningOrPaused then
      ce.Stop;
    ed.Lines.Text := FTempSpScript;
    FTempSpScript := '';
    ed.Color := clWindow;
    ed.ReadOnly := False;
  end;
end;

procedure TfrmScriptIDE.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if ce.Exec.Status in isRunningOrPaused then
    raise Exception.Create('Please stop the running-script before close');
  FDmlBaseScriptor.StopAll;
  CheckRestoreTempPsp;
  if not SaveCheck(True, False) then //check if script changed and not yet saved
    CanClose := False;
end;

procedure TfrmScriptIDE.FormCreate(Sender: TObject);
begin
  Width := Application.MainForm.Width * 80 div 100;
  Height := Application.MainForm.Height * 80 div 100;

  FEnablePasDbg := True;
  FRecentFiles := TStringList.Create;

  ce := TPSScriptDebugger.Create(Self);
  with ce do
  begin
    CompilerOptions := [];
    OnCompile := ceCompile;
    OnExecute := ceExecute;
    OnAfterExecute := ceAfterExecute;
    MainFileName := 'Unnamed';
    UsePreProcessor := True;
    OnNeedFile := ceNeedFile;
    OnIdle := ceIdle;
    OnLineInfo := ceLineInfo;
    OnBreakpoint := ceBreakpoint;
  end;

  pashighlighter := TSynPasSyn.Create(Self);
  jshighlighter := TSynJavaSyn.Create(Self);
  //SynEditSearch := TSynEditSearch.Create(Self);
  //SynEditRegexSearch := TSynEditRegexSearch.Create(Self);

  with pashighlighter do
  begin
    CommentAttri.Style := [fsItalic];
    CommentAttri.Foreground := clGreen;

    KeyAttri.Style := [fsBold];
    KeyAttri.Foreground := clNavy;

    NumberAttri.Foreground := clBlue;
    //FloatAttri.Foreground := clBlue;
    //HexAttri.Foreground := clBlue;
    StringAttri.Foreground := clBlue;
    //CharAttri.Foreground := clBlue;
  end;

  with jshighlighter do
  begin
    CommentAttri.Style := [fsItalic];
    CommentAttri.Foreground := clGreen;

    KeyAttri.Style := [fsBold];
    KeyAttri.Foreground := clNavy;

    NumberAttri.Foreground := clBlue;
    StringAttri.Foreground := clBlue;
  end;

  ed := TSynEdit.Create(Self);
  with ed do
  begin
    Parent := Self;
    Align := alClient;
    Font.Height := -13;
    Font.Name := 'Courier New';
    PopupMenu := PopupMenu1;
    TabOrder := 0;
    Gutter.AutoSize := True;
    Gutter.LineNumberPart().Visible := True;
    Highlighter := pashighlighter;
    Lines.Text := '';
    TabWidth := 2;
    WantTabs := True;
    Options := [eoAutoIndent, eoDragDropEditing, eoDropFiles, eoGroupUndo,
      eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs,
      eoTabsToSpaces, eoTrimTrailingSpaces, eoTabIndent];
    OnDropFiles := edDropFiles;
    OnMouseMove := edMouseMove;
    OnSpecialLineColors := edSpecialLineColors;
    OnStatusChange := edStatusChange;
    OnGutterClick := SynEditGutterClick;
  end;

  PopupMenu1.OnPopup := PopupMenuEdPopup;

  HintWin := THintWindow.Create(self);
  HintWin.ParentWindow := ed.Handle;
  ed.ShowHint := False;

  CheckActionsEnable;

end;

procedure TfrmScriptIDE.FormDestroy(Sender: TObject);
begin
  try
    FRecentFiles.Free;
    if Assigned(FDmlBaseScriptor) then
      FreeAndNil(FDmlBaseScriptor);
  except
  end;
end;

procedure TfrmScriptIDE.FormShow(Sender: TObject);
begin
  TabSetRes.Height := ToolBar1.Height * 16 div 10;
  LoadIni;
end;

procedure TfrmScriptIDE.TimerInitTimer(Sender: TObject);
begin
  TimerInit.Enabled := False;
  LoadIni;
end;

function TfrmScriptIDE.GetFileNameForcely: string;
var
  fn: string;
begin
  if FActiveFile <> '' then
    fn := FActiveFile
  else
  begin
    fn := GetConfFileOfApp('');
    if (FDmlBaseScriptor = nil) or (FDmlBaseScriptor.ScriptType <> 'pas') then
    begin
      fn := fn + '_untitled.js';
    end
    else
    begin
      fn := fn + '_untitled.pas';
    end;
  end;
  Result := fn;
end;

function TfrmScriptIDE.GetLastFile(var forceFile: string): string;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    //ini.EraseSection('RecentScripts');
    Result := ini.ReadString('RecentScripts', 'LastActiveFile', '');
    forceFile := ini.ReadString('RecentScripts', 'LastActvieFileForcely', '');
  finally
    ini.Free;
  end;
end;

function TfrmScriptIDE.GetLastTmpFileName(fn: string): string;
var
  dir, tp: string;
begin
  Result := '';
  if IsTmpFile(fn) then
  begin
    Exit;
  end;

  dir := GetTmpDirForFile(fn);
  if not DirectoryExists(dir) then
    Exit;

  tp := GetDmlScriptType(fn);
  fn := ExtractFileName(fn);
  fn := ChangeFileExt(fn, '.' + tp + '~');
  fn := FolderAddFileName(dir, fn);
  fn := GetLastUsedFileName(fn);
  Result := fn;
end;

function TfrmScriptIDE.GetNewTmpFileName(fn: string): string;
var
  dir: string;
begin
  if IsTmpFile(fn) then
    Result := ''
  else
  begin
    dir := GetTmpDirForFile(fn);
    if not DirectoryExists(dir) then
      ForceDirectories(dir);
    fn := ExtractFileName(fn);
    fn := ChangeFileExt(fn, '.' + GetDmlScriptType(fn) + '~');
    fn := FolderAddFileName(dir, fn);
    fn := GetUnusedTmpFileName(fn);
    Result := fn;
  end;
end;

function TfrmScriptIDE.GetTmpDirForFile(fn: string): string;
var
  dir: string;
begin
  if fn = '' then
    Result := GetAppDefTempPath
  else if IsTmpFile(fn) then
    Result := ExtractFileDir(fn)
  else
  begin
    dir := ExtractFileDir(fn);
    dir := StringReplace(dir, ':\', DirectorySeparator, []);
    dir := StringReplace(dir, ':', DirectorySeparator, []);
    Result := FolderAddFileName(GetAppDefTempPath(), dir);
  end;
  Result := TrimFileName(Result);
end;

function TfrmScriptIDE.IsTmpFile(fn: string): boolean;
var
  ext: string;
begin
  Result := False;
  ext := ExtractFileExt(fn);
  ext := LowerCase(ext);
  if Pos('~', ext) > 0 then
    Result := True;
end;

procedure TfrmScriptIDE.LoadIni;
var
  ini: TIniFile;
  I: integer;
  S: string;
begin
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    I := 0;
    FRecentFiles.Clear;
    while True do
    begin
      Inc(I);
      S := ini.ReadString('RecentScriptFiles', IntToStr(I), '');
      if S = '' then
        Break;
      FRecentFiles.Add(S);
    end;
    if ini.ReadBool('Options', 'SwitchLayout', False) then
    begin
      if PanelRes.Align = alBottom then
        SwitchResLayout;
    end;
  finally
    Ini.Free;
  end;
end;

procedure TfrmScriptIDE.SynEditGutterClick(Sender: TObject; X, Y, Line: integer;
  Mark: TSynEditMark);
begin
  Ed.CaretY := Line;
  actBreakPoint.Execute;
end;

procedure TfrmScriptIDE.actSyntaxcheckExecute(Sender: TObject);
begin
  Compile;
  TabSetRes.TabIndex := 0;
  TabSetResChange(nil);
end;

procedure TfrmScriptIDE.TabSetResChange(Sender: TObject);
begin
  case TabSetRes.TabIndex of
    0:
    begin
      Messages.Visible := True;
      MemoRes.Visible := False;
    end;
    1:
    begin
      Messages.Visible := False;
      MemoRes.Visible := True;
    end;
  end;
end;

procedure TfrmScriptIDE.TimerHintTimer(Sender: TObject);
var
  i: integer;
  str: string;
  str1: string;
  str2: string;
  str3: string;
  var_str, res: string;
  rc: TPoint;
  //pt: TPoint;
begin
  if ce.Exec.Status >= isRunning then
  begin
    str2 := '';
    str3 := '';
    rc := Point(FMouseX, FMouseY);
    rc := ed.PixelsToLogicalPos(rc);
    str := Copy(ed.Lines[rc.Y - 1], 1, rc.X - 1);
    str1 := Copy(ed.Lines[rc.Y - 1], rc.X, length(ed.Lines[rc.Y - 1]));
    for i := length(str) downto 1 do
    begin
      if ((Ord(str[i]) >= Ord('A')) and (Ord(str[i]) <= Ord('Z')))
        or ((Ord(str[i]) >= Ord('a')) and (Ord(str[i]) <= Ord('z')))
        or (Ord(str[i]) = Ord('.'))
        or ((Ord(str[i]) >= Ord('0')) and (Ord(str[i]) <= Ord('9')))
        or (Ord(str[i]) = Ord('_')) then
        str2 := str[i] + str2
      else
        break;
    end;

    for i := 1 to length(str1) do
    begin
      if ((Ord(str1[i]) >= Ord('A')) and (Ord(str1[i]) <= Ord('Z')))
        or ((Ord(str1[i]) >= Ord('a')) and (Ord(str1[i]) <= Ord('z')))
        or (Ord(str1[i]) = Ord('.'))
        or ((Ord(str1[i]) >= Ord('0')) and (Ord(str1[i]) <= Ord('9')))
        or (Ord(str1[i]) = Ord('_')) then
        str3 := str3 + str1[i]
      else
        break;
    end;
    var_str := str2 + str3;
    //Self.Caption :=Format('%d,%d Line %d，%d : %s',[FMouseX, FMouseY,rc.x, rc.y, var_str]);
    //Exit;

    if var_str = '' then
      Exit;
    if var_str = FLastEvalVarName then
      Exit;
    FLastEvalVarName := var_str;
    try
      res := ce.GetVarContents(var_str);
    except
      res := 'Error';
    end;
    StatusBar.SimpleText := Format('%s: %s', [var_str, res]);
    {if res <> 'Unknown Identifier' then
    begin
      ed.Hint := var_str + '=( ' + res + ' )';
      StatusBar.SimpleText := ed.Hint;
      GetCursorPos(pt);
      HintWin.Color := clinfobk;
      HintWin.Caption := ed.Hint;
      HintWin.Top := pt.Y + 12;
      HintWin.Left := pt.X + 8;
      HintWin.Show;
    end; }
  end;
end;

procedure TfrmScriptIDE.TryLoadLastFile;
var
  fn, forceFn: string;
  ss: TStringList;
begin
  forceFn := '';
  fn := GetLastFile(forceFn);
  if forceFn <> '' then
  begin
    forceFn := Self.GetLastTmpFileName(forceFn);
  end;
  if forceFn <> '' then
  begin
    try
      DmlScLoadFromFile(forceFn);
      ActiveFile := fn;
      if (fn = '') or not FileExists(fn) then
        ed.Modified := True
      else
      begin
        ss := TStringList.Create;
        try
          ss.LoadFromFile(fn);
          if Trim(ed.Lines.Text) = Trim(ss.Text) then
            ed.Modified := False
          else
            ed.Modified := True;
        finally
          ss.Free;
        end;
      end;
    except
      Application.HandleException(Self);
    end;
  end
  else if FileExists(fn) then
  begin
    ed.ClearAll;
    DmlScLoadFromFile(fn);
    ed.Modified := False;
    ActiveFile := fn;
  end
  else
    actNew.Execute;
end;

procedure TfrmScriptIDE._OnRecentFileClick(Sender: TObject);
var
  fn: string;
begin
  if Sender is TMenuItem then
  begin
    fn := TMenuItem(Sender).Hint;
    if FActiveFile = fn then
      Exit;

    if SaveCheck(False, False) then //check if script changed and not yet saved
    begin
      ed.ClearAll;
      DmlScLoadFromFile(fn);
      ed.Modified := False;
      ActiveFile := fn;
    end;
  end;
end;

procedure TfrmScriptIDE.edDropFiles(Sender: TObject; X, Y: integer;
  AFiles: TStrings);
begin
  if AFiles.Count >= 1 then
    if SaveCheck(False, False) then //check if script changed and not yet saved
    begin
      ed.ClearAll;
      DmlScLoadFromFile(AFiles[0]);
      ed.Modified := False;
      ActiveFile := AFiles[0];
    end;
end;

procedure TfrmScriptIDE.edMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: integer);
begin
  if (FMouseX <> X) or (FMouseY <> Y) then
  begin
    HintWin.Hide;
    FMouseX := X;
    FMouseY := Y;
    TimerHint.Enabled := False;
    if Self.Visible then
      TimerHint.Enabled := True;
  end;
end;

end.
