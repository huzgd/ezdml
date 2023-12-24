unit CtMetaMysqlDb;

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  CtMetaData, CtMetaTable, CtMetaFCLSqlDb, DB, sqlDb
  {$ifdef WIN32}
  , mysql57conn
  {$else}
  , mysql57conn2
  {$endif}   ;

type

  { TCtMetaMysqlDb }

  TCtMetaMysqlDb = class(TCtMetaFCLSqlDb)
  private
    FTempSS: TStrings;
  protected
    function CreateSqlDbConn: TSQLConnection; override;
    procedure SetDbSchema(const Value: string); override;
    procedure SetFCLConnDatabase; override;      
    procedure SetConnected(const Value: boolean); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function ShowDBConfig(AHandle: THandle): boolean; override;

    function GetDbNames: string; override;
    function GetDbUsers: string; override;
    function GetDbObjs(ADbUser: string): TStrings; override;

    function GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject; override;
    function GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string; override;

    //执行命令       
    // function ExecCmd(ACmd, AParam1, AParam2: string): string; override;
    function ObjectExists(ADbUser, AObjName: string): boolean; override;

  end;


implementation

uses Dialogs, wCommonDBConfig, Forms, dmlstrs;

{ TCtMetaMysqlDb }


function TCtMetaMysqlDb.CreateSqlDbConn: TSQLConnection;
begin
  Result := TMySQL57Connection.Create(nil);
  Result.CharSet := 'utf8';
  TMySQL57Connection(Result).SkipLibraryVersionCheck:=True;
end;

procedure TCtMetaMysqlDb.SetDbSchema(const Value: string);
begin
  if FDbSchema = Value then
    Exit;
  if Value <> '' then
  begin
    try
      ExecSql('use ' + GetDbQuotName(Value, Self.EngineType));
    except
      Application.HandleException(Self);
    end;
  end;
  FDbSchema := Value;
  inherited SetDbSchema(Value);
end;


procedure TCtMetaMysqlDb.SetFCLConnDatabase;
var
  po: integer;
  S: string;
begin
  inherited SetFCLConnDatabase;
  if not Assigned(FDbConn) then
    Exit;
  po := Pos(':', FDbConn.HostName);
  if po > 0 then
  begin
    S := Copy(FDbConn.HostName, po + 1, Length(FDbConn.HostName));
    TMySQL57Connection(FDbConn).Port := StrToIntDef(S, 3306);
    FDbConn.HostName := Copy(FDbConn.HostName, 1, po - 1);
  end;
end;

procedure TCtMetaMysqlDb.SetConnected(const Value: boolean);
begin
  inherited SetConnected(Value);
end;


constructor TCtMetaMysqlDb.Create;
begin
  inherited;
  FEngineType := 'MYSQL';
  FTempSS := TStringList.Create;
end;

destructor TCtMetaMysqlDb.Destroy;
begin
  FTempSS.Free;
  inherited;
end;

function TCtMetaMysqlDb.ShowDBConfig(AHandle: THandle): boolean;
var
  S: string;
begin
  S := Database;
  if S = ''  then
    S := 'localhost:3306@test';
  S := TfrmCommDBConfig.DoDbConfig(S, Self.EngineType);
  if S <> '' then
  begin
    Database := S;
    Result := True;
  end
  else
    Result := False;
end;

function TCtMetaMysqlDb.GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string;
begin
  Result := inherited GenObjSql(obj, obj_db, sqlType);
end;

function TCtMetaMysqlDb.GetDbNames: string;
begin
  Result := 'localhost:3306@test';
end;

function TCtMetaMysqlDb.GetDbObjs(ADbUser: string): TStrings;
var
  S, U: string;
  ss: TStringList;
  I: integer;
