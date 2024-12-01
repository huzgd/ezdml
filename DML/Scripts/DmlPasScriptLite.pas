unit DmlPasScriptLite;

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs, Variants, DB, Menus,
  CtMetaTable, CTMetaData, CtObjSerialer, DmlScriptPublic;

type

  { TDmlPasScriptorLite }

  TDmlPasScriptorLite = class(TDmlBaseScriptor)
  protected
    { Private declarations }
    AllModels: TCtDataModelGraphList;     
    CurModel: TCtDataModelGraph;
  public
    { Public declarations }
    constructor Create; override;
    destructor Destroy; override;

    function GetParamValueDef(AName,ADef: string): string;
    procedure AbortOut;
    procedure Alert(const Msg: Variant);

    function GetSettingPanelText: string; virtual;

    procedure Init(const ARule: string; ACtObj: TCtMetaObject;
      AResout: TStrings; ACtrlList: TObject); override;
    procedure Exec(ARule, AScript: string); override;
  end;
      
  TDmlPasScriptorLiteClass = class of TDmlPasScriptorLite;

  TCtPasLiteReg = record
    Name: string;
    PsClass: TDmlPasScriptorLiteClass;
    Cat: string;
  end;
            
procedure RegisterPasLite(Name: string; PsClass: TDmlPasScriptorLiteClass; Cat: String);
function CreatePsLiteScriptor(Name: string; Cat: String=''): TDmlPasScriptorLite;

var
  CtPsLiteRegs: array of TCtPasLiteReg;

implementation

uses
  PvtInput,
  WindowFuncs,
  AutoNameCapitalize,
  dmlstrs,
  TypInfo, lclproc,
  CtObjJsonSerial,
  NetUtil,
  PasGen_Cpp, PasGen_Excel, PasGen_Word, PasGen_Test, PasGen_AddAllTables,
  PasGen_JDBCServer, PasGen_RandColor;

procedure RegisterPasLite(Name: string; PsClass: TDmlPasScriptorLiteClass; Cat: String);
var
  L: Integer;
begin
  L := Length(CtPsLiteRegs);
  SetLength(CtPsLiteRegs, L+1);
  CtPsLiteRegs[L].Name := Name;
  CtPsLiteRegs[L].PsClass:=PsClass;     
  CtPsLiteRegs[L].Cat:=Cat;
end;

function CreatePsLiteScriptor(Name: string; Cat: String=''): TDmlPasScriptorLite;
var
  I: Integer;
begin
  Result := nil;
  for I:=0 to High(CtPsLiteRegs) do
  begin
    if Name= CtPsLiteRegs[I].Name then
      if (Cat='') or (Cat=CtPsLiteRegs[I].Cat) then
      begin
        Result := CtPsLiteRegs[I].PsClass.Create;
        Exit;
      end;
  end;
end;

constructor TDmlPasScriptorLite.Create;
begin
  inherited;
  FScriptType := 'paslt';
end;

destructor TDmlPasScriptorLite.Destroy;
begin
  inherited Destroy;
end;

function TDmlPasScriptorLite.GetParamValueDef(AName, ADef: string): string;
begin
  Result := ADef;
end;

procedure TDmlPasScriptorLite.AbortOut;
begin
  CtScript_AbortOut;
end;

procedure TDmlPasScriptorLite.Alert(const Msg: Variant);
begin
  MsgBox(Msg);
end;

function TDmlPasScriptorLite.GetSettingPanelText: string;
begin
  Result := '';
end;

procedure TDmlPasScriptorLite.Init(const ARule: string; ACtObj: TCtMetaObject;
  AResout: TStrings; ACtrlList: TObject);
begin
  inherited Init(ARule, ACtObj, AResout, ACtrlList);
  AllModels := FGlobeDataModelList;
  CurModel := FGlobeDataModelList.CurDataModel;
end;


procedure TDmlPasScriptorLite.Exec(ARule, AScript: string);
begin
end;



initialization
  DmlPasScriptorClass := TDmlPasScriptorLite;

end.

