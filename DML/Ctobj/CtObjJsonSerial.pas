unit CtObjJsonSerial;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses       
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Classes, SysUtils, Variants,
  CtObjSerialer, uJSON;

type

  { TCtObjJsonSerialer }

  TCtObjJsonSerialer = class(TCtObjSerialer)
  private
    FWriteEmptyVals: Boolean;
  protected
    FInnerFileStream: TFileStream;
    FStream: TStream;
    FRootJsonObj: TJSONObject;
    FCurJsonObj: TJSONObject;
    FCurJsonList: TJSONArray;
    FJsonInited: Boolean;
    FWriteEnded: Boolean;
    FCtVerWritten: Boolean;
    FJsonObjStack: array of TJSONObject;
    FJsonListStack: array of TJSONArray;
    procedure ValidCtVersion(const Value: Integer); override;
  public
    constructor Create(bIsReadMode: Boolean); overload; override;
    constructor Create(const fn: string; fm: Word); overload; override;
    destructor Destroy; override;

    procedure CheckInitJson; virtual;
    procedure EndJsonWrite; virtual;


    procedure SetRootName(const Value: string); override;

    //function NextChildObjToRead: Boolean; virtual; //读取下一个子对象时触发
    //function NewObjToWrite(AID: Integer): Boolean; virtual; //写入一个对象前触发
    //切换到子对象（传入子对象列表属性名）
    procedure BeginChildren(AGroupName: string); override;
    procedure EndChildren(AGroupName: string); override;

    procedure BeginObject(bRead: Boolean; AID: string); override;

    //读写字符串
    procedure ReadString(const PropName: string; var PropValue: string); override;
    procedure WriteString(const PropName: string; const PropValue: string); override;
    procedure ReadStrings(const PropName: string; var PropValue: string); override;
    procedure WriteStrings(const PropName: string; const PropValue: string); override;

    procedure WriteInteger(const PropName: string; const PropValue: Integer); override;
    procedure WriteFloat(const PropName: string; const PropValue: Double); override;

    procedure ReadBool(const PropName: string; var PropValue: Boolean); override;
    procedure WriteBool(const PropName: string; const PropValue: Boolean); override;

    procedure WriteByte(const PropName: string; const PropValue: Byte); override;
    procedure WriteDate(const PropName: string; const PropValue: TDateTime); override;

    procedure ReadBuffer(const PropName: string; const Len: LongInt; var PropValue); override;
    procedure WriteBuffer(const PropName: string; const Len: LongInt; const PropValue); override;

    property Stream: TStream read FStream write FStream;
    property WriteEmptyVals: Boolean read FWriteEmptyVals write FWriteEmptyVals;
  end;

  TCtObjMemJsonSerialer = class(TCtObjJsonSerialer)
  public
    constructor Create(bIsReadMode: Boolean); override;
    destructor Destroy; override;
  end;

implementation


uses
  WindowFuncs, Forms;

{ TCtObjJsonSerialer }

procedure TCtObjJsonSerialer.ValidCtVersion(const Value: Integer);
var
  S: String;
begin
  if (Value>0) and (Value < 20) then
    raise Exception.Create('CtVer not supported: version is too old and is not supported now');
  if Value > DEF_CURCTVER_VAL then
  begin
    S := Format(srEzdmlNewerVersionPrompt,[Value, DEF_CURCTVER_VAL]);
    if Application.MessageBox(PChar(S), PChar(Application.title), MB_YESNOCANCEL or MB_ICONWARNING)<>IDYES then
      Abort;
  end;
end;

constructor TCtObjJsonSerialer.Create(bIsReadMode: Boolean);
begin
  inherited;
  FRootJsonObj := TJSONObject.create;
  FCurJsonObj := FRootJsonObj;
end;

procedure TCtObjJsonSerialer.BeginChildren(AGroupName: string);
var
  nObj: TZAbstractObject;
