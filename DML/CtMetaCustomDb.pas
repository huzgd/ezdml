(*
  通过JSON结果来获取任意数据源信息
  by huz 20210213
*)

unit CtMetaCustomDb;

interface

uses
  LCLIntf, LCLType, Messages, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  CtMetaData, CtMetaTable, DB, uJson;

type

  { TCtMetaCustomDb }

  TCtMetaCustomDb = class(TCtMetaDatabase)
  private
    FTempSS: TStrings;
  protected              
    FNeedGenCustomSql: Boolean;
    //执行命令
    procedure ExecCustomDbCmdOk(cmd: string; par1: string = ''; par2: string = '';
      buf: string = ''); virtual;
    function ExecCustomDbCmdMap(cmd, par1, par2, buf: string): TJSONObject; virtual;
    function ExecCustomDbCmd(cmd, par1, par2, buf: string): string; virtual; //子类必须实现此方法

    function ConvertStrToJson(const str: string): TJSONObject; virtual;
    function ConvertJsonToDataSet(AJson: TJSONObject): TDataSet; virtual;
    procedure RaiseError(msg, cmd: string);
  public
    constructor Create; override;
    destructor Destroy; override;

    function ShowDBConfig(AHandle: THandle): boolean; override;

    procedure ExecSql(ASql: string); override;
    function OpenTable(ASql, op: string): TDataSet; override;

    function GetDbNames: string; override;
    function GetDbUsers: string; override;
    function GetDbObjs(ADbUser: string): TStrings; override;

    function GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject; override;
                                                                                       
    //生成普通SQL事件 是否生成创建表SQL、是否生成创建约束SQL、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL
    function OnGenTableSql(tb: TCtMetaTable; bCreateTb, bCreateConstrains: Boolean; defRes, dbType, options: string): string; override;
    //生成数据库升级SQL。sqlType: 0全部 1不含外键 2外键
    function GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string; override;

    //执行命令
    function ObjectExists(ADbUser, AObjName: string): boolean; override;
  end;


implementation

uses
  memds, WindowFuncs;

{ TCtMetaCustomDb }

function TCtMetaCustomDb.ConvertJsonToDataSet(AJson: TJSONObject): TDataSet;
  function GetDataTypeOfName(AName: string): TFieldType;
  begin
    if AName = 'Integer' then
      Result := ftInteger
    else if AName = 'Float' then
      Result := ftFloat
    else if AName = 'Date' then
      Result := ftString//ftDateTime
    else if AName = 'Blob' then
      Result := ftBlob
    else
      Result := ftString;
  end;

  procedure GetBlobFieldValue(ADS: TDataSet; Fld: TField; data: string);
  var
    Tmp: TStream;
    S: string;
  begin
    if data = '' then
      Exit;    
    if data = 'null' then
      Exit;
    S := WideCodeNarrow(data);
    Tmp := ADS.CreateBlobStream(Fld, bmReadWrite);
    try
      Tmp.WriteBuffer(PChar(S)^, Length(S));
    finally
      Tmp.Free;
    end;
  end;

var
  ADataSet: TMemDataSet;
  jCols, jRows: TJSONArray;
  mapA, mapR: TJSONObject;
  I, J: Integer;
  T: String;
begin
  Result := nil;
  if AJson = nil then
    Exit;

  ADataSet := TMemDataSet.Create(nil);
  Result := ADataSet;

  if ADataSet.Active then
    ADataSet.Close;
  ADataSet.FieldDefs.Clear;
  jCols := AJson.getList('Cols');
  if jCols.Count = 0 then
  begin
    with ADataSet.FieldDefs.AddFieldDef do
    begin
      Name := 'NO_DATA_FOUND';
      DataType := ftString;
      Size := 4000;
    end;
    Exit;
  end;

  for I := 0 to jCols.Count - 1 do
    with ADataSet.FieldDefs.AddFieldDef do
    begin
      mapA := jCols.getMap(I);
      Name := mapA.getString('Name');
      DataType := GetDataTypeOfName(mapA.getString('DataType'));
      if mapA.optInt('Size') > 0 then
        Size := mapA.optInt('Size')
      else if DataType = ftString then
        Size := 4000;
    end;
  ADataSet.CreateTable;
  if not ADataSet.Active then
    ADataSet.Open;
  for I := 0 to ADataSet.FieldCount - 1 do
    if ADataSet.Fields[I].DisplayWidth > 32 then
      ADataSet.Fields[I].DisplayWidth := 32;

  jRows := AJson.getList('Rows');
  for J := 0 to jRows.Count - 1 do
  begin
    mapR := jRows.getMap(J);
    ADataSet.Append;
    for I := 0 to ADataSet.FieldCount - 1 do
      case ADataSet.Fields[I].DataType of
        ftBlob:
          GetBlobFieldValue(ADataSet, ADataSet.Fields[I], mapR.optString(ADataSet.Fields[I].FieldName));
      else
        begin
          T:=mapR.optString(ADataSet.Fields[I].FieldName);
          if (T<>'') and (T<>'null') then
            ADataSet.Fields[I].AsString := T;
        end;
      end;
    ADataSet.Post;
  end;
  ADataSet.First;
