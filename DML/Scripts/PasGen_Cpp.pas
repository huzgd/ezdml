unit PasGen_Cpp;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs, Variants, DB, Menus,
  CtMetaTable, CTMetaData, CtObjSerialer, DmlScriptPublic, DmlPasScriptLite;

type

  { TDmlPasScriptorLite_Cpp }

  TDmlPasScriptorLite_Cpp=class(TDmlPasScriptorLite)
  public
    { Public declarations }
    procedure Exec(ARule, AScript: string); override;
  end;

implementation

{ TDmlPasScriptorLite_Cpp }


procedure TDmlPasScriptorLite_Cpp.Exec(ARule, AScript: string);
                 
// 以下代码来源于EZDML脚本模板C++.pas

function ExtStr(Str: string; Len: Integer): string;
var
  I: Integer;
begin
  Str := Trim(Str);
  if Length(Str) <= Len then
    for I := Length(Str) to Len do
      Str := Str + ' ';
  Result := Str;
end;

function DEF_CTMETAFIELD_DATATYPE_NAMES_CPP(idx: TCtFieldDataType): string;
begin
  case Integer(idx) of
    0: Result := 'Unknown';
    1: Result := 'char *';
    2: Result := 'int';
    3: Result := 'double';
    4: Result := 'Date';
    5: Result := 'bool';
    6: Result := 'enum';
    7: Result := 'Object';
    8: Result := 'Object';
    9: Result := 'List';
    10: Result := 'void';
    11: Result := 'EventClass';
    12: Result := 'class';
  else
    Result := 'Unknown';
  end;
end;

function getCamelCaseOfUnderlineName(N: String): String;
var
  po: Integer;
  S, S1, S2: String;
begin
  Result := N;
  if UpperCase(Result)=Result then
    Exit;
  while Pos('_', Result)>0 do
  begin
    S := Result;
    po := Pos('_', S);
    S1 := Copy(S, 1, po-1);
    S2 := Copy(S, po+1, Length(S));
    if (S2 <> '') then
      if S2[1] >= 'a' then
        if S2[1] <= 'z' then
          S2[1] := Chr(Ord(S2[1]) - (Ord('a') - Ord('A')));
    Result := S1+S2;
  end;
end;

function getProtectName(N: string): string;
begin
  Result := N;
  Result := getCamelCaseOfUnderlineName(Result);
  if (Result <> '') and (N <> UpperCase(N)) then
    if Result[1] >= 'A' then
      if Result[1] <= 'Z' then
        Result[1] := Chr(Ord(Result[1]) + (Ord('a') - Ord('A')));
end;

function getPublicName(N: string): string;
begin
  Result := N;
  Result := getCamelCaseOfUnderlineName(Result);
  if (Result <> '') then
    if Result[1] >= 'a' then
      if Result[1] <= 'z' then
        Result[1] := Chr(Ord(Result[1]) - (Ord('a') - Ord('A')));
end;

function GetDesName(p, n: string): string;
begin
  if p = '' then
    Result := n
  else
    Result := p;
end;

var
  I, L: Integer;
  clsName, S, T, V, FT: string;
  f: TCtMetaField;

function GFieldName(Fld: TCtMetaField): string;
begin
  Result := GetDesName(f.Name, f.DisplayName);
end;

function GFieldType(Fld: TCtMetaField): string;
begin
  if f.DataType = cfdtOther then
    Result := f.DataTypeName
  else if f.DataType = cfdtEnum then
    Result := getPublicName(f.Name) + 'Enum'
  else
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_CPP(f.DataType);
end;

