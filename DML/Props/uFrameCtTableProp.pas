unit uFrameCtTableProp;

{$MODE Delphi}
{$WARN 4105 off : Implicit string type conversion with potential data loss from "$1" to "$2"}
interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, StdCtrls, ComCtrls, ActnList, Menus, Buttons,
  CTMetaData, CtMetaTable,
  uFormAddCtFields, StdActns, Grids, ColorBox, Types;

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
    Bevel4: TBevel;
    Bevel5: TBevel;
    BevelGridFrame: TBevel;
    actEditCut: TEditCut;
    actEditCopy: TEditCopy;
    actEditDelete: TEditDelete;
    actEditPaste: TEditPaste;
    actEditUndo: TEditUndo;
    btnShowInGraph: TBitBtn;
    btnToggleTabs: TBitBtn;
    ckbForeignKeysOnly: TCheckBox;
    ckbGenCode: TCheckBox;
    ckbGenDatabase: TCheckBox;
    colobBgColor: TColorBox;
    edtTxtSizeH: TEdit;
    edtTbSizeW: TEdit;
    edtGenTxtFind: TEdit;
    edtPhysicalName: TEdit;
    edtTbSizeH: TEdit;
    edtTxtSizeW: TEdit;
    edtUIDisplayText: TEdit;
    edtOwnerCategory: TEdit;
    edtGroupName: TEdit;
    edtSQLAlias: TEdit;
    FindDialogTxt: TFindDialog;
    Label25: TLabel;
    lbTxtSize: TLabel;
    lbTbSizeX: TLabel;
    lbTbSize: TLabel;
    lbTbFieldCount: TLabel;
    lbDesignNotes: TLabel;
    lbPartitionInfo: TLabel;
    lbRelTbInfo: TLabel;
    lbSQLOrderByClause: TLabel;
    lbTbPhysicalName: TLabel;
    lbListSQL: TLabel;
    lbOwnerCategory: TLabel;
    lbGroupName: TLabel;
    lbSQLAlias: TLabel;
    lbTxtSizeX: TLabel;
    lbViewSQL: TLabel;
    lbGenTp: TLabel;
    lbExProps: TLabel;
    lbScriptRules: TLabel;
    lbUILogic: TLabel;
    lbBuzLogic: TLabel;
    lbUIDispName: TLabel;
    Label41: TLabel;
    lbExtraSQL: TLabel;
    lbSQLWhereClause: TLabel;
    ListBoxRelTbs: TListBox;
    listboxGenTypes: TListBox;
    memoDescHelp: TMemo;
    memoBusinessLogic: TMemo;
    memoExtraProps: TMemo;
    memoPartitionInfo: TMemo;
    memoListSQL: TMemo;
    memoDesignNotes: TMemo;
    memoSQLOrderByClause: TMemo;
    memoViewSQL: TMemo;
    memoScriptRules: TMemo;
    memoExtraSQL: TMemo;
    MemoUILogic: TMemo;
    memoSQLWhereClause: TMemo;
    MenuItem1: TMenuItem;
    MN_FieldWeights: TMenuItem;
    MN_OpenTemplFolder: TMenuItem;
    MNTabs_Cust: TMenuItem;
    MNTabs_Relations: TMenuItem;
    MNTabs_Close: TMenuItem;
    MNTabs_Settings: TMenuItem;
    MNTabs_Data: TMenuItem;
    MNTabs_UIDesign: TMenuItem;
    MNTabs_Gen: TMenuItem;
    MNTabs_AdvPage: TMenuItem;
    PanelTxtBottom: TPanel;
    PanelTbRelDml: TPanel;
    PanelRefInfo: TPanel;
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
    PopupMenuTabs: TPopupMenu;
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
    sbtnTbJson: TSpeedButton;
    ScrollBoxCustomScriptDef: TScrollBox;
    ScrollBoxOperLogic: TScrollBox;
    SpeedButton_FieldAdd: TSpeedButton;
    SpeedButton_FieldDel: TSpeedButton;
    SpeedButton_FIeldMoveDown: TSpeedButton;
    SpeedButton_FieldPropPanel: TSpeedButton;
    SpeedButton_FIeldMoveUp: TSpeedButton;
    SplitterTbRelInfo: TSplitter;
    SplitterGenTps: TSplitter;
    SplitterDescHelp: TSplitter;
    SplitterFsProp: TSplitter;
    StringGridTableFields: TStringGrid;
    TabSheetRelations: TTabSheet;
    TabSheetUI: TTabSheet;
    TabSheetAdvanced: TTabSheet;
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
    TimerAutoFocus: TTimer;
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
    procedure btnToggleTabsClick(Sender: TObject);
    procedure ckbForeignKeysOnlyChange(Sender: TObject);
    procedure colobBgColorGetColors(Sender: TCustomColorBox; Items: TStrings);
    procedure edtGenTxtFindKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FindDialogTxtFind(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure lb_DescrbTipsClick(Sender: TObject);
    procedure listboxGenTypesClick(Sender: TObject);
    procedure ListBoxRelTbsClick(Sender: TObject);
    procedure ListBoxRelTbsDblClick(Sender: TObject);
    procedure ListBoxRelTbsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoCodeGenDblClick(Sender: TObject);
    procedure MemoDescDblClick(Sender: TObject);
    procedure MemoDescKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoTextContentDblClick(Sender: TObject);
    procedure MemoTextContentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MNGenTab_CustomizeClick(Sender: TObject);
    procedure MNTabs_CloseClick(Sender: TObject);
    procedure MNTabs_CustClick(Sender: TObject);
    procedure MNTabs_DataClick(Sender: TObject);
    procedure MNTabs_GenClick(Sender: TObject);
    procedure MNTabs_RelationsClick(Sender: TObject);
    procedure MNTabs_SettingsClick(Sender: TObject);
    procedure MNTabs_UIDesignClick(Sender: TObject);
    procedure MN_OpenTemplFolderClick(Sender: TObject);
    procedure PageControlTbPropChange(Sender: TObject);
    procedure PageControlTbPropContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure PageControlTbPropMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelCustomScriptDefResize(Sender: TObject);
    procedure Panel_ScriptSettingsResize(Sender: TObject);
    procedure Panel_TbHResize(Sender: TObject);
    procedure pmSaveCodeAsClick(Sender: TObject);
    procedure PopupMenuTabsPopup(Sender: TObject);
    procedure PopupMenuTbFieldsPopup(Sender: TObject);
    procedure sbtnFindClick(Sender: TObject);
    procedure sbtnTbJsonClick(Sender: TObject);
    procedure ScrollBoxCustomScriptDefResize(Sender: TObject);
    procedure SplitterFsPropMoved(Sender: TObject);
    procedure SplitterGenTpsMoved(Sender: TObject);
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
    procedure TimerAutoFocusTimer(Sender: TObject);
    procedure TimerGridEditingCheckTimer(Sender: TObject);
    procedure TimerShowDataTimer(Sender: TObject);
    procedure actSortFieldsByNameExecute(Sender: TObject);
    procedure PageControlTbPropChanging(Sender: TObject; var AllowChange: boolean);
  private
    FCreatingNewTable: boolean;
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
    FShowAdvPage: boolean;

    FGridDragFocusingRow: integer;

    FTabInitTick: Integer;    
    FTbRelateModel: TCtDataModelGraph;

    FLastTabClickPos: TPoint;
    FLastTabClickTick: Int64;
    FAutoFocusRow: Integer;

    procedure SetShowAdvPage(AValue: boolean);
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
    function CurTbHasAdvProps: Boolean;     
    procedure _OnRelationMapRefresh(Sender: TObject);
    procedure GotoTab(tab: TTabSheet);
    procedure CloseCurTab;
    procedure SaveTabVisibles;
    procedure DoEscape;
    procedure RealignGenToolbar;
    procedure MItem_FieldWeightClick(Sender: TObject);
    procedure ChangeFieldWeight(iOpType, iRes: Integer);
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
    RelateDmlForm: TCustomForm;
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
    procedure RefreshRelationMap;
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
    property ShowAdvPage: boolean read FShowAdvPage write SetShowAdvPage;
    property CreatingNewTable: boolean read FCreatingNewTable write FCreatingNewTable;
  end;

  TStringGridXX = class(TStringGrid)
  end;

const
  DEF_clInfoBk = $E1FFFF;
  DEF_INNER_SQL_TABS: array[0..6] of
    string = ('SQL', 'Oracle', 'MySql', 'SQLServer', 'SQLite', 'PostgreSQL', 'Hive');
var
  G_TbPropTabInitTick: Integer = 0;
  G_LastTbDescInputDemo: string = '';
  G_LastTbDescHelpWidth: Integer = 0;

implementation

uses
  dmlstrs, DmlScriptPublic,  uDMLSqlEditor, IniFiles, uFrameCtFieldDef,
  ClipBrd, WindowFuncs, uFormCtDbLogon, PvtInput, Toolwin,
  {$ifndef EZDML_LITE}DmlPasScript, ide_editor,uFrameUIPreview,DmlScriptControl,
  {$else}DmlPasScriptLite,
  {$endif}
  uFormSelectFields,  ezdmlstrs, uFormGenTabCust, CtObjXmlSerial, uFormCtDML;

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
  procedure CreateFieldWeightMenus;
  var
    I: Integer; 
    MItem: TMenuItem;
    ss: TStringList;
    S: String;
  begin
    ss:= TStringList.Create;
    try
      ss.Text := GetCtDropDownItemsText(srFieldWeights);
      for I:=0 to ss.Count - 1 do
      begin
        S := ss[I];
        if Trim(S)='' then
          Continue;
        MItem := TMenuItem.Create(Self);
        MItem.Caption := S;
        MItem.Hint := S;
        MItem.OnClick := MItem_FieldWeightClick;
        MN_FieldWeights.Add(MItem);
      end;
    finally
      ss.Free;
    end;
  end;
var
  I: integer;
  ss: TStrings;
begin
  inherited;

  FAutoFocusRow := -1;
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
  begin
    if ShouldUseEnglishForDML then
      ss.Add(DEF_CTMETAFIELD_CONSTRAINT_STR_ENG[I] + IfElse(I=6, ':', ''))
    else
      ss.Add(DEF_CTMETAFIELD_CONSTRAINT_STR_CHN[I] + IfElse(I=6, ':', ''));
  end;
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
  if (G_LastTbDescHelpWidth > 0) and (G_LastTbDescHelpWidth < (Self.Width div 2)) then
    memoDescHelp.Width := G_LastTbDescHelpWidth;

  CreateFieldWeightMenus;

  FieldPropForm := TFrameCtFieldDef.Create(Self);
  FieldPropForm.Parent := PanelFieldProps;
  FieldPropForm.Align := alClient;
  TFrameCtFieldDef(FieldPropForm).stFieldName.Tag := 1;
  TFrameCtFieldDef(FieldPropForm).PageControl1.Align := alClient;
  TFrameCtFieldDef(FieldPropForm).OnFieldPropChange := _OnCtFieldFramePropChange;    
  TFrameCtFieldDef(FieldPropForm).btnHideFieldProp.Visible := True;
  TFrameCtFieldDef(FieldPropForm).btnHideFieldProp.OnClick := actFieldPropPanelExecute;

  btnShowSettings.Tag := 1;
  btnShowSettings.Caption := StringReplace(btnShowSettings.Caption, '>>', '<<', []);

  {$ifndef EZDML_LITE}
  UIPreviewFrame := TFrameUIPreview.Create(Self);
  UIPreviewFrame.Parent := PanelUIPreview;
  UIPreviewFrame.Align := alClient;
  TFrameUIPreview(UIPreviewFrame).Proc_OnUIPropChanged := _OnUIPropChanged;

  FDmlScControls := TDmlScriptControlList.Create;
  TDmlScriptControlList(FDmlScControls).OnCtrlValueExec := Self._OnCtrlValueExec;

  FCustDmlScControls := TDmlScriptControlList.Create;
  TDmlScriptControlList(FCustDmlScControls).OnCtrlValueExec :=
    Self._OnCustDmlCtrlValueExec;
  {$endif}       
  InitDmlScriptPages;
end;

destructor TFrameCtTableProp.Destroy;
begin
  FreeAndNil(FDmlScControls);
  FreeAndNil(FCustDmlScControls);
  FreeAndNil(FSelFields);
  FreeAndNil(FTbRelateModel);
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
  begin
    TabSheetCust.Caption := G_CustomPropUICaption;    
    MNTabs_Cust.Caption := G_CustomPropUICaption;
  end;
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
                             
  {$ifndef EZDML_LITE}   
  TDmlScriptControlList(FDmlScControls).CurFileName := '';
  {$endif}
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
  {$ifndef EZDML_LITE}
  if UIPreviewFrame <> nil then
    TFrameUIPreview(UIPreviewFrame).HideProps();
  {$endif}
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
      //StringGridTableFields.Row := I;
      FAutoFocusRow := I;
      TimerAutoFocus.Enabled := True;
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
                      
  {$ifdef EZDML_LITE}
    for I := 0 to High(CtPsLiteRegs) do
      if CtPsLiteRegs[I].Cat='Table' then
        listboxGenTypes.Items.Add(CtPsLiteRegs[I].Name);
  {$endif}

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
      ShowAdvPage := G_EnableAdvTbProp or CurTbHasAdvProps;
      if ShowAdvPage and (TabSheetAdvanced.Tag = 1) then
        TabSheetAdvanced.TabVisible := ShowAdvPage;

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
  {$ifndef EZDML_LITE}
  TFrameUIPreview(UIPreviewFrame).LoadConfig(secEx);
  {$endif}
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

  {$ifndef EZDML_LITE}
  TFrameUIPreview(UIPreviewFrame).SaveConfig(secEx);
  {$endif}

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
  MN_FieldWeights.Visible := not FReadOnlyMode;
  MN_GenOption.Visible := not FReadOnlyMode;

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
  {$ifdef EZDML_LITE}
  raise Exception.Create(srEzdmlLiteNotSupportFun);
  {$else}
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
  {$endif}
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
  fr: TfrmDmlSqlEditorN;
  sql, dbType: string;
  idx: integer;
begin
  if FIniting then
    Exit;
  if FCtMetaTable = nil then
    Exit;
  if TbDataSqlForm = nil then
  begin
    fr := TfrmDmlSqlEditorN.Create(Self);
    TbDataSqlForm := fr;
    fr.BorderStyle := bsNone;
    fr.Parent := TabSheetData;
    fr.Align := alClient;
    fr.SplitPercent := 65;
    {$ifndef EZDML_LITE}
    fr.actShowSqlTbProp.Visible:=False;
    {$endif}
  end
  else
    fr := TfrmDmlSqlEditorN(TbDataSqlForm);

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
  {$ifndef EZDML_LITE}
  fr.DefTableName := FCtMetaTable.Name;
  {$endif}                     
  if G_LogicNamesForTableData then
    sql := FCtMetaTable.GenSelectSql(G_MaxRowCountForTableData, dbType, fr.FCtMetaDatabase)
  else
    sql := FCtMetaTable.GenSelectSqlEx(G_MaxRowCountForTableData, '  t.*', '', '', '', dbType, fr.FCtMetaDatabase);
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

  {$ifndef EZDML_LITE}
  if (FCtMetaTable = nil) or FCtMetaTable.IsText or FCtMetaTable.IsGroup then
  begin
    TFrameUIPreview(UIPreviewFrame).HideProps; 
    TFrameUIPreview(UIPreviewFrame).InitByTable(nil, True);
  end
  else
    TFrameUIPreview(UIPreviewFrame).InitByTable(Self.FCtMetaTable, Self.FReadOnlyMode);
  {$endif}
end;

procedure TFrameCtTableProp.RefreshRelationMap;

  procedure AddRelTb(tb: TCtMetaTable);    
  var
    tb2: TCtMetaTable;
  begin
    tb2 := FTbRelateModel.Tables.NewTableItem();
    tb2.AssignFrom(tb);
  end;

  procedure GetRelateInfo;
  var
    I, J, K, po, idx, rc1, rc2, rc3: Integer;
    md: TCtDataModelGraph;
    tb, tb2: TCtMetaTable;
    fd: TCtMetaField;
    tbN, S, T: String;
    ss, ts: TStringList;
  begin
    FTbRelateModel.Tables.Clear;
    ListBoxRelTbs.Items.Clear;

    tbN := FCtMetaTable.Name;
    AddRelTb(FCtMetaTable);
    rc1 := 0;
    rc2 := 0;
    rc3 := 0;

    tb := FCtMetaTable;
    for K:=0 to tb.MetaFields.Count -1 do
    begin
      fd := tb.MetaFields.Items[K];
      if fd.DataLevel = ctdlDeleted then
        Continue;
      if not fd.IsPhysicalField then
        Continue;
      if (fd.KeyFieldType <> cfktId) and (fd.KeyFieldType <> cfktRid) then
        Continue;
      if (fd.RelateTable <> '') and (fd.GetRelateTableField<>nil) then
      begin
        tb2 := fd.GetRelateTableObj;
        if tb2=nil then
          Continue;    
        if tb2.Name = FCtMetaTable.Name then
          Continue;
        if FTbRelateModel.Tables.ItemByName(tb2.Name) = nil then
        begin
          AddRelTb(tb2);
          Inc(rc1);        
          //ListBoxRelTbs.Items.AddObject(tbN+'.'+fd.Name + ' -> '+tb2.NameCaption+'.'+fd.RelateField, tb2);
          ListBoxRelTbs.Items.AddObject(' - '+tb2.NameCaption, tb2);
        end;
      end;
    end;

    idx := ListBoxRelTbs.Items.AddObject(FCtMetaTable.NameCaption, FCtMetaTable);

    ss:= TStringList.Create;
    try
      for I:=0 to FGlobeDataModelList.Count-1 do
      begin
        md := FGlobeDataModelList.Items[I];
        for J:=0 to md.Tables.Count-1 do
        begin
          tb := md.Tables.Items[J];
          if tb.Name = FCtMetaTable.Name then
            Continue;
          for K:=0 to tb.MetaFields.Count -1 do
          begin
            fd := tb.MetaFields.Items[K];
            if fd.DataLevel = ctdlDeleted then
              Continue;
            if not fd.IsPhysicalField then
              Continue;
            if (fd.KeyFieldType <> cfktId) and (fd.KeyFieldType <> cfktRid) then
              Continue;
            if (UpperCase(fd.RelateTable)=UpperCase(tbN)) and (fd.GetRelateTableField <> nil) then
              begin
                if FTbRelateModel.Tables.ItemByName(tb.Name) = nil then
                  AddRelTb(tb);
                if ss.IndexOf(tb.NameCaption) < 0 then
                begin
                  ss.Add(tb.NameCaption);
                  Inc(rc2);
                  //ListBoxRelTbs.Items.AddObject(tbN+'.'+fd.RelateField + ' <- '+tb.NameCaption+'.'+fd.Name, tb);
                  ListBoxRelTbs.Items.AddObject(' * '+tb.NameCaption, tb);
                end;
              end;
          end;
        end;
      end;

      if not ckbForeignKeysOnly.Checked then
      begin
        ss.Clear;

        ts := TStringList.Create;
        try
          ts.Text := FCtMetaTable.GetManyToManyInfo;
          for I:=0 to ts.Count - 1 do
          begin
            S := ts[I];
            if S = '' then
              Continue;   
            po := Pos('@', S);
            if po=0 then
              T := ''
            else
              T := Copy(S, po+1, Length(S));
            po := Pos(':', S);
            if po=0 then
              Continue;   
            S := Copy(S, 1, po-1);
            po := Pos('.', S);
            if po>0 then
              S := Copy(S, 1, po-1);

            tb2 := FGlobeDataModelList.GetTableOfName(S);
            if tb2=nil then
              Continue;
            if tb2.Name = FCtMetaTable.Name then
              Continue;
            if FTbRelateModel.Tables.ItemByName(tb2.Name) = nil then
              AddRelTb(tb2);
            if ss.IndexOf(tb2.NameCaption) < 0 then
            begin
              ss.Add(tb2.NameCaption);
              Inc(rc3);
              //ListBoxRelTbs.Items.AddObject(tbN+'.'+fd.RelateField + ' <- '+tb.NameCaption+'.'+fd.Name, tb);
              ListBoxRelTbs.Items.AddObject(' :: '+tb2.NameCaption+' - '+T, tb2);
            end;

          end;
        finally
          ts.Free;
        end;

        tb := FCtMetaTable;
        for K:=0 to tb.MetaFields.Count -1 do
        begin
          fd := tb.MetaFields.Items[K];
          if fd.DataLevel = ctdlDeleted then
            Continue;
          if (fd.RelateTable <> '') and (fd.GetRelateTableField=nil) then
          begin                      
            tb2 := FGlobeDataModelList.GetTableOfName(fd.RelateTable);
            if tb2=nil then
              Continue;
            if tb2.Name = FCtMetaTable.Name then
              Continue;
            if FTbRelateModel.Tables.ItemByName(tb2.Name) = nil then
              AddRelTb(tb2);
            if ss.IndexOf(tb2.NameCaption) < 0 then
            begin
              ss.Add(tb2.NameCaption);
              Inc(rc3);
              //ListBoxRelTbs.Items.AddObject(tbN+'.'+fd.RelateField + ' <- '+tb.NameCaption+'.'+fd.Name, tb);
              ListBoxRelTbs.Items.AddObject(' ~ '+tb2.NameCaption+' - '+fd.Name, tb2);
            end;
          end;
        end;

        for I:=0 to FGlobeDataModelList.Count-1 do
        begin
          md := FGlobeDataModelList.Items[I];
          for J:=0 to md.Tables.Count-1 do
          begin
            tb := md.Tables.Items[J];
            if tb.Name = FCtMetaTable.Name then
              Continue;
            for K:=0 to tb.MetaFields.Count -1 do
            begin
              fd := tb.MetaFields.Items[K];
              if fd.DataLevel = ctdlDeleted then
                Continue;
              if (UpperCase(fd.RelateTable)=UpperCase(tbN)) and (fd.GetRelateTableField=nil) then
                begin
                  if FTbRelateModel.Tables.ItemByName(tb.Name) = nil then
                    AddRelTb(tb);
                  if ss.IndexOf(tb.NameCaption) < 0 then
                  begin
                    ss.Add(tb.NameCaption);
                    Inc(rc3);
                    //ListBoxRelTbs.Items.AddObject(tbN+'.'+fd.RelateField + ' <- '+tb.NameCaption+'.'+fd.Name, tb);
                    ListBoxRelTbs.Items.AddObject(' ~ '+tb.NameCaption+'.'+fd.Name, tb);
                  end;
                end;
            end;
          end;
        end;
      end;
    finally
      ss.Free;
    end;

    S := Format(srTbRelateInfo, [FCtMetaTable.NameCaption, rc1, rc2]);
    if rc3 > 0 then
      S := S + ' '+Format(srTbRelateInfoWeak, [rc3]);
    lbRelTbInfo.Caption := S;
    //ckbForeignKeysOnly.Left := lbRelTbInfo.Left + lbRelTbInfo.Width + 12;  
    ListBoxRelTbs.ItemIndex:= idx;
  end;

var
  fr: TfrmCtDML;
  brf: Boolean;
begin
  if PageControlTbProp.ActivePage <> TabSheetRelations then
  begin
    TabSheetRelations.Tag := 999;
    Exit;
  end;
  TabSheetRelations.Tag := 0;

  if FCtMetaTable = nil then
    Exit;

  if FTbRelateModel = nil then
    FTbRelateModel:= TCtDataModelGraph.Create;
  if RelateDmlForm = nil then
  begin
    fr := TfrmCtDML.Create(Self);
    RelateDmlForm := fr;
    fr.BorderStyle := bsNone;
    fr.Parent := PanelTbRelDml;
    fr.Align := alClient;
    fr.Visible := True;
    fr.BrowseMode := True;
    fr.FFrameCtDML.DMLGraph.DMLObjs.BriefMode := True;
    fr.FFrameCtDML.actRefresh.OnExecute:=_OnRelationMapRefresh;
  end
  else
    fr := TfrmCtDML(RelateDmlForm);

  GetRelateInfo;
  fr.FFrameCtDML.DMLGraph.BeginUpdate;
  try
    brf := fr.FFrameCtDML.DMLGraph.DMLObjs.BriefMode;
    fr.Init(FTbRelateModel, True, False);      
    fr.FFrameCtDML.ToolBar1.Align := alRight;
    fr.FFrameCtDML.ToolBar1.EdgeBorders:=[ebLeft];
    fr.FFrameCtDML.actRearrange.OnExecute(nil);
    fr.FFrameCtDML.DMLGraph.Reset;
    fr.FFrameCtDML.DMLGraph.DMLObjs.BriefMode := brf;   
    fr.FFrameCtDML.DMLGraph.DMLDrawer.HideBoundRect := True;
    if brf then
      fr.FFrameCtDML.DMLGraph.ViewCenterX:= fr.FFrameCtDML.DMLGraph.DMLDrawer.DrawerWidth * 2 + 9999;
    fr.LocToCtObj(FCtMetaTable);
  finally
    fr.FFrameCtDML.DMLGraph.EndUpdate;
  end;     
  fr.LocToCtObj(FCtMetaTable);
  lbRelTbInfo.BringToFront;
  try
    ListBoxRelTbs.SetFocus;
  except
  end;
end;

procedure TFrameCtTableProp.ShowTableDataDelay;
var
  idx: integer;
  dbType, sql: string;
begin
  TimerShowData.Enabled := False;
  if TbDataSqlForm <> nil then
    with TfrmDmlSqlEditorN(TbDataSqlForm) do
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
          {$ifndef EZDML_LITE}
          DefTableName := FCtMetaTable.Name;
          {$endif}
          if G_LogicNamesForTableData then                                                                       
            sql := FCtMetaTable.GenSelectSql(G_MaxRowCountForTableData, dbType, FCtMetaDatabase)
          else
            sql := FCtMetaTable.GenSelectSqlEx(G_MaxRowCountForTableData, '  t.*', '', '', '', dbType, FCtMetaDatabase);
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
    else if AControl <> StringGridTableFields then
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
    PanelFieldToolbar.Visible:= not bReadOnly;
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

  {$ifdef EZDML_LITE}
    MNTabs_UIDesign.Visible:=False;
    MNTabs_Cust.Visible:=False;
  {$endif}

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

      edtPhysicalName.Text := '';
      edtUIDisplayText.Text := '';
      ckbGenDatabase.Checked := False;   
      ckbGenCode.Checked := False; 
      memoListSQL.Lines.Text := '';
      memoViewSQL.Lines.Text := '';
      memoExtraSQL.Lines.Text := '';   
      MemoUILogic.Lines.Text := '';
      memoBusinessLogic.Lines.Text := '';
      memoExtraProps.Lines.Text := '';        
      memoScriptRules.Lines.Text := '';
      actTbGenDB.Checked := False;
      actTbGenCode.Checked := False; 
      btnToggleTabs.Visible := False;
      MN_GenOption.Visible := False;   
      MN_FieldWeights.Visible := False;

      edtOwnerCategory.Text := '';      
      edtGroupName.Text := '';
      edtSQLAlias.Text := '';
      memoPartitionInfo.Lines.Text := '';
      memoDesignNotes.Lines.Text := '';
      memoSQLOrderByClause.Lines.Text := '';
      memoSQLWhereClause.Lines.Text := '';

      TabSheetText.TabVisible := False;
      TabSheetTable.TabVisible := True;
      TabSheetDesc.TabVisible := True;

  {$ifndef EZDML_LITE}     
      TabSheetUI.TabVisible := True;
  {$else}                           
      TabSheetUI.TabVisible := False;
  {$endif}
      TabSheetRelations.TabVisible := True;
      TabSheetAdvanced.TabVisible := ShowAdvPage;
      TabSheetAdvanced.Tag := 1;

      TabSheetCodeGen.TabVisible := True;
      TabSheetData.TabVisible := True;
      TabSheetCust.TabVisible := False;

      if FLastActiveTabSheet <> nil then
        if FLastActiveTabSheet.TabVisible then
          PageControlTbProp.ActivePage := FLastActiveTabSheet;
    end
    else if ATb.IsText or ATb.IsGroup then
    begin
      if ATb.IsGroup then
        TabSheetText.Caption := srGroup
      else
        TabSheetText.Caption := srText;
      edtTextName.Text := ATb.Name;
      ckbIsSqlText.Visible:=ATb.IsText;
      ckbIsSqlText.Checked := ATb.IsSqlText;
      MemoTextContent.Lines.Text := ATb.Memo;
      with StringGridTableFields do
        Clean(0, 1, ColCount - 1, RowCount - 1, [gzNormal]);
      StringGridTableFields.RowCount := 1;

      TabSheetText.TabVisible := True;
      TabSheetTable.TabVisible := False;
      TabSheetDesc.TabVisible := False;         
      TabSheetUI.TabVisible := False;
      TabSheetRelations.TabVisible := False;
      TabSheetAdvanced.TabVisible := False;
      TabSheetAdvanced.Tag := 0;
      TabSheetCodeGen.TabVisible := False;
      TabSheetData.TabVisible := False;
      TabSheetCust.TabVisible := False;
      btnToggleTabs.Visible := False;
      MN_GenOption.Visible := False;  
      MN_FieldWeights.Visible := False;

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

      if MemoTableComment.Lines.Count >= 3 then
      begin
        MemoTableComment.Height := edtTableName.Height * 3;
        MemoTableComment.Top := MemoTableComment.Top + 1;
        MemoTableComment.ScrollBars:= ssVertical;
      end
      else if MemoTableComment.Lines.Count > 1 then
      begin
        MemoTableComment.Height := edtTableName.Height * 2;
        MemoTableComment.Top := MemoTableComment.Top + 1;     
        MemoTableComment.ScrollBars:= ssVertical;
      end;

      with StringGridTableFields do
        Clean(0, 1, ColCount - 1, RowCount - 1, [gzNormal]);
      StringGridTableFields.RowCount := 1;

      with ATb.MetaFields do
        for I := 0 to Count - 1 do
          AddDxFieldNode(Items[I]);

      MemoDesc.Lines.Text := atb.Describe;
      GenTbCode;
      MemoDesc.Modified := False;
                   
      edtPhysicalName.Text := ATb.PhysicalName;
      edtUIDisplayText.Text := ATb.UIDisplayText;
      ckbGenDatabase.Checked := ATb.GenDatabase;
      ckbGenCode.Checked := ATb.GenCode;
      colobBgColor.Selected:= ATb.BgColor;
      memoListSQL.Lines.Text := ATb.ListSQL;
      memoViewSQL.Lines.Text := ATb.ViewSQL;
      memoExtraSQL.Lines.Text := ATb.ExtraSQL;
      MemoUILogic.Lines.Text := ATb.UILogic;
      memoBusinessLogic.Lines.Text := ATb.BusinessLogic;
      memoExtraProps.Lines.Text := ATb.ExtraProps;
      memoScriptRules.Lines.Text := ATb.ScriptRules;
      actTbGenDB.Checked := FCtMetaTable.GenDatabase;
      actTbGenCode.Checked := FCtMetaTable.GenCode;
      btnToggleTabs.Visible := True;
      MN_GenOption.Visible := not FReadOnlyMode;
      MN_FieldWeights.Visible := not FReadOnlyMode;
                  
      edtOwnerCategory.Text := ATb.OwnerCategory;
      edtGroupName.Text := ATb.GroupName;
      edtSQLAlias.Text := ATb.SQLAlias;
      memoPartitionInfo.Lines.Text := ATb.PartitionInfo;
      memoDesignNotes.Lines.Text := ATb.DesignNotes;
      memoSQLOrderByClause.Lines.Text := ATb.SQLOrderByClause;
      memoSQLWhereClause.Lines.Text := ATb.SQLWhereClause;

      TabSheetText.TabVisible := False;
      TabSheetTable.TabVisible := True;
      TabSheetDesc.TabVisible := True;
  {$ifndef EZDML_LITE} 
      TabSheetUI.TabVisible := (G_EnableTbPropUIDesign {or ATb.HasUIDesignProps}) and not CreatingNewTable;  
      TabSheetCust.TabVisible := G_EnableCustomPropUI;
  {$else}
      TabSheetUI.TabVisible := False;   
      TabSheetCust.TabVisible := False;
  {$endif}
      TabSheetRelations.TabVisible := not CreatingNewTable and G_EnableTbPropRelations;
      TabSheetAdvanced.TabVisible := (ShowAdvPage or CurTbHasAdvProps) and not CreatingNewTable;
      TabSheetAdvanced.Tag := 1;
      TabSheetCodeGen.TabVisible := G_EnableTbPropGenerate and not CreatingNewTable;
      TabSheetData.TabVisible := G_EnableTbPropData and not CreatingNewTable;

      if FLastActiveTabSheet <> nil then
        if FLastActiveTabSheet.TabVisible then
          PageControlTbProp.ActivePage := FLastActiveTabSheet;
    end;

    RefreshFieldProps;
    RefreshUIPreview;
    RefreshRelationMap;
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
  lbTbFieldCount.Caption := Format(srTbFieldCountFmt, [Result]);
  SetDxFieldNode(AField, Result);
end;

procedure TFrameCtTableProp.btnEditScriptClick(Sender: TObject);

  function EditScriptFile(fn: string): boolean;
  begin
    Result := False;
    {$ifndef EZDML_LITE}
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
    {$else}
    raise Exception.Create(srEzdmlLiteNotSupportFun);
    {$endif}
  end;

begin        
  {$ifndef EZDML_LITE}   
  if TDmlScriptControlList(FDmlScControls).CurFileName = '' then
    Exit;
  if EditScriptFile(TDmlScriptControlList(FDmlScControls).CurFileName) then
  begin
    TDmlScriptControlList(FDmlScControls).CurFileName := '';
    GenTbCode;
  end;
  {$else}
  raise Exception.Create(srEzdmlLiteNotSupportFun);
  {$endif}
end;

procedure TFrameCtTableProp.btnSaveSettingsClick(Sender: TObject);
begin                             
  {$ifndef EZDML_LITE}
  if TDmlScriptControlList(FDmlScControls).CurFileName = '' then
    Exit;
  TDmlScriptControlList(FDmlScControls).SaveSettings;
  TDmlScriptControlList(FDmlScControls).CurFileName := '';
  GenTbCode;   
  {$else}
  raise Exception.Create(srEzdmlLiteNotSupportFun);
  {$endif}
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
  RealignGenToolbar;
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
    if Sender = UIPreviewFrame then    
      if not Proc_ShowCtFieldProp(AField, FReadOnlyMode) then
      begin      
        TCtMetaTable(pctnode).MetaFields.Remove(AField);
        Exit;
      end;
    AddDxFieldNode(AField);
    idx1 := TCtMetaTable(pctnode).MetaFields.IndexOf(AField);
    if (idx2 >= 0) and (idx1 > idx2 + 1) then
    begin                              
      if Sender = UIPreviewFrame then
        idx2 := idx2 - 1;
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
    RefreshRelationMap;
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
      RefreshRelationMap;
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
    lbTbFieldCount.Caption := Format(srTbFieldCountFmt, [StringGridTableFields.RowCount - 1]);
    DoTablePropsChanged(FCtMetaTable);
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
    RefreshRelationMap;
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
  lbTbFieldCount.Caption := Format(srTbFieldCountFmt, [StringGridTableFields.RowCount - 1]);
  DoTablePropsChanged(FCtMetaTable);
  RefreshDesc;
  RefreshUIPreview;
  RefreshFieldProps;
  RefreshRelationMap;
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
  RefreshRelationMap;
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
    RefreshRelationMap;
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
  if not IsValidTableName(edtTableName.Text, True) then
  begin
    Abort;
  end;
  FCtMetaTable.Name := edtTableName.Text;
  FCtMetaTable.Caption := edtDispName.Text;
  DoTablePropsChanged(FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(0, FCtMetaTable, nil, '');
  RefreshDesc;
  RefreshUIPreview;
  RefreshFieldProps;
  RefreshRelationMap;
end;

procedure TFrameCtTableProp.edtTextNameExit(Sender: TObject);
begin
  if FCtMetaTable = nil then
    Exit;                         
  if not IsValidTableName(edtTextName.Text, True) then
  begin
    Abort;
  end;
  if FCtMetaTable.Name <> edtTextName.Text then
  begin          
    if not CheckCanRenameTable(FCtMetaTable, edtTextName.Text, False) then
    begin
      edtTextName.Text := FCtMetaTable.Name;
      edtTextName.SetFocus;
      Abort;
    end;
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
  else if ARowIndex >= StringGridTableFields.RowCount then
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
  begin
    if not AField.CheckCanRenameTo(NewValue) then
    begin
      Abort;
    end;
    if AField.OldName = '' then
      AField.OldName:=AField.Name;
    AField.Name := NewValue;
  end;
  if aCol = 2 then
    AField.DisplayName := NewValue;

  if aCol = 3 then
  begin
    S := Trim(NewValue);

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
        if (UpperCase(Trim(T)) = 'LONG') or (UpperCase(Trim(T))='MAX') then
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
    RefreshRelationMap;
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
    RefreshRelationMap;
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
    RefreshRelationMap;
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
    RefreshRelationMap;
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
    RefreshRelationMap;
    Exit;
  end;
            
  if prop = 'table_changed' then
  begin                                                     
    FCtMetaTable.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);              
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(2, FCtMetaTable, nil, ''); 
    memoDesignNotes.Lines.Text := FCtMetaTable.DesignNotes;
    MemoTableComment.Lines.Text := FCtMetaTable.Memo;
    RefreshDesc;
    RefreshUIPreview;
    RefreshFieldProps;
    RefreshRelationMap;
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
              
  if prop = 'insert_new_field' then
  begin
    actFieldAddExecute(UIPreviewFrame);
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
  if prop = 'AggregateFun' then
  begin
    if fd = nil then
      Exit;
    fd.AggregateFun := Value;
    DoFieldChanged(fd);
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
  if prop = 'ShowFilterBox' then
  begin
    if fd = nil then
      Exit;
    fd.ShowFilterBox := GetBoolPropV(fd.ShowFilterBox);
    DoFieldChanged(fd);
  end;
  if prop = 'Exportable' then
  begin
    if fd = nil then
      Exit;
    fd.Exportable := GetBoolPropV(fd.Exportable);
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

function TFrameCtTableProp.CurTbHasAdvProps: Boolean;
begin
  if FCtMetaTable = nil then
  begin 
    Result := False;
    Exit;
  end;

  Result := True;
  if FCtMetaTable.PhysicalName <> '' then
    Exit;                
  if FCtMetaTable.UIDisplayText <> '' then
    Exit;
  if FCtMetaTable.ListSQL <> '' then
    Exit;
  if FCtMetaTable.ViewSQL <> '' then
    Exit;               
  if FCtMetaTable.ExtraSQL <> '' then
    Exit;
  if FCtMetaTable.UILogic <> '' then
    Exit;               
  if FCtMetaTable.BusinessLogic <> '' then
    Exit;
  if FCtMetaTable.ExtraProps <> '' then
    Exit;       
  if FCtMetaTable.ScriptRules <> '' then
    Exit;

  if FCtMetaTable.SQLWhereClause <> '' then
    Exit;
  if FCtMetaTable.SQLOrderByClause <> '' then
    Exit;
  if FCtMetaTable.SQLAlias <> '' then
    Exit;
  if FCtMetaTable.OwnerCategory <> '' then
    Exit;
  if FCtMetaTable.GroupName <> '' then
    Exit;
  if FCtMetaTable.PartitionInfo <> '' then
    Exit;
  if FCtMetaTable.DesignNotes <> '' then
    Exit;

  Result := False;
end;

procedure TFrameCtTableProp._OnRelationMapRefresh(Sender: TObject);
begin
  RefreshRelationMap;
end;

procedure TFrameCtTableProp.GotoTab(tab: TTabSheet);
var
  bChg: Boolean;
begin
  if tab = nil then
    Exit;
  bChg := False;
  if PageControlTbProp.ActivePage<>tab then
    bChg := True;
  if not tab.TabVisible then
    bChg := True;
  tab.TabVisible:= True;
  PageControlTbProp.ActivePage:=tab;
  PageControlTbPropChange(nil);  
  if tab = TabSheetAdvanced then
    G_EnableAdvTbProp := True
  else if tab = TabSheetUI then
    G_EnableTbPropUIDesign := True
  else if tab = TabSheetCodeGen then
    G_EnableTbPropGenerate := True
  else if tab = TabSheetCust then
    G_EnableCustomPropUI := True
  else if tab = TabSheetRelations then
    G_EnableTbPropRelations := True
  else if tab = TabSheetData then
    G_EnableTbPropData := True;
  if bChg then
  begin
    SaveTabVisibles;
    if Assigned(tab.OnShow) then
      tab.OnShow(nil);
  end;
end;

procedure TFrameCtTableProp.CloseCurTab;
var
  I, pg: Integer;
begin
  if PageControlTbProp.ActivePage = TabSheetAdvanced then
    G_EnableAdvTbProp := False
  else if PageControlTbProp.ActivePage = TabSheetUI then
    G_EnableTbPropUIDesign := False
  else if PageControlTbProp.ActivePage = TabSheetCodeGen then
    G_EnableTbPropGenerate := False          
  else if PageControlTbProp.ActivePage = TabSheetCust then
    G_EnableCustomPropUI := False
  else if PageControlTbProp.ActivePage = TabSheetRelations then
    G_EnableTbPropRelations := False
  else if PageControlTbProp.ActivePage = TabSheetData then
    G_EnableTbPropData := False
  else
    Exit;

  pg := 0;
  for I:=PageControlTbProp.ActivePageIndex-1 downto 0 do
    if PageControlTbProp.Pages[I].TabVisible then
    begin
      pg := I;
      Break;
    end;
  PageControlTbProp.ActivePage.TabVisible := False;
  PageControlTbProp.ActivePageIndex := pg;     
  PageControlTbPropChange(nil);
  SaveTabVisibles;
end;

procedure TFrameCtTableProp.SaveTabVisibles;   
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GetConfFileOfApp);
  try
    ini.WriteBool('Options', 'EnableCustomPropUI', G_EnableCustomPropUI);
    ini.WriteBool('Options', 'EnableAdvTbProp', G_EnableAdvTbProp);
    ini.WriteBool('Options', 'EnableTbPropGenerate', G_EnableTbPropGenerate);
    ini.WriteBool('Options', 'EnableTbPropRelations', G_EnableTbPropRelations);
    ini.WriteBool('Options', 'EnableTbPropData', G_EnableTbPropData);
    ini.WriteBool('Options', 'EnableTbPropUIDesign', G_EnableTbPropUIDesign);
  finally
    ini.Free;
  end;
