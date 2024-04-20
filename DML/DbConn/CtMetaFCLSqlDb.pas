unit CtMetaFCLSqlDb;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes,
  Graphics, Controls, ImgList, TypInfo,
  CTMetaData, CtMetaTable, DB, SqlDb, Forms, Dialogs;

type

  { TCtMetaFCLSqlDb }

  TCtMetaFCLSqlDb = class(TCtMetaDatabase)
  private
  protected
    FInnerDbConn: TSQLConnection;
    FDbConn: TSQLConnection;
    FTrans: TSQLTransaction;
    FQuery: TSQLQuery;
    FQueryB: TSQLQuery;
    FLastCmdRowAffected: Integer;
    FUseDriverType: string;
    procedure SetDbConn(AValue: TSQLConnection);
    function GetConnected: boolean; override;
    procedure SetConnected(const Value: boolean); override;
    function CreateSqlDbConn: TSQLConnection; virtual;
    function NeedRecreateDbConn: Boolean; virtual;
    procedure ReCreateFCLDbConn; virtual;
    procedure SetFCLConnDatabase; virtual;
    procedure CheckDsUpdateMode(ds: TSQLQuery); virtual;
    procedure DoDbConnLog(Sender : TSQLConnection; EventType : TDBEventType;
      Const Msg : String); virtual;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure CheckConnected; virtual;

    function ShowDBConfig(AHandle: THandle): boolean; override;
              
    //执行命令
    function ExecCmd(ACmd, AParam1, AParam2: string): string; override;
    procedure ExecSql(ASql: string); override;
    function OpenTable(ASql, op: string): TDataSet; override;

    property DbConn: TSQLConnection read FDbConn write SetDbConn;
  end;

  TSQLConnectionXX = class(TSQLConnection)
  end;

  { TCtSQLTransaction }

  TCtSQLTransaction = class(TSQLTransaction)
  protected
    Function AllowClose(DS: TDBDataset): Boolean; override;
  end;

  { TCtSQLQuery }

  TCtSQLQuery = class(TSQLQuery)
  protected            
    procedure InternalOpen; override;
  public
    procedure ExecSQL; override;
  end;

var
  G_SqlLogEnalbed: Boolean;
  G_SqlLogs: TStrings;

implementation

uses
  WindowFuncs;

procedure WriteSqlLog(const msg: string);
var
  S: String;
begin
  if not G_SqlLogEnalbed then
    Exit;
  S := TimeToStr(Now)+' '+msg;
  if G_SqlLogs=nil then
    G_SqlLogs := TStringList.Create;
  G_SqlLogs.Add(S);
end;

{ TCtSQLTransaction }

function TCtSQLTransaction.AllowClose(DS: TDBDataset): Boolean;
begin
  //Result:=inherited AllowClose(DS);
  Result:=False;
end;

{ TCtSQLQuery }

procedure TCtSQLQuery.InternalOpen;
begin                   
  try             
    if G_SqlLogEnalbed then
      WriteSqlLog('OpenSQL: '+Self.SQL.Text);
    inherited InternalOpen;   
    if G_SqlLogEnalbed then
      WriteSqlLog('OpenSQL: done!');
  except
    on E:Exception do
    begin
      if G_SqlLogEnalbed then
        WriteSqlLog('Open error: '+E.Message);
      raise;
    end;
  end;
end;

procedure TCtSQLQuery.ExecSQL;
begin
  try     
    if G_SqlLogEnalbed then
      WriteSqlLog('ExecSQL: '+Self.SQL.Text);
    inherited ExecSQL;    
    if G_SqlLogEnalbed then
      WriteSqlLog('ExecSQL: done!');
  except
    on E:Exception do
    begin
      if G_SqlLogEnalbed then
        WriteSqlLog('SQL error: '+E.Message);
      raise;
    end;
  end;
end;

{ TCtMetaFCLSqlDb }

