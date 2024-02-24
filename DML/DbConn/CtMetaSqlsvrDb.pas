unit CtMetaSqlsvrDb;

interface

uses
  LCLIntf, LCLType, LMessages, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  IniFiles, CtMetaData, CtMetaTable, CtMetaFCLSqlDb, mssqlconn, odbcconn, DB, sqlDb;

type

  { TCtMetaSqlsvrDb }

  TCtMetaSqlsvrDb = class(TCtMetaFCLSqlDb)
  private
    FSqlsvrType: integer; //0-Unknown 1-Sqlsvr2000 2-Sqlsvr2005
    FTempSS: TStrings;
  protected
    function CreateSqlDbConn: TSQLConnection; override;
    procedure SetConnected(const Value: boolean); override;
    function GetDbSchema: string; override;
    procedure SetDbSchema(const Value: string); override;
    procedure SetFCLConnDatabase; override;
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

uses
  wSqlServerDBConfig, Dialogs, Forms, dmlstrs, WindowFuncs;

{ TCtMetaSqlsvrDb }


function TCtMetaSqlsvrDb.CreateSqlDbConn: TSQLConnection;
begin                
  if (Pos('DSN:', DataBase) = 1) or (Pos('ODBC:', DataBase) = 1) then
    FUseDriverType := 'ODBC'
  else
    FUseDriverType := '';
  if FUseDriverType='ODBC' then
  begin
    Result := TODBCConnection.Create(nil);
    Result.CharSet := Trim(G_OdbcCharset);
    if Pos('[GSQL_FIELD_NULL]', FExtraOpt) > 0 then
      FExtraOpt := StringReplace(FExtraOpt, '[GSQL_FIELD_NULL]', '', []);
  end
  else
  begin
    Result := TMSSQLConnection.Create(nil);
    if Pos('[GSQL_FIELD_NULL]', FExtraOpt) = 0 then
      FExtraOpt := FExtraOpt + '[GSQL_FIELD_NULL]';
  end;
end;

procedure TCtMetaSqlsvrDb.SetConnected(const Value: boolean);
begin
  if FConnected = Value then
    Exit;
  inherited SetConnected(Value);
  if FConnected then
  begin
    FSqlsvrType := 0;
    with FQuery do
    begin
      Clear;
      SQL.Text := 'select count(*) from sysobjects where name = ''sysproperties''';
      Open;
      if not EOF then
      begin
        if Fields[0].AsInteger = 0 then
          FSqlsvrType := 2
        else
          FSqlsvrType := 1;
      end;
    end;
    with FQuery do
    begin
      Clear;
      Sql.Text := 'SELECT SCHEMA_NAME()';

      Open;
      FDbSchema :=Fields[0].AsString;
      if FDbSchema='' then
        FDbSchema := 'dbo';
    end;
  end;
end;

function TCtMetaSqlsvrDb.GetDbSchema: string;
begin
  if FDbSchema = '' then
    Result := 'dbo'
  else
    Result := FDbSchema;
end;

procedure TCtMetaSqlsvrDb.SetDbSchema(const Value: string);
var
  S: String;
begin               
  if FDbSchema = Value then
    Exit;

  inherited SetDbSchema(Value);  
  S := FDbConn.Params.Values['Database'];
  if S <> '' then
    ExecSql('use ' + GetDbQuotName(S, Self.EngineType));
end;

procedure TCtMetaSqlsvrDb.SetFCLConnDatabase;
var
  S, db, ip: string;
  po: integer;
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
  end
  else
  begin
    S := FDbConn.HostName;
    if Pos(':', S) = 0 then
      if Pos(',', S) > 0 then
        FDbConn.HostName := StringReplace(S, ',', ':', []);
  end;
end;



constructor TCtMetaSqlsvrDb.Create;
begin
  inherited;
  FEngineType := 'SQLSERVER';
  FTempSS := TStringList.Create;
end;

destructor TCtMetaSqlsvrDb.Destroy;
begin
  FTempSS.Free;
  inherited;
end;

function TCtMetaSqlsvrDb.ShowDBConfig(AHandle: THandle): boolean;
var
  S: string;
begin
  S := TfrmSqlSvrDBConfig.DoDbConfig(Database);
  if S <> '' then
  begin
    Database := S;
    Result := True;
  end
  else
    Result := False;