begin
  inherited;
  SetLength(FJsonObjStack, FChildCounter);
  FJsonObjStack[FChildCounter - 1] := FCurJsonObj;
  SetLength(FJsonListStack, FChildCounter);
  FJsonListStack[FChildCounter - 1] := FCurJsonList;
  if FIsReadMode then
  begin
    if AGroupName = '' then
    begin
      if FCurJsonObj.has('items') then
        FCurJsonList := FCurJsonObj.getList('items')
      else
      begin
        nObj := TJSONArray.create;
        FCurJsonObj.put('items', nObj);
        FCurJsonList := TJSONArray(nObj);
      end;
    end
    else
    begin
      FCurJsonList := nil;
      if FCurJsonObj.has(AGroupName) then
        FCurJsonObj := FCurJsonObj.getMap(AGroupName)
      else
      begin
        nObj := TJSONObject.create;
        FCurJsonObj.put(AGroupName, nObj);
        FCurJsonList := nil;
        FCurJsonObj := TJSONObject(nObj);
      end;
    end;
  end
  else
  begin
    if AGroupName = '' then
    begin
      nObj := TJSONArray.create;
      FCurJsonObj.put('items', nObj);
      FCurJsonList := TJSONArray(nObj);
    end
    else
    begin
      nObj := TJSONObject.create;
      FCurJsonObj.put(AGroupName, nObj);
      FCurJsonList := nil;
      FCurJsonObj := TJSONObject(nObj);
    end;
  end;
end;

procedure TCtObjJsonSerialer.BeginObject(bRead: Boolean; AID: string);
begin
  inherited;
  if bRead then
  begin
    if FCurJsonList <> nil then
    begin
      FCurJsonObj := FCurJsonList.getMap(FChildSeq - 1);
    end;
  end
  else
  begin
    if FCurJsonList <> nil then
    begin
      FCurJsonObj := TJSONObject.create;
      FCurJsonList.put(FCurJsonObj);
    end;
  end;
end;

procedure TCtObjJsonSerialer.CheckInitJson;
var
  S, V: string;
begin
  if FJsonInited then
    Exit;
  if FIsReadMode then
  begin
    FreeAndNil(FRootJsonObj);
    SetLength(S, FStream.Size);
    FStream.Read(PChar(S)^, FStream.Size);  
    if Copy(S, 1, 3) = #$EF#$BB#$BF then
      Delete(S, 1, 3);
    //解密
    if Assigned(Proc_CheckDecDmlData) then
      S := Proc_CheckDecDmlData(S);
    //判断版本号     
    V := Copy(S, 1, 1024);
    V := Trim(ExtractCompStr(V, '"CTVER":', ','));
    if V <> '' then
    begin
      if V[1] = '"' then
        if V[Length(V)] = '"' then
          V := Copy(V, 2, Length(V) - 2);
      if Length(V) <= 20 then
      begin
        V := WideCodeNarrow(V);
        if Copy(V, 1, 2) = 'CT' then
        begin
          Self.CurCtVer := StrToIntDef(Copy(V, 3, 2), 21);
        end;
      end;
    end;
    if NeedUtf8Convert then
    begin
      S := DecodeString(S);
      if FStream.Size>0 then
        if Length(S)=0 then
          raise Exception.Create('Decode json data failed, may contains invalid chars');
    end;
    if S<>'' then
      FRootJsonObj := TJSONObject.create(S)
    else
      FRootJsonObj := TJSONObject.create();
    FCurJsonObj := FRootJsonObj;
    FCurJsonList := nil;
  end;
  FJsonInited := True;
end;

constructor TCtObjJsonSerialer.Create(const fn: string; fm: Word);
begin
  inherited;

  FInnerFileStream := TFileStream.Create(fn, fm);
  FStream := FInnerFileStream;

  FRootJsonObj := TJSONObject.create;
  FCurJsonObj := FRootJsonObj;
  FCurJsonList := nil;
end;

destructor TCtObjJsonSerialer.Destroy;
begin
  EndJsonWrite;

  FreeAndNil(FRootJsonObj);

  if Assigned(FInnerFileStream) then
    FreeAndNil(FInnerFileStream);
  inherited;
end;