procedure TCtMetaFCLSqlDb.SetDbConn(AValue: TSQLConnection);
begin
  if FDbConn = AValue then
    Exit;
  FDbConn := AValue;
  if Assigned(FDbConn) then
  begin
    if FDbConn.Transaction = nil then
      FDbConn.Transaction := FTrans;
  end;
  FQuery.DataBase := FDbConn;
  FQueryB.DataBase := FDbConn;
end;

function TCtMetaFCLSqlDb.GetConnected: boolean;
begin
  if Assigned(FDbConn) then
    Result := FDbConn.Connected
  else
    Result := False;
end;

procedure TCtMetaFCLSqlDb.SetConnected(const Value: boolean);
begin
  if FConnected = Value then
    Exit;     
  if Value then
    ReCreateFCLDbConn;
  if Assigned(FDbConn) then
  begin
    if Value then
    begin
      SetFCLConnDatabase;
      FDbConn.Username := User;
      FDbConn.Password := Password;
    end
    else
      TSQLConnectionXX(FDbConn).ForcedClose := True;
    FDbConn.Connected := Value;
    if Value and FDbConn.Connected then
    begin
      if FDbConn.Transaction = FTrans then
        FTrans.Active := True;
    end;
  end
  else
    raise Exception.Create('No SqlDb connection assigned');
  FConnected := Value;
end;

function TCtMetaFCLSqlDb.CreateSqlDbConn: TSQLConnection;
begin
  Result := nil;
end;

function TCtMetaFCLSqlDb.NeedRecreateDbConn: Boolean;
var
  vUseDriverType: String;
begin
  Result := False;
  if (Pos('DSN:', DataBase) = 1) or (Pos('ODBC:', DataBase) = 1) then
    vUseDriverType := 'ODBC'
  else
    vUseDriverType := '';
  if vUseDriverType <> FUseDriverType then
    Result := True;
end;

procedure TCtMetaFCLSqlDb.ReCreateFCLDbConn;
begin               
  if Assigned(FInnerDbConn) and Assigned(FQuery) and Assigned(FTrans) then
    if not NeedRecreateDbConn then
      Exit;

  if Assigned(FQuery) then
    FreeAndNil(FQuery);
  if Assigned(FQueryB) then
    FreeAndNil(FQueryB);
  if Assigned(FTrans) then
    FreeAndNil(FTrans);
  if Assigned(FInnerDbConn) then
  begin      
    if FDbConn = FInnerDbConn then
      FDbConn := nil;
    FreeAndNil(FInnerDbConn);
  end;

  FQuery := TCtSQLQuery.Create(nil);
  FQueryB := TCtSQLQuery.Create(nil);
  FTrans := TCtSQLTransaction.Create(nil);
  FInnerDbConn := CreateSqlDbConn;
  if FInnerDbConn <> nil then
    DbConn := FInnerDbConn;
end;

procedure TCtMetaFCLSqlDb.SetFCLConnDatabase;
var
  S: string;
  po: integer;
begin
  if not Assigned(FDbConn) then
    Exit;       
  if FUseDriverType = 'ODBC' then
    if FDbConn.CharSet<>Trim(G_OdbcCharset) then
      FDbConn.CharSet := Trim(G_OdbcCharset);
  S := DataBase;
  if Pos('$<', S) > 0 then
  begin
    FDbConn.HostName := ExtractCompStr(S, '$<', '>');
    S := ModifyCompStr(S, 'XXX', '$<', '>');
    S := StringReplace(S, '$<XXX>', '', []);
    FDbConn.DatabaseName := S;
  end
  else
  begin
    po := Pos('@', S);
    if po > 0 then
    begin
      FDbConn.HostName := Copy(S, 1, po - 1);
      FDbConn.DatabaseName := Copy(S, po + 1, Length(S));
    end
    else
    begin
      FDbConn.HostName := S;
      FDbConn.DatabaseName := '';
    end;
  end;
  FDbConn.OnLog:=Self.DoDbConnLog;

end;

constructor TCtMetaFCLSqlDb.Create;
begin
  inherited;
  FEngineType := 'FCLSQLDB';
  FLastCmdRowAffected := -1;
end;

