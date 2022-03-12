{
  CtObjSerialer
  Create by huz(EMAIL) 2006-06-12 10:30:07
  CT对象读写器
  核心祖先类。必须保持此单元的纯洁性！
}

unit CtObjSerialer;
            
{$IFDEF FPC}
  {$MODE Delphi}
  {$WARN 4105 off : Implicit string type conversion with potential data loss from "$1" to "$2"}
  {$WARN 5057 off : Local variable "$1" does not seem to be initialized}
  {$WARN 5060 off : Function result variable does not seem to be initialized}
{$ENDIF}

interface

uses          
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Classes, SysUtils;

type

  { CT对象读写器 }

  { TCtObjSerialer }

  TCtObjSerialer = class(TObject)
  private
  protected
    FIsReadMode: Boolean;
    FCurCtVer: Integer;
    FUserID: Integer;
    FRaiseErrIfFailed: Boolean;
    FParam: string;
    FSection: string;
    FObjID: string;
    FGroupName: string;
    FRootName: string;
    FPreloadChildren: Boolean;
    FChildCountInvalid: Boolean;
    FEof: Boolean;
    FChildCounter: Integer;
    FChildNos: array of Integer;
    FChildSeq: Integer;
    FObjPIDs: array of string;
    FObjGroupNames: array of string;
    FCheckCounter: Integer;
    procedure SetCurCtVer(const Value: Integer); virtual;
    procedure SetObjID(const Value: string); virtual;
    procedure SetParam(const Value: string); virtual;
    procedure SetSection(const Value: string); virtual;
    procedure SetPreloadChildren(const Value: Boolean); virtual;
  public
    constructor Create; overload;
    constructor Create(bIsReadMode: Boolean); overload; virtual;
    constructor Create(const fn: string; fm: Word); overload; virtual;
    destructor Destroy; override;

    function IsUtf8: Boolean; virtual; //CT24 版后全部改用UTF8
    function NeedUtf8Convert: Boolean; virtual; //是否需要转换编码
    function DecodeString(const str: string): string; virtual; //读入文件内容后解码
    function EncodeString(const str: string): string; virtual; //写文件内容前编码

    procedure ReadString(const PropName: string; var PropValue: string); virtual; abstract;
    procedure ReadBool(const PropName: string; var PropValue: Boolean); virtual;         
    procedure ReadNotBool(const PropName: string; var PropValue: Boolean); virtual;
    procedure ReadByte(const PropName: string; var PropValue: Byte); virtual;
    procedure ReadInteger(const PropName: string; var PropValue: Integer); virtual;
    function ReadInt(const PropName: string): Integer;
    procedure ReadFloat(const PropName: string; var PropValue: Double); virtual;
    procedure ReadDate(const PropName: string; var PropValue: TDateTime); virtual;
    procedure ReadBuffer(const PropName: string; const Len: LongInt; var PropValue); virtual;
    procedure UnReadBuffer(const Len: LongInt); virtual;
    procedure ReadStrings(const PropName: string; var PropValue: string); virtual;


    procedure WriteString(const PropName: string; const PropValue: string); virtual; abstract;
    procedure WriteBool(const PropName: string; const PropValue: Boolean); virtual;         
    procedure WriteNotBool(const PropName: string; const PropValue: Boolean); virtual;
    procedure WriteByte(const PropName: string; const PropValue: Byte); virtual;
    procedure WriteInteger(const PropName: string; const PropValue: Integer); virtual;
    procedure WriteFloat(const PropName: string; const PropValue: Double); virtual;
    procedure WriteDate(const PropName: string; const PropValue: TDateTime); virtual;
    procedure WriteBuffer(const PropName: string; const Len: LongInt; const PropValue); virtual;
    procedure WriteStrings(const PropName: string; const PropValue: string); virtual;

    procedure ClearProp(const PropName: string); virtual;

    procedure CheckSectionName; virtual;
    //子对象数目
    function GetChildCount: Integer; virtual;
    //子对象ID（表名＋编号）
    function GetChildID(Index: Integer): string; virtual;
    procedure SetRootName(const Value: string); virtual;
    //切换到下一个对象
    function NextChildObjToRead: Boolean; virtual; //读取下一个子对象时触发
    function NewObjToWrite(AID: Integer): Boolean; virtual; //写入一个对象前触发
    function EOF: Boolean; virtual;
    //开始／完成读写一个对象
    procedure BeginObject(bRead: Boolean; AID: string); virtual;
    procedure EndObject(bRead: Boolean; AID: string); virtual;
    //切换到子对象（传入子对象列表属性名）
    procedure BeginChildren(AGroupName: string); virtual; //开始后可能会直接写一个Count
    procedure EndChildren(AGroupName: string); virtual;

    //章节名（表名）
    property Section: string read FSection write SetSection;
    property RootName: string read FRootName write SetRootName;
    //对象ID（可为ID编号或表名＋ID编号）
    property ObjID: string read FObjID write SetObjID;
    //相关参数
    property Param: string read FParam write SetParam;
    //读写失败时是否报错
    property RaiseErrIfFailed: Boolean read FRaiseErrIfFailed write FRaiseErrIfFailed;
    //最后一次读写结果是否成功 为0则成功
    //property LastOpFlag: Integer read FLastOpFlag write FLastOpFlag;
    //子节点数目是否变化
    property ChildCountInvalid: Boolean read FChildCountInvalid write FChildCountInvalid;
    //用户编号
    property UserID: Integer read FUserID write FUserID;

    //是否自动读入子对象内容（未实现）
    //如果是，设置OJBID后第一次从数据库读取时同时将其下所有子节点读入
    //否则，只在每次BeginChildren时临时创建新的读取器从数据库读取
    property PreloadChildren: Boolean read FPreloadChildren write SetPreloadChildren;
    property CurCtVer: Integer read FCurCtVer write SetCurCtVer;
    property IsReadMode: Boolean read FIsReadMode;
  end;

  { CT数据流读写 }
  //流数据的读写必须严格按顺序进行
  //Section与ObjID的定位操作在此无效
  //GetChildCount,GetChildID,NextObj等操作也无效
  TCtObjStream = class(TCtObjSerialer)
  private
    FStream: TStream;
  public
    procedure ReadString(const PropName: string; var PropValue: string); override;
    procedure ReadBool(const PropName: string; var PropValue: Boolean); override;
    procedure ReadByte(const PropName: string; var PropValue: Byte); override;
    procedure ReadInteger(const PropName: string; var PropValue: Integer); override;
    procedure ReadFloat(const PropName: string; var PropValue: Double); override;
    procedure ReadDate(const PropName: string; var PropValue: TDateTime); override;
    procedure ReadBuffer(const PropName: string; const Len: LongInt; var PropValue); override;
    procedure UnReadBuffer(const Len: LongInt); override;
    procedure WriteString(const PropName: string; const PropValue: string); override;
    procedure WriteBool(const PropName: string; const PropValue: Boolean); override;
    procedure WriteByte(const PropName: string; const PropValue: Byte); override;
    procedure WriteInteger(const PropName: string; const PropValue: Integer); override;
    procedure WriteFloat(const PropName: string; const PropValue: Double); override;
    procedure WriteDate(const PropName: string; const PropValue: TDateTime); override;
    procedure WriteBuffer(const PropName: string; const Len: LongInt; const PropValue); override;

    property Stream: TStream read FStream write FStream;
  end;

  TCtObjMemStream = class(TCtObjStream)
  public
    constructor Create(bIsReadMode: Boolean); override;
    destructor Destroy; override;
  end;

  TCtObjFileStream = class(TCtObjStream)
  protected
    FFileStream: TFileStream;
    FFileMode: Word;
  public
    constructor Create(const fn: string; fm: Word); overload; override;
    destructor Destroy; override;
  end;
   
