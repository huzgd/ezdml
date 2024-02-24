unit CtMetaOdbcDb;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  IniFiles, CtMetaData, CtMetaTable, CtMetaFCLSqlDb, odbcconn, DB, sqlDb;

type

  { TCtMetaOdbcDb }

  TCtMetaOdbcDb = class(TCtMetaFCLSqlDb)
  private
    FTempSS: TStrings;
  protected
    FSkipErrorTypes: string;
    function CreateSqlDbConn: TSQLConnection; override;
    procedure SetFCLConnDatabase; override;
    procedure ShowError(tp, msg: string);
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
{$IFDEF Windows}
  uFormWindowsOdbcCfg,
{$ENDIF}
  Dialogs, Forms, WindowFuncs;

{ TCtMetaOdbcDb }


function TCtMetaOdbcDb.CreateSqlDbConn: TSQLConnection;
begin
  Result := TODBCConnection.Create(nil);
  Result.CharSet := Trim(G_OdbcCharset);
end;

procedure TCtMetaOdbcDb.SetFCLConnDatabase;
var
  S: string;
begin
  if not Assigned(FDbConn) then
    Exit;
  S := DataBase;
  FDbConn.DatabaseName := '';
  FDbConn.Params.Clear;
  if Pos('=', S) = 0 then
  begin
    FDbConn.DatabaseName := S;
  end
  else
  begin
    S := StringReplace(S, ';', #10, [rfReplaceAll]);
    FDbConn.Params.Text := S;
  end;
end;

procedure TCtMetaOdbcDb.ShowError(tp, msg: string);
begin
  if tp <> '' then
    if (GetKeyState(VK_CONTROL) and $80) = 0 then
      if Pos('[' + tp + ']', FSkipErrorTypes) > 0 then
      begin
        Exit;
      end;

  msg :=PChar(msg) + #10'(SHIFT+OK=Don''t show again)';
  if Application.MessageBox(
    PChar(msg),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONERROR) <> idOk then
    Abort;
  if (GetKeyState(VK_SHIFT) and $80) <> 0 then
  begin
    if Pos('[' + tp + ']', FSkipErrorTypes) = 0 then
      FSkipErrorTypes := FSkipErrorTypes + '[' + tp + ']';
  end;
end;

constructor TCtMetaOdbcDb.Create;
begin
  inherited;
  FEngineType := 'ODBC';
  FTempSS := TStringList.Create;
end;

destructor TCtMetaOdbcDb.Destroy;
begin
  FTempSS.Free;
  inherited;
end;

function TCtMetaOdbcDb.ShowDBConfig(AHandle: THandle): boolean;
begin     
  FSkipErrorTypes := '';
{$IFDEF Windows}   
  Result := False;
  with TfrmWindowsOdbcConfg.create(nil) do
  try
    RefreshDSNs;
    if ShowModal = mrOk then
    begin
      DataBase := GetSelectedDSN;
      Result := True;
    end;
  finally
    Free;
  end;
{$ELSE}
  ShowMessage('Examples: ' + GetDbNames);
  Result := False;
{$ENDIF}
end;

function TCtMetaOdbcDb.GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string;
begin
  Result := inherited GenObjSql(obj, obj_db, sqlType);
end;

function TCtMetaOdbcDb.GetDbNames: string;
begin
  FTempSS.Clear;
  FTempSS.Add('User_or_System_DSN_Name');
  FTempSS.Add('FILEDSN=File_DSN_Name;');
  FTempSS.Add('Driver=Microsoft Access Driver (*.mdb, *.accdb);Dbq=C:\mydb.mdb;');
  FTempSS.Add('Driver=SQL Server;Server=MyDbServer,Port\SID;Database=pubs;Integrated Security=SSPI;');
  FTempSS.Add(
    'Provider=sqloledb;Data Source=192.168.1.123,1433;Network Library=DBMSSOCN;Initial Catalog=pubs;User ID=sa;Password=abcd;');
  Result := FTempSS.Text;
end;

function TCtMetaOdbcDb.GetDbObjs(ADbUser: string): TStrings;
begin
  CheckConnected;
  FTempSS.Clear;
  try
    DbConn.GetTableNames(FTempSS);
    FSkipErrorTypes := '';
  except
    on E: Exception do
      if ADbUser = '' then
        ShowError('GetDbObjs', 'Error retrieving all Objects:'#10 + E.Message)
      else
        ShowError('GetDbObjs', 'Error retrieving Objects of ' + ADbUser + ':'#10 + E.Message);
  end;
  Result := FTempSS;
end;

function TCtMetaOdbcDb.GetDbUsers: string;
begin
  CheckConnected;
  FTempSS.Clear;
  try
    DbConn.GetSchemaNames(FTempSS);
  except
    on E: Exception do
      ShowError('GetDbUsers', 'Error retrieving all SchemaNames:'#10 + E.Message);
  end;
  Result := FTempSS.Text;
end;



function TCtMetaOdbcDb.GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject;


  function GetDbFieldTypeName(ADS: TSQLQuery; AFieldDef: TFieldDef): string;
  begin
    Result := ''; //FieldTypeNames[AFieldDef.DataType];
  end;

var
  I, L, po: integer;
  o: TCtMetaTable;
  f: TCtMetaField;
  S: string;
  vFieldDef: TFieldDef;
  p2: string;
  VQuery: TSQLQuery; 
  idxNames, idxCols: array of string;
  idxUniqs: array of Boolean;
begin
  Result := nil;
  if AObjName = '' then
    Exit;
  CheckConnected;

  po := Pos('.', AObjName);
  if po > 0 then
  begin
    ADbUser := Copy(AObjName, 1, po - 1);
    AObjName := Copy(AObjName, po + 1, Length(AObjName));
  end;

  if not ObjectExists(ADbUser, AObjName) then
    Exit;

  FTempSS.Clear;
  DbConn.GetFieldNames(AObjName, FTempSS);
  if FTempSS.Count = 0 then   
    ShowError('GetFieldNames', 'Error retrieving Columns of ' +
      AObjName + #10'No column found (Not a table?)');

  with FQuery do
  begin
    Close;
    if ADbUser = '' then
      SQL.Text := 'select * from ' + AObjName
    else
      SQL.Text := 'select * from ' + ADBUser + '.' + AObjName;
    try
      Open;
    except
      on E: Exception do
      begin
        ShowError('GetTbColumns', 'Error retrieving Columns of ' +
          AObjName + #10'SQL: '+SQL.Text + #10 + E.Message);
        Exit;
      end;
    end;

    o := TCtMetaTable.Create;
    Result := o;
    Result.Name := AObjName;
    for I := 0 to FieldDefs.Count - 1 do
    begin
      vFieldDef := FieldDefs[I];
      with o.MetaFields.NewMetaField do
      begin
        Name := vFieldDef.Name;
        Nullable := not vFieldDef.Required;
        case vFieldDef.DataType of
          ftString, ftFixedChar, ftWideString:
          begin
            DataType := cfdtString;
            DataLength := vFieldDef.Size;
          end;
          ftAutoInc:
          begin
            DataType := cfdtInteger;
            DataLength := vFieldDef.Precision;
            KeyFieldType := cfktId;
            DefaultValue := DEF_VAL_auto_increment;
          end;
          ftSmallint, ftInteger, ftWord:
          begin
            DataType := cfdtInteger;
            DataLength := vFieldDef.Precision;
          end;
          ftBoolean:
            DataType := cfdtBool;
          ftFloat, ftCurrency, ftBCD:
          begin
            DataType := cfdtFloat;
            DataLength := vFieldDef.Precision;
          end;
          ftTimeStamp, ftDate, ftTime, ftDateTime:
            DataType := cfdtDate;
          ftVariant, ftArray, ftOraBlob, ftOraClob, ftBytes, ftVarBytes,
          ftBlob, ftMemo, ftGraphic, ftFmtMemo,
          ftFixedWideChar, ftWideMemo:
          begin
            //DataType := cfdtBlob;
            DataType := cfdtString;
            DataLength := DEF_TEXT_CLOB_LEN;
          end;
          ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor,
          ftLargeint, ftADT, ftReference, ftDataSet,
          ftInterface, ftIDispatch, ftGuid, ftFMTBcd:
          begin
            DataType := cfdtOther;
            DataTypeName := GetDbFieldTypeName(FQuery, vFieldDef);
            if DataTypeName = '' then
              DataTypeName := FieldTypeNames[vFieldDef.DataType];
          end;
          else
            DataType := cfdtUnknow;
        end;
        if (DataTypeName = '') and (Pos('[DBTYPENAMES]', AOpt) > 0) then
          DataTypeName := GetDbFieldTypeName(FQuery, vFieldDef);
      end;
    end;
    Close;
  end;


  if ADbUser = '' then
    p2 := ''
  else
    p2 := ADbUser;

  //https://docs.microsoft.com/en-us/sql/odbc/reference/syntax/sqlforeignkeys-function?view=sql-server-ver15 
  VQuery := TSQLQuery.Create(nil);

  try
    VQuery.DataBase := FDbConn;
    VQuery.Close;
    VQuery.ParseSQL := False;
    VQuery.Params.Clear;
    VQuery.Params.CreateParam(ftString, 'CustomODBCIndexType', ptInput);
    VQuery.Params.ParamValues['CustomODBCIndexType'] := 'PrimaryKeys';
    VQuery.SetSchemaInfo(stIndexes, AObjName, p2);
    VQuery.Open;
    while not VQuery.EOF do
    begin
      S := VQuery.Fields[3].AsString; //COLUMN_NAME
      f := o.MetaFields.FieldByName(S);
      if Assigned(f) then
        f.KeyFieldType := cfktId;
      VQuery.Next;
    end;
  except
    on E: Exception do
      ShowError('GetTbPrimaryKeys', 'Error retrieving PrimaryKeys of ' +
        AObjName + ':'#10 + E.Message);
  end;

  try
    VQuery.Close;
    VQuery.ParseSQL := False;
    VQuery.Params.Clear;
    VQuery.Params.CreateParam(ftString, 'CustomODBCIndexType', ptInput);
    VQuery.Params.ParamValues['CustomODBCIndexType'] := 'ForeignKeys';
    VQuery.SetSchemaInfo(stIndexes, AObjName, p2);
    VQuery.Open;
    while not VQuery.EOF do
    begin
      S := VQuery.Fields[7].AsString; //FKCOLUMN_NAME
      f := o.MetaFields.FieldByName(S);
      if Assigned(f) then
      begin
        if f.KeyFieldType <> cfktId then
          f.KeyFieldType := cfktRid;
        f.RelateTable := VQuery.Fields[2].AsString; //PKTABLE_NAME
        f.RelateField := VQuery.Fields[3].AsString; //PKCOLUMN_NAME
      end;
      VQuery.Next;
    end;
  except
    on E: Exception do
      ShowError('GetTbForeignKeys', 'Error retrieving ForeignKeys of ' +
        AObjName + ':'#10 + E.Message);
  end;

  //https://docs.microsoft.com/en-us/sql/odbc/reference/syntax/sqlstatistics-function?view=sql-server-ver15
  try
    VQuery.DataBase := FDbConn;
    VQuery.Close;
    VQuery.ParseSQL := False;
    VQuery.Params.Clear;
    VQuery.SetSchemaInfo(stIndexes, AObjName, p2);
    VQuery.Open;
    L := 0;
    SetLength(idxNames, L);
    SetLength(idxUniqs, L);
    SetLength(idxCols, L);
    while not VQuery.EOF do
    begin
      Inc(L);
      SetLength(idxNames, L);
      SetLength(idxUniqs, L);
      SetLength(idxCols, L);
      idxNames[L - 1] := VQuery.Fields[5].AsString; //INDEX_NAME
      idxUniqs[L - 1] := VQuery.Fields[3].AsInteger = 0; //NON_UNIQUE
      idxCols[L - 1] := VQuery.Fields[8].AsString; //COLUMN_NAME;

      VQuery.Next;
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
  except
    on E: Exception do
      ShowError('GetTbIndexes', 'Error retrieving Indexes of ' +
        AObjName + ':'#10 + E.Message);
  end;

  VQuery.Free;

end;

function TCtMetaOdbcDb.ObjectExists(ADbUser, AObjName: string): boolean;
var
  I: integer;
begin
  Result := False;
  CheckConnected;

  FTempSS.Clear;
  DbConn.GetTableNames(FTempSS);
  for I := 0 to FTempSS.Count - 1 do
    if LowerCase(AObjName) = LowerCase(FTempSS[I]) then
    begin
      Result := True;
      Exit;
    end;
end;


initialization
  AddCtMetaDBReg('ODBC', TCtMetaOdbcDb);

end.
