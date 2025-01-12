{
  ****************************************************************

  DMLObjs
  模型图界面对象

  By HUZZZ (huz0123@21cn.com)
  Date: 2005-10-01
  Guangzhou China

  模型图界面渲染相关的数据对象定义，主要包括：
    画图控制类TDMLDrawer、基础类TDMLObj、实体类（表、文字、流程步骤）、字段类
    连线类、对象列表类

               
  注：此单元为旧版代码，不再维护
  *****************************************************************
}
//unit DMLObjs;

{$IFDEF FPC}
{$MODE Delphi}
{$WARN 5057 off : Local variable "$1" does not seem to be initialized}
{$WARN 4105 off : Implicit string type conversion with potential data loss from "$1" to "$2"}
{$WARN 5091 off : }
{$WARN 4104 off : Implicit string type conversion from "$1" to "$2"}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  IniFiles, WindowFuncs;

const
  DML_FONTSC = 6.6;
  DML_FONT_EXWIDTH = 8;
type
  TDMLObj = class;
  TDMLObjList = class;

  TDMLFieldType = (dmlfUnknow, dmlfPK, dmlfFK, dmlfString, dmlfInteger, dmlfEnum,
    dmlfFloat, dmlfDate, dmlfBool, dmlfBlob, dmlfObject, dmlfCalculate, dmlfList,
    dmlfFunction, dmlfEvent, dmlfOther);

  TDMLPoint = record
    X, Y: Double;
  end;

  TDMLDrawer = class
  public
    Canvas: TCanvas;
    Scale: Double;
    CenterX: Double;
    CenterY: Double;
    BoundLeft: Double;
    BoundTop: Double;
    BoundHeight: Double;
    BoundWidth: Double;
    ControlWidth: Integer;
    ControlHeight: Integer;
    DrawerWidth: Integer;
    DrawerHeight: Integer;
    TempBitmap: TBitmap;
    Images: TImageList;

    WorkAreaColor: TColor;
    SkipDrawSelected: Boolean;
    SelectedColor: TColor;
    ShowFieldIcon: Boolean;
    ShowFieldType: Boolean;
    ShowPhyFieldName: Integer;
    HideSelectedField: Boolean;

    HideBoundRect: Boolean;

    IndependPosForOverviewMode: Boolean;

    CenterRngW0: Integer;
    CenterRngH0: Integer;
    CenterRngS0: Integer;
    CenterRngC0: Integer;
    CenterRngW: Integer;
    CenterRngH: Integer;
    CenterRngS: Integer;
    CenterRatioI0: Int64;
    CenterRatioI1: Int64;
    CenterRatioI2: Int64;
    CenterRatioI: Integer;
    CenterRatioX: Integer;
    CenterRatioY: Integer;
    CenterRatioW: Integer;
    CenterRatioH: Integer;

    DefaultObjectColor: TColor;
    DefaultTitleColor: TColor;
    DefaultPKColor: TColor;
    DefaultFKColor: TColor;
    DefaultBorderColor: TColor;
    DefaultLineColor: TColor;
    DefaultGroupEdgeColor: TColor;
    DatabaseEngine: string;

    GenFKIndexesSQL: Boolean;

    DrawSelectedOnly: Boolean;


    FLinkOptimizeLevel: Integer;
    FSuggestLinkOptimizeLevel: Integer;
    FIsHugeMode: Boolean;
    FFastDrawMode: Boolean;
    FCurSelectedLinkCount: Integer;
    FCurSelectedEntityCount: Integer;

    GetX: function(X: Double): Integer of object;
    GetY: function(Y: Double): Integer of object;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure SetDefaultProps(AObj: TDMLObj);

    function GetD(const D: Double): Double;
    function GetFontH: Integer;
    function RectInRange(L, T, W, H: Double): Boolean;
    function ImageIndexOf(const FT: TDMLFieldType): Integer;

    procedure Save(Ini: TCustomIniFile; Sec: string); virtual;
    procedure Load(Ini: TCustomIniFile; Sec: string); virtual;

    procedure SaveToStream(AStream: TStream); virtual;
    procedure LoadFromStream(AStream: TStream); virtual;

    procedure ResetConfig;
    function GetConfigStr: string;
    procedure SetConfigStr(Des: string);

    procedure DrawLine(X1, Y1, X2, Y2: Integer);
    procedure DrawRect(X1, Y1, X2, Y2: Integer);
    procedure DrawRectLine(X1, Y1, X2, Y2: Integer);
  end;

  { TDMLObj }

  TDMLObj = class
  private
    function GetHeight: Double;
    function GetWidth: Double;
    procedure SetHeight(AValue: Double);
    procedure SetWidth(AValue: Double);
  protected
    FOwnerList: TDMLObjList;

    FObjType: string;
    FID: Integer;
    FName: string;

    FoLeft: Double;
    FoTop: Double;
    FbLeft: Double;
    FbTop: Double;
    FoHeight: Double;
    FoWidth: Double;
    FbHeight: Double;
    FbWidth: Double;

    FReadOnly: Boolean;
    FVisible: Boolean;
    FSelected: Boolean;
    FAutoSize: Boolean;

    FBorderWidth: Integer;
    FFillStyle: TBrushStyle;
    FBorderColor: TColor;
    FFillColor: TColor;
    FBorderStyle: TPenStyle;
    FViewBorderStyle: TPenStyle;
    FTextColor: TColor;
    FComment: string;
    RowHeight: Integer;
    FVer: string;

    FUserObject: TObject;
    FUserPars: string;
    FUserVal: Integer;

    FDrawOnBackground: Integer;
    FDrawSelectGrips: Boolean;
    FBriefMode: Boolean;
  protected
    procedure SetID(const Value: Integer); virtual;
    procedure SetBriefMode(const Value: Boolean); virtual;
    function GetLeft: Double; virtual;
    function GetTop: Double; virtual;
    procedure SetLeft(const Value: Double); virtual;
    procedure SetTop(const Value: Double); virtual;
    procedure SetSelected(const Value: Boolean); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(obj: TDMLObj); virtual;
    procedure CheckResize; virtual;
    procedure PrepareDelete(objs: TDMLObjList); virtual;

    procedure Save(Ini: TCustomIniFile; Sec: string); virtual;
    procedure Load(Ini: TCustomIniFile; Sec: string); virtual;

    procedure SaveToStream(AStream: TStream); virtual;
    procedure LoadFromStream(AStream: TStream); virtual;

    procedure PaintTo(const ADrawer: TDMLDrawer); virtual;
    procedure DrawSelectedGrips(const ADrawer: TDMLDrawer); virtual;

    procedure SetClickPoint(X, Y: Double; ADrawer: TDMLDrawer); virtual;
    function PointInObj(X, Y: Double): Boolean; virtual;
    function RectTouchObj(X, Y, W, H: Double): Boolean; virtual;

    property ID: Integer read FID write SetID;
    property Name: string read FName write FName;
    property Comment: string read FComment write FComment;

    property Left: Double read GetLeft write SetLeft;
    property Top: Double read GetTop write SetTop;
    property Width: Double read GetWidth write SetWidth;
    property Height: Double read GetHeight write SetHeight;
    property OWidth: Double read FoWidth write FoWidth;
    property OHeight: Double read FoHeight write FoHeight; 
    property BWidth: Double read FbWidth write FbWidth;
    property BHeight: Double read FbHeight write FbHeight;

    property OLeft: Double read FoLeft write FoLeft;
    property OTop: Double read FoTop write FoTop;
    property BLeft: Double read FbLeft write FbLeft;
    property BTop: Double read FbTop write FbTop;

    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property Visible: Boolean read FVisible write FVisible;
    property Selected: Boolean read FSelected write SetSelected;
    property AutoSize: Boolean read FAutoSize write FAutoSize;

    property BorderStyle: TPenStyle read FBorderStyle write FBorderStyle;
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BorderWidth: Integer read FBorderWidth write FBorderWidth;
    property FillStyle: TBrushStyle read FFillStyle write FFillStyle;
    property FillColor: TColor read FFillColor write FFillColor;
    property TextColor: TColor read FTextColor write FTextColor;

    property UserObject: TObject read FUserObject write FUserObject;
    property UserPars: string read FUserPars write FUserPars;
    property UserVal: Integer read FUserVal write FUserVal;

    property DrawOnBackground: Integer read FDrawOnBackground;
    property BriefMode: Boolean read FBriefMode write SetBriefMode;
  end;
  TDMLObjClass = class of TDMLObj;

  { TDMLEntityObj }

  TDMLEntityObj = class(TDMLObj)
  private
  protected
    FLinks: TList;
    procedure SetBriefMode(const Value: Boolean); override;
  public
    constructor Create; override;
    destructor Destroy; override;
                              
    function IsResizable: Boolean; virtual;
    procedure CheckResize; override;
    procedure CheckPositions; virtual;
    procedure CheckSizeForName(AName: string);
    procedure CheckMoved(DX, DY: Double); virtual;
    function HasLinked(obj: TDMLObj): Boolean; virtual;
    procedure PrepareDelete(objs: TDMLObjList); override;
    procedure RemoveLinks(objs: TDMLObjList); virtual;

    procedure FindSpaceForLinkObjs(objs: TDMLObjList); virtual;

    property Links: TList read FLinks;

  end;

  TDMLLinkType = (dmllLine, dmllFKNormal, dmllFKUnique, dmllDirect, dmllOppDirect);

  TDMLLinkObj = class(TDMLObj)
  private
    FObj1: TDMLEntityObj;
    FObj2: TDMLEntityObj;
    FObj1_Name: string;
    FObj2_Name: string;
    FP1: TDMLPoint;
    FP2: TDMLPoint;
    FP3: TDMLPoint;
    FP4: TDMLPoint;
    FLinkType: TDMLLinkType;
    FClickPos: Integer;
    FMoving: Boolean;
    FObj2Field: string;
    FObj1Field: string;
    procedure SetObj1(const Value: TDMLEntityObj);
    procedure SetObj2(const Value: TDMLEntityObj);
    procedure CalculateArr(const FH: boolean; const Fo1, Fo2: TDMLPoint; var Points: array of TDMLPoint);
  protected
    procedure SetID(const Value: Integer); override;
    procedure SetBriefMode(const Value: Boolean); override;
    procedure SetSelected(const Value: Boolean); override;
  public
    FPMod_OP1: Boolean;
    FPMod_OP2: Boolean;
    FPMod_CP: Boolean;
    FHookP1: TDMLPoint;
    FHookP2: TDMLPoint;
    FHorz1: Boolean;
    FHorz2: Boolean;
    FBFHookP1: TDMLPoint;
    FBFHookP2: TDMLPoint;
    FPosInfoLoaded: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure CheckResize; override;   
    procedure CheckLoadedPos;
    procedure CheckPosition; virtual;
    procedure CheckPositionEx(bRecheck, bCanNoun: Boolean; iOptimize: Integer); virtual;
    procedure CheckLineAlign; virtual;
    procedure CheckMoved(Obj: TDMLEntityObj; DX, DY: Double); virtual;
    procedure ResetPosition;
    procedure ResetPositionEx;
    function IsDefPosChanged: Boolean;

    function GetDescText: string;

    procedure SetClickPoint(X, Y: Double; ADrawer: TDMLDrawer); override;
    procedure DoMove(DX, DY: Double); virtual;
    function PointInObj(X, Y: Double): Boolean; override;
    function RectTouchObj(X, Y, W, H: Double): Boolean; override;

    procedure PaintTo(const ADrawer: TDMLDrawer); override;
    procedure DrawSelectedGrips(const ADrawer: TDMLDrawer); override;

    procedure Save(Ini: TCustomIniFile; Sec: string); override;
    procedure Load(Ini: TCustomIniFile; Sec: string); override;
    procedure FindLinkObjs(Objs: TDMLObjList); virtual;

    procedure SaveToStream(AStream: TStream); override;
    procedure LoadFromStream(AStream: TStream); override;

    procedure SetRelateFieldSelected(bSel: Boolean);
    procedure ResetRelateTbFieldSelected;

    property Obj1: TDMLEntityObj read FObj1 write SetObj1;
    property Obj2: TDMLEntityObj read FObj2 write SetObj2;
    property Obj1Field: string read FObj1Field write FObj1Field;
    property Obj2Field: string read FObj2Field write FObj2Field;
    property LinkType: TDMLLinkType read FLinkType write FLinkType;
    property ClickPos: Integer read FClickPos write FClickPos;
    property P1: TDMLPoint read FP1 write FP1;
    property P2: TDMLPoint read FP2 write FP2;
    property P3: TDMLPoint read FP3 write FP3;
    property P4: TDMLPoint read FP4 write FP4;
  end;

  TDMLTextObj = class(TDMLEntityObj)
  protected
    FDrawComment: string;
    procedure SetID(const Value: Integer); override;
  public
    constructor Create; override;
    procedure CheckResize; override;
    procedure PaintTo(const ADrawer: TDMLDrawer); override;
    procedure Load(Ini: TCustomIniFile; Sec: string); override;
    procedure LoadFromStream(AStream: TStream); override;
  end;

  TDMLFlowStepObj = class(TDMLEntityObj)
  protected
    procedure SetID(const Value: Integer); override;
  public
    constructor Create; override;
  end;

  { TDMLGroupBoxObj }

  TDMLGroupBoxObj = class(TDMLTextObj)
  protected
    procedure SetID(const Value: Integer); override;
  public
    constructor Create; override;  
    procedure CheckResize; override;   
    function PointInObj(X, Y: Double): Boolean; override;
    procedure PaintTo(const ADrawer: TDMLDrawer); override;
  end;

  { TDMLField }

  TDMLField = class
  public
    Name: string;
    PhyName: string;
    FieldType: TDMLFieldType;
    FieldTypeName: string;
    FieldLen: Integer;
    FieldScal: Integer;
    FieldTypeEx: string;
    Comment: string;
    Nullable: Boolean;
    Editor: string;
    ExtraKeyType: Integer;
    IndexType: Integer;
    ExOptions: string;
    LinkSelectType: Integer;
  published
  public
    constructor Create;
    procedure Assign(f: TDMLField);

    procedure Save(Ini: TCustomIniFile; Sec: string); virtual;
    procedure Load(Ini: TCustomIniFile; Sec: string); virtual;

    procedure SaveToStream(AStream: TStream); virtual;
    procedure LoadFromStream(AStream: TStream); virtual;

    function IsPK: Boolean;
    function IsFK: Boolean;
    function IsLink: Boolean;
    function IsUnique: Boolean;
    function Get_PhyName: string;
    function Get_FieldTypeStr(bPhy: Boolean = True): string;
    function NeedCreate: Boolean;

  end;

  { TDMLTableObj }

  TDMLTableObj = class(TDMLEntityObj)
  private
    FFields: TList;
    FPKColor: TColor;
    FFKColor: TColor;
    FTbnameColor: TColor;
    FSeqName: string;
    FIsView: Boolean;
    FSql: string;

    FPhyTbName: string;
    FMaxFieldLen: Integer;
    FSelectedFieldIndex: Integer;

    FMaxDrawFieldCount: Integer;

    function GetField(Index: Integer): TDMLField;
    function GetFieldCount: Integer;
    function GenFKSQL: TStringList;
    function GetDescribe: string;
    procedure SetDescribe(const Value: string);
    procedure SetMaxDrawFieldCount(const Value: Integer);
    procedure SetSelectedFieldIndex(AValue: Integer);
  protected
    procedure SetID(const Value: Integer); override;
    procedure AssignFields(fs: TList); virtual;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Assign(obj: TDMLObj); override;
    procedure CheckResize; override;
    procedure RemoveFKLinks(objs: TDMLObjList); virtual;
    procedure FindFKLinks(objs: TDMLObjList); virtual;

    procedure Save(Ini: TCustomIniFile; Sec: string); override;
    procedure Load(Ini: TCustomIniFile; Sec: string); override;

    procedure SaveToStream(AStream: TStream); override;
    procedure LoadFromStream(AStream: TStream); override;

    procedure SetClickPoint(X, Y: Double; ADrawer: TDMLDrawer); override;
    function PointInObj(X, Y: Double): Boolean; override;

    procedure PaintTo(const ADrawer: TDMLDrawer); override;
    procedure DrawSelectedGrips(const ADrawer: TDMLDrawer); override;
    function Get_PhyTbName: string;
    function GenSql: string; virtual;
    function GenTBSQL: TStringList;

    function GetSelectedText(const ADrawer: TDMLDrawer): string;

    procedure ClearLinkSelection;

    function NewField: TDMLField;
    procedure DeleteField(Index: Integer);
    procedure ClearFields;
    function FindDMLField(AFieldName: string): TDMLField;

    property FieldCount: Integer read GetFieldCount;
    property Field[Index: Integer]: TDMLField read GetField;
    property Fields: TList read FFields;
    property MaxDrawFieldCount: Integer read FMaxDrawFieldCount write SetMaxDrawFieldCount;

    property SelectedFieldIndex: Integer read FSelectedFieldIndex write SetSelectedFieldIndex;

    property TbnameColor: TColor read FTbnameColor write FTbnameColor;
    property FKColor: TColor read FFKColor write FFKColor;
    property SeqName: string read FSeqName write FSeqName;
    property IsView: Boolean read FIsView write FIsView;
    property Sql: string read FSql write FSql;
    property TBSQL: TStringList read GenTBSQL;
    property FKSQL: TStringList read GenFKSQL;
    property PhyTbName: string read FPhyTbName write FPhyTbName;

    property Describe: string read GetDescribe write SetDescribe;
  end;

  TDMLObjProgressEvent = procedure(Sender: TObject; const Prompt: string;
    Cur, All: Integer; var bContinue: Boolean) of object;

  { TDMLObjList }

  TDMLObjList = class(TList)
  private
    FFreeItemOnDelete: Boolean;
    FObjidSeq: Integer;
    FOnObjProgress: TDMLObjProgressEvent;
    FFindNewSpace: Boolean;
    FVer: string;
    FBriefMode: Boolean;
    FLastCheckLinkOptiTick: Int64;
    FSelection: TList;
    function GetSelectedNames: string;
    procedure SetBriefMode(const Value: Boolean);
    function GetItems(Index: Integer): TDMLObj;
    procedure SetItems(Index: Integer; const Value: TDMLObj);
    procedure SetSelectedNames(AValue: string);
  protected
    FDMLDrawer: TDMLDrawer;
    FLinksUpdateCounter: Integer;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    procedure DoObjRelease(Obj: TDMLObj); virtual;

  public
    FAutoCheckedLinks: TList;

    constructor Create; virtual;
    destructor Destroy; override;

    procedure Save(Ini: TCustomIniFile; Sec: string); virtual;
    procedure Load(Ini: TCustomIniFile; Sec: string); virtual;

    procedure SaveToStream(AStream: TStream); virtual;
    procedure LoadFromStream(AStream: TStream); virtual;

    procedure PaintAll; virtual;
    procedure FindSpace(obj: TDMLObj);
    procedure FindSpaceEx(obj: TDMLObj; FromX, FromY, DY: Double);

    procedure ClearSelection;
    procedure ClearFieldSelection;
    procedure CheckSelection;
    procedure SelectAll(bEntitiesOnly: Boolean);
    function FindItemAt(X, Y: Double): Integer;
    function FindEntityAt(X, Y: Double): Integer;
    function FindEntityInRect(X1, Y1, X2, Y2: Double): Integer;
    procedure SelectItemAt(X, Y: Double; bCtrl: Boolean);
    procedure RectSelect(X1, Y1, X2, Y2: Double; bCtrl: Boolean);
    procedure SelectEntityByDir(dir: Integer; cx, cy: double);
    procedure MoveSelected(DX, DY: Double);
    procedure DeleteSelected;
    function SelectedObj: TDMLObj;
    function SelectedCount: Integer;
    function GetSelectedItem(AIndex:Integer): TDMLObj;
    function GetSelectionRect(var X1, Y1, X2, Y2: Double): Boolean;
    function GetSelectedFitRect(var X1, Y1, X2, Y2: Double): Boolean;
    procedure CheckSelectedLinks;
    function GetAllObjsRect(var X1, Y1, X2, Y2: Double): Boolean;
    function GetVisObjsRect(var X1, Y1, X2, Y2: Double): Boolean;
    procedure ReArrange;
    procedure ReArrangeEx(initDX, initDY: Double);
    procedure ReArrangeV2;
    procedure CheckLinkLines;
    procedure CheckLinkOptiTick(bInit: Boolean = False);
    procedure CheckSelLinksOfSelectedEntities;

    procedure BeginUpdateLinks;
    procedure EndUpdateLinks;
    procedure StopUpdateLinks;

    procedure Clear; override;
    function GetNextObjID: Integer;
    function CreateDMLObj(AClass: string): TDMLObj;

    procedure FindAllFKLinks; virtual;

    function EnitiesCount: Integer;
    function LinksCount: Integer;

    function ItemByName(AName: string): TDMLObj;

    property Items[Index: Integer]: TDMLObj read GetItems write SetItems; default;
    property FreeItemOnDelete: Boolean read FFreeItemOnDelete write FFreeItemOnDelete;
    property DMLDrawer: TDMLDrawer read FDMLDrawer write FDMLDrawer;

    property OnObjProgress: TDMLObjProgressEvent read FOnObjProgress write FOnObjProgress;
    property FindNewSpace: Boolean read FFindNewSpace write FFindNewSpace;
    property BriefMode: Boolean read FBriefMode write SetBriefMode;
    property SelectedNames: string read GetSelectedNames write SetSelectedNames;
  end;

  TDMLObjReg = record
    ObjType: string;
    ObjClass: TDMLObjClass;
  end;
  PDMLObjReg = ^TDMLObjReg;

procedure AddDMLObjReg(ObjType: string; ObjClass: TDMLObjClass);
function GetDMLObjReg(ObjType: string): PDMLObjReg;

function RectCrossOrTouchRect(L1, T1, W1, H1, L2, T2, W2, H2: Double): Boolean;
function RectCrossOrTouchRect2(L1, T1, R1, B1, L2, T2, R2, B2: Double): Boolean;
function Rect2InRect1(L1, T1, R1, B1, L2, T2, R2, B2: Double): Boolean;

procedure IniWriteStrings(Ini: TCustomIniFile; const Section, Ident, AStrs: string);
procedure IniReadStrings(Ini: TCustomIniFile; const Section, Ident: string;
  var AStrs: string);

procedure Stream_WriteString(AStream: TStream; const Value: string);
procedure Stream_WriteInteger(AStream: TStream; const Value: Integer);
procedure Stream_WriteFloat(AStream: TStream; const Value: Double);
procedure Stream_WriteBool(AStream: TStream; const Value: Boolean);
procedure Stream_WriteDMLPoint(AStream: TStream; var Value: TDMLPoint);

procedure Stream_ReadString(AStream: TStream; var Value: string);
procedure Stream_ReadStringL(AStream: TStream; Len: Integer; var Value: string);
procedure Stream_ReadInteger(AStream: TStream; var Value: Integer);
procedure Stream_ReadColor(AStream: TStream; var Value: TColor);
procedure Stream_ReadDMLPoint(AStream: TStream; var Value: TDMLPoint);
procedure Stream_ReadFloat(AStream: TStream; var Value: Double);
procedure Stream_ReadBool(AStream: TStream; var Value: Boolean);

function Get_DML_PhyFieldTypeNames(dbe: string; AFieldType: TDMLFieldType): string;

const
  DML_FieldTypeNames: array[TDMLFieldType] of string = (
    '未知', '主键', '外键', '字符串', '整数', '小整数', '浮点数', '日期',
    '真假', '二进制数据', '对象', '计算字段', '列表', '函数', '事件', '其它');
  DML_PhyFieldTypeNames_Ora: array[TDMLFieldType] of string = (
    '[UNKNOWN]', 'NUMBER', 'NUMBER', 'VARCHAR2', 'NUMBER', 'NUMBER(2)', 'NUMBER', 'DATE',
    'NUMBER(1)', 'BLOB', 'OBJECT', 'CALC', 'LIST', 'FUNCTION', 'EVENT', 'OTHER');
  DML_PhyFieldTypeNames_Mysql: array[TDMLFieldType] of string = (
    '[UNKNOWN]', 'INTEGER', 'INTEGER', 'VARCHAR', 'INTEGER', 'TINYINT', 'DOUBLE', 'DATETIME',
    'BIT', 'BINARY', 'OBJECT', 'CALC', 'LIST', 'FUNCTION', 'EVENT', 'OTHER');
  DML_PhyFieldTypeNames_Sqlsvr: array[TDMLFieldType] of string = (
    '[UNKNOWN]', 'INT', 'INT', 'VARCHAR', 'INT', 'TINYINT', 'NUMERIC', 'DATETIME',
    'BIT', 'BINARY', 'OBJECT', 'CALC', 'LIST', 'FUNCTION', 'EVENT', 'OTHER');
  DML_PhyFieldTypeNames_Std: array[TDMLFieldType] of string = (
    '[UNKNOWN]', 'INTEGER', 'INTEGER', 'VARCHAR', 'INTEGER', 'TINYINT', 'NUMERIC', 'DATETIME',
    'BIT', 'BINARY', 'OBJECT', 'CALC', 'LIST', 'FUNCTION', 'EVENT', 'OTHER');
  DML_LogicTypeNames: array[TDMLFieldType] of string = (
    'UNKNOWN', 'PK', 'FK', 'String', 'Integer', 'Enum', 'Float', 'Date', 'Bool',
    'Blob', 'Object', 'Calculate', 'List', 'Function', 'Event', 'Other');

  DEF_DMLLINK_PICK_DIST = 5;

var
  DMLObjRegs: array of TDMLObjReg;
  CurrentDmlDbEngine: string;
  DML_CustFieldTypeDefs: array of string;
  Proc_CheckStringMaxLen: function(DbType, custTpName: string; var res: string; len: Integer): Boolean;
  Proc_CheckCustDataTypeReplaces: function(Str: string): string;
  FieldNameMaxDrawSize: Integer;
  FieldTypeMaxDrawSize: Integer;
  TableFieldMaxDrawCount: Integer;

implementation

uses Types, dmlstrs, Math, ezdmlstrs;


function Get_DML_PhyFieldTypeNames(dbe: string; AFieldType: TDMLFieldType): string;
begin
  if dbe = 'ORACLE' then
    Result := DML_PhyFieldTypeNames_Ora[AFieldType]
  else if dbe = 'MYSQL' then
    Result := DML_PhyFieldTypeNames_Mysql[AFieldType]
  else if dbe = 'SQLSERVER' then
    Result := DML_PhyFieldTypeNames_Sqlsvr[AFieldType]
  else
    Result := DML_PhyFieldTypeNames_Std[AFieldType];
end;

function GetDMLFieldPhyTypeName(ADbType: string; AFieldType: TDMLFieldType; ADataLen: Integer): string;
var
  I, po: Integer;
  S, V: string;
begin
  Result := DML_LogicTypeNames[AFieldType];
  for I := 0 to High(DML_CustFieldTypeDefs) do
  begin
    po := Pos(':', DML_CustFieldTypeDefs[I]);
    S := Copy(DML_CustFieldTypeDefs[I], 1, po - 1);
    V := Copy(DML_CustFieldTypeDefs[I], po + 1, Length(DML_CustFieldTypeDefs[I]));
    if UpperCase(Result) = UpperCase(S) then
    begin
      Result := V;
      if ADataLen > 0 then
      begin
        po := Pos('(', Result);
        if po > 0 then
          Result := Copy(Result, 1, po - 1);
      end;
      Exit;
    end;
  end;
  Result := Get_DML_PhyFieldTypeNames(ADbType, AFieldType);
end;

function DmlObjListSortLinkCountCompare(Item1, Item2: Pointer): Integer;
begin
  if TDMLEntityObj(Item2).Links.Count > TDMLEntityObj(Item1).Links.Count then
    Result := 1
  else if TDMLEntityObj(Item2).Links.Count < TDMLEntityObj(Item1).Links.Count then
    Result := -1
  else
    Result := 0;
end;

procedure IniWriteStrings(Ini: TCustomIniFile; const Section, Ident, AStrs: string);
var
  I: Integer;
  VStrs: TStrings;
begin
  VStrs := TStringList.Create;
  try
    VStrs.Text := AStrs;
    Ini.WriteInteger(Section, Ident + ' LineCount', VStrs.Count);
    for I := 0 to VStrs.Count - 1 do
      Ini.WriteString(Section, Ident + ' Line' + IntToStr(I), VStrs.Strings[I]);
  finally
    VStrs.Free;
  end;
end;

procedure IniReadStrings(Ini: TCustomIniFile; const Section, Ident: string;
  var AStrs: string);
var
  I, C: Integer;
  VStrs: TStrings;
begin
  VStrs := TStringList.Create;
  try
    C := Ini.ReadInteger(Section, Ident + ' LineCount', 0);
    for I := 0 to C - 1 do
      VStrs.Add(Ini.ReadString(Section, Ident + ' Line' + IntToStr(I), ''));
    AStrs := VStrs.Text;
  finally
    VStrs.Free;
  end;
end;

procedure Stream_WriteString(AStream: TStream; const Value: string);
var
  L: Integer;
begin
  L := Length(Value);
  AStream.WriteBuffer(L, SizeOf(Integer));
  AStream.WriteBuffer(Pointer(Value)^, L);
end;

procedure Stream_WriteInteger(AStream: TStream; const Value: Integer);
begin
  AStream.WriteBuffer(Value, SizeOf(Integer));
end;

procedure Stream_WriteFloat(AStream: TStream; const Value: Double);
begin
  AStream.WriteBuffer(Value, SizeOf(Double));
end;

procedure Stream_WriteBool(AStream: TStream; const Value: Boolean);
var
  I: Byte;
begin
  if Value then
    I := 1
  else
    I := 0;
  AStream.WriteBuffer(I, SizeOf(Byte));
end;

procedure Stream_WriteDMLPoint(AStream: TStream; var Value: TDMLPoint);
var
  D: Double;
begin
  D := Value.X;
  AStream.WriteBuffer(D, SizeOf(Double));
  D := Value.Y;
  AStream.WriteBuffer(D, SizeOf(Double));