begin
  CheckConnected;
  Result := FTempSS;
  Result.Clear;
  ss := TStringList.Create;
  try
    if ADbUser <> '' then
      ss.Add(ADbUser)
    else
      ss.Text := Self.GetDbUsers;
    for I := 0 to ss.Count - 1 do
    begin
      U := Trim(ss[I]);
      if U = '' then
        Continue;

      with FQuery do
      begin
        Clear;
        S := 'show full tables from ' + GetDbQuotName(U, Self.EngineType);
        Sql.Text := S;

        Open;
        while not EOF do
        begin
          if UpperCase(Fields[1].AsString) <> 'VIEW' then
          begin
            if (ADbUser = '') or (ADbUser <> U) then
              Result.Add(U + '.' + Fields[0].AsString)
            else
              Result.Add(Fields[0].AsString);
          end;
          Next;
        end;
      end;
    end;
  finally
    ss.Free;
  end;
end;

function TCtMetaMysqlDb.GetDbUsers: string;
begin
  Result := '';
  with FQuery do
  begin
    Clear;
    Sql.Text := 'show databases';
    Open;
    while not EOF do
    begin
      if Result = '' then
        Result := Fields[0].AsString
      else
        Result := Result + #13#10 + Fields[0].AsString;
      Next;
    end;
  end;
end;



function TCtMetaMysqlDb.GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject;
var
  o: TCtMetaTable;
  f: TCtMetaField;
  S, T, sSz, sPr: string;
  I, L, po, iSz, iPr: integer;            
  idxNames, idxCols: array of string;
  idxUniqs: array of Boolean;
