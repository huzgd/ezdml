(*
  通过HTTP JSON结果来获取任意数据源信息
  by huz 20210214
*)

unit CtMetaHttpDb;

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, ImgList, DB, SqlDB,
  CtMetaData, CtMetaTable, CtMetaCustomDb, uJson, EzJdbcConn;

type

  TEzHttpJdbcConnection=class(TEzJdbcSqlConnection)
  end;

  { TCtMetaHttpDb }

  TCtMetaHttpDb = class(TCtMetaCustomDb)
  private
  protected      
    FCtJdbcConn: TEzHttpJdbcConnection;  
    FTrans: TSQLTransaction;

    FAccessToken: string; //访问令牌，连接时获取
    function ExecCustomDbCmd(cmd, par1, par2, buf: string): string; override; //子类必须实现此方法

    function ExecCustomDbCmdEx(cmd, par1, par2, buf: string): string; virtual; //此方法不检查登录

    procedure SetConnected(const Value: Boolean); override;   
    function GetOrigEngineType: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function ShowDBConfig(AHandle: THandle): boolean; override;

    function ExecCmd(ACmd, AParam1, AParam2: string): string; override;
    function OpenTable(ASql, op: string): TDataSet; override;

    function GetDbNames: string; override;
  end;


implementation

uses
  WindowFuncs, NetUtil, Forms, dmlstrs, wHttpJdbcConfig, CtMetaFCLSqlDb;

{ TCtMetaHttpDb }

constructor TCtMetaHttpDb.Create;
begin
  inherited;
  FEngineType := 'HTTP_JDBC';
end;

destructor TCtMetaHttpDb.Destroy;
begin       
  if Self.Connected then
  try
    Self.Connected := False;
  except
  end;
  inherited;
end;

procedure TCtMetaHttpDb.SetConnected(const Value: Boolean);
var
  S: string;
  map: TJSONObject;
begin
  if FConnected = Value then
    Exit;
  if Value then
  begin
    FConnected := False;   
    if Pos('JDBC:', DataBase) = 1 then
    begin
      if not Assigned(FCtJdbcConn) then
      begin
        FCtJdbcConn:=TEzHttpJdbcConnection.Create(nil);
        FreeAndNil(FTrans);
        FTrans := TCtSQLTransaction.Create(nil);  
        FCtJdbcConn.Transaction := FTrans;
      end
      else
        FCtJdbcConn.Connected:=False;
      FCtJdbcConn.HostName:=Self.Database; 
      S := FCtJdbcConn.HostName;
      if Pos('JDBC:', S) = 1 then
        S := Copy(S, 6, Length(S));
      FCtJdbcConn.DatabaseName := S;
      FCtJdbcConn.UserName:=Self.User;
      FCtJdbcConn.Password:=Self.Password;
      FCtJdbcConn.Connected:=True;
      FAccessToken := FCtJdbcConn.FAccessToken;
      FEngineType := FCtJdbcConn.EzDbType;
      S := FCtJdbcConn.FConnectResponse;
    end
    else
    begin
      S := ExecCustomDbCmdEx('connect', User, Password, DbSchema);
    end;
    if S = '' then
      RaiseError('no_data_result', 'connect');
    map := ConvertStrToJson(S);
    if map = nil then
      RaiseError('no_map_result', 'connect');
    if map.optInt('resultCode') = -1 then
    begin
      S := map.optString('errorMsg');
      map.Free;
      RaiseError(S, 'connect');
      Exit;
    end;

    FAccessToken := map.getString('EzdmlToken');
    FEngineType := map.getString('EngineType');
    DbSchema := GetDbQuotName(map.getString('DbSchema'), Self.EngineType);
    if FEngineType = '' then
      RaiseError('no_engine_type', 'connect');
    FNeedGenCustomSql := map.optBoolean('NeedGenCustomSql');
    map.Free;

    FConnected := Value;
  end
  else
  begin
    try
      if Assigned(FCtJdbcConn) then
      begin
        FCtJdbcConn.Connected:=False;
        FreeAndNil(FCtJdbcConn);   
        FreeAndNil(FTrans);
      end
      else
        S := ExecCustomDbCmdEx('disconnect', FAccessToken, '', '');
    finally
      FConnected := False;
    end;
  end;
end;

function TCtMetaHttpDb.GetOrigEngineType: string;
begin
  Result := 'HTTP_JDBC';
end;

function TCtMetaHttpDb.ShowDBConfig(AHandle: THandle): boolean;
var
  S: string;