const
  DEF_CURCTVER = 'CT31';
  DEF_CURCTVER_VAL = 31;
var     
{$IFnDEF FPC}    
  G_SysIsUtf8Encoding: Boolean = False; //系统是否UTF8编码？LAZARUS为TRUE，BDS为FALSE
{$ELSE}     
  G_SysIsUtf8Encoding: Boolean = True; //系统是否UTF8编码？LAZARUS为TRUE，BDS为FALSE
{$ENDIF}

resourcestring
  srEzdmlNewVersionNeeded = 'Data version not supported. You may need a newer version of EZDML.';

implementation

uses
  WindowFuncs;

{ TCtObjSerialer }

procedure TCtObjSerialer.CheckSectionName;
var
  I: Integer;
  S, T: string;
begin
  S := RootName;
  for I := 1 to FChildCounter - 1 do
  begin
    if CurCtVer <= 20 then
      S := S + '_item' + IntToStr(FChildNos[I])
    else
    begin
      T := FObjGroupNames[I];
      if T = '' then
        T := 'items';
      S := S + '_' + T;
      if FChildNos[I] > 0 then
        S := S + IntToStr(FChildNos[I]);
    end;
  end;
  if FChildCounter > 0 then
  begin
    if CurCtVer <= 20 then
      S := S + '_item' + IntToStr(FChildSeq)
    else
    begin
      T := FGroupName;
      if T = '' then
        T := 'items';
      S := S + '_' + T;
      if FChildSeq > 0 then
        S := S + IntToStr(FChildSeq);
    end;
  end;
  Section := S;
