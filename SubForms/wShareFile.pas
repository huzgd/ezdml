unit wShareFile;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  CheckLst, Calendar, EditBtn,
  CtObjJsonSerial, CtMetaTable;

type

  { TfrmShareFile }

  TfrmShareFile = class(TForm)
    btnClose: TButton;
    btnCancel: TButton;
    btnCopyUrl: TButton;
    btnPreview: TButton;
    btnBack: TButton;
    btnGenShareUrl: TButton;
    btnCopyPrev: TButton;
    btnEncHelp: TButton;
    btnSaveToFile: TButton;
    ckbCheckAll: TCheckBox;
    CheckListBox1: TCheckListBox;
    DateEdit_Expired: TDateEdit;
    edtPassword: TEdit;
    edtTitle: TEdit;
    edtTitle2: TEdit;
    edtUrl: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelTitle: TLabel;
    LabelTitle1: TLabel;
    LabelUrl: TLabel;
    MemoPrev: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    SaveDialog1: TSaveDialog;
    StaticTextEncTip: TStaticText;
    TimeEdit_Expired: TTimeEdit;
    procedure btnBackClick(Sender: TObject);
    procedure btnCopyUrlClick(Sender: TObject);
    procedure btnCopyPrevClick(Sender: TObject);
    procedure btnEncHelpClick(Sender: TObject);
    procedure btnGenShareUrlClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure ckbCheckAllChange(Sender: TObject);
    procedure DateEdit_ExpiredAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure DateEdit_ExpiredChange(Sender: TObject);
  private
    FFileName: string;
    function SaveCheckedModels: string;
  public
    procedure InitDml(dms: TCtDataModelGraphList);
  end;

var
  frmShareFile: TfrmShareFile;

implementation

uses
  WindowFuncs, base64, AESCrypt, md5, NetUtil, uJson, CtSysInfo, ezdmlstrs,
  uFormOnlineFile, ClipBrd;

{$R *.lfm}

{ TfrmShareFile }

function AEncryptStr(const S, Key,IV: string): string;
  function Min(const A, B: Integer): Integer;
  begin
    if A < B then
      Result := A
    else
      Result := B;
  end;
var
  SrcStream, TgtStream: TStringStream;
  AESKey: TAESKey256;
  InitVector: TAESBuffer;
begin
  Result := '';
  SrcStream := TStringStream.Create(S);
  TgtStream := TStringStream.Create('');
  try
    FillChar(AESKey, SizeOf(AESKey), 0);
    Move(PChar(Key)^, AESKey, Min(SizeOf(AESKey), Length(Key)));
    Move(PChar(IV)^, InitVector, Min(SizeOf(InitVector), Length(IV)));
    EncryptAESStreamCBC(SrcStream, SrcStream.Size - SrcStream.Position, AESKey,InitVector, TgtStream);
    Result := TgtStream.DataString;
  finally
    SrcStream.Free;
    TgtStream.Free;
  end;
end;

procedure TfrmShareFile.ckbCheckAllChange(Sender: TObject);
begin                      
  if ckbCheckAll.Checked then
    CheckListBox1.CheckAll(cbChecked)
  else
    CheckListBox1.CheckAll(cbUnchecked);
end;

procedure TfrmShareFile.DateEdit_ExpiredAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
  if ADate<Date then
    AcceptDate := False;
end;

procedure TfrmShareFile.DateEdit_ExpiredChange(Sender: TObject);
begin
  TimeEdit_Expired.Visible:= DateEdit_Expired.Text <> '';
end;

function TfrmShareFile.SaveCheckedModels: string;
var
  I: Integer; 
  mds: TCtDataModelGraphList;
  ose: TCtObjMemJsonSerialer;
