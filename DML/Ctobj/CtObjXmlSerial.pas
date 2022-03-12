unit CtObjXmlSerial;

{$MODE Delphi}
{$WARN 4055 off : Conversion between ordinals and pointers is not portable}
{$WARN 4082 off : Converting pointers to signed integers may result in wrong comparison results and range errors, use an unsigned type instead.}
interface

uses
  Classes, LCLIntf, LCLType, SysUtils, Variants,
  CtObjSerialer,
  Laz2_DOM, laz2_XMLRead, laz2_XMLWrite;

type

  { TCtObjXmlSerialer }

  TCtObjXmlSerialer = class(TCtObjSerialer)
  private
    FInnerFileStream: TFileStream;
    FStream: TStream;
    FTempMemStream: TMemoryStream;
    FXmlDoc: TXMLDocument;
    FCurXmlSec: string;
    FCurXMLNode: TDOMNode;
    FWriteInited: boolean;
    FWriteEnded: boolean;
    FCtVerWritten: boolean;
  protected
  public
    constructor Create(bIsReadMode: boolean); overload; override;
    constructor Create(const fn: string; fm: word); overload; override;
    destructor Destroy; override;
    procedure EndXmlWrite; virtual;

    //生成当章节对应的XML
    procedure CheckCurXmlSec(bRead: boolean);
    procedure CheckPostCurXml;

    procedure EndObject(bRead: boolean; AID: string); override;
                                 
    procedure BeginChildren(AGroupName: string); override; //开始后可能会直接写一个Count
    procedure EndChildren(AGroupName: string); override;

    //读写字符串
    procedure ReadString(const PropName: string; var PropValue: string); override;
    procedure WriteString(const PropName: string; const PropValue: string); override;
    procedure ReadStrings(const PropName: string; var PropValue: string); override;
    procedure WriteStrings(const PropName: string; const PropValue: string); override;

    procedure WriteInteger(const PropName: string; const PropValue: integer); override;
    procedure WriteFloat(const PropName: string; const PropValue: double); override;

    procedure WriteBool(const PropName: string; const PropValue: boolean); override;
    procedure WriteByte(const PropName: string; const PropValue: byte); override;
    procedure WriteDate(const PropName: string; const PropValue: TDateTime); override;

    procedure ReadBuffer(const PropName: string; const Len: longint;
      var PropValue); override;
    procedure WriteBuffer(const PropName: string; const Len: longint;
      const PropValue); override;

    property Stream: TStream read FStream write FStream;
  end;

  TCtObjMemXmlStream = class(TCtObjXmlSerialer)
  public
    constructor Create(bIsReadMode: boolean); override;
    destructor Destroy; override;
  end;

implementation

uses Dialogs;
//顺序读取指定的TAG内容

function ReadXmlTag(Stream: TStream; const Tag: string; var Value: string): boolean;
var
  I, L, Ia, p1, p2: integer;
  S: string;
  Buf: char;