end;

procedure Stream_ReadString(AStream: TStream; var Value: string);
var
  L: Integer;
begin
  L := Length(Value);
  AStream.ReadBuffer(L, SizeOf(Integer));
  SetLength(Value, L);
  AStream.ReadBuffer(Pointer(Value)^, L);
end;

procedure Stream_ReadStringL(AStream: TStream; Len: Integer; var Value: string);
var
  L: Integer;
begin
  L := 0;
  AStream.ReadBuffer(L, SizeOf(Integer));
  if L <> Len then
    Value := ''
  else
  begin
    SetLength(Value, L);
    AStream.ReadBuffer(Pointer(Value)^, L);
  end;
end;

procedure Stream_ReadInteger(AStream: TStream; var Value: Integer);
begin
  AStream.ReadBuffer(Value, SizeOf(Integer));
end;

procedure Stream_ReadColor(AStream: TStream; var Value: TColor);
var
  I: Integer;
begin
  AStream.ReadBuffer(I, SizeOf(Integer));
  Value := TColor(I);
end;

procedure Stream_ReadDMLPoint(AStream: TStream; var Value: TDMLPoint);
var
  D: Double;
begin
  AStream.ReadBuffer(D, SizeOf(Double));
  Value.X := D;
  AStream.ReadBuffer(D, SizeOf(Double));
  Value.Y := D;
end;

procedure Stream_ReadFloat(AStream: TStream; var Value: Double);
begin
  AStream.ReadBuffer(Value, SizeOf(Double));
end;

procedure Stream_ReadBool(AStream: TStream; var Value: Boolean);
var
  I: Byte;
begin
  I := 0;
  AStream.ReadBuffer(I, SizeOf(Byte));
  if I = 1 then
    Value := True
  else
    Value := False;
end;

procedure AddDMLObjReg(ObjType: string; ObjClass: TDMLObjClass);
var
  L: Integer;
begin
  L := Length(DMLObjRegs);
  SetLength(DMLObjRegs, L + 1);
  DMLObjRegs[L].ObjType := ObjType;
  DMLObjRegs[L].ObjClass := ObjClass;
end;

function GetDMLObjReg(ObjType: string): PDMLObjReg;
var
  I: Integer;
begin
  if ObjType = '' then
    ObjType := 'TABLE';
  for I := 0 to High(DMLObjRegs) do
    if UpperCase(DMLObjRegs[I].ObjType) = UpperCase(ObjType) then
    begin
      Result := @DMLObjRegs[I];
      Exit;
    end;
  Result := nil;
end;

function RectCrossOrTouchRect(L1, T1, W1, H1, L2, T2, W2, H2: Double): Boolean;
begin
  if L1 > L2 + W2 then
    Result := False
  else if L1 + W1 < L2 then
    Result := False
  else if T1 + H1 < T2 then
    Result := False
  else if T1 > T2 + H2 then
    Result := False
  else
    Result := True;
end;

function RectCrossOrTouchRect2(L1, T1, R1, B1, L2, T2, R2, B2: Double): Boolean;
var
  T: Double;
begin
  if L1 > R1 then
  begin
    T := L1;
    L1 := R1;
    R1 := T;
  end;
  if T1 > B1 then
  begin
    T := T1;
    T1 := B1;
    B1 := T;
  end;
  if L2 > R2 then
  begin
    T := L2;
    L2 := R2;
    R2 := T;
  end;
  if T2 > B2 then
  begin
    T := T2;
    T2 := B2;
    B2 := T;
  end;
  Result := RectCrossOrTouchRect(L1, T1, R1 - L1, B1 - T1, L2, T2, R2 - L2, B2 - T2);
end;

function Rect2InRect1(L1, T1, R1, B1, L2, T2, R2, B2: Double): Boolean;
var
  T: Double;
begin
  if L1 > R1 then
  begin
    T := L1;
    L1 := R1;
    R1 := T;
  end;
  if T1 > B1 then
  begin
    T := T1;
    T1 := B1;
    B1 := T;
  end;
  if L2 > R2 then
  begin
    T := L2;
    L2 := R2;
    R2 := T;
  end;
  if T2 > B2 then
  begin
    T := T2;
    T2 := B2;
    B2 := T;
  end;
  if (L2 >= L1) and (T2 >= T1) and (R2 <= R1) and (B2 <= B1) then
    Result := True
  else
    Result := False;
end;

function P2P_Distance(Point1, Point2: TDMLPoint): Double;
var
  D1, D2: Double;
begin
  try
    D1 := Point1.X - Point2.X;
    D2 := Point1.Y - Point2.Y;

    Result := Sqrt(Sqr(D1) + Sqr(D2));
  except
    Result := 0;
  end;
end;

function PointOnLine(PointIn, PL1, PL2: TDMLPoint): Boolean;
var
  La, Lb, D1, D2, D3: Double;
  bVert: Boolean;
begin
  Result := False;
  if not RectCrossOrTouchRect2(PointIn.X - 1, PointIn.Y - 1, PointIn.X + 1, PointIn.Y + 1, PL1.X, PL1.Y, PL2.X, PL2.Y) then
    Exit;

  D1 := PL2.Y - PL1.Y;
  D2 := PL2.X - PL1.X;
  if (d1 = 0) and (d2 = 0) then
    Exit;
  bVert := Abs(D2) <= 0.01;
  if bVert = False then
  begin
    La := D1 / D2;
    Lb := PL1.Y - La * PL1.X;
    D3 := La * PointIn.X + Lb;
    if Abs(D3 - PointIn.Y) <= 0.01 then
      Result := True;
  end
  else if Abs(PL1.X - PointIn.X) <= 0.01 then
  begin
    if PL1.Y < PL2.Y then
    begin
      D1 := PL1.Y;
      D2 := PL2.Y;
    end
    else
    begin
      D1 := PL2.Y;
      D2 := PL1.Y;
    end;
    D3 := PointIn.Y;
    if (D3 >= D1 - 0.01) and (D3 <= D2 + 0.01) then
      Result := True;
  end;

end;

function P2L_NearestP(PointP, PointL1, PointL2: TDMLPoint): TDMLPoint;
var
  D1, D2, A, B: Double;
begin
  D1 := PointL2.X - PointL1.X;
  D2 := PointL2.Y - PointL1.Y;
  if Abs(D1) <= 0.001 then
  begin
    Result.X := PointL1.X;
    Result.Y := PointP.Y;
    Exit;
  end;

  A := D2 / D1;
  B := PointL1.Y - PointL1.X * A;

  Result.X := (PointP.Y * A + PointP.X - A * B) / (A * A + 1);
  Result.Y := A * Result.X + B;
end;

function P2L_Distance(PointP, PointL1, PointL2: TDMLPoint): Double;
var
  PV: TDMLPoint;
  D, E: Double;
begin
  PV := P2L_NearestP(PointP, PointL1, PointL2);
  if PointOnLine(PV, PointL1, PointL2) then
    Result := P2P_Distance(PointP, PV)
  else
  begin
    D := P2P_Distance(PointP, PointL1);
    E := P2P_Distance(PointP, PointL2);
    if D > E then
      Result := E
    else
      Result := D;
  end;
end;

{ TDMLGroupBoxObj }

procedure TDMLGroupBoxObj.SetID(const Value: Integer);
begin
  inherited SetID(Value);
  if FName = ClassName then
    FName := srGroup + IntToStr(FID);
end;

constructor TDMLGroupBoxObj.Create;
begin
  inherited Create;
  FBorderStyle := psDot;
  FFillColor := clWhite;
  FObjType := 'GROUP';
  FDrawOnBackground := 2;
end;

procedure TDMLGroupBoxObj.CheckResize;
var
  w, h: Double;
begin
  w := Width;
  h := Height;
  if Self.BriefMode then
  begin
    if w < 200 then
      w:= 200;
    if h < 150 then
      h := 150;
  end
  else
  begin
    if w < 400 then
      w:= 400;
    if h < 300 then
      h := 300;
  end;
  inherited CheckResize;
  if Width < w then
    Width := w;
  if Height < h then
    Height := h;
end;

function TDMLGroupBoxObj.PointInObj(X, Y: Double): Boolean;
begin
  Result := False;
  if (FillColor <>$ffffff) or ((GetKeyState(VK_SHIFT) and $80) <> 0) then
    Result:=inherited PointInObj(X, Y);
  if not Result then
    Result := RectCrossOrTouchRect2(Self.Left, Self.Top, Self.Left, Self.Top+Self.Height,
      X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST);
  if not Result then
    Result := RectCrossOrTouchRect2(Self.Left, Self.Top, Self.Left+Self.Width, Self.Top,
      X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST);
  if not Result then
    Result := RectCrossOrTouchRect2(Self.Left+Self.Width, Self.Top, Self.Left+Self.Width, Self.Top+Self.Height,
      X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST);
  if not Result then
    Result := RectCrossOrTouchRect2(Self.Left, Self.Top+Self.Height, Self.Left+Self.Width, Self.Top+Self.Height,
      X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST);
end;

procedure TDMLGroupBoxObj.PaintTo(const ADrawer: TDMLDrawer);
var
  bW: Boolean;
begin
  TextColor := ADrawer.DefaultTitleColor;
  bW := False;
  if FFillColor = $FFFFFF then
  begin
    FFillColor := ADrawer.WorkAreaColor;
    bW := True;
  end;
  inherited PaintTo(ADrawer);
  if bW then
    FFillColor := $FFFFFF;
end;

{ TDMLObjList }

procedure TDMLObjList.BeginUpdateLinks;
begin
  Inc(FLinksUpdateCounter);
end;

procedure TDMLObjList.CheckLinkLines;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I] is TDMLEntityObj then
      TDMLEntityObj(Items[I]).CheckMoved(0, 0);
end;

procedure TDMLObjList.CheckLinkOptiTick(bInit: Boolean);
var
  tk: Int64;
begin
  if bInit then
  begin
    FLastCheckLinkOptiTick := GetTickCount64;
  end
  else if FDMLDrawer.FLinkOptimizeLevel > 0 then
  begin
    tk := GetTickCount64;
    tk := Abs(tk - FLastCheckLinkOptiTick);
    if tk > 1500 then
    begin
      if FDMLDrawer.FSuggestLinkOptimizeLevel > 1 then
        FDMLDrawer.FSuggestLinkOptimizeLevel := 1
      else
        FDMLDrawer.FSuggestLinkOptimizeLevel := 0;
      FDMLDrawer.FLinkOptimizeLevel := 0;
    end
    else if tk > 600 then
    begin
      if FDMLDrawer.FSuggestLinkOptimizeLevel > 2 then
        FDMLDrawer.FSuggestLinkOptimizeLevel := 2
      else
        FDMLDrawer.FSuggestLinkOptimizeLevel := 1;
      FDMLDrawer.FLinkOptimizeLevel := 1;
    end
    else if tk > 200 then
    begin
      if FDMLDrawer.FSuggestLinkOptimizeLevel = 9 then
        FDMLDrawer.FSuggestLinkOptimizeLevel := 3
      else
        FDMLDrawer.FSuggestLinkOptimizeLevel := 2;
      FDMLDrawer.FLinkOptimizeLevel := 2;
    end;
  end;
end;

procedure TDMLObjList.CheckSelLinksOfSelectedEntities;
var
  I: Integer;
  ALnk: TDMLLinkObj;
begin
  for I := 0 to Count - 1 do
    if Items[I] is TDMLLinkObj then
    begin
      ALnk:= TDMLLinkObj(Items[I]);
      if ALnk.Selected then
      begin
        if not ALnk.Obj1.Selected then
          ALnk.Obj1.Selected := True;
        if not ALnk.Obj2.Selected then
          ALnk.Obj2.Selected := True;
      end
      else
      begin
        if ALnk.Obj1.Selected and ALnk.Obj2.Selected then
          ALnk.Selected := True;
      end;
    end;
end;

procedure TDMLObjList.CheckSelectedLinks;

  procedure CheckLinkPos(ALnk: TDMLLinkObj);
  begin
    if ALnk.UserVal = 1 then
    begin
      ALnk.UserVal := 2;
      ALnk.CheckPosition;
      CheckLinkOptiTick;
    end;
  end;
var
  I, J, oLV: Integer;
  ent: TDMLEntityObj;
  lnk: TDMLLinkObj;
begin
  oLV := Self.FDMLDrawer.FLinkOptimizeLevel;
  Self.FDMLDrawer.FLinkOptimizeLevel := 9;
  try
    CheckLinkOptiTick(True);
    for I := 0 to Count - 1 do
      Items[I].UserVal := 1;
    for I := 0 to Count - 1 do
      if Items[I].Selected then
      begin
        if Items[I] is TDMLLinkObj then
        begin
          CheckLinkPos(TDMLLinkObj(Items[I]));
        end
        else
        begin
          if Items[I] is TDMLEntityObj then
          begin
            ent := TDMLEntityObj(Items[I]);
            for J := 0 to ent.Links.Count - 1 do
              CheckLinkPos(TDMLLinkObj(ent.Links[J]));
          end;
        end;
      end;
    for I := 0 to FAutoCheckedLinks.Count - 1 do
    begin
      lnk := TDMLLinkObj(FAutoCheckedLinks[I]);
      if Self.IndexOf(lnk) >= 0 then
        CheckLinkPos(lnk);
    end;
  finally
    Self.FDMLDrawer.FLinkOptimizeLevel := oLV;
  end;
end;

procedure TDMLObjList.Clear;
begin
  FBriefMode := False;
  FDMLDrawer.FSuggestLinkOptimizeLevel := 9;
  FDMLDrawer.FLinkOptimizeLevel := 9;
  FDMLDrawer.FIsHugeMode := False;
  inherited;
end;

procedure TDMLObjList.ClearFieldSelection;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I] is TDMLTableObj then
    begin
      TDMLTableObj(Items[I]).SelectedFieldIndex := -1;
      TDMLTableObj(Items[I]).ClearLinkSelection;
    end;
end;

procedure TDMLObjList.ClearSelection;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].FSelected := False;
  ClearFieldSelection;
  FSelection.Clear;
  CheckSelection;
end;

constructor TDMLObjList.Create;
begin
  inherited Create;
  FFreeItemOnDelete := True;
  FFindNewSpace := True;
  FVer := 'DML10';
  FAutoCheckedLinks := TList.Create;
  FSelection:= TList.Create;
end;

function TDMLObjList.CreateDMLObj(AClass: string): TDMLObj;
var
  otr: PDMLObjReg;
begin
  Result := nil;
  otr := GetDMLObjReg(AClass);
  if not Assigned(otr) then
    Exit;
  Result := otr.ObjClass.Create;
  Add(Result);

  Result.ID := GetNextObjID;
  Result.Left := 10;
  Result.Top := 10;
  Result.BriefMode := Self.FBriefMode;
  if Assigned(DMLDrawer) then
    DMLDrawer.SetDefaultProps(Result);
  if (Result.DrawOnBackground=0) and FFindNewSpace then
    FindSpace(Result);
end;

procedure TDMLObjList.DeleteSelected;
var
  I: Integer;
  o: TDMLObj;
begin
  for I := Count - 1 downto 0 do
    if I < Count then
      if Items[I].Selected then
      begin
        o := Items[I];
        o.PrepareDelete(Self);
        Remove(o);
      end;
end;

destructor TDMLObjList.Destroy;
begin
  FAutoCheckedLinks.Free;
  FSelection.Free;
  inherited;
end;

procedure TDMLObjList.DoObjRelease(Obj: TDMLObj);
var
  I: Integer;
  bFr: Boolean;
begin
  I := IndexOf(Obj);
  if I >= 0 then
  begin
    bFr := FFreeItemOnDelete;
    FFreeItemOnDelete := False;
    try
      Items[I] := nil;
      Delete(I);
    finally
      FFreeItemOnDelete := bFr;
    end;
  end;
end;

procedure TDMLObjList.CheckSelection;
var
  I: Integer;
  obj: TDMLObj;
begin
  for I:= FSelection.Count - 1 downto 0 do
  begin
    obj := TDMLObj(FSelection[I]);
    if obj = nil then
      FSelection.Delete(I)
    else if Self.IndexOf(obj) < 0  then
      FSelection.Delete(I)
    else if not obj.Selected then
      FSelection.Delete(I);
  end;
  for I:=0 to Count - 1 do
    if Items[I].Selected then
      if FSelection.IndexOf(Items[I]) < 0 then
        FSelection.Add(Items[I]);
end;

procedure TDMLObjList.EndUpdateLinks;
  procedure CheckLinkPos(ALnk: TDMLLinkObj);
  begin
    if ALnk.UserVal = 1 then
    begin
      ALnk.UserVal := 2;
      if ALnk.FBriefMode then
        ALnk.FPosInfoLoaded := False;
      if ALnk.FPosInfoLoaded then
        ALnk.CheckLoadedPos
      else
        ALnk.CheckPosition;
      CheckLinkOptiTick;
    end;
  end;
var
  I, oLV: Integer;
begin
  Dec(FLinksUpdateCounter);
  if FLinksUpdateCounter = 0 then
  begin
    oLV := Self.FDMLDrawer.FLinkOptimizeLevel;
    Self.FDMLDrawer.FLinkOptimizeLevel := 9;
    try
      CheckLinkOptiTick(True);
      for I := 0 to Count - 1 do
        Items[I].UserVal := 1;
      for I := 0 to Count - 1 do
        if Items[I] is TDMLLinkObj then
          CheckLinkPos(TDMLLinkObj(Items[I]));

    finally
      Self.FDMLDrawer.FLinkOptimizeLevel := oLV;
    end;
  end;
end;

function TDMLObjList.EnitiesCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Items[I] is TDMLEntityObj then
      Inc(Result);
end;

procedure TDMLObjList.FindAllFKLinks;
var
  tbs: TStringList;

  procedure FindLinkForTb(tb1: TDMLTableObj);
  var
    I, K, C1, po: Integer;
    S, T, F: string;
    o: TDMLLinkObj;
    obj2: TDMLEntityObj;
    f1: TDMLField;
  begin

    C1 := tb1.FieldCount;
    for K := 0 to C1 - 1 do
    begin
      f1 := tb1.Field[K];
      if f1.IsFK then
      begin
        S := f1.FieldTypeEx;
        po := Pos('.', S);
        if po = 0 then
          Continue;
        T := UpperCase(Copy(S, 1, po - 1));
        F := Copy(S, po + 1, Length(S));
        I := tbs.IndexOf(T);
        if I >= 0 then
        begin
          obj2 := TDMLEntityObj(tbs.Objects[I]);
          if (obj2 <> tb1) and (obj2 is TDMLTableObj) then
          begin
            if not tb1.HasLinked(obj2) then
            begin
              if TDMLTableObj(obj2).FindDMLField(F) <> nil then
              begin
                o := TDMLLinkObj(Self.CreateDMLObj('LINK'));
                o.Obj1 := obj2;
                o.Obj2 := tb1;
                if f1.IsUnique then
                  o.LinkType := dmllFKUnique
                else
                  o.LinkType := dmllFKNormal;
                o.Comment := f1.Get_PhyName;
                o.FObj1Field := F;
                o.FObj2Field := f1.Get_PhyName;

              end;
            end;
          end;
        end;
      end;
    end;

    for K := 0 to C1 - 1 do
    begin
      f1 := tb1.Field[K];
      if f1.IsLink then
      begin
        S := f1.FieldTypeEx;
        po := Pos('.', S);
        if po = 0 then
          Continue;
        T := UpperCase(Copy(S, 1, po - 1));
        F := Copy(S, po + 1, Length(S));
        I := tbs.IndexOf(T);
        if I >= 0 then
        begin
          obj2 := TDMLEntityObj(tbs.Objects[I]);
          if (obj2 <> tb1) then
          begin
            if not tb1.HasLinked(obj2) then
            begin
              o := TDMLLinkObj(Self.CreateDMLObj('LINK'));
              o.Obj1 := obj2;
              o.Obj2 := tb1;
              if F = '{Link:Direct}' then
                o.LinkType := dmllDirect
              else if F = '{Link:OppDirect}' then
                o.LinkType := dmllOppDirect
              else
                o.LinkType := dmllLine;
              o.Comment := f1.Get_PhyName;
            end;
          end;
        end;
      end;
    end;

  end;
var
  I: Integer;
  obj: TDMLObj;
  S: string;
begin
  tbs := TStringList.Create;
  try
    for I := 0 to Count - 1 do
    begin
      obj := Items[I];
      if obj.Visible and (obj is TDMLEntityObj) then
      begin
        S := TDMLEntityObj(obj).Name;
        if obj is TDMLTableObj then
          if TDMLTableObj(obj).PhyTbName <> '' then
            S := TDMLTableObj(obj).PhyTbName;
        tbs.AddObject(UpperCase(S), obj);
      end;
    end;

    tbs.Sorted := True;

    for I := 0 to tbs.Count - 1 do
      if tbs.Objects[I] is TDMLTableObj then
        FindLinkForTb(TDMLTableObj(tbs.Objects[I]));
  finally
    tbs.Free;
  end;

end;

function TDMLObjList.FindEntityAt(X, Y: Double): Integer;
var
  I, J: Integer;
begin
  for J := 0 to 2 do
  begin
    if J>=1 then
      Continue;
    for I := 0 to Count - 1 do
      if (Items[I].DrawOnBackground=J) and Items[I].PointInObj(X, Y) then
        if Items[I].Visible then
        begin
          Result := I;
          Exit;
        end;
  end;
  Result := -1;
end;

function TDMLObjList.FindEntityInRect(X1, Y1, X2, Y2: Double): Integer;
var
  I: Integer;
  T: Double;
begin
  Result := -1;
  if X1 > X2 then
  begin
    T := X1;
    X1 := X2;
    X2 := T;
  end;
  if Y1 > Y2 then
  begin
    T := Y1;
    Y1 := Y2;
    Y2 := T;
  end;
  X2 := X2 - X1;
  Y2 := Y2 - Y1;
  for I := 0 to Count - 1 do
  begin
    if (Items[I] is TDMLLinkObj) then
      Continue;
    if Items[I].RectTouchObj(X1, Y1, X2, Y2) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TDMLObjList.FindItemAt(X, Y: Double): Integer;
var
  I, J: Integer;
begin
  for J:=0 to 2 do
  begin
    for I := 0 to Count - 1 do
      if (Items[I].DrawOnBackground=J) and Items[I].PointInObj(X, Y) then
      begin
        Result := I;
        Exit;
      end;
  end;
  Result := -1;
end;

procedure TDMLObjList.FindSpace(obj: TDMLObj);
begin
  FindSpaceEx(obj, 10, 10, 50);
end;

procedure TDMLObjList.FindSpaceEx(obj: TDMLObj; FromX, FromY, DY: Double);
var
  I: Integer;
  ot: TDMLObj;
  RX, RY, RW, RH, DDY, DDS: Double;
  bCross: Boolean;
begin
  if not Assigned(obj) then
    Exit;
  if obj.DrawOnBackground<>0 then
    Exit;
  obj.BLeft := 0;
  obj.BTop := 0;
  obj.CheckResize;

  if FromX = 0 then
    FromX := 10;
  if FromY = 0 then
    FromY := 10;
  if DY = 0 then
    DY := 50;
  RX := FromX;
  RY := FromY;
  RW := obj.Width;
  RH := obj.Height;
  if (DY = 50) and (obj is TDMLEntityObj) and
    (TDMLEntityObj(obj).Links.Count > 0) then
    DY := 200;

  while True do
  begin
    bCross := False;
    for I := 0 to Count - 1 do
    begin
      ot := Items[I];
      if ot.Visible and (ot <> obj) and (ot.DrawOnBackground=0) then
      begin
        if (DY = 50) and (Items[I] is TDMLEntityObj) and
          (TDMLEntityObj(Items[I]).Links.Count > 0) then
          DDY := 200 / 4
        else
          DDY := DY / 4;
        DDS := LogN(2, (TDMLEntityObj(ot).Links.Count + 1)) * 20;
        if RectCrossOrTouchRect(ot.Left - DDS, ot.Top - DDS, ot.Width + DDS + DDS, ot.Height + DDS + DDS,
          RX - DDY - 5, RY - DDY - 1, RW + DDY + 5 + DDY + 5, RH + DDY + 1 + DDY + 1) then
        begin
          bCross := True;
          Break;
        end;
      end;
    end;
    if not bCross then
    begin
      obj.OLeft := RX;
      obj.OTop := RY;
      if obj is TDMLEntityObj then
        TDMLEntityObj(obj).CheckPositions;
      Break;
    end;
    RX := RX + 10 + DY / 4;
    if (RX + RW) > FDMLDrawer.DrawerWidth then
    begin
      RX := 10;
      RY := RY + DY;

    end;
  end;
end;

function TDMLObjList.GetAllObjsRect(var X1, Y1, X2, Y2: Double): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    if not Result then
    begin
      X1 := Items[I].Left;
      X2 := Items[I].Left + Items[I].Width;
      Y1 := Items[I].Top;
      Y2 := Items[I].Top + Items[I].Height;
      Result := True;
    end
    else
    begin
      if X1 > Items[I].Left then
        X1 := Items[I].Left;
      if X2 < Items[I].Left + Items[I].Width then
        X2 := Items[I].Left + Items[I].Width;
      if Y1 > Items[I].Top then
        Y1 := Items[I].Top;
      if Y2 < Items[I].Top + Items[I].Height then
        Y2 := Items[I].Top + Items[I].Height;
    end;
  end;
end;

function TDMLObjList.GetItems(Index: Integer): TDMLObj;
begin
  Result := TDMLObj(Get(Index));
end;

function TDMLObjList.GetNextObjID: Integer;
begin
  Inc(FObjidSeq);
  Result := FObjidSeq;
end;

function TDMLObjList.GetSelectedFitRect(var X1, Y1, X2, Y2: Double): Boolean;
  procedure CheckFitRItem(obj: TDMLObj);
  begin
    if obj = nil then
      Exit;
    if X1 > obj.Left then
      X1 := obj.Left;
    if X2 < obj.Left + obj.Width then
      X2 := obj.Left + obj.Width;
    if Y1 > obj.Top then
      Y1 := obj.Top;
    if Y2 < obj.Top + obj.Height then
      Y2 := obj.Top + obj.Height;
  end;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    if Items[I].Selected then
    begin
      if not Result then
      begin
        X1 := Items[I].Left;
        X2 := Items[I].Left + Items[I].Width;
        Y1 := Items[I].Top;
        Y2 := Items[I].Top + Items[I].Height;
        Result := True;
      end;

      CheckFitRItem(Items[I]);
      if Items[I] is TDMLLinkObj then
      begin
        CheckFitRItem(TDMLLinkObj(Items[I]).Obj1);
        CheckFitRItem(TDMLLinkObj(Items[I]).Obj2);
      end;
    end;
end;

function TDMLObjList.GetSelectionRect(var X1, Y1, X2, Y2: Double): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    if Items[I].Selected then
    begin
      if not Result then
      begin
        X1 := Items[I].Left;
        X2 := Items[I].Left + Items[I].Width;
        Y1 := Items[I].Top;
        Y2 := Items[I].Top + Items[I].Height;
        Result := True;
      end
      else
      begin
        if X1 > Items[I].Left then
          X1 := Items[I].Left;
        if X2 < Items[I].Left + Items[I].Width then
          X2 := Items[I].Left + Items[I].Width;
        if Y1 > Items[I].Top then
          Y1 := Items[I].Top;
        if Y2 < Items[I].Top + Items[I].Height then
          Y2 := Items[I].Top + Items[I].Height;
      end;
    end;
end;

function TDMLObjList.GetVisObjsRect(var X1, Y1, X2, Y2: Double): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    if Items[I].Visible then
    begin
      if not Result then
      begin
        X1 := Items[I].Left;
        X2 := Items[I].Left + Items[I].Width;
        Y1 := Items[I].Top;
        Y2 := Items[I].Top + Items[I].Height;
        Result := True;
      end
      else
      begin
        if X1 > Items[I].Left then
          X1 := Items[I].Left;
        if X2 < Items[I].Left + Items[I].Width then
          X2 := Items[I].Left + Items[I].Width;
        if Y1 > Items[I].Top then
          Y1 := Items[I].Top;
        if Y2 < Items[I].Top + Items[I].Height then
          Y2 := Items[I].Top + Items[I].Height;
      end;
    end;
end;

function TDMLObjList.LinksCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Items[I] is TDMLLinkObj then
      Inc(Result);
end;

function TDMLObjList.ItemByName(AName: string): TDMLObj;
var
  I: Integer;
begin
  Result:=nil;
  if AName='' then
    Exit;
  for I:=0 to Count - 1 do
  begin
    if UpperCase(Items[I].Name)=UpperCase(AName) then
    begin
      Result:=Items[I];
      Exit;
    end;
    if Items[I] is TDMLTableObj then
      if UpperCase(TDMLTableObj(Items[I]).PhyTbName) =UpperCase(AName) then
      begin
        Result:=Items[I];
        Exit;
      end;
  end;
end;

procedure TDMLObjList.Load(Ini: TCustomIniFile; Sec: string);
var
  I, C: Integer;
  bCont: Boolean;
  ot: string;
begin
  if not Assigned(Ini) then
    Exit;
  FObjidSeq := Ini.ReadInteger(Sec, 'ObjidSeq', FObjidSeq);
  C := Ini.ReadInteger(Sec, 'ObjCount', 0);
  Clear;
  bCont := True;
  FFindNewSpace := False;
  try
    for I := 0 to C - 1 do
    begin
      if Assigned(FOnObjProgress) then
      begin
        FOnObjProgress(Self, '读取对象', I + 1, C, bCont);
        if not bCont then
          Break;
      end;
      ot := Ini.ReadString(Sec + '_Obj' + IntToStr(I), 'ObjType', '');
      CreateDMLObj(ot).Load(Ini, Sec + '_Obj' + IntToStr(I));
    end;

  finally
    FFindNewSpace := True;
  end;
  for I := 0 to C - 1 do
    if Items[I] is TDMLLinkObj then
      TDMLLinkObj(Items[I]).FindLinkObjs(Self);
  if Assigned(FOnObjProgress) and bCont then
    FOnObjProgress(Self, '读取对象', C, C, bCont);
