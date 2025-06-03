unit DmlScriptPublic;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, ExtDlgs,
  Variants, DB, Menus, CtMetaTable, CTMetaData, CtObjSerialer, Process;

type

  { TDmlBaseScriptor }

  TDmlBaseScriptor = class
  protected
  private
  protected
    //FUTF8Needed: Boolean;
    FScriptType: string;
    FActiveFile: string; 
    FCurOut: TStrings;
    FStdOutPut: TStrings;
    function GetActiveFile: string; virtual;
    procedure SetActiveFile(const Value: string); virtual;
    function GetCurOut: TStrings; virtual;
    procedure SetCurOut(AValue: TStrings); virtual;
    function GetStdOutPut: TStrings; virtual;
    procedure SetStdOutPut(const Value: TStrings); virtual;
    procedure PrintVar(const AVal: variant); virtual;

  published
  public
    CurCtObj: TCtMetaObject;
    CurTable: TCtMetaTable;
    CurField: TCtMetaField;
    CtrlList: TObject;

    constructor Create; virtual;
    destructor Destroy; override;

    function _OnNeedFile(Sender: TObject; const OrginFileName: string;
      var FileName, Output: string): boolean; virtual;

    function IsSPRule(const AScript: string): boolean; virtual;
    function PreConvertSP(const AScript: string): string; virtual;
    function HasIncludes(const AScript: string): boolean; virtual;
    function ProcessIncludes(const AScript: string): string; virtual;

    procedure Init(const ARule: string; ACtObj: TCtMetaObject;
      AResout: TStrings; ACtrlList: TObject); virtual;
    function Compile(ARule, AScript: string): boolean; virtual;
    procedure Exec(ARule, AScript: string); virtual;
    procedure StopAll; virtual;

    procedure RunDmlScript(AFileName, AScript: string); virtual;

    property CurOut: TStrings read GetCurOut write SetCurOut;
    property StdOutPut: TStrings read GetStdOutPut write SetStdOutPut;
    property ActiveFile: string read GetActiveFile write SetActiveFile;
    property ScriptType: string read FScriptType;
    //property UTF8Needed: Boolean read FUTF8Needed;
  end;

  TDmlBaseScriptorClass = class of TDmlBaseScriptor;


  //全局参数
  TGlobeUrlParam = record
    Name: string;
    Value: string;
    Obj: TObject;
  end;
  PGlobeUrlParam = ^TGlobeUrlParam;
  //全局参数列表
  TGlobeUrlParams = class(TThreadList)
  public
    destructor Destroy; override;
    function GetParamValue(AName: string): string;
    function GetParamObject(AName: string): TObject;
    procedure AddOrModifyParam(AName, AValue: string; AObject: TObject);
    procedure DeleteParam(AName: string);
    procedure ClearParams;
  end;

function GetDmlScriptType(fn: string): string;
function CreateScriptForFile(fn: string): TDmlBaseScriptor;

function GetDmlScriptDir: string;
function PreConvertPSPEx(ARule, AScType: string): string;

function IsEnglish: boolean;

function CurDbType: string;
function ExecCtDbLogon(DbType, database, username, password: string;
  bSavePwd, bAutoLogin, bShowDialog: boolean; opt: string): string;
function ExecSql(sql, opts: string): TDataSet;
function ExecAppCmd(Cmd, param1, param2: string): string;
function GetEnv(const AName: string): string;
function GetSelectedCtMetaObj: TCtMetaObject;
function CtObjToJsonStr(ACtObj: TCtMetaObject; bFullProps, bSkipChild: Boolean): string;
function ReadCtObjFromJsonStr(ACtObj: TCtMetaObject; AJsonStr: string): boolean;
function GetGParamValue(AName: string): string;
function GetGParamObject(AName: string): TObject;
procedure SetGParamValue(AName, AValue: string);
procedure SetGParamObject(AName: string; AObject: TObject);
procedure SetGParamValueEx(AName, AValue: string; AObject: TObject);
procedure ShellOpen(FileName, Parameters, Directory: string);
function OpenFileDialog(const ATitle, AFilter, AFileName: string;
  bMulti: boolean): string;
function OpenPicDialog(const ATitle, AFilter, AFileName: string;
  bMulti: boolean): string;
procedure CtScript_Writeln(const s: string);
function CtScript_Readln(const question: string): string;
procedure CtScript_RaiseErr(const msg: string);
procedure CtScript_Abort;
procedure CtScript_WriteLog(const s: string);
function GetPointerByObj(v: TObject): integer;
function GetObjByPointer(p: integer): TObject;
function Send_Msg(AHandle: integer; Msg: integer; wParam: integer;
  lParam: integer): integer;
procedure MsgBox(const Msg: variant);
function Confirm(const Msg: variant): boolean;
function Prompt(const Msg: variant; AInitVal: string): string;
procedure Toast(const Msg: variant; closeTimeMs: integer);
function Choice(const Msg: variant; items: string; AInitVal: string): string;
procedure CtScript_RaiseErrOut(const msg: string);
procedure CtScript_AbortOut;
function CtCopyStream(src, dst: TStream; Count: longint): longint;
function EscapeXml(const XML: variant): string;
function CodeTextForLang(txt, lan: string): string;
//function RunCmd(cmd: string; timeout: integer): string;
function GetClassName(v: TObject): string;

