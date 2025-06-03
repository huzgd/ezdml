{
  从数据库读写对象
  内含一个DATASET，每次根据OBJID生成SQL来读写对象记录
  循环读取子节点时，将创建临时QUERY来查找PID为当前对象ID的子节点
  2006/07/05 by huz
}
unit CtObjDbSerial;

interface

uses
  Classes, SysUtils, DB,
  CtMetaData, CtMetaTable, CtObjSerialer, WindowFuncs;

type

  { TCtObjDbSerial }

  TCtObjDbSerial = class(TCtObjSerialer)
  private
  protected               
    FDbFileName: string;
    FDBEngine: TCtMetaDatabase;
    FInnerDataSet: TDataSet;
    FDataSet: TDataSet;
    FCurDataSec: string;

    FCurDSObjID: string;
    FObjTableName: string;
    FObjPKField: string;
    FObjPIDField: string;
    FCurObjModified: Boolean;

    FCurChildQuery: TDataSet;
    FObjChildQuerys: array of TDataSet;
    FChildQueryReady: Integer; //0－未初始化；1－已初始化；2－已执行
  protected
    procedure SetObjID(const Value: string); override;
  public
    constructor Create(const ADBEngine: TCtMetaDatabase; fn: String; bReadOnly: Boolean); virtual; overload;
    destructor Destroy; override;
               
    //生成子数据查询
    procedure NewChildQuery;
    //释放子数据查询
    procedure ReleaseChildQuery;

    procedure CheckSectionName; override;
    procedure ReloadCurDSObjID; virtual;
    function GenObjSql(incSubs: Boolean): string; virtual;
    function GenChildIDSql: string; virtual;
    procedure CheckObjPost; virtual;
    procedure CheckObjID; virtual;
    procedure CheckDsEdit; virtual;
    procedure SetPropModified; virtual;
    function GetPropField(const PropName: string): TField; virtual;

    function NextChildObjToRead: Boolean; override;
    function NewObjToWrite(AID: Integer): Boolean; override;
    function EOF: Boolean; override;
    //切换到子对象
    procedure BeginChildren(AGroupName: string); override;
    procedure EndChildren(AGroupName: string); override;

    procedure PreDeleteChildren(PID: Integer); virtual;

    procedure ReadString(const PropName: string; var PropValue: string); override;
    procedure ReadBool(const PropName: string; var PropValue: Boolean); override;
    procedure ReadNotBool(const PropName: string; var PropValue: Boolean); override;
    procedure ReadInteger(const PropName: string; var PropValue: Integer); override;
    procedure ReadFloat(const PropName: string; var PropValue: Double); override;
    procedure ReadDate(const PropName: string; var PropValue: TDateTime); override;
    procedure ReadBuffer(const PropName: string; const Len: LongInt; var PropValue); override;  
    procedure ReadStrings(const PropName: string; var PropValue: string); override;

    procedure WriteString(const PropName: string; const PropValue: string); override;
    procedure WriteBool(const PropName: string; const PropValue: Boolean); override;
    procedure WriteNotBool(const PropName: string; const PropValue: Boolean); override;
    procedure WriteInteger(const PropName: string; const PropValue: Integer); override;
    procedure WriteFloat(const PropName: string; const PropValue: Double); override;
    procedure WriteDate(const PropName: string; const PropValue: TDateTime); override;
    procedure WriteBuffer(const PropName: string; const Len: LongInt; const PropValue); override; 
    procedure WriteStrings(const PropName: string; const PropValue: string); override;

    property DataSet: TDataSet read FDataSet write FDataSet;
    property DbFileName: string read FDbFileName write FDbFileName;
  end;


implementation

{ TCtObjDbSerial }