end;

procedure TDMLObjList.LoadFromStream(AStream: TStream);
var
  I, C: Integer;
  bCont: Boolean;
  ot: string;
begin
  if not Assigned(AStream) then
    Exit;
  Stream_ReadStringL(AStream, Length(FVer), ot);
  if ot <> FVer then
    raise Exception.Create('读取内容校验出错');
  Stream_ReadInteger(AStream, FObjidSeq);
  Stream_ReadInteger(AStream, C);
  Clear;
  bCont := True;
  FFindNewSpace := False;
  try
    for I := 0 to C - 1 do
    begin
      if Assigned(FOnObjProgress) then
      begin
        FOnObjProgress(Self, '读取对象', I + 1, C, bCont);
        if not bCont then
          Break;
      end;
      Stream_ReadString(AStream, ot);
      CreateDMLObj(ot).LoadFromStream(AStream);
    end;

  finally
    FFindNewSpace := True;
  end;
  for I := 0 to C - 1 do
    if Items[I] is TDMLLinkObj then
      TDMLLinkObj(Items[I]).FindLinkObjs(Self);
  CheckLinkLines;
  if Assigned(FOnObjProgress) and bCont then
    FOnObjProgress(Self, '读取对象', C, C, bCont);
end;

procedure TDMLObjList.MoveSelected(DX, DY: Double);
var
  I, J, dd: Integer;
  ent: TDMLEntityObj;
  lnk: TDMLLinkObj;
begin
  dd := 16;

  Self.FDMLDrawer.FLinkOptimizeLevel := FDMLDrawer.FSuggestLinkOptimizeLevel;
  CheckLinkOptiTick(True);

  for I := 0 to Count - 1 do
    if Items[I].Selected then
    begin
      if Items[I] is TDMLLinkObj then
      begin

      end
      else
      begin
        Items[I].Left := Items[I].Left + DX;
        Items[I].Top := Items[I].Top + DY;
        if not Self.FDMLDrawer.IndependPosForOverviewMode then
        begin
          if Items[I].BriefMode then
          begin
            Items[I].OLeft := Items[I].BLeft * 2;
            Items[I].OTop := Items[I].BTop * 2;
          end
          else
          begin
            Items[I].BLeft := 0;
            Items[I].BTop := 0;
          end;
        end;
        if Items[I] is TDMLEntityObj then
        begin
          TDMLEntityObj(Items[I]).CheckMoved(DX, DY);
          CheckLinkOptiTick;
        end;
      end;
    end;
  for I := 0 to Count - 1 do
    if Items[I].Selected then
    begin
      if Items[I] is TDMLLinkObj then
      begin
        TDMLLinkObj(Items[I]).DoMove(DX, DY);
        CheckLinkOptiTick;
      end
      else if Items[I] is TDMLEntityObj then
        if not BriefMode then
        begin
          ent := TDMLEntityObj(Items[I]);
          for J := 0 to Self.Count - 1 do
            if not Items[J].Selected then
              if Items[J] is TDMLLinkObj then
              begin
                lnk := TDMLLinkObj(Items[J]);
                if (lnk.Obj1 <> ent) and (lnk.Obj2 <> ent) then
                  if lnk.RectTouchObj(ent.Left - dd, ent.Top - dd, ent.Width + dd * 2, ent.Height + dd * 2) then
                  begin
                    if FDMLDrawer.FLinkOptimizeLevel = 9 then
                    begin
                      lnk.CheckPosition;
                      CheckLinkOptiTick;
                    end;
                    if FAutoCheckedLinks.IndexOf(lnk) < 0 then
                      FAutoCheckedLinks.Add(lnk);
                  end;
              end;
        end;
    end;
  CheckLinkOptiTick;
end;

procedure TDMLObjList.Notify(Ptr: Pointer; Action: TListNotification);
var
  vDs: TDMLObj;
begin
  inherited;

  if FFreeItemOnDelete then
  begin
    if Action = lnAdded then
      TDMLObj(Ptr).FOwnerList := Self;
    if Action = lnDeleted then
    begin
      vDs := TDMLObj(Ptr);
      vDs.Free;
    end;
  end;
end;

procedure TDMLObjList.PaintAll;
var
  I, J: Integer;
  ADrawer: TDMLDrawer;
  S: string;
begin
  FDMLDrawer.FCurSelectedLinkCount := 0;
  FDMLDrawer.FCurSelectedEntityCount := 0;
  for I := Count - 1 downto 0 do
    if Items[I].Selected then
    begin
      if Items[I] is TDMLLinkObj then
        FDMLDrawer.FCurSelectedLinkCount := FDMLDrawer.FCurSelectedLinkCount + 1
      else
        FDMLDrawer.FCurSelectedEntityCount := FDMLDrawer.FCurSelectedEntityCount + 1;
    end;
{$IFNDEF FPC}
  S := srDefaultFontName;
{$ELSE}
  S := G_DmlGraphFontName;
  if (S = '') or (S = 'default') then
    S := srDmlGraphFontName;
  if (S = '') or (S = 'default') then
    S := srEzdmlDefaultFontName;
{$ENDIF}
  FDMLDrawer.Canvas.Font.Name := S;
  for J:=2 downto 0 do
    for I := Count - 1 downto 0 do
    begin
      if Items[I].DrawOnBackground=J then
        if not FDMLDrawer.DrawSelectedOnly or Items[I].Selected then
          Items[I].PaintTo(FDMLDrawer);
    end;

  ADrawer := FDMLDrawer;
  for I := Count + 18 downto 0 do
  begin
    if ADrawer.CenterRatioX = 130 then
      Exit;

  end;
end;

procedure TDMLObjList.ReArrange;
var
  I, J, oLV: Integer;
  ls: TList;
begin
  oLV := Self.DMLDrawer.FLinkOptimizeLevel;
  try
    Self.DMLDrawer.FLinkOptimizeLevel := 0;
    if SelectedCount = 0 then
    begin
      for I := Count - 1 downto 0 do
      begin
        Items[I].Visible := False;
        if Items[I] is TDMLLinkObj then
          TDMLLinkObj(Items[I]).ResetPosition;
      end;
    end
    else
      for I := Count - 1 downto 0 do
        if Items[I].Selected then
        begin
          Items[I].Visible := False;

          if Items[I] is TDMLEntityObj then
          begin
            ls := TDMLEntityObj(Items[I]).Links;
            for J := 0 to ls.Count - 1 do
            begin
              TDMLLinkObj(ls.Items[J]).ResetPosition;
            end;
          end
          else if Items[I] is TDMLLinkObj then
          begin
            TDMLLinkObj(Items[I]).ResetPosition;
          end;
        end;
    Self.DMLDrawer.FLinkOptimizeLevel := 1;
    ReArrangeEx(0, 0);
  finally
    Self.DMLDrawer.FLinkOptimizeLevel := oLV;
  end;
end;

procedure TDMLObjList.ReArrangeEx(initDX, initDY: Double);
  function GetRandomItem: Integer;
  var
    I, C: Integer;
  begin
    C := 0;
    repeat
      Inc(C);
      if C > Count * 10 then
        Break;
      Result := Random(Count);
      if (Result < 0) or (Result > Count - 1) then
        Continue;
      if not Items[Result].Visible then
        Exit
      else
        for I := 0 to Random(4) + 1 do
          if Result + I < Count then
          begin
            if not Items[Result + I].Visible then
            begin
              Result := Result + I;
              Exit;
            end;
          end;
    until False;
    for I := 0 to Count - 1 do
      if not Items[I].Visible then
      begin
        Result := I;
        Exit;
      end;
    Result := -1;
  end;
var
  I, C, AC: Integer;
  DX, DY: Double;
  bFast, bCont, bHuge: Boolean;
begin
  bHuge := Self.DMLDrawer.FIsHugeMode;

  C := 0;
  for I := Count - 1 downto 0 do
    if not Items[I].Visible then
    begin
      Inc(C);
    end;
  bCont := True;
  DX := initDX;
  DY := initDY;
  bFast := (GetKeyState(VK_SHIFT) and $80) = 0;
  AC := C;
  Randomize;
  while AC > 0 do
  begin
    I := GetRandomItem;
    if I = -1 then
      Break;
    Dec(AC);
    if not Items[I].Visible then
    begin
      if Assigned(FOnObjProgress) then
        FOnObjProgress(Self, srRearrangeObjs, C - AC, C, bCont);
      if bCont and (Items[I].DrawOnBackground=0) then
      begin
        FindSpaceEx(Items[I], DX, DY, 50);
        Items[I].Visible := True;
        if not bHuge then
          if Items[I] is TDMLEntityObj then
            TDMLEntityObj(Items[I]).FindSpaceForLinkObjs(Self);
        if bFast then
        begin
          DX := Items[I].Left;
          DY := Items[I].Top;
        end;
      end
      else
        Items[I].Visible := True;
    end;
  end;

  for I := 0 to Count - 1 do
    if Items[I] is TDMLLinkObj then
    begin
      TDMLLinkObj(Items[I]).FClickPos := 0;
      TDMLLinkObj(Items[I]).CheckPosition;
    end;
end;

procedure TDMLObjList.ReArrangeV2;
begin
  ReArrange;
end;

procedure TDMLObjList.RectSelect(X1, Y1, X2, Y2: Double; bCtrl: Boolean);
var
  I: Integer;
  T: Double;
  bShf, bHasEntity: Boolean;
begin
  bShf := (GetKeyState(VK_SHIFT) and $80) <> 0;
  if not bCtrl then
    ClearSelection;
  if X1 > X2 then
  begin
    T := X1;
    X1 := X2;
    X2 := T;
  end;
  if Y1 > Y2 then
  begin
    T := Y1;
    Y1 := Y2;
    Y2 := T;
  end;
  X2 := X2 - X1;
  Y2 := Y2 - Y1;
  bHasEntity := False;
  for I := 0 to Count - 1 do
  begin
    if bHasEntity and (Items[I] is TDMLLinkObj) then
      Continue;
    if Items[I].RectTouchObj(X1, Y1, X2, Y2) then
    begin
      Items[I].Selected := True;
      if bShf then
        if not bHasEntity then
          if Items[I] is TDMLEntityObj then
            bHasEntity := True;
    end;
  end;

  if bHasEntity then
    for I := 0 to Count - 1 do
    begin
      if Items[I].Selected and (Items[I] is TDMLLinkObj) then
        Items[I].Selected := False;
    end;
end;

procedure TDMLObjList.SelectEntityByDir(dir: Integer; cx, cy: double);
var
  sel, last, cur: TDMLObj;
  I: Integer;
  lastD, curD, cw, ch, dx, dy: Double;
begin
  sel := Self.SelectedObj;
  cw := 100;
  ch := 100;
  if sel <> nil then
  begin
    cw := sel.Width / 2;
    ch := sel.Height / 2;
    cx := sel.Left + cw;
    cy := sel.Top + ch;
  end;

  lastD := 9999999999999;
  last := nil;
  for I:=0 to Count - 1 do
  begin
    cur := Items[I];
    if cur=nil then
      Continue;
    if not (cur is TDMLEntityObj) then
      Continue;
    if cur=sel then
      Continue;

    dx := cur.Left + cur.Width / 2 - cx;
    dy := cur.Top + cur.Height / 2 - cy;
    curD := dx*dx+dy*dy;

    case dir of
      1:
      if dx < -cw then
        if lastD > curD then
        begin
          lastD := curD;
          last := cur;
        end;

      2:
      if dx > cw then
        if lastD > curD then
        begin
          lastD := curD;
          last := cur;
        end;

      3:
      if dy < -ch then
        if lastD > curD then
        begin
          lastD := curD;
          last := cur;
        end;

      4:
      if dy > ch then
        if lastD > curD then
        begin
          lastD := curD;
          last := cur;
        end;
    end;
  end;

  if last <> nil then
  begin
    Self.ClearSelection;
    last.FSelected := True;
    CheckSelection;
  end;
end;

procedure TDMLObjList.Save(Ini: TCustomIniFile; Sec: string);
var
  I, C: Integer;
  bCont: Boolean;
begin
  if not Assigned(Ini) then
    Exit;
  Ini.WriteInteger(Sec, 'ObjidSeq', FObjidSeq);
  C := Count;
  Ini.WriteInteger(Sec, 'ObjCount', C);
  bCont := True;
  for I := 0 to C - 1 do
  begin
    if Assigned(FOnObjProgress) then
    begin
      FOnObjProgress(Self, '写入对象', I + 1, C, bCont);
      if not bCont then
        Break;
    end;
    Items[I].Save(Ini, Sec + '_Obj' + IntToStr(I));
  end;
  if Assigned(FOnObjProgress) and bCont then
    FOnObjProgress(Self, '写入对象', C, C, bCont);
end;

procedure TDMLObjList.SaveToStream(AStream: TStream);
var
  I, C: Integer;
  bCont: Boolean;
begin
  if not Assigned(AStream) then
    Exit;
  Stream_WriteString(AStream, FVer);
  Stream_WriteInteger(AStream, FObjidSeq);
  C := Count;
  Stream_WriteInteger(AStream, C);
  bCont := True;
  for I := 0 to C - 1 do
  begin
    if Assigned(FOnObjProgress) then
    begin
      FOnObjProgress(Self, '写入对象', I + 1, C, bCont);
      if not bCont then
        Break;
    end;
    Stream_WriteString(AStream, Items[I].FObjType);
    Items[I].SaveToStream(AStream);
  end;
  if Assigned(FOnObjProgress) and bCont then
    FOnObjProgress(Self, '写入对象', C, C, bCont);
end;

procedure TDMLObjList.SelectAll(bEntitiesOnly: Boolean);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if not bEntitiesOnly or not (Items[I] is TDMLLinkObj) then
      Items[I].FSelected := True;
  CheckSelection;
end;

function TDMLObjList.SelectedCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Items[I].Selected then
      Inc(Result);
  if Result <> FSelection.Count then
    Self.CheckSelection;
end;

function TDMLObjList.GetSelectedItem(AIndex: Integer): TDMLObj;
begin
  Result := nil;
  if AIndex>=0 then
    if AIndex < FSelection.Count then
      Result := TDMLObj(FSelection[AIndex]);
end;

function TDMLObjList.SelectedObj: TDMLObj;
var
  I, C: Integer;
begin
  C := 0;
  Result := nil;
  for I := 0 to Count - 1 do
    if Items[I].Selected then
    begin
      Inc(C);
      if C = 1 then
        Result := Items[I]
      else
        Result := nil;
    end;
end;

procedure TDMLObjList.SelectItemAt(X, Y: Double; bCtrl: Boolean);
var
  I, J: Integer;
begin
  if not bCtrl then
    ClearSelection;
  for J:=0 to 2 do
  for I := 0 to Count - 1 do
    if (Items[I].DrawOnBackground = J) and Items[I].PointInObj(X, Y) then
    begin
      if not bCtrl then
        Items[I].Selected := True
      else
        Items[I].Selected := not Items[I].Selected;
      Exit;
    end;
end;

procedure TDMLObjList.SetBriefMode(const Value: Boolean);
var
  I, J: Integer;
begin
  FBriefMode := Value;
  BeginUpdateLinks;
  try
    for J := 2 downto 0 do
      for I := 0 to Count - 1 do
        if Items[I].DrawOnBackground = J then
          Items[I].BriefMode := FBriefMode;
  finally
    EndUpdateLinks;
  end;
end;

function TDMLObjList.GetSelectedNames: string;
var
  I: Integer;
  S: String;
begin
  Result := '';
  for I:=0 to Count - 1 do
    if Items[I].Selected then
    begin
      S := Items[I].Name;
      if Items[I] is TDMLTableObj then
        if TDMLTableObj(Items[I]).PhyTbName <> '' then
        S := TDMLTableObj(Items[I]).PhyTbName;
      Result:=Result+S+#13#10;
    end;
end;

procedure TDMLObjList.SetItems(Index: Integer;
  const Value: TDMLObj);
begin
  Put(Index, Value);
end;

procedure TDMLObjList.SetSelectedNames(AValue: string);
var
  S: String;
  ss: TStringList;
  obj: TDMLObj;
  I: Integer;
begin
  Self.ClearSelection;
  if AValue='' then
    Exit;
  ss:= TStringList.Create;
  try
    ss.Text := AValue;
    for I:=0 to ss.Count - 1 do
    begin
      S:=ss[I];
      if S='' then
        Continue;
      obj := Self.ItemByName(S);
      if obj<>nil then
        obj.Selected:= True;
    end;
  finally
    ss.Free;
  end;
end;

procedure TDMLObjList.StopUpdateLinks;
begin
  Dec(FLinksUpdateCounter);
end;

{ TDMLObj }

procedure TDMLObj.Assign(obj: TDMLObj);
begin
  if not Assigned(obj) then
    Exit;
  FName := obj.FName;
  FoHeight := obj.FoHeight;
  FoWidth := obj.FoWidth;
  FReadOnly := obj.FReadOnly;
  FVisible := obj.FVisible;
  FSelected := obj.FSelected;
  FAutoSize := obj.FAutoSize;
  FBorderWidth := obj.FBorderWidth;
  FFillStyle := obj.FFillStyle;
  FBorderColor := obj.FBorderColor;
  FFillColor := obj.FFillColor;
  FBorderStyle := obj.FBorderStyle;
  FViewBorderStyle := obj.FViewBorderStyle;
  FTextColor := obj.FTextColor;
  FComment := obj.FComment;
  FUserPars := obj.FUserPars;
end;

procedure TDMLObj.CheckResize;
begin
end;

constructor TDMLObj.Create;
begin
  FVer := 'DML10';
  RowHeight := 18;
  FName := ClassName;

  FReadOnly := False;
  FVisible := True;
  FSelected := False;
  FAutoSize := True;

  FUserPars := '';

  FBorderWidth := 1;
  FFillStyle := bsSolid;
  FBorderColor := clSilver;
  FFillColor := RGB(242, 242, 242);
  FBorderStyle := psSolid;
  FViewBorderStyle := psDot;
  FTextColor := clBlack;
end;

destructor TDMLObj.Destroy;
begin
  inherited;
end;

procedure TDMLObj.DrawSelectedGrips(const ADrawer: TDMLDrawer);
  procedure DrawR(X, Y: Integer);
  const
    DML_GripWidth = 3;
  begin
    ADrawer.Canvas.Rectangle(Rect(X - DML_GripWidth, Y - DML_GripWidth, X + DML_GripWidth, Y + DML_GripWidth));
  end;
var
  L, T, W, H: Integer;
begin
  if not Selected or not Assigned(ADrawer) or ADrawer.SkipDrawSelected then
    Exit;
  L := ADrawer.GetX(Left);
  T := ADrawer.GetY(Top);
  W := ADrawer.GetX(Left + Width);
  H := ADrawer.GetY(Top + Height);

  with ADrawer.Canvas do
  begin
    if Brush.Style <> bsSolid then
      Brush.Style := bsSolid;
    if Brush.Color <> ADrawer.SelectedColor then
      Brush.Color := ADrawer.SelectedColor;
    if Pen.Style <> psSolid then
      Pen.Style := psSolid;
    if Pen.Color <> ADrawer.SelectedColor then
      Pen.Color := ADrawer.SelectedColor;

    Pen.Mode := pmNotXor;
    if not FDrawSelectGrips then
    begin
      L := L - 1;
      T := T - 1;
      W := W + 2;
      H := H + 2;
      ADrawer.DrawRect(L, T, W, H);
    end
    else
    begin
      DrawR(L, T);
      DrawR(W, T);
      DrawR(L, H);
      DrawR(W, H);
    end;
    Pen.Mode := pmCopy;

    Exit;
    DrawR(L, T);
    DrawR(W, T);
    DrawR(L, H);
    DrawR(W, H);

    DrawR((L + W) div 2, T);
    DrawR((L + W) div 2, H);
    DrawR(L, (T + H) div 2);
    DrawR(W, (T + H) div 2);
  end;
end;

procedure TDMLObj.Load(Ini: TCustomIniFile; Sec: string);
begin
  if not Assigned(Ini) then
    Exit;
  ID := Ini.ReadInteger(Sec, 'ID', ID);
  Name := Ini.ReadString(Sec, 'Name', Name);
  IniReadStrings(Ini, Sec, 'Comment', FComment);
  Height := Ini.ReadFloat(Sec, 'Height', Height);
  Left := Ini.ReadFloat(Sec, 'Left', Left);
  Width := Ini.ReadFloat(Sec, 'Width', Width);
  Top := Ini.ReadFloat(Sec, 'Top', Top);
  ReadOnly := Ini.ReadBool(Sec, 'ReadOnly', ReadOnly);
  Visible := Ini.ReadBool(Sec, 'Visible', Visible);
  Selected := Ini.ReadBool(Sec, 'Selected', Selected);
  AutoSize := Ini.ReadBool(Sec, 'AutoSize', AutoSize);
  BorderWidth := Ini.ReadInteger(Sec, 'BorderWidth', BorderWidth);
  FillStyle := TBrushStyle(Ini.ReadInteger(Sec, 'FillStyle', Integer(FillStyle)));
  BorderColor := Ini.ReadInteger(Sec, 'BorderColor', BorderColor);
  FillColor := Ini.ReadInteger(Sec, 'FillColor', FillColor);
  BorderStyle := TPenStyle(Ini.ReadInteger(Sec, 'BorderStyle', Integer(BorderStyle)));
  TextColor := Ini.ReadInteger(Sec, 'TextColor', TextColor);
end;

procedure TDMLObj.LoadFromStream(AStream: TStream);
var
  I: Integer;
  S: string;
begin
  Stream_ReadStringL(AStream, Length(FVer), S);
  if FVer <> S then
    raise Exception.Create('读取内容校验出错');
  Stream_ReadString(AStream, FObjType);
  Stream_ReadInteger(AStream, FID);
  Stream_ReadString(AStream, FName);
  Stream_ReadString(AStream, FComment);
  Stream_ReadFloat(AStream, FoHeight);
  Stream_ReadFloat(AStream, FoLeft);
  Stream_ReadFloat(AStream, FoWidth);
  Stream_ReadFloat(AStream, FoTop);
  Stream_ReadBool(AStream, FReadOnly);
  Stream_ReadBool(AStream, FVisible);
  Stream_ReadBool(AStream, FSelected);
  Stream_ReadBool(AStream, FAutoSize);
  Stream_ReadInteger(AStream, FBorderWidth);
  Stream_ReadInteger(AStream, Integer(I));
  FillStyle := TBrushStyle(I);
  Stream_ReadColor(AStream, FBorderColor);
  Stream_ReadColor(AStream, FFillColor);
  Stream_ReadInteger(AStream, I);
  BorderStyle := TPenStyle(I);
  Stream_ReadColor(AStream, FTextColor);
end;

procedure TDMLObj.PaintTo(const ADrawer: TDMLDrawer);
begin
  if not Assigned(ADrawer) then
    Exit;
  if not RectTouchObj(ADrawer.BoundLeft, ADrawer.BoundTop,
    ADrawer.BoundWidth, ADrawer.BoundHeight) then
    Exit;
  with ADrawer.Canvas do
  begin
    if Brush.Color <> FFillColor then
      Brush.Color := FFillColor;
    if Brush.Style <> FFillStyle then
      Brush.Style := FFillStyle;
    if Pen.Style <> FBorderStyle then
      Pen.Style := FBorderStyle;
    if Pen.Color <> FBorderColor then
      Pen.Color := FBorderColor;
    if Pen.Width <> FBorderWidth then
      Pen.Width := FBorderWidth;

    Rectangle(ADrawer.GetX(Left), ADrawer.GetY(Top),
      ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + Self.Height));
    Font.Height := ADrawer.GetFontH;
    Font.Color := TextColor;
    TextOut(ADrawer.GetX(Left) + 2, ADrawer.GetY(Top) + 2, FName);

    DrawSelectedGrips(ADrawer);
  end;
end;

function TDMLObj.PointInObj(X, Y: Double): Boolean;
begin
  Result := RectCrossOrTouchRect(Left, Top, Width, Height, X, Y, 1, 1);
end;

procedure TDMLObj.PrepareDelete(objs: TDMLObjList);
begin
end;

function TDMLObj.RectTouchObj(X, Y, W, H: Double): Boolean;
begin
  Result := RectCrossOrTouchRect(Left, Top, Width, Height, X, Y, W, H);
end;

procedure TDMLObj.Save(Ini: TCustomIniFile; Sec: string);
begin
  if not Assigned(Ini) then
    Exit;
  Ini.WriteString(Sec, 'ObjType', FObjType);
  Ini.WriteInteger(Sec, 'ID', ID);
  Ini.WriteString(Sec, 'Name', Name);
  IniWriteStrings(Ini, Sec, 'Comment', Comment);
  Ini.WriteFloat(Sec, 'Height', Height);
  Ini.WriteFloat(Sec, 'Left', Left);
  Ini.WriteFloat(Sec, 'Width', Width);
  Ini.WriteFloat(Sec, 'Top', Top);
  Ini.WriteBool(Sec, 'ReadOnly', ReadOnly);
  Ini.WriteBool(Sec, 'Visible', Visible);
  Ini.WriteBool(Sec, 'Selected', Selected);
  Ini.WriteBool(Sec, 'AutoSize', AutoSize);
  Ini.WriteInteger(Sec, 'BorderWidth', BorderWidth);
  Ini.WriteInteger(Sec, 'FillStyle', Integer(FillStyle));
  Ini.WriteInteger(Sec, 'BorderColor', BorderColor);
  Ini.WriteInteger(Sec, 'FillColor', FillColor);
  Ini.WriteInteger(Sec, 'BorderStyle', Integer(BorderStyle));
  Ini.WriteInteger(Sec, 'TextColor', TextColor);
end;

procedure TDMLObj.SaveToStream(AStream: TStream);
begin
  Stream_WriteString(AStream, FVer);
  Stream_WriteString(AStream, FObjType);
  Stream_WriteInteger(AStream, ID);
  Stream_WriteString(AStream, Name);
  Stream_WriteString(AStream, Comment);
  Stream_WriteFloat(AStream, Height);
  Stream_WriteFloat(AStream, Left);
  Stream_WriteFloat(AStream, Width);
  Stream_WriteFloat(AStream, Top);
  Stream_WriteBool(AStream, ReadOnly);
  Stream_WriteBool(AStream, Visible);
  Stream_WriteBool(AStream, Selected);
  Stream_WriteBool(AStream, AutoSize);
  Stream_WriteInteger(AStream, BorderWidth);
  Stream_WriteInteger(AStream, Integer(FillStyle));
  Stream_WriteInteger(AStream, BorderColor);
  Stream_WriteInteger(AStream, FillColor);
  Stream_WriteInteger(AStream, Integer(BorderStyle));
  Stream_WriteInteger(AStream, TextColor);
end;

procedure TDMLObj.SetBriefMode(const Value: Boolean);
begin
  FBriefMode := Value;
end;

function TDMLObj.GetLeft: Double;
begin
  if FBriefMode then
  begin
    if ((FbLeft > 0.00001) or (FbLeft < -0.00001)) then
      Result := FbLeft
    else
      Result := FoLeft / 2;
  end
  else
  begin
    if ((FoLeft > 0.00001) or (FoLeft < -0.00001)) then
      Result := FoLeft
    else
      Result := FbLeft * 2;
  end;
end;

function TDMLObj.GetTop: Double;
begin
  if FBriefMode then
  begin
    if ((FbTop > 0.00001) or (FbTop < -0.00001)) then
      Result := FbTop
    else
      Result := FoTop / 2;
  end
  else
  begin
    if ((FoTop > 0.00001) or (FoTop < -0.00001)) then
      Result := FoTop
    else
      Result := FbTop * 2;
  end;
end;

procedure TDMLObj.SetLeft(const Value: Double);
begin
  if FBriefMode then
    FbLeft := Value
  else
    FoLeft := Value;
end;

procedure TDMLObj.SetSelected(const Value: Boolean);
begin
  if FSelected = Value then
    Exit;
  FSelected := Value;
  if Self.FOwnerList <> nil then
    FOwnerList.CheckSelection;
end;

procedure TDMLObj.SetTop(const Value: Double);
begin
  if FBriefMode then
    FbTop := Value
  else
    FoTop := Value;
end;

procedure TDMLObj.SetClickPoint(X, Y: Double; ADrawer: TDMLDrawer);
begin
end;

function TDMLObj.GetHeight: Double;
begin
  if FBriefMode then
  begin
    if ((FbHeight > 0.00001) or (FbHeight < -0.00001)) then
      Result := FbHeight
    else
      Result := FoHeight / 2;
  end
  else
  begin
    if ((FoHeight > 0.00001) or (FoHeight < -0.00001)) then
      Result := FoHeight
    else
      Result := FbHeight * 2;
  end;
end;

function TDMLObj.GetWidth: Double;
begin
  if FBriefMode then
  begin
    if ((FbWidth > 0.00001) or (FbWidth < -0.00001)) then
      Result := FbWidth
    else
      Result := FoWidth / 2;
  end
  else
  begin
    if ((FoWidth > 0.00001) or (FoWidth < -0.00001)) then
      Result := FoWidth
    else
      Result := FbWidth * 2;
  end;
end;

procedure TDMLObj.SetHeight(AValue: Double);
begin
  if FBriefMode then
    FbHeight := AValue
  else
    FoHeight := AValue;
end;

procedure TDMLObj.SetWidth(AValue: Double);
begin
  if FBriefMode then
    FbWidth := AValue
  else
    FoWidth := AValue;
end;


procedure TDMLObj.SetID(const Value: Integer);
begin
  FID := Value;
  if FName = ClassName then
    Name := ClassName + IntToStr(ID);
end;

{ TDMLTableObj }

procedure TDMLTableObj.Assign(obj: TDMLObj);
begin
  inherited;
  if not Assigned(obj) or not (obj is TDMLTableObj) then
    Exit;

  AssignFields(TDMLTableObj(obj).FFields);
  FFKColor := TDMLTableObj(obj).FFKColor;
  FTbnameColor := TDMLTableObj(obj).FTbnameColor;
  FSeqName := TDMLTableObj(obj).FSeqName;
  FIsView := TDMLTableObj(obj).FIsView;
  FSql := TDMLTableObj(obj).FSql;

  FPhyTbName := TDMLTableObj(obj).FPhyTbName;
