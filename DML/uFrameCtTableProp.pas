unit uFrameCtTableProp;

{$MODE Delphi}
{$WARN 4105 off : Implicit string type conversion with potential data loss from "$1" to "$2"}
interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, StdCtrls, ComCtrls, ActnList, Menus, Buttons,
  CTMetaData, CtMetaTable,
  uFormAddCtFields, StdActns, Grids, Types;

const
  HM_REFRESHPROP = WM_USER + $2432;

type

  { TFrameCtTableProp }

  TFrameCtTableProp = class(TFrame)
    actFieldPropPanel: TAction;
    actCopyExcelText: TAction;
    actFieldsCut: TAction;
    actFieldsCopy: TAction;
    actFieldsPaste: TAction;
    actTbGenDB: TAction;
    actTbGenCode: TAction;
    actShowAdvPage: TAction;
    actShowInGraph: TAction;
    actPasteFromExcel: TAction;
    actNewComplexIndex: TAction;
    actShowDescText: TAction;
    ActionList1: TActionList;
    actFieldAdd: TAction;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    BevelGridFrame: TBevel;
    actEditCut: TEditCut;
    actEditCopy: TEditCopy;
    actEditDelete: TEditDelete;
    actEditPaste: TEditPaste;
    actEditUndo: TEditUndo;
    btnShowInGraph: TBitBtn;
    ckbGenCode: TCheckBox;
    ckbGenDatabase: TCheckBox;
    edtUIDisplayText: TEdit;
    FindDialogTxt: TFindDialog;
    lbGenTp: TLabel;
    lbExProps: TLabel;
    lbScriptRules: TLabel;
    lbUILogic: TLabel;
    lbBuzLogic: TLabel;
    lbUIDispName: TLabel;
    Label41: TLabel;
    lbExtraSQL: TLabel;
    listboxGenTypes: TListBox;
    memoDescHelp: TMemo;
    memoBusinessLogic: TMemo;
    memoExtraProps: TMemo;
    memoScriptRules: TMemo;
    memoExtraSQL: TMemo;
    MemoUILogic: TMemo;
    pmFsPaste: TMenuItem;
    pmFsCut: TMenuItem;
    MN_SpltCp: TMenuItem;
    pmFsCopy: TMenuItem;
    MN_TBGenCode: TMenuItem;
    MN_TbGenDB: TMenuItem;
    MN_GenOption: TMenuItem;
    MN_ShowAdvPage: TMenuItem;
    PanelGenContent: TPanel;
    PanelUIPreview: TPanel;
    pmSaveCodeAs: TMenuItem;
    MNGenTab_Customize: TMenuItem;
    MN_SpltA: TMenuItem;
    MN_ShowInGraph: TMenuItem;
    MN_PasteFromExcel: TMenuItem;
    MN_CopyExcelText: TMenuItem;
    MN_ShowDescText: TMenuItem;
    MN_NewComplexIndex: TMenuItem;
    MN_FieldPropPanel: TMenuItem;
    MN_ImportFields: TMenuItem;
    PanelFieldToolbar: TPanel;
    PopupMenuGenTabs: TPopupMenu;
    PopupMenuTbFields: TPopupMenu;
    MN_FieldAdd: TMenuItem;
    actFieldDel: TAction;
    N1: TMenuItem;
    actFieldMoveUp: TAction;
    actFieldMoveDown: TAction;
    actFieldProp: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    actAddSysFields: TAction;
    N7: TMenuItem;
    PageControlTbProp: TPageControl;
    SaveDialogCode: TSaveDialog;
    sbtnFind: TSpeedButton;
    PanelFieldProps: TPanel;
    ScrollBoxCustomScriptDef: TScrollBox;
    ScrollBoxOperLogic: TScrollBox;
    SpeedButton_FieldAdd: TSpeedButton;
    SpeedButton_FieldDel: TSpeedButton;
    SpeedButton_FIeldMoveDown: TSpeedButton;
    SpeedButton_FieldPropPanel: TSpeedButton;
    SpeedButton_FIeldMoveUp: TSpeedButton;
    SplitterGenTps: TSplitter;
    SplitterDescHelp: TSplitter;
    SplitterFsProp: TSplitter;
    StringGridTableFields: TStringGrid;
    TabSheetUI: TTabSheet;
    TabSheetOperLogic: TTabSheet;
    TabSheetDesc: TTabSheet;
    TabSheetCodeGen: TTabSheet;
    MemoCodeGen: TMemo;
    MemoDesc: TMemo;
    TabSheetTable: TTabSheet;
    ImageListCttb: TImageList;
    PanelDescrbBottom: TPanel;
    lb_DescrbTips: TLabel;
    Panel_ScriptOpers: TPanel;
    btnShowSettings: TButton;
    btnSaveSettings: TButton;
    btnEditScript: TButton;
    Panel_ScriptSettings: TPanel;
    actImportFields: TAction;
    TabSheetText: TTabSheet;
    MemoTextContent: TMemo;
    Panel1: TPanel;
    edtTextName: TEdit;
    Label5: TLabel;
    ckbIsSqlText: TCheckBox;
    btnViewInBrowser: TButton;
    actEditSelectAll: TEditSelectAll;
    PopupMenuGenMemo: TPopupMenu;
    pmUndo1: TMenuItem;
    pmDivN9: TMenuItem;
    pmCut1: TMenuItem;
    pmCopy1: TMenuItem;
    pmPaste1: TMenuItem;
    pmDelete1: TMenuItem;
    N9: TMenuItem;
    pmSelectAll1: TMenuItem;
    pmSpecCopy: TMenuItem;
    pmCopyAsJava: TMenuItem;
    pmCopyAsCSharp: TMenuItem;
    pmCopyAsCpp: TMenuItem;
    pmCopyAsC: TMenuItem;
    pmCopyAsDelphi: TMenuItem;
    pmCopyAsPLSql: TMenuItem;
    Panel_TbH: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    edtTableName: TEdit;
    MemoTableComment: TMemo;
    edtDispName: TEdit;
    Panel_TbB: TPanel;
    Label3: TLabel;
    SplitterTbPropTop: TSplitter;
    actFieldMoveTop: TAction;
    actFieldMoveBottom: TAction;
    MN_FLD_MOV_TOP: TMenuItem;
    MN_FLD_MOV_BOTTOM: TMenuItem;
    TabSheetData: TTabSheet;
    TimerGridEditingCheck: TTimer;
    TimerShowData: TTimer;
    actSortFieldsByName: TAction;
    MN_SortFieldsByName: TMenuItem;
    TabSheetCust: TTabSheet;
    PanelCustomScriptDef: TPanel;
    lbCustomSCTip: TLabel;
    procedure actCopyExcelTextExecute(Sender: TObject);
    procedure actFieldPropPanelExecute(Sender: TObject);
    procedure actFieldsCopyExecute(Sender: TObject);
    procedure actFieldsCutExecute(Sender: TObject);
    procedure actFieldsPasteExecute(Sender: TObject);
    procedure actFieldsPasteUpdate(Sender: TObject);
    procedure actImportFieldsExecute(Sender: TObject);
    procedure actNewComplexIndexExecute(Sender: TObject);
    procedure actPasteFromExcelExecute(Sender: TObject);
    procedure actShowAdvPageExecute(Sender: TObject);
    procedure actShowDescTextExecute(Sender: TObject);
    procedure actShowInGraphExecute(Sender: TObject);
    procedure actTbGenCodeExecute(Sender: TObject);
    procedure actTbGenDBExecute(Sender: TObject);
    procedure btnShowInGraphClick(Sender: TObject);
    procedure FindDialogTxtFind(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure lb_DescrbTipsClick(Sender: TObject);
    procedure listboxGenTypesClick(Sender: TObject);
    procedure MemoCodeGenDblClick(Sender: TObject);
    procedure MemoDescDblClick(Sender: TObject);
    procedure MemoDescKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoTextContentDblClick(Sender: TObject);
    procedure MNGenTab_CustomizeClick(Sender: TObject);
    procedure PageControlTbPropChange(Sender: TObject);
    procedure PanelCustomScriptDefResize(Sender: TObject);
    procedure Panel_ScriptSettingsResize(Sender: TObject);
    procedure Panel_TbHResize(Sender: TObject);
    procedure pmSaveCodeAsClick(Sender: TObject);
    procedure PopupMenuTbFieldsPopup(Sender: TObject);
    procedure sbtnFindClick(Sender: TObject);
    procedure ScrollBoxCustomScriptDefResize(Sender: TObject);
    procedure SplitterFsPropMoved(Sender: TObject);
    procedure StringGridTableFieldsDblClick(Sender: TObject);
    procedure StringGridTableFieldsDragDrop(Sender, Source: TObject; X,
      Y: integer);
    procedure StringGridTableFieldsDragOver(Sender, Source: TObject; X,
      Y: integer; State: TDragState; var Accept: boolean);
    procedure StringGridTableFieldsDrawCell(Sender: TObject; aCol,
      aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure StringGridTableFieldsEndDrag(Sender, Target: TObject; X,
      Y: integer);
    procedure StringGridTableFieldsGetEditText(Sender: TObject; ACol,
      ARow: integer; var Value: string);
    procedure StringGridTableFieldsKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure StringGridTableFieldsMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure StringGridTableFieldsPrepareCanvas(Sender: TObject; aCol,
      aRow: integer; aState: TGridDrawState);
    procedure StringGridTableFieldsSelection(Sender: TObject; aCol,
      aRow: integer);
    procedure StringGridTableFieldsSetEditText(Sender: TObject; ACol,
      ARow: integer; const Value: string);
    procedure StringGridTableFieldsValidateEntry(Sender: TObject; aCol,
      aRow: integer; const OldValue: string; var NewValue: string);
    procedure TabSheetDescShow(Sender: TObject);
    procedure TabSheetCodeGenShow(Sender: TObject);
    procedure TabSheetCustShow(Sender: TObject);
    procedure actFieldMoveBottomExecute(Sender: TObject);
    procedure actFieldMoveTopExecute(Sender: TObject);
    procedure ckbIsSqlTextClick(Sender: TObject);
    procedure MemoTextContentExit(Sender: TObject);
    procedure edtTextNameExit(Sender: TObject);
    procedure btnEditScriptClick(Sender: TObject);
    procedure btnSaveSettingsClick(Sender: TObject);
    procedure btnShowSettingsClick(Sender: TObject);
    procedure actFieldAddExecute(Sender: TObject);
    procedure actFieldDelExecute(Sender: TObject);
    procedure actFieldMoveUpExecute(Sender: TObject);
    procedure actFieldMoveDownExecute(Sender: TObject);
    procedure actFieldPropExecute(Sender: TObject);
    procedure edtTableNameExit(Sender: TObject);
    procedure MemoTableCommentExit(Sender: TObject);
    procedure actAddSysFieldsExecute(Sender: TObject);
    procedure MemoDescExit(Sender: TObject);
    procedure btnViewInBrowserClick(Sender: TObject);
    procedure pmCopyAsJavaClick(Sender: TObject);
    procedure pmCopyAsCClick(Sender: TObject);
    procedure pmCopyAsCSharpClick(Sender: TObject);
    procedure pmCopyAsCppClick(Sender: TObject);
    procedure pmCopyAsDelphiClick(Sender: TObject);
    procedure pmCopyAsPLSqlClick(Sender: TObject);
    procedure PopupMenuGenMemoPopup(Sender: TObject);
    procedure SpeedButton_FieldAddClick(Sender: TObject);
    procedure TabSheetDataShow(Sender: TObject);
    procedure TimerGridEditingCheckTimer(Sender: TObject);
    procedure TimerShowDataTimer(Sender: TObject);
    procedure actSortFieldsByNameExecute(Sender: TObject);
    procedure PageControlTbPropChanging(Sender: TObject; var AllowChange: boolean);
  private
    { Private declarations }
    FReadOnlyMode: boolean;
    FCtMetaTable: TCtMetaTable;
    FSelFields: TCTMetaFieldList;
    FIniting: boolean;
    FGenCodeType: string; //Sql, Oracle, Pascal...
    FDmlScControls: TObject; //TDmlScriptControlList
    FLastActiveTabSheet: TTabSheet;
    FLastPanelTbH_Width: integer;

    FSCInited: boolean;
    FCustDmlScControls: TObject; //TDmlScriptControlList
    FFieldPropSplitPercent: double;
    FShowOperLogicPage: boolean;

    FGridDragFocusingRow: integer;

    FTabInitTick: Integer;

    procedure SetShowOperLogicPage(AValue: boolean);
    procedure _OnCustDmlCtrlValueExec(Sender: TObject);
    procedure RunCustomScriptDef(bReInitSettings: boolean);

    procedure _OnCtFieldFramePropChange(Sender: TObject);

    procedure GenTbCode;
    procedure CopyTextAs(tp: string);
    procedure CopyTextAsEx(txt, tp: string);
    function AddDxFieldNode(AField: TCtMetaField): integer;
    procedure SetDxFieldNode(AField: TCtMetaField; ARowIndex: integer);
    function GetImageIndexOfCtNode(Nd: TCtObject; bSelected: boolean = False): integer;
    procedure FieldListHideEditor;
    function FieldOfGridRow(ARowIndex: integer): TCtMetaField;
    function RowIndexOfField(AField: TCtMetaField): integer;
    procedure _OnCellXYValSet(aCol, aRow: integer; var NewValue: string;
      bEvents: boolean);
    procedure _OnUIPropChanged(Field, prop, Value, par1, par2, opt: string);
    function IsInnerSqlTab(tab: string): boolean;
    function GetSelectedFields: TCTMetaFieldList;
    procedure RestoreSelectionFeilds;
    procedure CopySelectedFields(bCut: Boolean);
  public
    { Public declarations }
    //tp: 0=Obj1.Prop,1=move,2=Obj1.Child
    Proc_OnPropChange:
    procedure(Tp: integer; Obj1, Obj2: TCtMetaObject; param: string) of object;
    Proc_GridEscape:
    procedure(Sender: TObject) of object;

    //dxTreeListTableFields: TdxTreeList;

    TbDataSqlForm: TCustomForm;
    FieldPropForm: TFrame;
    UIPreviewFrame: TFrame;
    OwnerDialog: TForm;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RefreshProp;
    procedure ShowTableProp(ATb: TCtMetaTable);
    procedure RefreshDesc;
    procedure ShowTableDataDelay;
    procedure ShowCurTableData;
    procedure RefreshFieldProps(AFld: TCtMetaField = nil);
    procedure RefreshUIPreview;
    procedure MoveDxField(ARowIndex, iMode: integer); //mode -2top -1up 1down 2bottom
    procedure SetActsEnable(bEnb: boolean);
    procedure CheckGridEditingMode;

    function GetDmlScriptFiles: string;
    function GetDmlScriptOutput(fn: string; bReInitSettings: boolean = True): string;
    function GetDmlScriptOutputEx(fn: string; bReInitSettings: boolean = True): string;
    procedure _OnCtrlValueExec(Sender: TObject);
    procedure InitDmlScriptPages;

    procedure LoadColWidths(secEx: string);
    procedure SaveColWidths(secEx: string);

    procedure Init(ATable: TCtMetaTable; bReadOnly: boolean);
    procedure HideProps;
    procedure FocusToField(cf: TCtMetaField);
    property ShowOperLogicPage: boolean read FShowOperLogicPage write SetShowOperLogicPage;
  end;

  TStringGridXX = class(TStringGrid)
  end;

const
  DEF_clInfoBk = $E1FFFF;
  DEF_INNER_SQL_TABS: array[0..5] of
    string = ('SQL', 'Oracle', 'MySql', 'SQLServer', 'SQLite', 'PostgreSQL');
var
  G_TbPropTabInitTick: Integer = 0;
  G_LastTbDescInputDemo: string = '';
  G_LastTbDescHelpWidth: Integer = 0;

implementation

uses
  dmlstrs, DmlScriptPublic, DmlScriptControl, uDMLSqlEditor, IniFiles, uFrameCtFieldDef,
  ClipBrd, WindowFuncs, uFormCtDbLogon, DmlPasScript, DmlJsScript, ide_editor,
  uFormSelectFields, uFrameUIPreview, ezdmlstrs, uFormGenTabCust, CtObjXmlSerial;

{$R *.lfm}

{ TFrameCtTable }

procedure TFrameCtTableProp.CopyTextAs(tp: string);
begin
  MemoCodeGen.CopyToClipboard;
  CopyTextAsEx(ClipBrd.Clipboard.AsText, tp);
end;

procedure TFrameCtTableProp.CopyTextAsEx(txt, tp: string);
begin
  txt := CopyTextAsLan(txt, tp);
  if txt <> '' then
    ClipBrd.Clipboard.AsText := txt;

end;

constructor TFrameCtTableProp.Create(AOwner: TComponent);
var
  I: integer;
  ss: TStrings;
begin
  inherited;
  FFieldPropSplitPercent := 0.4;
  PanelFieldProps.Visible := False;

  FSelFields:= TCTMetaFieldList.Create;
  FSelFields.AutoFree:=False;

  with StringGridTableFields do
  begin
    Columns[1].Title.Caption := srFieldName;
    Columns[2].Title.Caption := srLogicName;
    Columns[3].Title.Caption := srDataType;
    Columns[4].Title.Caption := srDataLength;
    Columns[5].Title.Caption := srConstraint;
    Columns[6].Title.Caption := srComments;
  end;
  FGridDragFocusingRow := -1;

  TabStop := False;
  PageControlTbProp.ActivePageIndex := 0;

  SpeedButton_FieldAdd.Caption := '';
  SpeedButton_FieldDel.Caption := '';
  SpeedButton_FIeldMoveUp.Caption := '';
  SpeedButton_FIeldMoveDown.Caption := '';

  ss := StringGridTableFields.Columns[5].PickList;
  for I := 0 to 6 do
    if ShouldUseEnglishForDML then
      ss.Add(DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[I])
    else
      ss.Add(DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[I]);
  if ShouldUseEnglishForDML then
  begin
    ss.Add(
      DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[2] + ',' +
      DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[7]);
    ss.Add(
      DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[3] + ',' +
      DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[5]);
  end
  else
  begin
    ss.Add(
      DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[2] + ',' +
      DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[7]);
    ss.Add(
      DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[3] + ',' +
      DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[5]);
  end;

  if Trim(G_LastTbDescInputDemo) <> '' then
    memoDescHelp.Lines.Text := G_LastTbDescInputDemo
  else
    memoDescHelp.Lines.Text := srTbDescInputDemo;
  if G_LastTbDescHelpWidth > 0 then  
    memoDescHelp.Width := G_LastTbDescHelpWidth;

  FieldPropForm := TFrameCtFieldDef.Create(Self);
  FieldPropForm.Parent := PanelFieldProps;
  FieldPropForm.Align := alClient;
  TFrameCtFieldDef(FieldPropForm).stFieldName.Tag := 1;
  TFrameCtFieldDef(FieldPropForm).PageControl1.Align := alClient;
  TFrameCtFieldDef(FieldPropForm).OnFieldPropChange := _OnCtFieldFramePropChange;    
  TFrameCtFieldDef(FieldPropForm).btnHideFieldProp.Visible := True;
  TFrameCtFieldDef(FieldPropForm).btnHideFieldProp.OnClick := actFieldPropPanelExecute;

  UIPreviewFrame := TFrameUIPreview.Create(Self);
  UIPreviewFrame.Parent := PanelUIPreview;
  UIPreviewFrame.Align := alClient;
  TFrameUIPreview(UIPreviewFrame).Proc_OnUIPropChanged := _OnUIPropChanged;

  btnShowSettings.Tag := 1;
  btnShowSettings.Caption := StringReplace(btnShowSettings.Caption, '>>', '<<', []);

  FDmlScControls := TDmlScriptControlList.Create;
  TDmlScriptControlList(FDmlScControls).OnCtrlValueExec := Self._OnCtrlValueExec;
  InitDmlScriptPages;

  FCustDmlScControls := TDmlScriptControlList.Create;
  TDmlScriptControlList(FCustDmlScControls).OnCtrlValueExec :=
    Self._OnCustDmlCtrlValueExec;
end;

destructor TFrameCtTableProp.Destroy;
begin
  FreeAndNil(FDmlScControls);
  FreeAndNil(FCustDmlScControls);
  FreeAndNil(FSelFields);
  inherited;
end;

procedure TFrameCtTableProp.Init(ATable: TCtMetaTable; bReadOnly: boolean);
var
  t: TCtFieldDataType;
  ss: TStrings;
  I: integer;
begin       
  if FTabInitTick <> G_TbPropTabInitTick then
    InitDmlScriptPages;
  if G_CustomPropUICaption <> '' then
    TabSheetCust.Caption := G_CustomPropUICaption;
  ss := StringGridTableFields.Columns[3].PickList;
  ss.Clear;
  for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
    if ShouldUseEnglishForDML then
      ss.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t])
    else
      ss.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t]);
  for I := 0 to High(CtCustFieldTypeList) do
    ss.Add(CtCustFieldTypeList[I]);

  FCtMetaTable := ATable;
  FReadOnlyMode := bReadOnly or not Assigned(ATable);

  StringGridTableFields.Options := StringGridTableFields.Options + [goAlwaysShowEditor];

  TDmlScriptControlList(FDmlScControls).CurFileName := '';
  FSCInited := False;
  if G_FieldGridShowLines then
    Self.StringGridTableFields.GridLineWidth := 1
  else
    Self.StringGridTableFields.GridLineWidth := 0;
  RefreshProp;

  lbCustomSCTip.Caption := '';
  lbCustomSCTip.Visible := False;

  if Self.PageControlTbProp.ActivePage = TabSheetCust then
  begin
    Self.TabSheetCustShow(TabSheetCust);
  end;
