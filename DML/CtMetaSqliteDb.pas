unit CtMetaSqliteDb;

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, ImgList,
  CtMetaData, CtMetaTable, CtMetaFCLSqlDb, sqlite3conn, DB, sqlDb;

type

  { TCtMetaSqliteDb }

  TCtMetaSqliteDb = class(TCtMetaFCLSqlDb)
  private
    FOpenDlg: TComponent;
    FTempSS: TStrings;
  protected
    function CreateSqlDbConn: TSQLConnection; override;
    procedure SetFCLConnDatabase; override;   
    procedure SetConnected(const Value: boolean); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function ShowDBConfig(AHandle: THandle): boolean; override;

    function GetDbNames: string; override;
    function GetDbUsers: string; override;
    function GetDbObjs(ADbUser: string): TStrings; override;

    function GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject; override;
    function GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string; override;

    //执行命令
    function ObjectExists(ADbUser, AObjName: string): boolean; override;

  end;


implementation

uses Dialogs, Forms, WindowFuncs;

{ TCtMetaSqliteDb }


function TCtMetaSqliteDb.CreateSqlDbConn: TSQLConnection;
begin
  Result := TSQLite3Connection.Create(nil);
end;

procedure TCtMetaSqliteDb.SetFCLConnDatabase;
begin
  if Assigned(FDbConn) then
    FDbConn.DatabaseName := Database;
end;

procedure TCtMetaSqliteDb.SetConnected(const Value: boolean);
begin
  if Value then
    if not FileExists(Database) then
    begin
      TSQLite3Connection(FDbConn).DatabaseName := Database;
      TSQLite3Connection(FDbConn).CreateDB;
    end;
  inherited SetConnected(Value);
end;


constructor TCtMetaSqliteDb.Create;
begin
  inherited;
  FEngineType := 'SQLITE';
  FTempSS := TStringList.Create;
end;

destructor TCtMetaSqliteDb.Destroy;
begin
  if Assigned(FOpenDlg) then
    FreeAndNil(FOpenDlg);
  FTempSS.Free;
  inherited;
end;

function TCtMetaSqliteDb.GenObjSql(obj, obj_db: TCtMetaObject; sqlType: integer): string;
begin
  Result := inherited GenObjSql(obj, obj_db, sqlType);
end;

function TCtMetaSqliteDb.GetDbNames: string;
begin
{$ifdef WINDOWS}
  Result := 'D:\test.db';
{$else}    
  Result := '/root/test1.db';
{$ENDIF}
end;

function TCtMetaSqliteDb.GetDbObjs(ADbUser: string): TStrings;
begin
  CheckConnected;
  Result := FTempSS;
  Result.Clear;
  with FQuery do
  begin
    Clear;
    Sql.Text :=
      'select name from sqlite_master where type=''table'' order by name';

    Open;
    while not EOF do
    begin
      Result.Add(Fields[0].AsString);
      Next;
    end;
  end;
end;

function TCtMetaSqliteDb.GetDbUsers: string;
begin
  Result := '';
end;


function Sqlite2CtFieldType(ft: string): TCtFieldDataType;
const
  FtNTableInt: array[0..5] of string = (
    'INT',
    'INTEGER',
    'MEDIUMINT',
    'BIGINT',
    'UNSIGNED BIG INT',
    'INT8');

  FtNTableEnum: array[0..3] of string = (
    'TINYINT',
    'SMALLINT',
    'INT1',
    'INT2');

  FtNTableText: array[0..7] of string = (
    'CHARACTER',
    'VARCHAR',
    'VARYING CHARACTER',
    'NCHAR',
    'NATIVE CHARACTER',
    'NVARCHAR',
    'TEXT',
    'CLOB');

  FtNTableFloat: array[0..5] of string = (
    'REAL',
    'DOUBLE',
    'DOUBLE PRECISION',
    'FLOAT',
    'NUMERIC',
    'DECIMAL');

  FtNTableDate: array[0..1] of string = (
    'DATE',
    'DATETIME');
var
  I, po: integer;
