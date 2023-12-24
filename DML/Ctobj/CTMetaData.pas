{
  CTMetaData
  Create by huz(huzxxxXXXXXX@21cn.com) 2006-04-17 13:04:00
  CTԪ���ݶ���

  20060426�������Ѿ����ͣ����迼�ǣ��߳�ͬ����������ƣ�Ȩ�޿���

  Ȩ��
  �߳�ͬ�����⣺�ڷ���㣬һ����˵CT�������ڲ�ͬ�߳��й�����˶���������
    ��д��������Ҫͬ��������һ��̫Ƶ��ͬ�������ֲ��ˡ���Ҫ��һ��ƽ��ķ�����
}

unit CTMetaData;

interface
   
{$IFDEF FPC}
  {$MODE Delphi}    
  {$WARN 4055 off : Conversion between ordinals and pointers is not portable}
  {$WARN 5091 off : }
  {$WARN 5057 off : Local variable "$1" does not seem to be initialized}
{$ENDIF}

uses

{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Classes, SysUtils, Variants, CtObjSerialer;

type
  TCtObject = class;
  TCtObjectList = class;
  TCtGlobList = class;
{$IFnDEF FPC}
  PtrInt = Integer;
{$ENDIF}

  //�¼������봦��
  TCtEventNotify = (ctnfNone, ctnfRelease, ctnfReset, ctnfInit, ctnfLoad,
    ctnfOpen, ctnfShow, ctnfHide, ctnfClose, ctnfUpdateUI, ctnfBeginUpdate, ctnfEndUpdate,
    ctnfCaptionChange, ctnfChildChange, ctnfCustom);
  TCtEventResult = record
    Result: Integer;
    CtObj: TCtObject;
    ParamA: string;
    ParamB: string;
  end;
  PCtEventResult = ^TCtEventResult;
  TCtEventSubscriber = procedure(Sender: TCtObject; ANotify: TCtEventNotify;
    PCeRes: PCtEventResult) of object;

  TOnCtObjGetSubitems = procedure(Sender: TCtObject) of object;

  //CT���ݼ���
  TctDataLevel = (ctdlUnknown, ctdlNormal, ctdlNew, ctdlModify, ctdlDeleted, ctdlDraft, ctdlDebug);

  //�ֶ����ͣ���DB���������������DB
  TCtFieldType = (cftUnknown, cftString, cftSmallint, cftInteger, cftWord, // 0..4
    cftBoolean, cftFloat, cftCurrency, cftBCD, cftDate, cftTime, cftDateTime, // 5..11
    cftBytes, cftVarBytes, cftAutoInc, cftBlob, cftMemo, cftGraphic, cftFmtMemo, // 12..18
    cftParadoxOle, cftDBaseOle, cftTypedBinary, cftCursor, cftFixedChar, cftWideString, // 19..24
    cftLargeint, cftADT, cftArray, cftReference, cftDataSet, cftOraBlob, cftOraClob, // 25..31
    cftVariant, cftInterface, cftIDispatch, cftGuid, cftTimeStamp, cftFMTBcd, // 32..37
    cftFixedWideChar, cftWideMemo, cftOraTimeStamp, cftOraInterval); // 38..41

  //CT�¼�������
  TCtEventProcessor = class
  private
    //�������б�
    FSubscribers: array of TCtEventSubscriber;
    FEnabled: Boolean;
  public
    constructor Create; virtual;
    //����ɾ��������
    procedure Reset; virtual;
    procedure AddSubscriber(const ASubscriber: TCtEventSubscriber); virtual;
    procedure RemoveSubscriber(const ASubscriber: TCtEventSubscriber); virtual;

    //���������¼�
    procedure DoCtEvent(Sender: TCtObject; ANotify: TCtEventNotify;
      PCeRes: PCtEventResult); virtual;
    //�Ƿ񼤻�
    property Enabled: Boolean read FEnabled write FEnabled;
  end;

  //CT������࣬�����������Ժʹ��л��ӿ�
  //guid:{E8D33D36-66DF-4568-8537-F24A1EDE0588}

  { TCtObject }

  TCtObject = class(TObject)
  private
  protected
    FID: Integer;   
    FName: string;
    FCtGuid: string;
    FRID: Integer;
    FPID: Integer;
    FPreName: string;
    FCaption: string;
    FMemo: string;
    FCreateDate: TDateTime;
    FModifier: Integer;
    FCreator: Integer;
    FTypeName: string;
    FModifyDate: TDateTime;
    FCreatorName: string;
    FModifierName: string;
    FVersionNo: Integer;
    FHistoryID: Integer;
    FLockStamp: string;
    FDataLevel: TctDataLevel;
    FOrderNo: Double;
    FAutoFreeObjs: array of TObject;
    FSubitems: TCtObjectList;
    FOnGetSubItems: TOnCtObjGetSubitems;
    FParentList: TCtObjectList;
    FEventProcessor: TCtEventProcessor;
    FGlobeList: TCtGlobList;
    FUserObjectList: TStrings;
    FSerialCounter: Integer;
    FCustomAttr2: string;
    FCustomAttr3: string;
    FCustomAttr1: string;
    FCustomAttr4: string;
    FCustomAttr5: string;
    FCalValue: Integer;
    FModifyCounter: Integer;
    FCalString: string;
  protected
    procedure SetName(const Value: string); virtual;

    procedure SetGlobeList(const Value: TCtGlobList); virtual;
    function GetDisplayText: string; virtual;

    function GetEventProcessor: TCtEventProcessor; virtual;
    function GetHasSubItems: Boolean; virtual;
    //�̳д˷������뱣��GLOBELIST�Ĵ���
    function GetSubitems: TCtObjectList; virtual;
    //����ȱʡ���б�
    function CreateDefSubitems: TCtObjectList; virtual;

    function GetUserObjectCount: Integer; virtual;
    function GetUserObject(Index: string): TObject; virtual;
    procedure SetUserObject(Index: string; const Value: TObject); virtual;
    function GetUserObjectList: TStrings; virtual;

    procedure SetCaption(const Value: string); virtual;
    function GetNameCaption: string; virtual;

    function GetParamList: TStrings; virtual;
    function GetParam(Name: string): string; virtual;
    procedure SetParam(Name: string; const Value: string); virtual;

  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure RaiseCtException(const msg: string); virtual;

    //�Զ�FREE�����ΪFREE����ר��дDESTROY������
    procedure AddAutoFree(Obj: TObject); virtual;
    procedure DelAutoFree(Obj: TObject; bFreeit: Boolean); virtual;
    procedure FreeAutoFree; virtual;

    //���������¼�
    procedure DoEvent(ANotify: TCtEventNotify;
      PCeRes: PCtEventResult = nil); virtual;
    procedure DoCustomEvent(EvtParamA, EvtParamB: string); virtual;

    procedure SetCtObjModified(bModified: Boolean); virtual;

    //����
    procedure SortByOrderNo; virtual;
    procedure SortByName; virtual;

    //״̬����ָ��ӿ�
    procedure Reset; virtual;
    procedure AssignFrom(ACtObj: TCtObject); virtual;
    procedure LoadFromSerialer(ASerialer: TCtObjSerialer); virtual;
    procedure SaveToSerialer(ASerialer: TCtObjSerialer); virtual;
    procedure LoadFromFile(fn: string); virtual;
    procedure SaveToFile(fn: string); virtual;  
    function SaveToTempFile(ext: string): string; virtual;
    function ExecCmd(ACmd, AParam1, AParam2: string): string; virtual;

    procedure BeginSerial(ASerialer: TCtObjSerialer; bRead: Boolean); virtual;
    procedure EndSerial(ASerialer: TCtObjSerialer; bRead: Boolean); virtual;

    //�Ƿ��в���
    function HasParams: Boolean;

    //�������ԣ�ID PID RID ���� ���� ���� ע�� ����ʱ��ʹ����� ����޸�ʱ����޸��� ���ݼ���
    property ID: Integer read FID write FID;
    property CtGuid: string read FCtGuid write FCtGuid;
    property PID: Integer read FPID write FPID;
    property RID: Integer read FRID write FRID;
    property Name: string read FName write SetName;
    property Caption: string read FCaption write SetCaption;
    property TypeName: string read FTypeName write FTypeName;
    property Memo: string read FMemo write FMemo;
    property DisplayText: string read GetDisplayText;
    property NameCaption: string read GetNameCaption;

    property CreateDate: TDateTime read FCreateDate write FCreateDate;
    property Creator: Integer read FCreator write FCreator;
    property CreatorName: string read FCreatorName write FCreatorName;
    property ModifyDate: TDateTime read FModifyDate write FModifyDate;
    property Modifier: Integer read FModifier write FModifier;
    property ModifierName: string read FModifierName write FModifierName;

    //��ʷ��� ��ͬ�����޸Ļ�ʱ���޸ģ������ܣ���֮���Զ������汾��ʷ
    property HistoryID: Integer read FHistoryID write FHistoryID;
    //�汾�� ÿ���޸��Զ���һ������ͬ��
    property VersionNo: Integer read FVersionNo write FVersionNo;
    //������Ϣ ��ǰ������Ϣ�����������ˡ�����ʱ�䡢��ʱ����
    property LockStamp: string read FLockStamp write FLockStamp;

    property DataLevel: TctDataLevel read FDataLevel write FDataLevel;
    //�����
    property OrderNo: Double read FOrderNo write FOrderNo;

    //���� ��Ҫ����OnGetSubItems�¼����������ͷ�
    property OnGetSubItems: TOnCtObjGetSubitems read FOnGetSubItems write FOnGetSubItems;
    property SubItems: TCtObjectList read GetSubitems write FSubitems;
    property HasSubItems: Boolean read GetHasSubItems;
    //���б�
    property ParentList: TCtObjectList read FParentList write FParentList;
    //�¼�������
    property EventProcessor: TCtEventProcessor read GetEventProcessor;
    //���ж���ȫ���б�
    property GlobeList: TCtGlobList read FGlobeList write SetGlobeList;
    //�û��Զ������
    property UserObjectList: TStrings read GetUserObjectList;
    property UserObjectCount: Integer read GetUserObjectCount;
    property UserObject[Index: string]: TObject read GetUserObject write SetUserObject;
    //����TSTRINGS
    property ParamList: TStrings read GetParamList;
    property Param[Name: string]: string read GetParam write SetParam;
    //�Զ�������
    property CustomAttr1: string read FCustomAttr1 write FCustomAttr1;
    property CustomAttr2: string read FCustomAttr2 write FCustomAttr2;
    property CustomAttr3: string read FCustomAttr3 write FCustomAttr3;
    property CustomAttr4: string read FCustomAttr4 write FCustomAttr4;
    property CustomAttr5: string read FCustomAttr5 write FCustomAttr5;
    //��ʱ�������
    property CalValue: Integer read FCalValue write FCalValue;    
    property CalString: string read FCalString write FCalString;
    //���޸Ĵ���
    property ModifyCounter: Integer read FModifyCounter write FModifyCounter;
  end;

  TCtObjectClass = class of TCtObject;


  { ���ͷ��б� }
  TCtAutoFreeList = class(TList)
  protected
    FAutoFree: Boolean;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    //�Զ�FREE
    property AutoFree: Boolean read FAutoFree write FAutoFree;
  end;

  TCtGlobList = class(TCtAutoFreeList)
  private
    FSeqCounter: Integer;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure AutoRegenObjIDs(ARootNode: TCtObject); virtual;
    procedure CheckMaxSeq; virtual;

    function GenNewItemID: Integer; virtual;
    property SeqCounter: Integer read FSeqCounter write FSeqCounter;
  end;

  //CT�����б����½����Զ�FREE��������������չ������

  { TCtObjectList }

  TCtObjectList = class(TCtGlobList)
  private
    FItemClass: TCtObjectClass;
    FInnerGlobeList: TCtGlobList;
    FGlobeList: TCtGlobList;
    function GetCtItem(Index: Integer): TCtObject;
    procedure PutCtItem(Index: Integer; const Value: TCtObject);
  protected
    //����������̣�NEWOBJʱ�ã����������̳�
    function CreateObj: TCtObject; virtual;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure RaiseCtException(const msg: string); virtual;

    //״̬����ָ��ӿ�
    procedure AssignFrom(ACtObj: TCtObjectList); virtual;
    procedure LoadFromSerialer(ASerialer: TCtObjSerialer); virtual;
    procedure SaveToSerialer(ASerialer: TCtObjSerialer); virtual;

    ///�½����� ����������������������������ע�⣺���������Ȼ����ʹ�ô˷��������������������������������
    function NewObj: TCtObject; virtual;
    //չ������
    procedure ExpandItem(AItem: TCtObject); virtual;
    //�����ͷ�֪ͨ
    procedure NotifyChildFree(AItem: TCtObject); virtual;
    //����ȫ���б�����һ���б��оͼ�¼��ͬһ�����µ����нڵ�
    function CreateGlobeList: TCtGlobList; virtual;
    //��ȡ����
    function ItemByID(AID: Integer): TCtObject; virtual;
    function ItemByName(AName: string; bCaseSensive: Boolean = False): TCtObject; virtual;
    function NameOfID(AID: Integer): string; virtual;

    function ValidItemCount: Integer;
    //ɾ����Ч�ڵ�
    procedure Pack; virtual;
    //��ɾ������FREE��
    procedure MereRemove(AItem: TCtObject); virtual;
    //����
    procedure SortByOrderNo; virtual;
    procedure SortByName; virtual;
    //���浱ǰ˳��
    procedure SaveCurrentOrder; virtual;

    property Items[Index: Integer]: TCtObject read GetCtItem write PutCtItem; default;
    //����
    property ItemClass: TCtObjectClass read FItemClass write FItemClass;
    //���ж���ȫ���б�
    //����һ��ȫ���б��м�¼��ͬһ�����µ����нڵ�
    property GlobeList: TCtGlobList read FGlobeList write FGlobeList;
  end;

  //Ŀ¼���ڵ�
  TCtTreeNode = class(TCtObject)
  private
    FParentNode: TCtTreeNode;
    function GetItems(Index: Integer): TCtTreeNode;
    function GetCount: Integer;
  protected
    procedure SetParentNode(const Value: TCtTreeNode); virtual;
    function GetSubitems: TCtObjectList; override;
    function CreateDefSubitems: TCtObjectList; override;
  public
    //�½�����  ע�����б�NEWOBJ������
    function NewSubItem(nam: string): TCtTreeNode; overload; virtual;
    //·����
    function GetPath: string; virtual;
    function GetFullPathName: string; virtual;
    //����·������ȡ�ӽڵ�
    function GetSubNodeByPath(APath: string): TCtTreeNode; virtual;

    procedure AssignTreeNodes(Source: TCtTreeNode; bNewID: Boolean); virtual;
    procedure MoveTo(TgNode: TCtTreeNode); virtual;

    //���ڵ�
    property ParentNode: TCtTreeNode read FParentNode write SetParentNode;
    //��Ŀ������
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCtTreeNode read GetItems; default;
  end;

  //Ŀ¼���б�
  TCtTreeList = class(TCtObjectList)
  private
    FOwnerNode: TCtTreeNode;
  protected
    function CreateObj: TCtObject; override;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    //չ������
    procedure ExpandItem(AItem: TCtObject); override;
    //���ڵ�
    property OwnerNode: TCtTreeNode read FOwnerNode write FOwnerNode;
  end;

  { CT���󹤳� }
  TCtObjFactory = class(TObject)
  private
  protected
    FLastObject: TCtObject;
    FName: string;
    FCap: string;
    FEnabled: Short;
    FGuid: string;
    FObjClass: TCtObjectClass;
    FIDSeq: Integer;
  public
    //constructor Create; virtual;
    //destructor Destroy; override;

    //�����¶���
    function CreateNew: TCtObject; virtual;

    //���
    property Guid: string read FGuid;
    //����
    property Name: string read FName;
    property Cap: string read FCap;
    //�Ƿ�����
    property Enabled: Short read FEnabled write FEnabled;
    //������ָ��
    property ObjClass: TCtObjectClass read FObjClass;
    //������
    property LastObject: TCtObject read FLastObject write FLastObject;
  end;


  { CT���󹤳�ע�� }
  TCtFactoryRegstry = class(TCtAutoFreeList)
  private
  protected
  public
    //constructor Create; virtual;
    //destructor Destroy; override;

    //��������
    function FindOrCreateFactory(const AName, ACap, AGuid: string;
      const AClass: TCtObjectClass): TCtObjFactory;
    //��ӹ���
    procedure AddFactory(AFactory: TCtObjFactory);
    //��������
    //��ֱ�������ƣ�����GUID��ʽΪ��guid:{E8D33D36-66DF-4568-8537-F24A1EDE0588}
    function CreateCtObj(AName: string): TCtObject;
    //��������
    //��ֱ�������ƣ�����GUID��ʽΪ��guid:{E8D33D36-66DF-4568-8537-F24A1EDE0588}
    function FindFactory(AName: string): TCtObjFactory;

    //����
    function GetItem(Index: Integer): TCtObjFactory;

    //��Ŀ
    property Count;
  end;

function GlobeCtFactories: TCtFactoryRegstry;

//ָ������������෽������ֱ�ӱȽϣ���ת�ú���������
function SameMethod(const ASubscriberA, ASubscriberB: TCtEventSubscriber): Boolean;

function CtoListOrderNoSortCompare(Item1, Item2: Pointer): Integer;
function CtoListNameSortCompare(Item1, Item2: Pointer): Integer;

var
  FGlobeCtobjCounter: Integer;
  FGlobeCtlstCounter: Integer;
  FGlobeCtoList: TStringList;       
  Proc_CreateCtObjSerialer: function(fn: string; bWriteMode: boolean): TCtObjSerialer;

implementation
   
uses
  WindowFuncs;

var
  FGlobeCtFactories: TCtFactoryRegstry;

function GlobeCtFactories: TCtFactoryRegstry;
begin
  if not Assigned(FGlobeCtFactories) then
    FGlobeCtFactories := TCtFactoryRegstry.Create;
  Result := FGlobeCtFactories;
end;

function SameMethod(const ASubscriberA, ASubscriberB: TCtEventSubscriber): Boolean;
begin
  Result := (TMethod(ASubscriberA).Code = TMethod(ASubscriberB).Code) and
    (TMethod(ASubscriberA).Data = TMethod(ASubscriberB).Data)
end;

function CtoListOrderNoSortCompare(Item1, Item2: Pointer): Integer;
var
  d, o1, o2: Double;
begin
  o1 := TCtObject(Item1).OrderNo;
  if o1 = 0 then
    o1 := TCtObject(Item1).ID;
  o2 := TCtObject(Item2).OrderNo;
  if o2 = 0 then
    o2 := TCtObject(Item2).ID;
  d := o1 - o2;
  if d > 0 then
    Result := 1
  else if d < 0 then
    Result := -1
  else
    Result := 0;
end;

function CtoListNameSortCompare(Item1, Item2: Pointer): Integer;
var
  o1, o2: string;
begin
  o1 := TCtObject(Item1).Name;
  o2 := TCtObject(Item2).Name;
  Result := AnsiCompareText(o1, o2);
end;

function CtoListNameDescSortCompare(Item1, Item2: Pointer): Integer;
var
  o1, o2: string;
begin
  o1 := TCtObject(Item1).Name;
  o2 := TCtObject(Item2).Name;
  Result := AnsiCompareText(o2, o1);
end;

{ TCtObject }

procedure TCtObject.AddAutoFree(Obj: TObject);
var
  I, L: Integer;
begin
  for I := 0 to High(FAutoFreeObjs) do
    if FAutoFreeObjs[I] = Obj then
      Exit;
  L := Length(FAutoFreeObjs);
  SetLength(FAutoFreeObjs, L + 1);
  FAutoFreeObjs[L] := Obj;
end;

procedure TCtObject.AssignFrom(ACtObj: TCtObject);
begin
  Reset;
  if ACtObj = nil then
    Exit;

  FID := ACtObj.FID;
  FCtGuid := ACtObj.FCtGuid;
  FPID := ACtObj.FPID;
  FRID := ACtObj.FRID;

  FPreName := ACtObj.FPreName;
  FName := ACtObj.FName;
  FCaption := ACtObj.FCaption;
  FTypeName := ACtObj.FTypeName;
  FMemo := ACtObj.FMemo;

  FCreateDate := ACtObj.FCreateDate;
  FModifier := ACtObj.FModifier;
  FCreatorName := ACtObj.CreatorName;
  FCreator := ACtObj.FCreator;
  FModifyDate := ACtObj.FModifyDate;
  FModifierName := ACtObj.ModifierName;

  FVersionNo := ACtObj.FVersionNo;
  FHistoryID := ACtObj.FHistoryID;
  FLockStamp := ACtObj.FLockStamp;

  FDataLevel := ACtObj.FDataLevel;
  FOrderNo := ACtObj.FOrderNo;

  FCustomAttr1 := ACtObj.FCustomAttr1;
  FCustomAttr2 := ACtObj.FCustomAttr2;
  FCustomAttr3 := ACtObj.FCustomAttr3;
  FCustomAttr4 := ACtObj.FCustomAttr4;
  FCustomAttr5 := ACtObj.FCustomAttr5;

  if ACtObj.HasParams then
    Self.ParamList.Text := ACtObj.ParamList.Text
  else if HasParams then
    Self.ParamList.Text := '';

  SetCtObjModified(True);
end;

procedure TCtObject.BeginSerial(ASerialer: TCtObjSerialer; bRead: Boolean);
begin
  Inc(FSerialCounter);
  if FSerialCounter = 1 then
  begin
    Assert(ASerialer <> nil);
    if Assigned(ASerialer) then
    begin
      if not bRead then
        ASerialer.NewObjToWrite(ID);
      ASerialer.BeginObject(bRead, '');
    end;
  end;
end;

constructor TCtObject.Create;
begin
  Self.SetCtObjModified(True);
  Inc(FGlobeCtobjCounter);
  FGlobeCtoList.AddObject(IntToStr(PtrInt(Pointer(Self))), Self);
end;

function TCtObject.CreateDefSubitems: TCtObjectList;
begin
  Result := TCtObjectList.Create;
  Result.ItemClass := TCtObject;
end;

procedure TCtObject.DelAutoFree(Obj: TObject; bFreeit: Boolean);
var
  I, J, L: Integer;
begin
  for I := 0 to High(FAutoFreeObjs) do
    if FAutoFreeObjs[I] = Obj then
    begin
      for J := I to High(FAutoFreeObjs) - 1 do
        FAutoFreeObjs[J] := FAutoFreeObjs[J + 1];
      L := Length(FAutoFreeObjs);
      SetLength(FAutoFreeObjs, L - 1);
      Break;
    end;

  if bFreeit then
    FreeAndNil(Obj);
end;

destructor TCtObject.Destroy;
var
  idx: Integer;
  S: string;
begin
  idx := FGlobeCtoList.IndexOf(IntToStr(PtrInt(Pointer(Self))));
  if idx = -1 then
  begin
    try
      S := 'UnknownType';
      try
        S := Self.ClassName;
        S := S + ',' + Self.Name;
      except
      end;

      if idx = -1 then
        raise Exception.Create('Object FREE twice: ' + S);
    finally
      if idx = 1 then
        Self.ID := 1;
    end;
  end
  else
    FGlobeCtoList.Delete(idx);

  Dec(FGlobeCtobjCounter);
  //��������֪ͨ
  DoEvent(ctnfRelease);

  //֪ͨ���б�����б�
  if Assigned(FParentList) then
    FParentList.NotifyChildFree(Self);
  if Assigned(FGlobeList) then
    FGlobeList.Remove(Self);
  //�ͷ��Ӷ���͹�������������
  FreeAutoFree;
  if Assigned(FUserObjectList) then
    FUserObjectList.Free;

  inherited;
end;

procedure TCtObject.DoCustomEvent(EvtParamA, EvtParamB: string);
var
  VCeRes: TCtEventResult;
begin
  FillChar(VCeRes, SizeOf(VCeRes), 0);
  VCeRes.CtObj := Self;
  VCeRes.ParamA := EvtParamA;
  VCeRes.ParamB := EvtParamB;
  DoEvent(ctnfCustom, @VCeRes);
end;

procedure TCtObject.SetCtObjModified(bModified: Boolean);
begin
  if bModified then
    Inc(Self.FModifyCounter)
  else
    FModifyCounter := 0;
end;

procedure TCtObject.DoEvent(ANotify: TCtEventNotify;
  PCeRes: PCtEventResult);
var
  VCeRes: TCtEventResult;
begin
  if Assigned(FEventProcessor) then
  begin
    if PCeRes = nil then
    begin
      FillChar(VCeRes, SizeOf(VCeRes), 0);
      FEventProcessor.DoCtEvent(Self, ANotify, @VCeRes);
    end
    else
      FEventProcessor.DoCtEvent(Self, ANotify, PCeRes);
  end;
end;

procedure TCtObject.EndSerial(ASerialer: TCtObjSerialer; bRead: Boolean);
begin
  Dec(FSerialCounter);
  if FSerialCounter = 0 then
    if Assigned(ASerialer) then
      ASerialer.EndObject(bRead, IntToStr(ID));
end;

procedure TCtObject.FreeAutoFree;
var
  I: Integer;
begin
  for I := High(FAutoFreeObjs) downto 0 do
  begin
    FAutoFreeObjs[I].Free;
    SetLength(FAutoFreeObjs, I);
  end;
end;

function TCtObject.GetDisplayText: string;
begin
  if FCaption = '' then
  begin
    if FName <> '' then
      Result := FName
    else
    begin
      Result := ClassName + '_' + IntToStr(ID);
      if Copy(Result, 1, 1) = 'T' then
        Result := Copy(Result, 2, Length(Result));
    end;
  end
  else
    Result := FCaption;
end;

function TCtObject.GetEventProcessor: TCtEventProcessor;
begin
  if not Assigned(FEventProcessor) then
  begin
    FEventProcessor := TCtEventProcessor.Create;
    AddAutoFree(FEventProcessor);
  end;
  Result := FEventProcessor;
end;

function TCtObject.GetHasSubItems: Boolean;
begin
  Result := Assigned(FSubitems) and (FSubItems.Count > 0);
end;

function TCtObject.GetNameCaption: string;
begin
  Result := Name;
  if Result = '' then
    Result := Caption
  else if Caption <> '' then
    if Caption <> Name then
      Result := Result + '(' + Caption + ')';
end;

function TCtObject.GetParam(Name: string): string;
var
  I, po: Integer;
  S, LS: string;
begin
  Result := '';
  if not Assigned(ParamList) then
    Exit;
  with ParamList do
    for I := 0 to Count - 1 do
    begin
      S := Strings[I];
      po := pos('=', S);
      if po = 0 then
        Continue;
      LS := Copy(S, 1, po - 1);
      if LS = Name then
        Result := Copy(S, po + 1, Length(S));
    end;
end;

function TCtObject.GetParamList: TStrings;
begin
  Result := TStrings(UserObject['DEF_PARAMLIST']);
  if not Assigned(Result) then
  begin
    Result := TStringList.Create;
    AddAutoFree(Result);
    UserObject['DEF_PARAMLIST'] := Result;
  end;
end;

function TCtObject.GetSubitems: TCtObjectList;
begin
  if not Assigned(FSubitems) then
  begin
    if Assigned(FOnGetSubitems) then
      FOnGetSubitems(Self);
    if not Assigned(FSubitems) then
    begin
      FSubitems := CreateDefSubitems;
      AddAutoFree(FSubitems);
      //����GLOBELIST
      if Assigned(FSubitems) then
        FSubitems.GlobeList := Self.GlobeList;
    end;
  end;
  Result := FSubitems;
end;

function TCtObject.GetUserObject(Index: string): TObject;
var
  I: Integer;
begin
  Result := nil;
  if Assigned(FUserObjectList) then
  begin
    I := FUserObjectList.IndexOf(Index);
    if I >= 0 then
      Result := FUserObjectList.Objects[I];
  end;
end;

function TCtObject.GetUserObjectCount: Integer;
begin
  if FUserObjectList = nil then
    Result := 0
  else
    Result := FUserObjectList.Count;
end;

function TCtObject.GetUserObjectList: TStrings;
begin
  if FUserObjectList = nil then
  begin
    FUserObjectList := TStringList.Create;
    TStringList(FUserObjectList).Sorted := True;
  end;
  Result := FUserObjectList;
end;

function TCtObject.HasParams: Boolean;
begin
  Result := False;
  if UserObject['DEF_PARAMLIST'] = nil then
    Exit;
  if ParamList.Count > 0 then
    Result := True;
end;

procedure TCtObject.LoadFromFile(fn: string);
var
  fs: TCtObjSerialer;
begin             
  if Assigned(Proc_CreateCtObjSerialer) then
    fs := Proc_CreateCtObjSerialer(fn, False)
  else
    fs := TCtObjFileStream.Create(fn, fmOpenRead or fmShareDenyNone);
  try
    Self.LoadFromSerialer(fs);
  finally
    fs.Free;
  end;
end;

procedure TCtObject.LoadFromSerialer(ASerialer: TCtObjSerialer);
var
  S: string;
  L: Integer;
begin
  BeginSerial(ASerialer, True);
  try

  //��ֹ����ʱL̫��
    L := Length(DEF_CURCTVER);
    SetLength(S, L);
    ASerialer.ReadBuffer('CTVER', L, Pointer(S)^);
    if Copy(S, 1, 2) <> 'CT' then
    begin
      if not ASerialer.IsReadMode then
        RaiseCtException('Version_Verify_Error_And_Not_READMODE')
      else
        RaiseCtException('Version_Verify_Error');
    end;
    ASerialer.CurCtVer := StrToIntDef(Copy(S, 3, 2), 21);

    ASerialer.ReadInteger('ID', FID);
    if ASerialer.CurCtVer >= 23 then
      ASerialer.ReadString('CtGuid', FCtGuid);

    ASerialer.ReadInteger('PID', FPID);
    ASerialer.ReadInteger('RID', FRID);

    ASerialer.ReadString('Name', FName);
    ASerialer.ReadString('Caption', FCaption);
    ASerialer.ReadString('TypeName', FTypeName);
    ASerialer.ReadString('Memo', FMemo);

    ASerialer.ReadInteger('Creator', FCreator);
    ASerialer.ReadDate('CreateDate', FCreateDate);
    ASerialer.ReadString('CreatorName', FCreatorName);
    ASerialer.ReadInteger('Modifier', FModifier);
    ASerialer.ReadDate('ModifyDate', FModifyDate);
    ASerialer.ReadString('ModifierName', FModifierName);

    ASerialer.ReadInteger('VersionNo', FVersionNo);
    ASerialer.ReadInteger('HistoryID', FHistoryID);
    ASerialer.ReadString('LockStamp', FLockStamp);

    ASerialer.ReadByte('DataLevel', Byte(FDataLevel));
    ASerialer.ReadFloat('OrderNo', FOrderNo);

    if ASerialer.CurCtVer >= 23 then
    begin
      S := '';
      ASerialer.ReadStrings('Params', S);
      if HasParams then
        ParamList.Text := S
      else if S <> '' then
        ParamList.Text := S;

      ASerialer.ReadStrings('CustomAttr1', FCustomAttr1);
      ASerialer.ReadStrings('CustomAttr2', FCustomAttr2);
      ASerialer.ReadStrings('CustomAttr3', FCustomAttr3);
      ASerialer.ReadStrings('CustomAttr4', FCustomAttr4);
      ASerialer.ReadStrings('CustomAttr5', FCustomAttr5);
    end;

    Self.SetCtObjModified(True);

    if Assigned(FSubitems) then
      FSubitems.Clear;

  finally
    EndSerial(ASerialer, True);
  end;
end;

procedure TCtObject.RaiseCtException(const msg: string);
begin
  raise Exception.Create(msg);
end;

procedure TCtObject.Reset;
begin
  //����֪ͨ
  DoEvent(ctnfReset);

  FID := 0;
  FCtGuid := '';
  FPID := 0;
  FRID := 0;

  FName := '';
  FCaption := '';
  FTypeName := '';
  FMemo := '';

  FCreator := 0;
  FModifier := 0;
  FCreatorName := '';
  FCreateDate := Now;
  FModifyDate := FCreateDate;
  FModifierName := '';

  FVersionNo := 0;
  FHistoryID := 0;
  FLockStamp := '';

  FSerialCounter := 0;

  FDataLevel := ctdlUnknown;

  if Self.HasParams then
    Self.ParamList.Clear;

  FCustomAttr1 := '';
  FCustomAttr2 := '';
  FCustomAttr3 := '';
  FCustomAttr4 := '';
  FCustomAttr5 := '';

  Self.SetCtObjModified(True);

  if Assigned(FSubitems) then
    FSubitems.Clear;
end;

procedure TCtObject.SaveToFile(fn: string);
var
  fs: TCtObjSerialer;
begin
  if FileExists(fn) then
    if not DeleteFile(fn) then
      RaiseLastOSError;
  if Assigned(Proc_CreateCtObjSerialer) then
    fs := Proc_CreateCtObjSerialer(fn, True)
  else
    fs := TCtObjFileStream.Create(fn, fmCreate);
  try
    Self.SaveToSerialer(fs);
  finally
    fs.Free;
  end;
end;

function TCtObject.SaveToTempFile(ext: string): string;
var
  fn: String;
begin
  if ext='' then
    ext:='json';
  if Pos('.', ext)=0 then
    ext := '.'+ext;
  fn := ext;
  if Pos('/', fn)=0 then
    if Pos('\', fn)=0 then
      fn := Self.Name+ext;
  Result := GetAppTempFileName(fn);
  Self.SaveToFile(Result);
end;

function TCtObject.ExecCmd(ACmd, AParam1, AParam2: string): string;
begin
  Result := '';
end;

procedure TCtObject.SaveToSerialer(ASerialer: TCtObjSerialer);
var
  S: string;
begin
  Assert(ASerialer <> nil);

  ASerialer.CurCtVer := StrToIntDef(Copy(DEF_CURCTVER, 3, 2), 21);

  BeginSerial(ASerialer, False);
  try

    S := DEF_CURCTVER;
    ASerialer.WriteBuffer('CTVER', Length(S), Pointer(S)^);

    ASerialer.WriteInteger('ID', FID);
    ASerialer.WriteString('CtGuid', FCtGuid);
    ASerialer.WriteInteger('PID', FPID);
    ASerialer.WriteInteger('RID', FRID);

    ASerialer.WriteString('Name', FName);
    ASerialer.WriteString('Caption', FCaption);
    ASerialer.WriteString('TypeName', FTypeName);
    ASerialer.WriteString('Memo', FMemo);

    ASerialer.WriteInteger('Creator', FCreator);
    ASerialer.WriteDate('CreateDate', FCreateDate);
    ASerialer.WriteString('CreatorName', FCreatorName);
    ASerialer.WriteInteger('Modifier', FModifier);
    ASerialer.WriteDate('ModifyDate', FModifyDate);
    ASerialer.WriteString('ModifierName', FModifierName);

    ASerialer.WriteInteger('VersionNo', FVersionNo);
    ASerialer.WriteInteger('HistoryID', FHistoryID);
    ASerialer.WriteString('LockStamp', FLockStamp);

    ASerialer.WriteByte('DataLevel', Byte(FDataLevel));
    ASerialer.WriteFloat('OrderNo', FOrderNo);

    S := '';
    if HasParams then
    begin
      S := ParamList.Text;
      while Copy(S, Length(S) - 1, 2) = #13#10 do
        S := Copy(S, 1, Length(S) - 2);      
      while Copy(S, Length(S) - 1, 1) = #10 do
        S := Copy(S, 1, Length(S) - 1);
    end;
    ASerialer.WriteStrings('Params', S);

    ASerialer.WriteStrings('CustomAttr1', FCustomAttr1);
    ASerialer.WriteStrings('CustomAttr2', FCustomAttr2);
    ASerialer.WriteStrings('CustomAttr3', FCustomAttr3);
    ASerialer.WriteStrings('CustomAttr4', FCustomAttr4);
    ASerialer.WriteStrings('CustomAttr5', FCustomAttr5);

  finally
    EndSerial(ASerialer, False);
  end;
end;

procedure TCtObject.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TCtObject.SetGlobeList(const Value: TCtGlobList);
begin
  FGlobeList := Value;
  if Assigned(FGlobeList) and Assigned(FSubitems) and not Assigned(FSubitems.GlobeList) then
    FSubitems.GlobeList := Self.FGlobeList;
end;

procedure TCtObject.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FPreName := FName;
    FName := Value;
  end;
end;

procedure TCtObject.SetParam(Name: string; const Value: string);
var
  I, po: Integer;
  S, LS, V: string;
begin
  if not Assigned(ParamList) then
    Exit;
  V := StringReplace(Value, #13, '[#13]', [rfReplaceAll]);
  V := StringReplace(V, #10, '[#10]', [rfReplaceAll]);
  for I := 0 to ParamList.Count - 1 do
  begin
    S := ParamList[I];
    po := pos('=', S);
    if po = 0 then
      Continue;
    LS := Copy(S, 1, po - 1);
    if LS = Name then
    begin
      ParamList[I] := LS + '=' + V;
      Exit;
    end;
  end;
  ParamList.Add(Name + '=' + V);
end;

procedure TCtObject.SetUserObject(Index: string; const Value: TObject);
var
  I: Integer;
begin
  I := UserObjectList.IndexOf(Index);
  if I >= 0 then
    UserObjectList.Objects[I] := Value
  else
    UserObjectList.AddObject(Index, Value);
end;

procedure TCtObject.SortByName;
begin
  if Assigned(FSubitems) then
    FSubitems.SortByName;
end;

procedure TCtObject.SortByOrderNo;
var
  I: Integer;
begin
  if Assigned(FSubitems) then
  begin
    FSubitems.SortByOrderNo;
    for I := 0 to FSubitems.Count - 1 do
      FSubitems.Items[I].SortByOrderNo;
  end;
end;

{ TCtObjectList }

procedure TCtObjectList.AssignFrom(ACtObj: TCtObjectList);
var
  I: Integer;
begin
  if ACtObj = nil then
    Clear
  else if ACtObj is TCtObjectList then
  begin
    Clear;
    for I := 0 to TCtObjectList(ACtObj).Count - 1 do
      NewObj.AssignFrom(TCtObjectList(ACtObj).Items[I]);
  end;
end;

function TCtObjectList.CreateObj: TCtObject;
begin
  if Assigned(FItemClass) then
    Result := FItemClass.Create
  else
    Result := TCtObject.Create;
  if Result.Name = '' then
    Result.Name := 'New CtObject';
end;

destructor TCtObjectList.Destroy;
begin
  if Assigned(FInnerGlobeList) then
    FreeAndNil(FInnerGlobeList);
  inherited;
end;

procedure TCtObjectList.ExpandItem(AItem: TCtObject);
begin
end;

function TCtObjectList.GetCtItem(Index: Integer): TCtObject;
begin
  Result := TCtObject(inherited Get(Index));
end;

function TCtObjectList.ItemByID(AID: Integer): TCtObject;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Assigned(Items[I]) and (Items[I].ID = AID) then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TCtObjectList.ItemByName(AName: string;
  bCaseSensive: Boolean): TCtObject;
var
  I: Integer;
begin
  if AName='' then
    Exit;
  if bCaseSensive then
  begin
    for I := 0 to Count - 1 do
      if Assigned(Items[I]) and (Items[I].Name = AName) then
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
      if Assigned(Items[I]) and (UpperCase(Items[I].Name) = AName) then
        if Items[I].DataLevel <> ctdlDeleted then
        begin
          Result := Items[I];
          Exit;
        end;
  end;
  Result := nil;


end;

constructor TCtObjectList.Create;
begin
  inherited;
  FAutoFree := True;
end;

function TCtObjectList.CreateGlobeList: TCtGlobList;
begin
  if not Assigned(FGlobeList) then
  begin
    if not Assigned(FInnerGlobeList) then
      FInnerGlobeList := TCtGlobList.Create;
    FGlobeList := FInnerGlobeList;
  end;
  Result := FGlobeList;
end;

procedure TCtObjectList.LoadFromSerialer(ASerialer: TCtObjSerialer);
var
  I, C: Integer;
begin
  Assert(ASerialer <> nil);

  Clear;
  ASerialer.ReadInteger('Count', C);
  ASerialer.BeginChildren('');
  if ASerialer.ChildCountInvalid then
  begin
    while ASerialer.NextChildObjToRead do
      NewObj.LoadFromSerialer(ASerialer);
  end
  else
    for I := 0 to C - 1 do
    begin
      if ASerialer.NextChildObjToRead then
        NewObj.LoadFromSerialer(ASerialer);
    end;
  ASerialer.EndChildren('');
end;

procedure TCtObjectList.MereRemove(AItem: TCtObject);
var
  bsAutoFree: Boolean;
begin
  bsAutoFree := AutoFree;
  try
    AutoFree := False;
    Remove(AItem);
  finally
    AutoFree := bsAutoFree;
  end;
end;

function TCtObjectList.NewObj: TCtObject;
begin
  //�������࣬�����ø�ָ��ָ���б�
  Result := CreateObj;
  Result.ParentList := Self;
  //�ӹ������ٴ���������Ĺ���
  Result.OnGetSubItems := Self.ExpandItem;

  //����ȫ���б�
  if not Assigned(GlobeList) then
    GlobeList := CreateGlobeList;
  Result.GlobeList := Self.GlobeList;
  if Result.ID = 0 then
    Result.ID := GlobeList.GenNewItemID;

  //�����б���
  Add(Result);
  GlobeList.Add(Result);
  SaveCurrentOrder;
end;

procedure TCtObjectList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  if Action = lnAdded then
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtObject) then
        if TCtObject(Ptr).ParentList = nil then
          TCtObject(Ptr).ParentList := Self;
end;

procedure TCtObjectList.NotifyChildFree(AItem: TCtObject);
begin
  MereRemove(AItem);
end;

procedure TCtObjectList.PutCtItem(Index: Integer; const Value: TCtObject);
begin
  inherited Put(Index, Value);
end;

procedure TCtObjectList.RaiseCtException(const msg: string);
begin
  raise Exception.Create(msg);
end;

procedure TCtObjectList.SaveToSerialer(ASerialer: TCtObjSerialer);
var
  I, C: Integer;
begin
  Assert(ASerialer <> nil);
  SortByOrderNo;

  C := Count;
  ASerialer.WriteInteger('Count', C);
  ASerialer.BeginChildren('');
  for I := 0 to C - 1 do
  begin
    Items[I].SaveToSerialer(ASerialer);
  end;
  ASerialer.EndChildren('');
end;

procedure TCtObjectList.SortByName;
var
  I: Integer;
  bChg: Boolean;
begin
  Self.SaveCurrentOrder;
  Sort(CtoListNameSortCompare);

  bChg := False;
  for I := 0 to Count - 1 do
    if Items[I].OrderNo <> I + 1 then
    begin
      bChg := True;
    end;
  if not bChg then
    Sort(CtoListNameDescSortCompare);
  Self.SaveCurrentOrder;
end;

procedure TCtObjectList.SortByOrderNo;
begin
  Sort(CtoListOrderNoSortCompare);
end;

function TCtObjectList.NameOfID(AID: Integer): string;
var
  o: TCtObject;
begin
  o := ItemByID(AID);
  if Assigned(o) then
    Result := o.DisplayText
  else
    Result := 'NONE';
end;

function TCtObjectList.ValidItemCount: Integer;
var
  I: Integer;
  o: TCtObject;
begin
  Result := 0;
  for I := Count - 1 downto 0 do
    if Assigned(Items[I]) and (Items[I].DataLevel <> ctdlDeleted) then
    begin
      Inc(Result);
    end;
end;

procedure TCtObjectList.SaveCurrentOrder;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OrderNo := I + 1;
end;

procedure TCtObjectList.Pack;
var
  I: Integer;
  o: TCtObject;
begin
  inherited Pack;
  for I := Count - 1 downto 0 do
    if Assigned(Items[I]) and (Items[I].DataLevel = ctdlDeleted) then
    begin
      o := Items[I];
      MereRemove(o);
      o.Free;
    end;
end;

{ TCtTreeList }

function TCtTreeList.CreateObj: TCtObject;
begin
  if Assigned(ItemClass) then
  begin
    Result := ItemClass.Create;
    if not (Result is TCtTreeNode) then
    begin
      Result.Free;
      RaiseCtException('Invalid class');
    end;
  end
  else
    Result := TCtTreeNode.Create;
  //���������б���Ҫ���Զ��ͷ�
  //Result.SubItems := TCtTreeList.Create;
  //Result.AddAutoFree(Result.SubItems);
  if Assigned(Result.SubItems) and Assigned(FOwnerNode) then
  begin
    Result.PID := FOwnerNode.ID;
    if Result is TCtTreeNode then
      TCtTreeNode(Result).FParentNode := FOwnerNode;
  end;
  TCtTreeList(Result.SubItems).ItemClass := Self.ItemClass;
  if Result.Name = '' then
    Result.Name := 'New Node';
end;

procedure TCtTreeList.ExpandItem(AItem: TCtObject);
begin
  if not (AItem is TCtTreeNode) then
    Exit;
end;


procedure TCtTreeList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;

  if Action = lnAdded then
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtTreeNode) then
        if TCtTreeNode(Ptr).ParentNode = nil then
          if Assigned(OwnerNode) then
            TCtTreeNode(Ptr).ParentNode := Self.OwnerNode;
end;

{ TCtTreeNode }

procedure TCtTreeNode.AssignTreeNodes(Source: TCtTreeNode; bNewID: Boolean);
var
  I, vID, vPID: Integer;
  nNode: TCtTreeNode;
begin
  vID := ID;
  vPID := PID;
  AssignFrom(Source);
  if bNewID then
  begin
    ID := vID;
    PID := vPID;
  end;
  if Assigned(FSubitems) then
    FSubitems.Clear;
  if not Assigned(Source) or (Source.Count <= 0) then
    Exit;
  for I := 0 to Source.Count - 1 do
  begin
    nNode := TCtTreeNode(SubItems.NewObj);
    nNode.AssignTreeNodes(Source.Items[I], bNewID);
  end;
end;

function TCtTreeNode.CreateDefSubitems: TCtObjectList;
begin
  Result := TCtTreeList.Create;
  TCtTreeList(Result).ItemClass := TCtTreeNode;
end;

function TCtTreeNode.GetCount: Integer;
begin
  if Assigned(FSubitems) then
    Result := FSubitems.Count
  else
    Result := 0;
end;

function TCtTreeNode.GetFullPathName: string;
begin
  Result := GetPath;
  if Result = '' then
    Result := Self.Name
  else
    Result := Result + '\' + Self.Name;
end;

function TCtTreeNode.GetItems(Index: Integer): TCtTreeNode;
begin
  if Assigned(FSubitems) then
    Result := FSubitems.Items[Index] as TCtTreeNode
  else
    Result := nil;
end;

function TCtTreeNode.GetPath: string;
begin
  if Assigned(ParentNode) then
    Result := ParentNode.GetFullPathName
  else
    Result := '';
end;

function TCtTreeNode.GetSubitems: TCtObjectList;
begin
  if not Assigned(FSubitems) then
  begin
    inherited GetSubitems;
    if FSubItems is TCtTreeList then
      TCtTreeList(FSubItems).OwnerNode := Self;
  end;
  Result := FSubitems;
end;

function TCtTreeNode.GetSubNodeByPath(APath: string): TCtTreeNode;
var
  po: Integer;
  S: string;
  res: TCtObject;
begin
  Result := nil;
  if not Assigned(FSubitems) then
    Exit;

  po := Pos('\', APath);
  if po > 0 then
  begin
    S := Copy(APath, 1, po - 1);
    APath := Copy(APath, po + 1, Length(APath));
  end
  else
  begin
    S := APath;
    APath := '';
  end;

  if S = '.' then
    res := Self
  else if S = '..' then
    res := ParentNode
  else
    res := SubItems.ItemByName(S);
  if res is TCtTreeNode then
  begin
    if APath = '' then
      Result := TCtTreeNode(res)
    else
      Result := TCtTreeNode(res).GetSubNodeByPath(APath);
  end;
end;

procedure TCtTreeNode.MoveTo(TgNode: TCtTreeNode);
begin
  if FParentNode = TgNode then
    Exit;
  if Assigned(FParentNode) then
    FParentNode.SubItems.MereRemove(Self);
  if Assigned(FParentList) then
    FParentList.MereRemove(Self);
  FParentList := nil;

  ParentNode := TgNode;

  if Assigned(FParentNode) then
  begin
    PID := FParentNode.ID;
    if FParentNode.SubItems.IndexOf(Self) < 0 then
      FParentNode.SubItems.Add(Self);
    FParentList := FParentNode.SubItems;
  end
  else
    PID := 0;
end;

function TCtTreeNode.NewSubItem(nam: string): TCtTreeNode;
begin
  Result := SubItems.NewObj as TCtTreeNode;
  Result.PID := Self.ID;
  if nam <> '' then
    Result.Name := nam;
end;

procedure TCtTreeNode.SetParentNode(const Value: TCtTreeNode);
begin
  if FParentNode = Value then
    Exit;
  FParentNode := Value;
end;

{ TCtEventProcessor }

procedure TCtEventProcessor.AddSubscriber(
  const ASubscriber: TCtEventSubscriber);
var
  I, L: Integer;
begin
  L := Length(FSubscribers);
  for I := 0 to L - 1 do
    if SameMethod(FSubscribers[I], ASubscriber) then
      Exit;
  SetLength(FSubscribers, L + 1);
  FSubscribers[L] := ASubscriber;
end;

constructor TCtEventProcessor.Create;
begin
  FEnabled := True;
end;

procedure TCtEventProcessor.DoCtEvent(Sender: TCtObject;
  ANotify: TCtEventNotify; PCeRes: PCtEventResult);
var
  I: Integer;
begin
  if not FEnabled then
    Exit;
  if Assigned(PCeres) and not Assigned(PCeRes^.CtObj) then
    PCeres^.CtObj := Sender;
  for I := High(FSubscribers) downto 0 do
    if not Assigned(PCeRes) or (PCeRes^.Result = 0) then
      FSubscribers[I](Sender, ANotify, PCeRes);
end;

procedure TCtEventProcessor.RemoveSubscriber(
  const ASubscriber: TCtEventSubscriber);
var
  I, J, L: Integer;
begin
  L := Length(FSubscribers);
  for I := 0 to L - 1 do
    if SameMethod(FSubscribers[I], ASubscriber) then
    begin
      if I < L - 1 then //����պ�Ϊ���һ�����������ƶ�
        for J := I to L - 2 do
          FSubscribers[J] := FSubscribers[J + 1];
      SetLength(FSubscribers, L - 1);
      Break;
    end;
end;

procedure TCtEventProcessor.Reset;
begin
  SetLength(FSubscribers, 0);
end;

{ TCtGlobList }

procedure TCtGlobList.AutoRegenObjIDs(ARootNode: TCtObject);
  procedure doit(AObj: TCtObject);
  var
    I: Integer;
  begin
    if AObj.FSubItems = nil then
      Exit;
    with AObj.SubItems do
    begin
      for I := 0 to Count - 1 do
      begin
        Items[I].ID := Self.GenNewItemID;
        Items[I].PID := AObj.ID;
      end;
      for I := 0 to Count - 1 do
        doit(Items[I]);
    end;
  end;
begin
  ARootNode.ID := Self.GenNewItemID;
  doit(ARootNode);
end;

procedure TCtGlobList.CheckMaxSeq;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if TObject(Items[I]) is TCtObject then
      if TCtObject(Items[I]).ID > FSeqCounter then
      begin
        FSeqCounter := TCtObject(Items[I]).ID;
      end;
end;

constructor TCtGlobList.Create;
begin
  inherited;

end;

destructor TCtGlobList.Destroy;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if TCtObject(Items[I]).FGlobeList = Self then
      TCtObject(Items[I]).FGlobeList := nil;
  inherited;
end;

function TCtGlobList.GenNewItemID: Integer;
begin
  Inc(FSeqCounter);
  Result := FSeqCounter;
end;

procedure TCtGlobList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  if Action = lnAdded then
    if (Ptr <> nil) then
      if (TObject(Ptr) is TCtObject) then
        if TCtObject(Ptr).ID > FSeqCounter then
          FSeqCounter := TCtObject(Ptr).ID;
end;

{ TCtObjFactory }

function TCtObjFactory.CreateNew: TCtObject;
begin
  if Assigned(FObjClass) then
  begin
    Inc(FIDSeq);
    Result := FObjClass.Create;
    if Result.ID = 0 then
      Result.ID := FIDSeq;
    FLastObject := Result;
  end
  else
    Result := nil;
end;

{ TCtFactoryRegstry }

procedure TCtFactoryRegstry.AddFactory(AFactory: TCtObjFactory);
begin
  Add(AFactory);
end;

function TCtFactoryRegstry.CreateCtObj(AName: string): TCtObject;
var
  f: TCtObjFactory;
begin
  f := FindFactory(AName);
  if Assigned(f) then
    Result := f.CreateNew
  else
    Result := nil;
end;

function TCtFactoryRegstry.FindFactory(AName: string): TCtObjFactory;
var
  I: Integer;
  guid: string;
begin
  Result := nil;
  if UpperCase(Copy(AName, 1, 5)) = 'GUID:' then
  begin
    guid := UpperCase(Copy(AName, 6, Length(AName)));
    for I := 0 to Count - 1 do
      if UpperCase(GetItem(I).Guid) = guid then
      begin
        Result := GetItem(I);
        Exit;
      end;
  end
  else
    for I := 0 to Count - 1 do
      if UpperCase(GetItem(I).Name) = UpperCase(AName) then
      begin
        Result := GetItem(I);
        Exit;
      end;
end;

function TCtFactoryRegstry.FindOrCreateFactory(const AName, ACap, AGuid: string;
  const AClass: TCtObjectClass): TCtObjFactory;
begin
  Result := FindFactory(AName);
  if Result = nil then
    Result := FindFactory('guid:' + AGuid);
  if Result = nil then
  begin
    Result := TCtObjFactory.Create;
    Result.FName := AName;
    Result.FGuid := AGuid;
    Result.FCap := ACap;
    Result.FObjClass := AClass;
    Add(Result);
  end;
end;

function TCtFactoryRegstry.GetItem(Index: Integer): TCtObjFactory;
begin
  Result := TObject(Items[Index]) as TCtObjFactory;
end;

{ TCtAutoFreeList }

constructor TCtAutoFreeList.Create;
begin
  inherited Create;
  Inc(FGlobeCtlstCounter);
end;

destructor TCtAutoFreeList.Destroy;
begin
  Dec(FGlobeCtlstCounter);
  inherited;
end;

procedure TCtAutoFreeList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;

  if FAutoFree then
    if Action = lnDeleted then
      if Assigned(Ptr) then
      begin
        TObject(Ptr).Free;
      end;
end;

initialization
  FGlobeCtoList := TStringList.Create;
  FGlobeCtoList.Sorted := True;
  GlobeCtFactories.FindOrCreateFactory('CtObject', '����CT����', '{E8D33D36-66DF-4568-8537-F24A1EDE0588}', TCtObject);
finalization
  if Assigned(FGlobeCtFactories) then
    FreeAndNil(FGlobeCtFactories);
{$IFOPT D+}
  //if (FGlobeCtobjCounter <> 0) or (FGlobeCtlstCounter <> 0) then
    //Windows.MessageBox(0, PChar('CtObject Count: ' + IntToStr(FGlobeCtobjCounter) +
      //'  CtList Count: ' + IntToStr(FGlobeCtlstCounter)), 'Memory leak check info', MB_OK or MB_ICONWARNING);
  FGlobeCtoList.Free;
{$ENDIF}

end.


