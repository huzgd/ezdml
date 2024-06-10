unit CtMetaPostgreSqlDb;

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  CtMetaData, CtMetaTable, CtMetaFCLSqlDb, pqconnection, DB, sqlDb;

type

  { TCtMetaPostgreSqlDb }

  TCtMetaPostgreSqlDb = class(TCtMetaFCLSqlDb)
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

uses Dialogs, wCommonDBConfig, Forms, dmlstrs, odbcconn, EzJdbcConn;


{ TCtMetaPostgreSqlDb }


function TCtMetaPostgreSqlDb.CreateSqlDbConn: TSQLConnection;
begin                           
  if (Pos('DSN:', DataBase) = 1) or (Pos('ODBC:', DataBase) = 1) then
    FUseDriverType := 'ODBC'
  else if Pos('JDBC:', DataBase) = 1 then
    FUseDriverType := 'JDBC'
  else
    FUseDriverType := '';

  if FUseDriverType='ODBC' then
  begin
    Result := TODBCConnection.Create(nil);
    Result.CharSet := Trim(G_OdbcCharset);
    Exit;
  end;
           
  if FUseDriverType='JDBC' then
  begin
    Result := TEzJdbcSqlConnection.Create(nil);
    TEzJdbcSqlConnection(Result).EzDbType := 'POSTGRESQL';
    Exit;
  end;

  Result := TPQConnection.Create(nil);
end;

procedure TCtMetaPostgreSqlDb.SetDbSchema(const Value: string);
begin
  if FDbSchema = Value then
    Exit;
  if Value <> '' then
    ExecSql('SET search_path TO ' + GetDbQuotName(Value, Self.EngineType));
  FDbSchema := Value;
  inherited SetDbSchema(Value);
end;


procedure TCtMetaPostgreSqlDb.SetFCLConnDatabase;
var
  po: integer;
  S: string;