constructor TCtObjDbSerial.Create(const ADBEngine: TCtMetaDatabase; fn: String; bReadOnly: Boolean);
begin
  inherited Create(bReadOnly);

  FDBEngine := ADBEngine;
  FDbFileName := fn;
  FObjTableName := 'CTTREENODE';
  FObjPKField := 'ID';
  FObjPIDField := 'PID';
  //FWhereClause := 'nvl(DATALEVEL,0)=1';

  //rem2022
  //FInnerDataSet := TDataSet.Create(nil);
  //FInnerDataSet.DBEngine := ADBEngine;
  //FInnerDataSet.QueryAllRecords := False;
  //FInnerDataSet.CommitOnPost := False;

  ChildCountInvalid := True;

  DataSet := FInnerDataSet;
end;

destructor TCtObjDbSerial.Destroy;
begin
  CheckObjPost;
  if Assigned(FInnerDataSet) then
    FreeAndNil(FInnerDataSet);

  inherited;
end;

procedure TCtObjDbSerial.NewChildQuery;
var
  vPID: string;
  iPid, L: Integer;
begin
  if FCurDataSec=FSection then
    Exit;    
  CheckObjPost;
  FCurDataSec:=FSection;
  DataSet := nil;

  L := Length(FObjChildQuerys);
  while L < FChildCounter do
  begin
    L := L + 1;
    SetLength(FObjChildQuerys, L);
  //rem2022
    //FObjChildQuerys[L - 1] := TDataSet.Create(nil);
    //FObjChildQuerys[L - 1].DBEngine := FDataSet.DBEngine;
  end;

  FChildQueryReady := 0;
  if FChildCounter > 0 then
  begin
    FCurChildQuery := FObjChildQuerys[FChildCounter - 1];
  //rem2022
    //FCurChildQuery.Clear;
    //FCurChildQuery.SQL.Text := GenChildIDSql;
    //FCurChildQuery.DeclareVariable('P_OBJID', otString);
    //FCurChildQuery.SetVariable('P_OBJID', vPID);
    FChildQueryReady := 1;
    //FCurChildQuery.Execute;
  end
  else
    FCurChildQuery := nil;
end;

procedure TCtObjDbSerial.ReleaseChildQuery;
begin       
  CheckObjPost;
  if Assigned(FCurChildQuery) then
  begin
  //rem2022
    //FCurChildQuery.Clear;
    FCurChildQuery := nil;
  end;
  FChildQueryReady := 0;
  if FChildCounter > 0 then
  begin
    FCurChildQuery := FObjChildQuerys[FChildCounter - 1];
    FChildQueryReady := 2;
  end;
end;

procedure TCtObjDbSerial.BeginChildren(AGroupName: string);
begin
  inherited;
  NewChildQuery;
end;

procedure TCtObjDbSerial.EndChildren(AGroupName: string);
begin
  inherited;
  ReleaseChildQuery;
end;

procedure TCtObjDbSerial.CheckDsEdit;
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
end;

procedure TCtObjDbSerial.CheckObjID;
begin
  if FCurDSObjID <> ObjID then
  begin
    FCurDSObjID := ObjID;
    ReloadCurDSObjID;
  end;
end;

procedure TCtObjDbSerial.CheckObjPost;
begin
  if FCurObjModified then
  begin
    if DataSet <> nil then
      DataSet.Post;
    FCurObjModified := False;
  end;
end;

procedure TCtObjDbSerial.CheckSectionName;
begin
  inherited;
  CheckObjPost;
  CheckObjID;
end;

function TCtObjDbSerial.EOF: Boolean;
begin
  if not Assigned(FCurChildQuery) then
    Result := True
  else if FChildQueryReady <> 2 then
    Result := True
  else
    Result := FCurChildQuery.Eof;
end;

function TCtObjDbSerial.GenChildIDSql: string;
begin
  Result := 'select t.' + FObjPKField + ' from ' + FObjTableName + ' t where t.' + FObjPIDField + ' = :P_OBJID order by orderNo';
end;

function TCtObjDbSerial.GenObjSql(incSubs: Boolean): string;
begin
  Result := 'select t.*,t.rowid from ' + FObjTableName + ' t order by orderno';
