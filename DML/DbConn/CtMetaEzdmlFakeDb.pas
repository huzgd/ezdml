unit CtMetaEzdmlFakeDb;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  IniFiles, CTMetaData, CtMetaTable, DB, Forms, Dialogs;

type
  TCtMetaEzdmlFakeDb = class(TCtMetaDatabase)
  private
    FDataModelList: TCtDataModelGraphList;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure SetFakeEngineType(AEngType: String);

    property DataModelList: TCtDataModelGraphList read FDataModelList;

    function GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject; override;
    function ObjectExists(ADbUser, AObjName: string): Boolean; override;
  end;


implementation

{ TCtMetaEzdmlFakeDb }

constructor TCtMetaEzdmlFakeDb.Create;
begin
  inherited;
  FEngineType := 'STANDARD';     
  FDataModelList := TCtDataModelGraphList.Create;
end;

destructor TCtMetaEzdmlFakeDb.Destroy;
begin
  FDataModelList.Free;
  inherited;
end;

function TCtMetaEzdmlFakeDb.GetObjInfos(ADbUser, AObjName,
  AOpt: string): TCtMetaObject;
var
  J, K: integer;
  MetaObjListDB: TCtMetaObjectList;
  dmlDBTbObj: TCtMetaObject;
begin
  Result := nil;
  for K := 0 to FDataModelList.Count - 1 do
  begin
    if ADbUser <> '' then
      if not AnsiSameText(ADbUser, FDataModelList.Items[K].Name) then
        Continue;
    MetaObjListDB:=FDataModelList.Items[K].Tables;

    for J := 0 to MetaObjListDB.Count - 1 do
    begin
      dmlDBTbObj := TCtMetaTable(MetaObjListDB[J]);
      if AnsiSameText(dmlDBTbObj.Name, AObjName) then
      begin
        Result := dmlDBTbObj;
        Exit;
      end;
    end;
  end;
end;

function TCtMetaEzdmlFakeDb.ObjectExists(ADbUser, AObjName: string): Boolean;
var
  res: TCtMetaObject;
begin
  Result := False;
  res := GetObjInfos(ADbUser, AObjName, '');
  if res <> nil then
    Result := True;
end;

procedure TCtMetaEzdmlFakeDb.SetFakeEngineType(AEngType: String);
begin
  Self.FEngineType := AEngType;
end;

end.

