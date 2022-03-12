unit uFormHttpSvr;

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CtMetaTable, IdContext, DB, SyncObjs,
  IdCustomHTTPServer, IdHTTPServer, Menus, ExtCtrls, uJson;
     
const
  WMZ_LOGREF = WM_USER + $2001;
type

  { TfrmHttpSvr }

  TfrmHttpSvr = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edtDBLinkInfo: TEdit;
    btnDBLogon: TButton;
    lbHTTPSvrTip: TLabel;
    TimerInit: TTimer;
    edtPassword: TEdit;
    Label3: TLabel;
    MemoLogs: TMemo;
    Label4: TLabel;
    edtPort: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure TimerInitTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDBLogonClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { Private declarations }
    FLinkDbNo: integer;
    FCtMetaDatabase: TCtMetaDatabase;
    IdHTTPServer1: TIdHTTPServer;
    FTotalProcCount: integer;
    FErrorPwdCount: integer;
    FAccessToken: string;
            
    FEzLock: TCriticalSection;
    FEzLogs: TStringList;

    procedure GenRandomPwd;
    procedure RefreshDbInfo;
    procedure Log(Msg: string; bAddSysInfo: boolean = True);

    procedure IdHTTPServer1Connect(AContext: TIdContext);
    procedure IdHTTPServer1Disconnect(AContext: TIdContext);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
                       
    procedure _WMZ_LOGREF(var msg: TMessage); message WMZ_LOGREF;
  public
    { Public declarations }
    procedure CheckActEnbs;
  end;

implementation

uses
  uFormCtDbLogon, WindowFuncs, dmlstrs;

{$R *.lfm}

procedure TfrmHttpSvr.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if IdHTTPServer1.Active then
    btnCancelClick(nil);
  CanClose := not IdHTTPServer1.Active;
end;

procedure TfrmHttpSvr.FormCreate(Sender: TObject);
begin     
  FEzLock := TCriticalSection.Create;
  FEzLogs := TStringList.Create;
  FLinkDbNo := -1;

  IdHTTPServer1 := TIdHTTPServer.Create(Self);
  IdHTTPServer1.OnConnect := IdHTTPServer1Connect;
  IdHTTPServer1.OnDisConnect := IdHTTPServer1Disconnect;
  IdHTTPServer1.OnCommandGet := IdHTTPServer1CommandGet;

  GenRandomPwd;
  RefreshDbInfo;
end;

procedure TfrmHttpSvr.btnDBLogonClick(Sender: TObject);
var
  I: integer;
begin
  I := ExecCtDbLogon;
  if I >= 0 then
  begin
    FLinkDbNo := I;
    RefreshDbInfo;
  end;
end;

procedure TfrmHttpSvr.RefreshDbInfo;
begin
  Refresh;

  if FLinkDbNo < 0 then
    FCtMetaDatabase := nil
  else
    FCtMetaDatabase := CtMetaDBRegs[FLinkDbNo].DbImpl;
  if not Assigned(FCtMetaDatabase) then
  begin
    edtDBLinkInfo.Text := '';
  end
  else
  begin
    edtDBLinkInfo.Text := '[' + FCtMetaDatabase.EngineType + ']' +
      FCtMetaDatabase.Database;
  end;

end;

procedure TfrmHttpSvr.TimerInitTimer(Sender: TObject);
begin
  TimerInit.Enabled := False;
  if not Assigned(FCtMetaDatabase) then
  begin
    btnDBLogonClick(nil);
    if Assigned(FCtMetaDatabase) then
      btnOKClick(nil);
  end;
end;

procedure TfrmHttpSvr.FormDestroy(Sender: TObject);
begin
  FEzLogs.Free;
  FEzLock.Free;
end;

procedure TfrmHttpSvr.btnOKClick(Sender: TObject);
var
  port: integer;
