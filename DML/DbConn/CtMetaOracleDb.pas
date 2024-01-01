unit CtMetaOracleDb;

interface

uses
  LCLIntf, LCLType, LMessages, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  IniFiles, CtMetaData, CtMetaTable, CtMetaFCLSqlDb, OracleConnection, DB, sqlDb;

type

  { TCtMetaOracleDb }

  TCtMetaOracleDb = class(TCtMetaFCLSqlDb)
  private
    FTempSS: TStrings;
  protected
    function CreateSqlDbConn: TSQLConnection; override;
    procedure SetConnected(const Value: boolean); override;       
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
    function ExecCmd(ACmd, AParam1, AParam2: string): string; override;
    function ObjectExists(ADbUser, AObjName: string): boolean; override;

  end;

var
  G_OracleNlsLang: string='';

implementation

uses wOracleDBConfig, Forms, WindowFuncs;

{ TCtMetaOracleDb }


function TCtMetaOracleDb.CreateSqlDbConn: TSQLConnection;
begin
  Result := TOracleConnection.Create(nil);
end;

procedure TCtMetaOracleDb.SetConnected(const Value: boolean);
var
  S: string;
  po: integer;
begin
  if FConnected = Value then
    Exit;
  if Value then
    if G_OracleNlsLang <> '' then
    begin
      if Pos('GBK', G_OracleNlsLang)>0 then    
        FDbConn.CharSet := 'GBK';
    end;
  inherited SetConnected(Value);

  if FConnected then
  begin
    with FQuery do
    try
      Clear;
      SQL.Text := 'select userenv(''language'') from dual';
      Open;
      if not EOF then
      begin
        S := Fields[0].AsString;
        po := Pos('.', S);
        if po > 0 then
          S := Copy(S, po + 1, Length(S));
        if Pos('GBK', S) > 0 then
          FDbConn.CharSet := 'GBK';
      end;
    except
    end;
  end;
end;

procedure TCtMetaOracleDb.SetFCLConnDatabase; 
var
  S: string;
begin
  if FDbConn=nil then
    Exit;
  inherited SetFCLConnDatabase;
  if FDbConn.DatabaseName = '' then
  begin
    S := FDbConn.HostName;
    if S <> '' then
    begin
      FDbConn.DatabaseName := S;
      FDbConn.HostName := '';
    end;
  //po: integer;
    //po := Pos('/', S);
    //if po > 0 then
    //begin
    //  FDbConn.DatabaseName := Copy(S, po + 1, Length(S));
    //end
    //else
    //begin
    //  FDbConn.DatabaseName := S;
    //end;
  end;
end;

constructor TCtMetaOracleDb.Create;
begin
  inherited;
  FEngineType := 'ORACLE';
  FTempSS := TStringList.Create;
end;

destructor TCtMetaOracleDb.Destroy;
begin
  FTempSS.Free;
  inherited;
end;

function TCtMetaOracleDb.ExecCmd(ACmd, AParam1, AParam2: string): string;
var
  S: string;
begin
  Result:=inherited ExecCmd(ACmd, AParam1, AParam2);
  if Result <> '' then
    Exit;
  Result := '';
  if (ACmd = 'DISABLE_CONSTRAINTS') or (ACmd = 'ENABLE_CONSTRAINTS') then
  begin      
    CheckConnected;
    if AParam1 = '' then
      Exit;
    with FQuery do
    begin
      Clear;
      SQL.Text :=
        'select c1.constraint_name, c.column_name' + #13#10 +
        'from sys.all_constraints c1,' + #13#10 + '     sys.all_constraints c2,' +
        #13#10 + '     sys.all_cons_columns c' + #13#10 +
        'where c1.table_name = upper(:v_tbn)' + #13#10 +
        'and c1.owner = user' + #13#10 + 'and c1.constraint_type = ''R''' +
        #13#10 + 'and c2.owner = c1.r_owner' + #13#10 +
        'and c2.constraint_name = c1.r_constraint_name' + #13#10 +
        'and c2.constraint_type in (''P'', ''U'')' + #13#10 +
        'and c.owner=c1.owner' + #13#10 +
        'and c.constraint_name=c1.constraint_name' + #13#10 +
        'order by c2.table_name, c1.constraint_name';

      Params.ParamByName('v_tbn').AsString := AParam1;
      Open;
      while not EOF do
      begin
        S := CtTrim(Fields[0].AsString);
        if Result <> '' then
          Result := Result + ',';
        Result := Result + CtTrim(Fields[1].AsString) + '(' + S + ')';
        with FQueryB do
        begin
          Clear;
          if ACmd = 'ENABLE_CONSTRAINTS' then
            SQL.Text := 'ALTER TABLE ' + AParam1 + ' ENABLE CONSTRAINT ' + S
          else
            SQL.Text := 'ALTER TABLE ' + AParam1 + ' DISABLE CONSTRAINT ' + S;
          ExecSql;
        end;
        Next;
      end;
    end;
    if Result = '' then
      Result := 'No constraint found'
    else if ACmd = 'ENABLE_CONSTRAINTS' then
      Result := 'Constraints enabled: ' + Result
    else
      Result := 'Constraints disabled: ' + Result;
    Exit;
  end;
