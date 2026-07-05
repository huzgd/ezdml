unit NetUtil;

interface

uses
  LCLIntf, LCLType, Classes, SysUtils, Variants, Graphics, Controls;

type
  TUrlWaitor = class
  private
  public
    FURL, FPostData, FOpts, FUrlResData: string;
    FWaitThr: TObject;
    procedure ShowAndWait;
    procedure DoExec(var bSuccess: Boolean);
  end;

function GetUrlData_Net(URL: string; PostData: string = ''; Opts: string = ''): string;
function GetUrlData_Net_Ex(URL: string; PostData: string; Opts: string): string;
function GetUrlData_Net_ExX(URL: string; PostData: string; headers: string; Opts: string; conn: TObject): string;
function URLEncodeEx(const VS: string): string;
function URLDecodeEx(const S: string): string;
function GetJSessionId_Net: string;
procedure SetJSessionId_Net(svr, ssid: string);
function IsPortAvailable(Aport: Word): Boolean;
function GetUrlParamVal(URL, par: string): string;

var
  G_NetLogEnabled: Boolean;
  G_NetLogs: TStrings;

implementation

uses
  fphttpclient, opensslsockets, ssockets, Sockets,
  ThreadWait, WindowFuncs, Forms, ezdmlstrs;

var
  FCookieJar: TStringList;
  FBaServerAddr: string;

function GetUrlParamVal(URL, par: string): string;
var
  S: string;
begin
  URL := URL + '&';
  S := ExtractCompStr(URL, '?' + par + '=', '&');
  if S = '' then
    S := ExtractCompStr(URL, '&' + par + '=', '&');
  S := URLDecode(S);
  Result := S;
end;

function IsPortAvailable(Aport: Word): Boolean;
var
  sock: TSocket;
  addr: TInetSockAddr;
  timeout: Integer;
begin
  sock := fpSocket(AF_INET, SOCK_STREAM, 0);
  if sock = TSocket(NOT(0)) then
  begin
    Result := False;
    Exit;
  end;

  addr.sin_family := AF_INET;
  addr.sin_port := htons(Aport);
  addr.sin_addr.s_addr := htonl($7f000001);

  timeout := 200;
  fpSetSockOpt(sock, SOL_SOCKET, SO_SNDTIMEO, @timeout, SizeOf(timeout));
  fpSetSockOpt(sock, SOL_SOCKET, SO_RCVTIMEO, @timeout, SizeOf(timeout));

  if fpConnect(sock, @addr, SizeOf(addr)) = 0 then
  begin
    CloseSocket(sock);
    Result := False;
  end
  else
  begin
    CloseSocket(sock);
    Result := True;
  end;
end;

procedure AddNetLog(const msg: string; bAddDate: Boolean = True);
var
  S: string;
begin
  if G_NetLogs = nil then
    Exit;
  while G_NetLogs.Count > 1000 do
    G_NetLogs.Delete(0);
  S := '';
  if bAddDate then
    S := FormatDateTime('hh:nn:ss', Now);
  G_NetLogs.Add(S + ' ' + msg);
end;

function ShouldNetLog(const URL: string): Boolean;
begin
  Result := G_NetLogEnabled and (Pos('&noNetLog=1', URL) = 0);
end;

function CookieNameOf(const CookiePair: string): string;
var
  P: Integer;
begin
  P := Pos('=', CookiePair);
  if P <= 1 then
    Result := ''
  else
    Result := Trim(Copy(CookiePair, 1, P - 1));
end;

