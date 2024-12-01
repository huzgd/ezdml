unit CtMetaTbUtil;
      
{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, CtMetaData, CtMetaTable;


function TryExtractLogicNameFromMemo(AObj: TCtMetaObject; var AMemo: string): string;
//function TryExtractLogicName(AMemo: string): string;

function GenRandBgColors(tbs: TCtMetaTableList): Integer;

implementation

uses
  WindowFuncs
  {$IFDEF FPC}, LazUTF8 {$ENDIF};

{$IFDEF FPC}
function GetSubWString(s: string; len: integer): string;
begin
  Result := s;
  if Length(Result) > len then
    Result := Copy(Result, 1, len);
end;
                                               
function IsPureAnsiText(S: string): Boolean;
var
  Idx, v: Integer;
begin
  Result := True;
  for Idx := 1 to Length(S) do
  begin
    v := Ord(S[Idx]);
    if (v=9) or (v=10) or (v=13) then
      Continue;
    if (V>=32) and (V<127) then
      Continue;
    Result := False;
    Break;
  end;
end;

function GetSplitPosOfMemo(AMemo: string): integer;
var
  CurP, EndP: PChar;
  Len, po: integer;
  S, V: string;
  bAnsi: Boolean;
begin
  Result := 0;
  S := AMemo;
  if S = '' then
    Exit;
  bAnsi := IsPureAnsiText(S);
  CurP := PChar(S);
  EndP := CurP + length(S);
  po := 1;
  while CurP < EndP do
  begin
    Len := UTF8CodepointSize(CurP);
    V := Copy(S, po, Len);
    //ctalert(V+' s:'+S+' len:'+IntToStr(len));
    if ((V = ' ') and not bAnsi) or
      (V = #13) or
      (V = #10) or
      (V = #9) or
      (V = ':') or
      (V = '.') or
      (V = ',') or
      (V = ';') or
      (V = '(') or
      (V = '[') or
      (V = '{') or
      (V = '~') or
      (V = '!') or
      (V = '@') or
      (V = '#') or
      (V = '$') or
      (V = '%') or
      (V = '^') or
      (V = '*') or
      (V = '-') or
      (V = '=') or
      (V = '/') or
      (V = '\') or
      (V = '|') or
      (V = '+') or
      (V = '。') or //
      (V = '：') or
      (V = '；') or
      (V = '，') or
      (V = '、') or
      (V = '（') or
      (V = '　')
    then
    begin
      Result := po;
      //ctalert('found result at: '+IntToStr(po));
      Exit;
    end;

    Inc(CurP, Len);
    Inc(po, Len);
  end;

end;

function TryExtractLogicName(var AMemo: string): string;
var
  po: integer;
begin
  if AMemo = '' then
  begin
    Result := '';
    Exit;
  end;
  po := GetSplitPosOfMemo(AMemo);
  if (po > 0) and (DmlStrLength(Copy(AMemo, 1, po-1)) > 32) then
  begin
    Result := '';
  end
  else if po > 2 then
  begin
    Result := GetSubWString(AMemo, po - 1);
  end
  else
  begin
    if (po = 1) or (Ord(AMemo[1]) >= Ord('0')) and (Ord(AMemo[1]) <= Ord('9')) then
    begin
      Result := '';
    end
    else if DmlStrLength(AMemo) > 32 then
    begin
      Result := '';
    end
    else
    begin
      Result := AMemo;
      AMemo := '';
    end;
  end;
end;

function TryExtractLogicNameFromMemo(AObj: TCtMetaObject; var AMemo: string): string;
var
  I, po: integer;
  S: string;
begin
  if AMemo = '' then
  begin
    Result := '';
    Exit;
  end;
  if AObj <> nil then
  begin
    po := GetSplitPosOfMemo(AMemo); //查找分隔符
    //ctalert(AMemo+#13#10' resPos:'+IntToStr(po)+ ' strLen'+IntToStr(Length(AMemo)) + ' strDmlLen'+IntToStr(DmlStrLength(AMemo)));
    if (po > 0) or
      (Ord(AMemo[1]) >= Ord('0')) and (Ord(AMemo[1]) <= Ord('9')) then
      //备注中有分隔符或以数字开头
    begin
      //分隔符长度超过32就不要了
      if DmlStrLength(Copy(AMemo, 1, po-1)) > 32 then
      begin
        Result := '';
        //ctalert(Copy(AMemo, 1, po)+' LLL'+IntToStr(po)+' too long 32 '+IntToStr(DmlStrLength(Copy(AMemo, 1, po))));
        Exit;
      end;
      S := AObj.Name;
      for I := 1 to Length(S) - 1 do
        if (Ord(S[i]) >= 129) then
        begin
          //名称中已经有汉字，不需要逻辑名
          Result := '';
        //ctalert('名称中已经有汉字');
          Exit;
        end;
    end;
  end;
  Result := TryExtractLogicName(AMemo);
  //ctalert('res:'+result);
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    S := GProc_OnEzdmlCmdEvent('EXTRACT_LOGIC_NAME_FROM_MEMO', AMemo, Result, AObj, nil);
    if S <> '' then
      Result := S;
  end;
end;
{$ELSE}

{
function GetSubWString(s: string; len: integer): string;
var
  ws: WideString;
  s1: string;
begin
  ws := s;
  if Length(ws) > len then
    ws := Copy(ws, 1, len);
  while True do
  begin
    s1 := ws;
    if Length(s1) <= len then
      Break;
    ws := Copy(ws, 1, Length(ws) - 1);
  end;
  Result := ws;
end;   }

function GetSplitPosOfMemo(AMemo: WideString): integer;
var
  I: integer;
begin
  Result := 0;
  for I := 1 to Length(AMemo) - 1 do
    if (AMemo[I] = ' ') or
      (AMemo[I] = #13) or
      (AMemo[I] = #10) or
      (AMemo[I] = #9) or
      (AMemo[I] = ':') or
      (AMemo[I] = '.') or
      (AMemo[I] = ',') or
      (AMemo[I] = ';') or
      (AMemo[I] = '(') or
      (AMemo[I] = '[') or
      (AMemo[I] = '{') or
      (AMemo[I] = '~') or
      (AMemo[I] = '!') or
      (AMemo[I] = '@') or
      (AMemo[I] = '#') or
      (AMemo[I] = '$') or
      (AMemo[I] = '%') or
      (AMemo[I] = '^') or
      (AMemo[I] = '*') or
      (AMemo[I] = '-') or
      (AMemo[I] = '=') or
      (AMemo[I] = '/') or
      (AMemo[I] = '\') or
      (AMemo[I] = '|') or
      (AMemo[I] = '+') or
      (AMemo[I] = '。') or
      (AMemo[I] = '：') or
      (AMemo[I] = '；') or
      (AMemo[I] = '，') or
      (AMemo[I] = '、') or
      (AMemo[I] = '（') or
      (AMemo[I] = '　')
    then
    begin
      Result := I;
      Break;
    end;
end;

function TryExtractLogicName(var AMemo: WideString): WideString;
var
  po: integer;
begin
  if AMemo = '' then
  begin
    Result := '';
    Exit;
  end;
  po := GetSplitPosOfMemo(AMemo);
  if po > 32 then
  begin
    Result := '';
  end
  else if po > 2 then
  begin
    //Result := GetSubWString(AMemo, po - 1);
    Result := Copy(AMemo, 1, po - 1);
  end
  else
  begin
    if (po = 1) or (Ord(AMemo[1]) >= Ord('0')) and (Ord(AMemo[1]) <= Ord('9')) then
    begin
      Result := '';
    end
    else if Length(AMemo) > 32 then
    begin
      Result := '';
    end
    else
    begin
      Result := AMemo;
      AMemo := '';
    end;
  end;
end;

function TryExtractLogicNameFromMemoEx(AObj: TCtMetaObject;
  var AMemo: WideString): WideString;
var
  I, po: integer;
  S: WideString;
begin
  if AMemo = '' then
  begin
    Result := '';
    Exit;
  end;
  if AObj <> nil then
  begin
    po := GetSplitPosOfMemo(AMemo); //查找分隔符
    if (po > 0) or
      (Ord(AMemo[1]) >= Ord('0')) and (Ord(AMemo[1]) <= Ord('9')) then
      //备注中有分隔符或以数字开头
    begin
      //分隔符长度超过32就不要了
      if po > 32 then
      begin
        Result := '';
        Exit;
      end;
      S := AObj.Name;
      for I := 1 to Length(S) - 1 do
        if (Ord(S[i]) >= 129) then
        begin
          //名称中已经有汉字，不需要逻辑名
          Result := '';
          Exit;
        end;
    end;
  end;
  Result := TryExtractLogicName(AMemo);
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    S := GProc_OnEzdmlCmdEvent('EXTRACT_LOGIC_NAME_FROM_MEMO', AMemo, Result, AObj, nil);
    if S <> '' then
      Result := S;
  end;
end;

function TryExtractLogicNameFromMemo(AObj: TCtMetaObject; var AMemo: string): string;
var
  VMemo: WideString;
begin
  VMemo := AMemo;
  Result := TryExtractLogicNameFromMemoEx(AObj, VMemo);
  AMemo := VMemo;
end;

{$ENDIF}

function GenRandBgColors(tbs: TCtMetaTableList): Integer;

  function GetLinkCount(atb: TCtMetaTable): Integer;
  var
    tbN: string;
    J, K: Integer;
    fd: TCtMetaField;   
    tb: TCtMetaTable;
  begin
    Result := 0;
    for K:=0 to atb.MetaFields.Count -1 do
    begin
      fd := atb.MetaFields.Items[K];
      if (fd.RelateTable <> '') and (fd.RelateField <> '') then
        Inc(Result);
    end;

    tbN := atb.Name;
    for J:=0 to tbs.Count-1 do
    begin
      tb := tbs.Items[J];
      if tb=atb then
        Continue;
      for K:=0 to tb.MetaFields.Count -1 do
      begin
        fd := tb.MetaFields.Items[K];
        if fd.DataLevel = ctdlDeleted then
          Continue;
        if (UpperCase(fd.RelateTable)=UpperCase(tbN)) and (fd.RelateField<>'') then
        begin
          Inc(Result);
        end;
      end;
    end;
  end;

  function GetRandColor(lkC: Integer): Integer;
  var
    r, g, b, lk, dd: Integer;
  begin
    lk := lkC+1;
    lk := lk*lk;
    if lk>48 then
      lk := 48;
    if lk<10 then
      lk := 10;

    while True do
    begin
      r := 245-Random(lk);
      g := 245-Random(lk);
      b := 245-Random(lk);
      dd := Abs(r-g)+Abs(g-b);
      if dd>12 then
        Break;
    end;
    Result := r+(g shl 8) + (b shl 16);
  end;
var
  I, K: Integer;
  tb: TCtMetaTable;
begin
  Result := 0;
  for I:=0 to tbs.Count-1 do
  begin
    tb := tbs.Items[I];
    if (tb.BgColor<>0) and (tb.BgColor<>$ffffff) then
      Continue;
    K := GetLinkCount(tb);
    if K>=2 then
    begin
      tb.BgColor := GetRandColor(K);
      Inc(Result);
    end;
  end;
end;

end.

