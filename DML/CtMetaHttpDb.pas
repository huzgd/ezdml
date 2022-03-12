(*
  通过HTTP JSON结果来获取任意数据源信息
  by huz 20210214
*)

unit CtMetaHttpDb;

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  CtMetaData, CtMetaTable, CtMetaCustomDb, DB, uJson;

type

  { TCtMetaHttpDb }

  TCtMetaHttpDb = class(TCtMetaCustomDb)
  private
  protected
    FAccessToken: string; //访问令牌，连接时获取
    function ExecCustomDbCmd(cmd, par1, par2, buf: string): string; override; //子类必须实现此方法

    function ExecCustomDbCmdEx(cmd, par1, par2, buf: string): string; virtual; //此方法不检查登录

    procedure SetConnected(const Value: Boolean); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function ShowDBConfig(AHandle: THandle): boolean; override;

    function GetDbNames: string; override;
  end;


implementation

uses
  WindowFuncs, NetUtil, Forms, DmlScriptPublic, dmlstrs;

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
    S := ExecCustomDbCmdEx('connect', User, Password, DbSchema);
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
    DbSchema := map.getString('DbSchema');
    if FEngineType = '' then
      RaiseError('no_engine_type', 'connect');   
    FNeedGenCustomSql := map.optBoolean('NeedGenCustomSql');

    FConnected := Value;
  end
  else
  begin
    try
      S := ExecCustomDbCmdEx('disconnect', FAccessToken, '', '');
    finally
      FConnected := False;
    end;
  end;
end;

function TCtMetaHttpDb.ShowDBConfig(AHandle: THandle): boolean;
  function GetJdbcCmdFn: string;
  begin
    Result := GetFolderPathOfAppExe('CustomTools');
    Result:=FolderAddFileName(Result, 'JDBC server.pas');
  end;

  procedure ExecDmlScriptFile(fn: string);
  var
    FileTxt, AOutput: TStrings;
    S: string;
    bUtf8: Boolean;
    cTb: TCtMetaTable;
  begin
    cTb := nil;

    FileTxt := TStringList.Create;
    AOutput := TStringList.Create;
    with CreateScriptForFile(fn) do
    try
      ActiveFile := fn;
      FileTxt.LoadFromFile(fn);
      S := FileTxt.Text;
      bUtf8 := False;
      if Length(S) > 3 then
        if (Ord(S[1]) = $EF) and (Ord(S[2]) = $BB) and (Ord(S[3]) = $BF) then
        begin
          S := Copy(S, 4, Length(S));
          bUtf8 := True;
        end;
      if not bUtf8 then
        if Pos('UTF-8', UpperCase(S)) >= 0 then
          bUtf8 := True;
      if bUtf8 then
      begin
        S := Utf8Decode(S);
      end;

      Init('DML_SCRIPT', cTb, AOutput, nil);
      Exec('DML_SCRIPT', FileTxt.Text);
    finally
      FileTxt.Free;
      AOutput.Free;
      Free;
    end;
  end;

var
  S: string;
begin
  //显示连接界面，用于获取服务地址端口用户名密码等信息
  Result := False;
  if Application.MessageBox(PChar(srHttpJdbcConfigTip), PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
    Exit;

  S := GetJdbcCmdFn;
  if not FileExists(S) then
    raise Exception.Create('Script file not found: ' + S);

  ExecDmlScriptFile(S);
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

  Result := GetUrlData_Net(url, qs, '[SHOW_PROGRESS][WAIT_TICKS=2000]');
end;

function TCtMetaHttpDb.GetDbNames: string;
begin
  Result := 'http://localhost:8083/ezdml/'#13#10'http://192.168.1.11:8083/ezdml/';
end;

initialization
  AddCtMetaDBReg('HTTP_JDBC', TCtMetaHttpDb);


end.

