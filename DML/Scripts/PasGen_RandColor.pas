unit PasGen_RandColor;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs, Variants, DB, Menus,
  CtMetaTable, CTMetaData, CtObjSerialer, DmlScriptPublic, DmlPasScriptLite;

type

  { TDmlPasScriptorLite_RandColor }

  TDmlPasScriptorLite_RandColor=class(TDmlPasScriptorLite)
  public
    { Public declarations }
    procedure Exec(ARule, AScript: string); override;
  end;

implementation

uses
  StdCtrls, WindowFuncs, ActnList;

{ TDmlPasScriptorLite_RandColor }


procedure TDmlPasScriptorLite_RandColor.Exec(ARule, AScript: string);
// 以下代码来源于EZDML自定义工具脚本模板RandColor.pas

function GetLinkCount(tb: TCtMetaTable): Integer;
var
  S: string;
  ss: TStringList;
  K: Integer;
  fd: TCtMetaField;
begin
  Result := 0;
  for K:=0 to tb.MetaFields.Count -1 do
  begin
    fd := tb.MetaFields.Items[K];
    if (fd.RelateTable <> '') and (fd.RelateField <> '') then
      Inc(Result);
  end;
  s:=tb.getOneToManyInfo(false);
  if Trim(s)='' then
    Exit;
  ss := TStringList.Create;
  try
    ss.Text := Trim(S);
    Result := Result + ss.Count;
  finally
    ss.Free;
  end;
end;

function GetRandColor(lkC: Integer): Integer;
var
  r, g, b, lk: Integer;
begin
  lk := lkC+1;
  lk := lk*lk;
  if lk>48 then
    lk := 48;
  if lk<10 then
    lk := 10;

  r := 245-Random(lk);
  g := 245-Random(lk);
  b := 245-Random(lk);
  Result := r+(g shl 8) + (b shl 16);
end;

var
  I, J, K, C: Integer;
  md: TCtDataModelGraph;
  tb: TCtMetaTable;
  fd: TCtMetaField;
begin         
  if not Confirm('此操作将对选中的对象设置设置随机颜色（按连接数量决定颜色深浅，将忽略少于两个连接的对象），确定要继续吗？') then
    Exit;
  Randomize;
  C := 0;
  for I:=0 to AllModels.Count-1 do
  if AllModels.Items[I] = AllModels.CurDataModel then
  begin
    md := AllModels.Items[I];
    CurOut.Add('Model'+IntToStr(I)+': '+md.NameCaption);

    for J:=0 to md.Tables.Count-1 do
    if md.Tables.Items[J].IsSelected then
    //if CurTable <> nil then if md.Tables.Items[J].Name = CurTable.Name then
    begin
      tb := md.Tables.Items[J];
      if (tb.BgColor<>0) and (tb.BgColor<>$ffffff) then
       ;// Continue;
      K := GetLinkCount(tb);
      if K>=2 then
      begin
        tb.BgColor := GetRandColor(K);
        DoTablePropsChanged(Tb);
        CurOut.Add('  '+IntToStr(K)+': '+tb.NameCaption+' - '+IntToStr(tb.BgColor));
        Inc(C);
      end;
    end;
  end;
  if C>0 then
  begin
    TAction(FindChildComp(Application.MainForm,'actRefresh')).Execute;
  end;
end;

initialization
  RegisterPasLite('RandColor', TDmlPasScriptorLite_RandColor, 'Tool');

end.

