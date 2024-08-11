unit uFormOnlineFile;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls, uJson;

type

  { TfrmOnlineFile }

  TfrmOnlineFile = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    edtFileURL: TEdit;
    ImageList1: TImageList;
    Label4: TLabel;
    ListViewFiles: TListView;
    TabControlFileType: TTabControl;
    TimerInit: TTimer;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListViewFilesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListViewFilesClick(Sender: TObject);
    procedure ListViewFilesDblClick(Sender: TObject);
    procedure TabControlFileTypeChange(Sender: TObject);
    procedure TimerInitTimer(Sender: TObject);
  private
    FWebRes: TJSONObject;    
    procedure ReloadListView;
    procedure GetSelectedInfo;

  public
    { Public declarations }
    procedure ReloadWebList;
  end;

function GetOnlineHistoryFiles: TStrings;
procedure AddOnlineHistoryFile(sid, url, memo: string; size: Integer);

var
  frmOnlineFile: TfrmOnlineFile;

implementation

{$R *.lfm}

uses
  ezdmlstrs, NetUtil, WindowFuncs, CtSysInfo;

var
  G_OnlineHistoryFiles: TStrings;

function GetOnlineHistoryFiles: TStrings; 
var
  AFileName: string;
begin
  if G_OnlineHistoryFiles<>nil then
  begin
    Result:=G_OnlineHistoryFiles;
    Exit;
  end;

  G_OnlineHistoryFiles := TStringList.Create;
  Result:=G_OnlineHistoryFiles;

  AFileName := GetConfFileOfApp('')+'_OLHist';
  if FileExists(AFileName) then
    G_OnlineHistoryFiles.LoadFromFile(AFileName);

end;

procedure AddOnlineHistoryFile(sid, url, memo: string; size: Integer);
var
  S,T,AFileName,dt: String;
  ts: TStrings;
  I,visCount: Integer;
begin
  if sid='' then
    Exit;
  ts := GetOnlineHistoryFiles;
  visCount := 1;
  for I:=0 to ts.Count - 1 do
  begin
    S:=ts[i];
    if Pos(sid+'=', S)=1 then
    begin
      S:=Copy(S,Length(sid)+2,Length(S));
      T:=ReadCornerStr(S,S);
      visCount := StrToIntDef(T,1)+1;
      ts.Delete(I);
      break;
    end;
  end;

  dt:=FormatDateTime('yyyy-mm-dd hh:nn:ss',Now);
  S:=sid+'='+IntToStr(visCount)+','+IntToStr(size)+','+UrlEncodeEx(dt)+','+UrlEncodeEx(memo)+','+url;
  if ts.Count>0 then
    ts.Insert(0,S)
  else
    ts.Add(S);    
  AFileName := GetConfFileOfApp('')+'_OLHist';
  ts.SaveToFile(AFileName);
end;

{ TfrmOnlineFile }

procedure TfrmOnlineFile.btnOKClick(Sender: TObject);
begin
  if Trim(edtFileURL.Text) <> '' then
    ModalResult := mrOk;
end;

procedure TfrmOnlineFile.FormCreate(Sender: TObject);
var
  H: Integer;
begin
  TabControlFileType.Tabs.Text := srEzdmlOnlineFiltTypes;
  H := TabControlFileType.Height;
  {$IFDEF Windows}
  {$ELSE}
  {$IFDEF Darwin}
  TabControlFileType.Height := H*2;
  ListViewFiles.Top := ListViewFiles.Top+H;
  ListViewFiles.Height := ListViewFiles.Height-H;
  {$ELSE}   
  TabControlFileType.Height := H+H div 2;
  ListViewFiles.Top := ListViewFiles.Top+H div 2;
  ListViewFiles.Height := ListViewFiles.Height-H div 2;
  {$ENDIF}
  {$ENDIF}
end;

procedure TfrmOnlineFile.FormDestroy(Sender: TObject);
begin
  if Assigned(FWebRes) then
    FreeAndNil(FWebRes);
end;

procedure TfrmOnlineFile.FormShow(Sender: TObject);
begin
  TimerInit.Enabled := True;
end;

procedure TfrmOnlineFile.ListViewFilesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  GetSelectedInfo;
end;

