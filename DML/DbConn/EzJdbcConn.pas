unit EzJdbcConn;

{$ifdef EZDML_LITE}

{$mode delphi}

interface

uses
  Classes, SysUtils, sqldb;

type

  { TEzJdbcSqlConnection }

  TEzJdbcSqlConnection=class(TSQLConnection)
  private
  protected
    FJdbcProcActive: Boolean;
    FEzDbDriverClass: string;
    FEzDbType: string;
    FAccessToken: string;
    FConnectResponse: string;
    FJdbcSvAddr: string;   
    procedure DoInternalConnect; override;
    procedure DoInternalDisconnect; override;
  public
    property JdbcProcActive: Boolean read FJdbcProcActive;
    property EzDbType: string read FEzDbType write FEzDbType;
    property EzDbDriverClass: string read FEzDbDriverClass write FEzDbDriverClass;
  end;

  TCtCustDbCursor=class(TSQLCursor)
  public
    FSelectCursorType: Boolean;
  end;


function ExtractJdbcProp(connstr, prop: string): string;
function GetDefaultDbTypeOfUrl(url: string): string;
function GetDefaultDbDriverOfUrl(url: string): string;

implementation

uses
  WindowFuncs, ezdmlstrs, dmlstrs;

function ExtractJdbcProp(connstr, prop: string): string;
begin
  if Copy(connstr,1,5)='JDBC:' then
    connstr := Trim(copy(connstr,6,Length(connstr)));
  Result := ExtractCompStr(';'+connstr+';', ';'+prop+'=',';');
end;

function GetDefaultDbTypeOfUrl(url: string): string;
begin
  Result := '';
  if Pos('jdbc:oracle:', url)=1 then
    Result := 'ORACLE'
  else if Pos('jdbc:mysql:', url)=1 then
    Result := 'MYSQL'
  else if Pos('jdbc:postgresql:', url)=1 then
    Result := 'POSTGRESQL'
  else if Pos('jdbc:sqlserver:', url)=1 then
    Result := 'SQLSERVER'
  else if Pos('jdbc:h2:', url)=1 then
    Result := 'H2'
  else if Pos('jdbc:hive2:', url)=1 then
    Result := 'HIVE';
end;

function GetDefaultDbDriverOfUrl(url: string): string;
var
  dbTp, cfg: string;
begin
  Result := '';
  dbTp := GetDefaultDbTypeOfUrl(url);
  if dbTp='' then
    Exit;
  cfg := GetCtDropDownTextOfValue(dbTp, srEzJdbcDriverList);
  Result := ExtractJdbcProp(cfg, 'driver');
end;

{ TEzJdbcSqlConnection }

procedure TEzJdbcSqlConnection.DoInternalConnect;
begin
  raise Exception.Create(srEzdmlLiteNotSupportFun);
end;

procedure TEzJdbcSqlConnection.DoInternalDisconnect;
begin     
  raise Exception.Create(srEzdmlLiteNotSupportFun);
end;

{$else}

{$i EzJdbcConnPr.inc}

{$endif}

end.