begin
  Result := cfdtUnknow;
  po := Pos('(', ft);
  if po > 0 then
    ft := Copy(ft, 1, po - 1);
  ft := UpperCase(Trim(ft));
  if ft = '' then
  begin
    Result := cfdtBlob;
    Exit;
  end;

  for I := 0 to High(FtNTableInt) do
    if ft = FtNTableInt[i] then
    begin
      Result := cfdtInteger;
      Exit;
    end;
  for I := 0 to High(FtNTableEnum) do
    if ft = FtNTableEnum[i] then
    begin
      Result := cfdtEnum;
      Exit;
    end;
  for I := 0 to High(FtNTableText) do
    if ft = FtNTableText[i] then
    begin
      Result := cfdtString;
      Exit;
    end;
  for I := 0 to High(FtNTableFloat) do
    if ft = FtNTableFloat[i] then
    begin
      Result := cfdtFloat;
      Exit;
    end;
  for I := 0 to High(FtNTableDate) do
    if ft = FtNTableDate[i] then
    begin
      Result := cfdtDate;
      Exit;
    end;
end;

function Sqlite2CtFieldLen(ft: string): integer;
var
  po: integer;
begin
  Result := 0;
  po := Pos('(', ft);
  if po <= 0 then
    Exit;
  ft := Copy(ft, po + 1, Length(ft));
  po := Pos(')', ft);
  if po <= 0 then
    Exit;
  ft := Copy(ft, 1, po - 1);
  po := Pos(',', ft);
  if po > 0 then
    ft := Copy(ft, 1, po - 1);
  Result := StrToIntDef(ft, 0);
end;

function Sqlite2CtFieldScale(ft: string): integer;
var
  po: integer;
begin
  Result := 0;
  po := Pos('(', ft);
  if po <= 0 then
    Exit;
  ft := Copy(ft, po + 1, Length(ft));
  po := Pos(')', ft);
  if po <= 0 then
    Exit;
  ft := Copy(ft, 1, po - 1);
  po := Pos(',', ft);
  if po <= 0 then
    Exit;
  ft := Copy(ft, po + 1, Length(ft));
  Result := StrToIntDef(ft, 0);
end;

function CustomFieldTypeNameRemoveLen(ft: string): string;
var
  po: integer;
begin
  Result := ft;
  po := Pos('(', ft);
  if po > 0 then
    Result := Copy(ft, 1, po - 1);
end;

function TCtMetaSqliteDb.GetObjInfos(ADbUser, AObjName, AOpt: string): TCtMetaObject;
var
  I, po: integer;
  o, o2: TCtMetaTable;
  fd, fd2: TCtMetaField;
  S, T, cql, idxfds: string;
