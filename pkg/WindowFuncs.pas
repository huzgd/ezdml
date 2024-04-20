unit WindowFuncs;

interface

uses
  SysUtils, Classes, Graphics,
  Forms, StdCtrls, LCLIntf, LCLType;


type

  { TCtMutex }

  TCtMutex = class(TObject)
  private
    FName: string;
    FLockFileName: string;
    FFileHandle: System.THandle;
  protected
  public
    constructor Create(AName: string); virtual;
    destructor Destroy; override;

    function Acquire(TimeOut: integer = 0; bForce: Boolean = False): boolean; virtual;
    function Release: boolean; virtual;

    property Name: string read FName;
  end;

  { TCtAppFormHandler }

  TCtAppFormHandler = class
  public
    procedure ScreenFormAddEvent(Sender: TObject; Form: TCustomForm);    
    procedure ScreenFormVisibleChgEvent(Sender: TObject; Form: TCustomForm);
  end;


function ShiftToInt(s: TShiftState): integer;
function CtStringToDateTime(s: string): TDateTime;
function CtStringToBool(AVal: string): Boolean;
function CtTrim(s: string): string;

function IntToShift(i: integer): TShiftState;

function WriteMsgToFile(LogFile, Msg: string): boolean; //追加信息写入日志文件

function ValueOfString(Str: string): word; //字节值的和，加密用
function StringExtToWideCode(Str: string): string; //字符串扩成WIDESTRING
function WideCodeNarrow(Str: string): string; //WIDESTRING->字符串
function HexStrToInt(Str: string): integer;

function GetFirstValueBySepStr(SepStr: string; var SrcStr: string): string;
                 
function ExtStr(Str: string; Len: integer; Span: string = ''): string;

function GetDocFileSize(AFile: string): integer;



function ReadCornerNumber(const Str: string; var SRe: string; Def: double): double;
function ReadCornerStr(const Str: string; var SRe: string): string;
function ExtractCompStr(const Strsrc: string; const sCompS, sCompE: string;
  bCaseInsensitive: boolean = False; const Def: string = ''): string;
function ExtractCompStrCt(const Strsrc: string; const sCompS, sCompE: string;
  bCaseInsensitive: boolean = False; const Def: string = ''): string;

function ModifyCompStr(const Strsrc, SubVal: string; const sCompS, sCompE: string;
  bCaseInsensitive: boolean = False): string;
function AddOrModifyCompStr(const Strsrc, SubVal: string; const sCompS, sCompE: string;
  bCaseInsensitive: boolean = False): string;
function RemoveCompStr(const Strsrc: string; const sCompS, sCompE: string;
  bCaseInsensitive: Boolean = False): string;
function TrimByStr(const src, trs: string): string;  
function LastPos(SubStr, S: string): integer;

procedure OleVariantToStream(const AVariant: olevariant; Stream: TStream);
procedure StreamToOleVariant(Stream: TStream; var AVariant: olevariant);
procedure VariantToStream(const AVariant: variant; Stream: TStream);
procedure StreamToVariant(Stream: TStream; var AVariant: variant);

procedure CheckAbort(const Msg: string = '');

procedure DelTree(Dir: string); //删除目录

function ReplaceXMLKeyword(const XML: string; bIsName: boolean = False): string;
function GetSysDefTempPath: string;
function GetAppDefTempPath(const appname: string = ''): string;
function GetFolderPathOfAppExe(subFolder: string = ''): string;
function GetConfFileOfApp(ext: string = '.INI'): string;
function GetAppTempFileName(filename: string): string;
function FolderAddFileName(folder, fileName: string): string;
function TrimFileName(fileName: string): string;
function CheckFileNameSep(fileName: string): string;

function GetUnusedFileName(AFileName: string): string;

function GetLastUsedFileName(AFileName: string): string;
function GetUnusedTmpFileName(AFileName: string): string;

function Utf8URLEncode(const msg: string): string;
function URLEncode(const msg: string): string;
function URLDecode(const url: string): string;

procedure ShellCmd(cmd: string; par: string = '');    
function RunCmd(cmd: string; timeout: integer): string;
procedure CtOpenDoc(adoc: string); 
procedure CtOpenDir(dir: string);
procedure CtBrowseFile(fn: string);

function CtCopyFile(lpExistingFileName, lpNewFileName: PChar; bFailIfExists: BOOL): BOOL;

function DmlStrLength(const S: string): integer;
//转ANSI或GBK编码时的字符长（英文1B，中文2B）

function DmlStrCut(const S: string; dLen: Integer): String;

function CtUTF8Encode(const s: string): string;
function CtUTF8Decode(const s: string): string;

function CtCsToUTF8(const s, charset: string): string;
function CtUTF8toCs(const s, charset: string): string;

procedure ctalert(s: string);    
procedure ctToast(s: variant; closeTimeMs: integer);   
function PvtMsgBox(AMsgId, ATitle, AMsg: string; def, tp, maxShowCount: Integer): Integer;
               
function GetAppConfigValue(Sec, Prop: string; def: string = ''): string;
procedure SetAppConfigValue(Sec, Prop, Val: string);

function CtGenGUID: string;

procedure CtSetFixWidthFont(ACtrl: TObject);
function ScaleDPISize(ASize: Integer): Integer;
procedure CheckFormScaleDPI(AForm: TCustomForm);


function SccStrEncode(str: string): string;
function SccStrDecode(str: string): string;
                          
function IfElse(const ABool, TrueVal, FalseVal: variant): variant;

const
  DEF_CT_DATETIME_FMTS: array[0..21] of String =(
    'yyyy"-"mm"-"dd hh:nn:ss', //'yyyy-MM-dd HH:mm:ss',
    'yyyy"/"mm"/"dd hh:nn:ss', //'yyyy/MM/dd HH:mm:ss',
    'yyyy"年"mm"月"dd"日" hh"时"nn"分"ss"秒"', //'yyyy年MM月dd日 HH时mm分ss秒',  
    'yyyymmddhhnnss', //'yyyyMMddHHmmss',
    'yyyymmdd hh:nn:ss', //'yyyyMMdd HH:mm:ss',
    'yyyy"-"mm"-"dd"T"hh:nn:ss', //'yyyy-MM-ddTHH:mm:ss',
    'yyyy"/"mm"/"dd"T"hh:nn:ss', //'yyyy/MM/ddTHH:mm:ss'
    'yyyy"-"mm"-"dd hh:nn', //'yyyy-MM-dd HH:mm',
    'yyyy"/"mm"/"dd hh:nn', //'yyyy/MM/dd HH:mm',
    'yyyy"-"mm"-"dd"T"hh:nn', //'yyyy-MM-ddTHH:mm',
    'yyyy"/"mm"/"dd"T"hh:nn', //'yyyy/MM/ddTHH:mm',
    'yyyymmdd t', //'yyyyMMdd HH:mm',
    'yyyy"年"mm"月"dd"日" hh"时"nn"分"', //'yyyy年MM月dd日 HH时mm分',
    'yyyy"年"mm"月"dd"日" hh:nn', //'yyyy年MM月dd日 HH:mm',
    'yyyy"年"mm"月"dd"日"', //'yyyy年MM月dd日',
    'yyyy"-"mm"-"dd', //'yyyy-MM-dd',
    'yyyy"/"mm"/"dd', //'yyyy/MM/dd', 
    'yyyymmdd', //'yyyyMMdd', 
    'yyyy"年"mm"月"', //'yyyy年MM月',
    'yyyymm', //'yyyyMM',
    'hh:nn:ss', //'HH:mm:ss',
    'hh:nn' //'HH:mm',
  );

