unit AutoNameCapitalize;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Classes, SysUtils, WindowFuncs, Controls, Forms,
  CtMetaData, CtMetaTable, IniFiles, contnrs;

type
  TAutoNameCapitalize = class
  protected
    FKeyWordFile: string;
    FKeywordNs: TStringList;
    FMyKeywordNs: TStringList;
    FLenKeyWords: array of TFPDataHashTable;   
    FCommonWords: TFPObjectHashTable;
    FRecoResults: THashedStringList;
    function DoAutoCapitalizeEx(AName: string): string;
  public
    destructor Destroy; override;
    procedure ReloadDictFile;

    function DoAutoCapitalize(AName: string): string;
    function DoCheckCustomDict(AObj: TObject; AName: string): string;

    function DoCheck(AName: string): string;
  end;

  TEzNameWordInfo=class
  public
    Name: string;
    Value: string;
    Score: Integer;
  end;


function CheckAutoCapitalize(AName: string): string;
function GetAutoNameCapitalizer: TAutoNameCapitalize;
function CamelCaseToUnderline(AName: string): string;
function UnderlineToCamelCase(AName: string): string;

function AutoCapProc(AName, sType: string): string;

procedure DoAutoCapProcess(ACtObj: TCtMetaObject; sType: string);

implementation


uses
  CtMetaTbUtil{$ifndef EZDML_LITE}, CnWordSeg{$endif}, UCNSpell, ezdmlstrs;


var
  DefAutoNameCapitalizer: TAutoNameCapitalize;

{$ifdef EZDML_LITE}
function ChnToPY(str: string): string;
begin
  Result := MakeSpellCode(str, 1, Length(str));
end;
{$endif}

function GetAutoNameCapitalizer: TAutoNameCapitalize;
begin
  if DefAutoNameCapitalizer = nil then
  begin
    DefAutoNameCapitalizer := TAutoNameCapitalize.Create;
    DefAutoNameCapitalizer.ReloadDictFile;
  end;
  Result := DefAutoNameCapitalizer;
end;

function CheckAutoCapitalize(AName: string): string;
begin
  Result := GetAutoNameCapitalizer.DoCheck(AName);
end;

function CamelCaseToUnderline(AName: string): string;
var
  I, L: integer;
  ch: char;
begin
  I := 1;
  L := Length(AName);
  Result := '';
  while I <= L do
  begin
    ch := AName[I];
    if (ch >= 'A') and (ch <= 'Z') then
    begin
      if (Result <> '') and (Result[Length(Result)] <> '_') then
        Result := Result + '_' + LowerCase(ch)
      else
        Result := Result + LowerCase(ch);
      Inc(I);
      while I <= L do
      begin
        ch := AName[I];
        if (ch >= 'A') and (ch <= 'Z') then
        begin
          Result := Result + LowerCase(ch);
          Inc(I);
        end
        else
          Break;
      end;
    end
    else
    begin
      Result := Result + ch;
      Inc(I);
    end;
  end;
end;

function UnderlineToCamelCase(AName: string): string;
var
  I, L: integer;
  ch: char;
  bNextWord: boolean;
begin
  I := 1;
  L := Length(AName);
  Result := '';
  bNextWord := False;
  while I <= L do
  begin
    ch := AName[I];
    if (ch = '_') then
    begin
      bNextWord := True;
      Inc(I);
    end
    else
    begin
      if bNextWord then
      begin
        bNextWord := False;
        if (ch >= 'a') and (ch <= 'z') then
          Result := Result + UpperCase(ch)
        else
          Result := Result + ch;
      end
      else
        Result := Result + ch;
      Inc(I);
    end;
  end;
end;