destructor TCtMetaFCLSqlDb.Destroy;
begin
  FreeAndNil(FQuery);
  FreeAndNil(FQueryB);
  FreeAndNil(FTrans);
  if FDbConn = FInnerDbConn then
    FDbConn := nil;
  FreeAndNil(FInnerDbConn);
  inherited;
end;

procedure TCtMetaFCLSqlDb.CheckConnected;
begin
  if not Connected then
    raise Exception.Create('Not connected');
end;

function TCtMetaFCLSqlDb.ShowDBConfig(AHandle: THandle): boolean;
begin
  ShowMessage('Format: host_name@database_name');
  Result := False;
end;

function TCtMetaFCLSqlDb.ExecCmd(ACmd, AParam1, AParam2: string): string;
begin                    
  try
    if G_SqlLogEnalbed then
      WriteSqlLog('ExecCmd: '+ACmd+':'+AParam1+':'+AParam2);
    Result:=inherited ExecCmd(ACmd, AParam1, AParam2);
    if LowerCase(ACmd)='commit' then
    begin
      if G_RetainAfterCommit then
        FDbConn.Transaction.CommitRetaining
      else
        FDbConn.Transaction.Commit;
    end
    else if LowerCase(ACmd)='rollback' then
    begin               
      if G_RetainAfterCommit then
        FDbConn.Transaction.RollbackRetaining
      else
        FDBConn.Transaction.Rollback;    
    end
    else if LowerCase(ACmd)='row_affected' then
    begin
      Result := IntToStr(FLastCmdRowAffected);
      if AParam1='reset' then
        FLastCmdRowAffected := -1;
    end;    
    if G_SqlLogEnalbed then
      WriteSqlLog('ExecCmd: done!');
  except
    on E:Exception do
    begin
      if G_SqlLogEnalbed then
        WriteSqlLog('Cmd error: '+E.Message);
      raise;
    end;
  end;
end;

function RemoveSqlComents(ASql: string): string;
var
  S: string;
  po: Integer;