end;

procedure TFrameCtTableProp.HideProps;
begin
  if UIPreviewFrame <> nil then
    TFrameUIPreview(UIPreviewFrame).HideProps();
end;

procedure TFrameCtTableProp.FocusToField(cf: TCtMetaField);
var
  I: integer;
begin
  if cf = nil then
    Exit;
  for I := 0 to StringGridTableFields.RowCount - 1 do
    if FieldOfGridRow(I) = cf then
    begin
      StringGridTableFields.Row := I;
      Break;
    end;
end;

procedure TFrameCtTableProp.InitDmlScriptPages;
var
  I: integer;
  SS: TStrings;
  fn, S: string;
begin
  FTabInitTick:=G_TbPropTabInitTick;
  for I := listboxGenTypes.Items.Count - 1 downto 0 do
    listboxGenTypes.Items.Delete(I);

  fn := FolderAddFileName(GetDmlScriptDir, 'gen_tabs.txt');
  if FileExists(fn) then
  begin
    SS := TStringList.Create;
    try
      SS.LoadFromFile(fn);
      S := ss.Text;
      if Copy(S, 1, 2) = #$FE#$FF then
        Delete(S, 1, 2)
      else if Copy(S, 1, 2) = #$FE#$FE then
        Delete(S, 1, 2)
      else if Copy(S, 1, 3) = #$EF#$BB#$BF then
        Delete(S, 1, 3);
      ss.Text := S;
      for I := 0 to SS.Count - 1 do
        if listboxGenTypes.Items.IndexOf(ss[I]) = -1 then
          listboxGenTypes.Items.Add(SS[I]);
    finally
      SS.Free;
    end;
  end;
     
  if listboxGenTypes.Items.Count = 0 then
  begin
    for I := 0 to High(DEF_INNER_SQL_TABS) do
      listboxGenTypes.Items.Add(DEF_INNER_SQL_TABS[I]);

    SS := TStringList.Create;
    try
      SS.Text := GetDmlScriptFiles;
      for I := 0 to SS.Count - 1 do
        if listboxGenTypes.Items.IndexOf(ss[I]) = -1 then
          listboxGenTypes.Items.Add(SS[I]);
    finally
      SS.Free;
    end;
  end;

  i := -1;
  if FGenCodeType <> '' then
    i := listboxGenTypes.Items.IndexOf(FGenCodeType);
  if i < 0 then
    if listboxGenTypes.Items.Count > 0 then
      i := 0;
  if i>=0 then
  begin
    listboxGenTypes.ItemIndex := i;
    listboxGenTypesClick(nil);
  end;
end;

procedure TFrameCtTableProp.LoadColWidths(secEx: string);
var
  fn, S: string;
  ini: TIniFile;
  I, w: integer;
  bChg: boolean;
begin
  fn := GetConfFileOfApp;
  if FileExists(fn) then
  begin
    ini := TIniFile.Create(fn);
    try
      S := 'TableProp' + secEx;
      for I := 1 to StringGridTableFields.Columns.Count - 1 do
      begin
        w := ini.ReadInteger(S, 'ColWidth' + IntToStr(I), 0);
        if w > 10 then
          StringGridTableFields.Columns[I].Width := w;
      end;
      bChg := False;
      FFieldPropSplitPercent :=
        ini.ReadFloat(S, 'FieldPropSplitPercent', FFieldPropSplitPercent);
      if ini.ReadBool(S, 'ShowFieldPropPanel', PanelFieldProps.Visible) <>
        PanelFieldProps.Visible then
      begin
        PanelFieldProps.Visible := not PanelFieldProps.Visible;
        bChg := True;
      end;
      if bChg then
        Self.FrameResize(nil);
      if OwnerDialog <> nil then
      begin
        OwnerDialog.Width := ini.ReadInteger(S, 'OwnerDialogWidth', OwnerDialog.Width);
        OwnerDialog.Height := ini.ReadInteger(S, 'OwnerDialogHeight',
          OwnerDialog.Height);
      end;

      FGenCodeType := ini.ReadString(S, 'GenCodeType', FGenCodeType);
      if FGenCodeType <> '' then
      begin
        i := listboxGenTypes.Items.IndexOf(FGenCodeType);
        if i>=0 then
        try
          listboxGenTypes.ItemIndex := i;
          listboxGenTypesClick(nil);
        except
          Application.HandleException(Self);
        end;
      end;
      if memoDescHelp.Visible <> ini.ReadBool(S, 'ShowDescHelp', memoDescHelp.Visible) then
        lb_DescrbTipsClick(nil);
      ShowOperLogicPage := G_EnableAdvTbProp;
      if ShowOperLogicPage and (TabSheetOperLogic.Tag = 1) then
        TabSheetOperLogic.TabVisible := ShowOperLogicPage;

      I := ini.ReadInteger(S, 'ActivePageIndex', -1);
      if (I >= 0) and (I < PageControlTbProp.PageCount) then
        if PageControlTbProp.Pages[I].TabVisible then
        begin
          if PageControlTbProp.ActivePageIndex <> I then
          begin
            PageControlTbProp.ActivePageIndex:=I;
            PageControlTbPropChange(nil);
          end;
        end;
    finally
      ini.Free;
    end;
  end;

  TFrameUIPreview(UIPreviewFrame).LoadConfig(secEx);
end;

procedure TFrameCtTableProp.SaveColWidths(secEx: string);
var
  fn, S: string;
  ini: TIniFile;
  I, w: integer;
begin
  fn := GetConfFileOfApp;
  ini := TIniFile.Create(fn);
  try
    S := 'TableProp' + secEx;
    for I := 1 to StringGridTableFields.Columns.Count - 1 do
    begin
      w := StringGridTableFields.Columns[I].Width;
      ini.WriteInteger(S, 'ColWidth' + IntToStr(I), w);
    end;
    ini.WriteFloat(S, 'FieldPropSplitPercent', FFieldPropSplitPercent);
    ini.WriteBool(S, 'ShowFieldPropPanel', PanelFieldProps.Visible or
      (PanelFieldProps.Tag = 1));
    if OwnerDialog <> nil then
      if OwnerDialog.WindowState <> wsMaximized then
      begin
        ini.WriteInteger(S, 'OwnerDialogWidth', OwnerDialog.Width);
        ini.WriteInteger(S, 'OwnerDialogHeight', OwnerDialog.Height);
      end;
    ini.WriteInteger(S, 'ActivePageIndex', PageControlTbProp.ActivePageIndex);
    ini.WriteString(S, 'GenCodeType', FGenCodeType);
    ini.WriteBool(S, 'ShowDescHelp', memoDescHelp.Visible);
  finally
    ini.Free;
  end;

  TFrameUIPreview(UIPreviewFrame).SaveConfig(secEx);

  S := memoDescHelp.Lines.Text;
  if Trim(S) <> Trim(srTbDescInputDemo) then
    G_LastTbDescInputDemo := S;
  G_LastTbDescHelpWidth :=  memoDescHelp.Width;
end;

procedure TFrameCtTableProp.RefreshDesc;
begin
  if FCtMetaTable = nil then
    Exit;
  MemoDesc.Lines.Text := FCtMetaTable.Describe;
  GenTbCode;
  MemoDesc.Modified := False;
end;

procedure TFrameCtTableProp.RefreshProp;
var
  bShowIcon: boolean;
begin
  actAddSysFields.Enabled := Assigned(FCtMetaTable) and not FReadOnlyMode;
  actAddSysFields.Visible := actAddSysFields.Enabled;
  actImportFields.Visible := Assigned(FCtMetaTable) and not FReadOnlyMode;
  actNewComplexIndex.Enabled := Assigned(FCtMetaTable) and not FReadOnlyMode;
  actNewComplexIndex.Visible := actNewComplexIndex.Enabled;

  actFieldAdd.Visible := not FReadOnlyMode;
  actFieldAdd.Enabled := not FReadOnlyMode;
  SpeedButton_FieldAdd.Visible := not FReadOnlyMode;
  actFieldDel.Visible := not FReadOnlyMode;
  actFieldDel.Enabled := not FReadOnlyMode;
  actFieldMoveUp.Visible := not FReadOnlyMode;
  actFieldMoveUp.Enabled := not FReadOnlyMode;
  actFieldMoveDown.Visible := not FReadOnlyMode;
  actFieldMoveDown.Enabled := not FReadOnlyMode;
  actFieldMoveTop.Visible := not FReadOnlyMode;
  actFieldMoveTop.Enabled := not FReadOnlyMode;
  actFieldMoveBottom.Visible := not FReadOnlyMode;
  actFieldMoveBottom.Enabled := not FReadOnlyMode;

  actPasteFromExcel.Visible := not FReadOnlyMode;
  actPasteFromExcel.Enabled := not FReadOnlyMode;
  actSortFieldsByName.Visible := not FReadOnlyMode;
  actSortFieldsByName.Enabled := not FReadOnlyMode;

  actFieldsCut.Visible := not FReadOnlyMode;
  actFieldsPaste.Visible := not FReadOnlyMode;

  MN_SpltA.Visible := not FReadOnlyMode;

  bShowIcon := True;
  if FGlobeDataModelList <> nil then
    if FGlobeDataModelList.CurDataModel <> nil then
      if Pos('ShowFieldIcon=0', FGlobeDataModelList.CurDataModel.ConfigStr) > 0 then
        bShowIcon := False;
  StringGridTableFields.Columns[0].Visible := bShowIcon;

  ShowTableProp(FCtMetaTable);
end;

procedure TFrameCtTableProp.RunCustomScriptDef(bReInitSettings: boolean);
var
  FileTxt, AOutput: TStrings;
  S, fn: string;
begin
  if FCtMetaTable = nil then
    Exit;
  if not G_EnableCustomPropUI then
    Exit;
  fn := 'CustomTableDef';
  //ofn := fn;
  fn := FolderAddFileName(GetDmlScriptDir, fn + '.js_');
  fn := GetConfigFile_OfLang(fn);
  if not FileExists(fn) then
  begin
    fn := FolderAddFileName(GetDmlScriptDir, fn + '.ps_');
    fn := GetConfigFile_OfLang(fn);
  end;
  FileTxt := TStringList.Create;
  AOutput := TStringList.Create;
  if FReadOnlyMode then
    SetGParamValue('CurTablePropReadOnly', '1')
  else
    SetGParamValue('CurTablePropReadOnly', '0');
  with CreateScriptForFile(fn) do
    try
      try

        FileTxt.LoadFromFile(fn);
        S := FileTxt.Text;
        ActiveFile := fn;
        if IsSPRule(S) then
        begin
          S := PreConvertSP(S);
          FileTxt.Text := S;
        end;
        S := ExtractCompStr(FileTxt.Text, '(*[SettingsPanel]', '[/SettingsPanel]*)');
        if TDmlScriptControlList(FCustDmlScControls).CurFileName <> fn then
        begin
          //if UTF8Needed then
          //  S := Utf8Decode(S);
          TDmlScriptControlList(FCustDmlScControls).TextDesc := S;
          TDmlScriptControlList(FCustDmlScControls).CurFileName := fn;
          TDmlScriptControlList(FCustDmlScControls).ParentWnd := PanelCustomScriptDef;
          TDmlScriptControlList(FCustDmlScControls).RegenControls;
        end;
        if not FSCInited then
        begin
          FSCInited := True;
          TDmlScriptControlList(FCustDmlScControls).CurAction := 'init';
        end;

        Init('DML_SCRIPT', FCtMetaTable, AOutput, FCustDmlScControls);
        Exec('DML_SCRIPT', FileTxt.Text);
        lbCustomSCTip.Visible := False;
      except
        on EA: EAbort do
          ;
        on E: Exception do
        begin
          lbCustomSCTip.Caption := E.Message;
          lbCustomSCTip.Font.Color := clRed;
          lbCustomSCTip.Visible := True;
        end;
      end;
    finally
      FileTxt.Free;
      AOutput.Free;
      Free;
    end;