end;

procedure TDMLTableObj.AssignFields(fs: TList);
var
  I: Integer;
begin
  if not Assigned(Fs) then
    Exit;
  ClearFields;
  for I := 0 to FS.Count - 1 do
    NewField.Assign(TDMLField(FS.Items[I]));
end;

procedure TDMLTableObj.CheckResize;
var
  I, J, FTL, K, L, fc, iLgPhMaxLen: Integer;
  F: TDMLField;
  S: string;
begin
  inherited;
  if FBriefMode then
  begin
    S := Name;
    if PhyTbName <> '' then
      if Name <> PhyTbName then
      if Length(Name) < Length(PhyTbName) then
      begin
        S := PhyTbName;
      end;
    CheckSizeForName('((' + S + '))');
    CheckPositions;
    Exit;
  end;

  FMaxFieldLen := 0;
  for I := 0 to FieldCount - 1 do
  begin
    F := Fields[I];
    S := F.Name;
    if (F.PhyName <> '') and (DmlStrLength(F.Name) < DmlStrLength(F.PhyName)) then
      S := F.PhyName;
    L := DmlStrLength(S);
    if F.FieldType in [dmlfFunction, dmlfEvent] then
      L := L div 2;
    if L > FieldNameMaxDrawSize then
      L := FieldNameMaxDrawSize;
    if FMaxFieldLen < L then
      FMaxFieldLen := L;
  end;
  FMaxFieldLen := FMaxFieldLen + 1;

  iLgPhMaxLen := 0;
  for I := 0 to FieldCount - 1 do
  begin
    F := Fields[I];
    S := '';
    if (F.Name <> '') and (F.Name <> F.PhyName) and (F.PhyName <> '') then
      S := F.Name;
    L := DmlStrLength(S);
    if F.FieldType in [dmlfFunction, dmlfEvent] then
      L := L div 2;
    if iLgPhMaxLen < L then
      iLgPhMaxLen := L;
  end;

  if FAutoSize then
  begin
    fc := FFields.Count;
    if FMaxDrawFieldCount >= 10 then
      if fc > FMaxDrawFieldCount then
        fc := FMaxDrawFieldCount;
    Height := (fc + 1) * RowHeight + 6;
    Width := 60;
    S := Name;
    if (PhyTbName <> '') and (Name <> PhyTbName) then
      S := Name + '(' + PhyTbName + ')';
    L := DmlStrLength(S);
    if Width < L * 6.5 then
      Width := Round(L * 6.5);
    for I := 0 to FieldCount - 1 do
    begin
      F := Fields[I];
      FTL := DmlStrLength(F.Get_FieldTypeStr);
      K := DmlStrLength(F.Get_FieldTypeStr(False));
      if FTL < iLgPhMaxLen then
        FTL := iLgPhMaxLen;
      if FTL < 8 then
        FTL := 8;
      if FTL < K then
        FTL := K;
      if FTL > FieldTypeMaxDrawSize then
        FTL := FieldTypeMaxDrawSize;
      L := FMaxFieldLen;
      if Width < Round((L + FTL) * 7) + 16 + 6 then
        Width := Round((L + FTL) * 7) + 16 + 6;
    end;
  end;
  if Width < 120 then
    Width := 120;
  if Height < 40 then
    Height := 40;

  with FFields do
    for I := 1 to Count - 1 do
      if TDMLField(Items[I]).FieldType = dmlfPK then
      begin
        for J := I downto 1 do
          if TDMLField(Items[J - 1]).FieldType = dmlfPK then
            Break
          else
            Exchange(J, J - 1);
      end;
end;

procedure TDMLTableObj.ClearFields;
var
  I: Integer;
begin
  with FFields do
  begin
    for I := Count - 1 downto 0 do
      if Assigned(Items[I]) then
      begin
        TObject(Items[I]).Free;
        Items[I] := nil;
      end;
    Clear;
  end;
end;

constructor TDMLTableObj.Create;
begin
  inherited;
  FDrawSelectGrips := True;
  RowHeight := 16;
  FObjType := 'TABLE';
  FTbnameColor := clRed;
  FPKColor := clFuchsia;
  FFKColor := clBlue;
  FFields := TList.Create;
  FSelectedFieldIndex := -1;
  FMaxDrawFieldCount := TableFieldMaxDrawCount;
end;

procedure TDMLTableObj.DeleteField(Index: Integer);
var
  f: TDMLField;
begin
  f := TDMLField(FFields.Items[Index]);
  f.Free;
  FFields.Delete(Index);
end;

destructor TDMLTableObj.Destroy;
begin
  ClearFields;
  FFields.Free;
  inherited;
end;

procedure TDMLTableObj.DrawSelectedGrips(const ADrawer: TDMLDrawer);
begin
  inherited;
end;

function TDMLTableObj.FindDMLField(AFieldName: string): TDMLField;
var
  I: Integer;
begin
  AFieldName := UpperCase(AFieldName);
  for I := 0 to FieldCount - 1 do
    if (UpperCase(Field[I].Name) = AFieldName)
      or (UpperCase(Field[I].PhyName) = AFieldName) then
    begin
      Result := Field[I];
      Exit;
    end;
  Result := nil;
end;

procedure TDMLTableObj.FindFKLinks(objs: TDMLObjList);
var
  I, K, C1, C2, po: Integer;
  S, T, F: string;
  o: TDMLLinkObj;
  obj: TDMLObj;
  tb: TDMLTableObj;
  f1: TDMLField;
begin
  CheckAbort(' ');
  if not Assigned(objs) then
    Exit;
  C1 := FieldCount;
  for K := 0 to C1 - 1 do
  begin
    f1 := Field[K];
    if f1.IsFK then
    begin
      S := f1.FieldTypeEx;
      po := Pos('.', S);
      if po = 0 then
        Continue;
      T := Copy(S, 1, po - 1);
      F := Copy(S, po + 1, Length(S));
      C2 := objs.Count;
      for I := 0 to C2 - 1 do
      begin
        obj := objs[I];
        if (obj <> Self) and obj.Visible
          and (obj is TDMLTableObj) then
        begin
          if (UpperCase(obj.Name) = UpperCase(T)) or
            (UpperCase(TDMLTableObj(obj).PhyTbName) = UpperCase(T)) then
            if not HasLinked(obj) then
            begin
              if TDMLTableObj(obj).FindDMLField(F) <> nil then
              begin
                tb := TDMLTableObj(obj);
                o := TDMLLinkObj(objs.CreateDMLObj('LINK'));
                o.Obj1 := tb;
                o.Obj2 := Self;
                if f1.IsUnique then
                  o.LinkType := dmllFKUnique
                else
                  o.LinkType := dmllFKNormal;
                o.Comment := f1.Get_PhyName;
                o.FObj1Field := F;
                o.FObj2Field := f1.Get_PhyName;
                o.CheckPosition;
              end;
            end;
        end;
      end;
    end;
  end;

  for K := 0 to C1 - 1 do
  begin
    f1 := Field[K];
    if f1.IsLink then
    begin
      S := f1.FieldTypeEx;
      po := Pos('.', S);
      if po = 0 then
        Continue;
      T := Copy(S, 1, po - 1);
      F := Copy(S, po + 1, Length(S));
      C2 := objs.Count;
      for I := 0 to C2 - 1 do
      begin
        obj := objs[I];
        if (obj <> Self) and obj.Visible
          and (obj is TDMLEntityObj) then
        begin
          if (UpperCase(obj.Name) = UpperCase(T)) or
            ((obj is TDMLTableObj) and (UpperCase(TDMLTableObj(obj).PhyTbName) = UpperCase(T))) then
            if not HasLinked(obj) then
            begin
              o := TDMLLinkObj(objs.CreateDMLObj('LINK'));
              o.Obj1 := TDMLEntityObj(obj);
              o.Obj2 := Self;
              if F = '{Link:Direct}' then
                o.LinkType := dmllDirect
              else if F = '{Link:OppDirect}' then
                o.LinkType := dmllOppDirect
              else
                o.LinkType := dmllLine;
              o.Comment := f1.Get_PhyName;
              o.CheckPosition;
            end;
        end;
      end;
    end;
  end;
end;

function TDMLTableObj.GenFKSQL: TStringList;
var
  I: integer;
  F: TDMLField;
  po: integer;
  strFKSQL: TStringList;
  strsql: string;
  strFkFirst, strFKEnd, S: string;
begin
  strFKSQL := TStringList.Create;
  for I := 0 to Fields.Count - 1 do
  begin
    F := Fields[I];
    if not F.NeedCreate then
      Continue;
    if F.FieldType = dmlfFK then
    begin
      S := F.FieldTypeEx;
      po := Pos('.', S);
      if po = 0 then
        Continue;
      strFKFirst := Copy(S, 1, po - 1);
      strFKEnd := Copy(S, po + 1, Length(S));
      strsql := 'alter table ' + PhyTbName + ' add foreign key ( ' + F.PhyName + ') ' +
        ' references ' + strFKFirst + ' (' + strFKEnd + ') ;';
      strFKSQL.Add(strsql);
    end;
  end;
  result := strFKSQL;

end;

function TDMLTableObj.GenSql: string;
var
  I, C: Integer;
  vTbn, S, T, sComment, sPK: string;
  Infos: TStrings;
  f: TDMLField;
