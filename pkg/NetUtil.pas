unit NetUtil;

{$ifndef EZDML_LITE}
//如果indy编译有问题，可注掉此开关，改用fpHttpClient
{$DEFINE USE_IDHTTP}
{$endif}

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
{$IFDEF USE_IDHTTP}
  IdHttp, IdCookieManager, IdMultipartFormData, IdSSLOpenSSL, IdGlobalProtocols, IdTCPClient,
  IdHTTPHeaderInfo,
{$else}
  fphttpclient, Sockets,
{$ENDIF}
  ThreadWait, WindowFuncs, Forms, ezdmlstrs;


function GetUrlParamVal(URL, par: string): string;
var
  S: String;
begin
  URL := URL+'&';
  S:=ExtractCompStr(URL,'?'+par+'=','&');
  if S='' then
    S:=ExtractCompStr(URL,'&'+par+'=','&');
  S:=URLDecode(S);
  Result := S;
end;

function IsPortAvailable(Aport: Word): Boolean; 
{$IFDEF USE_IDHTTP}
begin
  Result := True;
  with TIdTCPClient.Create(nil) do
  try
    ConnectTimeout := 200;
    try
      Connect('127.0.0.1', APort);
      Result := False;
      DisConnect;
    except
    end;
  finally
    Free;
  end;
end;
{$else}
var
  sock: TSocket;
  addr: TInetSockAddr;
  timeout: Integer;
begin
  // 创建一个 socket 连接
  sock := fpSocket(AF_INET, SOCK_STREAM, 0);
  if sock = {INVALID_SOCKET}TSocket(NOT(0)) then
  begin
    Result := False; // 创建失败，端口可能被占用
    Exit;
  end;

  // 设置地址信息
  addr.sin_family := AF_INET;
  addr.sin_port := htons(Aport);
  addr.sin_addr.s_addr := htonl($7f000001{INADDR_LOOPBACK}); // 本地地址

  timeout := 200;
  fpSetSockOpt(sock, SOL_SOCKET, SO_SNDTIMEO, @timeout, sizeof(timeout));  
  fpSetSockOpt(sock, SOL_SOCKET, SO_RCVTIMEO, @timeout, sizeof(timeout));

  // 尝试连接
  if fpConnect(sock, @addr, SizeOf(addr)) = 0 then
  begin
    // 连接成功，端口已被占用
    CloseSocket(sock);
    Result := False;
  end
  else
  begin
    // 连接失败，端口可用
    CloseSocket(sock);
    Result := True;
  end;
end;     
{$ENDIF}

                  
procedure AddNetLog(const msg: string; bAddDate: Boolean=True);
var
  S: string;
begin
  while G_NetLogs.Count > 1000 do
    G_NetLogs.Delete(0);
  if bAddDate then
    S := FormatDateTime('hh:nn:ss', Now);
  G_NetLogs.Add(S + ' ' + msg);
end;

               
{$IFNDEF USE_IDHTTP}
function GetUrlData_Net_ExX(URL: string; PostData: string; headers: string; Opts: string; conn: TObject): string;
var
  fn: string;             
  fp: TFPCustomHTTPClient;
  res:TMemoryStream;
  L:Integer;
begin
  if PostData='' then
    Result := TFPCustomHTTPClient.SimpleGet(url)
  else
  begin       
    if Pos('[POST_LOCAL_FILE]', PostData) > 0 then
    begin
      fn := ExtractCompStr(PostData, '[POST_LOCAL_FILE]', '[/POST_LOCAL_FILE]');
      if not FileExists(fn) then
        raise Exception.Create('Uploading file not exists: ' + fn);
      res := TMemoryStream.Create;
      fp:=TFPCustomHTTPClient.Create(nil);
      try
        fp.FileFormPost(url, 'file', fn, res);
        L := res.Size;
        res.Position:=0;
        SetLength(Result, L);
        res.Read(PChar(Result)^, L);
      finally
        res.Free;
        fp.Free;
      end;
    end
    else
      Result := TFPCustomHTTPClient.SimpleFormPost(url, PostData);
  end;
end;
function GetJSessionId_Net: string;
begin
  Result := '';
end;
procedure SetJSessionId_Net(svr, ssid: string);
begin
end;
{$ENDIF}
          