function CreateComponent(AOwner: TComponent; const AClassName: string): TComponent;
procedure ReadDfmComponents(ARoot: TComponent; const Dfm: string);
function FindChildComp(AOwner: TComponent; const AName: string): TComponent;
function FindCompPropObj(AInstance: TComponent; var AKey: string): TObject;
function GetCompPropValue(AComponent: TComponent; AKey: string): string;
procedure SetCompPropValue(AComponent: TComponent; AKey, sValue: string);
function GetCompPropObject(AComponent: TComponent; AKey: string): TObject;
procedure SetCompPropObject(AComponent: TComponent; AKey: string; sValue: TObject);
function CurrentTimeMillis: int64;


function GenData(ARule: string): string;
function GenDataEx(AField: TCtMetaField; ARule, ADef: string; ARowIndex: integer;
  AOpt: string; ADataSet: TDataSet): string;


var
  FCtscriptStdOutPut: TStrings;
  FOutErrorMsg: string;
  FCurDmlFileName: string;
  Proc_OnExecAppCmd: function(Cmd, param1, param2: string): string;
  FGlobeUrlParams: TGlobeUrlParams; //全局URL参数
  Proc_GetSelectedCtMetaObj: function: TCtMetaObject;
  DmlPasScriptorClass: TDmlBaseScriptorClass;
  {$ifndef EZDML_LITE}
  DmlJsScriptorClass: TDmlBaseScriptorClass; 
  {$endif}


implementation

uses
  PvtInput,
  WindowFuncs,   
  {$ifndef EZDML_LITE}
  DmlScriptControl,
  {$endif}
  UCNSpell,
  dmlstrs,
  TypInfo,
  CtObjJsonSerial,
  wToast,

  {xmldom, XMLIntf, Tabs, msxmldom, XMLDoc, OleCtrls,
  SHDocVw, dbcgrids,} DBCtrls,
  DBGrids, {OleCtnrs, MPlayer,} ExtCtrls, ComCtrls, ToolWin, ImgList,
  ValEdit, {AppEvnts,} StdCtrls, CheckLst, Grids,
  MaskEdit, Buttons, ActnList, CtSysInfo;

function GetDmlScriptType(fn: string): string;
var
  ext: string;
begin
  ext := LowerCase(ExtractFileExt(fn));      
  {$ifndef EZDML_LITE}
  if ext = '.js' then
    Result := 'js'
  else if ext = '.js_' then
    Result := 'js'
  else if ext = '.js~' then
    Result := 'js'
  else
  {$endif}
  if ext = '.pas' then
    Result := 'pas'
  else if ext = '.ps' then
    Result := 'pas'
  else if ext = '.ps_' then
    Result := 'pas'
  else if ext = '.pas~' then
    Result := 'pas'
  else
    Result := '';
end;

function CreateScriptForFile(fn: string): TDmlBaseScriptor;
var
  t: string;
begin
  t := GetDmlScriptType(fn);
  if (t = 'pas') and Assigned(DmlPasScriptorClass) then
    Result := DmlPasScriptorClass.Create
  {$ifndef EZDML_LITE}
  else if (t = 'js') and Assigned(DmlJsScriptorClass) then
    Result := DmlJsScriptorClass.Create
  {$endif}
  else
    raise Exception.Create('Can not create scriptor for file ' + fn);
end;

function GetDmlScriptDir: string;
begin
  Result := GetFolderPathOfAppExe('Templates');
end;