begin
  Result := '';

  Infos := TStringList.Create;
  try

    vTbn := Get_PhyTbName;
    S := 'create table ' + vTbn + #13#10'(';
    Infos.Add(S);

    S := '';
    sComment := '';
    sPK := '';
    C := 0;
    for I := 0 to Fields.Count - 1 do
    begin
      f := Fields[I];
      if not F.NeedCreate then
        Continue;
      Inc(C);
      if C > 1 then
        S := S + ','#13#10;
      S := S + ExtStr(' ', 6) + ExtStr(f.Get_PhyName, 16);
      T := F.Get_FieldTypeStr;
      S := S + ' ' + T;
      if not F.Nullable then
        S := S + ' not null';

      if F.Comment <> '' then
      begin
        if sComment <> '' then
          sComment := sComment + #13#10;
        sComment := sComment + 'comment on column '
          + vTbn + '.' + F.Get_PhyName + ' is ''' + F.Comment + ''';';
      end;
      if F.FieldType = dmlfPK then
      begin
        if sPK <> '' then
          sPK := sPK + #13#10;
        sPK := 'alter  table ' + vTbn + #13#10 +
          '       add constraint PK_' + F.Get_PhyName + ' primary key (' + F.Get_PhyName + ')' + #13#10 +
          '       using index;';
      end;
    end;
    if Copy(vTbn, 1, 3) = 'TT_' then
      S := S + #13#10')'#13#10'on commit delete rows;'
    else if Copy(vTbn, 1, 3) = 'TS_' then
      S := S + #13#10')'#13#10'on commit preserve rows;'
    else
      S := S + #13#10');';
    Infos.Add(S);

    if sPK <> '' then
      Infos.Add(sPK);

    if sComment <> '' then
      Infos.Add(sComment);
    if SeqName = '' then
      Infos.Add('create sequence SEQ_' + Get_PhyTbName + ';')
    else
      Infos.Add('create sequence ' + SeqName + ';');
    Infos.Add('');

  finally
    Result := infos.Text;
    Result := Result + GenFKSQL.Text;
    infos.Free;
  end;
end;

function TDMLTableObj.GenTBSQL: TStringList;
var
  I, C: Integer;
  vTbn, S, T, sComment, sPK: string;
  Infos: TStringList;
  f: TDMLField;
begin

  Infos := TStringList.Create;
  try

    vTbn := Get_PhyTbName;
    S := 'create table ' + vTbn + #13#10'(';
    Infos.Add(S);

    S := '';
    sComment := '';
    sPK := '';
    C := 0;
    for I := 0 to Fields.Count - 1 do
    begin
      f := Fields[I];
      if not F.NeedCreate then
        Continue;
      Inc(C);
      if C > 1 then
        S := S + ','#13#10;
      S := S + ExtStr(' ', 6) + ExtStr(f.Get_PhyName, 16);
      T := F.Get_FieldTypeStr;
      S := S + ' ' + T;
      if not F.Nullable then
        S := S + ' not null';

      if F.Comment <> '' then
      begin
        if sComment <> '' then
          sComment := sComment + #13#10;
        sComment := sComment + 'comment on column '
          + vTbn + '.' + F.Get_PhyName + ' is ''' + F.Comment + ''';';
      end;
      if F.FieldType = dmlfPK then
      begin
        if sPK <> '' then
          sPK := sPK + #13#10;
        sPK := 'alter  table ' + vTbn + #13#10 +
          '       add constraint PK_' + F.Get_PhyName + ' primary key (' + F.Get_PhyName + ')' + #13#10 +
          '       using index;';
      end;
    end;
    if Copy(vTbn, 1, 3) = 'TT_' then
      S := S + #13#10')'#13#10'on commit delete rows;'
    else if Copy(vTbn, 1, 3) = 'TS_' then
      S := S + #13#10')'#13#10'on commit preserve rows;'
    else
      S := S + #13#10');';
    Infos.Add(S);

    if sPK <> '' then
      Infos.Add(sPK);

    if sComment <> '' then
      Infos.Add(sComment);
    if SeqName = '' then
      Infos.Add('create sequence SEQ_' + Get_PhyTbName + ';')
    else
      Infos.Add('create sequence ' + SeqName + ';');
    Infos.Add('');

  finally
    Result := infos;
  end;
end;

function TDMLTableObj.GetDescribe: string;
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

  function ExtStrCh(Str: string; ch: Char; Len: Integer): string;
  var
    I, L: Integer;
  begin
    Str := Trim(Str);
    L := DmlStrLength(Str);
    if L <= Len then
      for I := L to Len do
        Str := Str + ch;
    Result := Str;
  end;

var
  I, L, LM: Integer;
  S, T, FT: string;
  Infos: TStringList;
  f: TDMLField;
begin
  Infos := TStringList.Create;
  try
    L := 0;
    for I := 0 to Fields.Count - 1 do
    begin
      f := Fields[I];
      S := GetDesName(f.PhyName, f.Name);
      if L < Length(S) then
        L := Length(S);
    end;
    LM := 0;
    for I := 0 to Fields.Count - 1 do
    begin
      f := Fields[I];
      S := ExtStr(GetDesName(f.PhyName, f.Name), L);
      if f.FieldType = dmlfOther then
        FT := f.FieldTypeEx
      else
      begin
        FT := DML_LogicTypeNames[f.FieldType];
        if f.FieldType = dmlfString then
          if (f.FieldLen <> 0) and (f.FieldLen <> 4000) then
            FT := FT + '(' + IntToStr(f.FieldLen) + ')';
      end;

      if LM < Length(S + ' ' + FT) then
        LM := Length(S + ' ' + FT);
      if F.Comment <> '' then
      begin
        T := F.Comment;
        T := StringReplace(T, '\', '\\', [rfReplaceAll]);
        T := StringReplace(T, #13, '\r', [rfReplaceAll]);
        T := StringReplace(T, #10, '\n', [rfReplaceAll]);
        S := S + ' ' + ExtStr(FT, 10) + '//' + T;
      end
      else
        S := S + ' ' + FT;

      Infos.Add(S);
    end;

    S := GetDesName(FPhyTbName, FName);
    if LM < Length(S) then
      LM := Length(S);
    T := ExtStrCh('-', '-', LM);
    Infos.Insert(0, T);
    if Comment <> '' then
    begin
      T := Comment;
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

function TDMLTableObj.GetField(Index: Integer): TDMLField;
begin
  Result := TDMLField(FFields.Items[Index]);
end;

function TDMLTableObj.GetFieldCount: Integer;
begin
  Result := FFields.Count;
end;

function TDMLTableObj.GetSelectedText(const ADrawer: TDMLDrawer): string;

  function GetTbSelectSql: string;
  var
    I, C: Integer;
    S, sPK: string;
    f: TDMLField;
  begin
    S := 'select'#13#10;
    sPK := '';
    C := 0;
    for I := 0 to Fields.Count - 1 do
    begin
      f := Fields[I];
      if not F.NeedCreate then
        Continue;
      Inc(C);
      if C > 1 then
        S := S + ',';
      S := S + #13#10 + f.Get_PhyName;
      if (F.FieldType = dmlfPK) or (F.ExtraKeyType = 1) then
      begin
        if sPK = '' then
          sPK := f.Get_PhyName;
      end;
    end;
    S := S + #13#10#13#10' from ' + Get_PhyTbName + ' t';
    S := S + #13#10'where 1=1';
    if sPk <> '' then
      S := S + #13#10'order by ' + sPk;

    Result := S;
  end;
var
  S: string;
  fd: TDMLField;
begin
  Result := '';
  if SelectedFieldIndex < 0 then
  begin
    Result := GetTbSelectSql;
    Exit;
  end;

  if SelectedFieldIndex = 0 then
  begin
    if ADrawer = nil then
    begin
      S := FPhyTbName;
      if S = '' then
        S := FName;
    end
    else if (ADrawer.ShowPhyFieldName = 1) then
    begin
      S := FPhyTbName;
      if S = '' then
        S := FName;
    end
    else if (ADrawer.ShowPhyFieldName = 2) then
    begin
      S := FName;
      if S = '' then
        S := FPhyTbName
      else if (FPhyTbName <> '') and (FPhyTbName <> FName) then
        S := FPhyTbName + '(' + FName + ')';
    end
    else
    begin
      S := FName;
      if S = '' then
        S := FPhyTbName;
    end;
    Result := S;
  end;

  if (SelectedFieldIndex > 0) and (SelectedFieldIndex <= FieldCount) then
  begin
    fd := Self.Field[SelectedFieldIndex - 1];
    S := fd.PhyName;
    if S = '' then
      S := fd.Name;

    if Assigned(ADrawer) and (ADrawer.ShowPhyFieldName = 0) and (fd.Name <> '') then
      S := fd.Name;
    Result := S;
  end;
end;

procedure TDMLTableObj.ClearLinkSelection;
var
  I: Integer;
begin
  with Fields do
    for I := 0 to Count - 1 do
    begin
      TDMLField(Items[I]).LinkSelectType := 0;
    end;
end;

function TDMLTableObj.Get_PhyTbName: string;
begin
  if FPhyTbName <> '' then
    Result := FPhyTbName
  else
    Result := FName;
end;

procedure TDMLTableObj.Load(Ini: TCustomIniFile; Sec: string);
var
  I, C: Integer;
begin
  inherited;
  if not Assigned(ini) then
    Exit;

  FKColor := Ini.ReadInteger(Sec, 'FKColor', FKColor);
  FTbnameColor := Ini.ReadInteger(Sec, 'TbnameColor', TbnameColor);
  FSeqName := Ini.ReadString(Sec, 'SeqName', FSeqName);
  FSql := Ini.ReadString(Sec, 'Sql', FSql);
  FPhyTbName := Ini.ReadString(Sec, 'PhyTbName', FPhyTbName);
  FIsView := Ini.ReadBool(Sec, 'IsView', FIsView);
  C := Ini.ReadInteger(Sec, 'FieldCount', 0);
  ClearFields;
  for I := 0 to C - 1 do
    NewField.Load(Ini, Sec + '_Fd' + IntToStr(I));
  CheckResize;
end;

procedure TDMLTableObj.LoadFromStream(AStream: TStream);
var
  I, C: Integer;
begin
  inherited;
  Stream_ReadColor(AStream, FFKColor);
  Stream_ReadColor(AStream, FTbnameColor);
  Stream_ReadString(AStream, FSeqName);
  Stream_ReadString(AStream, FSql);
  Stream_ReadString(AStream, FPhyTbName);
  Stream_ReadBool(AStream, FIsView);
  Stream_ReadInteger(AStream, C);
  ClearFields;
  for I := 0 to C - 1 do
    NewField.LoadFromStream(AStream);
  CheckResize;
end;

function TDMLTableObj.NewField: TDMLField;
begin
  Result := TDMLField.Create;
  FFields.Add(Result);
end;

procedure TDMLTableObj.PaintTo(const ADrawer: TDMLDrawer);
var
  I, L, T, W, H, LT, TK, ExtraDY, drSelT: Integer;
  F: TDMLField;
  pR: TRect;
  fti: TDMLFieldType;
  S: string;
  IA, IB: Double;
begin
  if not Assigned(ADrawer) then
    Exit;
  if not RectTouchObj(ADrawer.BoundLeft, ADrawer.BoundTop,
    ADrawer.BoundWidth, ADrawer.BoundHeight) then
    Exit;
  with ADrawer.Canvas do
  begin
    if Brush.Color <> FFillColor then
      Brush.Color := FFillColor;
    if Brush.Style <> FFillStyle then
      Brush.Style := FFillStyle;
    if Pen.Color <> FBorderColor then
      Pen.Color := FBorderColor;
    if Pen.Style <> FBorderStyle then
      Pen.Style := FBorderStyle;
    if Pen.Width <> FBorderWidth then
      Pen.Width := FBorderWidth;

    L := ADrawer.GetX(Left);
    T := ADrawer.GetY(Top);
    W := ADrawer.GetX(Left + Self.Width);
    H := ADrawer.GetY(Top + Self.Height);
    if Pen.Style <> psClear then
      Pen.Style := psClear;
    ADrawer.DrawRect(L, T, W + 1, H + 1);
    if IsView then
    begin
      if Pen.Style <> FViewBorderStyle then
        Pen.Style := FViewBorderStyle;
    end
    else if Pen.Style <> FBorderStyle then
      Pen.Style := FBorderStyle;
    ADrawer.DrawRectLine(L, T, W, H);

    {
    TK := ADrawer.GetY(Top + RowHeight + 2);
    ADrawer.DrawLine(L, TK, W, TK); }
  end;

  if FBriefMode then
    with ADrawer.Canvas do
    begin

      Font.Height := ADrawer.GetFontH;
      if Abs(Font.Height) > 1 then
        if (ADrawer.ShowPhyFieldName = 1) then
        begin
          S := FPhyTbName;
          if S = '' then
            S := FName;
        end
        else if (ADrawer.ShowPhyFieldName = 2) then
        begin
          S := FName;
          if S = '' then
            S := FPhyTbName
          else if (FPhyTbName <> '') and (FPhyTbName <> FName) then
            S := FPhyTbName + #13#10'(' + FName + ')';
        end
        else
        begin
          S := FName;
          if S = '' then
            S := FPhyTbName;
        end;

      drSelT := 0;
      if ADrawer.FCurSelectedEntityCount = 0 then
      begin
        for I:=0 to FieldCount - 1 do
        begin
          F := Fields[I];
          if F.LinkSelectType = 1 then
            drSelT := 2
          else if F.LinkSelectType = 2 then
            drSelT := 3;
        end;
      end;

      if (drSelT > 0) and not ADrawer.SkipDrawSelected then
      begin
        if Brush.Style <> bsSolid then
          Brush.Style := bsSolid;
        if drSelT = 2 then
        begin
          if Brush.Color <> ADrawer.DefaultPKColor then
            Brush.Color := ADrawer.DefaultPKColor;
          if Pen.Color <> ADrawer.DefaultPKColor then
            Pen.Color := ADrawer.DefaultPKColor;
        end
        else if drSelT = 3 then
        begin
          if Brush.Color <> ADrawer.DefaultFKColor then
            Brush.Color := ADrawer.DefaultFKColor;
          if Pen.Color <> ADrawer.DefaultFKColor then
            Pen.Color := ADrawer.DefaultFKColor;
        end
        else
        begin
          if Brush.Color <> ADrawer.SelectedColor then
            Brush.Color := ADrawer.SelectedColor;
          if Pen.Color <> ADrawer.SelectedColor then
            Pen.Color := ADrawer.SelectedColor;
        end;
        if Pen.Style <> psSolid then
          Pen.Style := psSolid;
        Pen.Mode := pmNotXor;

        ADrawer.DrawRect(ADrawer.GetX(Left + 2) + 1, ADrawer.GetY(Top + Self.Height - 3) - 1,
          ADrawer.GetX(Left + Self.Width - 1) - 1, ADrawer.GetY(Top + Self.Height) - 1);

        Pen.Mode := pmCopy;
      end;

      Font.Color := FTbnameColor;
      Font.Height := ADrawer.GetFontH;
      if Brush.Style <> bsClear then
        Brush.Style := bsClear;
      if Pos(#13#10, S) = 0 then
      begin
        pR := Rect(ADrawer.GetX(Left + 1), ADrawer.GetY(Top + 1),
          ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + Self.Height));
        DrawText(ADrawer.Canvas.Handle, PChar(S), Length(S), pR, DT_CENTER or DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      end
      else
      begin
        pR := Rect(ADrawer.GetX(Left + 1), ADrawer.GetY(Top + 1 + 7),
          ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + Self.Height));
        DrawText(ADrawer.Canvas.Handle, PChar(S), Length(S), pR, DT_CENTER or DT_VCENTER or DT_NOPREFIX);
      end;

      DrawSelectedGrips(ADrawer);
      Exit;
    end;

  with ADrawer.Canvas do
  begin         
    L := ADrawer.GetX(Left);
    W := ADrawer.GetX(Left + Self.Width);
    TK := ADrawer.GetY(Top + RowHeight + 2);
    ADrawer.DrawLine(L, TK, W, TK);

    Font.Color := FTbnameColor;
    Font.Height := ADrawer.GetFontH;
    if Brush.Style <> bsClear then
      Brush.Style := bsClear;
    S := '';
    if Abs(Font.Height) > 1 then
      if (ADrawer.ShowPhyFieldName = 1) then
      begin
        S := FPhyTbName;
        if S = '' then
          S := FName;
        if ADrawer.RectInRange(Left + 1, Top + 1, Self.Width, RowHeight) then
        begin
          pR := Rect(ADrawer.GetX(Left + 1), ADrawer.GetY(Top + 2),
            ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + RowHeight + 4));
          DrawText(ADrawer.Canvas.Handle, PChar(S), Length(S), pR, DT_CENTER or DT_VCENTER or DT_NOPREFIX);

        end;
      end
      else if (ADrawer.ShowPhyFieldName = 2) then
      begin
        S := FName;
        if S = '' then
          S := FPhyTbName
        else if (FPhyTbName <> '') and (FPhyTbName <> FName) then
          S := FPhyTbName + '(' + FName + ')';
        if ADrawer.RectInRange(Left + 1, Top + 1, Self.Width, RowHeight) then
        begin
          pR := Rect(ADrawer.GetX(Left + 1), ADrawer.GetY(Top + 2),
            ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + RowHeight + 4));
          DrawText(ADrawer.Canvas.Handle, PChar(S), Length(S), pR, DT_CENTER or DT_VCENTER or DT_NOPREFIX);

        end;
      end
      else
      begin
        S := FName;
        if S = '' then
          S := FPhyTbName;
        if ADrawer.RectInRange(Left + 1, Top + 1, Self.Width, RowHeight) then
        begin
          pR := Rect(ADrawer.GetX(Left + 1), ADrawer.GetY(Top + 2),
            ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + RowHeight + 4));
          DrawText(ADrawer.Canvas.Handle, PChar(S), Length(S), pR, DT_CENTER or DT_VCENTER or DT_NOPREFIX);

        end;
      end;

    if (S <> '') and Selected and (FSelectedFieldIndex = 0)
      and not ADrawer.HideSelectedField and not ADrawer.SkipDrawSelected then
    begin
      TK := Length(S);

      if Brush.Style <> bsSolid then
        Brush.Style := bsSolid;
      if Brush.Color <> ADrawer.SelectedColor then
        Brush.Color := ADrawer.SelectedColor;
      if Pen.Style <> psSolid then
        Pen.Style := psSolid;
      if Pen.Color <> ADrawer.SelectedColor then
        Pen.Color := ADrawer.SelectedColor;
      Pen.Mode := pmNotXor;

      IA := Left + (Self.Width - TK * DML_FONTSC - DML_FONT_EXWIDTH) / 2 - 2;
      if IA < Left + 2 then
        IA := Left + 2;
      IB := Left + Self.Width - (Self.Width - TK * DML_FONTSC - DML_FONT_EXWIDTH) / 2 + 2;
      if IB > Left + Self.Width - 2 then
        IB := Left + Self.Width - 2;

      ADrawer.DrawRect(ADrawer.GetX(IA), ADrawer.GetY(Top + 3),
        ADrawer.GetX(IB), ADrawer.GetY(Top + RowHeight + 1));

      Pen.Mode := pmCopy;

      if Brush.Color <> FFillColor then
        Brush.Color := FFillColor;
      if Brush.Style <> FFillStyle then
        Brush.Style := FFillStyle;
      if Pen.Color <> FBorderColor then
        Pen.Color := FBorderColor;
      if IsView then
      begin
        if Pen.Style <> FViewBorderStyle then
          Pen.Style := FViewBorderStyle;
      end
      else if Pen.Style <> FBorderStyle then
        Pen.Style := FBorderStyle;
    end;

    ExtraDY := 2;

    if ADrawer.ShowFieldIcon then
      LT := ADrawer.GetX(Left + 16 + 5)
    else
      LT := ADrawer.GetX(Left + 4 + 5);

    if not ADrawer.FFastDrawMode and (Abs(Font.Height) > 3) then
      for I := 0 to FieldCount - 1 do
      begin
        if not ADrawer.RectInRange(Left, Top + ExtraDY + RowHeight * (I + 1), Self.Width, RowHeight * (I + 2) + ExtraDY) then
          continue;
        if not Rect2InRect1(Left, Top, Left + Self.Width, Top + Self.Height,
          Left + 1, Top + ExtraDY + RowHeight * (I + 1) + 1, Left + Self.Width - 1, Top + RowHeight * (I + 2) + ExtraDY - 1) then
          Continue;

        F := Fields[I];
        if Assigned(ADrawer.Images) and ADrawer.ShowFieldIcon then
        begin
          ADrawer.TempBitmap.Width := 16;
          ADrawer.TempBitmap.Height := 16;
          ADrawer.TempBitmap.Canvas.Brush.Color := FFillColor;
          ADrawer.TempBitmap.Canvas.Rectangle(-1, -1, 18, 18);
          fti := F.FieldType;
          if (F.ExtraKeyType = 1) then
            fti := dmlfPK
          else if (F.ExtraKeyType = 2) then
            ;
          ADrawer.Images.Draw(ADrawer.TempBitmap.Canvas, 0, 0, ADrawer.ImageIndexOf(fti), True);
          ADrawer.Canvas.StretchDraw(Rect(
            ADrawer.GetX(Left + 4),
            ADrawer.GetY(Top + RowHeight * (I + 1) + 1 + ExtraDY),
            ADrawer.GetX(Left + 4 + 16),
            ADrawer.GetY(Top + RowHeight * (I + 1) + 1 + 16 + ExtraDY)), ADrawer.TempBitmap);

        end;
        if F.IsFK then
          Font.Color := FFKColor
        else if F.isPK then
          Font.Color := FPKColor
        else
          Font.Color := FTextColor;
        if Abs(Font.Height) > 1 then
        begin
          pR := Rect(LT, ADrawer.GetY(Top + RowHeight * (I + 1) + 3 + ExtraDY),
            ADrawer.GetX(Left + 16 + Round(FMaxFieldLen * DML_FONTSC + DML_FONT_EXWIDTH)), ADrawer.GetY(Top + RowHeight * (I + 2) + 3 + ExtraDY));
          S := F.Name;
          if S = '' then
            S := F.PhyName;
          if (ADrawer.ShowPhyFieldName = 1) or (ADrawer.ShowPhyFieldName = 2) then
            S := F.Get_PhyName
          else
          begin
            S := F.Name;
            if S = '' then
              S := F.PhyName;
          end;

          DrawText(ADrawer.Canvas.Handle, PChar(S), Length(S), pR, DT_LEFT or DT_NOPREFIX);

          if (FMaxDrawFieldCount >= 10) and (I = FMaxDrawFieldCount - 1) then
          begin
            pR := Rect(ADrawer.GetX(Left + 16 + 5 + Round(FMaxFieldLen * DML_FONTSC + DML_FONT_EXWIDTH)), ADrawer.GetY(Top + RowHeight * (I + 1) + 3 + ExtraDY),
              ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + RowHeight * (I + 2) + 3 + ExtraDY));
            S := '...';
            DrawText(ADrawer.Canvas.Handle, PChar(S), Length(S), pR, DT_LEFT or DT_NOPREFIX);
          end
          else if ADrawer.ShowFieldType then
          begin
            pR := Rect(ADrawer.GetX(Left + 16 + 5 + Round(FMaxFieldLen * DML_FONTSC + DML_FONT_EXWIDTH)), ADrawer.GetY(Top + RowHeight * (I + 1) + 3 + ExtraDY),
              ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + RowHeight * (I + 2) + 3 + ExtraDY));
            if (ADrawer.ShowPhyFieldName = 1) then
              S := F.Get_FieldTypeStr
            else if (ADrawer.ShowPhyFieldName = 2) then
            begin
              S := '';
              if (F.Name <> '') and (F.PhyName <> '') and (F.PhyName <> F.Name) then
                S := F.Name;
            end
            else
              S := F.Get_FieldTypeStr(False);
            DrawText(ADrawer.Canvas.Handle, PChar(S), Length(S), pR, DT_LEFT or DT_NOPREFIX);

          end;

        end;
        drSelT := 0;
        if Selected and (FSelectedFieldIndex = I + 1) and not ADrawer.HideSelectedField then
          drSelT := 1
        else if ADrawer.FCurSelectedEntityCount = 0 then
        begin
          if F.LinkSelectType = 1 then
            drSelT := 2
          else if F.LinkSelectType = 2 then
            drSelT := 3;
        end;
        if (drSelT > 0) and not ADrawer.SkipDrawSelected then
        begin
          S := F.Name;
          if S = '' then
            S := F.PhyName;
          if (ADrawer.ShowPhyFieldName = 1) or (ADrawer.ShowPhyFieldName = 2) then
            S := F.Get_PhyName
          else
          begin
            S := F.Name;
            if S = '' then
              S := F.PhyName;
          end;
          TK := Length(S);
          if TK > FMaxFieldLen then
            TK := FMaxFieldLen;

          if Brush.Style <> bsSolid then
            Brush.Style := bsSolid;
          if drSelT = 2 then
          begin
            if Brush.Color <> ADrawer.DefaultPKColor then
              Brush.Color := ADrawer.DefaultPKColor;
            if Pen.Color <> ADrawer.DefaultPKColor then
              Pen.Color := ADrawer.DefaultPKColor;
          end
          else if drSelT = 3 then
          begin
            if Brush.Color <> ADrawer.DefaultFKColor then
              Brush.Color := ADrawer.DefaultFKColor;
            if Pen.Color <> ADrawer.DefaultFKColor then
              Pen.Color := ADrawer.DefaultFKColor;
          end
          else
          begin
            if Brush.Color <> ADrawer.SelectedColor then
              Brush.Color := ADrawer.SelectedColor;
            if Pen.Color <> ADrawer.SelectedColor then
              Pen.Color := ADrawer.SelectedColor;
          end;
          if Pen.Style <> psSolid then
            Pen.Style := psSolid;
          Pen.Mode := pmNotXor;

          if drSelT = 1 then
          begin
            ADrawer.DrawRect(ADrawer.GetX(Left + 3) + 1, ADrawer.GetY(Top + RowHeight * (I + 1) + 2 + ExtraDY),
              ADrawer.GetX(Left + 16 + 5 + TK * DML_FONTSC + DML_FONT_EXWIDTH) - 1, ADrawer.GetY(Top + RowHeight * (I + 2) + 1 + ExtraDY));
          end
          else
          begin
            ADrawer.DrawRect(ADrawer.GetX(Left + 3) + 1, ADrawer.GetY(Top + RowHeight * (I + 1) + 2 + ExtraDY),
              ADrawer.GetX(Left + Self.Width - 2) - 1, ADrawer.GetY(Top + RowHeight * (I + 2) + 1 + ExtraDY));
          end;

          Pen.Mode := pmCopy;

          if Brush.Color <> FFillColor then
            Brush.Color := FFillColor;
          if Brush.Style <> FFillStyle then
            Brush.Style := FFillStyle;
          if Pen.Color <> FBorderColor then
            Pen.Color := FBorderColor;
          if IsView then
          begin
            if Pen.Style <> FViewBorderStyle then
              Pen.Style := FViewBorderStyle;
          end
          else if Pen.Style <> FBorderStyle then
            Pen.Style := FBorderStyle;
        end;

      end;
  end;
  DrawSelectedGrips(ADrawer);
end;

function TDMLTableObj.PointInObj(X, Y: Double): Boolean;
begin
  Result := inherited PointInObj(X, Y);
end;

procedure TDMLTableObj.RemoveFKLinks(objs: TDMLObjList);
var
  I: Integer;
  o: TObject;
begin
  if not Assigned(objs) then
    Exit;
  for I := FLinks.Count - 1 downto 0 do
  begin
    if (TDMLLinkObj(FLinks[I]).Obj2 = Self)
      and ((TDMLLinkObj(FLinks[I]).LinkType = dmllFKNormal)
      or (TDMLLinkObj(FLinks[I]).LinkType = dmllFKUnique)) then
    begin
      o := FLinks[I];
      objs.Remove(o);
      FLinks.Remove(o);
    end;
  end;
end;

procedure TDMLTableObj.Save(Ini: TCustomIniFile; Sec: string);
var
  I: Integer;
begin
  BriefMode := False;
  inherited;
  if not Assigned(ini) then
    Exit;

  Ini.WriteInteger(Sec, 'FKColor', FKColor);
  Ini.WriteInteger(Sec, 'TbnameColor', TbnameColor);
  Ini.WriteString(Sec, 'SeqName', FSeqName);
  Ini.WriteString(Sec, 'Sql', FSql);
  Ini.WriteString(Sec, 'PhyTbName', FPhyTbName);
  Ini.WriteBool(Sec, 'IsView', FIsView);
  Ini.WriteInteger(Sec, 'FieldCount', FieldCount);
  for I := 0 to FieldCount - 1 do
    Field[I].Save(Ini, Sec + '_Fd' + IntToStr(I));
end;

procedure TDMLTableObj.SaveToStream(AStream: TStream);
var
  I: Integer;
begin
  BriefMode := False;
  inherited;
  Stream_WriteInteger(AStream, FKColor);
  Stream_WriteInteger(AStream, TbnameColor);
  Stream_WriteString(AStream, FSeqName);
  Stream_WriteString(AStream, FSql);
  Stream_WriteString(AStream, FPhyTbName);
  Stream_WriteBool(AStream, FIsView);
  Stream_WriteInteger(AStream, FieldCount);
  for I := 0 to FieldCount - 1 do
    Field[I].SaveToStream(AStream);
end;

procedure TDMLTableObj.SetClickPoint(X, Y: Double; ADrawer: TDMLDrawer);
var
  I, L: Integer;
  iPhyMode: Integer;
  S: string;
const
  ExtraDY = 2;
begin
  inherited;
  FSelectedFieldIndex := -1;
  if not RectCrossOrTouchRect(Left, Top, Width, Height, X, Y, 1, 1) then
    Exit;

  iPhyMode := -1;
  if Assigned(ADrawer) then
    iPhyMode := ADrawer.ShowPhyFieldName;

  for I := 0 to FieldCount - 1 do
  begin

    L := Length(Field[I].Name);
    if (iPhyMode = -1) and (L < Length(Field[I].PhyName)) then
      L := Length(Field[I].PhyName)
    else if (iPhyMode > 0) and (Field[I].PhyName <> '') then
      L := Length(Field[I].PhyName);
    if not Rect2InRect1(Left, Top, Left + Width, Top + Height,
      Left + 1, Top + ExtraDY + RowHeight * (I + 1) + 1,
      Left + Width - 1, Top + RowHeight * (I + 2) + ExtraDY - 1) then
      Continue;
    if not Rect2InRect1(Left + 1, Top + ExtraDY + RowHeight * (I + 1),
      Left + 16 + 5 + Round(L * DML_FONTSC + DML_FONT_EXWIDTH) - 1, Top + RowHeight * (I + 2) + ExtraDY + 1,
      X, Y, X + 1, Y + 1) then
      Continue;
    FSelectedFieldIndex := I + 1;
    Break;
  end;

  if FSelectedFieldIndex < 0 then
  begin

    if (ADrawer.ShowPhyFieldName = 1) then
    begin
      S := FPhyTbName;
      if S = '' then
        S := FName;
    end
    else if (ADrawer.ShowPhyFieldName = 2) then
    begin
      S := FName;
      if S = '' then
        S := FPhyTbName
      else if (FPhyTbName <> '') and (FPhyTbName <> FName) then
        S := FPhyTbName + '(' + FName + ')';
    end
    else
    begin
      S := FName;
      if S = '' then
        S := FPhyTbName;
    end;

    L := Length(S);
    if (iPhyMode = -1) and (L < Length(PhyTbName)) then
      L := Length(PhyTbName)
    else if (iPhyMode = 1) and (PhyTbName <> '') then
      L := Length(PhyTbName);
    if Rect2InRect1(Left + (Width - L * DML_FONTSC - DML_FONT_EXWIDTH) / 2 - 2, Top + 3,
      Left + Width - (Width - L * DML_FONTSC - DML_FONT_EXWIDTH) / 2 + 2, Top + RowHeight + 1,
      X, Y, X + 1, Y + 1) then
      FSelectedFieldIndex := 0;
  end;
end;

procedure TDMLTableObj.SetDescribe(const Value: string);
var
  I, LI: Integer;
  LN, S, T, FT: string;
  Infos: TStringList;
  f: TDMLField;
  function GetNextLine: Boolean;
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
    po: Integer;
  begin
    vMem := GetMemo(Des);
    if Trim(vMem) <> '' then
      Mem := vMem;
    DeleteMemo(Des);
    Des := StringReplace(Des, ':', ' ', [rfReplaceAll]);
    Des := StringReplace(Des, ';', '', [rfReplaceAll]);

    vTemp := Des;
    po := Pos('(', vTemp);
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
    end;

    Tp := Trim(ExtractCompStr(Des + '//', ' ', '//'));
    if Pos(' ', Des) = 0 then
      vPhy := Des
    else
    begin
      vPhy := AddOrModifyCompStr(Des + '//', 'XXX', ' ', '//');
      vPhy := StringReplace(vPhy, ' XXX//', '', [rfReplaceAll]);
    end;
    vPhy := Trim(vPhy);
    if vNam = '' then
    begin
      vNam := vPhy;
      vPhy := '';
    end;
    vPhy := CheckDesName(vPhy);
    vNam := CheckDesName(vNam);
    if Phy = Nam then
      Phy := '';
    if vPhy <> vNam then
      Phy := vPhy;
    if vNam <> '' then
      Nam := vNam;
  end;
  procedure SetDesFieldType;
  var
    II: TDMLFieldType;
    po: Integer;
    vTemp: string;
  begin
    po := Pos('(', FT);
    if po > 0 then
    begin
      vTemp := Trim(ExtractCompStr(FT, '(', ')'));
      FT := Trim(Copy(FT, 1, po - 1));

      po := Pos(',', vTemp);
      if po > 0 then
      begin
        f.FieldLen := StrToIntDef(Trim(Copy(vTemp, 1, po - 1)), f.FieldLen);
        vTemp := Trim(Copy(vTemp, po + 1, Length(vTemp)));
        f.FieldScal := StrToIntDef(vTemp, f.FieldScal);
      end
      else
      begin
        f.FieldLen := StrToIntDef(vTemp, f.FieldLen);
        f.FieldScal := 0;
      end;
    end;

    if UpperCase(Copy(FT, 1, 2)) = 'PK' then
    begin
      f.ExtraKeyType := 1;
      if Length(FT) > 2 then
        FT := Copy(FT, 3, Length(FT))
      else
        Exit;
    end
    else if UpperCase(Copy(FT, 1, 2)) = 'FK' then
    begin
      f.ExtraKeyType := 2;
      if Length(FT) > 2 then
        FT := Copy(FT, 3, Length(FT))
      else
        Exit;
    end
    else
    begin
      f.ExtraKeyType := 0;
      f.FieldTypeEx := '';
    end;

    for II := Low(TDMLFieldType) to High(TDMLFieldType) do
    begin
      if UpperCase(FT) = UpperCase(DML_LogicTypeNames[II]) then
      begin
        f.FieldType := II;
        Exit;
      end;
    end;
    f.FieldType := dmlfOther;
    f.FieldTypeEx := FT;
  end;
begin
  Infos := TStringList.Create;
  try
    Infos.Text := Value;
    LI := 0;

    if not GetNextLine then
      Exit;
    S := LN;
    if not GetNextLine then
      Exit;
    T := LN;
    if Copy(T, 1, 2) = '//' then
    begin
      if not GetNextLine then
        Exit;
      T := GetMemo(T);
      if Trim(T) <> '' then
        Comment := T;
      T := LN;
    end;
    if Copy(T, 1, 2) = '--' then
    begin
      SetDesName(S, FPhyTbName, FName, FComment, FT);
    end
    else
      LI := 0;

    for I := 0 to Fields.Count - 1 do
    begin
      if not GetNextLine then
      begin
        while Fields.Count - 1 >= I do
        begin
          DeleteField(Fields.Count - 1);
        end;
        Exit;
      end;
      f := Fields[I];
      SetDesName(LN, f.PhyName, f.Name, f.Comment, FT);

      begin
        SetDesFieldType;
      end;
    end;
    while GetNextLine do
    begin
      f := NewField;
      SetDesName(LN, f.PhyName, f.Name, f.Comment, FT);
      if FT <> DML_LogicTypeNames[f.FieldType] then
      begin
        SetDesFieldType;
      end;
    end;

  finally
    infos.Free;
  end;

end;

procedure TDMLTableObj.SetID(const Value: Integer);
begin
  FID := Value;
  if FName = ClassName then
    FName := srTable + IntToStr(FID);
end;

procedure TDMLTableObj.SetMaxDrawFieldCount(const Value: Integer);
begin
  if FMaxDrawFieldCount <> Value then
  begin
    FMaxDrawFieldCount := Value;
    Self.CheckResize;
  end;
end;

procedure TDMLTableObj.SetSelectedFieldIndex(AValue: Integer);
begin
  if FSelectedFieldIndex=AValue then Exit;
  FSelectedFieldIndex:=AValue;
end;

{ TDMLDrawer }

constructor TDMLDrawer.Create;
begin
  TempBitmap := TBitmap.Create;
  CenterRngH := 11;
  CenterRngW := $A0A0A0;
  CenterRngS := Integer(bsClear);
  CenterRatioW := $4A5092;
  CenterRatioH := $783167;
  CenterRatioI0 := GetTickCount64;
  CenterRatioI1 := (90 + Random(30)) * 1000;
  FLinkOptimizeLevel := 9;
  FSuggestLinkOptimizeLevel := 9;
  FIsHugeMode := False;
  IndependPosForOverviewMode := False;
  ResetConfig;
end;

destructor TDMLDrawer.Destroy;
begin
  TempBitmap.Free;
  inherited;
end;

procedure TDMLDrawer.DrawLine(X1, Y1, X2, Y2: Integer);
begin
  if X1 < -1 then
    X1 := -1;
  if X1 > ControlWidth + 1 then
    X1 := ControlWidth + 1;
  if X2 < -1 then
    X2 := -1;
  if X2 > ControlWidth + 1 then
    X2 := ControlWidth + 1;

  if Y1 < -1 then
    Y1 := -1;
  if Y1 > ControlHeight + 1 then
    Y1 := ControlHeight + 1;
  if Y2 < -1 then
    Y2 := -1;
  if Y2 > ControlHeight + 1 then
    Y2 := ControlHeight + 1;

  Canvas.MoveTo(X1, Y1);
  Canvas.LineTo(X2, Y2);
end;

procedure TDMLDrawer.DrawRect(X1, Y1, X2, Y2: Integer);
begin
  if X1 < -1 then
    X1 := -1;
  if X1 > ControlWidth + 1 then
    X1 := ControlWidth + 1;
  if X2 < -1 then
    X2 := -1;
  if X2 > ControlWidth + 1 then
    X2 := ControlWidth + 1;

  if Y1 < -1 then
    Y1 := -1;
  if Y1 > ControlHeight + 1 then
    Y1 := ControlHeight + 1;
  if Y2 < -1 then
    Y2 := -1;
  if Y2 > ControlHeight + 1 then
    Y2 := ControlHeight + 1;
  Canvas.Rectangle(X1, Y1, X2, Y2);
end;

procedure TDMLDrawer.DrawRectLine(X1, Y1, X2, Y2: Integer);
begin
  DrawLine(X1, Y1, X1, Y2);
  DrawLine(X1, Y1, X2 + 1, Y1);
  DrawLine(X2, Y2, X2, Y1);
  DrawLine(X2, Y2, X1 - 1, Y2);
end;

function TDMLDrawer.GetConfigStr: string;
var
  res: TStringList;
begin
  res := TStringList.Create;
  try
    res.Add('DrawerWidth=' + IntToStr(DrawerWidth));
    res.Add('DrawerHeight=' + IntToStr(DrawerHeight));
    res.Add('WorkAreaColor=' + IntToStr(WorkAreaColor));
    res.Add('SelectedColor=' + IntToStr(SelectedColor));
    res.Add('DefaultObjectColor=' + IntToStr(DefaultObjectColor));
    res.Add('DefaultTitleColor=' + IntToStr(DefaultTitleColor));
    res.Add('DefaultPKColor=' + IntToStr(DefaultPKColor));
    res.Add('DefaultFKColor=' + IntToStr(DefaultFKColor));
    res.Add('DefaultBorderColor=' + IntToStr(DefaultBorderColor));
    res.Add('DefaultLineColor=' + IntToStr(DefaultLineColor));
    res.Add('DefaultGroupEdgeColor=' + IntToStr(DefaultGroupEdgeColor));
    res.Add('ShowFieldType=' + IntToStr(Integer(ShowFieldType)));
    res.Add('ShowFieldIcon=' + IntToStr(Integer(ShowFieldIcon)));
    res.Add('ShowPhyFieldName=' + IntToStr(ShowPhyFieldName));

    res.Add('DatabaseEngine=' + DatabaseEngine);
    res.Add('GenFKIndexesSQL=' + IntToStr(Integer(GenFKIndexesSQL)));

    res.Add('IndependPosForOverviewMode=' + IntToStr(Integer(IndependPosForOverviewMode)));

    Result := res.Text;
  finally
    res.Free;
  end;
end;

function TDMLDrawer.GetD(const D: Double): Double;
begin
  Result := D * Scale;
end;

function TDMLDrawer.GetFontH: Integer;
begin
  Result := Round(-12 * Scale);
  if Result = 0 then
    Result := -1;
end;

function TDMLDrawer.ImageIndexOf(const FT: TDMLFieldType): Integer;
begin
  if FT = dmlfOther then
    Result := 0
  else
    Result := Integer(FT);
end;

procedure TDMLDrawer.Load(Ini: TCustomIniFile; Sec: string);
begin
  if not Assigned(Ini) then
    Exit;
  Scale := Ini.ReadFloat(Sec, 'Scale', Scale);
  CenterX := Ini.ReadFloat(Sec, 'CenterX', CenterX);
  CenterY := Ini.ReadFloat(Sec, 'CenterY', CenterY);
  BoundLeft := Ini.ReadFloat(Sec, 'BoundLeft', BoundLeft);
  BoundTop := Ini.ReadFloat(Sec, 'BoundTop', BoundTop);
  BoundHeight := Ini.ReadFloat(Sec, 'BoundHeight', BoundHeight);
  BoundWidth := Ini.ReadFloat(Sec, 'BoundWidth', BoundWidth);
  ControlWidth := Ini.ReadInteger(Sec, 'ControlWidth', ControlWidth);
  ControlHeight := Ini.ReadInteger(Sec, 'ControlHeight', ControlHeight);
  DrawerWidth := Ini.ReadInteger(Sec, 'DrawerWidth', DrawerWidth);
  DrawerHeight := Ini.ReadInteger(Sec, 'DrawerHeight', DrawerHeight);
  SelectedColor := Ini.ReadInteger(Sec, 'SelectedColor', SelectedColor);
  DefaultObjectColor := Ini.ReadInteger(Sec, 'DefaultObjectColor', DefaultObjectColor);
  DefaultTitleColor := Ini.ReadInteger(Sec, 'DefaultTitleColor', DefaultTitleColor);
  DefaultPKColor := Ini.ReadInteger(Sec, 'DefaultFKColor', DefaultPKColor);
  DefaultFKColor := Ini.ReadInteger(Sec, 'DefaultFKColor', DefaultFKColor);
  DefaultBorderColor := Ini.ReadInteger(Sec, 'DefaultBorderColor', DefaultBorderColor);
  DefaultLineColor := Ini.ReadInteger(Sec, 'DefaultLineColor', DefaultLineColor);
  DefaultGroupEdgeColor := Ini.ReadInteger(Sec, 'DefaultGroupEdgeColor', DefaultGroupEdgeColor);
  DatabaseEngine := Ini.ReadString(Sec, 'DatabaseEngine', DatabaseEngine);
  IndependPosForOverviewMode := Ini.ReadBool(Sec, 'IndependPosForOverviewMode', IndependPosForOverviewMode);
end;

procedure TDMLDrawer.LoadFromStream(AStream: TStream);
begin
  if not Assigned(AStream) then
    Exit;
  Stream_ReadFloat(AStream, Scale);
  Stream_ReadFloat(AStream, CenterX);
  Stream_ReadFloat(AStream, CenterY);
  Stream_ReadFloat(AStream, BoundLeft);
  Stream_ReadFloat(AStream, BoundTop);
  Stream_ReadFloat(AStream, BoundHeight);
  Stream_ReadFloat(AStream, BoundWidth);
  Stream_ReadInteger(AStream, ControlWidth);
  Stream_ReadInteger(AStream, ControlHeight);
  Stream_ReadInteger(AStream, DrawerWidth);
  Stream_ReadInteger(AStream, DrawerHeight);
  Stream_ReadColor(AStream, SelectedColor);
end;

function TDMLDrawer.RectInRange(L, T, W, H: Double): Boolean;
begin
  Result := RectCrossOrTouchRect(L, T, W, H, BoundLeft, BoundTop, BoundWidth, BoundHeight);
end;

procedure TDMLDrawer.ResetConfig;
begin
  ShowFieldType := True;
  ShowFieldIcon := True;
  ShowPhyFieldName := 2;
  WorkAreaColor := clWhite;
  SelectedColor := clBlue;
  DefaultObjectColor := RGB(242, 242, 242);
  DefaultPKColor := clFuchsia;
  DefaultFKColor := clBlue;
  DefaultTitleColor := clRed;
  DefaultBorderColor := clSilver;
  DefaultLineColor := clBlue;
  DefaultGroupEdgeColor := clMaroon;
  DatabaseEngine := 'ORACLE';
  DrawerWidth := 1000;
  DrawerHeight := 1600;
  IndependPosForOverviewMode := False;
end;

procedure TDMLDrawer.Save(Ini: TCustomIniFile; Sec: string);
begin
  if not Assigned(Ini) then
    Exit;
  Ini.WriteFloat(Sec, 'Scale', Scale);
  Ini.WriteFloat(Sec, 'CenterX', CenterX);
  Ini.WriteFloat(Sec, 'CenterY', CenterY);
  Ini.WriteFloat(Sec, 'BoundLeft', BoundLeft);
  Ini.WriteFloat(Sec, 'BoundTop', BoundTop);
  Ini.WriteFloat(Sec, 'BoundHeight', BoundHeight);
  Ini.WriteFloat(Sec, 'BoundWidth', BoundWidth);
  Ini.WriteInteger(Sec, 'ControlWidth', ControlWidth);
  Ini.WriteInteger(Sec, 'ControlHeight', ControlHeight);
  Ini.WriteInteger(Sec, 'DrawerWidth', DrawerWidth);
  Ini.WriteInteger(Sec, 'DrawerHeight', DrawerHeight);
  Ini.WriteInteger(Sec, 'SelectedColor', SelectedColor);
  Ini.WriteInteger(Sec, 'DefaultObjectColor', DefaultObjectColor);
  Ini.WriteInteger(Sec, 'DefaultTitleColor', DefaultTitleColor);
  Ini.WriteInteger(Sec, 'DefaultPKColor', DefaultPKColor);
  Ini.WriteInteger(Sec, 'DefaultFKColor', DefaultFKColor);
  Ini.WriteInteger(Sec, 'DefaultBorderColor', DefaultBorderColor);
  Ini.WriteInteger(Sec, 'DefaultLineColor', DefaultLineColor);
  Ini.WriteInteger(Sec, 'DefaultGroupEdgeColor', DefaultGroupEdgeColor);
  Ini.WriteString(Sec, 'DatabaseEngine', DatabaseEngine);
  Ini.WriteBool(Sec, 'IndependPosForOverviewMode', IndependPosForOverviewMode);
end;

procedure TDMLDrawer.SaveToStream(AStream: TStream);
begin
  if not Assigned(AStream) then
    Exit;
  Stream_WriteFloat(AStream, Scale);
  Stream_WriteFloat(AStream, CenterX);
  Stream_WriteFloat(AStream, CenterY);
  Stream_WriteFloat(AStream, BoundLeft);
  Stream_WriteFloat(AStream, BoundTop);
  Stream_WriteFloat(AStream, BoundHeight);
  Stream_WriteFloat(AStream, BoundWidth);
  Stream_WriteInteger(AStream, ControlWidth);
  Stream_WriteInteger(AStream, ControlHeight);
  Stream_WriteInteger(AStream, DrawerWidth);
  Stream_WriteInteger(AStream, DrawerHeight);
  Stream_WriteInteger(AStream, SelectedColor);
end;

procedure TDMLDrawer.SetConfigStr(Des: string);
var
  S: string;
begin
  Des := #10 + Des + #10;
  Des := StringReplace(Des, #13, #10, [rfReplaceAll]);

  S := ExtractCompStr(Des, #10'DrawerWidth=', #10);
  DrawerWidth := StrToIntDef(S, DrawerWidth);
  S := ExtractCompStr(Des, #10'DrawerHeight=', #10);
  DrawerHeight := StrToIntDef(S, DrawerHeight);

  S := ExtractCompStr(Des, #10'WorkAreaColor=', #10);
  WorkAreaColor := StrToIntDef(S, WorkAreaColor);
  S := ExtractCompStr(Des, #10'SelectedColor=', #10);
  SelectedColor := StrToIntDef(S, SelectedColor);

  S := ExtractCompStr(Des, #10'DefaultObjectColor=', #10);
  DefaultObjectColor := StrToIntDef(S, DefaultObjectColor);
  S := ExtractCompStr(Des, #10'DefaultTitleColor=', #10);
  DefaultTitleColor := StrToIntDef(S, DefaultTitleColor);
  S := ExtractCompStr(Des, #10'DefaultPKColor=', #10);
  DefaultPKColor := StrToIntDef(S, DefaultPKColor);
  S := ExtractCompStr(Des, #10'DefaultFKColor=', #10);
  DefaultFKColor := StrToIntDef(S, DefaultFKColor);
  S := ExtractCompStr(Des, #10'DefaultBorderColor=', #10);
  DefaultBorderColor := StrToIntDef(S, DefaultBorderColor);
  S := ExtractCompStr(Des, #10'DefaultLineColor=', #10);
  DefaultLineColor := StrToIntDef(S, DefaultLineColor);
  S := ExtractCompStr(Des, #10'DefaultGroupEdgeColor=', #10);
  DefaultGroupEdgeColor := StrToIntDef(S, DefaultGroupEdgeColor);

  S := ExtractCompStr(Des, #10'ShowFieldIcon=', #10);
  ShowFieldIcon := (S <> '0');
  S := ExtractCompStr(Des, #10'ShowFieldType=', #10);
  ShowFieldType := (S <> '0');
  S := ExtractCompStr(Des, #10'ShowPhyFieldName=', #10);
  ShowPhyFieldName := StrToIntDef(S, ShowPhyFieldName);

  DatabaseEngine := ExtractCompStr(Des, #10'DatabaseEngine=', #10);
  S := ExtractCompStr(Des, #10'GenFKIndexesSQL=', #10);
  GenFKIndexesSQL := (S = '1');

  S := ExtractCompStr(Des, #10'IndependPosForOverviewMode=', #10);
  IndependPosForOverviewMode := (S = '1');
end;

procedure TDMLDrawer.SetDefaultProps(AObj: TDMLObj);
begin
  if AObj = nil then
    Exit;
  if Pos('[CUSTOM_BKCOLOR=1]', Aobj.UserPars) = 0 then
    AObj.FillColor := DefaultObjectColor;   
  if AObj is TDMLGroupBoxObj then
    AObj.BorderColor := DefaultGroupEdgeColor
  else
    AObj.BorderColor := DefaultBorderColor;
  if AObj is TDMLTableObj then
  begin
    TDMLTableObj(AObj).FPKColor := DefaultPKColor;
    TDMLTableObj(AObj).FFKColor := DefaultFKColor;
    TDMLTableObj(AObj).FTbnameColor := DefaultTitleColor;
  end;
  if AObj is TDMLLinkObj then
    AObj.BorderColor := DefaultLineColor;

end;

{ TDMLField }

procedure TDMLField.Assign(f: TDMLField);
begin
  if not Assigned(f) then
    Exit;
  Name := f.Name;
  PhyName := f.PhyName;
  FieldType := f.FieldType;
  FieldTypeName := f.FieldTypeName;
  FieldLen := f.FieldLen;
  FieldScal := f.FieldScal;
  FieldTypeEx := f.FieldTypeEx;
  Comment := f.Comment;
  Nullable := f.Nullable;
  ExtraKeyType := f.ExtraKeyType;
  Editor := f.Editor;
  IndexType := f.IndexType;
end;

constructor TDMLField.Create;
begin
  FieldType := dmlfString;
  Nullable := True;
end;

function TDMLField.Get_FieldTypeStr(bPhy: Boolean = True): string;
var
  L: Integer;
const
  DEF_TEXT_CLOB_LEN = 99999;
begin
  case FieldType of
    dmlfObject, dmlfOther:
      begin
        if FieldTypeName <> '' then
          Result := FieldTypeName
        else if FieldTypeEx = '' then
        begin
          if bPhy then
          begin
            Result := GetDMLFieldPhyTypeName(CurrentDmlDbEngine, FieldType, FieldLen);
          end
          else
            Result := DML_LogicTypeNames[FieldType];
        end
        else
        begin
          Result := FieldTypeEx;
          L := Length(Result);
          if L > 5 then
            if (Result[5] = '[') and (Result[L] = ']') then
              Result := Copy(Result, 6, L - 6);
          if (FieldLen > 0) then
            if (FieldScal > 0) then
              Result := Result + '(' + IntToStr(FieldLen) + ',' + IntToStr(FieldScal) + ')'
            else
              Result := Result + '(' + IntToStr(FieldLen) + ')';
        end;
        if bPhy then
          Result := Proc_CheckCustDataTypeReplaces(Result);
      end;
  else
    begin
      if bPhy then
      begin
        if FieldTypeName <> '' then
          Result := FieldTypeName
        else
          Result := GetDMLFieldPhyTypeName(CurrentDmlDbEngine, FieldType, FieldLen);

        case FieldType of
          dmlfString:
            if not Proc_CheckStringMaxLen(CurrentDmlDbEngine, '', Result, FieldLen) then
            begin
              if FieldLen > 0 then
                Result := Result + '(' + IntToStr(FieldLen) + ')'
              else if Pos('(', Result) = 0 then
                Result := Result + '(4000)';
            end;
          dmlfPK, dmlfFK, dmlfInteger:
            if (FieldLen > 0) and (FieldLen <> 10) then
              Result := Result + '(' + IntToStr(FieldLen) + ')'
            else if CurrentDmlDbEngine = 'ORACLE' then
              if Result = 'NUMBER' then
                Result := Result + '(10)';
          dmlfFloat:
            if (FieldLen > 0) then
              if (FieldScal > 0) then
                Result := Result + '(' + IntToStr(FieldLen) + ',' + IntToStr(FieldScal) + ')'
              else
                Result := Result + '(' + IntToStr(FieldLen) + ')';
          dmlfUnknow, dmlfOther:
            if (FieldLen > 0) then
              if (FieldScal > 0) then
                Result := Result + '(' + IntToStr(FieldLen) + ',' + IntToStr(FieldScal) + ')'
              else
                Result := Result + '(' + IntToStr(FieldLen) + ')';
        end;
        Result := Proc_CheckCustDataTypeReplaces(Result);
        if ExtraKeyType = 1 then
          Result := Result + ' PK'
        else if ExtraKeyType = 2 then
          Result := Result + ' FK';
      end
      else
      begin
        Result := DML_LogicTypeNames[FieldType];
        if ExtraKeyType = 1 then
        begin
          if (FieldType = dmlfInteger) and (FieldLen = 0) then
          begin
            Result := 'PK';
            Exit;
          end
          else
            Result := 'PK' + Result;
        end
        else if ExtraKeyType = 2 then
        begin
          if (FieldType = dmlfInteger) and (FieldLen = 0) then
          begin
            Result := 'FK';
            Exit;
          end
          else
            Result := 'FK' + Result;
        end;

        case FieldType of
          dmlfString:
            if FieldLen >= DEF_TEXT_CLOB_LEN then

              Result := Result + '(' + IntToStr(FieldLen) + ')'
            else if FieldLen > 0 then
              if FieldLen <> 4000 then
                Result := Result + '(' + IntToStr(FieldLen) + ')';
          dmlfPK, dmlfFK, dmlfInteger:
            if (FieldLen > 0) then
              Result := Result + '(' + IntToStr(FieldLen) + ')';
          dmlfFloat:
            if (FieldLen > 0) then
              if (FieldScal > 0) then
                Result := Result + '(' + IntToStr(FieldLen) + ',' + IntToStr(FieldScal) + ')'
              else
                Result := Result + '(' + IntToStr(FieldLen) + ')';
          dmlfUnknow, dmlfOther:
            if (FieldLen > 0) then
              if (FieldScal > 0) then
                Result := Result + '(' + IntToStr(FieldLen) + ',' + IntToStr(FieldScal) + ')'
              else
                Result := Result + '(' + IntToStr(FieldLen) + ')';
        end;
      end;
    end;
  end;
end;

function TDMLField.Get_PhyName: string;
begin
  if PhyName <> '' then
    Result := PhyName
  else
    Result := Name;
end;

function TDMLField.IsFK: Boolean;
begin
  Result := (FieldType = dmlfFK) or (ExtraKeyType = 2);
  if not Result then
    if (FieldType = dmlfPK) or (ExtraKeyType = 1) then
      if (FieldTypeEx <> '') and (Pos('.', FieldTypeEx) > 0) then
        Result := True;
end;

function TDMLField.IsLink: Boolean;
begin
  if (FieldType = dmlfFK) or (ExtraKeyType = 1) or (ExtraKeyType = 2) then
  begin
    Result := False;
    Exit;
  end;
  Result := (ExtraKeyType = 3);
  if not Result then
  begin
    if (FieldTypeEx <> '') then
      if (Pos('.{Link:Line}', FieldTypeEx) > 0) or (Pos('.{Link:Direct}', FieldTypeEx) > 0)
        or (Pos('.{Link:OppDirect}', FieldTypeEx) > 0) then
        Result := True;
  end;
end;

function TDMLField.IsPK: Boolean;
begin
  Result := (FieldType = dmlfPK) or (ExtraKeyType = 1);
end;

function TDMLField.IsUnique: Boolean;
begin
  Result := IsPK or (IndexType = 1);
end;

procedure TDMLField.Load(Ini: TCustomIniFile; Sec: string);
begin
  if not Assigned(ini) then
    Exit;
  Name := Ini.ReadString(Sec, 'Name', Name);
  PhyName := Ini.ReadString(Sec, 'PhyName', PhyName);
  FieldType := TDMLFieldType(Ini.ReadInteger(Sec, 'FieldType', Integer(FieldType)));
  FieldLen := Ini.ReadInteger(Sec, 'FieldLen', FieldLen);
  FieldScal := Ini.ReadInteger(Sec, 'FieldScal', FieldScal);
  FieldTypeEx := Ini.ReadString(Sec, 'FieldTypeEx', FieldTypeEx);
  Comment := Ini.ReadString(Sec, 'Comment', Comment);
  Nullable := Ini.ReadBool(Sec, 'Nullable', Nullable);
  Editor := Ini.ReadString(Sec, 'Editor', Editor);
  IndexType := Ini.ReadInteger(Sec, 'IndexType', IndexType);
end;

procedure TDMLField.LoadFromStream(AStream: TStream);
var
  I: Integer;
begin
  Stream_ReadString(AStream, Name);
  Stream_ReadString(AStream, PhyName);
  Stream_ReadInteger(AStream, I);
  FieldType := TDMLFieldType(I);
  Stream_ReadInteger(AStream, FieldLen);
  Stream_ReadInteger(AStream, FieldScal);
  Stream_ReadString(AStream, FieldTypeEx);
  Stream_ReadString(AStream, Comment);
  Stream_ReadBool(AStream, Nullable);
  Stream_ReadString(AStream, Editor);
  Stream_ReadInteger(AStream, IndexType);
end;

function TDMLField.NeedCreate: Boolean;
begin
  case FieldType of
    dmlfUnknow, dmlfPK, dmlfFK, dmlfString, dmlfInteger, dmlfEnum,
      dmlfFloat, dmlfDate, dmlfBlob, dmlfObject, dmlfOther:
      Result := True;
  else
    Result := False;
  end;
end;

procedure TDMLField.Save(Ini: TCustomIniFile; Sec: string);
begin
  if not Assigned(ini) then
    Exit;
  Ini.WriteString(Sec, 'Name', Name);
  Ini.WriteString(Sec, 'PhyName', PhyName);
  Ini.WriteInteger(Sec, 'FieldType', Integer(FieldType));
  Ini.WriteInteger(Sec, 'FieldLen', FieldLen);
  Ini.WriteInteger(Sec, 'FieldScal', FieldScal);
  Ini.WriteString(Sec, 'FieldTypeEx', FieldTypeEx);
  Ini.WriteString(Sec, 'Comment', Comment);
  Ini.WriteBool(Sec, 'Nullable', Nullable);
  Ini.WriteString(Sec, 'Editor', Editor);
  Ini.WriteInteger(Sec, 'IndexType', IndexType);
end;

procedure TDMLField.SaveToStream(AStream: TStream);
begin
  Stream_WriteString(AStream, Name);
  Stream_WriteString(AStream, PhyName);
  Stream_WriteInteger(AStream, Integer(FieldType));
  Stream_WriteInteger(AStream, FieldLen);
  Stream_WriteInteger(AStream, FieldScal);
  Stream_WriteString(AStream, FieldTypeEx);
  Stream_WriteString(AStream, Comment);
  Stream_WriteBool(AStream, Nullable);
  Stream_WriteString(AStream, Editor);
  Stream_WriteInteger(AStream, IndexType);
end;

{ TDMLTextObj }

procedure TDMLTextObj.CheckResize;
var
  I, L: Integer;
  SS: TStrings;
  WS, WT: WideString;
  S, T: string;
begin
  inherited;
  if FBriefMode then
  begin
    Exit;
  end;
  if AutoSize then
  begin
    SS := TStringList.Create;
    try
      SS.Text := FComment;

      I := 0;
      while I < SS.Count do
      begin
        S := SS[I];
        if Length(S) > 100 then
        begin
          L := 100;
          WS := S;
          while True do
          begin
            WT := Copy(WS, 1, L);
            T := WT;
            if Length(T) > 100 then
              Dec(L)
            else
              Break;
          end;
          S := Copy(WS, L + 1, Length(WS));
          SS[I] := S;
          SS.Insert(I, T);
        end;
        Inc(I);
      end;
      FDrawComment := SS.Text;

      Width := 120;
      Height := 80;
      if Height < SS.Count * 14 + 10 then
        Height := Round(SS.Count * 14 + 10);
      for I := 0 to SS.Count - 1 do
      begin
        L := DmlStrLength(SS[I]);
        if Width < L * 6.1 + 4 then
          Width := Round(L * 6.1 + 4);
      end;
      if Width > 320 then
        Width := 320;
      if Height > 480 then
        Height := 480;
    finally
      SS.Free;
    end;
  end;
end;

constructor TDMLTextObj.Create;
begin
  inherited;
  FDrawSelectGrips := True;
  FObjType := 'TEXT';
  RowHeight := 13;
  BorderColor := RGB(222, 111, 111);
end;

procedure TDMLTextObj.Load(Ini: TCustomIniFile; Sec: string);
begin
  inherited;
  CheckResize;
end;

procedure TDMLTextObj.LoadFromStream(AStream: TStream);
begin
  inherited;
  CheckResize;
end;

procedure TDMLTextObj.PaintTo(const ADrawer: TDMLDrawer);
var
  pR: TRect;
begin
  if FBriefMode then
  begin
    inherited;
    Exit;
  end;
  if not Assigned(ADrawer) then
    Exit;
  if not RectTouchObj(ADrawer.BoundLeft, ADrawer.BoundTop,
    ADrawer.BoundWidth, ADrawer.BoundHeight) then
    Exit;
  with ADrawer.Canvas do
  begin
    if Brush.Style <> FFillStyle then
      Brush.Style := FFillStyle;
    if Brush.Color <> FFillColor then
      Brush.Color := FFillColor;
    if Pen.Style <> FBorderStyle then
      Pen.Style := FBorderStyle;
    if Pen.Color <> FBorderColor then
      Pen.Color := FBorderColor;
    if Pen.Width <> FBorderWidth then
      Pen.Width := FBorderWidth;

    pR := Rect(ADrawer.GetX(Left), ADrawer.GetY(Top),
      ADrawer.GetX(Left + Self.Width), ADrawer.GetY(Top + Self.Height));
    Rectangle(pR);
    if Brush.Style <> bsClear then
      Brush.Style := bsClear;
    Font.Height := ADrawer.GetFontH;
    Font.Color := TextColor;
    pR.Left := pR.Left + 4;
    pR.Top := pR.Top + 4;
    pR.Right := pR.Right - 2;
    pR.Bottom := pR.Bottom - 2;

    if not ADrawer.FFastDrawMode and (Abs(Font.Height) > 3) then
    begin
      if FDrawComment <> '' then
        DrawText(ADrawer.Canvas.Handle, PChar(FDrawComment), Length(FDrawComment), pR, DT_LEFT or DT_NOPREFIX)
      else
        DrawText(ADrawer.Canvas.Handle, PChar(FComment), Length(FComment), pR, DT_LEFT or DT_NOPREFIX);
    end;

    DrawSelectedGrips(ADrawer);
  end;
end;

procedure TDMLTextObj.SetID(const Value: Integer);
begin
  FID := Value;
  if FName = ClassName then
    FName := srText + IntToStr(FID);
end;

{ TDMLLinkObj }

procedure TDMLLinkObj.CalculateArr(const FH: boolean; const Fo1, Fo2: TDMLPoint; var Points: array of TDMLPoint);
begin
  if FH then
  begin
    if (Fo1.X < fo2.X) then
    begin
      points[0] := Fo2;
      points[1].X := Fo2.x - 8;
      points[1].Y := fo2.y - 5;
      points[2].X := fo2.x - 8;
      points[2].Y := fo2.y + 5;
      points[3] := points[0];
    end
    else
    begin
      points[0] := Fo2;
      Points[1].X := Fo2.X + 8;
      points[1].Y := Fo2.Y - 5;
      points[2].X := Fo2.X + 8;
      points[2].Y := Fo2.Y + 5;
      points[3] := points[0];
    end;
  end
  else
  begin
    if (Fo1.Y < fo2.Y) then
    begin
      Points[0] := Fo2;
      Points[1].X := Fo2.X + 5;
      points[1].Y := fo2.Y - 8;
      points[2].X := fo2.X - 5;
      points[2].Y := fo2.Y - 8;
      points[3] := points[0];
    end
    else
    begin
      points[0] := Fo2;
      Points[1].X := Fo2.X + 5;
      points[1].Y := Fo2.Y + 8;
      points[2].X := Fo2.X - 5;
      points[2].Y := Fo2.Y + 8;
      points[3] := points[0];
    end;
  end;
end;

procedure TDMLLinkObj.CheckLineAlign;
var
  dd: Double;
begin

  case FClickPos of
    1:
      begin
        if FHorz1 and FHorz2 then
        begin
          if Abs(FP1.Y - FP3.Y) < 8 then
          begin
            dd := FP4.Y - FP1.Y;
            FP1.Y := FP1.Y + dd;
            FP2.Y := FP2.Y + dd;
            FHookP1.Y := FHookP1.Y + dd;
            FPMod_OP2 := True;
          end;
        end;
        if not FHorz1 and not FHorz2 then
        begin
          if Abs(FP1.X - FP3.X) < 8 then
          begin
            dd := FP4.X - FP1.X;
            FP1.X := FP1.X + dd;
            FP2.X := FP2.X + dd;
            FHookP1.X := FHookP1.X + dd;
            FPMod_OP2 := True;
          end;
        end;
      end;

    3:
      begin
        if FHorz1 and FHorz2 then
        begin
          if Abs(FP1.Y - FP3.Y) < 8 then
          begin
            dd := FP1.Y - FP4.Y;
            FP4.Y := FP4.Y + dd;
            FP3.Y := FP3.Y + dd;
            FHookP2.Y := FHookP2.Y + dd;
            FPMod_OP1 := True;
          end;
        end;
        if not FHorz1 and not FHorz2 then
        begin
          if Abs(FP1.X - FP3.X) < 8 then
          begin
            dd := FP1.X - FP4.X;
            FP4.X := FP4.X + dd;
            FP3.X := FP3.X + dd;
            FHookP2.X := FHookP2.X + dd;
            FPMod_OP1 := True;
          end;
        end;
      end;
  end;
end;

procedure TDMLLinkObj.CheckMoved(Obj: TDMLEntityObj; DX, DY: Double);
  procedure MoveDMLPoint(var ADMLPoint: TDMLPoint; AX, AY: Double);
  begin
    ADMLPoint.X := ADMLPoint.X + AX;
    ADMLPoint.Y := ADMLPoint.Y + AY;
  end;
begin
  if not Assigned(FObj1) or not Assigned(FObj2) then
    Exit;
  if FObj1.Selected and FObj2.Selected then
  begin
    if Obj = FObj1 then
    begin
      MoveDMLPoint(FP1, DX, DY);
      MoveDMLPoint(FP2, DX, DY);
      MoveDMLPoint(FP3, DX, DY);
      MoveDMLPoint(FP4, DX, DY);
      MoveDMLPoint(FBFHookP1, DX, DY);
      MoveDMLPoint(FBFHookP2, DX, DY);
      Left := Left + DX;
      Top := Top + DY;
    end;
  end
  else
  begin
    CheckPosition;
  end;
end;

function calAttPos(a1, a2, b1, b2, edge, def: Double; LnkIdx1, LnkIdx2: Integer): Double;
var
  t, da, db, dd, edist, idxDist1, idxDist2: Double;
begin
  Result := def;

  idxDist1 := LnkIdx1 * 8;

  idxDist2 := LnkIdx2 * 8;

  if a1 > a2 then
  begin
    t := a1;
    a1 := a2;
    a2 := t;
  end;
  da := a2 - a1;

  if b1 > b2 then
  begin
    t := b1;
    b1 := b2;
    b2 := t;
  end;
  db := b2 - b1;

  if edge < 2 then
    edge := 2;

  if da < edge * 2.0 then
  begin
    Result := a1 + da / 2.0 + idxDist1;
    Exit;
  end;

  a1 := a1 + edge;
  a2 := a2 - edge;

  if db < edge * 2.0 then
  begin
    b1 := b1 + db / 2.0;
    b2 := b1;
  end
  else
  begin
    b1 := b1 + edge;
    b2 := b2 - edge;
  end;

  da := a2 - a1;
  db := b2 - b1;

  if (b1 <= a1) and (a2 <= b2) then
  begin

    Result := a1 + da / 2.0 + idxDist1;
    Exit;
  end;

  if (a1 <= b1) and (b2 <= a2) then
  begin

    Result := b1 + db / 2.0 + idxDist2;
    Exit;
  end;

  if (b1 <= a1) and (a1 <= b2) and (b2 <= a2) then
  begin
    Result := a1 + (b2 - a1) / 2.0;
    Exit;
  end;

  if (a1 <= b1) and (b1 <= a2) and (a2 <= b2) then
  begin
    Result := b1 + (a2 - b1) / 2.0;
    Exit;
  end;

  edist := da / 2 - 8;

  if (a2 < b1) then
  begin
    if LnkIdx1 * 8 < edist then
      Result := a2 - LnkIdx1 * 8
    else
      Result := a2 - edist;

    dd := b1 - a2;
    t := 20;
    t := edge * t / (dd / t + t);
    if t > edge then
      t := edge;
    if t < 0 then
      ;

    Exit;
  end;

  if (b2 < a1) then
  begin
    if LnkIdx1 * 8 < edist then
      Result := a1 + LnkIdx1 * 8
    else
      Result := a1 + edist;

    dd := a1 - b2;
    t := 20;
    t := edge * t / (dd / t + t);
    if t > edge then
      t := edge;
    if t < 0 then
      ;

    Exit;
  end;

end;

function checkMoveLinkDist(obj, obj2: TDMLEntityObj; link: TDMLLinkObj; var dp: TDMLPoint): Boolean;
var
  I, J, C, CC, dx, dy: Integer;
  item: TDMLLinkObj;
  ap: TDMLPoint;
  bNearX, bNearY: Boolean;
begin

  Result := False;
  C := obj.Links.Count;
  ap.X := dp.X - obj.Left;
  ap.Y := dp.Y - obj.Top;
  dx := 0;
  dy := 0;
  CC := C;
  if obj2 <> nil then
    CC := CC + obj2.Links.Count;
  for J := 0 to CC * 5 + 10 do
  begin
    bNearX := False;
    bNearY := False;
    for I := 0 to C - 1 do
    begin
      item := TDMLLinkObj(obj.Links.Items[I]);
      if item = link then
        Continue;
      if item.FObj1 = obj then
      begin
        if item.FHorz1 then
        begin
          if Abs(item.FHookP1.Y - ap.Y) < 6 then
            bNearY := True;
        end
        else
          if Abs(item.FHookP1.X - ap.X) < 6 then
            bNearX := True;
      end
      else if item.FObj2 = obj then
      begin
        if item.FHorz2 then
        begin
          if Abs(item.FHookP2.Y - ap.Y) < 6 then
            bNearY := True;
        end
        else
          if Abs(item.FHookP2.X - ap.X) < 6 then
            bNearX := True;
      end;
    end;

    if obj2 <> nil then
      for I := 0 to obj2.Links.Count - 1 do
      begin
        item := TDMLLinkObj(obj2.Links.Items[I]);
        if item = link then
          Continue;
        if item.FObj1 = obj2 then
        begin
          if item.FHorz1 then
          begin
            if Abs((item.FHookP1.Y + obj2.Top) - (ap.Y + obj.Top)) < 6 then
              bNearY := True;
          end
          else
            if Abs((item.FHookP1.X + obj2.Left) - (ap.X + obj.Left)) < 6 then
              bNearX := True;
        end
        else if item.FObj2 = obj2 then
        begin
          if item.FHorz2 then
          begin
            if Abs((item.FHookP2.Y + obj2.Top) - (ap.Y + obj.Top)) < 6 then
              bNearY := True;
          end
          else
            if Abs((item.FHookP2.X + obj2.Left) - (ap.X + obj.Left)) < 6 then
              bNearX := True;
        end;
      end;

    if bNearX then
      Inc(dx)
    else if bNearY then
      Inc(dy)
    else if (ap.X < 6) or (ap.X > Obj.Width - 6) then
      Inc(dx)
    else if (ap.Y < 6) or (ap.Y > Obj.Height - 6) then
      Inc(dy)
    else
    begin
      dp.X := ap.X + obj.Left;
      dp.Y := ap.Y + obj.Top;
      Exit;
    end;
    Result := True;
    if (dx mod 2) = 0 then
      ap.X := dp.X - obj.Left + 3 * dx
    else
      ap.X := dp.X - obj.Left - 3 * dx;
    if (dy mod 2) = 0 then
      ap.Y := dp.Y - obj.Top + 3 * dy
    else
      ap.Y := dp.Y - obj.Top - 3 * dy;
  end;
  Result := False;
end;

procedure calLinkAttachPointV2(obj1, obj2: TDMLEntityObj; link: TDMLLinkObj; var a1, a2: TDMLPoint);
const
  DEF_LINK_EDGE_SPACE = 20;
var
  LnkIdx1, LnkIdx2: Integer;
begin

  LnkIdx1 := obj1.Links.IndexOf(link);
  LnkIdx2 := obj2.Links.IndexOf(link);

  a1.x := calAttPos(obj1.Left, obj1.Left + obj1.Width, obj2.Left, obj2.Left + obj2.Width, DEF_LINK_EDGE_SPACE, a1.x, LnkIdx1, LnkIdx2);

  a1.y := calAttPos(obj1.Top, obj1.Top + obj1.Height, obj2.Top, obj2.Top + obj2.Height, DEF_LINK_EDGE_SPACE, a1.y, LnkIdx1, LnkIdx2);

  a2.x := calAttPos(obj2.Left, obj2.Left + obj2.Width, obj1.Left, obj1.Left + obj1.Width, DEF_LINK_EDGE_SPACE, a2.x, LnkIdx2, LnkIdx1);

  a2.y := calAttPos(obj2.Top, obj2.Top + obj2.Height, obj1.Top, obj1.Top + obj1.Height, DEF_LINK_EDGE_SPACE, a2.y, LnkIdx2, LnkIdx1);

  if (Abs(a1.X - a2.X) < 1.1) or (Abs(a1.Y - a2.Y) < 1.1) then
  begin
    checkMoveLinkDist(obj1, obj2, link, a1);
    checkMoveLinkDist(obj2, obj1, link, a2);
  end
  else
  begin
    checkMoveLinkDist(obj1, nil, link, a1);
    checkMoveLinkDist(obj2, nil, link, a2);
  end;

  a1.x := Round(a1.x);
  a1.y := Round(a1.y);
  a2.x := Round(a2.x);
  a2.y := Round(a2.y);
end;

procedure TDMLLinkObj.CheckPosition;
begin
  if (FOwnerList <> nil) and (FOwnerList.DMLDrawer <> nil) then
  begin
    if FOwnerList.FLinksUpdateCounter = 0 then
    begin
      if FOwnerList.DMLDrawer.FIsHugeMode then
      begin
        if FOwnerList.DMLDrawer.FLinkOptimizeLevel > 1 then
          CheckPositionEx(True, True, 1)
        else
          CheckPositionEx(True, True, FOwnerList.DMLDrawer.FLinkOptimizeLevel);
      end
      else
        CheckPositionEx(True, True, FOwnerList.DMLDrawer.FLinkOptimizeLevel);
    end;
  end
  else
    CheckPositionEx(True, True, 2);
end;

procedure TDMLLinkObj.CheckPositionEx(bRecheck, bCanNoun: Boolean; iOptimize: Integer);
  function IsOppAngle(obj1, obj2: TDMLEntityObj): Boolean;
  var
    a1, a2, b1, b2, tol: Double;
    bFarX: Boolean;
  begin
    Result := False;
    if obj1.Width >= obj2.Width then
      tol := obj1.Width
    else
      tol := obj2.Width;

    a1 := obj1.Left;
    a2 := obj1.Left + obj1.Width;
    b1 := obj2.Left;
    b2 := obj2.Left + obj2.Width;
    if (a2 >= b1) and (a2 <= b2) then
      Exit;
    if (a1 >= b1) and (a1 <= b2) then
      Exit;
    if (b2 >= a1) and (b2 <= a2) then
      Exit;
    if (b1 >= a1) and (b1 <= a2) then
      Exit;
    bFarX := False;
    if (a1 <= b1) and (a2 <= b1) and (a2 + tol < b1) then
      bFarX := True;
    if (a1 >= b2) and (a2 >= b2) and (a1 - tol > b2) then
      bFarX := True;

    a1 := obj1.Top;
    a2 := obj1.Top + obj1.Height;
    b1 := obj2.Top;
    b2 := obj2.Top + obj2.Height;
    if (a2 >= b1) and (a2 <= b2) then
      Exit;
    if (a1 >= b1) and (a1 <= b2) then
      Exit;
    if (b2 >= a1) and (b2 <= a2) then
      Exit;
    if (b1 >= a1) and (b1 <= a2) then
      Exit;
    if bFarX then
    begin
      if (a1 <= b1) and (a2 <= b1) and (a2 + tol < b1) then
        Exit;
      if (a1 >= b2) and (a2 >= b2) and (a1 - tol > b2) then
        Exit;
    end;

    Result := True;
  end;

  function IsObjProjOverlay(obj1, obj2: TDMLEntityObj; bHorz: Boolean): Boolean;
  var
    a1, a2, b1, b2, tol: Double;
  begin
    tol := 4;
    if bHorz then
    begin
      a1 := obj1.Left;
      a2 := obj1.Left + obj1.Width;
      b1 := obj2.Left;
      b2 := obj2.Left + obj2.Width;
    end
    else
    begin
      a1 := obj1.Top;
      a2 := obj1.Top + obj1.height;
      b1 := obj2.Top;
      b2 := obj2.Top + obj2.height;
    end;
    if (a1 < b1 - tol) and (a2 < b1 - tol) then
      Result := False
    else if (a1 > b2 + tol) and (a2 > b2 + tol) then
      Result := False
    else
      Result := True;
  end;
  function GetPosDX(Obj: TDMLEntityObj): Integer;
  var
    idx, dmax: Integer;
  begin
    idx := Obj.Links.IndexOf(Self);
    Result := idx * 8;
    dmax := Round(Obj.Width / 2) - 10;
    if dmax < 10 then
      dmax := 10;
    if Result > dmax then
      Result := Random(dmax);
    if (idx mod 2) = 0 then
      Result := -Result;
  end;
  function GetPosDY(Obj: TDMLEntityObj): Integer;
  var
    idx, dmax: Integer;
  begin
    idx := Obj.Links.IndexOf(Self);
    Result := idx * 8;
    dmax := Round(Obj.Height / 2) - 10;
    if dmax < 10 then
      dmax := 10;
    if Result > dmax then
      Result := Random(dmax);
    if (idx mod 2) = 0 then
      Result := -Result;
  end;
var
  bNeedRecheck: Boolean;
  a1, a2: TDMLPoint;
  ii: Integer;
  dx, dy: Double;
begin
  if not Assigned(FObj1) or not Assigned(FObj2) then
    Exit;

  if FBriefMode then
  begin

    a1.X := Round(FObj1.Left + FObj1.Width / 2);
    a1.Y := Round(FObj1.Top + FObj1.Height / 2);
    a2.X := Round(FObj2.Left + FObj2.Width / 2);
    a2.Y := Round(FObj2.Top + FObj2.Height / 2);

    if Abs(a2.X - a1.X) <= 0.0005 then
    begin
      FBFHookP1.X := a1.X;
      if a1.Y < a2.Y then
        FBFHookP1.Y := a1.Y + FObj1.Height / 2
      else
        FBFHookP1.Y := a1.Y - FObj1.Height / 2;

      FBFHookP2.X := a2.X;
      if a1.Y < a2.Y then
        FBFHookP2.Y := a2.Y - FObj2.Height / 2
      else
        FBFHookP2.Y := a2.Y - FObj2.Height / 2;
    end
    else if Abs(a2.Y - a1.Y) <= 0.0005 then
    begin
      FBFHookP1.Y := a1.Y;
      if a1.X < a2.X then
        FBFHookP1.X := a1.X + FObj1.Width / 2
      else
        FBFHookP1.X := a1.X - FObj1.Width / 2;

      FBFHookP2.Y := a2.Y;
      if a1.X < a2.X then
        FBFHookP2.X := a2.X - FObj2.Width / 2
      else
        FBFHookP2.X := a2.X - FObj2.Width / 2;
    end
    else
    begin

      dy := Abs((FObj1.Width / 2) * (a2.Y - a1.Y) / (a2.X - a1.X));
      dx := Abs((FObj1.Height / 2) * (a2.X - a1.X) / (a2.Y - a1.Y));
      if dy > FObj1.Height / 2 then
      begin

        if a1.X < a2.X then
          FBFHookP1.X := a1.X + dx
        else
          FBFHookP1.X := a1.X - dx;
        if a1.Y < a2.Y then
          FBFHookP1.Y := a1.Y + FObj1.Height / 2
        else
          FBFHookP1.Y := a1.Y - FObj1.Height / 2;
      end
      else
      begin

        if a1.X < a2.X then
          FBFHookP1.X := a1.X + FObj1.Width / 2
        else
          FBFHookP1.X := a1.X - FObj1.Width / 2;
        if a1.Y < a2.Y then
          FBFHookP1.Y := a1.Y + dy
        else
          FBFHookP1.Y := a1.Y - dy;
      end;

      dy := Abs((FObj2.Width / 2) * (a1.Y - a2.Y) / (a1.X - a2.X));
      dx := Abs((FObj2.Height / 2) * (a1.X - a2.X) / (a1.Y - a2.Y));
      if dy > FObj2.Height / 2 then
      begin

        if a2.X < a1.X then
          FBFHookP2.X := a2.X + dx
        else
          FBFHookP2.X := a2.X - dx;
        if a2.Y < a1.Y then
          FBFHookP2.Y := a2.Y + FObj2.Height / 2
        else
          FBFHookP2.Y := a2.Y - FObj2.Height / 2;
      end
      else
      begin

        if a2.X < a1.X then
          FBFHookP2.X := a2.X + FObj2.Width / 2
        else
          FBFHookP2.X := a2.X - FObj2.Width / 2;
        if a2.Y < a1.Y then
          FBFHookP2.Y := a2.Y + dy
        else
          FBFHookP2.Y := a2.Y - dy;
      end;
    end;
    Exit;
  end;

  a1.X := Round(FObj1.Left + FObj1.Width / 2 + GetPosDX(FObj1));
  a1.Y := Round(FObj1.Top + FObj1.Height / 2 + GetPosDY(FObj1));
  a2.X := Round(FObj2.Left + FObj2.Width / 2 + GetPosDX(FObj2));
  a2.Y := Round(FObj2.Top + FObj2.Height / 2 + GetPosDY(FObj2));

  calLinkAttachPointV2(FObj1, FObj2, Self, a1, a2);

  if iOptimize > 0 then
  begin
    if not FPMod_OP1 then
    begin
      FP1 := a1;
      FHookP1.X := a1.X - FObj1.Left;
      FHookP1.Y := a1.Y - FObj1.Top;
    end;
    if not FPMod_OP2 then
    begin
      FP4 := a2;
      FHookP2.X := a2.X - FObj2.Left;
      FHookP2.Y := a2.Y - FObj2.Top;
    end;
  end;

  if (FHookP1.X < 1) or (FHookP1.X >= FObj1.Width) then
  begin
    if a1.X < a2.X then
      FHookP1.X := FObj1.Width
    else
      FHookP1.X := 1;
  end;
  if (FHookP1.Y < 1) or (FHookP1.Y >= FObj1.Height) then
  begin
    if a1.Y < a2.Y then
      FHookP1.Y := FObj1.Height
    else
      FHookP1.Y := 1;
  end;

  if (FHookP2.X < 1) or (FHookP2.X >= FObj2.Width) then
  begin
    if a1.X > a2.X then
      FHookP2.X := FObj2.Width
    else
      FHookP2.X := 1;
  end;
  if (FHookP2.Y < 1) or (FHookP2.Y >= FObj2.Height) then
  begin
    if a1.Y > a2.Y then
      FHookP2.Y := FObj2.Height
    else
      FHookP2.Y := 1;
  end;

  bNeedRecheck := False;

  if FPosInfoLoaded then
  begin
    if FObj1.PointInObj(FP2.X, FP2.Y) or FObj2.PointInObj(FP3.X, FP3.Y) then
      FPosInfoLoaded := False;
  end;

  if not FPMod_CP and (iOptimize > 0) and not FPosInfoLoaded then
  begin

    if not FPMod_OP1 and not FPMod_OP2 and bCanNoun and IsOppAngle(FObj1, FObj2) then
    begin
      if (Self.FLinkType = dmllFKNormal) and (FObj1.Height <= FObj2.Height * 3) and (FObj2.Height * 2 > FObj2.Width) then
      begin

        FHorz1 := False;
        FHorz2 := True;
      end

      else if FObj1.Height >= FObj2.Height then
      begin
        FHorz1 := True;
        FHorz2 := False;
      end
      else
      begin
        FHorz1 := False;
        FHorz2 := True;
      end;

      for ii := 0 to 1 do
      begin
        if FHorz1 then
        begin
          if FObj1.Left + FObj1.Width < FObj2.Left then
            FP1.X := FObj1.Left + FObj1.Width
          else
            FP1.X := FObj1.Left;
          FP1.Y := a1.y;

          FP2.Y := FP1.Y;

          FP3.Y := FP2.Y;
        end
        else
        begin
          if FObj1.Top + FObj1.Height < FObj2.Top then
            FP1.Y := FObj1.Top + FObj1.Height
          else
            FP1.Y := FObj1.Top;
          FP1.X := a1.x;

          FP2.X := FP1.X;

          FP3.X := FP2.X;
        end;

        if FHorz2 then
        begin
          if FObj2.Left > FObj1.Left + FObj1.Width then
            FP4.X := FObj2.Left
          else
            FP4.X := FObj2.Left + FObj2.Width;
          FP4.Y := a2.y;

          FP3.Y := FP4.Y;

          FP2.Y := FP3.Y;
        end
        else
        begin
          if FObj2.Top > FObj1.Top + FObj1.Height then
            FP4.Y := FObj2.Top
          else
            FP4.Y := FObj2.Top + FObj2.Height;
          FP4.X := a2.x;

          FP3.X := FP4.X;

          FP2.X := FP3.X;
        end;

        if (ii = 0) and (FOwnerList.FindEntityAt(FP2.X, FP2.Y) >= 0) then
        begin
          FHorz1 := not FHorz1;
          FHorz2 := not FHorz2;
        end
        else
          Break;

      end;
    end

    else if (Abs(a1.X - a2.X) > Abs(a1.Y - a2.Y)) or IsObjProjOverlay(FObj1, FObj2, False) then
    begin

      FHorz1 := True;
      FHorz2 := True;
      if FObj1.Left < FObj2.Left then
        FP1.X := FObj1.Left + FObj1.Width
      else
        FP1.X := FObj1.Left;
      if not FPMod_OP1 or (FHookP1.Y = 0) then
        FP1.Y := a1.y
      else
        FP1.Y := FObj1.Top + FHookP1.Y;

      if FObj1.Left > FObj2.Left then
        FP4.X := FObj2.Left + FObj2.Width
      else
        FP4.X := FObj2.Left;
      if not FPMod_OP2 or (FHookP2.Y = 0) then
        FP4.Y := a2.y
      else
        FP4.Y := FObj2.Top + FHookP2.Y;

      FP2.X := Round((FP1.X + FP4.X) / 2);
      FP2.Y := FP1.Y;
      FP3.X := Round((FP1.X + FP4.X) / 2);
      FP3.Y := FP4.Y;
    end
    else
    begin
      FHorz1 := False;
      FHorz2 := False;
      if FObj1.Top < FObj2.Top then
        FP1.Y := FObj1.Top + FObj1.Height
      else
        FP1.Y := FObj1.Top;
      if not FPMod_OP1 or (FHookP1.X = 0) then
        FP1.X := a1.x
      else
        FP1.X := FObj1.Left + FHookP1.X;

      if FObj1.Top > FObj2.Top then
        FP4.Y := FObj2.Top + FObj2.Height
      else
        FP4.Y := FObj2.Top;
      if not FPMod_OP2 or (FHookP2.X = 0) then
        FP4.X := a2.x
      else
        FP4.X := FObj2.Left + FHookP2.X;

      FP2.X := FP1.X;
      FP2.Y := Round((FP1.Y + FP4.Y) / 2);
      FP3.X := FP4.X;
      FP3.Y := Round((FP1.Y + FP4.Y) / 2);
    end;
  end
  else
  begin

    if FHorz1 then
    begin
      if FObj1.Left + FObj1.Width < FP3.X then
        FP1.X := FObj1.Left + FObj1.Width
      else
        FP1.X := FObj1.Left;
      if not FPMod_OP1 or (FHookP1.Y = 0) then
        FP1.Y := a1.y
      else
        FP1.Y := FObj1.Top + FHookP1.Y;

      FP2.Y := FP1.Y;
      if not FHorz2 then
        FP3.Y := FP2.Y;
    end
    else
    begin
      if FObj1.Top + FObj1.Height < FP3.Y then
        FP1.Y := FObj1.Top + FObj1.Height
      else
        FP1.Y := FObj1.Top;
      if not FPMod_OP1 or (FHookP1.X = 0) then
        FP1.X := a1.x
      else
        FP1.X := FObj1.Left + FHookP1.X;

      FP2.X := FP1.X;
      if FHorz2 then
        FP3.X := FP2.X;
    end;

    if FHorz2 then
    begin
      if FObj2.Left > FP2.X then
        FP4.X := FObj2.Left
      else
        FP4.X := FObj2.Left + FObj2.Width;
      if not FPMod_OP2 or (FHookP2.Y = 0) then
        FP4.Y := a2.y
      else
        FP4.Y := FObj2.Top + FHookP2.Y;

      FP3.Y := FP4.Y;
      if not FHorz1 then
        FP2.Y := FP3.Y;
    end
    else
    begin
      if FObj2.Top > FP2.Y then
        FP4.Y := FObj2.Top
      else
        FP4.Y := FObj2.Top + FObj2.Height;
      if not FPMod_OP2 or (FHookP2.X = 0) then
        FP4.X := a2.x
      else
        FP4.X := FObj2.Left + FHookP2.X;

      FP3.X := FP4.X;
      if FHorz1 then
        FP2.X := FP3.X;
    end;

  end;

  if bRecheck and FMoving then
  begin

    if FObj1.PointInObj(FP2.X, FP2.Y) then
    begin
      if FObj1.PointInObj(FP3.X, FP3.Y) then
      begin
        FPMod_CP := False;

        bNeedRecheck := True;
      end
      else if FObj2.PointInObj(FP3.X, FP3.Y) then
      begin
        if (FClickPos = 244) or (FClickPos = 660) then
        begin
          FPMod_CP := True;
          FPMod_OP1 := True;
          FPMod_OP2 := True;
          FClickPos := 1;
          FHorz1 := not FHorz1;
          FHorz2 := FHorz1;
        end
        else
          FPMod_CP := False;
        bNeedRecheck := True;
      end
      else
      begin
        FHorz1 := not FHorz2;

        bNeedRecheck := True;
      end;
    end
    else if FObj2.PointInObj(FP3.X, FP3.Y) then
    begin
      if FObj2.PointInObj(FP2.X, FP2.Y) then
      begin
        FPMod_CP := False;

        bNeedRecheck := True;
      end
      else
      begin
        FHorz2 := not FHorz1;

        bNeedRecheck := True;
      end;
    end;

  end
  else if bReCheck then
  begin

    if FObj1.PointInObj(FP2.X, FP2.Y) or FObj1.PointInObj(FP3.X, FP3.Y)
      or FObj2.PointInObj(FP2.X, FP2.Y) or FObj2.PointInObj(FP3.X, FP3.Y) then
    begin
      FPMod_CP := False;
      bNeedRecheck := True;
    end;
  end;

  if bNeedRecheck and bRecheck then
  begin
    CheckPositionEx(False, True, iOptimize);
    Exit;
  end;

  begin
    if not FHorz1 then
    begin
      if not FPMod_OP1 or (FHookP1.X = 0) then
        FHookP1.X := FP1.X - FObj1.Left;
    end
    else if not FPMod_OP1 or (FHookP1.Y = 0) then
      FHookP1.Y := FP1.Y - FObj1.Top;
    if not FHorz2 then
    begin
      if not FPMod_OP2 or (FHookP2.X = 0) then
        FHookP2.X := FP4.X - FObj2.Left;
    end
    else if not FPMod_OP2 or (FHookP2.Y = 0) then
      FHookP2.Y := FP4.Y - FObj2.Top;
  end;

  if FP1.X <= FP4.X then
    Left := FP1.X - 2
  else
    Left := FP4.X - 2;
  if FP1.Y <= FP4.Y then
    Top := FP1.Y - 2
  else
    Top := FP4.Y - 2;
  Width := Abs(FP4.X - FP1.X) + 4;
  Height := Abs(FP4.Y - FP1.Y) + 4;
end;
       
procedure TDMLLinkObj.CheckLoadedPos;
  function CalNearVal(val, start, dist: double; bEdge: Boolean): Double;
  var
    d1, d2: Double;
  begin
    if val<=start then
      Result := start
    else if val>=start+dist then
      Result := start+dist
    else
    begin
      Result := val;
      if bEdge then
      begin
        d1 := Abs(val-start);
        d2 := Abs(start+dist-val);
        if d1<d2 then
          Result := start
        else
          Result := start+dist;
      end;
    end;
  end;
begin
  //检查附着点的位置应在对象边框上
  FP1.X := CalNearVal(FP1.X, FObj1.Left, FObj1.Width, FHorz1);
  FP1.Y := CalNearVal(FP1.Y, FObj1.Top, FObj1.Height, not FHorz1);

  FP4.X := CalNearVal(FP4.X, FObj2.Left, FObj2.Width, FHorz2);
  FP4.Y := CalNearVal(FP4.Y, FObj2.Top, FObj2.Height, not FHorz2);

  if FP1.X <= FP4.X then
    Left := FP1.X - 2
  else
    Left := FP4.X - 2;
  if FP1.Y <= FP4.Y then
    Top := FP1.Y - 2
  else
    Top := FP4.Y - 2;
  Width := Abs(FP4.X - FP1.X) + 4;
  Height := Abs(FP4.Y - FP1.Y) + 4;
end;

procedure TDMLLinkObj.CheckResize;
begin
  inherited;
end;

constructor TDMLLinkObj.Create;
begin
  inherited;

  FObjType := 'LINK';
  FDrawOnBackground := 1;
  FFillColor := clWhite;

end;

destructor TDMLLinkObj.Destroy;
begin
  if Assigned(FObj1) then
    FObj1.Links.Remove(Self);
  if Assigned(FObj2) then
    FObj2.Links.Remove(Self);
  inherited;
end;

procedure TDMLLinkObj.DoMove(DX, DY: Double);
  function GetPosDX(Obj: TDMLEntityObj): Integer;
  var
    idx, dmax: Integer;
  begin
    idx := Obj.Links.IndexOf(Self);
    Result := idx * 8;
    dmax := Round(Obj.Width / 2) - 10;
    if dmax < 10 then
      dmax := 10;
    if Result > dmax then
      Result := Random(dmax);
    if (idx mod 2) = 0 then
      Result := -Result;
  end;
  function GetPosDY(Obj: TDMLEntityObj): Integer;
  var
    idx, dmax: Integer;
  begin
    idx := Obj.Links.IndexOf(Self);
    Result := idx * 8;
    dmax := Round(Obj.Height / 2) - 10;
    if dmax < 10 then
      dmax := 10;
    if Result > dmax then
      Result := Random(dmax);
    if (idx mod 2) = 0 then
      Result := -Result;
  end;
var
  bNeedChange: Boolean;
begin
  if FMoving or FBriefMode then
    Exit;
  FMoving := True;
  try
    bNeedChange := False;
    case FClickPos of
      1:
        begin
          if FHorz1 then
          begin
            FP1.Y := FP1.Y + DY;
            FP2.Y := FP2.Y + DY;
            if FHookP1.Y <> 0 then
            begin
              FHookP1.Y := FHookP1.Y + DY;
              if FHookP1.Y <= 1 then
              begin
                FHookP1.Y := 1;
                if Assigned(FObj1) then
                  FHookP1.Y := Round(FObj1.Height / 2 + GetPosDY(FObj1));
                bNeedChange := True;
              end;
              if Assigned(FObj1) then
                if FHookP1.Y >= FObj1.Height then
                begin
                  FHookP1.Y := Round(FObj1.Height / 2 + GetPosDY(FObj1));
                  bNeedChange := True;
                end;
            end;
            if not FPMod_OP1 then
              if Assigned(FObj1) then
                FHookP1.X := Round(FObj1.Width / 2 + GetPosDX(FObj1));
            if not FPMod_OP1 and not FPMod_OP2 and not FPMod_CP and (FHorz1 = not FHorz2) then
            begin
              FPMod_OP1 := True;
              FPMod_OP2 := True;
              FPMod_CP := True;
            end
            else
              FPMod_OP1 := True;
          end
          else
          begin
            FP1.X := FP1.X + DX;
            FP2.X := FP2.X + DX;
            FHookP1.X := FHookP1.X + DX;
            if FHookP1.X <> 0 then
            begin
              if FHookP1.X <= 1 then
              begin
                FHookP1.X := 1;
                if Assigned(FObj1) then
                  FHookP1.X := Round(FObj1.Width / 2 + GetPosDX(FObj1));
                bNeedChange := True;
              end;
              if Assigned(FObj1) then
                if FHookP1.X > FObj1.Width then
                begin
                  FHookP1.X := Round(FObj1.Width / 2 + GetPosDX(FObj1));
                  bNeedChange := True;
                end;
            end;
            if not FPMod_OP1 then
              if Assigned(FObj1) then
                FHookP1.Y := Round(FObj1.Height / 2 + GetPosDY(FObj1));
            if not FPMod_OP1 and not FPMod_OP2 and not FPMod_CP and (FHorz1 = not FHorz2) then
            begin
              FPMod_OP1 := True;
              FPMod_OP2 := True;
              FPMod_CP := True;
            end
            else
              FPMod_OP1 := True;
          end;
          if bNeedChange then
          begin
            if FHorz1 = FHorz2 then
            begin
              FHorz1 := not FHorz1;
              FHorz2 := not FHorz2;
              FPMod_CP := True;
              FClickPos := 2;
              if FHorz1 then
                FP3.X := FP2.X
              else
                FP3.Y := FP2.Y;
            end
            else
            begin
              FHorz1 := not FHorz1;
              FPMod_CP := True;
              FClickPos := 2;
              if FHorz1 then
              begin
                FP2.Y := FP1.Y;
                FP3.X := FP2.X;
              end
              else
              begin
                FP2.X := FP1.X;
                FP3.Y := FP2.Y;
              end;
            end;
          end;

          CheckPosition;
        end;
      2:
        begin
          if FHorz1 = FHorz2 then
          begin
            if FHorz1 then
            begin
              FP2.X := FP2.X + DX;
              FP3.X := FP3.X + DX;
              FPMod_CP := True;
            end
            else
            begin
              FP2.Y := FP2.Y + DY;
              FP3.Y := FP3.Y + DY;
              FPMod_CP := True;
            end;
            CheckPosition;
          end;
        end;
      3:
        begin
          if FHorz2 then
          begin
            FP3.Y := FP3.Y + DY;
            FP4.Y := FP4.Y + DY;
            if FHookP2.Y <> 0 then
            begin
              FHookP2.Y := FHookP2.Y + DY;
              if FHookP2.Y <= 1 then
              begin
                FHookP2.Y := 1;
                if Assigned(FObj2) then
                  FHookP2.Y := Round(FObj2.Height / 2 + GetPosDY(FObj2));
                bNeedChange := True;
              end;
              if Assigned(FObj2) then
                if FHookP2.Y > FObj2.Height then
                begin
                  FHookP2.Y := Round(FObj2.Height / 2 + GetPosDY(FObj2));
                  bNeedChange := True;
                end;
            end;
            if not FPMod_OP2 then
              if Assigned(FObj1) then
                FHookP2.X := Round(FObj2.Width / 2 + GetPosDX(FObj2));
            if not FPMod_OP1 and not FPMod_OP2 and not FPMod_CP and (FHorz1 = not FHorz2) then
            begin
              FPMod_OP1 := True;
              FPMod_OP2 := True;
              FPMod_CP := True;
            end
            else
              FPMod_OP2 := True;
          end
          else
          begin
            FP3.X := FP3.X + DX;
            FP4.X := FP4.X + DX;
            if FHookP2.X <> 0 then
            begin
              FHookP2.X := FHookP2.X + DX;
              if FHookP2.X <= 1 then
              begin
                FHookP2.X := 1;
                if Assigned(FObj2) then
                  FHookP2.X := Round(FObj2.Width / 2 + GetPosDX(FObj2));
                bNeedChange := True;
              end;
              if Assigned(FObj2) then
                if FHookP2.X > FObj2.Width then
                begin
                  FHookP2.X := Round(FObj2.Width / 2 + GetPosDX(FObj2));
                  bNeedChange := True;
                end;
            end;
            if not FPMod_OP2 then
              if Assigned(FObj1) then
                FHookP2.Y := Round(FObj2.Height / 2 + GetPosDY(FObj2));
            if not FPMod_OP1 and not FPMod_OP2 and not FPMod_CP and (FHorz1 = not FHorz2) then
            begin
              FPMod_OP1 := True;
              FPMod_OP2 := True;
              FPMod_CP := True;
            end
            else
              FPMod_OP2 := True;
          end;
          if bNeedChange then
          begin
            if FHorz1 = FHorz2 then
            begin
              FHorz1 := not FHorz1;
              FHorz2 := not FHorz2;
              FPMod_CP := True;
              FClickPos := 2;
              if FHorz1 then
                FP2.X := FP3.X
              else
                FP2.Y := FP3.Y;
            end
            else
            begin
              FHorz2 := not FHorz2;
              FPMod_CP := True;
              FClickPos := 2;
              if FHorz2 then
              begin
                FP3.Y := FP4.Y;
                FP2.X := FP3.X;
              end
              else
              begin
                FP3.X := FP4.X;
                FP2.Y := FP3.Y;
              end;
            end;
          end;
          CheckPosition;
        end;
    end;

  finally
    FMoving := False;
  end;
end;

procedure TDMLLinkObj.DrawSelectedGrips(const ADrawer: TDMLDrawer);
  procedure DrawR(X, Y: Integer);
  const
    DML_GripWidth = 2;
  begin
    ADrawer.Canvas.Rectangle(Rect(X - DML_GripWidth, Y - DML_GripWidth, X + DML_GripWidth, Y + DML_GripWidth));
  end;
var
  L, T: Integer;
begin
  if not Selected or not Assigned(ADrawer) and not ADrawer.SkipDrawSelected then
    Exit;
  L := ADrawer.GetX((FP2.X + FP3.X) / 2);
  T := ADrawer.GetY((FP2.Y + FP3.Y) / 2);

  with ADrawer.Canvas do
  begin
    if Brush.Style <> bsSolid then
      Brush.Style := bsSolid;
    if Brush.Color <> ADrawer.SelectedColor then
      Brush.Color := ADrawer.SelectedColor;
    if Pen.Style <> psSolid then
      Pen.Style := psSolid;
    if Pen.Color <> ADrawer.SelectedColor then
      Pen.Color := ADrawer.SelectedColor;

    DrawR(L, T);
  end;
end;

procedure TDMLLinkObj.FindLinkObjs(Objs: TDMLObjList);
var
  I: Integer;
begin
  if not Assigned(Objs) then
    Exit;
  if FObj1 = nil then
    for I := 0 to Objs.Count - 1 do
      if Objs.Items[I].Name = FObj1_Name then
        if Objs.Items[I] is TDMLEntityObj then
          Obj1 := TDMLEntityObj(Objs[I]);

  if FObj2 = nil then
    for I := 0 to Objs.Count - 1 do
      if Objs.Items[I].Name = FObj2_Name then
        if Objs.Items[I] is TDMLEntityObj then
          Obj2 := TDMLEntityObj(Objs[I]);
end;

function TDMLLinkObj.GetDescText: string;
begin
  Result := FObj1_Name + ' - ' + FObj2_Name;
end;

function TDMLLinkObj.IsDefPosChanged: Boolean;
begin
  Result := FPMod_OP1 or FPMod_OP2;
end;

procedure TDMLLinkObj.Load(Ini: TCustomIniFile; Sec: string);
begin
  inherited;
  if not Assigned(ini) then
    Exit;

  FObj1_Name := Ini.ReadString(Sec, 'Obj1_Name', '');
  FObj2_Name := Ini.ReadString(Sec, 'Obj2_Name', '');

  FLinkType := TDMLLinkType(Ini.ReadInteger(Sec, 'LinkType', 0));

  FP1.X := Ini.ReadFloat(Sec, 'P1_X', 0);
  FP1.Y := Ini.ReadFloat(Sec, 'P1_Y', 0);
  FP2.X := Ini.ReadFloat(Sec, 'P2_X', 0);
  FP2.Y := Ini.ReadFloat(Sec, 'P2_Y', 0);
  FP3.X := Ini.ReadFloat(Sec, 'P3_X', 0);
  FP3.Y := Ini.ReadFloat(Sec, 'P3_Y', 0);
  FP4.X := Ini.ReadFloat(Sec, 'P4_X', 0);
  FP4.Y := Ini.ReadFloat(Sec, 'P4_Y', 0);

  FHookP1.X := Ini.ReadFloat(Sec, 'HookP1_X', FHookP1.X);
  FHookP1.Y := Ini.ReadFloat(Sec, 'HookP1_Y', FHookP1.Y);
  FHookP2.X := Ini.ReadFloat(Sec, 'HookP2_X', FHookP2.X);
  FHookP2.Y := Ini.ReadFloat(Sec, 'HookP2_Y', FHookP2.Y);

  FPMod_OP1 := Ini.ReadBool(Sec, 'PMod_OP1', False);
  FPMod_OP2 := Ini.ReadBool(Sec, 'PMod_OP2', False);
  FPMod_CP := Ini.ReadBool(Sec, 'PMod_CP', False);

  FHorz1 := Ini.ReadBool(Sec, 'FHorz1', FHorz1);
  FHorz2 := Ini.ReadBool(Sec, 'FHorz2', FHorz2);
end;

procedure TDMLLinkObj.LoadFromStream(AStream: TStream);
var
  I: Integer;
begin
  inherited;
  Stream_ReadString(AStream, FObj1_Name);
  Stream_ReadString(AStream, FObj2_Name);

  Stream_ReadInteger(AStream, I);
  FLinkType := TDMLLinkType(I);

  Stream_ReadDMLPoint(AStream, FP1);
  Stream_ReadDMLPoint(AStream, FP2);
  Stream_ReadDMLPoint(AStream, FP3);
  Stream_ReadDMLPoint(AStream, FP4);

  Stream_ReadDMLPoint(AStream, FHookP1);
  Stream_ReadDMLPoint(AStream, FHookP2);

  Stream_ReadBool(AStream, FPMod_OP1);
  Stream_ReadBool(AStream, FPMod_OP2);
  Stream_ReadBool(AStream, FPMod_CP);

  Stream_ReadBool(AStream, FHorz1);
  Stream_ReadBool(AStream, FHorz2);
end;

procedure TDMLLinkObj.PaintTo(const ADrawer: TDMLDrawer);
var
  Pa, Pb, Pc, Pd, PaH1, PaH2, PbH1, PbH2: TDMLPoint;
  cp1, cp2: TDMLPoint;
  dcp1, dcp2: TPoint;
  pfa0, pfa1, pfa2, pfa3, pfb1, pfb2, pfb3, pfb4: TDMLPoint;
  Psd: array[0..3] of TDMLPoint;
  psdtmp: array[0..3] of TPoint;
  Ps: array[0..3] of TPoint;
  I: Integer;
  D, xa, ya, xb, yb: Double;

const
  paD = 10;
  pfaD = 20;
  pfaR = 2;
  ARROWLEN = 12;
begin
  if not Assigned(ADrawer) then
    Exit;
  if not RectTouchObj(ADrawer.BoundLeft, ADrawer.BoundTop,
    ADrawer.BoundWidth, ADrawer.BoundHeight) then
    Exit;
  with ADrawer.Canvas do
  begin
    if Pen.Style <> FBorderStyle then
      Pen.Style := FBorderStyle;
    if Pen.Color <> FBorderColor then
      Pen.Color := FBorderColor;
    if Pen.Width <> FBorderWidth then
      Pen.Width := FBorderWidth;
    if Brush.Style <> FFillStyle then
      Brush.Style := FFillStyle;

    if Brush.Color <> FFillColor then
      Brush.Color := FFillColor;
  end;

  if FBriefMode then
    with ADrawer.Canvas do
    begin
      for I := 0 to 1 do
      begin
        if I = 1 then
        begin
          if not Selected or ADrawer.SkipDrawSelected then
            Exit;
          Pen.Color := ADrawer.SelectedColor;
          Pen.Width := FBorderWidth + 2;
          Pen.Mode := pmNotXor;
        end;
        MoveTo(ADrawer.GetX(FBFHookP1.X), ADrawer.GetY(FBFHookP1.Y));
        LineTo(ADrawer.GetX(FBFHookP2.X), ADrawer.GetY(FBFHookP2.Y));
        if (FLinkType = dmllFKNormal) or (FLinkType = dmllFKUnique) then
        begin
          D := Sqrt((FBFHookP1.Y - FBFHookP2.Y) * (FBFHookP1.Y - FBFHookP2.Y) + (FBFHookP1.X - FBFHookP2.X) * (FBFHookP1.X - FBFHookP2.X));
          if D > 0 then
          begin
            Xa := FBFHookP1.X + ARROWLEN * ((FBFHookP2.X - FBFHookP1.X) + (FBFHookP2.Y - FBFHookP1.Y) / 2) / D;
            Ya := FBFHookP1.Y + ARROWLEN * ((FBFHookP2.Y - FBFHookP1.Y) - (FBFHookP2.X - FBFHookP1.X) / 2) / D;
            Xb := FBFHookP1.X + ARROWLEN * ((FBFHookP2.X - FBFHookP1.X) - (FBFHookP2.Y - FBFHookP1.Y) / 2) / D;
            Yb := FBFHookP1.Y + ARROWLEN * ((FBFHookP2.Y - FBFHookP1.Y) + (FBFHookP2.X - FBFHookP1.X) / 2) / D;
            MoveTo(ADrawer.GetX(FBFHookP1.X), ADrawer.GetY(FBFHookP1.Y));
            LineTo(ADrawer.GetX(Xa), ADrawer.GetY(Ya));
            MoveTo(ADrawer.GetX(FBFHookP1.X), ADrawer.GetY(FBFHookP1.Y));
            LineTo(ADrawer.GetX(Xb), ADrawer.GetY(Yb));
          end;
        end;

        Pen.Mode := pmCopy;

      end;
      Exit;
    end;

  with ADrawer.Canvas do
  begin
    dcp1.X := 0;
    dcp1.Y := 0;
    dcp2.X := 0;
    dcp2.Y := 0;

    if FHorz1 then
    begin

      PaH1 := FP1;
      if P2.X > P1.X then
        PaH1.X := PaH1.X + paD
      else
        PaH1.X := PaH1.X - paD;
      PaH2 := paH1;

      paH1.Y := paH1.Y - 4;
      paH2.Y := paH2.Y + 4;

      cp1 := FP1;
      if P2.X > P1.X then
      begin
        cp1.X := cp1.X + pfaR;
        dcp1.X := 1;
      end
      else
      begin
        cp1.X := cp1.X - pfaR;
        dcp1.X := -1;
      end;
    end
    else
    begin

      PaH1 := FP1;
      if P2.Y > P1.Y then
        PaH1.Y := PaH1.Y + paD
      else
        PaH1.Y := PaH1.Y - paD;
      PaH2 := paH1;
      paH1.X := paH1.X - 4;
      paH2.X := paH2.X + 4;

      cp1 := FP1;
      if P2.Y > P1.Y then
      begin
        cp1.Y := cp1.Y + pfaR;
        dcp1.Y := 1;
      end
      else
      begin
        cp1.Y := cp1.Y - pfaR;
        dcp1.Y := -1;
      end;
    end;

    if FHorz2 then
    begin

      PbH1 := FP4;
      if P4.X < P3.X then
        PbH1.X := PbH1.X + paD
      else
        PbH1.X := PbH1.X - paD;
      PbH2 := PbH1;

      PbH1.Y := PbH1.Y - 4;
      PbH2.Y := PbH2.Y + 4;

      cp2 := FP4;
      if P4.X < P3.X then
      begin
        cp2.X := cp2.X + pfaR;
        dcp2.X := 1;
      end
      else
      begin
        cp2.X := cp2.X - pfaR;
        dcp2.X := -1;
      end;
    end
    else
    begin

      PbH1 := FP4;
      if P4.Y < P3.Y then
        PbH1.Y := PbH1.Y + paD
      else
        PbH1.Y := PbH1.Y - paD;
      PbH2 := PbH1;
      PbH1.X := PbH1.X - 4;
      PbH2.X := PbH2.X + 4;

      cp2 := FP4;
      if P4.Y < P3.Y then
      begin
        cp2.Y := cp2.Y + pfaR;
        dcp2.Y := 1;
      end
      else
      begin
        cp2.Y := cp2.Y - pfaR;
        dcp2.Y := -1;
      end
    end;

    if FHorz2 then
    begin

      pfa0 := FP4;
      pfa1 := FP4;
      pfa2 := FP4;
      pfa3 := FP4;
      pfb1 := FP4;
      pfb2 := FP4;
      pfb3 := FP4;
      pfb4 := FP4;
      if P4.X > P3.X then
      begin
        pfa0.X := pfa0.X - pfaD;

        pfa1.X := pfa1.X - pfaD + pfaR;
        pfa2.X := pfa2.X - paD;
        pfa2.Y := pfa2.Y - 5;
        pfa3.X := pfa3.X - paD;
        pfa3.Y := pfa3.Y + 5;

        pfb1.X := pfb1.X - paD;
        pfb1.Y := pfb1.Y - 3;
        pfb2.Y := pfb2.Y - 3;

        pfb3.X := pfb3.X - paD;
        pfb3.Y := pfb3.Y + 3;
        pfb4.Y := pfb4.Y + 3;
      end
      else
      begin
        pfa0.X := pfa0.X + pfaD;

        pfa1.X := pfa1.X + pfaD - pfaR;
        pfa2.X := pfa2.X + paD;
        pfa2.Y := pfa2.Y - 5;
        pfa3.X := pfa3.X + paD;
        pfa3.Y := pfa3.Y + 5;

        pfb1.X := pfb1.X + paD;
        pfb1.Y := pfb1.Y - 3;
        pfb2.Y := pfb2.Y - 3;
        pfb3.X := pfb3.X + paD;
        pfb3.Y := pfb3.Y + 3;
        pfb4.Y := pfb4.Y + 3;
      end;

    end
    else
    begin

      pfa0 := FP4;
      pfa1 := FP4;
      pfa2 := FP4;
      pfa3 := FP4;
      pfb1 := FP4;
      pfb2 := FP4;
      pfb3 := FP4;
      pfb4 := FP4;
      if P4.Y > P3.Y then
      begin
        pfa0.Y := pfa0.Y - pfaD;

        pfa1.Y := pfa1.Y - pfaD + pfaR;
        pfa2.Y := pfa2.Y - paD;
        pfa2.X := pfa2.X - 5;
        pfa3.Y := pfa3.Y - paD;
        pfa3.X := pfa3.X + 5;

        pfb1.Y := pfb1.Y - paD;
        pfb1.X := pfb1.X - 3;
        pfb2.X := pfb2.X - 3;
        pfb3.Y := pfb3.Y - paD;
        pfb3.X := pfb3.X + 3;
        pfb4.X := pfb4.X + 3;

      end
      else
      begin
        pfa0.Y := pfa0.Y + pfaD;

        pfa1.Y := pfa1.Y + pfaD - pfaR;
        pfa2.Y := pfa2.Y + paD;
        pfa2.X := pfa2.X - 5;
        pfa3.Y := pfa3.Y + paD;
        pfa3.X := pfa3.X + 5;

        pfb1.Y := pfb1.Y + paD;
        pfb1.X := pfb1.X - 3;
        pfb2.X := pfb2.X - 3;
        pfb3.Y := pfb3.Y + paD;
        pfb3.X := pfb3.X + 3;
        pfb4.X := pfb4.X + 3;
      end;
    end;

    if FHorz1 and FHorz2 then
    begin

      Pa := FP2;
      Pb := FP2;
      if P2.X > P1.X then
        Pa.X := FP2.X - 3
      else
        Pa.X := FP2.X + 3;
      if P3.Y > P2.Y then
        Pb.Y := FP2.Y + 3
      else
        Pb.Y := FP2.Y - 3;

      Pc := FP3;
      Pd := FP3;
      if P4.X > P3.X then
        Pd.X := FP3.X + 3
      else
        Pd.X := FP3.X - 3;
      if P3.Y > P2.Y then
        Pc.Y := FP3.Y - 3
      else
        Pc.Y := FP3.Y + 3;

      if Abs(Pc.Y - Pb.Y) <= 6 then
      begin
        Pc.Y := (P2.Y + P3.Y) / 2;
        Pb.Y := (P2.Y + P3.Y) / 2;

      end;
    end
    else if not FHorz1 and not FHorz2 then
    begin

      Pa := FP2;
      Pb := FP2;
      if P2.Y > P1.Y then
        Pa.Y := FP2.Y - 3
      else
        Pa.Y := FP2.Y + 3;
      if P3.X > P2.X then
        Pb.X := FP2.X + 3
      else
        Pb.X := FP2.X - 3;

      Pc := FP3;
      Pd := FP3;
      if P4.Y > P3.Y then
        Pd.Y := FP3.Y + 3
      else
        Pd.Y := FP3.Y - 3;
      if P3.X > P2.X then
        Pc.X := FP3.X - 3
      else
        Pc.X := FP3.X + 3;

      if Abs(Pc.X - Pb.X) <= 6 then
      begin
        Pc.X := (P2.X + P3.X) / 2;
        Pb.X := (P2.X + P3.X) / 2;
      end;
    end
    else
    begin
      if FHorz1 and not FHorz2 then
      begin

        Pa := FP2;
        if P2.X > P1.X then
          Pa.X := FP2.X - 3
        else
          Pa.X := FP2.X + 3;
        Pb := Pa;

        Pd := FP3;
        if P4.Y > P3.Y then
          Pd.Y := FP3.Y + 3
        else
          Pd.Y := FP3.Y - 3;
        Pc := Pd;
      end
      else if not FHorz1 and FHorz2 then
      begin

        Pa := FP2;
        if P2.Y > P1.Y then
          Pa.Y := FP2.Y - 3
        else
          Pa.Y := FP2.Y + 3;
        Pb := Pa;

        Pd := FP3;
        if P4.X > P3.X then
          Pd.X := FP3.X + 3
        else
          Pd.X := FP3.X - 3;
        Pc := Pd;
      end
      else
      begin

        Pa := FP2;
        Pb := FP2;

        Pc := FP3;
        Pd := FP3;
      end;
    end;

    if (FLinkType = dmllDirect) then
      CalculateArr(FHorz2, FP3, FP4, psd)
    else if (FLinkType = dmllOppDirect) then
      CalculateArr(FHorz2, FP2, FP1, psd);
    for I := 0 to 1 do
    begin
      if I = 1 then
      begin
        if not Selected or ADrawer.SkipDrawSelected then
          Exit;
        Pen.Color := ADrawer.SelectedColor;
        Pen.Width := FBorderWidth + 2;
        Pen.Mode := pmNotXor;
      end;

      MoveTo(ADrawer.GetX(FP1.X), ADrawer.GetY(FP1.Y));
      LineTo(ADrawer.GetX(Pa.X), ADrawer.GetY(Pa.Y));
      LineTo(ADrawer.GetX(Pb.X), ADrawer.GetY(Pb.Y));
      LineTo(ADrawer.GetX(Pc.X), ADrawer.GetY(Pc.Y));
      LineTo(ADrawer.GetX(Pd.X), ADrawer.GetY(Pd.Y));
      LineTo(ADrawer.GetX(FP4.X), ADrawer.GetY(FP4.Y));

      if (FLinkType = dmllFKNormal) then
      begin

        MoveTo(ADrawer.GetX(PaH1.X), ADrawer.GetY(PaH1.Y));
        LineTo(ADrawer.GetX(PaH2.X), ADrawer.GetY(PaH2.Y));

        Ellipse(ADrawer.GetX(pfa0.X - pfaR), ADrawer.GetY(pfa0.Y - pfaR),
          ADrawer.GetX(pfa0.X + pfaR) + 1, ADrawer.GetY(pfa0.Y + pfaR) + 1);

        Ps[0] := Point(ADrawer.GetX(pfa1.X), ADrawer.GetY(pfa1.Y));
        Ps[1] := Point(ADrawer.GetX(pfa2.X), ADrawer.GetY(pfa2.Y));
        Ps[2] := Point(ADrawer.GetX(pfa3.X), ADrawer.GetY(pfa3.Y));
        ps[3] := Ps[0];

        Polygon(Ps);

        MoveTo(ADrawer.GetX(pfb1.X), ADrawer.GetY(pfb1.Y));
        LineTo(ADrawer.GetX(pfb2.X), ADrawer.GetY(pfb2.Y));
        MoveTo(ADrawer.GetX(pfb3.X), ADrawer.GetY(pfb3.Y));
        LineTo(ADrawer.GetX(pfb4.X), ADrawer.GetY(pfb4.Y));

      end;

      if (FLinkType = dmllFKUnique) then
      begin

        MoveTo(ADrawer.GetX(PaH1.X), ADrawer.GetY(PaH1.Y));
        LineTo(ADrawer.GetX(PaH2.X), ADrawer.GetY(PaH2.Y));

        MoveTo(ADrawer.GetX(PbH1.X), ADrawer.GetY(PbH1.Y));
        LineTo(ADrawer.GetX(PbH2.X), ADrawer.GetY(PbH2.Y));

      end;

      if (FLinkType = dmllDirect) then
      begin

        psdtmp[0] := Point(ADrawer.GetX(psd[0].X), ADrawer.GetY(psd[0].Y));
        psdtmp[1] := Point(ADrawer.GetX(psd[1].X), ADrawer.GetY(psd[1].Y));
        psdtmp[2] := Point(ADrawer.GetX(psd[2].X), ADrawer.GetY(psd[2].Y));
        psdtmp[3] := psdtmp[0];

        Polygon(psdtmp);

        Ellipse(ADrawer.GetX(cp1.X - pfaR) + dcp1.X, ADrawer.GetY(cp1.Y - pfaR) + dcp1.Y,
          ADrawer.GetX(cp1.X + pfaR) + 1 + dcp1.X, ADrawer.GetY(cp1.Y + pfaR) + 1 + dcp1.Y);
      end;

      if (FLinkType = dmllOppDirect) then
      begin

        psdtmp[0] := Point(ADrawer.GetX(psd[0].X), ADrawer.GetY(psd[0].Y));
        psdtmp[1] := Point(ADrawer.GetX(psd[1].X), ADrawer.GetY(psd[1].Y));
        psdtmp[2] := Point(ADrawer.GetX(psd[2].X), ADrawer.GetY(psd[2].Y));
        psdtmp[3] := psdtmp[0];

        Polygon(psdtmp);

        Ellipse(ADrawer.GetX(cp2.X - pfaR) + dcp2.X, ADrawer.GetY(cp2.Y - pfaR) + dcp2.Y,
          ADrawer.GetX(cp2.X + pfaR) + 1 + dcp2.X, ADrawer.GetY(cp2.Y + pfaR) + 1 + dcp2.Y);
      end;

      if (FLinkType = dmllLine) then
      begin

        Ellipse(ADrawer.GetX(cp1.X - pfaR) + dcp1.X, ADrawer.GetY(cp1.Y - pfaR) + dcp1.Y,
          ADrawer.GetX(cp1.X + pfaR) + 1 + dcp1.X, ADrawer.GetY(cp1.Y + pfaR) + 1 + dcp1.Y);

        Ellipse(ADrawer.GetX(cp2.X - pfaR) + dcp2.X, ADrawer.GetY(cp2.Y - pfaR) + dcp2.Y,
          ADrawer.GetX(cp2.X + pfaR) + 1 + dcp2.X, ADrawer.GetY(cp2.Y + pfaR) + 1 + dcp2.Y);

      end;

      Pen.Mode := pmCopy;
    end;

  end;
end;

function TDMLLinkObj.PointInObj(X, Y: Double): Boolean;
var
  p: TDMLPoint;
begin
  if FBriefMode then
  begin
    p.X := X;
    p.y := Y;
    Result := P2L_Distance(p, FBFHookP1, FBFHookP2) <= 7;
  end
  else
  begin
    Result := RectCrossOrTouchRect2(FP1.X, FP1.Y, FP2.X, FP2.Y, X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST);
    if not Result then
      Result := RectCrossOrTouchRect2(FP3.X, FP3.Y, FP2.X, FP2.Y, X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST);
    if not Result then
      Result := RectCrossOrTouchRect2(FP3.X, FP3.Y, FP4.X, FP4.Y, X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST);
  end;
end;

function TDMLLinkObj.RectTouchObj(X, Y, W, H: Double): Boolean;
begin
  if FBriefMode then
  begin
    Result := RectCrossOrTouchRect2(FBFHookP1.X, FBFHookP1.Y, FBFHookP2.X, FBFHookP2.Y, X, Y, X + W, Y + H);
    Exit;
  end;
  Result := RectCrossOrTouchRect2(FP1.X, FP1.Y, FP2.X, FP2.Y, X, Y, X + W, Y + H);
  if not Result then
    Result := RectCrossOrTouchRect2(FP3.X, FP3.Y, FP2.X, FP2.Y, X, Y, X + W, Y + H);
  if not Result then
    Result := RectCrossOrTouchRect2(FP3.X, FP3.Y, FP4.X, FP4.Y, X, Y, X + W, Y + H);
end;

procedure TDMLLinkObj.ResetPosition;
begin
  FPMod_OP1 := False;
  FPMod_OP2 := False;
  FPMod_CP := False;
  FPosInfoLoaded := False;
  FClickPos := 0;
  CheckPosition;
end;

procedure TDMLLinkObj.ResetPositionEx;
begin
  FPMod_OP1 := False;
  FPMod_OP2 := False;
  FPMod_CP := False;      
  FPosInfoLoaded := False;
  FClickPos := 0;
  CheckPosition;
end;

procedure TDMLLinkObj.ResetRelateTbFieldSelected;
var
  I: Integer;
begin
  if (FObj1 <> nil) and (FObj1 is TDmlTableObj) then
    TDmlTableObj(FObj1).ClearLinkSelection;

  if (FObj2 <> nil) and (FObj2 is TDmlTableObj) then
    TDmlTableObj(FObj2).ClearLinkSelection;

  SetRelateFieldSelected(FSelected);
end;

procedure TDMLLinkObj.Save(Ini: TCustomIniFile; Sec: string);
begin
  inherited;
  if not Assigned(ini) then
    Exit;
  Ini.WriteString(Sec, 'Obj1_Name', FObj1_Name);
  Ini.WriteString(Sec, 'Obj2_Name', FObj2_Name);

  Ini.WriteInteger(Sec, 'LinkType', Integer(FLinkType));

  Ini.WriteFloat(Sec, 'P1_X', P1.X);
  Ini.WriteFloat(Sec, 'P1_Y', P1.Y);
  Ini.WriteFloat(Sec, 'P2_X', P2.X);
  Ini.WriteFloat(Sec, 'P2_Y', P2.Y);
  Ini.WriteFloat(Sec, 'P3_X', P3.X);
  Ini.WriteFloat(Sec, 'P3_Y', P3.Y);
  Ini.WriteFloat(Sec, 'P4_X', P4.X);
  Ini.WriteFloat(Sec, 'P4_Y', P4.Y);

  Ini.WriteFloat(Sec, 'HookP1_X', FHookP1.X);
  Ini.WriteFloat(Sec, 'HookP1_Y', FHookP1.Y);
  Ini.WriteFloat(Sec, 'HookP2_X', FHookP2.X);
  Ini.WriteFloat(Sec, 'HookP2_Y', FHookP2.Y);

  Ini.WriteBool(Sec, 'PMod_OP1', FPMod_OP1);
  Ini.WriteBool(Sec, 'PMod_OP2', FPMod_OP2);
  Ini.WriteBool(Sec, 'PMod_CP', FPMod_CP);

  Ini.WriteBool(Sec, 'FHorz1', FHorz1);
  Ini.WriteBool(Sec, 'FHorz2', FHorz2);
end;

procedure TDMLLinkObj.SaveToStream(AStream: TStream);
begin
  inherited;
  Stream_WriteString(AStream, FObj1_Name);
  Stream_WriteString(AStream, FObj2_Name);

  Stream_WriteInteger(AStream, Integer(FLinkType));

  Stream_WriteDMLPoint(AStream, FP1);
  Stream_WriteDMLPoint(AStream, FP2);
  Stream_WriteDMLPoint(AStream, FP3);
  Stream_WriteDMLPoint(AStream, FP4);

  Stream_WriteDMLPoint(AStream, FHookP1);
  Stream_WriteDMLPoint(AStream, FHookP2);

  Stream_WriteBool(AStream, FPMod_OP1);
  Stream_WriteBool(AStream, FPMod_OP2);
  Stream_WriteBool(AStream, FPMod_CP);

  Stream_WriteBool(AStream, FHorz1);
  Stream_WriteBool(AStream, FHorz2);
end;

procedure TDMLLinkObj.SetBriefMode(const Value: Boolean);
begin
  if FBriefMode <> Value then
  begin
    inherited;

    FClickPos := 0;
    CheckPosition;
  end;
end;

procedure TDMLLinkObj.SetClickPoint(X, Y: Double; ADrawer: TDMLDrawer);
begin
  FClickPos := 0;
  if FBriefMode then
    Exit;
  if RectCrossOrTouchRect2(FP1.X, FP1.Y, FP2.X, FP2.Y, X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST) then
    FClickPos := 1
  else if RectCrossOrTouchRect2(FP3.X, FP3.Y, FP2.X, FP2.Y, X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST) then
    FClickPos := 2
  else if RectCrossOrTouchRect2(FP3.X, FP3.Y, FP4.X, FP4.Y, X - DEF_DMLLINK_PICK_DIST, Y - DEF_DMLLINK_PICK_DIST, X + DEF_DMLLINK_PICK_DIST, Y + DEF_DMLLINK_PICK_DIST) then
    FClickPos := 3;
end;

procedure TDMLLinkObj.SetID(const Value: Integer);
begin
  FID := Value;
  if FName = ClassName then
    FName := srLink + IntToStr(FID);
end;

procedure TDMLLinkObj.SetObj1(const Value: TDMLEntityObj);
begin
  FObj1 := Value;
  FObj1Field := '';

  if Assigned(FObj1) then
  begin
    FObj1_Name := FObj1.Name;
    FObj1.Links.Add(Self)
  end;
end;

procedure TDMLLinkObj.SetObj2(const Value: TDMLEntityObj);
begin
  FObj2 := Value;
  FObj2Field := '';

  if Assigned(FObj2) then
  begin
    FObj2_Name := FObj2.Name;
    FObj2.Links.Add(Self)
  end;
end;

procedure TDMLLinkObj.SetRelateFieldSelected(bSel: Boolean);
var
  fd: TDMLField;
begin
  if (FObj1 <> nil) and (FObj1Field <> '') and (FObj1 is TDmlTableObj) then
  begin
    fd := TDmlTableObj(FObj1).FindDMLField(FObj1Field);
    if fd <> nil then
    begin
      if not bSel then
        fd.LinkSelectType := 0
      else
        fd.LinkSelectType := 1;
    end;
  end;
  if (FObj2 <> nil) and (FObj2Field <> '') and (FObj2 is TDmlTableObj) then
  begin
    fd := TDmlTableObj(FObj2).FindDMLField(FObj2Field);
    if fd <> nil then
    begin
      if not bSel then
        fd.LinkSelectType := 0
      else
        fd.LinkSelectType := 2;
    end;
  end;
end;

procedure TDMLLinkObj.SetSelected(const Value: Boolean);
begin
  if FSelected = Value then
    Exit;
  inherited;
  SetRelateFieldSelected(FSelected);
end;

{ TDMLEntityObj }

procedure TDMLEntityObj.CheckMoved(DX, DY: Double);
var
  I: Integer;
begin
  for I := 0 to FLinks.Count - 1 do
    TDMLLinkObj(FLinks[I]).CheckMoved(Self, DX, DY);
end;

procedure TDMLEntityObj.CheckPositions;
var
  I: Integer;
begin
  for I := 0 to FLinks.Count - 1 do
  begin
    TDMLLinkObj(FLinks[I]).CheckPosition;
  end;
end;

procedure TDMLEntityObj.CheckResize;
begin
  inherited;
                 
  if AutoSize or Self.BriefMode then
    CheckSizeForName(Name);
  CheckPositions;
end;

procedure TDMLEntityObj.CheckSizeForName(AName: string);
var
  L: Integer;
begin
  Width := 90;
  Height := 45;
  L := DmlStrLength(AName);
  if L > FieldNameMaxDrawSize then
    L := FieldNameMaxDrawSize;
  if Width < L * 6.3 + 4 then
    Width := Round(L * 6.3 + 4);
end;

constructor TDMLEntityObj.Create;
begin
  inherited;

  FLinks := TList.Create;
end;

destructor TDMLEntityObj.Destroy;
var
  I: Integer;
begin
  for I := 0 to FLinks.Count - 1 do
  begin
    if TDMLLinkObj(FLinks[I]).Obj1 = Self then
      TDMLLinkObj(FLinks[I]).Obj1 := nil
    else if TDMLLinkObj(FLinks[I]).Obj2 = Self then
      TDMLLinkObj(FLinks[I]).Obj2 := nil;
  end;
  FLinks.Free;

  inherited;
end;

function TDMLEntityObj.IsResizable: Boolean;
begin
  Result := True;
  if BriefMode then
  begin
    if Self.DrawOnBackground <> 2 then
      Result := False;
  end;
end;

procedure TDMLEntityObj.FindSpaceForLinkObjs(objs: TDMLObjList);
var
  I: Integer;
  o: TDMLObj;
  lnk: TDMLLinkObj;
begin
  if not Assigned(objs) then
    Exit;

  for I := FLinks.Count - 1 downto 0 do
  begin
    lnk := TDMLLinkObj(FLinks[I]);
    lnk.FPMod_CP := False;
    if lnk.Obj1 <> Self then
      o := lnk.Obj1
    else
      o := lnk.Obj2;
    if Assigned(o) and not o.Visible then
    begin

      objs.FindSpaceEx(o, Self.Left, Self.Top, 200);
      o.Visible := True;

      if o is TDMLEntityObj then
        TDMLEntityObj(o).FindSpaceForLinkObjs(objs);
    end;
  end;
end;

function TDMLEntityObj.HasLinked(obj: TDMLObj): Boolean;
var
  I: Integer;
begin
  Result := False;
  if obj = Self then
    Exit;
  for I := 0 to FLinks.Count - 1 do
    if (TDMLLinkObj(FLinks[I]).Obj1 = Self) and (TDMLLinkObj(FLinks[I]).Obj2 = obj) then
    begin
      Result := True;
      Exit;
    end
    else if (TDMLLinkObj(FLinks[I]).Obj2 = Self) and (TDMLLinkObj(FLinks[I]).Obj1 = obj) then
    begin
      Result := True;
      Exit;
    end;
end;

procedure TDMLEntityObj.PrepareDelete(objs: TDMLObjList);
begin
  inherited;

  RemoveLinks(objs);
end;

procedure TDMLEntityObj.RemoveLinks(objs: TDMLObjList);
var
  I: Integer;
  o: TObject;
begin
  if not Assigned(objs) then
    Exit;
  for I := FLinks.Count - 1 downto 0 do 
  if I<FLinks.Count then
  begin
    if TDMLLinkObj(FLinks[I]).Obj1 = Self then
    begin
      o := FLinks[I];
      objs.Remove(o);
      FLinks.Remove(o);
    end
    else if TDMLLinkObj(FLinks[I]).Obj2 = Self then
    begin
      o := FLinks[I];
      objs.Remove(o);
      FLinks.Remove(o);
    end;
  end;
end;

procedure TDMLEntityObj.SetBriefMode(const Value: Boolean);
begin
  if FBriefMode <> Value then
  begin
    FBriefMode := Value;
    CheckResize;
  end;
end;

{ TDMLFlowStepObj }

constructor TDMLFlowStepObj.Create;
begin
  inherited;

  FDrawSelectGrips := True;
  BorderColor := RGB(222, 111, 111);
  FObjType := 'STEP';
  Width := 80;
  Height := 40;
end;

procedure TDMLFlowStepObj.SetID(const Value: Integer);
begin
  FID := Value;
  if FName = ClassName then
    FName := srStep + IntToStr(FID);
end;

initialization
  AddDMLObjReg('TABLE', TDMLTableObj);
  AddDMLObjReg('TEXT', TDMLTextObj);
  AddDMLObjReg('LINK', TDMLLinkObj);
  AddDMLObjReg('STEP', TDMLFlowStepObj); 
  AddDMLObjReg('GROUP', TDMLGroupBoxObj);
  FieldNameMaxDrawSize := 64;
  FieldTypeMaxDrawSize := 48;
  TableFieldMaxDrawCount := 50;


//end.