{$IFDEF USE_IDHTTP}     
var
  FCookieManager: TIdCookieManager;
  FBaServerAddr: string;

function IsUtf8Type(url: string; Response: TIdHTTPResponse): Boolean;
var
  tp: string;
begin
  Result := False;
  tp := Response.CharSet;
  if tp <> '' then
  begin
    tp := LowerCase(tp);
    if (Pos('utf8', tp) > 0) or (Pos('utf-8', tp) > 0) then
    begin
      Result := True;
    end;
    Exit;
  end;

  tp := LowerCase(Response.ContentType);
  if tp <> '' then
  begin
    if Pos('utf-8', tp) > 0 then
      Result := True
    else if Pos('utf8', tp) > 0 then
      Result := True;
    if Result then
      Exit;
  end;

  if (Pos('/ucv.nx?', url) > 0) or (Pos('/utf8cv.nx?', url) > 0) then
    Result := True;
end;

function GetJSessionId_Net: string;
var
  I: Integer;
begin
  Result := '';
  if FCookieManager = nil then
    Exit;
  I := FCookieManager.CookieCollection.GetCookieIndex('JSESSIONID');
  if I >= 0 then
    Result := FCookieManager.CookieCollection.Cookies[I].Value;
end;

procedure SetJSessionId_Net(svr, ssid: string);
var
  I: Integer;
begin
  if FCookieManager = nil then
    FCookieManager := TIdCookieManager.Create(Application);
  if svr <> '' then
    if svr[Length(svr)] <> '/' then
      svr := svr + '/';
  FBaServerAddr := svr;
  if ssid = '' then
    Exit;
  I := FCookieManager.CookieCollection.GetCookieIndex('JSESSIONID');
  if I >= 0 then
    FCookieManager.CookieCollection.Cookies[I].Value := ssid
  else
  begin
    FCookieManager.CookieCollection.AddClientCookie('JSESSIONID=' + ssid + ';');
  (*
    po := Pos('://', svr);
    if po > 0 then
      svr := Copy(svr, po + 3, Length(svr));
    po := Pos('/', svr);
    if po > 0 then
      svr := Copy(svr, 1, po - 1);
    po := Pos(':', svr);
    if po > 0 then
      svr := Copy(svr, 1, po - 1);

      FCookieManager.CookieCollection
      .AddCookie('JSESSIONID=' + ssid + '; path=/', uri, False);
             *)
  end;
end;

function GetUrlData_Net_ExX(URL: string; PostData: string; headers: string; Opts: string; conn: TObject): string;
var
  vIdHTTP: TIdHTTP;
  SslIo: TIdSSLIOHandlerSocketOpenSSL;
  ms, rs: TMemoryStream;
  rfs: TFileStream;
  pfs: TIdMultiPartFormDataStream;
  S, T, V, fn: string;
  I, po, tmOut: Integer;
  hs: TStrings;