begin                        
  mds:= TCtDataModelGraphList.Create;
  ose := TCtObjMemJsonSerialer.Create(False);
  try    
    mds.AutoFree := False;
    with CheckListBox1.Items do
      for I:=0 to Count - 1 do
        if CheckListBox1.Checked[I] then
          mds.Add(TCtDataModelGraph(CheckListBox1.Items.Objects[I]));

    ose.RootName := 'DataModels';
    mds.SaveToSerialer(ose);   
    ose.EndJsonWrite;

    ose.Stream.Seek(0, soFromBeginning);
    SetLength(Result, ose.Stream.Size);
    ose.Stream.Read(PChar(Result)^, ose.Stream.Size);
  finally    
    ose.Free;
    mds.Free;
  end;
end;

procedure TfrmShareFile.btnPreviewClick(Sender: TObject);
  function GenRandomStr(len: Integer): string;
  var
    b: byte;
  begin
    Result := '';
    while Length(Result)<len do
    begin
      b:=Random(256);
      Result := Result + Chr(b);
    end;
  end;
  function MakeKey(S: string): string;
  begin
    while Length(S)<32 do
      S:=S+S;
    Result := Copy(S,1,32);
  end;

  function MakeIV(S: string): string;
  var
    md: TMD5Digest;
  begin
    md:=MD5String(S);
    SetLength(Result, 16);
    Move(md, PChar(Result)^, 16);
  end;

var
  I, C, L: Integer;
  S, T, hd, tail: String;
begin
  c:=MemoPrev.Font.Size;
  CtSetFixWidthFont(MemoPrev);
  MemoPrev.Font.Size := C;

  C:=0;
  with CheckListBox1.Items do
    for I:=0 to Count - 1 do
      if CheckListBox1.Checked[I] then
        Inc(C);
  if C=0 then
    raise Exception.Create(srEzdmlNoModelChecked);
  edtTitle2.Text := edtTitle.Text;

  btnEncHelp.Visible := False;    
  StaticTextEncTip.Visible := False;
  S:=SaveCheckedModels;
  if Trim(edtPassword.Text)<>'' then
  begin
    Randomize;
    hd := GenRandomStr(64+Random(128));
    hd := EncodeStringBase64(hd);
    hd := Copy(hd, 1, Length(hd)-3);
    S:=hd+#10+S+#10+hd+#10;
    L:=Length(S);
    L := L mod 16;
    L := 16 - L;
    tail := GenRandomStr(L+8);
    tail := EncodeStringBase64(tail);
    S:=S+Copy(tail,1,L);
    S:=AEncryptStr(S,MakeKey(edtPassword.Text), MakeIV(edtTitle.Text));
    T := EncodeStringBase64(S);
    S:='[DMJ_ENC_AES]'#13#10'TITLE='+UrlEncode(edtTitle.Text)+#13#10;
    while T<>'' do
    begin
      if Length(T)>80 then
      begin
        S:=S+Copy(T,1,80)+#13#10;
        T:=Copy(T,81,Length(T));
      end
      else
      begin
        S:=S+T;
        T:='';
      end;
    end; 
    btnEncHelp.Visible := True;
  end;
  MemoPrev.Lines.Text :=S;

  Panel1.Hide;
  Panel2.Show;
end;

procedure TfrmShareFile.btnSaveToFileClick(Sender: TObject);
begin
  SaveDialog1.FileName:=edtTitle.Text;
  if SaveDialog1.Execute then
    MemoPrev.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmShareFile.btnBackClick(Sender: TObject);
begin
  Panel2.Hide;
  Panel1.Show;
end;

procedure TfrmShareFile.btnCopyUrlClick(Sender: TObject);
begin
  ClipBoard.AsText:=edtUrl.Text;
end;

procedure TfrmShareFile.btnCopyPrevClick(Sender: TObject);
begin
  MemoPrev.SelectAll;
  MemoPrev.CopyToClipboard;
end;

procedure TfrmShareFile.btnEncHelpClick(Sender: TObject);
begin
  if not StaticTextEncTip.Visible then
  begin
    StaticTextEncTip.Show;
    StaticTextEncTip.BringToFront;
  end
  else
    StaticTextEncTip.Hide;
end;

procedure TfrmShareFile.btnGenShareUrlClick(Sender: TObject);
var
  S, url, ssid, qData, fn: String;
  jMap: TJSONObject;
