(*
  CtMetaTable
  Create by huz(EMAIL) 2009-1-28 18:39:44
  CT数据表

CtMetaTable[CT数据表]
-----------------------------
ID[编号]              PK
CellTreeId[CT编号]    FK
Name[名称]            String
CreateDate[创建日期]  Date
CreatorName[创建人]   String
ModifyDate[修改日期]  Date
ModifierName[修改人]  String
Memo[备注]            String
DATALEVEL[数据级别]   Enum


  CtMetaField
  Create by huz(EMAIL) 2009-1-28 18:40:46
  CT数据字段

CtMetaField[CT数据字段]
---------------------------------------------------
ID[编号]                                   PK
RID[表编号]                                FK
Name[名称]                                 String
DisplayName[显示名称]                      String
DataType[数据类型]                         Enum
DataTypeName[数据类型]                     String
KeyFieldType[关键字段类型_IdPidRid...]     Enum
RelateTable[关联表]                        String
RelateField[关联字段]                      String
IndexType[索引类型_0无1唯一2普通]          Enum
IndexFields[索引字段]                      String    
DBCheck[数据库检查]                        String
Hint[提示]                                 String
Memo[备注]                                 String
DefaultValue[缺省值]                       String
Nullable[是否可为空]                       Bool
DataLength[最大长度]                       Integer
FieldWeight[字段权重]                      Integer
Url[链接]                                  String
ResType[资源类型]                          String
Formula[公式]                              String
FormulaCondition[公式条件]                 String
AggregateFun[汇总函数]                     String
MeasureUnit[计量单位]                      String
ValidateRule[字段值检查规则]               String
EditorType[编辑器类型]                     String
LabelText[标签文字]                        String
EditorReadOnly[编辑器是否只读]             Bool
EditorEnabled[编辑器是否激活]              Bool
DisplayFormat[显示格式]                    String
EditFormat[输入格式]                       String
FontName[字体名称]                         String
FontSize[字体大小]                         Float
FontStyle[字体样式]                        Integer
ForeColor[前景颜色]                        Integer
BackColor[背景颜色]                        Integer
DropDownItems[下拉列表]                    String
DropDownMode[下拉模式_0无1选择2编辑3添加]  Enum
Visibility   Integer
TextAlign    Enum
ColWidth     Integer
MaxLength    Integer
Searchable   Bool
Queryable    Bool
Exportable   Bool
InitValue    String
ValueMin     String
ValueMax     String
ValueFormat  String
ExtraProps   String
CustomConfigs String

ExplainText    String
TextClipSize   Integer
DropDownSQL    String
ItemColCount   Integer
FixColType     Enum
HideOnList     Bool
HideOnEdit     Bool
HideOnView     Bool
AutoMerge      Bool
ColGroup       String
SheetGroup     String
ColSortable    Bool
ShowFilterBox  Bool
AutoTrim       Bool
Required       Bool
EditorProps    String
TestDataRules  String
UILogic        String
BusinessLogic  String


CtDataModelGraph(数据模型图)
-----------------------------------
ID                         PK
Name                       String
GraphWidth(图形区宽度)     Integer
GraphHeight(图形区高度)    Integer
DefDbEngine(缺省数据连接)  String
DbConnectStr(数据连接名)   String
ConfigStr(选项设置串)      String
Tables(数据表)             List

*)

unit CtMetaTable;

{$IFDEF FPC}
{$MODE Delphi}
{$WARN 4104 off : Implicit string type conversion from "$1" to "$2"}
{$WARN 4105 off : Implicit string type conversion with potential data loss from "$1" to "$2"}
{$WARN 5057 off : Local variable "$1" does not seem to be initialized}
{$ENDIF}
interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Classes, SysUtils, Variants, Graphics, Controls,
  CTMetaData, CtObjSerialer, DB;

type
  TCTMetaFieldList = class;
  TCtMetaTableList = class;
  TCtDataModelGraph = class;
  TCtDataModelGraphList = class;
  TCtMetaDatabase = class;
  TCtMetaTable = class;
  TCtMetaField = class;

  TCtFieldDataType = (
    cfdtUnknow,
    cfdtString,
    cfdtInteger,
    cfdtFloat,
    cfdtDate,
    cfdtBool,
    cfdtEnum,
    cfdtBlob,
    cfdtObject,
    cfdtCalculate,
    cfdtList,
    cfdtFunction,
    cfdtEvent,
    cfdtOther);

  TCtKeyFieldType =
    (
    cfktNormal,
    cfktId,
    cfktPid,
    cfktRid,
    cfktName,
    cfktCaption,
    cfktComment,
    cfktTypeName,
    cfktOrgId,
    cfktPeriod,
    cfktCreatorId,
    cfktCreatorName,
    cfktCreateDate,
    cfktModifierId,
    cfktModifierName,
    cfktModifyDate,
    cfktVersionNo,
    cfktHistoryId,
    cfktLockStamp,
    cfktInstNo,
    cfktProcID,
    cfktURL,
    cfktDataLevel,
    cfktStatus,
    cfktOrderNo,
    cfktOthers
    );

  TCtFieldIndexType =
    (
    cfitNone,
    cfitUnique,
    cfitNormal
    );

  TCtFieldDropDownMode =
    (
    cfddNone,
    cfddFixed,
    cfddEditable,
    cfddAppendable,
    cfddAutoComplete,
    cfddAutoCompleteFixed
    );

  TCtFieldFixColType =
    (
    cffcNone,
    cffcLeft,
    cffcRight
    );

  TCtTextAlignment =
    (
    cftaAuto,
    cftaLeft,
    cftaRight,
    cftaCenter
    );

  TCtFieldDataTypeNames = array[TCtFieldDataType] of string;


  //生成单个表的SQL，传入表对象、是否生成创建表SQL、是否生成创建约束SQL、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL
  TOnEzdmlGenTbSqlEvent = function(tb: TCtMetaTable;
    bCreateTb, bCreateConstrains: boolean; defRes, dbType, options: string): string of
    object;

  //生成数据库的更新SQL，传入新旧表对象、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL
  TOnEzdmlGenDbSqlEvent = function(designTb, dbTable: TCtMetaTable;
    defRes, dbType, options: string): string of object;

  //生成单个字段的类型（varchar(255) nullable），传入表对象、字段对象、默认生成的结果、数据库类型、选项，返回自定义结果
  TOnEzdmlGenFieldTypeDescEvent = function(tb: TCtMetaTable; fd: TCtMetaField;
    defRes, dbType, options: string): string of object;

  //生成增删改单个字段的SQL（alter table add xxx），传入要执行的操作(alter/add/drop)、表对象、新旧字段对象、默认生成的结果、数据库类型、选项，返回自定义结果
  TOnEzdmlGenAlterFieldEvent = function(action: string; tb: TCtMetaTable;
    designField, dbField: TCtMetaField; defRes, dbType, options: string): string of
    object;
           
  //生成表数据的SQL，传入表对象、SQL类型、默认生成的SQL结果、参数1、参数2、数据库类型、选项，返回自定义结果SQL
  TOnEzdmlGenDataSqlEvent = function(tb: TCtMetaTable;
    sqlType, defRes, param1, param2, dbType, options: string): string of
    object;

  //自定义命令事件
  TOnEzdmlCmdEvent = function(cmd, param1, param2: string;
    parobj1, parobj2: TObject): string of object;


  { TCtMetaObject }

  TCtMetaObject = class(TCtObject)
  private
    FIsSelected: boolean;
    FIsChecked: boolean;
    FMetaModified: boolean;
    function GetJsonStr: string;
    function GetMetaModified: boolean;
    procedure SetJsonStr(AValue: string);
    procedure SetMetaModified(const Value: boolean);
  public
    property JsonStr: string read GetJsonStr write SetJsonStr; //added by huz 20210214
    property MetaModified: boolean read GetMetaModified write SetMetaModified;
    property IsSelected: boolean read FIsSelected write FIsSelected; //是否被选中
    property IsChecked: boolean read FIsChecked write FIsChecked; //是否被勾选
  end;

  TCtMetaObjectList = class(TCtObjectList)
  end;

  { CT数据表 }
  //注意：TYPENAME为空或TABLE时才是表，为TEXT时是纯文字
  //为FUNCTION、PROCEDURE、PACKAGE时为存储过程
  //为DATASQL时表示插入数据的初始化SQL

  { TCtMetaTable }

  TCtMetaTable = class(TCtMetaObject)
  private
  protected               
    FBgColor: integer;
    FPhysicalName: string;
    FCellTreeId: integer;
    FGraphDesc: string;
    FCustomConfigs: string;
    FScriptRules: string;  
    FUIDisplayText: string;
    FBusinessLogic: string;
    FExtraProps: string;
    FExtraSQL: string;      
    FListSQL: string;
    FViewSQL: string;
    FGenCode: boolean;
    FGenDatabase: boolean;
    FMetaFields: TCTMetaFieldList;
    FOwnerList: TCtMetaTableList;
    FUILogic: string;      
    FDesignNotes: string;
    FGroupName: string;
    FOwnerCategory: string;
    FPartitionInfo: string;
    FSQLAlias: string;
    FSQLOrderByClause: string;
    FSQLWhereClause: string;
    function GetExcelText: string;
    function GetMetaFields: TCTMetaFieldList;
    function GetDescribe: string;    
    function GetSketchyDescribe: string;
    function GetUIDisplayName: string;
    procedure SetDescribe(const Value: string);
    function GetKeyFieldName: string;
    procedure SetExcelText(AValue: string);   
    function GetRealTableName: string;   
    procedure AssignTbPropsFrom(tb: TCtMetaTable); virtual;
  public
    constructor Create; override;
    destructor Destroy; override;

    //状态保存恢复接口
    procedure Reset; override;
    procedure AssignFrom(ACtObj: TCtObject); override;
    procedure SyncPropFrom(ACtTable: TCtMetaTable); virtual;
    procedure LoadFromSerialer(ASerialer: TCtObjSerialer); override;
    procedure SaveToSerialer(ASerialer: TCtObjSerialer); override;

    function MaybeSame(ATb: TCtMetaTable): boolean;

    function GetTableComments: string; virtual;
    function GetPrimaryKeyNames(AQuotDbType: string = ''): string;
    function GetSpecKeyNames(keyFieldTp: TCtKeyFieldType;
      AQuotDbType: string = ''): string;
    function GetPossibleKeyName(keyFieldTp: TCtKeyFieldType): string;
    function GetTitleFieldName: string;
    function IsSeqNeeded: boolean; virtual;
    function IsText: boolean; virtual;
    function IsTable: boolean; virtual;
    function IsSqlText: boolean; virtual;

    function GetPrimaryKeyField: TCtMetaField; virtual; 
    function FieldOfChildTable(ATbName: string): TCtMetaField; virtual; //获取引用子表的List字段
    function IsManyToManyLinkTable: Boolean; virtual;
    function GetOneToManyInfo(bFKsOnly: Boolean): string; virtual;
    function GetManyToManyInfo: string; virtual;

    function GenSqlEx(bCreatTb: boolean; bFK: boolean; dbType: string = '';
      dbEngine: TCtMetaDatabase = nil): string; virtual;
    function GenSql(dbType: string = ''): string; virtual;
    function GenSqlWithoutFK: string; virtual;
    function GenFKSql: string; virtual;
    function GenDropSql(dbType: string = ''): string; virtual;
    function GenDqlDmlSql(dbType: string = ''; sqlType: string = ''): string; virtual;
    function GenTestDataInsertSql(row: Integer; dbType: string = '';
      opt: string = ''; dbEngine: TCtMetaDatabase = nil): string; virtual;
    function GenSelectRandRelateKeySql(fd: TCtMetaField; maxrow: Integer; dbType: string = '';
      opt: string = ''; dbEngine: TCtMetaDatabase = nil): string; virtual;
    function GenSelectSqlNoDb(maxRowCount: integer; dbType: string): string; virtual;
    function GenSelectSql(maxRowCount: integer; dbType: string = ''; dbEngine: TCtMetaDatabase = nil): string; virtual;
   function GenSelectSqlEx(maxRowCount: integer; selFields, whereCls, groupBy, orderBy, dbType: string;
      dbEngine: TCtMetaDatabase = nil): string; virtual;   
    function GenJoinSqlWhere(bTable: TCtMetaTable; aAlias, bAlias: string; bFKsOnly: Boolean): string; virtual;

    function GetCustomConfigValue(AName: string): string; virtual;
    procedure SetCustomConfigValue(AName, AValue: string); virtual;

    function GetDemoJsonData(ARowIndex: Integer; AOpt, AFields: string): string; virtual; 
    //总的设计说明（包含字段的）
    function GetFullDesignNotes(includeEmptyFields: boolean): string; virtual;
                        
    function HasUIDesignProps: Boolean;

    property OwnerList: TCtMetaTableList read FOwnerList;

    //编号
    property ID;
    //CT编号
    property CellTreeId: integer read FCellTreeId write FCellTreeId;
    //名称
    property Name;
    //物理表名
    property RealTableName: string read GetRealTableName;
    property PhysicalName: string read FPhysicalName write FPhysicalName;
    //在界面上显示的名称
    property UIDisplayName: string read GetUIDisplayName;
    property UIDisplayText: string read FUIDisplayText write FUIDisplayText;
    //类型
    //TYPENAME为空或TABLE时是表，为TEXT时是纯文字
    //为FUNCTION、PROCEDURE、PACKAGE时为存储过程
    //为DATASQL时表示插入数据的初始化SQL
    property TypeName;
    //备注
    property Memo;
    //图形描述
    property GraphDesc: string read FGraphDesc write FGraphDesc;

    //元字段列表
    property MetaFields: TCTMetaFieldList read GetMetaFields;
    //主键字段名（只取第一个）
    property KeyFieldName: string read GetKeyFieldName;

    //描述字
    property Describe: string read GetDescribe write SetDescribe;
    //粗略描述字（仅物理名+逻辑类型）
    property SketchyDescribe: string read GetSketchyDescribe;
    //Excel字串
    property ExcelText: string read GetExcelText write SetExcelText;


    //背景色
    property BgColor: integer read FBgColor write FBgColor;
    //是否生成数据库
    property GenDatabase: boolean read FGenDatabase write FGenDatabase;
    //是否生成代码
    property GenCode: boolean read FGenCode write FGenCode; 
    //视图SQL
    property ViewSQL: string read FViewSQL write FViewSQL;  
    //列表SQL
    property ListSQL: string read FListSQL write FListSQL;
    //额外的数据库SQL
    property ExtraSQL: string read FExtraSQL write FExtraSQL;
    //前端界面逻辑
    property UILogic: string read FUILogic write FUILogic;
    //后端业务逻辑
    property BusinessLogic: string read FBusinessLogic write FBusinessLogic;
    //扩展属性
    property ExtraProps: string read FExtraProps write FExtraProps;

    //自定义配置
    property CustomConfigs: string read FCustomConfigs write FCustomConfigs;
    //脚本配置
    property ScriptRules: string read FScriptRules write FScriptRules;

    //过滤条件
    property SQLWhereClause: string read FSQLWhereClause write FSQLWhereClause;
    //排序字段 
    property SQLOrderByClause: string read FSQLOrderByClause write FSQLOrderByClause;
    //别名
    property SQLAlias: string read FSQLAlias write FSQLAlias;
    //所属分类
    property OwnerCategory: string read FOwnerCategory write FOwnerCategory;
    //分组
    property GroupName: string read FGroupName write FGroupName;
    //分区信息
    property PartitionInfo: string read FPartitionInfo write FPartitionInfo;    
    //设计说明
    property DesignNotes: string read FDesignNotes write FDesignNotes;
  end;


  TMetaObjProgressEvent = procedure(Sender: TObject; const Prompt: string;
    Cur, All: integer; var bContinue: boolean) of object;


  { CT数据表列表 }

  { TCtMetaTableList }

  TCtMetaTableList = class(TCtMetaObjectList)
  private
    FOwnerModel: TCtDataModelGraph;
    FOnObjProgress: TMetaObjProgressEvent;
    function GetItem(Index: integer): TCtMetaTable;
    procedure PutItem(Index: integer; const Value: TCtMetaTable);
  protected
    function CreateObj: TCtObject; override;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create; override;
    destructor Destroy; override;
                                    
    function ItemByName(AName: string; bCaseSensive: Boolean = False): TCtObject; override;   
    function TableByName(AName: string; bCaseSensive: Boolean = False): TCtMetaTable; virtual;
    function NewTableItem(tp: string = ''): TCtMetaTable; virtual;

    procedure LoadFromSerialer(ASerialer: TCtObjSerialer); override;
    procedure SaveToSerialer(ASerialer: TCtObjSerialer); override;

    procedure LoadFromDMLText(AText: string);

    property Items[Index: integer]: TCtMetaTable read GetItem write PutItem; default;
    property OwnerModel: TCtDataModelGraph read FOwnerModel;
    property OnObjProgress: TMetaObjProgressEvent
      read FOnObjProgress write FOnObjProgress;
  end;



  { CT连接 }
  TCtMetaLink = class(TCtMetaObject)
  end;

  { CT数据字段 }

  { TCtMetaField }

  TCtMetaField = class(TCtMetaObject)
  private
    FBusinessLogic: string;
    FDBCheck: string;
    FDesensitised: boolean;
    FDesignNotes: string;
    FExplainText: string;
    FAutoMerge: boolean;
    FAutoTrim: boolean;
    FColGroup: string;
    FColSortable: boolean;
    FDropDownSQL: string;
    FEditorProps: string;
    FExportable: boolean;
    FFixColType: TCtFieldFixColType;
    FHideOnEdit: boolean;
    FHideOnList: boolean;
    FHideOnView: boolean;
    FIsFactMeasure: boolean;
    FItemColCount: integer;      
    FFieldWeight: integer;
    FRequired: boolean;
    FSheetGroup: string;
    FShowFilterBox: boolean;
    FTestDataNullPercent: Integer;
    FTestDataRules: string;
    FTestDataType: string;
    FTextClipSize: integer;
    FUILogic: string;              
    FOldName: string;
    FIsHidden: boolean;
    procedure SetRelateTable(AValue: string);
  protected
    FValueMin: string;
    FMaxLength: integer;
    FExtraProps: string;
    FCustomConfigs: string;
    FValueFormat: string;
    FQueryable: boolean;
    FSearchable: boolean;
    FVisibility: integer;
    FValueMax: string;
    FTextAlign: TCtTextAlignment;
    FInitValue: string;
    FColWidth: integer;
    FOwnerList: TCtMetaFieldList;
    FDisplayName: string;
    FDataType: TCtFieldDataType;
    FDataTypeName: string;
    FKeyFieldType: TCtKeyFieldType;
    FRelateTable: string;
    FRelateField: string;
    FIndexType: TCtFieldIndexType;
    FIndexFields: string;
    FHint: string;
    FDefaultValue: string;
    FNullable: boolean;
    FDataLength: integer;
    FDataScale: integer;
    FUrl: string;
    FResType: string;
    FFormula: string;
    FFormulaCondition: string;
    FAggregateFun: string;
    FMeasureUnit: string;
    FValidateRule: string;
    FEditorType: string;
    FLabelText: string;
    FEditorReadOnly: boolean;
    FEditorEnabled: boolean;
    FDisplayFormat: string;
    FEditFormat: string;
    FFontName: string;
    FFontSize: double;
    FFontStyle: integer;
    FForeColor: integer;
    FBackColor: integer;
    FDropDownItems: string;
    FDropDownMode: TCtFieldDropDownMode;
    FGraphDesc: string;

    FLastGetRuleScriptModifyCount: Integer;   
    FLastGetRuleScriptResult: string;

    procedure SetDefaultValue(const Value: string);
    function GetNullable: boolean;
    function GetOwnerTable: TCtMetaTable;
    function GetNameCaption: string; override;
    //对于旧版DMJ文件，如果编辑器所有属性均未改动，可默认将 EditorEnabled 设置为TRUE
    function IsEditorUIClear: boolean;
  public
    constructor Create; override;
    destructor Destroy; override;

    //状态保存恢复接口
    procedure Reset; override;
    procedure AssignFrom(ACtObj: TCtObject); override;
    procedure LoadFromSerialer(ASerialer: TCtObjSerialer); override;
    procedure SaveToSerialer(ASerialer: TCtObjSerialer); override;


    function GetLogicDataTypeName: string;
    function GetPhyDataTypeName(dbType: string): string;
    function GetFieldTypeDesc(bPhy: boolean = False; dbType: string = ''): string;
    function GetFieldComments: string;
    function GetFieldDefaultValDesc(dbType: string = ''): string;

    function GetConstraintStr: string;
    procedure SetConstraintStr(Value: string);
    function GetConstraintStrEx(bWithKeys, bWithRelate: boolean): string;
    procedure SetConstraintStrEx(Value: string; bForce: boolean);

    function GetNullableStr(dbType: string): string;

    function GetCustomConfigValue(AName: string): string;
    procedure SetCustomConfigValue(AName, AValue: string);
    function CheckCanRenameTo(ANewName: string): Boolean;

    function HasValidComplexIndex: boolean;      
    function IsLobField(dbType: string): boolean;
    function IsFK: boolean;
    function IsPhysicalField: boolean;

    function PossibleKeyFieldType: TCtKeyFieldType;
    function CanDisplay(tp: string): boolean;
    function IsRequired: boolean;
    function GetLabelText: string;
    function PossibleEditorType: string;
    function PossibleTextAlign: TCtTextAlignment;

    function PossibleDemoDataRule: string;                                               
    function GenDemoData(ARowIndex: integer; AOpt: string; ADataSet: TDataSet): string;
    function GenDemoDataEx(ARowIndex: integer; AOpt: string; ADataSet: TDataSet): string;
    function GetSqlQuotValue(AVal, ADbType: string; ADbEngine: TCtMetaDatabase): string;
    function GetDemoItemList(bTextOnly: boolean = True): string;
    function ExtractDropDownItemsFromMemo: string;
                                                
    function CheckMaxMinDemoInt(val: integer): integer;
    function CheckMaxMinDemoFloat(val: double): double;

    function GetRelateTableObj: TCtMetaTable;
    function GetRelateTableField: TCtMetaField;
    function GetRelateTableTitleField: TCtMetaField;
    function GetRelateTableDemoJson(ARowIndex: Integer; AOpt: string): string;

    function HasUIDesignProps: Boolean;

    property OwnerList: TCtMetaFieldList read FOwnerList;
    property OwnerTable: TCtMetaTable read GetOwnerTable;

    //编号
    property ID;
    //表编号
    property RID;
    //名称
    property Name;
    //显示名，逻辑名
    property DisplayName: string read FDisplayName write FDisplayName;
    //数据类型
    property DataType: TCtFieldDataType read FDataType write FDataType;
    //数据类型
    property DataTypeName: string read FDataTypeName write FDataTypeName;
    //关键字段类型_IdPidRid...
    property KeyFieldType: TCtKeyFieldType read FKeyFieldType write FKeyFieldType;
    //关联表
    property RelateTable: string read FRelateTable write SetRelateTable;
    //关联字段
    property RelateField: string read FRelateField write FRelateField;
    //索引类型_0无1唯一2普通
    property IndexType: TCtFieldIndexType read FIndexType write FIndexType;
    //索引字段
    property IndexFields: string read FIndexFields write FIndexFields;
    //数据库检查
    property DBCheck: string read FDBCheck write FDBCheck;
    //提示
    property Hint: string read FHint write FHint;
    //备注
    property Memo;
    //缺省值
    property DefaultValue: string read FDefaultValue write SetDefaultValue;
    //是否可为空
    property Nullable: boolean read GetNullable write FNullable;
    //最大长度
    property DataLength: integer read FDataLength write FDataLength;
    //精度
    property DataScale: integer read FDataScale write FDataScale;
            
    //设计说明
    property DesignNotes: string read FDesignNotes write FDesignNotes;
    //链接
    property Url: string read FUrl write FUrl;
    //资源类型
    property ResType: string read FResType write FResType;
    //公式
    property Formula: string read FFormula write FFormula;
    //公式条件
    property FormulaCondition: string read FFormulaCondition write FFormulaCondition;
    //汇总函数
    property AggregateFun: string read FAggregateFun write FAggregateFun;
    //计量单位
    property MeasureUnit: string read FMeasureUnit write FMeasureUnit;
    //字段值检查规则
    property ValidateRule: string read FValidateRule write FValidateRule;
    //编辑器类型
    property EditorType: string read FEditorType write FEditorType;
    //标签文字
    property LabelText: string read FLabelText write FLabelText;
    //说明文字
    property ExplainText: string read FExplainText write FExplainText;
    //编辑器是否只读
    property EditorReadOnly: boolean read FEditorReadOnly write FEditorReadOnly;
    //编辑器是否激活
    property EditorEnabled: boolean read FEditorEnabled write FEditorEnabled;
    //是否隐藏
    property IsHidden: boolean read FIsHidden write FIsHidden;
    //是否在列表中默认隐藏（可手工选择显示）
    property HideOnList: boolean read FHideOnList write FHideOnList;
    //是否编辑时隐藏
    property HideOnEdit: boolean read FHideOnEdit write FHideOnEdit;
    //是否查看（只读）时隐藏
    property HideOnView: boolean read FHideOnView write FHideOnView;
    //显示格式
    property DisplayFormat: string read FDisplayFormat write FDisplayFormat;
    //输入格式
    property EditFormat: string read FEditFormat write FEditFormat;
    //编辑器其它属性
    property EditorProps: string read FEditorProps write FEditorProps;
    //表单分组
    property SheetGroup: string read FSheetGroup write FSheetGroup;
    //列表头分组
    property ColGroup: string read FColGroup write FColGroup;
    //冻结列类型
    property FixColType: TCtFieldFixColType read FFixColType write FFixColType;
    //表格中自动合并相同列值
    property AutoMerge: boolean read FAutoMerge write FAutoMerge;
    //表格中显示过滤钮
    property ShowFilterBox: boolean read FShowFilterBox write FShowFilterBox;
    //表格中显示排序钮
    property ColSortable: boolean read FColSortable write FColSortable;

    //字体名称
    property FontName: string read FFontName write FFontName;
    //字体大小
    property FontSize: double read FFontSize write FFontSize;
    //字体样式
    property FontStyle: integer read FFontStyle write FFontStyle;
    //前景颜色
    property ForeColor: integer read FForeColor write FForeColor;
    //背景颜色
    property BackColor: integer read FBackColor write FBackColor;
    //下拉列表
    property DropDownItems: string read FDropDownItems write FDropDownItems;
    //下拉SQL
    property DropDownSQL: string read FDropDownSQL write FDropDownSQL;
    //下拉模式_0无1选择2编辑3添加
    property DropDownMode: TCtFieldDropDownMode read FDropDownMode write FDropDownMode;
    //每行分几列（对复选列表、单选列表、按钮列表等有效）
    property ItemColCount: integer read FItemColCount write FItemColCount;
    //DML图形描述
    property GraphDesc: string read FGraphDesc write FGraphDesc;
                
    //字段权重（0正常，大于0高亮，小于0灰色，小于-9隐藏）
    property FieldWeight: integer read FFieldWeight write FFieldWeight;
    //显示级别
    //0自动、1摘要、2列表、3表单
    property Visibility: integer read FVisibility write FVisibility;
    //文字对齐
    property TextAlign: TCtTextAlignment read FTextAlign write FTextAlign;
    //列宽
    property ColWidth: integer read FColWidth write FColWidth;
    //最大长度
    property MaxLength: integer read FMaxLength write FMaxLength;
    //裁剪内容长度（多行文本，显示“更多”按钮）
    property TextClipSize: integer read FTextClipSize write FTextClipSize;
    //是否可搜索
    property Searchable: boolean read FSearchable write FSearchable;
    //是否可查询
    property Queryable: boolean read FQueryable write FQueryable;   
    //是否可导出
    property Exportable: boolean read FExportable write FExportable;
    //是否为事实度量值
    property IsFactMeasure: boolean read FIsFactMeasure write FIsFactMeasure;

    //初始值
    property InitValue: string read FInitValue write FInitValue;
    //值格式类型
    property ValueFormat: string read FValueFormat write FValueFormat;
    //必填
    property Required: boolean read FRequired write FRequired;
    //最小值
    property ValueMin: string read FValueMin write FValueMin;
    //最大值
    property ValueMax: string read FValueMax write FValueMax;
    //是否自动去除文字两头空格
    property AutoTrim: boolean read FAutoTrim write FAutoTrim;
    //是否脱敏
    property Desensitised: boolean read FDesensitised write FDesensitised;
    //生成测试数据类型
    property TestDataType: string read FTestDataType write FTestDataType;
    //生成测试数据规则
    property TestDataRules: string read FTestDataRules write FTestDataRules;  
    //生成测试空值百分比（为0为无空值）
    property TestDataNullPercent: Integer read FTestDataNullPercent write FTestDataNullPercent;
    //前端界面逻辑
    property UILogic: string read FUILogic write FUILogic;
    //后端业务逻辑
    property BusinessLogic: string read FBusinessLogic write FBusinessLogic;
    //扩展属性
    property ExtraProps: string read FExtraProps write FExtraProps;
    //自定义配置
    property CustomConfigs: string read FCustomConfigs write FCustomConfigs;
    //旧名称（修改字段名时使用，以便更新所有引用字段）
    property OldName: string read FOldName write FOldName;
  end;

  { CT数据字段列表 }

  { TCtMetaFieldList }

  TCtMetaFieldList = class(TCtObjectList)
  private
    function GetItem(Index: integer): TCtMetaField;
    procedure PutItem(Index: integer; const Value: TCtMetaField);
  protected
    FOwnerTable: TCtMetaTable;
    function CreateObj: TCtObject; override;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function NewMetaField: TCtMetaField;

    function FieldByName(AName: string): TCtMetaField;
    function FieldByDisplayName(ADispName: string): TCtMetaField;
    function FieldByLabelName(ALbName: string): TCtMetaField;
    procedure SyncFieldsFrom(ACtFlds: TCtMetaFieldList;
      tmpList: TCtMetaFieldList); virtual;

    property OwnerTable: TCtMetaTable read FOwnerTable;
    property Items[Index: integer]: TCtMetaField read GetItem write PutItem; default;
  end;

  TCtDMGOptions = record
    //GenFKIndexesSQL: boolean;
  end;

  { 数据模型图 }

  { TCtDataModelGraph }

  TCtDataModelGraph = class(TCtMetaObject)
  private
    FOwnerList: TCtDataModelGraphList;
    procedure SetConfigStr(const Value: string);
    function GetDisplayName: string;
  protected
    //FID         : Integer;
    //FName       : String;
    FGraphWidth: integer;
    FGraphHeight: integer;
    FDefDbEngine: string;
    FDbConnectStr: string;
    FConfigStr: string;
    FTables: TCtMetaTableList;
  public
    CtDMGOptions: TCtDMGOptions;

    constructor Create; override;
    destructor Destroy; override;

    procedure CheckDMGOptions;

    //CT对象相关接口
    procedure Reset; override;
    procedure AssignFrom(ACtObj: TCtObject); override;
    procedure LoadFromSerialer(ASerialer: TCtObjSerialer); override;
    procedure SaveToSerialer(ASerialer: TCtObjSerialer); override;

    function IsHuge: boolean;    
    function CheckCanRenameTo(ANewName: string): Boolean;

    property ID; //       : Integer       read FID           write FID          ;
    property Name; //     : String        read FName         write FName        ;
    //显示名称
    property DisplayName: string read GetDisplayName;
    //图形区宽度
    property GraphWidth: integer read FGraphWidth write FGraphWidth;
    //图形区高度
    property GraphHeight: integer read FGraphHeight write FGraphHeight;
    //缺省数据连接
    property DefDbEngine: string read FDefDbEngine write FDefDbEngine;
    //数据连接名
    property DbConnectStr: string read FDbConnectStr write FDbConnectStr;
    //选项设置串
    property ConfigStr: string read FConfigStr write SetConfigStr;
    //数据表
    property Tables: TCtMetaTableList read FTables write FTables;

    property OwnerList: TCtDataModelGraphList read FOwnerList;
  end;

  { 数据模型图列表 }

  { TCtDataModelGraphList }

  TCtDataModelGraphList = class(TCtObjectList)
  private
    FCurDataModel: TCtDataModelGraph;
    FOnObjProgress: TMetaObjProgressEvent;
    FSyncingTbProp: boolean;
    function GetCurDataModel: TCtDataModelGraph;
    function GetItem(Index: integer): TCtDataModelGraph;
    procedure PutItem(Index: integer; const Value: TCtDataModelGraph);
  protected
    function CreateObj: TCtObject; override;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public       
    constructor Create; override;
    destructor Destroy; override;

    procedure LoadFromSerialer(ASerialer: TCtObjSerialer); override;
    procedure SaveToSerialer(ASerialer: TCtObjSerialer); override;

    procedure LoadFromFile(fn: string); virtual;
    procedure SaveToFile(fn: string); virtual;

    function GetAllTableCount: integer;
    function GetAllSubItemCount: integer;
    function IsHuge: boolean;
    function GetTableOfName(AName: string): TCtMetaTable;

    //修改过表后，同步到所有同名对象上
    procedure SyncTableProps(ATb: TCtMetaTable); virtual;
    function HasSameNameTables(ATb: TCtMetaTable; AName: string): boolean; virtual;
    function GetSameNameTableCount(ATb: TCtMetaTable): integer; virtual;
    function RenameSameNameTables(ATb: TCtMetaTable; AName: string): integer; virtual;
    //修改表名后修改相关外键名
    procedure DoOnTableRename(ATb: TCtMetaTable; AOldName, ANewName: string); virtual;

    procedure SortByOrderNo; override;
    procedure Pack; override;
    function TableCount: integer;
    function NewModelItem: TCtDataModelGraph;
    property CurDataModel: TCtDataModelGraph read GetCurDataModel write FCurDataModel;
    property Items[Index: integer]: TCtDataModelGraph read GetItem write PutItem;
      default;
    property OnObjProgress: TMetaObjProgressEvent
      read FOnObjProgress write FOnObjProgress;
  end;

  { TCtMetaDatabase }

  TCtMetaDatabase = class
  private
  protected
    FConnected: boolean;
    FDatabase: string;
    FPassword: string;
    FUser: string;
    FEngineType: string;
    FDbSchema: string;         
    FExtraOpt: string;
    function GetDbSchema: string; virtual;
    procedure SetDbSchema(const Value: string); virtual;
    function GetConnected: boolean; virtual;
    procedure SetConnected(const Value: boolean); virtual;  
    function GetOrigEngineType: string; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function ShowDBConfig(AHandle: THandle): boolean; virtual;

    //获取唯一标识ID（用户名@连接类型_HASH值）
    function GetIdentStr: string;

    //库、用户、对象列表，一行一个
    function GetDbNames: string; virtual;
    function GetDbUsers: string; virtual;
    function GetDbObjs(ADbUser: string): TStrings; virtual;

    function GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject; virtual;
    //生成普通SQL事件 是否生成创建表SQL、是否生成创建约束SQL、默认生成的SQL结果、数据库类型、选项，返回自定义结果SQL
    function OnGenTableSql(tb: TCtMetaTable; bCreateTb, bCreateConstrains: boolean;
      defRes, dbType, options: string): string; virtual;
    //生成数据库升级SQL。sqlType: 0全部 1不含外键 2外键
    function GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string; virtual;
    procedure ExecSql(ASql: string); virtual;
    //打开SQL表，OP可为空，含[FORWARD_CURSOR]表示打开为单向游标
    function OpenTable(ASql, op: string): TDataSet; virtual;
    //执行命令
    function ExecCmd(ACmd, AParam1, AParam2: string): string; virtual;
    function ObjectExists(ADbUser, AObjName: string): boolean; virtual;
    function IsDiffField(Fd1, Fd2: TCtMetaField): boolean; virtual;
  public
    property OrigEngineType: string read GetOrigEngineType; //原始连接类型（有些连接如HTTP的EngineType会变）
    property EngineType: string read FEngineType;
    property Database: string read FDatabase write FDatabase;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
    property DbSchema: string read GetDbSchema write SetDbSchema;
    property Connected: boolean read GetConnected write SetConnected;
    property ExtraOpt: string read FExtraOpt write FExtraOpt;
  end;

  TCtMetaDatabaseClass = class of TCtMetaDatabase;

  TCtMetaDBReg = record
    DbEngineType: string;
    DbClass: TCtMetaDatabaseClass;
    DbImpl: TCtMetaDatabase;
  end;
  PCtMetaDBReg = ^TCtMetaDBReg;

                                            
function IsValidTableName(AName: string; bPrompt: boolean): boolean;
function CheckCanRenameTable(ATb: TCtMetaTable; AName: string; bAbort: boolean): boolean;
function HasSameNameTables(ATb: TCtMetaTable; AName: string): boolean;

//检查是否可以进入编辑模式
function IsEditingMeta: boolean;
procedure CheckCanEditMeta;
procedure EditMetaAcquire(AObj: TCtMetaObject; AForm: TWinControl);
procedure EditMetaRelease(AObj: TCtMetaObject; AForm: TWinControl);
procedure EditMetaForceRelease;
function GetMetaEditingWin: TWinControl;

procedure BeginTbPropUpdate(Tb: TCtMetaTable);
procedure EndTbPropUpdate(Tb: TCtMetaTable);
procedure DoTablePropsChanged(Tb: TCtMetaTable);

procedure AddCtMetaDBReg(EngineType: string; DbClass: TCtMetaDatabaseClass);
function GetCtMetaDBReg(EngineType: string): PCtMetaDBReg;
procedure RemoveCtMetaDBReg(EngineType: string);
procedure ClearCtMetaDbReg(bFreeConns: boolean);

function GetCtFieldDataTypeOfName(AName: string): TCtFieldDataType;
function GetCtFieldDataTypeOfAlias(AName: string): TCtFieldDataType;
function GetPossibleCtFieldTypeOfName(AName: string): TCtFieldDataType;

function GetCtFieldDataTypeNameList(ADbType: string): TCtFieldDataTypeNames;
function GetCtFieldPhyTypeName(ADbType: string; AFieldType: TCtFieldDataType;
  ADataLen: integer): string;

function CheckStringMaxLen(DbType, custTpName: string; var res: string; len: integer): boolean;
function CheckCustDataTypeReplaces(Str: string): string;

function IsReservedKeyworkd(str: string): boolean;    
function IsSymbolName(AName: string): boolean;

function GetDbQuotName(AName, dbType: string): string;
function GetIdxName(ATbn, AFieldName: string): string;
function RemoveIdxNamePrefx(idxName, tbName: string): string;

function MaybeSameStr(Str1, Str2: string): boolean;
function ReplaceSingleQuotmark(val: string): string;

function NeedGenFKIndexesSQL(tb: TCtMetaTable): boolean;

function RemoveCtSQLComment(const ASQL: string; KeepHints: boolean = False): string;
                                                     
function GetDbQuotString(AStr, dbType: string): string;
function DBSqlStringToDateTime(AStr, ADbType: string): string;

procedure EzdmlMenuActExecuteEvt(actName: string; Sender: TObject = nil);

function GetConfigFile_OfLang(fn: string): string;

procedure InitCtChnNames;

function IsTbPropDefViewMode: boolean;


var
  Proc_ShowCtTableProp: function(ATb: TCtMetaTable; bReadOnly, bIsNew: boolean): boolean;
  Proc_ShowCtFieldProp: function(AField: TCtMetaField; bReadOnly: boolean): boolean;
  Proc_ShowCtTableOfField: function(ATb: TCtMetaTable; AField: TCtMetaField;
  bReadOnly, bIsNew, bViewModal: boolean): boolean;
  Proc_ShowCtDmlSearch: function(dm: TCtDataModelGraphList;
  res: TCtMetaObjectList): boolean;
  Proc_GetLastCtDbType: function: string;
  Proc_ExecCtDbLogon: function(DbType, database, username, password: string;
  bSavePwd, bAutoLogin, bShowDialog: boolean; opt: string): string;
  Proc_ExecSql: function(sql, opts: string): TDataSet;
  Proc_JsonPropProc: function(AJsonStr, AName, AValue: string; bRead: boolean): string;
  Proc_CtObjToJsonStr: function(ACtObj: TCtMetaObject): string; //added by huz 20210214
  Proc_ReadCtObjFromJsonStr: function(ACtObj: TCtMetaObject; AJsonStr: string): boolean; 
  Proc_GetTableDemoDataJson: function(ATb: TCtMetaTable; ARowIndex: Integer; AOpt, AFields: string): string;
  Proc_GenDemoData: function(AField: TCtMetaField; ARule, ADef: string;
  ARowIndex: integer; AOpt: string; ADataSet: TDataSet): string;

  CtMetaDBRegs: array of TCtMetaDBReg;
  CtCurMetaDbConn: TCtMetaDatabase;
  CtCurMetaDbName: string;
  CtCustFieldTypeDefs: array of string;
  CtCustFieldTypeList: array of string;
  CtCustFieldTypeDefList: array of string;
  CtCustDataTypeReplaces: array of string;
  CtTbNamePrefixDefs: array of string;
  CtCustFieldDataGenRules: array of string;
  FGlobeDataModelList: TCtDataModelGraphList;   
  G_LastMetaDbSchema: string;
  G_CheckForUpdates: boolean;
  G_CreateSeqForOracle: boolean;
  G_GenSqlSketchMode: boolean;
  G_BackupBeforeAlterColumn: boolean;
  G_QuotReservedNames: boolean;
  G_QuotAllNames: boolean;
  G_LogicNamesForTableData: boolean;
  G_MaxRowCountForTableData: integer;
  G_HugeModeTableCount: integer = 500;
  G_WriteConstraintToDescribeStr: boolean;
  G_FieldGridShowLines: boolean;
  G_AddColCommentToCreateTbSql: boolean;
  G_CreateForeignkeys: boolean;
  G_CreateIndexForForeignkey: boolean;
  G_HiveVersion: Integer;             
  G_MysqlVersion: Integer;
  G_RetainAfterCommit: boolean;
  G_EnableCustomPropUI: boolean;
  G_CustomPropUICaption: string;  
  G_EnableAdvTbProp: boolean;
  G_EnableTbPropGenerate: boolean;
  G_EnableTbPropRelations: boolean;
  G_EnableTbPropData: boolean;
  G_EnableTbPropUIDesign: boolean;
  G_Reserved_Keywords: TStrings;
  G_TableDialogViewModeByDefault: boolean;
  CtFieldTextColor_Id: TColor = clFuchsia;
  CtFieldTextColor_Rid: TColor = clBlue;   
  CtFieldTextColor_Low: TColor = clGray;
  CtFieldTextColor_Lowest: TColor = clSilver;
  G_FieldItemListKeys: TStrings;
  G_BigIntForIntKeys: boolean = true;

  GProc_OnEzdmlGenTbSqlEvent: TOnEzdmlGenTbSqlEvent;
  GProc_OnEzdmlGenDbSqlEvent: TOnEzdmlGenDbSqlEvent;
  GProc_OnEzdmlGenFieldTypeDescEvent: TOnEzdmlGenFieldTypeDescEvent;
  GProc_OnEzdmlGenAlterFieldEvent: TOnEzdmlGenAlterFieldEvent;    
  GProc_OnEzdmlGenDataSqlEvent: TOnEzdmlGenDataSqlEvent;
  GProc_OnEzdmlCmdEvent: TOnEzdmlCmdEvent;

  DEF_CTMETAFIELD_DATATYPE_NAMES_CHN: TCtFieldDataTypeNames;
  DEF_CTMETAFIELD_CONSTRAINT_STR_CHN: array[0..9] of string;
  DEF_CTMETAFIELD_KEYFIELD_NAMES_CHN: array[TCtKeyFieldType] of string;
  DEF_CTMETAFIELD_KEYFIELD_NAMES_POSSIBLE: array[TCtKeyFieldType] of string;

  G_WMZ_CUSTCMD_Object: TObject;
  G_WMZ_CUSTCMD_WndRect: TRect;

const
  DEF_VAL_auto_increment = '{auto_increment}';
  DEF_SQLTEXT_MARK = '/*[SQL]*/';

  DEF_CTMETAFIELD_DATATYPE_NAMES_ENG: TCtFieldDataTypeNames = (
    'Unknow',
    'String',
    'Integer',
    'Float',
    'Date',
    'Bool',
    'Enum',
    'Blob',
    'Object',
    'Calculate',
    'List',
    'Function',
    'Event',
    'Other'
    );
  DEF_CTMETAFIELD_DATATYPE_NAMES_ORACLE: TCtFieldDataTypeNames = (
    '[UNKNOWN]',
    'VARCHAR2',
    'NUMBER',
    'NUMBER',
    'DATE',
    'NUMBER(1)',
    'NUMBER(2)',
    'BLOB',
    'OBJECT',
    'CALCULATE',
    'LIST',
    'FUNCTION',
    'EVENT',
    '[OTHER]'
    );
  DEF_CTMETAFIELD_DATATYPE_NAMES_MYSQL: TCtFieldDataTypeNames = (
    '[UNKNOWN]',
    'VARCHAR',
    'INT',
    'DOUBLE',
    'DATETIME',
    'BIT',
    'TINYINT',
    'LONGBLOB',
    'OBJECT',
    'CALCULATE',
    'LIST',
    'FUNCTION',
    'EVENT',
    '[OTHER]'
    );
  DEF_CTMETAFIELD_DATATYPE_NAMES_SQLSERVER: TCtFieldDataTypeNames = (
    '[UNKNOWN]',
    'VARCHAR',
    'INT',
    'NUMERIC',
    'DATETIME',
    'BIT',
    'TINYINT',
    'IMAGE',
    'OBJECT',
    'CALCULATE',
    'LIST',
    'FUNCTION',
    'EVENT',
    '[OTHER]'
    );
  DEF_CTMETAFIELD_DATATYPE_NAMES_SQLITE: TCtFieldDataTypeNames = (
    '[UNKNOWN]',
    'TEXT',
    'INTEGER',
    'NUMERIC',
    'DATETIME',
    'BOOLEAN',
    'TINYINT',
    'BLOB',
    'OBJECT',
    'CALCULATE',
    'LIST',
    'FUNCTION',
    'EVENT',
    '[OTHER]'
    );
  DEF_CTMETAFIELD_DATATYPE_NAMES_POSTGRESQL: TCtFieldDataTypeNames = (
    '[UNKNOWN]',
    'varchar',
    'integer',
    'numeric',
    'timestamp',
    'boolean',
    'smallint',
    'bytea',
    'OBJECT',
    'CALCULATE',
    'LIST',
    'FUNCTION',
    'EVENT',
    '[OTHER]'
    );          
  DEF_CTMETAFIELD_DATATYPE_NAMES_HIVE: TCtFieldDataTypeNames = (
    '[UNKNOWN]',
    'string',
    'int',
    'double',
    'timestamp',
    'boolean',
    'tinyint',
    'binary',
    'map',
    'CALCULATE',
    'array',
    'FUNCTION',
    'EVENT',
    '[OTHER]'
    );
  DEF_CTMETAFIELD_DATATYPE_NAMES_STD: TCtFieldDataTypeNames = (
    '[UNKNOWN]',
    'VARCHAR',
    'INTEGER',
    'NUMERIC',
    'DATETIME',
    'BIT',
    'TINYINT',
    'BLOB',
    'OBJECT',
    'CALCULATE',
    'LIST',
    'FUNCTION',
    'EVENT',
    '[OTHER]'
    );
  DEF_CTMETAFIELD_DATATYPE_NAMES_A: TCtFieldDataTypeNames = (
    'U',
    'S',
    'I',
    'F',
    'D',
    'BO',
    'E',
    'BL',
    'O',
    'C',
    'L',
    'FU',
    'EV',
    'X'
    );
  DEF_CTMETAFIELD_DATATYPE_NAMES_DOATYPE: TCtFieldDataTypeNames = (
    'otString',
    'otString',
    'otInteger',
    'otFloat',
    'otDate',
    'otBoolean',
    'otInteger',
    'otBLOB',
    'otObject',
    'CALCULATE',
    'otObject',
    'FUNCTION',
    'EVENT',
    'OTHER'
    );

  DEF_CTMETAFIELD_DATATYPE_NAMES_ALIAS: TCtFieldDataTypeNames = (
    '',
    'string,char,nchar,varchar,nvarchar,longvarchar,varchar2,nvarchar2,text,ntext,clob,nclob,long,tinytext,mediumtext,longtext,str,guid,uuid,uniqueidentifier,字符,文本,文字',
    'integer,smallint,int,bigint,mediumint,seq,seri,整数,整形,自然数,序列,自增',
    'float,double,real,decimal,number,numeric,money,smallmoney,dec,fixed,浮点,精度,实数,货币,金额,小数',
    'datetime,date,time,timestamp,year,smalldatetime,日期,时间,日历',
    'boolean,bit,bool,布尔,真假',
    'enum,set,tinyint,枚举,集合',
    'blob,bfile,binary,varbinary,longvarbinary,image,raw,longraw,tinyblob,mediumblob,longblob,文件,二进制,图像,原始',
    'geoloc,mdsys.geoloc,xmltype,json,对象,复杂',
    '',
    '',
    '',
    '',
    ''
    );

  DEF_CTMETAFIELD_DATATYPE_NAMES_NULL: TCtFieldDataTypeNames = (
    '',
    'char,nchar,varchar,nvarchar,longvarchar,varchar2,nvarchar2,text,ntext,clob,nclob,long,tinytext,mediumtext,longtext',
    'integer,smallint,int,bigint,mediumint',
    'float,double,real,decimal,number,numeric,money,smallmoney,fixed',
    'datetime,date,time,timestamp,year,smalldatetime',
    'boolean,bit,bool',
    'enum,set,tinyint',
    'blob,bfile,binary,varbinary,longvarbinary,image,raw,longraw,tinyblob,mediumblob,longblob',
    '',
    '',
    '',
    '',
    '',
    ''
    );

  DEF_CTMETAFIELD_KEYFIELD_NAMES_ENG: array[TCtKeyFieldType] of string =
    (
    'Normal',
    'Id',
    'Pid',
    'Rid',
    'Name',
    'Caption',
    'Memo',
    'TypeName',
    'OrgId',
    'Period',
    'CreatorId',
    'CreatorName',
    'CreateDate',
    'ModifierId',
    'ModifierName',
    'ModifyDate',
    'VersionNo',
    'HistoryId',
    'LockStamp',
    'InsNo',
    'ProcID',
    'URL',
    'DataLevel',
    'DataStatus',
    'OrderNo',
    'Others');


  DEF_CTMETAFIELD_CONSTRAINT_STR_ENG: array[0..9] of string =
    (
    '',
    'NotNull',
    'PK',
    'FK',
    'UniqueIndex',
    'NormalIndex',
    'Default',
    'AutoInc',
    'Relation',
    'TypeName'
    );

  DEF_CTMETAFIELD_KEYFIELD_TYPES: array[TCtKeyFieldType] of TCtFieldDataType =
    (
    cfdtOther, //普通
    cfdtInteger, //编号
    cfdtInteger, //父编号
    cfdtInteger, //关联编号
    cfdtString, //名称
    cfdtString, //标题
    cfdtString, //注释
    cfdtString, //类名
    cfdtInteger, //组织机构编号
    cfdtString, //期号
    cfdtInteger, //创建人编号
    cfdtString, //创建人姓名
    cfdtDate, //创建日期
    cfdtInteger, //修改人编号
    cfdtString, //修改人姓名
    cfdtDate, //修改日期
    cfdtInteger, //版本号
    cfdtInteger, //历史编号
    cfdtString, //锁定状态
    cfdtInteger, //工作流编号
    cfdtInteger, //工作流进程号
    cfdtString, //超链接
    cfdtEnum, //状态
    cfdtEnum, //状态
    cfdtFloat, //排序号
    cfdtString //其它
    );
  DEF_TEXT_CLOB_LEN = 1000000;
  DEF_RESERVED_KEYWORDS =
    ',action,add,aggregate,all,alter,after,and,as,asc,avg,avg_row_length,auto_increment,between,'
    +
    'bigint,bit,binary,blob,bool,both,by,cascade,case,char,character,change,check,checksum,column,'
    +
    'columns,comment,constraint,create,cross,current_date,current_time,current_timestamp,data,'
    +
    'database,databases,date,datetime,day,day_hour,day_minute,day_second,dayofmonth,dayofweek,'
    +
    'dayofyear,dec,decimal,default,delayed,delay_key_write,delete,desc,describe,distinct,distinctrow,'
    +
    'double,drop,end,else,escape,escaped,enclosed,enum,explain,exists,fields,file,first,float,float4,'
    +
    'float8,flush,foreign,from,for,full,function,global,grant,grants,group,having,heap,high_priority,'
    +
    'hour,hour_minute,hour_second,hosts,identified,ignore,in,index,infile,inner,insert,insert_id,int,'
    +
    'integer,interval,int1,int2,int3,int4,int8,into,if,is,isam,join,key,keys,kill,last_insert_id,'
    +
    'leading,left,length,like,lines,limit,load,local,lock,logs,long,longblob,longtext,low_priority,'
    +
    'max,max_rows,match,mediumblob,mediumtext,mediumint,middleint,min_rows,minute,minute_second,'
    +
    'modify,month,monthname,myisam,natural,numeric,no,not,null,on,optimize,option,optionally,or,order,'
    +
    'outer,outfile,pack_keys,partial,password,precision,primary,procedure,process,processlist,'
    +
    'privileges,read,real,references,reload,regexp,rename,replace,restrict,returns,revoke,rlike,row,'
    +
    'rows,second,select,set,show,shutdown,smallint,soname,sql_big_tables,sql_big_selects,'
    +
    'sql_low_priority_updates,sql_log_off,sql_log_update,sql_select_limit,sql_small_result,'
    +
    'sql_big_result,sql_warnings,straight_join,starting,status,string,table,tables,temporary,'
    +
    'terminated,text,then,time,timestamp,tinyblob,tinytext,tinyint,trailing,to,type,use,using,unique,'
    +
    'unlock,unsigned,update,usage,values,varchar,variables,varying,varbinary,with,write,when,where,'
    +
    'year,year_month,zerofill,';


implementation

uses
  dmlstrs, Forms, WindowFuncs;

var
  TbPropUpdateCounter: integer;

function RemoveCtSQLComment(const ASQL: string; KeepHints: boolean): string;
var
  i, l: integer;
  c1, c2, c3, Mode: char;
begin
  Result := '';
  l := Length(ASQL);
  i := 1;
  Mode := 'N';
  while i <= l do
  begin
    c1 := ASQL[i];
    if c1 = '''' then
    begin
      if Mode = 'Q' then
        Mode := 'N'
      else if Mode = 'N' then
        Mode := 'Q';
    end;
    if Mode = 'Q' then
      Result := Result + c1;
    if i < l then
      c2 := ASQL[i + 1]
    else
      c2 := #0;
    if i + 1 < l then
      c3 := ASQL[i + 2]
    else
      c3 := #0;
    if Mode = 'N' then
    begin
      if (c1 = '/') and (c2 = '*') then
        Mode := '*';
      if (c1 = '-') and (c2 = '-') then
        Mode := '-';
      if KeepHints and (Mode <> 'N') and (c3 = '+') then
        Mode := 'N';
      if Mode = 'N' then
        Result := Result + c1;
    end;
    if ((Mode = '*') and (c1 = '*') and (c2 = '/')) or
      ((Mode = '-') and (c1 = #13) and (c2 = #10)) then
    begin
      Mode := 'N';
      Inc(i);
    end;
    Inc(i);
  end;
  Result := Trim(Result);
end;
            
function DBSqlStringToDateTime(AStr, ADbType: string): string;
begin
  Result := AStr;
  if Trim(Result)='' then
    Exit;
  if LowerCase(Trim(Result))='null' then
    Exit;
  if Pos('/', Result)>0 then
    Result := StringReplace(Result, '/', '-', [rfReplaceAll]);
  if ADbType = 'ORACLE' then
  begin
    if Pos(':', Result) = 0 then
      Result := 'to_date(''' + Result + ''',''yyyy-mm-dd'')'
    else
      Result := 'to_date(''' + Result + ''',''yyyy-mm-dd HH24:mi:ss'')';
  end
  else if ADbType = 'SQLSERVER' then
  begin
    if Pos(':', Result) = 0 then
      Result := 'convert(datetime,''' + Result + ''',23)'
    else
      Result := 'convert(datetime,''' + Result + ''',120)';
  end
  else if ADbType = 'MYSQL' then
  begin
    if Pos(':', Result) = 0 then
      Result := 'STR_TO_DATE(''' + Result + ''',''%Y-%m-%d'')'
    else
      Result := 'STR_TO_DATE(''' + Result + ''',''%Y-%m-%d %H:%i:%s'')';
  end
  else if ADbType = 'POSTGRESQL' then
  begin
    if Pos(':', Result) = 0 then
      Result := 'to_timestamp(''' + Result + ''',''yyyy-MM-dd'')'
    else
      Result := 'to_timestamp(''' + Result + ''',''yyyy-MM-dd HH24:mi:ss'')';
  end       
  else if ADbType = 'H2' then
  begin
    if Pos(':', Result) = 0 then
      Result := 'parsedatetime(''' + Result + ''',''yyyy-MM-dd'')'
    else
      Result := 'parsedatetime(''' + Result + ''',''yyyy-MM-dd hh:mm:ss'')';
  end
  else if ADbType = 'SQLITE' then
  begin
    Result := '''' + Result + '''';
  end
  else
  begin
    Result := '''' + Result + '''';
  end;
end;

procedure EzdmlMenuActExecuteEvt(actName: string; Sender: TObject);
begin
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('MENU_ACTION', actName, '', Sender, nil);
  end;
end;

function GetConfigFile_OfLang(fn: string): string;
var
  fp, ext, S: string;
begin
  Result := fn;
  if Result = '' then
    Exit;

  ext := ExtractFileExt(fn);
  fp := ChangeFileExt(fn, '');
  if not FileExists(Result) then
    if FileExists(fp + '_en' + ext) then
      Result := fp + '_en' + ext;

  if LangIsEnglish then
  begin
    if FileExists(fp + '_en' + ext) then
      Result := fp + '_en' + ext;
  end
  else
  begin
    S := '_' + LowerCase(GetEzdmlLang);
    if FileExists(fp + S + ext) then
      Result := fp + S + ext;
  end;
end;

function IsTbPropDefViewMode: boolean;
begin
  Result := G_TableDialogViewModeByDefault;
  if (GetKeyState(VK_SHIFT) and $80) <> 0 then
    Result := not Result;
  if IsEditingMeta then
    Result := True;
end;

procedure InitCtChnNames;
var
  t: TCtFieldDataType;
  I, n: integer;
  k: TCtKeyFieldType;
  ss: TStringList;
  S: string;
begin
  ss := TStringList.Create;
  try
    ss.Text := srDmlDataTypeNames;
    N := 0;
    for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
    begin
      if N < ss.Count then
        S := Trim(ss[N])
      else
        S := '';
      if S <> '' then
        DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t] := S
      else
        DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t] := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t];
      Inc(N);
    end;

    ss.Text := srDmlConstraintNames;
    N := 0;
    for I := 0 to High(DEF_CTMETAFIELD_CONSTRAINT_STR_CHN) do
    begin
      if N < ss.Count then
        S := Trim(ss[N])
      else
        S := '';
      if S <> '' then
        DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[I] := S
      else
        DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[I] := DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[I];
      Inc(N);
    end;

    ss.Text := srDmlKeyFieldNames;
    N := 0;
    for k := Low(TCtKeyFieldType) to High(TCtKeyFieldType) do
    begin
      if N < ss.Count then
        S := Trim(ss[N])
      else
        S := '';
      if S <> '' then
        DEF_CTMETAFIELD_KEYFIELD_NAMES_CHN[k] := S
      else
        DEF_CTMETAFIELD_KEYFIELD_NAMES_CHN[k] := DEF_CTMETAFIELD_KEYFIELD_NAMES_ENG[k];
      Inc(N);
    end;

    ss.Text := srDmlPossibleKeyFieldNames;
    N := 0;
    for k := Low(TCtKeyFieldType) to High(TCtKeyFieldType) do
    begin
      if N < ss.Count then
        S := Trim(ss[N])
      else
        S := '';
      DEF_CTMETAFIELD_KEYFIELD_NAMES_POSSIBLE[k] := S;
      Inc(N);
    end;
  finally
    ss.Free;
  end;
end;

procedure DoTablePropsChanged(Tb: TCtMetaTable);
begin
  if Tb = nil then
    Exit;    
  Tb.SetCtObjModified(True);
  if TbPropUpdateCounter <> 0 then
    Exit;
  FGlobeDataModelList.SyncTableProps(Tb);
end;


function IsValidTableName(AName: string; bPrompt: boolean): boolean;  
var
  S: string;
begin     
  Result := True;
  if (Pos('.', AName)>0) or (Pos(' ', AName)>0)
     or (Pos('/', AName)>0) or (Pos('\', AName)>0)
     or (Pos('(', AName)>0) or (Pos(')', AName)>0) then
  begin
    S := Format(srInvalidTbNameError, [AName]);
    if bPrompt then
      Application.MessageBox(PChar(S), PChar(Application.Title),
        MB_OK or MB_ICONERROR);
    Result := False;
  end;
end;

function CheckCanRenameTable(ATb: TCtMetaTable; AName: string; bAbort: boolean): boolean;
var
  S: string;
begin
  Result := True;
  if UpperCase(ATb.Name) = UpperCase(AName) then
    Exit;
  if not IsValidTableName(AName, True) then
  begin
    Result := False;
    if bAbort then
      Abort;
    Exit;
  end;
  if HasSameNameTables(ATb, AName) then
  begin
    S := Format(srRenameToExistsError, [AName]);
    Application.MessageBox(PChar(S), PChar(Application.Title),
      MB_OK or MB_ICONERROR);
    Result := False;
    if bAbort then
      Abort;
    Exit;
    {
    S := Format(srRenameToDulObjleWarning, [AName]);
    case Application.MessageBox(PChar(S), PChar(Application.Title),
      MB_YESNOCANCEL or MB_ICONWARNING or MB_DEFBUTTON2) of
      idYes:;
      idCancel:
        Abort;
    else
      begin
        Result := False;
        if bAbort then
          Abort;
      end;
    end;  }
  end;

  if HasSameNameTables(ATb, ATb.Name) then
  begin
    FGlobeDataModelList.RenameSameNameTables(ATb, AName);
    {S := Format(srRenameFromDulObjlePrompt, [FGlobeDataModelList.GetSameNameTableCount(ATb), ATb.Name, AName]);
    case Application.MessageBox(PChar(S), PChar(Application.Title),
      MB_YESNOCANCEL or MB_ICONWARNING or MB_DEFBUTTON2) of
      IDYES:
      begin
      end;
      IDNO:
      begin
      end
    else
      begin
        Result := False;
        if bAbort then
          Abort;
      end;
    end;}
  end;

  if Result then
  begin
    FGlobeDataModelList.DoOnTableRename(ATb, ATb.Name, AName);
  end;
end;

function HasSameNameTables(ATb: TCtMetaTable; AName: string): boolean;
begin
  Result := FGlobeDataModelList.HasSameNameTables(ATb, AName);
end;

procedure BeginTbPropUpdate(Tb: TCtMetaTable);
begin
  Inc(TbPropUpdateCounter);
end;

procedure EndTbPropUpdate(Tb: TCtMetaTable);
begin
  Dec(TbPropUpdateCounter);
  if TbPropUpdateCounter = 0 then
    if Tb <> nil then
      DoTablePropsChanged(tb);
end;

var
  G_EditingMetaObj: TCtMetaObject;
  G_EditingMetaForm: TWinControl;

function IsEditingMeta: boolean;
begin
  if GetMetaEditingWin <> nil then
    Result := True
  else
    Result := False;
end;

function GetMetaEditingWin: TWinControl;
begin
  Result := G_EditingMetaForm;
end;

procedure CheckCanEditMeta;
begin
  if G_EditingMetaForm <> nil then
  begin
    if Application.MessageBox(PChar(Format(srCheckEditingMetaFailedFmt,
      [TForm(G_EditingMetaForm).Caption])),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONERROR) = idOk then
      TForm(G_EditingMetaForm).BringToFront;
    Abort;
  end;
end;

procedure EditMetaAcquire(AObj: TCtMetaObject; AForm: TWinControl);
begin
  if G_EditingMetaForm <> nil then
    if G_EditingMetaForm <> AForm then
      raise Exception.Create(Format(srCheckEditingMetaFailedFmt,
        [TForm(G_EditingMetaForm).Caption]));
  G_EditingMetaForm := AForm;
  G_EditingMetaObj := AObj;
end;

procedure EditMetaRelease(AObj: TCtMetaObject; AForm: TWinControl);
begin
  if G_EditingMetaObj = AObj then
    if G_EditingMetaForm = AForm then
    begin
      G_EditingMetaForm := nil;
      G_EditingMetaObj := nil;
      Exit;
    end;
  raise Exception.Create('Failed to release editing window');
end;

procedure EditMetaForceRelease;
begin
  G_EditingMetaForm := nil;
  G_EditingMetaObj := nil;
end;

function IsConChar(ch: char): boolean;
begin
  if (ch >= 'a') and (ch <= 'z') then
    Result := True
  else if (ch >= 'A') and (ch <= 'Z') then
    Result := True
  else if (ch >= '0') and (ch <= '9') then
    Result := True
  else if (ch = '_') then
    Result := True
  else
    Result := False;
end;

function StringReplaceHuz(src, key, rep: string): string;
var
  po, len: integer;
  s, k, v: string;
  needWholeWordLeft, needWholeWordRight, isWholeWord: boolean;
begin
  v := src;
  needWholeWordLeft := True;
  if Copy(key, 1, 1) = '%' then
  begin
    needWholeWordLeft := False;
    key := Copy(key, 2, Length(key));
  end;

  needWholeWordRight := True;
  if Copy(key, Length(key), 1) = '%' then
  begin
    needWholeWordRight := False;
    key := Copy(key, 1, Length(key) - 1);
  end;

  s := UpperCase(v);
  k := UpperCase(key);
  len := Length(key);
  if len = 0 then
  begin
    Result := src;
    Exit;
  end;

  Result := '';
  while True do
  begin
    po := Pos(k, s);
    if po = 0 then
      Break;
    isWholeWord := True;
    if needWholeWordLeft then
      if (po > 1) and IsConChar(s[po - 1]) and IsConChar(s[po]) then
        isWholeWord := False;
    if needWholeWordRight then
      if IsConChar(s[po + len - 1]) and IsConChar(s[po + len]) then
        isWholeWord := False;

    Result := Copy(v, 1, po - 1);
    if isWholeWord then
      Result := Result + rep
    else
      Result := Result + Copy(v, po, len);
    s := Copy(s, po + len, Length(s));
    v := Copy(v, po + len, Length(v));
  end;
  Result := Result + v;
end;

function CheckCustDataTypeReplaces(Str: string): string;
var
  I, po: integer;
  S, V: string;
begin
  Result := Str;
  for I := 0 to High(CtCustDataTypeReplaces) do
  begin
    po := Pos(':', CtCustDataTypeReplaces[I]);
    if po = 0 then
      Continue;
    S := Copy(CtCustDataTypeReplaces[I], 1, po - 1);
    V := Copy(CtCustDataTypeReplaces[I], po + 1, Length(CtCustDataTypeReplaces[I]));
    Result := StringReplaceHuz(Result, S, V);
  end;
end;

function CheckStringMaxLen(DbType, custTpName: string; var res: string; len: integer): boolean;
begin
  Result := False;
  if dbType = 'POSTGRESQL' then
  begin
    if res = 'varchar' then
    begin
      if len = 0 then
        Result := True
      else if len > 8000 then
      begin
        res := 'text';
        if Trim(custTpName) <> '' then
          res := custTpName;
        Result := True;
      end;
    end;
  end
  else if dbType = 'SQLSERVER' then
  begin
    if len > 8000 then
    begin
      if res = 'VARCHAR' then
        res := 'VARCHAR(MAX)'
      else
        res := 'TEXT'; 
      if Trim(custTpName) <> '' then
        res := custTpName;
      Result := True;
    end;
  end
  else if dbType = 'ORACLE' then
  begin
    if len > 4000 then
    begin
      res := 'CLOB';  
      if Trim(custTpName) <> '' then
        res := custTpName;
      Result := True;
    end;
  end
  else if dbType = 'MYSQL' then
  begin
    if len > 65532 then
    begin
      res := 'LONGTEXT';  
      if Trim(custTpName) <> '' then
        res := custTpName;
      Result := True;
    end;
  end
  else if dbType = 'SQLITE' then
  begin
    if len > 8000 then
    begin
      res := 'TEXT';   
      if Trim(custTpName) <> '' then
        res := custTpName;
      Result := True;
    end;
  end    
  else if dbType = 'HIVE' then
  begin
    if len > 65535 then
    begin
      res := 'string';   
      if Trim(custTpName) <> '' then
        res := custTpName;
      Result := True;
    end;
  end
  else if len > 8000 then
  begin
    res := 'TEXT';  
    if Trim(custTpName) <> '' then
      res := custTpName;
    Result := True;
  end
  else if Pos('TEXT', UpperCase(res)) > 0 then
    Result := True
  else if Pos('CLOB', UpperCase(res)) > 0 then
    Result := True
  else if Pos('BLOB', UpperCase(res)) > 0 then
    Result := True;
end;

function IsSymbolName(AName: string): boolean;
const
  Def_SymbolNames = '~!@#$%^&*()-+=|\:;,."''<>/';
var
  I: integer;
  S: string;
begin
  S := Def_SymbolNames;
  for I := 1 to Length(S) do
    if Pos(S[I], AName) > 0 then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

function GetDbQuotName(AName, dbType: string): string;
begin
  Result := AName;

  if G_QuotAllNames then
  begin

  end
  else if IsReservedKeyworkd(AName) then
  begin
    if not G_QuotReservedNames and not G_QuotAllNames then
      Exit;
  end
  else if IsSymbolName(AName) then
  begin
  end
  else
    Exit;

  if (dbType = 'MYSQL') or (dbType = 'HIVE') then
  begin
    if Pos('`', Result) <> 1 then
      Result := '`' + Result + '`';
  end
  else if dbType = 'ORACLE' then
  begin
    if Pos('"', Result) <> 1 then
      Result := '"' + Result + '"';
  end
  else if dbType = 'SQLSERVER' then
  begin
    if Pos('[', Result) <> 1 then
      Result := '[' + Result + ']';
  end
  else
  begin
    if Pos('"', Result) <> 1 then
      Result := '"' + Result + '"';
  end;
end;

function GetDbQuotString(AStr, dbType: string): string;
const
  DEF_DB_CV_KEY_CHARS: array[0..3] of String = ('\', '''', #13, #10);
  DEF_DB_CV_KEY_CHARS_REP_ORACLE: array[0..3] of String = ('\', '''''', ''' || chr(13) || ''', ''' || chr(10) || ''');
  DEF_DB_CV_KEY_CHARS_REP_MYSQL: array[0..3] of String = ('\\', '''''', '\r', '\n');
  DEF_DB_CV_KEY_CHARS_REP_SQLSERVER: array[0..3] of String = ('\', '''''', ''' + char(13) + ''', ''' + char(10) + ''');
  DEF_DB_CV_KEY_CHARS_REP_POSTGRESQL: array[0..3] of String = (''' || chr(92) || ''', '''''', ''' || chr(13) || ''', ''' || chr(10) || ''');
  DEF_DB_CV_KEY_CHARS_REP_SQLITE: array[0..3] of String = (''' || char(92) || ''', '''''', ''' || char(13) || ''', ''' || char(10) || ''');
  DEF_DB_CV_KEY_CHARS_REP_STD: array[0..3] of String = ('\', '''''', #13, #10);
var
  I: Integer;
  S: String;
begin
  if AStr = '' then
    Result := 'null'
  else
  begin
    Result := AStr;
    for I:=0 to High(DEF_DB_CV_KEY_CHARS) do
    begin
      if Pos(DEF_DB_CV_KEY_CHARS[I], Result) > 0 then
      begin
        if dbType='ORACLE' then
          S := DEF_DB_CV_KEY_CHARS_REP_ORACLE[I]
        else if dbType='MYSQL' then
          S := DEF_DB_CV_KEY_CHARS_REP_MYSQL[I]   
        else if dbType='SQLSERVER' then
          S := DEF_DB_CV_KEY_CHARS_REP_SQLSERVER[I]
        else if dbType='POSTGRESQL' then
          S := DEF_DB_CV_KEY_CHARS_REP_POSTGRESQL[I]
        else if dbType='SQLITE' then
          S := DEF_DB_CV_KEY_CHARS_REP_SQLITE[I]
        else
          S := DEF_DB_CV_KEY_CHARS_REP_STD[I];
               
        Result := StringReplace(Result, DEF_DB_CV_KEY_CHARS[I], S, [rfReplaceAll]);
      end;
    end;
    Result := '''' + Result + '''';
  end;
end;

function NeedGenFKIndexesSQL(tb: TCtMetaTable): boolean;
begin
  Result := G_CreateForeignkeys and G_CreateIndexForForeignkey;
end;

function ReplaceSingleQuotmark(val: string): string;
begin
  Result := StringReplace(val, '''', '''''', [rfReplaceAll]);
end;

function MaybeSameStr(Str1, Str2: string): boolean;
begin
  if Pos(#13#10, Str1) > 0 then
    Str1 := StringReplace(Str1, #13#10, #10, [rfReplaceAll]);
  if Pos(#13, Str1) > 0 then
    Str1 := StringReplace(Str1, #13, #10, [rfReplaceAll]);

  if Pos(#13#10, Str2) > 0 then
    Str2 := StringReplace(Str2, #13#10, #10, [rfReplaceAll]);
  if Pos(#13, Str2) > 0 then
    Str2 := StringReplace(Str2, #13, #10, [rfReplaceAll]);

  if Str1 = Str2 then
    Result := True
  else
    Result := False;
end;

const
  ct_ArrayCRCHi: array[0..255] of longword =
    (
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0,
    $80, $41, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0,
    $80, $41, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1,
    $81, $40, $01, $C0, $80, $41, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $00, $C1,
    $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0,
    $80, $41, $00, $C1, $81, $40, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $01, $C0, $80, $41, $00, $C1,
    $81, $40, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0,
    $80, $41, $00, $C1, $81, $40, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $00, $C1, $81, $40, $01, $C0,
    $80, $41, $01, $C0, $80, $41, $00, $C1, $81, $40,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0,
    $80, $41, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $00, $C1, $81, $40, $01, $C0,
    $80, $41, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $01, $C0, $80, $41, $00, $C1, $81, $40, $01, $C0,
    $80, $41, $00, $C1, $81, $40, $00, $C1, $81, $40,
    $01, $C0, $80, $41, $01, $C0, $80, $41, $00, $C1,
    $81, $40, $00, $C1, $81, $40, $01, $C0, $80, $41,
    $00, $C1, $81, $40, $01, $C0, $80, $41, $01, $C0,
    $80, $41, $00, $C1, $81, $40
    );
  ct_ArrayCRCLo: array[0..255] of longword =
    (
    $00, $C0, $C1, $01, $C3, $03, $02, $C2, $C6, $06,
    $07, $C7, $05, $C5, $C4, $04, $CC, $0C, $0D, $CD,
    $0F, $CF, $CE, $0E, $0A, $CA, $CB, $0B, $C9, $09,
    $08, $C8, $D8, $18, $19, $D9, $1B, $DB, $DA, $1A,
    $1E, $DE, $DF, $1F, $DD, $1D, $1C, $DC, $14, $D4,
    $D5, $15, $D7, $17, $16, $D6, $D2, $12, $13, $D3,
    $11, $D1, $D0, $10, $F0, $30, $31, $F1, $33, $F3,
    $F2, $32, $36, $F6, $F7, $37, $F5, $35, $34, $F4,
    $3C, $FC, $FD, $3D, $FF, $3F, $3E, $FE, $FA, $3A,
    $3B, $FB, $39, $F9, $F8, $38, $28, $E8, $E9, $29,
    $EB, $2B, $2A, $EA, $EE, $2E, $2F, $EF, $2D, $ED,
    $EC, $2C, $E4, $24, $25, $E5, $27, $E7, $E6, $26,
    $22, $E2, $E3, $23, $E1, $21, $20, $E0, $A0, $60,
    $61, $A1, $63, $A3, $A2, $62, $66, $A6, $A7, $67,
    $A5, $65, $64, $A4, $6C, $AC, $AD, $6D, $AF, $6F,
    $6E, $AE, $AA, $6A, $6B, $AB, $69, $A9, $A8, $68,
    $78, $B8, $B9, $79, $BB, $7B, $7A, $BA, $BE, $7E,
    $7F, $BF, $7D, $BD, $BC, $7C, $B4, $74, $75, $B5,
    $77, $B7, $B6, $76, $72, $B2, $B3, $73, $B1, $71,
    $70, $B0, $50, $90, $91, $51, $93, $53, $52, $92,
    $96, $56, $57, $97, $55, $95, $94, $54, $9C, $5C,
    $5D, $9D, $5F, $9F, $9E, $5E, $5A, $9A, $9B, $5B,
    $99, $59, $58, $98, $88, $48, $49, $89, $4B, $8B,
    $8A, $4A, $4E, $8E, $8F, $4F, $8D, $4D, $4C, $8C,
    $44, $84, $85, $45, $87, $47, $46, $86, $82, $42,
    $43, $83, $41, $81, $80, $40
    );

function CRC(a_strPuchMsg: string): longword;
var
  l_CRCHi, l_CRCLo, l_Index, l_DataLen, i: longword;
begin
  l_DataLen := Length(a_strPuchMsg);
  l_CRCHi := $FF;
  l_CRCLo := $FF;
  //l_Index :=0;
  i := 1;
  while (i <= l_DataLen) do
  begin
    l_Index := l_CRCHi xor longword(a_strPuchMsg[i]);
    l_CRCHi := l_CRCLo xor ct_ArrayCRCHi[l_Index];
    l_CRCLo := ct_ArrayCRCLo[l_Index];
    Inc(i);
  end;
  Result := (l_CRCHi shl 8) or l_CRCLo;
end;


function GetIdxName(ATbn, AFieldName: string): string;
var
  S, T, S2: string;
  WS: WideString;
  I, N: integer;
begin
  S := AFieldName;
  if Pos(ATbn, S) = 0 then
    S := ATbn + '_' + S
  else
    ATbn := '';
  T := S;

  if Length(S) > 21 then
  begin
    for I := 0 to High(CtTbNamePrefixDefs) do
      if Pos(UpperCase(CtTbNamePrefixDefs[i]), UpperCase(S)) = 1 then
      begin
        S := Copy(S, Length(CtTbNamePrefixDefs[i]) + 1, Length(S));
        ATbn := Copy(ATbn, Length(CtTbNamePrefixDefs[i]) + 1, Length(ATbn));
        Break;
      end;
  end;
  if Length(S) > 21 then
  begin
    N := 8;
    S := ATbn;
    if Length(S) > 9 then
    begin
      WS := S;
      S2 := Copy(WS, Length(WS) - 2, Length(WS));
      if Length(S2) > 5 then
        S2 := Copy(WS, Length(WS) - 1, Length(WS));
      while Length(S) > (10 - Length(S2)) do
      begin
        S := Copy(WS, 1, N);
        Dec(N);
      end;
      S := S + S2;
      ATbn := S;
    end;

    S := ATbn + '_' + AFieldName;
    if Length(S) > 21 then
    begin
      N := 18;
      WS := S;
      S2 := Copy(WS, Length(WS) - 2, Length(WS));
      if Length(S2) > 5 then
        S2 := Copy(WS, Length(WS) - 1, Length(WS));

      while Length(S) > (21 - Length(S2)) do
      begin
        S := Copy(WS, 1, N);
        Dec(N);
      end;
      S := S + S2;
    end;

    T := IntToHex(Crc(T), 4);
    S := S + T;
  end;

  Result := S;
end;

function RemoveIdxNamePrefx(idxName, tbName: string): string;
var
  S: string;
  I, po, L1, L2: integer;
begin
  S := idxName;
  if (Pos('IDU_', UpperCase(S)) = 1) or (Pos('IDX_', UpperCase(S)) = 1) then
  begin
    S := Copy(S, 5, Length(S));
  end;
  L1 := Length(S);
  L2 := Length(tbName);
  po := 0;
  for I := 1 to L1 do
  begin
    if I > L2 then
      Break;
    if UpperCase(S[I]) = UpperCase(tbName[I]) then
      po := I
    else
      Break;
  end;
  if po >= 2 then
    S := Copy(S, po + 1, Length(S));
  if Copy(S, 1, 1) = '_' then
    S := Copy(S, 2, Length(S));
  Result := S;
end;

function IsReservedKeyworkd(str: string): boolean;
var
  fn: string;
  I: integer;
begin

  str := Trim(str);
  if Length(str) <= 1 then
  begin
    Result := True;
    Exit;
  end;

  str := LowerCase(str);
  if not Assigned(G_Reserved_Keywords) then
  begin
    G_Reserved_Keywords := TStringList.Create;
    fn := GetFolderPathOfAppExe('Templates');
    fn := FolderAddFileName(fn, 'reserved_words.txt');
    if FileExists(fn) then
    begin
      G_Reserved_Keywords.LoadFromFile(fn);
      for I := G_Reserved_Keywords.Count - 1 downto 0 do
        if Trim(G_Reserved_Keywords[I]) = '' then
          G_Reserved_Keywords.Delete(I);
    end;
  end;
  if G_Reserved_Keywords.Count > 0 then
    Result := G_Reserved_Keywords.IndexOf(str) >= 0
  else
    Result := Pos(',' + str + ',', DEF_RESERVED_KEYWORDS) > 0;
end;

function GetCtFieldDataTypeOfName(AName: string): TCtFieldDataType;
var
  t: TCtFieldDataType;
begin
  for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
    if (UpperCase(AName) = UpperCase(DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t]))
      or (UpperCase(AName) = UpperCase(DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t])) then
    begin
      Result := t;
      Exit;
    end;
  if LowerCase(AName)='boolean' then
  begin
    Result := cfdtBool;
    Exit;
  end;
  Result := cfdtUnknow;
end;

function GetPossibleCtFieldTypeOfName(AName: string): TCtFieldDataType;
var
  AllCtFieldDataTypeNames: array[0..7] of TCtFieldDataTypeNames;
  t: TCtFieldDataType;
  I: integer;
  ft: string;
begin
  Result := cfdtUnknow;
  ft := UpperCase(AName);
  AName := LowerCase(AName);
  AllCtFieldDataTypeNames[0] := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG;
  AllCtFieldDataTypeNames[1] := DEF_CTMETAFIELD_DATATYPE_NAMES_ORACLE;
  AllCtFieldDataTypeNames[2] := DEF_CTMETAFIELD_DATATYPE_NAMES_MYSQL;
  AllCtFieldDataTypeNames[3] := DEF_CTMETAFIELD_DATATYPE_NAMES_SQLSERVER;
  AllCtFieldDataTypeNames[4] := DEF_CTMETAFIELD_DATATYPE_NAMES_SQLITE;
  AllCtFieldDataTypeNames[5] := DEF_CTMETAFIELD_DATATYPE_NAMES_POSTGRESQL;
  AllCtFieldDataTypeNames[6] := DEF_CTMETAFIELD_DATATYPE_NAMES_HIVE;
  AllCtFieldDataTypeNames[7] := DEF_CTMETAFIELD_DATATYPE_NAMES_STD;
  for I := 0 to High(AllCtFieldDataTypeNames) do
    for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
      if (AName = LowerCase(AllCtFieldDataTypeNames[I][t])) then
      begin
        Result := t;
        Exit;
      end;

  if (Pos('TINYINT', ft) > 0) or (Pos('SMALLINT', ft) > 0) then
  begin
    Result := cfdtEnum;
    Exit;
  end;
  if Pos('INT', ft) > 0 then
  begin
    Result := cfdtInteger;
    Exit;
  end;
  if (Pos('CHAR', ft) > 0) or (Pos('CLOB', ft) > 0) or (Pos('TEXT', ft) > 0) then
  begin
    Result := cfdtString;
    Exit;
  end;
  if Pos('BLOB', ft) > 0 then
  begin
    Result := cfdtBlob;
    Exit;
  end;
  if (Pos('REAL', ft) > 0) or (Pos('FLOA', ft) > 0) or (Pos('DOUB', ft) > 0) then
  begin
    Result := cfdtFloat;
    Exit;
  end;
  if (Pos('DATE', ft) > 0) or (Pos('TIME', ft) > 0) then
  begin
    Result := cfdtDate;
    Exit;
  end;
  if (Pos('BOOL', ft) > 0) then
  begin
    Result := cfdtBool;
    Exit;
  end;

  for I := 0 to High(AllCtFieldDataTypeNames) do
    for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
      if Pos(LowerCase(AllCtFieldDataTypeNames[I][t]), AName) > 0 then
      begin
        Result := t;
        Exit;
      end;
end;

function GetCtFieldDataTypeNameList(ADbType: string): TCtFieldDataTypeNames;
begin
  if ADbType = 'ORACLE' then
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_ORACLE
  else if ADbType = 'MYSQL' then
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_MYSQL
  else if ADbType = 'SQLSERVER' then
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_SQLSERVER
  else if ADbType = 'SQLITE' then
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_SQLITE
  else if ADbType = 'POSTGRESQL' then
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_POSTGRESQL      
  else if ADbType = 'HIVE' then
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_HIVE
  else
    Result := DEF_CTMETAFIELD_DATATYPE_NAMES_STD;
end;

function GetCtFieldPhyTypeName(ADbType: string; AFieldType: TCtFieldDataType;
  ADataLen: integer): string;
var
  ft_names: TCtFieldDataTypeNames;
  I, po: integer;
  S, V, U: string;
begin
  Result := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[AFieldType];

  U := '';
  if ADbType <> '' then
  begin
    for I := 0 to High(CtCustFieldTypeDefs) do
    begin
      po := Pos(':', CtCustFieldTypeDefs[I]);
      S := Copy(CtCustFieldTypeDefs[I], 1, po - 1);
      V := Copy(CtCustFieldTypeDefs[I], po + 1, Length(CtCustFieldTypeDefs[I]));
      if UpperCase(Result+'_'+ADbType) = UpperCase(S) then
      begin
        U := V;
        Break;
      end;
    end;
  end;
  if U = '' then
  begin
    for I := 0 to High(CtCustFieldTypeDefs) do
    begin
      po := Pos(':', CtCustFieldTypeDefs[I]);
      S := Copy(CtCustFieldTypeDefs[I], 1, po - 1);
      V := Copy(CtCustFieldTypeDefs[I], po + 1, Length(CtCustFieldTypeDefs[I]));
      if UpperCase(Result) = UpperCase(S) then
      begin
        U := V;
        Break;
      end;
    end;
  end;
  if U <> '' then
  begin
    Result := U;
    if ADataLen > 0 then
    begin
      po := Pos('(', Result);
      if po > 0 then
        Result := Copy(Result, 1, po - 1);
    end;
    Exit;
  end;
  ft_names := GetCtFieldDataTypeNameList(ADbType);
  Result := ft_names[AFieldType];
  if ADataLen > 0 then
  begin
    po := Pos('(', Result);
    if po > 0 then
      Result := Copy(Result, 1, po - 1);
  end;
end;

function GetCtCustFieldPhyTypeName(ADbType, ADataTypeName: string;
  ADataLen: integer): string;
var
  I, po: integer;
  S, V: string;
begin
  Result := Trim(ADataTypeName);
  if Result = '' then
    Exit;
  for I := 0 to High(CtCustFieldTypeList) do
  begin
    S := Trim(CtCustFieldTypeList[I]);
    V := Trim(CtCustFieldTypeDefList[I]);
    if UpperCase(Result) = UpperCase(S) then
    begin
      if V <> '' then
        Result := V
      else
        Result := S;
      if ADataLen > 0 then
      begin
        po := Pos('(', Result);
        if po > 0 then
          Result := Copy(Result, 1, po - 1);
      end;
      if ADbType <> 'LOGIC_TYPE' then
      begin          
        po := Pos(':', Result);
        if po>0 then
        begin
          Result := Copy(Result, po + 1, Length(Result));
        end;
      end;
      Exit;
    end;
  end;
end;

function GetCtFieldDataTypeIsNullDefault(AName: string): boolean;
var
  t: TCtFieldDataType;
  s: string;
begin
  Result := False;
  if AName = '' then
  begin
    Result := True;
    Exit;
  end;
  for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
  begin
    S := ',' + DEF_CTMETAFIELD_DATATYPE_NAMES_NULL[t] + ',';
    if Pos(LowerCase(',' + AName + ','), LowerCase(S)) > 0 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function GetCtFieldDataTypeOfAliasEx(AName: string; bPartial: boolean): TCtFieldDataType;
var
  t: TCtFieldDataType;
  s: string;
  ss: TStringList;
  I: integer;
begin
  Result := cfdtUnknow;
  for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
  begin
    S := ',' + DEF_CTMETAFIELD_DATATYPE_NAMES_ALIAS[t] + ',';
    if Pos(LowerCase(',' + AName + ','), LowerCase(S)) > 0 then
    begin
      Result := t;
      Exit;
    end;
  end;

  if not bPartial then
    Exit;

  ss := TStringList.Create;
  try
    for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
    begin
      S := DEF_CTMETAFIELD_DATATYPE_NAMES_ALIAS[t];
      ss.CommaText := LowerCase(S);
      for I := 0 to ss.Count - 1 do
        if ss[I] <> '' then
          if Pos(ss[I], LowerCase(AName)) > 0 then
          begin
            Result := t;
            Exit;
          end;
    end;
  finally
    ss.Free;
  end;
end;

function GetCtFieldDataTypeOfAlias(AName: string): TCtFieldDataType;
var
  S: string;
begin
  Result := cfdtUnknow;
  if IsSymbolName(AName) then
    Exit;
  S := GetCtCustFieldPhyTypeName('LOGIC_TYPE', AName, 1);
  if (S <> '') and (S <> AName) then
    Result := GetCtFieldDataTypeOfAliasEx(S, True);
  if Result = cfdtUnknow then
  begin
    Result := GetCtFieldDataTypeOfAliasEx(AName, True);
  end;
end;

procedure AddCtMetaDBReg(EngineType: string; DbClass: TCtMetaDatabaseClass);

  procedure MoveDbe(ATP: string; AIdx: integer);
  var
    I, J, H: integer;
    dbe: TCtMetaDBReg;
  begin
    H := High(CtMetaDBRegs);
    if AIdx > H then
      Exit;
    for I := 0 to H do
      if CtMetaDBRegs[I].DbEngineType = ATP then
      begin
        if I > AIdx then
        begin
          dbe := CtMetaDBRegs[I];
          for J := I downto AIdx + 1 do
            CtMetaDBRegs[J] := CtMetaDBRegs[J - 1];
          CtMetaDBRegs[AIdx] := dbe;
        end
        else if I < AIdx then
        begin
          dbe := CtMetaDBRegs[I];
          for J := I to AIdx - 1 do
            CtMetaDBRegs[J] := CtMetaDBRegs[J + 1];
          CtMetaDBRegs[AIdx] := dbe;
        end;
      end;
  end;

var
  L: integer;
begin
  L := Length(CtMetaDBRegs);
  SetLength(CtMetaDBRegs, L + 1);
  CtMetaDBRegs[L].DbEngineType := EngineType;
  CtMetaDBRegs[L].DbClass := DbClass;

  MoveDbe('ORACLE', 0);
  MoveDbe('SQLSERVER', 1);
  MoveDbe('MYSQL', 2);
  MoveDbe('POSTGRESQL', 3);
  MoveDbe('SQLITE', 4);
  MoveDbe('ODBC', 5);
  MoveDbe('HTTP_JDBC', 6);
end;

function GetCtMetaDBReg(EngineType: string): PCtMetaDBReg;
var
  I: integer;
begin
  for I := 0 to High(CtMetaDBRegs) do
    if UpperCase(CtMetaDBRegs[I].DbEngineType) = UpperCase(EngineType) then
    begin
      Result := @CtMetaDBRegs[I];
      Exit;
    end;
  Result := nil;
end;

procedure RemoveCtMetaDBReg(EngineType: string);
var
  I, J: integer;
begin
  for I := 0 to High(CtMetaDBRegs) do
    if UpperCase(CtMetaDBRegs[I].DbEngineType) = UpperCase(EngineType) then
    begin
      for J := I to High(CtMetaDBRegs) - 1 do
      begin
        CtMetaDBRegs[J] := CtMetaDBRegs[J + 1];
      end;
      SetLength(CtMetaDBRegs, Length(CtMetaDBRegs) - 1);
      Exit;
    end;
end;

procedure ClearCtMetaDbReg(bFreeConns: boolean);
var
  I: integer;
begin
  if bFreeConns then
    for I := 0 to High(CtMetaDBRegs) do
      if CtMetaDBRegs[I].DbImpl <> nil then
      begin
        CtMetaDBRegs[I].DbImpl.Free;
        CtMetaDBRegs[I].DbImpl := nil;
      end;
  SetLength(CtMetaDBRegs, 0);
end;


{ TCtMetaTable }

constructor TCtMetaTable.Create;
begin
  inherited;   
  FGenDatabase := True;
  FGenCode := True;
  FBgColor := 0;
end;

destructor TCtMetaTable.Destroy;
begin
  inherited;
end;

procedure TCtMetaTable.Reset;
begin
  inherited;
  FPhysicalName := '';

  FCellTreeId := 0;
  FGraphDesc := '';
  FScriptRules := '';
  FUIDisplayText := '';
  FCustomConfigs := '';

  FBgColor := 0;
  FGenDatabase := True;   
  FGenCode := True;
  FViewSQL := '';
  FListSQL := '';
  FExtraSQL := '';
  FUILogic := '';
  FBusinessLogic := '';
  FExtraProps := '';

  FDesignNotes       := '';
  FGroupName        := '';
  FOwnerCategory    := '';
  FPartitionInfo    := '';
  FSQLAlias         := '';
  FSQLOrderByClause := '';
  FSQLWhereClause   := '';

  if Assigned(FMetaFields) then
    FMetaFields.Clear;
end;

procedure TCtMetaTable.AssignFrom(ACtObj: TCtObject);
begin
  inherited;
  if ACtObj is TCtMetaTable then
  begin
    AssignTbPropsFrom(TCtMetaTable(ACtObj));

    if Assigned(TCTMetaTable(ACtObj).FMetaFields) then
      MetaFields.AssignFrom(TCTMetaTable(ACtObj).FMetaFields);
  end;
end;

procedure TCtMetaTable.LoadFromSerialer(ASerialer: TCtObjSerialer);

  procedure CheckEditorUIProp;
  var
    I: integer;
  begin
    if FMetaFields = nil then
      Exit;
    for I := 0 to FMetaFields.Count - 1 do
      if not FMetaFields[I].IsEditorUIClear then
        Exit;
    for I := 0 to FMetaFields.Count - 1 do
      with FMetaFields[I] do
      begin
        EditorEnabled := True;
      end;
  end;

var
  S: String;
begin
  BeginSerial(ASerialer, True);
  try
    inherited;
    ASerialer.ReadInteger('CellTreeId', FCellTreeId);
    ASerialer.ReadStrings('GraphDesc', FGraphDesc);
    if ASerialer.CurCtVer >= 22 then
    begin
      ASerialer.ReadStrings('ScriptRules', FScriptRules);
      ASerialer.ReadStrings('CustomConfigs', FCustomConfigs);
    end;              
    if ASerialer.CurCtVer >= 31 then
    begin
      ASerialer.ReadString('UIDisplayText', FUIDisplayText);
      ASerialer.ReadNotBool('GenDatabase', FGenDatabase);
      ASerialer.ReadNotBool('GenCode', FGenCode);
      ASerialer.ReadStrings('ExtraSQL', FExtraSQL);
      ASerialer.ReadStrings('UILogic', FUILogic);
      ASerialer.ReadStrings('BusinessLogic', FBusinessLogic);
      ASerialer.ReadStrings('ExtraProps', FExtraProps);
    end;
    if ASerialer.CurCtVer >= 32 then
    begin
      ASerialer.ReadStrings('PhysicalName', FPhysicalName);
      ASerialer.ReadStrings('ViewSQL', FViewSQL);
      ASerialer.ReadStrings('ListSQL', FListSQL);
    end;

    if ASerialer.CurCtVer >= 33 then
    begin
      ASerialer.ReadInteger('BgColor', FBgColor);
    end
    else
    begin
      S := Trim(ExtractCompStr(FGraphDesc+#10, #10'BkColor=', #10));
      if S <> '' then
      begin
        FBgColor := StrToIntDef(S, 0);
        FGraphDesc := ModifyCompStr(FGraphDesc+#10, 'XXX', #10'BkColor=', #10);
        FGraphDesc := StringReplace(FGraphDesc, #10'BkColor=XXX', '', []);
      end;
    end;

    if ASerialer.CurCtVer >= 34 then
    begin
      ASerialer.ReadStrings('DesignNotes', FDesignNotes);
      ASerialer.ReadString('GroupName', FGroupName);
      ASerialer.ReadString('OwnerCategory', FOwnerCategory);
      ASerialer.ReadStrings('PartitionInfo', FPartitionInfo);
      ASerialer.ReadString('SQLAlias', FSQLAlias);
      ASerialer.ReadStrings('SQLOrderByClause', FSQLOrderByClause);
      ASerialer.ReadStrings('SQLWhereClause', FSQLWhereClause);
    end;

    ASerialer.BeginChildren('MetaFields');
    try
      MetaFields.LoadFromSerialer(ASerialer);
      ASerialer.EndChildren('MetaFields');
    finally
    end;
    if ASerialer.CurCtVer < 27 then
      CheckEditorUIProp;
    EndSerial(ASerialer, True);
  finally
  end;
end;

procedure TCtMetaTable.SaveToSerialer(ASerialer: TCtObjSerialer);
var
  I: integer;
begin
  BeginSerial(ASerialer, False);
  try
    if Assigned(FMetaFields) then
      FMetaFields.SaveCurrentOrder;
    inherited;
    ASerialer.WriteInteger('CellTreeId', FCellTreeId);
    ASerialer.WriteStrings('GraphDesc', FGraphDesc);
    ASerialer.WriteStrings('ScriptRules', FScriptRules);
    ASerialer.WriteStrings('CustomConfigs', FCustomConfigs);

    ASerialer.WriteString('UIDisplayText', FUIDisplayText);
    ASerialer.WriteNotBool('GenDatabase', FGenDatabase);
    ASerialer.WriteNotBool('GenCode', FGenCode);
    ASerialer.WriteStrings('ExtraSQL', FExtraSQL);
    ASerialer.WriteStrings('UILogic', FUILogic);
    ASerialer.WriteStrings('BusinessLogic', FBusinessLogic);
    ASerialer.WriteStrings('ExtraProps', FExtraProps);

    ASerialer.WriteStrings('PhysicalName', FPhysicalName);
    ASerialer.WriteStrings('ViewSQL', FViewSQL);
    ASerialer.WriteStrings('ListSQL', FListSQL);
                                      
    ASerialer.WriteInteger('BgColor', BgColor);

    ASerialer.WriteStrings('DesignNotes', FDesignNotes);
    ASerialer.WriteString('GroupName', FGroupName);
    ASerialer.WriteString('OwnerCategory', FOwnerCategory);
    ASerialer.WriteStrings('PartitionInfo', FPartitionInfo);
    ASerialer.WriteString('SQLAlias', FSQLAlias);
    ASerialer.WriteStrings('SQLOrderByClause', FSQLOrderByClause);
    ASerialer.WriteStrings('SQLWhereClause', FSQLWhereClause);

    if Assigned(MetaFields) then
    begin
      //创建时间与主表相近（15分钟内）则清空
      for I := 0 to FMetaFields.Count - 1 do
        if Abs(FMetaFields[I].CreateDate - Self.CreateDate) < 15 / 24 / 60 then
          FMetaFields[I].CreateDate := 0;

      ASerialer.BeginChildren('MetaFields');
      try
        FMetaFields.SaveToSerialer(ASerialer);
        ASerialer.EndChildren('MetaFields');
      finally
      end;
    end;
    EndSerial(ASerialer, False);
  finally
  end;
end;

function TCtMetaTable.MaybeSame(ATb: TCtMetaTable): boolean;
var
  S1, S2: String;
begin      
  Result := False;
  if ATb=nil then
    Exit;

  S1 := LowerCase(Describe);
  S1 := StringReplace(S1, '\r\n','\n', [rfReplaceAll]);
  S2 := LowerCase(ATb.Describe);
  S2 := StringReplace(S2, '\r\n','\n', [rfReplaceAll]);
  if S1 = S2 then
    Result := True;
end;


function TCtMetaTable.GetMetaFields: TCTMetaFieldList;
begin
  if not Assigned(FMetaFields) then
  begin
    FMetaFields := TCTMetaFieldList.Create;
    FMetaFields.FOwnerTable := Self;
    AddAutoFree(FMetaFields);
  end;
  Result := FMetaFields;
end;

function TCtMetaTable.GetRealTableName: string;
begin
  if Trim(FPhysicalName) <> '' then
    Result := Trim(FPhysicalName)
  else
    Result := Trim(Name);
end;

procedure TCtMetaTable.AssignTbPropsFrom(tb: TCtMetaTable);
begin
  if tb=nil then
    Exit;

  FPhysicalName := tb.FPhysicalName;
  FCellTreeId := tb.FCellTreeId;
  FGraphDesc := tb.FGraphDesc;
  FScriptRules := tb.FScriptRules;
  FUIDisplayText := tb.FUIDisplayText;
  FCustomConfigs := tb.FCustomConfigs;

  FBgColor := tb.FBgColor;
  FGenDatabase := tb.FGenDatabase;
  FGenCode := tb.FGenCode;
  FViewSQL := tb.FViewSQL;
  FListSQL := tb.FListSQL;
  FExtraSQL := tb.FExtraSQL;
  FUILogic := tb.FUILogic;
  FBusinessLogic := tb.FBusinessLogic;
  FExtraProps := tb.FExtraProps;

  FDesignNotes := tb.FDesignNotes;
  FGroupName := tb.FGroupName;
  FOwnerCategory := tb.FOwnerCategory;
  FPartitionInfo := tb.FPartitionInfo;
  FSQLAlias := tb.FSQLAlias;
  FSQLOrderByClause := tb.FSQLOrderByClause;
  FSQLWhereClause := tb.FSQLWhereClause;

end;

function TCtMetaTable.GetSketchyDescribe: string;

  function CheckDesName(nm: string): string;
  begin
    Result := nm;
    if Pos(' ', Result) > 0 then
      Result := StringReplace(Result, ' ', '#32', [rfReplaceAll]);
    if Pos(#9, Result) > 0 then
      Result := StringReplace(Result, #9, '#9', [rfReplaceAll]);
    if Pos('(', Result) > 0 then
      Result := StringReplace(Result, '(', '#40', [rfReplaceAll]);
    if Pos(')', Result) > 0 then
      Result := StringReplace(Result, ')', '#41', [rfReplaceAll]);
  end;

var
  I, L, LM: integer;
  S, T, FT: string;
  Infos: TStringList;
  f: TCtMetaField;
begin
  if not IsTable then
  begin
    Result := Name;
    Exit;
  end;
  Infos := TStringList.Create;
  try
    L := 0;
    for I := 0 to MetaFields.Count - 1 do
      if MetaFields[I].DataLevel <> ctdlDeleted then
      begin
        f := MetaFields[I];  
        if not f.IsPhysicalField then
          Continue;
        S := f.Name;
        if L < Length(S) then
          L := Length(S);
      end;
    LM := 0;
    for I := 0 to MetaFields.Count - 1 do
      if MetaFields[I].DataLevel <> ctdlDeleted then
      begin
        f := MetaFields[I];
        if not f.IsPhysicalField then
          Continue;
        S := ExtStr(f.Name, L);     
        if f.DataType in [cfdtInteger, cfdtBool, cfdtEnum] then
          FT := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[cfdtInteger]
        else
          FT := f.GetLogicDataTypeName;

        if LM < Length(S + ' ' + FT) then
          LM := Length(S + ' ' + FT);

        S := S + ' ' + FT;

        Infos.Add(S);
      end;
    //Infos.Add('');

    S := RealTableName;
    if LM < Length(S) then
      LM := Length(S);
    T := ExtStr('-', LM, '-');
    Infos.Insert(0, T);
    Infos.Insert(0, S);

    Result := Infos.Text;
  finally
    infos.Free;
  end;
end;

function TCtMetaTable.GetFullDesignNotes(includeEmptyFields: boolean): string;
var
  ss: TStringList;
  procedure adds(ds: string);
  begin
    ss.Add(Trim(ds));
  end;
var
  I, nn: Integer;
  fd: TCtMetaField;
begin
  Result := '';

  ss:= TStringList.Create;
  try
    adds(NameCaption);
    I := DmlStrLength(NameCaption);
    if I>32 then
      I := 32;
    adds(ExtStr('====', I, '='));

    if Trim(Self.DesignNotes) <> '' then      
    begin
      adds(Self.DesignNotes);  
      if Trim(Self.Memo) <> '' then
        adds('');
    end;  
    if Trim(Self.Memo) <> '' then
    begin
      adds('['+srComments+']');
      adds(Self.Memo);
    end;  
    adds('');

    nn := 0;
    for I := 0 to MetaFields.Count - 1 do
    begin
      fd := MetaFields[I];
      if fd.DataLevel = ctdlDeleted then
        Continue;
      if not includeEmptyFields then
        if Trim(fd.DesignNotes) = '' then
          if Trim(fd.Memo) = '' then
            Continue;

      Inc(nn);
      //adds(ExtStr('----', 32, '-'));
      adds(IntToStr(nn)+'. '+fd.NameCaption);

      if Trim(fd.DesignNotes) <> '' then
      begin
        adds(fd.DesignNotes); 
        if Trim(fd.Memo) <> '' then
          adds('');
      end;  
      if Trim(fd.Memo) <> '' then
      begin
        adds('['+srComments+']');
        adds(fd.Memo);
      end;           
      adds('');
    end;

    Result := ss.Text;
  finally
    ss.Free;
  end;
end;

function TCtMetaTable.GetExcelText: string;
var
  I: integer;
  S, T, DN: string;
  fd: TCtMetaField;
  ss: TStringList;
  ft: TCtFieldDataType;
begin
  S := NameCaption;
  if Trim(Self.Memo) <> '' then
  begin
    DN := Self.Memo;
    DN := StringReplace(DN, #13#10, '#10', [rfReplaceAll]);
    DN := StringReplace(DN, #13, '#10', [rfReplaceAll]);
    DN := StringReplace(DN, #10, '#10', [rfReplaceAll]);
    DN := StringReplace(DN, #9, '#9', [rfReplaceAll]);
    S := S + #13#10 + DN;
  end;

  S := S + #13#10 + ExtStr('-', WindowFuncs.DmlStrLength(NameCaption) - 1, '-');

  T := srFieldName;
  T := T + #9 + srLogicName;
  T := T + #9 + srDataType;
  T := T + #9 + srDataLength;
  T := T + #9 + srConstraint;
  T := T + #9 + srComments;
  S := S + #13#10 + T;

  ss := TStringList.Create;
  try

    for ft := Low(TCtFieldDataType) to High(TCtFieldDataType) do
      if ShouldUseEnglishForDML then
        ss.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[ft])
      else
        ss.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[ft]);
    for I := 0 to High(CtCustFieldTypeList) do
      ss.Add(CtCustFieldTypeList[I]);

    for I := 0 to MetaFields.Count - 1 do
    begin
      fd := MetaFields[I];
      if fd.DataLevel = ctdlDeleted then
        Continue;
      T := fd.Name;
      T := T + #9 + fd.DisplayName;

      DN := fd.DataTypeName;
      if DN <> '' then
        if ss.IndexOf(DN) < 0 then
          DN := '';
      if DN = '' then
      begin
        if fd.DataType = cfdtUnknow then
          DN := ''
        else if ShouldUseEnglishForDML then
          DN := fd.GetLogicDataTypeName
        else
          DN := DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[fd.DataType];
      end;
      T := T + #9 + DN;

      DN := '';
      if fd.DataLength > 0 then
      begin
        if fd.DataScale > 0 then
          DN := DN + Format('%d,%d', [fd.DataLength, fd.DataScale])
        else if fd.DataLength >= DEF_TEXT_CLOB_LEN then
          DN := DN + 'LONG'
        else
          DN := DN + Format('%d', [fd.DataLength]);
      end;
      T := T + #9 + DN;

      T := T + #9 + fd.GetConstraintStr;

      DN := fd.Memo;
      DN := StringReplace(DN, #13#10, '#10', [rfReplaceAll]);
      DN := StringReplace(DN, #13, '#10', [rfReplaceAll]);
      DN := StringReplace(DN, #10, '#10', [rfReplaceAll]);
      DN := StringReplace(DN, #9, '#9', [rfReplaceAll]);
      T := T + #9 + DN;
      S := S + #13#10 + T;

    end;

  finally
    ss.Free;
  end;

  Result := S;

end;

function TCtMetaTable.GetPrimaryKeyNames(AQuotDbType: string): string;
begin
  Result := GetSpecKeyNames(cfktId, AQuotDbType);
end;

function TCtMetaTable.GetSpecKeyNames(keyFieldTp: TCtKeyFieldType;
  AQuotDbType: string): string;
var
  I: integer;
  f: TCtMetaField;
begin
  Result := '';
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not f.IsPhysicalField then
      Continue;
    if f.KeyFieldType = keyFieldTp then
    begin
      if Result <> '' then
        Result := Result + ',';
      if AQuotDbType='' then                 
        Result := Result + f.Name
      else
        Result := Result + GetDbQuotName(f.Name, AQuotDbType);
    end;
  end;
end;

function TCtMetaTable.GetPossibleKeyName(keyFieldTp: TCtKeyFieldType): string;
var
  I: integer;
  f: TCtMetaField;
begin
  Result := '';
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not f.IsPhysicalField then
      Continue;
    if f.KeyFieldType = keyFieldTp then
    begin
      Result := f.Name;
      Exit;
    end;
  end;

  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not f.IsPhysicalField then
      Continue;
    if f.PossibleKeyFieldType = keyFieldTp then
    begin
      Result := f.Name;
      Exit;
    end;
  end;
end;

function TCtMetaTable.GetTitleFieldName: string;
var
  I: integer;
  f: TCtMetaField;
begin
  Result := GetPossibleKeyName(cfktName);
  if Result = '' then
    Result := GetPossibleKeyName(cfktCaption);
  if Result <> '' then
    Exit;
           
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if f.KeyFieldType=cfktName then
    begin
      Result := f.Name;
      Exit;
    end;
  end;    
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if f.KeyFieldType=cfktCaption then
    begin
      Result := f.Name;
      Exit;
    end;
  end;

  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not f.IsPhysicalField then
      Continue;
    if f.CanDisplay('grid') then
    begin
      Result := f.Name;
      Exit;
    end;
  end;
end;

function TCtMetaTable.GenSqlEx(bCreatTb: boolean; bFK: boolean; dbType: string;
  dbEngine: TCtMetaDatabase): string;

  function Get_FieldTypeStrEE(AField: TCtMetaField): string;
  begin
    Result := AField.GetFieldTypeDesc(True, dbType);
  end;
             
  function GetSqlDbSchemaName: string;
  begin
    if dbEngine = nil then
      Result := 'dbo'
    else
    begin
      Result := dbEngine.DbSchema;
      if Result = '' then
        Result := 'dbo';
    end;
  end;

  function GetQuotName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);
  end;
           
  function GetQuotTbName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);   
    if Trim(OwnerCategory) <> '' then
      Result := OwnerCategory+'.'+Result
    else if dbEngine <> nil then
    begin
      if dbEngine.EngineType='SQLSERVER' then
      begin
        if dbEngine.DbSchema <> '' then
          Result := dbEngine.DbSchema+'.'+Result
        else
          Result := 'dbo.'+Result;
      end;
    end
    else if dbType='SQLSERVER' then
    begin
      Result := 'dbo.'+Result;
    end;
  end;

  function GetIndexPrefixInfo(AField: TCtMetaField): string;
  begin
    Result := '';
    if dbType = 'MYSQL' then
      if AField.DataType = cfdtString then
        if AField.DataLength > 255 then
          Result := '(255)';
  end;

  function IsNameOk(AName: string): boolean;
  var
    I, C: integer;
  begin
    Result := True;
    if not bCreatTb then
      Exit;
    if IsReservedKeyworkd(AName) then
      Result := False
    else
      for I := 1 to Length(AName) do
      begin
        C := Ord(AName[I]);
        if C < 128 then
        begin
          if C = 95 then //_
            Continue;
          if (C >= 48) and (C <= 57) then //0-9
            Continue;
          if (C >= 65) and (C <= 90) then //A-Z
            Continue;
          if (C >= 97) and (C <= 122) then //A-Z
            Continue;
          Result := False;
          Break;
        end;
      end;
  end;

var
  I, J, C: integer;
  vTbn, S, T, sNull, sComment, sPK, sFK, sIdx, sChk, sFdEx, sFPN: string;
  Infos: TStringList;
  f: TCtMetaField;
  pkAdded: boolean;
begin
  Infos := TStringList.Create;
  try

    T := '';
    pkAdded := False;

    S := RealTableName;
    if not IsNameOk(S) then
    begin
      if T <> '' then
        T := T + #13#10;
      T := T + Format(srInvalidTableNameWarningFmt, [S]);
    end;

    for I := 0 to MetaFields.Count - 1 do
      if MetaFields[I].DataLevel <> ctdlDeleted then
      begin
        if not MetaFields[I].IsPhysicalField then
          Continue;
        S := MetaFields[I].Name;
        if not IsNameOk(S) then
        begin
          if T <> '' then
            T := T + #13#10;
          T := T + Format(srInvalidFieldNameWarningFmt, [S]);
        end;

        for J := I - 1 downto 0 do
          if MetaFields[J].DataLevel <> ctdlDeleted then
            if UpperCase(S) = UpperCase(MetaFields[J].Name) then
            begin
              if T <> '' then
                T := T + #13#10;
              T := T + Format(srDuplicateFieldNameWarningFmt, [S]);
            end;
      end;

    if T <> '' then
    begin
      if dbType='HIVE' then
      begin
        with TStringList.Create do
        try
          Text := T;
          for I:=0 to Count - 1 do
            Strings[I] := '-- '+ Strings[I];
          T := Text;
        finally
          Free;
        end;   
        Infos.Add(Trim(T));
      end
      else
      begin
        Infos.Add('/*');
        Infos.Add(T);
        Infos.Add('*/');
      end;
    end;

    vTbn := RealTableName;
    if vTbn = '' then
      vTbn := Caption;

    vTbn := GetQuotTbName(vTbn);

    S := 'create table  ' + vTbn;
    if Dbtype = 'SQLITE' then
    begin
      S := S + #13#10'/**EZDML_DESC_START**'#13#10 + Trim(Describe) +
        #13#10'**EZDML_DESC_END**/';
    end;
    S := S + #13#10'(';
    if bCreatTb then
      Infos.Add(S);

    S := '';
    sComment := '';
    sPK := '';
    sFK := '';
    sIdx := '';
    sChk := '';
    sFdEx := '';
    C := 0;

    T := Self.GetTableComments;
    if T <> '' then
    begin
      if (dbType = 'ORACLE') or (dbType = 'POSTGRESQL') then
      begin
        if sComment <> '' then
          sComment := sComment + #13#10;
        sComment := sComment + 'comment on table '
          + vTbn + ' is ''' + ReplaceSingleQuotmark(T) + ''';';
      end
      else if dbType = 'SQLSERVER' then
      begin
        if sComment <> '' then
          sComment := sComment + #13#10;
        sComment := sComment + 'EXEC sp_addextendedproperty ''MS_Description'', ''' +
          ReplaceSingleQuotmark(T) + ''', ''user'', ' + GetSqlDbSchemaName +
          ', ''table'', ' + GetQuotName(RealTableName) + ', NULL, NULL;';
      end
      else if dbType = 'MYSQL' then
      begin
        //if sComment <> '' then
        //  sComment := sComment + #13#10;
        //sComment := sComment + 'alter table '
        //  + vTbn + ' comment ''' + ReplaceSingleQuotmark(T) + ''';';
        //改在create table后附上
      end;
    end;

    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      if not f.IsPhysicalField then
        Continue;
      Inc(C);
      if C > 1 then
        S := S + ','#13#10;
      sFPN := f.Name;
        {if sFPN = '' then
          sFPN := f.DisplayName; }
      sFPN := GetQuotName(sFPN);
      S := S + ExtStr(' ', 6) + ExtStr(sFPN, 16);
      T := Get_FieldTypeStrEE(F);
      S := S + ' ' + T;
      if F.DefaultValue <> '' then
      begin
        if (dbType = 'HIVE') and (G_HiveVersion < 3) then
        begin  //hive2不支持缺省值
        end
        else
          S := S + F.GetFieldDefaultValDesc(dbType);
        //          if dbType = 'SQLSERVER' then     //似乎sqlserver 也支持default 0
        //          begin
        //          if Trim(F.DefaultValue) <> DEF_VAL_auto_increment  then
        //            Result := Result +#13#10'alter  table '+tableName+' add constraint DF_'+
        //              GetIdxName(tab.Name, ctF.Name)+' '+ctF.GetFieldDefaultValDesc(EngineType)+' for '+
        //              GetQuotName(ctF.Name)+';';
        //          end
        //ALTER TABLE dbo.doc_exz ADD CONSTRAINT col_b_def DEFAULT 50 FOR column_b ;

      end;
      sNull := F.GetNullableStr(dbType);
      if Trim(sNull) = '' then
        if dbEngine <> nil then
          if Pos('[GSQL_FIELD_NULL]', dbEngine.ExtraOpt) > 0 then
            sNull := ' null';
      S := S + sNull;

      T := F.GetFieldComments;
      if T <> '' then
      begin
        if (dbType = 'MYSQL') or (dbType = 'HIVE') then
        begin
          S := S + ' comment ''' + ReplaceSingleQuotmark(T) + '''';
        end
        else
        begin
          if (dbType = 'ORACLE') or (dbType = 'POSTGRESQL') then
          begin
            if sComment <> '' then
              sComment := sComment + #13#10;
            sComment := sComment + 'comment on column '
              + vTbn + '.' + sFPN + ' is ''' + ReplaceSingleQuotmark(T) + ''';';
          end
          else if dbType = 'SQLSERVER' then
          begin
            if sComment <> '' then
              sComment := sComment + #13#10;
            sComment := sComment +
              'EXEC sp_addextendedproperty ''MS_Description'', ''' +
              ReplaceSingleQuotmark(T) + ''', ''user'', ' +
              GetSqlDbSchemaName + ', ''table'', ' + GetQuotName(RealTableName) +
              ', ''column'', ' + sFPN + ';';
          end;
          if G_AddColCommentToCreateTbSql and (dbType <> 'HIVE') and (F.DisplayName <> '') and (F.DisplayName <> F.Name) then
          begin
            if F.Nullable and (F.DefaultValue <> '') and (sNull = '') then
              S := S + ' null';
            S := S + '  /*' + ReplaceSingleQuotmark(F.DisplayName) + '*/';
          end;
        end;
      end;

      T := GetIdxName(Self.RealTableName, f.Name);
      if F.KeyFieldType = cfktId then
      begin
        if dbType = 'SQLITE' then
        begin
          //SQLITE主键在字段中直接定义
          //removed by huz 20230617: 改在字段中直接定义
          if not pkAdded then
          begin
            pkAdded := True;
            //CONSTRAINT xxx PRIMARY KEY (xxx)
            sFdEx := sFdEx + ',' + #13#10 + ExtStr(' ', 6) +
              ExtStr('constraint', 16)+' ' + GetQuotName('PK_' + T)
               + ' primary key (' + GetPrimaryKeyNames(dbType) + ')';
          end;
        end
        else
        if (dbType = 'MYSQL') and (Trim(F.DefaultValue) =
          DEF_VAL_auto_increment) then
        begin
          //mysql自增型主键改在字段中直接定义
        end               
        else if (dbType = 'HIVE') and (G_HiveVersion < 3) then
        begin  //hive2不支持主外键
        end
        else if not pkAdded then
        begin
          pkAdded := True;
          if sPK <> '' then
            sPK := sPK + #13#10;
          sPK := sPK + 'alter  table ' + vTbn + #13#10 +
            '       add constraint ' + GetQuotName('PK_' + T) +
            ' primary key (' + GetPrimaryKeyNames(dbType) + ');';
        end;
        if (F.RelateTable <> '')
          and (F.RelateField <> '') and (Pos('{Link:', F.RelateField)=0) then
        begin
          {if dbType = 'SQLITE' then
          begin
            //SQLITE外键在字段中直接定义
            //removed by huz 20230617: 改在独立语句中
          end
          else}
          if (dbType = 'HIVE') and (G_HiveVersion < 3) then
          begin  //hive2不支持主外键
          end
          else
          begin
            if sFK <> '' then
              sFK := sFK + #13#10;
            sFK := sFK + 'alter  table ' + vTbn + #13#10 +
              '       add constraint ' + GetQuotName('FK_' + T) +
              ' foreign key (' + sFPN + ')' + #13#10 +
              '       references ' + GetQuotName(F.RelateTable) +
              '(' + GetQuotName(F.RelateField) + ');';
          end;
        end;
      end
      else
      begin
        if (F.KeyFieldType = cfktRid) and (F.RelateTable <> '')
          and (F.RelateField <> '') and (Pos('{Link:', F.RelateField)=0) and G_CreateForeignkeys then
        begin
          if dbType = 'SQLITE' then
          begin
            //sqlite外键在字段中直接定义
            //foreign key(classes_id) references classes(id)
            sFdEx := sFdEx + ',' + #13#10 + ExtStr(' ', 6) +
              ExtStr('foreign key', 16) + ' (' + sFPN + GetIndexPrefixInfo(F) + ')'
              + ' references ' + F.RelateTable + '(' + F.RelateField + ')';
          end
          else if (dbType = 'MYSQL') and (Trim(F.DefaultValue) =
            DEF_VAL_auto_increment) then
          begin
            //mysql自增型外键改在字段列表后定义
            //constraint xx foreign key(classes_id) references classes(id)
            sFdEx := sFdEx + ',' + #13#10 + ExtStr(' ', 6) +
              ExtStr('constraint', 16) + ' ' + GetQuotName('IDU_' + T)
              + ' foreign key(' + sFPN + GetIndexPrefixInfo(F) + ')'
              + ' references ' + F.RelateTable + '(' + F.RelateField + ')';
          end
          else if (dbType = 'HIVE') and (G_HiveVersion < 3) then
          begin  //hive2不支持主外键
          end
          else
          begin
            if sFK <> '' then
              sFK := sFK + #13#10;
            sFK := sFK + 'alter  table ' + vTbn + #13#10 +
              '       add constraint ' + GetQuotName('FK_' + T) +
              ' foreign key (' + sFPN + ')' + #13#10 +
              '       references ' + GetQuotName(F.RelateTable) +
              '(' + GetQuotName(F.RelateField) + ');';
          end;
        end;
        if F.IndexType = cfitUnique then
        begin
          if (dbType = 'MYSQL') and (Trim(F.DefaultValue) =
            DEF_VAL_auto_increment) then
          begin
            //mysql自增型唯一索引改在字段列表后直接定义
            sFdEx := sFdEx + ',' + #13#10 + ExtStr(' ', 6) +
              ExtStr('UNIQUE', 16) + ' ' + GetQuotName('IDU_' + T) + '(' + sFPN +
              GetIndexPrefixInfo(F) + ')';
          end 
          else if (dbType = 'HIVE') then
          begin  //hive不支持唯一索引，转成普通索引
            if sIdx <> '' then
              sIdx := sIdx + #13#10;
            sIdx := sIdx + 'create index ' + GetQuotName('IDU_' + T) +
              ' on table ' + vTbn + '(' + sFPN + GetIndexPrefixInfo(F) + ')'#13#10 +
              ' as ''org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler'' with deferred rebuild;';
            if G_HiveVersion >= 3 then
            begin
              sIdx := sIdx + #13#10; //hive3支持唯一约束
              sIdx := sIdx + 'alter table ' + vTbn + ' add constraint ' + GetQuotName('UNQ_' + T) + ' unique (' +  sFPN + GetIndexPrefixInfo(F) + ') disable novalidate;';
            end;
          end
          else
          begin
            if sIdx <> '' then
              sIdx := sIdx + #13#10;
            sIdx := sIdx + 'create unique index ' + GetQuotName('IDU_' + T) +
              ' on ' + vTbn + '(' + sFPN + GetIndexPrefixInfo(F) + ');';
          end;
        end
        else if F.IndexType = cfitNormal then
        begin
          if sIdx <> '' then
            sIdx := sIdx + #13#10;      
          if (dbType = 'HIVE') then
          begin  //hive
            sIdx := sIdx + 'create index ' + GetQuotName('IDU_' + T) +
              ' on table ' + vTbn + '(' + sFPN + GetIndexPrefixInfo(F) + ')'#13#10 +
              ' as ''org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler'' with deferred rebuild;';
          end
          else
            sIdx := sIdx + 'create index ' + GetQuotName('IDX_' + T) +
              ' on ' + vTbn + '(' + sFPN + GetIndexPrefixInfo(F) + ');';
        end
        else if (F.KeyFieldType = cfktRid) and NeedGenFKIndexesSQL(Self) then
        begin
          if sIdx <> '' then
            sIdx := sIdx + #13#10;
          if (dbType = 'HIVE') then
          begin  //hive
            sIdx := sIdx + 'create index ' + GetQuotName('IDU_' + T) +
              ' on table ' + vTbn + '(' + sFPN + GetIndexPrefixInfo(F) + ')'#13#10 +
              ' as ''org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler'' with deferred rebuild;';
          end
          else
            sIdx := sIdx + 'create index ' + GetQuotName('IDX_' + T) +
              ' on ' + vTbn + '(' + sFPN + GetIndexPrefixInfo(F) + ');';
        end;
            
        if Trim(F.DBCheck) <> '' then
        begin
          if sChk <> '' then
            sChk := sChk + #13#10;
          sChk := sChk + 'alter  table ' + vTbn + #13#10 +
            '       add constraint ' + GetQuotName('CHK_' + T) +
            ' check (' + F.DBCheck + ');';
        end;
      end;
    end;

    //多字段索引
    for I := 0 to MetaFields.Count - 1 do
      if MetaFields[I].DataLevel <> ctdlDeleted then
      begin
        f := MetaFields[I];
        if F.DataLevel = ctdlDeleted then
          Continue;
        if F.DataType <> cfdtFunction then
          Continue;
        if F.IndexType = cfitNone then
          Continue;
        if Trim(F.IndexFields) = '' then
          Continue;
        if (Pos(',', F.IndexFields) = 0) and (Pos('(', F.IndexFields) = 0) then
          Continue;
        T := GetIdxName(Self.RealTableName, f.Name);
        if Pos('(', F.IndexFields) > 0 then
          sFPN := f.IndexFields
        else
        begin
          sFPN := '';
          with TStringList.Create do
            try
              CommaText := f.IndexFields;
              for J := 0 to Count - 1 do
              begin
                if sFPN <> '' then
                  sFPN := sFPN + ',';
                sFPN := sFPN + GetQuotName(Strings[J]);
              end;
            finally
              Free;
            end;
        end;
        if sFPN = '' then
          Continue;
        if (dbType = 'HIVE') then
        begin  //hive不支持唯一索引
          sIdx := sIdx + 'create index ' + GetQuotName('IDX_' + T) +
            ' on table ' + vTbn + '(' + sFPN + ')'#13#10+
            ' as ''org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler'' with deferred rebuild;';
        end
        else  if F.IndexType = cfitUnique then
        begin
          if sIdx <> '' then
            sIdx := sIdx + #13#10;
          sIdx := sIdx + 'create unique index ' + GetQuotName('IDU_' + T) +
            ' on ' + vTbn + '(' + sFPN + ');';
        end
        else if F.IndexType = cfitNormal then
        begin
          if sIdx <> '' then
            sIdx := sIdx + #13#10;
          sIdx := sIdx + 'create index ' + GetQuotName('IDX_' + T) +
            ' on ' + vTbn + '(' + sFPN + ');';
        end;
      end;

    if sFdEx <> '' then
      S := S + sFdEx;

    if dbType = 'ORACLE' then
    begin
      if Copy(Self.RealTableName, 1, 3) = 'TT_' then
        S := S + #13#10')'#13#10'on commit delete rows;'
      else if Copy(Self.RealTableName, 1, 3) = 'TS_' then
        S := S + #13#10')'#13#10'on commit preserve rows;'
      else
        S := S + #13#10');';
    end
    else if (dbType = 'MYSQL') or (dbType = 'HIVE') then
    begin
      T := Self.GetTableComments;
      if T <> '' then
      begin
        S := S + #13#10') comment ''' + ReplaceSingleQuotmark(T) + ''';';
      end
      else
        S := S + #13#10');';
    end
    else
      S := S + #13#10');';
    if bCreatTb then
      Infos.Add(S);

    if bCreatTb then
    begin
      if sPK <> '' then
        Infos.Add(sPK);
      if sFK <> '' then
        if bFK then
          Infos.Add(sFK);
      if sIdx <> '' then
        Infos.Add(sIdx);   
      if sChk <> '' then
        Infos.Add(sChk);

      if sComment <> '' then
        Infos.Add(sComment);
      if dbType = 'ORACLE' then
        if G_CreateSeqForOracle and IsSeqNeeded then
          Infos.Add('create sequence SEQ_' + Self.RealTableName + ';');
      //额外的SQL
      if Self.ExtraSQL <> '' then
        Infos.Add(Self.ExtraSQL);
      Infos.Add('');
    end
    else if bFK then
      Infos.Add(sFK);
    Result := infos.Text;
  finally
    infos.Free;
  end;
  if Assigned(CtCurMetaDbConn) then
    Result := CtCurMetaDbConn.OnGenTableSql(Self, bCreatTb, bFK, Result, dbType, '');
  if Assigned(GProc_OnEzdmlGenTbSqlEvent) then
  begin
    Result := GProc_OnEzdmlGenTbSqlEvent(Self, bCreatTb, bFK, Result, dbType, '');
  end;
end;

function TCtMetaTable.GenFKSql: string;
begin
  Result := GenSqlEx(False, True);
end;

function TCtMetaTable.GenDropSql(dbType: string): string;
var
  vTbn: String;
begin
  vTbn := RealTableName;
  if vTbn = '' then
    vTbn := Caption;
  vTbn := GetDbQuotName(vTbn, dbType);
  Result := 'drop table '+vTbn+';';
end;

function TCtMetaTable.GenSelectSql(maxRowCount: integer;
  dbType: string; dbEngine: TCtMetaDatabase): string;
begin
  Result := GenSelectSqlEx(maxRowCount, '', '', '', '', dbType, dbEngine);
end;

function TCtMetaTable.GenSelectSqlEx(maxRowCount: integer;
  selFields, whereCls, groupBy, orderBy, dbType: string; dbEngine: TCtMetaDatabase = nil): string;

  function GetQuotName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);
  end;
     
  function GetQuotTbName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);
    if Trim(OwnerCategory) <> '' then
      Result := OwnerCategory+'.'+Result
    else if dbEngine <> nil then
    begin
      if dbEngine.EngineType='SQLSERVER' then
      begin
        if dbEngine.DbSchema <> '' then
          Result := dbEngine.DbSchema+'.'+Result
        else
          Result := 'dbo.'+Result;
      end;
    end
    else if dbType='SQLSERVER' then
    begin
      Result := 'dbo.'+Result;
    end;
  end;

var
  I, C, exLen: integer;
  vTbn, vFdn, S: string;
  Infos: TStringList;
  f: TCtMetaField;
begin
  Infos := TStringList.Create;
  try
    S := RealTableName;

    vTbn := RealTableName;
    if vTbn = '' then
      vTbn := Caption;
    vTbn := GetQuotTbName(vTbn);

    exLen := 8;
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      if not f.IsPhysicalField then
        Continue;
      if Length(F.Name) > exLen then
        exLen := Length(F.Name);
    end;
    if exLen > 24 then
      exLen := 24;

    Infos.Add('select');
    if maxRowCount > 0 then
    begin
      if dbType = 'SQLSERVER' then
        Infos.Add('  top ' + IntToStr(maxRowCount));
    end;

    S := '';
    C := 0;

    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      if not F.IsPhysicalField then
        Continue;
      Inc(C);
      if C > 1 then
        S := S + ','#13#10;
      vFdn := f.Name;
      vFdn := GetQuotName(vFdn);
      if G_LogicNamesForTableData and (f.DisplayName <> '') and
        (f.DisplayName <> f.Name) then
      begin
        S := S + '  ' + ExtStr(vFdn, exLen);
        S := S + ' as ' + GetQuotName(f.DisplayName);
      end
      else
        S := S + '  ' + vFdn;
    end;
    if S <> '' then
      if dbType = 'ORACLE' then
        S := S + ','#13#10'  t.rowid';

    if Trim(selFields) <> '' then
      S := selFields;

    Infos.Add(S);
    Infos.Add(' from ' + vTbn + ' t');
    if Trim(whereCls)='' then
    begin
      if dbType='HIVE' then               
        Infos.Add('where 1=1')
      else
        Infos.Add('where 1=1/*_SQL_WHERE*/')
    end
    else
      Infos.Add('where ('+whereCls+')');

    if maxRowCount > 0 then
    begin
      if dbType = 'ORACLE' then
      begin
        if Trim(whereCls)='' then
          Infos.Add('  and rownum <= ' + IntToStr(maxRowCount))
        else
          Infos.Add('  and (rownum <= ' + IntToStr(maxRowCount) + ')');
      end;
    end;

    if Trim(groupBy) <> '' then
      Infos.Add('group by ' + groupBy);

    if Trim(orderBy) <> '' then
      Infos.Add('order by ' + orderBy)
    else if orderBy = '' then
    begin
      f := Self.GetPrimaryKeyField;
      if f <> nil then
        if f.DataType <> cfdtInteger then
          f := nil;
      {if f=nil then
      begin
        S := GetPossibleKeyName(cfktModifyDate);
        if S = '' then
          S := GetPossibleKeyName(cfktCreateDate);
        if S <> '' then
          f := Self.MetaFields.FieldByName(S);
      end; }
      if f <> nil then
      begin
        Infos.Add('order by ' + f.Name + ' desc');
      end;
    end;

    if maxRowCount > 0 then
    begin
      if (dbType = 'MYSQL') or (dbType = 'POSTGRESQL')
        or (dbType = 'SQLITE') or (dbType = 'HIVE') then
        Infos.Add('limit ' + IntToStr(maxRowCount));
    end;

    Result := Infos.Text;
  finally
    Infos.Free;
  end;

  if Assigned(CtCurMetaDbConn) then
    Result := CtCurMetaDbConn.OnGenTableSql(Self, False, False, Result,
      dbType, '[GEN_SELECT_SQL][MAXROWCOUNT:' + IntToStr(maxRowCount) + ']');
  if Assigned(GProc_OnEzdmlGenTbSqlEvent) then
  begin
    Result := GProc_OnEzdmlGenTbSqlEvent(Self, False, False, Result,
      dbType, '[GEN_SELECT_SQL][MAXROWCOUNT:' + IntToStr(maxRowCount) + ']');
  end;
end;

function TCtMetaTable.GenJoinSqlWhere(bTable: TCtMetaTable; aAlias,
  bAlias: string; bFKsOnly: Boolean): string;
var
  K: Integer;
  fd: TCtMetaField;
  tbN, S: String;
begin
  Result := '';
  if bTable = nil then
    Exit;
  tbN := Self.RealTableName;
  if aAlias = '' then
    aAlias := tbN;
  if bAlias = '' then
    bAlias := bTable.RealTableName;
  for K:=0 to bTable.MetaFields.Count -1 do
  begin
    fd := bTable.MetaFields.Items[K];
    if fd.DataLevel = ctdlDeleted then
      Continue;
    if bFKsOnly then
    begin
      if not fd.IsPhysicalField then
        Continue;
      if (fd.KeyFieldType <> cfktId) and (fd.KeyFieldType <> cfktRid) then
        Continue;
    end;
    if (UpperCase(fd.RelateTable)=UpperCase(tbN)) and (fd.RelateField<>'') then
    begin
      S := bAlias + '.'+fd.Name+' = '+ aAlias + '.' +fd.RelateField;
      if Result <> '' then
        Result :=  Result + ' and ';
      Result :=  Result + S;
    end;
  end;
       
  tbN := bTable.RealTableName;
  for K:=0 to Self.MetaFields.Count -1 do
  begin
    fd := Self.MetaFields.Items[K];
    if fd.DataLevel = ctdlDeleted then
      Continue;
    if bFKsOnly then
    begin
      if not fd.IsPhysicalField then
        Continue;
      if (fd.KeyFieldType <> cfktId) and (fd.KeyFieldType <> cfktRid) then
        Continue;
    end;
    if (UpperCase(fd.RelateTable)=UpperCase(tbN)) and (fd.RelateField<>'') then
    begin
      S := aAlias + '.'+fd.Name+' = '+ bAlias + '.' +fd.RelateField;
      if Result <> '' then
        Result :=  Result + ' and ';
      Result :=  Result + S;
    end;
  end;
end;

function TCtMetaTable.GetCustomConfigValue(AName: string): string;
begin
  Result := '';
  if FCustomConfigs = '' then
    Exit;
  if Assigned(Proc_JsonPropProc) then
    Result := Proc_JsonPropProc(FCustomConfigs, AName, '', True);
end;

procedure TCtMetaTable.SetCustomConfigValue(AName, AValue: string);
begin
  if AName = '' then
    Exit;
  if Assigned(Proc_JsonPropProc) then
    FCustomConfigs := Proc_JsonPropProc(FCustomConfigs, AName, AValue, False);
end;

function TCtMetaTable.GetDemoJsonData(ARowIndex: Integer; AOpt, AFields: string): string;
begin
  Result := '';
  if Assigned(Proc_GetTableDemoDataJson) then
    Result := Proc_GetTableDemoDataJson(Self, ARowIndex, AOpt, AFields);
end;

function TCtMetaTable.HasUIDesignProps: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I:=0 to MetaFields.Count - 1 do
    if MetaFields.Items[I].DataLevel <> ctdlDeleted then
      if MetaFields.Items[I].HasUIDesignProps then
      begin
        Result := True;
        Exit;
      end;
end;

function TCtMetaTable.GenSql(dbType: string): string;
begin
  Result := GenSqlEx(True, True, dbType);
end;

function TCtMetaTable.GenSqlWithoutFK: string;
begin
  Result := GenSqlEx(True, False);
end;

function TCtMetaTable.GetDescribe: string;

  function CheckDesName(nm: string): string;
  begin
    Result := nm;
    if Pos(' ', Result) > 0 then
      Result := StringReplace(Result, ' ', '#32', [rfReplaceAll]);
    if Pos(#9, Result) > 0 then
      Result := StringReplace(Result, #9, '#9', [rfReplaceAll]);
    if Pos('(', Result) > 0 then
      Result := StringReplace(Result, '(', '#40', [rfReplaceAll]);
    if Pos(')', Result) > 0 then
      Result := StringReplace(Result, ')', '#41', [rfReplaceAll]);
  end;

  function GetDesName(phy, nm: string): string;
  begin
    phy := CheckDesName(phy);
    nm := CheckDesName(nm);
    Result := nm;
    if Result = '' then
      Result := phy
    else if (phy <> '') and (Result <> phy) then
      Result := phy + '(' + Result + ')';
  end;

var
  I, L, LM: integer;
  S, T, CSTR, FT: string;
  Infos: TStringList;
  f: TCtMetaField;
begin
  if not IsTable then
  begin
    Result := Name;
    Exit;
  end;
  Infos := TStringList.Create;
  try
    L := 0;
    for I := 0 to MetaFields.Count - 1 do
      if MetaFields[I].DataLevel <> ctdlDeleted then
      begin
        f := MetaFields[I];
        S := GetDesName(f.Name, f.DisplayName);
        if L < Length(S) then
          L := Length(S);
      end;
    LM := 0;
    for I := 0 to MetaFields.Count - 1 do
      if MetaFields[I].DataLevel <> ctdlDeleted then
      begin
        f := MetaFields[I];
        S := ExtStr(GetDesName(f.Name, f.DisplayName), L);
        FT := f.GetFieldTypeDesc(False, 'DESC');

        if LM < Length(S + ' ' + FT) then
          LM := Length(S + ' ' + FT);

        T := F.Memo;
        if F.DataType = cfdtFunction then
          if F.Memo = F.IndexFields then
            T := '';
        if G_WriteConstraintToDescribeStr then
        begin
          CSTR := f.GetConstraintStrEx(False, True);
          if CSTR <> '' then
          begin
            CSTR := '<<' + CSTR + '>>';
          end;
          T := CSTR + T;
        end;
        if T <> '' then
        begin
          T := StringReplace(T, '\', '\\', [rfReplaceAll]);
          T := StringReplace(T, #13, '\r', [rfReplaceAll]);
          T := StringReplace(T, #10, '\n', [rfReplaceAll]);
          S := S + ' ' + ExtStr(FT, 11) + ' //' + T;
        end
        else
          S := S + ' ' + FT;

        Infos.Add(S);
      end;
    //Infos.Add('');

    S := Trim(Name);
    if Trim(PhysicalName) <> '' then
      if Trim(PhysicalName) <> Name then
        S:=S + ':' + Trim(PhysicalName);
    S := GetDesName(S, Trim(Caption));
    if LM < Length(S) then
      LM := Length(S);
    T := ExtStr('-', LM, '-');
    Infos.Insert(0, T);
    if Memo <> '' then
    begin
      T := Memo;
      T := StringReplace(T, '\', '\\', [rfReplaceAll]);
      T := StringReplace(T, #13, '\r', [rfReplaceAll]);
      T := StringReplace(T, #10, '\n', [rfReplaceAll]);
      Infos.Insert(0, '//' + T);
    end;
    Infos.Insert(0, S);

    Result := Infos.Text;
  finally
    infos.Free;
  end;
end;

function TCtMetaTable.GetUIDisplayName: string;
var
  I: integer;
begin
  Result := FUIDisplayText;
  if Result <> '' then
    Exit;
  Result := Self.Caption;
  if Result <> '' then
    Exit;

  Result := Name;
  for I := 0 to High(CtTbNamePrefixDefs) do
    if Pos(UpperCase(CtTbNamePrefixDefs[i]), UpperCase(Result)) = 1 then
    begin
      Result := Copy(Result, Length(CtTbNamePrefixDefs[i]) + 1, Length(Result));
      Break;
    end;
end;

procedure TCtMetaTable.SetDescribe(const Value: string);
var
  I, LI: integer;
  LN, S, T, FT: string;
  Infos: TStringList;
  f: TCtMetaField;

  function GetNextLine: boolean;
  begin
    LN := '';
    repeat
      if LI >= Infos.Count then
        Break;
      LN := Trim(Infos[LI]);
      Inc(LI);
    until (LI >= Infos.Count) or (LN <> '');
    Result := (LN <> '');
  end;

  function GetMemo(AStr: string): string;
  begin
    Result := '';
    AStr := AStr + #13#10;
    if Pos('//', AStr) > 0 then
    begin
      Result := ExtractCompStr(AStr, '//', #13#10);
      Result := StringReplace(Result, '\n', #10, [rfReplaceAll]);
      Result := StringReplace(Result, '\r', #13, [rfReplaceAll]);
      Result := StringReplace(Result, '\\', '\', [rfReplaceAll]);
    end;
  end;

  function CheckDesName(nm: string): string;
  begin
    Result := nm;
    if Pos('#32', Result) > 0 then
      Result := StringReplace(Result, '#32', ' ', [rfReplaceAll]);
    if Pos('#9', Result) > 0 then
      Result := StringReplace(Result, '#9', #9, [rfReplaceAll]);
    if Pos('#40', Result) > 0 then
      Result := StringReplace(Result, '#40', '(', [rfReplaceAll]);
    if Pos('#41', Result) > 0 then
      Result := StringReplace(Result, '#41', ')', [rfReplaceAll]);
  end;

  procedure DeleteMemo(var AStr: string);
  begin
    AStr := AStr + #13#10;
    while Pos('//', AStr) > 0 do
    begin
      AStr := AddOrModifyCompStr(AStr, 'XXX', '//', #13#10);
      AStr := StringReplace(AStr, '//XXX'#13#10, '', [rfReplaceAll]);
    end;
    AStr := Trim(AStr);
  end;

  procedure SetDesName(Des: string; var Phy, Nam, Mem, Tp: string);
  var
    vPhy, vNam, vMem, vTemp: string;
    po: integer;
  begin
    vMem := GetMemo(Des); //获取注释
    if Trim(vMem) <> '' then
      Mem := vMem;
    DeleteMemo(Des); //删除注释
    //Des := StringReplace(Des, ':', ' ', [rfReplaceAll]);
    Des := StringReplace(Des, ';', ' ', [rfReplaceAll]);
    Des := StringReplace(Des, #9, ' ', [rfReplaceAll]);
    while Pos('  ', Des) > 0 do
      Des := StringReplace(Des, '  ', ' ', [rfReplaceAll]);

    vTemp := Des; //获取逻辑名
    po := Pos('(', vTemp);
    if Pos(' ', vTemp) > 0 then
      if po > Pos(' ', vTemp) then
        po := 0;
    if po > 0 then
    begin
      vTemp := Trim(Copy(vTemp, 1, po - 1));
      if Pos(' ', vTemp) = 0 then
      begin
        vNam := ExtractCompStr(Des, '(', ')');
        if vNam <> '' then
        begin
          Des := ModifyCompStr(Des, 'XXX', '(', ')');
          Des := StringReplace(Des, '(XXX)', '', [rfReplaceAll]);
        end;
      end;
    end
    else
    begin
      vTemp := Des;
      po := Pos('（', vTemp);
      if po > 0 then
      begin
        vTemp := Trim(Copy(vTemp, 1, po - 1));
        if Pos(' ', vTemp) = 0 then
        begin
          vNam := ExtractCompStr(Des, '（', '）');
          if vNam <> '' then
          begin
            Des := ModifyCompStr(Des, 'XXX', '（', '）');
            Des := StringReplace(Des, '（XXX）', '', [rfReplaceAll]);
          end;
        end;
      end
      else
      begin
        vTemp := Des;
        po := Pos(' ', vTemp);
        if po > 0 then
        begin
          vTemp := Trim(Copy(vTemp, 1, po - 1));
          vNam := ExtractCompStr(Des, ' ', ' ');
          if vNam <> '' then
          begin
            Des := ModifyCompStr(Des, 'XXX', ' ', ' ');
            Des := Trim(StringReplace(Des, ' XXX ', ' ', [rfReplaceAll]));
          end;
        end;
      end;
    end;

    //获取类型
    Tp := Trim(ExtractCompStr(Des + '//', ' ', '//'));
    if Pos(' ', Des) = 0 then
      vPhy := Des
    else
    begin
      vPhy := AddOrModifyCompStr(Des + '//', 'XXX', ' ', '//');
      vPhy := StringReplace(vPhy, ' XXX//', '', [rfReplaceAll]);
    end;
    vPhy := Trim(vPhy);
    if vPhy = '' then
    begin
      vPhy := vNam;
      vNam := '';
    end;
    vPhy := CheckDesName(vPhy);
    vNam := CheckDesName(vNam);
    if Phy = Nam then
      Nam := '';
    if vPhy <> vNam then
      Nam := vNam;
    if vPhy <> '' then
      Phy := vPhy;
  end;

  procedure SetDesFieldType;
  var
    II: TCtFieldDataType;
    po: integer;
    vTemp, vTpName, vFullName: string;
    bHasLen: boolean;
  begin
    bHasLen := False;
    vTpName := '';
    if Pos('（', FT) > 0 then
    begin
      FT := StringReplace(FT, '（', '(', [rfReplaceAll]);
      FT := StringReplace(FT, '）', ')', [rfReplaceAll]);
    end;
    po := Pos('(', FT);
    if po > 0 then
    begin
      bHasLen := True;
      vTemp := Trim(ExtractCompStr(FT, '(', ')'));
      FT := Trim(Copy(FT, 1, po - 1));

      FT := StringReplace(FT, '，', ',', [rfReplaceAll]);
      po := Pos(',', vTemp);
      if po > 0 then
      begin
        f.DataLength := StrToIntDef(Trim(Copy(vTemp, 1, po - 1)), 0);
        vTemp := Trim(Copy(vTemp, po + 1, Length(vTemp)));
        f.DataScale := StrToIntDef(vTemp, 0);
      end
      else
      begin
        f.DataLength := StrToIntDef(vTemp, 0);
        f.DataScale := 0;
      end;
    end
    else
    begin
      f.DataLength := 0;
      f.DataScale := 0;
    end;

    if UpperCase(Copy(FT, 1, 2)) = 'PK' then
    begin
      if f.DataType = cfdtUnknow then
        f.DataType := cfdtInteger;
      f.KeyFieldType := cfktId;
      if Length(FT) > 2 then
        FT := Copy(FT, 3, Length(FT))
      else
        Exit;

      if UpperCase(FT) = 'INC' then
      begin
        FT := 'Integer';
        f.DataType := cfdtInteger;
        f.DefaultValue := DEF_VAL_auto_increment;
      end;
    end
    else if UpperCase(Copy(FT, 1, 2)) = 'FK' then
    begin
      if f.DataType = cfdtUnknow then
        f.DataType := cfdtInteger;
      f.KeyFieldType := cfktRid;
      if Length(FT) > 2 then
        FT := Copy(FT, 3, Length(FT))
      else
        Exit;
    end
    else if f.KeyFieldType in [cfktId, cfktRid] then
      f.KeyFieldType := cfktNormal;

    vFullName := FT;
    po := Pos(':', FT);
    if po > 0 then
    begin
      vTpName := Trim(Copy(FT, po + 1, Length(FT)));
      FT := Trim(Copy(FT, 1, po - 1));
    end
    else
    begin
      po := Pos('：', FT);
      if po > 0 then
      begin
        vTpName := Trim(Copy(FT, po + 2, Length(FT)));
        FT := Trim(Copy(FT, 1, po - 1));
      end;
    end;

    for II := Low(TCtFieldDataType) to High(TCtFieldDataType) do
    begin
      if UpperCase(FT) = UpperCase(DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[II]) then
      begin
        f.DataType := II;
        if vTpName <> '' then
          f.DataTypeName := vTpName;
        Exit;
      end;
    end;
    for II := Low(TCtFieldDataType) to High(TCtFieldDataType) do
    begin
      if UpperCase(FT) = UpperCase(DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[II]) then
      begin
        f.DataType := II;
        if vTpName <> '' then
          f.DataTypeName := vTpName;
        Exit;
      end;
    end;
    for II := Low(TCtFieldDataType) to High(TCtFieldDataType) do
    begin
      if UpperCase(FT) = UpperCase(DEF_CTMETAFIELD_DATATYPE_NAMES_A[II]) then
      begin
        f.DataType := II;
        if vTpName <> '' then
          f.DataTypeName := vTpName;
        Exit;
      end;
    end;

    FT := vFullName;
    if (f.DisplayName = '') and not bHasLen and
      (GetCtFieldDataTypeOfAliasEx(FT, False) = cfdtUnknow) then
      f.DisplayName := FT
    else
    begin
      f.DataType := GetCtFieldDataTypeOfAlias(FT);
      f.DataTypeName := FT;
    end;
  end;

var
  vPhy, vNam, vMem, vTp, vCstr: string;
  J, po, cspo: integer;
  bNewF: boolean;
begin
  if not IsTable then
  begin
    Name := Value;
    Exit;
  end;
  Infos := TStringList.Create;
  try
    Infos.Text := Value;
    LI := 0;

    if not GetNextLine then //读取名称
      Exit;
    S := LN;
    if not GetNextLine then
      Exit;
    T := LN;
    if Copy(T, 1, 2) = '//' then //读取注释
    begin
      if not GetNextLine then
        Exit;
      T := GetMemo(T);
      if Trim(T) <> '' then
        Memo := T;
      T := LN;
    end;
    if Copy(T, 1, 2) = '--' then
    begin
      FT := '';
      vPhy := '';
      SetDesName(S, vPhy, FCaption, FMemo, FT);
      po := Pos(':', vPhy);
      if po>0 then
      begin
        FName := Trim(Copy(vPhy, 1, po -1));
        FPhysicalName := Trim(Copy(vPhy, po+1, Length(vPhy)));
      end
      else
      begin
        FName := vPhy;
        FPhysicalName := '';
      end;
      if (FCaption = '') and (FT <> '') then
        FCaption := FT;
    end
    else
      LI := 0; //读不到名称则复位,从第一行开始读字段

    //标记原有的字段
    for I := MetaFields.Count - 1 downto 0 do
      if MetaFields[I].DataLevel = ctdlDeleted then
        MetaFields.Delete(I);
    for I := 0 to MetaFields.Count - 1 do
      MetaFields[I].UserObject['OLD'] := TObject(1);

    //读取字段
    I := 0;
    while GetNextLine do
    begin
      vPhy := '';
      vNam := '';
      vMem := '';
      vTp := '';
      SetDesName(LN, vPhy, vNam, vMem, vTp);
      if vPhy = '' then
        Continue;

      f := TCtMetaField(MetaFields.ItemByName(vPhy));
      if f = nil then
      begin
        f := MetaFields.NewMetaField;
        f.DataType := cfdtUnknow;
        bNewF := True;
      end
      else
        bNewF := False;
      J := MetaFields.IndexOf(f);
      if (J >= 0) and (J <> I) and (I < MetaFields.Count) then
        MetaFields.Exchange(I, J);
      f.UserObject['OLD'] := TObject(0);
      f.Name := vPhy;
      f.DisplayName := vNam;
      FT := vTp;
      //SetDesName(LN, f.FName, f.FDisplayName, f.FMemo, FT);
      //if FT <> DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[f.DataType] then
      SetDesFieldType; //读取字段类型
      if f.DataType = cfdtUnknow then
        if bNewF then
          f.DataType := cfdtString;

      //判断注释是否有约束
      if Copy(vMem, 1, 2) = '<<' then
      begin
        cspo := Pos('>>', vMem);
        if cspo > 0 then
        begin
          vCstr := Copy(vMem, 1 + 2, cspo - 1 - 2);
          vMem := Copy(vMem, cspo + 2, Length(vMem));
          if vCstr <> '' then
            f.SetConstraintStrEx(vCstr, False)
          else
            f.SetConstraintStrEx('', True);
        end;
      end;

      if vMem = '' then
      begin
        if f.DataType = cfdtFunction then
          if f.IndexType <> cfitNone then
            vMem := f.IndexFields;
      end
      else if f.DataType = cfdtFunction then
      begin
        if f.IndexType <> cfitNone then
          if bNewF then
            if f.IndexFields = '' then
              f.IndexFields := vMem;
      end;
      f.Memo := vMem;

      Inc(I);
    end;

    //删除不在描述字中的字段
    for I := MetaFields.Count - 1 downto 0 do
      if MetaFields[I].UserObject['OLD'] = TObject(1) then
        MetaFields.Delete(I);

    MetaFields.SaveCurrentOrder;
  finally
    infos.Free;
  end;
end;

procedure TCtMetaTable.SyncPropFrom(ACtTable: TCtMetaTable);
var
  S: string;
  tmpList: TCtMetaFieldList;
begin
  S := Self.GraphDesc;

  tmpList := TCtMetaFieldList.Create;
  try
    tmpList.AssignFrom(Self.MetaFields);

    inherited AssignFrom(ACtTable);
    AssignTbPropsFrom(ACtTable);
    Self.GraphDesc := S;
    FCellTreeId := ACtTable.FCellTreeId;

    if Assigned(ACtTable.FMetaFields) then
      MetaFields.SyncFieldsFrom(ACtTable.FMetaFields, tmpList);

  finally
    tmpList.Free;
  end;
end;

function TCtMetaTable.GetKeyFieldName: string;
var
  I: integer;
begin
  Result := '';
  if FMetaFields = nil then
    Exit;
  for I := 0 to FMetaFields.Count - 1 do
    if FMetaFields[I].DataLevel <> ctdlDeleted then
      if FMetaFields[I].KeyFieldType = cfktId then
      begin
        Result := FMetaFields[I].Name;
        Exit;
      end;
end;

procedure TCtMetaTable.SetExcelText(AValue: string);
begin

end;

function TCtMetaTable.GenDqlDmlSql(dbType: string; sqlType: string): string;

  function GetQuotName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);
  end;

var
  I, C, exLen, aFC: integer;
  vTbn, vFdn, S, sEnd: string;
  Infos: TStringList;
  f: TCtMetaField;
begin
  Infos := TStringList.Create;
  try
    S := RealTableName;

    vTbn := RealTableName;
    if vTbn = '' then
      vTbn := Caption;
    vTbn := GetQuotName(vTbn);

    exLen := 8;
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      if not F.IsPhysicalField then
        Continue;
      if Length(F.Name) > exLen then
        exLen := Length(F.Name);
    end;
    if exLen > 24 then
      exLen := 24;

    if (sqlType = '') then
      sEnd := ';'
    else
      sEnd := '';

    C := 0;
    for I := 0 to MetaFields.Count - 1 do
    begin
      f := MetaFields[I];
      if not F.IsPhysicalField then
        Continue;
      Inc(C);
    end;
    aFC := C;

    if (sqlType = '') or (Pos('select', sqlType) > 0) then
    begin
      Infos.Add('select');
      S := '';
      C := 0;

      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        Inc(C);
        if C > 1 then
          S := S + ','#13#10;
        vFdn := GetQuotName(f.Name);
        if (f.DisplayName <> '') and (f.DisplayName <> f.Name) then
        begin
          S := S + '  ' + ExtStr(vFdn, exLen);
          S := S + ' as ' + GetQuotName(f.DisplayName);
        end
        else
          S := S + '  ' + vFdn;
      end;
      Infos.Add(S);
      Infos.Add('from ' + vTbn + ' t' + sEnd);
      Infos.Add('');
    end;

    if (sqlType = '') or (Pos('insert', sqlType) > 0) then
    begin
      Infos.Add('insert into ' + vTbn);
      Infos.Add('(');
      S := '';
      C := 0;
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        Inc(C);
        if C > 1 then
          S := S + ','#13#10;
        vFdn := GetQuotName(f.Name);
        S := S + '  ' + vFdn;
      end;
      Infos.Add(S);
      Infos.Add(')');
      Infos.Add('values(');
      S := '';
      C := 0;
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        Inc(C);
        vFdn := f.Name;
        if dbType='HIVE' then
        begin
          S := S + '  :v_' + ExtStr(vFdn + ',', exLen) + ' --' + vFdn + #13#10;
        end
        else if C = aFC then
          S := S + '  :v_' + ExtStr(vFdn, exLen) + ' /*' + vFdn + '*/'
        else
          S := S + '  :v_' + ExtStr(vFdn + ',', exLen) + ' /*' + vFdn + '*/'#13#10;
      end;
      Infos.Add(S);
      Infos.Add(')' + sEnd);
      Infos.Add('');
    end;

    if (sqlType = '') or (Pos('insert_value', sqlType) > 0) then
    begin

      Infos.Add('insert into ' + vTbn);
      Infos.Add('(');
      S := '';
      C := 0;
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        Inc(C);
        if C > 1 then
          S := S + ','#13#10;
        vFdn := GetQuotName(f.Name);
        S := S + '  ' + vFdn;
      end;
      Infos.Add(S);
      Infos.Add(')');
      Infos.Add('values(');
      S := '';
      C := 0;
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        Inc(C);

        if F.IsFK and F.Nullable then
          vFdn := 'null'
        else if F.DataType = cfdtBlob then
          vFdn := 'null'
        else
        begin
          vFdn := f.GenDemoData(1, '[VALUE_ONLY]', nil);
          vFdn := f.GetSqlQuotValue(vFdn, dbType, nil);
        end;

        if dbType='HIVE' then
        begin
          S := S + '  ' + ExtStr(vFdn + ',', exLen) + ' --' + f.Name + #13#10;
        end
        else if C = aFC then
          S := S + '  ' + ExtStr(vFdn, exLen) + ' /*' + f.Name + '*/'
        else
          S := S + '  ' + ExtStr(vFdn + ',', exLen) + ' /*' + f.Name + '*/'#13#10;
      end;
      Infos.Add(S);
      Infos.Add(')' + sEnd);

      Infos.Add('');
    end;

    if (sqlType = '') or (Pos('update', sqlType) > 0) then
    begin
      Infos.Add('update ' + vTbn);
      Infos.Add('set');
      S := '';
      C := 0;
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        Inc(C);
        if C > 1 then
          S := S + ','#13#10;
        vFdn := GetQuotName(f.Name);
        S := S + '  ' + ExtStr(vFdn, exLen);
        S := S + ' = :v_' + vFdn;
      end;
      Infos.Add(S);
      S := KeyFieldName;
      if S = '' then
        S := 'id';
      Infos.Add('where ' + S + ' = :v_' + S + sEnd);

      Infos.Add('');

    end;

    if (sqlType = '') or (Pos('delete', sqlType) > 0) then
    begin
      Infos.Add('delete from ' + vTbn);
      Infos.Add('where ' + S + ' = :v_' + S + sEnd);
    end;


    if (dbType = 'ORACLE') and (sqlType = '') then
    begin
      Infos.Add('');
      Infos.Add('-- PL/SQL Test --');
      Infos.Add('');
      Infos.Add('declare');
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        vFdn := f.Name;
        Infos.Add('  v_' + ExtStr(vFdn, exLen) + '  ' +
          F.GetFieldTypeDesc(True, 'ORACLE') + ';');
      end;
      Infos.Add('begin');
      Infos.Add('  select');
      C := 0;
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        Inc(C);
        vFdn := f.Name;
        if C = aFC then
          Infos.Add('    ' + vFdn)
        else
          Infos.Add('    ' + vFdn + ',');
      end;
      Infos.Add('  into');
      C := 0;
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        Inc(C);
        vFdn := f.Name;
        if C = aFC then
          Infos.Add('    v_' + vFdn)
        else
          Infos.Add('    v_' + vFdn + ',');
      end;
      Infos.Add('  from ' + vTbn);
      if Self.GetKeyFieldName <> '' then
        Infos.Add('  where ' + Self.GetKeyFieldName + ' = :p_' +
          Self.GetKeyFieldName + ';')
      else
        Infos.Add('  where xxx=xxx;');
      Infos.Add('end;');

      Infos.Add('');
      Infos.Add('-- DOA Variable Declaration --');
      Infos.Add('');
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        vFdn := f.Name;
        Infos.Add('  DeclareVariable(''' + vFdn + ''', ' +
          DEF_CTMETAFIELD_DATATYPE_NAMES_DOATYPE[F.DataType] + ');');
      end;
      Infos.Add('');
      for I := 0 to MetaFields.Count - 1 do
      begin
        f := MetaFields[I];
        if not F.IsPhysicalField then
          Continue;
        vFdn := f.Name;
        Infos.Add('  SetVariable(''' + vFdn + ''', ' + vFdn + ');');
      end;
    end;
    Result := infos.Text;
  finally
    infos.Free;
  end;   
  if Assigned(GProc_OnEzdmlGenDataSqlEvent) then
  begin
    Result := GProc_OnEzdmlGenDataSqlEvent(Self, 'DQL_DML_SQL', Result, '', '', dbType, '[SQL_TYPE:' + sqlType + ']');
  end;
end;

function TCtMetaTable.GenTestDataInsertSql(row: Integer; dbType: string; opt: string; dbEngine: TCtMetaDatabase): string;

  function GetQuotName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);
  end;
      
  function GetQuotTbName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);
    if Trim(OwnerCategory) <> '' then
      Result := OwnerCategory+'.'+Result
    else if dbEngine <> nil then
    begin
      if dbEngine.EngineType='SQLSERVER' then
      begin
        if dbEngine.DbSchema <> '' then
          Result := dbEngine.DbSchema+'.'+Result
        else
          Result := 'dbo.'+Result;
      end;
    end
    else if dbType='SQLSERVER' then
    begin
      Result := 'dbo.'+Result;
    end;
  end;

var
  I, C, exLen, aFC: integer;
  vTbn, vFdn, S: string;
  f: TCtMetaField;
begin
  vTbn := RealTableName;
  if vTbn = '' then
    vTbn := Caption;
  vTbn := GetQuotTbName(vTbn);

  exLen := 8;
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not F.IsPhysicalField then
      Continue;
    if Length(F.Name) > exLen then
      exLen := Length(F.Name);
  end;
  if exLen > 24 then
    exLen := 24;

  C := 0;
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not F.IsPhysicalField then
      Continue;
    Inc(C);
  end;
  aFC := C;

  S := 'insert into ' + vTbn + '(';
  C := 0;
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not F.IsPhysicalField then
      Continue;
    if F.KeyFieldType=cfktId then
      if Trim(F.DefaultValue) = DEF_VAL_auto_increment then  
        Continue;
    Inc(C);
    if (C > 1) then
      S := S + ', ';
    vFdn := GetQuotName(f.Name);
    S := S + vFdn;
  end;
  S := S+ ')'#13#10;
  S := S+'values(';
  C := 0;
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not F.IsPhysicalField then
      Continue;    
    if F.KeyFieldType=cfktId then
      if Trim(F.DefaultValue) = DEF_VAL_auto_increment then
        Continue;
    Inc(C);
                             
    if F.IsFK and (F.KeyFieldType<>cfktId) then
    begin
      vFdn := 'null';
      if Pos('[REF_FK_VALUES]', opt)>0 then
      begin
        vFdn := '/*_FK:'+Self.RealTableName+'.'+F.Name+'*/null';
      end;
    end   
    else if (F.KeyFieldType=cfktId) and (F.DataType=cfdtInteger) then
    begin
      if (Pos('[GEN_PK_BY_SEQ]', opt) > 0) and (dbType='ORACLE') then
        vFdn := 'seq_'+Self.RealTableName+'.nextval'
      //else if (Pos('[GEN_PK_BY_SEQ]', opt) > 0) and (dbType='POSTGRESQL') then
      //  vFdn := 'nextval(seq_'+Self.RealTableName+')'
      else
        vFdn := IntToStr(row+1) + '/*_PK:'+RealTableName+'.'+F.Name+'*/';
    end           
    else if F.DataType = cfdtBlob then
      vFdn := 'null'
    else if (F.KeyFieldType=cfktId) and (F.DataType=cfdtString)
      and (Trim(F.TestDataType) = '') and (Trim(F.TestDataRules) = '')then
    begin
      vFdn := LowerCase(CtGenGUID);
      vFdn := f.GetSqlQuotValue(vFdn, dbType, dbEngine);
    end
    else
    begin
      vFdn := f.GenDemoData(row, '[VALUE_ONLY]', nil);
      if vFdn = '_null' then
        vFdn := 'null'
      else
      begin
        case f.PossibleKeyFieldType of
          cfktComment:
          begin
            vFdn := vFdn+'[GEN_BY_EZDML]';
          end;
          cfktDataLevel:
          begin
            if StrToIntDef(vFdn, 0) <> 0 then
              if Random(20)>4 then
                vFdn := '0';
          end;
        end;
        vFdn := f.GetSqlQuotValue(vFdn, dbType, dbEngine);
      end;
    end;

    if (C > 1) then
      S := S + ', ';
    S := S + vFdn;
  end;
  S := S+ ');';

  Result := S;

  if Assigned(GProc_OnEzdmlGenDataSqlEvent) then
  begin
    Result := GProc_OnEzdmlGenDataSqlEvent(Self, 'TEST_DATA_INSERT_SQL', Result, IntToStr(row), '', dbType, opt);
  end;
end;

function TCtMetaTable.GenSelectRandRelateKeySql(fd: TCtMetaField; maxrow: Integer;
  dbType: string; opt: string; dbEngine: TCtMetaDatabase): string;

  function GetQuotName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);
  end;

  function GetQuotTbName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, dbType);
    if Trim(OwnerCategory) <> '' then
      Result := OwnerCategory+'.'+Result
    else if dbEngine <> nil then
    begin
      if dbEngine.EngineType='SQLSERVER' then
      begin
        if dbEngine.DbSchema <> '' then
          Result := dbEngine.DbSchema+'.'+Result
        else
          Result := 'dbo.'+Result;
      end;
    end
    else if dbType='SQLSERVER' then
    begin
      Result := 'dbo.'+Result;
    end;
  end;

var
  vTbn, vFdn, S: string;
begin
  vTbn := fd.RelateTable;
  vTbn := GetQuotTbName(vTbn);
  vFdn := GetQuotName(fd.RelateField);
  if maxRow <= 0 then
    maxRow := 1;

  if dbType ='ORACLE' then
  begin
    S := 'select '+vFdn+' from(select '+vFdn+' from '+vTbn+' where '+vFdn+' is not null order by dbms_random.value) where rownum <= '+IntToStr(maxRow);
  end else if dbType ='SQLSERVER' then
  begin
    S := 'select top '+IntToStr(maxRow)+' '+vFdn+' from '+vTbn+' where '+vFdn+' is not null order by NEWID()';
  end else if (dbType ='MYSQL') or (dbType ='HIVE') then
  begin
    S := 'select '+vFdn+' from '+vTbn+' where '+vFdn+' is not null order by rand() limit '+IntToStr(maxRow);
  end else if dbType ='POSTGRESQL' then
  begin
    S := 'select '+vFdn+' from '+vTbn+' where '+vFdn+' is not null order by random() limit '+IntToStr(maxRow);
  end else if dbType ='SQLITE' then
  begin
    S := 'select '+vFdn+' from '+vTbn+' where '+vFdn+' is not null order by random() limit '+IntToStr(maxRow);
  end else
  begin
    S := 'select '+vFdn+' from '+vTbn+' where '+vFdn+' is not null /*order by random() limit '+IntToStr(maxRow)+'*/';
  end;
  Result := S;

  if Assigned(GProc_OnEzdmlGenDataSqlEvent) then
  begin
    Result := GProc_OnEzdmlGenDataSqlEvent(Self, 'SELECT_RAND_RELATE_KEY_SQL', Result, fd.Name, IntToStr(maxRow), dbType, opt);
  end;
end;

function TCtMetaTable.GenSelectSqlNoDb(maxRowCount: integer; dbType: string
  ): string;
begin
  Result := GenSelectSql(maxRowCount, dbType, nil);
end;

function TCtMetaTable.GetTableComments: string;
begin
  Result := Memo;
  if Result <> '' then
  begin
    if (Name <> '') and (Caption <> '') and (Name <> Caption) and (RealTableName <> Caption) then
      Result := Caption + ' ' + Result;
  end
  else if (Name <> Caption) and (Caption <> '') and (Caption <> RealTableName)then
    Result := Caption;
end;

function TCtMetaTable.IsSeqNeeded: boolean;
var
  I, C: integer;
  f: TCtMetaField;
begin
  Result := False;
  C := 0;
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not F.IsPhysicalField then
      Continue;
    if f.KeyFieldType = cfktId then
    begin
      Inc(C);
      if C = 1 then
        if f.DataType = cfdtInteger then
          Result := True;
    end;
  end;
  if C <> 1 then
    Result := False;
end;

function TCtMetaTable.IsSqlText: boolean;
begin
  Result := False;
  if IsText then
  begin
    if Copy(Memo, 1, Length(DEF_SQLTEXT_MARK)) = DEF_SQLTEXT_MARK then
      Result := True;
  end;
end;

function TCtMetaTable.GetPrimaryKeyField: TCtMetaField;
var
  I: integer;
  f: TCtMetaField;
begin
  Result := nil;
  for I := 0 to MetaFields.Count - 1 do
  begin
    f := MetaFields[I];
    if not f.IsPhysicalField then
      Continue;
    if f.KeyFieldType = cfktId then
    begin
      Result := f;
      Exit;
    end;
  end;
end;

function TCtMetaTable.IsManyToManyLinkTable: Boolean;
var
  I: Integer;
  fd: TCtMetaField;
begin
  Result := False;
  MetaFields.Pack;   
  if MetaFields.Count < 2 then
    Exit;
  for I:=0 to 1 do
  begin
    fd := MetaFields.Items[I];
    if not fd.IsPhysicalField then
      Exit;
    if fd.KeyFieldType <> cfktRid then
      Exit;
    if Trim(fd.RelateTable)='' then
      Exit;
    if Trim(fd.RelateField)='' then
      Exit;
  end;
  if Pos('/*[m2m_link]*/', LowerCase(Self.Memo))>0 then
  begin
    Result := True;
    Exit;
  end;
  if MetaFields.Count <> 2 then
    Exit;
  Result := True;
end;

function TCtMetaTable.GetOneToManyInfo(bFKsOnly: Boolean): string;
var
  I, J, K: Integer;
  md: TCtDataModelGraph;
  tb: TCtMetaTable;
  fd: TCtMetaField;
  tbN, S: String;
  ss: TStringList;
begin
  tbN := Self.Name;
  ss:= TStringList.Create;
  try
    for I:=0 to FGlobeDataModelList.Count-1 do
    begin
      md := FGlobeDataModelList.Items[I];
      for J:=0 to md.Tables.Count-1 do
      begin
        tb := md.Tables.Items[J];   
        if tb.IsManyToManyLinkTable then
          Continue;
        for K:=0 to tb.MetaFields.Count -1 do
        begin
          fd := tb.MetaFields.Items[K];
          if fd.DataLevel = ctdlDeleted then
            Continue;
          if bFKsOnly then
          begin
            if not fd.IsPhysicalField then
              Continue;      
            if (fd.KeyFieldType <> cfktId) and (fd.KeyFieldType <> cfktRid) then
              Continue;
          end;
          if (UpperCase(fd.RelateTable)=UpperCase(tbN)) and (fd.RelateField<>'') then
          begin
            S := tb.Name + '.'+fd.Name+':'+fd.RelateField;
            if ss.IndexOf(S) < 0 then
              ss.add(S);
          end;
        end;
      end;
    end;
    Result:=ss.Text;
  finally
    ss.Free;
  end;
end;

function TCtMetaTable.GetManyToManyInfo: string;
var
  I, J: Integer;
  md: TCtDataModelGraph;
  tb: TCtMetaTable;
  fd: TCtMetaField;
  tbN, S, S1, S2: String;
  ss: TStringList;
begin
  tbN := Self.Name;
  ss:= TStringList.Create;
  try
    for I:=0 to FGlobeDataModelList.Count-1 do
    begin
      md := FGlobeDataModelList.Items[I];
      for J:=0 to md.Tables.Count-1 do
      begin
        tb := md.Tables.Items[J];
        if not tb.IsManyToManyLinkTable then
          Continue;
        S1 := '';
        S2 := '';
        fd := tb.MetaFields.Items[0];
        if (UpperCase(fd.RelateTable)=UpperCase(tbN)) and (fd.RelateField<>'') then
        begin
          S2 := fd.RelateField;   
          fd := tb.MetaFields.Items[1];
          S1 := fd.RelateTable + '.'+fd.RelateField;
        end
        else
        begin    
          fd := tb.MetaFields.Items[1];
          if (UpperCase(fd.RelateTable)=UpperCase(tbN)) and (fd.RelateField<>'') then
          begin
            S2 := fd.RelateField;
            fd := tb.MetaFields.Items[0];
            S1 := fd.RelateTable + '.'+fd.RelateField;
          end;
        end;
        if S1 <> '' then
        begin
          S := S1+':'+S2+'@'+tb.Name;
          if ss.IndexOf(S) < 0 then
            ss.add(S);
        end;
      end;
    end;
    Result:=ss.Text;
  finally
    ss.Free;
  end;
end;

function TCtMetaTable.FieldOfChildTable(ATbName: string): TCtMetaField;
var
  I: Integer;
  fd: TCtMetaField;
begin
  Result := nil;
  for I:=0 to MetaFields.Count - 1 do
  begin
    fd := MetaFields[I];
    if fd.DataLevel=ctdlDeleted then
      Continue;
    if UpperCase(fd.RelateTable) <> UpperCase(ATbName) then
      Continue;
    if (fd.DataType<>cfdtList) then
      Continue;
    Result := fd;
    Exit;
  end;
end;

function TCtMetaTable.IsTable: boolean;
begin
  Result := (TypeName = '') or (TypeName = 'TABLE');
end;

function TCtMetaTable.IsText: boolean;
begin
  Result := TypeName = 'TEXT';
end;

{ TCtMetaTableList }

destructor TCtMetaTableList.Destroy;
begin

  inherited;
end;

function TCtMetaTableList.ItemByName(AName: string; bCaseSensive: Boolean
  ): TCtObject;
var
  I: Integer;
begin
  Result:=inherited ItemByName(AName, bCaseSensive);
  if Result = nil then
  begin
    if AName='' then
      Exit;
    if bCaseSensive then
    begin
      for I := 0 to Count - 1 do
        if Assigned(Items[I]) and (Items[I].PhysicalName = AName) then
          if Items[I].DataLevel <> ctdlDeleted then
          begin
            Result := Items[I];
            Exit;
          end;
    end
    else
    begin
      AName := UpperCase(AName);
      for I := 0 to Count - 1 do
        if Assigned(Items[I]) and (UpperCase(Items[I].PhysicalName) = AName) then
          if Items[I].DataLevel <> ctdlDeleted then
          begin
            Result := Items[I];
            Exit;
          end;
    end;
  end;
end;

function TCtMetaTableList.TableByName(AName: string; bCaseSensive: Boolean
  ): TCtMetaTable;
var
  o: TCtObject;
begin
  Result := nil;
  o := Self.ItemByName(AName, bCaseSensive);
  if o = nil then
    Exit;
  if o is TCtMetaTable then
    Result := TCtMetaTable(o);
end;

function TCtMetaTableList.GetItem(Index: integer): TCtMetaTable;
begin
  Result := TCtMetaTable(inherited Get(Index));
end;

procedure TCtMetaTableList.PutItem(Index: integer; const Value: TCtMetaTable);
begin
  inherited Put(Index, Value);
end;

constructor TCtMetaTableList.Create;
begin
  inherited;

end;

function TCtMetaTableList.CreateObj: TCtObject;
begin
  if Assigned(ItemClass) then
    Result := ItemClass.Create
  else
    Result := TCtMetaTable.Create;
  if Result.Name = '' then
    Result.Name := 'New TCtMetaTable';
end;

function TCtMetaTableList.NewTableItem(tp: string): TCtMetaTable;
var
  S: string;
begin
  Result := TCtMetaTable(NewObj);
  Result.CreateDate := Now;
  if (tp = 'TEXT') then
  begin
    Result.TypeName := 'TEXT';
    Result.Name := Format(srNewTextNameFmt, [Result.ID]);
  end
  else
  begin
    if LangIsEnglish then
      Result.Name := Format(srNewTableNameFmt, [Result.ID])
    else
    begin
      Result.Name := Format('Table%d', [Result.ID]);
      S := Format(srNewTableNameFmt, [Result.ID]);
      if S <> Result.Name then
        Result.Caption := S;
    end;
  end;
  Result.MetaModified := True;
end;

procedure TCtMetaTableList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if (Action = lnDeleted) then
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtMetaTable) then
      begin
        if (TCtMetaTable(Ptr).FOwnerList = Self) then
          TCtMetaTable(Ptr).FOwnerList := nil;
      end;
  inherited;

  if (Action = lnAdded) then
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtMetaTable) then
      begin
        if (TCtMetaTable(Ptr).FOwnerList = nil) then
          TCtMetaTable(Ptr).FOwnerList := Self;
      end;
end;

procedure TCtMetaTableList.SaveToSerialer(ASerialer: TCtObjSerialer);
var
  I, C: integer;
  bCont: boolean;
begin
  Assert(ASerialer <> nil);
  SaveCurrentOrder;
  SortByOrderNo;

  C := Count;
  ASerialer.WriteInteger('Count', C);
  ASerialer.BeginChildren('');
  for I := 0 to C - 1 do
  begin
    Items[I].SaveToSerialer(ASerialer);
    if Assigned(FOnObjProgress) then
    begin
      bCont := True;
      FOnObjProgress(Self, Items[I].NameCaption, I, C, bCont);
      if not bCont then
        Break;
    end;
  end;
  ASerialer.EndChildren('');
end;

procedure TCtMetaTableList.LoadFromDMLText(AText: string);
var
  I: Integer;
  ss: TStringList;
  S: String;
  tb: TCtMetaTable;
begin
  Clear;
  ss:=TStringList.Create;
  try
    ss.Text :=AText+#13#10#13#10;
    S:='';
    for I:=0 to ss.Count - 1 do
    begin
      S:=S+ss[I]+#13#10;
      if Trim(ss[i])='' then
      begin
        S:=Trim(S);
        if S<>'' then
        begin
          tb:=Self.NewTableItem();
          tb.Describe:=S;
          S:='';
        end;
      end;
    end;
  finally
    ss.Free;
  end;
end;

procedure TCtMetaTableList.LoadFromSerialer(ASerialer: TCtObjSerialer);
var
  I, C: integer;
  obj: TCtObject;
  bCont: boolean;
begin
  Assert(ASerialer <> nil);

  Clear;
  ASerialer.ReadInteger('Count', C);
  ASerialer.BeginChildren('');
  if ASerialer.ChildCountInvalid then
  begin
    I := 0;
    while ASerialer.NextChildObjToRead do
    begin
      obj := NewObj;
      Inc(I);
      obj.LoadFromSerialer(ASerialer);
      if Assigned(FOnObjProgress) then
      begin
        bCont := True;
        FOnObjProgress(Self, obj.NameCaption, I, C, bCont);
        if not bCont then
          Break;
      end;
    end;
  end
  else
    for I := 0 to C - 1 do
    begin
      if ASerialer.NextChildObjToRead then
      begin
        obj := NewObj;
        obj.LoadFromSerialer(ASerialer);
        if Assigned(FOnObjProgress) then
        begin
          bCont := True;
          FOnObjProgress(Self, obj.NameCaption, I, C, bCont);
          if not bCont then
            Break;
        end;
      end;
    end;
  ASerialer.EndChildren('');
end;

{ TCtMetaField }

function TCtMetaField.CanDisplay(tp: string): boolean;

  function HasTp(mtp: string): boolean;
  begin
    if mtp = tp then
      Result := True  
    else if Pos(mtp, tp)>0 then
      Result := True
    else
      Result := False;
  end;

  function MaybeIdNames(fdn: string): boolean;
  var
    tbn, fn, S, T, V1: String;
  begin    
    Result := True;
    if fdn='' then
      Exit;

    tbn := '';
    if Self.OwnerTable <> nil then
      tbn := LowerCase(Self.OwnerTable.RealTableName);
    fn := LowerCase(fdn);
    S:=srIdFieldNames;
    while S <> '' do
    begin    
      T := ReadCornerStr(S, S);
      if T='' then
        Break;
      V1 := LowerCase(T);
      if fn=V1 then
        Exit;
      if fn= tbn+V1 then
        Exit;
      if fn= tbn+'_'+V1 then
        Exit;
    end;   
    Result := False;
  end;

var
  kf: TCtKeyFieldType;
begin
  //tp显示类型:all title subtitle describ card grid sheet
  Result := True;
  if Self.DataLevel = ctdlDeleted then
  begin
    Result := False;
    Exit;
  end;
  if tp='all' then
    Exit;
  if Pos('[CAN_DISPLAY]', UpperCase(Self.Memo)) = 0 then
  begin
    case DataType of
      cfdtUnknow, cfdtFunction, cfdtEvent, cfdtOther:
        Result := False;
      cfdtList, cfdtObject:
        if Visibility = 0 then
          if (tp <> '') and not HasTp('sheet') then
            Result := False;
    end;
    if not Result then
      Exit;
  end;

  if Self.IsHidden then
  begin
    Result := False;
    Exit;
  end;

  if tp <> '' then
  begin
    Result := False;
    if HasTp('title') then
    begin
      if kf = cfktName then
        Result := True;
      Exit;
    end;
    if HasTp('subtitle') then
    begin
      if kf = cfktCaption then
        Result := True;
      Exit;
    end;
    if HasTp('describ') then
    begin
      if Visibility = 1 then
        Result := True;
      Exit;
    end;
    if HasTp('card') or HasTp('grid') then
      if Self.HideOnList then
        Exit;
    if HasTp('sheet') then
      if Self.HideOnEdit and Self.HideOnView then
        Exit;
  end;

  //0自动、1摘要、2列表、3表单

  if Visibility <> 0 then
  begin
    Result := False;
    if Visibility = 6 then
      Exit;
                    
    if Visibility = 1 then
      if HasTp('card') or HasTp('grid') or HasTp('sheet') then       
      begin
        Result := True;
        Exit;
      end;
    if Visibility = 2 then
      if HasTp('grid') or HasTp('sheet') then
      begin
        Result := True;
        Exit;
      end;       
    if Visibility = 3 then
      if HasTp('sheet') then
      begin
        Result := True;
        Exit;
      end;
    Exit;
  end;


  kf := PossibleKeyFieldType;
  case kf of
    cfktId,
    cfktVersionNo,
    cfktHistoryId,
    cfktLockStamp,
    cfktInstNo,
    cfktProcID,
    //cfktDataLevel,
    //cfktStatus,
    cfktOrderNo:
    begin
      Result := False;
      Exit;
    end;    
    cfktCreatorId,
    cfktModifierId,
    cfktOrgId,
    cfktPid,
    cfktRid: 
      if (Self.LabelText = '') and MaybeIdNames(Self.DisplayName) then
      begin
        Result := False;
        Exit;
      end;
  end;

  Result := True;
end;

function TCtMetaField.IsRequired: boolean;
begin
  Result := not Nullable or FRequired;
end;

function TCtMetaField.GetLabelText: string;
begin
  Result := LabelText;
  if Result = '' then
    Result := DisplayName;
  if Result = '' then
    Result := Name;
end;

function TCtMetaField.PossibleEditorType: string;
var
  fd: TCtMetaField;
  tb: TCtMetaTable;
  S: string;
begin
  Result := EditorType;
  if Result <> '' then
    Exit;

  if (Self.DataType = cfdtCalculate) then
  begin
    fd := GetRelateTableField;
    if (fd <> nil) and (fd <> Self) then
    begin
      Result := fd.PossibleEditorType;
      Exit;
    end;
  end;

  case Self.PossibleKeyFieldType of
    cfktPid,
    cfktRid:
    begin
      Result := 'ButtonEdit';
      Exit;
    end;
    cfktTypeName,
    cfktDataLevel,
    cfktStatus:
    begin
      Result := 'ComboBox';
      Exit;
    end;
  end;

  case DataType of
    cfdtInteger,
    cfdtString:
    begin
      S := Self.DropDownItems;
      if S = '' then
        S := ExtractDropDownItemsFromMemo;
      if S <> '' then
      begin
        Result := 'ComboBox';
        Exit;
      end;
    end;     
    cfdtObject:
    begin
      tb := GetRelateTableObj;
      if (tb <> nil) and (tb <> Self.OwnerTable) then
      begin
        Result := 'KeyValueList';
        Exit;
      end;
    end;
    cfdtList:
    begin
      tb := GetRelateTableObj;
      if (tb <> nil) and (tb <> Self.OwnerTable) then
      begin
        Result := 'DataGrid';
        Exit;
      end;
    end;
  end;

  case DataType of
    cfdtInteger:
      Result := 'SpinEdit';
    cfdtFloat:
      Result := 'NumberEdit';
    cfdtDate:
      Result := 'DateEdit';
    cfdtBool:
      Result := 'CheckBox';
    cfdtEnum:
      Result := 'ComboBox';
    cfdtBlob:
      Result := 'ImageFile';
    cfdtString:
      if Self.DataLength >= 1000 then
        Result := 'Memo'
      else if Self.PossibleKeyFieldType = cfktComment then
        Result := 'Memo';
  end;
end;

function TCtMetaField.PossibleTextAlign: TCtTextAlignment;
begin
  Result := TextAlign;
  if Result <> cftaAuto then
    Exit;
  case DataType of
    cfdtFloat:
      Result := cftaRight;
    //cfdtBool, cfdtEnum:
    //  Result := cftaCenter;
  end;
end;

function TCtMetaField.PossibleDemoDataRule: string;

  function PossibleDemoDataRuleEx: string;
  begin
    Result := '';
    if Trim(Self.TestDataRules) <> '' then
    begin
      Result := Self.TestDataRules;
      Exit;
    end;
    if Trim(TestDataType) <> '' then
    begin
      Result := '#' + Trim(Self.TestDataType);
      Exit;
    end;
    if Trim(Self.DropDownItems) <> '' then
    begin
      Result := GetCtDropDownItemsText(DropDownItems);
      Exit;
    end;
    Result := Self.ExtractDropDownItemsFromMemo;
    if Trim(Result) <> '' then
    begin    
      Result := GetCtDropDownItemsText(Result);
      Exit;
    end;
    if LowerCase(Self.ValueFormat) = LowerCase('UserName') then
    begin
      Result := '#login_name';
      Exit;
    end;
    if LowerCase(Self.ValueFormat) = LowerCase('Email') then
    begin
      Result := '#email';
      Exit;
    end;
    if LowerCase(Self.ValueFormat) = LowerCase('Url') then
    begin
      Result := '#url';
      Exit;
    end;
    if LowerCase(Self.ValueFormat) = LowerCase('Zipcode') then
    begin
      Result := '#zipcode';
      Exit;
    end;
    if LowerCase(Self.ValueFormat) = LowerCase('Mobile') then
    begin
      Result := '#cell_phone';
      Exit;
    end;
    if LowerCase(Self.ValueFormat) = LowerCase('Tel') then
    begin
      Result := '#phone';
      Exit;
    end;
    if LowerCase(Self.ValueFormat) = LowerCase('IdCard') then
    begin
      Result := '#idcard';
      Exit;
    end;
    if LowerCase(Self.ValueFormat) = LowerCase('Json') then
    begin
      Result := '#json';
      Exit;
    end;
    if Self.PossibleKeyFieldType in [cfktId, cfktPid, cfktRid, cfktOrgId,
      cfktCreatorId, cfktModifierId, cfktHistoryId, cfktInstNo, cfktProcID] then
    begin
      if Self.DataType = cfdtString then
        Result := '#guid';
    end
    else if Self.DataType = cfdtInteger then
      Result := '#int';
  end;

var
  S: string;
begin
  Result := PossibleDemoDataRuleEx;
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    //判断是否有变化，避免重复执行脚本
    if FLastGetRuleScriptModifyCount = Self.ModifyCounter then
      Result := FLastGetRuleScriptResult
    else
    begin
      FLastGetRuleScriptModifyCount := Self.ModifyCounter;
      S := GProc_OnEzdmlCmdEvent('FIELD_GEN_DEMO_DATA_RULE', Result,
        Self.Name, Self, nil);
      if S <> '' then
        Result := S;
      FLastGetRuleScriptResult := Result;
    end;
  end;
end;

function TCtMetaField.GenDemoData(ARowIndex: integer; AOpt: string;
  ADataSet: TDataSet): string;
  function IsValidBool(AVal: string): Boolean;
  const
    DEF_VALID_BOOL_NAMES:array[0..9]of String = ('false','true','no','yes','0','1','y','n','t','f');
  var
    I: Integer;
  begin        
    Result := True;
    if AVal='' then
      Exit;
    AVal := LowerCase(AVal);
    for I:=0 to High(DEF_VALID_BOOL_NAMES) do
      if AVal=DEF_VALID_BOOL_NAMES[I] then
        Exit;
    if AVal = LowerCase(srBoolName_False) then
      Exit;       
    if AVal = LowerCase(srBoolName_True) then
      Exit;

    Result := False;
  end;

  function CheckDropDownVal(aval: string; bInt: Boolean): string;
  var
    I: Integer;
    dds, S: string;
    iFound: Integer;
  begin    
    Result := AVal;
    if bInt then
      if TryStrToInt(Result, I) then
        Exit;

    dds := Self.DropDownItems;
    if dds <> '' then
      if Trim(dds)='' then
        dds := '';
    if dds = '' then
      dds := ExtractDropDownItemsFromMemo;
    if Trim(dds) = '' then
    begin
      if bInt then
        Result := '-1';
      Exit;
    end;

    iFound := -1;
    S := GetCtDropDownValueOfTextEx(Result, dds, iFound);
    if iFound >= 0 then
    begin
      if bInt then
        Result := IntToStr(iFound)
      else
        Result := S;
    end
    else
      if bInt then
        Result := '-1';
  end;
var
  dt: TDateTime;
  I, J: Integer;
  F: Double;
  V: string;
begin
  Result := GenDemoDataEx(ARowIndex, AOpt, ADataSet);

  if Pos('[VALUE_ONLY]', AOpt) = 0 then
    Exit;
  if Result = '' then
    Exit;     
  if LowerCase(Result) = '_null' then
    Exit;
  if LowerCase(Result) = 'null' then
    Exit;

  J := ARowIndex;
  if J < 0 then
    J := Random(100);

  case DataType of
    cfdtDate:
    begin
      dt:=CtStringToDateTime(Result);
      if dt>0.00000000001 then
      begin
      end
      else
        dt := Trunc(Now) - 20 + J + Self.ID + Cos(J + Trunc(Time * 100));
      if Abs(Trunc(dt)-dt) < 0.000000000001 then
        Result := FormatDateTime('yyyy-mm-dd', dt)
      else
        Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', dt);
    end;
    cfdtInteger:
    begin      
      Result := CheckDropDownVal(Result, True);
      if not TryStrToInt(Result, I) then
      begin     
        if KeyFieldType <> cfktId then
          J := Round(Abs(Sin(ARowIndex + Self.ID + Trunc(Time * 123)) * 11779));
        Result := IntToStr(CheckMaxMinDemoInt(J + 1));
      end;
    end;
    cfdtEnum:
    begin
      Result := CheckDropDownVal(Result, True);
      if (Result = '-1') or not TryStrToInt(Result, I) then
      begin           
        J := Round(Abs(Sin(ARowIndex + Self.ID + Trunc(Time * 123)) * 11779));
        Result := IntToStr(J mod 5);
      end;
    end;
    cfdtFloat:
    begin
      if not TryStrToFloat(Result, F) then
      begin
        Result := FormatFloat('#0.##', CheckMaxMinDemoFloat(Abs(Sin(J + ID + Trunc(Time * 120)) * 100)));
      end;
    end;
    cfdtBool:
    begin        
      Result := CheckDropDownVal(Result, True);
      if not IsValidBool(Trim(Result)) then
      begin
        if ((J + ID + Trunc(Time * 130)) mod 3) = 0 then
          Result := '0'
        else
          Result := '1';
      end
      else
      begin
        if not CtStringToBool(Trim(Result)) then
          Result := '0'
        else
          Result := '1';
      end;
    end;
    cfdtString:
    begin
      if Self.DropDownMode in[cfddFixed, cfddAutoCompleteFixed] then
      begin     
        V := CheckDropDownVal(Result, True);
        if StrToIntDef(V, -1) >= 0 then    
          Result := CheckDropDownVal(Result, False)
        else
          Result := '';
      end
      else
        Result := CheckDropDownVal(Result, False);
    end;
  end;
end;

constructor TCtMetaField.Create;
begin
  inherited;
  Reset;
end;

destructor TCtMetaField.Destroy;
begin
  inherited;
end;

procedure TCtMetaField.Reset;
begin
  inherited;
  FDisplayName := '';
  FDataType := cfdtUnknow;
  FDataTypeName := '';
  FKeyFieldType := cfktNormal;
  FRelateTable := '';
  FRelateField := '';
  FIndexType := cfitNone;
  FIndexFields := '';      
  FDBCheck := '';
  FHint := '';
  FDefaultValue := '';
  FNullable := True;
  FDataLength := 0;
  FDataScale := 0;
  FUrl := '';
  FResType := '';
  FFormula := '';
  FFormulaCondition := '';
  FAggregateFun := '';
  FMeasureUnit := '';
  FValidateRule := '';
  FEditorType := '';
  FLabelText := '';
  FExplainText := '';
  FEditorReadOnly := False;
  FEditorEnabled := True;
  FIsHidden := False;
  FDisplayFormat := '';
  FEditFormat := '';
  FFontName := '';
  FFontSize := 0;
  FFontStyle := 0;
  FForeColor := 0;
  FBackColor := 0;
  FDropDownItems := '';
  FDropDownMode := cfddNone;
  FGraphDesc := '';

  FVisibility := 0;
  FTextAlign := cftaAuto;
  FColWidth := 0;
  FMaxLength := 0;
  FSearchable := False;
  FQueryable := False;
  FExportable := False;
  FInitValue := '';
  FValueMin := '';
  FValueMax := '';
  FValueFormat := '';
  FExtraProps := '';
  FCustomConfigs := '';

  FExplainText := '';
  FTextClipSize := 0;
  FDropDownSQL := '';
  FItemColCount := 0;
  FFixColType := cffcNone;
  FHideOnList := False;
  FHideOnEdit := False;
  FHideOnView := False;
  FAutoMerge := False;
  FAutoTrim := False;
  FRequired := False;
  FColGroup := '';
  FSheetGroup := '';
  FColSortable := False;
  FShowFilterBox := False;
  FEditorProps := '';
  FTestDataType := '';
  FTestDataRules := '';
  FUILogic := '';
  FBusinessLogic := '';
                   
  FDesensitised        := False;
  FDesignNotes          := '';
  FIsFactMeasure       := False;
  FTestDataNullPercent := 0;
                        
  FFieldWeight := 0;

  FOldName := '';
end;

procedure TCtMetaField.AssignFrom(ACtObj: TCtObject);
begin
  inherited;
  if ACtObj is TCtMetaField then
  begin
    FDisplayName := TCtMetaField(ACtObj).FDisplayName;
    FDataType := TCtMetaField(ACtObj).FDataType;
    FDataTypeName := TCtMetaField(ACtObj).FDataTypeName;
    FKeyFieldType := TCtMetaField(ACtObj).FKeyFieldType;
    FRelateTable := TCtMetaField(ACtObj).FRelateTable;
    FRelateField := TCtMetaField(ACtObj).FRelateField;
    FIndexType := TCtMetaField(ACtObj).FIndexType;
    FIndexFields := TCtMetaField(ACtObj).FIndexFields;   
    FDBCheck := TCtMetaField(ACtObj).FDBCheck;
    FHint := TCtMetaField(ACtObj).FHint;
    FDefaultValue := TCtMetaField(ACtObj).FDefaultValue;
    FNullable := TCtMetaField(ACtObj).FNullable;
    FDataLength := TCtMetaField(ACtObj).FDataLength;
    FDataScale := TCtMetaField(ACtObj).FDataScale;
    FUrl := TCtMetaField(ACtObj).FUrl;
    FResType := TCtMetaField(ACtObj).FResType;
    FFormula := TCtMetaField(ACtObj).FFormula;
    FFormulaCondition := TCtMetaField(ACtObj).FFormulaCondition;
    FAggregateFun := TCtMetaField(ACtObj).FAggregateFun;
    FMeasureUnit := TCtMetaField(ACtObj).FMeasureUnit;
    FValidateRule := TCtMetaField(ACtObj).FValidateRule;
    FEditorType := TCtMetaField(ACtObj).FEditorType;
    FLabelText := TCtMetaField(ACtObj).FLabelText;
    FExplainText := TCtMetaField(ACtObj).FExplainText;
    FEditorReadOnly := TCtMetaField(ACtObj).FEditorReadOnly;
    FEditorEnabled := TCtMetaField(ACtObj).FEditorEnabled;
    FIsHidden := TCtMetaField(ACtObj).FIsHidden;
    FDisplayFormat := TCtMetaField(ACtObj).FDisplayFormat;
    FEditFormat := TCtMetaField(ACtObj).FEditFormat;
    FFontName := TCtMetaField(ACtObj).FFontName;
    FFontSize := TCtMetaField(ACtObj).FFontSize;
    FFontStyle := TCtMetaField(ACtObj).FFontStyle;
    FForeColor := TCtMetaField(ACtObj).FForeColor;
    FBackColor := TCtMetaField(ACtObj).FBackColor;
    FDropDownItems := TCtMetaField(ACtObj).FDropDownItems;
    FDropDownMode := TCtMetaField(ACtObj).FDropDownMode;
    FGraphDesc := TCtMetaField(ACtObj).FGraphDesc;

    FVisibility := TCtMetaField(ACtObj).FVisibility;
    FTextAlign := TCtMetaField(ACtObj).FTextAlign;
    FColWidth := TCtMetaField(ACtObj).FColWidth;
    FMaxLength := TCtMetaField(ACtObj).FMaxLength;
    FSearchable := TCtMetaField(ACtObj).FSearchable;
    FQueryable := TCtMetaField(ACtObj).FQueryable;        
    FExportable := TCtMetaField(ACtObj).FExportable;
    FInitValue := TCtMetaField(ACtObj).FInitValue;
    FValueMin := TCtMetaField(ACtObj).FValueMin;
    FValueMax := TCtMetaField(ACtObj).FValueMax;
    FValueFormat := TCtMetaField(ACtObj).FValueFormat;
    FExtraProps := TCtMetaField(ACtObj).FExtraProps;
    FCustomConfigs := TCtMetaField(ACtObj).FCustomConfigs;

    FExplainText := TCtMetaField(ACtObj).FExplainText;
    FTextClipSize := TCtMetaField(ACtObj).FTextClipSize;
    FDropDownSQL := TCtMetaField(ACtObj).FDropDownSQL;
    FItemColCount := TCtMetaField(ACtObj).FItemColCount;
    FFixColType := TCtMetaField(ACtObj).FFixColType;
    FHideOnList := TCtMetaField(ACtObj).FHideOnList;
    FHideOnEdit := TCtMetaField(ACtObj).FHideOnEdit;
    FHideOnView := TCtMetaField(ACtObj).FHideOnView;
    FAutoMerge := TCtMetaField(ACtObj).FAutoMerge;
    FColGroup := TCtMetaField(ACtObj).FColGroup;
    FSheetGroup := TCtMetaField(ACtObj).FSheetGroup;
    FColSortable := TCtMetaField(ACtObj).FColSortable;
    FShowFilterBox := TCtMetaField(ACtObj).FShowFilterBox;
    FAutoTrim := TCtMetaField(ACtObj).FAutoTrim;
    FRequired := TCtMetaField(ACtObj).FRequired;
    FEditorProps := TCtMetaField(ACtObj).FEditorProps;
    FTestDataType := TCtMetaField(ACtObj).FTestDataType;
    FTestDataRules := TCtMetaField(ACtObj).FTestDataRules;
    FUILogic := TCtMetaField(ACtObj).FUILogic;
    FBusinessLogic := TCtMetaField(ACtObj).FBusinessLogic;

    FDesensitised := TCtMetaField(ACtObj).FDesensitised;
    FDesignNotes := TCtMetaField(ACtObj).FDesignNotes;
    FIsFactMeasure := TCtMetaField(ACtObj).FIsFactMeasure;
    FTestDataNullPercent := TCtMetaField(ACtObj).FTestDataNullPercent;
                                             
    FFieldWeight := TCtMetaField(ACtObj).FFieldWeight;
    FOldName := TCtMetaField(ACtObj).FOldName;
  end;
end;

procedure TCtMetaField.LoadFromSerialer(ASerialer: TCtObjSerialer);
var
  iv: integer;
begin
  BeginSerial(ASerialer, True);
  try
    inherited;
    ASerialer.ReadString('DisplayName', FDisplayName);
    iv := ASerialer.ReadInt('DataType');
    if ASerialer.CurCtVer <= 25 then
      if iv >= integer(cfdtCalculate) then
        iv := iv + 1;
    if iv < 0 then
      iv := 0
    else if iv > integer(cfdtOther) then
      iv := integer(cfdtOther);
    FDataType := TCtFieldDataType(iv);

    ASerialer.ReadString('DataTypeName', FDataTypeName);
    FKeyFieldType := TCtKeyFieldType(ASerialer.ReadInt('KeyFieldType'));
    ASerialer.ReadString('RelateTable', FRelateTable);
    ASerialer.ReadString('RelateField', FRelateField);
    FIndexType := TCtFieldIndexType(ASerialer.ReadInt('IndexType'));
    if ASerialer.CurCtVer >= 25 then
      ASerialer.ReadString('IndexFields', FIndexFields);  
    if ASerialer.CurCtVer >= 31 then
      ASerialer.ReadString('DBCheck', FDBCheck);
    ASerialer.ReadString('Hint', FHint);
    ASerialer.ReadString('DefaultValue', FDefaultValue);
    ASerialer.ReadNotBool('Nullable', FNullable);
    ASerialer.ReadInteger('DataLength', FDataLength);
    ASerialer.ReadInteger('DataScale', FDataScale);

    ASerialer.ReadString('Url', FUrl);
    ASerialer.ReadString('ResType', FResType);
    ASerialer.ReadString('Formula', FFormula);
    ASerialer.ReadString('FormulaCondition', FFormulaCondition);
    ASerialer.ReadString('AggregateFun', FAggregateFun);
    ASerialer.ReadString('MeasureUnit', FMeasureUnit);
    ASerialer.ReadString('ValidateRule', FValidateRule);
    ASerialer.ReadString('EditorType', FEditorType);
    ASerialer.ReadString('LabelText', FLabelText);
    if ASerialer.CurCtVer >= 29 then
      ASerialer.ReadString('ExplainText', FExplainText);
    ASerialer.ReadBool('EditorReadOnly', FEditorReadOnly);
    ASerialer.ReadNotBool('EditorEnabled', FEditorEnabled);
    if ASerialer.CurCtVer >= 28 then
      ASerialer.ReadBool('IsHidden', FIsHidden);
    ASerialer.ReadString('DisplayFormat', FDisplayFormat);
    ASerialer.ReadString('EditFormat', FEditFormat);
    ASerialer.ReadString('FontName', FFontName);
    ASerialer.ReadFloat('FontSize', FFontSize);
    ASerialer.ReadInteger('FontStyle', FFontStyle);
    ASerialer.ReadInteger('ForeColor', FForeColor);
    ASerialer.ReadInteger('BackColor', FBackColor);
    ASerialer.ReadStrings('DropDownItems', FDropDownItems);
    FDropDownMode := TCtFieldDropDownMode(ASerialer.ReadInt('DropDownMode'));
    ASerialer.ReadString('GraphDesc', FGraphDesc);

    if ASerialer.CurCtVer >= 22 then
    begin
      ASerialer.ReadInteger('Visibility', FVisibility);
      FTextAlign := TCtTextAlignment(ASerialer.ReadInt('TextAlign'));
      if ASerialer.CurCtVer < 29 then //旧版本的0=Left转为自动，其它的+1
        if FTextAlign <> cftaAuto then
          FTextAlign := TCtTextAlignment(integer(FTextAlign) + 1);
      ASerialer.ReadInteger('ColWidth', FColWidth);
      ASerialer.ReadInteger('MaxLength', FMaxLength);
      ASerialer.ReadBool('Searchable', FSearchable);
      ASerialer.ReadBool('Queryable', FQueryable);
      ASerialer.ReadString('InitValue', FInitValue);
      ASerialer.ReadString('ValueMin', FValueMin);
      ASerialer.ReadString('ValueMax', FValueMax);
      ASerialer.ReadString('ValueFormat', FValueFormat);
      ASerialer.ReadString('ExtraProps', FExtraProps);
      ASerialer.ReadString('CustomConfigs', FCustomConfigs);
    end;

    if ASerialer.CurCtVer >= 29 then
    begin
      ASerialer.ReadString('ExplainText', FExplainText);
      ASerialer.ReadInteger('TextClipSize', FTextClipSize);
      ASerialer.ReadString('DropDownSQL', FDropDownSQL);
      ASerialer.ReadInteger('ItemColCount', FItemColCount);
      FFixColType := TCtFieldFixColType(ASerialer.ReadInt('FixColType'));
      ASerialer.ReadBool('HideOnList', FHideOnList);
      ASerialer.ReadBool('HideOnEdit', FHideOnEdit);
      ASerialer.ReadBool('HideOnView', FHideOnView);
      ASerialer.ReadBool('AutoMerge', FAutoMerge);
      ASerialer.ReadString('ColGroup', FColGroup);
      ASerialer.ReadString('SheetGroup', FSheetGroup);
      ASerialer.ReadBool('ColSortable', FColSortable);
      ASerialer.ReadBool('ShowFilterBox', FShowFilterBox);
      ASerialer.ReadBool('AutoTrim', FAutoTrim);
      ASerialer.ReadBool('Required', FRequired);
      ASerialer.ReadString('EditorProps', FEditorProps);
      ASerialer.ReadString('TestDataType', FTestDataType);
      ASerialer.ReadString('TestDataRules', FTestDataRules);
      ASerialer.ReadString('UILogic', FUILogic);
      ASerialer.ReadString('BusinessLogic', FBusinessLogic);
    end;

    if ASerialer.CurCtVer >= 32 then
      ASerialer.ReadBool('Exportable', FExportable);


    if ASerialer.CurCtVer >= 34 then
    begin
      ASerialer.ReadBool('Desensitised', FDesensitised);
      ASerialer.ReadStrings('DesignNotes', FDesignNotes);
      ASerialer.ReadBool('IsFactMeasure', FIsFactMeasure);
      ASerialer.ReadInteger('TestDataNullPercent', FTestDataNullPercent);
    end;

    if ASerialer.CurCtVer >= 35 then 
      ASerialer.ReadInteger('FieldWeight', FFieldWeight);

    EndSerial(ASerialer, True);
  finally
  end;
end;

procedure TCtMetaField.SaveToSerialer(ASerialer: TCtObjSerialer);
begin
  BeginSerial(ASerialer, False);
  try
    CreateDate := 0;
    ModifyDate := 0;
    inherited;
    ASerialer.WriteString('DisplayName', FDisplayName);
    ASerialer.WriteInteger('DataType', integer(FDataType));
    ASerialer.WriteString('DataTypeName', FDataTypeName);
    ASerialer.WriteInteger('KeyFieldType', integer(FKeyFieldType));
    ASerialer.WriteString('RelateTable', FRelateTable);
    ASerialer.WriteString('RelateField', FRelateField);
    ASerialer.WriteInteger('IndexType', integer(FIndexType));
    ASerialer.WriteString('IndexFields', FIndexFields);       
    ASerialer.WriteString('DBCheck', DBCheck);
    ASerialer.WriteString('Hint', FHint);
    ASerialer.WriteString('DefaultValue', FDefaultValue);
    ASerialer.WriteNotBool('Nullable', FNullable);
    ASerialer.WriteInteger('DataLength', FDataLength);
    ASerialer.WriteInteger('DataScale', FDataScale);


    ASerialer.WriteString('Url', FUrl);
    ASerialer.WriteString('ResType', FResType);
    ASerialer.WriteString('Formula', FFormula);
    ASerialer.WriteString('FormulaCondition', FFormulaCondition);
    ASerialer.WriteString('AggregateFun', FAggregateFun);
    ASerialer.WriteString('MeasureUnit', FMeasureUnit);
    ASerialer.WriteString('ValidateRule', FValidateRule);
    ASerialer.WriteString('EditorType', FEditorType);
    ASerialer.WriteString('LabelText', FLabelText);
    ASerialer.WriteString('ExplainText', FExplainText);
    ASerialer.WriteBool('EditorReadOnly', FEditorReadOnly);
    ASerialer.WriteNotBool('EditorEnabled', FEditorEnabled);
    ASerialer.WriteBool('IsHidden', FIsHidden);
    ASerialer.WriteString('DisplayFormat', FDisplayFormat);
    ASerialer.WriteString('EditFormat', FEditFormat);
    ASerialer.WriteString('FontName', FFontName);
    ASerialer.WriteFloat('FontSize', FFontSize);
    ASerialer.WriteInteger('FontStyle', FFontStyle);
    ASerialer.WriteInteger('ForeColor', FForeColor);
    ASerialer.WriteInteger('BackColor', FBackColor);
    ASerialer.WriteStrings('DropDownItems', FDropDownItems);
    ASerialer.WriteInteger('DropDownMode', integer(FDropDownMode));
    ASerialer.WriteString('GraphDesc', FGraphDesc);

    ASerialer.WriteInteger('Visibility', FVisibility);
    ASerialer.WriteInteger('TextAlign', integer(FTextAlign));
    ASerialer.WriteInteger('ColWidth', FColWidth);
    ASerialer.WriteInteger('MaxLength', FMaxLength);
    ASerialer.WriteBool('Searchable', FSearchable);
    ASerialer.WriteBool('Queryable', FQueryable);
    ASerialer.WriteString('InitValue', FInitValue);
    ASerialer.WriteString('ValueMin', FValueMin);
    ASerialer.WriteString('ValueMax', FValueMax);
    ASerialer.WriteString('ValueFormat', FValueFormat);
    ASerialer.WriteString('ExtraProps', FExtraProps);
    ASerialer.WriteString('CustomConfigs', FCustomConfigs);

    ASerialer.WriteString('ExplainText', FExplainText);
    ASerialer.WriteInteger('TextClipSize', FTextClipSize);
    ASerialer.WriteString('DropDownSQL', FDropDownSQL);
    ASerialer.WriteInteger('ItemColCount', FItemColCount);
    ASerialer.WriteInteger('FixColType', integer(FFixColType));
    ASerialer.WriteBool('HideOnList', FHideOnList);
    ASerialer.WriteBool('HideOnEdit', FHideOnEdit);
    ASerialer.WriteBool('HideOnView', FHideOnView);
    ASerialer.WriteBool('AutoMerge', FAutoMerge);
    ASerialer.WriteString('ColGroup', FColGroup);
    ASerialer.WriteString('SheetGroup', FSheetGroup);
    ASerialer.WriteBool('ColSortable', FColSortable);
    ASerialer.WriteBool('ShowFilterBox', FShowFilterBox);
    ASerialer.WriteBool('AutoTrim', FAutoTrim);
    ASerialer.WriteBool('Required', FRequired);
    ASerialer.WriteString('EditorProps', FEditorProps);
    ASerialer.WriteString('TestDataType', FTestDataType);
    ASerialer.WriteString('TestDataRules', FTestDataRules);
    ASerialer.WriteString('UILogic', FUILogic);
    ASerialer.WriteString('BusinessLogic', FBusinessLogic);
                   
    ASerialer.WriteBool('Exportable', FExportable);


    ASerialer.WriteBool('Desensitised', FDesensitised);
    ASerialer.WriteStrings('DesignNotes', FDesignNotes);
    ASerialer.WriteBool('IsFactMeasure', FIsFactMeasure);
    ASerialer.WriteInteger('TestDataNullPercent', FTestDataNullPercent);
                                      
    ASerialer.WriteInteger('FieldWeight', FFieldWeight);

    EndSerial(ASerialer, False);
  finally
  end;
end;


procedure TCtMetaField.SetConstraintStr(Value: string);
begin
  SetConstraintStrEx(Value, True);
end;

procedure TCtMetaField.SetConstraintStrEx(Value: string; bForce: boolean);

  function Sub_FindConsStr(ci: integer; val: string): boolean;
  var
    T1, T2: string;
  begin
    T1 := DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[ci];
    T2 := DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[ci];
    T1 := ',' + T1 + ',';
    T2 := ',' + T2 + ',';
    if Pos(T1, val) > 0 then
      Result := True
    else if Pos(T2, val) > 0 then
      Result := True
    else
      Result := False;
  end;

  function Sub_FindConsVal(ci: integer; val: string): string;
  var
    T1, T2: string;
    po: integer;
  begin
    T1 := DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[ci];
    T1 := ',' + LowerCase(T1) + ':';
    T2 := DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[ci];
    T2 := ',' + LowerCase(T2) + ':';
    val := ',' + val;
    po := Pos(T1, LowerCase(val));
    if po > 0 then
    begin
      Result := Copy(val, po + Length(T1), Length(val));
      if Result = '' then
        Result := '(NONE)';
      po := Pos(',', Result);
      if po > 0 then
        Result := Copy(Result, 1, po - 1);
    end
    else
    begin
      po := Pos(T2, LowerCase(val));
      if po > 0 then
      begin
        Result := Copy(val, po + Length(T2), Length(val));
        if Result = '' then
          Result := '(NONE)';
        po := Pos(',', Result);
        if po > 0 then
          Result := Copy(Result, 1, po - 1);
      end
      else
        Result := '';
    end;
  end;

  function Sub_GetDefaultVal(val: string): string;
  begin
    Result := Sub_FindConsVal(6, val);
    if Result <> '' then
      Exit
    else if Sub_FindConsStr(7, ',' + val + ',') then
      Result := DEF_VAL_auto_increment
    else
      Result := '';
  end;

  function GetIndexFieldVals(S: string): string;
  var
    po: integer;
  begin
    Result := '';
    po := Pos(':', S);
    if po > 0 then
      Result := Trim(Copy(S, po + 1, Length(S)));
  end;
     
  function DeccStr(cs: string): string;
  begin
    Result := cs;
    if Pos('&', Result) > 0 then
      result := StringReplace(Result, '&', ',', [rfReplaceAll]);
  end;
var
  S, svIdxes, idxV: string;
  pdot: integer;
begin
  S := ',' + Value + ',';
  S := StringReplace(S, ' ', '', [rfReplaceAll]);
  S := StringReplace(S, '　', '', [rfReplaceAll]);
  S := StringReplace(S, '，', ',', [rfReplaceAll]);

  if Sub_FindConsStr(2, S) then
  begin
    KeyFieldType := cfktId;
  end
  else if Sub_FindConsStr(3, S) then
  begin
    KeyFieldType := cfktRid;
  end
  else if bForce then
  begin
    KeyFieldType := cfktNormal;
  end;

  if bForce then
    Nullable := not Sub_FindConsStr(1, S)
  else if Sub_FindConsStr(1, S) then
    Nullable := False;

  if Self.DataType = cfdtFunction then
  begin //复合索引
    svIdxes := IndexFields;
    idxV := Sub_FindConsVal(4, S);
    if idxV <> '' then
    begin
      IndexType := cfitUnique;
      Self.IndexFields := DeccStr(GetIndexFieldVals(Value));
      if svIdxes = Self.Memo then
        Self.Memo := IndexFields;
    end
    else
    begin
      idxV := Sub_FindConsVal(5, S);
      if idxV <> '' then
      begin
        IndexType := cfitNormal;
        Self.IndexFields := DeccStr(GetIndexFieldVals(Value));
        if svIdxes = Self.Memo then
          Self.Memo := IndexFields;
      end;
    end;
  end
  else
    idxV := '';

  if idxV <> '' then
  begin
  end
  else if Sub_FindConsStr(4, S) then
    IndexType := cfitUnique
  else if Sub_FindConsStr(5, S) then
    IndexType := cfitNormal
  else if bForce then
    IndexType := cfitNone;

  S := Sub_GetDefaultVal(Value);
  if (S <> '') or bForce then
  begin
    if S = '(NONE)' then
      S := '';
    DefaultValue := DeccStr(S);
  end;

  S := Sub_FindConsVal(8, Value);
  if (S <> '') or bForce then
  begin
    if S = '(NONE)' then
      S := '';
    pdot := Pos('.', S);
    if pdot > 0 then
    begin
      Self.RelateField := DeccStr(Trim(Copy(S, pdot + 1, Length(S))));
      S := Copy(S, 1, pdot - 1);
    end;
    Self.RelateTable := DeccStr(Trim(S));
  end;

  S := Sub_FindConsVal(9, Value);
  if (S <> '') then
  begin
    if S = '(NONE)' then
      S := '';
    S := DeccStr(Trim(S));
    while Pos('> >', S)>0 do
      S := StringReplace(S, '> >', '>>', [rfReplaceAll]);
    Self.DataTypeName := S;
  end;
end;

function TCtMetaField.GetNullableStr(dbType: string): string;
var
  S: string;
  po: integer;
begin
  Result := '';
  if (dbType='HIVE') and (G_HiveVersion < 3) then
    Exit;
  if not Nullable then
    Result := ' not null'
  else if Self.DataTypeName <> '' then
  begin
    if GetCtFieldDataTypeIsNullDefault(DataTypeName) then
    begin
      Exit;
    end;
    S := GetCtCustFieldPhyTypeName(dbType, DataTypeName, DataLength);
    ;
    po := Pos('(', S);
    if po > 0 then
      S := Copy(S, 1, po - 1);
    if S <> DataTypeName then
      if GetCtFieldDataTypeIsNullDefault(DataTypeName) then
        Exit;
    Result := ' null';
  end;
end;

function TCtMetaField.GetCustomConfigValue(AName: string): string;
begin
  Result := '';
  if FCustomConfigs = '' then
    Exit;
  if Assigned(Proc_JsonPropProc) then
    Result := Proc_JsonPropProc(FCustomConfigs, AName, '', True);
end;

procedure TCtMetaField.SetCustomConfigValue(AName, AValue: string);
begin
  if AName = '' then
    Exit;
  if Assigned(Proc_JsonPropProc) then
    FCustomConfigs := Proc_JsonPropProc(FCustomConfigs, AName, AValue, False);
end;

function TCtMetaField.CheckCanRenameTo(ANewName: string): Boolean;
var
  I: Integer;
  fd: TCtMetaField;
  S: String;
begin
  Result:=True;
  if Self.OwnerList = nil then
    Exit;
  if ANewName = Self.Name then
    Exit;
  for I:=0 to OwnerList.Count - 1 do
  begin
    fd := OwnerList.Items[I];
    if fd=Self then
      Continue;
    if fd.DataLevel=ctdlDeleted then
      Continue;
    if UpperCase(fd.Name) <> UpperCase(ANewName) then   
      Continue;   
    S := Format(srRenameToExistsFeildError, [ANewName]);
    Application.MessageBox(PChar(S), PChar(Application.Title),
      MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;
end;

function TCtMetaField.HasValidComplexIndex: boolean;
begin
  Result := False;

  if DataLevel = ctdlDeleted then
    Exit;
  if DataType <> cfdtFunction then
    Exit;
  if IndexType = cfitNone then
    Exit;
  if Trim(IndexFields) = '' then
    Exit;
  if (Pos(',', IndexFields) = 0) and (Pos('(', IndexFields) = 0) then
    Exit;

  Result := True;
end;

function TCtMetaField.IsLobField(dbType: string): boolean;
var
  S: String;
begin
  Result := False;    
  if DataType = cfdtBlob then
  begin
    Result := True;
    Exit;
  end;

  S := GetCtFieldPhyTypeName(dbType, DataType, DataLength);
  if DataTypeName <> '' then
    S := GetCtCustFieldPhyTypeName(dbType, DataTypeName, DataLength);  
  if Pos('TEXT', UpperCase(S)) > 0 then
    Result := True
  else if Pos('CLOB', UpperCase(S)) > 0 then
    Result := True
  else if Pos('BLOB', UpperCase(S)) > 0 then
    Result := True;
  if Result then
    Exit;

  if DataType <> cfdtString then
    Exit;
  if DataLength = 0 then
    Exit;
  if CheckStringMaxLen(dbType, Self.DataTypeName, S, DataLength) then
    Result := True;
end;

function TCtMetaField.IsFK: boolean;
begin
  Result := False;
  if not IsPhysicalField then
    Exit;
  if (Self.KeyFieldType <> cfktId) and (Self.KeyFieldType <> cfktRid) then
    Exit;
  if Trim(Self.RelateTable)='' then
    Exit;
  if Trim(Self.RelateField)='' then
    Exit;
  Result := True;
end;


function TCtMetaField.IsPhysicalField: boolean;
begin
  Result := True;
  if Self.DataLevel = ctdlDeleted then
  begin
    Result := False;
    Exit;
  end;
  if Pos('[NOT_DB_FIELD]', UpperCase(Self.Memo)) > 0 then
  begin
    Result := False;
    Exit;
  end;
  if Pos('[IS_DB_FIELD]', UpperCase(Self.Memo)) > 0 then
  begin
    Result := True;
    Exit;
  end;

  case DataType of
    cfdtUnknow, cfdtCalculate, cfdtFunction, cfdtEvent, cfdtOther:
      Result := False;
    cfdtObject, cfdtList:
      if Trim(Self.DataTypeName) = '' then
        Result := False;
  end;
end;

function TCtMetaField.PossibleKeyFieldType: TCtKeyFieldType;

  function FindMatchKNP(kns: string): boolean;
  var
    S: string;
  begin
    S := ',' + LowerCase(Name) + ',';
    if Pos(S, ',' + LowerCase(kns) + ',') > 0 then
      Result := True
    else
      Result := False;
  end;

var
  k: TCtKeyFieldType;
begin
  Result := KeyFieldType;
  if Result <> cfktNormal then
    Exit;
  if Name = '' then
    Exit;
  for k := Low(TCtKeyFieldType) to High(TCtKeyFieldType) do
  begin
    if UpperCase(Name) = UpperCase(DEF_CTMETAFIELD_KEYFIELD_NAMES_ENG[k]) then
    begin
      Result := k;
      Exit;
    end;
  end;
  for k := Low(TCtKeyFieldType) to High(TCtKeyFieldType) do
  begin
    if UpperCase(Name) = UpperCase(DEF_CTMETAFIELD_KEYFIELD_NAMES_CHN[k]) then
    begin
      Result := k;
      Exit;
    end;
  end;
  for k := Low(TCtKeyFieldType) to High(TCtKeyFieldType) do
  begin
    if FindMatchKNP(DEF_CTMETAFIELD_KEYFIELD_NAMES_POSSIBLE[k]) then
    begin
      Result := k;
      Exit;
    end;
  end;
end;

procedure TCtMetaField.SetRelateTable(AValue: string);
begin
  if FRelateTable=AValue then Exit;
  FRelateTable:=AValue;
end;

procedure TCtMetaField.SetDefaultValue(const Value: string);
begin
  FDefaultValue := Value;
  if LowerCase(Trim(FDefaultValue)) = 'null' then
    FDefaultValue := '';
end;

function TCtMetaField.GetOwnerTable: TCtMetaTable;
begin
  Result := nil;
  if Assigned(FOwnerList) then
    Result := FOwnerList.FOwnerTable;
end;

function TCtMetaField.GetFieldTypeDesc(bPhy: boolean; dbType: string): string;
var
  FT: string;
begin
  if bPhy then
  begin
    Result := GetPhyDataTypeName(dbType);
    if (DbType = 'SQLITE') then
    begin //sqlite主键直接定义
      if Self.KeyFieldType = cfktID then
      begin
        //Result := Result + ' primary key'; //removed by huz 20230617: 转为独立声明  CONSTRAINT xxx PRIMARY KEY(xxx)
        if (RelateTable <> '') and (RelateField <> '') and (Pos('{Link:', RelateField)=0) then
          Result := Result + ' references ' + RelateTable + '(' + RelateField + ')';
      end
      else if Self.KeyFieldType = cfktRID then
      begin
        if (RelateTable <> '') and (RelateField <> '') and (Pos('{Link:', RelateField)=0) then
          Result := Result + ' references ' + RelateTable + '(' + RelateField + ')';
      end;
    end
    else if ((dbType = 'MYSQL') and (Trim(DefaultValue) = DEF_VAL_auto_increment)) then
    begin //mysql自增型主键直接定义
      if Self.KeyFieldType = cfktID then
      begin
        Result := Result + ' primary key';
        if (RelateTable <> '') and (RelateField <> '') then
          Result := Result + ' references ' + RelateTable + '(' + RelateField + ')';
      end;
    end;
    if Assigned(GProc_OnEzdmlGenFieldTypeDescEvent) then
      Result := GProc_OnEzdmlGenFieldTypeDescEvent(Self.OwnerTable,
        Self, Result, DbType, '');
    Exit;
  end
  else
  begin
    if ((DataType = cfdtUnknow) or (DataType = cfdtOther))
      and (DataTypeName <> '') then
    begin
      FT := DataTypeName;
      if DataLength > 0 then
      begin
        if DataScale > 0 then
          FT := FT + Format('(%d,%d)', [DataLength, DataScale])
        else
          FT := FT + Format('(%d)', [DataLength]);
      end;
    end
    else
    begin
      if dbType = 'LANG_DATATYPE' then
      begin
        Result := DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[DataType];
        Exit;
      end;
      if dbType = 'LANG' then
        FT := DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[DataType]
      else
        FT := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[DataType];
      if DataType = cfdtString then
      begin
        if (DataLength <> 0) and (DataLength <> 4000) then
          FT := FT + '(' + IntToStr(DataLength) + ')';
      end
      else if DataType = cfdtFloat then
      begin
        if DataLength > 0 then
        begin
          if DataScale > 0 then
            FT := FT + Format('(%d,%d)', [DataLength, DataScale])
          else
            FT := FT + Format('(%d)', [DataLength]);
        end;
      end
      else if DataType = cfdtInteger then
      begin
        if (DataLength > 0) then
        begin
          FT := FT + Format('(%d)', [DataLength]);
        end;
      end;
    end;
    Result := FT;

    if dbType = 'DESC' then
      if (KeyFieldType = cfktId) then
        Result := 'PK' + Result
      else if (KeyFieldType = cfktRid) then
        Result := 'FK' + Result;
  end;
end;

function TCtMetaField.GetLogicDataTypeName: string;
begin
  Result := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[DataType];
end;

function TCtMetaField.GetPhyDataTypeName(dbType: string): string;
var
  dl: integer;
begin
  case DataType of
    cfdtFloat:
    begin
      Result := GetCtFieldPhyTypeName(dbType, DataType, DataLength);
      if DataTypeName <> '' then
        Result := GetCtCustFieldPhyTypeName(dbType, DataTypeName, DataLength);
      if DataLength > 0 then
      begin
        if dbType='HIVE' then
          if LowerCase(Result)='double' then
            Result := 'decimal';
        if DataScale > 0 then
          Result := Result + Format('(%d,%d)', [DataLength, DataScale])
        else
          Result := Result + Format('(%d)', [DataLength]);
      end
      else
      begin
        if dbType = 'SQLSERVER' then
          if UpperCase(Result) = 'NUMERIC' then
            Result := 'FLOAT';
      end;
    end;
    cfdtInteger:
    begin
      Result := GetCtFieldPhyTypeName(dbType, DataType, DataLength);
      dl := DataLength;
      if (dbType = 'POSTGRESQL') and (Trim(DefaultValue) =
        DEF_VAL_auto_increment) then
      begin
        Result := 'bigserial';
        dl := 0;
      end
      else if dl > 0 then
      begin
        if (dbType = 'SQLITE') then
          dl := 0
        else if (dbType = 'POSTGRESQL') then
        begin
          if dl > 11 then
            Result := 'bigint'
          else if dl <= 6 then
            Result := 'smallint'
          else
            Result := 'integer';
          dl := 0;
        end
        else if (dbType = 'SQLSERVER') then
        begin
          if dl > 11 then
            Result := 'bigint'
          else if dl <= 4 then
            Result := 'tinyint'
          else if dl <= 6 then
            Result := 'smallint'
          else
            Result := 'int';
          Result := UpperCase(Result);
          dl := 0;
        end
        else if (dbType = 'MYSQL') then
        begin
          if dl > 11 then
            Result := 'bigint'
          else if dl <= 4 then
            Result := 'tinyint'
          else if dl <= 6 then
            Result := 'smallint'
          else if dl <= 8 then
            Result := 'mediumint'
          else
            Result := 'int';
          Result := UpperCase(Result);
          dl := 0;
        end
        else if (dbType = 'HIVE') then
        begin
          if dl > 11 then
            Result := 'bigint'
          else if dl <= 4 then
            Result := 'tinyint'
          else if dl <= 6 then
            Result := 'smallint'
          else
            Result := 'int';
          Result := UpperCase(Result);
          dl := 0;
        end;
      end;
      if DataTypeName <> '' then
        Result := GetCtCustFieldPhyTypeName(dbType, DataTypeName, dl);
      if dl > 0 then
      begin
        //if (dbType <> 'SQLSERVER') and (dbType <> 'MYSQL') then
        Result := Result + Format('(%d)', [dl]);
      end
      else
      begin
        if dbType = 'ORACLE' then
        begin
          if UpperCase(Result) = 'NUMBER' then
          begin
            if (KeyFieldType in [cfktId, cfktRid]) and G_BigIntForIntKeys then
              Result := Result + '(19)'
            else
              Result := Result + '(10)';
          end;
        end
        else if (KeyFieldType in [cfktId, cfktRid]) and G_BigIntForIntKeys then
          if (UpperCase(Result) = 'INT') or (UpperCase(Result) = 'INTEGER') then
          begin
            if (dbType = 'MYSQL') or (dbType = 'SQLSERVER') then
            begin
              Result := 'BIGINT';
            end
            else if (dbType = 'POSTGRESQL') or (dbType = 'HIVE') then
            begin
              Result := 'bigint';
            end;
          end;
      end;
    end;
    cfdtEnum:
    begin
      Result := GetCtFieldPhyTypeName(dbType, DataType, DataLength);
      ;
      if DataLength > 0 then
      begin
        //if (dbType <> 'SQLSERVER') and (dbType <> 'MYSQL') then
        Result := Result + Format('(%d)', [DataLength]);
      end;
      if dbType <> 'ORACLE' then
        if DataTypeName <> '' then
          Result := GetCtCustFieldPhyTypeName(dbType, DataTypeName, DataLength);
    end;
    cfdtDate:
    begin
      Result := GetCtFieldPhyTypeName(dbType, DataType, DataLength);
      if dbType = 'MYSQL' then //MYSQL的日期，只有TIMESTAMP支持缺省值
        if Self.DefaultValue <> '' then
          if G_MysqlVersion <= 5 then
            Result := 'TIMESTAMP';
      if DataTypeName <> '' then
      begin
        Result := GetCtCustFieldPhyTypeName(dbType, DataTypeName, DataLength);
      end;
      if DataLength > 0 then
        Result := Result + Format('(%d)', [DataLength]);
    end;
    cfdtBool,
    cfdtBlob:
    begin
      Result := GetCtFieldPhyTypeName(dbType, DataType, DataLength);
      ;
      if DataTypeName <> '' then
        Result := GetCtCustFieldPhyTypeName(dbType, DataTypeName, DataLength);
      if DataLength > 0 then
        if Pos('binary', LowerCase(Result)) > 0 then
          Result := Result + Format('(%d)', [DataLength]);
    end;
    cfdtString:
    begin
      Result := GetCtFieldPhyTypeName(dbType, DataType, DataLength);
      if DataTypeName <> '' then
        Result := GetCtCustFieldPhyTypeName(dbType, DataTypeName, DataLength);
      if not CheckStringMaxLen(dbType, Self.DataTypeName, Result, DataLength) then
      begin
        if DbType = 'HIVE' then
        begin
          if DataLength > 0 then
          begin
            if LowerCase(Result)='string' then
              Result := 'varchar';
            Result := Result + '(' + IntToStr(DataLength) + ')';
          end
          else
          begin
            if LowerCase(Result)='varchar' then
              Result := 'string'
            else if LowerCase(Result)<>'string' then
              Result := Result + '(4000)';
          end;
        end
        else
        begin
          if DataLength > 0 then
            Result := Result + '(' + IntToStr(DataLength) + ')'
          else if Pos('(', Result) = 0 then
          begin
            if DbType <> 'SQLITE' then
              Result := Result + '(4000)';
          end;
        end;
      end;
    end;
    else
      Result := DataTypeName;
      if Result = '' then
        Result := GetCtFieldPhyTypeName(dbType, DataType, DataLength)
      else
        Result := GetCtCustFieldPhyTypeName(dbType, DataTypeName, DataLength);
      if DataLength > 0 then
      begin
        if DataScale > 0 then
          Result := Result + Format('(%d,%d)', [DataLength, DataScale])
        else
          Result := Result + Format('(%d)', [DataLength]);
      end;
  end;
  Result := CheckCustDataTypeReplaces(Result);
end;

function TCtMetaField.GetNameCaption: string;
begin
  Result := Name;
  if Result = '' then
    Result := DisplayName
  else if DisplayName <> '' then
    if DisplayName <> Name then
      Result := Result + '(' + DisplayName + ')';
end;

function TCtMetaField.IsEditorUIClear: boolean;
begin
  Result := False;

  if FEditorType <> '' then
    Exit;
  if FLabelText <> '' then
    Exit;
  if FEditorReadOnly then
    Exit;
  //FEditorEnabled := True;
  if FDisplayFormat <> '' then
    Exit;
  if FEditFormat <> '' then
    Exit;
  if FDropDownItems <> '' then
    Exit;
  if FDropDownMode <> cfddNone then
    Exit;

  //FVisibility := 0;
  if FColWidth <> 0 then
    Exit;
  if FMaxLength <> 0 then
    Exit;
  if FSearchable then
    Exit;
  if FQueryable then
    Exit;

  Result := True;
end;

function TCtMetaField.GetNullable: boolean;
begin
  Result := FNullable and (KeyFieldType <> cfktId);
end;

function TCtMetaField.GenDemoDataEx(ARowIndex: integer; AOpt: string;
  ADataSet: TDataSet): string;
var
  S: string;
  J: integer;
  fd: TCtMetaField;
  bHasCustRule: boolean;
  bChkNulls: boolean;
begin    
  if Pos('[REMOVE_NULLS]', AOpt)>0 then
  begin
    bChkNulls:=True;
    AOpt := StringReplace(AOpt, '[REMOVE_NULLS]', '', [rfReplaceAll]);
  end
  else
    bChkNulls:=False;

  if Self.DropDownItems <> '' then
    bHasCustRule := True
  else if Self.TestDataType <> '' then
    bHasCustRule := True
  else if Self.TestDataRules <> '' then
    bHasCustRule := True
  else if Self.ValueFormat <> '' then
    bHasCustRule := True
  else if Self.ExtractDropDownItemsFromMemo <> '' then
    bHasCustRule := True
  else
    bHasCustRule := False;

  if not bHasCustRule and (Self.KeyFieldType in [cfktPid, cfktRid]) then
  begin
    if Self.LabelText <> '' then
    begin
      if Self.KeyFieldType in [cfktPid] then
        if OwnerTable <> nil then
        begin
          S := self.OwnerTable.GetTitleFieldName;
          if S <> '' then
            if UpperCase(S) <> UpperCase(Self.Name) then
            begin
              fd := OwnerTable.MetaFields.FieldByName(S);
              if fd <> nil then
              begin
                Result := fd.GenDemoData(ARowIndex, AOpt, ADataSet);
                Exit;
              end;
            end;
        end;
      if Self.KeyFieldType in [cfktRid] then
      begin
        fd := Self.GetRelateTableTitleField;
        if fd <> nil then
          if fd <> Self then
          begin
            Result := fd.GenDemoData(ARowIndex, AOpt, ADataSet);
            Exit;
          end;
      end;
    end;
  end;

  if not bHasCustRule and (Self.DataType = cfdtCalculate) then
  begin
    fd := GetRelateTableField;
    if (fd <> nil) and (fd <> Self) then
    begin
      Result := fd.GenDemoData(ARowIndex, AOpt, ADataSet);
      Exit;
    end;
  end;

  if not bHasCustRule and (Self.DataType = cfdtObject) then
  begin
    fd := GetRelateTableTitleField;
    if (fd <> nil) and (fd <> Self) then
    begin
      Result := fd.GenDemoData(ARowIndex, AOpt, ADataSet);
      Exit;
    end;
  end;

  if not bHasCustRule and (Self.DataType = cfdtList) then
  begin
    fd := GetRelateTableTitleField;
    if (fd <> nil) and (fd <> Self) then
    begin
      S := fd.GenDemoData(ARowIndex, AOpt, ADataSet);
      S := S + ', '+ fd.GenDemoData(ARowIndex+17, AOpt, ADataSet);
      S := S + ', '+ fd.GenDemoData(ARowIndex+79, AOpt, ADataSet);
      Result := S;
      Exit;
    end;
  end;

  S := Self.DisplayName;
  if S = '' then
    S := Self.Name;

  J := ARowIndex;
  if J < 0 then
    J := Random(100);
  S := S + IntToStr(J + 1);

  {if DefaultValue <> '' then
    S := DefaultValue
  else }
  if DataType = cfdtDate then
    S := FormatDateTime('yyyy-mm-dd hh:nn:ss', Trunc(Now) - 20 + J +
      Self.ID + Cos(J + Trunc(Time * 100)))
  else if DataType = cfdtInteger then
  begin
    if KeyFieldType <> cfktId then
      J := Round(Abs(Sin(ARowIndex + Self.ID + Trunc(Time * 123)) * 11779));
    S := IntToStr(CheckMaxMinDemoInt(J + 1));
  end                                
  else if DataType = cfdtEnum then
  begin
    J := Round(Abs(Sin(ARowIndex + Self.ID + Trunc(Time * 123)) * 11779));
    S := IntToStr(J mod 5);
  end
  else if DataType = cfdtFloat then
    S := FormatFloat('#0.##', CheckMaxMinDemoFloat(Abs(Sin(J + ID + Trunc(Time * 120)) * 100)))
  else if DataType = cfdtBool then
  begin
    if ((J + ID + Trunc(Time * 130)) mod 3) = 0 then
      S := srBoolName_False
    else
      S := srBoolName_True;
  end;
  Result := S;

  if Assigned(Proc_GenDemoData) then
    Result := Proc_GenDemoData(Self, '', Result, ARowIndex, AOpt, ADataSet);

  if Result='_null' then
    if bChkNulls then
       Result := '';
end;

function TCtMetaField.GetSqlQuotValue(AVal, ADbType: string;
  ADbEngine: TCtMetaDatabase): string;
begin
  Result := AVal;
  if ADbEngine <> nil then
    if ADbEngine.EngineType <> '' then
      ADbType := ADbEngine.EngineType;

  case Self.DataType of
    cfdtDate:
    begin
      Result := DBSqlStringToDateTime(Result, ADbType);
    end;
    cfdtInteger,
    cfdtFloat,
    cfdtBool,
    cfdtEnum:
    begin
    end;
  else
    Result := GetDbQuotString(Result, ADbType);
  end;
end;

function TCtMetaField.GetDemoItemList(bTextOnly: boolean): string;
var
  S: string;
  fd: TCtMetaField;
  ss: TStringList;
  I: Integer;
begin
  Result := Self.DropDownItems;
  if Result <> '' then
    if Trim(Result)='' then
      Result := '';
  if Result = '' then
  begin
    Result := ExtractDropDownItemsFromMemo;
  end;

  if Result = '' then
  begin
    if Assigned(Proc_GenDemoData) then
    begin
      S := Proc_GenDemoData(Self, '', '', -1, '[GET_DROPDOWN_ITEMS]', nil);
      if S <> '' then
        Result := S;
    end;
  end;

  if Result = '' then
  begin
    if Self.DataType = cfdtCalculate then
    begin
      fd := GetRelateTableField;
      if (fd <> nil) and (fd <> Self) then
      begin
        Result := fd.GetDemoItemList(bTextOnly);
        Exit;
      end;
    end;
  end;

  if Result = '' then
  begin              
    ss:= TStringList.Create;
    try
      for I:=0 to 4 do
      begin
        if I=4 then   
          if (Self.ID mod 3) <> 1 then
            Break;      
        S := GenDemoData(I, '[GEN_DROPDOWN_ITEM]', nil);
        if ss.IndexOf(S) < 0 then
          ss.Add(S);
      end;
      Result := ss.Text;
    finally
      ss.Free;
    end;
  end;

  if Result <> '' then
    if bTextOnly then
      Result := GetCtDropDownItemsText(Result);
end;

function TCtMetaField.ExtractDropDownItemsFromMemo: string;
var
  I, po: integer;
  S, M, T: string;
begin
  Result := '';
  if Memo = '' then
    Exit;
  if G_FieldItemListKeys = nil then
  begin
    G_FieldItemListKeys := TStringList.Create;
    G_FieldItemListKeys.Text := srFieldItemListKey;
    for I := G_FieldItemListKeys.Count - 1 downto 0 do
    begin
      S := Trim(G_FieldItemListKeys[I]);
      if S = '' then
        G_FieldItemListKeys.Delete(I)
      else
        G_FieldItemListKeys[I] := ' ' + LowerCase(S);
    end;
  end;

  M := ' ' + Memo;
  T := LowerCase(M);
  for I := 0 to G_FieldItemListKeys.Count - 1 do
  begin
    S := G_FieldItemListKeys[I];
    po := Pos(S, T);
    if po > 0 then
    begin
      Result := Trim(Copy(M, po + Length(S), Length(M)));
      if Pos(#10, Result) = 0 then
      begin
        if Pos('; ', Result) > 0 then
          Result := StringReplace(Result, '; ', #13#10, [rfReplaceAll])
        else if Pos(', ', Result) > 0 then
          Result := StringReplace(Result, ', ', #13#10, [rfReplaceAll])
        else if Pos(';', Result) > 0 then
          Result := StringReplace(Result, ';', #13#10, [rfReplaceAll])
        else if Pos(',', Result) > 0 then
          Result := StringReplace(Result, ',', #13#10, [rfReplaceAll])
        else if Pos(' ', Result) > 0 then
          Result := StringReplace(Result, ' ', #13#10, [rfReplaceAll]);
      end;
      Exit;
    end;
  end;
end;

function TCtMetaField.CheckMaxMinDemoInt(val: integer): integer;
var
  v1, v2, dv: integer;
begin
  v1 := 0;
  if Self.ValueMin <> '' then
  begin
    v1 := StrToIntDef(ValueMin, 0);
    if v1 > 0 then
      if val < v1 then
        val := v1 + val;
  end;
  if Self.ValueMax <> '' then
  begin
    v2 := StrToIntDef(ValueMax, 0);
    if v2 > 0 then
      if val > v2 then
      begin
        if (v1 <= 0) or (v1 > v2) then
          val := v2 - Abs(val)
        else
        begin
          dv := v2 - v1;
          if dv <= 0 then
            val := v1
          else
          begin
            val := val mod dv + v1;
          end;
        end;
      end;
  end;
  Result := val;
end;

function TCtMetaField.CheckMaxMinDemoFloat(val: double): double;
var
  v1, v2, dv: double;
begin
  v1 := 0;
  if Self.ValueMin <> '' then
  begin
    v1 := StrToFloatDef(ValueMin, 0);
    if v1 > 0 then
      if val < v1 then
        val := v1 + val;
  end;
  if Self.ValueMax <> '' then
  begin
    v2 := StrToFloatDef(ValueMax, 0);
    if v2 > 0 then
      if val > v2 then
      begin
        if (v1 < 0.00000001) or (v1 > v2) then
          val := v2 - Abs(val)
        else
        begin
          dv := v2 - v1;
          if dv < 0.00000001 then
            val := v1
          else
          begin
            dv := dv * 10000;
            val := val * 10000;
            val := Round(val) mod Round(dv);
            val := val / 10000.0 + v1;
          end;
        end;
      end;
  end;
  Result := val;
end;

function TCtMetaField.GetRelateTableObj: TCtMetaTable;
begin
  Result := nil;
  if Trim(Self.RelateTable) = '' then
    Exit;
  if FGlobeDataModelList = nil then
    Exit;
  Result := FGlobeDataModelList.GetTableOfName(Self.RelateTable);
  if Assigned(Result) then
    if not Result.IsTable then
      Result := nil;
end;

function TCtMetaField.GetRelateTableField: TCtMetaField;
var
  tb: TCtMetaTable;
begin
  Result := nil;
  if Trim(Self.RelateField) = '' then
    Exit;
  if Pos('{Link:', Trim(Self.RelateField)) = 1 then
    Exit;
  tb := GetRelateTableObj;
  if tb = nil then
    Exit;
  Result := tb.MetaFields.FieldByName(Self.RelateField);
end;

function TCtMetaField.GetRelateTableTitleField: TCtMetaField;
var
  tb: TCtMetaTable;
  S: string;
begin
  Result := nil;
  tb := GetRelateTableObj;
  if tb = nil then
    Exit;

  S := tb.GetTitleFieldName;
  if S <> '' then
    Result := tb.MetaFields.FieldByName(S);
end;

function TCtMetaField.GetRelateTableDemoJson(ARowIndex: Integer; AOpt: string): string;
var
  tb: TCtMetaTable;
begin
  Result := '';
  tb := GetRelateTableObj;
  if tb = nil then
    Exit;
  Result := tb.GetDemoJsonData(ARowIndex, AOpt, Self.RelateField);
end;

function TCtMetaField.HasUIDesignProps: Boolean;
begin
  Result := True;


  if FHint <> '' then Exit;
  if FUrl <> '' then Exit;
  if FResType <> '' then Exit;
  if FFormula <> '' then Exit;
  if FFormulaCondition <> '' then Exit;
  if FAggregateFun <> '' then Exit;
  if FMeasureUnit <> '' then Exit;
  if FValidateRule <> '' then Exit;
  if FEditorType <> '' then Exit;
  if FLabelText <> '' then Exit;
  if FExplainText <> '' then Exit;
  if FEditorReadOnly then Exit;
  if not FEditorEnabled then Exit;
  if FIsHidden then Exit;
  if FDisplayFormat <> '' then Exit;
  if FEditFormat <> '' then Exit;
  if FFontName <> '' then Exit;
  if FFontSize <> 0 then Exit;
  if FFontStyle <> 0 then Exit;
  if FForeColor <> 0 then Exit;
  if FBackColor <> 0 then Exit;
  if FDropDownItems <> '' then Exit;
  if FDropDownMode <> cfddNone then Exit;

  if FVisibility <> 0 then Exit;
  if FTextAlign <> cftaAuto then Exit;
  if FColWidth <> 0 then Exit;
  if FMaxLength <> 0 then Exit;
  if FSearchable then Exit;
  if FQueryable then Exit;
  if FExportable then Exit;
  if FInitValue <> '' then Exit;
  if FValueMin <> '' then Exit;
  if FValueMax <> '' then Exit;
  if FValueFormat <> '' then Exit;
  if FExtraProps <> '' then Exit;
  if FCustomConfigs <> '' then Exit;

  if FExplainText <> '' then Exit;
  if FTextClipSize <> 0 then Exit;
  if FDropDownSQL <> '' then Exit;
  if FItemColCount <> 0 then Exit;
  if FFixColType <> cffcNone then Exit;
  if FHideOnList then Exit;
  if FHideOnEdit then Exit;
  if FHideOnView then Exit;
  if FAutoMerge then Exit;
  if FAutoTrim then Exit;
  if FRequired then Exit;
  if FColGroup <> '' then Exit;
  if FSheetGroup <> '' then Exit;
  if FColSortable then Exit;
  if FShowFilterBox then Exit;
  if FEditorProps <> '' then Exit;
  if FTestDataType <> '' then Exit;
  if FTestDataRules <> '' then Exit;
  if FUILogic <> '' then Exit;
  if FBusinessLogic <> '' then Exit;


  Result := False;
end;

function TCtMetaField.GetConstraintStr: string;
begin
  Result := GetConstraintStrEx(True, False);
end;

function TCtMetaField.GetConstraintStrEx(bWithKeys, bWithRelate: boolean): string;

  function Sub_GetConsStr(ci: integer): string;
  begin
    if ShouldUseEnglishForDML then
      Result := DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[ci]
    else
      Result := DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[ci];
  end;

  function EnccStr(cs: string): string;
  begin
    Result := cs;
    if Pos(',', Result) > 0 then
      result := StringReplace(Result, ',', '&', [rfReplaceAll]);
  end;

  function CheckLRQ(s: string): string;
  begin
    Result := S;
    if Pos('>', Result)=0 then
      Exit;
    while Pos('>>', Result)>0 do
      Result := StringReplace(Result, '>>', '> >', [rfReplaceAll]);
    if Result<>'' then
      if Result[Length(Result)]='>' then
        Result := Result+' ';
  end;

var
  S: string;
begin
  if not bWithKeys then
    S := ''
  else if KeyFieldType = cfktId then
    S := Sub_GetConsStr(2)
  else if KeyFieldType = cfktRid then
    S := Sub_GetConsStr(3)
  else
    S := '';
  if bWithRelate then
    if DataTypeName <> '' then
    begin
      if S <> '' then
        S := S + ',';
      S := S + Sub_GetConsStr(9) + ':' + EnccStr(DataTypeName);
    end;
  if IndexType = cfitUnique then
  begin
    if S <> '' then
      S := S + ',';
    S := S + Sub_GetConsStr(4);
    if Self.DataType = cfdtFunction then
      if bWithRelate and (IndexFields <> '') then
      begin
        S := S + ':' + EnccStr(Self.IndexFields);
        Result := CheckLRQ(S);
        Exit;
      end;
  end
  else if IndexType = cfitNormal then
  begin
    if S <> '' then
      S := S + ',';
    S := S + Sub_GetConsStr(5);
    if Self.DataType = cfdtFunction then
      if bWithRelate and (IndexFields <> '') then
      begin
        S := S + ':' + EnccStr(Self.IndexFields);
        Result := CheckLRQ(S);
        Exit;
      end;
  end;
  if not Nullable then
  begin
    if KeyFieldType <> cfktId then
    begin
      if S <> '' then
        S := S + ',';
      S := S + Sub_GetConsStr(1);
    end;
  end;
  if DefaultValue <> '' then
  begin
    if S <> '' then
      S := S + ',';
    if Trim(DefaultValue) = DEF_VAL_auto_increment then
    begin
      S := S + Sub_GetConsStr(7);
    end
    else
      S := S + Sub_GetConsStr(6) + ':' + EnccStr(DefaultValue);
  end;

  if bWithRelate then
    if (RelateTable <> '') then
    begin
      if S <> '' then
        S := S + ',';
      S := S + Sub_GetConsStr(8) + ':' + EnccStr(RelateTable);
      if RelateField <> '' then
        S := S + '.' + EnccStr(RelateField);
    end;

  Result := CheckLRQ(S);
end;

function TCtMetaField.GetFieldComments: string;
begin
  Result := Memo;
  if Result <> '' then
  begin
    if (Name <> '') and (DisplayName <> '') and (Name <> DisplayName) then
      Result := DisplayName + ' ' + Result;
  end
  else if DisplayName <> '' then
    Result := DisplayName;
end;

function TCtMetaField.GetFieldDefaultValDesc(dbType: string = ''): string;
begin
  if DefaultValue = '' then
    Result := ''
  else if Trim(DefaultValue) = DEF_VAL_auto_increment then
  begin
    if dbType = 'SQLSERVER' then
      Result := ' identity(1, 1)'
    else if dbType = 'MYSQL' then
    begin
      Result := ' auto_increment';
    end
    else if dbType = 'SQLITE' then
    begin
      Result := ' autoincrement';
    end
    else
      Result := ' /*auto_increment*/';
  end
  else
  begin
    if (LowerCase(DefaultValue) = 'sysdate')     
      or (LowerCase(DefaultValue) = 'sysdate()')
      or (LowerCase(DefaultValue) = 'getdate')
      or (LowerCase(DefaultValue) = 'getdate()')
      or (LowerCase(DefaultValue) = 'now')
      or (LowerCase(DefaultValue) = 'now()')
      or (LowerCase(DefaultValue) = 'current_timestamp()')
      or (LowerCase(DefaultValue) = 'current_timestamp') then
    begin
      if dbType = 'ORACLE' then
        Result := ' default sysdate'
      else if dbType = 'SQLSERVER' then
        Result := ' default getdate()'
      else if dbType = 'MYSQL' then
        Result := ' default current_timestamp'
      else if dbType = 'SQLITE' then
        Result := ' default (datetime(current_timestamp, ''localtime''))'
      else if dbType = 'POSTGRESQL' then
        Result := ' default now()'
      else
        Result := ' default ' + DefaultValue;
    end
    else if (LowerCase(DefaultValue) = 'empty_clob()') or
      (LowerCase(DefaultValue) = 'empty_blob()') then
    begin
      if dbType = 'ORACLE' then
        Result := ' default ' + DefaultValue
      else
        Result := '';
    end
    else
      Result := ' default ' + DefaultValue;
  end;
end;

{ TCtMetaFieldList }

function TCtMetaFieldList.FieldByName(AName: string): TCtMetaField;
var
  I: integer;
begin
  AName := UpperCase(AName);
  for I := 0 to Count - 1 do
    if Assigned(Items[I]) and (UpperCase(Items[I].Name) = AName) then
      if Items[I].DataLevel <> ctdlDeleted then
      begin
        Result := Items[I];
        Exit;
      end;
  Result := nil;
end;

function TCtMetaFieldList.FieldByDisplayName(ADispName: string): TCtMetaField;
var
  I: integer;
  S: string;
begin
  ADispName := UpperCase(ADispName);
  for I := 0 to Count - 1 do
    if Assigned(Items[I]) then
    begin
      S := Items[I].DisplayName;
      if S = '' then
        S := Items[I].Name;
      if (UpperCase(S) = ADispName) then
        if Items[I].DataLevel <> ctdlDeleted then
        begin
          Result := Items[I];
          Exit;
        end;
    end;
  Result := nil;
end;

function TCtMetaFieldList.FieldByLabelName(ALbName: string): TCtMetaField;
var
  I: integer;
  S: string;
begin
  ALbName := UpperCase(ALbName);
  for I := 0 to Count - 1 do
    if Assigned(Items[I]) then
    begin
      S := Items[I].GetLabelText;
      if (UpperCase(S) = ALbName) then
        if Items[I].DataLevel <> ctdlDeleted then
        begin
          Result := Items[I];
          Exit;
        end;
    end;
  Result := nil;
end;

function TCtMetaFieldList.GetItem(Index: integer): TCtMetaField;
begin
  Result := TCtMetaField(inherited Get(Index));
end;

procedure TCtMetaFieldList.PutItem(Index: integer; const Value: TCtMetaField);
begin
  inherited Put(Index, Value);
end;

procedure TCtMetaFieldList.SyncFieldsFrom(ACtFlds: TCtMetaFieldList;
  tmpList: TCtMetaFieldList);
var
  I: integer;
  S: string;
  fd: TCtMetaField;
begin
  if ACtFlds = nil then
    Exit;
  Self.AssignFrom(ACtFlds);
  if tmpList <> nil then
    for I := 0 to Count - 1 do
    begin
      S := Items[I].Name;
      fd := tmpList.FieldByName(S);
      if fd <> nil then
        Items[I].GraphDesc := fd.GraphDesc;
    end;
end;

function TCtMetaFieldList.CreateObj: TCtObject;
begin
  if Assigned(ItemClass) then
    Result := ItemClass.Create
  else
    Result := TCtMetaField.Create;
  if Result.Name = '' then
    Result.Name := 'New TCtMetaField';
end;

function TCtMetaFieldList.NewMetaField: TCtMetaField;
begin
  Result := TCtMetaField(NewObj);
  Result.CreateDate := Now;
  Result.DataType := cfdtString;
  Result.Name := Format(srNewFieldNameFmt, [Result.ID]);
  Result.MetaModified := True;
  if Assigned(FOwnerTable) then
    FOwnerTable.MetaModified := True;
end;

procedure TCtMetaFieldList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Self.AutoFree and (Action = lnDeleted) then
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtMetaField) then
      begin
        if (TCtMetaField(Ptr).FOwnerList = Self) then
          TCtMetaField(Ptr).FOwnerList := nil;
      end;
  inherited;
  if Self.AutoFree and (Action = lnAdded) then
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtMetaField) then
      begin
        if (TCtMetaField(Ptr).FOwnerList = nil) then
          TCtMetaField(Ptr).FOwnerList := Self;
      end;
end;

{ TCtMetaObject }

function TCtMetaObject.GetMetaModified: boolean;
begin
  Result := FMetaModified;
end;

function TCtMetaObject.GetJsonStr: string;
begin
  Result := '';
  if Assigned(Proc_CtObjToJsonStr) then
    Result := Proc_CtObjToJsonStr(Self);
end;

procedure TCtMetaObject.SetJsonStr(AValue: string);
begin
  if AValue = '' then
    Exit;
  if Assigned(Proc_ReadCtObjFromJsonStr) then
    Proc_ReadCtObjFromJsonStr(Self, AValue);
end;

procedure TCtMetaObject.SetMetaModified(const Value: boolean);
begin
  FMetaModified := Value;
end;


{ TCtDataModelGraph }

procedure TCtDataModelGraph.CheckDMGOptions;
begin
  //CtDMGOptions.GenFKIndexesSQL := Pos('GenFKIndexesSQL=1', FConfigStr) > 0;
end;

constructor TCtDataModelGraph.Create;
begin
  inherited;
  FTables := TCtMetaTableList.Create;
  FTables.FOwnerModel := Self;
end;

destructor TCtDataModelGraph.Destroy;
begin
  FreeAndNil(FTables);
  inherited;
end;

function TCtDataModelGraph.GetDisplayName: string;
begin
  if FCaption <> '' then
    Result := FCaption
  else
    Result := Name;
end;

function TCtDataModelGraph.IsHuge: boolean;
begin
  Result := Self.Tables.Count >= G_HugeModeTableCount;
end;

function TCtDataModelGraph.CheckCanRenameTo(ANewName: string): Boolean;
var
  I: Integer;
  md: TCtDataModelGraph;
  S: String;
begin
  Result:=True;
  if Self.OwnerList = nil then
    Exit;
  for I:=0 to OwnerList.Count - 1 do
  begin
    md := OwnerList.Items[I];
    if md=Self then
      Continue;
    if md.DataLevel=ctdlDeleted then
      Continue;
    if UpperCase(md.Name) <> UpperCase(ANewName) then
      Continue;
    S := Format(srRenameToExistsError, [ANewName]);
    Application.MessageBox(PChar(S), PChar(Application.Title),
      MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;
end;

procedure TCtDataModelGraph.Reset;
begin
  inherited;
  //FID         := 0;
  //FName       := '';
  FGraphWidth := 0;
  FGraphHeight := 0;
  FDefDbEngine := '';
  FDbConnectStr := '';
  FConfigStr := '';
  FTables.Clear;
end;

procedure TCtDataModelGraph.AssignFrom(ACtObj: TCtObject);
var
  cobj: TCtDataModelGraph;
begin
  inherited;
  if not (ACtObj is TCtDataModelGraph) then
    Exit;
  cobj := TCtDataModelGraph(ACtObj);
  //FID         := cobj.FID;
  //FName       := cobj.FName;
  FGraphWidth := cobj.FGraphWidth;
  FGraphHeight := cobj.FGraphHeight;
  FDefDbEngine := cobj.FDefDbEngine;
  FDbConnectStr := cobj.FDbConnectStr;
  FConfigStr := cobj.FConfigStr;
  FTables.AssignFrom(cobj.FTables);
end;

procedure TCtDataModelGraph.LoadFromSerialer(ASerialer: TCtObjSerialer);
begin
  BeginSerial(ASerialer, True);
  try
    inherited;
    //ASerialer.ReadInteger('ID', FID);
    //ASerialer.ReadString('Name', FName);
    ASerialer.ReadInteger('GraphWidth', FGraphWidth);
    ASerialer.ReadInteger('GraphHeight', FGraphHeight);
    ASerialer.ReadString('DefDbEngine', FDefDbEngine);
    ASerialer.ReadString('DbConnectStr', FDbConnectStr);
    ASerialer.ReadString('ConfigStr', FConfigStr);
    CheckDMGOptions;
    ASerialer.BeginChildren('Tables');
    try
      FTables.LoadFromSerialer(ASerialer);
      ASerialer.EndChildren('Tables');
    finally
    end;
    EndSerial(ASerialer, True);
  finally
  end;
end;

procedure TCtDataModelGraph.SaveToSerialer(ASerialer: TCtObjSerialer);
begin
  BeginSerial(ASerialer, False);
  try
    inherited;
    //ASerialer.WriteInteger('ID', FID);
    //ASerialer.WriteString('Name', FName);
    ASerialer.WriteInteger('GraphWidth', FGraphWidth);
    ASerialer.WriteInteger('GraphHeight', FGraphHeight);
    ASerialer.WriteString('DefDbEngine', FDefDbEngine);
    ASerialer.WriteString('DbConnectStr', FDbConnectStr);
    ASerialer.WriteString('ConfigStr', FConfigStr);
    ASerialer.BeginChildren('Tables');
    try
      FTables.SaveToSerialer(ASerialer);
      ASerialer.EndChildren('Tables');
    finally
    end;
    EndSerial(ASerialer, False);
  finally
  end;
end;

procedure TCtDataModelGraph.SetConfigStr(const Value: string);
begin
  FConfigStr := Value;
  CheckDMGOptions;
end;

{ TCtDataModelGraphList }

procedure TCtDataModelGraphList.DoOnTableRename(ATb: TCtMetaTable; AOldName,
  ANewName: string);
var
  I, J, K: integer;
  tb: TCtMetaTable;
  tbs: TCtMetaTableList;
begin
  if ATb = nil then
    Exit;
  for I := 0 to Count - 1 do
  begin
    tbs := Items[I].Tables;
    for J := 0 to tbs.Count - 1 do
    begin
      tb := tbs[J];
      for K := 0 to tb.MetaFields.Count - 1 do
        if UpperCase(tb.MetaFields[K].RelateTable) = UpperCase(AOldName) then
        begin
          tb.MetaFields[K].RelateTable := ANewName;
        end;
    end;
  end;
end;

function TCtDataModelGraphList.GetAllSubItemCount: integer;
var
  I, J: integer;
  md: TCtDataModelGraph;
  tb: TCtMetaTable;
begin
  Result := 1;
  for I := 0 to Count - 1 do
  begin
    md := Items[I];
    Inc(Result);
    for J := 0 to md.Tables.Count - 1 do
    begin
      tb := md.Tables.Items[J];
      Inc(Result);
      Result := Result + tb.MetaFields.Count;
    end;
  end;
end;

function TCtDataModelGraphList.GetAllTableCount: integer;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
  begin
    Result := Result + Items[I].Tables.Count;
  end;
end;

function TCtDataModelGraphList.GetCurDataModel: TCtDataModelGraph;
var
  I: integer;
begin
  if Assigned(FCurDataModel) then
    if FCurDataModel.DataLevel = ctdlDeleted then
      FCurDataModel := nil;
  if FCurDataModel = nil then
  begin
    for I := 0 to Count - 1 do
      if Items[I].DataLevel <> ctdlDeleted then
      begin
        FCurDataModel := Items[I];
        Break;
      end;

    if FCurDataModel = nil then
      FCurDataModel := NewModelItem;
  end;
  Result := FCurDataModel;
end;

function TCtDataModelGraphList.GetItem(Index: integer): TCtDataModelGraph;
begin
  Result := TCtDataModelGraph(inherited Get(Index));
end;

function TCtDataModelGraphList.HasSameNameTables(ATb: TCtMetaTable;
  AName: string): boolean;
var
  I, J: integer;
  tb: TCtMetaTable;
  tbs: TCtMetaTableList;
  tn: string;
begin
  Result := False;
  if ATb = nil then
    Exit;
  tn := AName;
  for I := 0 to Count - 1 do
  begin
    tbs := Items[I].Tables;
    for J := 0 to tbs.Count - 1 do
    begin
      tb := tbs.Items[J];
      if (tb <> ATb) and (tb.DataLevel <> ctdlDeleted) then
        if UpperCase(tb.Name) = UpperCase(tn) then
        begin
          Result := True;
          Exit;
        end;
    end;
  end;
end;

function TCtDataModelGraphList.GetSameNameTableCount(ATb: TCtMetaTable
  ): integer;
var
  I, J: integer;
  tb: TCtMetaTable;
  tbs: TCtMetaTableList;
  tn: string;
begin
  Result := 0;
  if ATb = nil then
    Exit;
  tn := ATb.Name;
  for I := 0 to Count - 1 do
  begin
    tbs := Items[I].Tables;
    for J := 0 to tbs.Count - 1 do
    begin
      tb := tbs.Items[J];
      if (tb <> ATb) and (tb.DataLevel <> ctdlDeleted) then
        if UpperCase(tb.Name) = UpperCase(tn) then
        begin
          Inc(Result);
        end;
    end;
  end;
end;

function TCtDataModelGraphList.RenameSameNameTables(ATb: TCtMetaTable;
  AName: string): integer;
var
  I, J: integer;
  tb: TCtMetaTable;
  tbs: TCtMetaTableList;
  tn: string;
begin
  Result := 0;
  if ATb = nil then
    Exit;
  tn := ATb.Name;
  for I := 0 to Count - 1 do
  begin
    tbs := Items[I].Tables;
    for J := 0 to tbs.Count - 1 do
    begin
      tb := tbs.Items[J];
      if (tb <> ATb) and (tb.DataLevel <> ctdlDeleted) then
        if UpperCase(tb.Name) = UpperCase(tn) then
        begin
          tb.Name := AName;
          Inc(Result);
        end;
    end;
  end;
end;

function TCtDataModelGraphList.IsHuge: boolean;
begin
  if GetAllTableCount >= G_HugeModeTableCount then
    Result := True
  else
    Result := False;
end;

function TCtDataModelGraphList.GetTableOfName(AName: string): TCtMetaTable;
var
  I: integer;
  md: TCtDataModelGraph;
  tb: TCtMetaTable;
begin
  Result := nil;
  if Trim(AName) = '' then
    Exit;
  for I := 0 to Count - 1 do
  begin
    md := FGlobeDataModelList.Items[I];

    tb := TCtMetaTable(md.Tables.ItemByName(AName));
    if tb = nil then
      Continue;
    Result := tb;
    Exit;
  end;
end;

procedure TCtDataModelGraphList.LoadFromFile(fn: string);
var
  fs: TCtObjSerialer;
begin
  if not Assigned(Proc_CreateCtObjSerialer) then
    raise Exception.Create('Proc_CreateCtObjSerialer not assigned');
  fs := Proc_CreateCtObjSerialer(fn, False);
  try
    fs.RootName := 'DataModels';
    Self.LoadFromSerialer(fs);
  finally
    fs.Free;
  end;
end;

procedure TCtDataModelGraphList.LoadFromSerialer(ASerialer: TCtObjSerialer);
var
  I, C, L: integer;
  obj: TCtObject;
  bCont: boolean;
  S: string;
begin
  Assert(ASerialer <> nil);

  FCurDataModel := nil;

  //防止出错时L太大
  L := Length(DEF_CURCTVER);
  SetLength(S, L);
  ASerialer.ReadBuffer('CTVER', L, Pointer(S)^);
  if Copy(S, 1, 2) = 'CT' then
    ASerialer.CurCtVer := StrToIntDef(Copy(S, 3, 2), 21)
  else
  begin
    if not ASerialer.IsReadMode then
      RaiseCtException('CTVER_Error_And_Not_READMODE')
    else
      ASerialer.UnReadBuffer(L);
  end;

  Clear;
  ASerialer.ReadInteger('TableCount', C);
  if Assigned(FOnObjProgress) then
  begin
    bCont := True;
    FOnObjProgress(Self, '', 0, C, bCont);
    if not bCont then
      Exit;
  end;

  ASerialer.ReadInteger('Count', C);
  ASerialer.BeginChildren('');
  if ASerialer.ChildCountInvalid then
  begin
    I := 0;
    while ASerialer.NextChildObjToRead do
    begin
      obj := NewObj;
      Inc(I);
      obj.LoadFromSerialer(ASerialer);
      if Assigned(FOnObjProgress) then
      begin
        bCont := True;
        FOnObjProgress(Self, obj.NameCaption, I, C, bCont);
        if not bCont then
          Break;
      end;
    end;
  end
  else
    for I := 0 to C - 1 do
    begin
      if ASerialer.NextChildObjToRead then
      begin
        obj := NewObj;
        obj.LoadFromSerialer(ASerialer);
        if Assigned(FOnObjProgress) then
        begin
          bCont := True;
          FOnObjProgress(Self, obj.NameCaption, I, C, bCont);
          if not bCont then
            Break;
        end;
      end;
    end;
  ASerialer.EndChildren('');
end;

function TCtDataModelGraphList.NewModelItem: TCtDataModelGraph;
begin
  Result := TCtDataModelGraph(NewObj);
  Result.CreateDate := Now;
  Result.Name := Format(srNewDiagramNameFmt, [Result.ID]);
end;

procedure TCtDataModelGraphList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
  begin
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtDataModelGraph) then
      begin
        if Ptr = FCurDataModel then
          FCurDataModel := nil;
        if (TCtDataModelGraph(Ptr).FOwnerList = Self) then
          TCtDataModelGraph(Ptr).FOwnerList := nil;
      end;
  end;

  inherited;

  if (Action = lnAdded) then
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtDataModelGraph) then
      begin
        if (TCtDataModelGraph(Ptr).FOwnerList = nil) then
          TCtDataModelGraph(Ptr).FOwnerList := Self;
      end;
end;

constructor TCtDataModelGraphList.Create;
begin
  inherited Create;
end;

destructor TCtDataModelGraphList.Destroy;
begin
  inherited Destroy;
end;

procedure TCtDataModelGraphList.Pack;
var
  I, J: integer;
  item: TCtDataModelGraph;
begin
  inherited;
  for I := 0 to Count - 1 do
  begin
    item := Items[I];
    item.Tables.Pack;
    for J := 0 to item.Tables.Count - 1 do
      item.Tables[J].MetaFields.Pack;
  end;
end;

procedure TCtDataModelGraphList.PutItem(Index: integer; const Value: TCtDataModelGraph);
begin
  inherited Put(Index, Value);
end;

procedure TCtDataModelGraphList.SaveToFile(fn: string);
var
  fs: TCtObjSerialer;
begin
  if not Assigned(Proc_CreateCtObjSerialer) then
    raise Exception.Create('Proc_CreateCtObjSerialer not assigned');
  fs := Proc_CreateCtObjSerialer(fn, True);
  try
    fs.RootName := 'DataModels';
    Self.SaveToSerialer(fs);
  finally
    fs.Free;
  end;
end;

procedure TCtDataModelGraphList.SaveToSerialer(ASerialer: TCtObjSerialer);
var
  I, C: integer;
  bCont: boolean;
  S: string;
begin
  Assert(ASerialer <> nil);
  SaveCurrentOrder;
  SortByOrderNo;

  C := TableCount;
  if Assigned(FOnObjProgress) then
  begin
    bCont := True;
    FOnObjProgress(Self, '', 0, C, bCont);
    if not bCont then
      Exit;
  end;

  ASerialer.CurCtVer := StrToIntDef(Copy(DEF_CURCTVER, 3, 2), 21);
  S := DEF_CURCTVER;
  ASerialer.WriteBuffer('CTVER', Length(S), Pointer(S)^);

  ASerialer.WriteInteger('TableCount', C);

  C := Count;
  ASerialer.WriteInteger('Count', C);
  ASerialer.BeginChildren('');
  for I := 0 to C - 1 do
  begin
    Items[I].SaveToSerialer(ASerialer);
    if Assigned(FOnObjProgress) then
    begin
      bCont := True;
      FOnObjProgress(Self, Items[I].NameCaption, I, C, bCont);
      if not bCont then
        Break;
    end;
  end;
  ASerialer.EndChildren('');
end;

procedure TCtDataModelGraphList.SortByOrderNo;
var
  I, J: integer;
  item: TCtDataModelGraph;
begin
  inherited;

  for I := 0 to Count - 1 do
  begin
    item := Items[I];
    item.Tables.SortByOrderNo;
    for J := 0 to item.Tables.Count - 1 do
      item.Tables[J].MetaFields.SortByOrderNo;
  end;
end;

procedure TCtDataModelGraphList.SyncTableProps(ATb: TCtMetaTable);
var
  I, J, K, H: integer;
  tb: TCtMetaTable;
  fa, fb: TCtMetaField;
  tbs: TCtMetaTableList;
  tn: string;
begin
  if FSyncingTbProp then
    Exit;
  FSyncingTbProp := True;
  try
    if ATb = nil then
      Exit;
    //将表属性同步到所有同名表
    tn := ATb.Name;
    for I := 0 to Count - 1 do
    begin
      tbs := Items[I].Tables;
      for J := 0 to tbs.Count - 1 do
      begin
        tb := tbs.Items[J];
        if (tb <> ATb) and (tb.DataLevel <> ctdlDeleted) then
          if UpperCase(tb.Name) = UpperCase(tn) then
          begin
            tb.SyncPropFrom(ATb);
          end;
      end;
    end;
    //如果有修改字段名，则同时更新引用字段名
    for H:=0 to ATb.MetaFields.Count - 1 do
    begin
      fa := ATb.MetaFields[H];
      if fa.DataLevel = ctdlDeleted then
        Continue;
      if fa.OldName='' then
        Continue;   
      for I := 0 to Count - 1 do
      begin
        tbs := Items[I].Tables;
        for J := 0 to tbs.Count - 1 do
        begin
          tb := tbs.Items[J];
          if (tb <> ATb) and (tb.DataLevel <> ctdlDeleted) then
            for K:=0 to tb.MetaFields.Count - 1 do
            begin
              fb := tb.MetaFields[K];
              if UpperCase(fb.RelateTable)=UpperCase(tn) then
              begin
                if UpperCase(fb.RelateField)=UpperCase(fa.OldName) then
                  fb.RelateField:= fa.Name;
              end;
            end;
        end;
      end;
      fa.OldName:='';
    end;
  finally
    FSyncingTbProp := False;
  end;
end;

function TCtDataModelGraphList.TableCount: integer;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    Result := Result + Items[I].Tables.Count;
end;

function TCtDataModelGraphList.CreateObj: TCtObject;
begin
  if Assigned(ItemClass) then
    Result := ItemClass.Create
  else
    Result := TCtDataModelGraph.Create;
  TCtDataModelGraph(Result).Tables.OnObjProgress := Self.OnObjProgress;
  if Result.Name = '' then
    Result.Name := 'New TCtDataModelGraph';
end;

{ TCtMetaDatabase }

constructor TCtMetaDatabase.Create;
begin
end;

destructor TCtMetaDatabase.Destroy;
begin
  inherited;
end;

function TCtMetaDatabase.ExecCmd(ACmd, AParam1, AParam2: string): string;
begin
  Result := '';
end;

procedure TCtMetaDatabase.ExecSql(ASql: string);
begin
end;

function TCtMetaDatabase.GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string;

  var
    VModelTb: TCtMetaTable;

  function GetFieldBK(dmlTl: TCtMetaTable; fldName: string): string;
  var
    I: integer;
    resi: integer;
  begin
    resi := 1;
    while True do
    begin
      Inc(resi);
      Result := fldName + '_BK' + IntToStr(resi) + '_';
      for I := 0 to dmlTl.MetaFields.Count - 1 do
      begin
        if AnsiSameText(dmlTl.MetaFields[I].Name, Result) then
        begin
          Result := '';
          Break;
        end;
      end;
      if Result <> '' then
        Break;
    end;
  end;

  function GetQuotName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, EngineType);
  end;

  function GetQuotTbName(AName: string): string;
  begin
    Result := GetDbQuotName(AName, EngineType);
    if Assigned(VModelTb) and (Trim(VModelTb.OwnerCategory) <> '') then
      Result := VModelTb.OwnerCategory+'.'+Result
    else if EngineType='SQLSERVER' then
    begin
      if Self.FDbSchema <> '' then
        Result := FDbSchema+'.'+Result
      else
        Result := 'dbo.'+Result;
    end;
  end;

  function GetIndexPrefixInfo(AField: TCtMetaField): string;
  begin
    Result := '';
    if EngineType = 'MYSQL' then
      if AField.DataType = cfdtString then
        if AField.DataLength > 255 then
          Result := '(255)';
  end;

  function TrimQuot(AStr: string): string;
  var
    s1, s2: string;
  begin
    Result := Trim(AStr);
    if Pos('default ', Result) = 1 then
      Result := Trim(Copy(Result, 9, Length(Result)));
    if Length(Result) >= 2 then
    begin
      s1 := Result[1];
      s2 := Result[Length(Result)];
      if s1 = s2 then
      begin
        if (s1 = '''') or (s1 = '`') or (s1 = '"') then
          Result := Copy(Result, 2, Length(Result) - 2);
      end;
    end;
  end;

  function IsIntKeyField(AField: TCtMetaField): boolean;
  begin
    if (AField.KeyFieldType = cfktID) or (AField.KeyFieldType = cfktPID)
      or (AField.KeyFieldType = cfktRID) then
      Result := True
    else
      Result := False;
  end;

  function GetAlterTableColActStrEx(cmd: string; tab: TCtMetaTable;
    ctF, dbF: TCtMetaField): string;
  var
    tableName, nulls, T, S: string;
  begin
    Result := '';
    //TOnEzdmlGenAlterFieldEvent = function (action: String; tb: TCtMetaTable; designField, dbField: TCtMetaField; defRes, dbType, options: String): string;
    tableName := GetQuotTbName(tab.RealTableName);
    nulls := ctF.GetNullableStr(EngineType);
    if EngineType = 'ORACLE' then
    begin
      if cmd = 'alter' then
      begin
        Result := 'alter  table ' + tableName + ' modify ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);

        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType)
        else if dbF.DefaultValue <> '' then
          Result := Result + ' default null';

        if nulls <> '' then
          Result := Result + nulls
        else if not dbF.Nullable then
          Result := Result + ' null';
        Result := Result + ';';
      end
      else if cmd = 'add' then
      begin
        Result := 'alter  table ' + tableName + ' add ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);
        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType);
        Result := Result + nulls;
        Result := Result + ';';
      end
      else if cmd = 'drop' then
      begin
        Result := '-- alter  table ' + tableName + ' drop column ' +
          GetQuotName(dbF.Name) + ';';
      end;
      Exit;
    end;
    if EngineType = 'MYSQL' then
    begin
      if cmd = 'alter' then
      begin
        Result := 'alter  table ' + tableName + ' modify ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);

        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType)
        else if dbF.DefaultValue <> '' then
          Result := Result + ' default null';

        if nulls <> '' then
          Result := Result + nulls
        else if not dbF.Nullable then
          Result := Result + ' null';

        Result := Result + ' comment ''' + ReplaceSingleQuotmark(
          ctF.GetFieldComments) + '''';

        Result := Result + ';';
      end
      else if cmd = 'add' then
      begin
        Result := 'alter  table ' + tableName + ' add ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);
        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType);
        Result := Result + nulls;
        Result := Result + ' comment ''' + ReplaceSingleQuotmark(
          ctF.GetFieldComments) + '''';
        Result := Result + ';';
      end
      else if cmd = 'drop' then
      begin
        Result := '-- alter  table ' + tableName + ' drop column ' +
          GetQuotName(dbF.Name) + ';';
      end;
      Exit;
    end;
    if EngineType = 'SQLSERVER' then
    begin
      if cmd = 'alter' then
      begin
        Result := 'alter  table ' + tableName + ' alter column ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);

        if nulls <> '' then
          Result := Result + nulls
        else if not dbF.Nullable then
          Result := Result + ' null';
        Result := Result + ';';

        if ctF.DefaultValue <> dbF.DefaultValue then
        begin
          if dbF.Param['SQLSERVER_DF_CONSTRAINT_NAME'] <> '' then
          begin
            Result := 'alter  table ' + tableName + ' drop constraint ' +
              dbF.Param['SQLSERVER_DF_CONSTRAINT_NAME'] + ';'#13#10 + Result;
          end;
          if Trim(ctF.DefaultValue) <> DEF_VAL_auto_increment then
            Result := Result + #13#10'alter  table ' + tableName +
              ' add constraint DF_' +
              GetIdxName(tab.RealTableName, ctF.Name) + ' ' +
              ctF.GetFieldDefaultValDesc(EngineType) + ' for ' +
              GetQuotName(ctF.Name) + ';';
        end;
      end
      else if cmd = 'add' then
      begin
        Result := 'alter  table ' + tableName + ' add ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);
        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType);
        Result := Result + nulls;
        Result := Result + ';';

        if ctF.DefaultValue <> '' then
        begin
          if Trim(ctF.DefaultValue) <> DEF_VAL_auto_increment then
            Result := Result + #13#10'alter  table ' + tableName +
              ' add constraint DF_' +
              GetIdxName(tab.RealTableName, ctF.Name) + ' ' +
              ctF.GetFieldDefaultValDesc(EngineType) + ' for ' +
              GetQuotName(ctF.Name) + ';';
        end;
      end
      else if cmd = 'drop' then
      begin
        Result := '-- alter  table ' + tableName + ' drop column ' +
          GetQuotName(dbF.Name) + ';';
      end;
      Exit;
    end;
    if EngineType = 'POSTGRESQL' then
    begin
      if cmd = 'alter' then
      begin
        Result := '';
        if ctF.GetFieldTypeDesc(True, EngineType) <>
          dbF.GetFieldTypeDesc(True, EngineType) then
          Result := 'alter  table ' + tableName + ' alter column ' +
            GetQuotName(ctF.Name)
            + ' TYPE ' + ctF.GetFieldTypeDesc(True, EngineType) + ';';

        if ctF.DefaultValue <> dbF.DefaultValue then
        begin
          if (ctF.DefaultValue <> '') and (Trim(ctF.DefaultValue) <>
            DEF_VAL_auto_increment) then
            Result := Result + #13#10 + 'alter  table ' + tableName +
              ' alter column ' + GetQuotName(ctF.Name)
              + ' set ' + ctF.GetFieldDefaultValDesc(EngineType) + ';'
          else if (dbF.DefaultValue <> '') and
            (Trim(dbF.DefaultValue) <> DEF_VAL_auto_increment) then
            Result := Result + #13#10 + 'alter  table ' + tableName +
              ' alter column ' + GetQuotName(ctF.Name)
              + ' drop default;';
        end;

        if (ctF.Nullable <> dbF.Nullable) or (nulls <> '') then
        begin
          if ctF.Nullable then
            Result := Result + #13#10 + 'alter  table ' + tableName +
              ' alter column ' + GetQuotName(ctF.Name)
              + ' drop not null;'
          else
            Result := Result + #13#10 + 'alter  table ' + tableName +
              ' alter column ' + GetQuotName(ctF.Name)
              + ' set not null;';
        end;
      end
      else if cmd = 'add' then
      begin
        Result := 'alter  table ' + tableName + ' add column ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);
        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType);
        Result := Result + nulls;
        Result := Result + ';';
      end
      else if cmd = 'drop' then
      begin
        Result := '-- alter  table ' + tableName + ' drop column ' +
          GetQuotName(dbF.Name) + ';';
      end;
      Exit;
    end;
    if EngineType = 'SQLITE' then
    begin
      if cmd = 'alter' then
      begin
        Result := '-- Warning: Can not modify table in Sqlite!!!'#13#10'alter  table '
          + tableName + ' alter column ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);

        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType)
        else if dbF.DefaultValue <> '' then
          Result := Result + ' default null';

        if nulls <> '' then
          Result := Result + nulls
        else if not dbF.Nullable then
          Result := Result + ' null';
        Result := Result + ';';
      end
      else if cmd = 'add' then
      begin
        Result := 'alter  table ' + tableName + ' add ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);
        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType);
        Result := Result + nulls;
        Result := Result + ';';
      end
      else if cmd = 'drop' then
      begin
        Result := '-- alter  table ' + tableName + ' drop column ' +
          GetQuotName(dbF.Name) + ';';
      end;
      Exit;
    end;


    if EngineType = 'HIVE' then
    begin
      if cmd = 'alter' then
      begin                        
        S := ctF.GetFieldTypeDesc(True, EngineType);
        if ctF.DefaultValue <> '' then
        begin
          if (G_HiveVersion >= 3) then //hive2不支持缺省值
            S := S + ctF.GetFieldDefaultValDesc(EngineType);
        end;
        nulls := ctF.GetNullableStr(EngineType);
        S := S + nulls;
        T := ctF.GetFieldComments;
        if T <> '' then
          S := S + ' comment ''' + ReplaceSingleQuotmark(T) + '''';

        Result := 'alter  table ' + tableName + ' change ' + GetQuotName(ctF.Name)+ ' '
            + GetQuotName(ctF.Name)+ ' ' + S + ';';
      end
      else if cmd = 'add' then
      begin
        S := ctF.GetFieldTypeDesc(True, EngineType);
        if ctF.DefaultValue <> '' then
        begin
          if (G_HiveVersion >= 3) then //hive2不支持缺省值
            S := S + ctF.GetFieldDefaultValDesc(EngineType);
        end;
        nulls := ctF.GetNullableStr(EngineType);
        S := S + nulls;
        T := ctF.GetFieldComments;
        if T <> '' then
          S := S + ' comment ''' + ReplaceSingleQuotmark(T) + '''';

        Result := 'alter  table ' + tableName + ' add columns(' + GetQuotName(ctF.Name)
          + ' ' + S+');';
      end
      else if cmd = 'drop' then
      begin
        Result := '-- alter  table ' + tableName + ' drop column ' +
          GetQuotName(dbF.Name) + ';';
      end;
      Exit;
    end;

    //if EngineType='STD' then
    begin
      if cmd = 'alter' then
      begin
        Result := 'alter  table ' + tableName + ' alter column ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);

        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType)
        else if dbF.DefaultValue <> '' then
          Result := Result + ' default null';

        if nulls <> '' then
          Result := Result + nulls
        else if not dbF.Nullable then
          Result := Result + ' null';
        Result := Result + ';';
      end
      else if cmd = 'add' then
      begin
        Result := 'alter  table ' + tableName + ' add column ' + GetQuotName(ctF.Name)
          + ' ' + ctF.GetFieldTypeDesc(True, EngineType);
        if ctF.DefaultValue <> '' then
          Result := Result + ctF.GetFieldDefaultValDesc(EngineType);
        Result := Result + nulls;
        Result := Result + ';';
      end
      else if cmd = 'drop' then
      begin
        Result := '-- alter  table ' + tableName + ' drop column ' +
          GetQuotName(dbF.Name) + ';';
      end;
      Exit;
    end;
  end;

  function GetAlterTableColActStr(cmd: string; tab: TCtMetaTable;
    ctF, dbF: TCtMetaField): string;
  begin
    Result := GetAlterTableColActStrEx(cmd, tab, ctF, dbF);
    if Assigned(GProc_OnEzdmlGenAlterFieldEvent) then
      Result := GProc_OnEzdmlGenAlterFieldEvent(cmd, tab, ctF, dbF,
        Result, EngineType, '');
  end;

  function GetCtfIndexType(tab: TCtMetaTable; ctF: TCtMetaField): TCtFieldIndexType;
  begin
    if ctF.IndexType <> cfitNone then
      Result := ctF.IndexType
    else if (ctF.KeyFieldType = cfktRid) and NeedGenFKIndexesSQL(tab) then
    begin
      Result := cfitNormal;
    end
    else
      Result := cfitNone;
  end;

  function IsSameIndexFields(if1, if2: string): boolean;
  begin
    if UpperCase(if1) = UpperCase(if2) then
      Result := True
    else
      Result := False;
  end;
    
  function GenIndexSql(idxName, tbName: string; fd: TCtMetaField; bUniq: Boolean): string;
  begin
    if bUniq then
    begin
      if EngineType='HIVE' then //hive不支持唯一索引，只有普通索引
      begin
        Result := 'create index ' + GetQuotName('IDU_' + idxName) +
          ' on table ' + GetQuotTbName(tbName) +
          '(' + GetQuotName(fd.Name) + GetIndexPrefixInfo(fd) + ')'#13#10 +
          ' as ''org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler'' with deferred rebuild;';
      end
      else
      begin
        Result := 'create unique index ' + GetQuotName('IDU_' + idxName) +
          ' on ' + GetQuotTbName(tbName) +
          '(' + GetQuotName(fd.Name) + GetIndexPrefixInfo(fd) + ');';
      end;
    end
    else
    begin
      if EngineType='HIVE' then //hive普通索引
      begin
        Result := 'create index ' + GetQuotName('IDX_' + idxName) +
          ' on table ' + GetQuotTbName(tbName) +
          '(' + GetQuotName(fd.Name) + GetIndexPrefixInfo(fd) + ')'#13#10 +
          ' as ''org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler'' with deferred rebuild;';
      end
      else
      begin
        Result := 'create index ' + GetQuotName('IDX_' + idxName) +
          ' on ' + GetQuotTbName(tbName) + '(' +
          GetQuotName(fd.Name) + GetIndexPrefixInfo(fd) + ');';
      end;
    end;

  end;
var
  J, K, L: integer;
  strtmp: string; //临时变量
  strSQL: string; //临时SQL
  ResTbSQL: TStringList; //生成表的sql语句
  ResFKSQL: TStringList; //创建外键的SQL
  dmlDBTbObj: TCtMetaTable;
  dmlLsTbObj: TCtMetaTable;
  ctF, dbF: TCtMetaField;
  T, dbu, sTpn1, sTpn2, sFPN: string;
  bFieldFound, bDiff: boolean;
begin
  Result := '';
  if not (obj is TCtMetaTable) then
    Exit;
  VModelTb := nil;
  if TCtMetaTable(obj).IsText then
  begin
    if TCtMetaTable(obj).IsSqlText then
      if sqlType <> 1 then
        Result := TCtMetaTable(obj).Memo;
    Exit;
  end;
  if not TCtMetaTable(obj).IsTable then
    Exit;

  if not (obj_db is TCtMetaTable) then
  begin
    //改在生成SQL的同时生成
    //判断有无sequences，无则创建
    {if EngineType = 'ORACLE' then
      strSQL := #13#10'create sequence ' + GetQuotName('SEQ_' + obj.Name) + '; '
    else}
    strSql := '';

    case sqlType of
      1:
        Result := TCtMetaTable(obj).GenSqlEx(True, False, EngineType, Self) + strSql;
      2:
        Result := TCtMetaTable(obj).GenSqlEx(False, True, EngineType, Self);
      else
        Result := TCtMetaTable(obj).GenSqlEx(True, False, EngineType, Self) + #13#10 +
          TCtMetaTable(obj).GenSqlEx(False, True, EngineType, Self) + strSql;
    end;

    if Assigned(GProc_OnEzdmlGenDbSqlEvent) then
      Result := GProc_OnEzdmlGenDbSqlEvent(TCtMetaTable(obj), nil,
        Result, EngineType, '');
    Exit;
  end;

  ResTbSQL := TStringList.Create;
  ResFKSQL := TStringList.Create;

  dmlLsTbObj := TCtMetaTable(obj);
  dmlDBTbObj := TCtMetaTable(obj_db);
  VModelTb := dmlLsTbObj;

  dbu := '';

  if G_GenSqlSketchMode then //粗略近似模式，只检查逻辑类型
  begin

  end
  else if dmlLsTbObj.GetTableComments <> dmlDBTbObj.GetTableComments then
  begin
    if (EngineType = 'ORACLE') or (EngineType = 'POSTGRESQL') then
    begin
      ResTbSQL.Add('comment on table '
        + GetQuotTbName(dmlLsTbObj.RealTableName) + ' is ''' +
        ReplaceSingleQuotmark(dmlLsTbObj.GetTableComments) + ''';');
    end
    else if EngineType = 'SQLSERVER' then
    begin
      if dmlDBTbObj.GetTableComments <> '' then
      begin
        if dmlLsTbObj.GetTableComments <> '' then
          ResTbSQL.Add('EXEC sp_updateextendedproperty ''MS_Description'', ''' +
            ReplaceSingleQuotmark(dmlLsTbObj.GetTableComments) +
            ''', ''user'', ' + DbSchema + ', ''table'', '
            + GetQuotName(dmlLsTbObj.RealTableName) + ', NULL, NULL;')
        else
          ResTbSQL.Add('EXEC sp_dropextendedproperty ''MS_Description'', ''user'', ' +
            DbSchema + ', ''table'', '
            + GetQuotName(dmlLsTbObj.RealTableName) + ', NULL, NULL;');
      end
      else
        ResTbSQL.Add('EXEC sp_addextendedproperty ''MS_Description'', ''' +
          ReplaceSingleQuotmark(dmlLsTbObj.GetTableComments) +
          ''', ''user'', ' + DbSchema + ', ''table'', '
          + GetQuotName(dmlLsTbObj.RealTableName) + ', NULL, NULL;');
    end
    else if EngineType = 'MYSQL' then
    begin
      ResTbSQL.Add('alter table '
        + GetQuotTbName(dmlLsTbObj.RealTableName) + ' comment ''' +
        ReplaceSingleQuotmark(dmlLsTbObj.GetTableComments) + ''';');
    end          
    else if EngineType = 'HIVE' then
    begin
      ResTbSQL.Add('alter table '
        + GetQuotTbName(dmlLsTbObj.RealTableName) + ' set tblproperties(''comment'' = ''' +
        ReplaceSingleQuotmark(dmlLsTbObj.GetTableComments) + ''');');
    end
    else if EngineType = 'SQLITE' then
    begin
      //SQLITE不支持注释比对 
      ResTbSQL.Add('-- skip comments-check in SQLITE');
    end;
  end;

  //遍历字段
  strSQL := '';
  for k := 0 to dmlLsTbObj.MetaFields.Count - 1 do
  begin
    ctF := dmlLsTbObj.MetaFields[k];
    if not ctF.IsPhysicalField then
      Continue;

    bFieldFound := False;
    for L := 0 to dmlDBTbObj.MetaFields.Count - 1 do
    begin
      dbF := dmlDBTbObj.MetaFields[L];
      if not dbF.IsPhysicalField then
        Continue;
      if AnsiSameText(dbF.Name, ctF.Name) then
      begin
        bFieldFound := True;
        sTpn1 := ctF.DataTypeName;
        sTpn2 := dbF.DataTypeName;
        try
          if (ctF.DataType <> cfdtUnknow) and (ctF.DataType <> cfdtOther) then
            ctF.DataTypeName := '';
          if (dbF.DataType <> cfdtUnknow) and (dbF.DataType <> cfdtOther) then
            dbF.DataTypeName := '';
          bDiff := IsDiffField(dbF, ctF);
        finally
          ctF.DataTypeName := sTpn1;
          dbF.DataTypeName := sTpn2;
        end;

        if bDiff {and not (IsIntKeyField(dbF) and IsIntKeyField(ctF))} then
        begin
          //数据库字段与设计字段完全不同，需要备份旧字段并创建新字段（HIVE除外）
          if G_BackupBeforeAlterColumn and (EngineType <> 'HIVE') then
          begin
            ResTbSQL.Add('');
            ResTbSQL.Add('-- Modify from ' + dmlLsTbObj.RealTableName + '.' +
              dbF.Name + ' ' + dbF.GetFieldTypeDesc(True, EngineType));
            strtmp := GetQuotName(GetFieldBK(dmlDBTbObj, dbF.Name));
            //获得可用备份字段名
            ResTbSQL.Add('-- SQL for ' + dmlLsTbObj.RealTableName + '.' + dbF.Name);
            if EngineType = 'SQLSERVER' then
              strSQL := 'exec   sp_rename ''' +IfElse(FDbSchema='','dbo',FDbSchema) +'.'+ dmlLsTbObj.RealTableName +
                '.' + dbF.Name + ''', ''' + strtmp + ''', ''COLUMN'';'
            else if EngineType = 'MYSQL' then
              strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + ' change ' +
                GetQuotName(dbF.Name) + ' ' + strtmp + ' ' +
                dbF.GetFieldTypeDesc(True, EngineType) + ';'
            else
              strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) +
                ' rename column ' +
                GetQuotName(dbF.Name) + ' TO ' + strtmp + ';';
            ResTbSQL.Add(strSQL);                  
            strSQL := GetAlterTableColActStr('add', dmlLsTbObj, ctF, ctF);
            ResTbSQL.Add(strSQL);
            dbF.Memo := '';
            //重建字段会导致注释丢失，这时应重新生成注释

            //复制数据
            strSQL := 'update ' + GetQuotTbName(dmlLsTbObj.RealTableName) + ' set ' +
              GetQuotName(ctF.Name) + ' = ' + strtmp + ';';
            ResTbSQL.Add(strSQL);
            strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) +
              ' drop column ' + strtmp + ';';
            ResTbSQL.Add(strSQL);
            ResTbSQL.Add('');
          end
          else
          begin
            ResTbSQL.Add('-- Modify from ' + dmlLsTbObj.RealTableName + '.' +
              dbF.Name + ' ' + dbF.GetFieldTypeDesc(True, EngineType));
            strSQL := GetAlterTableColActStr('alter', dmlLsTbObj, ctF, dbF);
            ResTbSQL.Add(strSQL);
          end;

          //字段说明
          if not MaybeSameStr(ctF.GetFieldComments, dbF.GetFieldComments) then
          begin
            if (EngineType = 'ORACLE') or (EngineType = 'POSTGRESQL') then
            begin
              strSQL := 'comment on column ' + GetQuotTbName(dmlLsTbObj.RealTableName) + '.' +
                GetQuotName(ctF.Name) + ' is ''' +
                ReplaceSingleQuotmark(ctF.GetFieldComments) + ''';';
              ResTbSQL.Add(strSQL);
            end
            else if EngineType = 'SQLSERVER' then
            begin
              if dbF.GetFieldComments <> '' then
                ResTbSQL.Add('EXEC sp_updateextendedproperty ''MS_Description'', ''' +
                  ReplaceSingleQuotmark(ctF.GetFieldComments) +
                  ''', ''user'', ' + DbSchema + ', ''table'', '
                  + GetQuotName(dmlLsTbObj.RealTableName) + ', ''column'', ' + ctF.Name + ';')
              else
                ResTbSQL.Add('EXEC sp_addextendedproperty ''MS_Description'', ''' +
                  ReplaceSingleQuotmark(ctF.GetFieldComments) +
                  ''', ''user'', ' + DbSchema + ', ''table'', '
                  + GetQuotName(dmlLsTbObj.RealTableName) + ', ''column'', ' + ctF.Name + ';');
            end;
          end;

          //主键
          T := GetIdxName(dmlLsTbObj.RealTableName, ctF.Name);
          //if Pos(dmlLsTbObj.Name, T) = 0 then
          //T := dmlLsTbObj.Name + '_' + T;
          if (EngineType = 'HIVE') and (G_HiveVersion < 3) then
          begin  //hive2不支持主外键
          end
          else
          begin
            if ctF.KeyFieldType = cfktId then
              if not ObjectExists(dbu, 'PK_' + T) then
              begin
                if UpperCase(dmlLsTbObj.GetPrimaryKeyNames) <> UpperCase(ctf.Name) then
                  strSQL := '-- warning: skip primary key: ' + ctf.Name
                else
                  strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
                    '       add constraint ' + GetQuotName('PK_' + T) +
                    ' primary key (' + GetQuotName(ctF.Name) + ');';
                if EngineType <> 'SQLITE' then
                ;
              end;
            //外键
            if ((ctF.KeyFieldType = cfktRid) or (ctF.KeyFieldType = cfktId)) and
              (ctF.RelateTable <> '')
              and (ctF.RelateField <> '')  and (Pos('{Link:', ctF.RelateField)=0)
              and G_CreateForeignkeys then
              if not ObjectExists(dbu, 'FK_' + T) then
              begin
                strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
                  '       add constraint ' + GetQuotName('FK_' + T) +
                  ' foreign key (' + GetQuotName(ctF.Name) + ')' + #13#10 +
                  '       references ' + GetQuotName(ctF.RelateTable) +
                  '(' + GetQuotName(ctF.RelateField) + ');';
                ResFKSQL.Add(strSQL);
              end;
          end;
          //索引
          if (ctF.KeyFieldType <> cfktId) then
            if ctF.IndexType = cfitUnique then
            begin
              if not ObjectExists(dbu, 'IDU_' + T) then
              begin
                strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, True);
                ResTbSQL.Add(strSQL);
              end;
            end
            else if ctF.IndexType = cfitNormal then
            begin
              if not ObjectExists(dbu, 'IDX_' + T) then
              begin         
                strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, False);
                ResTbSQL.Add(strSQL);
              end;
            end
            else if (ctF.KeyFieldType = cfktRid) and NeedGenFKIndexesSQL(dmlLsTbObj) then
            begin
              if not ObjectExists(dbu, 'IDX_' + T) then
              begin
                strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, False);
                ResTbSQL.Add(strSQL);
              end;
            end;
          //检查约束    
          if Trim(ctF.DBCheck) <> '' then
            if not ObjectExists(dbu, 'CHK_' + T) then
            begin
              strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
                '       add constraint ' + GetQuotName('CHK_' + T) +
                ' check (' + ctF.DBCheck + ');';
              ResTbSQL.Add(strSQL);
            end;

          ResTbSQL.Add('');
        end
        else if G_GenSqlSketchMode then //粗略近似模式，只检查逻辑类型
        begin

        end
        else
        begin
          //数据库字段与设计字段基本相同，需要检查缺省值、注释和索引约束
          bDiff := (TrimQuot(ctF.GetFieldDefaultValDesc(EngineType)) <>
            TrimQuot(dbF.GetFieldDefaultValDesc(EngineType)));
          if bDiff then
          if (EngineType = 'HIVE') and (G_HiveVersion < 3) then
            bDiff := False;  //hive2不支持缺省值

          if bDiff and (EngineType = 'SQLSERVER') then
          begin
            strSQL := '-- default value for ' + dmlLsTbObj.RealTableName +
              '.' + GetQuotName(ctF.Name)+ #13#10;
            if dbF.Param['SQLSERVER_DF_CONSTRAINT_NAME'] <> '' then
            begin
              strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) +
                ' drop constraint ' +
                dbF.Param['SQLSERVER_DF_CONSTRAINT_NAME'] + ';'#13#10;
            end;
            if Trim(ctF.DefaultValue) <> DEF_VAL_auto_increment then
              strSQL := strSQL + 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) +
                ' add constraint DF_' +
                GetIdxName(dmlLsTbObj.RealTableName, ctF.Name) + ' ' +
                ctF.GetFieldDefaultValDesc(EngineType) + ' for ' +
                GetQuotName(ctF.Name) + ';';
            ResTbSQL.Add(strSQL);
            bDiff := False;
          end;
          if not bDiff and (ctF.Nullable <> dbF.Nullable) then
            if (EngineType<>'HIVE') or (G_HiveVersion>=3) then
              bDiff := True;        
          if not bDiff and (EngineType<>'HIVE') then //HIVE字段的注释与其它属性一起修改
            if not MaybeSameStr(dbF.GetFieldComments, ctF.GetFieldComments) then
              bDiff := True;
          if bDiff then
          begin
            strSQL := GetAlterTableColActStr('alter', dmlLsTbObj, ctF, dbF);
            ResTbSQL.Add(strSQL);
          end;
          //字段说明
          if not MaybeSameStr(dbF.GetFieldComments, ctF.GetFieldComments) then
          begin
            if (EngineType = 'ORACLE') or (EngineType = 'POSTGRESQL') then
            begin
              strSQL := 'comment on column ' + GetQuotTbName(dmlLsTbObj.RealTableName) + '.' +
                GetQuotName(ctF.Name) + ' is ''' +
                ReplaceSingleQuotmark(ctF.GetFieldComments) + ''';';
              ResTbSQL.Add(strSQL);
            end
            else if EngineType = 'SQLSERVER' then
            begin
              if dbF.GetFieldComments <> '' then
              begin
                if ctF.GetFieldComments <> '' then
                  ResTbSQL.Add('EXEC sp_updateextendedproperty ''MS_Description'', ''' +
                    ReplaceSingleQuotmark(ctF.GetFieldComments) +
                    ''', ''user'', ' + DbSchema + ', ''table'', '
                    + GetQuotName(dmlLsTbObj.RealTableName) + ', ''column'', ' + ctF.Name + ';')
                else
                  ResTbSQL.Add(
                    'EXEC sp_dropextendedproperty ''MS_Description'', ''user'', ' +
                    DbSchema + ', ''table'', ' + GetQuotName(dmlLsTbObj.RealTableName) +
                    ', ''column'', ' + ctF.Name + ';');
              end
              else
                ResTbSQL.Add('EXEC sp_addextendedproperty ''MS_Description'', ''' +
                  ReplaceSingleQuotmark(ctF.GetFieldComments) +
                  ''', ''user'', ' + DbSchema + ', ''table'', '
                  + GetQuotName(dmlLsTbObj.RealTableName) + ', ''column'', ' + ctF.Name + ';');
            end
            else if EngineType = 'SQLITE' then
            begin
              //SQLITE不支持注释比对
            end       
            else if EngineType = 'HIVE' then
            begin
              //HIVE统一在修改字段时设置属性
            end
            else
            begin
              ResTbSQL.Add('-- Modify comment of ' + dmlLsTbObj.RealTableName + '.' + dbF.Name);
              strSQL := GetAlterTableColActStr('alter', dmlLsTbObj, ctF, dbF);
              ResTbSQL.Add(strSQL);
            end;
          end;

          T := GetIdxName(dmlLsTbObj.RealTableName, ctF.Name);
          //T := ctF.Name;
          //if Pos(dmlLsTbObj.Name, T) = 0 then
          //T := dmlLsTbObj.Name + '_' + T;
          //主键
          if (ctF.KeyFieldType = cfktId) and (dbF.KeyFieldType <> cfktId) then
            if (EngineType<>'HIVE') or (G_HiveVersion>=3) then //hive2不支持主外键
              if not ObjectExists(dbu, 'PK_' + T) then
              begin
                if UpperCase(dmlLsTbObj.GetPrimaryKeyNames) <> UpperCase(ctF.Name) then
                  strSQL := '-- warning: skip primary key: ' + ctf.Name
                else
                  strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
                    '       add constraint ' + GetQuotName('PK_' + T) + ' primary key (' +
                    GetQuotName(ctF.Name) + ');';
                ResTbSQL.Add(strSQL);
                if (dbF.KeyFieldType <> cfktRid) and (ctF.RelateTable <> '') and (Pos('{Link:', ctF.RelateField)=0) and
                  (ctF.RelateField <> '') and G_CreateForeignkeys then
                  if not ObjectExists(dbu, 'FK_' + T) then
                  begin
                    strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
                      '       add constraint ' + GetQuotName('FK_' + T) +
                      ' foreign key (' +
                      GetQuotName(ctF.Name) + ')' + #13#10 +
                      '       references ' + GetQuotName(ctF.RelateTable) +
                      '(' + GetQuotName(ctF.RelateField) + ');';
                    ResFKSQL.Add(strsql);
                  end;
              end;
          //外键
          if (ctF.KeyFieldType = cfktRid) and (dbF.KeyFieldType <> cfktRid) and
            (ctF.RelateTable <> '')  and (Pos('{Link:', ctF.RelateField)=0)
            and (ctF.RelateField <> '') and G_CreateForeignkeys then 
            if (EngineType<>'HIVE') or (G_HiveVersion>=3) then //hive2不支持主外键
              if not ObjectExists(dbu, 'FK_' + T) then
              begin
                strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
                  '       add constraint ' + GetQuotName('FK_' + T) + ' foreign key (' +
                  GetQuotName(ctF.Name) + ')' + #13#10 +
                  '       references ' + GetQuotName(ctF.RelateTable) +
                  '(' + GetQuotName(ctF.RelateField) + ');';
                ResFKSQL.Add(strsql);
              end;
          //索引
          if (ctF.KeyFieldType <> cfktId) and (dbF.IndexType <>
            GetCtfIndexType(dmlLsTbObj, ctF)) and (EngineType<>'HIVE') then //hive暂时不检查索引，因为暂时不知道如何判断是否已经存在
            if ctF.IndexType = cfitUnique then
            begin
              if not ObjectExists(dbu, 'IDU_' + T) then
              begin
                strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, True);
                ResTbSQL.Add(strSQL);
              end;
            end
            else if ctF.IndexType = cfitNormal then
            begin
              if not ObjectExists(dbu, 'IDX_' + T) then
              begin
                strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, False);
                ResTbSQL.Add(strSQL);
              end;
            end
            else if (ctF.KeyFieldType = cfktRid) and NeedGenFKIndexesSQL(dmlLsTbObj) then
            begin
              if not ObjectExists(dbu, 'IDX_' + T) then
              begin
                strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, False);
                ResTbSQL.Add(strSQL);
              end;
            end; 
          //检查约束
          if Trim(ctF.DBCheck) <> Trim(dbF.DBCheck) then
            if not ObjectExists(dbu, 'CHK_' + T) then
            begin
              strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
                '       add constraint ' + GetQuotName('CHK_' + T) +
                ' check (' + ctF.DBCheck + ');';
              ResTbSQL.Add(strSQL);
            end;
        end;
        //找到后退出循环
        break;
      end;
    end;

    //数据库中没找到该字段
    if not bFieldFound then
    begin
      //添加字段
      strSQL := GetAlterTableColActStr('add', dmlLsTbObj, ctF, ctF);
      ResTbSQL.Add(strSQL);
      //字段说明
      if ctF.GetFieldComments <> '' then
      begin
        if (EngineType = 'ORACLE') or (EngineType = 'POSTGRESQL') then
        begin
          strSQL := 'comment on column ' + GetQuotTbName(dmlLsTbObj.RealTableName) + '.' +
            GetQuotName(ctF.Name) + ' is ''' +
            ReplaceSingleQuotmark(ctF.GetFieldComments) + ''';';
          ResTbSQL.Add(strSQL);
        end
        else if EngineType = 'SQLSERVER' then
        begin
          ResTbSQL.Add('EXEC sp_addextendedproperty ''MS_Description'', ''' +
            ReplaceSingleQuotmark(ctF.GetFieldComments) + ''', ''user'', ' +
            DbSchema + ', ''table'', '
            + GetQuotName(dmlLsTbObj.RealTableName) + ', ''column'', ' + ctF.Name + ';');
        end;
      end;

      T := GetIdxName(dmlLsTbObj.RealTableName, ctF.Name);
      //主键
      if ctF.KeyFieldType = cfktId then   
        if (EngineType<>'HIVE') or (G_HiveVersion>=3) then //hive2不支持主外键
        begin
          if UpperCase(dmlLsTbObj.GetPrimaryKeyNames) <> UpperCase(ctf.Name) then
            strSQL := '-- warning: skip primary key: ' + ctf.Name
          else
            strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
              '       add constraint ' + GetQuotName('PK_' + T) + ' primary key (' +
              GetQuotName(ctF.Name) + ');';
          ResTbSQL.Add(strSQL);
        end;
      //外键
      if ((ctF.KeyFieldType = cfktRid) or (ctF.KeyFieldType = cfktId)) and
        (ctF.RelateTable <> '') and (Pos('{Link:', ctF.RelateField)=0)
        and (ctF.RelateField <> '') and G_CreateForeignkeys then  
        if (EngineType<>'HIVE') or (G_HiveVersion>=3) then //hive2不支持主外键
        begin
          strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
            '       add constraint ' + GetQuotName('FK_' + T) + ' foreign key (' +
            GetQuotName(ctF.Name) + ')' + #13#10 +
            '       references ' + GetQuotName(ctF.RelateTable) + '(' +
            GetQuotName(ctF.RelateField) + ');';
          ResFKSQL.Add(strsql);
        end;
      //索引
      if (ctF.KeyFieldType <> cfktId) then
        if ctF.IndexType = cfitUnique then
        begin             
          strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, True);
          ResTbSQL.Add(strSQL);
        end
        else if ctF.IndexType = cfitNormal then
        begin
          strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, False);
          ResTbSQL.Add(strSQL);
        end
        else if (ctF.KeyFieldType = cfktRid) and NeedGenFKIndexesSQL(dmlLsTbObj) then
        begin
          strSQL := GenIndexSql(T, dmlLsTbObj.RealTableName, ctF, False);
          ResTbSQL.Add(strSQL);
        end;
         
      //检查约束
      if Trim(ctF.DBCheck) <> '' then
        if not ObjectExists(dbu, 'CHK_' + T) then
        begin
          strSQL := 'alter  table ' + GetQuotTbName(dmlLsTbObj.RealTableName) + #13#10 +
            '       add constraint ' + GetQuotName('CHK_' + T) +
            ' check (' + ctF.DBCheck + ');';
          ResTbSQL.Add(strSQL);
        end;
    end;

  end;

  //数据库中有但模型中没有的字段
  for L := 0 to dmlDBTbObj.MetaFields.Count - 1 do
  begin
    dbF := dmlDBTbObj.MetaFields[L];
    if not dbF.IsPhysicalField then
      Continue;
    bFieldFound := False;
    for k := 0 to dmlLsTbObj.MetaFields.Count - 1 do
    begin
      ctF := dmlLsTbObj.MetaFields[k];
      if ctF.DataLevel = ctdlDeleted then
        Continue;
      if AnsiSameText(dbF.Name, ctF.Name) then
      begin
        bFieldFound := True;
        Break;
      end;
    end;

    if not bFieldFound then
    begin
      strSQL := GetAlterTableColActStr('drop', dmlLsTbObj, dbF, dbF);
      ResTbSQL.Add(strSQL);
    end;
  end;

  //遍历复合索引
  for k := 0 to dmlLsTbObj.MetaFields.Count - 1 do
  begin
    ctF := dmlLsTbObj.MetaFields[k];
    if not ctF.HasValidComplexIndex then
      Continue;

    //查找类型和索引字段一样的复合索引
    bFieldFound := False;
    for L := 0 to dmlDBTbObj.MetaFields.Count - 1 do
    begin
      dbF := dmlDBTbObj.MetaFields[L];
      if not dbF.HasValidComplexIndex then
        Continue;

      if ctf.IndexType = dbF.IndexType then
        if IsSameIndexFields(dbF.IndexFields, ctF.IndexFields) then
        begin
          bFieldFound := True;
          Break;
        end;
    end;
    //没找到就创建
    if not bFieldFound then
    begin
      T := GetIdxName(dmlLsTbObj.RealTableName, ctF.Name);
      if Pos('(', ctF.IndexFields) > 0 then
        sFPN := ctF.IndexFields
      else
      begin
        sFPN := '';
        with TStringList.Create do
          try
            CommaText := ctF.IndexFields;
            for J := 0 to Count - 1 do
            begin
              if sFPN <> '' then
                sFPN := sFPN + ',';
              sFPN := sFPN + GetQuotName(Strings[J]);
            end;
          finally
            Free;
          end;
      end;
      if sFPN = '' then
        Continue;
      if ctF.IndexType = cfitUnique then
      begin
        if ObjectExists(dbu, 'IDU_' + T) then
        begin
          strSQL := 'drop index ' + GetQuotName('IDU_' + T) + ';';
          ResTbSQL.Add(strSQL);
        end;
        strSQL := 'create unique index ' + GetQuotName('IDU_' + T) +
          ' on ' + GetQuotTbName(dmlLsTbObj.RealTableName) +
          '(' + sFPN + ');';
        ResTbSQL.Add(strSQL);
      end
      else if ctF.IndexType = cfitNormal then
      begin
        if ObjectExists(dbu, 'IDX_' + T) then
        begin
          strSQL := 'drop index ' + GetQuotName('IDX_' + T) + ';';
          ResTbSQL.Add(strSQL);
        end;
        strSQL := 'create index ' + GetQuotName('IDX_' + T) + ' on ' +
          GetQuotTbName(dmlLsTbObj.RealTableName) + '(' +
          sFPN + ');';
        ResTbSQL.Add(strSQL);
      end;
    end;
  end;

  //数据库中有但模型中没有的复合索引
  for L := 0 to dmlDBTbObj.MetaFields.Count - 1 do
  begin
    dbF := dmlDBTbObj.MetaFields[L];
    if not dbF.HasValidComplexIndex then
      Continue;
    bFieldFound := False;
    for k := 0 to dmlLsTbObj.MetaFields.Count - 1 do
    begin
      ctF := dmlLsTbObj.MetaFields[k];
      if not ctF.HasValidComplexIndex then
        Continue;
      if UpperCase(ctF.Name) = UpperCase(dbF.Name) then
      begin
        bFieldFound := True;
        Break;
      end;
      if IsSameIndexFields(dbF.IndexFields, ctF.IndexFields) then
      begin
        bFieldFound := True;
        Break;
      end;
    end;

    if not bFieldFound then
    begin
      T := ExtractCompStr(dbF.Memo, '[DB_INDEX_NAME:', ']');
      if T = '' then
      begin
        T := GetIdxName(dmlLsTbObj.RealTableName, dbF.Name);
        if dbF.IndexType = cfitUnique then
          T := 'IDU_' + T
        else if dbF.IndexType = cfitNormal then
          T := 'IDX_' + T;
      end;
      if ObjectExists(dbu, T) then
      begin
        strSQL := '-- drop index ' + GetQuotName(T) + ';';
        ResTbSQL.Add(strSQL);
      end
      else if ObjectExists(dbu, dbF.Name) then
      begin
        strSQL := '-- drop index ' + dbF.Name + ';';
        ResTbSQL.Add(strSQL);
      end;
    end;
  end;

  //判断有无sequences，无则创建
  strtmp := dmlLsTbObj.RealTableName;
  if EngineType = 'ORACLE' then
    if G_CreateSeqForOracle and dmlLsTbObj.IsSeqNeeded then
      if not ObjectExists(dbu, 'SEQ_' + strtmp) then
      begin
        strSQL := 'create sequence ' + GetQuotName('SEQ_' + strtmp) + '; ';
        ResTbSQL.Add(strSQL);
      end;

  //额外的SQL
  if dmlLsTbObj.ExtraSQL <> '' then
    ResTbSQL.Add(dmlLsTbObj.ExtraSQL);

  case sqlType of
    0:
    begin
      ResTbSQL.AddStrings(ResFKSQL);
      Result := ResTbSQL.Text;
    end;
    1:
      Result := ResTbSQL.Text;
    2:
      Result := ResFKSQL.Text;
    else
      ResTbSQL.AddStrings(ResFKSQL);
      Result := ResTbSQL.Text;
  end;

  ResTbSQL.Free;
  ResFKSQL.Free;

  if Assigned(GProc_OnEzdmlGenDbSqlEvent) then
    Result := GProc_OnEzdmlGenDbSqlEvent(dmlLsTbObj, dmlDBTbObj, Result, EngineType, '');
end;

function TCtMetaDatabase.GetConnected: boolean;
begin
  Result := FConnected;
end;

function TCtMetaDatabase.GetDbNames: string;
begin
  Result := '';
end;

function TCtMetaDatabase.GetDbObjs(ADbUser: string): TStrings;
begin
  Result := nil;
end;

function TCtMetaDatabase.GetOrigEngineType: string;
begin
  Result := FEngineType;
end;

function TCtMetaDatabase.GetDbSchema: string;
begin
  Result := FDbSchema;
end;

function TCtMetaDatabase.GetDbUsers: string;
begin
  Result := '';
end;

function TCtMetaDatabase.GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject;
begin
  Result := nil;
end;

function TCtMetaDatabase.OnGenTableSql(tb: TCtMetaTable; bCreateTb,
  bCreateConstrains: boolean; defRes, dbType, options: string): string;
begin
  Result := defRes;
end;

function TCtMetaDatabase.IsDiffField(Fd1, Fd2: TCtMetaField): boolean;

  function IsBigField(f: TCtMetaField): boolean;
  begin
    Result := False;
    if f.DataType = cfdtBlob then
      Result := True
    else if f.DataType = cfdtString then
    begin
      if FEngineType = 'SQLSERVER' then
      begin
        if f.DataLength > 8000 then
          Result := True;
      end
      else if FEngineType = 'ORACLE' then
      begin
        if f.DataLength > 4000 then
          Result := True;
      end
      else if FEngineType = 'MYSQL' then
      begin
        if f.DataLength > 65532 then
          Result := True;
      end           
      else if FEngineType = 'HIVE' then
      begin
        if f.DataLength > 65535 then
          Result := True;
      end
      else if f.DataLength > 8000 then
        Result := True;
    end;
  end;

begin
  Result := False;
  if (Fd1 = nil) or (Fd2 = nil) then
    Exit;
  if G_GenSqlSketchMode or (EngineType='HIVE') then //粗略近似模式，只检查逻辑类型
  begin
    if Fd1.DataType = Fd2.DataType then //相同的逻辑类型，直接忽略
      Exit;
    //粗略近似模式下，小整数、枚举、布尔型可以看成是一样的
    if Fd1.DataType in [cfdtInteger, cfdtBool, cfdtEnum] then
      if Fd2.DataType in [cfdtInteger, cfdtBool, cfdtEnum] then
        Exit;
  end;
  if UpperCase(Fd1.GetFieldTypeDesc(True, EngineType)) =
    UpperCase(Fd2.GetFieldTypeDesc(True, EngineType)) then
    Exit;
  if IsBigField(Fd1) and IsBigField(Fd2) then
    Exit;
  Result := True;
end;

function TCtMetaDatabase.ObjectExists(ADbUser, AObjName: string): boolean;
begin
  Result := False;
end;

function TCtMetaDatabase.OpenTable(ASql, op: string): TDataSet;
begin
  Result := nil;
end;

procedure TCtMetaDatabase.SetConnected(const Value: boolean);
begin
  FConnected := Value;
end;

procedure TCtMetaDatabase.SetDbSchema(const Value: string);
begin
  FDbSchema := Value;
end;

function TCtMetaDatabase.ShowDBConfig(AHandle: THandle): boolean;
begin
  Result := False;
end;

function TCtMetaDatabase.GetIdentStr: string;
var
  S, T: string;
  N: Integer;
  WS: WideString;
begin    
  Result := LowerCase(EngineType);
  if EngineType <> OrigEngineType then
    Result := Result + '/' + LowerCase(OrigEngineType);
  Result := Result+':';
  if User <> '' then
    Result := Result + User+'@';

  T := DataBase; 
  T := StringReplace(T, ':', '_', [rfReplaceAll]);
  T := StringReplace(T, '/', '_', [rfReplaceAll]);
  T := StringReplace(T, '\', '_', [rfReplaceAll]);  
  T := StringReplace(T, '@', '_', [rfReplaceAll]);    
  T := StringReplace(T, '#', '_', [rfReplaceAll]);
  T := StringReplace(T, '__', '_', [rfReplaceAll]);
  S := T;
  if Length(S) > 24 then
  begin
    N := 21;
    WS := S;

    while Length(S) > 21 do
    begin
      S := Copy(WS, 1, N);
      Dec(N);
    end;

    T := S+IntToHex(Crc(T), 4);
  end;
           
  Result := Result + T;
end;

end.