end;


function TCtMetaOracleDb.GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string;
var
  tb, key: string;
  kval, seqval: integer;
begin
  Result := inherited GenObjSql(obj, obj_db, sqlType);
  if not TCtMetaTable(obj).IsTable then
    Exit;
  CheckConnected;
  if (sqlType = 0) or (sqlType = 1) then
    if G_CreateSeqForOracle and (obj_db <> nil) and (obj_db is TCtMetaTable) and
      (TCtMetaTable(obj_db).KeyFieldName <> '') then
    begin
      tb := UpperCase(TCtMetaTable(obj_db).Name);
      key := TCtMetaTable(obj_db).KeyFieldName;
      with FQuery do
        try
          Clear;
          Sql.Text := 'select max(' + key + ') from ' + tb;
          Open;
          if not EOF then
            kval := Fields[0].AsInteger
          else
            kval := 0;

          Clear;
          SQL.Text :=
            'select last_number from user_sequences where sequence_name = :v_seqn';
          Params.ParamByName('v_seqn').AsString := 'SEQ_' + tb;
          Open;
          if not EOF then
            seqval := Fields[0].AsInteger
          else
          begin
            seqval := 0;
            //Result := Result + 'create sequence SEQ_' + tb + ';'+#13#10;
          end;

          if (kval > 0) and (seqval > 0) then
            if seqval < kval then
            begin
              Result := Result + '--     sequence change: SEQ_' + tb + #13#10;
              Result := Result + 'alter  sequence SEQ_' + tb +
                ' increment by ' + IntToStr(kval - seqval + 1) + ' nocache;' + #13#10;
              Result := Result + 'select SEQ_' + tb + '.nextval from dual;' + #13#10;
              Result := Result + 'alter  sequence SEQ_' + tb +
                ' increment by 1 nocache;' + #13#10;
              Result := Result + 'declare' + #13#10;
              Result := Result + '  LastValue integer;' + #13#10;
              Result := Result + 'begin' + #13#10;
              Result := Result + '  loop' + #13#10;
              Result := Result + '    select SEQ_' + tb +
                '.currval into LastValue from dual;' + #13#10;
              Result := Result + '    exit when LastValue >= ' +
                IntToStr(kval + 1) + ' - 1;' + #13#10;
              Result := Result + '    select SEQ_' + tb +
                '.nextval into LastValue from dual;' + #13#10;
              Result := Result + '  end loop;' + #13#10;
              Result := Result + 'end;' + #13#10;
              Result := Result + '/' + #13#10;
              Result := Result + 'alter  sequence SEQ_' + tb +
                ' increment by 1 cache 20;' + #13#10;
              Result := Result + '--     ' + #13#10;
            end;
        except
        end;
    end;
end;

function TCtMetaOracleDb.GetDbNames: string;
begin
  Result := 'ORCL'#13#10'127.0.0.1:1521/ORCL';
end;

function TCtMetaOracleDb.GetDbObjs(ADbUser: string): TStrings;
begin
  CheckConnected;
  Result := FTempSS;
  Result.Clear;
  with FQuery do
  begin
    Clear;
    Sql.Text :=
      'select t.owner,t.table_name from all_tables t where (:OW is null or t.owner=:OW) and t.table_name not like ''%$%'' order by t.owner, t.table_name';

    ADBUser := UpperCase(ADBUser);
    Params.ParamByName('OW').AsString := ADBUser;
    Open;
    while not EOF do
    begin
      if (ADBUser = '') then
        Result.Add(CtTrim(Fields[0].AsString) + '.' + CtTrim(Fields[1].AsString))
      else
        Result.Add(CtTrim(Fields[1].AsString));
      Next;
    end;
  end;
