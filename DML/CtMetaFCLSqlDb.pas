unit CtMetaFCLSqlDb;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes,
  Graphics, Controls, ImgList,
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
    procedure SetDbConn(AValue: TSQLConnection);
    function GetConnected: boolean; override;
    procedure SetConnected(const Value: boolean); override;
    function CreateSqlDbConn: TSQLConnection; virtual;
    procedure ReCreateFCLDbConn; virtual;
    procedure SetFCLConnDatabase; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure CheckConnected; virtual;

    function ShowDBConfig(AHandle: THandle): boolean; override;

    procedure ExecSql(ASql: string); override;
    function OpenTable(ASql, op: string): TDataSet; override;

    property DbConn: TSQLConnection read FDbConn write SetDbConn;
  end;


implementation

uses
  WindowFuncs;

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
  if Assigned(FDbConn) then
  begin
    if Value then
    begin
      SetFCLConnDatabase;
      FDbConn.Username := User;
      FDbConn.Password := Password;
    end;
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

procedure TCtMetaFCLSqlDb.ReCreateFCLDbConn;
begin
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

  FQuery := TSQLQuery.Create(nil);
  FQueryB := TSQLQuery.Create(nil);
  FTrans := TSQLTransaction.Create(nil);
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
end;

constructor TCtMetaFCLSqlDb.Create;
begin
  inherited;
  FEngineType := 'FCLSQLDB';
  ReCreateFCLDbConn;
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

procedure TCtMetaFCLSqlDb.ExecSql(ASql: string);
begin
  CheckConnected;
  with FQuery do
  begin
    Clear;
    Sql.Text := ASql; 
    try
      ExecSQL;
      FDbConn.Transaction.Commit;
    except
      try
        FDbConn.Transaction.Rollback;
      except
      end;
      raise;
    end;
  end;
end;

function TCtMetaFCLSqlDb.OpenTable(ASql, op: string): TDataSet;
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

  if Pos('[ISSQL]', op) > 0 then
    S := ASql
  else
    S := 'select * from ' + ASql;
  Result := TSQLQuery.Create(nil);
  TSQLQuery(Result).DataBase := FDbConn;
  TSQLQuery(Result).Sql.Text := S;
  Result.Open;
end;

end.