function PreConvertPSPEx(ARule, AScType: string): string;
var
  I, L, C, p0, p1, p2: integer;
  S, tk, te, prt: string;
  ress: TStringList;
  bDollar: boolean;

  procedure SearchForNextTk;
  begin
    p0 := I;
    p1 := 0;
    p2 := 0;
    tk := '';
    te := '';
    while I <= L - 1 do
    begin
      if (ARule[I] = '<') and (ARule[I + 1] = '%') then
      begin
        p1 := I;
        tk := '<%';
        te := '%>';
        I := I + 2;
        while I <= L - 1 do
        begin
          if (ARule[I] = '%') and (ARule[I + 1] = '>') then
          begin
            p2 := I + 2;
            I := I + 2;
            Break;
          end;
          Inc(I);
        end;
        if p2 = 0 then
          p2 := L + 1;
        Break;
      end
      else if bDollar and (ARule[I] = '$') and (ARule[I + 1] = '{') then
      begin
        p1 := I;
        tk := '${';
        te := '}';
        I := I + 2;
        while I <= L do
        begin
          if (ARule[I] = '}') then
          begin
            p2 := I + 1;
            I := I + 1;
            Break;
          end;
          Inc(I);
        end;
        if p2 = 0 then
          p2 := L + 1;
        Break;
      end   
      else if not bDollar and (ARule[I] = '@') and (ARule[I + 1] = '[') then
      begin
        p1 := I;
        tk := '@[';
        te := ']';
        I := I + 2;
        while I <= L do
        begin
          if (ARule[I] = ']') then
          begin
            p2 := I + 1;
            I := I + 1;
            Break;
          end;
          Inc(I);
        end;
        if p2 = 0 then
          p2 := L + 1;
        Break;
      end
      else if (I < L - 4) and (ARule[I] = #10) and (ARule[I + 1] = '[') and
        (ARule[I + 2] = '[') and (ARule[I + 3] = '[') and (ARule[I + 4] in [#13, #10]) then
      begin
        p1 := I + 1;
        tk := '[[[';
        te := ']]]';   
        I := I + 4;
        while I <= L - 4 do
        begin
          if (ARule[I] = #10) and (ARule[I + 1] = ']') and (ARule[I + 2] = ']') and
            (ARule[I + 3] = ']') and (ARule[I + 4] in [#13, #10]) then
          begin          
            p2 := I + 4;
            if (ARule[I + 4] = #13) and (I <= L - 6) and (ARule[I + 5] = #10) then
              I := I + 6
            else
              I := I + 5;
            Break;
          end;
          Inc(I);
        end;
        if p2 = 0 then
          p2 := L + 1;
        Break;
      end;
      Inc(I);
    end;
  end;

begin
  Result := '';
  bDollar := Pos('//[NO_DOLLAR_EXPRESSION]//', ARule)=0;
  ARule := Trim(ARule);
  L := Length(ARule);
  tk := '';
  I := 1;
  prt := 'PrintVar';
  if AScType = 'JAVA' then
    prt := '_printVar';
  while I <= L - 1 do
  begin
    SearchForNextTk;
    if p1 > 0 then
    begin
      if p1 > p0 then
      begin
        S := Copy(ARule, p0, p1 - p0);
        S := CopyTextAsLan(S, AScType);
        S := Copy(S, 1, Length(S) - 1);
        Result := Result + prt + '(' + S + ');';
        Result := Result + #13#10;
      end;

      if p2 = 0 then
        p2 := L + 1;
      S := Copy(ARule, p1 + Length(tk), p2 - p1 - Length(tk) - Length(te));
      if tk = '<%' then
      begin
        Result := Result + S;
      end
      else if tk = '[[[' then
      begin
        if Length(S)>2 then
        begin
          if (S[1]=#13) and (S[2]=#10) then
            Delete(S, 1, 2)
          else if S[1]=#10 then
            Delete(S, 1, 1);
        end;
        S := CopyTextAsLan(S, AScType);
        S := Copy(S, 1, Length(S) - 1);
        Result := Result + prt + '(' + S + ');';
        Result := Result + #13#10;
      end
      else
        Result := Result + prt + '(' + S + ');';
      Result := Result + #13#10;
    end
    else
    if L >= p0 then
    begin
      S := Copy(ARule, p0, L - p0 + 1);
      S := CopyTextAsLan(S, AScType);
      S := Copy(S, 1, Length(S) - 1);
      Result := Result + prt + '(' + S + ');';
      Result := Result + #13#10;
    end;
  end;
  Result := Result;


  if AScType = 'DELPHI' then
  begin
    ress := TStringList.Create;
    try
      ress.Text := Result;
      C := 0;
      for I := 0 to ress.Count - 1 do
      begin
        if LowerCase(Copy(trim(ress[I]), 1, 5)) = 'gvar ' then
          if I <> C then
          begin
            S := Trim(ress[I]);
            ress.Delete(I);
            S := Copy(S, 2, Length(S));
            ress.Insert(C, S);
            C := C + 1;
          end;
      end;

      Result := ress.Text;
    finally
      ress.Free;
    end;
  end;
end;


function IsEnglish: boolean;
begin
  Result := LangIsEnglish;
end;


procedure RegClasses(const AClasses: array of TPersistentClass);
begin
  RegisterClasses(AClasses);
end;

procedure RegClassesForDmlScript;
begin

  RegClasses([
    TAction, TActionList,
    TBevel, TBitBtn, TButton, TCheckBox, TCheckListBox,
    TColorDialog, TComboBox, TControlBar, TCoolBar, TDataSource, TDBCheckBox,
    TDBComboBox, TDBEdit, TDBGrid, TDBImage, TDBListBox, TDBLookupComboBox,
    TDBLookupListBox, TDBMemo,
    TDBNavigator, TDBRadioGroup, TDBText, TDrawGrid, TEdit, TFontDialog, TForm, TFrame,
    TGroupBox, THeaderControl, TImage, TImageList, TLabel, TLabeledEdit,
    TListBox, TListView, TMainMenu, TMaskEdit, TMemo, TMenuItem, TOpenDialog,
    TOpenPictureDialog, TPageControl, TPaintBox,
    TPanel, TPopupMenu, TProgressBar, TRadioButton, TRadioGroup,
    TSaveDialog, TSavePictureDialog, TScrollBar, TScrollBox, TShape,
    TSpeedButton, TSplitter,
    TStaticText, TStatusBar, TStringGrid, TTabControl, TTabSheet,
    TTimer, TToolBar, TToolButton, TTrackBar,
    TTreeView, TUpDown, TValueListEditor
    ]);

  RegClasses([
    TStringField, { ftString }
    TSmallintField, { ftSmallint }
    TIntegerField, { ftInteger }
    TWordField, { ftWord }
    TBooleanField, { ftBoolean }
    TFloatField, { ftFloat }
    TCurrencyField, { ftCurrency }
    TBCDField, { ftBCD }
    TDateField, { ftDate }
    TTimeField, { ftTime }
    TDateTimeField, { ftDateTime }
    TBytesField, { ftBytes }
    TVarBytesField, { ftVarBytes }
    TAutoIncField, { ftAutoInc }
    TBlobField, { ftBlob }
    TMemoField, { ftMemo }
    TGraphicField, { ftGraphic }
    TWideStringField, { ftWideString }
    TLargeIntField, { ftLargeInt }
    TVariantField, { ftVariant }
    TGuidField, { ftGuid }
    TFMTBcdField
    ]);
end;

function CurDbType: string;
begin
  Result := '';
  if Assigned(Proc_GetLastCtDbType) then
    Result := Proc_GetLastCtDbType;
end;

function ExecCtDbLogon(DbType, database, username, password: string;
  bSavePwd, bAutoLogin, bShowDialog: boolean; opt: string): string;
begin
  Result := '';
  if Assigned(Proc_ExecCtDbLogon) then
    Result := Proc_ExecCtDbLogon(DbType, database, username, password,
      bSavePwd, bAutoLogin, bShowDialog, opt);
end;


function ExecSql(sql, opts: string): TDataSet;
begin
  Result := nil;
  if Assigned(Proc_ExecSql) then
    Result := Proc_ExecSql(sql, opts);
end;

function ExecAppCmd(Cmd, param1, param2: string): string;
begin
  Result := '';
  if Assigned(Proc_OnExecAppCmd) then
    Result := Proc_OnExecAppCmd(cmd, param1, param2);
end;

function GetEnv(const AName: string): string;
begin
  Result := '';
  if AName = 'WINUSER' then
    Result := 'CurUserName'
  else if AName = 'COMPUTER' then
    Result := GetThisComputerName//'ComputerName'
  else if AName = 'IP' then
    Result := 'GetLocalIP'
  else if AName = 'LANGUAGE' then
    Result := GetEzdmlLang
  else if AName = 'DMLFILEPATH' then
    Result := FCurDmlFileName
  else if AName = 'DMLFILETITLE' then
    Result := ChangeFileExt(ExtractFileName(FCurDmlFileName), '')
  else if AName = 'CMDLINE' then
    Result := 'GetCommandLine'
  else if AName = 'APPFOLDER' then
    Result := GetFolderPathOfAppExe('')
  else if AName = 'TEMPFOLDER' then
    Result := GetAppDefTempPath('')
  else if AName = 'CONFIGFILE' then
    Result := GetConfFileOfApp()
  else if AName = 'SCRIPTFOLDER' then
    Result := GetFolderPathOfAppExe('Templates')
  else if AName = 'ARCHBITS' then
    Result := '64'
  else if AName = 'SYSTEMTYPE' then
  begin
    Result := '';
  {$IFDEF Windows}
    Result := 'WINDOWS';
  {$ELSE}
  {$IFDEF Darwin}
    Result := 'DARWIN';
  {$ELSE}
    Result := 'UNIX';
  {$ENDIF}
  {$ENDIF}
  end
  else
    Result := GetEnvVar(AName, Result);
end;

function GetSelectedCtMetaObj: TCtMetaObject;
begin
  Result := nil;
  if Assigned(Proc_GetSelectedCtMetaObj) then
    Result := Proc_GetSelectedCtMetaObj();
end;

function CtObjToJsonStr(ACtObj: TCtMetaObject; bFullProps, bSkipChild: Boolean): string;
var
  ose: TCtObjMemJsonSerialer;
begin
  Result := '';
  if ACtObj = nil then
    Exit;

  ose := TCtObjMemJsonSerialer.Create(False);
  try      
    ose.WriteEmptyVals := bFullProps;
    ose.SkipChildren:=bSkipChild;
    ose.RootName := ACtObj.ClassName;
    ACtObj.SaveToSerialer(ose);
    ose.EndJsonWrite;

    ose.Stream.Seek(0, soFromBeginning);
    SetLength(Result, ose.Stream.Size);
    ose.Stream.Read(PChar(Result)^, ose.Stream.Size);
  finally
    ose.Free;
  end;
end;


function ReadCtObjFromJsonStr(ACtObj: TCtMetaObject; AJsonStr: string): boolean;
var
  ose: TCtObjMemJsonSerialer;
begin
  Result := False;
  if ACtObj = nil then
    Exit;
  if AJsonStr = '' then
    Exit;

  ose := TCtObjMemJsonSerialer.Create(True);
  try
    ose.RootName := ACtObj.ClassName;
    ose.Stream.Write(PChar(AJSonStr)^, Length(AJsonStr));
    ose.Stream.Seek(0, soFromBeginning);
    ACtObj.LoadFromSerialer(ose);

    Result := True;
  finally
    ose.Free;
  end;
end;

function GetGParamValue(AName: string): string;
begin
  Result := FGlobeUrlParams.GetParamValue(AName);
end;

function GetGParamObject(AName: string): TObject;
begin
  Result := FGlobeUrlParams.GetParamObject(AName);
end;

procedure SetGParamValue(AName, AValue: string);
begin
  FGlobeUrlParams.AddOrModifyParam(AName, AValue, nil);
end;

procedure SetGParamObject(AName: string; AObject: TObject);
begin
  FGlobeUrlParams.AddOrModifyParam(AName, '', AObject);
end;

procedure SetGParamValueEx(AName, AValue: string; AObject: TObject);
begin
  FGlobeUrlParams.AddOrModifyParam(AName, AValue, AObject);
end;

procedure ShellOpen(FileName, Parameters, Directory: string);
begin
  CtOpenDoc(PChar(FileName)); { *Converted from ShellExecute* }
end;


function OpenFileDialog(const ATitle, AFilter, AFileName: string;
  bMulti: boolean): string;
var
  I: integer;
begin
  with TOpenDialog.Create(nil) do
    try
      if ATitle <> '' then
        Title := ATitle;
      if AFilter <> '' then
        Filter := AFilter;
      FileName := AFileName;
      if bMulti then
        Options := Options + [ofAllowMultiSelect]
      else
        Options := Options - [ofAllowMultiSelect];
      if Execute then
      begin
        if not bMulti then
          Result := FileName
        else
        begin
          Result := '';
          for I := 0 to Files.Count - 1 do
            if I = 0 then
              Result := Result + Files[I]
            else
              Result := Result + #13#10 + Files[I];
        end;
      end
      else
        Result := '';
    finally
      Free;
    end;
end;

function OpenPicDialog(const ATitle, AFilter, AFileName: string;
  bMulti: boolean): string;
var
  I: integer;
begin
  with TOpenPictureDialog.Create(nil) do
    try
      if ATitle <> '' then
        Title := ATitle;
      if AFilter <> '' then
        Filter := AFilter;
      FileName := AFileName;
      if bMulti then
        Options := Options + [ofAllowMultiSelect]
      else
        Options := Options - [ofAllowMultiSelect];
      if Execute then
      begin
        if not bMulti then
          Result := FileName
        else
        begin
          Result := '';
          for I := 0 to Files.Count - 1 do
            if I = 0 then
              Result := Result + Files[I]
            else
              Result := Result + #13#10 + Files[I];
        end;
      end
      else
        Result := '';
    finally
      Free;
    end;
end;

procedure CtScript_Writeln(const s: string);
begin
  FCtscriptStdOutPut.Add(s);
end;

function CtScript_Readln(const question: string): string;
begin
  Result := InputBox(question, '', '');
end;

procedure CtScript_RaiseErr(const msg: string);
begin
  raise Exception.Create(msg);
end;

procedure CtScript_Abort;
begin
  Abort;
end;

procedure CtScript_WriteLog(const s: string);
var
  fn, dt: string;
begin
  fn := GetConfFileOfApp('.log');
  dt := DateTimeToStr(Now);
  WindowFuncs.WriteMsgToFile(fn, dt + ' ' + s + #13#10);
end;

function GetPointerByObj(v: TObject): integer;
begin
  Result := integer(v);
end;

function GetObjByPointer(p: integer): TObject;
begin
  Result := TObject(p);
end;


function Send_Msg(AHandle: integer; Msg: integer; wParam: integer;
  lParam: integer): integer;
begin
  Result := SendMessage(AHandle, Msg, wParam, lParam);
end;

procedure MsgBox(const Msg: variant);
var
  s: string;
begin
  s := 'null';
  if not VarIsNull(Msg) then
    s := VarToStr(Msg);
  Application.MessageBox(PChar(s), PChar(Application.Title), MB_OK or
    MB_ICONINFORMATION);
end;

function Confirm(const Msg: variant): boolean;
var
  s: string;
begin
  s := 'null';
  if not VarIsNull(Msg) then
    s := VarToStr(Msg);
  if Application.MessageBox(PChar(s), PChar(Application.Title),
    MB_OKCANCEL or MB_ICONQUESTION) = idOk then
    Result := True
  else
    Result := False;
end;

function Prompt(const Msg: variant; AInitVal: string): string;
var
  s: string;
begin
  s := 'null';
  if not VarIsNull(Msg) then
    s := VarToStr(Msg);
  Result := PvtInputBox(Application.Title, S, AInitVal);
end;

procedure Toast(const Msg: variant; closeTimeMs: integer);
begin
  ShowToastForm(Application.MainForm, msg, Application.Title, closeTimeMs);
end;

function Choice(const Msg: variant; items: string; AInitVal: string): string;
var
  S: string;
begin
  Result := '';
  S := AInitVal;
  if PvtChoiceQuery(Application.Title, Msg, S, items, '') then
    Result := S;
end;

procedure CtScript_RaiseErrOut(const msg: string);
begin
  FOutErrorMsg := msg;
  raise Exception.Create(msg);
end;

procedure CtScript_AbortOut;
begin
  FOutErrorMsg := '[ABORT]';
  Abort;
end;

function CtCopyStream(src, dst: TStream; Count: longint): longint;
begin
  Result := dst.CopyFrom(src, Count);
end;

function EscapeXml(const XML: variant): string;
begin
  Result := 'null';
  if not VarIsNull(XML) then
    Result := VarToStr(XML);
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
  Result := StringReplace(Result, '''', '&apos;', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
end;

function CodeTextForLang(txt, lan: string): string;
var
  L: Integer;
begin
  if (lan='') then
  begin
    Result :=txt;
    Exit;
  end;
  Result := CopyTextAsLan(txt, lan);
  L := Length(Result);
  if (L>0) and (Result<>txt) then
    if Result[L]=';' then
      Delete(result, L, 1);
end;

function GetClassName(v: TObject): string;
begin
  if v = nil then
    Result := ''
  else
    Result := v.ClassName;
end;

function CreateComponent(AOwner: TComponent; const AClassName: string): TComponent;
var
  cls: TClass;
  res: TObject;
begin
  Result := nil;
  if AClassName = '' then
    Exit;
  cls := GetClass(AClassName);
  if cls = nil then
    Exit;
  res := cls.NewInstance;
  if res is TComponent then
  begin
    Result := TComponent(res);
    Result.Create(AOwner);
  end
  else
    raise Exception.Create('CreateComponent failed: ' + AClassName +
      ' is not a TComponent Class');
end;

procedure ReadDfmComponents(ARoot: TComponent; const Dfm: string);
var
  StrStream: TStringStream;
  BinStream: TMemoryStream;
  Reader: TReader;
  S: string;
begin
  if ARoot = nil then
    raise Exception.Create('ReadDfmComponents: Root component not specified');
  if Dfm = '' then
    Exit;
  S := Dfm;
  if Pos('[FILE]', S) = 1 then
  begin
    S := Copy(S, 7, Length(S));
    with TStringList.Create do
      try
        LoadFromFile(S);
        S := Text;
      finally
        Free;
      end;
  end;

  ARoot.DestroyComponents;
  StrStream := TStringStream.Create(S);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Reader := TReader.Create(BinStream, 4096);
      try
        //Reader.OnFindComponentClass := _FindComponentClassEvent;
        Reader.ReadRootComponent(ARoot);
      finally
        Reader.Free;
      end;
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

function FindChildComp(AOwner: TComponent; const AName: string): TComponent;

  function FindChild(AComp: TComponent): TComponent;
  var
    I: integer;
  begin
    Result := nil;
    if AComp = nil then
      Exit;
    for I := 0 to AComp.ComponentCount - 1 do
      if SameText(AComp.Components[I].Name, AName) then
      begin
        Result := AComp.Components[I];
        Exit;
      end;
    if AComp is TWinControl then
      for I := 0 to TWinControl(AComp).ControlCount - 1 do
        if SameText(TWinControl(AComp).Controls[I].Name, AName) then
        begin
          Result := TWinControl(AComp).Controls[I];
          Exit;
        end;
    for I := 0 to AComp.ComponentCount - 1 do
    begin
      Result := FindChild(AComp.Components[I]);
      if Result <> nil then
        Exit;
    end;
    if AComp is TWinControl then
      for I := 0 to TWinControl(AComp).ControlCount - 1 do
        if TWinControl(AComp).Controls[I].Owner <> AComp then
        begin
          Result := FindChild(TWinControl(AComp).Controls[I]);
          if Result <> nil then
            Exit;
        end;
  end;

begin
  Result := nil;
  if AName = '' then
    Exit;
  Result := FindChild(AOwner);
end;

function FindCompPropObj(AInstance: TComponent; var AKey: string): TObject;
var
  I, J, L: integer;
  Instance: TPersistent;
  PropInfo: PPropInfo;
  PropValue: TObject;
  PropPath, Prop: string;
begin
  if Pos('.', AKey) = 0 then
  begin
    Result := AInstance;
    Exit;
  end;

  PropPath := AKey;

  I := 1;
  L := Length(PropPath);
  Instance := AInstance;
  while True do
  begin
    J := I;
    while (I <= L) and (PropPath[I] <> '.') do
      Inc(I);
    Prop := Copy(PropPath, J, I - J);
    if I > L then
      Break;
    PropInfo := GetPropInfo(Instance.ClassInfo, Prop);
    if PropInfo = nil then
      raise Exception.Create('找不到属性 ' + AKey);
    PropValue := nil;
    if PropInfo^.PropType^.Kind = tkClass then
      PropValue := TObject(GetOrdProp(Instance, PropInfo));
    if not (PropValue is TPersistent) then
      raise Exception.Create('找不到属性 ' + AKey);
    Instance := TPersistent(PropValue);
    Inc(I);
  end;
  Result := Instance;
  AKey := Prop;
end;

function GetCompPropValue(AComponent: TComponent; AKey: string): string;
var
  obj: TObject;
begin
  obj := FindCompPropObj(AComponent, AKey);
  Result := GetPropValue(obj, AKey);
end;

procedure SetCompPropValue(AComponent: TComponent; AKey, sValue: string);
var
  obj: TObject;
begin
  obj := FindCompPropObj(AComponent, AKey);

  SetPropValue(obj, AKey, sValue);
end;

function GetCompPropObject(AComponent: TComponent; AKey: string): TObject;
var
  obj: TObject;
begin
  obj := FindCompPropObj(AComponent, AKey);
  Result := GetObjectProp(obj, AKey);
end;

procedure SetCompPropObject(AComponent: TComponent; AKey: string; sValue: TObject);
var
  obj: TObject;
begin
  obj := FindCompPropObj(AComponent, AKey);

  SetObjectProp(obj, AKey, sValue);
end;

var
  G_LocalDateTimeZoneDiff: double = -9999;

function BESENGetLocalDateTime: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

function BESENGetUTCDateTime: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

function GetLocalDateTimeZone: TDateTime;
begin
  Result := G_LocalDateTimeZoneDiff;
end;

function CurrentTimeMillis: int64;
begin
  Result := Trunc((Now - GetLocalDateTimeZone - 25569.0) * 86400000.0);
end;

function GenData(ARule: string): string;
begin
  Result := GenDataEx(nil, ARule, '', -1, '', nil);
end;

function GenDataEx(AField: TCtMetaField; ARule, ADef: string; ARowIndex: integer;
  AOpt: string; ADataSet: TDataSet): string;
begin
  Result := '';
  if Assigned(Proc_GenDemoData) then
    Result := Proc_GenDemoData(AField, ARule, ADef, ARowIndex, AOpt, ADataSet);
end;

{ TGlobeUrlParams }

procedure TGlobeUrlParams.AddOrModifyParam(AName, AValue: string; AObject: TObject);
var
  I: integer;
  pgp: PGlobeUrlParam;
begin
  AName := UpperCase(AName);
  with LockList do
    try
      for I := 0 to Count - 1 do
        if Items[I] <> nil then
          if UpperCase(PGlobeUrlParam(Items[I])^.Name) = AName then
          begin
            PGlobeUrlParam(Items[I])^.Value := AValue;
            PGlobeUrlParam(Items[I])^.Obj := AObject;
            Exit;
          end;

      pgp := New(PGlobeUrlParam);
      pgp^.Name := AName;
      pgp^.Value := AValue;
      pgp^.Obj := AObject;
      Add(pgp);
    finally
      UnlockList;
    end;
end;

procedure TGlobeUrlParams.ClearParams;
var
  I: integer;
  pgp: PGlobeUrlParam;
begin
  with LockList do
    try
      for I := 0 to Count - 1 do
      begin
        pgp := PGlobeUrlParam(Items[I]);
        if pgp <> nil then
        begin
          Items[I] := nil;
          Dispose(pgp);
        end;
      end;
      Pack;
    finally
      UnlockList;
    end;
end;

procedure TGlobeUrlParams.DeleteParam(AName: string);
var
  I: integer;
  pgp: PGlobeUrlParam;
begin
  AName := UpperCase(AName);
  with LockList do
    try
      for I := 0 to Count - 1 do
        if Items[I] <> nil then
          if UpperCase(PGlobeUrlParam(Items[I])^.Name) = AName then
          begin
            pgp := PGlobeUrlParam(Items[I]);
            Items[I] := nil;
            Dispose(pgp);
          end;
      Pack;
    finally
      UnlockList;
    end;
end;

destructor TGlobeUrlParams.Destroy;
begin
  ClearParams;

  inherited;
end;

function TGlobeUrlParams.GetParamObject(AName: string): TObject;
var
  I: integer;
begin
  AName := UpperCase(AName);
  with LockList do
    try
      for I := 0 to Count - 1 do
        if Items[I] <> nil then
          if UpperCase(PGlobeUrlParam(Items[I])^.Name) = AName then
          begin
            Result := PGlobeUrlParam(Items[I])^.Obj;
            Exit;
          end;
      Result := nil;
    finally
      UnlockList;
    end;
end;

function TGlobeUrlParams.GetParamValue(AName: string): string;
var
  I: integer;
begin
  AName := UpperCase(AName);
  with LockList do
    try
      for I := 0 to Count - 1 do
        if Items[I] <> nil then
          if UpperCase(PGlobeUrlParam(Items[I])^.Name) = AName then
          begin
            Result := PGlobeUrlParam(Items[I])^.Value;
            Exit;
          end;
      Result := '';
    finally
      UnlockList;
    end;
end;

{ TDmlBaseScriptor }

function TDmlBaseScriptor.Compile(ARule, AScript: string): boolean;
begin
  Result := True;
end;

constructor TDmlBaseScriptor.Create;
begin
  //Self.FUTF8Needed := False;
  StdOutPut := FCtscriptStdOutPut;
end;

destructor TDmlBaseScriptor.Destroy;
begin

  inherited;
end;

procedure TDmlBaseScriptor.Exec(ARule, AScript: string);
begin
end;

procedure TDmlBaseScriptor.StopAll;
begin
end;

function TDmlBaseScriptor.GetStdOutPut: TStrings;
begin
  Result := FStdOutPut;
end;

function TDmlBaseScriptor.GetCurOut: TStrings;
begin
  Result := FCurOut;
end;

procedure TDmlBaseScriptor.SetCurOut(AValue: TStrings);
begin               
  FCurOut := AValue;
end;

function TDmlBaseScriptor.GetActiveFile: string;
begin
  Result := FActiveFile;
end;

function TDmlBaseScriptor.HasIncludes(const AScript: string): boolean;
begin
  Result := False;
end;

procedure TDmlBaseScriptor.Init(const ARule: string; ACtObj: TCtMetaObject;
  AResout: TStrings; ACtrlList: TObject);
var
  selObj: TCtMetaObject;
begin
  CurCtObj := ACtObj;
  CurTable := nil;
  CurField := nil;
  if ACtObj <> nil then
  begin
    if ACtObj is TCtMetaTable then
      CurTable := TCtMetaTable(ACtObj);
    if ACtObj is TCtMetaField then
      CurField := TCtMetaField(ACtObj);
  end;

  selObj := GetSelectedCtMetaObj;
  if selObj <> nil then
  begin
    if CurTable = nil then
      if selObj is TCtMetaTable then
        CurTable := TCtMetaTable(selObj);

    if CurField = nil then
      if selObj is TCtMetaField then
        CurField := TCtMetaField(selObj);
  end;
  CurOut := AResout;
  CtrlList := ACtrlList;
end;

function TDmlBaseScriptor.IsSPRule(const AScript: string): boolean;
begin
  Result := False;
end;

function TDmlBaseScriptor.PreConvertSP(const AScript: string): string;
begin
  Result := AScript;
end;

procedure TDmlBaseScriptor.PrintVar(const AVal: variant);
var
  s, V: string;
  I: integer;
begin
  s := 'null';
  if not VarIsNull(AVal) then
    s := VarToStr(AVal);

  if CurOut.Count > 0 then
  begin
    I := CurOut.Count - 1;
    V := CurOut.Strings[I] + S;
    CurOut.Strings[I] := V;
  end
  else
    CurOut.Add(S);
end;

function TDmlBaseScriptor.ProcessIncludes(const AScript: string): string;
begin
  Result := AScript;
end;

procedure TDmlBaseScriptor.RunDmlScript(AFileName, AScript: string);
var
  FileTxt: TStrings;
  S: string;
begin
  FileTxt := nil;
  with CreateScriptForFile(AFileName) do
    try
      S := AScript;
      if ExtractFilePath(AFileName) = '' then
        if ActiveFile <> '' then
          AFileName := ExtractFilePath(Self.ActiveFile) + AFileName;

      if S = '' then
      begin
        FileTxt := TStringList.Create;
        FileTxt.LoadFromFile(AFileName);
        S := FileTxt.Text;
      end;
      ActiveFile := AFileName;
      if IsSPRule(S) then
      begin
        S := PreConvertSP(S);
      end;
      Init('DML_SCRIPT', Self.CurCtObj, Self.StdOutPut, nil);
      Exec('DML_SCRIPT', S);
    finally
      if Assigned(FileTxt) then
        FileTxt.Free;
      Free;
    end;
end;

procedure TDmlBaseScriptor.SetActiveFile(const Value: string);
begin
  FActiveFile := Value;
end;

procedure TDmlBaseScriptor.SetStdOutPut(const Value: TStrings);
begin
  FStdOutPut := Value;
end;

function TDmlBaseScriptor._OnNeedFile(Sender: TObject;
  const OrginFileName: string; var FileName, Output: string): boolean;
var
  path: string;
  f: TFileStream;
begin
  Path := '';
  if OrginFileName <> '' then
    Path := ExtractFilePath(OrginFileName);
  if Path = '' then
    if ActiveFile <> '' then
      Path := ExtractFilePath(ActiveFile);
  if Path = '' then
    Path := ExtractFilePath(ParamStr(0));
  if Pos(':\', FileName) > 0 then
    Path := FileName
  else
    Path := FolderAddFileName(Path, FileName);
  Path := ExpandFileName(Path);
  try
    F := TFileStream.Create(Path, fmOpenRead or fmShareDenyWrite);
  except
    Result := False;
    exit;
  end;
  FileName := Path;
  try
    SetLength(Output, f.Size);
    f.Read(Output[1], Length(Output));
  finally
    f.Free;
  end;
  Result := True;
end;

initialization
  GProc_Toast := Toast;
  FCtscriptStdOutPut := TStringList.Create;
  FGlobeUrlParams := TGlobeUrlParams.Create;
  RegClassesForDmlScript();

finalization
  if Assigned(FCtscriptStdOutPut) then
    FreeAndNil(FCtscriptStdOutPut);
  if Assigned(FGlobeUrlParams) then
    FreeAndNil(FGlobeUrlParams);

end.