end;

function TCtMetaOracleDb.GetDbUsers: string;
begin
  Result := '';
  CheckConnected;
  with FQuery do
  begin
    Clear;
    Sql.Text := 'select username from all_users order by username';
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

function TCtMetaOracleDb.GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject;

  function CheckNameCap(AName: string): string;
  begin
    Result := AName;
    {if UpperCase(AName) = AName then
      if LowerCase(AName) <> AName then
      begin
        Result := Copy(AName, 1, 1) + LowerCase(Copy(AName, 2, Length(AName)));
      end; }
  end;

var
  po: integer;
  o: TCtMetaTable;
  f: TCtMetaField;
  S, T, vObjName: string;
begin
  Result := nil;
  CheckConnected;
  po := Pos('.', AObjName);
  if po > 0 then
  begin
    ADbUser := Copy(AObjName, 1, po - 1);
    AObjName := Copy(AObjName, po + 1, Length(AObjName));
  end;
  if ADBUser = '' then
    ADBUser := UpperCase(DbConn.Username);
  ADBUser := UpperCase(ADBUser);
  vObjName := UpperCase(AObjName);

  CheckConnected;
  with FQuery do
  begin
    Clear;
    if ADbUser = '' then
    begin
      Sql.Text :=
        'select t.column_name,' + #13#10 + '       t.data_type,' +
        #13#10 + '       t.DATA_LENGTH,' + #13#10 + '       t.data_type_owner,' +
        #13#10 + '       t.data_precision,' + #13#10 +
        '       t.data_scale,' + #13#10 + '       t.CHAR_COL_DECL_LENGTH,' +
        #13#10 + '       t.nullable,' + #13#10 + '       t.data_default,' +
        #13#10 + '       (select c.comments' + #13#10 +
        '          from user_col_comments c' + #13#10 +
        '         where c.table_name = t.table_name' + #13#10 +
        '           and c.column_name = t.column_name) comments' +
        #13#10 + '  from user_tab_cols t' + #13#10 +
        ' where upper(t.table_name) =:TBN' + #13#10 + ' order by column_id';
      Params.ParamByName('TBN').AsString := vObjName;
    end
    else
    begin
      Sql.Text := 'select t.column_name,' + #13#10 + '       t.data_type,' +
        #13#10 + '       t.DATA_LENGTH,' + #13#10 + '       t.data_type_owner,' +
        #13#10 + '       t.data_precision,' + #13#10 +
        '       t.data_scale,' + #13#10 + '       t.CHAR_COL_DECL_LENGTH,' +
        #13#10 + '       t.data_default,' + #13#10 + '       t.nullable,' +
        #13#10 + '       (select c.comments' + #13#10 +
        '          from all_col_comments c' + #13#10 +
        '         where c.owner = t.owner' + #13#10 +
        '           and c.table_name = t.table_name' + #13#10 +
        '           and c.column_name = t.column_name) comments' +
        #13#10 + '  from all_tab_cols t' + #13#10 +
        ' where t.owner=:OW and upper(t.table_name) =:TBN' + #13#10 +
        ' order by column_id';
      Params.ParamByName('OW').AsString := ADBUser;
      Params.ParamByName('TBN').AsString := vObjName;
    end;
    Open;
    if EOF then
      Exit;
    o := TCtMetaTable.Create;
    Result := o;
    Result.Name := CheckNameCap(AObjName);
    while not EOF do
    begin
      with o.MetaFields.NewMetaField do
      begin
        Name := CheckNameCap(CtTrim(FieldByName('column_name').AsString));
        Memo := CtTrim(FieldByName('comments').AsString);
        DefaultValue := CtTrim(FieldByName('data_default').AsString);
        Nullable := CtTrim(FieldByName('nullable').AsString) = 'Y';
        S := CtTrim(FieldByName('data_type').AsString);
        if (S = 'VARCHAR2') or (S = 'NVARCHAR2') or (S = 'CHAR') or
          (S = 'NCHAR') then
        begin
          DataType := cfdtString;
          //if (S = 'NVARCHAR2') or (S = 'NCHAR') then
          //DataTypeName := S;
          DataLength := FieldByName('CHAR_COL_DECL_LENGTH').AsInteger;
        end
        else if (S = 'LONG') or (S = 'CLOB') or (S = 'NCLOB') or
          (S = 'RAW') or (S = 'LONG RAW') then
        begin
          DataType := cfdtString;
          DataLength := DEF_TEXT_CLOB_LEN;
        end
        else if S = 'FLOAT' then
        begin
          DataType := cfdtFloat;
        end
        else if S = 'NUMBER' then
        begin
          {if (Name = 'ID') or (Name = o.Name + '编号') or (Name = o.Name + 'ID') then
            KeyFieldType := cfktId
          else if (Name = 'RID') then
            KeyFieldType := cfktRid
          else }
          T := CtTrim(FieldByName('DATA_SCALE').AsString);
          if T = '0' then
          begin
            T := CtTrim(FieldByName('data_precision').AsString);
            if T = '1' then
            begin
              DataType := cfdtEnum;
              DataLength := 1;
            end
            else if T = '2' then
              DataType := cfdtEnum
            else
            begin
              if (T <> '') then
                DataLength := StrToIntDef(T, 0);
              if DataLength = 10 then
                if Pos('[DBTYPENAMES]', AOpt) = 0 then
                  DataLength := 0;
              DataType := cfdtInteger;
            end;
          end
          else
          begin
            DataScale := StrToIntDef(T, 0);
            T := CtTrim(FieldByName('data_precision').AsString);
            if (T <> '') then
              DataLength := StrToIntDef(T, 0);
            DataType := cfdtFloat;
          end;
        end
        else if S = 'DATE' then
          DataType := cfdtDate
        else if Pos('TIMESTAMP', S) = 1 then
        begin
          DataType := cfdtDate;
          DataTypeName := 'TIMESTAMP';
          DataLength := FieldByName('DATA_SCALE').AsInteger;
          if DataLength = 6 then
            DataLength := 0;
        end
        else if S = 'BOOLEAN' then
          DataType := cfdtBool
        else if (S = 'BLOB') or (S = 'BFILE') then
          DataType := cfdtBlob
        else
        begin
          DataType := GetPossibleCtFieldTypeOfName(S);
          DataTypeName := S;
        end;
        if Pos('[DBTYPENAMES]', AOpt) > 0 then
          DataTypeName := S;
      end;
      Next;
    end;

    Clear;
    if ADbUser = '' then
    begin
      Sql.Text :=
        'select t.comments' + #13#10 + '  from user_tab_comments t' +
        #13#10 + ' where upper(t.table_name) =:TBN';
      Params.ParamByName('TBN').AsString := vObjName;
    end
    else
    begin
      Sql.Text :=
        'select t.comments' + #13#10 + '  from all_tab_comments t' +
        #13#10 + ' where t.owner=:OW and upper(t.table_name) =:TBN';
      Params.ParamByName('OW').AsString := ADBUser;
      Params.ParamByName('TBN').AsString := vObjName;
    end;
    Open;
    if not EOF then
    begin
      o.Memo := CtTrim(Fields[0].AsString);
    end;

    Clear;
    SQL.Text :=
      'select t.r_constraint_name, c.column_name, t.constraint_type, t.r_owner' +
      #13#10 + '  from all_constraints t, all_cons_columns c' + #13#10 +
      ' where c.owner = t.owner and c.constraint_name = t.constraint_name and' +
      #13#10 + '       upper(t.table_name) = :v_tbn and t.owner = :v_owner and' +
      #13#10 + '       t.constraint_type in (''P'',''R'')';


    Params.ParamByName('v_owner').AsString := ADBUser;
    Params.ParamByName('v_tbn').AsString := vObjName;
    Open;
    while not EOF do
    begin
      S := CtTrim(Fields[1].AsString);
      f := o.MetaFields.FieldByName(S);
      if Assigned(f) then
      begin
        S := CtTrim(Fields[2].AsString);
        if S = 'P' then
          f.KeyFieldType := cfktId
        else if S = 'R' then
        begin
          if f.KeyFieldType <> cfktId then
            f.KeyFieldType := cfktRid;
          S := Fields[0].AsString;
          with FQueryB do
          begin
            Clear;
            SQL.Text :=
              'select c.column_name,t.table_name' + #13#10 +
              '  from all_constraints t, all_cons_columns c' + #13#10 +
              ' where c.owner = t.owner and c.constraint_name = t.constraint_name and' +
              #13#10 + '       t.constraint_name = :v_tbn and t.owner = :v_owner and' +
              #13#10 + '       t.constraint_type in (''P'',''U'')';

            Params.ParamByName('v_owner').AsString := ADBUser;
            Params.ParamByName('v_tbn').AsString := S;
            //ctalert(Sql.Text+#13#10' owner '+ADBUser+' tb '+VObjName);
            Open;
            if not EOF then
            begin
              f.RelateTable := CtTrim(Fields[1].AsString);
              f.RelateField := CtTrim(Fields[0].AsString);
            end;
          end;
        end;
      end;
      Next;
    end;


    Clear;
    SQL.Text :=
      'select t.column_name, a.uniqueness, a.index_name,' + #13#10 +    
      '  (select count(*) from all_ind_columns c where c.table_owner=a.table_owner and c.index_name=a.index_name) ind_col_count '+#13#10+
      '  from all_ind_columns t, all_indexes a' + #13#10 +
      ' where upper(a.table_name) = :v_tbn' + #13#10 +
      '   and a.table_owner = :v_owner' + #13#10 +
      '   and t.table_owner = a.TABLE_OWNER' + #13#10 +
      '   and t.index_name = a.index_name' + #13#10 +
      '   and a.index_type <> ''DOMAIN''' + #13#10 +
      ' order by t.index_name, t.column_position';

    Params.ParamByName('v_owner').AsString := ADBUser;
    Params.ParamByName('v_tbn').AsString := vObjName;
    Open;
    while not EOF do
    begin
      S := CtTrim(Fields[0].AsString);       
      po := Fields[3].AsInteger;
      if po > 1 then
      begin
        f := o.MetaFields.NewMetaField;
        f.Name := RemoveIdxNamePrefx(Fields[2].AsString, o.Name);
        f.DataType := cfdtFunction;
        if Fields[1].AsString = 'UNIQUE' then
          f.IndexType := cfitUnique
        else
          f.IndexType := cfitNormal;
        while po > 1 do
        begin
          Next;
          Dec(po);
          S := S+','+CtTrim(Fields[0].AsString);
        end;
        f.IndexFields := S;
                      
        f.Memo := S;
        T := GetIdxName(o.Name, f.Name);
        if f.IndexType = cfitUnique then
          T := 'IDU_' + T
        else
          T := 'IDX_' + T;
        if LowerCase(CtTrim(Fields[2].AsString)) <> LowerCase(T) then
          f.Memo := f.Memo + '[DB_INDEX_NAME:' + CtTrim(Fields[2].AsString) + ']';
      end
      else
      begin
        f := o.MetaFields.FieldByName(S);
        if Assigned(f) then
        begin
          S := CtTrim(Fields[1].AsString);
          if S = 'UNIQUE' then
          begin
            if f.KeyFieldType <> cfktId then
              f.IndexType := cfitUnique;
          end
          else
            f.IndexType := cfitNormal;
        end;
      end;
      Next;
    end;
  end;