procedure TCtObjJsonSerialer.EndChildren(AGroupName: string);
begin
  inherited; //FChildCounter减1

  FCurJsonObj := FJsonObjStack[FChildCounter];
  SetLength(FJsonObjStack, FChildCounter);

  FCurJsonList := FJsonListStack[FChildCounter];
  SetLength(FJsonListStack, FChildCounter);
end;

procedure TCtObjJsonSerialer.EndJsonWrite;
var
  S: string;
begin
  if FWriteEnded then
    Exit;

  if not FIsReadMode and Assigned(FStream) then
  begin
    S := FRootJsonObj.toString(2);
    S := EncodeString(S);
    FStream.Write(PChar(S)^, Length(S));
  end;
  FWriteEnded := True;
end;

procedure TCtObjJsonSerialer.ReadBool(const PropName: string;
  var PropValue: Boolean);
begin
  PropValue := FCurJsonObj.optBoolean(PropName);
end;

procedure TCtObjJsonSerialer.ReadBuffer(const PropName: string;
  const Len: LongInt; var PropValue);
var
  S: string;
begin
  if PropName = 'CTVER' then
  begin
    if Self.CurCtVer > 0 then
    begin
      S := 'CT' + IntToStr(Self.CurCtVer);
      Move(Pointer(S)^, PropValue, Length(S));
      Exit;
    end;
  end;

  inherited;
end;

procedure TCtObjJsonSerialer.ReadString(const PropName: string; var PropValue: string);
begin
  CheckInitJson;
  PropValue := FCurJsonObj.optString(PropName);
end;

procedure TCtObjJsonSerialer.ReadStrings(const PropName: string;
  var PropValue: string);
begin
  ReadString(PropName, PropValue);
end;

procedure TCtObjJsonSerialer.SetRootName(const Value: string);
begin
  inherited;
  FRootJsonObj.put('RootName', Value);
end;

procedure TCtObjJsonSerialer.WriteBool(const PropName: string;
  const PropValue: Boolean);
begin
  if FWriteEmptyVals or PropValue then
    FCurJsonObj.put(PropName, PropValue);
end;

procedure TCtObjJsonSerialer.WriteBuffer(const PropName: string;
  const Len: LongInt; const PropValue);
begin
  if PropName = 'CTVER' then
  begin
    if FCtVerWritten then
      Exit;
    FCtVerWritten := True;
  end;
  inherited;
end;

procedure TCtObjJsonSerialer.WriteByte(const PropName: string;
  const PropValue: Byte);
begin
  if FWriteEmptyVals or (PropValue <> 0) then
    inherited;
end;

procedure TCtObjJsonSerialer.WriteDate(const PropName: string;
  const PropValue: TDateTime);
begin
  if FWriteEmptyVals or (PropValue > 0) then
    inherited;
end;

procedure TCtObjJsonSerialer.WriteFloat(const PropName: string;
  const PropValue: Double);
var
  vint: Integer;
begin
  if FWriteEmptyVals or (PropValue <> 0) then
  begin
    vint := Round(PropValue);
    if (vint * 1.0) = PropValue then
      FCurJsonObj.put(PropName, vint)
    else
      FCurJsonObj.put(PropName, PropValue);
  end;
end;

procedure TCtObjJsonSerialer.WriteInteger(const PropName: string;
  const PropValue: Integer);
begin
  if FWriteEmptyVals or (PropValue <> 0) then
    FCurJsonObj.put(PropName, PropValue);
end;

procedure TCtObjJsonSerialer.WriteString(const PropName: string;
  const PropValue: string);
begin
  if FWriteEmptyVals or (PropValue <> '') then
    FCurJsonObj.put(PropName, PropValue);
end;

procedure TCtObjJsonSerialer.WriteStrings(const PropName: string;
  const PropValue: string);
begin
  if FWriteEmptyVals or (PropValue <> '') then
    FCurJsonObj.put(PropName, PropValue);
end;

{ TCtObjMemJsonSerialer }

constructor TCtObjMemJsonSerialer.Create(bIsReadMode: Boolean);
begin
  inherited;
  FStream := TMemoryStream.Create;
end;

destructor TCtObjMemJsonSerialer.Destroy;
begin
  EndJsonWrite;
  FreeAndNil(FStream);
  inherited;
end;

end.

