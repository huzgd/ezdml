unit DmlGlobalPasScriptLite;

{$mode delphi}

interface

uses
  Classes, SysUtils, CtMetaTable;

type

  { TDmlGlobalPasScriptLite }
  //EZDML Global Event Scripts (Only support Pascal-Script) Ver20191006
  //EZDML全局事件脚本（注：只支持Pascal脚本）

  TDmlGlobalPasScriptLite = class
  protected
  public
    { Public declarations }
    constructor Create; virtual;
    destructor Destroy; override;

    procedure TakeGlobalEvents;

    //Generate SQL for a single Table. defRes is the default result.
    //生成单个表的SQL，传入表对象、是否生成创建表SQL、是否生成创建约束SQL、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL
    function _OnEzdmlGenTbSqlEvent(tb: TCtMetaTable;
      bCreateTb, bCreateConstrains: boolean; defRes, dbType, options: string): string;

    //Generate upgrade SQL for an exists Table in a database. defRes is the default result.
    //生成数据库的更新SQL，传入新旧表对象、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL
    function _OnEzdmlGenDbSqlEvent(designTb, dbTable: TCtMetaTable;
      defRes, dbType, options: string): string;

    //Generate SQL for a single Field. defRes is the default result.
    //生成单个字段的类型（varchar(255) nullable），传入表对象、字段对象、默认生成的结果、数据库类型、选项，返回自定义结果
    function _OnEzdmlGenFieldTypeDescEvent(tb: TCtMetaTable; fd: TCtMetaField;
      defRes, dbType, options: string): string;

    //Generate upgrade SQL for an exists database-Field of a Table. defRes is the default result.
    //生成增删改单个字段的SQL（alter table add xxx），传入要执行的操作(alter/add/drop)、表对象、新旧字段对象、默认生成的结果、数据库类型、选项，返回自定义结果
    function _OnEzdmlGenAlterFieldEvent(action: string; tb: TCtMetaTable;
      designField, dbField: TCtMetaField; defRes, dbType, options: string): string;

    //Generate test Data Insert SQL for an exists database-table. defRes is the default result.
    //生成插入测试数据的SQL，传入表对象、SQL类型（insert select_max_key select_random_key update_fk）、默认生成的结果、参数1、参数2、数据库类型、选项，返回自定义结果
    function _OnEzdmlGenDataSqlEvent(tb: TCtMetaTable;
    sqlType, defRes, param1, param2, dbType, options: string): string;

    //Reserved custom events
    //自定义命令事件
    function _OnEzdmlCmdEvent(cmd, param1, param2: string;
      parobj1, parobj2: TObject): string;
  end;


implementation

uses
  ezdmlstrs;

{ TDmlGlobalPasScriptLite }


constructor TDmlGlobalPasScriptLite.Create;
begin
end;

destructor TDmlGlobalPasScriptLite.Destroy;
begin
  inherited Destroy;
end;

procedure TDmlGlobalPasScriptLite.TakeGlobalEvents;
begin
  GProc_OnEzdmlGenTbSqlEvent := _OnEzdmlGenTbSqlEvent;
  GProc_OnEzdmlGenDbSqlEvent := _OnEzdmlGenDbSqlEvent;
  GProc_OnEzdmlGenFieldTypeDescEvent := _OnEzdmlGenFieldTypeDescEvent;
  GProc_OnEzdmlGenAlterFieldEvent := _OnEzdmlGenAlterFieldEvent;
  GProc_OnEzdmlGenDataSqlEvent := _OnEzdmlGenDataSqlEvent;
  GProc_OnEzdmlCmdEvent := _OnEzdmlCmdEvent;
end;
                     
//Generate SQL for a single Table. defRes is the default result.
//生成单个表的SQL，传入表对象、是否生成创建表SQL、是否生成创建约束SQL、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL
function TDmlGlobalPasScriptLite._OnEzdmlGenTbSqlEvent(tb: TCtMetaTable; bCreateTb,
  bCreateConstrains: boolean; defRes, dbType, options: string): string;
begin
  Result := defRes;
end;
                    
//Generate upgrade SQL for an exists Table in a database. defRes is the default result.
//生成数据库的更新SQL，传入新旧表对象、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL
function TDmlGlobalPasScriptLite._OnEzdmlGenDbSqlEvent(designTb,
  dbTable: TCtMetaTable; defRes, dbType, options: string): string;
begin
  Result := defRes;
end;
                         
//Generate SQL for a single Field. defRes is the default result.
//生成单个字段的类型（varchar(255) nullable），传入表对象、字段对象、默认生成的结果、数据库类型、选项，返回自定义结果
function TDmlGlobalPasScriptLite._OnEzdmlGenFieldTypeDescEvent(tb: TCtMetaTable;
  fd: TCtMetaField; defRes, dbType, options: string): string;
begin
  Result := defRes;
end;
                    
//Generate upgrade SQL for an exists database-Field of a Table. defRes is the default result.
//生成增删改单个字段的SQL（alter table add xxx），传入要执行的操作(alter/add/drop)、表对象、新旧字段对象、默认生成的结果、数据库类型、选项，返回自定义结果
function TDmlGlobalPasScriptLite._OnEzdmlGenAlterFieldEvent(action: string;
  tb: TCtMetaTable; designField, dbField: TCtMetaField; defRes, dbType,
  options: string): string;
begin
  Result := defRes;
end;


//Generate test Data Insert SQL for an exists database-table. defRes is the default result.
//生成插入测试数据的SQL，传入表对象、SQL类型（DQL_DML_SQL TEST_DATA_INSERT_SQL GET_MAX_KEY_SQL TEST_DATA_UPDATE_FK_SQL）、默认生成的结果、数据库类型、参数1、参数2、选项，返回自定义结果
function TDmlGlobalPasScriptLite._OnEzdmlGenDataSqlEvent(tb: TCtMetaTable; sqlType,
  defRes, param1, param2, dbType, options: string): string;
begin
  Result := defRes;
end;
            
//Reserved custom events
//自定义命令事件
function TDmlGlobalPasScriptLite._OnEzdmlCmdEvent(cmd, param1, param2: string;
  parobj1, parobj2: TObject): string;
begin
  Result := '';
end;

end.