end;

procedure TFrameCtTableProp.DoEscape;
begin
  if Assigned(Proc_GridEscape) then
    Proc_GridEscape(Self);
end;

procedure TFrameCtTableProp.RealignGenToolbar;
begin
  btnEditScript.Left := listboxGenTypes.Width + 5;
  btnShowSettings.Left := btnEditScript.Left + btnEditScript.Width + 5;
  if btnSaveSettings.Visible then
  begin
    btnSaveSettings.Left := btnShowSettings.Left + btnShowSettings.Width + 5;    
    edtGenTxtFind.Left := btnSaveSettings.Left + btnSaveSettings.Width + 5;
  end
  else if btnShowSettings.Visible then                                    
    edtGenTxtFind.Left := btnShowSettings.Left + btnShowSettings.Width + 5
  else if btnEditScript.Visible then
    edtGenTxtFind.Left := btnShowSettings.Left
  else
    edtGenTxtFind.Left := btnEditScript.Left;
end;

procedure TFrameCtTableProp.MItem_FieldWeightClick(Sender: TObject);  
var
  MItem: TMenuItem;
  S, V: String;  
  wt: Integer;
begin     
  if FReadOnlyMode then
    Exit;
  if not (Sender is TMenuItem) then
    Exit;
  MItem := TMenuItem(Sender);
  S := MItem.Hint;
  if S='' then
    Exit;
  V := GetCtDropDownValueOfText(S, srFieldWeights);
  if V='' then
    Exit;
  wt := StrToInt(V);
  ChangeFieldWeight(0, wt);