var
  G_AppExeFolderPath: string = '';
  G_CtAppFormHandler: TCtAppFormHandler = nil;
  G_AppDefFontName: string = '';
  G_AppDefFontSize: integer = 0;
  G_AppFixWidthFontName: string = '';
  G_AppFixWidthFontSize: integer = 0;
  G_DmlGraphFontName: string = '';      
  G_DmlGraphDefScale: string = '';
  GProc_Toast: procedure(const Msg: variant; closeTimeMs: integer);

const
  MUTEX_WAIT_INTERVAL = 10;

implementation

uses
  dmlstrs, ezdmlstrs, Variants, Dialogs, LazUTF8, LConvEncoding, FileUtil,
  Controls, StrUtils, process, IniFiles, DateUtils;
                 
function IfElse(const ABool, TrueVal, FalseVal: variant): variant;
var
  S: string;
  d: double;
begin
  if VarIsNull(ABool) or VarIsEmpty(ABool) or VarIsClear(ABool) then
    Result := FalseVal
  else if VarIsNumeric(ABool) then
  begin
    if ABool = 0 then
      Result := FalseVal
    else
      Result := TrueVal;
  end
  else if VarIsBool(ABool) then
  begin
    if ABool then
      Result := TrueVal
    else
      Result := FalseVal;
  end
  else
  begin
    S := UpperCase(VarToStr(ABool));
    if not CtStringToBool(S) then
      Result := FalseVal
    else
    begin
      d := StrToFloatDef(S, 1);
      if (d >= -0.0000000001) and (d <= 0.0000000001) then
        Result := FalseVal
      else
        Result := TrueVal;
    end;
  end;
end;
       
function CtStringToDateTime(s: string): TDateTime;
var
  I, L: Integer;
  V: String;
begin
  Result := 0;
  if Trim(S)='' then
    Exit;

  if Pos(':', S)=0 then
  begin
    if TryStrToDate(S, Result) then
      Exit;
    if Pos('-', S)> 0 then
    begin
      V:=StringReplace(S,'-','/',[rfReplaceAll]); 
      if TryStrToDate(V, Result) then
        Exit;
    end
    else if Pos('/', S)> 0 then
    begin
      V:=StringReplace(S,'/','-',[rfReplaceAll]);
      if TryStrToDate(V, Result) then
        Exit;
    end;
  end
  else
  begin
    if TryStrToDateTime(S, Result) then
      Exit;

    if Pos('-', S)> 0 then
    begin
      V:=StringReplace(S,'-','/',[rfReplaceAll]);
      if TryStrToDateTime(V, Result) then
        Exit;
    end
    else if Pos('/', S)> 0 then
    begin
      V:=StringReplace(S,'/','-',[rfReplaceAll]);
      if TryStrToDateTime(V, Result) then
        Exit;
    end;
  end;

  L := Length(DEF_CT_DATETIME_FMTS);
  for I:=0 to L - 1 do
  begin
    try
      Result := ScanDateTime(DEF_CT_DATETIME_FMTS[i], S);
      if Result>0.0000000000001 then
        Exit;
    except
    end;
  end;
end;

function CtStringToBool(AVal: string): Boolean;
begin
  if LowerCase(AVal) = 'false' then
    Result := False
  else if LowerCase(AVal) = 'no' then
    Result := False       
  else if LowerCase(AVal) = 'n' then
    Result := False
  else if LowerCase(AVal) = 'f' then
    Result := False
  else if Trim(AVal) = '' then
    Result := False
  else if AVal = '0' then
    Result := False      
  else if AVal = '否' then
    Result := False
  else if AVal = '假' then
    Result := False
  else if LowerCase(AVal) = LowerCase(srBoolName_False) then
    Result := False
  else
    Result := True;
end;

function CtTrim(s: string): string;
var
  po: Integer;