end;

procedure TFrameCtTableProp._OnCtFieldFramePropChange(Sender: TObject);
var
  AField: TCtMetaField;
  ARowIndex: integer;
begin
  ARowIndex := StringGridTableFields.Row;
  if ARowIndex <= 0 then
    Exit;

  AField := FieldOfGridRow(ARowIndex);
  if AField = nil then
    Exit;

  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(0, AField, nil, '');
  SetDxFieldNode(AField, ARowIndex);
  RefreshDesc;
  RefreshUIPreview;
end;

procedure TFrameCtTableProp.ShowCurTableData;
var
  fr: TfrmDmlSqlEditor;
  sql, dbType: string;
  idx: integer;
begin
  if FIniting then
    Exit;
  if FCtMetaTable = nil then
    Exit;
  if TbDataSqlForm = nil then
  begin
    fr := TfrmDmlSqlEditor.Create(Self);
    TbDataSqlForm := fr;
    fr.BorderStyle := bsNone;
    fr.Parent := TabSheetData;
    fr.Align := alClient;
    fr.SplitPercent := 65;
  end
  else
    fr := TfrmDmlSqlEditor(TbDataSqlForm);

  sql := Trim(fr.MemoSql.Lines.Text); //sql被手工修改过则不处理
  if (sql <> '') and (sql <> Trim(fr.AutoExecSql)) and (Trim(fr.AutoExecSql) <> '') then
    Exit;


  dbType := '';
  if fr.FCtMetaDatabase <> nil then
    dbType := fr.FCtMetaDatabase.EngineType
  else
  begin
    idx := GetLastCtDbConn(False);
    if idx >= 0 then
    begin
      dbType := CtMetaDBRegs[Idx].DbImpl.EngineType;
      if CtMetaDBRegs[Idx].DbImpl.Connected then
        fr.FCtMetaDatabase := CtMetaDBRegs[Idx].DbImpl;
    end;
  end;
  sql := FCtMetaTable.GenSelectSql(G_MaxRowCountForTableData, dbType);
  if fr.AutoExecSql = sql then
    Exit;
  fr.AutoExecSql := sql;
  fr.MemoSql.Lines.Text := sql;
  if not fr.Showing then
    fr.Show;
  if fr.FCtMetaDatabase <> nil then
    if fr.FCtMetaDatabase.Connected then
      fr.actExec.Execute;
end;

procedure TFrameCtTableProp.RefreshFieldProps(AFld: TCtMetaField);
var
  AField: TCtMetaField;
  ARowIndex: integer;
begin
  if AFld <> nil then
    AField := AFld
  else
  begin
    ARowIndex := StringGridTableFields.Row;
    if ARowIndex <= 0 then
      AField := nil
    else
      AField := FieldOfGridRow(ARowIndex);
  end;
  if AField = nil then
    TFrameCtFieldDef(FieldPropForm).Init(nil, True)
  else
    TFrameCtFieldDef(FieldPropForm).Init(AField, Self.FReadOnlyMode);
end;

procedure TFrameCtTableProp.RefreshUIPreview;
begin        
  if PageControlTbProp.ActivePage <> TabSheetUI then
  begin
    TabSheetUI.Tag := 999;
    Exit;
  end;
  TabSheetUI.Tag := 0;

  if (FCtMetaTable = nil) or FCtMetaTable.IsText then
    TFrameUIPreview(UIPreviewFrame).HideProps
  else
    TFrameUIPreview(UIPreviewFrame).InitByTable(Self.FCtMetaTable, Self.FReadOnlyMode);
end;

procedure TFrameCtTableProp.ShowTableDataDelay;
var
  idx: integer;
  dbType, sql: string;
begin
  TimerShowData.Enabled := False;
  if TbDataSqlForm <> nil then
    with TfrmDmlSqlEditor(TbDataSqlForm) do
    begin
      sql := Trim(MemoSql.Lines.Text); //sql没被手工修改过才处理
      if (sql = '') or (sql = Trim(AutoExecSql)) or (Trim(AutoExecSql) = '') then
      begin
        if FCtMetaTable <> nil then
        begin
          if FCtMetaDatabase <> nil then
            dbType := FCtMetaDatabase.EngineType
          else
          begin
            idx := GetLastCtDbConn(False);
            if idx >= 0 then
            begin
              dbType := CtMetaDBRegs[Idx].DbImpl.EngineType;
            end;
          end;
          sql := FCtMetaTable.GenSelectSql(G_MaxRowCountForTableData, dbType);
          if AutoExecSql <> sql then
          begin
            ClearSql;
            MemoSql.Lines.Text := sql;
          end;
        end
        else
          ClearSql;
      end;
    end;
  TimerShowData.Enabled := True;
end;

procedure TFrameCtTableProp.ShowTableProp(ATb: TCtMetaTable);

  procedure SetControlReadOnly(AControl: TControl);
  begin
    if AControl is TCustomEdit then
    begin
      if FReadOnlyMode then
      begin
        TEdit(AControl).ReadOnly := True;
        TEdit(AControl).ParentColor := True;
      end
      else
      begin
        TEdit(AControl).ReadOnly := False;
        TEdit(AControl).Color := clWindow;
      end;
    end
    else
      AControl.Enabled := not FReadOnlyMode;
  end;

var
  bReadOnly: boolean;
  I: integer;
  //t: TCtFieldDataType;
begin
  if FIniting then
    Exit;
  FIniting := True;
  try

    {dxTreeListTableFieldsColumn_fDataType.Items.Clear;
    for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
      if ShouldUseEnglishForDML then
        dxTreeListTableFieldsColumn_fDataType.Items.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t])
      else
        dxTreeListTableFieldsColumn_fDataType.Items.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t]);
    for I := 0 to High(CtCustFieldTypeList) do
      dxTreeListTableFieldsColumn_fDataType.Items.Add(CtCustFieldTypeList[I]);  }

    for I := 0 to Panel_TbH.ControlCount - 1 do
      SetControlReadOnly(Panel_TbH.Controls[I]);
    for I := 0 to Panel_TbB.ControlCount - 1 do
      SetControlReadOnly(Panel_TbB.Controls[I]);  
    for I := 0 to ScrollBoxOperLogic.ControlCount - 1 do
      SetControlReadOnly(ScrollBoxOperLogic.Controls[I]);

    bReadOnly := FReadOnlyMode or (ATb = nil);
    if bReadOnly then
    begin
      edtTableName.ParentColor := True;
      edtTableName.ReadOnly := True;
      edtDispName.ParentColor := True;
      edtDispName.ReadOnly := True;
      MemoTableComment.ParentColor := True;
      MemoTableComment.ReadOnly := True;
      //StringGridTableFields.ParentColor := True;
      StringGridTableFields.Color := $f8f8f8;
      //StringGridTableFields.ReadOnly := True;
      StringGridTableFields.Options := StringGridTableFields.Options - [goEditing];

      edtTextName.ParentColor := True;
      edtTextName.ReadOnly := True;
      ckbIsSqlText.Enabled := False;
      MemoTextContent.ParentColor := True;
      MemoTextContent.ReadOnly := True;

      MemoDesc.ParentColor := True;
      MemoDesc.ReadOnly := True;
      MemoCodeGen.ParentColor := True;
      MemoCodeGen.ReadOnly := False;
    end
    else
    begin
      edtTableName.Color := clWindow;
      edtTableName.ReadOnly := False;
      edtDispName.Color := clWindow;
      edtDispName.ReadOnly := False;
      MemoTableComment.Color := clWindow;
      MemoTableComment.ReadOnly := False;
      StringGridTableFields.Color := clWindow;
      StringGridTableFields.Options := StringGridTableFields.Options + [goEditing];
      //ListViewTableFields.ReadOnly := False;

      edtTextName.Color := clWindow;
      edtTextName.ReadOnly := False;
      ckbIsSqlText.Enabled := True;
      MemoTextContent.Color := clWindow;
      MemoTextContent.ReadOnly := False;

      MemoDesc.Color := clWindow;
      MemoDesc.ReadOnly := False;
      MemoCodeGen.Color := DEF_clInfoBk;
      MemoCodeGen.ReadOnly := False;
    end;

    if ATb = nil then
    begin
      edtTableName.Text := '';
      edtDispName.Text := '';
      MemoTableComment.Lines.Text := '';

      with StringGridTableFields do
        Clean(0, 1, ColCount - 1, RowCount - 1, [gzNormal]);
      StringGridTableFields.RowCount := 1;

      edtTextName.Text := '';
      MemoTextContent.Lines.Text := '';

      MemoDesc.Lines.Text := '';
      MemoCodeGen.Lines.Text := '';
      MemoDesc.Modified := False;

      edtUIDisplayText.Text := '';
      ckbGenDatabase.Checked := False;   
      ckbGenCode.Checked := False;
      memoExtraSQL.Lines.Text := '';   
      MemoUILogic.Lines.Text := '';
      memoBusinessLogic.Lines.Text := '';
      memoExtraProps.Lines.Text := '';        
      memoScriptRules.Lines.Text := '';
      actTbGenDB.Checked := False;
      actTbGenCode.Checked := False;
      MN_GenOption.Visible := False;

      TabSheetText.TabVisible := False;
      TabSheetTable.TabVisible := True;
      TabSheetDesc.TabVisible := True;      
      TabSheetUI.TabVisible := True;
      TabSheetOperLogic.TabVisible := ShowOperLogicPage;
      TabSheetOperLogic.Tag := 1;

      TabSheetCodeGen.TabVisible := True;
      TabSheetData.TabVisible := True;
      TabSheetCust.TabVisible := False;

      if FLastActiveTabSheet <> nil then
        if FLastActiveTabSheet.TabVisible then
          PageControlTbProp.ActivePage := FLastActiveTabSheet;
    end
    else if ATb.IsText then
    begin
      edtTextName.Text := ATb.Name;
      ckbIsSqlText.Checked := ATb.IsSqlText;
      MemoTextContent.Lines.Text := ATb.Memo;
      with StringGridTableFields do
        Clean(0, 1, ColCount - 1, RowCount - 1, [gzNormal]);
      StringGridTableFields.RowCount := 1;

      TabSheetText.TabVisible := True;
      TabSheetTable.TabVisible := False;
      TabSheetDesc.TabVisible := False;         
      TabSheetUI.TabVisible := False;
      TabSheetOperLogic.TabVisible := False; 
      TabSheetOperLogic.Tag := 0;
      TabSheetCodeGen.TabVisible := False;
      TabSheetData.TabVisible := False;
      TabSheetCust.TabVisible := False;  
      MN_GenOption.Visible := False;

      if PageControlTbProp.ActivePage <> TabSheetText then
      begin
        FLastActiveTabSheet := PageControlTbProp.ActivePage;
        PageControlTbProp.ActivePage := TabSheetText;
      end;
    end
    else
    begin
      edtTableName.Text := ATb.Name;
      edtDispName.Text := ATb.Caption;
      MemoTableComment.Lines.Text := ATb.Memo;
      with StringGridTableFields do
        Clean(0, 1, ColCount - 1, RowCount - 1, [gzNormal]);
      StringGridTableFields.RowCount := 1;

      with ATb.MetaFields do
        for I := 0 to Count - 1 do
          AddDxFieldNode(Items[I]);

      MemoDesc.Lines.Text := atb.Describe;
      GenTbCode;
      MemoDesc.Modified := False;
                   
      edtUIDisplayText.Text := ATb.UIDisplayText;
      ckbGenDatabase.Checked := ATb.GenDatabase;
      ckbGenCode.Checked := ATb.GenCode;
      memoExtraSQL.Lines.Text := ATb.ExtraSQL;
      MemoUILogic.Lines.Text := ATb.UILogic;
      memoBusinessLogic.Lines.Text := ATb.BusinessLogic;
      memoExtraProps.Lines.Text := ATb.ExtraProps;
      memoScriptRules.Lines.Text := ATb.ScriptRules;
      actTbGenDB.Checked := FCtMetaTable.GenDatabase;
      actTbGenCode.Checked := FCtMetaTable.GenCode;  
      MN_GenOption.Visible := True;

      TabSheetText.TabVisible := False;
      TabSheetTable.TabVisible := True;
      TabSheetDesc.TabVisible := True;      
      TabSheetUI.TabVisible := True;
      TabSheetOperLogic.TabVisible := ShowOperLogicPage;   
      TabSheetOperLogic.Tag := 1;
      TabSheetCodeGen.TabVisible := True;
      TabSheetData.TabVisible := True;
      TabSheetCust.TabVisible := G_EnableCustomPropUI;

      if FLastActiveTabSheet <> nil then
        if FLastActiveTabSheet.TabVisible then
          PageControlTbProp.ActivePage := FLastActiveTabSheet;
    end;

    RefreshFieldProps;
    RefreshUIPreview;
  finally
    FIniting := False;
  end;

  if PageControlTbProp.ActivePage = TabSheetData then
  begin
    ShowTableDataDelay;
  end;
end;

procedure TFrameCtTableProp.SpeedButton_FieldAddClick(Sender: TObject);
begin
  actFieldAddExecute(Sender);
end;

function TFrameCtTableProp.AddDxFieldNode(AField: TCtMetaField): integer;
begin
  Result := -1;
  if not Assigned(AField) or (AField.DataLevel = ctdlDeleted) then
    Exit;

  Result := StringGridTableFields.RowCount;
  StringGridTableFields.RowCount := Result + 1;
  SetDxFieldNode(AField, Result);
end;

procedure TFrameCtTableProp.btnEditScriptClick(Sender: TObject);

  function EditScriptFile(fn: string): boolean;
  begin
    Result := False;
    if not Assigned(scriptIdeEditor) then
      Application.CreateForm(TfrmScriptIDE, scriptIdeEditor);
    with scriptIdeEditor do
    begin
      DmlScInit(fn, FCtMetaTable, nil, FDmlScControls);
      ed.ClearAll;
      DmlScLoadFromFile(fn);
      ed.Modified := False;
      FileModified := False;
      ActiveFile := fn;
      ShowModal;       
      DmlScInit(fn, nil, nil, nil);
      Result := FileModified;
    end;
  end;

begin
  if TDmlScriptControlList(FDmlScControls).CurFileName = '' then
    Exit;
  if EditScriptFile(TDmlScriptControlList(FDmlScControls).CurFileName) then
  begin
    TDmlScriptControlList(FDmlScControls).CurFileName := '';
    GenTbCode;
  end;
end;

procedure TFrameCtTableProp.btnSaveSettingsClick(Sender: TObject);
begin
  if TDmlScriptControlList(FDmlScControls).CurFileName = '' then
    Exit;
  TDmlScriptControlList(FDmlScControls).SaveSettings;
  TDmlScriptControlList(FDmlScControls).CurFileName := '';
  GenTbCode;
end;

procedure TFrameCtTableProp.btnShowSettingsClick(Sender: TObject);
begin
  if btnShowSettings.Tag = 0 then
  begin
    btnShowSettings.Tag := 1;
    btnShowSettings.Caption := StringReplace(btnShowSettings.Caption, '>>', '<<', []);
    Panel_ScriptSettings.Top := Panel_ScriptOpers.Top + Panel_ScriptOpers.Height;
    Panel_ScriptSettings.Visible := True;
    btnSaveSettings.Visible := True;
  end
  else
  begin
    btnShowSettings.Tag := 0;
    btnShowSettings.Caption := StringReplace(btnShowSettings.Caption, '<<', '>>', []);
    Panel_ScriptSettings.Visible := False;
    btnSaveSettings.Visible := False;
  end;
end;

procedure TFrameCtTableProp.btnViewInBrowserClick(Sender: TObject);
  function ExtractCompStrCp(str: string; s1, s2: string): String;
  var
    po1, po2: Integer;
  begin
    //找第一个s1和最后一个s2中间的内容
    Result:='';
    po1:=Pos(s1, str);
    if po1=0 then
      Exit;
    str := Copy(str, po1+Length(s1), Length(str));
      
    po2:=LastPos(s2, str);
    if po2=0 then
      Exit;
    Result := Copy(str, 1, po2-1);
  end;
var
  fn, tfn, S, T, V: string;
  ss: TStringList;
