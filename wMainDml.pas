unit wMainDml;

{$MODE Delphi}
{$WARN 5057 off : Local variable "$1" does not seem to be initialized}
{$WARN 4105 off : Implicit string type conversion with potential data loss from "$1" to "$2"}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, StdCtrls, ExtCtrls, WindowFuncs, {XPMan,}
  uFrameCtTableDef, CtMetaTable, CTMetaData, CtObjSerialer, CtObjXmlSerial, wDmlHelp,
  BESENCharset, //这玩意不先引用一下的话，在MAC下编译会说找不到
  uWaitWnd, ActnList, StdActns, Buttons, FileUtil, CtObjJsonSerial;

const
  WMZ_CUSTCMD = WM_USER + $1001;

type

  { TfrmMainDml }

  TfrmMainDml = class(TForm)
    actEditGlobalScript: TAction;
    actImportFile: TAction;
    actCharCodeTool: TAction;
    actGenerateLastCode: TAction;
    actHttpServer: TAction;
    actCheckUpdates: TAction;
    actFullScreen: TAction;
    actToggleTableView: TAction;
    actShowDescText: TAction;
    actSettings: TAction;
    ImageListSwitchOnOff: TImageList;
    lbNewVerInfo: TLabel;
    MainMenu1: TMainMenu;
    MN_ToggleTableView: TMenuItem;
    MN_FullScreen: TMenuItem;
    MN_CheckUpdates: TMenuItem;
    MN_HttpServer: TMenuItem;
    MnGenerateLastCode: TMenuItem;
    MN_Settings: TMenuItem;
    MN_FindHex: TMenuItem;
    MNImportFile: TMenuItem;
    MN_editGlobalScript: TMenuItem;
    PanelNewVerHint: TPanel;
    Shape1: TShape;
    StatusBar1: TStatusBar;
    MnOpenFile: TMenuItem;
    MnSaveFile: TMenuItem;
    MnExit: TMenuItem;
    MnQuickStart: TMenuItem;
    TimerInit: TTimer;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MnImportDatabase: TMenuItem;
    MnGenerateDatabase: TMenuItem;
    MnNewFile: TMenuItem;
    MNNewTable: TMenuItem;
    Mn_File: TMenuItem;
    N2: TMenuItem;
    MnExitWithoutSave: TMenuItem;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    MNSaveFileAs: TMenuItem;
    MN_Model: TMenuItem;
    Mn_Help: TMenuItem;
    Mn_About: TMenuItem;
    N1: TMenuItem;
    MnNewModel: TMenuItem;
    MnTogglePhyView: TMenuItem;
    MN_ColorStyles: TMenuItem;
    N3: TMenuItem;
    MN_ExportXls: TMenuItem;
    mn_EzdmlHomePage: TMenuItem;
    MN_SearchFields: TMenuItem;
    MN_Recentfiles: TMenuItem;
    actOpenLastFile1: TAction;
    MnOpenLastFile1A: TMenuItem;
    MN_EditMyDict: TMenuItem;
    MnTools1: TMenuItem;
    MnBackupDatabase: TMenuItem;
    MnRestoreDatabase: TMenuItem;
    MNSqlTool: TMenuItem;
    TimerAutoSave: TTimer;
    MNShowFileInExplorer: TMenuItem;
    N4: TMenuItem;
    MN_EditINIfile: TMenuItem;
    MN_ExecScript: TMenuItem;
    MNShowTemprFile: TMenuItem;
    MN_BrowseScripts: TMenuItem;
    MnGenerateCode: TMenuItem;
    N5: TMenuItem;
    MnOpenCustomToolFolder: TMenuItem;
    actGoTbFilter: TAction;
    actNewFile: TAction;
    actOpenFile: TAction;
    actSaveFile: TAction;
    actSaveFileAs: TAction;
    actShowFileInExplorer: TAction;
    actShowTmprFile: TAction;
    actExitWithoutSave: TAction;
    actExit: TAction;
    actNewTable: TAction;
    actNewModel: TAction;
    actImportDatabase: TAction;
    actGenerateDatabase: TAction;
    actGenerateCode: TAction;
    actTogglePhyView: TAction;
    actModelOptions: TAction;
    actExportModel: TAction;
    actExecScript: TAction;
    actFindObjects: TAction;
    actEditSettingFile: TAction;
    actEditMyDict: TAction;
    actBrowseScripts: TAction;
    actBackupDatabase: TAction;
    actRestoreDatabase: TAction;
    actSqlTool: TAction;
    actBrowseCustomTools: TAction;
    actQuickStart: TAction;
    actEzdmlHomePage: TAction;
    actAboutEzdml: TAction;
    OpenDialogImp: TOpenDialog;
    procedure actCharCodeToolExecute(Sender: TObject);
    procedure actCheckUpdatesExecute(Sender: TObject);
    procedure actEditGlobalScriptExecute(Sender: TObject);
    procedure actFullScreenExecute(Sender: TObject);
    procedure actGenerateLastCodeExecute(Sender: TObject);
    procedure actHttpServerExecute(Sender: TObject);
    procedure actImportFileExecute(Sender: TObject);
    procedure actOpenLastFile1Execute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actShowDescTextExecute(Sender: TObject);
    procedure actToggleTableViewExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure lbNewVerInfoClick(Sender: TObject);
    procedure TimerInitTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerAutoSaveTimer(Sender: TObject);
    procedure actGoTbFilterExecute(Sender: TObject);
    procedure actNewFileExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actSaveFileExecute(Sender: TObject);
    procedure actSaveFileAsExecute(Sender: TObject);
    procedure actShowFileInExplorerExecute(Sender: TObject);
    procedure actShowTmprFileExecute(Sender: TObject);
    procedure actExitWithoutSaveExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actNewTableExecute(Sender: TObject);
    procedure actNewModelExecute(Sender: TObject);
    procedure actImportDatabaseExecute(Sender: TObject);
    procedure actGenerateDatabaseExecute(Sender: TObject);
    procedure actGenerateCodeExecute(Sender: TObject);
    procedure actTogglePhyViewExecute(Sender: TObject);
    procedure actModelOptionsExecute(Sender: TObject);
    procedure actExportModelExecute(Sender: TObject);
    procedure actExecScriptExecute(Sender: TObject);
    procedure actFindObjectsExecute(Sender: TObject);
    procedure actEditSettingFileExecute(Sender: TObject);
    procedure actEditMyDictExecute(Sender: TObject);
    procedure actBrowseScriptsExecute(Sender: TObject);
    procedure actBackupDatabaseExecute(Sender: TObject);
    procedure actRestoreDatabaseExecute(Sender: TObject);
    procedure actSqlToolExecute(Sender: TObject);
    procedure actBrowseCustomToolsExecute(Sender: TObject);
    procedure actQuickStartExecute(Sender: TObject);
    procedure actEzdmlHomePageExecute(Sender: TObject);
    procedure actAboutEzdmlExecute(Sender: TObject);
  private
    { Private declarations }
    FFrameCtTableDef: TFrameCtTableDef;
    FCtDataModelList: TCtDataModelGraphList;
    FCurFileName: string;
    FCurFileSize: integer;
    FMainSplitterPos: integer;
    FCurFileDate: TDateTime;

    FfrmMetaImport: TForm;
    FfrmHttpServer: TForm;
    FFindHexDlg: TForm;

    FProgressAll: integer;
    FProgressCur: integer;

    FWaitWnd: TfrmWaitWnd;
    FOrginalCaption: string;

    FGlobeOpeningFile: string;
    FRecentFiles: TStringList;
    FReservedToolsMenuCount: integer;
    FCustomTools: TStringList;

    FAutoSaveMinutes: integer;
    FAutoSaveCounter: integer;
    FIsAutoSaving: boolean;
    FSaveTempFileOnExit: boolean;

    FGlobalScriptor: TObject;

    FFileLockMutex: TCtMutex;
    FFileWorking: boolean;
    FStartMaximized: Boolean;

    FFullScrnSaveBound: TRect;

    procedure _OnDMLObjProgress(Sender: TObject; const Prompt: string;
      Cur, All: integer; var bContinue: boolean);
    procedure _OnRecentFileClick(Sender: TObject);
    procedure _OnAppActivate(Sender: TObject);

    procedure PromptOpenFile(fn: string; bDisableTmpFiles: boolean = False);
    procedure LoadFromFile(fn: string);
    procedure RememberFileDateSize;
    procedure ImportFromFile(fn: string); //导入文件
    procedure SaveToFile(fn: string);
    procedure PromptSaveFile;
    procedure CheckCaption;

    procedure LoadIni;
    procedure SaveIni;
    procedure SetRecentFile(fn: string);
    procedure RemoveRecentFile(fn: string);
    procedure RecreateRecentMn;
    procedure TryLockFile(fn: string; bAsk: boolean = True);

    procedure ReCreateCustomToolsMenu;
    procedure _OnCustomToolsClick(Sender: TObject);

    function CheckCurFileDateSizeChanged: boolean;
    function IsTmpFile(fn: string): boolean;
    function GetStatusPanelFileName(fn: string): string;
    function GetTmpDirForFile(fn: string): string;
    function GetFastTmpFileName(fn: string): string; //快速加载用的临时文件名
    function GetLastTmpFileName(fn: string): string; //最后一次的临时文件名
    function GetNewTmpFileName(fn: string): string;
    function SaveDMLToTmpFile: string;
    procedure SaveDMLFastTmpFile;
    function TryLoadFromTmpFile(sfn: string): boolean;

    procedure CheckReloadGlobalScript;

    procedure CheckForUpdates(bForceNow: boolean);
    procedure CheckShowNewVersionInfo(bForceNow: boolean);
  protected
    procedure CreateWnd; override;
    procedure _WMZ_CUSTCMD(var msg: TMessage); message WMZ_CUSTCMD;
  public
    { Public declarations }
    function IsShortcut(var Message: TLMKey): boolean; override;
    procedure SetStatusBarMsg(msg: string; tp: integer = -1);
    procedure ExecDmlScript(fn: string);
  end;

procedure CheckAppStart;
function EzdmlExecAppCmd(Cmd, param1, param2: string): string;
function EzdmlCreateCtObjSerialer(fn: string; bWriteMode: boolean): TCtObjSerialer;

function IsSameFileContent(// 比较两个文件是否相等
  mFileName1, mFileName2: string // 两个文件
  ): boolean;

var
  frmMainDml: TfrmMainDml;