begin
  Result := nil;
  if AObjName = '' then
    Exit;

  CheckConnected;

  po := Pos('.', AObjName);
  if po > 0 then
  begin
    ADbUser := Copy(AObjName, 1, po - 1);
    AObjName := Copy(AObjName, po + 1, Length(AObjName));
  end;

  if not ObjectExists(ADbUser, AObjName) then
    Exit;

  S := 'PRAGMA table_info(' + AObjName + ')';
  with FQuery do
  begin
    Clear;
    SQL.Text := S;
    Open;

    o := TCtMetaTable.Create;
    Result := o;
    Result.Name := AObjName;
    while not EOF do
    begin
      with o.MetaFields.NewMetaField do
      begin
        Name := FieldByName('name').AsString;
        S := FieldByName('type').AsString;
        DataType := Sqlite2CtFieldType(S);
        if DataType = cfdtUnknow then
        begin
          DataType := GetPossibleCtFieldTypeOfName(S);
          DataTypeName := CustomFieldTypeNameRemoveLen(S);
        end;
        DataLength := Sqlite2CtFieldLen(S);
        DataScale := Sqlite2CtFieldScale(S);
        if Pos('[DBTYPENAMES]', AOpt) > 0 then
          DataTypeName := CustomFieldTypeNameRemoveLen(FieldByName('type').AsString);

        if FieldByName('notnull').AsInteger = 1 then
          Nullable := False
        else
          Nullable := True;
        if FieldByName('pk').AsInteger = 1 then
          KeyFieldType := cfktId;
        DefaultValue := FieldByName('dflt_value').AsString;
      end;
      Next;
    end;
  end;


  S := 'select sql from sqlite_master where type=''table'' and name=''' +
    AObjName + '''';
  with FQuery do
  begin
    Clear;
    SQL.Text := S;
    Open;

    cql := '';
    while not EOF do
    begin
     // cql := Fields[0].AsString;
      Break;
    end;
    if cql <> '' then
    begin
      S := Trim(ExtractCompStr(cql, '/**EZDML_DESC_START**', '**EZDML_DESC_END**/'));
      if S <> '' then
      begin
        o2 := TCtMetaTable.Create;
        try
          o2.Describe := S;
          if o2.Name = o.Name then
          begin
            o.Caption := o2.Caption;
            o.Memo := o2.Memo;
            for I := 0 to o.MetaFields.Count - 1 do
            begin
              fd := o.MetaFields[I];
              fd2 := o2.MetaFields.FieldByName(fd.Name);
              if fd2 <> nil then
              begin
                fd.DisplayName := fd2.DisplayName;
                fd.Memo := fd2.Memo;
              end;
            end;
          end;
        finally
          o2.Free;
        end;
      end;

    end;
  end;


  S := 'PRAGMA foreign_key_list(' + AObjName + ')';
  with FQuery do
  try
    Clear;
    SQL.Text := S;
    Open;

    while not EOF do
    begin
      S := FieldByName('from').AsString;
      fd := o.MetaFields.FieldByName(S);
      if fd <> nil then
      begin
        fd.RelateTable := FieldByName('table').AsString;
        fd.RelateField := FieldByName('to').AsString;
        if fd.KeyFieldType <> cfktId then
          fd.KeyFieldType := cfktRid;
      end;
      Next;
    end;
  except
  end;

  S := 'PRAGMA index_list(' + AObjName + ')';
  with FQuery do
  try
    Clear;
    SQL.Text := S;
    Open;

    while not EOF do
    begin
      S := 'PRAGMA index_info(' + FieldByName('name').AsString + ')';
      with FQueryB do
      begin
        Clear;
        SQL.Text := S;
        Open;
      end;            
      idxfds := '';
      while not FQueryB.EOF do
      begin
        S := FQueryB.FieldByName('name').AsString;  
        if idxfds='' then
          idxfds := S
        else
          idxfds := idxfds+','+S;
        FQueryB.Next;
      end;
         
      if (idxfds<>'') then
      begin      
        if (Pos(',', idxfds)=0) and (Pos('(',idxfds)=0) then
        begin
          fd := o.MetaFields.FieldByName(idxfds);
          if fd <> nil then
          begin
            if FieldByName('unique').AsInteger = 1 then
              fd.IndexType := cfitUnique
            else
              fd.IndexType := cfitNormal;
          end;
        end
        else
        begin
          fd := o.MetaFields.NewMetaField;
          S := FQuery.FieldByName('name').AsString;
          T := S;
          fd.Memo := '[DB_INDEX_NAME:'+S+']';
          S := RemoveIdxNamePrefx(S, o.Name);
          fd.Name := S;
          fd.DataType := cfdtFunction;
          if FieldByName('unique').AsInteger = 1 then
            fd.IndexType  := cfitUnique
          else
            fd.IndexType  := cfitNormal;
          fd.IndexFields := idxfds;

          fd.Memo := idxfds;
          S := GetIdxName(o.Name, fd.Name);
          if fd.IndexType = cfitUnique then
            S := 'IDU_' + S
          else
            S := 'IDX_' + S;
          if LowerCase(T) <> LowerCase(S) then
            fd.Memo := fd.Memo + ' [DB_INDEX_NAME:' + T + ']';
        end;
      end;

      Next;
    end;
  except
  end;


end;

function TCtMetaSqliteDb.ObjectExists(ADbUser, AObjName: string): boolean;
var
  po: integer;
  S: string;
begin
  Result := False;
  CheckConnected;

  po := Pos('.', AObjName);
  if po > 0 then
  begin
    ADbUser := Copy(AObjName, 1, po - 1);
    AObjName := Copy(AObjName, po + 1, Length(AObjName));
  end;


  S := 'select count(*) as CC from sqlite_master where upper(name)='''+UpperCase(AObjName)+'''';

  with FQuery do
  begin
    Clear;
    Sql.Text := S;
    Open;      
    if not EOF then
      Result := Fields[0].AsInteger > 0;
  end;
end;


function TCtMetaSqliteDb.ShowDBConfig(AHandle: THandle): boolean;
begin
  Result := False;
  if FOpenDlg = nil then
    FOpenDlg := TOpenDialog.Create(nil);
  with TOpenDialog(FOpenDlg) do
  begin
    Filter := 'db files (*.db)|*.db|db3 files (*.db3)|*.db3|All files (*.*)|*.*';
    if Execute then
    begin
      Database := FileName;
      Result := True;
    end;
  end;
end;


initialization
  AddCtMetaDBReg('SQLITE', TCtMetaSqliteDb);

end.