function FindCookieIndex(const CookieName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  if FCookieJar = nil then
    Exit;
  for I := 0 to FCookieJar.Count - 1 do
    if SameText(CookieNameOf(FCookieJar[I]), CookieName) then
    begin
      Result := I;
      Exit;
    end;
end;

procedure SetCookiePair(const CookiePair: string);
var
  Name: string;
  I: Integer;
begin
  Name := CookieNameOf(CookiePair);
  if Name = '' then
    Exit;
  if FCookieJar = nil then
    FCookieJar := TStringList.Create;
  I := FindCookieIndex(Name);
  if I >= 0 then
    FCookieJar[I] := CookiePair
  else
    FCookieJar.Add(CookiePair);
end;

function GetCookieValue(const CookieName: string): string;
var
  I, P: Integer;
  S: string;
begin
  Result := '';
  I := FindCookieIndex(CookieName);
  if I < 0 then
    Exit;
  S := FCookieJar[I];
  P := Pos('=', S);
  if P > 0 then
    Result := Copy(S, P + 1, Length(S));
end;

procedure MergeSetCookieHeader(const HeaderLine: string);
const
  SetCookiePrefix = 'set-cookie:';
var
  S: string;
  P: Integer;
begin
  S := Trim(HeaderLine);
  if LowerCase(Copy(S, 1, Length(SetCookiePrefix))) <> SetCookiePrefix then
    Exit;

  Delete(S, 1, Length(SetCookiePrefix));
  S := Trim(S);
  P := Pos(';', S);
  if P > 0 then
    S := Trim(Copy(S, 1, P - 1));
  if S <> '' then
    SetCookiePair(S);
end;

procedure MergeResponseCookies(Client: TFPHTTPClient);
var
  I: Integer;
begin
  for I := 0 to Client.ResponseHeaders.Count - 1 do
    MergeSetCookieHeader(Client.ResponseHeaders[I]);
end;

function ShouldUseCookieJar(const URL: string): Boolean;
begin
  Result := (FBaServerAddr <> '') and (Pos(FBaServerAddr, URL) = 1);
end;

function GetJSessionId_Net: string;
begin
  Result := GetCookieValue('JSESSIONID');
end;

procedure SetJSessionId_Net(svr, ssid: string);
begin
  if svr <> '' then
    if svr[Length(svr)] <> '/' then
      svr := svr + '/';
  FBaServerAddr := svr;
  if ssid <> '' then
    SetCookiePair('JSESSIONID=' + ssid);
end;

function GetNetUserAgent: string;
begin
  Result := 'Mozilla/3.0 (compatible; FPC HTTPClient) EZDML ';
  {$ifdef WINDOWS}
  {$ifdef WIN32}
  Result := Result + 'Win32 ';
  {$else}
  Result := Result + 'Win64 ';
  {$endif}
  {$else}
  {$IFDEF DARWIN}
  Result := Result + 'MacOS ';
  {$else}
  Result := Result + 'Linux ';
  {$ENDIF}
  {$endif}
  Result := Result + srEzdmlVersionNum;
end;

function IsUtf8Type(const URL: string; Client: TFPHTTPClient): Boolean;
var
  Tp: string;
begin
  Result := False;
  Tp := LowerCase(TFPCustomHTTPClient.GetHeader(Client.ResponseHeaders, 'Content-Type'));
  if Tp <> '' then
  begin
    Result := (Pos('utf-8', Tp) > 0) or (Pos('utf8', Tp) > 0);
    if Result then
      Exit;
  end;

  if (Pos('/ucv.nx?', URL) > 0) or (Pos('/utf8cv.nx?', URL) > 0) then
    Result := True;
end;

procedure AddCustomHeaders(Client: TFPHTTPClient; const Headers: string);
var
  HS: TStringList;
  I, P: Integer;
  S, T, V: string;
begin
  if Headers = '' then
    Exit;

  HS := TStringList.Create;
  try
    HS.Text := Headers;
    for I := 0 to HS.Count - 1 do
    begin
      S := HS[I];
      P := Pos('=', S);
      if P > 0 then
      begin
        T := Trim(Copy(S, 1, P - 1));
        V := Copy(S, P + 1, Length(S));
        if T <> '' then
          Client.AddHeader(T, V);
      end;
    end;
  finally
    HS.Free;
  end;
end;

procedure ReadStreamToString(Stream: TStream; out S: string);
var
  L: Integer;
begin
  L := Stream.Size;
  Stream.Position := 0;
  SetLength(S, L);
  if L > 0 then
    Stream.ReadBuffer(S[1], L);
end;

function ExtractSaveToFileName(var PostData: string; const Opts: string): string;
begin
  Result := '';
  if Pos('[SAVE_TO_FILE]', PostData) > 0 then
  begin
    Result := ExtractCompStr(PostData, '[SAVE_TO_FILE]', '[/SAVE_TO_FILE]');
    PostData := '';
  end
  else if Pos('[SAVE_TO_FILE]', Opts) > 0 then
    Result := ExtractCompStr(Opts, '[SAVE_TO_FILE]', '[/SAVE_TO_FILE]');
end;

function GetUrlData_Net_ExX(URL: string; PostData: string; headers: string; Opts: string; conn: TObject): string;
var
  Client: TFPHTTPClient;
  BodyStream: TRawByteStringStream;
  MemoryResult: TMemoryStream;
  FileResult: TFileStream;
  ResponseStream: TStream;
  SaveFn, UploadFn, S: string;
  TmOut: Integer;
  OwnClient, UseCookies: Boolean;
begin
  OwnClient := not ((conn <> nil) and (conn is TFPHTTPClient));
  if OwnClient then
    Client := TFPHTTPClient.Create(nil)
  else
    Client := TFPHTTPClient(conn);

  BodyStream := nil;
  MemoryResult := nil;
  FileResult := nil;
  try
    if Client.RequestBody <> nil then
      Client.RequestBody := nil;
    Client.RequestHeaders.Clear;
    Client.Cookies.Clear;
    Client.KeepConnection := False;

    TmOut := 20000;
    if Pos('[SAVE_TO_FILE]', PostData) > 0 then
      TmOut := 90000;
    if Pos('[SAVE_TO_FILE]', Opts) > 0 then
      TmOut := 90000;
    if Pos('[POST_LOCAL_FILE]', PostData) > 0 then
      TmOut := 90000;
    S := ExtractCompStr(Opts, '[READ_TIMEOUT=', ']');
    if S <> '' then
      TmOut := StrToIntDef(S, TmOut);
    Client.IOTimeout := TmOut;
    if TmOut > 1 then
      Client.ConnectTimeout := TmOut div 2
    else
      Client.ConnectTimeout := TmOut;
    Client.AllowRedirect := Pos('[NO_REDIR]', Opts) = 0;

    Client.AddHeader('User-Agent', GetNetUserAgent);
    Client.AddHeader('Accept', 'text/html, */*');
    AddCustomHeaders(Client, headers);

    if FBaServerAddr <> '' then
    begin
      if Copy(URL, 1, 1) = '/' then
        URL := FBaServerAddr + URL
      else if Pos('://', URL) = 0 then
        URL := FBaServerAddr + '/' + URL;
    end;

    if Pos('${TICK}', URL) > 0 then
      URL := StringReplace(URL, '${TICK}', IntToStr(GetTickCount), [rfReplaceAll]);
    if Pos('${JSESSIONID}', URL) > 0 then
      URL := StringReplace(URL, '${JSESSIONID}', URLEncodeEx(GetJSessionId_Net), [rfReplaceAll]);

    UseCookies := ShouldUseCookieJar(URL);
    if UseCookies and (FCookieJar <> nil) then
      Client.Cookies.Assign(FCookieJar);

    if ShouldNetLog(URL) then
    begin
      S := 'Net_URL: ' + URL;
      if Opts <> '' then
        S := S + #13#10 + 'Options: ' + Opts;
      if PostData <> '' then
        S := S + #13#10 + 'PostData: ' + PostData;
      AddNetLog(S);
      if headers <> '' then
        AddNetLog('Net_Header: ' + Client.RequestHeaders.Text);
    end;

    SaveFn := ExtractSaveToFileName(PostData, Opts);
    if SaveFn <> '' then
    begin
      S := ExtractFilePath(SaveFn);
      if S <> '' then
        ForceDirectories(S);
      FileResult := TFileStream.Create(SaveFn, fmCreate);
      ResponseStream := FileResult;
    end
    else
    begin
      MemoryResult := TMemoryStream.Create;
      ResponseStream := MemoryResult;
    end;

    try
      if PostData = '' then
        Client.HTTPMethod('GET', URL, ResponseStream, [])
      else if Pos('[POST_LOCAL_FILE]', PostData) > 0 then
      begin
        UploadFn := ExtractCompStr(PostData, '[POST_LOCAL_FILE]', '[/POST_LOCAL_FILE]');
        if not FileExists(UploadFn) then
          raise Exception.Create('Uploading file not exists: ' + UploadFn);
        if ShouldNetLog(URL) then
          AddNetLog('Net_Upload: ' + UploadFn);
        Client.FileFormPost(URL, ExtractFileName(UploadFn), UploadFn, ResponseStream);
      end
      else
      begin
        if ShouldNetLog(URL) then
          AddNetLog('Net_Post: ' + PostData);

        S := ExtractCompStr(Opts, '[CONTENT_TYPE=', ']');
        if S = '' then
          S := 'application/x-www-form-urlencoded; charset=utf-8';
        Client.AddHeader('Content-Type', S);

        BodyStream := TRawByteStringStream.Create(PostData);
        Client.RequestBody := BodyStream;
        try
          Client.HTTPMethod('POST', URL, ResponseStream, []);
        finally
          Client.RequestBody := nil;
          FreeAndNil(BodyStream);
        end;
      end;

      if UseCookies then
        MergeResponseCookies(Client);

      if Client.ResponseStatusCode >= 400 then
      begin
        S := Format('Error %d', [Client.ResponseStatusCode]);
        if Client.ResponseStatusText <> '' then
          S := S + ': ' + Client.ResponseStatusText;
        raise Exception.Create(S);
      end;
    except
      on E: Exception do
      begin
        if ShouldNetLog(URL) then
          AddNetLog('Net_Error: ' + E.Message);
        raise;
      end;
    end;

    Result := '';
    if MemoryResult <> nil then
      ReadStreamToString(MemoryResult, Result);

    if IsUtf8Type(URL, Client) then
      Result := UTF8Decode(Result);

    if ShouldNetLog(URL) then
      AddNetLog('Net_Result: ' + Result + #13#10'-------------------------------------------------');
  finally
    if BodyStream <> nil then
    begin
      Client.RequestBody := nil;
      BodyStream.Free;
    end;
    FileResult.Free;
    MemoryResult.Free;
    if OwnClient then
      Client.Free;
  end;
end;

function GetUrlData_Net_Ex(URL: string; PostData: string; Opts: string): string;
begin
  try
    Result := GetUrlData_Net_ExX(URL, PostData, '', Opts, nil);
  except
    on E: Exception do
    begin
      AddNetLog('Network error - ' + URL + #13#10 + E.Message);
      raise Exception.Create('Request failed, please check network.'#13#10'Error message:'#13#10 + E.Message);
    end;
  end;
end;

function GetUrlData_Net(URL: string; PostData: string; Opts: string): string;
var
  cr: TCursor;
begin
  if Pos('[SHOW_PROGRESS]', UpperCase(Opts)) = 0 then
  begin
    Result := GetUrlData_Net_Ex(URL, PostData, Opts);
    Exit;
  end;
  {$IFNDEF WINDOWS}
  cr := Screen.Cursor;
  Screen.Cursor := crAppStart;
  try
    Result := GetUrlData_Net_Ex(URL, PostData, Opts);
  finally
    Screen.Cursor := cr;
  end;
  Exit;
  {$ENDIF}
  with TUrlWaitor.Create do
  try
    FUrl := URL;
    FPostData := PostData;
    FOpts := Opts;
    ShowAndWait;
    Result := FUrlResData;
  finally
    Free;
  end;
end;

function URLDecodeEx(const S: string): string;
var
  Idx: Integer;
  Hex: string;
  Code: Integer;
begin
  Result := '';
  Idx := 1;
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
        begin
          if Idx <= Length(S) - 2 then
          begin
            Hex := S[Idx + 1] + S[Idx + 2];
            Code := SysUtils.StrToIntDef('$' + Hex, -1);
            Inc(Idx, 2);
          end
          else
            Code := -1;
          if Code = -1 then
            raise SysUtils.EConvertError.Create('Invalid hex digit in URL');
          Result := Result + Chr(Code);
        end;
      '+':
        Result := Result + ' ';
    else
      Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
end;

function URLEncodeEx(const VS: string): string;
var
  Idx: Integer;
  InQueryString: Boolean;
  S: string;
begin
  Result := '';
  S := VS;
  InQueryString := False;
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
    else
      Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;

{ TUrlWaitor }

procedure TUrlWaitor.ShowAndWait;
var
  title, msg, cancelPrompt, tks: string;
  wt: TWaitThread;
  tk: Integer;
begin
  title := ExtractCompStr(FOpts, '[TITLE=', ']');
  msg := ExtractCompStr(FOpts, '[MSG=', ']');
  cancelPrompt := ExtractCompStr(FOpts, '[CANCEL_MSG=', ']');

  tks := ExtractCompStr(FOpts, '[WAIT_TICKS=', ']');
  tk := StrToIntDef(tks, 900);

  wt := TWaitThread.Create(Title, msg, cancelPrompt, Self.DoExec);
  FWaitThr := wt;
  with wt do
  try
    frmWait.btnCancel.Visible := True;
    if not WaitEx(tk) then
      Abort;
  finally
    FWaitThr := nil;
    AutoFree;
  end;
end;

procedure TUrlWaitor.DoExec(var bSuccess: Boolean);
begin
  try
    FUrlResData := GetUrlData_Net_Ex(FURL, FPostData, FOpts);
  except
    on E: Exception do
      TWaitThread(FWaitThr).ErrorMsg := E.Message;
  end;
  bSuccess := True;
end;

initialization
  G_NetLogEnabled := True;
  G_NetLogs := TStringList.Create;
  FCookieJar := TStringList.Create;

finalization
  FreeAndNil(FCookieJar);
  FreeAndNil(G_NetLogs);

end.