end;

procedure TFrameCtTableProp.ChangeFieldWeight(iOpType, iRes: Integer);
var
  AField: TCtMetaField;
  ARowIndex: integer;
  I, owt, wt: Integer;
  bChged: Boolean;
begin
  //iOpType: 0设置权重为iRes 1增加权重 2降低权重
  if FReadOnlyMode then
    Exit;
  wt := iRes;

  GetSelectedFields;       
  if FSelFields.Count = 0 then
    Exit;    
    ARowIndex := StringGridTableFields.Row;
  if iOpType = 1 then
  begin    
    AField := FieldOfGridRow(ARowIndex);
    owt := AField.FieldWeight;
    if owt<-1 then
      wt := -1
    else if owt < 0 then
      wt := 0
    else
      wt := 1;
  end
  else if iOpType = -1 then
  begin
    AField := FieldOfGridRow(ARowIndex);
    owt := AField.FieldWeight;
    if owt>0 then
      wt := 0
    else if owt > -1 then
      wt := -1
    else
      wt := -9;
  end;
  if FSelFields.Count <= 1 then
  begin
    ARowIndex := StringGridTableFields.Row;
    if ARowIndex <= 0 then
      Exit;
    AField := FieldOfGridRow(ARowIndex);
    if AField.FieldWeight = wt then
      Exit;
    AField.FieldWeight := wt;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, AField, nil, '');
    DoTablePropsChanged(FCtMetaTable);
    RefreshUIPreview;
    RefreshFieldProps;
    StringGridTableFields.Refresh;
    Exit;
  end;

  FieldListHideEditor;
  bChged:= False;
  for I:=0 to FSelFields.Count - 1 do
  begin
    ARowIndex := RowIndexOfField(FSelFields[I]);
    if ARowIndex <= 0 then
      Continue;
    AField := FieldOfGridRow(ARowIndex);
    if AField.FieldWeight = wt then
      Continue;
    AField.FieldWeight := wt;
    bChged:= True;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(0, AField, nil, '');
  end;
  if bChged then
  begin
    DoTablePropsChanged(FCtMetaTable);
    RefreshUIPreview;
    RefreshFieldProps;
    StringGridTableFields.Refresh;
  end;
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
    RefreshUIPreview;
  end;       
  if Sender=edtPhysicalName then
  begin
    if FCtMetaTable.PhysicalName = edtPhysicalName.Text then
      Exit;
    FCtMetaTable.PhysicalName := edtPhysicalName.Text;
    RefreshDesc;  
    RefreshUIPreview;
  end;         
  if Sender=edtUIDisplayText then
  begin
    if FCtMetaTable.UIDisplayText = edtUIDisplayText.Text then
      Exit;
    FCtMetaTable.UIDisplayText := edtUIDisplayText.Text;  
    RefreshUIPreview;
  end;               
  if Sender=memoListSQL then
  begin
    if FCtMetaTable.ListSQL = memoListSQL.Lines.Text then
      Exit;
    FCtMetaTable.ListSQL := memoListSQL.Lines.Text;
  end;
  if Sender=memoViewSQL then
  begin
    if FCtMetaTable.ViewSQL = memoViewSQL.Lines.Text then
      Exit;
    FCtMetaTable.ViewSQL := memoViewSQL.Lines.Text;
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
  if Sender = colobBgColor then
  begin      
    if FCtMetaTable.BgColor = colobBgColor.Selected then
      Exit;
    FCtMetaTable.BgColor := colobBgColor.Selected;
  end;

  if Sender=edtSQLAlias then
  begin
    if FCtMetaTable.SQLAlias = edtSQLAlias.Text then
      Exit;
    FCtMetaTable.SQLAlias := edtSQLAlias.Text;
  end;

  if Sender=edtOwnerCategory then
  begin
    if FCtMetaTable.OwnerCategory = edtOwnerCategory.Text then
      Exit;
    FCtMetaTable.OwnerCategory := edtOwnerCategory.Text;
  end;

  if Sender=edtGroupName then
  begin
    if FCtMetaTable.GroupName = edtGroupName.Text then
      Exit;
    FCtMetaTable.GroupName := edtGroupName.Text;
  end;

  if Sender=memoSQLWhereClause then
  begin
    if FCtMetaTable.SQLWhereClause = memoSQLWhereClause.Lines.Text then
      Exit;
    FCtMetaTable.SQLWhereClause := memoSQLWhereClause.Lines.Text;
  end;

  if Sender=memoSQLOrderByClause then
  begin
    if FCtMetaTable.SQLOrderByClause = memoSQLOrderByClause.Lines.Text then
      Exit;
    FCtMetaTable.SQLOrderByClause := memoSQLOrderByClause.Lines.Text;
  end;

  if Sender=memoPartitionInfo then
  begin
    if FCtMetaTable.PartitionInfo = memoPartitionInfo.Lines.Text then
      Exit;
    FCtMetaTable.PartitionInfo := memoPartitionInfo.Lines.Text;
  end;

  if Sender=memoDesignNotes then
  begin
    if FCtMetaTable.DesignNotes = memoDesignNotes.Lines.Text then
      Exit;
    FCtMetaTable.DesignNotes := memoDesignNotes.Lines.Text; 
    RefreshUIPreview;
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
        if (ext <> '.pas') then     
          {$ifndef EZDML_LITE}
          if (ext <> '.js') then   
          {$endif}
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
  nfn, ofn: string;
  {$ifdef EZDML_LITE}
  ScLt : TDmlPasScriptorLite;
  AOutput: TStrings;
  {$endif}