function AutoCapProc(AName, sType: string): string;
  function CheckAllUpper(str: string): string;
  begin
    Result := str;
    if Result = '' then
      Exit;
    if Trim(str)=str then
      if (UpperCase(str)=str) and (LowerCase(str) <> str) then
      begin
        if str[1] >= 'A' then
          if str[1] <= 'Z' then
            Result := str[1] + LowerCase(Copy(str, 2, Length(str)));
      end;
  end;
  function CanUnCap(str: string): Boolean;
  var
    L: Integer;
  begin
    Result := False;
    L := Length(str);
    if L=0 then
      Exit;
    if (str[1] >='A') and (str[1] <='Z') then
    begin
      if L=2 then
        if (str[2] >='A') and (str[2] <='Z') then
          Exit;
      if L>=3 then
        if (str[2] >='A') and (str[2] <='Z') then
          if (str[3] >='A') and (str[3] <='Z') then
            Exit;
      Result := True;
    end;
  end;

  function GetTbNamePref: String;
  var
    I: Integer;
  begin
    Result := '';
    for I := 0 to High(CtTbNamePrefixDefs) do
      if Pos(CtTbNamePrefixDefs[i], AName) = 1 then
      begin
        Result :=CtTbNamePrefixDefs[i];
        Break;
      end;
  end;

var
  prfH: string;
begin
  Result := AName;
  prfH := GetTbNamePref;

  sType := LowerCase(sType);
  if sType = LowerCase('AutoCapitalize') then
  begin
    Result := CheckAutoCapitalize(Result);
  end
  else if sType = LowerCase('UpperCase') then
  begin
    Result := Uppercase(Result);
  end
  else if sType = LowerCase('LowerCase') then
  begin
    Result := LowerCase(Result);
  end       
  else if sType = LowerCase('Capitalize') then
  begin
    if (Result[1] >='a') and (Result[1] <='z') then
      Result := UpperCase(Result[1])+Copy(Result,2,Length(Result));
  end     
  else if sType = LowerCase('UnCapitalize') then
  begin
    if CanUnCap(Result) then
      Result := LowerCase(Result[1])+Copy(Result,2,Length(Result));
  end
  else if sType = LowerCase('CamelCaseToUnderline') then
  begin
    Result := CamelCaseToUnderline(Result);
  end
  else if sType = LowerCase('UnderlineToCamelCase') then
  begin
    Result := UnderlineToCamelCase(Result);
  end
  else if sType = 'CnWordSegment' then
  begin                 
  {$ifndef EZDML_LITE}
    Result := CheckCnWordSeg(Result);
  {$else}
    raise Exception.Create(srEzdmlLiteNotSupportFun);
  {$endif}
  end
  else if sType = LowerCase('ChnToPY') then
  begin
    Result := ChnToPY(Result);
  end
  else if sType = LowerCase('ClassName') then
  begin
    Result := CheckAllUpper(Result);
    Result := AutoCapProc(Result,'ChnToPY');  
    Result := AutoCapProc(Result,'UnderlineToCamelCase');   
    Result := AutoCapProc(Result,'Capitalize');
  end      
  else if sType = LowerCase('ClassNameSafe') then
  begin                             
    Result := CheckAllUpper(Result);
    Result := AutoCapProc(Result,'ChnToPY');
    if IsReservedKeyworkd(Result) then
      Result := 'Ez_'+Result;
    Result := AutoCapProc(Result,'UnderlineToCamelCase');
    Result := AutoCapProc(Result,'Capitalize');
  end
  else if sType = LowerCase('PackageName') then
  begin
    Result := AutoCapProc(Result,'ChnToPY'); 
    Result := AutoCapProc(Result,'CamelCaseToUnderline');
  end               
  else if sType = LowerCase('JavaPackageName') then
  begin
    Result := AutoCapProc(Result,'ChnToPY');
    Result := AutoCapProc(Result,'UnderlineToCamelCase');
    Result := AutoCapProc(Result,'LowerCase');
  end
  else if sType = LowerCase('FieldName') then
  begin
    if prfH<>'' then
      Result := Copy(Result, Length(prfH)+1, Length(result));
    Result := CheckAllUpper(Result);
    Result := AutoCapProc(Result,'ChnToPY');
    Result := AutoCapProc(Result,'UnderlineToCamelCase');
    Result := AutoCapProc(Result,'UnCapitalize');
    if prfH<>'' then
      Result := prfH + Result;
  end
  else if sType = LowerCase('FieldNameSafe') then
  begin
    if prfH<>'' then
      Result := Copy(Result, Length(prfH)+1, Length(result));
    Result := CheckAllUpper(Result);
    Result := AutoCapProc(Result,'ChnToPY');    
    if IsReservedKeyworkd(Result) then
      Result := 'Ez_'+Result;
    Result := AutoCapProc(Result,'UnderlineToCamelCase');
    Result := AutoCapProc(Result,'UnCapitalize'); 
    if prfH<>'' then
      Result := prfH + Result;
  end;