end;

procedure TCtObjSerialer.ClearProp(const PropName: string);
begin
  WriteString(PropName, '');
end;

constructor TCtObjSerialer.Create(const fn: string; fm: Word);
begin              
  FCurCtVer := StrToInt(Copy(DEF_CURCTVER, 3, 2));
  if fm = fmCreate then
    FIsReadMode := False
  else
    FIsReadMode := True;
end;

constructor TCtObjSerialer.Create;
begin
  raise Exception.Create('shoud not direct create TCtObjSerialer');
end;

constructor TCtObjSerialer.Create(bIsReadMode: Boolean);
begin               
  FCurCtVer := StrToInt(Copy(DEF_CURCTVER, 3, 2));
  FIsReadMode := bIsReadMode;
end;

function TCtObjSerialer.DecodeString(const str: string): string;
begin
  if not NeedUtf8Convert then
  begin
    Result := str;
    Exit;
  end;

  Result := str;
  if IsUtf8 then
  begin
    if not G_SysIsUtf8Encoding then
      Result := CtUtf8Decode(str);
  end
  else
  begin
    if G_SysIsUtf8Encoding then
      Result := CtUtf8Encode(str);
  end;
end;

destructor TCtObjSerialer.Destroy;
begin
  inherited;
end;

procedure TCtObjSerialer.BeginChildren(AGroupName: string);
begin
  Inc(FChildCounter);
  SetLength(FChildNos, FChildCounter);
  FChildNos[FChildCounter - 1] := FChildSeq;
  FChildSeq := 0;
  SetLength(FObjPIDs, FChildCounter);
  FObjPIDs[FChildCounter - 1] := FObjID;
  SetLength(FObjGroupNames, FChildCounter);
  FObjGroupNames[FChildCounter - 1] := FGroupName;
  FGroupName := AGroupName;
  CheckSectionName;
end;

function TCtObjSerialer.EncodeString(const str: string): string;
begin
  if not NeedUtf8Convert then
  begin
    Result := str;
    Exit;
  end;


  Result := str;
  if IsUtf8 then
  begin
    if not G_SysIsUtf8Encoding then
      Result := CtUtf8Encode(str);
  end
  else
  begin
    if G_SysIsUtf8Encoding then
      Result := CtUtf8Decode(str);
  end;
end;

procedure TCtObjSerialer.EndChildren(AGroupName: string);
begin
  if FChildCounter = 0 then
    raise Exception.Create('Unexpected error: ChildCounter<0');
  if AGroupName <> FGroupName then
    raise Exception.Create('Invalid group name - ' + AGroupName + ', expected name is ' + FGroupName);

  FChildSeq := FChildNos[FChildCounter - 1];
  ObjID := FObjPIDs[FChildCounter - 1];
  FGroupName := FObjGroupNames[FChildCounter - 1];
  Dec(FChildCounter);
  SetLength(FChildNos, FChildCounter);
  SetLength(FObjPIDs, FChildCounter);
  SetLength(FObjGroupNames, FChildCounter);
  CheckSectionName;
end;

function TCtObjSerialer.EOF: Boolean;
begin
  Result := FEof;
end;

function TCtObjSerialer.GetChildCount: Integer;
begin
  Result := 0;
  ReadInteger('Count', Result);
end;

function TCtObjSerialer.GetChildID(Index: Integer): string;
begin
  Result := '';