begin
  if IdHTTPServer1.Active then
    raise Exception.Create('active already');

  if not Assigned(FCtMetaDatabase) then
  begin
    btnDBLogonClick(nil);
    if not Assigned(FCtMetaDatabase) then
      Exit;
  end;
  port := StrToIntDef(edtPort.Text, 0);
  if port <= 0 then
    raise Exception.Create('invalid port');

  //if edtPassword.Text = '' then
  //  raise Exception.Create('password needed');

  Log('starting HTTP server...');
  try
    IdHTTPServer1.Active := False;
    FTotalProcCount := 0;
    FErrorPwdCount := 0;
    FAccessToken := '';
    IdHTTPServer1.DefaultPort := port;
    IdHTTPServer1.Active := True;
    Log('HTTP server listening at http://localhost:' + IntToStr(port) + '/ezdml/');
  except
    on E: Exception do
      Log('Error: ' + E.Message);
  end;
  CheckActEnbs;
end;

procedure TfrmHttpSvr.CheckActEnbs;
var
  bRun: boolean;
begin
  bRun := IdHTTPServer1.Active;
  btnDBLogon.Enabled := not bRun;
  edtPort.Enabled := not bRun;
  edtPassword.ReadOnly := bRun;
  if edtPassword.ReadOnly then
    edtPassword.color := clBtnFace
  else
    edtPassword.Color := clWindow;
  btnOk.Enabled := not bRun;
  if bRun then
    btnCancel.Caption := srCapCancel
  else
    btnCancel.Caption := srCapClose;
end;

procedure TfrmHttpSvr.FormShow(Sender: TObject);
begin
  if FCtMetaDatabase = nil then
    TimerInit.Enabled := True;
end;


procedure TfrmHttpSvr.GenRandomPwd;
var
  I: integer;
  S: string;
begin
  Randomize;
  I := Random(999999);
  S := IntToStr(I);
  while Length(S) < 6 do
    S := '0' + S;
  edtPassword.Text := S;
end;