end;

procedure DoAutoCapProcess(ACtObj: TCtMetaObject; sType: string);
var
  S, V: string;
  I: Integer;
begin
  if ACtObj = nil then
    Exit;
  if sType = 'AutoCapitalize' then
  begin
    if ACtObj is TCtMetaTable then
    begin
      S := ACtObj.Name;
      V := '';
      for I := 0 to High(CtTbNamePrefixDefs) do
        if Pos(UpperCase(CtTbNamePrefixDefs[i]), UpperCase(S)) = 1 then
        begin
          S := Copy(S, Length(CtTbNamePrefixDefs[i]) + 1, Length(S));
          V := CtTbNamePrefixDefs[i];
          Break;
        end;       
      S := CheckAutoCapitalize(S);
      ACtObj.Name := V + S;
    end
    else
      ACtObj.Name := CheckAutoCapitalize(ACtObj.Name);
  end
  else if sType = 'UpperCase' then
  begin
    ACtObj.Name := Uppercase(ACtObj.Name);
  end
  else if sType = 'LowerCase' then
  begin
    ACtObj.Name := LowerCase(ACtObj.Name);
  end
  else if sType = 'CamelCaseToUnderline' then
  begin
    S := CamelCaseToUnderline(ACtObj.Name);
    if ACtObj is TCtMetaTable then
      CheckCanRenameTable(TCtMetaTable(ACtObj), S, True);
    ACtObj.Name := S;
  end
  else if sType = 'UnderlineToCamelCase' then
  begin                        
    S := ACtObj.Name;
    V := '';
    if ACtObj is TCtMetaTable then
    begin
      for I := 0 to High(CtTbNamePrefixDefs) do
        if Pos(UpperCase(CtTbNamePrefixDefs[i]), UpperCase(S)) = 1 then
        begin
          S := Copy(S, Length(CtTbNamePrefixDefs[i]) + 1, Length(S));
          V := CtTbNamePrefixDefs[i];
          Break;
        end;
    end;      
    S := UnderlineToCamelCase(S);
    S := V + S;
    if ACtObj is TCtMetaTable then
      CheckCanRenameTable(TCtMetaTable(ACtObj), S, True);
    ACtObj.Name := S;
  end
  else if sType = 'ChnToPY' then
  begin
    S := ChnToPY(ACtObj.Name);
    if S <> ACtObj.Name then
    begin   
      if ACtObj is TCtMetaTable then
        CheckCanRenameTable(TCtMetaTable(ACtObj), S, True);
      if ACtObj is TCtMetaField then
      begin
        if (TCtMetaField(ACtObj).DisplayName = '') or (TCtMetaField(ACtObj).DisplayName=ACtObj.Name) then
          TCtMetaField(ACtObj).DisplayName := ACtObj.Name
        else if ACtObj.Memo='' then
          ACtObj.Memo := ACtObj.Name;
      end
      else
      begin
        if (ACtObj.Caption = '') or (ACtObj.Caption=ACtObj.Name) then
          ACtObj.Caption := ACtObj.Name
        else if ACtObj.Memo='' then
          ACtObj.Memo := ACtObj.Name;
      end;
      ACtObj.Name := S;
    end;
  end
  else if sType = 'CnWordSegment' then
  begin                   
  {$ifndef EZDML_LITE}
    S := CheckCnWordSeg(ACtObj.Name);
    if ACtObj is TCtMetaTable then
      CheckCanRenameTable(TCtMetaTable(ACtObj), S, True);
    ACtObj.Name := S;
  {$else}
    raise Exception.Create(srEzdmlLiteNotSupportFun);
  {$endif}
  end
  else if sType = 'CommentToLogicName' then
  begin
    if ACtObj is TCtMetaField then
      S := TCtMetaField(ACtObj).DisplayName
    else
      S := ACtObj.Caption;
    if S = '' then
    begin
      S := ACtObj.Memo;
      V := TryExtractLogicNameFromMemo(ACtObj, S);
      ACtObj.Memo := S;
    end
    else
    begin
      V := ACtObj.Memo;
      ACtObj.Memo := S;
    end;
    if ACtObj is TCtMetaField then
      TCtMetaField(ACtObj).DisplayName := V
    else
      ACtObj.Caption := V;
  end
  else if sType = 'CheckMyDict' then
  begin
    ACtObj.Name := GetAutoNameCapitalizer.DoCheckCustomDict(ACtObj, ACtObj.Name);
  end
  else if sType = 'NameToLogicName' then
  begin
    if ACtObj is TCtMetaField then
    begin
      S := TCtMetaField(ACtObj).DisplayName;
      TCtMetaField(ACtObj).DisplayName := ACtObj.Name;
      if S <> '' then
      begin
        if ACtObj is TCtMetaTable then
          CheckCanRenameTable(TCtMetaTable(ACtObj), S, True);
        ACtObj.Name := S;
      end;
    end
    else
    begin
      S := ACtObj.Caption;
      ACtObj.Caption := ACtObj.Name;
      if S <> '' then
      begin
        if ACtObj is TCtMetaTable then
          CheckCanRenameTable(TCtMetaTable(ACtObj), S, True);
        ACtObj.Name := S;
      end;
    end;
  end;