begin
  inherited SetFCLConnDatabase;
  if not Assigned(FDbConn) then
    Exit;

  if FUseDriverType='ODBC' then
  begin
    S := FDbConn.HostName;

    FDbConn.DatabaseName := '';
    FDbConn.Params.Clear;

    if Pos('DSN:', S) = 1 then
    begin
      FDbConn.DatabaseName := Copy(S, 5, Length(S));
    end
    else if Pos('ODBC:', S) = 1 then
    begin
      S := Copy(S, 6, Length(S));
      S := StringReplace(S, ';', #10, [rfReplaceAll]);
      FDbConn.Params.Text := S;
    end;
    Exit;
  end;

  if FUseDriverType='JDBC' then
  begin
    S := FDbConn.HostName;
    if Pos('JDBC:', S) = 1 then
      S := Copy(S, 6, Length(S));

    FDbConn.DatabaseName := S;

    Exit;
  end;

  FDbConn.Params.Clear;
  po := Pos(':', FDbConn.HostName);
  if po > 0 then
  begin
    S := Copy(FDbConn.HostName, po + 1, Length(FDbConn.HostName));
    FDbConn.Params.Add('port=' + S);
    FDbConn.HostName := Copy(FDbConn.HostName, 1, po - 1);
  end;
end;

procedure TCtMetaPostgreSqlDb.SetConnected(const Value: boolean);
begin
  inherited SetConnected(Value);
end;


constructor TCtMetaPostgreSqlDb.Create;
begin
  inherited;
  FEngineType := 'POSTGRESQL';
  FTempSS := TStringList.Create;
end;

destructor TCtMetaPostgreSqlDb.Destroy;
begin
  FTempSS.Free;
  inherited;
end;

function TCtMetaPostgreSqlDb.ShowDBConfig(AHandle: THandle): boolean;
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

function TCtMetaPostgreSqlDb.GenObjSql(obj, obj_db: TCtMetaObject;
  sqlType: integer): string;
begin
  Result := inherited GenObjSql(obj, obj_db, sqlType);
end;

function TCtMetaPostgreSqlDb.GetDbNames: string;
begin
  Result := 'localhost:5432@test';
  Result := Result + #10'JDBC:jdbc:postgresql://localhost:5432/dbname'#10'DSN:User_or_System_DSN_Name'#10'ODBC:Driver=PostgreSQL Unicode;Server=MyDbServer;Port=3306;Database={database_name};';
end;

function TCtMetaPostgreSqlDb.GetDbObjs(ADbUser: string): TStrings;
var
  S: string;
begin
  CheckConnected;
  Result := FTempSS;
  Result.Clear;

  with FQuery do
  begin
    Clear;
    S := 'SELECT schemaname, tablename FROM pg_tables';
    if ADbUser <> '' then
      S := S + ' where schemaname=''' + ADbUser + '''';
    S := S + ' order by schemaname, tablename';
    Sql.Text := S;

    Open;
    while not EOF do
    begin
      if ADbUser = '' then
        Result.Add(Fields[0].AsString + '.' + Fields[1].AsString)
      else
        Result.Add(Fields[1].AsString);
      Next;
    end;
  end;
end;

function TCtMetaPostgreSqlDb.GetDbUsers: string;
begin
  Result := '';
  with FQuery do
  begin
    Clear;
    Sql.Text := 'SELECT nspname FROM pg_namespace ORDER BY nspname';
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


function PostgreSql2CtFieldType(ft: string): TCtFieldDataType;
const
  FtNTableInt: array[0..7] of string = (
    'bigint',
    'bigserial',
    'int8',
    'integer',
    'int4',
    'int',
    'serial',
    'serial4');

  FtNTableEnum: array[0..3] of string = (
    'TINYINT',
    'smallint',
    'int2',
    'int1');

  FtNTableText: array[0..4] of string = (
    'character',
    'varchar',
    'character varying',
    'char',
    'text');

  FtNTableFloat: array[0..6] of string = (
    'real',
    'double precision',
    'numeric',
    'decimal',
    'float8',
    'money',
    'float4');

  FtNTableDate: array[0..5] of string = (
    'date',
    'timestamp',
    'timestamp without time zone',
    'time without time zone',
    'interval',
    'time');
  FtNTableBool: array[0..1] of string = (
    'bool',
    'boolean');
  FtNTableBlob: array[0..0] of string = (
    'bytea');
  FtNTableObj: array[0..10] of string = (
    'point',
    'line',
    'lseg',
    'box',
    'path',
    'polygon',
    'circle',
    'cidr',
    'inet',
    'macaddr',
    'bit');
var
  I, po: integer;
begin
  Result := cfdtUnknow;
  po := Pos('(', ft);
  if po > 0 then
    ft := Copy(ft, 1, po - 1);
  ft := LowerCase(Trim(ft));
  if ft = '' then
  begin
    Result := cfdtBlob;
    Exit;
  end;

  for I := 0 to High(FtNTableInt) do
    if ft = FtNTableInt[i] then
    begin
      Result := cfdtInteger;
      Exit;
    end;
  for I := 0 to High(FtNTableEnum) do
    if ft = FtNTableEnum[i] then
    begin
      Result := cfdtEnum;
      Exit;
    end;
  for I := 0 to High(FtNTableText) do
    if ft = FtNTableText[i] then
    begin
      Result := cfdtString;
      Exit;
    end;
  for I := 0 to High(FtNTableFloat) do
    if ft = FtNTableFloat[i] then
    begin
      Result := cfdtFloat;
      Exit;
    end;
  for I := 0 to High(FtNTableDate) do
    if ft = FtNTableDate[i] then
    begin
      Result := cfdtDate;
      Exit;
    end;
  for I := 0 to High(FtNTableBool) do
    if ft = FtNTableBool[i] then
    begin
      Result := cfdtBool;
      Exit;
    end;
  for I := 0 to High(FtNTableBlob) do
    if ft = FtNTableBlob[i] then
    begin
      Result := cfdtBlob;
      Exit;
    end;
  for I := 0 to High(FtNTableObj) do
    if ft = FtNTableObj[i] then
    begin
      Result := cfdtObject;
      Exit;
    end;
end;

function TCtMetaPostgreSqlDb.GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject;
var
  o: TCtMetaTable;
  f: TCtMetaField;
  S, T: string;
  I, L, po: integer;    
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
    S := 'select  column_name,' + #13#10 +
      '        data_type,' + #13#10 +
      '        character_maximum_length,' + #13#10 +
      '        numeric_precision,' + #13#10 +
      '        numeric_scale,' + #13#10 +       
      '        numeric_precision_radix,' + #13#10 +
      '        column_default,' + #13#10 +
      '        is_nullable' + #13#10 +
      '   from information_schema.columns' + #13#10 +
      '  where lower(table_name) = lower(''' + AObjName + ''')';
    if ADbUser <> '' then
      S := S + #13#10 +
        '    and table_schema=''' + ADbUser + '''';

    S := S + #13#10 +
      '  order by ordinal_position';
    SQL.Text := S;
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
        Name := FieldByName('column_name').AsString;
        T := LowerCase(FieldByName('data_type').AsString);

        DataType := PostgreSql2CtFieldType(T);
        if DataType = cfdtUnknow then
        begin
          DataType := GetPossibleCtFieldTypeOfName(S);
          DataTypeName := S;
        end;
        if Pos('serial', LowerCase(S)) > 0 then
          DefaultValue := DEF_VAL_auto_increment;
        if Pos('[DBTYPENAMES]', AOpt) > 0 then
          DataTypeName := T;

        if FieldByName('is_nullable').AsString = 'NO' then
          Nullable := False
        else
          Nullable := True;

        DataLength := FieldByName('character_maximum_length').AsInteger;
        if DataLength = 0 then
        begin
          DataLength := FieldByName('numeric_precision').AsInteger;
          DataScale := FieldByName('numeric_scale').AsInteger;
          if (DataType = cfdtInteger) and (DataScale = 0)
            and (FieldByName('numeric_scale').AsInteger = 2) then
          begin
            if DataLength = 64 then
              DataLength := 20        
            else if DataLength = 16 then
              DataLength := 5
            else if DataLength > 32 then
              DataLength := 10
            else
              DataLength := 0;
          end;
        end;
        DefaultValue := FieldByName('column_default').AsString;
        po := Pos('::', DefaultValue);
        if po > 0 then
          DefaultValue := Copy(DefaultValue, 1, po - 1);
      end;
      Next;
    end;

    //主键
    if ADbUser <> '' then
      S := 'SELECT a.attname as field' + #13#10 +
        '  FROM pg_class c, pg_attribute a, pg_constraint p, pg_namespace n' + #13#10 +
        ' WHERE lower(c.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '   and a.attnum > 0' + #13#10 +
        '   and a.attrelid = c.oid' + #13#10 +
        '   and p.conrelid = c.oid' + #13#10 +
        '   and (a.attnum = p.conkey[0] or a.attnum = p.conkey[1] or a.attnum = p.conkey[2] '
        + #13#10 +
        '        or a.attnum = p.conkey[3] or a.attnum = p.conkey[4])' + #13#10 +
        '   and p.connamespace = n.oid' + #13#10 +
        '   and n.nspname = ''' + ADbUser + '''' + #13#10 +
        '   and p.contype = ''p''' + #13#10 +
        ''
    else
      S := 'SELECT a.attname as field' + #13#10 +
        '  FROM pg_class c, pg_attribute a, pg_constraint p' + #13#10 +
        ' WHERE lower(c.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '   and a.attnum > 0' + #13#10 +
        '   and a.attrelid = c.oid' + #13#10 +
        '   and p.conrelid = c.oid' + #13#10 +
        '   and (a.attnum = p.conkey[0] or a.attnum = p.conkey[1] or a.attnum = p.conkey[2] '
        + #13#10 +
        '        or a.attnum = p.conkey[3] or a.attnum = p.conkey[4])' + #13#10 +
        '   and p.contype = ''p''' + #13#10 +
        '';
    Close;
    SQL.Text := S;
    Open;
    while not EOF do
    begin
      S := FieldByName('field').AsString;
      f := o.MetaFields.FieldByName(S);
      if (f <> nil) then
      begin
        f.KeyFieldType := cfktId;
      end;
      Next;
    end;

    //外键
    if ADbUser <> '' then
      S := 'SELECT a.attname as field, rc.relname as reltable, ra.attname as relfield'
        + #13#10 +
        '  FROM pg_class c, pg_attribute a, pg_constraint p, pg_namespace n, pg_class rc, pg_attribute ra'
        + #13#10 +
        ' WHERE lower(c.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '   and a.attnum > 0' + #13#10 +
        '   and a.attrelid = c.oid' + #13#10 +
        '   and (a.attnum = p.conkey[0] or a.attnum = p.conkey[1] or a.attnum = p.conkey[2] '
        + #13#10 +
        '        or a.attnum = p.conkey[3] or a.attnum = p.conkey[4])' + #13#10 +
        '   and p.conrelid = c.oid' + #13#10 +
        '   and p.confrelid=rc.oid' + #13#10 +
        '   and ra.attnum > 0' + #13#10 +
        '   and ra.attrelid = rc.oid' + #13#10 +
        '   and (ra.attnum = p.confkey[0] or ra.attnum = p.confkey[1] or ra.attnum = p.confkey[2]'
        + #13#10 +
        '        or ra.attnum = p.confkey[3] or ra.attnum = p.confkey[4])' + #13#10 +
        '   and p.connamespace = n.oid' + #13#10 +
        '   and n.nspname = ''' + ADbUser + '''' + #13#10 +
        '   and p.contype = ''f''' + #13#10 +
        ''
    else
      S := 'SELECT a.attname as field, rc.relname as reltable, ra.attname as relfield'
        + #13#10 +
        '  FROM pg_class c, pg_attribute a, pg_constraint p, pg_class rc, pg_attribute ra'
        +
        #13#10 +
        ' WHERE lower(c.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '   and a.attnum > 0' + #13#10 +
        '   and a.attrelid = c.oid' + #13#10 +
        '   and (a.attnum = p.conkey[0] or a.attnum = p.conkey[1] or a.attnum = p.conkey[2] '
        + #13#10 +
        '        or a.attnum = p.conkey[3] or a.attnum = p.conkey[4])' + #13#10 +
        '   and p.conrelid = c.oid' + #13#10 +
        '   and p.confrelid=rc.oid' + #13#10 +
        '   and ra.attnum > 0' + #13#10 +
        '   and ra.attrelid = rc.oid' + #13#10 +
        '   and (ra.attnum = p.confkey[0] or ra.attnum = p.confkey[1] or ra.attnum = p.confkey[2]'
        + #13#10 +
        '        or ra.attnum = p.confkey[3] or ra.attnum = p.confkey[4])' + #13#10 +
        '   and p.contype = ''f''' + #13#10 +
        '';
    Close;
    SQL.Text := S;
    Open;
    while not EOF do
    begin
      S := FieldByName('field').AsString;
      f := o.MetaFields.FieldByName(S);
      if (f <> nil) then
      begin
        if f.KeyFieldType <> cfktId then
          f.KeyFieldType := cfktRid;
        f.RelateTable := FieldByName('reltable').AsString;
        f.RelateField := FieldByName('relfield').AsString;
      end;
      Next;
    end;

    //索引  
    L := 0;
    SetLength(idxNames, L);
    SetLength(idxUniqs, L);
    SetLength(idxCols, L);

    if ADbUser <> '' then
      S := 'select' + #13#10 +
        '    i.relname as index_name,' + #13#10 +
        '    a.attname as column_name,' + #13#10 +
        '    ix.indisunique' + #13#10 +
        'from' + #13#10 +
        '    pg_class t,' + #13#10 +
        '    pg_class i,' + #13#10 +
        '    pg_index ix,' + #13#10 +
        '    pg_attribute a,' + #13#10 +
        '    pg_namespace n' + #13#10 +
        'where' + #13#10 +
        '    t.oid = ix.indrelid' + #13#10 +
        '    and i.oid = ix.indexrelid' + #13#10 +
        '    and a.attrelid = t.oid' + #13#10 +
        '    and a.attnum = ANY(ix.indkey)' + #13#10 +
        '    and t.relkind = ''r''' + #13#10 +
        '    and lower(t.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '    and t.relnamespace = n.oid' + #13#10 +
        '    and n.nspname=''' + ADbUser + '''' + #13#10 +
        'order by' + #13#10 +
        '    i.relname, a.attnum'
    else
      S := 'select' + #13#10 +
        '    i.relname as index_name,' + #13#10 +
        '    a.attname as column_name,' + #13#10 +
        '    ix.indisunique' + #13#10 +
        'from' + #13#10 +
        '    pg_class t,' + #13#10 +
        '    pg_class i,' + #13#10 +
        '    pg_index ix,' + #13#10 +
        '    pg_attribute a' + #13#10 +
        'where' + #13#10 +
        '    t.oid = ix.indrelid' + #13#10 +
        '    and i.oid = ix.indexrelid' + #13#10 +
        '    and a.attrelid = t.oid' + #13#10 +
        '    and a.attnum = ANY(ix.indkey)' + #13#10 +
        '    and t.relkind = ''r''' + #13#10 +
        '    and lower(t.relname) = lower(''' + AObjName + ''')' + #13#10 +
        'order by' + #13#10 +
        '    i.relname, a.attnum';

    Close;
    SQL.Text := S;
    Open;
    while not EOF do
    begin
      Inc(L);
      SetLength(idxNames, L);
      SetLength(idxUniqs, L);
      SetLength(idxCols, L);
      idxNames[L - 1] := FieldByName('index_name').AsString;
      idxCols[L - 1] := FieldByName('column_name').AsString;
      idxUniqs[L - 1] := FieldByName('indisunique').AsString = 't';
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


    { 表注释 }
    if ADbUser <> '' then
      S := 'select col_description(c.oid, 0) as comments' + #13#10 +
        '  from pg_class c, pg_namespace n' + #13#10 +
        ' where lower(c.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '   and c.relnamespace = n.oid' + #13#10 +
        '   and n.nspname = ''' + ADbUser + '''' + #13#10 +
        ''
    else
      S := 'select col_description(c.oid, 0) as comments' + #13#10 +
        '  from pg_class c' + #13#10 +
        ' where lower(c.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '';
    Close;
    Sql.Text := S;
    Open;
    if not EOF then
      o.Memo := Fields[0].AsString;

    //字段注释
    if ADbUser <> '' then
      S := 'select a.attname as field, col_description(c.oid, a.attnum) as comments'
        + #13#10 +
        '  from pg_class c, pg_attribute a, pg_namespace n' + #13#10 +
        ' where lower(c.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '   and c.relnamespace = n.oid' + #13#10 +
        '   and n.nspname = ''' + ADbUser + '''' + #13#10 +
        '   and a.attrelid = c.oid' + #13#10 +
        '   and a.attnum > 0' + #13#10 +
        ''
    else
      S := 'select a.attname as field, col_description(c.oid, a.attnum) as comments'
        + #13#10 +
        '  from pg_class c, pg_attribute a' + #13#10 +
        ' where lower(c.relname) = lower(''' + AObjName + ''')' + #13#10 +
        '   and a.attrelid = c.oid' + #13#10 +
        '   and a.attnum > 0' + #13#10 +
        '';
    Close;
    SQL.Text := S;
    Open;
    while not EOF do
    begin
      S := FieldByName('field').AsString;
      f := o.MetaFields.FieldByName(S);
      if f <> nil then
      begin
        f.Memo := FieldByName('comments').AsString;
      end;
      Next;
    end;
  end;
end;

function TCtMetaPostgreSqlDb.ObjectExists(ADbUser, AObjName: string): boolean;
var
  po: integer;
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
    sql.Text := 'SELECT count(*) as CC FROM pg_tables where lower(tablename)=lower(''' +
      AObjName + ''')';
    if ADbUser <> '' then
      sql.Text := sql.Text + ' and schemaname=''' + ADbUser + '''';

    Open;
    if not EOF then
      Result := Fields[0].AsInteger > 0;

    if not Result then
    begin
      Clear;
      sql.Text := 'SELECT count(*) as CC FROM pg_indexes where lower(indexname)=lower('''
        + AObjName + ''')';
      if ADbUser <> '' then
        sql.Text := sql.Text + ' and schemaname=''' + ADbUser + '''';

      Open;
      if not EOF then
        Result := Fields[0].AsInteger > 0;
    end;
  end;
end;


initialization
  AddCtMetaDBReg('POSTGRESQL', TCtMetaPostgreSqlDb);

end.