begin
  if FGenCodeType = '' then
    Exit;

  fn := FGenCodeType;
  if (Pos('_html.', LowerCase(fn + '.txt')) = 0) and
    (Pos('_md.', LowerCase(fn + '.txt')) > 0) and
    (Pos('_vue.', LowerCase(fn + '.txt')) = 0) then
  begin             
    tfn := Trim(ExtractCompStrCp(MemoCodeGen.Lines.Text, '<!-- EZDML_PREVIEW_HTML:', ' -->'));
    if tfn='' then
      tfn := 'MarkdownPreview.html';
    tfn := FolderAddFileName(GetDmlScriptDir, tfn);
    if not FileExists(tfn) then
      raise Exception.Create(Format(srEzdmlFileNotFoundFmt, [tfn]));
    ss := TStringList.Create;
    try
      ss.LoadFromFile(tfn);
      S := ss.Text;
      T := MemoCodeGen.Lines.Text;
      if Pos('%MARKDOWN_TEXT%', S) > 0 then
        S := StringReplace(S, '%MARKDOWN_TEXT%', T, [rfReplaceAll]);
      ss.Text := S;
      fn := FolderAddFileName(GetAppDefTempPath, fn + '.html');
      ss.SaveToFile(fn);
      CtOpenDoc(PChar(fn));
    finally
      ss.Free;
    end;
    Exit;
  end;

  if (Pos('_html.', LowerCase(fn + '.txt')) = 0) and
    (Pos('_md.', LowerCase(fn + '.txt')) = 0) and
    (Pos('_vue.', LowerCase(fn + '.txt')) > 0) then
  begin
    tfn := Trim(ExtractCompStrCp(MemoCodeGen.Lines.Text, '<!-- EZDML_PREVIEW_HTML:', ' -->'));
    if tfn='' then
      tfn := 'vue_preview.html';
    tfn := FolderAddFileName(GetDmlScriptDir, tfn);
    if not FileExists(tfn) then
      raise Exception.Create(Format(srEzdmlFileNotFoundFmt, [tfn]));
    ss := TStringList.Create;
    try
      ss.LoadFromFile(tfn);
      S := ss.Text;
      T := MemoCodeGen.Lines.Text;
      if Pos('%VUE_TEMPLATE%', S) > 0 then
      begin
        V := ExtractCompStrCp(T, '<template>', '</template>');
        S := StringReplace(S, '%VUE_TEMPLATE%', V, [rfReplaceAll]);
      end;

      if Pos('%VUE_APP_SCRIPT%', S) > 0 then
      begin
        V := ExtractCompStrCp(T, '<script>', '</script>');
        if Pos('export default vueAppInfo;', V)>0 then
          V := StringReplace(V, 'export default vueAppInfo;', '/* export default vueAppInfo; */', []);
        S := StringReplace(S, '%VUE_APP_SCRIPT%', V, [rfReplaceAll]);
      end;

      if Pos('%VUE_STYLE%', S) > 0 then    
      begin                          
        V := ExtractCompStrCp(T, '<style>', '</style>');
        S := StringReplace(S, '%VUE_STYLE%', V, [rfReplaceAll]);
      end;
      ss.Text := S;
      fn := FolderAddFileName(GetAppDefTempPath, fn + '.html');
      ss.SaveToFile(fn);
      CtOpenDoc(PChar(fn));
    finally
      ss.Free;
    end;
    Exit;
  end;

  fn := FolderAddFileName(GetAppDefTempPath, fn + '.html');
  MemoCodeGen.Lines.SaveToFile(fn);
  CtOpenDoc(PChar(fn)); { *Converted from ShellExecute* }
end;

procedure TFrameCtTableProp.ckbIsSqlTextClick(Sender: TObject);
var
  S: string;
begin
  if FIniting then
    Exit;

  if ckbIsSqlText.Checked then
  begin
    S := MemoTextContent.Lines.Text;
    if Copy(S, 1, Length(DEF_SQLTEXT_MARK)) <> DEF_SQLTEXT_MARK then
    begin
      MemoTextContent.Lines.Insert(0, '/*[SQL]*/');
      FCtMetaTable.Memo := MemoTextContent.Lines.Text;
    end;
  end
  else
  begin
    S := MemoTextContent.Lines.Text;
    if Copy(S, 1, Length(DEF_SQLTEXT_MARK)) = DEF_SQLTEXT_MARK then
    begin
      S := Copy(S, Length(DEF_SQLTEXT_MARK) + 1, Length(S));
      if Copy(S, 1, 2) = #13#10 then
        S := Copy(S, 3, Length(S));
      MemoTextContent.Lines.Text := S;
      FCtMetaTable.Memo := MemoTextContent.Lines.Text;
    end;
  end;
end;


procedure TFrameCtTableProp.actFieldAddExecute(Sender: TObject);
var
  pctnode: TCtMetaObject;
  AField: TCtMetaField;
  I, C, idx1, idx2: integer;
begin
  if FReadOnlyMode then
    Exit;
  pctnode := Self.FCtMetaTable;
  if not (pctnode is TCtMetaTable) then
    Exit;
  FieldListHideEditor;
  if Sender <> nil then
  begin
    idx2 := StringGridTableFields.Row - 1;
    AField := TCtMetaTable(pctnode).MetaFields.NewMetaField;
    AddDxFieldNode(AField);
    idx1 := TCtMetaTable(pctnode).MetaFields.IndexOf(AField);
    if (idx2 >= 0) and (idx1 > idx2 + 1) then
    begin
      TCtMetaTable(pctnode).MetaFields.Move(idx1, idx2 + 1);
      StringGridTableFields.MoveColRow(False, idx1 + 1, idx2 + 2);
      StringGridTableFields.Row := idx2 + 2;
    end;
    TCtMetaTable(pctnode).MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, AField, nil, '');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
  end
  else
  begin
    AField := TCtMetaTable(pctnode).MetaFields.NewMetaField;
    if not Assigned(Proc_ShowCtFieldProp) then
      raise Exception.Create('Proc_ShowCtFieldProp not defined');
    C := FCtMetaTable.MetaFields.Count;
    if Proc_ShowCtFieldProp(AField, FReadOnlyMode) then
    begin
      AddDxFieldNode(AField);
      //SetDxFieldNode(AField, dNode);
      TCtMetaTable(pctnode).MetaFields.SaveCurrentOrder;
      DoTablePropsChanged(Self.FCtMetaTable);
      if Assigned(Proc_OnPropChange) then
        Proc_OnPropChange(0, AField, nil, '');
      with FCtMetaTable.MetaFields do
        for I := C to Count - 1 do
        begin
          AddDxFieldNode(Items[I]);
          if Assigned(Proc_OnPropChange) then
            Proc_OnPropChange(0, Items[I], nil, '');
        end;
      RefreshDesc;
      RefreshUIPreview;
      RefreshFieldProps;
    end
    else
      TCtMetaTable(pctnode).MetaFields.Remove(AField);
  end;

end;

procedure TFrameCtTableProp.actFieldDelExecute(Sender: TObject);
var
  AField: TCtMetaField;
  ARowIndex: integer;
  I: Integer;
begin
  if FReadOnlyMode then
    Exit;          
  GetSelectedFields;
  if FSelFields.Count <= 1 then
  begin
    ARowIndex := StringGridTableFields.Row;
    if ARowIndex <= 0 then
      Exit;
    AField := FieldOfGridRow(ARowIndex);
    AField.DataLevel := ctdlDeleted;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, AField, nil, '');
    Self.FCtMetaTable.MetaFields.Pack;
    FSelFields.Clear;
    StringGridTableFields.DeleteRow(ARowIndex); 
    DoTablePropsChanged(FCtMetaTable);
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
    Exit;
  end;
           
  FieldListHideEditor;
  for I:=0 to FSelFields.Count - 1 do
  begin
    ARowIndex := RowIndexOfField(FSelFields[I]);
    if ARowIndex <= 0 then
      Continue;
    AField := FieldOfGridRow(ARowIndex);
    AField.DataLevel := ctdlDeleted;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, AField, nil, '');
    Self.FCtMetaTable.MetaFields.Pack;
    StringGridTableFields.DeleteRow(ARowIndex);
  end;                                 
  FSelFields.Clear;
  StringGridTableFields.ClearSelections;  
  DoTablePropsChanged(FCtMetaTable);
  RefreshDesc;
  RefreshUIPreview;
  RefreshFieldProps;
end;

procedure TFrameCtTableProp.actFieldMoveTopExecute(Sender: TObject);
begin                    
  if FReadOnlyMode then
    Exit;
  MoveDxField(StringGridTableFields.Row, -2);
end;

procedure TFrameCtTableProp.actFieldMoveUpExecute(Sender: TObject);  
var
  ARowIndex: integer;
  I: Integer;
begin
  if FReadOnlyMode then
    Exit;
  GetSelectedFields;
  if FSelFields.Count <= 1 then
  begin
    MoveDxField(StringGridTableFields.Row, -1); 
    Exit;
  end;
          
  FSelFields.SortByOrderNo;
  for I:=0 to FSelFields.Count - 1 do
  begin      
    ARowIndex := RowIndexOfField(FSelFields[I]);
    if ARowIndex <= 0 then
      Continue;
    if ARowIndex <= 1 then
      Break;
    MoveDxField(ARowIndex, -1);
  end;
  RestoreSelectionFeilds;
end;

procedure TFrameCtTableProp.actFieldMoveDownExecute(Sender: TObject); 
var
  ARowIndex: integer;
  I: Integer;
begin
  if FReadOnlyMode then
    Exit;
  GetSelectedFields;
  if FSelFields.Count <= 1 then
  begin
    MoveDxField(StringGridTableFields.Row, 1);  
    Exit;
  end;

  FSelFields.SortByOrderNo;
  for I:= FSelFields.Count - 1 downto 0 do
  begin
    ARowIndex := RowIndexOfField(FSelFields[I]);
    if ARowIndex <= 0 then
      Continue;
    if ARowIndex >= StringGridTableFields.RowCount - 1 then
      Break;
    MoveDxField(ARowIndex, 1);
  end;
  RestoreSelectionFeilds;
end;

procedure TFrameCtTableProp.actFieldMoveBottomExecute(Sender: TObject);
begin
  if FReadOnlyMode then
    Exit;
  MoveDxField(StringGridTableFields.Row, 2);
end;

procedure TFrameCtTableProp.MoveDxField(ARowIndex, iMode: integer);

  function GetLVNode(idx: integer): integer;
  begin
    Result := -1;
    if idx <= 0 then
      Exit
    else if idx > StringGridTableFields.RowCount - 1 then
      Exit;

    Result := idx;
  end;

var
  SrcNode, TgNode: integer;
  i1, i2: integer;
  oList: TCtObjectList;
  ctNodeC: TCtMetaField;
begin
  //mode -2top -1up 1down 2bottom
  if ARowIndex <= 0 then
    Exit;
  SrcNode := ARowIndex;

  ctNodeC := FieldOfGridRow(SrcNode);

  oList := ctNodeC.OwnerList;
  i1 := oList.IndexOf(ctNodeC);

  if iMode = 1 then
    TgNode := GetLVNode(SrcNode + 1)
  else if iMode = -1 then
    TgNode := GetLVNode(SrcNode - 1)
  else if iMode = 2 then
    TgNode := GetLVNode(StringGridTableFields.RowCount - 1)
  else if iMode = -2 then
    TgNode := GetLVNode(1)
  else
    TgNode := -1;
  if TgNode <= 0 then
    Exit;
  i2 := oList.IndexOf(FieldOfGridRow(TgNode));

  oList.Move(i1, i2);
  StringGridTableFields.MoveColRow(False, SrcNode, TgNode);
  oList.SaveCurrentOrder;

  DoTablePropsChanged(Self.FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(1, ctNodeC, FieldOfGridRow(TgNode), '[MoveTreeNodeOnly]');
  RefreshDesc;
  RefreshUIPreview;
  RefreshFieldProps;
end;

procedure TFrameCtTableProp.PageControlTbPropChanging(Sender: TObject;
  var AllowChange: boolean);
begin
  if MemoTableComment.Focused then
    MemoTableCommentExit(nil)
  else if edtTableName.Focused or edtDispName.Focused then
    edtTableNameExit(nil);
  FieldListHideEditor;
end;

procedure TFrameCtTableProp.pmCopyAsCClick(Sender: TObject);
begin
  CopyTextAs('C');
end;

procedure TFrameCtTableProp.pmCopyAsCppClick(Sender: TObject);
begin
  CopyTextAs('CPP');
end;

procedure TFrameCtTableProp.pmCopyAsCSharpClick(Sender: TObject);
begin
  CopyTextAs('CSHARP');
end;

procedure TFrameCtTableProp.pmCopyAsDelphiClick(Sender: TObject);
begin
  CopyTextAs('DELPHI');
end;

procedure TFrameCtTableProp.pmCopyAsJavaClick(Sender: TObject);
begin
  CopyTextAs('JAVA');
end;

procedure TFrameCtTableProp.pmCopyAsPLSqlClick(Sender: TObject);
begin
  CopyTextAs('PLSQL');
end;

procedure TFrameCtTableProp.PopupMenuGenMemoPopup(Sender: TObject);
begin
  FieldListHideEditor;
  pmSpecCopy.Enabled := MemoCodeGen.SelLength > 0;
end;

procedure TFrameCtTableProp.actFieldPropExecute(Sender: TObject);
var
  AField: TCtMetaField;
  ARowIndex: integer;
begin
  ARowIndex := StringGridTableFields.Row;
  if ARowIndex <= 0 then
    Exit;

  FieldListHideEditor;

  AField := FieldOfGridRow(ARowIndex);

  if not Assigned(Proc_ShowCtFieldProp) then
    raise Exception.Create('Proc_ShowCtFieldProp not defined');
  if Proc_ShowCtFieldProp(AField, FReadOnlyMode) then
  begin
    SetDxFieldNode(AField, ARowIndex);
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, AField, nil, '');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
  end;
end;

procedure TFrameCtTableProp.actSortFieldsByNameExecute(Sender: TObject);
var
  S: string;
