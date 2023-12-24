unit uFormEzdmlDbFile;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls, CheckLst, Menus, CtMetaTable,
  ExtCtrls, Buttons, DB;

type

  { TfrmEzdmlDbFile }

  TfrmEzdmlDbFile = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edtFileName: TEdit;
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtDBLinkInfo: TEdit;
    btnDBLogon: TButton;
    combDBUser: TComboBox;
    combObjFilter: TComboBox;
    Label6: TLabel;
    ListViewFiles: TListView;
    MemoDML: TMemo;
    MenuItem1: TMenuItem;
    Mn_Memo: TMenuItem;
    MN_Refresh: TMenuItem;
    MN_Info: TMenuItem;
    MN_Delete: TMenuItem;
    MN_Rename: TMenuItem;
    MN_ShowHist: TMenuItem;
    PopupMenuFiles: TPopupMenu;
    TimerFilter: TTimer;
    TimerInit: TTimer;
    procedure ListViewFilesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListViewFilesDblClick(Sender: TObject);
    procedure MN_DeleteClick(Sender: TObject);
    procedure MN_InfoClick(Sender: TObject);
    procedure Mn_MemoClick(Sender: TObject);
    procedure MN_RefreshClick(Sender: TObject);
    procedure MN_RenameClick(Sender: TObject);
    procedure MN_ShowHistClick(Sender: TObject);
    procedure PopupMenuFilesPopup(Sender: TObject);
    procedure TimerFilterTimer(Sender: TObject);
    procedure TimerInitTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDBLogonClick(Sender: TObject);
    procedure combDBUserChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure combObjFilterChange(Sender: TObject);
  private
    FIsSaveMode: boolean;
    { Private declarations }
    FLinkDbNo: Integer;
    FCtMetaDatabase: TCtMetaDatabase;

    FLastAutoSelDBUser: string;
    FResultFileID: string;
    FResultFileName: string;

    FShowHistories: boolean;
    FHistoryFileFilter: string;

    procedure RefreshDbInfo;
    procedure RefreshDbInfoEx;
    procedure RefreshObjList;
       
    function GenDbFileSql(sels, where, orderby: string): string;
    procedure SetIsSaveMode(AValue: boolean);
    procedure SyncDML;
    procedure ToogleHistoryView;
    function DbFileExists(fn: string): boolean;
  public
    { Public declarations }
    Proc_OnDbFileMemoChanged: procedure(Sender: TObject; fn: string) of object;
    function PrepareToLoadFile(fn: string): boolean;
    function CheckDbFileState(fn: string; var fileSize: Integer; var fileDate: TDateTime; bForce: Boolean): Integer;     
    function GetDbFileModifierInfo(fn: string; var modifier, fileMemo: string): boolean;

    procedure LoadFromDbFile(AData: TStream; AFileId: string);
    function SaveDataToDbFile(AData: TStream; AFileName: string; bPromptMemo: Boolean): Boolean;

    property IsSaveMode: boolean read FIsSaveMode write SetIsSaveMode;
    property ResultFileName: string read FResultFileName;
    property ResultFileID: string read FResultFileID;
  end;

function ParseDbFileName(fn: string; out ptr, eng, usr, db, doc, fid: string): boolean;

var
  frmEzdmlDbFile: TfrmEzdmlDbFile;

implementation

uses
  uFormCtDbLogon, WindowFuncs, dmlstrs, AutoNameCapitalize,
  CTMetaData, uFormGenSql, PvtInput, CtSysInfo, Md5;

{$R *.lfm}
            
function ParseDbFileName(fn: string; out ptr, eng, usr, db, doc, fid: string): boolean;
var
  po: Integer;
  S1, S2, S3: String;