begin
  Result := '';
  if FCtMetaTable = nil then
    Exit;
               
  {$ifndef EZDML_LITE}
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

  {$else}         
  btnShowSettings.Enabled := False;
  btnEditScript.Enabled := True;
  btnSaveSettings.Enabled := False;
  Panel_ScriptSettings.Visible := False;
  RealignGenToolbar;

  ScLt := CreatePsLiteScriptor(fn);
  if ScLt <> nil then
  begin
    AOutput := TStringList.Create;
    try
      ofn := fn+'.paslt';
      with ScLt do
      begin       
        btnViewInBrowser.Visible :=
          (LowerCase(Copy(ofn, 1, 4)) = 'html') or (Pos('_html.', LowerCase(ofn)) > 0) or
          (Pos('_md.', LowerCase(ofn)) > 0)or
          (Pos('_vue.', LowerCase(ofn)) > 0);
        Init('DML_SCRIPT', FCtMetaTable, AOutput, FDmlScControls);
        Exec('DML_SCRIPT', '');
        Result := AOutput.Text;
      end;
    finally
      AOutput.Free;
      ScLt.Free;
    end;
  end;   
  {$endif}
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
  {$ifndef EZDML_LITE}
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
        RealignGenToolbar;
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
  {$else}
  raise Exception.Create(srEzdmlLiteNotSupportFun);
  {$endif}
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
    begin
      Result := 2 + integer(TCtMetaField(Nd).DataType);
      if TCtMetaField(Nd).FieldWeight < 0 then
        Result := Result + 20;
    end;
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
  {$ifdef EZDML_LITE}    
  btnShowSettings.Visible := False;
  //btnEditScript.Visible := False;
  btnSaveSettings.Visible := False;
  Panel_ScriptSettings.Visible := False;
  {$endif}
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
  RealignGenToolbar;         
  {$ifndef EZDML_LITE}
  TDmlScriptControlList(FDmlScControls).CurFileName := '';
  {$endif}
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
  else if T = 'Hive' then
    S := '-- Hive Sql Generate '#13#10#13#10 +
      FCtMetaTable.GenSql('HIVE') + #13#10 +
      FCtMetaTable.GenDqlDmlSql('HIVE')
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