end;

function TCtObjDbSerial.GetPropField(const PropName: string): TField;
begin
  if FDataSet=nil then    
    raise Exception.Create('DataSet not ready for '+FGroupNamePath+' section: '+FSection);
  Result := FDataSet.FindField(PropName);
  if Result = nil then
    Result := FDataSet.FindField('T_' + PropName);
  if Result = nil then
    raise Exception.Create('Field ' + PropName + ' not exists');
end;


function TCtObjDbSerial.NewObjToWrite(AID: Integer): Boolean;
begin
  CheckObjPost;
  ObjID := IntToStr(AID);
  if FDataSet.Eof then
    FDataSet.Insert;
  Result := True;
end;

function TCtObjDbSerial.NextChildObjToRead: Boolean;
begin
  CheckObjPost;
  Result := False;
  if FCurChildQuery = nil then
    Exit;
  if FChildQueryReady = 0 then
    Exit;
  if FChildQueryReady = 1 then
  begin
//rem2022
    //FCurChildQuery.Execute;
    FChildQueryReady := 2;
  end
  else
    FCurChildQuery.Next;
  Result := not Eof;
  if Result then
  begin
    ObjID := FCurChildQuery.Fields[0].AsString;
  end;
end;

procedure TCtObjDbSerial.ReadBool(const PropName: string;
  var PropValue: Boolean);
begin
  CheckObjID;
  PropValue := GetPropField(PropName).AsBoolean;
end;

procedure TCtObjDbSerial.ReadNotBool(const PropName: string;
  var PropValue: Boolean);
begin
  ReadBool(PropName, PropValue);
end;

procedure TCtObjDbSerial.ReadBuffer(const PropName: string; const Len: LongInt;
  var PropValue);
var
  fd: TField;
  BlobStream: TStream;
  S: string;
  L: Integer;
begin
  CheckObjID;
  if PropName='CTVER' then
  begin
    S := 'CT'+IntToStr(Self.CurCtVer);
    Move(PChar(S)^, PropValue, Length(S));
    Exit;
  end;
  fd := GetPropField(PropName);
  if fd is TBlobField then
  begin
    BlobStream := DataSet.CreateBlobStream(fd, bmRead);
    try
      BlobStream.ReadBuffer(PropValue, Len);
    finally
      BlobStream.Free;
    end;
  end
  else
  begin
    S := fd.AsString;
    FillChar(PropValue, Len, 0);
    L := Length(S);
    if L > Len then
      L := Len;
    Move(Pointer(S)^, PropValue, L);
  end;
end;

procedure TCtObjDbSerial.ReadStrings(const PropName: string;
  var PropValue: string);
begin
  ReadString(PropName, PropValue);
end;

procedure TCtObjDbSerial.ReadDate(const PropName: string;
  var PropValue: TDateTime);
begin
  CheckObjID;
  PropValue := GetPropField(PropName).AsDateTime;
end;

procedure TCtObjDbSerial.ReadFloat(const PropName: string;
  var PropValue: Double);
begin
  CheckObjID;
  PropValue := GetPropField(PropName).AsFloat;
end;

procedure TCtObjDbSerial.ReadInteger(const PropName: string;
  var PropValue: Integer);
begin
  CheckObjID;
  PropValue := GetPropField(PropName).AsInteger;
end;

procedure TCtObjDbSerial.ReadString(const PropName: string;
  var PropValue: string);
begin
  CheckObjID;
  if PropName = 'IconImg' then
  begin
    if FDataSet.FindField(PropName) <> nil then
      PropValue := GetPropField(PropName).AsString
    else
      PropValue := '';
    PropValue := StringExtToWideCode(PropValue);
  end
  else
    PropValue := GetPropField(PropName).AsString;
end;