begin
  Result := False;

  I := 0;
  L := 4096;
  SetLength(Value, L);

  //一直往下循环，直到找到TAG头
  while True do
  begin
    //定位到下一个TAG, 以<开头
    Buf := #0;
    while True do
    begin
      if Stream.Read(Buf, 1) = 1 then
      begin
        if Buf = #60 then //'<'
          Break;
      end
      else //找不到: 退出
      begin
        SetLength(Value, 0);
        Value := '';
        Exit;
      end;
    end;

    //读取TAG头内容，以>结束
    I := 1;
    Value[1] := Buf;
    while True do
    begin
      if Stream.Read(Pointer(PtrInt(Pointer(Value)) + I)^, 1) = 1 then
      begin
        Inc(I);
        if Value[I] = #62 then //'>'
          Break;
        if I >= L then
        begin
          L := L + 4096;
          SetLength(Value, L);
        end;
      end
      else //找不到: 退出
      begin
        SetLength(Value, 0);
        Value := '';
        Exit;
      end;
    end;

    if Copy(Value, 2, Length(Tag)) = Tag then //找到了？
      if Pos(Value[Length(Tag) + 2], ' />'#9#13#10) > 0 then //全字匹配
        Break;
  end;

  Result := True;

  if (I > 3) and (Value[I - 1] = '/') then //<tag />形式的结束标志？
  begin
    SetLength(Value, I);
    Exit;
  end;

  //增大缓存
  L := 4096 + Length(Value);
  SetLength(Value, L);

  //一直往下循环，直到找到TAG结束
  while True do
  begin
    //定位到下一个TAG, 以<开头
    while True do
    begin
      if Stream.Read(Pointer(PtrInt(Pointer(Value)) + I)^, 1) = 1 then
      begin
        Inc(I);
        if Value[I] = #60 then //'<'
          Break;
        if I >= L then
        begin
          L := L + 4096;
          SetLength(Value, L);
        end;
      end
      else //找不到: 退出
      begin
        SetLength(Value, I);
        Exit;
      end;
    end;

    //读取TAG头内容，以>结束
    Ia := I;
    while True do
    begin
      if Stream.Read(Pointer(PtrInt(Pointer(Value)) + I)^, 1) = 1 then
      begin
        Inc(I);
        if Value[I] = #62 then //'>'
          Break;
        if I >= L then
        begin
          L := L + 4096;
          SetLength(Value, L);
        end;
      end
      else //找不到: 退出
      begin
        SetLength(Value, I);
        Exit;
      end;
    end;

    S := Copy(Value, Ia, I);
    p1 := Pos('/', S);
    p2 := Pos(Tag + '>', S);
    //找到了？格式：<__/__tag>
    if (p1 > 0) and (S[1] = '<') and (p2 > 0) and (p2 > p1) and
      (Trim(Copy(S, 2, p1 - 2)) = '') and (Trim(Copy(S, p1 + 1, p2 - p1 - 1)) = '') then
    begin
      SetLength(Value, I);
      Break;
    end;
  end;

end;

{ TCtObjXmlSerialer }


procedure TCtObjXmlSerialer.CheckCurXmlSec(bRead: boolean);
var
  S, V: string;
begin
  if FCurXmlSec = FSection then
    Exit;

  CheckPostCurXml;

  if not Assigned(FStream) then
    raise Exception.Create('DataStream unspecified');

  FCurXmlSec := FSection;
  FCurXMLNode := nil;
  if Assigned(FXmlDoc) then
    FreeAndNil(FXmlDoc);
  if not Assigned(FTempMemStream) then
    FTempMemStream := TMemoryStream.Create;

  if bRead then
  begin
    V := '';
    if not ReadXmlTag(FStream, FCurXmlSec, V) then
    begin
      FStream.Seek(0, soFromBeginning);
      ReadXmlTag(FStream, FCurXmlSec, V);
    end;
    if Trim(V)='' then
      Exit;
    //if IsUtf8 then
    V := '<?xml version="1.0" encoding="UTF8"?>' + DecodeString(V);

    //ShowMessage(V);

    //with TStringList.Create do
    //try
    //  Text :=  V;
    //  SaveToFile('/Users/admin/Documents/tt.xml');
    //finally
    //  Free;
    //end;

    FTempMemStream.Clear;
    FTempMemStream.WriteBuffer(PChar(V)^, Length(V));
    FTempMemStream.Position := 0;
    try
    ReadXmlFile(FXmlDoc, FTempMemStream);
    FCurXMLNode := FXmlDoc.FindNode(FCurXmlSec);

    except
      ShowMEssage(FCurXmlSec+' '+V);
      raise;
    end;
  end
  else
  begin
    FXmlDoc := TXMLDocument.Create;
    FCurXMLNode := FXmlDoc.CreateElement(FCurXmlSec);
    FXmlDoc.Appendchild(FCurXMLNode);
    if not FWriteInited then
    begin
      S := '<?xml version="1.0" encoding="UTF-8"?>'#13#10'<CTOXML>'#13#10;
      FStream.WriteBuffer(Pointer(S)^, Length(S));
      FWriteInited := True;
    end;
  end;

end;

procedure TCtObjXmlSerialer.CheckPostCurXml;
var
  S: string;
  po, L: integer;
begin
  if not FIsReadMode and Assigned(FXmlDoc) and Assigned(FStream) and
    (FCurXmlSec <> '') then
  begin
    if not FWriteInited then
      Exit;
    if not Assigned(FTempMemStream) then
      FTempMemStream := TMemoryStream.Create;
    FTempMemStream.Clear;
    WriteXmlFile(FXmlDoc, FTempMemStream);

    L := FTempMemStream.Size;
    SetLength(S, L);
    FTempMemStream.Position := 0;
    FTempMemStream.ReadBuffer(PChar(S)^, L);
    if Pos('<?xml version="', S) = 1 then
    begin
      po := Pos('?>', S);
      if po > 0 then
      begin
        S := Copy(S, po + 2, Length(S));
        if Copy(S, 1, 2) = #13#10 then
          S := Copy(S, 3, Length(S));
      end;
    end;
    //if NeedUtf8Convert then
    //  S := EncodeString(S);
    S := S + #13#10;
    FStream.Write(Pointer(S)^, Length(S));
    FCurXmlSec := '';
  end;
end;

constructor TCtObjXmlSerialer.Create(bIsReadMode: boolean);
begin
  inherited;
end;

constructor TCtObjXmlSerialer.Create(const fn: string; fm: word);
begin
  inherited;
  FInnerFileStream := TFileStream.Create(fn, fm);
  FStream := FInnerFileStream;
end;

destructor TCtObjXmlSerialer.Destroy;
begin
  FCurXMLNode := nil;
  try
    EndXmlWrite;
  except
  end;


  if Assigned(FXmlDoc) then
    FXmlDoc := nil;
  if Assigned(FInnerFileStream) then
    FreeAndNil(FInnerFileStream);
  if Assigned(FTempMemStream) then
    FreeAndNil(FTempMemStream);
  inherited;
end;

procedure TCtObjXmlSerialer.EndObject(bRead: boolean; AID: string);
begin
  inherited;
  CheckPostCurXml;
end;

procedure TCtObjXmlSerialer.BeginChildren(AGroupName: string);
begin
  inherited BeginChildren(AGroupName); 
  if not IsReadMode then
    CheckCurXmlSec(False);
end;

procedure TCtObjXmlSerialer.EndChildren(AGroupName: string);
begin
  inherited EndChildren(AGroupName);
end;

procedure TCtObjXmlSerialer.EndXmlWrite;
var
  S: string;
begin
  if FWriteEnded then
    Exit;
  CheckPostCurXml;
  if Assigned(FStream) and not FIsReadMode then
  begin
    S := #13#10'</CTOXML>';
    FStream.WriteBuffer(Pointer(S)^, Length(S));
  end;
  FWriteEnded := True;
end;

procedure TCtObjXmlSerialer.ReadBuffer(const PropName: string;
  const Len: longint; var PropValue);
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

procedure TCtObjXmlSerialer.ReadString(const PropName: string; var PropValue: string);

  function GetNodeVal(cnd: TDOMNode): string;
  var
    S, T: string;
  begin
    Result := '';
    if cnd = nil then
      Exit;
    if cnd.ChildNodes <> nil then
    begin
      S := '';
      cnd := cnd.FirstChild;
      while cnd <> nil do
      begin
        if cnd.NodeType = TEXT_NODE then
          S := S + cnd.NodeValue
        else if cnd.NodeType = CDATA_SECTION_NODE then
          S := S + cnd.NodeValue
        else if cnd.NodeType = ENTITY_REFERENCE_NODE then
        begin
          T := cnd.NodeValue;
          if T = '&gt;' then
            T := '>'
          else if T = '&lt;' then
            T := '<'
          else if T = '&lt;' then
            T := '<'
          else if T = '&amp;' then
            T := '&'
          else if T = '&apos;' then
            T := ''''
          else if T = '&quot;' then
            T := '"'
          else
            T := ' ';
          S := S + T;
        end;
        cnd := cnd.NextSibling;
      end;
      Result := S;
    end;
  end;

var
  S: string;
  nd: TDOMNode;
begin
  CheckCurXmlSec(True);
  if FCurXMLNode = nil then
  begin
    PropValue := '';
    Exit;
  end;
  S := PropName;
  try
    nd := FCurXMLNode.FindNode(S);
    PropValue := GetNodeVal(nd);
  except on E: Exception do
    raise Exception.Create('read prop '+FCurXmlSec+'.'+S+' error: '+E.Message);
  end;
  //ShowMessage(nd.NodeName+'='+PropValue+' nodechild:'+IntToStr(nd.GetChildCount));
end;

procedure TCtObjXmlSerialer.ReadStrings(const PropName: string; var PropValue: string);
begin
  ReadString(PropName, PropValue);
end;

procedure TCtObjXmlSerialer.WriteBool(const PropName: string; const PropValue: boolean);
begin
  if PropValue then
    inherited;
end;

procedure TCtObjXmlSerialer.WriteBuffer(const PropName: string;
  const Len: longint; const PropValue);
begin
  if PropName = 'CTVER' then
  begin
    if FCtVerWritten then
      Exit;
    FCtVerWritten := True;
  end;
  inherited;
end;

procedure TCtObjXmlSerialer.WriteByte(const PropName: string; const PropValue: byte);
begin
  if PropValue <> 0 then
    inherited;
end;

procedure TCtObjXmlSerialer.WriteDate(const PropName: string;
  const PropValue: TDateTime);
begin
  if PropValue > 0 then
    inherited;
end;

procedure TCtObjXmlSerialer.WriteFloat(const PropName: string; const PropValue: double);
begin
  if PropValue <> 0 then
    inherited;
end;

procedure TCtObjXmlSerialer.WriteInteger(const PropName: string;
  const PropValue: integer);
begin
  if PropValue <> 0 then
    inherited;
end;

procedure TCtObjXmlSerialer.WriteString(const PropName: string;
  const PropValue: string);
var
  V: String;
  nd, ntxt: TDOMNode;
begin
  CheckCurXmlSec(False);
  if not Assigned(FCurXMLNode) then
    raise Exception.Create('Xml Node not exists');
  //S := PropName;
  V := PropValue;
  if V = '' then
    Exit;
  nd := FXmlDoc.CreateElement(PropName);   
  ntxt := FXmlDoc.CreateTextNode(V);
  nd.AppendChild(ntxt);
  FCurXMLNode.AppendChild(nd);
end;

procedure TCtObjXmlSerialer.WriteStrings(const PropName: string;
  const PropValue: string);
begin
  WriteString(PropName, PropValue);
end;

{ TCtObjMemXmlStream }

constructor TCtObjMemXmlStream.Create(bIsReadMode: boolean);
begin
  inherited;
  FStream := TMemoryStream.Create;
end;

destructor TCtObjMemXmlStream.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

end.