end;

function TCtObjSerialer.IsUtf8: Boolean;
begin
  if FCurCtVer >= 24 then
    Result := True
  else
    Result := False;
end;

function TCtObjSerialer.NeedUtf8Convert: Boolean;
begin
  //如果是23及以前的旧版，BDS加载
  if IsUtf8 then
  begin
    if G_SysIsUtf8Encoding then
      Result := False
    else
      Result := True;
  end
  else
  begin
    if G_SysIsUtf8Encoding then
      Result := True
    else
      Result := False;
  end;
end;

function TCtObjSerialer.NewObjToWrite(AID: Integer): Boolean;
begin
  Inc(FChildSeq);
  ObjID := IntToStr(AID);
  CheckSectionName;
  Result := True;
end;

function TCtObjSerialer.NextChildObjToRead: Boolean;
begin
  Inc(FChildSeq);
  CheckSectionName;
  Result := True;
end;

procedure TCtObjSerialer.ReadBool(const PropName: string;
  var PropValue: Boolean);
var
  i: Integer;
begin
  i := Ord(PropValue);
  ReadInteger(PropName, i);
  PropValue := i <> 0;
end;

procedure TCtObjSerialer.ReadNotBool(const PropName: string;
  var PropValue: Boolean);
begin       
  if CurCtVer < 27 then
    ReadBool(PropName, PropValue)
  else
  begin
    ReadBool('Not_'+PropName, PropValue);
    PropValue := not PropValue;
  end;
end;

procedure TCtObjSerialer.ReadBuffer(const PropName: string; const Len: LongInt;
  var PropValue);
var
  S: string;
  L: Integer;
begin            
  //ShowMessage(PropName);
  S := '';
  ReadString(PropName, S);
  S := WideCodeNarrow(S);
  if Length(S) > Len then
  begin
    SetLength(S, Len);
    L := Len;
  end
  else
    L := Length(S);
  Move(Pointer(S)^, PropValue, L);
end;

procedure TCtObjSerialer.ReadByte(const PropName: string; var PropValue: Byte);
var
  I: Integer;
begin
  ReadInteger(PropName, I);
  PropValue := I;
end;

procedure TCtObjSerialer.ReadDate(const PropName: string;
  var PropValue: TDateTime);
var
  S: string;
begin
  S := '';
  ReadString(PropName, S);
  if S = '' then
    Double(PropValue) := 0
  else
  try       
    if System.Pos(DateSeparator, S)=0 then   //added by huz 20210329
    begin
      if (DateSeparator='/') and (System.Pos('-', S)>0) then
        S:=StringReplace(S,'-','/',[rfReplaceAll])
      else if (DateSeparator='-') and (System.Pos('/', S)>0) then
        S:=StringReplace(S,'/','-',[rfReplaceAll]);
    end;
    PropValue := StrToDateTime(S);
  except
    on Exception do
      if RaiseErrIfFailed then
        raise;
  end;
end;

procedure TCtObjSerialer.ReadFloat(const PropName: string;
  var PropValue: Double);
var
  S: string;
begin
  S := '';
  ReadString(PropName, S);
  if S = '' then
    PropValue := 0
  else
  try
    PropValue := StrToFloat(S);
  except
    on Exception do
      if RaiseErrIfFailed then
        raise;
  end;
end;

procedure TCtObjSerialer.ReadInteger(const PropName: string;
  var PropValue: Integer);
var
  S: string;
begin
  S := '';
  ReadString(PropName, S);
  if S = '' then
    PropValue := 0
  else
  try
    PropValue := StrToInt(S);
  except
    on Exception do
      if RaiseErrIfFailed then
        raise;
  end;
end;

procedure TCtObjSerialer.SetCurCtVer(const Value: Integer);
begin
  if (Value>0) and (Value < 20) then
    raise Exception.Create('CtVer not supported: version is too old and is not supported now');
  if Value > DEF_CURCTVER_VAL then
    raise Exception.Create(srEzdmlNewVersionNeeded);
  FCurCtVer := Value;
end;

procedure TCtObjSerialer.SetObjID(const Value: string);
begin
  FObjID := Value;
end;

procedure TCtObjSerialer.SetParam(const Value: string);
begin
  FParam := Value;
end;