begin
  //解释DB文件格式： db://user@dbtype_dbid/doc

  Result := False;

  ptr:='';
  eng:='';
  usr:='';
  db:='';
  doc:='';
  fid:='';

  po := Pos('://', fn);
  if po = 0 then
  begin
    Exit;
  end;

  S1 := Copy(fn, 1, po-1);
  S2 := Copy(fn, po+3, Length(fn));


  po := Pos('/', S2);
  if po = 0 then
  begin
    fn := S2;
    S2 := '';
    S3 := '';
  end
  else
  begin
    fn := Copy(S2, po+1, Length(S2));
    S2 := Copy(S2, 1, po-1);
    po := Pos('@', S2);
    if po=0 then
    begin
      S3 := S2;
      S2 := '';
    end
    else
    begin
      S3 := Copy(S2, po+1, Length(S2));
      S2 := Copy(S2, 1, po-1);
    end;
  end;

  ptr := S1;
  db := S3;
  doc := fn;

  po := Pos('#', doc);
  if po>0 then
  begin
    fid := Copy(doc, po+1, Length(doc));
    doc := Copy(doc, 1, po-1);
  end;

  po := Pos(':', S2);
  if po=0 then
  begin
    eng := S2;
    usr := '';
  end
  else
  begin
    eng := Copy(S2,1,po-1);
    usr := Copy(S2,po+1,Length(S2));
  end;

  Result := True;
end;

procedure TfrmEzdmlDbFile.FormCreate(Sender: TObject);
begin
  FLinkDbNo := -1;
  RefreshDbInfo;
end;

procedure TfrmEzdmlDbFile.btnDBLogonClick(Sender: TObject);
var
  I: Integer;
begin
  if Sender = btnDBLogon then
    if (GetKeyState(VK_SHIFT) and $80) <> 0 then
    begin
      Self.SyncDML;
      Exit;
    end;
  I := ExecCtDbLogon;
  if I >= 0 then
  begin
    FLinkDbNo := I;
    RefreshDbInfo;
  end;
end;


procedure TfrmEzdmlDbFile.RefreshDbInfoEx;
var
  I: Integer;
  dbus: String;
begin
  Refresh;

  if FLastAutoSelDBUser = combDBUser.Text then
  begin
    combDBUser.Text := '';
    FLastAutoSelDBUser := '';
  end;

  if FLinkDbNo < 0 then
    FCtMetaDatabase := nil
  else
    FCtMetaDatabase := CtMetaDBRegs[FLinkDbNo].DbImpl;
  if not Assigned(FCtMetaDatabase) then
  begin       
    edtDBLinkInfo.Text := '';

    combDBUser.Items.Clear;
    combDBUser.Enabled := False;
    combDBUser.ParentColor := True;

    combObjFilter.Enabled := False;
    combObjFilter.ParentColor := True;
  end
  else
  begin                  
    edtDBLinkInfo.Text := '[' + FCtMetaDatabase.EngineType + ']' + FCtMetaDatabase.Database;
    Self.Refresh;

    combDBUser.Items.Text := FCtMetaDatabase.GetDbUsers;
    combDBUser.Enabled := True;
    combDBUser.Color := clWindow;
    combDBUser.Text := '';

    combObjFilter.Enabled := True;
    combObjFilter.Color := clWindow;
  end;

  if Assigned(FCtMetaDatabase) and (combDBUser.Text = '') then
  begin
    dbus := FCtMetaDatabase.DbSchema;
    if dbus = '' then
      dbus := FCtMetaDatabase.User;
    for I := 0 to combDBUser.Items.Count - 1 do
      if UpperCase(combDBUser.Items[I]) = UpperCase(dbus) then
      begin
        combDBUser.ItemIndex := I;
        FLastAutoSelDBUser := combDBUser.Text;
        RefreshObjList;
        Exit;
      end;
  end;

  RefreshObjList;
end;

procedure TfrmEzdmlDbFile.RefreshDbInfo;
var
  cr: TCursor;
begin
  cr:=Screen.Cursor;
  Screen.Cursor := crAppStart;
  try
    RefreshDbInfoEx;
    Screen.Cursor := cr;
  except                      
    Screen.Cursor := cr;
    Application.HandleException(Self);
  end;
end;

procedure TfrmEzdmlDbFile.RefreshObjList;
  function KeyFilterMatch(key, str: string): Boolean;
  begin
    Result:=True;
    if key='' then
      Exit;
    key := LowerCase(key);
    str := LowerCase(str);
    if Pos(key, str)>0 then
      Exit;
    Result := False;
  end;
  procedure ShowNoFileTip;
  var
    lv: TListItem;
  begin       
    ListViewFiles.Items.Clear;
    lv := ListViewFiles.Items.Add;
    lv.Caption := srNoFilePrompt;
    lv.ImageIndex:=1;
  end;
var
  sql, ft, sel: String;
  ds: TDataSet;
  lv: TListItem;
