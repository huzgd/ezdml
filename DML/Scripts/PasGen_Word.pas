unit PasGen_Word;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs, Variants, DB, Menus,
  CtMetaTable, CTMetaData, CtObjSerialer, DmlScriptPublic, DmlPasScriptLite;

type

  { TDmlPasScriptorLite_Word }

  TDmlPasScriptorLite_Word=class(TDmlPasScriptorLite)
  public
    { Public declarations }
    procedure Exec(ARule, AScript: string); override;
  end;

implementation

{ TDmlPasScriptorLite_Word }


procedure TDmlPasScriptorLite_Word.Exec(ARule, AScript: string);
// 以下代码来源于EZDML脚本模板export_doc_html_en.ps_

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

function DEF_CTMETAFIELD_DATATYPE_NAMES_JAVA(idx: TCtFieldDataType): string;
begin
  case Integer(idx) of
    0: Result := 'Unknown';
    1: Result := 'String';
    2: Result := 'int';
    3: Result := 'double';
    4: Result := 'Date';
    5: Result := 'boolean';
    6: Result := 'int';
    7: Result := 'Object';
    8: Result := 'Object';
    9: Result := 'List';
    10: Result := 'function';
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
  Result := getCamelCaseOfUnderlineName(Result);
end;

function GFieldName(F: TCtMetaField): string;
begin
  Result := GetDesName(f.Name, f.DisplayName);
end;

function GFieldType(F: TCtMetaField): string;
begin
  if f.DataType = cfdtOther then
    Result := f.DataTypeName
  else
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_JAVA(f.DataType);
end;

procedure AddFieldInfo(F: TCtMetaField);
var
  S, T, T1, T2, FT: string;
