(*
  ###Pascal Code Generate###
  CtMetaChange
  Create by User(EMAIL) 2025/11/11 21:53:49
  数据变化记录

CtMetaChange(数据变化记录)
----------------------------------
Id(编号)              PKInteger
ObjName(对象名称)     String(255)
ObjType(对象类型)     String
CtGuid(唯一标识)      String
ParentGuid(上级标识)  String
ChangeType(变化类型)  Enum         //0未知 1新增 2修改 3图形 4子对象排序 5移除
ModifyDate(修改日期)  Date

*)

unit CtMetaChange;

interface

uses
  Classes, SysUtils, Variants, Graphics, Controls, CtMetaTable, CTMetaData,
  uJSON;

type

  { 数据变化记录 }

  { TCtMetaChange }

  TCtMetaChange = class(TObject)
  private
  protected
    FId: integer;
    FObjName: string;
    FObjType: string;
    FCtGuid: string;          
    FParentGuid: string;
    FChangeType: TCtMetaChangeType;
    FModifyDate: TDateTime;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Reset; virtual;
    procedure AssignFrom(AObj: TCtMetaChange); virtual;

    procedure InitWithObj(AObj: TObject; tp: TCtMetaChangeType); virtual;

    //编号
    property Id: integer read FId write FId;
    //对象名称
    property ObjName: string read FObjName write FObjName;
    //对象类型
    property ObjType: string read FObjType write FObjType;
    //唯一标识
    property CtGuid: string read FCtGuid write FCtGuid;   
    //上级标识
    property ParentGuid: string read FParentGuid write FParentGuid;
    //变化类型 0未知 1新增 2修改 3图形 4子对象排序 5移除
    property ChangeType: TCtMetaChangeType read FChangeType write FChangeType;
    //修改日期
    property ModifyDate: TDateTime read FModifyDate write FModifyDate;

  end;

  { TCtMetaChangeList }

  TCtMetaChangeList = class(TList)
  private
    FTbLocks: TJSONObject;
    function GetItem(Index: integer): TCtMetaChange;
    procedure PutItem(Index: integer; const Value: TCtMetaChange);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    destructor Destroy; override;

    function AddTbLock(ATbGuid: string; actTp: Integer): Boolean;       
    function RemoveTbLock(ATbGuid: string; bPrevRelease: Boolean): Boolean;

    procedure Clear; override;
    function NewItem: TCtMetaChange; virtual;
    function NewChangeItem(AObj: TObject; tp: TCtMetaChangeType): TCtMetaChange; virtual;
    property Items[Index: integer]: TCtMetaChange read GetItem write PutItem; default;
  end;

implementation

uses
  WindowFuncs;

{ TCtMetaChange }

constructor TCtMetaChange.Create;
begin
  inherited;
end;

destructor TCtMetaChange.Destroy;
begin
  inherited;
end;

procedure TCtMetaChange.Reset;
begin
  FId := 0;
  FObjName := '';
  FObjType := '';
  FCtGuid := '';       
  ParentGuid := '';
  FChangeType := cmctNone;
  FModifyDate := 0;
end;

procedure TCtMetaChange.AssignFrom(AObj: TCtMetaChange);
begin
  if not Assigned(AObj) then
  begin
    Reset;
  end;
  FId := AObj.FId;
  FObjName := AObj.FObjName;
  FObjType := AObj.FObjType;
  FCtGuid := AObj.FCtGuid;       
  FParentGuid := AObj.FParentGuid;
  FChangeType := AObj.FChangeType;
  FModifyDate := AObj.FModifyDate;
end;

procedure TCtMetaChange.InitWithObj(AObj: TObject; tp: TCtMetaChangeType);
  procedure SyncTbGuids(AName, AGuid: String); 
  var
    I, J: integer; 
    tbs: TCtMetaTableList;  
    tb: TCtMetaTable;
  begin
    for I := 0 to FGlobeDataModelList.Count - 1 do
    begin
      tbs := FGlobeDataModelList.Items[I].Tables;
      for J := 0 to tbs.Count - 1 do
      begin
        tb := tbs.Items[J];
        if tb.DataLevel <> ctdlDeleted then
          if UpperCase(tb.Name) = UpperCase(AName) then
          begin
            if tb.CtGuid = '' then
              tb.CtGuid := AGuid
            else if tb.CtGuid<>AGuid then
              raise Exception.Create('Sync table '+AName+' guid failed: exists - '+tb.CtGuid);
          end;
      end;
    end;
  end;