end;

function TCtMetaSqlsvrDb.GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string;
begin
  Result := inherited GenObjSql(obj, obj_db, sqlType);
end;

function TCtMetaSqlsvrDb.GetDbNames: string;
begin
  Result := 'localhost\MSSQLSERVER@master'#10'192.168.1.123:1433\MSSQLSERVER@master';
  Result := Result + #10'DSN:User_or_System_DSN_Name'#10'ODBC:Driver=SQL Server;Server=MyDbServer,Port\SID;Database=pubs;Integrated Security=SSPI;';
end;

function TCtMetaSqlsvrDb.GetDbObjs(ADbUser: string): TStrings;
var
  S: string;
begin
  CheckConnected;
  Result := FTempSS;
  Result.Clear;
  with FQuery do
  begin
    Clear;
    S := 'SELECT TABLE_NAME, TABLE_SCHEMA FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = ''BASE TABLE''';
    if ADbUser = '' then
      ADbUser := Self.FDbSchema;
    if ADbUser <> '' then
      S := S + ' AND TABLE_SCHEMA=''' + ADbUser + '''';
    S := S + ' ORDER BY TABLE_SCHEMA, TABLE_NAME';
    Sql.Text := S;

    Open;
    while not EOF do
    begin
      if ADbUser = '' then
        Result.Add(CtTrim(Fields[1].AsString) + '.' + CtTrim(Fields[0].AsString))
      else
        Result.Add(CtTrim(Fields[0].AsString));
      Next;
    end;
  end;
end;

function TCtMetaSqlsvrDb.GetDbUsers: string;
begin
  Result := '';
  with FQuery do
  begin
    Clear;
    if FSqlsvrType >= 2 then
      Sql.Text := 'SELECT name FROM sys.schemas ORDER BY name'
    else
      Sql.Text := 'SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA ORDER BY SCHEMA_NAME';
    Open;
    while not EOF do
    begin
      if Result = '' then
        Result := CtTrim(Fields[0].AsString)
      else
        Result := Result + #13#10 + CtTrim(Fields[0].AsString);
      Next;
    end;
  end;
end;



function TCtMetaSqlsvrDb.GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject;

  function TrimDefQuots(def: string): string;
  var
    L: integer;
  begin
    Result := def;
    while True do
    begin
      L := Length(Result);
      if L < 3 then
        Break;
      if (Result[1] = '(') and (Result[L] = ')') then
        Result := Copy(Result, 2, L - 2)
      else
        Break;
    end;
  end;

var
  o: TCtMetaTable;
  f: TCtMetaField;
  S, T, oid: string;
begin
  (*if FSqlsvrType = 0 then
  begin
    Result := inherited GetObjInfos(ADbUser, AObjName, AOpt);
    Exit;
  end;      *)
  Result := nil;

  if ADbUser = '' then
    ADbUser := Self.FDbSchema;


  with FQueryB do
  begin
    Clear;
    Sql.Text := 'select object_id(''' +ADbUser+'.'+ AObjName + ''')';
    Open;
    if EOF then
      Exit;
    if Fields[0].IsNull then
      Exit;
    oid := CtTrim(Fields[0].AsString);
  end;
  if Trim(oid)= '' then
    Exit;

  with FQueryB do
  begin
    { 字段信息 }
    Clear;
    if FSqlsvrType >= 2 then
      SQL.Text :=
        'select t.name, a.name datatype, t.isnullable, b.text defaultval, cast(c.[value] as varchar(1023)) comments, t.length, t.prec, t.scale, COLUMNPROPERTY(t.id,t.name,''IsIdentity'') IsIdentity ' + 'from syscolumns t left outer join systypes a on a.xusertype = t.xusertype ' + 'left join syscomments b on b.id = t.cdefault ' + 'left join sys.extended_properties c on c.major_id = t.id and c.minor_id = t.colid and c.name=''MS_Description'' ' + 'where t.id = ''' + oid + ''' order by t.colid'
    else
      SQL.Text :=
        'select t.name, a.name datatype, t.isnullable, b.text defaultval, cast(c.[value] as varchar(1023)) comments, t.length, t.prec, t.scale, COLUMNPROPERTY(t.id,t.name,''IsIdentity'') IsIdentity ' + 'from dbo.syscolumns t left outer join dbo.systypes a on a.xusertype = t.xusertype ' + 'left join dbo.syscomments b on b.id = t.cdefault ' + 'left join dbo.sysproperties c on c.id=t.id AND t.colid = c.smallid and c.name=''MS_Description'' ' + 'where t.id = ''' + oid + '''order by t.colid';
    try
      Open;
    except
      on E: Exception do
      begin
        if Pos(UpperCase('sys.extended_properties'), UpperCase(E.Message)) > 0 then
        begin
          Close;
          SQL.Text :=
            'select t.name, a.name datatype, t.isnullable, b.text defaultval, cast(c.[value] as varchar(1023)) comments, t.length,  t.prec, t.scale, COLUMNPROPERTY(t.id,t.name,''IsIdentity'') IsIdentity ' + 'from dbo.syscolumns t left outer join dbo.systypes a on a.xusertype = t.xusertype ' + 'left join dbo.syscomments b on b.id = t.cdefault ' + 'left join dbo.sysproperties c on c.id=t.id AND t.colid = c.smallid and c.name=''MS_Description'' ' + 'where t.id = ''' + oid + '''order by t.colid';
          Open;
        end
        else
          raise;
      end;
    end;

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
        Name := CtTrim(Fields[0].AsString);
        T := LowerCase(CtTrim(Fields[1].AsString));
        if (T = 'char') or (T = 'varchar') or (T = 'nchar') or (T = 'nvarchar') then
        begin
          DataType := cfdtString;
          DataLength := Fields[5].AsInteger;
          if (T = 'nchar') or (T = 'nvarchar') then
            DataLength := DataLength div 2;
        end
        else if (T = 'text') or (T = 'ntext') then
        begin
          DataType := cfdtString;
          DataLength := DEF_TEXT_CLOB_LEN;
        end
        else if (T = 'bigint') or (T = 'int') or (T = 'smallint') then
        begin
          DataType := cfdtInteger;
          if Fields[8].AsInteger = 1 then
            DefaultValue := DEF_VAL_auto_increment;
        end
        else if (T = 'decimal') or (T = 'numeric') then
        begin
          if Fields[7].AsInteger = 0 then
          begin
            DataType := cfdtInteger;
            DataLength := Fields[6].AsInteger;
            if DataLength <= 2 then
            begin
              DataType := cfdtEnum;
              DataLength := 0;
            end;
            if Fields[8].AsInteger = 1 then
              DefaultValue := DEF_VAL_auto_increment;
          end
          else
          begin
            DataType := cfdtFloat;
            DataLength := Fields[6].AsInteger;
            DataScale := Fields[7].AsInteger;
          end;
        end
        else if (T = 'float') or (T = 'real') or (T = 'money') or (T = 'smallmoney') then
        begin
          DataType := cfdtFloat;
        end
        else if (T = 'datetime') or (T = 'smalldatetime') then
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
        end
        else if (T = 'binary') or (T = 'varbinary') or (T = 'image') then
        begin
          DataType := cfdtBlob;
        end
        else
        begin
          DataType := GetPossibleCtFieldTypeOfName(T);
          DataTypeName := CtTrim(Fields[1].AsString);
        end;
        if (Pos('[DBTYPENAMES]', AOpt) > 0) then
          DataTypeName := CtTrim(Fields[1].AsString);

        if not Fields[3].IsNull then
        begin
          DefaultValue := TrimDefQuots(CtTrim(Fields[3].AsString));
        end;
        if Fields[2].AsInteger <> 1 then
          Nullable := False;

        if not Fields[4].IsNull then
          Memo := CtTrim(Fields[4].AsString);
      end;
      Next;
    end;

    { 表注释 }
    Close;
    Sql.Text := 'select cast(value as varchar(2047)) as tbmemo from ::fn_listextendedproperty(''MS_Description'', ''user'', '''
      + ADbUser + ''', ''table'', ''' + AObjName + ''', null,null)';
    try
      Open;
    except
    end;
    if not EOF then
      o.Memo := CtTrim(Fields[0].AsString);

    { 主键信息 }
    Close;
    SQL.Text :=
      'EXEC sp_pkeys @table_name = N''' + AObjName + ''', @table_owner = N''' + ADbUser + '''';
    try
      Open;
    except
    end;
    while not EOF do
    begin
      S := CtTrim(FieldByName('COLUMN_NAME').AsString);
      f := o.MetaFields.FieldByName(S);
      if f <> nil then
        f.KeyFieldType := cfktId;
      Next;
    end;

    { 外键信息 }
    Close;
    SQL.Text := 'EXEC sp_fkeys @fktable_name = N''' + AObjName + ''', @fktable_owner = N''' + ADbUser + '''';
    try
      Open;
    except
    end;
    while not EOF do
    begin
      S := CtTrim(FieldByName('FKCOLUMN_NAME').AsString);
      f := o.MetaFields.FieldByName(S);
      if f <> nil then
      begin
        if f.KeyFieldType <> cfktId then
          f.KeyFieldType := cfktRid;
        f.RelateTable := CtTrim(FieldByName('PKTABLE_NAME').AsString);
        f.RelateField := CtTrim(FieldByName('PKCOLUMN_NAME').AsString);
      end;
      Next;
    end;

    { 索引信息 }
    Close;
    SQL.Text := 'exec sp_helpindex @objname = N''' + ADbUser + '.'+ AObjName + '''';
    try
      Open;
    except
    end;
    while not EOF do
    begin
      S := CtTrim(Fields[2].AsString);
      if (Pos(',', S) = 0) and (Pos('(', S) = 0) then
      begin
        f := o.MetaFields.FieldByName(S);
        if f <> nil then
          if f.KeyFieldType <> cfktId then
            //if Pos('PRIMARY KEY', UpperCase(S)) = 0 then
          begin
            S := CtTrim(Fields[1].AsString);
            if Pos('UNIQUE', UpperCase(S)) > 0 then
              f.IndexType := cfitUnique
            else
              f.IndexType := cfitNormal;
          end;
      end
      else
      begin
        f := o.MetaFields.NewMetaField;
        f.Name := RemoveIdxNamePrefx(CtTrim(Fields[0].AsString), o.Name);
        f.DataType := cfdtFunction;
        if Pos('UNIQUE', UpperCase(CtTrim(Fields[1].AsString))) > 0 then
          f.IndexType := cfitUnique
        else
          f.IndexType := cfitNormal;
        while Pos(', ', S) > 0 do
          S := StringReplace(S, ', ', ',', [rfReplaceAll]);
        f.IndexFields := S;

        f.Memo := S;
        T := GetIdxName(o.Name, f.Name);
        if f.IndexType = cfitUnique then
          T := 'IDU_' + T
        else
          T := 'IDX_' + T;
        if LowerCase(CtTrim(Fields[0].AsString)) <> LowerCase(T) then
          f.Memo := f.Memo + ' [DB_INDEX_NAME:' + Fields[0].AsString + ']';
      end;
      Next;
    end;

    { 缺省约束信息 }
    Close;
    SQL.Text := 'select t.name as dfname, c.name as colname' + #13#10 +
      '  from sys.default_constraints t, sys.columns c' + #13#10 +
      ' where t.parent_object_id = ''' + oid +
      '''' + #13#10 + '   and c.column_id = t.parent_column_id' +
      #13#10 + '   and c.object_id = t.parent_object_id' + #13#10 + '';
    try
      Open;
    except
    end;
    while not EOF do
    begin
      f := o.MetaFields.FieldByName(CtTrim(Fields[1].AsString));
      if f <> nil then
        f.Param['SQLSERVER_DF_CONSTRAINT_NAME'] := CtTrim(Fields[0].AsString);
      Next;
    end;
  end;
end;

function TCtMetaSqlsvrDb.ObjectExists(ADbUser, AObjName: string): boolean;
var
  S: string;
begin
  Result := False;
  CheckConnected;

  S := AObjName;  
  if ADbUser = '' then
    ADbUser := Self.FDbSchema;
  if ADbUser <> '' then
    S := ADbUser + '.' + S;

  with FQuery do
  begin
    Clear;
    Sql.Text := 'select object_id(''' + S + ''')';
    Open;
    if not EOF then
      Result := CtTrim(Fields[0].AsString) <> '';
  end;
end;


initialization
  AddCtMetaDBReg('SQLSERVER', TCtMetaSqlsvrDb);

end.