begin
  if Trim(edtPassword.Text)='' then
    if Application.MessageBox(PChar(srEzdmlShareWithoutPwdWarning),
      PChar(edtTitle.Text), MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
      Exit;
  ssid := CtGenGUID;
  url := 'http://ezdml.com/ez/mup/?attssid='+ssid;
  url := url+'&dataType=json&t='+FormatDateTime('yyyymmddhhnnss',Now);
  fn := GetAppDefTempPath();
  if not DirectoryExists(fn) then
    ForceDirectories(fn);
  fn := FolderAddFileName(fn, FFileName+'.dmj');
  fn := GetUnusedFileName(fn);
  MemoPrev.Lines.SaveToFile(fn); 
  jMap := nil;
  try
    S := GetUrlData_Net(url, '[POST_LOCAL_FILE]' + fn + '[/POST_LOCAL_FILE]', '[SHOW_PROGRESS]');
    if (Pos('{', S)=1) and (Pos('"resultCode":0',S)>0) then
    begin    
      url := 'http://ezdml.com/ez/msave/?t='+FormatDateTime('yyyymmddhhnnss',Now);
      qData := 'main.NAME='+UrlEncode(edtTitle2.Text);  
      if Trim(edtPassword.Text)='' then
        qData := qData+'&main.PWD_PROTECTED=0'
      else
        qData := qData+'&main.PWD_PROTECTED=1';
      qData := qData+'&main.MEMO=';
      qData := qData+'&main.EXPIRED_DATE=';
      if DateEdit_Expired.Text<>'' then
      begin        
        if TimeEdit_Expired.Text<>'' then
          qData := qData+UrlEncode(DateEdit_Expired.Text+' '+TimeEdit_Expired.Text)
        else
          qData := qData+UrlEncode(DateEdit_Expired.Text);
      end;
      qData := qData+'&main.__GLOBE_OPID='+ssid;
      qData := qData+'&main.CREATOR_DML_UID='+GetMyComputerId;
      S := GetUrlData_Net(url,qData, '[SHOW_PROGRESS]');
      if (Pos('{', S)=1) then
      begin
        jMap := TJSONObject.create(S);
        if jMap.optInt('resultCode') <> 0 then   
          raise Exception.Create(srEzdmlCommitShareError+' - '+jMap.optString('errorMsg'));
        edtUrl.Text := jMap.optString('SHARE_URL');
        AddOnlineHistoryFile(jMap.optString('SHARE_GUID'),edtUrl.Text,srEzdmlSharedByMe,Length(MemoPrev.Lines.Text));
        LabelUrl.Visible := True;
        edtUrl.Visible := True;        
        btnCopyUrl.Visible := True;
        DateEdit_Expired.Enabled:=False;              
        TimeEdit_Expired.Enabled:=False;
        btnGenShareUrl.Enabled:=False;       
        btnBack.Visible:=False;
        btnClose.Visible:=True;
      end
      else
        raise Exception.Create(srEzdmlCommitShareError+' - '+S);
    end
    else
      raise Exception.Create(srEzdmlCommitShareError+' - '+S);
  finally
    DeleteFile(fn);
    if Assigned(jMap) then
      jMap.Free;
  end;

end;

procedure TfrmShareFile.InitDml(dms: TCtDataModelGraphList);
var
  I, si: Integer;
  md: TCtDataModelGraph;
  ds: String;
begin
  si:=-1;
  ds := FormatDateTime('yyyymmdd_hhnnss',Now);
  FFileName := 'ezmodel_'+ds;
  DateEdit_Expired.Text := FormatDateTime('yyyy-mm-dd', Date+10);
  TimeEdit_Expired.Text := '00:00';
  with CheckListBox1.Items do
  begin
    Clear;
    for I:=0 to dms.Count - 1 do
    begin
      md := dms.items[I];
      AddObject(md.NameCaption, md);
      if md=dms.CurDataModel then
      begin
        si := I;
        edtTitle.Text:= md.NameCaption+'_'+Self.Caption+'_'+ds;
      end;
    end;
  end;
  if si>=0 then
    CheckListBox1.Checked[si]:=True;
end;

end.