procedure TfrmOnlineFile.ListViewFilesClick(Sender: TObject);
begin
  GetSelectedInfo;
end;

procedure TfrmOnlineFile.ListViewFilesDblClick(Sender: TObject);
begin  
  if Assigned(ListViewFiles.Selected) then
    btnOKClick(nil);
end;

procedure TfrmOnlineFile.TabControlFileTypeChange(Sender: TObject);
begin
  ReloadListView;
end;

procedure TfrmOnlineFile.TimerInitTimer(Sender: TObject);
begin         
  TimerInit.Enabled := False; 
  if not Assigned(FWebRes) then
    ReloadWebList;
end;

procedure TfrmOnlineFile.ReloadListView;
  procedure AddItem(jMap: TJSONObject);
  var
    item: TListItem;
    S: string;
  begin
    item := ListViewFiles.Items.Add;
    item.Caption:=jMap.optString('NAME');
    item.SubItems.Add(jMap.optString('FILE_SIZE'));
    S:=jMap.optString('CREATEDATE');
    if S='' then
      S:=jMap.optString('LASTDATE');
    item.SubItems.Add(S);
    item.SubItems.Add(jMap.optString('VISIT_COUNTER'));
    item.SubItems.Add(jMap.optString('MEMO'));           
    item.SubItems.Add(jMap.optString('FILE_GUID'));
    item.SubItems.Add(jMap.optString('SHARE_URL')); 
    item.ImageIndex:=1;
  end;
  procedure AddItem2(str: string);
  var
    item: TListItem;
    sid, S,url,fn, memo,size,vsCount,dt: string;
    po: Integer;
  begin
    if Trim(str)='' then
      Exit;
    po := Pos('=', str);
    if po<=1 then
      Exit;
    sid :=Copy(Str,1,po-1);
    S:=Copy(str,po+1,Length(Str));
    vsCount:=ReadCornerStr(S,S);  
    size:=ReadCornerStr(S,S);
    dt:=ReadCornerStr(S,S);
    dt:= UrlDecodeEx(dt);
    memo:=ReadCornerStr(S,S);
    memo:=UrlDecodeEx(memo);
    url:=S;
    fn:=GetUrlParamVal(url,'cap');
    if fn='' then
      fn := sid;

    item := ListViewFiles.Items.Add;
    item.Caption:=fn;
    item.SubItems.Add(size);
    item.SubItems.Add(dt);
    item.SubItems.Add(vsCount);
    item.SubItems.Add(memo);
    item.SubItems.Add(sid);
    item.SubItems.Add(url);
    item.ImageIndex:=1;
  end;
var
  I: Integer;
  jArr: TJSONArray;
  ts:TStrings;
begin
  ListViewFiles.Items.Clear;
  if TabControlFileType.TabIndex = 0 then
  begin
    if FWebRes= nil then
      Exit;
    jArr := FWebRes.getList('itemList');   
    for I:=0 to jArr.Count - 1 do
    begin
      AddItem(jArr.getMap(I));
    end;
  end
  else if TabControlFileType.TabIndex = 1 then
  begin
    ts := GetOnlineHistoryFiles;
    for I:=0 to ts.Count - 1 do
    begin
      AddItem2(ts[i]);
    end;
  end;
end;

procedure TfrmOnlineFile.GetSelectedInfo;
begin
  if Assigned(ListViewFiles.Selected) then
    edtFileURL.Text:=ListViewFiles.Selected.SubItems.Strings[5];
end;

procedure TfrmOnlineFile.ReloadWebList;
var
  S, url: String;
begin              
  url := 'http://ezdml.com/ez/mfiles/?uid='+GetMyComputerId+'&t='+FormatDateTime('yyyymmddhhnnss',Now);
  S := GetUrlData_Net(url, '', '[SHOW_PROGRESS][WAIT_TICKS=0]');
  if (Pos('{', S)=1) then
  begin
    FreeAndNil(FWebRes);
    FWebRes := TJSONObject.create(S);
    if FWebRes.optInt('resultCode') <> 0 then
    begin
      S:=FWebRes.optString('errorMsg');
      FreeAndNil(FWebRes);
      raise Exception.Create(srEzdmlError+' - '+S);
    end;
  end
  else
    raise Exception.Create(srEzdmlError+' - '+S);
  ReloadListView();
end;

end.