procedure TCtObjSerialer.SetPreloadChildren(const Value: Boolean);
begin
  FPreloadChildren := Value;
end;

procedure TCtObjSerialer.SetRootName(const Value: string);
begin
  FRootName := Value;
  CheckSectionName;
end;

procedure TCtObjSerialer.SetSection(const Value: string);
begin
  FSection := Value;
end;

procedure TCtObjSerialer.UnReadBuffer(const Len: LongInt);
begin
end;

procedure TCtObjSerialer.WriteBool(const PropName: string;
  const PropValue: Boolean);
const
  Values: array[Boolean] of string = ('0', '1');
begin
  WriteString(PropName, Values[PropValue]);
end;

procedure TCtObjSerialer.WriteNotBool(const PropName: string;
  const PropValue: Boolean);
begin
  WriteBool('Not_'+PropName, not PropValue);
end;

procedure TCtObjSerialer.WriteBuffer(const PropName: string;
  const Len: LongInt; const PropValue);
var
  S: string;
begin
  SetLength(S, Len);
  Move(PropValue, Pointer(S)^, Len);
  S := StringExtToWideCode(S);
  WriteString(PropName, S);
end;

procedure TCtObjSerialer.WriteByte(const PropName: string;
  const PropValue: Byte);
var
  I: Integer;
begin
  I := PropValue;
  WriteInteger(PropName, I);
end;

procedure TCtObjSerialer.WriteDate(const PropName: string;
  const PropValue: TDateTime);
begin
  WriteString(PropName, DateTimeToStr(PropValue));
end;

procedure TCtObjSerialer.WriteFloat(const PropName: string;
  const PropValue: Double);
begin
  WriteString(PropName, FloatToStr(PropValue));
end;

procedure TCtObjSerialer.WriteInteger(const PropName: string;
  const PropValue: Integer);
begin
  WriteString(PropName, IntToStr(PropValue));
end;

procedure TCtObjSerialer.BeginObject(bRead: Boolean; AID: string);
begin
  if bRead <> FIsReadMode then
  begin
    if FIsReadMode then
      raise Exception.Create('Serialer is in ReadMode and can not write')
    else
      raise Exception.Create('Serialer is in WriteMode and can not read');
  end;
  if bRead then
    if (AID <> '') and (ObjID <> AID) then
    begin
      ObjID := AID;
      CheckSectionName;
    end;
end;

procedure TCtObjSerialer.EndObject(bRead: Boolean; AID: string);
begin
  if bRead <> FIsReadMode then
  begin
    if FIsReadMode then
      raise Exception.Create('Serialer is in ReadMode and can not write')
    else
      raise Exception.Create('Serialer is in WriteMode and can not read');
  end;
  Inc(FCheckCounter);
  if FCheckCounter > 200 then
    CheckAbort(' ');
end;

procedure TCtObjSerialer.ReadStrings(const PropName: string;
  var PropValue: string);
var
  I, C: Integer;
  Strs: TStrings;
  S: string;
begin
  Strs := TStringList.Create;
  try
    ReadInteger(PropName + '_Count', C);
    for I := 0 to C - 1 do
    begin
      S:='';
      ReadString(PropName + '_' + IntTostr(I), S);
      if (S <> '') and (S[1] = '$') then
        S := Copy(S, 2, Length(S));
      if (S <> '') and (S[Length(S)] = '$') then
        S := Copy(S, 1, Length(S) - 1);
      Strs.Add(S);
    end;
    PropValue := Strs.Text;
  finally
    Strs.Free;
  end;
end;

procedure TCtObjSerialer.WriteStrings(const PropName: string;
  const PropValue: string);
var
  I, C: Integer;
  Strs: TStrings;
begin
  Strs := TStringList.Create;
  try
    Strs.Text := PropValue;
    C := Strs.Count;
    WriteInteger(PropName + '_Count', C);
    for I := 0 to C - 1 do
      WriteString(PropName + '_' + IntTostr(I), '$' + Strs[I] + '$');
  finally
    Strs.Free;
  end;
end;

function TCtObjSerialer.ReadInt(const PropName: string): Integer;
begin
  ReadInteger(PropName, Result);
end;

{ TCtObjStream }

procedure TCtObjStream.ReadBool(const PropName: string; var PropValue: Boolean);
var
  B: Byte;