end;

{ TAutoNameCapitalize }

destructor TAutoNameCapitalize.Destroy;
var
  I: Integer;
begin
  FreeAndNil(FCommonWords);
  FreeAndNil(FKeywordNs);
  FreeAndNil(FMyKeywordNs);
  FreeAndNil(FRecoResults);
  for I:=0 to High(FLenKeyWords) do
    FLenKeyWords[I].Free;
  SetLength(FLenKeyWords, 0);
  inherited;
end;

{$ifdef EZDML_LITE}
function TAutoNameCapitalize.DoAutoCapitalizeEx(AName: string): string;
begin
  Result := '';
end;
{$else} 
{$I AutoCap1.inc}
{$endif}

function TAutoNameCapitalize.DoAutoCapitalize(AName: string): string;

  function IsWordOk(AStr: string; DeepLevel: integer): string;
  var
    I, J, L: integer;
    S1, S2, S3: string;
  begin
    Result := '';
    L := Length(AStr);
    if (L <= 1) then
    begin
      Result := AStr;
      Exit;
    end;
    if FKeywordNs.IndexOf(AStr) >= 0 then
    begin
      S1 := AStr;
      Result := UpperCase(S1[1]) + Copy(S1, 2, L);
      Exit;
    end;
    for I := L - 1 downto 1 do
    begin
      S1 := Copy(AStr, 1, I);
      if FKeywordNs.IndexOf(S1) >= 0 then
      begin
        S2 := Copy(AStr, I + 1, L);
        S3 := IsWordOk(S2, DeepLevel + 1);
        if (S2 = '') or (S3 <> '') then
        begin
          Result := UpperCase(S1[1]) + Copy(S1, 2, L) + S3;
          Exit;
        end;
      end;
    end;

    for I := 2 to L - 1 do
      for J := L downto I + 1 do
      begin
        S1 := Copy(AStr, I, J - I + 1);
        if FKeywordNs.IndexOf(S1) >= 0 then
        begin
          S2 := Copy(AStr, J + 1, L);
          S2 := IsWordOk(S2, DeepLevel + 1);
          if S2 <> '' then
          begin
            Result := Copy(AStr, 1, I - 1);
            Result := UpperCase(Result[1]) + Copy(Result, 2, L);
            Result := Result + UpperCase(S1[1]) + Copy(S1, 2, L) + S2;
            Exit;
          end;
        end;
      end;

    if DeepLevel > 1 then
    begin
      S1 := AStr;
      Result := UpperCase(S1[1]) + Copy(S1, 2, L);
    end;
  end;

var
  I, L, K, M: integer;
  S, sL, sR, V: string;
begin
  Result := AName;

