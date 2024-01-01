unit PasGen_Excel;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs, Variants, DB, Menus,
  CtMetaTable, CTMetaData, CtObjSerialer, DmlScriptPublic, DmlPasScriptLite;

type

  { TDmlPasScriptorLite_Excel }

  TDmlPasScriptorLite_Excel=class(TDmlPasScriptorLite)
  public
    { Public declarations }
    procedure Exec(ARule, AScript: string); override;
  end;

implementation

{ TDmlPasScriptorLite_Excel }


procedure TDmlPasScriptorLite_Excel.Exec(ARule, AScript: string);

// 以下代码来源于EZDML脚本模板export_xls_en.ps_

var
  I, J, K, N, selC: Integer;
  S: String;
  tb: TCtMetaTable;
  F: TCTMetaField;
  bPhyMode: Boolean;
  db: String;
begin
  if AllModels.CurDataModel.Param['ShowPhyFieldName']='1' then
    bPhyMode := True
  else
    bPhyMode := False;
  db := AllModels.CurDataModel.Param['DatabaseEngine'];

  selC := 0;
  for I:=0 to AllModels.CurDataModel.Tables.Count-1 do
    if AllModels.CurDataModel.Tables[I].IsSelected then
      selC := selC+1;


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
'.x_head0' + #13#10 +
'' + #9 + '{' + #13#10 +
'' + #9 + 'font-size:11.0pt;' + #13#10 +
'' + #9 + 'text-align:left;' + #13#10 +
'' + #9 + 'border:0pt solid windowtext;' + #13#10 +
'' + #9 + 'background:#fff;}' + #13#10 +
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
'<table class=x_dml x:str border=0 cellpadding=0 cellspacing=0' + #13#10 +
'' + #9 + 'style=''border-collapse:collapse;table-layout:fixed;''>' + #13#10 +
'');

  for K:=0 to AllModels.Count-1 do
  if (AllModels.Items[K] = AllModels.CurDataModel) then
  begin

PrintVar('' + #13#10 +
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
'' + #13#10 +
'<tr>' + #13#10 +
'<td colspan=5 class=x_head0>' + #13#10 +
'');
PrintVar(N);
PrintVar('. ');
PrintVar(tb.NameCaption);
PrintVar('' + #13#10 +
'</td>' + #13#10 +
'</tr>' + #13#10 +
'' + #13#10 +
'');
 if tb.Memo <> '' then
begin
PrintVar('' + #13#10 +
'<tr>' + #13#10 +
'<td colspan=5 class=x_head0>' + #13#10 +
'  ');
PrintVar(tb.Memo);
PrintVar('' + #13#10 +
'</td>' + #13#10 +
'</tr>' + #13#10 +
'');

end;
PrintVar('' + #13#10 +
'' + #13#10 +
'<tr>' + #13#10 +
'<td class=x_head1>Field Name</td>' + #13#10 +
'<td class=x_head2>Logic Name</td>' + #13#10 +
'<td class=x_head2>Data Type</td>' + #13#10 +
'<td class=x_head2>Constraint</td>' + #13#10 +
'<td class=x_head3>Comments</td>' + #13#10 +
'</tr>' + #13#10 +
'' + #13#10 +
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
'' + #13#10 +
'<tr>' + #13#10 +
'<td colspan=5 class=x_head0>' + #13#10 +
'&nbsp;' + #13#10 +
'</td>' + #13#10 +
'</tr>' + #13#10 +
'' + #13#10 +
'');

  end; //I
  end; //K

PrintVar('' + #13#10 +
'' + #13#10 +
'</table>' + #13#10 +
'</body>' + #13#10 +
'</html>' + #13#10 +
'');

end;

initialization
  RegisterPasLite('Excel_html', TDmlPasScriptorLite_Excel, 'Table');

end.

