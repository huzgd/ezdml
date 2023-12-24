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

  TCtObjDbSerial = class(TCtObjSerialer)
  private
    FInnerDataSet: TDataSet;
    FDataSet: TDataSet;
    FWhereClause: string;
    FOrderByClause: string;
    FLoadCtoIconImage: Boolean;
  protected
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
    procedure SetPreloadChildren(const Value: Boolean); override;
  public
    constructor Create(const ADBEngine: TCtMetaDatabase; fn: String; bReadOnly: Boolean); overload;
    destructor Destroy; override;

    procedure CheckSectionName; override;
    procedure ReloadCurDSObjID; virtual;
    function GenObjSql(incSubs: Boolean): string; virtual;
    function GenChildIDSql: string; virtual;
    function GetAndWhereClause(op: string): string; virtual;
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
    procedure ReadInteger(const PropName: string; var PropValue: Integer); override;
    procedure ReadFloat(const PropName: string; var PropValue: Double); override;
    procedure ReadDate(const PropName: string; var PropValue: TDateTime); override;
    procedure ReadBuffer(const PropName: string; const Len: LongInt; var PropValue); override;
    procedure WriteString(const PropName: string; const PropValue: string); override;
    procedure WriteBool(const PropName: string; const PropValue: Boolean); override;
    procedure WriteInteger(const PropName: string; const PropValue: Integer); override;
    procedure WriteFloat(const PropName: string; const PropValue: Double); override;
    procedure WriteDate(const PropName: string; const PropValue: TDateTime); override;
    procedure WriteBuffer(const PropName: string; const Len: LongInt; const PropValue); override;

    property DataSet: TDataSet read FDataSet write FDataSet;
    property WhereClause: string read FWhereClause write FWhereClause;    
    property OrderByClause: string read FOrderByClause write FOrderByClause;
    property LoadCtoIconImage: Boolean read FLoadCtoIconImage write FLoadCtoIconImage;
  end;


implementation

{ TCtObjDbSerial }

constructor TCtObjDbSerial.Create(const ADBEngine: TCtMetaDatabase; fn: String; bReadOnly: Boolean);
begin
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

procedure TCtObjDbSerial.BeginChildren(AGroupName: string);
var
  vPID: string;
  iPid, L: Integer;