begin
  if not Assigned(FCtMetaTable) then
    Exit;
  if FIniting then
    Exit;
  if Application.MessageBox(PChar(srConfirmSortFieldsByName), PChar(Application.Title),
    MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;
  S := FCtMetaTable.Describe;
  FCtMetaTable.MetaFields.SortByName;
  if FCtMetaTable.Describe = S then
    Exit;
  FCtMetaTable.MetaFields.SaveCurrentOrder;
  DoTablePropsChanged(FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(2, FCtMetaTable, nil, '');
  ShowTableProp(FCtMetaTable);
end;

procedure TFrameCtTableProp.edtTableNameExit(Sender: TObject);
begin
  if FCtMetaTable = nil then
    Exit;  
  if Self.FReadOnlyMode then
    Exit;
  if FCtMetaTable.Name = edtTableName.Text then
    if FCtMetaTable.Caption = edtDispName.Text then
      Exit;
  if Assigned(Proc_OnPropChange) and (Sender = edtTableName) then
    if FCtMetaTable.Name <> edtTableName.Text then
    begin
      if not CheckCanRenameTable(FCtMetaTable, edtTableName.Text, False) then
      begin
        edtTableName.Text := FCtMetaTable.Name;
        edtTableName.SetFocus;
        Abort;
      end;
    end;
  FCtMetaTable.Name := edtTableName.Text;
  FCtMetaTable.Caption := edtDispName.Text;
  DoTablePropsChanged(FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(0, FCtMetaTable, nil, '');
  RefreshDesc;
  RefreshUIPreview;
  RefreshFieldProps;
end;

procedure TFrameCtTableProp.edtTextNameExit(Sender: TObject);
begin
  if FCtMetaTable = nil then
    Exit;
  if FCtMetaTable.Name <> edtTableName.Text then
  begin
    FCtMetaTable.Name := edtTextName.Text;
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, FCtMetaTable, nil, '');
  end;
end;

procedure TFrameCtTableProp.FieldListHideEditor;
begin
  if StringGridTableFields.EditorMode then
  begin
    try
      Self.SetFocus;
      StringGridTableFields.SetFocus;
    except
    end;
    if StringGridTableFields.EditorMode then
      StringGridTableFields.EditorMode := False;
  end;
  //if aoEditing in dxTreeListTableFields.Options then
  //dxTreeListTableFields.HideEditor;
end;

function TFrameCtTableProp.FieldOfGridRow(ARowIndex: integer): TCtMetaField;
begin
  if ARowIndex <= 0 then
    Result := nil
  else
    Result := TCtMetaField(StringGridTableFields.Objects[0, ARowIndex]);
end;

function TFrameCtTableProp.RowIndexOfField(AField: TCtMetaField): integer;
var
  I, C: integer;
begin
  Result := -1;
  if AField = nil then
    Exit;

  C := StringGridTableFields.RowCount;
  for I := 0 to C - 1 do
    if StringGridTableFields.Objects[0, I] = AField then
    begin
      Result := I;
      Exit;
    end;
end;

procedure TFrameCtTableProp._OnCellXYValSet(aCol, aRow: integer;
  var NewValue: string; bEvents: boolean);
var
  AField: TCtMetaField;
  tp, po: integer;
  S, T, V, oName, oDisp, oFieldTp, oFieldPhyTp, oDtName, oCons, oMemo, sDtName, sIdxFds, sRelTb, sRelFd: string;
begin
  if (ACol <= 0) or (ARow <= 0) then
    Exit;
  AField := FieldOfGridRow(aRow);
  oName := AField.Name;
  oDisp := AField.DisplayName;
  oFieldTp := AField.GetFieldTypeDesc;
  oFieldPhyTp := AField.GetFieldTypeDesc(True);
  oDtName := AField.DataTypeName;
  oCons := AField.GetConstraintStr;
  oMemo := AField.Memo;

  if aCol = 1 then
    AField.Name := NewValue;
  if aCol = 2 then
    AField.DisplayName := NewValue;

  if aCol = 3 then
  begin
    S := NewValue;
    T := AField.DataTypeName;
    tp := integer(AField.DataType);
    if tp > 0 then
      V := StringGridTableFields.Columns[3].PickList[tp]
    else
      V := AField.DataTypeName;
    if UpperCase(V) <> UpperCase(S) then
    begin
      AField.DataType := GetCtFieldDataTypeOfName(S);
      if AField.DataType = cfdtUnknow then
      begin
        AField.DataTypeName := S;
        AField.DataType := GetCtFieldDataTypeOfAlias(S);
      end
      else if AField.DataType = cfdtOther then
        AField.DataTypeName := T
      else
        AField.DataTypeName := '';
    end;
  end;


  if aCol = 4 then
  begin
    T := NewValue;
    if T = '' then
    begin
      AField.DataLength := 0;
      AField.DataScale := 0;
    end
    else
    begin
      po := Pos(',', T);
      if po = 0 then
      begin
        if T = 'LONG' then
          AField.DataLength := DEF_TEXT_CLOB_LEN
        else
          AField.DataLength := StrToIntDef(T, 0);
        AField.DataScale := 0;
      end
      else
      begin
        AField.DataLength := StrToIntDef(Trim(Copy(T, 1, po - 1)), 0);
        AField.DataScale := StrToIntDef(Trim(Copy(T, po + 1, Length(T))), 0);
      end;
    end;
  end;

  if aCol = 5 then
  begin
    sDtName := AField.DataTypeName;
    sIdxFds := AField.IndexFields;
    sRelTb := AField.RelateTable;
    sRelFd := AField.RelateField;
    AField.SetConstraintStr(NewValue);
    AField.DataTypeName:=sDtName;
    AField.IndexFields:=sIdxFds;
    AField.RelateTable:=sRelTb;
    AField.RelateField:=sRelFd;
  end;
  if aCol = 6 then
    AField.Memo := NewValue;

  if not bEvents then
    Exit;

  DoTablePropsChanged(Self.FCtMetaTable);

  if (oName <> AField.Name)
    or (oDisp <> AField.DisplayName)
    or (oFieldTp <> AField.GetFieldTypeDesc)
    or (oFieldPhyTp <> AField.GetFieldTypeDesc(True))
    or (oDtName <> AField.DataTypeName)
    or (oCons <> AField.GetConstraintStr)
    or (oMemo <> AField.Memo) then
  begin
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, AField, nil, '');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
  end;
end;

procedure TFrameCtTableProp._OnUIPropChanged(Field, prop, Value, par1,
  par2, opt: string);

  procedure DoFieldChanged(fd: TCtMetaField);
  begin
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(fd) and Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, fd, nil, '');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
  end;

  function GetBoolPropV(bSrc: boolean): boolean;
  begin
    if Value = '1' then
      Result := True
    else if Value = '0' then
      Result := False
    else
      Result := not bSrc;
  end;

  function FieldMatch(fd: TCtMetaField; tp: string): boolean;
  begin
    Result:=True;
    if tp='all' then
      Exit;
    if (tp='grid') or (tp='sheet') or (tp='card') then
    begin
      Result := fd.CanDisplay(tp);
      Exit;
    end;
    if tp='query' then
    begin
      Result := fd.Queryable;
      Exit;
    end;   
    if tp='fastsearch' then
    begin
      Result := fd.Searchable;
      Exit;
    end;        
    if tp='required' then
    begin
      Result := fd.IsRequired;
      Exit;
    end;
    if tp='hidden' then
    begin
      Result := (fd.IsHidden or not fd.CanDisplay('grid,sheet,card'));
      Exit;
    end;
  end;

var
  fd, fd2: TCtMetaField;
  I, idx, i1, i2: integer;
begin
  if FCtMetaTable = nil then
    Exit;
  fd := FCtMetaTable.MetaFields.FieldByName(Field);
  if fd = nil then
    fd := FCtMetaTable.MetaFields.FieldByLabelName(Field);
  idx := Self.RowIndexOfField(fd);

  if prop = 'toggle_dml_graph' then
  begin
    actShowInGraph.Execute;
    Exit;
  end;

  if prop = 'selected' then
  begin
    if fd = nil then
      Exit;
    if idx < 0 then
      Exit;
    StringGridTableFields.Row := idx;
    Exit;
  end;

  if prop = 'index_position' then
  begin
    if fd = nil then
      Exit;
    if idx < 0 then
      Exit;
    i1 := FCtMetaTable.MetaFields.IndexOf(fd);
    if par2 <> '' then
    begin
      fd2 := FCtMetaTable.MetaFields.FieldByName(par2);
      if fd2 = nil then
        fd2 := FCtMetaTable.MetaFields.FieldByLabelName(par2);
      i2 := FCtMetaTable.MetaFields.IndexOf(fd2);
      if i2 > i1 then
        i2 := i2 - 1;
      FCtMetaTable.MetaFields.Move(i1, i2);
      StringGridTableFields.MoveColRow(False, i1 + 1, i2 + 1);
      StringGridTableFields.Row := i2 + 1;
    end
    else if par1 <> '' then
    begin
      fd2 := FCtMetaTable.MetaFields.FieldByName(par1);
      if fd2 = nil then
        fd2 := FCtMetaTable.MetaFields.FieldByLabelName(par1);
      i2 := FCtMetaTable.MetaFields.IndexOf(fd2);
      FCtMetaTable.MetaFields.Move(i1, i2);
      StringGridTableFields.MoveColRow(False, i1 + 1, i2 + 1);
      StringGridTableFields.Row := i2 + 1;
    end
    else
      Exit;

    FCtMetaTable.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(1, fd, fd2, '[MoveTreeNodeOnly]');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
    Exit;
  end;

  if prop = 'move_index' then
  begin
    if fd = nil then
      Exit;
    if idx < 0 then
      Exit;
    i1 := FCtMetaTable.MetaFields.IndexOf(fd);
    if par1='' then
      par1 := 'sheet';
    if Value = 'top' then
    begin
      i2 := 0;
      //表单中置顶时，要一直找到能在表单中显示的
      while i2 < FCtMetaTable.MetaFields.Count - 1 do
      begin
        if FieldMatch(FCtMetaTable.MetaFields[i2],par1) then
          Break;
        Inc(I2);
      end;
    end
    else if Value = 'bottom' then
    begin
      i2 := FCtMetaTable.MetaFields.Count - 1;
      //表单中置底时，要一直找到能在表单中显示的
      while i2 > 0 do
      begin
        if FieldMatch(FCtMetaTable.MetaFields[i2],par1) then
          Break;
        Dec(I2);
      end;
    end
    else if Value = 'up' then
    begin
      i2 := i1 - 1;
      //表单中上移时，要一直找到能在表单中显示的
      while i2 > 0 do
      begin
        if FieldMatch(FCtMetaTable.MetaFields[i2], par1) then
          Break;
        Dec(I2);
      end;
    end
    else if Value = 'down' then
    begin
      i2 := i1 + 1;
      //表单中下移时，要一直找到能在表单中显示的
      while i2 < FCtMetaTable.MetaFields.Count do
      begin
        if FieldMatch(FCtMetaTable.MetaFields[i2], par1) then
          Break;
        Inc(I2);
      end;
    end
    else
      Exit;

    if i2 < 0 then
      i2 := 0;
    if i2 = i1 then
      Exit;

    if i2 < FCtMetaTable.MetaFields.Count then
    begin
      fd2 := FCtMetaTable.MetaFields[i2];
      FCtMetaTable.MetaFields.Move(i1, i2);
      StringGridTableFields.MoveColRow(False, i1 + 1, i2 + 1);
      StringGridTableFields.Row := i2 + 1;
    end
    else
    begin
      fd2 := FCtMetaTable.MetaFields[FCtMetaTable.MetaFields.Count - 1];
      i2 := FCtMetaTable.MetaFields.IndexOf(fd2);
      FCtMetaTable.MetaFields.Move(i1, i2);
      StringGridTableFields.MoveColRow(False, i1 + 1, i2 + 1);
      StringGridTableFields.Row := i2 + 1;
    end;

    FCtMetaTable.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(1, fd, fd2, '[MoveTreeNodeOnly]');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
    Exit;
  end;

  if prop = 'drag_drop' then
  begin
    if fd = nil then
      Exit;
    if idx < 0 then
      Exit;
    i1 := FCtMetaTable.MetaFields.IndexOf(fd);

    fd2 := FCtMetaTable.MetaFields.FieldByName(Value);
    if fd2 = nil then
      fd2 := FCtMetaTable.MetaFields.FieldByLabelName(Value);
    if fd2 = nil then
      Exit;
    i2 := FCtMetaTable.MetaFields.IndexOf(fd2);

    if i2 < 0 then
      i2 := 0;
    if i2 = i1 then
      Exit;

    if i2 < FCtMetaTable.MetaFields.Count then
    begin
      fd2 := FCtMetaTable.MetaFields[i2];
      FCtMetaTable.MetaFields.Move(i1, i2);
      StringGridTableFields.MoveColRow(False, i1 + 1, i2 + 1);
      StringGridTableFields.Row := i2 + 1;
    end
    else
    begin
      fd2 := FCtMetaTable.MetaFields[FCtMetaTable.MetaFields.Count - 1];
      i2 := FCtMetaTable.MetaFields.IndexOf(fd2);
      FCtMetaTable.MetaFields.Move(i1, i2);
      StringGridTableFields.MoveColRow(False, i1 + 1, i2 + 1);
      StringGridTableFields.Row := i2 + 1;
    end;

    FCtMetaTable.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(1, fd, fd2, '[MoveTreeNodeOnly]');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
    Exit;
  end;
            
  if prop = 'table_changed' then
  begin                                                     
    FCtMetaTable.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);              
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(2, FCtMetaTable, nil, '');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
    Exit;
  end;
              
  if prop = 'field_changed' then
  begin            
    if fd = nil then
      Exit;
    DoFieldChanged(fd);
    Exit;
  end;

  if prop = 'show_props' then
  begin
    if fd = nil then
      Exit;
    if idx < 0 then
      Exit;
    StringGridTableFields.Row := idx;
    actFieldProp.Execute;
    Exit;
  end;

  if prop = 'ColWidth' then
  begin
    if fd = nil then
      Exit;
    i1 := StrToIntDef(Value, -1);
    if i1 >= 0 then
    begin
      fd.ColWidth := i1;
      DoFieldChanged(fd);
    end;
  end;
  if prop = 'Visibility' then
  begin
    if fd = nil then
      Exit;
    i1 := StrToIntDef(Value, -1);
    if i1 >= 0 then
    begin
      fd.Visibility := i1;
      DoFieldChanged(fd);
    end;
  end;
  if prop = 'EditorType' then
  begin
    if fd = nil then
      Exit;
    if Value <> fd.EditorType then
    begin
      fd.EditorType := Value;
      DoFieldChanged(fd);
    end;
  end;
  if prop = 'TextAlignment' then
  begin
    if fd = nil then
      Exit;
    i1 := StrToIntDef(Value, -1);
    if i1 >= 0 then
    begin
      fd.TextAlign := TCtTextAlignment(i1);
      DoFieldChanged(fd);
    end;
  end;
  if prop = 'ReadOnly' then
  begin
    if fd = nil then
      Exit;
    fd.EditorReadOnly := GetBoolPropV(fd.EditorReadOnly);
    DoFieldChanged(fd);
  end;
  if prop = 'Enabled' then
  begin
    if fd = nil then
      Exit;
    fd.EditorEnabled := GetBoolPropV(fd.EditorEnabled);
    DoFieldChanged(fd);
  end;
  if prop = 'Hidden' then
  begin
    if fd = nil then
      Exit;
    fd.IsHidden := GetBoolPropV(fd.IsHidden);
    DoFieldChanged(fd);
  end;
  if prop = 'Searchable' then
  begin
    if fd = nil then
      Exit;
    fd.Searchable := GetBoolPropV(fd.Searchable);
    DoFieldChanged(fd);
  end;
  if prop = 'Queryable' then
  begin
    if fd = nil then
      Exit;
    fd.Queryable := GetBoolPropV(fd.Queryable);
    DoFieldChanged(fd);
  end;
  if prop = 'Sortable' then
  begin
    if fd = nil then
      Exit;
    fd.ColSortable := GetBoolPropV(fd.ColSortable);
    DoFieldChanged(fd);
  end;

  if prop = '__ui_frame__reset_visibilities' then
  begin
    with FCtMetaTable.MetaFields do
      for I := 0 to Count - 1 do
      begin
        Items[I].Visibility := 0;
        Items[I].IsHidden := False;
      end;
    DoFieldChanged(nil);
  end;
end;

function TFrameCtTableProp.IsInnerSqlTab(tab: string): boolean;
var
  I: integer;
begin
  Result := False;
  for I := 0 to High(DEF_INNER_SQL_TABS) do
    if tab = DEF_INNER_SQL_TABS[I] then
    begin
      Result := True;
      Break;
    end;
end;

function TFrameCtTableProp.GetSelectedFields: TCTMetaFieldList;
var
  I, J: Integer;
  rc: TGridRect;
  fd: TCtMetaField;
begin
  FSelFields.Clear;
  with StringGridTableFields do
  begin
    for I := 0 to SelectedRangeCount - 1 do
    begin
      rc := SelectedRange[I];
      for J := rc.Top to rc.Bottom do
      begin
        fd := Self.FieldOfGridRow(J);
        if fd<>nil then
        begin
          if FSelFields.IndexOf(fd) < 0 then
            FSelFields.Add(fd);
        end;
      end;
    end;
  end;
  Result := FSelFields;
end;

procedure TFrameCtTableProp.RestoreSelectionFeilds;
var
  bFirst: Boolean;
  procedure AddARange(idx1, idx2: Integer);
  begin                                                                                      
    if bFirst then
      bFirst := False
    else
      TStringGridXX(StringGridTableFields).AddSelectedRange;
    StringGridTableFields.Selection := Rect(0, idx1, StringGridTableFields.ColCount-1, idx2);
  end;
var
  ARowIndex: integer;
  I, idx1, idx2: Integer;
begin
  idx1 := 0;
  idx2 := 0;
  bFirst := True;
  StringGridTableFields.ClearSelections;
  for I:=0 to FSelFields.Count - 1 do
  begin
    ARowIndex := RowIndexOfField(FSelFields[I]);
    if ARowIndex <= 0 then
      Continue;
    if idx1=0 then
    begin
      idx1 := ARowIndex;
      idx2 := idx1;
    end
    else if idx2 = (ARowIndex -1) then
      idx2 := ARowIndex
    else
    begin
      AddARange(idx1, idx2);
      idx1 := ARowIndex;
      idx2 := idx1;
    end;
  end;    
  if idx1>0 then  
    AddARange(idx1, idx2);
end;

procedure TFrameCtTableProp.CopySelectedFields(bCut: Boolean);
var
  I: integer;
  vFld: TCtMetaField;
  vTempFlds: TCtMetaFieldList;
  fs: TCtObjMemXmlStream;
  ss: TStringList;
begin           
  if bCut and FReadOnlyMode then
    Exit;        
  FieldListHideEditor;
  GetSelectedFields;

  if FSelFields.Count = 0 then
    Exit;

  vTempFlds := TCtMetaFieldList.Create;
  fs := TCtObjMemXmlStream.Create(False);
  ss := TStringList.Create;
  try
    for I := 0 to FSelFields.Count - 1 do
    begin
      vFld := vTempFlds.NewMetaField;
      vFld.AssignFrom(FSelFields[I]);
      vFld.GraphDesc := '';
    end;
    fs.RootName := 'Fields';
    vTempFlds.SaveToSerialer(fs);
    fs.EndXmlWrite;
    fs.Stream.Seek(0, soFromBeginning);
    ss.LoadFromStream(fs.Stream);
    Clipboard.AsText := ss.Text;
  finally
    vTempFlds.Free;
    fs.Free;
    ss.Free;
  end;
  if bCut then
    actFieldDelExecute(nil);