begin
  //显示连接界面，用于获取服务地址端口用户名密码等信息
  Result := False;                            
  S := TfrmHttpJdbcConfig.DoDBConfig(Database);
  if S <> '' then
  begin
    Database := S;
    Result := True;
  end;
end;

function TCtMetaHttpDb.ExecCmd(ACmd, AParam1, AParam2: string): string;
begin        
  if ACmd='CT_BEFORE_RECONNECT' then
  begin
    if Connected and Assigned(FCtJdbcConn) then
      if AParam1=Self.Database then
        if AParam2=(Self.User+'/'+Self.Password) then    
          if FCtJdbcConn.JdbcProcActive then
          begin
            Result := '_HANDLED';
            Exit;
          end;
  end;
  Result:=inherited ExecCmd(ACmd, AParam1, AParam2);
end;

function TCtMetaHttpDb.OpenTable(ASql, op: string): TDataSet;   
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
  if not Assigned(FCtJdbcConn) or not FCtJdbcConn.Connected then
  begin
    Result:=inherited OpenTable(ASql, op);
    Exit;
  end;

  if (Pos('[EXECSQL]', op) > 0) or (Pos('[EXECSQL]', ASql) > 0) then
  begin
    Self.ExecSql(ASql);
    Result := nil;
    Exit;
  end;

  if (Pos('[ISSQL]', op) > 0) or IsSql then
    S := ASql
  else
    S := 'select * from ' + ASql;
  Result := TCtSQLQuery.Create(nil);
  TSQLQuery(Result).DataBase := FCtJdbcConn;
  TSQLQuery(Result).Sql.Text := S;
  if not G_AutoCommit then
    TSQLQuery(Result).Options := [sqoAutoApplyUpdates]
  else if G_RetainAfterCommit then
    TSQLQuery(Result).Options := [sqoAutoApplyUpdates]
  else
    TSQLQuery(Result).Options := [sqoKeepOpenOnCommit, sqoAutoApplyUpdates];
  try
    Result.Open;
    //FLastCmdRowAffected := Result.RecordCount;
    if G_AutoCommit and (Pos('[NO_CT_TRANS]', ASql) = 0) then
      FCtJdbcConn.Transaction.CommitRetaining;
  except
    try
      if G_AutoCommit and (Pos('[NO_CT_TRANS]', ASql) = 0) then
        FCtJdbcConn.Transaction.RollbackRetaining;
    except
    end;
    raise;
  end;
  CheckDsUpdateMode(TSQLQuery(Result), op);
end;

function TCtMetaHttpDb.ExecCustomDbCmd(cmd, par1, par2, buf: string): string;
begin
  if not Self.Connected then
    RaiseError('not_connected', cmd);
  Result := ExecCustomDbCmdEx(cmd, par1, par2, buf);
end;

function TCtMetaHttpDb.ExecCustomDbCmdEx(cmd, par1, par2, buf: string): string;
var
  url, qs: string;
begin
  //执行命令，返回JSON字符串，其中resultCode=-1表示失败，errorMsg为出错信息，其它情况为成功
  url := Self.Database;
  if Assigned(FCtJdbcConn) then
    url := FCtJdbcConn.FJdbcSvAddr; 
  if EngineType='H2' then
  begin
    if (cmd='GetDbObjs') or (cmd='GetObjInfos') or (cmd='ObjectExists') then
    begin
      par1 := UpperCase(par1);
      par2 := UpperCase(par2);
    end;
  end;
  url := url + '?cmd=' + cmd;
  if Self.Connected then
    if FAccessToken <> '' then
      url := url + '&eztoken=' + URLEncodeEx(FAccessToken);

  qs := '';
  if par1 <> '' then
    qs := qs + '&param1=' + URLEncodeEx(par1);
  if par2 <> '' then
    qs := qs + '&param2=' + URLEncodeEx(par2);
  if buf <> '' then
    qs := qs + '&data=' + URLEncodeEx(buf);
  if Length(qs) <= 1000 then
  begin
    url := url + qs;
    qs := '';
  end;

  Result := GetUrlData_Net(url, qs, '[SHOW_PROGRESS][WAIT_TICKS=2000][READ_TIMEOUT=90000]');
end;

function TCtMetaHttpDb.GetDbNames: string;
begin
  Result := 'http://localhost:8083/ezdml/'#13#10'http://192.168.1.11:8083/ezdml/'#10'JDBC:jdbc:mysql://192.168.1.1:3306/dbname';
end;

initialization
  AddCtMetaDBReg('HTTP_JDBC', TCtMetaHttpDb);


end.