var
  ctObj: TCtObject;
  tbs: TCtMetaTableList;
begin
  if AObj = nil then
    Exit;
  ctObj := nil;
  if AObj is TCtMetaTable then
  begin
    ctObj := TCtMetaTable(AObj);
    FObjType := 'table';
    if TCtMetaTable(AObj).OwnerList =nil then
      raise Exception.Create('Table owner should not be empty');
    if TCtMetaTable(AObj).OwnerList.OwnerModel = nil then
      raise Exception.Create('Table owner model should not be empty');
    if ctObj.CtGuid='' then
    begin
      if not (tp in [cmctNew, cmctModify]) then   
        raise Exception.Create('Table CtGuid should not be empty');
      ctObj.CtGuid := CtGenGuid;
      SyncTbGuids(ctObj.Name, ctObj.CtGuid);
    end;
    FParentGuid := TCtMetaTable(AObj).OwnerList.OwnerModel.CtGuid;
    if FParentGuid = '' then
    begin         
      raise Exception.Create('Table Owner CtGuid should not be empty');
    end;
  end  
  else if AObj is TCtDataModelGraph then
  begin
    ctObj := TCtDataModelGraph(AObj);
    FObjType := 'model';   
    if ctObj.CtGuid='' then
    begin
      if not (tp in [cmctNew, cmctModify]) then
        raise Exception.Create('Model CtGuid should not be empty');
      ctObj.CtGuid := CtGenGuid;
    end;
  end
  else if AObj is TCtMetaTableList then
  begin
    tbs := TCtMetaTableList(AObj);
    ctObj := tbs.OwnerModel;
    FObjType := 'table_list';
  end
  else if AObj is TCtDataModelGraphList then
  begin
    ctObj := TCtDataModelGraphList(AObj).ModelFileConfig;
    FObjType := 'model_list';
  end;
  if ctObj = nil then
    Exit;
  FObjName := ctObj.Name;
  FCtGuid := ctObj.CtGuid;  
  if FCtGuid='' then
    raise Exception.Create('CtGuid should not be empty');
  FChangeType := tp;
  FModifyDate := Now;
end;


{ TCtMetaChangeList }

function TCtMetaChangeList.GetItem(Index: integer): TCtMetaChange;
begin
  Result := TCtMetaChange(inherited Get(Index));
end;

procedure TCtMetaChangeList.PutItem(Index: integer; const Value: TCtMetaChange);
begin
  inherited Put(Index, Value);
end;

function TCtMetaChangeList.NewItem: TCtMetaChange;
begin
  Result := TCtMetaChange.Create;
  Add(Result);
end;

function TCtMetaChangeList.NewChangeItem(AObj: TObject; tp: TCtMetaChangeType
  ): TCtMetaChange;
begin
  if AObj = nil then
  begin
    Result := nil;
    Exit;
  end;
  Result := NewItem;
  Result.InitWithObj(AObj, tp);
end;

procedure TCtMetaChangeList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  if Action = lnDeleted then
    if Assigned(Ptr) then
      TObject(Ptr).Free;
end;

destructor TCtMetaChangeList.Destroy;
begin
  FreeAndNil(FTbLocks);
  inherited Destroy;
end;

function TCtMetaChangeList.AddTbLock(ATbGuid: string; actTp: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if FTbLocks=nil then
    FTbLocks := TJSONObject.Create;
  i := FTbLocks.optInt(ATbGuid);
  if i>0 then
  begin
    if (actTp=1) then
    begin
      if i=2 then
      begin
        FTbLocks.put(ATbGuid, 1);
      end;
    end;
    Exit;
  end;
  FTbLocks.put(ATbGuid, actTp);
  Result := True;
end;

function TCtMetaChangeList.RemoveTbLock(ATbGuid: string; bPrevRelease: Boolean): Boolean;
var
  I: Integer;
begin      
  Result := False;
  if FTbLocks=nil then
    Exit;
  if not FTbLocks.has(ATbGuid) then
    Exit;
  I := FTbLocks.optInt(ATbGuid);
  if bPrevRelease then
    if I <> 2 then
      Exit;
  FTbLocks.remove(ATbGuid);
  Result := True;
end;

procedure TCtMetaChangeList.Clear;
begin
  inherited Clear; 
  FreeAndNil(FTbLocks);
end;


end.