end;

procedure TFrameCtTableProp.MemoTableCommentExit(Sender: TObject);
begin
  if FCtMetaTable = nil then
    Exit;
  if Sender=nil then
    Exit;
  if Self.FReadOnlyMode then
    Exit;
  if Sender=MemoTableComment then
  begin
    if FCtMetaTable.Memo = MemoTableComment.Lines.Text then
      Exit;
    FCtMetaTable.Memo := MemoTableComment.Lines.Text; 
    RefreshDesc;
  end;       
  if Sender=edtUIDisplayText then
  begin
    if FCtMetaTable.UIDisplayText = edtUIDisplayText.Text then
      Exit;
    FCtMetaTable.UIDisplayText := edtUIDisplayText.Text;
  end;      
  if Sender=memoExtraSQL then
  begin
    if FCtMetaTable.ExtraSQL = memoExtraSQL.Lines.Text then
      Exit;
    FCtMetaTable.ExtraSQL := memoExtraSQL.Lines.Text;
  end;
  if Sender=MemoUILogic then
  begin
    if FCtMetaTable.UILogic = MemoUILogic.Lines.Text then
      Exit;
    FCtMetaTable.UILogic := MemoUILogic.Lines.Text;
  end;            
  if Sender=memoBusinessLogic then
  begin
    if FCtMetaTable.BusinessLogic = memoBusinessLogic.Lines.Text then
      Exit;
    FCtMetaTable.BusinessLogic := memoBusinessLogic.Lines.Text;
  end;
  if Sender=memoExtraProps then
  begin
    if FCtMetaTable.ExtraProps = memoExtraProps.Lines.Text then
      Exit;
    FCtMetaTable.ExtraProps := memoExtraProps.Lines.Text;
  end;          
  if Sender=memoScriptRules then
  begin
    if FCtMetaTable.ScriptRules = memoScriptRules.Lines.Text then
      Exit;
    FCtMetaTable.ScriptRules := memoScriptRules.Lines.Text;
  end;
  if Sender=ckbGenDatabase then
  begin
    if FCtMetaTable.GenDatabase = ckbGenDatabase.Checked then
      Exit;
    FCtMetaTable.GenDatabase := ckbGenDatabase.Checked;  
    actTbGenDB.Checked := FCtMetaTable.GenDatabase;
  end;   
  if Sender=ckbGenCode then
  begin
    if FCtMetaTable.GenCode = ckbGenCode.Checked then
      Exit;
    FCtMetaTable.GenCode := ckbGenCode.Checked;
    actTbGenCode.Checked := FCtMetaTable.GenCode;
  end;

  DoTablePropsChanged(FCtMetaTable);
end;

procedure TFrameCtTableProp.MemoTextContentExit(Sender: TObject);
begin
  if FCtMetaTable = nil then
    Exit;
  FCtMetaTable.Memo := MemoTextContent.Lines.Text;
end;

function TFrameCtTableProp.GetDmlScriptFiles: string;
var
  Sr: TSearchRec;
  AFolderName, ext: string;
begin
  Result := '';
  AFolderName := GetDmlScriptDir;
  if not DirectoryExists(AFolderName) then
    Exit;
  if FindFirst(FolderAddFileName(AFolderName, '*.*'),
    SysUtils.faAnyFile,
    //SysUtils.faAnyFile + SysUtils.faHidden + SysUtils.faSysFile + SysUtils.faDirectory + SysUtils.faArchive,
    Sr) = 0 then
    try
      repeat
        if (Sr.Name = '.') or (Sr.Name = '..') then
          Continue;
        if (Sr.Attr and SysUtils.faDirectory) <> 0 then
          Continue;

        ext := LowerCase(ExtractFileExt(Sr.Name));
        if (ext <> '.pas') and (ext <> '.js') then
          Continue;

        Result := Result + ChangeFileExt(SR.Name, '') + #13#10;
      until FindNext(Sr) <> 0;
    finally
      FindClose(Sr);
    end;
  Result := Trim(Result);
end;


function TFrameCtTableProp.GetDmlScriptOutput(fn: string;
  bReInitSettings: boolean): string;
var
  nfn: string;
begin
  Result := '';
  if FCtMetaTable = nil then
    Exit;

  nfn := FolderAddFileName(GetDmlScriptDir, fn + '.js');
  if FileExists(nfn) then
  begin
    Result := GetDmlScriptOutputEx(fn + '.js', bReInitSettings);
    Exit;
  end;

  nfn := FolderAddFileName(GetDmlScriptDir, fn + '.pas');
  if FileExists(nfn) then
  begin
    Result := GetDmlScriptOutputEx(fn + '.pas', bReInitSettings);
    Exit;
  end;

end;

function TFrameCtTableProp.GetDmlScriptOutputEx(fn: string;
  bReInitSettings: boolean): string;
var
  FileTxt, AOutput: TStrings;
  S, ofn: string;
begin
  Result := '';
  if FCtMetaTable = nil then
    Exit;
  ofn := fn;
  fn := FolderAddFileName(GetDmlScriptDir, fn);
  FileTxt := TStringList.Create;
  AOutput := TStringList.Create;
  if FReadOnlyMode then
    SetGParamValue('CurTablePropReadOnly', '1')
  else
    SetGParamValue('CurTablePropReadOnly', '0');
  with CreateScriptForFile(fn) do
    try
      FileTxt.LoadFromFile(fn);
      S := FileTxt.Text;
      ActiveFile := fn;
      if IsSPRule(S) then
      begin
        S := PreConvertSP(S);
        FileTxt.Text := S;
      end;
      if bReInitSettings then
      begin
        S := ExtractCompStr(FileTxt.Text, '(*[SettingsPanel]', '[/SettingsPanel]*)');
        if TDmlScriptControlList(FDmlScControls).CurFileName <> fn then
        begin
          //if UTF8Needed then
          //  S := Utf8Decode(S);
          TDmlScriptControlList(FDmlScControls).TextDesc := S;
          TDmlScriptControlList(FDmlScControls).CurFileName := fn;
          TDmlScriptControlList(FDmlScControls).ParentWnd := Panel_ScriptSettings;
          TDmlScriptControlList(FDmlScControls).RegenControls;
        end;
        btnShowSettings.Enabled := S <> '';
        btnEditScript.Enabled := True;
        btnViewInBrowser.Visible :=
          (LowerCase(Copy(ofn, 1, 4)) = 'html') or (Pos('_html.', LowerCase(ofn)) > 0) or
          (Pos('_md.', LowerCase(ofn)) > 0)or
          (Pos('_vue.', LowerCase(ofn)) > 0);
        btnSaveSettings.Enabled :=
          btnShowSettings.Enabled and (Panel_ScriptSettings.ControlCount > 0);
        if btnShowSettings.Tag = 0 then
        begin
          Panel_ScriptSettings.Visible := False;
          btnSaveSettings.Visible := False;
        end
        else
        begin
          Panel_ScriptSettings.Visible := btnShowSettings.Enabled;
          btnSaveSettings.Visible := True;
        end;
      end;

      Init('DML_SCRIPT', FCtMetaTable, AOutput, FDmlScControls);
      Exec('DML_SCRIPT', FileTxt.Text);
      Result := AOutput.Text;
      if (GetKeyState(VK_CONTROL) and $80) <> 0 then
        if (GetKeyState(VK_MENU) and $80) <> 0 then
          Application.MessageBox(PChar(FCtscriptStdOutPut.Text),
            PChar(Application.Title),
            MB_OK or MB_ICONINFORMATION);
    finally
      FileTxt.Free;
      AOutput.Free;
      Free;
    end;
end;

function TFrameCtTableProp.GetImageIndexOfCtNode(Nd: TCtObject;
  bSelected: boolean): integer;
begin
  Result := -1;
  if nd = nil then
    Exit;
  if (Nd is TCtMetaTable) then
    Result := 1
  else if (Nd is TCtMetaField) then
  begin
    if TCtMetaField(Nd).KeyFieldType = cfktID then
      Result := 20
    else
      Result := 2 + integer(TCtMetaField(Nd).DataType);
  end;
end;

procedure TFrameCtTableProp.SetActsEnable(bEnb: boolean);
var
  I: integer;
begin
  for I := 0 to ActionList1.ActionCount - 1 do
    if ActionList1.Actions[I] is TCustomAction then
      TCustomAction(ActionList1.Actions[I]).Enabled := bEnb;
end;

procedure TFrameCtTableProp.CheckGridEditingMode;
begin
  TimerGridEditingCheck.Enabled := False;
  TimerGridEditingCheck.Enabled := True;
end;

procedure TFrameCtTableProp.SetDxFieldNode(AField: TCtMetaField;
  ARowIndex: integer);
var
  rss: TStringList;
  S: string;
begin
  rss := TStringList.Create;
  try

    rss.Add('');
    rss.Add(AField.Name);
    rss.Add(AField.DisplayName);

    S := AField.DataTypeName;
    if S <> '' then
      if StringGridTableFields.Columns[3].PickList.IndexOf(S) < 0 then
        S := '';
    if S = '' then
    begin
      if AField.DataType = cfdtUnknow then
        S := ''
      else if ShouldUseEnglishForDML then
        S := AField.GetLogicDataTypeName
      else
        S := DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[AField.DataType];
    end;
    rss.Add(S);

    S := '';
    if AField.DataLength > 0 then
    begin
      if AField.DataScale > 0 then
        S := S + Format('%d,%d', [AField.DataLength, AField.DataScale])
      else if AField.DataLength >= DEF_TEXT_CLOB_LEN then
        S := S + 'LONG'
      else
        S := S + Format('%d', [AField.DataLength]);
    end;
    rss.Add(S);
    rss.Add(AField.GetConstraintStr);
    rss.Add(AField.Memo);
    StringGridTableFields.Rows[ARowIndex] := rss;
    StringGridTableFields.Objects[0, ARowIndex] := AField;
  finally
    rss.Free;
  end;
  {
  dNode.Values[0] := AField.Name;
  dNode.Values[1] := AField.DisplayName;

  tp := Integer(AField.DataType);
  S := '';
  if tp > 0 then
  begin
    if AField.DataTypeName <> '' then
      for I := 0 to dxTreeListTableFieldsColumn_fDataType.Items.Count - 1 do
        if dxTreeListTableFieldsColumn_fDataType.Items[I] = AField.DataTypeName then
        begin
          S := AField.DataTypeName;
          Break;
        end;
    if S = '' then
      S := dxTreeListTableFieldsColumn_fDataType.Items[tp];
  end
  else
    S := AField.DataTypeName;
  dNode.Values[2] := S;

  S := '';
  if AField.DataLength > 0 then
  begin
    if AField.DataScale > 0 then
      S := S + Format('%d,%d', [AField.DataLength, AField.DataScale])
    else if AField.DataLength >= DEF_TEXT_CLOB_LEN then
      S := S + 'LONG'
    else
      S := S + Format('%d', [AField.DataLength])
  end;
  dNode.Values[3] := S;

  dNode.Values[4] := AField.GetConstraintStr;

  dNode.Values[5] := AField.Memo;  }

  //tp := GetImageIndexOfCtNode(AField);
  //dNode.ImageIndex := tp;
  //dNode.SelectedIndex := tp;
  //dNode.Data := AField;
end;

procedure TFrameCtTableProp.actAddSysFieldsExecute(Sender: TObject);
begin
  if not Assigned(FCtMetaTable) then
    Exit;
  with TfrmAddCtFields.Create(nil) do
    try
      LoadFromTb(FCtMetaTable);
      if ShowModal = mrOk then
      begin
        SaveToTb(FCtMetaTable);
        DoTablePropsChanged(Self.FCtMetaTable);
        if Assigned(Proc_OnPropChange) then
          Proc_OnPropChange(2, FCtMetaTable, nil, '');
        RefreshProp;
      end;
    finally
      Free;
    end;
end;

procedure TFrameCtTableProp.MemoDescExit(Sender: TObject);
var
  tb: TCtMetaTable;