begin
  ft := combObjFilter.Text;
  if not Assigned(FCtMetaDatabase) then
  begin
    ShowNoFileTip;
    Exit;
  end;
  if not FCtMetaDatabase.Connected then
  begin
    ShowNoFileTip;
    Exit;
  end;
  if not FCtMetaDatabase.ObjectExists(combDBUser.Text, 'ezdml_meta_file') then
  begin
    ShowNoFileTip;
    Exit;
  end;

  if ListViewFiles.Items.Count = 0 then
  begin
    lv := ListViewFiles.Items.Add;
    lv.Caption := srRefreshingPrompt;    
    lv.ImageIndex:=1;
    Refresh;
  end;

  sel := edtFileName.Text;
  sql := GenDbFileSql('', '', '');
  ds := FCtMetaDatabase.OpenTable(sql, '[ISSQL]');
  ListViewFiles.Items.BeginUpdate;
  try

    ListViewFiles.Items.Clear;
    if ds=nil then
    begin
      ShowNoFileTip;
      Exit;
    end;
    try
      ds.first;
      while not ds.Eof do
      begin
        if not KeyFilterMatch(ft, ds.FieldByName('fileName').AsString+' '+ds.FieldByName('fileMemo').AsString+' '+ds.FieldByName('ModifierName').AsString) then
        begin
          ds.next;
          Continue;
        end;
        lv := ListViewFiles.Items.Add;
        lv.Caption := ds.FieldByName('fileName').AsString;
        lv.SubItems.Add(ds.FieldByName('fileSize').AsString);
        lv.SubItems.Add(ds.FieldByName('modifyDate').AsString);
        lv.SubItems.Add(ds.FieldByName('ModifierName').AsString);
        lv.SubItems.Add(ds.FieldByName('fileMemo').AsString);
        lv.SubItems.Add(ds.FieldByName('fileGuid').AsString);     
        lv.SubItems.Add(ds.FieldByName('fileVersion').AsString);  
        lv.ImageIndex:=0;
        if lv.Caption = sel then
          lv.Selected:=True;
        ds.next;
      end;
    finally
      ds.Free;
    end;
    if ListViewFiles.Items.Count = 0 then
      ShowNoFileTip;
  finally
    ListViewFiles.Items.EndUpdate;
  end;

  if combDBUser.Text <> '' then
    G_LastMetaDbSchema := combDBUser.Text;
end;