procedure TfrmHttpSvr.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

  function GetTKGUID: string;
  var
    LTep: TGUID;
    S: string;
  begin
    CreateGUID(LTep);
    S := GUIDToString(LTep);
    S := LowerCase(S);
    S := Copy(S, 2, Length(S) - 2);
    S := StringReplace(S, '-', '', [rfReplaceAll]);
    Result := S;
  end;

  function GetFtName(ft: TFieldType): string;
  begin
    Result := 'String';
    case ft of
      ftAutoInc,
      ftSmallint,
      ftInteger,
      ftLargeint,
      ftWord:
        Result := 'Integer';
      ftFloat,
      ftCurrency,
      ftBCD,
      ftFMTBcd:
        Result := 'Float';
      ftDate,
      ftTime,
      ftDateTime,
      ftTimeStamp:
        Result := 'Date';
      ftBytes,
      ftVarBytes,
      ftBlob,
      ftGraphic,
      ftOraBlob,
      ftTypedBinary:
        Result := 'Blob';
    end;
  end;

  function GetBlobHex(DS: TDataSet; Fld: TField): string;
  var
    Tmp: TStream;
    L: integer;
    S: string;
  begin
    Result := '';
    if Fld.IsNull then
      Exit;
    Tmp := DS.CreateBlobStream(Fld, bmRead);
    try
      L := Tmp.Size;
      SetLength(S, L);
      Tmp.ReadBuffer(PChar(S)^, L);
      Result := StringExtToWideCode(S);
    finally
      Tmp.Free;
    end;
  end;

  function ConvertDsToJson(DS: TDataSet): string;
  var
    jCols, jRows: TJSONArray;
    rmap, mapA, mapR: TJSONObject;
    I: integer;
  begin
    Result := '{}';
    if ds = nil then
      Exit;
    rmap := TJSONObject.Create;
    try
      jCols := TJSONArray.Create;
      rmap.put('Cols', jCols);
      for I := 0 to ds.Fields.Count - 1 do
      begin
        mapA := TJSONObject.Create;
        mapA.put('Name', ds.Fields[I].FieldName);
        mapA.put('DataType', GetFtName(ds.Fields[I].DataType));
        mapA.put('Size', ds.Fields[I].Size);
        jCols.put(mapA);
      end;

      jRows := TJSONArray.Create;
      rmap.put('Rows', jRows);
      ds.First;
      while not ds.EOF do
      begin
        mapR := TJSONObject.Create;
        for I := 0 to ds.Fields.Count - 1 do
          case ds.Fields[I].DataType of
            ftBytes,
            ftVarBytes,
            ftBlob,
            ftGraphic,
            ftOraBlob,
            ftTypedBinary:
              mapR.put(ds.Fields[I].FieldName, GetBlobHex(ds, ds.Fields[I]))
            else
              mapR.put(ds.Fields[I].FieldName, ds.Fields[I].AsString);
          end;
        jRows.put(mapR);
        ds.Next;
      end;

      Result := rmap.toString;
    finally
      rmap.Free;
    end;
  end;

  function GetReqResult(req: TIdHTTPRequestInfo): string;
  var
    cmd, eztoken, param1, param2, Data, S: string;
    rmap: TJSONObject;
    arr: TJSONArray;
    ds: TDataSet;
    I: integer;
    ss: TStrings;
    cto: TCtMetaObject;
  begin
    cmd := req.Params.Values['cmd'];
    eztoken := req.Params.Values['eztoken'];
    param1 := req.Params.Values['param1'];
    param2 := req.Params.Values['param2'];
    Data := req.Params.Values['data'];

    if FCtMetaDatabase = nil then
      raise Exception.Create('database not ready');

    if cmd = 'connect' then
    begin                 
      if edtPassword.Text<>'' then
      begin
        if FAccessToken <> '' then
          raise Exception.Create('already connected by aother client');

        if FErrorPwdCount > 5 then
          raise Exception.Create('too many errors');

        if param2 <> edtPassword.Text then
        begin
          Inc(FErrorPwdCount);
          raise Exception.Create('invalid password');
        end;
      end;

      FErrorPwdCount := 0;
      FAccessToken := GetTKGUID;
      rmap := TJSONObject.Create;
      try
        rmap.put('EzdmlToken', FAccessToken);
        rmap.put('EngineType', FCtMetaDatabase.EngineType);
        if FCtMetaDatabase.DbSchema<>'' then
            rmap.put('DbSchema', FCtMetaDatabase.DbSchema)
        else
            rmap.put('DbSchema', FCtMetaDatabase.User);
        Result := rmap.toString;
      finally
        rmap.Free;
      end;
      Exit;
    end;
                       
    if edtPassword.Text<>'' then
      if eztoken <> FAccessToken then
      begin
        Sleep(1000);
        raise Exception.Create('invalid eztoken');
      end;

    if cmd = 'disconnect' then
    begin
      FAccessToken := '';
      Exit;
    end;

    if cmd = 'ExecSql' then
    begin
      FCtMetaDatabase.ExecSql(param1);
      Result := '{"RESULT":"OK"}';
      Exit;
    end;

    if cmd = 'OpenTable' then
    begin
      ds := FCtMetaDatabase.OpenTable(param1, param2);
      if ds = nil then
        raise Exception.Create('no result');
      try
        Result := ConvertDsToJson(ds);
      finally
        ds.Free;
      end;
      Exit;
    end;

    if cmd = 'GetDbUsers' then
    begin
      S := FCtMetaDatabase.GetDbUsers;
      ss := TStringList.Create;
      rmap := TJSONObject.Create;
      try
        ss.Text := S;
        arr := TJSONArray.Create;
        rmap.put('itemList', arr);
        for I := 0 to ss.Count - 1 do
          if ss[I] <> '' then
            arr.put(ss[I]);
        Result := rmap.toString;
      finally
        ss.Free;
        rmap.Free;
      end;
      Exit;
    end;

    if cmd = 'GetDbObjs' then
    begin
      ss := FCtMetaDatabase.GetDbObjs(param1);
      rmap := TJSONObject.Create;
      try
        arr := TJSONArray.Create;
        rmap.put('itemList', arr);
        for I := 0 to ss.Count - 1 do
          if ss[I] <> '' then
            arr.put(ss[I]);
        Result := rmap.toString;
      finally
        rmap.Free;
      end;
      Exit;
    end;

    if cmd = 'GetObjInfos' then
    begin
      Log('GetObjInfos: ' + param1 + ' ' + param2);
      cto := FCtMetaDatabase.GetObjInfos(param1, param2, Data);
      if cto = nil then
        raise Exception.Create('no result');
      try
        Result := cto.JsonStr;
      finally
        cto.Free;
      end;
      Exit;
    end;

    if cmd = 'ObjectExists' then
    begin
      if FCtMetaDatabase.ObjectExists(param1, param2) then
        Result := '{"RESULT":"true"}'
      else
        Result := '{"RESULT":"false"}';
      Exit;
    end;

    Result := '{resultCode:-1, errorMsg:"500 error: unknown cmd ' +
      cmd + '", time:"' + DateTimeToStr(Now) + '"}';
  end;

