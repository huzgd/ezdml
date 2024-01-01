unit PasGen_AddAllTables;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs, Variants, DB, Menus, ActnList,
  CtMetaTable, CTMetaData, CtObjSerialer, DmlScriptPublic, DmlPasScriptLite;

type

  { TDmlPasScriptorLite_AddAllTables }

  TDmlPasScriptorLite_AddAllTables=class(TDmlPasScriptorLite)
  public
    { Public declarations }
    procedure Exec(ARule, AScript: string); override;
  end;

implementation

{ TDmlPasScriptorLite_AddAllTables }


procedure TDmlPasScriptorLite_AddAllTables.Exec(ARule, AScript: string);

// 以下代码来源于EZDML自定义工具脚本模板Add all tables.pas

//本脚本将当前文件中所有其它模型中的表都添加到当前模型中来（重复表名的除外）
var
  I, J, C: Integer;
  md, curMd: TCtDataModelGraph;
  tb, ntb: TCtMetaTable;
  comp, comp2: TComponent;
  S: string;
begin
  curMd := CurModel;
  if curMd=nil then
  begin
    alert('No model');
    Exit;
  end;
  if Application.MessageBox('Add all tables from other models to current model?',
    PChar(Application.title), MB_OKCANCEL or MB_ICONQUESTION)<>IDOK then
    Exit;

  for I:=0 to AllModels.Count-1 do //遍历所有模型图
    if AllModels.Items[I] <> curMd then //排除当前模型图
    begin
      md := AllModels.Items[I];

      for J:=0 to md.Tables.Count-1 do //遍历所有表
      begin
        tb := md.Tables.Items[J];
        if curMd.Tables.ItemByName(tb.Name, False)=nil then //当前模型找不到同名表？
        begin
          ntb := curMd.Tables.NewTableItem;
          ntb.AssignFrom(tb);
          C := C+1;
        end;
      end;
    end;

  if C>0 then
  begin
    comp:=FindChildComp(Application.MainForm,'FrameCtTableDef');
    comp:=FindChildComp(comp,'FrameDMLGraph');
    comp:=FindChildComp(comp,'FrameCtDML');    
    comp2:=FindChildComp(comp,'actRefresh');
    TAction(comp2).Execute;
    comp2:=FindChildComp(comp,'actRearrange');
    TAction(comp2).Execute;
  end;
  alert(Format('%d tables added',[C]));

end;

initialization
  RegisterPasLite('Add all tables', TDmlPasScriptorLite_AddAllTables, 'Tool');

end.