end;

function TCtMetaOracleDb.ObjectExists(ADbUser, AObjName: string): boolean;
begin
  CheckConnected;
  with FQuery do
  begin
    Clear;
    AObjName := UpperCase(AObjName);
    ADbUser := UpperCase(ADbUser);
    if (ADbUser = '') or (ADbUser = UpperCase(Self.User)) then
    begin
      Sql.Text := 'select count(*) from user_objects where upper(object_name) = :OBJN';

      Params.ParamByName('OBJN').AsString := AObjName;
    end
    else
    begin
      Sql.Text :=
        'select count(*) from all_objects t where t.owner = :VOWNER and upper(t.object_name) = :OBJN';
      Params.ParamByName('VOWNER').AsString := ADbUser;
      Params.ParamByName('OBJN').AsString := AObjName;
    end;
    Open;                
    if not EOF then
      Result := Fields[0].AsInteger > 0;
  end;
end;


function TCtMetaOracleDb.ShowDBConfig(AHandle: THandle): boolean;
var
  S: string;
begin
  S := TfrmOraDBConfig.DoOracleNetConfig(Database);
  if S <> '' then
  begin
    Database := S;
    Result := True;
  end
  else
    Result := False;
end;


initialization
  AddCtMetaDBReg('ORACLE', TCtMetaOracleDb);

end.