begin
  if not MemoDesc.Modified then
    Exit;
  if not Assigned(FCtMetaTable) then
    Exit;
  if FIniting then
    Exit;
  if FCtMetaTable.Describe = MemoDesc.Lines.Text then
    Exit;
  tb := TCtMetaTable.Create;
  try
    tb.Describe := MemoDesc.Lines.Text;   
    if Assigned(Proc_OnPropChange) then
      if FCtMetaTable.Name <> tb.Name then
      begin
        if not CheckCanRenameTable(FCtMetaTable, tb.Name, False) then
          Abort;
      end;
  finally
    tb.Free;
  end;
  FCtMetaTable.Describe := MemoDesc.Lines.Text;
  DoTablePropsChanged(FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(2, FCtMetaTable, nil, '');
  ShowTableProp(FCtMetaTable);
end;

procedure TFrameCtTableProp.GenTbCode;
var
  T, S: string;
begin
  MemoCodeGen.Lines.Clear;
  if PageControlTbProp.ActivePage <> TabSheetCodeGen then
  begin
    TabSheetCodeGen.Tag := 999;
    Exit;
  end;  
  TabSheetCodeGen.Tag := 0;
  if FGenCodeType = '' then
    Exit;
  if FCtMetaTable = nil then
    Exit;
  if not IsInnerSqlTab(FGenCodeType) then
  begin
    T := FGenCodeType;
    MemoCodeGen.Lines.Text := GetDmlScriptOutput(T);
    TabSheetCodeGen.Realign;
    Exit;
  end;

  btnShowSettings.Enabled := False;
  btnEditScript.Enabled := False;
  btnSaveSettings.Enabled := False;
  Panel_ScriptSettings.Visible := False;
  btnViewInBrowser.Visible := False;
  TDmlScriptControlList(FDmlScControls).CurFileName := '';
  T := FGenCodeType;
  if T = 'Oracle' then
    S := '/** Oracle Sql Generate **/'#13#10#13#10 +
      FCtMetaTable.GenSql('ORACLE') + #13#10 + FCtMetaTable.GenDqlDmlSql('ORACLE')
  else if T = 'MySql' then
    S := '/** MySql Sql Generate **/'#13#10#13#10 +
      FCtMetaTable.GenSql('MYSQL') + #13#10 + FCtMetaTable.GenDqlDmlSql('MYSQL')
  else if T = 'SQLServer' then
    S := '/** SQLServer Sql Generate **/'#13#10#13#10 +
      FCtMetaTable.GenSql('SQLSERVER') + #13#10 + FCtMetaTable.GenDqlDmlSql('SQLSERVER')
  else if T = 'SQLite' then
    S := '/** SQLite Sql Generate **/'#13#10#13#10 +
      FCtMetaTable.GenSql('SQLITE') + #13#10 + FCtMetaTable.GenDqlDmlSql('SQLITE')
  else if T = 'PostgreSQL' then
    S := '/** PostgreSQL Sql Generate **/'#13#10#13#10 +
      FCtMetaTable.GenSql('POSTGRESQL') + #13#10 +
      FCtMetaTable.GenDqlDmlSql('POSTGRESQL')
  else
    S := '/** Sql Generate **/'#13#10#13#10 +
      FCtMetaTable.GenSql + #13#10 + FCtMetaTable.GenDqlDmlSql;
  MemoCodeGen.Lines.Text := S;
  TabSheetCodeGen.Realign;
end;


procedure TFrameCtTableProp.TabSheetDataShow(Sender: TObject);
begin
  ShowTableDataDelay;
end;


procedure TFrameCtTableProp.TimerGridEditingCheckTimer(Sender: TObject);
begin
  TimerGridEditingCheck.Enabled := False;
  if StringGridTableFields.EditorMode then
  begin
    StringGridTableFields.Options := StringGridTableFields.Options + [goAlwaysShowEditor] - [goRowSelect, goRangeSelect];
    StringGridTableFields.RangeSelectMode := rsmSingle;
  end
  else
  begin
    StringGridTableFields.Options :=
      StringGridTableFields.Options - [goAlwaysShowEditor] + [goRowSelect, goRangeSelect];
    StringGridTableFields.RangeSelectMode := rsmMulti;
  end;
end;

procedure TFrameCtTableProp.TabSheetCustShow(Sender: TObject);
begin
  if not FSCInited then
    RunCustomScriptDef(True);
end;


procedure TFrameCtTableProp.StringGridTableFieldsDblClick(Sender: TObject);
begin
  if (GetKeyState(VK_CONTROL) and $80) <> 0 then
    if btnShowInGraph.Visible then
    begin
      actShowInGraph.Execute;
      Exit;
    end;

  if (GetKeyState(VK_MENU) and $80) = 0 then
  begin
    //if not PanelFieldProps.Visible then
    actFieldProp.Execute;
  end
  else
  begin
    PanelFieldProps.Visible := not PanelFieldProps.Visible;
    Self.FrameResize(nil);
  end;
  TStringGridXX(StringGridTableFields).GridFlags :=
    TStringGridXX(StringGridTableFields).GridFlags - [gfAutoEditPending];
end;

procedure TFrameCtTableProp.StringGridTableFieldsDragDrop(Sender,
  Source: TObject; X, Y: integer);

  function GetLVNode(idx: integer): integer;
  begin
    Result := -1;
    if idx <= 0 then
      Exit
    else if idx > StringGridTableFields.RowCount - 1 then
      Exit;

    Result := idx;
  end;

var
  SrcNode, TgNode: integer;
  i1, i2: integer;
  oList: TCtObjectList;
  ctNodeC: TCtMetaField;
  pt: TPoint;
begin
  if (Source <> StringGridTableFields) then
    Exit;
  if Self.FReadOnlyMode then
    Exit;

  SrcNode := StringGridTableFields.Row;

  ctNodeC := FieldOfGridRow(SrcNode);

  oList := ctNodeC.OwnerList;
  i1 := oList.IndexOf(ctNodeC);

  pt := StringGridTableFields.MouseToCell(Point(X, Y));
  TgNode := pt.Y;
  if TgNode = SrcNode then
    Exit;
  if TgNode <= 0 then
    Exit;
  i2 := oList.IndexOf(FieldOfGridRow(TgNode));

  oList.Move(i1, i2);
  StringGridTableFields.MoveColRow(False, SrcNode, TgNode);
  oList.SaveCurrentOrder;

  DoTablePropsChanged(Self.FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(1, ctNodeC, FieldOfGridRow(TgNode), '[MoveTreeNodeOnly]');
  RefreshDesc;
  RefreshUIPreview;
  RefreshFieldProps;
end;

procedure TFrameCtTableProp.StringGridTableFieldsDragOver(Sender,
  Source: TObject; X, Y: integer; State: TDragState; var Accept: boolean);
var
  pt: TPoint;
begin
  if Self.FReadOnlyMode then
  begin
    Accept := False;
    Exit;
  end;
  Accept := (Source = StringGridTableFields);
  pt := StringGridTableFields.MouseToCell(Point(X, Y));
  FGridDragFocusingRow := pt.Y;
  StringGridTableFields.Invalidate;
end;

procedure TFrameCtTableProp.actShowDescTextExecute(Sender: TObject);
begin
  if not Assigned(FCtMetaTable) then
    Exit;
  if FIniting then
    Exit;
  if not FCtMetaTable.IsTable then
    Exit;
  if not TabSheetDesc.TabVisible then
    Exit;
  try
    if PageControlTbProp.ActivePage <> TabSheetDesc then
    begin
      PageControlTbProp.ActivePage := TabSheetDesc;
      //MemoDesc.Show;
      MemoDesc.SetFocus;
    end
    else
    begin
      PageControlTbProp.ActivePage := TabSheetTable;
      StringGridTableFields.SetFocus;
    end;
  except
  end;
end;

procedure TFrameCtTableProp.actShowInGraphExecute(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 2, 0);
end;

procedure TFrameCtTableProp.actTbGenCodeExecute(Sender: TObject);
begin
  if not Assigned(FCtMetaTable) then
    Exit;
  if not FCtMetaTable.IsTable then
    Exit;          
  if Self.FReadOnlyMode then
    Exit;
  FCtMetaTable.GenCode:= not FCtMetaTable.GenCode;
  actTbGenCode.Checked := FCtMetaTable.GenCode;
  ckbGenCode.Checked := FCtMetaTable.GenCode;
  DoTablePropsChanged(FCtMetaTable);
end;

procedure TFrameCtTableProp.actTbGenDBExecute(Sender: TObject);
begin
  if not Assigned(FCtMetaTable) then
    Exit;
  if not FCtMetaTable.IsTable then
    Exit;  
  if Self.FReadOnlyMode then
    Exit;
  FCtMetaTable.GenDatabase:= not FCtMetaTable.GenDatabase;
  actTbGenDB.Checked := FCtMetaTable.GenDatabase;
  ckbGenDatabase.Checked := FCtMetaTable.GenDatabase;
  DoTablePropsChanged(FCtMetaTable);
end;


procedure TFrameCtTableProp.btnShowInGraphClick(Sender: TObject);
begin
  actShowInGraph.Execute;
end;


procedure TFrameCtTableProp.actImportFieldsExecute(Sender: TObject);
var
  res: TCtMetaObjectList;
  I: integer;
  fd: TCtMetaField;
  fIdx: integer;
begin
  if not Assigned(Proc_ShowCtDmlSearch) then
    raise Exception.Create('Proc_ShowCtDmlSearch not defined');

  FieldListHideEditor;

  res := TCtMetaObjectList.Create;
  try
    Proc_ShowCtDmlSearch(FGlobeDataModelList, res);
    if res.Count = 0 then
      Exit;

    fIdx := -1;
    for I := 0 to res.Count - 1 do
    begin
      if res[I] is TCtMetaField then
        if FCtMetaTable.MetaFields.FieldByName(TCtMetaField(res[I]).Name) = nil then
        begin
          fd := FCtMetaTable.MetaFields.NewMetaField;
          fd.AssignFrom(res[I] as TCtMetaField);
          fIdx := AddDxFieldNode(fd);
        end;
    end;

    if fIdx < 0 then
      Exit;
    StringGridTableFields.Row := fIdx;

    FCtMetaTable.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(2, FCtMetaTable, nil, '');

    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;

  finally
    res.Free;
  end;
end;

procedure TFrameCtTableProp.actNewComplexIndexExecute(Sender: TObject);
var
  V: string;
  pctnode: TCtMetaObject;
  AField: TCtMetaField;
begin
  if FReadOnlyMode then
    Exit;
  V := CtSelectFields(FCtMetaTable.Describe, '', '');
  if V = '' then
    Exit;
  FieldListHideEditor;

  pctnode := FCtMetaTable;


  AField := TCtMetaTable(pctnode).MetaFields.NewMetaField;
  AField.Name := Format(srNewComplexIndexNameFmt, [AField.ID]);
  AField.DisplayName := srNewComplexIndexDispName;
  AField.DataType := cfdtFunction;
  AField.IndexType := cfitNormal;
  AField.IndexFields := V;
  AField.Memo := V;
  AddDxFieldNode(AField);
  TCtMetaTable(pctnode).MetaFields.SaveCurrentOrder;
  DoTablePropsChanged(Self.FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(0, AField, nil, '');
  RefreshDesc;
  RefreshUIPreview;
  RefreshFieldProps;

  StringGridTableFields.Row := StringGridTableFields.RowCount - 1;
end;

procedure TFrameCtTableProp.actPasteFromExcelExecute(Sender: TObject);

  procedure SetCellText(ARow, ACol: integer; AValue: string; bPost: boolean);
  var
    po: integer;
    vTp, vSz: string;
  begin
    if (ARow < 1) then
      Exit;
    while (StringGridTableFields.RowCount <= ARow) do
    begin
      StringGridTableFields.Row := StringGridTableFields.RowCount - 1;
      actFieldAddExecute(actPasteFromExcel);
      StringGridTableFields.Row := StringGridTableFields.RowCount - 1;
    end;
    if (ACol = 3) and (Pos('(', AValue) > 0) and (AValue[Length(AValue)] = ')') and
      bPost then
    begin
      po := Pos('(', AValue);
      vTp := Copy(AValue, 1, po - 1);
      vSz := Copy(AValue, po + 1, Length(AValue) - po - 1);
      StringGridTableFields.Cells[ACol, ARow] := vTp;
      _OnCellXYValSet(ACol, ARow, AValue, False);
      StringGridTableFields.Cells[ACol + 1, ARow] := vSz;
      _OnCellXYValSet(ACol + 1, ARow, AValue, False);
    end
    else
    begin
      StringGridTableFields.Cells[ACol, ARow] := AValue;
      _OnCellXYValSet(ACol, ARow, AValue, False);
    end;
  end;

var
  S: string;
  ss, sv: TStringList;
  I, J, x, y: integer;
begin
  S := Clipboard.AsText;
  if Trim(S) = '' then
    Exit;
  ss := TStringList.Create;
  sv := TStringList.Create;
  try
    ss.Text := S;
    x := StringGridTableFields.Col;
    y := StringGridTableFields.Row;
    if y <= 0 then
      y := 1;
    if x = 0 then
      x := 1;
    for I := 0 to ss.Count - 1 do
    begin
      sv.Text := StringReplace(ss[I], #9, #10, [rfReplaceAll]);
      for J := 0 to sv.Count - 1 do
      begin
        try
          SetCellText(y + I, x + J, sv[J], (J = sv.Count - 1));
        except
        end;
      end;
    end;

    FCtMetaTable.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(2, FCtMetaTable, nil, '');
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
  finally
    ss.Free;
    sv.Free;
  end;
end;

procedure TFrameCtTableProp.actShowAdvPageExecute(Sender: TObject);
begin
  ShowOperLogicPage := True;
  TabSheetOperLogic.TabVisible := ShowOperLogicPage;
  PageControlTbProp.ActivePage := TabSheetOperLogic;
end;

procedure TFrameCtTableProp.actFieldPropPanelExecute(Sender: TObject);
begin
  PanelFieldProps.Visible := not PanelFieldProps.Visible;
  actFieldPropPanel.Checked := PanelFieldProps.Visible;
  Self.FrameResize(nil);
end;

procedure TFrameCtTableProp.actFieldsCopyExecute(Sender: TObject);
begin
  CopySelectedFields(False);
end;

procedure TFrameCtTableProp.actFieldsCutExecute(Sender: TObject);
begin
  CopySelectedFields(True);
end;

procedure TFrameCtTableProp.actFieldsPasteExecute(Sender: TObject);
var
  sRow, I, J, idx: integer;
  vTempFlds: TCtMetaFieldList;
  fs: TCtObjMemXmlStream;
  ss: TStringList;
  S: string;
  tb: TCtMetaTable;
  fd: TCtMetaField;
  cto: TCtMetaObject;
begin
  if FReadOnlyMode then
    Exit;
  S := Clipboard.AsText;
  if S = '' then
    Exit;
  if Copy(S, 1, 5) <> '<?xml' then
    Exit;

  I := Pos('<Fields>', S);
  if (I <= 0) or (I > 100) then
    Exit;

  FieldListHideEditor;

  tb := Self.FCtMetaTable;

  vTempFlds := TCtMetaFieldList.Create;
  fs := TCtObjMemXmlStream.Create(True);
  ss := TStringList.Create;
  try
    ss.Text := S;
    ss.SaveToStream(fs.Stream);
    fs.Stream.Seek(0, soFromBeginning);
    fs.RootName := 'Fields';
    vTempFlds.LoadFromSerialer(fs);

    idx := -1;
    sRow := StringGridTableFields.Row;
    if sRow >0 then
    begin
      cto := FieldOfGridRow(sRow);
      idx := tb.MetaFields.IndexOf(cto);
    end;

    for I := 0 to vTempFlds.Count - 1 do
    begin
      fd := tb.MetaFields.FieldByName(vTempFlds[I].Name);
      if fd = nil then
        Continue;
      J := 1;
      while tb.MetaFields.FieldByName(vTempFlds[I].Name + '_'+srPasteCopySuffix+IfElse(J=1, '', IntToStr(J))) <> nil do
        Inc(J);
      vTempFlds[I].Name := vTempFlds[I].Name + '_'+srPasteCopySuffix+IfElse(J=1, '', IntToStr(J));
    end;

    for I := 0 to vTempFlds.Count - 1 do
    begin
      fd := tb.MetaFields.NewMetaField;
      fd.AssignFrom(vTempFlds[I]);
      fd.GraphDesc := '';

      if (idx >= 0) and (idx < tb.MetaFields.Count - 1) then
      begin
        Inc(idx);
        tb.MetaFields.Move(tb.MetaFields.Count - 1, idx);
      end;
    end;
    tb.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(2, FCtMetaTable, nil, '');
    ShowTableProp(FCtMetaTable);
    if sRow > 1 then
      StringGridTableFields.Row := sRow;
  finally
    vTempFlds.Free;
    fs.Free;
    ss.Free;
  end;
end;

procedure TFrameCtTableProp.actFieldsPasteUpdate(Sender: TObject);
var
  S: String;
  I: Integer;
begin
  if StringGridTableFields.EditorMode then
  begin
    actFieldsCut.Enabled := False;
    actFieldsCopy.Enabled := False;
    actFieldsPaste.Enabled := False;
    Exit;
  end;         
  actFieldsCopy.Enabled := True;
  if FReadOnlyMode then
  begin             
    actFieldsCut.Enabled := False;
    actFieldsPaste.Enabled := False;
    Exit;
  end;           
  actFieldsCut.Enabled := True;

  S := Clipboard.AsText;
  I := Pos('<Fields>', S);
  if (I <= 0) or (I > 100) then
    actFieldsPaste.Enabled := False
  else    
    actFieldsPaste.Enabled := True;
end;

procedure TFrameCtTableProp.actCopyExcelTextExecute(Sender: TObject);
begin
 {
var
  X, Y: Integer;
  S, T: String;
 S := FCtMetaTable.NameCaption;
  S := S+#13#10+ExtStr('-',WindowFuncs.DmlStrLength(S)-1,'-');

  T := '';
  for X := 1 to StringGridTableFields.Columns.Count - 1 do
  begin
    if X > 1 then
      T := T + #9;
    T := T + StringGridTableFields.Columns[X].Title.Caption;
  end;
  S:=S+#13#10+T;

  for Y := 1 to StringGridTableFields.RowCount - 1 do
  begin
    T := '';
    for X := 1 to StringGridTableFields.Columns.Count - 1 do
    begin
      if X > 1 then
        T := T + #9;
      T := T + StringGridTableFields.Cells[X, Y];
    end;
    S:=S+#13#10+T;
  end;  }

  ClipBoard.AsText := FCtMetaTable.ExcelText;
end;

procedure TFrameCtTableProp.FindDialogTxtFind(Sender: TObject);
var
  F, S, T: WideString;
  p1, p2: integer;
begin
  F := UpperCase(FindDialogTxt.FindText);
  if F = '' then
    Exit;
  T := UpperCase(MemoDesc.Lines.Text);
  p1 := MemoDesc.SelStart + MemoDesc.SelLength;
  S := Copy(T, p1 + 1, Length(T));
  p2 := Pos(F, S);
  if p2 > 0 then
  begin
    MemoDesc.SelStart := p1 + p2 - 1;
    MemoDesc.SelLength := Length(F);
  end
  else
    Application.MessageBox(PChar(srDmlSearchNotFound), PChar(Application.Title),
      MB_OK or MB_ICONINFORMATION);
end;


procedure TFrameCtTableProp.FrameResize(Sender: TObject);
begin
  if not Panel_TbB.Visible then
    Exit;

  if FFieldPropSplitPercent < 0.2 then
    FFieldPropSplitPercent := 0.2
  else if FFieldPropSplitPercent > 0.8 then
    FFieldPropSplitPercent := 0.8;
  if PanelFieldProps.Visible then
  begin
    if PanelFieldProps.Parent.ClientWidth > 100 then
      PanelFieldProps.Width :=
        Round(PanelFieldProps.Parent.ClientWidth * FFieldPropSplitPercent);

    if not SplitterFsProp.Visible then
    begin
      SplitterFsProp.Left := PanelFieldProps.Left - SplitterFsProp.Width - 1;
      SplitterFsProp.Visible := True;
    end;
  end
  else
  begin
    if SplitterFsProp.Visible then
      SplitterFsProp.Visible := False;
  end;

end;

procedure TFrameCtTableProp.lb_DescrbTipsClick(Sender: TObject);
begin
  if memoDescHelp.Visible then
  begin              
    SplitterDescHelp.Visible := False;
    memoDescHelp.Visible := False;
  end else
  begin
    memoDescHelp.Visible := True;
    SplitterDescHelp.Visible := True;   
    SplitterDescHelp.Left := memoDescHelp.Left - SplitterDescHelp.Width - 2;
  end;
end;

procedure TFrameCtTableProp.listboxGenTypesClick(Sender: TObject);
begin
  if listboxGenTypes.ItemIndex >= 0 then
    FGenCodeType := Trim(listboxGenTypes.Items[listboxGenTypes.ItemIndex])
  else
    FGenCodeType := '';
  GenTbCode;
end;


procedure TFrameCtTableProp.MemoCodeGenDblClick(Sender: TObject);
begin
  if (GetKeyState(VK_CONTROL) and $80) <> 0 then 
    actShowInGraph.Execute;
end;

procedure TFrameCtTableProp.MemoDescDblClick(Sender: TObject);
begin
  if (GetKeyState(VK_CONTROL) and $80) <> 0 then
    actShowInGraph.Execute;
end;

procedure TFrameCtTableProp.MemoDescKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
    if (Key = Ord('f')) or (Key = Ord('F')) then
      sbtnFindClick(nil);
end;

procedure TFrameCtTableProp.MemoTextContentDblClick(Sender: TObject);
begin
  if (GetKeyState(VK_CONTROL) and $80) <> 0 then
    actShowInGraph.Execute;
end;

procedure TFrameCtTableProp.MNGenTab_CustomizeClick(Sender: TObject);
var
  I: integer;
  SS1, ss2: TStrings;
  fn, S: string;  
  frmGenTabCust: TfrmGenTabCust;
begin
  SS1 := TStringList.Create;
  SS2 := TStringList.Create;   
  frmGenTabCust:=nil;
  try
    fn := FolderAddFileName(GetDmlScriptDir, 'gen_tabs.txt');
    if FileExists(fn) then
    begin
      SS1.LoadFromFile(fn);
      S := ss1.Text;
      if Copy(S, 1, 2) = #$FE#$FF then
        Delete(S, 1, 2)
      else if Copy(S, 1, 2) = #$FE#$FE then
        Delete(S, 1, 2)
      else if Copy(S, 1, 3) = #$EF#$BB#$BF then
        Delete(S, 1, 3);
      ss1.Text := S;
    end;

    SS2.Text := GetDmlScriptFiles;
    for I := High(DEF_INNER_SQL_TABS) downto 0 do
      SS2.Insert(0, DEF_INNER_SQL_TABS[I]);
             
    frmGenTabCust:= TfrmGenTabCust.Create(nil);
    frmGenTabCust.Init(ss1,ss2);
    if frmGenTabCust.ShowModal=mrOk then
    begin
      ss1.Clear;
      frmGenTabCust.GetConfigResult(ss1);
      ss1.SaveToFile(fn);
      Inc(G_TbPropTabInitTick);
      InitDmlScriptPages;
    end;
  finally
    SS2.Free;
    SS1.Free;
    if Assigned(frmGenTabCust) then
    FreeAndNil(frmGenTabCust);
  end;
end;

procedure TFrameCtTableProp.PageControlTbPropChange(Sender: TObject);
begin
  if (PageControlTbProp.ActivePage = TabSheetUI) then
  begin
    if TabSheetUI.Tag = 999 then
      RefreshUIPreview;
  end;
    
  if PageControlTbProp.ActivePage = TabSheetCodeGen then
  begin
    if TabSheetCodeGen.Tag = 999 then
      GenTbCode;
  end;
end;

procedure TFrameCtTableProp.PanelCustomScriptDefResize(Sender: TObject);
begin
  TDmlScriptControlList(FCustDmlScControls).RealignControls;
end;

procedure TFrameCtTableProp.Panel_ScriptSettingsResize(Sender: TObject);
begin
  TDmlScriptControlList(FDmlScControls).RealignControls;
end;

procedure TFrameCtTableProp.Panel_TbHResize(Sender: TObject);
var
  pd, pdr, sp, spv, lw, cw, aw, lh, dh: integer;
begin
  cw := Panel_TbH.ClientWidth;
  if cw < ScaleDPISize(100) then
    Exit;
  if FLastPanelTbH_Width = cw then
    Exit;
  FLastPanelTbH_Width := cw;
  pd := ScaleDPISize(6);
  pdr := ScaleDPISize(2);
  lw := ScaleDPISize(90);
  sp := ScaleDPISize(18);
  spv := ScaleDPISize(5);
  lh := ScaleDPISize(32);
  Label1.Left := pd;
  edtTableName.Left := pd + lw;
  if cw < ScaleDPISize(600) then
  begin
    aw := cw - lw - pd - pdr;
    edtTableName.Width := aw;

    Label4.Top := Label1.Top + lh;
    Label4.Left := pd;
    edtDispName.Top := edtTableName.Top + lh;
    edtDispName.Left := edtTableName.Left;
    edtDispName.Width := aw;

    Label2.Top := Label4.Top + lh;
    Label2.Left := pd;

    MemoTableComment.Left := edtTableName.Left;
    MemoTableComment.Width := aw;
    if MemoTableComment.Top <> edtDispName.Top + lh then
    begin
      MemoTableComment.Anchors := [akTop, akLeft];
      dh := MemoTableComment.Height;
      if dh<edtDispName.Height then
        dh := edtDispName.Height;
      MemoTableComment.Top := edtDispName.Top + lh;
      Panel_TbH.Height := MemoTableComment.Top + dh + spv;
      MemoTableComment.Height := dh;
      MemoTableComment.Anchors := [akTop, akLeft, akBottom];
    end;

  end
  else if cw < ScaleDPISize(1000) then
  begin
    aw := (cw - pd - pdr - sp) div 2 - lw;
    edtTableName.Width := aw;

    Label4.Top := Label1.Top;
    Label4.Left := edtTableName.Left + edtTableName.Width + sp;
    edtDispName.Top := edtTableName.Top;
    edtDispName.Left := Label4.Left + lw;
    edtDispName.Width := aw;

    Label2.Top := Label4.Top + lh;
    Label2.Left := pd;

    MemoTableComment.Left := edtTableName.Left;
    MemoTableComment.Width := cw - pdr - MemoTableComment.Left;
    if MemoTableComment.Top <> edtDispName.Top + lh then
    begin
      MemoTableComment.Anchors := [akTop, akLeft];
      dh := MemoTableComment.Height;
      if dh<edtDispName.Height then
        dh := edtDispName.Height;
      MemoTableComment.Top := edtDispName.Top + lh;
      Panel_TbH.Height := MemoTableComment.Top + dh + spv;
      MemoTableComment.Height := dh;
      MemoTableComment.Anchors := [akTop, akLeft, akBottom];
    end;
  end
  else
  begin
    aw := (cw - pd - pdr - sp * 3) div 4 - 96;
    edtTableName.Width := aw;

    Label4.Top := Label1.Top;
    Label4.Left := edtTableName.Left + edtTableName.Width + sp;
    edtDispName.Top := edtTableName.Top;
    edtDispName.Left := Label4.Left + lw;
    edtDispName.Width := aw;

    Label2.Top := Label1.Top;
    Label2.Left := edtDispName.Left + edtDispName.Width + sp;

    MemoTableComment.Left := Label2.Left + lw;
    MemoTableComment.Width := cw - pdr - MemoTableComment.Left;

    if MemoTableComment.Top <> edtDispName.Top then
    begin
      MemoTableComment.Anchors := [akTop, akLeft];
      dh := MemoTableComment.Height;     
      if dh<edtDispName.Height then
        dh := edtDispName.Height;
      MemoTableComment.Top := edtDispName.Top;
      Panel_TbH.Height := MemoTableComment.Top + dh + spv;
      MemoTableComment.Height := dh;
      MemoTableComment.Anchors := [akTop, akLeft, akBottom];
    end;
  end;

end;

procedure TFrameCtTableProp.pmSaveCodeAsClick(Sender: TObject);  
var
  S, fn: string;
begin
  fn := StringReplace(FGenCodeType, '_', '.', [rfReplaceAll]);
  S := ExtractFileExt(fn);
  if S='' then
    S:='.txt';
  SaveDialogCode.Filter:=Copy(S,2,Length(S))+' files (*'+S+')|*'+S+'|all files (*.*)|*.*'; 
  if not SaveDialogCode.Execute then
    Exit;

  MemoCodeGen.Lines.SaveToFile(SaveDialogCode.FileName);
  if Application.MessageBox(PChar(srConfirmOpenFileLocation),
    PChar(Application.Title), MB_OKCANCEL) <> idOk then
    Exit;
  fn := SaveDialogCode.FileName;
{$ifdef WINDOWS}
  S := 'Explorer /select, "' + fn + '"';
  ShellCmd(S);
{$else}
  S := ExtractFilePath(fn);
  CtOpenDoc(S);
{$endif}
end;

procedure TFrameCtTableProp.PopupMenuTbFieldsPopup(Sender: TObject);
begin
  if StringGridTableFields.EditorMode then
  begin
    StringGridTableFields.EditorMode:=False;  
    CheckGridEditingMode;
  end;
end;


procedure TFrameCtTableProp.sbtnFindClick(Sender: TObject);
begin
  FindDialogTxt.Execute;
end;

procedure TFrameCtTableProp.ScrollBoxCustomScriptDefResize(Sender: TObject);
begin
  PanelCustomScriptDef.Width := ScrollBoxCustomScriptDef.ClientWidth - 2;
end;

procedure TFrameCtTableProp.SplitterFsPropMoved(Sender: TObject);
begin
  if (PanelFieldProps.Parent.ClientWidth > 100) and (PanelFieldProps.Width > 50) then
    FFieldPropSplitPercent := PanelFieldProps.Width / PanelFieldProps.Parent.ClientWidth;

  if FFieldPropSplitPercent < 0.2 then
    FFieldPropSplitPercent := 0.2
  else if FFieldPropSplitPercent > 0.8 then
    FFieldPropSplitPercent := 0.8;

end;


procedure TFrameCtTableProp.StringGridTableFieldsDrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
var
  dd, idx: integer;
  AField: TCtMetaField;
begin
  if (ACol = 0) and (ARow > 0) then
  begin
    AField := FieldOfGridRow(aRow);
    idx := GetImageIndexOfCtNode(AField);
    if idx >= 0 then
    begin
      dd := StringGridTableFields.DefaultRowHeight - ScaleDPISize(ImageListCttb.Height);
      dd := dd div 2;
      ImageListCttb.Scaled := True;
      ImageListCttb.DrawForPPI(StringGridTableFields.Canvas, ARect.Left +
        dd, ARect.Top + dd, idx, ImageListCttb.Width, Screen.PixelsPerInch, 1, True);
    end;
  end;
  if ARow = FGridDragFocusingRow then
    with StringGridTableFields do
    begin
      Canvas.Pen.Width := 3;
      Canvas.Pen.Color := clRed;
      if FGridDragFocusingRow < StringGridTableFields.Row then
      begin
        Canvas.MoveTo(aRect.Left, aRect.Top + 3);
        Canvas.LineTo(aRect.Right, aRect.Top + 3);
      end
      else
      begin
        Canvas.MoveTo(aRect.Left, aRect.Bottom - 3);
        Canvas.LineTo(aRect.Right, aRect.Bottom - 3);
      end;
      Canvas.Pen.Width := 1;
    end;
end;

procedure TFrameCtTableProp.StringGridTableFieldsEndDrag(Sender,
  Target: TObject; X, Y: integer);
begin
  FGridDragFocusingRow := -1;
end;

procedure TFrameCtTableProp.StringGridTableFieldsGetEditText(Sender: TObject;
  ACol, ARow: integer; var Value: string);
begin
  CheckGridEditingMode;
end;

procedure TFrameCtTableProp.StringGridTableFieldsKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  case Key of
    VK_DELETE:
      if Shift = [ssCtrl] then
      begin
        FieldListHideEditor;
        actFieldDel.Execute;
        Key := 0;
      end;
    VK_UP:
      if Shift = [ssCtrl] then
      begin
        FieldListHideEditor;
        actFieldMoveUp.Execute;
        Key := 0;
      end;
    VK_DOWN:
      if Shift = [] then
      begin
        FieldListHideEditor;
        if (StringGridTableFields.RowCount <= 1) or (
          (StringGridTableFields.Row = StringGridTableFields.RowCount - 1)) then
          if actFieldAdd.Enabled then
            actFieldAddExecute(nil);
      end
      else if Shift = [ssCtrl] then
      begin
        FieldListHideEditor;
        actFieldMoveDown.Execute;
        Key := 0;
      end;
    VK_ESCAPE:
    begin
      CheckGridEditingMode;
      if not StringGridTableFields.EditorMode then
        if Assigned(Proc_GridEscape) then
          Proc_GridEscape(Self);
    end;
  end;
end;

procedure TFrameCtTableProp.StringGridTableFieldsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  CheckGridEditingMode;
end;

procedure TFrameCtTableProp.StringGridTableFieldsPrepareCanvas(Sender: TObject;
  aCol, aRow: integer; aState: TGridDrawState);
var
  AField: TCtMetaField;
begin
  if ARow > 0 then
  begin
    AField := FieldOfGridRow(aRow);
    if Assigned(AField) then
    begin
      if AField.KeyFieldType = cfktRid then
      begin
        StringGridTableFields.Canvas.Font.Color := CtFieldTextColor_Rid;
      end
      else if AField.KeyFieldType = cfktId then
      begin
        if (AField.RelateTable <> '') and (AField.RelateField <> '') then
          StringGridTableFields.Canvas.Font.Color := CtFieldTextColor_Rid
        else
          StringGridTableFields.Canvas.Font.Color := CtFieldTextColor_Id;
      end;
    end;
  end;
end;

procedure TFrameCtTableProp.StringGridTableFieldsSelection(Sender: TObject;
  aCol, aRow: integer);
var
  AField: TCtMetaField;
begin
  AField := FieldOfGridRow(aRow);
  if AField <> nil then
    RefreshFieldProps(AField);
end;

procedure TFrameCtTableProp.StringGridTableFieldsSetEditText(Sender: TObject;
  ACol, ARow: integer; const Value: string);
begin
  CheckGridEditingMode;
end;

procedure TFrameCtTableProp.StringGridTableFieldsValidateEntry(Sender: TObject;
  aCol, aRow: integer; const OldValue: string; var NewValue: string);
begin
  _OnCellXYValSet(aCol, aRow, NewValue, True);
end;

procedure TFrameCtTableProp.TabSheetDescShow(Sender: TObject);
begin
  CtSetFixWidthFont(MemoDesc);
end;

procedure TFrameCtTableProp.TabSheetCodeGenShow(Sender: TObject);
begin
  CtSetFixWidthFont(MemoCodeGen);
  btnShowSettings.Left := btnEditScript.Left + btnEditScript.Width + 10;
  btnSaveSettings.Left := btnShowSettings.Left + btnShowSettings.Width + 5;
  TabSheetCodeGen.Realign;

end;

procedure TFrameCtTableProp.TimerShowDataTimer(Sender: TObject);
begin
  TimerShowData.Enabled := False;
  ShowCurTableData;
end;

procedure TFrameCtTableProp._OnCtrlValueExec(Sender: TObject);
var
  I: integer;
begin
  if FGenCodeType='' then
    Exit;
  if IsInnerSqlTab(FGenCodeType) then
    Exit;

  MemoCodeGen.Lines.Text := GetDmlScriptOutput(FGenCodeType, False);
  if Assigned(FCtMetaTable) and FCtMetaTable.IsTable
    and (FCtMetaTable.Describe <> MemoDesc.Lines.Text) then
  begin
    RefreshDesc;
    RefreshFieldProps;
    DoTablePropsChanged(FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(2, FCtMetaTable, nil, '');
    if FIniting then
      Exit;
    FIniting := True;
    try
      edtTableName.Text := FCtMetaTable.Name;
      edtDispName.Text := FCtMetaTable.Caption;
      MemoTableComment.Lines.Text := FCtMetaTable.Memo;

      edtUIDisplayText.Text := FCtMetaTable.UIDisplayText;
      ckbGenDatabase.Checked := FCtMetaTable.GenDatabase;
      ckbGenCode.Checked := FCtMetaTable.GenCode;
      memoExtraSQL.Lines.Text := FCtMetaTable.ExtraSQL;
      MemoUILogic.Lines.Text := FCtMetaTable.UILogic;
      memoBusinessLogic.Lines.Text := FCtMetaTable.BusinessLogic;
      memoExtraProps.Lines.Text := FCtMetaTable.ExtraProps;
      memoScriptRules.Lines.Text := FCtMetaTable.ScriptRules;

      with StringGridTableFields do
        Clean(0, 1, ColCount - 1, RowCount - 1, [gzNormal]);
      StringGridTableFields.RowCount := 1;

      with FCtMetaTable.MetaFields do
        for I := 0 to Count - 1 do
          AddDxFieldNode(Items[I]);
    finally
      FIniting := False;
    end;
  end;
end;

procedure TFrameCtTableProp._OnCustDmlCtrlValueExec(Sender: TObject);
begin
  RunCustomScriptDef(False);
end;

procedure TFrameCtTableProp.SetShowOperLogicPage(AValue: boolean);
begin
  if FShowOperLogicPage=AValue then Exit;
  FShowOperLogicPage:=AValue;
end;

end.