procedure AddFieldInfo(isHeader: Boolean);
begin
  S := GetDesName(f.Name, f.DisplayName);
  if f.DataType = cfdtFunction then
  begin
    FT := f.DataTypeName;
    if FT = '' then
      FT := 'void';
    if isHeader then
      S := FT + ' ' + getPublicName(S) + '(void);'
    else
      S := clsName + '::' + FT + ' ' + getPublicName(S) + '(void)'#13#10
        + '{' + #13#10
        + '}';
  end
  else
  begin
    if f.DataType = cfdtOther then
      FT := f.DataTypeName
    else if f.DataType = cfdtEnum then
      FT := GFieldType(f)
    else
      FT := DEF_CTMETAFIELD_DATATYPE_NAMES_CPP(f.DataType);
    if isHeader then
      S := FT + ' Get' + getPublicName(S) + '(void);'#13#10 +
        'void Set' + getPublicName(S) + '(' + FT + ');'
    else
      S := FT + ' ' + clsName + '::Get' + getPublicName(S) + '(void)'#13#10
        + '{' + #13#10
        + '  return ' + getProtectName(S) + ';' + #13#10
        + '}' + #13#10
        + 'void ' + clsName + '::Set' + getPublicName(S) + '(' + FT + ' value)'#13#10
        + '{' + #13#10
        + '    this->' + getProtectName(S) + ' = value;' + #13#10
        + '}';
  end;

  T := F.GetFieldComments;
  if T <> '' then
  begin
      //T := F.Comment;
    if (Pos(#13, T) > 0) or (Pos(#10, T) > 0) then
    begin
      if Length(T) <= 100 then
      begin
        T := StringReplace(T, #13#10, ' ', [rfReplaceAll]);
        T := StringReplace(T, #13, ' ', [rfReplaceAll]);
        T := StringReplace(T, #10, ' ', [rfReplaceAll]);
        S := '//' + T + #13#10 + S;
      end
      else
      begin
        T := '{' + StringReplace(T, '}', '%7D', [rfReplaceAll]) + '}';
        S := T + #13#10 + S;
      end;
    end
    else
      S := '//' + T + #13#10 + S;
  end;

  if isHeader then
    S := '    ' + StringReplace(S, #13#10, #13#10'    ', [rfReplaceAll]);
  CurOut.Add(S);
end;
begin
  with CurTable do
  begin
    S := GetTableComments;
    CurOut.Add('/*');
    CurOut.Add('  ###C++ Code Generate Demo###');
    CurOut.Add('  ' + Name);
    CurOut.Add('  Create by '+GetParamValueDef('Author','User')+'('+GetParamValueDef('EMail','EMail')+') ' + DateTimeToStr(Now));
    S := StringReplace(S, '}', '%7D', [rfReplaceAll]);
    if S <> '' then
      CurOut.Add('  ' + StringReplace(S, #13#10, #13#10'  ', [rfReplaceAll]));
    CurOut.Add('');
    CurOut.Add(Describe);
    CurOut.Add('');
    CurOut.Add('*/');
    CurOut.Add('');

    CurOut.Add('/******** ' + Name + '.h ********/');
    CurOut.Add('');
    CurOut.Add('#ifndef _INCL_' + UpperCase(Name) + '_H_');
    CurOut.Add('#define _INCL_' + UpperCase(Name) + '_H_');
    CurOut.Add('');

    S := GetTableComments;
    if S <> '' then
    begin
      S := StringReplace(S, '}', '%7D', [rfReplaceAll]);
      CurOut.Add('/* ' + StringReplace(S, #13#10, #13#10'  ', [rfReplaceAll]) + ' */');
    end;

    CurOut.Add('');
    CurOut.Add('typedef char * Date;');
    CurOut.Add('typedef char * Object;');
    CurOut.Add('');

    L := 0;
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      S := GetDesName(f.Name, f.DisplayName);
      if L < Length(S) then
        L := Length(S);
    end;

    clsName := Name;

    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      case f.DataType of
        cfdtEnum:
          begin
            CurOut.Add('typedef	enum{');
            CurOut.Add('    ' + getPublicName(GFieldName(f)) + '_Unknown = 0,');
            CurOut.Add('    ' + getPublicName(GFieldName(f)) + '_Value1,');
            CurOut.Add('    ' + getPublicName(GFieldName(f)) + '_Value2');
            CurOut.Add('}' + GFieldType(f) + ';');
            CurOut.Add('');
          end;
      end;
    end;

    CurOut.Add('class ' + clsName);
    CurOut.Add('{');

    CurOut.Add('private:');
    CurOut.Add('protected:');
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      if f.DataType <> cfdtFunction then
        CurOut.Add('    ' + GFieldType(f) + ' ' + getProtectName(GFieldName(f)) + ';');
    end;
    CurOut.Add('');

    CurOut.Add('public:');
    CurOut.Add('    ' + clsName + '(void);');
    CurOut.Add('    ~' + clsName + '(void);');

    CurOut.Add('');
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      AddFieldInfo(True);
    end;
    CurOut.Add('');
    CurOut.Add('    void Reset();');
    CurOut.Add('    void AssignFrom(' + clsName + ' * AObj);');
    CurOut.Add('};');
    CurOut.Add('');

    CurOut.Add('#endif');
    CurOut.Add('/******** END of ' + Name + '.h ********/');
    CurOut.Add('');
    CurOut.Add('');
    CurOut.Add('/******** ' + Name + '.cpp ********/');
    CurOut.Add('');
    CurOut.Add('#include "stdafx.h"');
    CurOut.Add('#include "' + Name + '.h"');
    CurOut.Add('');

    CurOut.Add(clsName + '::' + clsName + '(void)');
    CurOut.Add('{');
    CurOut.Add('}');
    CurOut.Add('');
    CurOut.Add(clsName + '::~' + clsName + '(void)');
    CurOut.Add('{');
    CurOut.Add('}');
    CurOut.Add('');

    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      AddFieldInfo(False);
    end;

    CurOut.Add('');
    CurOut.Add('void ' + clsName + '::' + 'Reset()');
    CurOut.Add('{');
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      S := getProtectName(GFieldName(f));
      V := '';
      case f.DataType of
        cfdtInteger, cfdtFloat:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = 0;');
        cfdtString:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = NULL;');
        cfdtDate:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = NULL;');
        cfdtEnum:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = ' + getPublicName(GFieldName(f)) + '_Unknown;');
        cfdtBool:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = false;');
        cfdtList:
          CurOut.Add('    ' + ExtStr(V + S, L) + '->Clear();');
        cfdtEvent:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = NULL;');
        cfdtFunction: ;
      else
        CurOut.Add('    ' + ExtStr(S, L) + ' ->Reset();');
      end;
    end;
    CurOut.Add('}');
    CurOut.Add('');


    CurOut.Add('void ' + clsName + '::AssignFrom(' + clsName + ' * AObj)');
    CurOut.Add('{');
    CurOut.Add('    if(AObj==NULL)');
    CurOut.Add('    {');
    CurOut.Add('      Reset();');
    CurOut.Add('      return;');
    CurOut.Add('    }');
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      S := getProtectName(GFieldName(f));
      V := ''; //RemRootCtField(f.Name);
      case f.DataType of
        cfdtString, cfdtInteger, cfdtFloat, cfdtDate, cfdtBool, cfdtEnum:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = AObj->' + S + ';');
        cfdtFunction, cfdtEvent: ;
      else
        CurOut.Add('    ' + ExtStr(S, L) + ' -> AssignFrom(AObj->' + S + ');');
      end;
    end;
    CurOut.Add('}');
    CurOut.Add('');
  end;

end;

initialization
  RegisterPasLite('C++', TDmlPasScriptorLite_Cpp, 'Table');

end.