begin
  Result := nil;

  if ADbUser = '' then
  begin
    po := Pos('.', AObjName);
    if po > 0 then
    begin
      ADbUser := Copy(AObjName, 1, po - 1);
      AObjName := Copy(AObjName, po + 1, Length(AObjName));
    end;
  end;

  if ADbUser <> '' then
    DbSchema := GetDbQuotName(ADbUser, Self.EngineType);

  if not ObjectExists(ADbUser, AObjName) then
    Exit;

  with FQueryB do
  begin
    { 字段信息 }
    Clear;
    if ADbUser <> '' then
      SQL.Text := 'SHOW FULL COLUMNS FROM ' + GetDbQuotName(AObjName, Self.EngineType) + ' FROM ' + GetDbQuotName(ADbUser, Self.EngineType)
    else
      SQL.Text := 'SHOW FULL COLUMNS FROM ' + GetDbQuotName(AObjName, Self.EngineType);
    Open;

    if EOF then
      Exit;

    S := '';
    o := TCtMetaTable.Create;
    Result := o;
    Result.Name := AObjName;
    while not EOF do
    begin
      with o.MetaFields.NewMetaField do
      begin
        Name := FieldByName('Field').AsString;
        T := LowerCase(FieldByName('Type').AsString);
        po := Pos('(', T);
        if po > 0 then
        begin
          sSz := Trim(Copy(T, po + 1, Length(T)));
          T := Copy(T, 1, po - 1);

          if Copy(sSz, Length(sSz), 1) = ')' then
            sSz := Copy(sSz, 1, Length(sSz) - 1);

          sPr := '';
          po := Pos(',', sSz);
          if po > 0 then
          begin
            sPr := Trim(Copy(sSz, po + 1, Length(sSz)));
            sSz := Trim(Copy(sSz, 1, po - 1));
          end;
        end
        else
        begin
          sSz := '';
        end;
        iSz := StrToIntDef(sSz, 0);
        iPr := StrToIntDef(sPr, 0);

        if (T = 'char') or (T = 'varchar') or (T = 'tinytext') then
        begin
          DataType := cfdtString;
          DataLength := iSz;
        end
        else if (T = 'text') or (T = 'mediumtext') or (T = 'longtext') then
        begin
          DataType := cfdtString;
          DataLength := DEF_TEXT_CLOB_LEN;
        end
        else if (T = 'bigint') or (T = 'int') or (T = 'smallint') or
          (T = 'mediumint') then
        begin
          DataType := cfdtInteger;
          if iSz = 1 then
            DataType := cfdtBool
          else if iSz = 2 then
            DataType := cfdtEnum;
          if Pos('auto_increment', FieldByName('Extra').AsString) > 0 then
            DefaultValue := DEF_VAL_auto_increment;
        end
        else if (T = 'decimal') then
        begin
          if (iSz > 0) and (iPr = 0) then
          begin
            DataType := cfdtInteger;
            DataLength := iSz;
            if DataLength <= 2 then
            begin
              DataType := cfdtEnum;
              DataLength := 0;
            end;
            if Pos('auto_increment', FieldByName('Extra').AsString) > 0 then
              DefaultValue := DEF_VAL_auto_increment;
          end
          else
          begin
            DataType := cfdtFloat;
            DataLength := iSz;
            DataScale := iPr;
          end;
        end
        else if (T = 'float') or (T = 'double') then
        begin
          DataType := cfdtFloat;
          DataLength := iSz;
          DataScale := iPr;
        end
        else if (T = 'datetime') or (T = 'time') or (T = 'year') or
          (T = 'datetime') or (T = 'timestamp') then
        begin
          DataType := cfdtDate;
        end
        else if (T = 'bit') then
        begin
          DataType := cfdtBool;
        end
        else if (T = 'tinyint') then
        begin
          DataType := cfdtEnum;
          if iSz = 1 then
            DataType := cfdtBool
          else if iSz = 2 then
            DataType := cfdtEnum;
        end
        else if (T = 'tinyblob') or (T = 'blob') or (T = 'mediumblob') or
          (T = 'longblob') then
        begin
          DataType := cfdtBlob;
          if T <> 'BLOB' then
            DataTypeName := UpperCase(T);
        end
        else
        begin
          DataType := GetPossibleCtFieldTypeOfName(T);
          DataTypeName := T;
        end;
        if (Pos('[DBTYPENAMES]', AOpt) > 0) then
          DataTypeName := T;

        T := LowerCase(FieldByName('Key').AsString);
        if T = 'pri' then
          KeyFieldType := cfktId
        {else if T = 'uni' then
          IndexType := cfitUnique
        else if T = 'mul' then
          IndexType := cfitNormal};

        T := FieldByName('Null').AsString;
        if T = 'NO' then
          Nullable := False;

        T := FieldByName('Default').AsString;
        if T<>'' then
          DefaultValue := T;

        T := FieldByName('Comment').AsString;
        Memo := T;
      end;
      Next;
    end;

    { 表注释 }
    Close;                  
    if ADbUser <> '' then
      Sql.Text := 'SELECT table_comment  FROM information_schema.tables WHERE TABLE_NAME='''
        + AObjName + ''' and TABLE_SCHEMA=''' + ADbUser + ''''
    else
      Sql.Text := 'SELECT table_comment  FROM information_schema.tables WHERE TABLE_NAME='''
        + AObjName + '''';
    Open;
    if not EOF then
      o.Memo := Fields[0].AsString;

    { 外键信息 }
    Close;   
    if ADbUser <> '' then
      SQL.Text :=
        'select Column_Name, Referenced_Table_Schema, Referenced_Table_Name, Referenced_Column_Name'
        + #13#10 + '  from information_schema.KEY_COLUMN_USAGE' + #13#10 +
        ' where table_name = ''' + AObjName + ''' and table_schema = ''' + ADbUser + ''''
    else
      SQL.Text :=
        'select Column_Name, Referenced_Table_Schema, Referenced_Table_Name, Referenced_Column_Name'
        + #13#10 + '  from information_schema.KEY_COLUMN_USAGE' + #13#10 +
        ' where table_name = ''' + AObjName + '''';
    Open;
    while not EOF do
    begin
      S := FieldByName('Column_Name').AsString;
      T := FieldByName('Referenced_Table_Name').AsString;
      f := o.MetaFields.FieldByName(S);
      if (f <> nil) and (T <> '') then
      begin
        if f.KeyFieldType <> cfktId then
          f.KeyFieldType := cfktRid;
        f.RelateTable := T;
        f.RelateField := FieldByName('Referenced_Column_Name').AsString;
      end;
      Next;
    end;

    { 索引信息 }
    Close;       
    L := 0;
    SetLength(idxNames, L);
    SetLength(idxUniqs, L);
    SetLength(idxCols, L);

    if ADbUser <> '' then
      SQL.Text :=  'select INDEX_NAME, NON_UNIQUE, COLUMN_NAME ' + #13#10 +
        '  from information_schema.STATISTICS' + #13#10 +
        ' where table_name = ''' + AObjName + ''' and table_schema = ''' + ADbUser + ''''
    else
      SQL.Text :=  'select INDEX_NAME, NON_UNIQUE, COLUMN_NAME ' + #13#10 +
        '  from information_schema.STATISTICS' + #13#10 +
        ' where table_name = ''' + AObjName + '''';
    Open;
    while not EOF do
    begin                
      Inc(L);
      SetLength(idxNames, L);
      SetLength(idxUniqs, L);
      SetLength(idxCols, L);   
      idxNames[L - 1] := FieldByName('INDEX_NAME').AsString;
      idxUniqs[L - 1] := FieldByName('NON_UNIQUE').AsInteger = 0;
      idxCols[L - 1] := FieldByName('COLUMN_NAME').AsString;

      Next;
    end;

    I := 0;
    while I <= L - 1 do
    begin
      if (I < L - 1) and (idxNames[I] = idxNames[I + 1]) then
      begin
        f := o.MetaFields.NewMetaField;
        f.Name := RemoveIdxNamePrefx(idxNames[I], o.Name);
        f.DataType := cfdtFunction;
        if idxUniqs[I] then
          f.IndexType := cfitUnique
        else
          f.IndexType := cfitNormal;

        S := GetIdxName(o.Name, f.Name);
        if f.IndexType = cfitUnique then
          S := 'IDU_' + S
        else
          S := 'IDX_' + S;
        if LowerCase(idxNames[I]) <> LowerCase(S) then
          f.Memo := '[DB_INDEX_NAME:' + idxNames[I] + ']';

        S := idxCols[I];
        Inc(I);
        S := S + ',' + idxCols[I];
        while (I < L - 1) and (idxNames[I] = idxNames[I + 1]) do
        begin
          Inc(I);
          S := S + ',' + idxCols[I];
        end;
        f.IndexFields := S;
        f.Memo := Trim(S + ' ' + f.Memo);
        Inc(I);
      end
      else
      begin
        f := o.MetaFields.FieldByName(idxCols[I]);
        if Assigned(f) and (f.KeyFieldType <> cfktId) then
        begin
          if idxUniqs[I] then
            f.IndexType := cfitUnique
          else
            f.IndexType := cfitNormal;
        end;
        Inc(I);
      end;
    end;
  end;
end;

function TCtMetaMysqlDb.ObjectExists(ADbUser, AObjName: string): boolean;
var
  po: integer;
  S: String;
begin
  Result := False;
  CheckConnected;

  if ADbUser = '' then
  begin
    po := Pos('.', AObjName);
    if po > 0 then
    begin
      ADbUser := Copy(AObjName, 1, po - 1);
      AObjName := Copy(AObjName, po + 1, Length(AObjName));
    end;
  end;

  with FQuery do
  begin
    Clear;
    S := 'SELECT count(*) as OBJ_COUNT FROM information_schema.tables WHERE TABLE_NAME='''
      + AObjName + '''';
    if ADbUser <> '' then
      S := S+' and TABLE_SCHEMA=''' + ADbUser + '''';
    Sql.Text := S;

    Open;
    if not EOF then
      Result := Fields[0].AsInteger > 0;
  end;
end;


initialization
  AddCtMetaDBReg('MYSQL', TCtMetaMysqlDb);

end.