begin
  Result := ASql;
  while Pos('/*', Result)>0 do
  begin
    S := Result;
    Result := WindowFuncs.RemoveCompStr(Result, '/*', '*/', True);
    if S=Result then
      Break;
  end;        
  while Pos('--', Result)>0 do
  begin
    S := Result;
    Result := WindowFuncs.RemoveCompStr(Result, '--', #10, True);
    if S=Result then
    begin
      po := Pos('--', Result);
      Result := Copy(Result, 1, po - 1);
    end;
    if S=Result then
      Break;
  end;
end;

procedure TCtMetaFCLSqlDb.ExecSql(ASql: string);
var
  S: String;
begin
  CheckConnected;
  S := RemoveSqlComents(ASql);   
  S := LowerCase(Trim(S));
  if S='' then
    Exit;
  if S[Length(S)]=';' then
    Delete(S, Length(S), 1);   
  S := LowerCase(Trim(S));
  if S='' then
    Exit;
  if S='commit' then
  begin
    ExecCmd('commit', '', '');
    Exit;
  end;    
  if S='rollback' then
  begin
    ExecCmd('rollback', '', '');
    Exit;
  end;
  with FQuery do
  begin
    Clear;
    FLastCmdRowAffected := -1;
    Sql.Text := ASql; 
    try
      ExecSQL;
      FLastCmdRowAffected := RowsAffected;
      if Pos('[NO_CT_TRANS]', ASql) = 0 then
        ExecCmd('commit', '', '');
    except
      try
        if Pos('[NO_CT_TRANS]', ASql) = 0 then
          ExecCmd('rollback', '', '');
      except
      end;
      raise;
    end;
  end;
end;

function TCtMetaFCLSqlDb.OpenTable(ASql, op: string): TDataSet;
  function isSql: boolean;
  var
    S: String;
  begin
    S := ' '+LowerCase(ASql);
    S:=StringReplace(S,#13,' ',[rfReplaceAll]);
    S:=StringReplace(S,#10,' ',[rfReplaceAll]);
    S:=StringReplace(S,#9,' ',[rfReplaceAll]);
    if Pos(' select ',S) > 0 then
      Result := True
    else
      Result := False;
  end;
var
  S: string;
begin
  if (Pos('[EXECSQL]', op) > 0) or (Pos('[EXECSQL]', ASql) > 0) then
  begin
    Self.ExecSql(ASql);
    Result := nil;
    Exit;
  end;

  CheckConnected;


  if (Pos('[ISSQL]', op) > 0) or IsSql then
    S := ASql
  else
    S := 'select * from ' + ASql;
  Result := TCtSQLQuery.Create(nil);
  TSQLQuery(Result).DataBase := FDbConn;
  TSQLQuery(Result).Sql.Text := S;        
  if G_RetainAfterCommit then                      
    TSQLQuery(Result).Options := [sqoAutoApplyUpdates]
  else
    TSQLQuery(Result).Options := [sqoKeepOpenOnCommit, sqoAutoApplyUpdates];
  try
    FLastCmdRowAffected := -1;
    Result.Open;
    //FLastCmdRowAffected := Result.RecordCount;
    if Pos('[NO_CT_TRANS]', ASql) = 0 then
      FDbConn.Transaction.CommitRetaining;
  except
    try
      if Pos('[NO_CT_TRANS]', ASql) = 0 then
        FDbConn.Transaction.RollbackRetaining;
    except
    end;
    raise;
  end;
  CheckDsUpdateMode(TSQLQuery(Result));
end;
    
procedure TCtMetaFCLSqlDb.CheckDsUpdateMode(ds: TSQLQuery);
var
  I: Integer;
  fd: TField;  
  S: string;
begin
  if ds=nil then
    Exit;
  if not ds.Active then
  begin
    ds.UpdateMode:=upWhereAll;
    Exit;
  end;
  for I:=0 to ds.FieldCount - 1 do
  begin
    fd := ds.Fields[I];
    if fd.DataType in [ftUnknown, ftBytes, ftVarBytes, ftBlob, ftGraphic,
      ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftADT, ftArray, ftReference,
      ftDataSet, ftOraBlob, ftVariant, ftInterface, ftIDispatch] then
    begin
      //fd.ReadOnly:=True;
    end;
  end;
  for I:=0 to ds.FieldCount - 1 do
  begin
    fd := ds.Fields[I];
    S := UpperCase(fd.FieldName);
    if (S='ROWID') then
    begin
      fd.ProviderFlags:=fd.ProviderFlags+[pfInKey];
      fd.ReadOnly := True;
      ds.UpdateMode:=upWhereKeyOnly;
      Exit;
    end;
  end;

  for I:=0 to ds.FieldCount - 1 do
  begin
    fd := ds.Fields[I];
    S := UpperCase(fd.FieldName);
    if (S='ID') or (S='GUID') or (S='UUID') or (S='CTGUID') then
    begin
      fd.ProviderFlags:=fd.ProviderFlags+[pfInKey];  
      //fd.ReadOnly := True;
      ds.UpdateMode:=upWhereKeyOnly;
      Exit;
    end;
  end;
               
  ds.UpdateMode:=upWhereAll;
  for I:=0 to ds.FieldCount - 1 do
  begin
    fd := ds.Fields[I];
    if fd.DataType in [ftString, ftSmallint, ftInteger, ftWord, ftBCD, ftAutoInc,
      ftFixedChar, ftWideString, ftLargeint, ftGuid, ftFixedWideChar] then
    begin
      fd.ProviderFlags:=fd.ProviderFlags+[pfInWhere];
    end
    else
    begin
      fd.ProviderFlags:=fd.ProviderFlags-[pfInWhere];
    end;
  end;

end;

procedure TCtMetaFCLSqlDb.DoDbConnLog(Sender: TSQLConnection;
  EventType: TDBEventType; const Msg: String);
var
  S: String;
begin
  if not G_SqlLogEnalbed then
    Exit;
  S := GetEnumName(TypeInfo(TDBEventType),Ord(EventType));
  WriteSqlLog(S+': '+Msg);
end;

finalization
  FreeAndNil(G_SqlLogs);

end.