var
  S: string;
begin
  Inc(FTotalProcCount);
  try
    Log('Client request - ' + ARequestInfo.Command + ' ' + ARequestInfo.Document +
      '?' + ARequestInfo.QueryParams);
    AResponseInfo.ContentType := 'text/plain; charset=UTF-8';
    if ARequestInfo.Document = '/ezdml/' then
      //http://127.0.0.1:8083/ezdml/?cmd=connect&xxx
    begin
      S := GetReqResult(ARequestInfo);
    end
    else
      S := '{resultCode:-1, errorMsg:"404 error", time:"' + DateTimeToStr(Now) + '"}';
    AResponseInfo.ContentText := S;
    Log('response: ' + S);
  except
    on E: Exception do
    begin
      S := E.Message;
      S := StringReplace(S, '"', '\"', [rfReplaceAll]);
      S := StringReplace(S, #13, '\r', [rfReplaceAll]);
      S := StringReplace(S, #10, '\n', [rfReplaceAll]);
      S := '{resultCode:-1, errorMsg:"' + S + '", time:"' + DateTimeToStr(Now) + '"}';
      AResponseInfo.ContentText := S;
      Log('response: ' + S);
    end;
  end;
end;

procedure TfrmHttpSvr._WMZ_LOGREF(var msg: TMessage);
begin
  FEzLock.Acquire;
  try
    if FEzLogs.Count > 0 then
    begin
      MemoLogs.Lines.AddStrings(FEzLogs);
      FEzLogs.Clear;
    end;
  finally
    FEzLock.Release;
  end;
end;

procedure TfrmHttpSvr.IdHTTPServer1Connect(AContext: TIdContext);
begin
  //Log('Client connect - ' + AContext.Binding.IP + ':' + IntToStr(AContext.Binding.Port));
end;

procedure TfrmHttpSvr.IdHTTPServer1Disconnect(AContext: TIdContext);
begin
  //Log('Client disconnect - ' + AContext.Binding.IP + ':' + IntToStr(AContext.Binding.Port));
end;

procedure TfrmHttpSvr.Log(Msg: string; bAddSysInfo: boolean);
begin
  if bAddSysInfo then
    Msg := DateTimeToStr(Now) + ' ' + Msg;
  FEzLock.Acquire;
  try
    FEzLogs.Add(Msg);
    PostMessage(Handle, WMZ_LOGREF, 0, 0);
  finally
    FEzLock.Release;
  end;
end;

procedure TfrmHttpSvr.btnCancelClick(Sender: TObject);
begin
  if IdHTTPServer1.Active then
  begin
    Log('stopping HTTP server...');
    try
      IdHTTPServer1.Active := False;
      Log('HTTP server stopped');
    except
      on E: Exception do
        Log('Error: ' + E.Message);
    end;
    CheckActEnbs;
    Exit;
  end
  else
    Close;
end;

end.
