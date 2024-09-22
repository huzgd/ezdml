{
  SQL脚本编辑窗口
  Create by Huz(huz0123@21cn.com) 2004/02/02
  Changed: 2005/04
  http://www.nnxxtt.com


  注：此单元为旧版代码，不再维护
}

unit uDmlSqlEditorO;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ActnList, StdActns, DB, DBCtrls,
  Grids, DBGrids, Menus, ComCtrls, CtMetaTable;

type

  { TfrmDmlSqlEditorO }

  TfrmDmlSqlEditorO = class(TForm)
    actCopyCol: TAction;
    combDbUsers: TComboBox;
    ListBoxTbs: TListBox;
    MemoFieldContent: TDBMemo;
    MenuItem1: TMenuItem;
    MenuItemDbConn: TMenuItem;
    MenuItemDedicatedConn: TMenuItem;
    MN_CopyTbName: TMenuItem;
    MN_QueryTableData: TMenuItem;
    MN_ShowTableProps: TMenuItem;
    MN_TbsRefresh: TMenuItem;
    PanelSql: TPanel;
    PanelRes: TPanel;
    Bevel3: TBevel;
    PanelTbs: TPanel;
    PopupMenuDbConn: TPopupMenu;
    PopupMenuTbs: TPopupMenu;
    sbtnToggleTbList: TSpeedButton;
    Splitter1: TSplitter;
    ActionList1: TActionList;
    actEditSelall: TAction;
    DataSourceRes: TDataSource;
    DBGridRes: TDBGrid;
    Label1: TLabel;
    actExec: TAction;
    Bevel1: TBevel;
    Panel1: TPanel;
    Panel2: TPanel;
    LabelSql: TLabel;
    PopupMenuOldSql: TPopupMenu;
    sbtnSqlPrev: TSpeedButton;
    sbtnSqlNext: TSpeedButton;
    actCopyRec: TAction;
    PopupMenuGrid: TPopupMenu;
    N5: TMenuItem;
    actCopyAll: TAction;
    N1: TMenuItem;
    actRollback: TAction;
    sbtnRun: TSpeedButton;
    sbtnClearAll: TSpeedButton;
    actCommit: TAction;
    SplitterFV: TSplitter;
    SplitterTbs: TSplitter;
    TimerInit: TTimer;
    sbtnConnectDb: TSpeedButton;
    lbStatus: TLabel;
    procedure actCopyColExecute(Sender: TObject);
    procedure combDbUsersChange(Sender: TObject);
    procedure DBGridResCellClick(Column: TColumn);
    procedure DBGridResColEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxTbsDblClick(Sender: TObject);
    procedure MenuItemDbConnClick(Sender: TObject);
    procedure MenuItemDedicatedConnClick(Sender: TObject);
    procedure MN_CopyTbNameClick(Sender: TObject);
    procedure MN_QueryTableDataClick(Sender: TObject);
    procedure MN_ShowTablePropsClick(Sender: TObject);
    procedure MN_TbsRefreshClick(Sender: TObject);
    procedure sbtnToggleTbListClick(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure actEditSelallExecute(Sender: TObject);
    procedure actExecExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PopupMenuOldSqlPopup(Sender: TObject);
    procedure sbtnSqlPrevClick(Sender: TObject);
    procedure sbtnSqlNextClick(Sender: TObject);
    procedure LabelSqlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure actCopyRecExecute(Sender: TObject);
    procedure DBGridResMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure actCopyAllExecute(Sender: TObject);
    procedure PopupMenuGridPopup(Sender: TObject);
    procedure sbtnClearAllClick(Sender: TObject);
    procedure actExecUpdate(Sender: TObject);
    procedure TimerInitTimer(Sender: TObject);
    procedure sbtnConnectDbClick(Sender: TObject);
  private
    FAfterExec: TNotifyEvent;
    FBeforeExec: TNotifyEvent;
    { Private declarations }
    FSplitPercent: double;
    FNeedSaveIni: boolean;
    FOldSqlList: TStrings;
    FRecCount: integer;
    FHisIndex: integer;
    FSaveCurSql: string;
    FReadOnlyMode: boolean;
    FExecSqlModified: boolean;
    FOptionsStr: string;
    FLastTbListDBInfo: string;

    procedure CheckLoadOldSql;
    procedure DoExecute;

    procedure CreateSqlMenus(MMenuItem: TMenuItem);
    procedure MItem_SqlClick(Sender: TObject);
    procedure SetHistorySql(Index: integer);

    procedure LoadIniFile;
    procedure SaveIniFile;
    procedure SetReadOnlyMode(const Value: boolean);
    procedure SetSplitPercent(const Value: double);
    procedure RefreshTbList(bForce, bCheckMode: boolean);
    procedure DoDbTableAction(act: string);
  public
    { Public declarations }
    FCtMetaDatabase: TCtMetaDatabase; 
    FCloneMetaDb: TCtMetaDatabase;
    ResultDataSet: TDataSet;
    MemoSql: TMemo;
    AutoExecSql: string;
    Proc_CheckSpecValue:
    function(const Value: string): string of object;
    procedure ClearSql;

    property ReadOnlyMode: boolean read FReadOnlyMode write SetReadOnlyMode;
    property OptionsStr: string read FOptionsStr write FOptionsStr;
    property SplitPercent: double read FSplitPercent write SetSplitPercent;
    property BeforeExec: TNotifyEvent read FBeforeExec write FBeforeExec;
    property AfterExec: TNotifyEvent read FAfterExec write FAfterExec;
  end;

function SReplaceCRX(const st: string): string;
function SReplaceCR(const st: string): string;

var
  FDmlSqlEditorForm: TfrmDmlSqlEditorO;

implementation

uses
  dmlstrs, WindowFuncs, IniFiles, ClipBrd, uFormCtDbLogon;

{$R *.lfm}

function SReplaceCR(const st: string): string;
begin
  Result := StringReplace(st, '#13', #13, [rfReplaceAll]);
  Result := StringReplace(Result, '#10', #10, [rfReplaceAll]);
end;

function SReplaceCRX(const st: string): string;
begin
  Result := StringReplace(st, #13, '#13', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '#10', [rfReplaceAll]);
end;

{ TfrmCTDebugSql }

procedure TfrmDmlSqlEditorO.FormCreate(Sender: TObject);
begin
  MemoSql := TMemo.Create(Self);
  MemoSql.Align := alClient;
  MemoSql.Parent := Panel1;
  MemoSql.ScrollBars := ssBoth;


  FSplitPercent := PanelRes.Height / Height * 100;
end;

procedure TfrmDmlSqlEditorO.DBGridResCellClick(Column: TColumn);
begin
  if DBGridRes.SelectedField = nil then
    Exit;
  MemoFieldContent.DataField := DBGridRes.SelectedField.FieldName;
  if not MemoFieldContent.Visible then
  begin
    MemoFieldContent.Show;
    SplitterFV.Left := MemoFieldContent.Left - 4;
    SplitterFV.Show;
  end;
end;

procedure TfrmDmlSqlEditorO.combDbUsersChange(Sender: TObject);
begin
  RefreshTbList(False, False);
end;

procedure TfrmDmlSqlEditorO.actCopyColExecute(Sender: TObject);
var
  S, V, Ts: string;
  I: integer;
  fd: TField;
begin
  fd := DBGridRes.SelectedField;
  if fd = nil then
    Exit;
  if ResultDataSet <> nil then
    if ResultDataSet.Active then
      with ResultDataSet do
      begin
        Ts := '';

        First;
        while not EOF do
        begin
          S := fd.AsString;
          if Ts <> '' then
            Ts := Ts + #13#10;
          Ts := Ts + S;
          Next;
        end;
        if Ts <> '' then
          Clipboard.AsText := Ts;
      end;
end;

procedure TfrmDmlSqlEditorO.DBGridResColEnter(Sender: TObject);
begin
  DBGridResCellClick(nil);
end;

procedure TfrmDmlSqlEditorO.FormResize(Sender: TObject);
begin
  if PanelRes.Visible and (FSplitPercent <> 0) then
    PanelRes.Height := Round(FSplitPercent * Height / 100);
  DBGridRes.Realign;
end;

procedure TfrmDmlSqlEditorO.FormShow(Sender: TObject);
begin
  CtSetFixWidthFont(MemoSql);
end;

procedure TfrmDmlSqlEditorO.ListBoxTbsDblClick(Sender: TObject);
begin
  DoDbTableAction('show_props');
end;

procedure TfrmDmlSqlEditorO.MenuItemDbConnClick(Sender: TObject);
var
  I: integer;
begin
  I := GetLastCtDbConn;
  if (Sender <> nil) or (I < 0) then
    I := ExecCtDbLogon;
  if I >= 0 then
  begin                                      
    if Assigned(FCloneMetaDb) then
      FreeAndNil(FCloneMetaDb);
    FCtMetaDatabase := CtMetaDBRegs[I].DbImpl;
    lbStatus.Caption := 'Connected to [' + FCtMetaDatabase.EngineType +
      ']' + FCtMetaDatabase.Database;
    if PanelTbs.Visible then
      RefreshTbList(False, True)
    else if PanelTbs.Tag = 1 then
    begin
      PanelTbs.Tag := 0;
      sbtnToggleTbListClick(nil);
    end;
  end;     
  sbtnConnectDb.Caption := MenuItemDbConn.Caption;
end;

procedure TfrmDmlSqlEditorO.MenuItemDedicatedConnClick(Sender: TObject);
var
  db: TCtMetaDatabase;
begin
  db := ExecDedicatedDbLogon(Self, FCloneMetaDb);
  if db = nil then
    Exit;

  if Assigned(FCloneMetaDb) then
    FreeAndNil(FCloneMetaDb);
  FCloneMetaDb := db;
  FCtMetaDatabase := db;
  lbStatus.Caption := 'Connected to [' + FCtMetaDatabase.EngineType +
    ']' + FCtMetaDatabase.Database;
  if PanelTbs.Visible then
    RefreshTbList(False, True)
  else if PanelTbs.Tag = 1 then
  begin
    PanelTbs.Tag := 0;
    sbtnToggleTbListClick(nil);
  end;        
  sbtnConnectDb.Caption := MenuItemDedicatedConn.Caption;
end;


procedure TfrmDmlSqlEditorO.MN_CopyTbNameClick(Sender: TObject);
begin
  if ListBoxTbs.ItemIndex < 0 then
    Exit;
  ClipBoard.AsText := ListBoxTbs.Items[ListBoxTbs.ItemIndex];
end;

procedure TfrmDmlSqlEditorO.MN_QueryTableDataClick(Sender: TObject);
begin
  DoDbTableAction('get_select_sql');
end;

procedure TfrmDmlSqlEditorO.MN_ShowTablePropsClick(Sender: TObject);
begin
  DoDbTableAction('show_props');
end;

procedure TfrmDmlSqlEditorO.MN_TbsRefreshClick(Sender: TObject);
begin
  RefreshTbList(True, False);
end;

procedure TfrmDmlSqlEditorO.sbtnToggleTbListClick(Sender: TObject);
begin
  if PanelTbs.Visible then
  begin
    Self.SplitterTbs.Visible := False;
    PanelTbs.Visible := False;
  end
  else
  begin
    PanelTbs.Visible := True;
    SplitterTbs.Left := PanelTbs.Left - SplitterTbs.Width;
    SplitterTbs.Visible := True;
    RefreshTbList(True, False);
  end;
end;

procedure TfrmDmlSqlEditorO.Splitter1Moved(Sender: TObject);
begin
  FSplitPercent := PanelRes.Height / Height * 100;
end;

procedure TfrmDmlSqlEditorO.TimerInitTimer(Sender: TObject);
begin
  TimerInit.Enabled := False;
  if not Assigned(FCtMetaDatabase) then
  begin
    if CanAutoShowLogin then
      sbtnConnectDbClick(nil);
    if Assigned(FCtMetaDatabase) and FCtMetaDatabase.Connected then
      if AutoExecSql <> '' then
      begin
        MemoSql.Lines.Text := AutoExecSql;
        actExec.Execute;
      end;
  end;
end;

procedure TfrmDmlSqlEditorO.actEditSelallExecute(Sender: TObject);
begin
  if ActiveControl is TCustomEdit then
    (ActiveControl as TCustomEdit).SelectAll
  else if ActiveControl is TComboBox then
    (ActiveControl as TComboBox).SelectAll;
end;

procedure TfrmDmlSqlEditorO.actExecExecute(Sender: TObject);
begin
  DoExecute;
end;

procedure TfrmDmlSqlEditorO.DoExecute;
var
  I, ra: integer;
  Tm: int64;
  cr: TCursor;
  S, vT: string;
  bSel: boolean;
begin       
  if Assigned(FBeforeExec) then
    FBeforeExec(Self);

  if (FCtMetaDatabase = nil) or not FCtMetaDatabase.Connected then
    sbtnConnectDbClick(nil);
  if (FCtMetaDatabase = nil) or not FCtMetaDatabase.Connected then
    Exit;
  CheckLoadOldSql;

  SplitterFV.Visible := False;
  MemoFieldContent.DataField := '';

  S := MemoSql.SelText;
  bSel := Length(Trim(S)) >= 2;
  if not bSel then
    S := MemoSql.Lines.Text;
  //检测分号
  vT := SReplaceCRX(S);
  I := FOldSqlList.IndexOf(vT);
  if I = -1 then
  begin
    if (AutoExecSql = '') or (MemoSql.Lines.Text <> AutoExecSql) then
      FOldSqlList.Insert(0, vT);
  end
  else
  begin
    FOldSqlList.Move(I, 0);
  end;
  FNeedSaveIni := True;
  FExecSqlModified := False;

  DataSourceRes.DataSet := nil;
  if ResultDataSet <> nil then
  begin
    ResultDataSet.Close;
    FreeAndNil(ResultDataSet);
  end;
  //ResultDataSet.SQL.Text := S;

  //执行查询
  FRecCount := -1;
  lbStatus.Caption := srSqlEditorRunning;
  Panel2.Refresh;
  cr := Screen.Cursor;
  try
    Screen.Cursor := crAppStart;

    Tm := GetTickCount64;
    try
      ResultDataSet := FCtMetaDatabase.OpenTable(S, '[ISSQL]');
      if ResultDataSet <> nil then
      begin
        DataSourceRes.DataSet := ResultDataSet;
        with DataSourceRes.DataSet.Fields do
          for I := 0 to Count - 1 do
            if Fields[I].DisplayWidth > 18 then
              Fields[I].DisplayWidth := 18;
      end;
    except
      on e: Exception do
      begin
        lbStatus.Caption := srSqlEditorRunError + e.Message;
        Application.MessageBox(PChar(srSqlEditorRunError + e.Message),
          PChar(Application.Title), MB_OK or MB_ICONERROR);
        Exit;
      end;
    end;


    Tm := int64(GetTickCount64) - Tm;                       
    ra := StrToIntDef(FCtMetaDatabase.ExecCmd('row_affected','',''),0);
    lbStatus.Caption := Format(srSqlEditorRunFinishedFmt, [Tm / 1000, ra]);
            
    if Assigned(FAfterExec) then
      FAfterExec(Self);
  finally
    Screen.Cursor := cr;
  end;
end;

procedure TfrmDmlSqlEditorO.FormDestroy(Sender: TObject);
begin
  try
    SaveIniFile;
  except
  end;
  if FDmlSqlEditorForm = Self then
    FDmlSqlEditorForm := nil;

  if Assigned(FOldSqlList) then
    FreeAndNil(FOldSqlList);   
  if Assigned(FCloneMetaDb) then
    FreeAndNil(FCloneMetaDb);
end;

procedure TfrmDmlSqlEditorO.ClearSql;
begin
  if ResultDataSet <> nil then
    if ResultDataSet.Active then
      ResultDataSet.Close;
  MemoSql.Clear;
  AutoExecSql := '';
  FHisIndex := -1;
end;

procedure TfrmDmlSqlEditorO.PopupMenuOldSqlPopup(Sender: TObject);
begin
  CreateSqlMenus(PopupMenuOldSql.Items);
end;

procedure TfrmDmlSqlEditorO.CreateSqlMenus(MMenuItem: TMenuItem);
var
  I, L: integer;
  MItem: TMenuItem;
begin
  if not Assigned(MMenuItem) then
    Exit;
  with MMenuItem do
  begin
    Clear;
    CheckLoadOldSql;
    if not Assigned(FOldSqlList) then
      Exit;

    for I := 0 to FOldSqlList.Count - 1 do
    begin
      L := Length(FOldSqlList.Strings[I]);
      if L = 0 then
        Continue;
      MItem := TMenuItem.Create(PopupMenuOldSql);
      if L <= 64 then
        MItem.Caption := FOldSqlList.Strings[I]
      else
        MItem.Caption := Copy(FOldSqlList.Strings[I], 1, 64) + '...';
      MItem.Tag := I;
      MItem.OnClick := MItem_SqlClick;
      Add(MItem);
    end;
  end;
end;

procedure TfrmDmlSqlEditorO.MItem_SqlClick(Sender: TObject);
var
  MItem: TMenuItem;
begin
  if not Assigned(FOldSqlList) then
    Exit;
  if Sender is TMenuItem then
  begin
    MItem := TMenuItem(Sender);
    if (MItem.Tag >= 0) and (MItem.Tag < FOldSqlList.Count) then
      SetHistorySql(MItem.Tag);
  end;
end;

procedure TfrmDmlSqlEditorO.SetHistorySql(Index: integer);
begin
  CheckLoadOldSql;
  if not Assigned(FOldSqlList) then
    Exit;
  if (FHisIndex = -1) and FExecSqlModified then
  begin
    FSaveCurSql := MemoSql.Lines.Text;
  end;
  if (Index >= 0) and (Index < FOldSqlList.Count) then
  begin
    MemoSql.Lines.Text := SReplaceCR(FOldSqlList.Strings[Index]);
    FExecSqlModified := False;
    FHisIndex := Index;
  end
  else
  begin
    MemoSql.Lines.Text := FSaveCurSql;
    FExecSqlModified := False;
    FHisIndex := -1;
  end;
end;

procedure TfrmDmlSqlEditorO.sbtnSqlPrevClick(Sender: TObject);
begin
  CheckLoadOldSql;
  if (FHisIndex = -1) or not Assigned(FOldSqlList) then
    SetHistorySql(0)
  else if FHisIndex < FOldSqlList.Count - 1 then
    SetHistorySql(FHisIndex + 1);
end;

procedure TfrmDmlSqlEditorO.sbtnSqlNextClick(Sender: TObject);
begin
  if FHisIndex <> -1 then
    SetHistorySql(FHisIndex - 1)
  else
  begin
    MemoSql.Lines.Text := '';
    FExecSqlModified := False;
  end;
end;

procedure TfrmDmlSqlEditorO.LabelSqlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  P: TPoint;
begin
  P := LabelSql.ClientToScreen(Point(0, LabelSql.Height + 1));
  PopupMenuOldSql.Popup(P.X, P.Y);
end;

procedure TfrmDmlSqlEditorO.CheckLoadOldSql;
begin
  if not Assigned(FOldSqlList) then
  begin
    FOldSqlList := TStringList.Create;
    LoadIniFile;
  end;
end;

procedure TfrmDmlSqlEditorO.actCopyRecExecute(Sender: TObject);
var
  S, V: string;
  I, L: integer;
begin
  if ResultDataSet <> nil then
    if ResultDataSet.Active then
      with ResultDataSet do
      begin
        L := 4;
        for I := 0 to FieldCount - 1 do
        begin
          if Length(Fields[I].FieldName) > L then
            L := Length(Fields[I].FieldName);
        end;
        S := '';
        for I := 0 to FieldCount - 1 do
        begin
          V := ExtStr(Fields[I].FieldName + ':', L + 3) + Fields[I].AsString;
          if I = 0 then
            S := V
          else
            S := S + #13#10 + V;
        end;
        if S <> '' then
          Clipboard.AsText := S;
      end;
end;

procedure TfrmDmlSqlEditorO.DBGridResMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  P: TPoint;
begin
  if (Button = mbRight) and not DBGridRes.EditorMode then
  begin
    P := DBGridRes.ClientToScreen(Point(X, Y));
    PopupMenuGrid.Popup(P.X, P.Y);
  end;
end;

procedure TfrmDmlSqlEditorO.actCopyAllExecute(Sender: TObject);
var
  S, V, Ts: string;
  I: integer;
begin
  if ResultDataSet <> nil then
    if ResultDataSet.Active then
      with ResultDataSet do
      begin
        Ts := '';
        S := '';
        for I := 0 to FieldCount - 1 do
        begin
          if I = 0 then
            S := Fields[I].FieldName
          else
            S := S + #9 + Fields[I].FieldName;
        end;
        if Ts <> '' then
          Ts := Ts + #13#10;
        Ts := Ts + S;

        First;
        while not EOF do
        begin
          S := '';
          for I := 0 to FieldCount - 1 do
          begin
            if Fields[I].IsBlob then
              V := '(BLOB)'
            else
              V := Fields[I].AsString;
            if I = 0 then
              S := V
            else
              S := S + #9 + V;
          end;
          if Ts <> '' then
            Ts := Ts + #13#10;
          Ts := Ts + S;
          Next;
        end;
        if Ts <> '' then
          Clipboard.AsText := Ts;
      end;
end;

procedure TfrmDmlSqlEditorO.LoadIniFile;
var
  AFileName, str: string;
  IniFile: TIniFile;
  I, C: integer;
begin
  AFileName := GetConfFileOfApp('') + '_SQL.INI';
  if not FileExists(AFileName) then
    Exit;

  IniFile := TIniFile.Create(AFileName);
  with IniFile do
    try
      C := ReadInteger('SqlQuery', 'HistorySqlCount', 0);
      if C <= 0 then
        Exit;
      FOldSqlList.Clear;

      for I := 0 to C - 1 do
      begin
        str := ReadString('SqlQuery', 'HistorySql' + IntToStr(I), '');
        if str <> '' then
        begin
          FOldSqlList.Add(str);
        end;
      end;

    finally
      Free;
    end;
end;

procedure TfrmDmlSqlEditorO.SaveIniFile;
var
  AFileName: string;
  IniFile: TIniFile;
  I, C: integer;
begin
  if not Assigned(FOldSqlList) then
    Exit;
  AFileName := GetConfFileOfApp('') + '_SQL.INI';

  IniFile := TIniFile.Create(AFileName);
  with IniFile do
    try
      C := FOldSqlList.Count;
      if C <= 0 then
        Exit;
      if C > 20 then
        C := 20;
      WriteInteger('SqlQuery', 'HistorySqlCount', C);

      for I := 0 to C - 1 do
      begin
        WriteString('SqlQuery', 'HistorySql' + IntToStr(I), FOldSqlList[I]);
      end;

    finally
      Free;
    end;
end;

procedure TfrmDmlSqlEditorO.PopupMenuGridPopup(Sender: TObject);
begin
  actCopyRec.Enabled := Assigned(ResultDataSet) and ResultDataSet.Active;
  actCopyCol.Enabled := Assigned(ResultDataSet) and ResultDataSet.Active;
  actCopyAll.Enabled := Assigned(ResultDataSet) and ResultDataSet.Active;
end;

procedure TfrmDmlSqlEditorO.sbtnClearAllClick(Sender: TObject);
var
  sql: string;
begin
  sql := Trim(MemoSql.Lines.Text);
  if (sql <> '') and (sql <> Trim(AutoExecSql)) and (Trim(AutoExecSql) <> '') then
  begin
    MemoSql.Lines.Text := AutoExecSql;
  end
  else
  begin
    MemoSql.Lines.Text := '';
    AutoExecSql := '';
  end;
  FExecSqlModified := False;
  if ResultDataSet <> nil then
    if ResultDataSet.Active then
      ResultDataSet.Close;
end;

procedure TfrmDmlSqlEditorO.sbtnConnectDbClick(Sender: TObject);
var
  p: TPoint;
begin
  p.X := 0;
  p.Y := sbtnConnectDb.Height;
  p := sbtnConnectDb.ClientToScreen(p);
  PopupMenuDbConn.Popup(p.X, p.Y);
end;

procedure TfrmDmlSqlEditorO.SetReadOnlyMode(const Value: boolean);
var
  cl: TColor;
begin
  FReadOnlyMode := Value;
  MemoSql.ReadOnly := FReadOnlyMode;
  if FReadOnlyMode then
    cl := clCream
  else
    cl := clWindow;
  MemoSql.Color := cl;
  DBGridRes.Color := cl;
  sbtnClearAll.Enabled := not FReadOnlyMode;
end;

procedure TfrmDmlSqlEditorO.SetSplitPercent(const Value: double);
begin
  FSplitPercent := Value;
  FormResize(nil);
end;

procedure TfrmDmlSqlEditorO.RefreshTbList(bForce, bCheckMode: boolean);
var
  S, dbus: string;
  I: integer;
begin
  if not Assigned(FCtMetaDatabase) or not FCtMetaDatabase.Connected then
    Exit;
  S := '[' + FCtMetaDatabase.EngineType + ']' + FCtMetaDatabase.Database;
  if (FLastTbListDBInfo = S) and not bForce and bCheckMode then
    Exit;
  FLastTbListDBInfo := S;

  Screen.Cursor := crAppStart;
  try
    if bForce or (combDbUsers.Items.Count = 0) then
    begin
      combDbUsers.Items.Text := FCtMetaDatabase.GetDbUsers;
      dbus := FCtMetaDatabase.DbSchema;
      if dbus = '' then
        dbus := FCtMetaDatabase.User;
      for I := 0 to combDbUsers.Items.Count - 1 do
        if UpperCase(combDbUsers.Items[I]) = UpperCase(dbus) then
          combDbUsers.ItemIndex := I;
    end;
    ListBoxTbs.Items.Assign(FCtMetaDatabase.GetDbObjs(combDbUsers.Text));
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmDmlSqlEditorO.DoDbTableAction(act: string);
var
  o: TCtMetaObject;
  I, po: integer;
  db, obj: string;
begin
  if FCtMetaDatabase = nil then
    Exit;
  I := ListBoxTbs.ItemIndex;
  if I < 0 then
    Exit;
  obj := ListBoxTbs.Items[I];
  db := combDBUsers.Text;

  if db = '' then
  begin
    po := Pos('.', obj);
    if po > 0 then
    begin
      db := Copy(obj, 1, po - 1);
      obj := Copy(obj, po + 1, Length(obj));
    end;
  end;

  Screen.Cursor := crAppStart;
  try
    o := FCtMetaDatabase.GetObjInfos(db, obj, '');
  finally
    Screen.Cursor := crDefault;
  end;

  if o = nil then
    raise Exception.Create(srDmlSearchNotFound + ' - ' + obj);
  try
    if act = 'show_props' then
    begin
      if not Assigned(Proc_ShowCtTableOfField) then
        raise Exception.Create('Proc_ShowCtTableOfField not assigned');
      Proc_ShowCtTableOfField(TCtMetaTable(o), nil, True, False, True);
    end;

    if act = 'get_select_sql' then
    begin
      MemoSql.Lines.Text := TCtMetaTable(o).GenSelectSql(G_MaxRowCountForTableData,
        FCtMetaDatabase.EngineType);
      actExec.Execute;
    end;
  finally
    o.Free;
  end;
end;

procedure TfrmDmlSqlEditorO.actExecUpdate(Sender: TObject);
begin
  actExec.Enabled := MemoSql.CanFocus;
end;

end.
