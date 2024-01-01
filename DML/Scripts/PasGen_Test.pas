unit PasGen_Test;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs, Variants, DB, Menus,
  CtMetaTable, CTMetaData, CtObjSerialer, DmlScriptPublic, DmlPasScriptLite;

type

  { TDmlPasScriptorLite_Test }

  TDmlPasScriptorLite_Test=class(TDmlPasScriptorLite)
  public
    { Public declarations }
    procedure Exec(ARule, AScript: string); override;
  end;

implementation

{ TDmlPasScriptorLite_Test }


procedure TDmlPasScriptorLite_Test.Exec(ARule, AScript: string);
begin
  CurOut.Add('Hello world!');
end;

initialization
  RegisterPasLite('Hello world', TDmlPasScriptorLite_Test, 'Table');

end.