begin
  vPID := ObjID;
  inherited;

  if PreloadChildren then
  begin
    if TryStrToInt(vPID, iPID) then
      FDataSet.Filter := FObjPIDField + '=' + vPID
    else
      FDataSet.Filter := FObjPIDField + '=''' + vPID + '''';
    FDataSet.Filtered := FDataSet.Filter <> '';
    FDataSet.First;
    FChildQueryReady := 1;
    Exit;
  end;

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

procedure TCtObjDbSerial.EndChildren(AGroupName: string);
var
  vPid, oPid: string;
  iPid: Integer;
begin
  oPid := '';
  if PreloadChildren then
  begin
    if FChildCounter > 1 then
    begin
      oPid := FObjPIDs[FChildCounter - 1];
      vPid := FObjPIDs[FChildCounter - 2];
      if TryStrToInt(vPID, iPID) then
        FDataSet.Filter := FObjPIDField + '=' + vPID
      else
        FDataSet.Filter := FObjPIDField + '=''' + vPID + '''';
    end
    else
      FDataSet.Filter := '';
    FDataSet.Filtered := FDataSet.Filter <> '';
    FDataSet.First;
    FChildQueryReady := 1;
  end;

  inherited;
  if PreloadChildren then
  begin
    if FChildCounter > 0 then
    begin
      //vPid := FObjPIDs[FChildCounter - 2];
      if oPid <> '' then
        if FDataSet.Locate(FObjPKField, oPID, []) then
          FChildQueryReady := 2;
    end;
    Exit;
  end;

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

procedure TCtObjDbSerial.CheckDsEdit;
begin
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
  if PreloadChildren then
    Result := FDataSet.Eof
  else if not Assigned(FCurChildQuery) then
    Result := True
  else if FChildQueryReady <> 2 then
    Result := True
  else
    Result := FCurChildQuery.Eof;
end;

function TCtObjDbSerial.GenChildIDSql: string;
begin
  Result := 'select t.' + FObjPKField + ' from ' + FObjTableName + ' t where t.' + FObjPIDField + ' = :P_OBJID' + GetAndWhereClause('and');
  if Trim(FOrderByClause)<>'' then
    Result := Result+' order by '+FOrderByClause;
end;

function TCtObjDbSerial.GenObjSql(incSubs: Boolean): string;
begin
  if LoadCtoIconImage then
    Result := 'select t.*,t.rowid,pkg_ctobjs.get_ctobj_icon(t.id, t.param) iconimg from ' + FObjTableName + ' t'
  else
    Result := 'select t.*,t.rowid from ' + FObjTableName + ' t';
  if incSubs then
    Result := Result + GetAndWhereClause('where')
      + ' start with t.' + FObjPKField + ' = :P_OBJID connect by '
      + FObjPIDField + ' = prior ' + FObjPKField
  else
    Result := Result + ' where t.' + FObjPKField + ' = :P_OBJID' + GetAndWhereClause('and');
  if Trim(FOrderByClause)<>'' then
    Result := Result+' order by '+FOrderByClause;
end;

function TCtObjDbSerial.GetPropField(const PropName: string): TField;
begin
  Result := FDataSet.FindField(PropName);
  if Result = nil then
    Result := FDataSet.FindField('T_' + PropName);
  if Result = nil then
    raise Exception.Create('Field ' + PropName + ' not exists');
end;

function TCtObjDbSerial.GetAndWhereClause(op: string): string;
begin
  if Trim(WhereClause) = '' then
    Result := ''
  else if op = '' then
    Result := '(' + WhereClause + ')'
  else
    Result := ' ' + op + ' (' + WhereClause + ')';
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
  if PreloadChildren then
  begin
    if FChildQueryReady = 1 then
      FChildQueryReady := 2
    else
      FDataSet.Next;
    Result := not Eof;
    if Result then
    begin
      ObjID := GetPropField(FObjPKField).AsString;
    end;
  end
  else
  begin
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
end;

procedure TCtObjDbSerial.ReadBool(const PropName: string;
  var PropValue: Boolean);
begin
  CheckObjID;
  PropValue := GetPropField(PropName).AsBoolean;
end;

procedure TCtObjDbSerial.ReadBuffer(const PropName: string; const Len: Integer;
  var PropValue);
var
  fd: TField;
  BlobStream: TStream;
  S: string;
  L: Integer;
begin
  CheckObjID;
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
    if PreloadChildren then
    begin
      if not Active then
      begin
        Close;     
  //rem2022
        //DeleteVariables;
        //SQL.Text := GenObjSql(True);
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
      if GetPropField(FObjPKField).AsString = ObjID then
      begin
        FChildQueryReady := 2;
        Exit;
      end
      else
      begin
        First;
        if Locate(FObjPKField, ObjID, []) then
        begin
          FChildQueryReady := 2;
          Exit;
        end;
      end;
    end;
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
    PreloadChildren := False;
  end;
end;

procedure TCtObjDbSerial.SetObjID(const Value: string);
begin
  CheckObjPost;
  inherited;
  CheckObjID;
end;

procedure TCtObjDbSerial.SetPreloadChildren(const Value: Boolean);
begin
  inherited;
  if not PreloadChildren then
    Exit;
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

procedure TCtObjDbSerial.WriteBuffer(const PropName: string;
  const Len: Integer; const PropValue);
var
  fd: TField;
  BlobStream: TStream;
  S: string;
begin
  CheckObjID;
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

procedure TCtObjDbSerial.WriteString(const PropName, PropValue: string);
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