procedure TFrameCtTableProp.TimerAutoFocusTimer(Sender: TObject);
begin
  TimerAutoFocus.Enabled := False;
  if Self.FAutoFocusRow>0 then
  begin
    StringGridTableFields.Row := FAutoFocusRow;
  end;
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
  if ctNodeC = nil then
    Exit;

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
  RefreshRelationMap;
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

procedure TFrameCtTableProp.btnToggleTabsClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := Point(0, btnToggleTabs.Height);
  pt := btnToggleTabs.ClientToScreen(pt);
  PopupMenuTabs.PopUp(pt.x, pt.y);
end;

procedure TFrameCtTableProp.ckbForeignKeysOnlyChange(Sender: TObject);
begin
  RefreshRelationMap;
end;

procedure TFrameCtTableProp.colobBgColorGetColors(Sender: TCustomColorBox;
  Items: TStrings);
var
  I: Integer;
  procedure AddCL(cls: string);
  var
    cl: Integer;
  begin
    cl:=StrToIntDef('$'+cls, 0);
    Items.InsertObject(I+1, 'EzColor' + IntToStr(I), TObject(PtrInt(cl)));
    Inc(I);
  end;
begin
  I := Items.IndexOf('Black');
  if I >= 0 then
    Items.Delete(I);
  Items.InsertObject(1,srDmlDefaultColor, TObject(PtrInt(0)));

  I:=1;
  AddCL('ccccff');
  AddCL('d9e6ff');
  AddCL('ccffff');
  AddCL('ccffcc');
  AddCL('ffffcc');
  AddCL('ffcccc');
  AddCL('ffccff');
  AddCL('e6e6e6');

  AddCL('eeeeff');
  AddCL('f0f7ff');
  AddCL('eeffff');
  AddCL('eeffee');
  AddCL('ffffee');
  AddCL('ffeeee');
  AddCL('ffeeff');
  AddCL('f6f6f6');