end;

function TCtMetaCustomDb.ConvertStrToJson(const str: string): TJSONObject;
begin
  Result := nil;
  if Str = '' then
    Exit;
  Result := TJSONObject.create(str); ;
end;

constructor TCtMetaCustomDb.Create;
begin
  inherited;
  FEngineType := 'CUSTOM';
  FTempSS := TStringList.Create;
end;

destructor TCtMetaCustomDb.Destroy;
begin
  FreeAndNil(FTempSS);
  inherited;
end;

function TCtMetaCustomDb.ShowDBConfig(AHandle: THandle): boolean;
begin
  //显示连接界面，用于获取服务地址端口用户名密码等信息
  Result := False;
end;

function TCtMetaCustomDb.ExecCustomDbCmd(cmd, par1, par2, buf: string): string;
begin
  //执行命令，返回JSON字符串，其中resultCode=-1表示失败，errorMsg为出错信息，其它情况为成功
  Result := '';
end;

function TCtMetaCustomDb.ExecCustomDbCmdMap(cmd, par1, par2,
  buf: string): TJSONObject;
var
  S: string;
begin
  S := ExecCustomDbCmd(cmd, par1, par2, buf);
  if S = '' then
    RaiseError('no_data_result', cmd);
  Result := ConvertStrToJson(S);
  if Result = nil then
    RaiseError('no_map_result', cmd);
  if Result.optInt('resultCode') = -1 then
  begin
    S := Result.optString('errorMsg');
    Result.Free;
    Result := nil;
    RaiseError(S, cmd);
  end;
end;

procedure TCtMetaCustomDb.ExecCustomDbCmdOk(cmd: string; par1: string;
  par2: string; buf: string);
var
  map: TJSONObject;
begin
  map := ExecCustomDbCmdMap(cmd, par1, par2, buf);
  if map <> nil then
    map.Free;
end;

procedure TCtMetaCustomDb.ExecSql(ASql: string);
begin
  ExecCustomDbCmdOk('ExecSql', ASql);
end;

function TCtMetaCustomDb.OpenTable(ASql, op: string): TDataSet;
var
  map: TJSONObject;
begin
  Result := nil;
  map := ExecCustomDbCmdMap('OpenTable', ASql, op, '');
  if map = nil then
    Exit;
  try
    Result := ConvertJsonToDataSet(map);
  finally
    map.Free;
  end;


(*

var
  map: TJSONObject;
  ds: TDataSet;
  S: string;
begin
  map := ExecCustomDbCmdMap('GetDbObjs', ADbUser, '', '');
  if map = nil then
    Exit;
  ds := nil;
  try
    ds := ConvertJsonToDataSet(map);
    ds.First;
    while not ds.Eof do
    begin
      S := ds.Fields[0].AsString;
      Result.Add(S);
      ds.Next;
    end;
  finally
    if ds <> nil then
      ds.Free;
    map.Free;
  end;*)
end;

procedure TCtMetaCustomDb.RaiseError(msg, cmd: string);
begin
  if msg = '' then
    msg := 'unknown_error';
  raise Exception.Create(msg);
end;

function TCtMetaCustomDb.GetDbNames: string;
begin
  Result := ''; //'http://localhost:8083/ezdml/dbcmd'#13#10'http://192.168.1.11:8083/ezdml/dbcmd';
end;

function TCtMetaCustomDb.GetDbUsers: string;
var
  map: TJSONObject;
  ds: TJSONArray;
  S: string;
  I: Integer;