begin
  Result := s;
  po := Pos(#0, s);
  if po>0 then
  begin
    Result := Copy(s,1, po - 1);   
    //CtAlert('zzzzzzzzz0: '+StringExtToWideCode(s));
  end;
  Result := Trim(Result);
end;

function SccStrEncode(str: string): string;
begin
  Result := str;
  if Pos('"', Result) > 0 then
    Result := StringReplace(Result, '"', '#34', [rfReplaceAll]);
  if Pos(#13, Result) > 0 then
    Result := StringReplace(Result, #13, '#13', [rfReplaceAll]);
  if Pos(#10, Result) > 0 then
    Result := StringReplace(Result, #10, '#10', [rfReplaceAll]);
  if Pos(#44, Result) > 0 then
    Result := StringReplace(Result, #44, '#44', [rfReplaceAll]);    
  if Pos(#37, Result) > 0 then
    Result := StringReplace(Result, #37, '#37', [rfReplaceAll]);
  if Pos(#23, Result) > 0 then
    Result := StringReplace(Result, #23, '#23', [rfReplaceAll]);

end;

function SccStrDecode(str: string): string;
begin
  Result := str;
  if Pos('#34', Result) > 0 then
    Result := StringReplace(Result, '#34', '"', [rfReplaceAll]);
  if Pos('#13', Result) > 0 then
    Result := StringReplace(Result, '#13', #13, [rfReplaceAll]);
  if Pos('#10', Result) > 0 then
    Result := StringReplace(Result, '#10', #10, [rfReplaceAll]); 
  if Pos('#44', Result) > 0 then
    Result := StringReplace(Result, '#44', #44, [rfReplaceAll]);
  if Pos('#37', Result) > 0 then
    Result := StringReplace(Result, '#37', #37, [rfReplaceAll]);    
  if Pos('#23', Result) > 0 then
    Result := StringReplace(Result, '#23', #23, [rfReplaceAll]);
end;



function ScaleDPISize(ASize: Integer): Integer;
begin
  if Forms.Screen.PixelsPerInch = 96 then
    Result := ASize
  else
    Result := ASize * Screen.PixelsPerInch div 96;
end;

procedure CheckFormScaleDPIEx(AForm: TCustomForm);
var
  sbnds: TStringList;

  procedure ScanContrls(ACtrl: TControl);
  var
    I, C: integer;
    wn: TWinControl;
    S: string;
  begin
    if (ACtrl.Align <> alClient) and (ACtrl.Parent <> nil) then
    begin
      S := Format('%d,%d,%d,%d,%d,%d', [ACtrl.Left, ACtrl.Top, ACtrl.Width, ACtrl.Height, ACtrl.Parent.ClientWidth, ACtrl.Parent.ClientHeight]);
      sbnds.AddObject(S, ACtrl);
    end;

    if ACtrl is TWinControl then
    begin
      wn := TWinControl(ACtrl);
      C := wn.ControlCount;
      for I := 0 to C - 1 do
        ScanContrls(wn.Controls[I]);
    end;
  end;

var
  I, C, Lx, Ly, Lw, Lh, Rx, Ry, Pw, Ph: integer;
  S, V: string;
  ctrl: TControl;
begin
  if AForm.Tag > 0 then
    Exit;
  AForm.Tag := 1;
  if Forms.Screen.PixelsPerInch = 96 then
    Exit;

  sbnds := TStringList.Create;
  try
    ScanContrls(AForm);

    if AForm.Position = poDefault then
    begin
    end
    else if AForm.Position = poDefaultSizeOnly then
    begin
    end
    else
    begin
      AForm.Width := ScaleDPISize(AForm.Width);
      AForm.Height := ScaleDPISize(AForm.Height);
    end;

    C := sbnds.Count;
    for I := 1 to C - 1 do
    begin
      S := sbnds.Strings[I];
      V := ReadCornerStr(S, S);
      Lx := StrToInt(V);
      V := ReadCornerStr(S, S);
      Ly := StrToInt(V);
      V := ReadCornerStr(S, S);
      Lw := StrToInt(V);
      V := ReadCornerStr(S, S);
      Lh := StrToInt(V);

      V := ReadCornerStr(S, S);
      Pw := StrToInt(V);
      V := ReadCornerStr(S, S);
      Ph := StrToInt(V);
      Rx := Pw-Lx-Lw;
      Ry := Ph-Ly-Lh;


      ctrl := TControl(sbnds.Objects[I]);
      if ctrl.Align = alClient then
        Continue;      
      if ctrl.Parent = nil then
        Continue;
      Pw := ctrl.Parent.ClientWidth;
      Ph := ctrl.Parent.ClientHeight;

      try
             
        Lx := ScaleDPISize(Lx);
        Ly := ScaleDPISize(Ly);   
        Rx := ScaleDPISize(Rx);
        Ry := ScaleDPISize(Ry);
        //if not ctrl.AutoSize then
        begin
          Lw := ScaleDPISize(Lw);
          Lh := ScaleDPISize(Lh);
        end;
        if ctrl.Align in [alLeft, alRight] then
        begin
          ctrl.Width:=Lw
        end
        else if ctrl.Align in [alTop, alBottom] then
        begin
          ctrl.Height:=Lh
        end                            
        else if ctrl.Anchors = [akLeft, akTop, akRight, akBottom] then
        begin                                                 
          //ctrl.SetBounds(Lx, ly, ctrl.Left+ctrl.Width-lx, ctrl.Top+ctrl.Height-ly);  
          ctrl.SetBounds(Lx, ly, Pw-Lx-Rx, Ph-Ry-Ly);
        end
        else if ctrl.Anchors = [akLeft, akTop, akRight] then
        begin
          //ctrl.SetBounds(Lx, ly, ctrl.Left+ctrl.Width-lx, Lh);    
          ctrl.SetBounds(Lx, ly, Pw-Lx-Rx, Lh);
        end                                                      
        else if ctrl.Anchors = [akLeft, akTop, akBottom] then
        begin
          //ctrl.SetBounds(Lx, ly, lw, ctrl.Top+ctrl.Height-ly);   
          ctrl.SetBounds(Lx, ly, lw, Ph-Ry-Ly);
        end
        else if ctrl.Anchors = [akRight, akTop] then
        begin
          //ctrl.SetBounds(ctrl.Left+ctrl.Width-lw, ly, lw, lh);    
          ctrl.SetBounds(Pw-Rx-lw, ly, lw, lh);
        end    
        else if ctrl.Anchors = [akRight, akBottom] then
        begin
          //ctrl.SetBounds(ctrl.Left+ctrl.Width-lw, ctrl.Top+ctrl.Height-lh, lw, lh);   
          ctrl.SetBounds(Pw-Rx-Lw, Ph-Ry-Lh, lw, lh);
        end                                                               
        else if ctrl.Anchors = [akLeft, akBottom] then
        begin
          //ctrl.SetBounds(lx, ctrl.Top+ctrl.Height-lh, lw, lh);  
          ctrl.SetBounds(lx, Ph-Ry-Lh, lw, lh);
        end
        else
        begin
          ctrl.SetBounds(Lx, Ly, Lw, Lh);
        end;
      except
      end;
    end;
  finally
    sbnds.Free;
  end;
end;

procedure CheckFormScaleDPI(AForm: TCustomForm);
begin

end;

procedure CtSetFixWidthFont(ACtrl: TObject);
var
  sz: integer;
  S: string;
begin
  if ACtrl <> nil then
    if ACtrl is TControl then
    begin
      sz := TControl(ACtrl).Font.Height;
      //if sz = 0 then
      begin
        S := G_AppFixWidthFontName;
        if S = '' then
          S := srEzdmlFixWidthFontName;
        sz := G_AppFixWidthFontSize;
        if sz = 0 then
          sz := StrToIntDef(srEzdmlFixWidthFontSize, 0);

        if (S = '') or (S = 'default') then
        begin
{$ifdef WINDOWS}
          S := 'Courier New';  
          if sz = 0 then
            sz := 10;
{$else}
{$IFDEF DARWIN}
          S := 'Monaco';
          if sz = 0 then
            sz := 10;
{$else}
          S := 'Mono';
          if sz = 0 then
            sz := 10;
{$ENDIF}
{$endif}

        end;
        TControl(ACtrl).Font.Name := S;

        if sz > 0 then
        begin
          //sz := ScaleDPISize(sz);
          TControl(ACtrl).Font.Size := sz;
        end;
      end;
    end;
end;

procedure ctalert(s: string);
begin
  ShowMessage(s);
end;

procedure ctToast(s: variant; closeTimeMs: integer);
begin
  if Assigned(GProc_Toast) then
    GProc_Toast(S, closeTimeMs)
  else
    ctalert(s);
end;
           
function PvtMsgBox(AMsgId, ATitle, AMsg: string; def, tp, maxShowCount: Integer): Integer;
var
  shownCount: Integer;
  flag: Longint;
  S: String;
begin
  //tp: 0=ok 1=okcancel 2=yesnocancel 3=abortRetrySkip
  //maxShowCount: 0/99999-no limit
                                           
  if (GetKeyState(VK_SHIFT) and $80) = 0 then
  begin
    S := GetAppConfigValue('PvtMessageBox', AMsgId+'_DefResult', '');
    if S <> '' then
    begin //已经有默认值了？
      Result := StrToInt(S);
      Exit;
    end;

    if maxShowCount > 0 then
    begin
      S := GetAppConfigValue('PvtMessageBox', AMsgId+'_ShownCount', '');
      if S <> '' then
      begin //已经显示过很多次了而且用户选择结果跟默认值一样？
        shownCount := StrToInt(S);
        if shownCount > maxShowCount then
        begin
          Result := def;
          Exit;
        end;
      end;
    end;
  end
  else  //清除默认值
  begin
    S := GetAppConfigValue('PvtMessageBox', AMsgId+'_DefResult', '');
    if S <> '' then
    begin
      SetAppConfigValue('PvtMessageBox', AMsgId+'_DefResult', '');
    end;

    S := GetAppConfigValue('PvtMessageBox', AMsgId+'_ShownCount', '');
    if S <> '' then
    begin
      SetAppConfigValue('PvtMessageBox', AMsgId+'_ShownCount', '');
    end;
  end;

  if tp=0 then
  begin
    flag := MB_ICONINFORMATION or MB_OK;
  end
  else if tp=1 then
  begin
    flag := MB_ICONQUESTION or MB_OKCANCEL;  
  end
  else if tp=2 then
  begin
    flag := MB_ICONQUESTION or MB_YESNOCANCEL;       
  end
  else if tp=3 then
  begin
    flag := MB_ICONWARNING or MB_ABORTRETRYIGNORE;
  end
  else
  begin
    flag := MB_ICONINFORMATION or MB_OK;
  end;

  if ATitle='' then
    ATitle := Application.Title;

  Result := Application.MessageBox(PChar(AMsg + #13#10#13#10 + srEzdmlPromptNeverShown), PChar(ATitle), flag);  
  if (GetKeyState(VK_SHIFT) and $80) <> 0 then
  begin
    SetAppConfigValue('PvtMessageBox', AMsgId+'_DefResult', IntToStr(Result));
  end;
  if (def=-1) or (result=def) then
  begin
    S := GetAppConfigValue('PvtMessageBox', AMsgId+'_ShownCount', '');
    shownCount := StrToIntDef(S, 0);
    Inc(shownCount);
    SetAppConfigValue('PvtMessageBox', AMsgId+'_ShownCount', IntToStr(shownCount));
  end;
end;
           
function GetAppConfigValue(Sec, Prop: string; def: string = ''): string;
var
  fn: string;
begin
  Result := def;
  fn := GetConfFileOfApp;
  if not FileExists(fn) then
    Exit;
  with TIniFile.Create(fn) do
  try
    if not SectionExists(sec) then
      Exit;
    Result := ReadString(sec, prop, def);
  finally
    Free;
  end;
end;

procedure SetAppConfigValue(Sec, Prop, Val: string);
var
  fn: string;
begin
  fn := GetConfFileOfApp;
  with TIniFile.Create(fn) do
  try
    WriteString(sec, prop, val);
  finally
    Free;
  end;
end;

function CtUTF8Encode(const s: string): string;
begin
  //Result := CP396ToUTF8(s);
  Result := WinCPToUTF8(PChar(s));
end;

function CtUTF8Decode(const s: string): string;
begin
  //Result := UTF8ToCP936(s);
  Result := PChar(UTF8ToWinCP(s));
end;

function CtCsToUTF8(const s, charset: string): string;
begin
  if Trim(charset)='' then
    Result := s
  else if (LowerCase(charset)='gbk') or (LowerCase(charset)='gb2312') then
    Result := ConvertEncoding(s, 'cp936', 'utf8')
  else
    Result := ConvertEncoding(s, charset, 'utf8');
end;

function CtUTF8toCs(const s, charset: string): string;
begin
  if Trim(charset)='' then
    Result := s
  else if (LowerCase(charset)='gbk') or (LowerCase(charset)='gb2312') then
    Result := ConvertEncoding(s, 'utf8', 'cp936')
  else
    Result := ConvertEncoding(s, 'utf8', charset);
end;

function CtGenGUID: string;
var
  LTep: TGUID;
begin
  CreateGUID(LTep);
  Result := GUIDToString(LTep);
  if Result[1] = '{' then
    Result := Copy(Result, 2, Length(Result) - 2);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
end;

procedure ShellCmd(cmd, par: string);
begin
{$ifdef WINDOWS}    
{$ifndef WIN32}
  cmd := CtUTF8Decode(cmd);
{$endif}
{$endif}
  SysUtils.ExecuteProcess(cmd, '', []);
end;
               
function RunCmd(cmd: string; timeout: integer): string;
var
  AProcess: TProcess;
  sl: TStringList;
begin
  Result := '';
  sl := TStringList.Create;
  AProcess := TProcess.Create(nil);
  try
    AProcess.CommandLine := cmd;
    if timeout = 0 then
      AProcess.Options := AProcess.Options + [poWaitOnExit]
    else if timeout = -1 then
      AProcess.Options := AProcess.Options + [poWaitOnExit, poNoConsole]
    else if timeout = -2 then
      AProcess.Options := AProcess.Options + [poUsePipes]
    else if timeout = -3 then
      AProcess.Options := AProcess.Options + [poUsePipes,poNoConsole];
    AProcess.Execute;
    if timeout <= 0 then
    begin
      if AProcess.Output <> nil then
      begin
        sl.LoadFromStream(AProcess.Output);
        Result := sl.Text;
      end
      else
        Result := 'Exit code: ' + IntToStr(AProcess.ExitCode);
    end;
  finally
    AProcess.Free;
    sl.Free;
  end;
end;

procedure CtOpenDoc(adoc: string);
begin
  if Pos('://', adoc)=1 then
    OpenUrl(adoc)
  else
  begin 
    {$ifndef WINDOWS}
    if LowerCase(ExtractFileExt(adoc))='.sh' then
    begin
      RunCmd('chmod 777 "'+adoc+'"',1);
      {$IFDEF DARWIN}
      adoc := 'open -a Terminal "'+adoc+'"';
      {$else}
      adoc := 'xterm -e bash -c '''+adoc+''' &';;
      {$ENDIF}
      RunCmd(adoc,1);
      Exit;
    end;
    {$endif}
    OpenDocument(adoc);
  end;
end;

procedure CtOpenDir(dir: string);
var
  S: String;
begin
{$ifdef WINDOWS}
  S := 'Explorer "' + dir + '"';
  ShellCmd(S);
{$else}
  S := dir;
  CtOpenDoc(S);
{$endif}
end;

procedure CtBrowseFile(fn: string);
var
  S: string;
begin
{$ifdef WINDOWS}
  S := 'Explorer /select, "' + fn + '"';
  ShellCmd(S);
{$else}
  S := ExtractFilePath(fn);
  CtOpenDoc(S);
{$endif}
end;


function CtCopyFile(lpExistingFileName, lpNewFileName: PChar; bFailIfExists: BOOL): BOOL;
begin
  if bFailIfExists then
    Result := CopyFile(lpExistingFileName, lpNewFileName, [cffPreserveTime], False)
  else
    Result := CopyFile(lpExistingFileName, lpNewFileName,
      [cffOverwriteFile, cffPreserveTime], False);
end;

function DmlStrLength(const S: string): integer;
var
  CurP, EndP: PChar;
  Len: integer;
begin
  Result := 0;
  if S = '' then
    Exit;
  CurP := PChar(S);
  EndP := CurP + length(S);
  while CurP < EndP do
  begin
    Len := UTF8CodepointSize(CurP);
    if Len > 1 then
      Inc(Result, 2)
    else
      Inc(Result, 1);
    Inc(CurP, Len);
  end;
end;

function DmlStrCut(const S: string; dLen: Integer): String;
var
  CurP, EndP: PChar;
  Len, cLen: integer;
begin
  Result := S;
  if S = '' then
    Exit;
  CurP := PChar(Result);
  EndP := CurP + length(Result);
  cLen := 0;
  while CurP < EndP do
  begin
    Len := UTF8CodepointSize(CurP);
    if Len > 1 then
    begin
      if cLen <= dLen - 2 then
        Inc(cLen, 2)
      else
      begin
        Result := Copy(Result, 1, cLen);
        Exit;
      end;
    end
    else
    begin
      if cLen <= dLen - 1 then
        Inc(cLen, 1)
      else
      begin
        Result := Copy(Result, 1, cLen);
        Exit;
      end;
    end;
    Inc(CurP, Len);
  end;
end;

function Utf8URLEncode(const msg: string): string;
begin
  Result := Utf8Encode(msg);
  Result := URLEncode(Result);
end;

function URLEncode(const msg: string): string;
var
  I: integer;
begin
  Result := '';
  for I := 1 to Length(msg) do
  begin
    if msg[I] = ' ' then
      Result := Result + '+'
    else if msg[I] in ['a'..'z', 'A'..'Z', '0'..'9'] then
      Result := Result + msg[I]
    else
      Result := Result + '%' + IntToHex(Ord(msg[I]), 2);
  end;
end;

function urlDecode(const url: string): string;
var
  i, s, g: integer;
begin
  Result := '';

  for i := 1 to Length(url) do
  begin

    if url[i] = '%' then
    begin
      s := StrToInt('$' + url[i + 1]) * 16;
      g := StrToInt('$' + url[i + 2]);

      Result := Result + Chr(s + g);
    end
    else if i = Length(url) then
      Result := Result + url[i]
    else if not (((i > 1) and (url[i - 1] = '%') and (url[i + 1] <> '%')) or
      ((i > 2) and (url[i - 2] = '%') and (url[i - 1] <> '%') and (url[i + 1] = '%')) or
      ((i > 2) and (url[i - 2] = '%') and (url[i - 1] <> '%') and
      (url[i + 1] <> '%'))) then
      Result := Result + url[i];
  end;
end;


function ShiftToInt(s: TShiftState): integer;
begin
  Result := 0;
  if ssShift in s then
    Result := Result + 1;
  if ssAlt in s then
    Result := Result + 2;
  if ssCtrl in s then
    Result := Result + 4;
  if ssLeft in s then
    Result := Result + 8;
  if ssRight in s then
    Result := Result + 16;
  if ssMiddle in s then
    Result := Result + 32;
  if ssDouble in s then
    Result := Result + 64;
end;

function IntToShift(i: integer): TShiftState;
begin
  Result := [];
  if (i and 1) = 1 then
    Result := Result + [ssShift];
  if ((i shr 1) and 1) = 1 then
    Result := Result + [ssAlt];
  if ((i shr 2) and 1) = 1 then
    Result := Result + [ssCtrl];
  if ((i shr 3) and 1) = 1 then
    Result := Result + [ssLeft];
  if ((i shr 4) and 1) = 1 then
    Result := Result + [ssRight];
  if ((i shr 5) and 1) = 1 then
    Result := Result + [ssMiddle];
  if ((i shr 6) and 1) = 1 then
    Result := Result + [ssDouble];
end;

function WriteMsgToFile(LogFile, Msg: string): boolean;
var
  hFile: integer;
  Cs: array[0..1024] of char;
begin
  Result := False;

  if not FileExists(LogFile) then
  begin
    hFile := FileCreate(LogFile);
    if hFile = -1 then
      Exit;
    FileClose(hFile);
  end;

  hFile := FileOpen(LogFile, fmOpenWrite);
  if hFile = -1 then
    Exit;

  FileSeek(hFile, 0, 2);

  if Length(Msg) > 1024 then
    Msg := Copy(Msg, 0, 1024);

  StrPCopy(Cs, Msg);
  FileWrite(hFile, Cs, Length(Msg));

  FileClose(hFile);
  Result := True;
end;

function ValueOfString(Str: string): word;
var
  I: integer;
begin
  Result := 0;
  for I := 1 to Length(Str) do
  begin
    Result := Result + Ord(Str[I]);
  end;
end;

function StringExtToWideCode(Str: string): string;
var
  I, L: integer;
  S: string;
begin
  S := '';
  L := Length(Str);

  for I := 1 to L do
    S := S + IntToHex(smallint(Str[I]), 2);
  //S := S + Format('%2X', [SmallInt(Str[I])]);

  Result := S;
end;

function WideCodeNarrow(Str: string): string;
var
  I, L: integer;
  S, T: string;
begin
  S := '';
  T := Str;
  L := Length(T) div 2;
  for I := 1 to L do
    S := S + char(HexStrToInt(Copy(T, I * 2 - 1, 2)));
  Result := S;
end;

function HexStrToInt(Str: string): integer;
begin
  if Str[1] <> '$' then
    Result := StrToInt('$' + Str)
  else
    Result := StrToInt(Str);
{
var
  I, K, L, C, N: Integer;

  L := Length(Str);
  N := 1;
  C := 0;
  for I := 1 to L do
  begin
    K := SmallInt(Str[L - I + 1]);
    if K < 48 then // The Char Must Between '0'-'9' or 'A'-'F' or 'a'-'f'
      K := 0
    else if K <= 57 then
      K := K - 48
    else if (K >= 65) and (K <= 70) then
      K := K - 65 + 10
    else if (K >= 97) and (K <= 102) then
      K := K - 97 + 10
    else
      K := 0;

    C := C + K * N;
    N := N * 16;
  end;
  Result := C;  }
end;

function GetFirstValueBySepStr(SepStr: string; var SrcStr: string): string;
var
  ip: integer;
begin
  ip := Pos(SepStr, SepStr);
  if ip = 0 then
  begin
    Result := SrcStr;
    SrcStr := '';
  end
  else
  begin
    Result := Copy(SrcStr, 1, ip - 1);
    SrcStr := copy(SrcStr, ip + Length(SepStr), length(SrcStr) -
      (ip + Length(SepStr) - 1));
  end;
end;


function ExtStr(Str: string; Len: integer; Span: string = ''): string;
var
  I, L: integer;
begin
  Str := Trim(Str);
  if Span = '' then
    Span := ' ';
  L := DmlStrLength(Str);
  if L <= Len then
    for I := L to Len do
      Str := Str + Span;
  Result := Str;
end;


function ReadCornerNumber(const Str: string; var SRe: string; Def: double): double;
var
  ip: integer;
begin
  try
    ip := Pos(',', Str);
    if ip = 0 then
    begin
      Result := StrToFloatDef(Trim(Str), Def);
      SRe := '';
      Exit;
    end;
    Result := StrToFloatDef(Trim(Copy(Str, 1, ip - 1)), Def);
    SRe := copy(Str, ip + 1, length(Str) - ip);
  except
    Result := Def;
  end;
end;

function ReadCornerStr(const Str: string; var SRe: string): string;
var
  ip: integer;
begin
  ip := Pos(',', Str);
  if ip = 0 then
  begin
    Result := Trim(Str);
    SRe := '';
    Exit;
  end;
  Result := Trim(Copy(Str, 1, ip - 1));
  SRe := copy(Str, ip + 1, length(Str) - ip);
end;

function GetDocFileSize(AFile: string): integer;
begin
  Result := FileUtil.FileSize(AFile);
end;


function ExtractCompStr(const Strsrc: string; const sCompS, sCompE: string;
  bCaseInsensitive: boolean; const Def: string): string;
var
  L, P0, P1: integer;
  Str: string;
begin
  Result := Def;
  Str := Strsrc;

  if bCaseInsensitive then
    P0 := Pos(UpperCase(sCompS), UpperCase(Str))
  else
    P0 := Pos(sCompS, Str);
  if P0 = 0 then
    Exit;

  L := Length(sCompS);
  Str := Copy(Str, P0 + L, Length(Str));

  if bCaseInsensitive then
    P1 := Pos(UpperCase(sCompE), UpperCase(Str))
  else
    P1 := Pos(sCompE, Str);
  if P1 = 0 then
    Exit;
  Result := Copy(Str, 1, P1 - 1);
end;

function ExtractCompStrCt(const Strsrc: string; const sCompS, sCompE: string;
  bCaseInsensitive: boolean = False; const Def: string = ''): string;
var
  S: string;
begin
  if sCompE = '] ' then
    Result := ExtractCompStr(Strsrc, sCompS, ']', True, '')
  else
    Result := ExtractCompStr(Strsrc, sCompS, sCompE, True, '');
  if Result <> '' then
    Exit;
  S := Trim(sCompE);
  if (S = '/]') or (S = '\]') or (S = ']') then
  begin
    Result := Trim(ExtractCompStr(Strsrc, sCompS, ']', True, ''));
    if Result <> '' then
      Exit;
    Result := Trim(ExtractCompStr(Strsrc, sCompS, '/]', True, ''));
    if Result <> '' then
      Exit;
    Result := Trim(ExtractCompStr(Strsrc, sCompS, '\]', True, ''));
    if Result <> '' then
      Exit;
  end;
  Result := Def;
end;

function ModifyCompStr(const Strsrc, SubVal: string; const sCompS, sCompE: string;
  bCaseInsensitive: boolean): string;
var
  L, P0, P1: integer;
  Str, Res: string;
begin
  Result := '';
  Str := Strsrc;

  if bCaseInsensitive then
    P0 := Pos(UpperCase(sCompS), UpperCase(Str))
  else
    P0 := Pos(sCompS, Str);
  if P0 = 0 then
    Exit;

  L := Length(sCompS);
  Res := Copy(Str, 1, P0 + L - 1);
  Str := Copy(Str, P0 + L, Length(Str));

  if bCaseInsensitive then
    P1 := Pos(UpperCase(sCompE), UpperCase(Str))
  else
    P1 := Pos(sCompE, Str);
  if P1 = 0 then
    Exit;
  Result := Res + SubVal + Copy(Str, P1, Length(Str));
end;

function AddOrModifyCompStr(const Strsrc, SubVal: string;
  const sCompS, sCompE: string; bCaseInsensitive: boolean): string;
begin
  Result := ModifyCompStr(Strsrc, SubVal, sCompS, sCompE, bCaseInsensitive);
  if Result = '' then
    Result := Strsrc + sCompS + SubVal + sCompE;
end;
     
function RemoveCompStr(const Strsrc: string; const sCompS, sCompE: string;
  bCaseInsensitive: Boolean = False): string;
var
  L, P0, P1: Integer;
  Str, Res: string;
begin
  Result := Strsrc;
  Str := Strsrc;

  if bCaseInsensitive then
    P0 := Pos(UpperCase(sCompS), UpperCase(Str))
  else
    P0 := Pos(sCompS, Str);
  if P0 = 0 then
    Exit;

  L := Length(sCompS);
  Res := Copy(Str, 1, P0 - 1);
  Str := Copy(Str, P0 + L, Length(Str));

  if bCaseInsensitive then
    P1 := Pos(UpperCase(sCompE), UpperCase(Str))
  else
    P1 := Pos(sCompE, Str);
  if P1 = 0 then
    Exit;
  Result := Res + Copy(Str, P1 + Length(sCompE), Length(Str));
end;

function TrimByStr(const src, trs: string): string;
var
  L, M: integer;
begin
  Result := src;
  L := Length(trs);
  if L = 0 then
    Exit;
  M := Length(Result);
  if Copy(Result, 1, L) = trs then
    Result := Copy(Result, L + 1, M);
  M := Length(Result);
  if Copy(Result, M - L + 1, L) = trs then
    Result := Copy(Result, 1, M - L);
end;

function LastPos(SubStr, S: string): integer;
var
  i: integer;
begin
  i := Pos(ReverseString(SubStr), ReverseString(S));
  if i > 0 then
    i := Length(S) - i - Length(SubStr) + 2;
  Result := i;
end;

procedure StreamToVariant(Stream: TStream; var AVariant: variant);
var
  p: PChar;
begin
  Stream.Seek(0, soFromBeginning);
  AVariant := VarArrayCreate([0, Stream.Size - 1], VarByte);
  try
    p := VarArrayLock(AVariant);
    try
      Stream.ReadBuffer(p^, Stream.Size);
    finally
      VarArrayUnlock(AVariant);
    end;
  except
    AVariant := Unassigned;
  end;
end;

procedure VariantToStream(const AVariant: variant; Stream: TStream);
var
  p: PChar;
  sz: integer;
begin
  Stream.Size := 0;
  Stream.Seek(0, soFromBeginning);
  if VarIsEmpty(AVariant) or VarIsNull(AVariant) or (not VarIsArray(AVariant)) then
    Exit;

  sz := VarArrayHighBound(AVariant, 1);
  p := VarArrayLock(AVariant);
  try
    Stream.WriteBuffer(p^, sz + 1);
  finally
    VarArrayUnlock(AVariant);
  end;
  Stream.Seek(0, soFromBeginning);
end;

procedure StreamToOleVariant(Stream: TStream; var AVariant: olevariant);
var
  p: PChar;
begin
  Stream.Seek(0, soFromBeginning);
  AVariant := VarArrayCreate([0, Stream.Size - 1], VarByte);
  try
    p := VarArrayLock(AVariant);
    try
      Stream.ReadBuffer(p^, Stream.Size);
    finally
      VarArrayUnlock(AVariant);
    end;
  except
    AVariant := Unassigned;
  end;
end;

procedure OleVariantToStream(const AVariant: olevariant; Stream: TStream);
var
  p: PChar;
  sz: integer;
begin
  Stream.Size := 0;
  Stream.Seek(0, soFromBeginning);
  if VarIsEmpty(AVariant) or VarIsNull(AVariant) or (not VarIsArray(AVariant)) then
    Exit;

  sz := VarArrayHighBound(AVariant, 1);
  p := VarArrayLock(AVariant);
  try
    Stream.WriteBuffer(p^, sz + 1);
  finally
    VarArrayUnlock(AVariant);
  end;
  Stream.Seek(0, soFromBeginning);
end;

procedure CheckAbort(const Msg: string);
begin
end;

procedure DelTree(Dir: string);
var
  sr: TSearchRec;
  fn: string;
begin
  Dir := TrimFileName(Dir);

  if FindFirst(FolderAddFileName(Dir, '*'), faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name = '.') or (sr.Name = '..') then
        Continue;
      if (sr.Attr and faDirectory) = faDirectory then
      begin
        DelTree(FolderAddFileName(Dir, sr.Name));
      end
      else
      begin
        fn := FolderAddFileName(Dir, sr.Name);
        FileSetAttr(fn, 0);
        DeleteFile(fn);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
    FileSetAttr(Dir, faDirectory);
    RemoveDir(Dir);
  end;
end;

function ReplaceXMLKeyword(const XML: string; bIsName: boolean): string;
var
  I, J: integer;
  C: char;
const
  InvalidChars: array[0..25] of char = (
    ',', '.', '/', '?', ':',
    ';', '\', '|', '+', '=',
    ')', '(', '*', '^', '%',
    '$', '#', '@', '!', '`',
    '~', '-', '[', ']', '{',
    '}');

begin
  Result := XML;
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
  Result := StringReplace(Result, '''', '&apos;', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  if bIsName then
    for I := 1 to Length(Result) do
    begin
      C := Result[I];
      for J := 0 to High(InvalidChars) do
        if C = InvalidChars[J] then
        begin
          Result[I] := '_';
          Break;
        end;
    end;
end;

function GetSysDefTempPath: string;
begin
{$ifdef WINDOWS}
  Result := FolderAddFileName(GetFolderPathOfAppExe, 'temp');
{$else}
  Result := FolderAddFileName(ExpandFileName('~/ezdml_appdata'), 'temp');
{$endif}
end;

function GetAppDefTempPath(const appname: string): string;
begin
  Result := GetSysDefTempPath;
  if appname = '' then
    Result := FolderAddFileName(Result, 'ezdml')
  else
    Result := FolderAddFileName(Result, appname);
  Result := TrimFileName(Result);
end;

function GetFolderPathOfAppExe(subFolder: string): string;
begin
  Result := G_AppExeFolderPath;
  if Result = '' then
  begin
{$ifdef DARWIN}
    Result := ExtractFilePath(Application.ExeName);
    Result := TrimFileName(Result);
    //指向app/Contents目录
    if LowerCase(Copy(Result, Length(Result) - 15 + 1, 15)) =
      LowerCase('/Contents/MacOS') then
      Result := Copy(Result, 1, Length(Result) - 6) + '/ezappx';
{$else}
    Result := ExtractFilePath(Application.ExeName);
    if Result<>'' then
      if (Result[Length(Result)]='\') or (Result[Length(Result)]='/') then
        Delete(Result, Length(result), 1);
{$endif}
    G_AppExeFolderPath := Result;
    if not DirectoryExists(G_AppExeFolderPath) then
      ForceDirectories(G_AppExeFolderPath);
  end;
  if subFolder <> '' then
    Result := FolderAddFileName(Result, subFolder);
end;

function GetAppTempFileName(filename: string): string;
begin
  if filename='' then
    filename := 'ezdml_tmp.tmp';
  Result := GetAppDefTempPath;
  Result := FolderAddFileName(Result, filename);
end;

function GetConfFileOfApp(ext: string): string;
begin
{$ifdef WINDOWS}
  Result := ChangeFileExt(Application.ExeName, ext);
{$else}                          
  Result := ExtractFileName(Application.ExeName);
  Result := ChangeFileExt(Result,'');
  Result := ExpandFileName('~/ezdml_appdata/'+Result);

  Result := FolderAddFileName(Result, 'ezdml' + ext);
{$endif}
end;

function FolderAddFileName(folder, fileName: string): string;
begin
  folder := TrimFileName(folder);
  if folder = '' then
    Result := fileName
  else
    Result := folder + DirectorySeparator + fileName;
end;

function TrimFileName(fileName: string): string;
var
  L: integer;
begin
  Result := Trim(fileName);
  if Result = '' then
    Exit;
  L := Length(Result);
  if (Result[L] = '/') or (Result[L] = '\') then
    Delete(Result, L, 1);
end;

function CheckFileNameSep(fileName: string): string;
var
  S: String;
begin
  Result := fileName;
  if DirectorySeparator='/' then
    S:='\'
  else
    S:='/';
  Result := StringReplace(Result,S,DirectorySeparator,[rfReplaceAll]);
end;

function GetUnusedFileName(AFileName: string): string;
var
  I: integer;
  pth, fnam, fext: string;
begin
  pth := ExtractFilePath(AFileName);
  fnam := ExtractFileName(AFileName);
  if fnam = '' then
    raise Exception.Create('文件名为空');

  Result := FolderAddFileName(pth, fnam);
  if FileExists(Result) or DirectoryExists(Result) then
  begin
    I := 2;
    fext := ExtractFileExt(fnam);
    fnam := ExtractFileName(ChangeFileExt(fnam, ''));
    while FileExists(Result) or DirectoryExists(Result) do
    begin
      Result := FolderAddFileName(pth, fnam + Format('(%d)', [I])) + fext;
      Inc(I);
    end;
  end;
end;

function GetLastUsedFileName(AFileName: string): string;
var
  I: integer;
  pth, fnam, fext, fn, lastFn: string;
begin
  Result := '';
  pth := ExtractFilePath(AFileName);
  fnam := ExtractFileName(AFileName);
  if fnam = '' then
    raise Exception.Create('文件名为空');

  pth := TrimFileName(pth);

  I := 1;
  fext := ExtractFileExt(fnam);
  fnam := ExtractFileName(ChangeFileExt(fnam, ''));
  lastFn := '';
  while True do
  begin
    fn := FolderAddFileName(pth, fnam + Format('(%d)', [I])) + fext;
    if not FileExists(fn) then
    begin
      Result := lastFn;
      Exit;
    end
    else
      lastFn := fn;
    Inc(I);
  end;
end;

function GetUnusedTmpFileName(AFileName: string): string;
var
  I: integer;
  pth, fnam, fext: string;
begin
  pth := ExtractFilePath(AFileName);
  fnam := ExtractFileName(AFileName);
  if fnam = '' then
    raise Exception.Create('文件名为空');

  pth := TrimFileName(pth);


  I := 1;
  fext := ExtractFileExt(fnam);
  fnam := ExtractFileName(ChangeFileExt(fnam, ''));
  Result := FolderAddFileName(pth, fnam + Format('(%d)', [I])) + fext;
  while FileExists(Result) or DirectoryExists(Result) do
  begin
    Result := FolderAddFileName(pth, fnam + Format('(%d)', [I])) + fext;
    Inc(I);
  end;
end;

function Crc16str(buf: string): word;
var
  r, c: word;
  i, j: integer;
  len: integer;
begin
  len := Length(buf);
  r := $FFFF;
  for i := 0 to len - 1 do
  begin
    r := r xor Ord(buf[i + 1]);
    for j := 0 to 7 do
    begin
      c := r and $0001; //按位与
      r := r shr 1; //右移位
      if c > 0 then
        r := r xor $A001;
    end;
  end;
  Result := r;
end;



function GetCrcedFileName(fn: string; segLen, maxLen: integer): string;
var
  S1, S2, S: string;
  cr: word;
begin
  S1 := fn;
  S2 := '';
  while (S1 <> '') and (Length(S1) + Length(S2) > maxLen) do
  begin
    if Length(S1) > segLen then
    begin
      S := Copy(S1, Length(S1) - segLen + 1, segLen);
      S1 := Copy(S1, 1, Length(S1) - segLen);
    end
    else
    begin
      S := S1;
      S1 := '';
    end;
    cr := Crc16str(S);
    S2 := S2 + IntToHex(cr, 4);
  end;
  Result := S1 + S2;
  if Length(Result) > maxLen then
    Result := GetCrcedFileName(Result, segLen, maxLen);
end;

{ TCtAppFormHandler }

procedure TCtAppFormHandler.ScreenFormAddEvent(Sender: TObject;
  Form: TCustomForm);
var
  S: string;
  sz: integer;
begin
  //ctalert('form added:'+Form.className);
  if Form = nil then
    Exit;
  S := G_AppDefFontName;
  if S = '' then
    S := srEzdmlDefaultFontName;
  if S <> '' then
    Form.Font.Name := S;

  sz := G_AppDefFontSize;
  if sz = 0 then
    sz := StrToIntDef(srEzdmlDefaultFontSize, 0);
  if sz > 0 then
    Form.Font.Size := sz;
end;

procedure TCtAppFormHandler.ScreenFormVisibleChgEvent(Sender: TObject;
  Form: TCustomForm);
begin
  if Form.Visible then
    CheckFormScaleDPIEx(Form)
  else if Assigned(Application.MainForm) and (Form <> Application.MainForm)
    and (Application.MainForm.Tag = 55678) then
    PostMessage(Application.MainForm.Handle, 1024+$1001,9,0);
end;

{ TCtMutex }

constructor TCtMutex.Create(AName: string);
begin
  FName := AName;
  if FName = '' then
    FName := CtGenGUID;
  FFileHandle := feInvalidHandle;
end;

destructor TCtMutex.Destroy;
begin
  if FFileHandle <> feInvalidHandle then
    Release;
  inherited Destroy;
end;

function TCtMutex.Acquire(TimeOut: integer; bForce: Boolean): boolean;

  function NextAttempt(const MaxTime: int64): boolean;
  begin
    Sleep(10);
    Result := GetTickCount64 < MaxTime;
  end;

var
  MaxTime: int64;
  dir, S: string;
begin
  Result := False;
  if FFileHandle <> feInvalidHandle then
  begin
    Result := True;
    Exit;
  end;

  dir := GetAppDefTempPath;
  dir := FolderAddFileName(dir, 'mutexes');
  if not DirectoryExists(dir) then
    ForceDirectories(dir);

  S := FName;
  S := StringReplace(S, ':', '_', [rfReplaceAll]);
  S := StringReplace(S, '/', '_', [rfReplaceAll]);
  S := StringReplace(S, '\', '_', [rfReplaceAll]);
  S := LowerCase(GetCrcedFileName(S, 32, 72));
  FLockFileName := FolderAddFileName(dir, S + '.mtx');
  MaxTime := GetTickCount64 + TimeOut;
  repeat
    if FileExists(FLockFileName) then
    begin
      if bForce then
      begin
        Result := DeleteFile(FLockFileName);
        if Result then
          FFileHandle := FileCreate(FLockFileName, fmShareExclusive);
        Exit;
      end;
      FFileHandle := FileOpen(FLockFileName, fmShareExclusive);
    end
    else
      FFileHandle := FileCreate(FLockFileName, fmShareExclusive);
  until (FFileHandle <> feInvalidHandle) or not NextAttempt(MaxTime);
  if FFileHandle = feInvalidHandle then
    Result := False
  else
    Result := True;
end;

function TCtMutex.Release: boolean;
begin
  if FFileHandle <> feInvalidHandle then
  begin
    FileClose(FFileHandle);
    DeleteFile(FLockFileName);
    Result := True;
    FFileHandle := feInvalidHandle;
  end;
end;



end.