const
  DEF_GSCRIPT_FN = 'GlobalScript.ps_';
  DEF_GSCRIPT_PS = '//EZDML Global Event Scripts (Only support Pascal-Script) Ver20191006'
    + #13#10 +
    '//EZDML全局事件脚本（注：只支持Pascal脚本）' + #13#10 +
    '' + #13#10 +
    '//Generate SQL for a single Table. defRes is the default result.' + #13#10 +
    '//生成单个表的SQL，传入表对象、是否生成创建表SQL、是否生成创建约束SQL、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL' + #13#10 +
    'function OnEzdmlGenTbSqlEvent(tb: TCtMetaTable; bCreateTb, bCreateConstrains: Boolean; defRes, dbType, options: String): string;'
    + #13#10 +
    'begin' + #13#10 +
    '  Result := defRes;' + #13#10 +
    'end;' + #13#10 +
    '' + #13#10 +
    '//Generate upgrade SQL for an exists Table in a database. defRes is the default result.'
    + #13#10 +
    '//生成数据库的更新SQL，传入新旧表对象、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL'
    + #13#10 +
    'function OnEzdmlGenDbSqlEvent(designTb, dbTable: TCtMetaTable; defRes, dbType, options: String): string;'
    + #13#10 +
    'begin' + #13#10 +
    '  Result := defRes;' + #13#10 +
    'end;' + #13#10 +
    '' + #13#10 +
    '//Generate SQL for a single Field. defRes is the default result.' + #13#10 +
    '//生成单个字段的类型（varchar(255) nullable），传入表对象、字段对象、默认生成的结果、数据库类型、选项，返回自定义结果' + #13#10 +
    'function OnEzdmlGenFieldTypeDescEvent(tb: TCtMetaTable; fd: TCtMetaField; defRes, dbType, options: String): string;'
    + #13#10 +
    'begin' + #13#10 +
    '  Result := defRes;' + #13#10 +
    'end;' + #13#10 +
    '' + #13#10 +
    '//Generate upgrade SQL for an exists database-Field of a Table. defRes is the default result.'
    + #13#10 +
    '//生成增删改单个字段的SQL（alter table add xxx），传入要执行的操作(alter/add/drop)、表对象、新旧字段对象、默认生成的结果、数据库类型、选项，返回自定义结果' + #13#10 +
    'function OnEzdmlGenAlterFieldEvent(action: String; tb: TCtMetaTable; designField, dbField: TCtMetaField; defRes, dbType, options: String): string;' + #13#10 +
    'begin' + #13#10 +
    '  Result := defRes;' + #13#10 +
    'end;' + #13#10 +
    '' + #13#10 +
    '//Reserved custom events' + #13#10 +
    '//自定义命令事件' + #13#10 +
    'function OnEzdmlCmdEvent(cmd, param1, param2: String; parobj1, parobj2: TObject): string;'
    + #13#10 +
    'begin' + #13#10 +
    '  //WriteLog(''OnEzdmlCmdEvent(''+cmd+'', ''+param1+'', ''+param2+'', obj1, obj2)'');'
    + #13#10 +
    '  Result := '''';' + #13#10 +
    'end;' + #13#10 +
    '' + #13#10 +
    'begin' + #13#10 +
    'end.';

implementation

uses
  uFormImpTable, uFormGenSql, uFormCtDML, CtMetaOracleDb, CtMetaPdmImporter,
  CtMetaOdbcDb,
  ocidyn, mysql57dyn, mssqlconn, dblib, sqlite3dyn, CtMetaCustomDb,
  postgres3dyn, NetUtil,
  ezdmlstrs, dmlstrs, DMLObjs, IniFiles, AutoNameCapitalize, uDMLSqlEditor,
  wAbout, wSettings, uFormCtTableProp,
  uFormGenCode, uJSON, DmlScriptPublic, DmlGlobalPasScript, CtMetaSqliteDb, FindHexDlg,
  ide_editor, uPSComponent, DmlPasScript, LCLTranslator,
 {$IFDEF DARWIN}  MacOSAll,{$ENDIF}
  CtMetaSqlsvrDb, CtMetaMysqlDb, CtMetaPostgreSqlDb, LCLProc, CtMetaHttpDb, uFormHttpSvr,
  CtTestDataGen, DmlScriptControl;

{$R *.lfm}

  {$IFDEF DARWIN}
function GetOSLanguageEz: string;
  {独立于平台的方法来读取用户界面语言}
var
  l, fbl: string;
  theLocaleRef: CFLocaleRef;
  locale: CFStringRef;
  buffer: StringPtr;
  bufferSize: CFIndex;
  encoding: CFStringEncoding;
  success: boolean;
begin
  theLocaleRef := CFLocaleCopyCurrent;
  locale := CFLocaleGetIdentifier(theLocaleRef);
  encoding := 0;
  bufferSize := 256;
  buffer := new(StringPtr);
  success := CFStringGetPascalString(locale, buffer, bufferSize, encoding);
  if success then
    l := string(buffer^)
  else
    l := '';
  fbl := Copy(l, 1, 2);
  dispose(buffer);
  Result := fbl;
end;

{$ENDIF}


procedure CheckAppStart;
var
  ini: TIniFile;
  fn, dir, S: string;
begin
  try
    if G_CtAppFormHandler = nil then
    begin
      G_CtAppFormHandler := TCtAppFormHandler.Create;
      Screen.AddHandlerFormAdded(G_CtAppFormHandler.ScreenFormAddEvent);
      Screen.AddHandlerFormVisibleChanged(G_CtAppFormHandler.ScreenFormVisibleChgEvent);
    end;
    S := '';
    fn := GetConfFileOfApp;
    if FileExists(fn) then
    begin
      ini := TIniFile.Create(fn);
      try
        S := ini.ReadString('Options', 'LANG', '');
        G_AppDefFontName := ini.ReadString('Options', 'AppDefFontName', '');
        G_AppDefFontSize := ini.ReadInteger('Options', 'AppDefFontSize', 0);
        G_AppFixWidthFontName := ini.ReadString('Options', 'AppFixWidthFontName', '');
        G_AppFixWidthFontSize := ini.ReadInteger('Options', 'AppFixWidthFontSize', 0);
        G_DmlGraphFontName := ini.ReadString('Options', 'DmlGraphFontName', '');      
        G_UseOdbcDriverForMsSql := ini.ReadBool('Options', 'UseOdbcDriverForMsSql',
          G_UseOdbcDriverForMsSql);
      finally
        ini.Free;
      end;
    end;
  {$IFDEF DARWIN}
    if S = '' then
      S := GetOSLanguageEz;
    dir := GetFolderPathOfAppExe('languages');
  {$ENDIF}
    SetDefaultLang(S, dir, False);
    S := GetDefaultLang;
    SetEzdmlLang(S);
    InitCtChnNames;
  except
  end;
end;

function EzdmlExecAppCmd(Cmd, param1, param2: string): string;

  function SaveDmlGraphFile(dmlName, fn: string): string;
  var
    dml: TCtDataModelGraph;
  begin
    if dmlName = '(CUR_DATA_MODEL)' then
    begin
      Result := frmMainDml.FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.SaveDmlImage(fn);
      Exit;
    end;

    with TfrmCtDML.Create(Application) do
      try
        dml := TCtDataModelGraph(FGlobeDataModelList.ItemByName(dmlName));
        if dml = nil then
          dml := FGlobeDataModelList.CurDataModel;
        Init(dml, True, True);
        FFrameCtDML.DMLGraph.ViewScale := 1;
        Result := FFrameCtDML.SaveDmlImage(fn);
      finally
        Free;
      end;
  end;

  function SaveTableGraphFile(tbName, fn: string): string;
  var
    tb, tb2: TCtMetaTable;
    dml: TCtDataModelGraph;
  begin
    tb := frmMainDml.FFrameCtTableDef.GetCurTable;
    if tbName <> '(CUR_TABLE)' then
      tb := FGlobeDataModelList.GetTableOfName(tbName);
    if tb = nil then
      Exit;

    dml := TCtDataModelGraph.Create;
    with TfrmCtDML.Create(Application) do
      try            
        tb2 := dml.Tables.NewTableItem();
        tb2.AssignFrom(tb);
        Init(dml, True, True);
        FFrameCtDML.DMLGraph.ViewScale := 1;
        Result := FFrameCtDML.SaveDmlImage(fn);
      finally
        Free;
        dml.Free;
      end;
  end;

begin
  Result := '';
  if cmd = 'GET_DML_GRAPH_BASE64TEXT' then
  begin
    Result := SaveDmlGraphFile(param1, '(BASE64TEXT)' + param2);
  end;
  if cmd = 'SAVE_DML_GRAPH_FILE' then
  begin
    Result := SaveDmlGraphFile(param1, param2);
  end;          
  if cmd = 'GET_TABLE_GRAPH_BASE64TEXT' then
  begin
    Result := SaveTableGraphFile(param1, '(BASE64TEXT)' + param2);
  end;           
  if cmd = 'SAVE_TABLE_GRAPH_FILE' then
  begin
    Result := SaveTableGraphFile(param1, param2);
  end;
  if cmd = 'GET_PARAM_STR' then
  begin
    Result := ParamStr(StrToIntDef(param1, 0));
  end;
  if cmd = 'SET_JSON_UHEX_MODE' then
  begin
    if StrToIntDef(param1, 0) = 0 then
      stringsAsUtf8Encode := True
    else
      stringsAsUtf8Encode := False;
    if stringsAsUtf8Encode then
      Result := '0'
    else
      Result := '1';
  end;
end;

function EzdmlCreateCtObjSerialer(fn: string; bWriteMode: boolean): TCtObjSerialer;
var
  ext: string;
begin
  ext := LowerCase(ExtractFileExt(fn));
  if bWriteMode then
  begin
    if (ext = '.dmx') or (ext = '.xml') then
      Result := TCtObjXmlSerialer.Create(fn, fmCreate)
    else if (ext = '.dmj') or (ext = '.json') then
      Result := TCtObjJsonSerialer.Create(fn, fmCreate)
    else
      Result := TCtObjFileStream.Create(fn, fmCreate);
  end
  else
  begin
    if (ext = '.dmx') or (ext = '.xml') then
      Result := TCtObjXmlSerialer.Create(fn, fmOpenRead or fmShareDenyNone)
    else if (ext = '.dmj') or (ext = '.json') then
      Result := TCtObjJsonSerialer.Create(fn, fmOpenRead or fmShareDenyNone)
    else
      Result := TCtObjFileStream.Create(fn, fmOpenRead or fmShareDenyNone);
  end;
  if not bWriteMode then
    Result.CurCtVer := 0;
end;

function Ezdml_JsonPropProc(AJsonStr, AName, AValue: string; bRead: boolean): string;
var
  js: TJSONObject;
begin
  Result := '';
  if Trim(AJsonStr) <> '' then
    js := TJSONObject.Create(AJsonStr)
  else
    js := TJSONObject.Create;
  try
    if bRead then
      Result := js.optString(AName)
    else
    begin
      js.put(AName, AValue);
      Result := js.toString;
    end;
  finally
    js.Free;
  end;
end;

function GetFileAges(fn: string; var vFileDate: TDateTime): boolean;
var
  age: longint;
begin
  Result := False;
  age := FileAge(fn);
  if age = -1 then
    Exit;
  vFileDate := FileDateToDateTime(age);
  Result := True;
  {
var
  Handle: THandle;
  FindData: TWin32FindData;
  LocalFileTime: TFileTime;
  Res: Integer;
begin
  Result := False;
  vFileDate := Now;
  vCreateDate := vFileDate;
  Handle := FindFirstFile(PChar(Fn), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Result := True;
    Windows.FindClose(Handle);

    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Res).Hi,
      LongRec(Res).Lo);
    vFileDate := FileDateToDateTime(res);
    FileTimeToLocalFileTime(FindData.ftCreationTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(res).Hi,
      LongRec(res).Lo);
    vCreateDate := FileDateToDateTime(res);
  end;    }
end;

function SetFileAges(fn: string; vFileDate: TDateTime): boolean;
var
  age: longint;
begin
  age := DateTimeToFileDate(vFileDate);
  Result := (FileSetDate(fn, age) = 0);
  {var
  Handle, f: THandle;
  FindData: TWin32FindData;
  LocalFileTime, FileTime: TFileTime;
  Age: Integer;
begin
  Result := False;
  Handle := FindFirstFile(PChar(Fn), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);

    f := CreateFile(PChar(fn), GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_DELETE,
      nil, OPEN_EXISTING,
      FILE_FLAG_BACKUP_SEMANTICS, 0);

    //f := FileOpen(fn, fmOpenWrite);
    if f = THandle(-1) then
      RaiseLastOSError;

    if vFileDate > 1 then
    begin
      Age := DateTimeToFileDate(vFileDate);
      if DosDateTimeToFileTime(LongRec(Age).Hi, LongRec(Age).Lo, LocalFileTime) and
        LocalFileTimeToFileTime(LocalFileTime, FileTime) then
        SetFileTime(f, nil, nil, @FileTime);
    end;

    if vCreateDate > 1 then
    begin
      Age := DateTimeToFileDate(vCreateDate);
      if DosDateTimeToFileTime(LongRec(Age).Hi, LongRec(Age).Lo, LocalFileTime) and
        LocalFileTimeToFileTime(LocalFileTime, FileTime) then
        SetFileTime(f, @FileTime, nil, nil);
    end;

    FileClose(f);

  end; }
  Result := False;
end;

function ezdml_GetSelectedCtMetaObj: TCtMetaObject;
begin
  Result := frmMainDml.FFrameCtTableDef.GetCurObject;
end;

procedure TfrmMainDml.CreateWnd;
begin
  inherited;

end;

procedure TfrmMainDml.ExecDmlScript(fn: string);
var
  FileTxt, AOutput: TStrings;
  S: string;
  bUtf8: boolean;
  cTb: TCtMetaTable;
begin
  cTb := FFrameCtTableDef.GetCurTable;

  FileTxt := TStringList.Create;
  AOutput := TStringList.Create;
  with CreateScriptForFile(fn) do
    try
      ActiveFile := fn;
      FileTxt.LoadFromFile(fn);
      S := FileTxt.Text;
      bUtf8 := False;
      if Length(S) > 3 then
        if (Ord(S[1]) = $EF) and (Ord(S[2]) = $BB) and (Ord(S[3]) = $BF) then
        begin
          S := Copy(S, 4, Length(S));
          bUtf8 := True;
        end;
      if not bUtf8 then
        if Pos('UTF-8', UpperCase(S)) >= 0 then
          bUtf8 := True;
      if bUtf8 then
      begin
        S := Utf8Decode(S);
      end;

      Init('DML_SCRIPT', cTb, AOutput, nil);
      Exec('DML_SCRIPT', FileTxt.Text);
    finally
      FileTxt.Free;
      AOutput.Free;
      Free;
    end;
end;

procedure TfrmMainDml.FormCloseQuery(Sender: TObject; var CanClose: boolean);

  procedure ReleaseModelList;
  begin
    Self.Caption := srEzdmlAppTitle + ' - ' + srEzdmlExiting;
    Self.SetStatusBarMsg(srEzdmlExiting);
    try
      if FCtDataModelList.IsHuge then
        Screen.Cursor := crAppStart;
      try
        FCtDataModelList.Clear;
        FCtDataModelList.SeqCounter := 0;
        FCtDataModelList.GlobeList.SeqCounter := 0;
        if FCtDataModelList.CurDataModel = nil then
          Exit;
        //FFrameCtTableDef.Init(FCtDataModelList, False);
        FCurFileName := '';
        FAutoSaveCounter := 0;
        FCurDmlFileName := '';
        TryLockFile('');
      except
      end;
      Screen.Cursor := crDefault;
    finally
      FCurFileName := '';
      FAutoSaveCounter := 0;
      FCurDmlFileName := '';
    end;
  end;

var
  bCke, bHuge: boolean;
begin
  bCke := True;
  if GetMetaEditingWin <> nil then
  begin
    if GetMetaEditingWin = FfrmCtTableProp then
      if not FfrmCtTableProp.CheckModified then
      begin
        FfrmCtTableProp.Close;
        bCke := False;
      end;
  end;
  if bCke then
    CheckCanEditMeta;
  bHuge := FCtDataModelList.IsHuge;
  if (FCtDataModelList.TableCount > 0) then
  begin
    if (IsTmpFile(FCurFileName) or (FCurFileName = '')) then
    begin
      case Application.MessageBox(PChar(srEzdmlConfirmExit), PChar(Application.Title),
          MB_YESNOCANCEL or MB_ICONWARNING) of
        idYes:
        begin
          actSaveFileAs.Execute;
          if (IsTmpFile(FCurFileName) or (FCurFileName = '')) then
          begin
            CanClose := False;
            Exit;
          end;
        end;
        idNo:
        begin
          ReleaseModelList;
        end
        else
          CanClose := False;
          Exit;
      end;
    end
    else if bHuge or not FSaveTempFileOnExit then
    begin
      PromptSaveFile;
    end;
  end;
  FFrameCtTableDef.Init(nil, False);
  Self.Caption := srEzdmlAppTitle + ' - ' + srEzdmlExiting;
  Self.SetStatusBarMsg(srEzdmlExiting);
  if FFrameCtTableDef.FFrameCtTableList.TreeViewCttbs.Items.GetFirstNode <> nil then
    FFrameCtTableDef.FFrameCtTableList.TreeViewCttbs.Items.GetFirstNode.Text :=
      srEzdmlExiting;
  Self.Refresh;
  try
    SaveIni;
    if not bHuge then
      SaveDmlFastTmpFile;
  except
  end;
  if CanClose then
  begin
    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('MAINFORM', 'CLOSE', '', Self, nil);
    end;
  end;

  if CanClose then
  begin
    if FMainSplitterPos <> Self.FFrameCtTableDef.PanelCttbTree.Width then
      SaveIni;
    if Assigned(scriptIdeEditor) then
      FreeAndNil(scriptIdeEditor);
    ReleaseModelList;
  end;

  try
    CheckCaption;
    CheckForUpdates(False);
  except
  end;
end;

procedure TfrmMainDml.FormDropFiles(Sender: TObject;
  const FileNames: array of string);
var
  L: integer;
  S: string;
begin
  L := Length(FileNames);
  if L = 0 then
    Exit;
  S := Trim(FileNames[0]);
  FGlobeOpeningFile := S;
  PostMessage(Handle, WMZ_CUSTCMD, 1, 0);
end;

procedure TfrmMainDml.lbNewVerInfoClick(Sender: TObject);
var
  sNewVer, sUrl, V: string;
  ini: TIniFile;
begin
  PanelNewVerHint.Hide;
  if lbNewVerInfo.Tag <> 1 then
    Exit;
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    sNewVer := ini.ReadString('Updates', 'NewVerNum', '');
    if sNewVer = '' then
      Exit;
    ini.WriteString('Updates', 'LastPromptVer', sNewVer);
    sUrl := ini.ReadString('Updates', 'NewVerUrl', '');
    if sUrl = '' then
      Exit;
    V := Format(srEzdmlConfirmOpenUrlFmt, [sUrl]);

    if Application.MessageBox(PChar(V),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
      Exit;

    CtOpenDoc(PChar(sUrl));
  finally
    ini.Free;
  end;
end;

procedure TfrmMainDml.FormCreate(Sender: TObject);
var
  db: TCtMetaDatabase;
  dpi: Integer;
begin
  Randomize;
  G_DmlImageListSwitchOnOff := Self.ImageListSwitchOnOff;
  //if LoadNewResourceModule($0409) <> 0 then
  //ReinitializeForms();
  dpi := Screen.PixelsPerInch;
  if dpi = 0 then //由于启动后会自动放大，因此一开始要缩小主窗口
    dpi := 96;
  Width := Screen.Width * 90 div 100 * 96 div dpi;
  Height := Screen.Height * 80 div 100 * 96 div dpi;

  Caption := srEzdmlAppTitle;
  FOrginalCaption := Caption;
  FMainSplitterPos := 150;

  AllowDropFiles := True;

  FRecentFiles := TStringList.Create;
  FCustomTools := TStringList.Create;
  FAutoSaveMinutes := 5;
  FSaveTempFileOnExit := True;

  FCtDataModelList := TCtDataModelGraphList.Create;
  FGlobeDataModelList := FCtDataModelList;
  FCtDataModelList.OnObjProgress := _OnDMLObjProgress;

  FFrameCtTableDef := TFrameCtTableDef.Create(Self);
  FFrameCtTableDef.Name := 'FrameCtTableDef';
  FFrameCtTableDef.Parent := Self;
  FFrameCtTableDef.Align := alClient;
  FFrameCtTableDef.Init(FCtDataModelList, False);
  FFrameCtTableDef.RefreshProp;

  with FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML do
  begin
    actFileNew.Caption := Self.actNewFile.Caption;
    actFileNew.OnExecute := Self.actNewFile.OnExecute;
    actFileOpen.Caption := Self.actOpenFile.Caption;
    actFileOpen.OnExecute := Self.actOpenFile.OnExecute;
    actFileSave.Caption := Self.actSaveFile.Caption;
    actFileSave.OnExecute := Self.actSaveFile.OnExecute;
    actFullScreen.OnExecute := Self.actFullScreen.OnExecute;
    actFullScreen.Visible := True;
    Porc_OnStatusMsg := Self.SetStatusBarMsg;
  end;


  if GetCtMetaDBReg('ORACLE')^.DbImpl = nil then
  begin
    db := TCtMetaOracleDb.Create;
    GetCtMetaDBReg('ORACLE')^.DbImpl := db;
  end;
  if GetCtMetaDBReg('SQLSERVER')^.DbImpl = nil then
  begin
    db := TCtMetaSqlsvrDb.Create;
    GetCtMetaDBReg('SQLSERVER')^.DbImpl := db;
  end;
  if GetCtMetaDBReg('MYSQL')^.DbImpl = nil then
  begin
    db := TCtMetaMysqlDb.Create;
    GetCtMetaDBReg('MYSQL')^.DbImpl := db;
  end;
  if GetCtMetaDBReg('POSTGRESQL')^.DbImpl = nil then
  begin
    db := TCtMetaPostgreSqlDb.Create;
    GetCtMetaDBReg('POSTGRESQL')^.DbImpl := db;
  end;
  if GetCtMetaDBReg('SQLITE')^.DbImpl = nil then
  begin
    db := TCtMetaSqliteDb.Create;
    GetCtMetaDBReg('SQLITE')^.DbImpl := db;
  end;
  if GetCtMetaDBReg('ODBC')^.DbImpl = nil then
  begin
    db := TCtMetaOdbcDb.Create;
    GetCtMetaDBReg('ODBC')^.DbImpl := db;
  end;
  if GetCtMetaDBReg('HTTP_JDBC')^.DbImpl = nil then
  begin
    db := TCtMetaHttpDb.Create;
    GetCtMetaDBReg('HTTP_JDBC')^.DbImpl := db;
  end;


  LoadIni;


  RecreateRecentMn;
  ReCreateCustomToolsMenu;

  CheckFormScaleDPI(Self);

  CheckReloadGlobalScript;
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('MAINFORM', 'CREATE', '', Self, nil);
  end;

  if ParamStr(1) <> '' then
    if GetDmlScriptType(ParamStr(1)) <> '' then
    begin
      Self.TimerInit.Enabled := False;
      try
        ExecDmlScript(ParamStr(1));
      except
        on E: EAbort do
        begin
          Self.Visible := False;
          Application.Terminate;
          Application.ShowMainForm := False;
        end
        else
          Application.HandleException(Self);
      end;
    end;

  Application.OnActivate := Self._OnAppActivate;
  Application.ExceptionDialog := aedOkMessageBox;
  TimerInit.Enabled := True;
end;

procedure TfrmMainDml.LoadFromFile(fn: string);
var
  fs: TCtObjSerialer;
begin
  if FFileWorking then
    Exit;
  FFileWorking := True;
  try
    if Assigned(FWaitWnd) then
      raise Exception.Create('wait wnd busy');
    if FileExists(fn) then
    begin
      try
        SetStatusBarMsg(Format(srEzdmlOpeningFileFmt, [GetStatusPanelFileName(fn)]));
        Self.Refresh;
        fs := EzdmlCreateCtObjSerialer(fn, False);  
        FFrameCtTableDef.IsInitLoading := False;
        try
          fs.RootName := 'DataModels';
          FProgressAll := 0;
          FProgressCur := 0;
          if IsTmpFile(fn) and (GetDocFileSize(fn) < 1024 * 1024) then
            //1MB内的小文件不显示进度条
          begin
            FWaitWnd := nil;
            Screen.Cursor := crAppStart;
          end
          else
            FWaitWnd := TfrmWaitWnd.Create(Self);
          try
            if Assigned(FWaitWnd) then
              FWaitWnd.Init(srEzdmlOpenFile + ' ' + ExtractFileName(fn), srEzdmlOpening,
                srEzdmlAbortOpening);
            try
              FCtDataModelList.Clear;
              FFrameCtTableDef.Init(nil, True);
            except
            end;
            FFrameCtTableDef.IsInitLoading := True;
            FCtDataModelList.LoadFromSerialer(fs);
          finally
            Screen.Cursor := crDefault;
            if Assigned(FWaitWnd) then
              FWaitWnd.Release;
            FWaitWnd := nil;
          end;
        finally
          fs.Free;
                   
          FFrameCtTableDef.IsInitLoading := False;
          FFrameCtTableDef.Init(FCtDataModelList, False);
        end;
        SetStatusBarMsg(GetStatusPanelFileName(fn));
        FCurFileName := fn;
        Self.RememberFileDateSize;
        FAutoSaveCounter := 0;
        CheckCaption;
      except
        on E: Exception do
          if not IsTmpFile(fn) then
            raise
          else
            raise Exception.Create(Format(srEzdmlLoadTmpFileFailFmt, [fn, E.message]));
      end;
    end;
  finally
    FFileWorking := False;
  end;
end;

procedure TfrmMainDml.LoadIni;
var
  ini: TIniFile;
  I, L, po: integer;
  S, V: string;
begin
  S := GetAppDefTempPath;
  if not DirectoryExists(S) then
    ForceDirectories(S);

  ini := TIniFile.Create(GetConfFileOfApp);
  try
    G_AppDefFontName := ini.ReadString('Options', 'AppDefFontName', '');
    G_AppDefFontSize := ini.ReadInteger('Options', 'AppDefFontSize', 0);
    G_AppFixWidthFontName := ini.ReadString('Options', 'AppFixWidthFontName', '');
    G_AppFixWidthFontSize := ini.ReadInteger('Options', 'AppFixWidthFontSize', 0);
    G_DmlGraphFontName := ini.ReadString('Options', 'DmlGraphFontName', '');

    I := 0;
    FRecentFiles.Clear;
    while True do
    begin
      Inc(I);
      S := ini.ReadString('RecentFiles', IntToStr(I), '');
      if S = '' then
        Break;
      FRecentFiles.Add(S);
    end;

    I := 0;
    L := 0;
    SetLength(CtCustFieldTypeDefs, L);
    while True do
    begin
      Inc(I);
      S := Trim(ini.ReadString('DefaultFieldTypes', IntToStr(I), ''));
      if S = '' then
        Break;
      Inc(L);
      SetLength(CtCustFieldTypeDefs, L);
      CtCustFieldTypeDefs[L - 1] := S;
    end;
    SetLength(DML_CustFieldTypeDefs, L);
    for I := 0 to L - 1 do
      DML_CustFieldTypeDefs[I] := CtCustFieldTypeDefs[I];

    I := 0;
    L := 0;
    SetLength(CtCustFieldTypeList, L);
    SetLength(CtCustFieldTypeDefList, L);
    while True do
    begin
      Inc(I);
      S := Trim(ini.ReadString('CustFieldTypes', IntToStr(I), ''));
      if S = '' then
        Break;
      Inc(L);
      po := Pos(':', S);
      if po > 0 then
      begin
        V := Copy(S, po + 1, Length(S));
        S := Copy(S, 1, po - 1);
      end
      else
      begin
        V := '';
      end;
      SetLength(CtCustFieldTypeList, L);
      CtCustFieldTypeList[L - 1] := S;
      SetLength(CtCustFieldTypeDefList, L);
      CtCustFieldTypeDefList[L - 1] := V;
    end;

    I := 0;
    L := 0;
    SetLength(CtCustDataTypeReplaces, L);
    while True do
    begin
      Inc(I);
      S := Trim(ini.ReadString('CustDataTypeReplaces', IntToStr(I), ''));
      if S = '' then
        Break;
      Inc(L);
      SetLength(CtCustDataTypeReplaces, L);
      CtCustDataTypeReplaces[L - 1] := S;
    end;

    I := 0;
    L := 0;
    SetLength(CtTbNamePrefixDefs, L);
    while True do
    begin
      Inc(I);
      S := Trim(ini.ReadString('TbNamePrefixDefs', IntToStr(I), ''));
      if S = '' then
        Break;
      Inc(L);
      SetLength(CtTbNamePrefixDefs, L);
      CtTbNamePrefixDefs[L - 1] := S;
    end;

    I := 0;
    L := 0;
    SetLength(CtCustFieldDataGenRules, L);
    while True do
    begin
      Inc(I);
      S := Trim(ini.ReadString('CustFieldDataGenRules', IntToStr(I), ''));
      if S = '' then
        Break;
      Inc(L);
      SetLength(CtCustFieldDataGenRules, L);
      CtCustFieldDataGenRules[L - 1] := S;
    end;

    G_CheckForUpdates := ini.ReadBool('Options', 'CheckForUpdates', True);

    FCurFileName := ini.ReadString('RecentFiles', 'CurFileName', '');
    FAutoSaveMinutes := ini.ReadInteger('Options', 'AutoSaveMinutes', FAutoSaveMinutes);
    FSaveTempFileOnExit := ini.ReadBool('Options', 'SaveTempFileOnExit',
      FSaveTempFileOnExit);

    FieldNameMaxDrawSize := ini.ReadInteger('Options', 'FieldNameMaxDrawSize',
      FieldNameMaxDrawSize);
    FieldTypeMaxDrawSize := ini.ReadInteger('Options', 'FieldTypeMaxDrawSize',
      FieldTypeMaxDrawSize);
    TableFieldMaxDrawCount := ini.ReadInteger('Options', 'TableFieldMaxDrawCount',
      TableFieldMaxDrawCount);
    G_MaxRowCountForTableData :=
      ini.ReadInteger('Options', 'MaxRowCountForTableData', G_MaxRowCountForTableData);
    G_HugeModeTableCount := ini.ReadInteger('Options', 'HugeModeTableCount',
      G_HugeModeTableCount);
    G_CreateSeqForOracle := ini.ReadBool('Options', 'CreateSeqForOracle',
      G_CreateSeqForOracle);
    G_QuotReservedNames := ini.ReadBool('Options', 'QuotReservedNames',
      G_QuotReservedNames);
    G_QuotAllNames := ini.ReadBool('Options', 'QuotAllNames', G_QuotAllNames);
    G_LogicNamesForTableData :=
      ini.ReadBool('Options', 'LogicNamesForTableData', G_LogicNamesForTableData);
    G_WriteConstraintToDescribeStr :=
      ini.ReadBool('Options', 'WriteConstraintToDescribeStr', G_WriteConstraintToDescribeStr);

    G_FieldGridShowLines := ini.ReadBool('Options', 'FieldGridShowLines',
      G_FieldGridShowLines);
    G_AddColCommentToCreateTbSql :=
      ini.ReadBool('Options', 'AddColCommentToCreateTbSql', G_AddColCommentToCreateTbSql);

    G_CreateIndexForForeignkey :=
      ini.ReadBool('Options', 'CreateIndexForForeignkey', G_CreateIndexForForeignkey);
    G_EnableCustomPropUI := ini.ReadBool('Options', 'EnableCustomPropUI',
      G_EnableCustomPropUI); 
    G_CustomPropUICaption := ini.ReadString('Options', 'CustomPropUICaption', '');   
    G_EnableAdvTbProp := ini.ReadBool('Options', 'EnableAdvTbProp',
      G_EnableAdvTbProp);
    G_BackupBeforeAlterColumn :=
      ini.ReadBool('Options', 'BackupBeforeAlterColumn', G_BackupBeforeAlterColumn);
    G_TableDialogViewModeByDefault :=
      ini.ReadBool('Options', 'TableDialogViewModeByDefault', G_TableDialogViewModeByDefault);
    S := ini.ReadString('Options', 'OCILIB', '');
    if S = '' then
      S := ini.ReadString('Options', 'OCIDLL', '');
    if S = '' then
    begin
      V := GetFolderPathOfAppExe();
      V := FolderAddFileName(V, ocilib);
      if FileExists(V) then
        S := V;
    end;
    if S <> '' then
    begin
      OCILoadedLibrary := S;
      //Windows.SetEnvironmentVariable('_NS_ORA_INSTANT_CLIENT', 'True');
      //Windows.SetEnvironmentVariable('_NS_OCIDLL', PAnsiChar(S));
    end;
    S := ini.ReadString('Options', 'NLSLang', '');
    if S <> '' then
    begin
      SetEnvVar('NLS_LANG', S);
    end;

    S := ini.ReadString('Options', 'MYSQLLIB', '');
    if S = '' then
    begin
      V := GetFolderPathOfAppExe();
      V := FolderAddFileName(V, mysqllib);
      if FileExists(V) then
        S := V;
    end;
    if S <> '' then
    begin
      MysqlLoadedLibrary := S;
    end;

    S := ini.ReadString('Options', 'SQLSERVERLIB', '');
    if S = '' then
    begin
      V := GetFolderPathOfAppExe();
      V := FolderAddFileName(V, DBLIBDLL);
      if FileExists(V) then
        S := V;
    end;
    if S <> '' then
    begin
      DBLibLibraryName := S;
    end;

    S := ini.ReadString('Options', 'POSTGRESLIB', '');
    if S = '' then
    begin
      V := GetFolderPathOfAppExe();
      V := FolderAddFileName(V, pqlib);
      if FileExists(V) then
        S := V;
    end;
    if S <> '' then
    begin
      Postgres3LoadedLibrary := S;
    end;

    S := ini.ReadString('Options', 'SQLITELIB', '');
    if S = '' then
    begin
      V := GetFolderPathOfAppExe();
      V := FolderAddFileName(V, Sqlite3Lib);
      if FileExists(V) then
        S := V;
    end;
    if S <> '' then
    begin
      SQLiteDefaultLibrary := S;
    end;


    //S := ini.ReadString('Options', 'LANG', '');
    //if S<>'' then
    //  SetDefaultLang(S);

    FMainSplitterPos := ini.ReadInteger('MainForm', 'MainSplitterPos', FMainSplitterPos);
    FStartMaximized := ini.ReadBool('MainForm', 'Maximized', False);
  finally
    ini.Free;
  end;
end;

procedure TfrmMainDml.FormDestroy(Sender: TObject);
begin
  try
    FRecentFiles.Free;
    FCustomTools.Free;
    FCtDataModelList.Free;
    if Assigned(FGlobalScriptor) then
      FreeAndNil(FGlobalScriptor);

    ClearCtMetaDbReg(True);
  except
  end;
end;

function TfrmMainDml.GetFastTmpFileName(fn: string): string;
var
  dir: string;
begin
  if IsTmpFile(fn) then
    Result := ''
  else
  begin
    dir := GetTmpDirForFile(fn);
    fn := ExtractFileName(fn);
    fn := ChangeFileExt(fn, '') + '(0).~dmh0';
    fn := FolderAddFileName(dir, fn);
    Result := fn;
  end;
end;

function TfrmMainDml.GetLastTmpFileName(fn: string): string;
var
  dir: string;
begin
  Result := '';
  if IsTmpFile(fn) then
  begin
    Exit;
  end;

  dir := GetTmpDirForFile(fn);
  if not DirectoryExists(dir) then
    Exit;

  fn := ExtractFileName(fn);
  fn := ChangeFileExt(fn, '.~dmh');
  fn := FolderAddFileName(dir, fn);
  fn := GetLastUsedFileName(fn);
  Result := fn;
end;

function TfrmMainDml.GetNewTmpFileName(fn: string): string;
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
    fn := ChangeFileExt(fn, '.~dmh');
    fn := FolderAddFileName(dir, fn);
    fn := GetUnusedTmpFileName(fn);
    Result := fn;
  end;
end;

function TfrmMainDml.GetStatusPanelFileName(fn: string): string;
begin
  if IsTmpFile(fn) then
    Result := Format(srEzdmlTempFileFmt, [ExtractFileName(fn)])
  else
    Result := fn;
end;

function TfrmMainDml.GetTmpDirForFile(fn: string): string;
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

procedure TfrmMainDml.ImportFromFile(fn: string);

  procedure ImportPDM;
  begin
    SetStatusBarMsg(Format(srEzdmlOpeningFileFmt, [GetStatusPanelFileName(fn)]));
    Self.Refresh;
    FCtDataModelList.Clear;
    FFrameCtTableDef.Init(nil, True);
    FCurFileName := '';
    FProgressAll := 0;
    FProgressCur := 0;
    FWaitWnd := TfrmWaitWnd.Create(Self);
    with TCtMetaPdmImporter.Create do
      try
        FWaitWnd.Init(srEzdmlOpenFile + ' ' + ExtractFileName(fn), srEzdmlOpening,
          srEzdmlAbortOpening);
        FWaitWnd.CheckAbort;
        ModelList := FCtDataModelList;
        FileName := fn;
        DoImport;
        Sleep(100);
        FWaitWnd.CheckAbort;
        Sleep(200);
        FWaitWnd.CheckAbort;
      finally
        Free;
        FWaitWnd.Release;
        FWaitWnd := nil;
        FFrameCtTableDef.Init(FCtDataModelList, False);
      end;
  end;

var
  ext: string;
begin
  CheckCanEditMeta;
  ext := LowerCase(ExtractFileExt(fn));
  if ext = '.pdm' then
  begin
    ImportPDM;
  end;

  SetStatusBarMsg(GetStatusPanelFileName(fn));
  FCurFileName := '';
  FAutoSaveCounter := 0;
  CheckCaption;
end;

function TfrmMainDml.IsTmpFile(fn: string): boolean;
var
  ext: string;
begin
  Result := False;
  ext := ExtractFileExt(fn);
  ext := LowerCase(ext);
  if (ext = '.~dmh') or (ext = '.~dmh0') then
    Result := True;
end;

function CompareStream(// 比较两个流是否相等
  mStream1, mStream2: TStream // 两个流
  ): boolean; // 返回两个流是否相等
var
  vBuffer1, vBuffer2: array[0..$1000 - 1] of char;
  vLength1, vLength2: integer;
begin
  Result := mStream1 = mStream2;
  if Result then
    Exit;
  if not Assigned(mStream1) or not Assigned(mStream2) then
    Exit; // 其中一个为空
  while True do
  begin
    vLength1 := mStream1.Read(vBuffer1, SizeOf(vBuffer1));
    vLength2 := mStream2.Read(vBuffer2, SizeOf(vBuffer2));
    if vLength1 <> vLength2 then
      Exit;
    if vLength1 = 0 then
      Break;
    if not CompareMem(@vBuffer1[0], @vBuffer2[0], vLength1) then
      Exit;
  end;
  Result := True;
end;

function IsSameFileContent(// 比较两个文件是否相等
  mFileName1, mFileName2: string // 两个文件
  ): boolean; // 返回两个文件是否相等
var
  vFileStream1, vFileStream2: TFileStream;
  fn1, fn2: string;
begin
  Result := False;
  if not FileExists(mFileName1) or not FileExists(mFileName2) then
    Exit; // 其中一个文件不存在
  fn1 := ExpandFileName(mFileName1);
  fn2 := ExpandFileName(mFileName2);
  if LowerCase(fn1) = LowerCase(fn2) then// 两个文件名是否相同
  begin
    Result := True;
    Exit;
  end;

  if GetDocFileSize(mFileName1) <> GetDocFileSize(mFileName2) then
    // 文件大小是否一致
    Exit;

  vFileStream1 := TFileStream.Create(mFileName1, fmOpenRead or fmShareDenyNone);
  vFileStream2 := TFileStream.Create(mFileName2, fmOpenRead or fmShareDenyNone);
  try
    Result := CompareStream(vFileStream1, vFileStream2);
    // 比较两个文件内容是否相同
  finally
    vFileStream1.Free;
    vFileStream2.Free;
  end;
end;

procedure TfrmMainDml.SaveDMLFastTmpFile;
var
  fn, fastFn: string;
  vFileDate: TDateTime;
begin
  if FCtDataModelList.TableCount <= 0 then
    Exit;
  if FCtDataModelList.IsHuge then
    Exit;

  if not FSaveTempFileOnExit then
  begin
    Exit;
  end;

  try
    fn := SaveDMLToTmpFile(); //这一次保存的临时文件
    if fn <> '' then
    begin
      fastFn := GetFastTmpFileName(FCurFileName); //上一次保存的临时文件
      if (fastFn <> '') and not FileExists(fastFn) then
      begin
        //快速加载文件不存在，直接复制一份
        CopyFile(PChar(fn), PChar(fastfn), False);
        fn := fastfn;
      end
      else if (fastFn <> '') and (fastFn <> fn) then
        //将新文件覆盖零号文件（启动时会自动加载）
      begin
        if IsSameFileContent(fastFn, fn) then
        begin
          fn := fastFn;
        end
        else
        begin
          DeleteFile(fastFn);
          CopyFile(PChar(fn), PChar(fastfn), False);
          fn := fastfn;
        end;
      end;
      if fn <> '' then
        if GetFileAges(FCurFileName, vFileDate) then
          SetFileAges(fn, vFileDate);
    end;
  except
  end;
end;

function TfrmMainDml.SaveDMLToTmpFile: string;
var
  lastFn, fn, sfn, sts: string;
begin
  Result := '';
  if FCtDataModelList.TableCount <= 0 then
    Exit;

  sfn := FCurFileName;
  fn := sfn;
  if fn = '' then
    fn := GetConfFileOfApp('.dmh');
  if IsTmpFile(fn) then
    Exit;
  lastFn := GetLastTmpFileName(fn); //上一次保存的临时文件
  if not IsTmpFile(fn) then
    fn := GetNewTmpFileName(fn);
  sts := StatusBar1.SimpleText;
  FIsAutoSaving := True;
  try
    SaveToFile(fn);
  finally
    FIsAutoSaving := False;
  end;
  FCurFileName := sfn;
  CheckCaption;
  Result := fn;

  if not FileExists(lastFn) then
  begin
    lastFn := '';
    //快速加载文件不存在
  end
  //判断两次的文件是否相同
  else if (lastFn <> '') and (lastFn <> fn) and IsSameFileContent(lastFn, fn) then
  begin
    //完全相同的话，说明本次备份是多余，直接删除之
    DeleteFile(Result);
    Result := lastFn;
    SetStatusBarMsg(sts);
  end;
end;

procedure TfrmMainDml.SaveIni;
var
  ini: TIniFile;
  I: integer;
begin
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    ini.EraseSection('RecentFiles');
    for I := 0 to FRecentFiles.Count - 1 do
      ini.WriteString('RecentFiles', IntToStr(I + 1), FRecentFiles[I]);
    ini.WriteString('RecentFiles', 'CurFileName', FCurFileName);
    FMainSplitterPos := Self.FFrameCtTableDef.PanelCttbTree.Width;
    if FMainSplitterPos > 20 then
      ini.WriteInteger('MainForm', 'MainSplitterPos', FMainSplitterPos);
    if Self.WindowState = wsMaximized then
      ini.WriteBool('MainForm', 'Maximized', True)
    else
      ini.WriteBool('MainForm', 'Maximized', False);
  finally
    ini.Free;
  end;
end;

procedure TfrmMainDml.SaveToFile(fn: string);
var
  fs: TCtObjSerialer;
  //I: Integer;
begin
  if FFileWorking then
    Exit;
  FFileWorking := True;
  try
    if Assigned(FWaitWnd) then
      raise Exception.Create('wait wnd busy');
    try
      if not FIsAutoSaving then
        if not FFrameCtTableDef.FFrameDMLGraph.Visible then
          if FFrameCtTableDef.FFrameCtTableList.TreeViewCttbs.CanFocus then
            FFrameCtTableDef.FFrameCtTableList.TreeViewCttbs.SetFocus;
    except
    end;
    SetStatusBarMsg(Format(srEzdmlSaveingFileFmt, [GetStatusPanelFileName(fn)]));
    Self.Refresh;
    if FileExists(fn) then
      DeleteFile(fn);

    fs := EzdmlCreateCtObjSerialer(fn, True);
    try
      fs.RootName := 'DataModels';
      FCtDataModelList.Pack;

      FProgressAll := 0;
      FProgressCur := 0;
      if FIsAutoSaving and not FCtDataModelList.IsHuge then
        //自动保存：超过1万个字段才显示进度
      begin
        FWaitWnd := nil;
        Screen.Cursor := crAppStart;
      end
      else
        FWaitWnd := TfrmWaitWnd.Create(Self);
      try
        if Assigned(FWaitWnd) then
          FWaitWnd.Init(srEzdmlSaveFile + ' ' + ExtractFileName(fn), srEzdmlSaving,
            srEzdmlAbortSaving);

        {for I := 0 to FTableList.Count - 1 do
          FTableList[I].MetaFields.Pack;}
        FCtDataModelList.SaveToSerialer(fs);

      finally
        if not FIsAutoSaving then
          FWaitWnd.Release;
        FWaitWnd := nil;
        Screen.Cursor := crDefault;
      end;
    finally
      fs.Free;
    end;
    SetStatusBarMsg(srEzdmlSaved + GetStatusPanelFileName(fn) + ' ' + TimeToStr(Now));
    FCurFileName := fn;
    RememberFileDateSize;
    FAutoSaveCounter := 0;
    if not FIsAutoSaving then
      CheckCaption;
  finally
    FFileWorking := False;
  end;
end;

procedure TfrmMainDml.SetRecentFile(fn: string);
var
  I: integer;
  S: string;
begin
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

procedure TfrmMainDml.SetStatusBarMsg(msg: string; tp: integer);
begin
  if (tp < 0) or (tp >= StatusBar1.Panels.Count) then
    tp := 0;
  if StatusBar1.Panels[tp].Text <> msg then
  begin
    StatusBar1.Panels[tp].Text := msg;
    StatusBar1.Refresh;
  end;
end;

procedure TfrmMainDml.TimerAutoSaveTimer(Sender: TObject);
begin
  if csDestroying in Self.ComponentState then
    Exit;
  if FIsAutoSaving or (FAutoSaveMinutes = 0) then
    Exit;
  //hw := GetForegroundWindow;
  // if GetWindowThreadProcessId(hw, nil) <> MainThreadID then
  //  Exit;
  Inc(FAutoSaveCounter);
  if FAutoSaveCounter < FAutoSaveMinutes then
    Exit;
  if Assigned(FWaitWnd) then
    Exit;

  FAutoSaveCounter := 0;
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('MAINFORM', 'FILE_AUTOSAVE', FCurDmlFileName, Self, nil);
  end;

  if not FCtDataModelList.IsHuge then
    SaveDmlToTmpFile;
end;

procedure TfrmMainDml.TimerInitTimer(Sender: TObject);
var
  fn, ext: string;
  tp: Integer;
begin
  TimerInit.Enabled := False;
  if csDestroying in Self.ComponentState then
    Exit;
  if Application.Terminated then
    Exit;

  if (Top + Height + ScaleDPISize(80)) > Screen.DesktopHeight then
  begin
    tp := Screen.DesktopHeight - Height - ScaleDPISize(80);
    if tp >= 0 then
      Top := tp
    else
    begin
      Top := 0;
    end;
  end;
  if FStartMaximized then
    Self.WindowState:=wsMaximized;
  CheckShowNewVersionInfo(False);
  if FMainSplitterPos >= 20 then
    Self.FFrameCtTableDef.PanelCttbTree.Width := FMainSplitterPos;
  if ParamStr(1) <> '' then
  begin
    ext := ExtractFileExt(ParamStr(1));
    if LowerCase(ext) <> '.pas' then
    begin
      PromptOpenFile(ParamStr(1));
      if ParamStr(2) <> '' then
      begin
        if GetDmlScriptType(ParamStr(2)) <> '' then
          ExecDmlScript(ParamStr(2));
      end;
    end;
  end
  else if FCurFileName <> '' then
  begin
    fn := FCurFileName;
    FCurFileName := '';
    try
      TryLockFile(fn, False);
    except
      Exit;
    end;
    if TryLoadFromTmpFile(fn) then
    begin
    end
    else if FRecentFiles.Count > 0 then
      actOpenLastFile1.Execute;
  end
  else if FRecentFiles.Count > 0 then
  begin
    //fn := FRecentFiles[0];
    //if Application.MessageBox(PChar(Format(srEzdmlOpenLastFileFmt, [fn])),
    //  PChar(srEzdmlNew), MB_OKCANCEL or MB_ICONQUESTION) = IDOK then
   { actOpenLastFile1.Execute;
    if FCurFileName <> '' then
      Self.SaveIni; }
  end
  else
  begin
    fn := GetFolderPathOfAppExe;
    fn := FolderAddFileName(fn, 'demo.dmj');
    fn := GetConfigFile_OfLang(fn);
    if FileExists(fn) then
    begin
      if Application.MessageBox(PChar(srEzdmlPromptOpenDemoFile),
        PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) = idOk then
      begin
        PromptOpenFile(fn);
      end;
    end
    else
    begin
      //fn :='/Users/admin/Documents/ezdml_x/demo.dmj';
      //  PromptOpenFile(fn);
    end;
  end;

  if FCurFileName = '' then
    FFrameCtTableDef.Init(FCtDataModelList, False);
end;

function TfrmMainDml.TryLoadFromTmpFile(sfn: string): boolean;
var
  fn: string;
  bCheck: boolean;
  vFileDate1, vFileDate2: TDateTime;
begin
  Result := False;
  if not FSaveTempFileOnExit then
    Exit;

  if not FileExists(sfn) then
    Exit;
  fn := GetFastTmpFileName(sfn);
  if fn = '' then
    Exit;
  if not FileExists(fn) then
    Exit;

  bCheck := False;
  if GetFileAges(sfn, vFileDate1) and
    GetFileAges(fn, vFileDate2) then
  begin
    if Abs(vFileDate1 - vFileDate2) > 2 / 24 / 60 / 60 then
      bCheck := True;
  end
  else
    bCheck := True;
  if bCheck then
    case (Application.MessageBox(PChar(Format(srEzdmlTmpFileIgnoredFmt, [fn])),
        PChar(srEzdmlOpenFile), MB_OK or MB_ICONWARNING)) of
      idOk: fn := sfn;
      else
        Abort;
    end;
  LoadFromFile(fn);
  FCurFileName := sfn;
  FCurDmlFileName := FCurFileName;
  RememberFileDateSize;
  CheckCaption;
  Result := True;
end;


procedure CallScriptFunctionAsMethod;
var
  S: string;
begin
  with TPSScript.Create(nil) do
    try
      Script.Clear;
      Script.Add(
        'function Test(s,par1,par2,par3,par4:string): string; begin Result := ''Test Results:2''+s+par1+par2+par3+par4;end; begin end.');
      if not Compile() then
        ShowMessage('err1');
      S := ExecuteFunction(['INDATA', 'ss', 'p222', 'p333', 'p444'], 'Test');
      ShowMessage(S);

    finally
      Free;
    end;
end;


procedure TfrmMainDml.CheckReloadGlobalScript;
var
  FileTxt: TStrings;
  fn, S: string;
  bSuccess: boolean;
  ce: TPSScript;
begin
  //CallScriptFunctionAsMethod;
  //Exit;

  GProc_OnEzdmlGenTbSqlEvent := nil;
  GProc_OnEzdmlGenDbSqlEvent := nil;
  GProc_OnEzdmlGenFieldTypeDescEvent := nil;
  GProc_OnEzdmlGenAlterFieldEvent := nil;
  GProc_OnEzdmlCmdEvent := nil;
  if Assigned(FGlobalScriptor) then
    FreeAndNil(FGlobalScriptor);

  fn := DEF_GSCRIPT_FN;
  S := GetFolderPathOfAppExe;
  S := FolderAddFileName(S, fn);
  if not FileExists(S) then
    Exit;

  FGlobalScriptor := TDmlGlobalPasScript.Create;
  TDmlPasScriptor(FGlobalScriptor).ActiveFile := S;
  FileTxt := TStringList.Create;
  try
    FileTxt.LoadFromFile(S);
    S := FileTxt.Text;
  finally
    FileTxt.Free;
  end;

  bSuccess := False;
  with TDmlGlobalPasScript(FGlobalScriptor) do
    try
      ce := GetPS;
      ce.UsePreProcessor := True;

      if not Compile('PASCAL_SCRIPT', S) then
        raise Exception.Create(DEF_GSCRIPT_FN + ' compile failed!'#13#10 + StdOutPut.Text);
      Exec('PASCAL_SCRIPT', S);
      //GProc_OnEzdmlGenTbSqlEvent := TOnEzdmlGenTbSqlEvent(ce.GetProcMethod('OnEzdmlGenTbSqlEvent'));
      //GProc_OnEzdmlGenDbSqlEvent := TOnEzdmlGenDbSqlEvent(ce.GetProcMethod('OnEzdmlGenDbSqlEvent'));
      //GProc_OnEzdmlGenFieldTypeDescEvent := TOnEzdmlGenFieldTypeDescEvent(ce.GetProcMethod('OnEzdmlGenFieldTypeDescEvent'));
      //GProc_OnEzdmlGenAlterFieldEvent := TOnEzdmlGenAlterFieldEvent(ce.GetProcMethod('OnEzdmlGenAlterFieldEvent'));
      //GProc_OnEzdmlCmdEvent := TOnEzdmlCmdEvent(ce.GetProcMethod('OnEzdmlCmdEvent'));
      TakeGlobalEvents;

      //S:=GProc_OnEzdmlCmdEvent( 'TEST222222222222222', 'pp111','p222',Self,nil);
      //ShowMessage(S);

      bSuccess := True;
    finally
      if not bSuccess then
        FreeAndNil(FGlobalScriptor);
    end;

end;

procedure TfrmMainDml.CheckForUpdates(bForceNow: boolean);
var
  ini: TIniFile;
  dt: TDateTime;
  uid, url, pf, jstr, opt, ver: string;
  cc: integer;
  jo: TJSONObject;
begin
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    cc := ini.ReadInteger('Updates', 'tk', 0);
    Inc(cc);
    ini.WriteInteger('Updates', 'tk', cc);

    if not bForceNow then
    begin
      if not G_CheckForUpdates then
        Exit;
      dt := ini.ReadDateTime('Updates', 'LastCheckOkDate', 0);
      if (Now - dt) < 8 then
        Exit;
      dt := ini.ReadDateTime('Updates', 'LastCheckDate', 0);
      if (Now - dt) < 1 then
        Exit;
    end;
    ini.WriteDateTime('Updates', 'LastCheckDate', Now);

    uid := ini.ReadString('Updates', 'UID', '');
    if uid = '' then
    begin
      uid := CtGenGUID;
      ini.WriteString('Updates', 'UID', uid);
    end;

  {$IFDEF Windows}
  {$ifdef WIN32}
    pf := 'win32';
  {$else}
    pf := 'win64';
  {$endif}
  {$ELSE}
  {$IFDEF Darwin}
    pf := 'mac64';
  {$ELSE}
    pf := 'linux64';
  {$ENDIF}
  {$ENDIF}
    url := 'http://www.ezdml.com/up.html?app=ezdml&platform=' + pf +
      '&ver=' + srEzdmlVersionNum + '&uid=' + uid + '&tk=' + IntToStr(cc);

    //Toast(srEzdmlCheckingForUpdates+#10+url, 1000);
{
  "app": "ezdml",
  "platform": "win32",
  "ver": "3.09",
  "date": "2021-04-11",
  "desc": "2021-04-11 V3.09: new version, bugs fixed",
  "detail_url": "http://www.ezdml.com/"
}
    opt := '[SHOW_PROGRESS]';
    if bForceNow then
      opt := opt + '[WAIT_TICKS=0]'
    else
      opt := opt + '[WAIT_TICKS=2000]';
    opt := opt + '[MSG=' + srEzdmlCheckingForUpdates + ']';
    try
      jstr := GetUrlData_Net(url, '', opt);
      if jstr = '' then
        Exit;
      {lres := jstr;
      lres := StringReplace(lres, #13 ,' ', [rfReplaceAll]);
      lres := StringReplace(lres, #10 ,' ', [rfReplaceAll]);
      ini.WriteString('Updates', 'LastResult', lres);  }
      jo := TJSONObject.Create(jstr);
      ver := jo.optString('ver');
      ini.WriteString('Updates', 'NewVerNum', ver);
      ini.WriteString('Updates', 'NewVerDate', jo.optString('date'));
      ini.WriteString('Updates', 'NewVerDesc', jo.optString('desc'));
      ini.WriteString('Updates', 'NewVerUrl', jo.optString('detail_url'));
      jo.Free;
      ini.WriteDateTime('Updates', 'LastCheckOkDate', Now);
    except
      on E: Exception do
        //lres := 'Error: '+E.Message;
    end;

    //showmessage(lres);
  finally
    ini.Free;
  end;
end;

procedure TfrmMainDml.CheckShowNewVersionInfo(bForceNow: boolean);
var
  sCurVer, sNewVer, sLastPromptVer, sDesc: string;
  ini: TIniFile;
begin
  if not bForceNow and not G_CheckForUpdates then
    Exit;
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    sCurVer := srEzdmlVersionNum;
    sNewVer := ini.ReadString('Updates', 'NewVerNum', '');
    if (sNewVer = '') or (sNewVer = sCurVer) then
    begin
      if not bForceNow then
        Exit;
      lbNewVerInfo.Caption := srEzdmlNoUpdateFound;
      lbNewVerInfo.Tag := 2;
      lbNewVerInfo.Hint := '';
    end
    else
    begin
      sLastPromptVer := ini.ReadString('Updates', 'LastPromptVer', '');
      if not bForceNow then
      begin
        if (sNewVer = sLastPromptVer) then
          Exit;
        if StrToFloatDef(sCurVer, 0) >= StrToFloatDef(sNewVer, 0) then
          Exit;
      end;
      sDesc := ini.ReadString('Updates', 'NewVerDesc', '');
      if sDesc = '' then
        sDesc := ini.ReadString('Updates', 'NewVerDate', '') + ' ' + sNewVer + ' released.';
      lbNewVerInfo.Caption := sDesc;
      lbNewVerInfo.Tag := 1;
      lbNewVerInfo.Hint := ini.ReadString('Updates', 'NewVerUrl', '');
    end;

    PanelNewVerHint.Left := 4;
    PanelNewVerHint.Top := Self.StatusBar1.Top - PanelNewVerHint.Height - 4;
    PanelNewVerHint.Show;
    PanelNewVerHint.BringToFront;
  finally
    ini.Free;
  end;
end;

function TfrmMainDml.IsShortcut(var Message: TLMKey): boolean;
begin
  Result := inherited IsShortcut(Message);
  if not Result then
    if Assigned(FFrameCtTableDef) and Assigned(FFrameCtTableDef.FFrameDMLGraph)
      and FFrameCtTableDef.PanelDMLGraph.Visible then
      Result := FFrameCtTableDef.FFrameDMLGraph.IsShortcut(Message);
end;

procedure TfrmMainDml.TryLockFile(fn: string; bAsk: boolean);
begin
  if FFileLockMutex <> nil then
  begin
    FreeAndNil(FFileLockMutex);
  end;
  if fn = '' then
    Exit;

  FFileLockMutex := TCtMutex.Create(fn);
  if not FFileLockMutex.Acquire(400) then
  begin
{$ifdef WINDOWS}
    bAsk := False;
{$else}
{$endif}
    if not bAsk then
    begin
      FreeAndNil(FFileLockMutex);
      raise Exception.Create(Format(srEzdmlFileAlreadyOpenedFmt, [fn]));
    end
    else if Application.MessageBox(
      PChar(Format(srEzdmlConfirmAlreadyOpenedFileFmt, [fn])),
      PChar(Application.Title), MB_YESNOCANCEL or MB_DEFBUTTON2 or MB_ICONWARNING) <>
      idYes then
    begin
      FreeAndNil(FFileLockMutex);
      Abort;
    end
    else
      FFileLockMutex.Acquire(40, True);
  end;
end;

procedure TfrmMainDml._OnAppActivate(Sender: TObject);
begin
  if FFileWorking then
    Exit;
  if CheckCurFileDateSizeChanged then
  begin
    if Application.MessageBox(PChar(srEzdmlPromptReloadOnFileDateSizeChanged),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    begin
      Self.RememberFileDateSize;
      Exit;
    end;

    FCtDataModelList.Clear;
    FFrameCtTableDef.Init(FCtDataModelList, True);
    PromptOpenFile(FCurFileName, True);
  end;
end;

procedure TfrmMainDml._OnCustomToolsClick(Sender: TObject);

  function GetCustomToolsDir: string;
  begin
    Result := GetFolderPathOfAppExe('CustomTools');
  end;

var
  fn: string;
begin
  if Sender is TMenuItem then
  begin
    fn := TMenuItem(Sender).Hint;
    //ext := ExtractFileExt(fn);
    fn := FolderAddFileName(GetCustomToolsDir, fn);

    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('MENU_ACTION', 'Tools_CustomMenu', fn, Sender, nil);
    end;

    if GetDmlScriptType(fn) <> '' then
      ExecDmlScript(fn)
    else
      CtOpenDoc(PChar(fn)); { *Converted from ShellExecute* }
  end;
end;

procedure TfrmMainDml._OnDMLObjProgress(Sender: TObject;
  const Prompt: string; Cur, All: integer; var bContinue: boolean);
begin
  if Assigned(FWaitWnd) then
  begin
    if (Prompt = '') and (Cur = 0) then
      if FProgressAll = 0 then
      begin
        FProgressCur := 0;
        FProgressAll := All;
      end;

    if FProgressAll > 0 then
    begin
      if Sender is TCtMetaTableList then
        Inc(FProgressCur);
      FWaitWnd.SetPercentMsg(FProgressCur * 100 / FProgressAll, Prompt, True);
    end
    else
    begin
      if All > 0 then
        FWaitWnd.SetPercentMsg(Cur * 100 / All, Prompt, True)
      else
        FWaitWnd.CheckCanceled;
    end;
    if FWaitWnd.Canceled then
      bContinue := False;
  end;
end;

procedure TfrmMainDml._OnRecentFileClick(Sender: TObject);
var
  fn: string;
begin
  if Sender is TMenuItem then
  begin
    fn := TMenuItem(Sender).Hint;
    if FCurFileName = fn then
      Exit;
    PromptOpenFile(fn);
  end;
end;

procedure TfrmMainDml._WMZ_CUSTCMD(var msg: TMessage);
var
  tb: TCtMetaTable;
begin
  if msg.wParam = 1 then
  begin
    PromptOpenFile(FGlobeOpeningFile);
    FGlobeOpeningFile := '';
  end;
  if msg.wParam = 2 then
  begin
    Application.ProcessMessages;
    Application.Idle(True);
    if Assigned(Proc_ShowCtTableProp) then
      if G_WMZ_CUSTCMD_Object <> nil then
      begin
        tb := TCtMetaTable(G_WMZ_CUSTCMD_Object);
        if Proc_ShowCtTableProp(tb, msg.lParam = 1, False) then
        begin
          if FFrameCtTableDef.PanelDMLGraph.Showing then
          begin
            FFrameCtTableDef.FFrameDMLGraph.ReloadTbInfo(tb);
          end;
          FFrameCtTableDef._OnCtTablePropChange(2, tb, nil, '');
        end;
      end;
  end;
  if msg.wParam = 2 then
  begin
    actToggleTableView.Execute;
  end;       
  if msg.wParam = 3 then
  begin      
    if (GetKeyState(VK_CONTROL) and $80)=0 then
      actGenerateCode.Execute
    else
      actGenerateLastCode.Execute;
  end;
end;

procedure TfrmMainDml.actEditMyDictExecute(Sender: TObject);
var
  S, fn: string;
begin
  //20200406: 弃用
  fn := 'MyDict.txt';
  if Application.MessageBox(PChar(Format(srEzdmlConfirmEditTextFmt, [fn])),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONINFORMATION) <> idOk then
    Exit;
  S := GetFolderPathOfAppExe;
  S := FolderAddFileName(S, fn);
  if not FileExists(S) then
    with TFileStream.Create(S, fmCreate) do
      Free;
  CtOpenDoc(PChar(S)); { *Converted from ShellExecute* }
  if Application.MessageBox(PChar(Format(srEzdmlConfirmEditedTextFmt, [fn])),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONINFORMATION) <> idOk then
    Exit;
  GetAutoNameCapitalizer.ReloadDictFile;
end;

procedure TfrmMainDml.actEditSettingFileExecute(Sender: TObject);
var
  S, fn: string;
  //ws:WideString;
begin
  //20200406: 弃用
  //s:=trim('附件123');
  //t:=IntToStr(Length(s));   {本身就是UTF8编码}
  //t:=t+' '+Utf8ToAnsi(s)+':' +IntToStr(length(Utf8ToAnsi(s)));
  //t:=t+' '+UTF8Decode(s)+':' +IntToStr(Length(UTF8Decode(s)));

  fn := 'INI';
  if Application.MessageBox(PChar(Format(srEzdmlConfirmEditTextFmt, [fn])),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONINFORMATION) <> idOk then
    Exit;
  S := GetConfFileOfApp;
  if not FileExists(S) then
    with TFileStream.Create(S, fmCreate) do
      Free;
{$ifdef WINDOWS}
  CtOpenDoc(PChar(S));
  if Application.MessageBox(PChar(Format(srEzdmlConfirmEditedTextFmt, [fn])),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONINFORMATION) <> idOk then
    Exit;
{$else}
  RenameFile(S, S + '.txt');
  try
    CtOpenDoc(PChar(S + '.txt'));
    if Application.MessageBox(PChar(Format(srEzdmlConfirmEditedTextFmt, [fn])),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONINFORMATION) <> idOk then
      Exit;
  finally
    RenameFile(S + '.txt', S);
  end;
{$endif}
  LoadIni;
end;

procedure TfrmMainDml.actExecScriptExecute(Sender: TObject);
begin
  FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.actBatchOps.Execute;
end;

procedure TfrmMainDml.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMainDml.actExitWithoutSaveExecute(Sender: TObject);
begin
  FCtDataModelList.Clear;
  FFrameCtTableDef.Init(nil, True);
  Close;
end;

procedure TfrmMainDml.actExportModelExecute(Sender: TObject);
begin
  FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.actExportXls.Execute;
end;

procedure TfrmMainDml.actEzdmlHomePageExecute(Sender: TObject);
var
  S, V: string;
begin
  EzdmlMenuActExecuteEvt('Help_EzdmlHome');
  if not LangIsChinese then
    S := 'http://www.ezdml.com/index.html'
  else
    S := 'http://www.ezdml.com/index_cn.html';
  //S := 'http://blog.csdn.net/huzgd/';
  V := Format(srEzdmlConfirmOpenUrlFmt, [S]);

  if Application.MessageBox(PChar(V),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;

  CtOpenDoc(PChar(S)); { *Converted from ShellExecute* }
end;

procedure TfrmMainDml.actFindObjectsExecute(Sender: TObject);
begin
  // if not Assigned(Proc_ShowCtDmlSearch) then
  //   Exit;
  //Proc_ShowCtDmlSearch(FGlobeDataModelList, nil);
  FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.actFindObject.Execute;
end;

procedure TfrmMainDml.actGenerateCodeExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('Model_GenerateCode');
  CheckCanEditMeta;
  if not Assigned(frmCtGenCode) then
    frmCtGenCode := TfrmCtGenCode.Create(Self);
  frmCtGenCode.CtDataModelList := FCtDataModelList;

  if frmCtGenCode.ShowModal = mrOk then
  begin
  end;
end;

procedure TfrmMainDml.actGenerateDatabaseExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('Model_GenerateDatabase');
  CheckCanEditMeta;
  if not Assigned(frmCtGenSQL) then
    frmCtGenSQL := TfrmCtGenSQL.Create(Self);
  frmCtGenSQL.CtDataModelList := FCtDataModelList;
  frmCtGenSQL.SetWorkMode(0);

  if frmCtGenSQL.ShowModal = mrOk then
  begin
  end;
end;

procedure TfrmMainDml.actGoTbFilterExecute(Sender: TObject);
begin
  try
    FFrameCtTableDef.FFrameCtTableList.edtTbFilter.SetFocus;
  except
  end;
end;

procedure TfrmMainDml.actImportDatabaseExecute(Sender: TObject);
var
  C: integer;
begin
  EzdmlMenuActExecuteEvt('Model_ImportDatabase');
  CheckCanEditMeta;
  if not Assigned(FfrmMetaImport) then
    FfrmMetaImport := TfrmImportCtTable.Create(Self);
  TfrmImportCtTable(FfrmMetaImport).FCtMetaObjList :=
    Self.FCtDataModelList.CurDataModel.Tables;
  TfrmImportCtTable(FfrmMetaImport).SetWorkMode(0);
  C := Self.FCtDataModelList.CurDataModel.Tables.Count;
  if FfrmMetaImport.ShowModal = mrOk then
  begin
    //FFrameCtTableDef.Init(FCtDataModelList, False);
    FFrameCtTableDef.FFrameCtTableList.RefreshTheTree;
    FFrameCtTableDef.RefreshProp;
    if C = 0 then
      if Self.FCtDataModelList.CurDataModel.Tables.Count > 2 then
      begin
        FFrameCtTableDef.FFrameDMLGraph.RearrangeAll;
      end;
  end;
end;

procedure TfrmMainDml.actModelOptionsExecute(Sender: TObject);
begin
  FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.actColorStyles.Execute;
end;

procedure TfrmMainDml.actNewFileExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('File_New');
  CheckCanEditMeta;
  FCtDataModelList.Pack;
  if FCtDataModelList.Count = 0 then
    Exit;
  if Application.MessageBox(PChar(srEzdmlConfirmClearAll),
    PChar(srEzdmlNew), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;
  if FCurFileName <> '' then
  begin
    if not FSaveTempFileOnExit then
    begin
      PromptSaveFile;
    end
    else
      SaveDMLFastTmpFile;
  end;
  try
    FCtDataModelList.Clear;
    FFrameCtTableDef.Init(FCtDataModelList, True);
    FCtDataModelList.SeqCounter := 0;
    FCtDataModelList.GlobeList.SeqCounter := 0;
    if FCtDataModelList.CurDataModel = nil then
      Exit;
    FFrameCtTableDef.Init(FCtDataModelList, False);
    SetStatusBarMsg('');
    FCurFileName := '';
    FAutoSaveCounter := 0;
    FCurDmlFileName := '';
    TryLockFile('');
    CheckCaption;
    SaveIni;
  finally
    FCurFileName := '';
    FAutoSaveCounter := 0;
    FCurDmlFileName := '';
  end;
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('MAINFORM', 'FILE_NEW', '', Self, nil);
  end;
end;

procedure TfrmMainDml.actNewModelExecute(Sender: TObject);
begin
  FFrameCtTableDef.FFrameCtTableList.actNewModel.Execute;
end;

procedure TfrmMainDml.actNewTableExecute(Sender: TObject);
begin
  //FFrameCtTableDef.FFrameCtTableList.actNewTable.Execute;
  FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.actNewObj.Execute;
end;

procedure TfrmMainDml.actOpenFileExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('File_Open');
  if OpenDialog1.Execute then
  begin
    PromptOpenFile(OpenDialog1.FileName);
  end;
end;

procedure TfrmMainDml.actOpenLastFile1Execute(Sender: TObject);
var
  fn: string;
begin
  if FRecentFiles.Count > 0 then
    try
      fn := FRecentFiles[0];
      if FCurFileName = fn then
      begin
        case Application.MessageBox(PChar(ExtractFileName(fn) + ' ' +
            srEzdmlConfirmReOpenFile),
            PChar(srEzdmlOpenFile), MB_YESNOCANCEL or MB_ICONWARNING) of
          idYes:
          begin
            FCtDataModelList.Clear;
            FFrameCtTableDef.Init(FCtDataModelList, True);
          end
          else
            Exit;
        end;
        PromptOpenFile(fn, True);
      end
      else
        PromptOpenFile(fn);
    except
      Application.HandleException(Self);
    end;
end;

procedure TfrmMainDml.actSettingsExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('Tools_Settings');
  if (GetKeyState(VK_SHIFT) and $80) <> 0 then
  begin
    actEditSettingFile.Execute;
    Exit;
  end;
  if ShowEzdmlSettings then
  begin
    LoadIni;
  end;
end;

procedure TfrmMainDml.actShowDescTextExecute(Sender: TObject);
begin
  if FFrameCtTableDef.FFrameCtTableProp.Showing then
    FFrameCtTableDef.FFrameCtTableProp.actShowDescText.Execute;
end;

procedure TfrmMainDml.actToggleTableViewExecute(Sender: TObject);
var
  cto: TCtMetaObject;
begin
  cto := FFrameCtTableDef.GetCurObject;
  if cto is TCtDataModelGraph then
    cto := nil;
  if cto = nil then
    if FFrameCtTableDef.PanelDMLGraph.Visible then
      if FFrameCtTableDef.FFrameCtTableList.CtTableList <> nil then
        if FFrameCtTableDef.FFrameCtTableList.CtTableList.Count > 0 then
          cto := FFrameCtTableDef.FFrameCtTableList.CtTableList.Items[0];
  if cto = nil then
    Exit;
  FFrameCtTableDef.ShouldFocusUITick := GetTickCount64;
  if FFrameCtTableDef.PanelDMLGraph.Visible then
  begin
    if cto is TCtMetaField then
      cto := TCtMetaField(cto).OwnerTable;
    FFrameCtTableDef.FFrameCtTableList.FocusToTable(cto.Name);
  end
  else
  begin
    FFrameCtTableDef.FFrameCtTableList.actFindInGraph.Execute;
  end;
end;

procedure TfrmMainDml.actEditGlobalScriptExecute(Sender: TObject);
var
  S, fn: string;
begin
  fn := DEF_GSCRIPT_FN;
  S := GetFolderPathOfAppExe;
  S := FolderAddFileName(S, fn);
  if not FileExists(S) then
  begin
    if Application.MessageBox(PChar(Format(srEzdmlCreateGScriptTipFmt, [S])),
      PChar(Application.Title),
      MB_YESNOCANCEL or MB_ICONINFORMATION) <> idYes then
      Exit;
    with TStringList.Create do
      try
        Text := DEF_GSCRIPT_PS;
        SaveToFile(S);
      finally
        Free;
      end;
  end;

  fn := S;
  if not Assigned(scriptIdeEditor) then
    Application.CreateForm(TfrmScriptIDE, scriptIdeEditor);
  with scriptIdeEditor do
  begin
    DmlScInit(fn, nil, nil, nil);
    ed.ClearAll;
    DmlScLoadFromFile(fn);
    ed.Modified := False;
    FileModified := False;
    ActiveFile := fn;
    ShowModal;
  end;
  CheckReloadGlobalScript;
end;

procedure TfrmMainDml.actFullScreenExecute(Sender: TObject);
var
  mon: TMonitor;
begin
  EzdmlMenuActExecuteEvt('Model_FullScreen');
  actFullScreen.Checked := not actFullScreen.Checked;
  Self.FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.actFullScreen.Checked :=
    actFullScreen.Checked;
  {$IFDEF UNIX}
  if actFullScreen.Checked then
  begin
    ShowWindow(Handle, SW_SHOWFULLSCREEN);
    Self.FFrameCtTableDef.SplitterCttbTree.Visible := False;
    Self.FFrameCtTableDef.PanelCttbTree.Visible := False;
    {$IFNDEF DARWIN}
    Self.Menu := nil;
    {$ENDIF}
    Self.StatusBar1.Visible := False;
    Refresh;
    try
      Self.FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.DMLGraph.SetFocus;
    except
    end;
  end
  else
  begin
    ShowWindow(Handle, SW_SHOWNORMAL);
    ;
    {$IFNDEF DARWIN}
    Self.Menu := Self.MainMenu1;
    {$ENDIF}
    Self.FFrameCtTableDef.PanelCttbTree.Visible := True;
    Self.FFrameCtTableDef.SplitterCttbTree.Visible := True;
    Self.StatusBar1.Visible := True;
  end;
  {$ELSE}
  if actFullScreen.Checked then
  begin
    if WindowState <> wsNormal then
      WindowState := wsNormal;
    FFullScrnSaveBound := Self.BoundsRect;
    mon := Screen.MonitorFromRect(FFullScrnSaveBound);
    Self.FFrameCtTableDef.SplitterCttbTree.Visible := False;
    Self.FFrameCtTableDef.PanelCttbTree.Visible := False;
    Self.Menu := nil;
    //Self.FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.ToolBar1.Visible := False;
    Self.StatusBar1.Visible := False;
    Self.BorderStyle := bsNone;
    //Self.FormStyle := fsStayOnTop;
    Self.Left := mon.Left;
    Self.Top := mon.Top;
    Self.ClientWidth := mon.Width;
    Self.ClientHeight := mon.Height;
    Refresh;
    try
      Self.FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.DMLGraph.SetFocus;
    except
    end;
  end
  else
  begin
    //Self.FormStyle := fsNormal;
    Self.BorderStyle := bsSizeable;
    Self.Menu := Self.MainMenu1;
    Self.FFrameCtTableDef.PanelCttbTree.Visible := True;
    Self.FFrameCtTableDef.SplitterCttbTree.Visible := True;
    //Self.FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.ToolBar1.Visible := True;
    Self.StatusBar1.Visible := True;
    Self.BoundsRect := FFullScrnSaveBound;
  end;
  {$ENDIF}
end;

procedure TfrmMainDml.actGenerateLastCodeExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('Model_GenerateLastCode');
  CheckCanEditMeta;
  if not Assigned(frmCtGenCode) then
    frmCtGenCode := TfrmCtGenCode.Create(Self);
  frmCtGenCode.CtDataModelList := FCtDataModelList;
  frmCtGenCode.TimerAutoGen.Tag := 1;

  if frmCtGenCode.ShowModal = mrOk then
  begin
  end;
end;

procedure TfrmMainDml.actHttpServerExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('Tools_HttpServer');
  if not Assigned(FfrmHttpServer) then
    FfrmHttpServer := TfrmHttpSvr.Create(Self);
  FfrmHttpServer.ShowModal;
end;

procedure TfrmMainDml.actCharCodeToolExecute(Sender: TObject);
begin
  if FFindHexDlg = nil then
    FFindHexDlg := TfrmFindHex.Create(Self);
  FFindHexDlg.ShowModal;
end;

procedure TfrmMainDml.actCheckUpdatesExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('Help_CheckUpdates');
  CheckForUpdates(True);
  CheckShowNewVersionInfo(True);
end;

procedure TfrmMainDml.actImportFileExecute(Sender: TObject);
begin
  if OpenDialogImp.Execute then
  begin
    PromptOpenFile(OpenDialogImp.FileName);
  end;
end;

procedure TfrmMainDml.actQuickStartExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('Help_QuickStart');
  if frmHelpAbout = nil then
  begin
    frmHelpAbout := TfrmHelpAbout.Create(Self);
    frmHelpAbout.LoadFile('');
  end;
  frmHelpAbout.ShowModal;
end;

procedure TfrmMainDml.actRestoreDatabaseExecute(Sender: TObject);
begin
  if not Assigned(frmCtGenSQL) then
    frmCtGenSQL := TfrmCtGenSQL.Create(Self);
  frmCtGenSQL.MetaObjList := nil;
  frmCtGenSQL.SetWorkMode(1);
  if frmCtGenSQL.LoadDbBackFile then
    if frmCtGenSQL.ShowModal = mrOk then
    begin
    end;
end;

procedure TfrmMainDml.actSaveFileAsExecute(Sender: TObject);
var
  bSaveUCodeJson: boolean;
begin
  EzdmlMenuActExecuteEvt('File_SaveAs');
  CheckCanEditMeta;
  if FCurFileName <> '' then
    SaveDialog1.FileName := FCurFileName;
  if SaveDialog1.Execute then
  begin
    bSaveUCodeJson := stringsAsUtf8Encode;
    if (GetKeyState(VK_CONTROL) and $80) <> 0 then
      if LowerCase(ExtractFileExt(SaveDialog1.FileName)) = '.dmj' then
        case Application.MessageBox(PChar(srEzdmlDmjUnicodePropmt),
            PChar(Application.Title),
            MB_YESNOCANCEL or MB_ICONQUESTION) of
          idYes:
            stringsAsUtf8Encode := False;
          idNo:
            stringsAsUtf8Encode := True;
          else
            Exit;
        end;

    try
      TryLockFile(SaveDialog1.FileName);
      SaveToFile(SaveDialog1.FileName);
      TryLockFile(FCurFileName);
    finally
      stringsAsUtf8Encode := bSaveUCodeJson;
    end;

    FCurDmlFileName := FCurFileName;
    SetRecentFile(FCurFileName);
    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('MAINFORM', 'FILE_SAVE', FCurDmlFileName, Self, nil);
    end;
  end;
end;

procedure TfrmMainDml.actSaveFileExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('File_Save');
  CheckCanEditMeta;
  if FCurFileName <> '' then
  begin
    SaveToFile(FCurFileName);
    if Assigned(GProc_OnEzdmlCmdEvent) then
    begin
      GProc_OnEzdmlCmdEvent('MAINFORM', 'FILE_SAVE', FCurDmlFileName, Self, nil);
    end;
  end
  else
    actSaveFileAs.Execute;
end;

procedure TfrmMainDml.actShowFileInExplorerExecute(Sender: TObject);
var
  S, fn: string;
begin
  fn := FCurFileName;
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

procedure TfrmMainDml.actAboutEzdmlExecute(Sender: TObject);
begin
  EzdmlMenuActExecuteEvt('Help_About');
  with TfrmAbout.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmMainDml.actBackupDatabaseExecute(Sender: TObject);
begin
  if not Assigned(FfrmMetaImport) then
    FfrmMetaImport := TfrmImportCtTable.Create(Self);
  TfrmImportCtTable(FfrmMetaImport).FCtMetaObjList := nil;
  TfrmImportCtTable(FfrmMetaImport).SetWorkMode(1);
  if FfrmMetaImport.ShowModal = mrOk then
  begin
    //FFrameCtTableDef.Init(FCtDataModelList, False);
    FFrameCtTableDef.FFrameCtTableList.RefreshTheTree;
  end;
end;

procedure TfrmMainDml.actBrowseCustomToolsExecute(Sender: TObject);
var
  S, fn: string;
begin
  fn := GetFolderPathOfAppExe('CustomTools');
{$ifdef WINDOWS}
  S := 'Explorer "' + fn + '"';
  ShellCmd(S);
{$else}
  S := fn;
  CtOpenDoc(S);
{$endif}
end;

procedure TfrmMainDml.actBrowseScriptsExecute(Sender: TObject);
var
  S, fn: string;
begin
  fn := GetFolderPathOfAppExe('Templates');
{$ifdef WINDOWS}
  S := 'Explorer "' + fn + '"';
  ShellCmd(S);
{$else}
  S := ExtractFilePath(fn);
  CtOpenDoc(S);
{$endif}
end;

procedure TfrmMainDml.actShowTmprFileExecute(Sender: TObject);
var
  S, dir, fn: string;
begin
  fn := FCurFileName;
  if fn = '' then
    if FCtDataModelList.TableCount > 0 then
      fn := GetConfFileOfApp('.dmh');
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

procedure TfrmMainDml.actSqlToolExecute(Sender: TObject);
begin
  if FDmlSqlEditorForm = nil then
  begin
    FDmlSqlEditorForm := TfrmDmlSqlEditor.Create(Application);
    FDmlSqlEditorForm.PanelTbs.Tag := 1;
  end;
  FDmlSqlEditorForm.ShowModal;
end;

procedure TfrmMainDml.actTogglePhyViewExecute(Sender: TObject);
begin
  FFrameCtTableDef.FFrameDMLGraph.FFrameCtDML.actShowPhyView.Execute;
end;

procedure TfrmMainDml.CheckCaption;
begin
  if FCurFileName = '' then
  begin
    Caption := FOrginalCaption;
    Application.Title := srEzdmlAppTitle;
  end
  else
  begin
    Caption := FOrginalCaption + ' - ' + FCurFileName;
    Application.Title := srEzdmlAppTitle + ' - ' + ExtractFileName(FCurFileName);
  end;
end;

function TfrmMainDml.CheckCurFileDateSizeChanged: boolean;
var
  sz: integer;
  vFileDate: TDateTime;
begin
  Result := False;
  if FCurFileName = '' then
    Exit;
  if IsTmpFile(FCurFileName) then
    Exit;
  if (FCurFileSize = 0) and (FCurFileDate = 0) then
    Exit;
  if not FileExists(FCurFileName) then
    Exit;

  sz := GetDocFileSize(FCurFileName);
  if sz <> Self.FCurFileSize then
  begin
    Result := True;
    Exit;
  end;

  if GetFileAges(FCurFileName, vFileDate) then
  begin
    if Abs(vFileDate - FCurFileDate) > 2 / 24 / 60 / 60 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;


procedure TfrmMainDml.PromptOpenFile(fn: string; bDisableTmpFiles: boolean);
var
  vOldMds: TCtDataModelGraphList;
  I: integer;
begin
  if FFileWorking then
    Exit;

  if not FileExists(fn) then
  begin
    RemoveRecentFile(fn);
    raise Exception.Create(Format(srEzdmlFileNotFoundFmt, [fn]));
  end;

  CheckCanEditMeta;

  TryLockFile(fn);
  FCtDataModelList.Pack;
  vOldMds := nil;
  try
    if FCtDataModelList.TableCount > 0 then
      case Application.MessageBox(PChar(ExtractFileName(fn) + ' ' +
          srEzdmlConfirmClearOnOpen),
          PChar(srEzdmlOpenFile), MB_YESNOCANCEL or MB_ICONWARNING) of
        idYes:
          if FCurFileName <> '' then
          begin
            if not FSaveTempFileOnExit then
            begin
              PromptSaveFile;
            end
            else
              SaveDMLFastTmpFile;
          end;
        idNo:
        begin
          vOldMds := TCtDataModelGraphList.Create;
          vOldMds.AssignFrom(FCtDataModelList);
        end
        else
          Exit;
      end;

    if LowerCase(ExtractFileExt(fn)) = '.pdm' then
    begin
      ImportFromFile(fn);
      Exit;
    end;
    if not IsTmpFile(fn) and not bDisableTmpFiles then
    begin
      if TryLoadFromTmpFile(fn) then
      begin
      end
      else
        LoadFromFile(fn);
    end
    else
      LoadFromFile(fn);
    FCurDmlFileName := fn;

    if Assigned(vOldMds) then
    begin
      for I := 0 to vOldMds.Count - 1 do
        FCtDataModelList.NewModelItem.AssignFrom(vOldMds[I]);
      FFrameCtTableDef.Init(FCtDataModelList, False);
    end;

    SetRecentFile(fn);
  finally
    if Assigned(vOldMds) then
      vOldMds.Free;
  end;
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('MAINFORM', 'FILE_OPEN', FCurDmlFileName, Self, nil);
  end;
end;

procedure TfrmMainDml.PromptSaveFile;
begin
  case Application.MessageBox(PChar(srEzdmlPromptSaveFile), PChar(Application.Title),
      MB_YESNOCANCEL or MB_ICONWARNING) of
    idYes: ;
    idNo:
      Exit;
    else
      Abort;
  end;

  if (IsTmpFile(FCurFileName) or (FCurFileName = '')) then
  begin
    actSaveFileAs.Execute;
    if (IsTmpFile(FCurFileName) or (FCurFileName = '')) then
    begin
      Abort;
    end;
  end
  else
    SaveToFile(FCurFileName);
end;

procedure TfrmMainDml.ReCreateCustomToolsMenu;

  function GetCustomToolsDir: string;
  begin
    Result := GetFolderPathOfAppExe('CustomTools');
  end;

  function GetCustomToolsFiles: string;
  var
    Sr: TSearchRec;
    AFolderName: string;
  begin
    Result := '';
    AFolderName := GetCustomToolsDir;
    if not DirectoryExists(AFolderName) then
      Exit;
    if FindFirst(FolderAddFileName(AFolderName, '*.*'),
      SysUtils.faAnyFile,
      //SysUtils.faAnyFile + SysUtils.faHidden + SysUtils.faSysFile + SysUtils.faDirectory + SysUtils.faArchive,
      Sr) = 0 then
      try
        repeat
          if (Sr.Name = '.') or (Sr.Name = '..') then
            Continue;
          if (Sr.Attr and SysUtils.faDirectory) <> 0 then
            Continue
          else
            Result := Result + SR.Name + #13#10;
        until FindNext(Sr) <> 0;
      finally
        FindClose(Sr);
      end;
    Result := Trim(Result);
  end;

var
  mn: TMenuItem;
  I: integer;
  fn: string;
begin
  if FReservedToolsMenuCount = 0 then
    FReservedToolsMenuCount := MnTools1.Count;
  FCustomTools.Text := GetCustomToolsFiles;

  for I := MnTools1.Count - 1 downto FReservedToolsMenuCount do
    MnTools1.Items[I].Free;
  for I := 0 to FCustomTools.Count - 1 do
  begin
    fn := FCustomTools[I];
    mn := TMenuItem.Create(Self);
    mn.Caption := ChangeFileExt(fn, '');
    mn.Hint := fn;
    mn.Tag := I;
    mn.OnClick := _OnCustomToolsClick;
    if I < 8 then
    begin
      mn.ShortCut := TextToShortCut('Alt+' + IntToStr(I + 2));
    end;
    MnTools1.Add(mn);
  end;
end;

procedure TfrmMainDml.RecreateRecentMn;
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

procedure TfrmMainDml.RememberFileDateSize;
var
  vFileDate: TDateTime;
begin
  if FCurFileName = '' then
    Exit;
  if IsTmpFile(FCurFileName) then
    Exit;
  FCurFileSize := GetDocFileSize(FCurFileName);
  FCurFileDate := Now;
  if GetFileAges(FCurFileName, vFileDate) then
    FCurFileDate := vFileDate;
end;

procedure TfrmMainDml.RemoveRecentFile(fn: string);
var
  I: integer;
  S: string;
begin
  S := LowerCase(fn);
  for I := 0 to FRecentFiles.Count - 1 do
    if LowerCase(FRecentFiles[I]) = S then
    begin
      FRecentFiles.Delete(I);
      SaveIni;
      RecreateRecentMn;
      Exit;
    end;
end;

initialization
  G_CreateSeqForOracle := False;
  G_GenSqlSketchMode := False;
  G_BackupBeforeAlterColumn := False;
  G_QuotReservedNames := True;
  G_QuotAllNames := False;
  G_LogicNamesForTableData := False;
  G_MaxRowCountForTableData := 25;
  G_WriteConstraintToDescribeStr := True;
  G_FieldGridShowLines := False;
  G_AddColCommentToCreateTbSql := True;
  G_CreateIndexForForeignkey := False;
  G_EnableCustomPropUI := False;       
  G_EnableAdvTbProp := False;
  G_TableDialogViewModeByDefault := False;
  G_CheckForUpdates := True;

  Proc_CheckStringMaxLen := CheckStringMaxLen;
  Proc_CheckCustDataTypeReplaces := CheckCustDataTypeReplaces;
  Proc_OnExecAppCmd := EzdmlExecAppCmd;
  Proc_CreateCtObjSerialer := EzdmlCreateCtObjSerialer;
  Proc_GetSelectedCtMetaObj := ezdml_GetSelectedCtMetaObj;
  Proc_JsonPropProc := Ezdml_JsonPropProc;
  Proc_CtObjToJsonStr := CtObjToJsonStr; //added by huz 20210214
  Proc_ReadCtObjFromJsonStr := ReadCtObjFromJsonStr;
  Proc_GenDemoData := CtGenTestData;
  Proc_GetTableDemoDataJson := CtGenTableDemoDataJson;

  InitCtChnNames;

finalization
  if Assigned(G_Reserved_Keywords) then
    FreeAndNil(G_Reserved_Keywords);

end.