begin
  if FCookieManager = nil then
    FCookieManager := TIdCookieManager.Create(Application);

  vIdHTTP := nil;
  SslIo := nil;
  try
    if (conn <> nil) and (conn is TIdHTTP) then
      vIdHTTP := TIdHTTP(conn)
    else
    begin
      vIdHTTP := TIdHTTP.Create(nil);
  {

  object vIdHTTP: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 20000
    AuthRetries = 1
    AllowCookies = True
    HandleRedirects = True
    RedirectMaximum = 1
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    OnRedirect = vIdHTTPRedirect
    Left = 256
    Top = 276
  end
  }
  //vIdHTTP.ProxyParams.ProxyServer := '127.0.0.1';
  //vIdHTTP.ProxyParams.ProxyPort := 8088;

      with vIdHTTP do
      begin
        tmOut := 20000;
        if Pos('[SAVE_TO_FILE]', PostData) > 0 then
          tmOut := 90000;
        if Pos('[POST_LOCAL_FILE]', PostData) > 0 then
          tmOut := 90000;
        S := ExtractCompStr(Opts, '[READ_TIMEOUT=', ']');
        if S <> '' then
          tmOut := StrToIntDef(S, tmOut); 
        ConnectTimeout := tmOut div 2;
        ReadTimeout := tmOut;
        AllowCookies := True;
        if Pos('[NO_REDIR]', opts) > 0 then
          HandleRedirects := False
        else
          HandleRedirects := True;
        HTTPOptions := [hoForceEncodeParams];
      end;
    end;

    if FBaServerAddr<>'' then
    begin
      if Copy(URL, 1, 1) = '/' then
        URL := FBaServerAddr + URL
      else if Pos('://', URL) = 0 then
        URL := FBaServerAddr + '/' + URL;
    end;

    if Pos('https://', URL) = 1 then
      if vIdHTTP.IOHandler = nil then
      begin
        SslIo := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        vIdHTTP.IOHandler := sslIO;
        with SslIo do
        begin
          SSLOptions.Method := sslvSSLv23;
          SSLOptions.Mode := sslmClient;
          SSLOptions.VerifyMode := [];
          SSLOptions.VerifyDepth := 0;
          PassThrough := True;
        end;
      end;

    Result := '';
    if Pos('${TICK}', URL) > 0 then
      URL := StringReplace(URL, '${TICK}', IntToStr(GetTickCount), [rfReplaceAll]);
    if Pos('${JSESSIONID}', URL) > 0 then
      URL := StringReplace(URL, '${JSESSIONID}', UrlEncode(GetJSessionId_Net), [rfReplaceAll]);

    if FBaServerAddr <> '' then
      if Pos(FBaServerAddr, URL) = 1 then
        vIdHTTP.CookieManager := FCookieManager;

    if G_NetLogEnabled then
      if Pos('&noNetLog=1', URL) = 0 then
      begin
        S := 'Net_URL: ' + URL;
        if Opts <> '' then
          S := S + #13#10 + 'Options: ' + Opts;
        if PostData <> '' then
          S := S + #13#10 + 'PostData: ' + PostData;
        AddNetLog(S);
      end;

    rs := TMemoryStream.Create;
    if Pos('[SAVE_TO_FILE]', PostData) > 0 then
    begin
      fn := ExtractCompStr(PostData, '[SAVE_TO_FILE]', '[/SAVE_TO_FILE]');
      ForceDirectories(ExtractFilePath(fn));
      rfs := TFileStream.Create(fn, fmCreate);
      PostData := '';
    end
    else
      rfs := nil;

    try
      if headers <> '' then
      begin
        hs := TStringList.Create;
        try
          hs.Text := headers;
          for I := 0 to hs.Count - 1 do
          begin
            S := hs[I];
            po := Pos('=', S);
            if po > 0 then
            begin
              T := Trim(Copy(S, 1, po - 1));
              V := Copy(S, po + 1, Length(S));
              if T <> '' then
                vIdHTTP.Request.CustomHeaders.Values[T] := V;
            end;
          end;
        finally
          hs.Free;
        end;
        if G_NetLogEnabled then
          if Pos('&noNetLog=1', URL) = 0 then
          begin
            S := 'Net_Header: ' + vIdHTTP.Request.CustomHeaders.Text;
            AddNetLog(S);
          end;
      end;

      //vIdHTTP.Request.UserAgent :='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';
      try

        if PostData = '' then
        begin
          if rfs = nil then
          begin
           // Result := vIdHTTP.Get(URL{, CharsetToEncoding('GBK')})
            vIdHTTP.Get(URL, rs);
            rs.Seek(0, soFromBeginning);
            SetLength(Result, rs.Size);
            rs.Read(PChar(Result)^, rs.Size);
          end
          else
            vIdHTTP.Get(URL, rfs);
        end
        else if Pos('[POST_LOCAL_FILE]', PostData) > 0 then
        begin
          fn := ExtractCompStr(PostData, '[POST_LOCAL_FILE]', '[/POST_LOCAL_FILE]');
          if not FileExists(fn) then
            raise Exception.Create('Uploading file not exists: ' + fn);
          if G_NetLogEnabled then
            if Pos('&noNetLog=1', URL) = 0 then
            begin
              S := 'Net_Upload: ' + fn;
              AddNetLog(S);
            end;
          pfs := TIdMultiPartFormDataStream.Create;
          try
            pfs.AddFile(ExtractFileName(fn), fn, '');
            if rfs = nil then
            begin
              vIdHTTP.Post(URL, pfs, rs);  
              rs.Seek(0, soFromBeginning);
              SetLength(Result, rs.Size);
              rs.Read(PChar(Result)^, rs.Size);
            end
            else
              vIdHTTP.Post(URL, pfs, rfs);
          finally
            pfs.Free;
          end;
        end
        else
        begin
          if G_NetLogEnabled then
            if Pos('&noNetLog=1', URL) = 0 then
            begin
              S := 'Net_Post: ' + PostData;
              AddNetLog(S);
            end;
          ms := TMemoryStream.Create;
          try
            ms.Write(Pointer(PostData)^, Length(PostData));
            ms.Seek(0, soFromBeginning);
            S := ExtractCompStr(Opts, '[CONTENT_TYPE=', ']');
            if S = '' then
              S := 'application/x-www-form-urlencoded; charset=utf-8';
            if S <> '' then
              vIdHTTP.Request.ContentType := S;
            if rfs = nil then
            begin
              vIdHTTP.Post(URL, ms, rs);
              rs.Seek(0, soFromBeginning);
              SetLength(Result, rs.Size);
              rs.Read(PChar(Result)^, rs.Size);
            end
            else
              vIdHTTP.Post(URL, ms, rfs);
          finally
            ms.Free;
          end;
        end;

      except
        on E: Exception do
        begin
          if G_NetLogEnabled then
            if Pos('&noNetLog=1', URL) = 0 then
            begin
              S := 'Net_Error: ' + E.Message;
              AddNetLog(S);
            end;
          raise;
        end;
      end;


    finally
      if rfs <> nil then
        rfs.Free;
      rs.Free;
    end;

    if IsUtf8Type(URL, vIdHTTP.Response) then
      Result := UTF8Decode(Result);

    if G_NetLogEnabled then
      if Pos('&noNetLog=1', URL) = 0 then
      begin
        S := 'Net_Result: ' + Result;
        AddNetLog(S + #13#10'-------------------------------------------------');
      end;

  finally
    if SslIo <> nil then
    begin
      if vIdHTTP.IOHandler = SslIo then
        vIdHTTP.IOHandler := nil;
      SslIo.Free;
    end;
    if vIdHTTP <> conn then
      vIdHTTP.Free;
  end;

end;           
{$ENDIF}

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
begin
  if Pos('[SHOW_PROGRESS]', UpperCase(Opts)) = 0 then
  begin
    Result := GetUrlData_Net_Ex(URL, PostData, Opts);
    Exit;
  end;
  {$IFNDEF WINDOWS}   
    Result := GetUrlData_Net_Ex(URL, PostData, Opts);
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
  Idx: Integer; // loops thru chars in string
  Hex: string; // string of hex characters
  Code: Integer; // hex character code (-1 on error)
begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
        begin
        // % should be followed by two hex digits - exception otherwise
          if Idx <= Length(S) - 2 then
          begin
          // there are sufficient digits - try to decode hex digits
            Hex := S[Idx + 1] + S[Idx + 2];
            Code := SysUtils.StrToIntDef('$' + Hex, -1);
            Inc(Idx, 2);
          end
          else
          // insufficient digits - error
            Code := -1;
        // check for error and raise exception if found
          if Code = -1 then
            raise SysUtils.EConvertError.Create(
              'Invalid hex digit in URL'
              );
        // decoded OK - add character to result
          Result := Result + Chr(Code);
        end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
    else
        // All other characters pass thru unchanged
      Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
  //Result := Utf8Decode(Result);
end;


function URLEncodeEx(const VS: string): string;
var
  Idx: Integer; // loops thru characters in string
  InQueryString: Boolean;
  S: string;
begin
  Result := '';
  S := Utf8Encode(VS);
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
{$IFDEF USE_IDHTTP}                 
{$ifdef WINDOWS}
{$ifdef WIN32}
  GIdDefaultUserAgent := 'Mozilla/3.0 (compatible; Indy Library) EZDML Win32 '+srEzdmlVersionNum;
{$else}
  GIdDefaultUserAgent := 'Mozilla/3.0 (compatible; Indy Library) EZDML Win64 '+srEzdmlVersionNum;
{$endif}
{$else}
{$IFDEF DARWIN}
  GIdDefaultUserAgent := 'Mozilla/3.0 (compatible; Indy Library) EZDML MacOS '+srEzdmlVersionNum;
{$else}
  GIdDefaultUserAgent := 'Mozilla/3.0 (compatible; Indy Library) EZDML Linux '+srEzdmlVersionNum;
{$ENDIF}
{$endif}
{$ENDIF}



end.