begin
  S := GetDesName(f.Name, f.DisplayName);
  T := F.GetFieldComments;
  if T <> '' then
  begin
    //T := F.Comment;
    T := StringReplace(T, #13#10, #13#10' * ', [rfReplaceAll]);
    T := StringReplace(T, #13, #13' * ', [rfReplaceAll]);
    T := StringReplace(T, #10, #10' * ', [rfReplaceAll]);
  end;

  if f.DataType = cfdtFunction then
  begin
    FT := f.DataTypeName;
    if FT = '' then
      FT := 'void';
    if T<>'' then
      T2 := '/**'#13#10' * ' + T + #13#10' */'#13#10
    else
      T2 := '';
    S := T2+ 'public ' + FT + ' ' + getPublicName(S) + '()'#13#10
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
      FT := DEF_CTMETAFIELD_DATATYPE_NAMES_JAVA(f.DataType);
    if T<>'' then
    begin
      T1 := '/**'#13#10' * Get ' + T + #13#10' */'#13#10;
      T2 := '/**'#13#10' * Set ' + T + #13#10' */'#13#10;
    end
    else
    begin
      T1 := '';
      T2 := '';
    end;
    S := T1+'public ' + FT + ' get' + getPublicName(S) + '()'#13#10
      + '{' + #13#10
      + '  return ' + getProtectName(S) + ';' + #13#10
      + '}' + #13#10
      + T2+'public void set' + getPublicName(S) + '(' + FT + ' value)'#13#10
      + '{' + #13#10
      + '  this.' + getProtectName(S) + ' = value;' + #13#10
      + '}';
  end;

  CurOut.Add('  ' + StringReplace(S, #13#10, #13#10'  ', [rfReplaceAll]));
end;

procedure GenTbCode(atb: TCtMetaTable);
var
  I, L: Integer;
  clsName, S, V: string;
  f: TCtMetaField;
begin
  with atb do
  begin
    S := GetTableComments;
    CurOut.Add('<pre style="font-size:12px">');
    CurOut.Add('/**');
    CurOut.Add(' * ' + Name);
    if S <> '' then
      CurOut.Add(' * ' + StringReplace(S, #13#10, #13#10' * ', [rfReplaceAll]));
    CurOut.Add('*/');
    CurOut.Add('');

    CurOut.Add('package ' + Name + ';');
    CurOut.Add('');
    CurOut.Add('import java.sql.Date;');
    CurOut.Add('');

    S := GetTableComments;
    if S <> '' then
    begin
      S := StringReplace(S, '}', '%7D', [rfReplaceAll]);
      CurOut.Add('/** '#13#10' * ' + StringReplace(S, #13#10, #13#10' * ', [rfReplaceAll]) + #13#10' */');
    end;

    L := 0;
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      S := GetDesName(f.Name, f.DisplayName);
      if L < Length(S) then
        L := Length(S);
    end;

    clsName := GetPublicName(Name);

    CurOut.Add('public class ' + clsName);
    CurOut.Add('{');

    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      case f.DataType of
        cfdtEnum:
          begin
            CurOut.Add('  public static final int ' + clsName + getPublicName(GFieldName(f)) + 'Unknown = 0;');
            CurOut.Add('  public static final int ' + clsName + getPublicName(GFieldName(f)) + 'Value1 = 1;');
            CurOut.Add('  public static final int ' + clsName + getPublicName(GFieldName(f)) + 'Value2 = 2;');
            CurOut.Add('');
          end;
      end;
    end;

    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      if f.DataType <> cfdtFunction then
        CurOut.Add('  protected ' + GFieldType(f) + ' ' + getProtectName(GFieldName(f)) + ';');
    end;
    CurOut.Add('');

    CurOut.Add('  public ' + clsName + '()');
    CurOut.Add('  {');
    CurOut.Add('  }');

    CurOut.Add('');
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      AddFieldInfo(f);
    end;

    CurOut.Add('');
    CurOut.Add('  public void reset()');
    CurOut.Add('  {');
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      S := getProtectName(GFieldName(f));
      V := '';
      case f.DataType of
        cfdtInteger, cfdtFloat:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = 0;');
        cfdtString:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = null;');
        cfdtDate:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = null;');
        cfdtEnum:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = ' + getPublicName(GFieldName(f)) + '_Unknown;');
        cfdtBool:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = false;');
        cfdtList:
          CurOut.Add('    ' + ExtStr(V + S, L) + '.Clear();');
        cfdtEvent:
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = null;');
        cfdtFunction: ;
      else
        CurOut.Add('    ' + ExtStr(S, L) + ' .reset();');
      end;
    end;
    CurOut.Add('  }');
    CurOut.Add('');


    CurOut.Add('  public void assignFrom(' + clsName + ' AObj)');
    CurOut.Add('  {');
    CurOut.Add('    if(AObj==null)');
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
          CurOut.Add('    ' + ExtStr(V + S, L) + ' = AObj.' + S + ';');
        cfdtFunction, cfdtEvent: ;
      else
        CurOut.Add('    ' + ExtStr(S, L) + ' .  assignFrom(AObj.' + S + ');');
      end;
    end;
    CurOut.Add('  }');
    CurOut.Add('');


    CurOut.Add('}');
    CurOut.Add('');
    CurOut.Add('</pre>');

  end;
end;


procedure GenHtmlList(atb:TCtMetaTable);
var
  I, J: Integer;
  S,T, tbN, Tmp1,Tmp2,Tmp3: String;
  F: TCTMetaField;
  col, listColCount:Integer;
begin
  Tmp1 :=
'<table class="x_hlist" cellSpacing="1" cellPadding="0" width="660" border="0">' + #13#10 +
'  <tr>' + #13#10 +
'  <td class="TitleLine" colSpan="4" >' + #13#10 +
'    %OBJ_NAME%' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td bgColor="#ffffff" colSpan="4" height="1">' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr class="vt9_title">' + #13#10 +
'  <td noWrap width="100%" colSpan="4" >' + #13#10 +
'    &nbsp; %OBJ_NAME% Information Query' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td colSpan="4" height="5">' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10  +
'  <tr height="1"><td width="100"></td><td width="230"><td width="100"></td><td width="230"></td></tr>' + #13#10 + #13#10;
  Tmp2 :=
#13#10'<tr>' + #13#10 +
'<td height="6" colSpan="4" >' + #13#10 +
'</td>' + #13#10 +
'</tr>' + #13#10 +
'<tr>' + #13#10 +
'<td></td>' + #13#10 +
'<td colspan="3">' + #13#10 +
'    [&nbsp;&nbsp;Query&nbsp;&nbsp;&nbsp;&nbsp;]' + #13#10 +
'    &nbsp;&nbsp;Tips:' + #13#10 +
'      <span id="Cabp_Control_errtip" style="COLOR: red">' + #13#10 +
'      Please enter filter keywords to search.' + #13#10 +
'      </span>' + #13#10 +
'</td></tr>' + #13#10 +
'<tr>' + #13#10 +
'<td height="6" colSpan="4" >' + #13#10 +
'</td>' + #13#10 +
'</tr>' + #13#10 +
'<tr>' + #13#10 +
'<tr>' + #13#10 +
'<td height="2" class="T9_blackB" colSpan="4" >' + #13#10 +
'</td>' + #13#10 +
'</tr>' + #13#10 +
'<tr>' + #13#10 +
'<td height="6" colSpan="4" >' + #13#10 +
'</td>' + #13#10 +
'</tr>' + #13#10 +
'' + #13#10 +
'<tr>' + #13#10 +
'<tr>' + #13#10 +
'<td colSpan="4" >' + #13#10 +
'<div style="width=660px; height=300px;overflow:auto">' + #13#10 +
'<table class="x_hlist table_border" border="0" cellspacing="0" cellpadding="0" width="%LIST_TABLE_WIDTH%">';
  Tmp3 :=
  '</table>' + #13#10 +
'</div>' + #13#10 +
'</td>' + #13#10 +
'</tr>' + #13#10 +
'' + #13#10 +
'<tr>' + #13#10 +
'</table>';


  tbN:=atb.Caption;
  if tbN='' then
    tbN:=atb.Name;
  S := StringReplace(Tmp1,'%OBJ_NAME%',tbN,[rfReplaceAll]);
  CurOut.Add(S);
  col := 1;
  listColCount:=0;
  for I:=0 to atb.MetaFields.Count-1 do
  begin
    F:=atb.MetaFields.Items[I];
    S:=F.Name;
    if (F.KeyFieldType=cfktId) or (F.KeyFieldType=cfktRid) then
      Continue;
    if F.DisplayName<>'' then
      S:=F.DisplayName;
    listColCount:=listColCount+1;
    if (Pos('content',LowerCase(S))>0) or (Pos('memo',LowerCase(S))>0) or (Pos('list',LowerCase(S))>0)
      or (F.DataLength>=9999) or (F.DataType=cfdtBlob) then
    begin
      Continue;
    end;

    if col=3 then
    begin
      CurOut.Add('</tr>');
      col := 1;
    end;
    if col=1 then
    begin
      CurOut.Add('');
      CurOut.Add('<tr>');
    end;
    CurOut.Add('<td>'+S+'</td>');
    if (F.DataType = cfdtBool) then
      T:='<td><input type="checkbox"/>Yes</td>'
    else if(Pos('type',LowerCase(S))>0) or (Pos('choose',LowerCase(S))>0) or (Pos('parent',LowerCase(S))>0) or (Pos('stat',LowerCase(S))>0) or (Pos('level',LowerCase(S))>0) or (Pos('sel',LowerCase(S))>0)
      or (Pos('time',LowerCase(S))>0) or (Pos('date',LowerCase(S))>0) or (F.DataType = cfdtDate) or (F.DataType=cfdtEnum) then
    begin
      if (F.DataType = cfdtInteger) or (F.DataType = cfdtFloat) or (F.DataType = cfdtDate) then
        T:='<td><select style="WIDTH: 90px"></select>-<select style="WIDTH: 90px"></select></td>'
      else
        T:='<td><select style="WIDTH: 186px"></select></td>';
    end
    else
    begin
      if (F.DataType = cfdtInteger) or (F.DataType = cfdtFloat) or (F.DataType = cfdtDate) then
        T:='<td><input style="WIDTH: 90px" />-<input style="WIDTH: 90px" /></td>'
      else
        T:='<td><input style="WIDTH: 186px" /></td>';
    end;
    CurOut.Add(T);
    col:=col+1;
  end;
  if col=2 then
  begin
    CurOut.Add('<td></td><td></td>');
    col:=3;
  end;
  if col=3 then
  begin
    CurOut.Add('</tr>');
  end;
  CurOut.Add('');

  S := StringReplace(Tmp2,'%OBJ_NAME%',tbN,[rfReplaceAll]);
  S := StringReplace(Tmp2,'%LIST_TABLE_WIDTH%',IntToStr(listColCount*120+30),[rfReplaceAll]);
  CurOut.Add(S);

  for J:=0 to 10 do
  begin
    if J=0 then
      CurOut.Add('<tr height="25" class="T9_blackB">')
    else
      CurOut.Add('<tr height="25">');
    col := 1;
    for I:=0 to atb.MetaFields.Count-1 do
    begin
      F:=atb.MetaFields.Items[I];
      S:=F.Name;
      if (F.KeyFieldType=cfktId) or (F.KeyFieldType=cfktRid) then
        Continue;
      if F.DisplayName<>'' then
        S:=F.DisplayName;

      if J>0 then
      begin
        S := F.GenDemoData(J, '', nil);
      end;
      if col=1 then
        CurOut.Add('<td width="150">'+S+'</td>')
      else
        CurOut.Add('<td width="120">'+S+'</td>');
      col:=col+1;
    end;
    CurOut.Add('</tr>');
  end;

  S := StringReplace(Tmp3,'%OBJ_NAME%',tbN,[rfReplaceAll]);
  CurOut.Add(S);
end;

procedure GenHtmlSheet(atb: TCtMetaTable);var
  I: Integer;
  S,T,V,U, tbN, Tmp1,Tmp2: String;
  F: TCTMetaField;
  col:Integer;
begin
  Tmp1 :=
'<table class="x_hlist" cellSpacing="1" cellPadding="0" width="660" border="0">' + #13#10 +
'  <tr>' + #13#10 +
'  <td class="TitleLine" colSpan="4" >' + #13#10 +
'    %OBJ_NAME%' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td bgColor="#ffffff" colSpan="4" height="1">' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr class="vt9_title">' + #13#10 +
'  <td noWrap width="100%" colSpan="4" >' + #13#10 +
'    &nbsp; %OBJ_NAME% Information Management' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td colSpan="4" height="5">' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td class="T9_black" colSpan="4">' + #13#10 +
'    &nbsp; Tips:' + #13#10 +
'      <span id="Cabp_Control_errtip" style="COLOR: red">' + #13#10 +
'      Please make sure the information filled in is true, correct and effective.' + #13#10 +
'      </span>' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td colSpan="4" height="5">' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td class="T9_blackB" colSpan="2">' + #13#10 +
'    %OBJ_NAME% Information' + #13#10 +
'  </td>' + #13#10 +
'  <td class="T9_blackB" colSpan="2">' + #13#10 +
'    Note: items with * must be filled in.' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr height="1"><td width="100"></td><td width="230"><td width="100"></td><td width="230"></td></tr>' + #13#10+ #13#10 ;
  Tmp2 :=
'  <tr>' + #13#10 +
'  <td height="12" colSpan="4" >' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td height="4" class="T9_blackB" colSpan="4" >' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <tr>' + #13#10 +
'  <td colSpan="4">' + #13#10 +
'    [&nbsp;New&nbsp;]' + #13#10 +
'    [&nbsp;Edit&nbsp;]' + #13#10 +
'    [&nbsp;Query&nbsp;]' + #13#10 +
'    [&nbsp;Delete&nbsp;]' + #13#10 +
'    [&nbsp;Refresh&nbsp;]' + #13#10 +
'    [&nbsp;Return&nbsp;]' + #13#10 +
'  </td>' + #13#10 +
'  </tr>' + #13#10 +
'</table>';

  tbN:=atb.Caption;
  if tbN='' then
    tbN:=atb.Name;
  S := StringReplace(Tmp1,'%OBJ_NAME%',tbN,[rfReplaceAll]);
  CurOut.Add(S);
  col := 1;
  for I:=0 to atb.MetaFields.Count-1 do
  begin
    F:=atb.MetaFields.Items[I];
    S:=F.Name;
    if (F.KeyFieldType=cfktId) or (F.KeyFieldType=cfktRid) then
      Continue;
    if F.DisplayName<>'' then
      S:=F.DisplayName;
    U:=S;
    if (F.KeyFieldType=cfktName) or not F.Nullable then
      U:='* '+S;
    V:= F.GenDemoData(1, '', nil);

    if (Pos('content',LowerCase(S))>0) or (Pos('memo',LowerCase(S))>0) or (Pos('list',LowerCase(S))>0)
      or (F.DataLength>=9999) or (F.DataType = cfdtBlob) then
    begin
      if col=2 then
      begin
        CurOut.Add('<td></td><td></td></tr>');
        CurOut.Add('');
        col := 1;
      end;
      CurOut.Add('<tr>');
      CurOut.Add('<td>'+U+'</td>');
      T:='<td colspan="3"><textarea style="WIDTH: 491px; HEIGHT: ';
      if (F.DataType = cfdtBlob) then
        T:=T+'180'
      else
        T:=T+'72';
      T:=T+'" rows="1" cols="20">'+V+'</textarea></td>';
      CurOut.Add(T);
      col := 3;
      Continue;
    end;

    if col=3 then
    begin
      CurOut.Add('</tr>');
      CurOut.Add('');
      col := 1;
    end;
    if col=1 then
    begin
      CurOut.Add('<tr>');
    end;
    CurOut.Add('<td>'+U+'</td>');
    if (F.DataType = cfdtBool) then
      T:='<td><input type="checkbox" checked/>Yes</td>'
    else
    begin
      if(Pos('type',LowerCase(S))>0) or (Pos('choose',LowerCase(S))>0) or (Pos('parent',LowerCase(S))>0) or (Pos('stat',LowerCase(S))>0) or (Pos('level',LowerCase(S))>0) or (Pos('sel',LowerCase(S))>0)
        or (Pos('time',LowerCase(S))>0) or (Pos('date',LowerCase(S))>0) or (F.DataType = cfdtDate) or (F.DataType=cfdtEnum) then
        T:='<td><select style="WIDTH: 162px"><option selected>'+V+'</option></select></td>'
      else
        T:='<td><input style="WIDTH: 162px" value="'+V+'"/></td>';
    end;
    CurOut.Add(T);
    col:=col+1;
  end;
  if col=2 then
  begin
    CurOut.Add('<td></td><td></td>');
    col:=3;
  end;
  if col=3 then
  begin
    CurOut.Add('</tr>');
    CurOut.Add('');
  end;
  S := StringReplace(Tmp2,'%OBJ_NAME%',tbN,[rfReplaceAll]);
  CurOut.Add(S);

end;



var
  I, J, K, N, selC: Integer;
  tfn, S, sBoundary: String;
  tb: TCtMetaTable;
  F: TCTMetaField;
  bPhyMode, bMht: Boolean;
  db: String;
  bGenUI: Boolean;
begin
  bGenUI := False;
  case Application.MessageBox('Do you want to generate HTML UI when exporting document? (HTML UI may be slow and cause problems if you have too many tables)',
    'Export', MB_YESNOCANCEL or MB_ICONQUESTION or MB_DEFBUTTON2) of
    IDYES: bGenUI := True;
    IDNO: bGenUI := False;
  else
    AbortOut;
  end;

  sBoundary := '--_NextPart_AED089B74422496E96E3_A75697E013C6';
  tfn:=AllModels.CurDataModel.Param['ExportFileName'];
  S:=LowerCase(ExtractFileExt(tfn));
  if (S='.mht')  or (S='.doc') then
    bMht := True
  else
    bMht := False;
  if AllModels.CurDataModel.Param['ShowPhyFieldName']='1' then
    bPhyMode := True
  else
    bPhyMode := False;
  db := AllModels.CurDataModel.Param['DatabaseEngine'];

  selC := 0;
  for I:=0 to AllModels.CurDataModel.Tables.Count-1 do
    if AllModels.CurDataModel.Tables[I].IsSelected then
      selC := selC+1;

  if bMht then
  begin
    CurOut.Add(
    'MIME-Version: 1.0' + #13#10 +
    'Content-Type: multipart/related;' + #13#10 +
    '       type="text/html";' + #13#10 +
    '       boundary="' + sBoundary + '"' + #13#10 +
    'X-Priority: 3' + #13#10 +
    'X-MSMail-Priority: Normal' + #13#10 +
    'X-Unsent: 1' + #13#10 +
    'X-MimeOLE: Produced By EZDML' + #13#10 +
    '' + #13#10 +
    'This is a multi-part message in MIME format.' + #13#10 +
    '' + #13#10 +
    '' + #13#10 +
    '--' + sBoundary + #13#10 +
    'Content-Type: text/html;' + #13#10 +
    '    charset="utf-8"' + #13#10 +
    'Content-Transfer-Encoding: 8bit' + #13#10 +
    '');
  end;

PrintVar('' + #13#10 +
'<html xmlns:o="urn:schemas-microsoft-com:office:office"' + #13#10 +
'xmlns:x="urn:schemas-microsoft-com:office:excel"' + #13#10 +
'xmlns="http://www.w3.org/TR/REC-html40">' + #13#10 +
'' + #13#10 +
'<head>' + #13#10 +
'<meta http-equiv=Content-Type content="text/html; charset=utf-8">' + #13#10 +
'<meta name=ProgId content=Excel.Sheet>' + #13#10 +
'<meta name=Generator content="Netsky-CellTree">' + #13#10 +
'<style>' + #13#10 +
'<!--' + #13#10 +
'br.x_dml' + #13#10 +
'' + #9 + '{mso-data-placement:same-cell;}' + #13#10 +
'tr.x_dml' + #13#10 +
'' + #9 + '{height:14.25pt;}' + #13#10 +
'td.x_dml' + #13#10 +
'' + #9 + '{' + #13#10 +
'' + #9 + 'padding-top:1px;' + #13#10 +
'' + #9 + 'padding-right:1px;' + #13#10 +
'' + #9 + 'padding-left:1px;' + #13#10 +
'' + #9 + 'font-size:12.0pt;' + #13#10 +
'' + #9 + 'font-weight:400;' + #13#10 +
'' + #9 + 'font-style:normal;' + #13#10 +
'' + #9 + 'text-decoration:none;' + #13#10 +
'' + #9 + 'color:windowtext;' + #13#10 +
'' + #9 + 'font-family:Tahoma;' + #13#10 +
'' + #9 + 'text-align:general;' + #13#10 +
'' + #9 + 'vertical-align:middle;' + #13#10 +
'' + #9 + 'border:none;' + #13#10 +
'' + #9 + 'mso-number-format:"_ * \#\,\#\#0\.00_ \;_ * \\-\#\,\#\#0\.00_ \;_ * \0022-\0022??_ \;_ \@_ ";' + #13#10 +
'' + #9 + 'white-space:nowrap;}' + #13#10 +
'.x_head1' + #13#10 +
'' + #9 + '{' + #13#10 +
'' + #9 + 'height:14.25pt;' + #13#10 +
'' + #9 + 'width:80pt;' + #13#10 +
'' + #9 + 'font-size:9.0pt;' + #13#10 +
'' + #9 + 'text-align:left;' + #13#10 +
'' + #9 + 'border:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'background:teal;}' + #13#10 +
'.x_head2' + #13#10 +
'' + #9 + '{' + #13#10 +
'' + #9 + 'height:14.25pt;' + #13#10 +
'' + #9 + 'width:80pt;' + #13#10 +
'' + #9 + 'font-size:9.0pt;' + #13#10 +
'' + #9 + 'text-align:left;' + #13#10 +
'' + #9 + 'border-top:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-right:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-bottom:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-left:none;' + #13#10 +
'' + #9 + 'background:teal;}' + #13#10 +
'.x_head3' + #13#10 +
'' + #9 + '{' + #13#10 +
'' + #9 + 'height:14.25pt;' + #13#10 +
'' + #9 + 'width:160pt;' + #13#10 +
'' + #9 + 'font-size:9.0pt;' + #13#10 +
'' + #9 + 'text-align:left;' + #13#10 +
'' + #9 + 'border-top:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-right:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-bottom:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-left:none;' + #13#10 +
'' + #9 + 'background:teal;}' + #13#10 +
'.x_item1' + #13#10 +
'' + #9 + '{' + #13#10 +
'' + #9 + 'height:14.25pt;' + #13#10 +
'' + #9 + 'font-size:9.0pt;' + #13#10 +
'' + #9 + 'text-align:left;' + #13#10 +
'' + #9 + 'border-top:none;' + #13#10 +
'' + #9 + 'border-right:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-bottom:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-left:.5pt solid windowtext;}' + #13#10 +
'.x_item2' + #13#10 +
'' + #9 + '{' + #13#10 +
'' + #9 + 'font-size:9.0pt;' + #13#10 +
'' + #9 + 'text-align:left;' + #13#10 +
'' + #9 + 'border-top:none;' + #13#10 +
'' + #9 + 'border-right:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-bottom:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-left:none;}' + #13#10 +
'.x_item3' + #13#10 +
'' + #9 + '{' + #13#10 +
'' + #9 + 'font-size:9.0pt;' + #13#10 +
'' + #9 + 'text-align:left;' + #13#10 +
'' + #9 + 'border-top:none;' + #13#10 +
'' + #9 + 'border-right:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-bottom:.5pt solid windowtext;' + #13#10 +
'' + #9 + 'border-left:none;}' + #13#10 +
'' + #13#10 +
'' + #9 + 'TABLE.x_hlist { FONT-SIZE: 12px; COLOR: #000000 } ' + #13#10 +
'' + #9 + '.TitleLine { padding-left: 12px; FONT-WEIGHT:' + #13#10 +
'' + #9 + 'bold; FONT-SIZE: 12px; COLOR: #ffffff; background-color: #578b43; height:' + #13#10 +
'' + #9 + '28px; padding-top:6px; } ' + #13#10 +
'' + #9 + '.TitleLine2 { padding-left: 12px; FONT-WEIGHT:' + #13#10 +
'' + #9 + 'bold; FONT-SIZE: 12px; COLOR: #ffffff; background-color: #578b43; height:' + #13#10 +
'' + #9 + '20px; padding-top:4px; } ' + #13#10 +
'' + #9 + '.Titleline2_bg{ background-color:#f3f3ec; border-bottom:2px' + #13#10 +
'' + #9 + 'solid #578b43; padding:10px; } ' + #13#10 +
'' + #9 + '.Titleline2td{ height:18px; } ' + #13#10 +
'' + #9 + '.vt9_title' + #13#10 +
'' + #9 + '{ font-weight: bold; font-size: 12px; color: #2F2F2F; background-color:' + #13#10 +
'' + #9 + '#CCCCCC; height: 20px; line-height: 24px; } ' + #13#10 +
'' + #9 + '.T9_blackB { FONT-WEIGHT: bold;' + #13#10 +
'' + #9 + 'FONT-SIZE: 12px; COLOR: #008000; LINE-height: 25px; TEXT-DECORATION: none;' + #13#10 +
'' + #9 + 'TEXT-align: left; background-color:#cecece; padding-left:5px; }' + #13#10 +
'' + #9 + '.table_border td{border-top:1px #888 solid;border-right:1px #888 solid;padding-left:5px;}' + #13#10 +
'' + #9 + '.table_border{border-bottom:1px #888 solid;border-left:1px #888 solid;}' + #13#10 +
'-->' + #13#10 +
'</style>' + #13#10 +
'<!--[if gte mso 9]><xml>' + #13#10 +
' <x:ExcelWorkbook>' + #13#10 +
'  <x:ExcelWorksheets>' + #13#10 +
'   <x:ExcelWorksheet>' + #13#10 +
'    <x:Name>Sheet1</x:Name>' + #13#10 +
'    <x:WorksheetOptions>' + #13#10 +
'     <x:Selected/>' + #13#10 +
'    </x:WorksheetOptions>' + #13#10 +
'   </x:ExcelWorksheet>' + #13#10 +
'  </x:ExcelWorksheets>' + #13#10 +
' </x:ExcelWorkbook>' + #13#10 +
'</xml>' + #13#10 +
'<![endif]-->' + #13#10 +
'</head>' + #13#10 +
'' + #13#10 +
'' + #13#10 +
'<body link=blue vlink=purple>' + #13#10 +
'' + #13#10 +
'<h1>');
PrintVar(GetEnv('DMLFILETITLE'));
PrintVar(' (');
PrintVar(ChangeFileExt(ExtractFileName(tfn),''));
PrintVar(')</h1>' + #13#10 +
'<p>' + #13#10 +
'--');
PrintVar(GetEnv('WINUSER'));
PrintVar(' ');
PrintVar(DateToStr(Now));
PrintVar('' + #13#10 +
'</p>' + #13#10 +
'' + #13#10 +
'<h2>1. Architecture</h2>' + #13#10 +
'');

  for K:=0 to AllModels.Count-1 do
  if (selC=0) or (AllModels.Items[K] = AllModels.CurDataModel) then
  begin

PrintVar('' + #13#10 +
'<h3>1.');
PrintVar(K+1);
PrintVar(' ');
PrintVar(AllModels.Items[K].Name);
PrintVar('</h3>' + #13#10 +
'' + #13#10 +
'');

  N:=0;
  for I:=0 to AllModels.Items[K].Tables.Count-1 do
  if (selC=0) or AllModels.Items[K].Tables[I].IsSelected then
  begin
    N := N+1;
    tb := AllModels.Items[K].Tables[I];

PrintVar('' + #13#10 +
'<h4>1.');
PrintVar(K+1);
PrintVar('.');
PrintVar(N);
PrintVar(' ');
PrintVar(tb.Name);
PrintVar(' ');
if tb.Caption<>'' then PrintVar('('+tb.Caption+')');
PrintVar('</h4>' + #13#10 +
'');

  end; //I

PrintVar('' + #13#10 +
'<p>Model diagram:</p>' + #13#10 +
'');

    if bMht then
    begin

PrintVar('' + #13#10 +
'<img src="file:///dmlgraph');
PrintVar(K+1);
PrintVar('.png" />' + #13#10 +
'');

    end
    else
    begin
	  if selC>0 then
	    S := ExecAppCmd('GET_DML_GRAPH_BASE64TEXT', '(CUR_DATA_MODEL)', '(SINGLELINE).png')
	  else
	    S := ExecAppCmd('GET_DML_GRAPH_BASE64TEXT', AllModels.Items[K].Name, '(SINGLELINE).png');

PrintVar('' + #13#10 +
'<img src="data:image/png;base64,');
PrintVar(S);
PrintVar('" />' + #13#10 +
'' + #13#10 +
'');

    end;

PrintVar('' + #13#10 +
'' + #13#10 +
'<p>Object relationship:</p>' + #13#10 +
'');

    if bMht then
    begin

PrintVar('' + #13#10 +
'<img src="file:///objgraph');
PrintVar(K+1);
PrintVar('.png" />' + #13#10 +
'');

    end
    else
    begin
	  if selC>0 then
	    S := ExecAppCmd('GET_DML_GRAPH_BASE64TEXT', '(CUR_DATA_MODEL)', '(SINGLELINE)(BRIEF).png')
	  else
	    S := ExecAppCmd('GET_DML_GRAPH_BASE64TEXT', AllModels.Items[K].Name, '(SINGLELINE)(BRIEF).png');

PrintVar('' + #13#10 +
'<img src="data:image/png;base64,');
PrintVar(S);
PrintVar('" />' + #13#10 +
'' + #13#10 +
'');

    end;
  end;

PrintVar('' + #13#10 +
'' + #13#10 +
'' + #13#10 +
'<h2>2. Data Dictionary</h2>' + #13#10 +
'' + #13#10 +
'');

  for K:=0 to AllModels.Count-1 do
  if (selC=0) or (AllModels.Items[K] = AllModels.CurDataModel) then
  begin

PrintVar('' + #13#10 +
'' + #13#10 +
'<h3>2.');
PrintVar(K+1);
PrintVar(' ');
PrintVar(AllModels.Items[K].Name);
PrintVar('</h3>' + #13#10 +
'' + #13#10 +
'');

  N:=0;
  for I:=0 to AllModels.Items[K].Tables.Count-1 do
  if (selC=0) or AllModels.Items[K].Tables[I].IsSelected then
  begin
    N := N+1;
    tb := AllModels.Items[K].Tables[I];

PrintVar('' + #13#10 +
'' + #13#10 +
'<h4>2.');
PrintVar(K+1);
PrintVar('.');
PrintVar(N);
PrintVar(' ');
PrintVar(tb.Name);
PrintVar(' ');
if tb.Caption<>'' then PrintVar('('+tb.Caption+')');
PrintVar('</h4>' + #13#10 +
'' + #13#10 +
'');
 if tb.Memo <> '' then
begin
PrintVar('' + #13#10 +
'<p>');
PrintVar(tb.Memo);
PrintVar('</p>' + #13#10 +
'');
end;
PrintVar('' + #13#10 +
'' + #13#10 +
'<table class=x_dml x:str border=0 cellpadding=0 cellspacing=0' + #13#10 +
'' + #9 + 'style=''border-collapse:collapse;table-layout:fixed;''>' + #13#10 +
'<tr>' + #13#10 +
'<td class=x_head1>Field Name</td>' + #13#10 +
'<td class=x_head2>Logic Name</td>' + #13#10 +
'<td class=x_head2>Data Type</td>' + #13#10 +
'<td class=x_head2>Constraint</td>' + #13#10 +
'<td class=x_head3>Comments</td>' + #13#10 +
'</tr>' + #13#10 +
'');

    for J:=0 to tb.MetaFields.Count-1 do
    begin
      F:=tb.MetaFields.Items[J];

PrintVar('' + #13#10 +
'<tr>' + #13#10 +
'<td class=x_item1>');
PrintVar(F.Name);
PrintVar('</td>' + #13#10 +
'<td class=x_item2>');
PrintVar(F.DisplayName);
PrintVar('</td>' + #13#10 +
'<td class=x_item2>');
PrintVar(F.GetFieldTypeDesc(bPhyMode,db));
PrintVar('</td>' + #13#10 +
'<td class=x_item2>');
PrintVar(F.GetConstraintStr);
PrintVar('</td>' + #13#10 +
'<td class=x_item3>');
PrintVar(EscapeXml(F.Memo));
PrintVar('</td>' + #13#10 +
'</tr>' + #13#10 +
'' + #13#10 +
'');

    end; //J

PrintVar('' + #13#10 +
'</table>' + #13#10 +
'' + #13#10 +
'');

  end; //I
  end; //K

PrintVar('' + #13#10 +
'' + #13#10 +
'<h2>3. User Interface</h2>' + #13#10 +
'' + #13#10 +
'');

if bGenUI then
begin

  for K:=0 to AllModels.Count-1 do
  if (selC=0) or (AllModels.Items[K] = AllModels.CurDataModel) then
  begin

PrintVar('' + #13#10 +
'' + #13#10 +
'<h3>3.');
PrintVar(K+1);
PrintVar(' ');
PrintVar(AllModels.Items[K].Name);
PrintVar('</h3>' + #13#10 +
'' + #13#10 +
'');

  N:=0;
  for I:=0 to AllModels.Items[K].Tables.Count-1 do
  if (selC=0) or AllModels.Items[K].Tables[I].IsSelected then
  begin
    N := N+1;
    tb := AllModels.Items[K].Tables[I];

PrintVar('' + #13#10 +
'' + #13#10 +
'<h4>3.');
PrintVar(K+1);
PrintVar('.');
PrintVar(N);
PrintVar(' ');
PrintVar(tb.Name);
PrintVar(' ');
if tb.Caption<>'' then PrintVar('('+tb.Caption+')');
PrintVar('</h4>' + #13#10 +
'' + #13#10 +
'');

    CurOut.Add('<p>List UI:</p>');
    GenHtmlList(tb);
    CurOut.Add('<p>Content UI:</p>');
    GenHtmlSheet(tb);

  end; //I
  end; //K

end
else
begin
  CurOut.Add('<p>(Skipped)</p>');
end;

PrintVar('' + #13#10 +
'<h2>4. Code</h2>' + #13#10 +
'' + #13#10 +
'');

  for K:=0 to AllModels.Count-1 do
  if (selC=0) or (AllModels.Items[K] = AllModels.CurDataModel) then
  begin

PrintVar('' + #13#10 +
'' + #13#10 +
'<h3>4.');
PrintVar(K+1);
PrintVar(' ');
PrintVar(AllModels.Items[K].Name);
PrintVar('</h3>' + #13#10 +
'' + #13#10 +
'');

  N:=0;
  for I:=0 to AllModels.Items[K].Tables.Count-1 do
  if (selC=0) or AllModels.Items[K].Tables[I].IsSelected then
  begin
    N := N+1;
    tb := AllModels.Items[K].Tables[I];

PrintVar('' + #13#10 +
'<h4>4.');
PrintVar(K+1);
PrintVar('.');
PrintVar(N);
PrintVar(' ');
PrintVar(tb.Name);
PrintVar(' ');
if tb.Caption<>'' then PrintVar('('+tb.Caption+')');
PrintVar('</h4>' + #13#10 +
'');

    GenTbCode(tb);
  end; //I
  end; //K

PrintVar('' + #13#10 +
'' + #13#10 +
'</body>' + #13#10 +
'</html>' + #13#10 +
'');

  if bMht then
  begin
    for K:=0 to AllModels.Count-1 do
    if (selC=0) or (AllModels.Items[K] = AllModels.CurDataModel) then
    begin
      CurOut.Add('--'+sBoundary);

PrintVar('' + #13#10 +
'Content-Type: image/png' + #13#10 +
'Content-Transfer-Encoding: base64' + #13#10 +
'Content-Location: file:///dmlgraph');
PrintVar(K+1);
PrintVar('.png' + #13#10 +
'' + #13#10 +
'');

      if selC>0 then
        CurOut.Add(ExecAppCmd('GET_DML_GRAPH_BASE64TEXT', '(CUR_DATA_MODEL)', 'a.png'))
      else
        CurOut.Add(ExecAppCmd('GET_DML_GRAPH_BASE64TEXT', AllModels.Items[K].Name, 'a.png'));

      CurOut.Add('');
      CurOut.Add('');
      CurOut.Add('--'+sBoundary);

PrintVar('' + #13#10 +
'Content-Type: image/png' + #13#10 +
'Content-Transfer-Encoding: base64' + #13#10 +
'Content-Location: file:///objgraph');
PrintVar(K+1);
PrintVar('.png' + #13#10 +
'' + #13#10 +
'');

      if selC>0 then
        CurOut.Add(ExecAppCmd('GET_DML_GRAPH_BASE64TEXT', '(CUR_DATA_MODEL)', 'a(BRIEF).png'))
      else
        CurOut.Add(ExecAppCmd('GET_DML_GRAPH_BASE64TEXT', AllModels.Items[K].Name, 'a(BRIEF).png'));
    end;
    CurOut.Add('--'+sBoundary+'--');
  end;
end;

initialization
  RegisterPasLite('Word_html', TDmlPasScriptorLite_Word, '');

end.