function TfrmEzdmlDbFile.GenDbFileSql(sels, where, orderby: string): string;
begin
  if sels='' then
    sels := 'fileGuid, fileName, fileSize, modifyDate, ModifierName, fileMemo, fileVersion';
  if where='' then
  begin
    if FShowHistories then
    begin
      where := 'fileStatus >= 0';
      if FHistoryFileFilter <> '' then
        where := where +' and fileName = '''+FHistoryFileFilter+'''';
    end
    else
      where := 'fileStatus = 0';
  end;
  if orderby='' then
    orderby := 'modifyDate desc';
  Result := 'select '+sels+' from ezdml_meta_file where '+ where+' order by '+orderby;
end;

procedure TfrmEzdmlDbFile.SetIsSaveMode(AValue: boolean);
begin
  if FIsSaveMode=AValue then Exit;
  FIsSaveMode:=AValue;
end;

procedure TfrmEzdmlDbFile.SyncDML;
var
  mds: TCtDataModelGraphList;   
  frm: TfrmCtGenSQL;
begin       
  mds:= TCtDataModelGraphList.Create;
  frm := nil;
  try
    mds.CurDataModel.Tables.LoadFromDMLText(MemoDML.Text);
    frm := TfrmCtGenSQL.Create(Self);
    frm.CtDataModelList := mds;
    frm.SetWorkMode(0);
    if frm.ShowModal = mrOk then
    begin
    end;
  finally
    mds.Free;
    if Assigned(frm) then
      frm.Free;
  end;
end;

procedure TfrmEzdmlDbFile.ToogleHistoryView;
begin
  FShowHistories := not FShowHistories; 
  FHistoryFileFilter := '';
  if FShowHistories then
    if ListViewFiles.Selected <> nil then
      FHistoryFileFilter := ListViewFiles.Selected.Caption;    
  RefreshObjList;
end;

function TfrmEzdmlDbFile.DbFileExists(fn: string): boolean;
var
  Sql: String;  
  ds:TDataSet;
begin
  Result := False;
  Sql := 'select fileGuid from ezdml_meta_file where fileName='''+fn+''' and fileStatus = 0';   
  ds := FCtMetaDatabase.OpenTable(sql, '');
  if (ds<>nil) then
  begin
    if not ds.Eof then
      Result := True;
    ds.Free;
  end;
end;

function TfrmEzdmlDbFile.PrepareToLoadFile(fn: string): boolean;
var
  ptr, eng, usr, db, doc, fid, sch, sql: string;
  po: Integer;
  ds:TDataSet;     
  cr: TCursor;
begin
  Result := False;

  if not ParseDbFileName(fn, ptr, eng, usr, db, doc, fid) then
    Exit;
            
  if not Assigned(FCtMetaDatabase) then
    btnDBLogonClick(nil);

  if FCtMetaDatabase=nil then
    Exit;

  po := Pos('/', doc);
  if po>0 then
  begin
    sch := Copy(doc, 1, po-1);
    doc := Copy(doc, po+1, Length(doc));

    if sch <>'' then
    begin
      combDBUser.Text := sch;
      FCtMetaDatabase.DbSchema:= sch;
    end;
  end;

  edtFileName.Text:=doc;

  if fid <> '' then
    sql := GenDbFileSql('fileGuid', 'fileName='''+doc+''' and fileGuid='''+fid+'''', '')
  else
    sql := GenDbFileSql('fileGuid', 'fileName='''+doc+''' and fileStatus=0', '');

  cr := Screen.Cursor;
  Screen.Cursor := crAppStart;
  try
    ds := FCtMetaDatabase.OpenTable(sql, '');
    if ds<>nil then
    try
      ds.first;
      while not ds.Eof do
      begin
        FResultFileID := ds.Fields[0].AsString;
        FResultFileName := fn;
        Result := True;
        Break;
      end;
    finally
      ds.Free;
    end; 
  finally
    Screen.Cursor := cr;
  end;
end;

function TfrmEzdmlDbFile.CheckDbFileState(fn: string; var fileSize: Integer; var fileDate: TDateTime; bForce: Boolean): Integer;
var
  S, dbid, ptr, eng, usr, db, doc, fid, sch, sql: string;
  ds:TDataSet;
  idx, po: Integer;
begin        
  //检查数据库文件状态
  //返回：0未连接 1连接失败 2不存在 3存在
  Result := 0;
                    
  dbid := ExtractFileDbIdentStr(fn);
  idx := GetLastCtDbConn(False);
  if idx < 0 then
    Exit;
  if (dbid <> GetLastCtDbIdentStr) or not CtMetaDBRegs[idx].DbImpl.Connected then
  begin
    if not bForce then
      Exit;

    try
      btnDBLogonClick(nil);
    except
      on E: Exception do
      begin
        Application.HandleException(Self);
      end;
    end;
    if not Assigned(FCtMetaDatabase) or not FCtMetaDatabase.Connected then
    begin
      Result := 1;
      Exit;
    end;
  end;
  if not Assigned(FCtMetaDatabase) or not FCtMetaDatabase.Connected then
  begin
    Exit;
  end;
       
  if dbid <> GetLastCtDbIdentStr then
    Exit;

  Result := 2;

    
  if not ParseDbFileName(fn, ptr, eng, usr, db, doc, fid) then
    Exit;

  po := Pos('/', doc);
  if po>0 then
  begin
    sch := Copy(doc, 1, po-1);
    doc := Copy(doc, po+1, Length(doc));

    if sch <>'' then
    begin
      if FCtMetaDatabase.DbSchema <> sch then
        FCtMetaDatabase.DbSchema:= sch;
    end;
  end;

  if fid <> '' then
    sql := GenDbFileSql('fileSize, modifyDate', 'fileName='''+doc+''' and fileGuid='''+fid+'''', '')
  else
    sql := GenDbFileSql('fileSize, modifyDate', 'fileName='''+doc+''' and fileStatus=0', '');
  try
    ds := FCtMetaDatabase.OpenTable(sql, '');
  except
    Result := 1;
    Exit;
  end;
  if ds<>nil then
  try
    ds.first;
    if not ds.Eof then
    begin
      fileSize := ds.FieldByName('fileSize').AsInteger;
      fileDate := ds.FieldByName('modifyDate').AsDateTime;
      Result := 3;
    end;
  finally
    ds.Free;
  end;
end;

function TfrmEzdmlDbFile.GetDbFileModifierInfo(fn: string; var modifier,
  fileMemo: string): boolean;
var
  S, ptr, eng, usr, db, doc, fid, sch, sql: string;
  ds:TDataSet;
  idx, po: Integer;
begin
  //检查数据库文件状态
  //返回：0未连接 1连接失败 2不存在 3存在
  Result := False;

  if not Assigned(FCtMetaDatabase) or not FCtMetaDatabase.Connected then
  begin
    Exit;
  end;

  S := ExtractFileDbIdentStr(fn);
  if S <> GetLastCtDbIdentStr then
    Exit;


  if not ParseDbFileName(fn, ptr, eng, usr, db, doc, fid) then
    Exit;

  po := Pos('/', doc);
  if po>0 then
  begin
    sch := Copy(doc, 1, po-1);
    doc := Copy(doc, po+1, Length(doc));

    if sch <>'' then
    begin
      if FCtMetaDatabase.DbSchema <> sch then
        FCtMetaDatabase.DbSchema:= sch;
    end;
  end;
                              
  if fid <> '' then                                   
    sql := GenDbFileSql('modifierName, fileMemo', 'fileName='''+doc+''' and fileGuid='''+fid+'''', '')
  else
    sql := GenDbFileSql('modifierName, fileMemo', 'fileName='''+doc+''' and fileStatus=0', '');
  ds := FCtMetaDatabase.OpenTable(sql, '');
  if ds<>nil then
  try
    ds.first;
    if not ds.Eof then
    begin
      modifier := ds.FieldByName('modifierName').AsString;
      fileMemo := ds.FieldByName('fileMemo').AsString;
      Result := True;
    end;
  finally
    ds.Free;
  end;
end;


procedure TfrmEzdmlDbFile.LoadFromDbFile(AData: TStream;
  AFileId: string);    
var
  sql, buf: String;
  ds:TDataSet;
  fd: TField;
  L: Integer;
begin
  if AFileId='' then
    raise Exception.Create('FileId not assigned');

  Sql := 'select fileBlob from ezdml_meta_file where fileGuid='''+AFileId+'''';
  ds := FCtMetaDatabase.OpenTable(sql, '');
  if (ds<>nil) and not ds.Eof then
  begin
    fd := ds.FieldByName('fileBlob');
    if fd.IsBlob then
    begin
      TBlobField(fd).SaveToStream(AData);
    end
    else
    begin
      buf := fd.AsString;
      L := Length(buf);
      if L > 0 then
      begin
        AData.Write(PChar(buf)^, L);
      end;
    end;
  end;
end;

function TfrmEzdmlDbFile.SaveDataToDbFile(AData: TStream; AFileName: string;
  bPromptMemo: Boolean): Boolean;
var
  sql, hisId, fid,creatorName,modifierName,fileHash,oldHash, uSql: String;
  createDate: TDateTime;
  po,L, fileVersion:Integer;
  ds:TDataSet;
  sch, AMemo, buf: String;
  fd: TField;
begin
  Result := False;

  po := Pos('/', AFileName);
  if po>0 then
  begin
    sch := Copy(AFileName, 1, po-1);
    AFileName := Copy(AFileName, po+1, Length(AFileName));

    if sch <>'' then
    begin
      FCtMetaDatabase.DbSchema:= sch;
    end;
  end;
  //旧文件改成历史记录  
  sql := GenDbFileSql('fileGuid,historyGuid,createDate,creatorName,fileHash,fileVersion', 'fileName='''+AFileName+''' and fileStatus=0', '');
  hisId:='';
  fileVersion:=0;
  createDate:=Now;
  creatorName:='';
  oldHash:='';
  modifierName:=GetThisComputerName;

  L:=AData.Size;
  SetLength(buf, L);
  AData.Seek(0, soFromBeginning);
  AData.Read(PChar(buf)^,L);
  fileHash := LowerCase(MD5Print(MD5String(buf)));


  ds := FCtMetaDatabase.OpenTable(sql, '');
  if ds<>nil then
  try
    ds.first;
    while not ds.Eof do
    begin
      fid := ds.FieldByName('fileGuid').AsString;
      if hisId='' then
        hisId := ds.FieldByName('historyGuid').AsString;
      oldHash := ds.FieldByName('fileHash').AsString;
      if oldHash <> '' then
        if fileHash=oldHash then
        begin
          if Application.MessageBox(PChar(Format(srOverwriteSameDbFileWarning,[AFileName, fid])),
            PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
            Exit;
        end;
      fileVersion := ds.FieldByName('fileVersion').AsInteger;
      if ds.FieldByName('createDate').AsDateTime > 0 then
        createDate := ds.FieldByName('createDate').AsDateTime;
      creatorName := ds.FieldByName('creatorName').AsString;
      uSql := 'update ezdml_meta_file set fileStatus=1 where fileGuid='''+fid+'''';
      FCtMetaDatabase.ExecSql(uSql);
      ds.next;
    end;
  finally
    ds.Free;
  end;
        
  AMemo:='';
  if bPromptMemo then
  begin
    AMemo := 'by '+modifierName+' '+DateTimeToStr(Now);
    if not PvtInput.PvtInputQuery(Self.Caption, srDbFileComment, AMemo) then
      Exit;
  end;

  //生成新记录
  fid := LowerCase(CtGenGUID);
  if hisId='' then
    hisId:=fid;
  if fileVersion < 0 then
    fileVersion := 0;
  Inc(fileVersion);
  if creatorName='' then
    creatorName := modifierName;

  sql := GenDbFileSql('*', 'fileName='''+AFileName+''' and fileStatus=0', '');
  ds := FCtMetaDatabase.OpenTable(sql, '');
  if ds<>nil then
  try
    ds.Append;
    ds.FieldByName('fileGuid').AsString := fid;
    ds.FieldByName('historyGuid').AsString := hisId;
    ds.FieldByName('fileName').AsString := AFileName;
    ds.FieldByName('fileHash').AsString := fileHash;
    ds.FieldByName('fileMemo').AsString := AMemo;
    ds.FieldByName('createDate').AsDateTime := createDate;
    ds.FieldByName('creatorName').AsString := creatorName;
    ds.FieldByName('modifyDate').AsDateTime := Now;
    ds.FieldByName('modifierName').AsString := modifierName;
    ds.FieldByName('fileStatus').AsInteger := 0;
    ds.FieldByName('fileVersion').AsInteger := fileVersion;

    ds.FieldByName('fileSize').AsInteger := L;
    fd := ds.FieldByName('fileBlob');
    if fd.IsBlob then
    begin              
      AData.Seek(0, soFromBeginning);
      TBlobField(fd).LoadFromStream(AData);
    end
    else
    begin
      fd.AsString:=buf;
    end;

    ds.Post;
  finally
    ds.Free;
  end;                  
  FCtMetaDatabase.ExecCmd('commit','','');
  Result:=True;
end;


procedure TfrmEzdmlDbFile.TimerInitTimer(Sender: TObject); 
var
  I: integer;
begin
  TimerInit.Enabled := False;
  if not Assigned(FCtMetaDatabase) then
  begin
    I := GetLastCtDbConn(True);
    if I >= 0 then
    begin
      FLinkDbNo := I;
      RefreshDbInfo;
    end
    else
    begin
      //if CanAutoShowLogin then
      btnDBLogonClick(nil);
    end;
  end
  else if FShowHistories or (ListViewFiles.Items.Count = 0) then
  begin
    FShowHistories := False;
    RefreshObjList;
  end
  else
  begin
    RefreshObjList;
  end;
end;


procedure TfrmEzdmlDbFile.ListViewFilesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Assigned(Item) then
    if Item.SubItems.Count > 0 then
      edtFileName.Text := Item.Caption;
end;

procedure TfrmEzdmlDbFile.ListViewFilesDblClick(Sender: TObject);
begin      
  if Assigned(ListViewFiles.Selected) then
    btnOKClick(nil);
end;

procedure TfrmEzdmlDbFile.MN_DeleteClick(Sender: TObject);
var
  uSql, fid, fn: String;
begin
  if ListViewFiles.Selected = nil then
    Exit;
  if ListViewFiles.Selected.SubItems.Count = 0 then
    Exit;
  fn := ListViewFiles.Selected.Caption; 
  if Application.MessageBox(PChar(Format(srConfirmDeleteDbFileFmt, [fn])),
    PChar(MN_Delete.Caption), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
    Exit;
  fid := ListViewFiles.Selected.SubItems[4];
  uSql := 'update ezdml_meta_file set fileStatus=-1 where fileGuid='''+fid+'''';
  FCtMetaDatabase.ExecSql(uSql);
  FCtMetaDatabase.ExecCmd('commit','','');
  RefreshObjList;
end;

procedure TfrmEzdmlDbFile.MN_InfoClick(Sender: TObject);
  function addFi(str, key, val: string): string;
  begin
    Result := str;
    if val='' then
      Exit;
    Result := Result + key +': '+ val + #13#10;
  end;
var
  uSql, fid, S: String;
  ds: TDataSet;
begin
  if ListViewFiles.Selected = nil then
    Exit;
  if ListViewFiles.Selected.SubItems.Count = 0 then
    Exit;
  fid := ListViewFiles.Selected.SubItems[4];

  uSql := GenDbFileSql('fileGuid,historyGuid,fileName,fileHash,fileSize,fileMemo,createDate,creatorName,modifyDate,modifierName,deleteDate,deleterName,fileStatus,fileVersion', 'fileGuid='''+fid+'''', '');
  ds := FCtMetaDatabase.OpenTable(uSql, '');
  if ds = nil then
    Exit;
  try
    if ds.Eof then
      Exit;
    S := '';
    S := addFi(S, '唯一标识', ds.FieldByName('fileGuid').AsString);
    S := addFi(S, '历史文件标识', ds.FieldByName('historyGuid').AsString);
    S := addFi(S, '文件名', ds.FieldByName('fileName').AsString);
    S := addFi(S, '文件哈希值', ds.FieldByName('fileHash').AsString);
    S := addFi(S, '文件大小', ds.FieldByName('fileSize').AsString);
    S := addFi(S, '文件备注', ds.FieldByName('fileMemo').AsString);
    S := addFi(S, '创建时间', ds.FieldByName('createDate').AsString);
    S := addFi(S, '创建人', ds.FieldByName('creatorName').AsString);
    S := addFi(S, '修改时间', ds.FieldByName('modifyDate').AsString);
    S := addFi(S, '修改人', ds.FieldByName('modifierName').AsString);
    S := addFi(S, '删除时间', ds.FieldByName('deleteDate').AsString);
    S := addFi(S, '删除人', ds.FieldByName('deleterName').AsString);
    S := addFi(S, '文件状态', ds.FieldByName('fileStatus').AsString);
    S := addFi(S, '文件版本号', ds.FieldByName('fileVersion').AsString);
  finally
    ds.Free;
  end;
  PvtInput.PvtMemoQuery(Application.Title, MN_Info.Caption, S, True);
end;

procedure TfrmEzdmlDbFile.Mn_MemoClick(Sender: TObject);
var
  sql, fid, fn, memo: String;
  ds: TDataSet;
begin
  if ListViewFiles.Selected = nil then
    Exit;
  if ListViewFiles.Selected.SubItems.Count = 0 then
    Exit;
  fn := ListViewFiles.Selected.Caption;
  memo := ListViewFiles.Selected.SubItems[3];
  if not PvtInput.PvtInputQuery(Mn_Memo.Caption+' - '+fn, srDbFileComment, memo) then
    Exit;
  if memo = ListViewFiles.Selected.SubItems[3] then
    Exit;
  fid := ListViewFiles.Selected.SubItems[4];

  sql := GenDbFileSql('fileGuid, modifierName, modifyDate, fileMemo', 'fileGuid='''+fid+'''', '');
  ds := FCtMetaDatabase.OpenTable(sql, '');
  if ds<>nil then
  try
    if not ds.Eof then
    begin
      ds.Edit;
      ds.FieldByName('modifierName').AsString := GetThisComputerName;    
      ds.FieldByName('modifyDate').AsDateTime := Now;
      ds.FieldByName('fileMemo').AsString := memo;
      ds.Post;
    end;
  finally
    ds.Free;
  end;

  FCtMetaDatabase.ExecCmd('commit','','');
  RefreshObjList;
  if Assigned(Proc_OnDbFileMemoChanged) then
  begin
    fn := edtFileName.Text;
    if Assigned(FCtMetaDatabase) and (combDBUser.Text <> '') then
      if UpperCase(Trim(FCtMetaDatabase.User)) <> UpperCase(Trim(combDBUser.Text)) then
        fn := combDBUser.Text + '/' + fn;
    fn := 'db://'+GetLastCtDbIdentStr+'/'+fn;
    Proc_OnDbFileMemoChanged(Self, fn);
  end;
end;

procedure TfrmEzdmlDbFile.MN_RefreshClick(Sender: TObject);
begin
  RefreshObjList;
end;

procedure TfrmEzdmlDbFile.MN_RenameClick(Sender: TObject);
var
  uSql, fid, fn: String;
begin
  if ListViewFiles.Selected = nil then
    Exit;      
  if ListViewFiles.Selected.SubItems.Count = 0 then
    Exit;
  fn := ListViewFiles.Selected.Caption;
  if not PvtInput.PvtInputQuery(MN_Rename.Caption, srDbFileRenamePrompt, fn) then
    Exit;           
  if fn = ListViewFiles.Selected.Caption then
    Exit;
  if IsSymbolName(fn) then
    Exit;
  fid := ListViewFiles.Selected.SubItems[4];
  uSql := 'update ezdml_meta_file set fileName='''+fn+''' where fileGuid='''+fid+'''';
  FCtMetaDatabase.ExecSql(uSql);
  FCtMetaDatabase.ExecCmd('commit','',''); 
  RefreshObjList;
end;

procedure TfrmEzdmlDbFile.MN_ShowHistClick(Sender: TObject);
begin
  ToogleHistoryView;
end;

procedure TfrmEzdmlDbFile.PopupMenuFilesPopup(Sender: TObject);
begin
  MN_ShowHist.Checked := FShowHistories;
end;

procedure TfrmEzdmlDbFile.TimerFilterTimer(Sender: TObject);
begin
  TimerFilter.Enabled :=False;
  RefreshObjList;
end;

procedure TfrmEzdmlDbFile.combDBUserChange(Sender: TObject);
begin
  RefreshObjList;
  FLastAutoSelDBUser := '';
end;


procedure TfrmEzdmlDbFile.btnOKClick(Sender: TObject);
begin
  edtFileName.Text := Trim(edtFileName.Text);
  if edtFileName.Text='' then
    Exit;
  if IsSymbolName(edtFileName.Text) then
    Exit;
  if IsSaveMode then
  begin
    if not Assigned(FCtMetaDatabase) then
      Exit;
    if not FCtMetaDatabase.Connected then
      Exit;
    if not FCtMetaDatabase.ObjectExists(combDBUser.Text, 'ezdml_meta_file') then
    begin         
      if Application.MessageBox(PChar(srCreateDbFileSystemPrompt),
        PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
        Exit;
      SyncDML;
      Exit;
    end;
    if DbFileExists(edtFileName.Text) then
      if Application.MessageBox(PChar(Format(srOverwriteDbFileWarning,[edtFileName.Text])),
        PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
        Exit;
  end
  else
  begin
    if ListViewFiles.Selected = nil then
      Exit;
    if ListViewFiles.Selected.Caption <> edtFileName.Text then
      Exit;
    FResultFileID := ListViewFiles.Selected.SubItems[4];
    if FResultFileID = '' then
      Exit;
  end;
  FResultFileName := edtFileName.Text;  
  if Assigned(FCtMetaDatabase) and (combDBUser.Text <> '') then
    if UpperCase(Trim(FCtMetaDatabase.User)) <> UpperCase(Trim(combDBUser.Text)) then
      FResultFileName := combDBUser.Text + '/' + FResultFileName;  
  if not IsSaveMode then
    if FShowHistories then
      FResultFileName := FResultFileName + '#' + FResultFileID;
  ModalResult := mrOk;
end;


procedure TfrmEzdmlDbFile.FormShow(Sender: TObject);
begin
  TimerInit.Enabled := True;
end;

procedure TfrmEzdmlDbFile.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEzdmlDbFile.FormDestroy(Sender: TObject);
begin
end;

procedure TfrmEzdmlDbFile.combObjFilterChange(Sender: TObject);
begin
  TimerFilter.Enabled := False;
  TimerFilter.Enabled := True;
end;

end.