begin
  //{"itemList":["TEST1","TEST2"]}
  Result := '';
  map := ExecCustomDbCmdMap('GetDbUsers', '', '', '');
  if map = nil then
    Exit;
  try
    ds := map.getList('itemList');
    for I := 0 to ds.Count - 1 do
    begin
      S := ds.getString(I);
      if S <> '' then
      begin
        if Result <> '' then
          Result := Result + #13#10;
        Result := Result + S;
      end;
    end;
  finally
    map.Free;
  end;
end;

function TCtMetaCustomDb.GetDbObjs(ADbUser: string): TStrings;
var
  map: TJSONObject;
  ds: TJSONArray;
  S: string;
  I: Integer;
begin
  //{"itemList":[{"DBUSER":"TEST1","DBOBJECT":"TABLE1"},{"DBUSER":"TEST1","DBOBJECT":"TABLE2"}]}
  Result := FTempSS;
  Result.Clear;
  map := ExecCustomDbCmdMap('GetDbObjs', ADbUser, '', '');
  if map = nil then
    Exit;
  try
    ds := map.getList('itemList');
    for I := 0 to ds.Count - 1 do
    begin
      S := ds.getString(I);
      if S <> '' then
      begin
        Result.Add(S);
      end;
    end;
  finally
    map.Free;
  end;
end;

function TCtMetaCustomDb.GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject;
var
  S: string;
begin
  //RESULT为CtMetaTable对象内容
  //{"RESULT":{"Name":"TABLE1","MetaFields":{Count:8, items:[...]}}}
  S := ExecCustomDbCmd('GetObjInfos', ADbUser, AObjName, AOpt);
  if S = '' then
    RaiseError('no_data_result', 'GetObjInfos');
  Result := TCtMetaTable.Create;
  Result.JsonStr := S;
end;

function TCtMetaCustomDb.OnGenTableSql(tb: TCtMetaTable; bCreateTb,
  bCreateConstrains: Boolean; defRes, dbType, options: string): string;  
var
  rmap, pmap: TJSONObject;
begin
  Result:=inherited OnGenTableSql(tb, bCreateTb, bCreateConstrains, defRes,
    dbType, options);

  if FNeedGenCustomSql then
  begin
    if dbType <> '' then
      if dbType <> Self.EngineType then
        Exit;
    //{"RESULT":"xxx"}
    pmap := TJSONObject.create;
    pmap.put('GenCreateTableSql', bCreateTb);
    pmap.put('GenCreateConstrainsSql', bCreateConstrains);
    pmap.put('EngineType', dbType);
    pmap.put('DefaultResult', Result);
    pmap.put('Options', options);
    rmap := ExecCustomDbCmdMap('GenCustomSql', tb.JsonStr, '', pmap.toString);
    try
      if rmap <> nil then
        Result := rmap.getString('RESULT');
    finally
      pmap.Free;
      if rmap <> nil then
        rmap.Free;
    end;
  end;
end;

function TCtMetaCustomDb.GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string;    
var
  rmap, pmap: TJSONObject;
begin
  Result := inherited GenObjSql(obj, obj_db, sqlType);

  if FNeedGenCustomSql then
  begin
    //{"RESULT":"xxx"}
    pmap := TJSONObject.create;
    if sqlType = 0 then
    begin
      pmap.put('GenCreateTableSql', True);
      pmap.put('GenCreateConstrainsSql', True);
    end
    else if sqlType = 1 then
    begin
      pmap.put('GenCreateTableSql', True);
      pmap.put('GenCreateConstrainsSql', False);
    end
    else if sqlType = 2 then
    begin
      pmap.put('GenCreateTableSql', False);
      pmap.put('GenCreateConstrainsSql', True);
    end;
    pmap.put('EngineType', Self.EngineType);
    pmap.put('DefaultResult', Result);
    pmap.put('SqlType', sqlType);
    rmap := ExecCustomDbCmdMap('GenCustomSql', obj.JsonStr, obj_db.JsonStr, pmap.toString);
    try
      if rmap <> nil then
        Result := rmap.getString('RESULT');
    finally
      pmap.Free;
      if rmap <> nil then
        rmap.Free;
    end;
  end;
end;

function TCtMetaCustomDb.ObjectExists(ADbUser, AObjName: string): boolean;
var
  map: TJSONObject;
begin
  //{"RESULT":"false"}
  Result := False;
  map := ExecCustomDbCmdMap('ObjectExists', ADbUser, AObjName, '');
  if map = nil then
    Exit;
  try
    Result := map.getBoolean('RESULT');
  finally
    map.Free;
  end;
end;


end.