{$ifndef EZDML_LITE}
  Result := DoAutoCapitalizeEx(AName);
  Exit;
{$endif}

  if UpperCase(Result) = LowerCase(Result) then
    Exit;

  if (UpperCase(Result) <> Result) and (LowerCase(Result) <> Result) then
    Exit;

  CheckAbort(' ');
  if FKeywordNs.Count = 0 then
    Exit;

  S := LowerCase(AName);
  L := Length(S);
  if L = 0 then
    Exit;
  if FKeywordNs.IndexOf(S) >= 0 then
  begin
    Result := UpperCase(S[1]) + Copy(S, 2, L);
    Exit;
  end;

  K := 1;
  for I := 1 to L do
    if (S[I] >= 'a') and (S[I] <= 'z') then
      Inc(K)
    else
      Break;
  sL := Copy(S, 1, K - 1);

  M := L + 1;
  for I := K to L do
    if (S[I] >= 'a') and (S[I] <= 'z') then
    begin
      M := I;
      Break;
    end;
  sR := Copy(S, M, L);

  S := Copy(S, K, M - K);

  V := IsWordOk(sL, 0);
  if V <> '' then
    sL := V
  else if sL <> '' then
    sL := UpperCase(sL[1]) + Copy(sL, 2, L);
  sR := DoAutoCapitalize(sR);
  Result := sL + S + sR;
end;

function TAutoNameCapitalize.DoCheck(AName: string): string;
begin
  Result := DoAutoCapitalize(AName);
  Result := DoCheckCustomDict(nil, Result);
end;

function TAutoNameCapitalize.DoCheckCustomDict(AObj: TObject; AName: string): string;
var
  I: integer;
  S: string;
begin
  S := LowerCase(AName);
  Result := AName;
  for I := 0 to FMyKeywordNs.Count - 1 do
    if Pos(LowerCase(FMyKeywordNs[I]), S) > 0 then
      Result := StringReplace(Result, FMyKeywordNs[I], FMyKeywordNs[I], [rfIgnoreCase]);
  if Assigned(GProc_OnEzdmlCmdEvent) and Assigned(AObj) then
  begin
    S := GProc_OnEzdmlCmdEvent('CHECK_CUSTOM_DICT_NAME', AName, Result, AObj, nil);
    if S <> '' then
      Result := S;
  end;
end;

                  
{$ifdef EZDML_LITE}
procedure TAutoNameCapitalize.ReloadDictFile;
var
  S: string;
  I: integer;
begin
  FreeAndNil(FMyKeywordNs);
  FMyKeywordNs := TStringList.Create;
  S := GetFolderPathOfAppExe;
  S := FolderAddFileName(S, 'MyDict.txt');
  if FileExists(S) then
    FMyKeywordNs.LoadFromFile(S);
  for I := FMyKeywordNs.Count - 1 downto 0 do
    if (Trim(FMyKeywordNs[I]) = '') or (Copy(FMyKeywordNs[I], 1, 1) = ';') then
      FMyKeywordNs.Delete(I);
  FMyKeywordNs.Sorted := True;

  FreeAndNil(FKeywordNs);
  FKeywordNs := TStringList.Create;
  if FKeyWordFile <> '' then
    S := FKeyWordFile
  else
  begin
    S := GetFolderPathOfAppExe;
    S := FolderAddFileName(S, 'dict.txt');
  end;
  if FileExists(S) then
    FKeywordNs.LoadFromFile(S)
  else
    Application.MessageBox(PChar('Dict file not found: ' + S), PChar(Application.Title), MB_OK or MB_ICONWARNING);
  FKeywordNs.AddStrings(FMyKeywordNs);
  for I := 0 to FKeywordNs.Count - 1 do
    FKeywordNs[I] := LowerCase(FKeywordNs[I]);
  for I := FKeywordNs.Count - 1 downto 0 do
    if (Trim(FKeywordNs[I]) = '') or (Copy(FKeywordNs[I], 1, 1) = ';') then
      FKeywordNs.Delete(I);
  FKeywordNs.Sorted := True;
end;
{$else}
{$I AutoCap2.inc}
{$endif}


initialization
  ;

finalization
  if DefAutoNameCapitalizer <> nil then
    FreeAndNil(DefAutoNameCapitalizer);

end.