procedure TCtObjDbSerial.ReloadCurDSObjID;
begin
  CheckObjPost;
  with FDataSet do
  begin
    Close;  
  //rem2022
    //DeleteVariables;
    //SQL.Text := GenObjSql(False);
    //DeclareVariable('P_OBJID', otString);
    //SetVariable('P_OBJID', FCurDSObjID);
    //if Pos('%USERID%', SQL.Text) > 0 then
    //begin
    //  SQL.Text := StringReplace(SQL.Text, '%USERID%', ':v_USERID', [rfReplaceAll]);
    //  DeclareVariable('v_USERID', otInteger);
    //  SetVariable('v_USERID', FUserID);
    //end;
    Open;
  end;
end;

procedure TCtObjDbSerial.SetObjID(const Value: string);
begin
  CheckObjPost;
  inherited;
  CheckObjID;
end;


procedure TCtObjDbSerial.SetPropModified;
begin
  FCurObjModified := True;
end;

procedure TCtObjDbSerial.WriteBool(const PropName: string;
  const PropValue: Boolean);
begin
  CheckObjID;
  CheckDsEdit;
  GetPropField(PropName).AsBoolean := PropValue;
  SetPropModified;
end;

procedure TCtObjDbSerial.WriteNotBool(const PropName: string;
  const PropValue: Boolean);
begin
  WriteBool(PropName, PropValue);
end;

procedure TCtObjDbSerial.WriteBuffer(const PropName: string;
  const Len: LongInt; const PropValue);
var
  fd: TField;
  BlobStream: TStream;
  S: string;
begin
  CheckObjID;
  if PropName='CTVER' then
    Exit;
  fd := GetPropField(PropName);
  if fd is TBlobField then
  begin
    BlobStream := DataSet.CreateBlobStream(fd, bmReadWrite);
    try
      BlobStream.Size := 0;
      BlobStream.WriteBuffer(PropValue, Len);
    finally
      BlobStream.Free;
    end;
  end
  else
  begin
    SetLength(S, Len);
    FillChar(Pointer(S)^, Len, 0);
    Move(PropValue, Pointer(S)^, Len);
    fd.AsString := S;
  end;
  SetPropModified;
end;

procedure TCtObjDbSerial.WriteStrings(const PropName: string;
  const PropValue: string);
begin
  WriteString(PropName, PropValue);
end;

procedure TCtObjDbSerial.WriteDate(const PropName: string;
  const PropValue: TDateTime);
begin
  CheckObjID;
  CheckDsEdit;
  GetPropField(PropName).AsDateTime := PropValue;
  SetPropModified;
end;

procedure TCtObjDbSerial.WriteFloat(const PropName: string;
  const PropValue: Double);
begin
  CheckObjID;
  CheckDsEdit;
  GetPropField(PropName).AsFloat := PropValue;
  SetPropModified;
end;

procedure TCtObjDbSerial.WriteInteger(const PropName: string;
  const PropValue: Integer);
begin
  CheckObjID;
  CheckDsEdit;
  GetPropField(PropName).AsInteger := PropValue;
  SetPropModified;
end;

procedure TCtObjDbSerial.WriteString(const PropName: string;
  const PropValue: string);
begin
  CheckObjID;
  CheckDsEdit;
  if PropName = 'IconImg' then
    Exit;
  GetPropField(PropName).AsString := PropValue;
  SetPropModified;
end;

procedure TCtObjDbSerial.PreDeleteChildren(PID: Integer);
begin
  with TDataSet.Create(nil) do
  try        
  //rem2022
    //DBEngine := Self.FDataSet.DBEngine;
    //Clear;
    //Sql.Text :=
    //  'update cttreenode x' + #13#10 +
    //  '   set x.datalevel = 4' + #13#10 +
    //  ' where x.id in (select t.id' + #13#10 +
    //  '                  from cttreenode t' + #13#10 +
    //  '                 start with id = :VPID' + #13#10 +
    //  '                connect by pid = prior id)';
    //
    //DeclareVariable('VPID', otInteger);
    //SetVariable('VPID', PID);
    //Execute;
  finally
    Free;
  end;
end;

end.