begin
  B := 0;
  FStream.ReadBuffer(B, SizeOf(B));
  PropValue := B <> 0;
end;

procedure TCtObjStream.ReadBuffer(const PropName: string; const Len: Integer;
  var PropValue);
begin
  FStream.ReadBuffer(PropValue, Len);
end;

procedure TCtObjStream.ReadByte(const PropName: string; var PropValue: Byte);
begin
  FStream.ReadBuffer(PropValue, SizeOf(PropValue));
end;

procedure TCtObjStream.ReadDate(const PropName: string;
  var PropValue: TDateTime);
begin
  FStream.ReadBuffer(PropValue, SizeOf(PropValue));
end;

procedure TCtObjStream.ReadFloat(const PropName: string; var PropValue: Double);
begin
  FStream.ReadBuffer(PropValue, SizeOf(PropValue));
end;

procedure TCtObjStream.ReadInteger(const PropName: string;
  var PropValue: Integer);
begin
  FStream.ReadBuffer(PropValue, SizeOf(PropValue));
end;

procedure TCtObjStream.ReadString(const PropName: string;
  var PropValue: string);
var
  L: Integer;
begin
  FStream.ReadBuffer(L, SizeOf(Integer));
  SetLength(PropValue, L);
  FStream.ReadBuffer(Pointer(PropValue)^, L);
  if NeedUtf8Convert then
    PropValue := DecodeString(PropValue);
end;

procedure TCtObjStream.UnReadBuffer(const Len: Integer);
begin
  inherited;
  FStream.Seek(-Len, soFromCurrent);
end;

procedure TCtObjStream.WriteBool(const PropName: string;
  const PropValue: Boolean);
var
  B: Byte;
begin
  if PropValue then
    B := 1
  else
    B := 0;
  FStream.WriteBuffer(B, SizeOf(B));
end;

procedure TCtObjStream.WriteBuffer(const PropName: string; const Len: Integer;
  const PropValue);
begin
  FStream.WriteBuffer(PropValue, Len);
end;

procedure TCtObjStream.WriteByte(const PropName: string; const PropValue: Byte);
begin
  FStream.WriteBuffer(PropValue, SizeOf(PropValue));
end;

procedure TCtObjStream.WriteDate(const PropName: string;
  const PropValue: TDateTime);
begin
  FStream.WriteBuffer(PropValue, SizeOf(PropValue));
end;

procedure TCtObjStream.WriteFloat(const PropName: string;
  const PropValue: Double);
begin
  FStream.WriteBuffer(PropValue, SizeOf(PropValue));
end;

procedure TCtObjStream.WriteInteger(const PropName: string;
  const PropValue: Integer);
begin
  FStream.WriteBuffer(PropValue, SizeOf(PropValue));
end;

procedure TCtObjStream.WriteString(const PropName, PropValue: string);
var
  L: Integer;
  S: string;
begin
  if NeedUtf8Convert then
  begin
    S := EncodeString(PropValue);
    L := Length(S);
    FStream.WriteBuffer(L, SizeOf(Integer));
    FStream.WriteBuffer(Pointer(S)^, L);
  end
  else
  begin
    L := Length(PropValue);
    FStream.WriteBuffer(L, SizeOf(Integer));
    FStream.WriteBuffer(Pointer(PropValue)^, L);
  end;
end;

{ TCtObjFileStream }

constructor TCtObjFileStream.Create(const fn: string; fm: Word);
begin
  inherited;
  FFileStream := TFileStream.Create(fn, fm);
  FFileMode := fm;
  FStream := TMemoryStream.Create;
  if fm <> fmCreate then
    FStream.CopyFrom(FFileStream, 0);
  FStream.Seek(0, soFromBeginning);
end;

destructor TCtObjFileStream.Destroy;
begin
  if FFileMode = fmCreate then
    FFileStream.CopyFrom(FStream, 0);
  FFileStream.Free;
  FStream.Free;
  inherited;
end;

{ TCtObjMemStream }

constructor TCtObjMemStream.Create(bIsReadMode: Boolean);
begin
  inherited;
  FStream := TMemoryStream.Create;
end;

destructor TCtObjMemStream.Destroy;
begin
  FStream.Free;
  inherited;
end;

end.