end;

procedure TFrameCtTableProp.edtGenTxtFindKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  F, S, T: WideString;
  p1, p2: integer;
begin
  if Key <> VK_RETURN then
    Exit;
  F := UpperCase(edtGenTxtFind.Text);
  if F = '' then
    Exit;
  T := UpperCase(MemoCodeGen.Lines.Text);
  p1 := MemoCodeGen.SelStart + MemoCodeGen.SelLength;
  S := Copy(T, p1 + 1, Length(T));
  p2 := Pos(F, S);
  if p2 > 0 then
  begin
    MemoCodeGen.SelStart := p1 + p2 - 1;
    MemoCodeGen.SelLength := Length(F);
  end
  else
    Application.MessageBox(PChar(srDmlSearchNotFound), PChar(Application.Title),
      MB_OK or MB_ICONINFORMATION);
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
    RefreshRelationMap;

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
  AField.FieldWeight := -9;
  AddDxFieldNode(AField);
  TCtMetaTable(pctnode).MetaFields.SaveCurrentOrder;
  DoTablePropsChanged(Self.FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(0, AField, nil, '');
  RefreshDesc;
  RefreshUIPreview;
  RefreshRelationMap;
  RefreshFieldProps;

  StringGridTableFields.Row := StringGridTableFields.RowCount - 1;
end;

procedure TFrameCtTableProp.actPasteFromExcelExecute(Sender: TObject);
var
  bSkipEmptyCol4: boolean;

  function ReplaceExcelQuotLF(sIn: string): string;
  var
    I, L: Integer;
  begin  //替换掉双引号中的回车换行制表符
    Result := '';
    L := Length(sIn);
    I:=1;
    while I <= L do
    begin
      if sIn[I]='"' then
      begin
        Inc(I);
        while I <= L do
        begin
          if sIn[I]=#9 then
            Result := Result+'\t'
          else if sIn[I]=#10 then
            Result := Result+'\n'
          else if sIn[I]=#13 then
            Result := Result+'\r'
          else if sIn[I]='"' then
          begin
            if I=L then
              Break;
            if sIn[I+1]<>'"' then  //下一个是不是双引号？不是就结束了
            begin
              Inc(I);
              Break;
            end;
            Result := Result+'"';   //两个双引号? 转成一个
            Inc(I);
          end
          else   
            Result := Result+sIn[I];
          Inc(I);
        end;
      end
      else
      begin
        Result := Result+sIn[I];
        Inc(I);
      end;
    end;
  end;

  procedure SetCellText(ARow, ACol: integer; AValue: string);
  var
    po: integer;
    vTp, vSz: string;
  begin
    if (ARow < 1) then
      Exit;
    if ACol=4 then
      if bSkipEmptyCol4 then
        Exit;
    while (StringGridTableFields.RowCount <= ARow) do
    begin
      StringGridTableFields.Row := StringGridTableFields.RowCount - 1;
      actFieldAddExecute(actPasteFromExcel);
      StringGridTableFields.Row := StringGridTableFields.RowCount - 1;
    end;
    if (ACol = 3) and (Pos('(', AValue) > 0) and (AValue[Length(AValue)] = ')') then
    begin   //类似String(255)的类型，包含了长度
      po := Pos('(', AValue);
      vTp := Copy(AValue, 1, po - 1);
      vSz := Copy(AValue, po + 1, Length(AValue) - po - 1);
      StringGridTableFields.Cells[ACol, ARow] := vTp;
      _OnCellXYValSet(ACol, ARow, vTp, False);
      StringGridTableFields.Cells[ACol + 1, ARow] := vSz;
      _OnCellXYValSet(ACol + 1, ARow, vSz, False);
      bSkipEmptyCol4 := True; //在类型已经顺带设置了长度的情况下，忽略下一单元格长度为空的设置
    end
    else
    begin
      StringGridTableFields.Cells[ACol, ARow] := AValue;
      _OnCellXYValSet(ACol, ARow, AValue, False);
    end;
  end;

var
  S, T, V, sCrLf: string;
  ss, sv: TStringList;
  I, J, x, y, po: integer;
  bCrLf: Boolean;
begin
  S := Clipboard.AsText;
  if Trim(S) = '' then
    Exit;
  if not PvtInput.PvtMemoQuery(actPasteFromExcel.Caption, srPasteFromExcelPrompt, S, False) then
    Exit;
  ss := TStringList.Create;
  sv := TStringList.Create;
  try        
    sCrLf := '<crlf>';
    bCrLf := False;
    if (Pos(sCrLf+#9, S+#9) > 0) or (Pos(sCrLf+#10, S+#10) > 0) or (Pos(sCrLf+#13, S+#13) > 0) then
    begin  //对用<crlf>分隔的进行替换处理
      S := Trim(S);
      S := StringReplace(S, #13#10'<crlf>', '<crlf>', [rfReplaceAll]);    
      S := StringReplace(S, #13'<crlf>', '<crlf>', [rfReplaceAll]);
      S := StringReplace(S, #10'<crlf>', '<crlf>', [rfReplaceAll]);  
      S := StringReplace(S, '<crlf>'#9, '<crlf>', [rfReplaceAll]);
      S := StringReplace(S, #13, '\r', [rfReplaceAll]);
      S := StringReplace(S, #10, '\n', [rfReplaceAll]);  
      S := StringReplace(S, '<crlf>', #13#10, [rfReplaceAll]);
      bCrLf := True;
    end
    else
    begin
      if (Pos(#9'"', #9+S)>0) or (Pos(#10'"', #10+S)>0) then
      begin
        S := ReplaceExcelQuotLF(S); //对有双引号的进行处理 
        bCrLf := True;
      end;

      //对于多行备注可能跨行的情况进行处理，如果一行数据只有备注有值，则将内容归到上一行，并清空本行
      ss.Text := S;  
      for I := ss.Count - 1 downto 0 do
      begin
        V := ss[I];   
        po := Pos('\n', V);
        if po>0 then
        begin
          //忽略回车符后面的制表符
          T := Copy(V, po+1, Length(V));
          V := Copy(V, 1, po);
          T := StringReplace(T, #9, ' ', [rfReplaceAll]);
          V := V+ T;
        end;
        sv.Text := StringReplace(V, #9, #10, [rfReplaceAll]);
        if sv.Count >= 6 then
        begin
          if Trim(sv[0]+sv[1]+sv[2]+sv[3]+sv[4]) = '' then
          begin
            ss[I-1] := ss[I-1] + '\n' + Trim(V);
            ss.Delete(I);
            bCrLf := True;
          end;
        end;
      end;
      S := ss.Text;
    end;

    ss.Text := S;
    while ss.Count > 0 do
      if Trim(ss[0])='' then
        ss.Delete(0)      
      else if Trim(ss[ss.Count-1])='' then
        ss.Delete(ss.Count-1)
      else
        Break;
    x := StringGridTableFields.Col;
    y := StringGridTableFields.Row;
    if y <= 0 then
      y := 1;
    if x = 0 then
      x := 1;
    for I := 0 to ss.Count - 1 do
    begin
      V := ss[I];
      if Trim(V) = '' then
        Continue;
      po := Pos('\n', V);
      if po>0 then
      begin
        //忽略回车符后面的制表符
        T := Copy(V, po+1, Length(V));
        V := Copy(V, 1, po);
        T := StringReplace(T, #9, ' ', [rfReplaceAll]);
        V := V+ T;
      end;
      sv.Text := StringReplace(V, #9, #10, [rfReplaceAll]);  
      bSkipEmptyCol4 := False;
      for J := 0 to sv.Count - 1 do
      begin
        try
          V := sv[J];
          if bCrLf then
          begin
            V := StringReplace(V, '\r', #13, [rfReplaceAll]);
            V := StringReplace(V, '\n', #10, [rfReplaceAll]);
          end;
          SetCellText(y, x + J, V);
        except
        end;
      end; 
      Inc(y);
    end;

    FCtMetaTable.MetaFields.SaveCurrentOrder;
    DoTablePropsChanged(Self.FCtMetaTable);
    if Assigned(Proc_OnPropChange) then
      Proc_OnPropChange(2, FCtMetaTable, nil, '');
    RefreshDesc;
    RefreshUIPreview;
    RefreshRelationMap;
    RefreshFieldProps;
  finally
    ss.Free;
    sv.Free;
  end;
end;

procedure TFrameCtTableProp.actShowAdvPageExecute(Sender: TObject);
begin
  ShowAdvPage := True;       
  G_EnableAdvTbProp := True;
  TabSheetAdvanced.TabVisible := ShowAdvPage;
  PageControlTbProp.ActivePage := TabSheetAdvanced;
  PageControlTbPropChange(nil);
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

procedure TFrameCtTableProp.ListBoxRelTbsClick(Sender: TObject);
var
  idx: Integer;
  tb: TCtMetaTable;
begin
  if RelateDmlForm=nil then
    Exit;
  idx := ListBoxRelTbs.ItemIndex;
  if idx < 0 then
    Exit;
  tb := TCtMetaTable(ListBoxRelTbs.Items.Objects[idx]);
  if tb=nil then
    Exit;
  if not TfrmCtDML(RelateDmlForm).LocToCtObj(tb) then
    Exit;
  if tb.Name = Self.FCtMetaTable.Name then
    Exit;
  TfrmCtDML(RelateDmlForm).SelectRelateLink(tb, FCtMetaTable, True);
end;

procedure TFrameCtTableProp.ListBoxRelTbsDblClick(Sender: TObject);
begin
  if RelateDmlForm=nil then
    Exit;
  TfrmCtDML(RelateDmlForm).FFrameCtDML.actDMLObjProp.Execute;
end;

procedure TFrameCtTableProp.ListBoxRelTbsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_ESCAPE) then
    DoEscape;
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
var
  S,V: String;
begin
  if Shift = [] then
  begin
    if Key = VK_ESCAPE then
    begin
      if FReadOnlyMode then
      begin
        DoEscape;
        Exit;
      end;
      V := MemoDesc.Lines.Text;
      V := StringReplace(V, #13#10, #10, [rfReplaceAll]);
      S := FCtMetaTable.Describe;
      S := StringReplace(S, #13#10, #10, [rfReplaceAll]);
      if Trim(S)=Trim(V) then
      begin
        DoEscape;
        Exit;
      end;
    end;
  end;
  if ssCtrl in Shift then
    if (Key = Ord('f')) or (Key = Ord('F')) then
      sbtnFindClick(nil);
end;

procedure TFrameCtTableProp.MemoTextContentDblClick(Sender: TObject);
begin
  if (GetKeyState(VK_CONTROL) and $80) <> 0 then
    actShowInGraph.Execute;
end;

procedure TFrameCtTableProp.MemoTextContentKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  S,V: String;
begin
  if Shift = [] then
  begin
    if Key = VK_ESCAPE then
    begin
      if FReadOnlyMode then
      begin
        DoEscape;
        Exit;
      end;
      V := MemoTextContent.Lines.Text;
      V := StringReplace(V, #13#10, #10, [rfReplaceAll]);
      S := FCtMetaTable.Memo;
      S := StringReplace(S, #13#10, #10, [rfReplaceAll]);
      if Trim(S)=Trim(V) then
      begin
        DoEscape;
        Exit;
      end;
    end;
  end;
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

  {$ifdef EZDML_LITE}
    for I := 0 to High(CtPsLiteRegs) do
      if CtPsLiteRegs[I].Cat='Table' then
        SS2.Add(CtPsLiteRegs[I].Name);
  {$endif}

    frmGenTabCust:= TfrmGenTabCust.Create(nil);
    frmGenTabCust.Init(ss1,ss2);
    if frmGenTabCust.ShowModal=mrOk then
    begin
      ss1.Clear;
      frmGenTabCust.GetConfigResult(ss1);
      S := GetDmlScriptDir;
      if not DirectoryExists(S) then
        ForceDirectories(S);
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

procedure TFrameCtTableProp.MNTabs_CloseClick(Sender: TObject);
begin
  CloseCurTab;
end;

procedure TFrameCtTableProp.MNTabs_CustClick(Sender: TObject);
begin
  GotoTab(TabSheetCust);
end;

procedure TFrameCtTableProp.MNTabs_DataClick(Sender: TObject);
begin
  GotoTab(TabSheetData);
end;

procedure TFrameCtTableProp.MNTabs_GenClick(Sender: TObject);
begin
  GotoTab(TabSheetCodeGen);
end;

procedure TFrameCtTableProp.MNTabs_RelationsClick(Sender: TObject);
begin
  GotoTab(TabSheetRelations);
end;

procedure TFrameCtTableProp.MNTabs_SettingsClick(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001 {WMZ_CUSTCMD}, 7, 0);
end;

procedure TFrameCtTableProp.MNTabs_UIDesignClick(Sender: TObject);
begin           
  {$ifndef EZDML_LITE}  
  GotoTab(TabSheetUI);
  {$else}
  raise Exception.Create(srEzdmlLiteNotSupportFun);
  {$endif}
end;

procedure TFrameCtTableProp.MN_OpenTemplFolderClick(Sender: TObject);
var
  S, dir, fn, nfn: string;
begin
  dir := GetFolderPathOfAppExe('Templates');
  fn := '';                        
  if FGenCodeType <> '' then
    if not IsInnerSqlTab(FGenCodeType) then
    begin            
      {$ifndef EZDML_LITE}
      nfn := FolderAddFileName(GetDmlScriptDir, FGenCodeType + '.js');
      if FileExists(nfn) then
      begin
        fn := nfn;
      end
      else   
      {$endif}
      begin
        nfn := FolderAddFileName(GetDmlScriptDir, FGenCodeType + '.pas');
        if FileExists(nfn) then
        begin
          fn := nfn;
        end;
      end;
    end;    
  if fn <> '' then
    CtBrowseFile(fn)
  else
    CtOpenDir(dir);
end;

procedure TFrameCtTableProp.PageControlTbPropChange(Sender: TObject);
begin
  if (PageControlTbProp.ActivePage = TabSheetUI) then
  begin
    if TabSheetUI.Tag = 999 then
      RefreshUIPreview;
  end;

  if (PageControlTbProp.ActivePage = TabSheetRelations) then
  begin
    if TabSheetRelations.Tag = 999 then
      RefreshRelationMap;
  end;
    
  if PageControlTbProp.ActivePage = TabSheetCodeGen then
  begin
    if TabSheetCodeGen.Tag = 999 then
      GenTbCode;
  end;
end;

procedure TFrameCtTableProp.PageControlTbPropContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  pt: TPoint;    
  tk: Int64;
begin
  if not TabSheetTable.TabVisible then
    Exit;
  tk := GetTickCount64;
  if Abs(tk-FLastTabClickTick) > 1000 then
    Exit;
  if FLastTabClickPos.Y > ScaleDPISize(30) then
    Exit;
  pt := PageControlTbProp.ClientToScreen(MousePos);
  PopupMenuTabs.PopUp(pt.X, pt.Y);
  Handled := True;
end;

procedure TFrameCtTableProp.PageControlTbPropMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tk: Int64;
begin
  tk := GetTickCount64;
  if Y > ScaleDPISize(30) then
  begin
    FLastTabClickTick := tk; 
    FLastTabClickPos := Point(X, Y);
    Exit;
  end;
  if Abs(tk-FLastTabClickTick) < 800 then
  begin               
    if Button = mbLeft then
      if Abs(FLastTabClickPos.X - X)<=3 then
        if Abs(FLastTabClickPos.Y - Y)<=3 then
        begin
          CloseCurTab;
          FLastTabClickTick := 0;
          FLastTabClickPos := Point(0, 0);
          Exit;
        end;
  end;
  FLastTabClickPos := Point(X, Y);
  FLastTabClickTick := tk;
end;

procedure TFrameCtTableProp.PanelCustomScriptDefResize(Sender: TObject);
begin                                      
  {$ifndef EZDML_LITE}        
  TDmlScriptControlList(FCustDmlScControls).RealignControls;
  {$endif}
end;

procedure TFrameCtTableProp.Panel_ScriptSettingsResize(Sender: TObject);
begin                             
  {$ifndef EZDML_LITE}
  TDmlScriptControlList(FDmlScControls).RealignControls;
  {$endif}
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
  CtBrowseFile(fn);
end;

procedure TFrameCtTableProp.PopupMenuTabsPopup(Sender: TObject);
var
  bEnb : Boolean;
begin
  bEnb := False;
  if PageControlTbProp.ActivePage = TabSheetAdvanced then
    bEnb := True
  else if PageControlTbProp.ActivePage = TabSheetUI then
    bEnb := True
  else if PageControlTbProp.ActivePage = TabSheetRelations then
    bEnb := True
  else if PageControlTbProp.ActivePage = TabSheetCust then
    bEnb := True           
  else if PageControlTbProp.ActivePage = TabSheetCodeGen then
    bEnb := True
  else if PageControlTbProp.ActivePage = TabSheetData then
    bEnb := True;
  MNTabs_Close.Enabled := bEnb;
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

procedure TFrameCtTableProp.sbtnTbJsonClick(Sender: TObject);
var
  tb: TCtMetaTable;
  S, V: String;
begin   
  if not Assigned(FCtMetaTable) then
    Exit;
  S:= FCtMetaTable.JsonStr;
  if Self.FReadOnlyMode then
  begin
    PvtInput.PvtMemoQuery(FCtMetaTable.NameCaption, 'JSON:', S, True);
    Exit;
  end;

  V:=S;
  if not PvtInput.PvtMemoQuery(FCtMetaTable.NameCaption, 'JSON:', V, False) then
    Exit;

  if Trim(V)=Trim(S) then
    Exit;

  tb := TCtMetaTable.Create;
  try
    tb.JsonStr := V;
    if Assigned(Proc_OnPropChange) then
      if FCtMetaTable.Name <> tb.Name then
      begin
        if not CheckCanRenameTable(FCtMetaTable, tb.Name, False) then
          Abort;
      end;
  finally
    tb.Free;
  end;
  FCtMetaTable.JsonStr := V;
  DoTablePropsChanged(FCtMetaTable);
  if Assigned(Proc_OnPropChange) then
    Proc_OnPropChange(2, FCtMetaTable, nil, '');
  ShowTableProp(FCtMetaTable);
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

procedure TFrameCtTableProp.SplitterGenTpsMoved(Sender: TObject);
begin
  RealignGenToolbar;
end;


procedure TFrameCtTableProp.StringGridTableFieldsDrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
var
  dd, idx: integer;
  AField: TCtMetaField;
  bEnb: Boolean;
begin
  if (ACol = 0) and (ARow > 0) then
  begin
    AField := FieldOfGridRow(aRow);
    idx := GetImageIndexOfCtNode(AField);
    bEnb := True;
    if AField <> nil then
    begin                         
      if AField.FieldWeight <= -9 then
        idx := -1;
      if AField.FieldWeight < 0 then
        bEnb := False;
    end;
    if idx >= 0 then
    begin
      dd := StringGridTableFields.DefaultRowHeight - ScaleDPISize(ImageListCttb.Height);
      dd := dd div 2;
      ImageListCttb.Scaled := True;
      ImageListCttb.DrawForPPI(StringGridTableFields.Canvas, ARect.Left +
        dd, ARect.Top + dd, idx, ImageListCttb.Width, Screen.PixelsPerInch, 1, bEnb);
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
    VK_LEFT:
      if Shift = [ssCtrl] then
      begin
        FieldListHideEditor;
        ChangeFieldWeight(1, 0);
        Key := 0;
      end;
    VK_RIGHT:
      if Shift = [ssCtrl] then
      begin
        FieldListHideEditor;
        ChangeFieldWeight(-1, 0);
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
        DoEscape;
    end;
  end;

  if Shift = [ssCtrl] then
    if not StringGridTableFields.EditorMode then
    begin
      if (Key = Ord('c')) or (Key = Ord('C')) then
      begin
        actFieldsCopy.Execute;
        Key := 0;
      end;
      if (Key = Ord('x')) or (Key = Ord('X')) then
      begin
        actFieldsCut.Execute;
        Key := 0;
      end;
      if (Key = Ord('v')) or (Key = Ord('V')) then
      begin
        actFieldsPaste.Execute;
        Key := 0;
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
      if AField.FieldWeight > 0 then  
        StringGridTableFields.Canvas.Font.Style:= [fsBold];
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
      end
      else if not (gdSelected in aState) then
      begin
        if AField.FieldWeight <= -9 then
        begin
          StringGridTableFields.Canvas.Font.Color := CtFieldTextColor_Lowest;
        end
        else if AField.FieldWeight < 0 then
        begin
          StringGridTableFields.Canvas.Font.Color := CtFieldTextColor_Low;
        end
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
  RealignGenToolbar;
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

      edtPhysicalName.Text := FCtMetaTable.PhysicalName;
      edtUIDisplayText.Text := FCtMetaTable.UIDisplayText;
      ckbGenDatabase.Checked := FCtMetaTable.GenDatabase;
      ckbGenCode.Checked := FCtMetaTable.GenCode;   
      memoListSQL.Lines.Text := FCtMetaTable.ListSQL;
      memoViewSQL.Lines.Text := FCtMetaTable.ViewSQL;
      memoExtraSQL.Lines.Text := FCtMetaTable.ExtraSQL;
      MemoUILogic.Lines.Text := FCtMetaTable.UILogic;
      memoBusinessLogic.Lines.Text := FCtMetaTable.BusinessLogic;
      memoExtraProps.Lines.Text := FCtMetaTable.ExtraProps;
      memoScriptRules.Lines.Text := FCtMetaTable.ScriptRules;
                        
      edtOwnerCategory.Text := FCtMetaTable.OwnerCategory;
      edtGroupName.Text := FCtMetaTable.GroupName;
      edtSQLAlias.Text := FCtMetaTable.SQLAlias;
      memoPartitionInfo.Lines.Text := FCtMetaTable.PartitionInfo;
      memoDesignNotes.Lines.Text := FCtMetaTable.DesignNotes;
      memoSQLOrderByClause.Lines.Text := FCtMetaTable.SQLOrderByClause;
      memoSQLWhereClause.Lines.Text := FCtMetaTable.SQLWhereClause;

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

procedure TFrameCtTableProp.SetShowAdvPage(AValue: boolean);
begin
  if FShowAdvPage=AValue then Exit;
  FShowAdvPage:=AValue;
end;

end.
