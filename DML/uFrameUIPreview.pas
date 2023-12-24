unit uFrameUIPreview;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Classes, SysUtils, Forms, Controls, ComCtrls, ExtCtrls, Grids, StdCtrls,
  ActnList, Graphics, Menus, Buttons, CtMetaTable, DmlScriptControl, Types, Dialogs,
  uFrameUISheet;

type

  { TFrameUIPreview }

  TFrameUIPreview = class(TFrame)
    actCanceItem: TAction;
    actCustItem1: TAction;
    actCustItem2: TAction;
    actCustItem3: TAction;
    actCustItem4: TAction;
    actCustItem5: TAction;
    actCustItem6: TAction;
    actCustItem7: TAction;
    actCustItem8: TAction;
    actDeleteItem: TAction;
    actExcelExp: TAction;
    actExcelImp: TAction;
    actFirstPage: TAction;
    actGotoPage: TAction;
    actCardView: TAction;
    actCatAddField: TAction;
    actCatRemoveField: TAction;
    actCatFieldMoveUp: TAction;
    actCatFieldMoveDown: TAction;
    actCatFieldProp: TAction;
    actBackToList: TAction;
    actInsertNewField: TAction;
    actPageSize: TAction;
    actShowSheet: TAction;
    actModifyItem: TAction;
    actPrint: TAction;
    actQuery: TAction;
    ActionList1: TActionList;
    actViewItem: TAction;
    actLastPage: TAction;
    actNewItem: TAction;
    actNextPage: TAction;
    actPostItem: TAction;
    actPrevPage: TAction;
    actRefresh: TAction;
    btnShowEmptyNotes: TSpeedButton;
    btnToggleUISettings: TBitBtn;
    btnUIShapePhone: TBitBtn;
    btnUIShapePC: TBitBtn;
    btnUIShapePad: TBitBtn;
    ckbAutoMerge: TCheckBox;
    ckbAutoTrim: TCheckBox;
    ckbColSortable: TCheckBox;
    ckbEditorEnabled: TCheckBox;
    ckbEditorReadOnly: TCheckBox;
    ckbHideOnEdit: TCheckBox;
    ckbHideOnList: TCheckBox;
    ckbHideOnView: TCheckBox;
    ckbIsHidden: TCheckBox;
    ckbQueryable: TCheckBox;
    ckbRequired: TCheckBox;
    ckbSearchable: TCheckBox;
    ckbExportable: TCheckBox;
    ckbShowFilterBox: TCheckBox;
    combAggregateFun: TComboBox;
    combEditorType: TComboBox;
    combFixColType: TComboBox;
    combTestDataType: TComboBox;
    combTextAlign: TComboBox;
    combValueFormat: TComboBox;
    combVisibilty: TComboBox;
    EditFastSearch: TEdit;
    edtColGroup: TEdit;
    edtColWidth: TEdit;
    edtDisplayName: TEdit;
    edtExplainText: TEdit;
    edtHint: TEdit;
    edtItemColCount: TEdit;
    edtLabelText: TEdit;
    edtMaxLength: TEdit;
    edtName: TEdit;
    edtTestDataNullPercent: TEdit;
    HeaderControlSummary: THeaderControl;
    Image1: TImage;
    Image2: TImage;
    ImageList1: TImageList;
    ImageListColTitle: TImageList;
    lbDesignNotes: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    lbMobNavTitle: TLabel;
    lbStatusTime: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label4: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label47: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label52: TLabel;
    Label56: TLabel;
    Label7: TLabel;
    ListBoxFieldCategory: TListBox;
    ListBoxFields: TListBox;
    MemoDesignNotesAll: TMemo;
    memoDropDownItems: TMemo;
    memoDesignNotes: TMemo;
    memoTestDataRules: TMemo;
    MenuItem1: TMenuItem;
    MNSc_CopyFieldName: TMenuItem;
    MNGrid_CopyFieldName: TMenuItem;
    MNGrid_CopyCell: TMenuItem;
    MNGrid_Exportable: TMenuItem;
    MNGrid_ShowFilterBox: TMenuItem;
    MNGrid_Aggr_None: TMenuItem;
    MenuItem16: TMenuItem;
    MNGrid_Aggr_TextSum: TMenuItem;
    MNGrid_Aggr_StdDev: TMenuItem;
    MNGrid_Aggr_Min: TMenuItem;
    MNGrid_Aggr_Max: TMenuItem;
    MNGrid_Aggr_Avg: TMenuItem;
    MNGrid_Aggr_Count: TMenuItem;
    MNGrid_Aggr_Sum: TMenuItem;
    MNGrid_TextAggrFun: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem9: TMenuItem;
    MNGrid_TestData_Auto: TMenuItem;
    MNGrid_TestDataType: TMenuItem;
    MNSC_TestData_Auto: TMenuItem;
    MNSC_TestDataType: TMenuItem;
    MNCF_Remove: TMenuItem;
    MNCF_MoveUp: TMenuItem;
    MNCF_MoveDn: TMenuItem;
    MenuItem14: TMenuItem;
    MNCF_Props: TMenuItem;
    MNCF_Add: TMenuItem;
    MNSC_Editor_Auto: TMenuItem;
    MNSC_EditorType: TMenuItem;
    MNSc_Align_3: TMenuItem;
    MNSc_Align_2: TMenuItem;
    MNSc_Align_1: TMenuItem;
    MNSc_Align_0: TMenuItem;
    MNSC_TextAlignment: TMenuItem;
    MNGrid_Align_2: TMenuItem;
    MNGrid_Align_3: TMenuItem;
    MNGrid_Align_1: TMenuItem;
    MNGrid_Align_0: TMenuItem;
    MNGrid_TextAlignment: TMenuItem;
    MNGrid_Sortable: TMenuItem;
    MNGrid_CopyCol: TMenuItem;
    MNGrid_CopyAll: TMenuItem;
    MNCard_BackToGrid: TMenuItem;
    MNCard_RefreshUI: TMenuItem;
    MN_ShowHiddenFields: TMenuItem;
    MNSc_MoveUp: TMenuItem;
    MenuItem11: TMenuItem;
    MNSc_CtrlName: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MNSC_MoveDown: TMenuItem;
    MNSc_Enabled: TMenuItem;
    MNSc_MoveToBottom: TMenuItem;
    MNSc_MoveToTop: TMenuItem;
    MNSC_Properties: TMenuItem;
    MNSC_Queryable: TMenuItem;
    MNSc_Readonly: TMenuItem;
    MNGrid_RefreshUI1: TMenuItem;
    MNSc_Searchable: TMenuItem;
    MNSC_Visibility: TMenuItem;
    MNSc_VisResetAll: TMenuItem;
    MNSc_Vis_0: TMenuItem;
    MNSc_Vis_1: TMenuItem;
    MNSc_Vis_2: TMenuItem;
    MNSc_Vis_3: TMenuItem;
    MNGrid_Vis_Hidden: TMenuItem;
    MNGrid_Vis4_RemoveFromGrid: TMenuItem;
    MNGrid_VisResetAll: TMenuItem;
    MenuItem5: TMenuItem;
    MNGrid_RefreshUI: TMenuItem;
    MNGrid_MoveToBack: TMenuItem;
    MNGrid_MoveToFront: TMenuItem;
    MenuItem4: TMenuItem;
    MNGrid_Properties: TMenuItem;
    MNGrid_Visibility: TMenuItem;
    MNGrid_Readonly: TMenuItem;
    MNGrid_Enabled: TMenuItem;
    MNGrid_Searchable: TMenuItem;
    MNGrid_Vis_0: TMenuItem;
    MNGrid_Vis_1: TMenuItem;
    MNGrid_Vis_3: TMenuItem;
    MNGrid_Vis_4: TMenuItem;
    MNGrid_Queryable: TMenuItem;
    MNSc_Vis_Hidden: TMenuItem;
    PaintBoxUIShape: TPaintBox;
    PanelMobileHeader: TPanel;
    PanelSheetContainer: TPanel;
    PanelToggleMaximize: TPanel;
    PanelFieldProps: TPanel;
    PanelTopDesign: TPanel;
    PanelDataCard: TPanel;
    PanelDataGridCard: TPanel;
    PanelDataQuery: TPanel;
    PanelFastSearch: TPanel;
    sbtnMobNavEdit: TSpeedButton;
    sbtnMobNavSave: TSpeedButton;
    sbtnMobNavSearch: TSpeedButton;
    sbtnMobNavDel: TSpeedButton;
    ScrollBoxUIPanels: TScrollBox;
    PanelSummary: TPanel;
    PopupMenuCatFields: TPopupMenu;
    PopupMenuGrid: TPopupMenu;
    PopupMenuCard: TPopupMenu;
    PopupMenuScControl: TPopupMenu;
    ScrollBoxFieldProps: TScrollBox;
    ScrollBoxDataCard: TScrollBox;
    Shape1: TShape;
    Shape2: TShape;
    SpdBtnAddField: TSpeedButton;
    SpdBtnDelField: TSpeedButton;
    SpdBtnDownField: TSpeedButton;
    SpdBtnUpField: TSpeedButton;
    sbtnMobNavBack: TSpeedButton;
    sbtnMobNavAdd: TSpeedButton;
    btnToggleDesignNotes: TSpeedButton;
    SplitterTopPanel: TSplitter;
    StaticTextUIScrollBR: TStaticText;
    TimerDesignNotesEdit: TTimer;
    TimerRowSelect: TTimer;
    TimerScDelayCmd: TTimer;
    ToolBarGrid: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButtonSpb2: TToolButton;
    ToolButtonSpb3: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButtonSpb0: TToolButton;
    ToolButton16: TToolButton;
    ToolButtonSpb1: TToolButton;
    ToolButton18: TToolButton;
    ToolButtonSpb4: TToolButton;
    ToolButton2: TToolButton;
    ToolButton20: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure actBackToListExecute(Sender: TObject);
    procedure actCanceItemExecute(Sender: TObject);
    procedure actCatAddFieldExecute(Sender: TObject);
    procedure actCatFieldMoveDownExecute(Sender: TObject);
    procedure actCatFieldMoveUpExecute(Sender: TObject);
    procedure actCatFieldPropExecute(Sender: TObject);
    procedure actCatRemoveFieldExecute(Sender: TObject);
    procedure actCustItem1Execute(Sender: TObject);
    procedure actExcelExpExecute(Sender: TObject);
    procedure actInsertNewFieldExecute(Sender: TObject);
    procedure actPageSizeExecute(Sender: TObject);
    procedure actPostItemExecute(Sender: TObject);
    procedure actViewItemExecute(Sender: TObject);
    procedure actModifyItemExecute(Sender: TObject);
    procedure actNewItemExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actQueryExecute(Sender: TObject);
    procedure actCardViewExecute(Sender: TObject);
    procedure actShowSheetExecute(Sender: TObject);
    procedure btnShowEmptyNotesClick(Sender: TObject);
    procedure btnToggleDesignNotesClick(Sender: TObject);
    procedure btnToggleUISettingsClick(Sender: TObject);
    procedure btnUIShapePadClick(Sender: TObject);
    procedure btnUIShapePCClick(Sender: TObject);
    procedure btnUIShapePhoneClick(Sender: TObject);
    procedure EditFastSearchEnter(Sender: TObject);
    procedure EditFastSearchExit(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure HeaderControlSummaryMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure HeaderControlSummarySectionClick(
      HeaderControl: TCustomHeaderControl; Section: THeaderSection);
    procedure HeaderControlSummarySectionResize(
      HeaderControl: TCustomHeaderControl; Section: THeaderSection);
    procedure ListBoxFieldCategoryClick(Sender: TObject);
    procedure ListBoxFieldsClick(Sender: TObject);
    procedure ListBoxFieldsDblClick(Sender: TObject);
    procedure MemoDesignNotesAllChange(Sender: TObject);
    procedure MemoDesignNotesAllExit(Sender: TObject);
    procedure MNCard_BackToGridClick(Sender: TObject);
    procedure MNGrid_Aggr_SumClick(Sender: TObject);
    procedure MNGrid_Align_Click(Sender: TObject);
    procedure MNGrid_CopyAllClick(Sender: TObject);
    procedure MNGrid_CopyCellClick(Sender: TObject);
    procedure MNGrid_CopyColClick(Sender: TObject);
    procedure MNGrid_CopyFieldNameClick(Sender: TObject);
    procedure MNGrid_TestData_Click(Sender: TObject);
    procedure MNSc_Align_Click(Sender: TObject);
    procedure MNSc_CopyFieldNameClick(Sender: TObject);
    procedure MNSC_Editor_Click(Sender: TObject);
    procedure MNSC_TestData_Click(Sender: TObject);
    procedure MNSC_VisClick(Sender: TObject);
    procedure MNSC_MoveDownClick(Sender: TObject);
    procedure MNSc_MoveToBottomClick(Sender: TObject);
    procedure MNGrid_MoveToBackClick(Sender: TObject);
    procedure MNGrid_MoveToFrontClick(Sender: TObject);
    procedure MNGrid_PropClick(Sender: TObject);
    procedure MNGrid_PropertiesClick(Sender: TObject);
    procedure MNGrid_VisResetAllClick(Sender: TObject);
    procedure MNGrid_Vis_Click(Sender: TObject);
    procedure MNSc_MoveToTopClick(Sender: TObject);
    procedure MNSc_MoveUpClick(Sender: TObject);
    procedure MNSC_PropertiesClick(Sender: TObject);
    procedure MNSc_PropClick(Sender: TObject);
    procedure MN_ShowHiddenFieldsClick(Sender: TObject);
    procedure PaintBoxUIShapePaint(Sender: TObject);
    procedure PanelDataCardEnter(Sender: TObject);
    procedure PanelDataCardExit(Sender: TObject);
    procedure PanelDataGridCardResize(Sender: TObject);
    procedure PanelDataQueryEnter(Sender: TObject);
    procedure PanelDataQueryExit(Sender: TObject);
    procedure PanelDataQueryResize(Sender: TObject);
    procedure PanelDataCardResize(Sender: TObject);
    procedure PanelSheetEditEnter(Sender: TObject);
    procedure PanelSheetEditExit(Sender: TObject);
    procedure PanelSheetEditResize(Sender: TObject);
    procedure PanelSheetViewEnter(Sender: TObject);
    procedure PanelSheetViewExit(Sender: TObject);
    procedure PanelSheetViewResize(Sender: TObject);
    procedure sbtnMobNavAddClick(Sender: TObject);
    procedure sbtnMobNavEditClick(Sender: TObject);
    procedure sbtnMobNavSaveClick(Sender: TObject);
    procedure ScrollBoxDataCardResize(Sender: TObject);
    procedure ScrollBoxUIPanelsResize(Sender: TObject);
    procedure SplitterTopPanelMoved(Sender: TObject);
    procedure StringGridDataClick(Sender: TObject);
    procedure StringGridDataColRowMoved(Sender: TObject; IsColumn: boolean;
      sIndex, tIndex: integer);
    procedure StringGridDataDblClick(Sender: TObject);
    procedure StringGridDataHeaderClick(Sender: TObject; IsColumn: boolean;
      Index: integer);
    procedure StringGridDataHeaderSized(Sender: TObject; IsColumn: boolean;
      Index: integer);
    procedure StringGridDataMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StringGridDataPrepareCanvas(Sender: TObject; aCol, aRow: integer;
      aState: TGridDrawState);
    procedure TimerDesignNotesEditTimer(Sender: TObject);
    procedure TimerRowSelectTimer(Sender: TObject);
    procedure TimerScDelayCmdTimer(Sender: TObject);
  private               
    FCtMetaTable: TCtMetaTable;
    FLastTbJson: string;
    FLastTableName: string;
    FLastScControlName: string;
    FDelayRunCmd: string;
    FDragDropScControlName: string;
    FCurDemoDataIndex: integer;
    FOnSheetVisibleChanged: TNotifyEvent;
    FReadOnlyMode: boolean;
    FIniting: boolean;
    FFieldPropIniting: boolean;
    FSheetContainer: TWinControl;
    FSkipGridRefreshTick: int64;   
    FSkipCatRefreshTick: int64;
    FSkipDesNotesRefreshTick: int64;
    FRefreshUpdateing: boolean;
    FShowHiddenFields: boolean;
    FShowSearchOnInit: boolean;
    FMetaField: TCtMetaField;
    FDataQueryControls: TDmlScriptControlList;
    FDataCardControls: TDmlScriptControlList;
    FSheetViewControls: TDmlScriptControlList;
    FSheetEditControls: TDmlScriptControlList;
                                          
    FTopSplitPercent: Double;

    FGridSortColumn: string;
    FGridSortType: integer; //0none 1asc 2desc
    FGridPageSize: integer;
    FFocusedCatIndex: integer;

    FScMenuPopupPoint: TPoint;
    FUIOperateType: Integer;
    FUIShapeType: Integer;

    StringGridData: TStringGrid;


    procedure DoUIPropChanged(Field, prop, Value, par1, par2, opt: string);
    function GetTopPanelVisible: boolean;
    procedure SetTopPanelVisible(AValue: boolean);
    procedure SetUIOperateType(AValue: Integer);
    procedure SetUIShapeType(AValue: Integer);
    function _OnScriptControlEvent(Sender: TObject; ScCtrl: TDmlScriptControl;
      evt, par1, par2: string): string;
    function _OnCardScControlEvent(Sender: TObject; ScCtrl: TDmlScriptControl;
      evt, par1, par2: string): string;
    procedure _OnGridUIScrolled(Sender: TObject);
    procedure _OnSheetSizeChange(Sender: TObject);
    procedure _OnSheetVisChange(Sender: TObject);

    procedure SetGridFucosColIndex(AColIndex: integer);
    procedure SetSheetFocusRowIndex(ARowIndex: integer);
    function GetGridField(ACol: integer = -999): TCtMetaField;
    function GetGridFieldName(ACol: integer = -999): string;
    procedure CheckCardGridCtrls;
    procedure CheckSheetActs;
    procedure RefreshCatFields;
    procedure RefreshUIShape;
    procedure FocusCatField(AField: string);
    procedure InitCatField(AField: TCtMetaField);
    procedure RefreshDesignNotes;
    procedure FocusFieldDesignNotes(AField: string);
    procedure ScanDesignNotes;
    procedure SaveCatFieldProp(Sender: TObject);
    procedure NotifyTbPropChanged;
    procedure DoSetFieldTestDataRule(fd: TCtMetaField; tp: String); 
    procedure ExportGridToCsv(fn: string);
  public
    Proc_OnUIPropChanged:
    procedure(Field, prop, Value, par1, par2, opt: string) of object;
    FFrameUIPrvSheet: TFrameUIPrvSheet;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadConfig(secEx: string);
    procedure SaveConfig(secEx: string);

    procedure InitByTable(ATable: TCtMetaTable; bReadOnlyMode: boolean);
    procedure InitByTableEx;

    procedure HideProps;

    procedure CreateDataCard(ATable: TCtMetaTable;
      AScControls: TDmlScriptControlList; AOpt: string);
    procedure CreateControlList(ATable: TCtMetaTable;
      AScControls: TDmlScriptControlList; AOpt: string);

    procedure RefreshUI;
    procedure SetUITypes(Shap, Oper: Integer);

    property ReadOnlyMode: boolean read FReadOnlyMode write FReadOnlyMode;
    property SheetContainer: TWinControl read FSheetContainer write FSheetContainer;
    property OnSheetVisibleChanged: TNotifyEvent read FOnSheetVisibleChanged write FOnSheetVisibleChanged;
    property TopPanelVisible: boolean read GetTopPanelVisible write SetTopPanelVisible;
    //UI类型：1PC 2PAD 3PHONE
    property UIShapeType: Integer read FUIShapeType write SetUIShapeType;
    //操作类型：1列表 2查看 3修改 4新增
    property UIOperateType: Integer read FUIOperateType write SetUIOperateType;
  end;

implementation

{$R *.lfm}


uses
  dmlstrs, WindowFuncs, ClipBrd, INIFiles, CtTestGridData, PvtInput,
  CtTestDataGen, uFormSelectFields, uFormDBDataRule, CtMetaData;


{ TFrameUIPreview }

procedure TFrameUIPreview.StringGridDataClick(Sender: TObject);
begin
  DoUIPropChanged(GetGridFieldName, 'selected',
    '1', '', '', '[DONT_REFRESH_GRID]');
  TimerRowSelect.Enabled := False;
  TimerRowSelect.Enabled := True;
end;

procedure TFrameUIPreview.StringGridDataColRowMoved(Sender: TObject;
  IsColumn: boolean; sIndex, tIndex: integer);
var
  f0, f1, f2, htxt: string;
  hw: integer;
  hitem: THeaderSection;
  al: TAlignment;
begin
  if ReadOnlyMode or not IsColumn then
    Exit;

  if (sIndex >= 0) and (sIndex < HeaderControlSummary.Sections.Count) then
    if (tIndex >= 0) and (tIndex <= HeaderControlSummary.Sections.Count) then
    begin
      hItem := HeaderControlSummary.Sections[sIndex];
      htxt := hItem.Text;
      hw := hItem.Width;
      al := hItem.Alignment;

      HeaderControlSummary.Sections.Delete(sIndex);

      if tIndex < HeaderControlSummary.Sections.Count then
        hItem := HeaderControlSummary.Sections.Insert(tIndex)
      else
        hItem := HeaderControlSummary.Sections.Add;
      hItem.Text := htxt;
      hItem.Width := hw;
      hItem.Alignment := al;
    end;

  if tIndex >= 1 then
  begin
    f0 := GetGridFieldName(sIndex);
    if sIndex > tIndex then
    begin
      if tIndex > 1 then
        f1 := GetGridFieldName(tIndex - 1)
      else
        f1 := '';
      f2 := GetGridFieldName(tIndex);
    end
    else
    begin
      f1 := GetGridFieldName(tIndex);
      if tIndex < StringGridData.ColCount - 1 then
        f2 := GetGridFieldName(tIndex + 1)
      else
        f2 := '';
    end;
    StringGridData.Col := sIndex;
    DoUIPropChanged(f0, 'index_position',
      '', f1, f2, '[DONT_REFRESH_GRID]');
  end;
end;

procedure TFrameUIPreview.StringGridDataDblClick(Sender: TObject);
var
  col: Integer;
  rct: TRect;
begin
  col := StringGridData.Col;
  if col >= 1 then              
    if StringGridData.Row=1 then
    begin
      rct := StringGridData.Selection;
      if (rct.Left = col) and (rct.Right = col) then
        if (rct.Top = 1) and (rct.Bottom = StringGridData.RowCount - 1) then
        begin    
          MNGrid_PropertiesClick(nil);
          Exit;
        end;
    end;
  if (GetKeyState(VK_CONTROL) and $80) = 0 then
  begin             
    //actShowSheet.Execute;
    TimerScDelayCmd.Enabled := False;
    TimerScDelayCmd.Tag := 6;
    TimerScDelayCmd.Enabled := True;
  end
  else
    MNGrid_PropertiesClick(nil);
end;

procedure TFrameUIPreview.StringGridDataHeaderClick(Sender: TObject;
  IsColumn: boolean; Index: integer);
var
  fd: TCtMetaField;
begin
  if Index >= 1 then
  begin
    StringGridData.ColRow := Point(Index, 1);
    StringGridData.Selection := Rect(Index, 1, Index, StringGridData.RowCount - 1);
    DoUIPropChanged(GetGridFieldName, 'selected',
      '1', '', '', '[DONT_REFRESH_GRID]');

    fd := GetGridField;
    if fd <> nil then
      if fd.ColSortable then
      begin
        if FGridSortColumn <> fd.Name then
        begin
          FGridSortColumn := fd.Name;
          FGridSortType := 0;
          Exit;
        end
        else if FGridSortType = 0 then
          FGridSortType := 1
        else if FGridSortType = 1 then
          FGridSortType := 2
        else
          FGridSortType := 1;
        if FGridSortType = 2 then
          StringGridData.SortOrder := soDescending
        else
          StringGridData.SortOrder := soAscending;
        TStringGridUI(StringGridData).Sort(True, index, 1, StringGridData.RowCount - 1);
      end;
  end;
end;

procedure TFrameUIPreview.StringGridDataHeaderSized(Sender: TObject;
  IsColumn: boolean; Index: integer);
var
  w: integer;
  S: string;
begin
  if not IsColumn then
    Exit;
  if (Index >= 0) and (Index < HeaderControlSummary.Sections.Count) then
    HeaderControlSummary.Sections[Index].Width := StringGridData.ColWidths[Index];

  if Index >= 1 then
  begin
    StringGridData.Col := Index;
    S := GetGridFieldName;
    w := ScaleDPISize(StringGridData.ColWidths[Index]);
    DoUIPropChanged(S, 'ColWidth', IntToStr(w), '', '', '[DONT_REFRESH_GRID]');
  end;
end;

procedure TFrameUIPreview.StringGridDataMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  pt: TPoint;
  S: string;
  fd: TCtMetaField;
  bEnb: boolean;
begin
  if Button = mbRight then
  begin
    pt := StringGridData.MouseToCell(Point(X, Y));
    StringGridData.ColRow := pt;
    StringGridData.SetFocus;
    pt := StringGridData.ClientToScreen(Point(X, Y));
    if FCtMetaTable <> nil then
    begin
      bEnb := not FReadOnlyMode;
      S := GetGridFieldName;
      fd := FCtMetaTable.MetaFields.FieldByName(S);
      if fd <> nil then
      begin
        MNGrid_Readonly.Checked := fd.EditorReadOnly;
        MNGrid_Enabled.Checked := fd.EditorEnabled;
        MNGrid_Searchable.Checked := fd.Searchable;
        MNGrid_Queryable.Checked := fd.Queryable;
        MNGrid_Vis_Hidden.Checked := fd.IsHidden;
        MNGrid_Sortable.Checked := fd.ColSortable;    
        MNGrid_ShowFilterBox.Checked := fd.ShowFilterBox;
        MNGrid_Exportable.Checked := fd.Exportable;

        if (fd.Visibility >= 0) and (fd.Visibility <= 3) then
          MNGrid_Visibility.Items[fd.Visibility].Checked := True;

        MNGrid_TextAlignment.Items[integer(fd.TextAlign)].Checked := True;
      end
      else
      begin
        MNGrid_Readonly.Checked := False;
        MNGrid_Enabled.Checked := True;
        MNGrid_Searchable.Checked := True;
        MNGrid_Queryable.Checked := True;
        MNGrid_Vis_Hidden.Checked := False;
        MNGrid_Vis_0.Checked := True;
        MNGrid_Align_0.Checked := True;
        MNGrid_Sortable.Checked := False;     
        MNGrid_ShowFilterBox.Checked := False;
        MNGrid_Exportable.Checked := False;
        bEnb := False;
      end;
    end
    else
      bEnb := False;
    MNGrid_Readonly.Enabled := bEnb;
    MNGrid_Enabled.Enabled := bEnb;
    MNGrid_Searchable.Enabled := bEnb;
    MNGrid_Queryable.Enabled := bEnb;
    MNGrid_Vis_Hidden.Enabled := bEnb;
    MNGrid_Sortable.Enabled := bEnb;  
    MNGrid_ShowFilterBox.Enabled := bEnb;
    MNGrid_Exportable.Enabled := bEnb;
    MNGrid_Vis4_RemoveFromGrid.Enabled := bEnb;
    MNGrid_Visibility.Enabled := bEnb;      
    MNGrid_TestDataType.Enabled := bEnb;
    MNGrid_TextAlignment.Enabled := bEnb;   
    MNGrid_TextAggrFun.Enabled := bEnb;
    MNGrid_MoveToFront.Enabled := bEnb;
    MNGrid_MoveToBack.Enabled := bEnb;
    PopupMenuGrid.PopUp(pt.X, pt.Y);
  end;
end;

procedure TFrameUIPreview.StringGridDataPrepareCanvas(Sender: TObject; aCol,
  aRow: integer; aState: TGridDrawState);
var
  tg: Integer;
begin
  if aRow = 0 then
    aRow := 1;

  tg := integer(StringGridData.Objects[aCol, aRow]);
  if tg = 3 then
    StringGridData.Canvas.Font.Color := $AAAAAA
  else if tg = 2 then
    StringGridData.Canvas.Font.Color := $668888;
end;

procedure TFrameUIPreview.TimerDesignNotesEditTimer(Sender: TObject);
begin
  TimerDesignNotesEdit.Enabled := False;
  ScanDesignNotes;
end;


procedure TFrameUIPreview.TimerRowSelectTimer(Sender: TObject);
begin
  TimerRowSelect.Enabled := False;
  with StringGridData.Selection do
    if Left = Right then
      if Top = Bottom then
      begin
        //StringGridData.Selection := Rect(1, Top, StringGridData.ColCount - 1, Bottom);
        SetSheetFocusRowIndex(Top - 1);
      end;
end;

procedure TFrameUIPreview.TimerScDelayCmdTimer(Sender: TObject);
var
  vTag: integer;
  S: string;
begin
  vTag := TimerScDelayCmd.Tag;
  TimerScDelayCmd.Tag := 0;
  TimerScDelayCmd.Enabled := False;
  if vTag = 1 then
  begin
    PopupMenuScControl.PopUp(FScMenuPopupPoint.X, FScMenuPopupPoint.Y);
  end;
  if vTag = 2 then
  begin
    if (GetKeyState(VK_CONTROL) and $80)<> 0 then
      DoUIPropChanged(FLastScControlName, 'toggle_dml_graph',
        '1', '', '', '[DONT_REFRESH_GRID]')
    else
      DoUIPropChanged(FLastScControlName, 'show_props', '', '', '', '');
  end;
  if vTag = 3 then
  begin
    DoUIPropChanged(FLastScControlName, 'drag_drop', FDragDropScControlName, '', '', '');
  end;
  if vTag = 4 then
  begin
    Self.InitByTableEx;
  end;
  if vTag = 5 then
  begin
    S := FDelayRunCmd;
    FDelayRunCmd := '';
    if S = 'sheet_btn:' + srCapNew then
      actNewItem.Execute
    else if S = 'sheet_btn:' + srCapModify then
      actModifyItem.Execute
    else if S = 'sheet_btn:' + srCapOk then
      actViewItem.Execute
    else if S = 'sheet_btn:' + srCapCancel then
      //actViewItem.Execute                    
      actShowSheet.Execute
    else if S = 'sheet_btn:' + srCapClose then
      actShowSheet.Execute
    else if S = 'sheet_btn:' + srCapDelete then
    begin
      if Application.MessageBox(PChar(srConfirmDeleteCurRec), PChar(srCapDelete), MB_OKCANCEL or MB_ICONWARNING) = IDOK then
        actShowSheet.Execute;
    end;
  end;  
  if vTag = 6 then
  begin
    actShowSheet.Execute;
  end;
end;


procedure TFrameUIPreview.DoUIPropChanged(Field, prop, Value, par1, par2, opt: string);
begin
  if FIniting then
    Exit;
  if Field = '' then
    Exit;
  FIniting := True;
  try
    FocusCatField(Field);
  finally
    FIniting := False;
  end;
  if prop='selected' then
    FocusFieldDesignNotes(Field);
  if Assigned(Proc_OnUIPropChanged) then
  begin
    if Pos('[DONT_REFRESH_GRID]', opt) > 0 then
      if TimerScDelayCmd.Tag <> 4 then
        FSkipGridRefreshTick := GetTickCount;
    Proc_OnUIPropChanged(Field, prop, Value, par1, par2, opt);
  end;
end;

function TFrameUIPreview.GetTopPanelVisible: boolean;
begin
  Result := PanelTopDesign.Visible;
end;

procedure TFrameUIPreview.SetTopPanelVisible(AValue: boolean);
begin
  if PanelTopDesign.Visible=AValue then
    Exit;
  if PanelTopDesign.Visible then
  begin
    SplitterTopPanel.Visible := False;
    PanelTopDesign.Visible := False;
  end
  else
  begin   
    PanelTopDesign.Visible := True;
    SplitterTopPanel.Visible := True;
    SplitterTopPanel.Top := PanelTopDesign.Top + PanelTopDesign.Height;
  end;
end;

procedure TFrameUIPreview.SetUIOperateType(AValue: Integer);
begin
  if FUIOperateType=AValue then Exit;
  FUIOperateType:=AValue;  
  RefreshUIShape;
end;

procedure TFrameUIPreview.SetUIShapeType(AValue: Integer);
begin
  if FUIShapeType=AValue then Exit;
  FUIShapeType:=AValue;
  RefreshUIShape;
end;

function TFrameUIPreview._OnScriptControlEvent(Sender: TObject;
  ScCtrl: TDmlScriptControl; evt, par1, par2: string): string;

  procedure CheckGenDataForScGrid;
  var
    fd: TCtMetaField;
    tb: TCtMetaTable;
  begin
    if ScCtrl = nil then
      Exit;
    if ScCtrl.Control = nil then
      Exit;
    if not (ScCtrl.Control is TStringGrid) then
      Exit;
    if FCtMetaTable = nil then
      Exit;
    fd := FCtMetaTable.MetaFields.FieldByName(ScCtrl.Name);
    if fd = nil then
      Exit;
    if fd.IsPhysicalField then
      Exit;
    if fd.RelateTable = '' then
      Exit;
    tb := fd.GetRelateTableObj;
    if tb = nil then
      Exit;
    GenGridDemoData(tb, TStringGrid(ScCtrl.Control), nil, 5, fd.RelateField, '');
  end;

  procedure DoScPopupMenu(Sd: TObject; X, Y: integer);
  var
    ct: TControl;
    pt: TPoint;
    fd: TCtMetaField;
    bEnb: boolean;
    I: Integer;
  begin
    if not (sd is TControl) then
      Exit;
    ct := (sd as TControl);
    pt := ct.ClientToScreen(Point(X, Y));
    FScMenuPopupPoint := pt;
    MNSc_CtrlName.Caption := ScCtrl.Caption;

    if FCtMetaTable <> nil then
    begin
      bEnb := not FReadOnlyMode;
      fd := FCtMetaTable.MetaFields.FieldByName(ScCtrl.Name);
      if fd <> nil then
      begin
        MNSC_Readonly.Checked := fd.EditorReadOnly;
        MNSC_Enabled.Checked := fd.EditorEnabled;
        MNSC_Searchable.Checked := fd.Searchable;
        MNSC_Queryable.Checked := fd.Queryable;

        if (fd.Visibility >= 0) and (fd.Visibility <= 3) then
          MNSC_Visibility.Items[fd.Visibility].Checked := True;
        for I:=0 to MNSC_EditorType.Count - 1 do
          if MNSC_EditorType.Items[I].Hint = fd.EditorType then
             MNSC_EditorType.Items[I].Checked := True
          else
             MNSC_EditorType.Items[I].Checked := False;

        MNSC_TextAlignment.Items[integer(fd.TextAlign)].Checked := True;
      end
      else
      begin
        MNSC_Readonly.Checked := False;
        MNSC_Enabled.Checked := True;
        MNSC_Searchable.Checked := True;
        MNSC_Queryable.Checked := True;
        MNSC_Vis_0.Checked := True;
        MNSC_Align_0.Checked := True;
        bEnb := False;
      end;
    end
    else
      bEnb := False;

    MNSc_CtrlName.Enabled := bEnb;
    MNSC_Visibility.Enabled := bEnb;
    MNSC_EditorType.Enabled := bEnb; 
    MNSC_TestDataType.Enabled := bEnb;
    MNSC_TextAlignment.Enabled := bEnb;
    MNSc_Vis_Hidden.Enabled := bEnb;
    MNSC_Readonly.Enabled := bEnb;
    MNSC_Enabled.Enabled := bEnb;
    MNSC_Searchable.Enabled := bEnb;
    MNSC_Queryable.Enabled := bEnb;
    MNSc_MoveToTop.Enabled := bEnb;
    MNSC_MoveUp.Enabled := bEnb;
    MNSC_MoveDown.Enabled := bEnb;
    MNSc_MoveToBottom.Enabled := bEnb;

    TimerScDelayCmd.Enabled := False;
    TimerScDelayCmd.Tag := 1;
    TimerScDelayCmd.Enabled := True;
  end;

begin
  if FIniting then
  begin
    if (evt = 'CreateControl') then
    begin
      CheckGenDataForScGrid();
    end;
    Exit;
  end;
  if ScCtrl = nil then
    Exit;
  FLastScControlName := ScCtrl.Name;

  if evt = 'ControlClick' then
    if (Sender <> nil) and (Sender is TButton) then
      if (FLastScControlName = '_UIPreview_OperPanel_View') or
        (FLastScControlName = '_UIPreview_OperPanel_Edit') then
      begin
        FDelayRunCmd := 'sheet_btn:' + TButton(Sender).Caption;
        TimerScDelayCmd.Enabled := False;
        TimerScDelayCmd.Tag := 5;
        TimerScDelayCmd.Enabled := True;
      end;


  if (evt = 'LabelClick') or (evt = 'ControlClick') or (evt = 'ControlEnter') then
  begin
    DoUIPropChanged(FLastScControlName, 'selected', '1', '', '', '[DONT_REFRESH_GRID]');
  end;
  if (evt = 'LabelDblClick') or (evt = 'ControlDblClick') then
  begin
    TimerScDelayCmd.Enabled := False;
    TimerScDelayCmd.Tag := 2;
    TimerScDelayCmd.Enabled := True;
  end;
  if (evt = 'LabelMouseRightClick') then
  begin
    DoScPopupMenu(Sender, StrToInt(par1), StrToInt(par2));
  end;
  if (evt = 'ItemDragDrop') then
  begin
    if Assigned(Sender) and (Sender is TDmlScriptControl) then
    begin
      FLastScControlName := TDmlScriptControl(Sender).Name;
      FDragDropScControlName := ScCtrl.Name;
      if FLastScControlName <> FDragDropScControlName then
      begin
        TimerScDelayCmd.Enabled := False;
        TimerScDelayCmd.Tag := 3;
        TimerScDelayCmd.Enabled := True;
      end;
    end;
  end;

  if (evt = 'CreateControl') then
    CheckGenDataForScGrid();
end;

function TFrameUIPreview._OnCardScControlEvent(Sender: TObject;
  ScCtrl: TDmlScriptControl; evt, par1, par2: string): string;   
var
  S: String;
begin
  if FIniting then
    Exit;
  if ScCtrl <> nil then
    Self.SetSheetFocusRowIndex(ScCtrl.Index);
  if (evt = 'LabelDblClick') or (evt = 'ControlDblClick') then
  begin
    if not FFrameUIPrvSheet.Visible then
      actShowSheet.Execute
    else
      FFrameUIPrvSheet.ReCalSizes;
  end;
end;

procedure TFrameUIPreview._OnGridUIScrolled(Sender: TObject);
var
  pt: TPoint;
begin
  pt := TStringGridUI(StringGridData).TopLeftXY;
  if HeaderControlSummary.Left = -pt.X then
    Exit;
  HeaderControlSummary.Left := -pt.X;
end;

procedure TFrameUIPreview.SetGridFucosColIndex(AColIndex: integer);
begin
  if AColIndex >= 0 then
    if AColIndex < StringGridData.ColCount then
    begin
      StringGridData.ColRow := Point(AColIndex, 1);
      StringGridData.Selection :=
        Rect(AColIndex, 1, AColIndex, StringGridData.RowCount - 1);
      DoUIPropChanged(GetGridFieldName(AColIndex), 'selected',
        '1', '', '', '[DONT_REFRESH_GRID]');
    end;
end;

procedure TFrameUIPreview.SetSheetFocusRowIndex(ARowIndex: integer);
begin
  if FCurDemoDataIndex = ARowIndex then
    Exit;
  FCurDemoDataIndex := ARowIndex;
  if FCtMetaTable = nil then
    Exit;
  CreateControlList(FCtMetaTable, FSheetViewControls, '[VIEW_MODE][ResetValuesOnly]');
  CreateControlList(FCtMetaTable, FSheetEditControls, '[ResetValuesOnly]');
end;

function TFrameUIPreview.GetGridField(ACol: integer): TCtMetaField;
var
  gCol: TGridColumn;
begin
  if ACol = -999 then
    ACol := StringGridData.col;
  Result := nil;
  if Acol > 0 then
    if ACol <= StringGridData.Columns.Count then
    begin
      gCol := StringGridData.Columns[ACol - 1];
      if gCol is TCtFieldGridColumn then
        Result := TCtFieldGridColumn(gCol).CtField;
    end;
end;

function TFrameUIPreview.GetGridFieldName(ACol: integer = -999): string;
var
  fd: TCtMetaField;
begin
  fd := GetGridField(ACol);
  if fd <> nil then
    Result := fd.Name
  else
    Result := '';
end;

procedure TFrameUIPreview.CheckCardGridCtrls;
var
  bInit: Boolean;
begin
  bInit := FIniting;
  FIniting := True;
  try
    if PanelDataQuery.Visible then
      FDataQueryControls.CheckGenControls;
    if ScrollBoxDataCard.Visible then
      FDataCardControls.CheckGenControls;
  finally
    FIniting := bInit;
  end;
end;

procedure TFrameUIPreview.CheckSheetActs;
  function FindVisTb(AToolBar: TToolBar; AName: string): TToolButton;
  var
    I: Integer;
    tb: TToolButton;
  begin    
    Result := nil;
    for I:=0 to AToolBar.ButtonCount - 1 do
    begin
      tb := AToolBar.Buttons[I];
      if tb.Name=AName then
      begin
        if tb.Visible then
          Result := tb;
        Exit;
      end
      else if (tb.Action <> nil) and (tb.Action.Name=AName) then 
      begin
        if TAction(tb.Action).Visible then
          Result := tb;
        Exit;
      end;
    end;
  end;
  procedure SortTbs;
  const
    STB_NAMES:array[0..21] of String=(
      'actBackToList',
      'ToolButtonSpb0',
      'actModifyItem',
      'actDeleteItem',
      'actPrint',
      'actNewItem',
      'actViewItem',
      'ToolButtonSpb1',
      'actQuery',
      'actExcelExp',
      'ToolButtonSpb2',
      'actFirstPage',
      'actPrevPage',
      'actNextPage',
      'actLastPage',
      'actPageSize',
      'ToolButtonSpb3',
      'actRefresh',
      'ToolButtonSpb4',
      'PanelFastSearch',
      'actPostItem',
      'actCanceItem');
  var
    I, X: Integer;
    tb: TToolButton;
  begin
    X := 0;
    for I:=0 to High(STB_NAMES) do
    begin
      tb := FindVisTb(ToolBarGrid, STB_NAMES[I]);
      if tb <> nil then
      begin
        tb.Left := X;
        X := X+tb.Width;
      end;
    end;
  end;
var
  S: String;
  bShtMode, bEdit: Boolean;
begin
  S := '';             
  bShtMode := False;
  bEdit := False;
  if FFrameUIPrvSheet.Visible then
  begin
    S:= FFrameUIPrvSheet.ViewType;
    bShtMode := True;   
    if (S='new') or (S='modify') then
      bEdit := True;
  end;

  actBackToList.Visible := bShtMode and not bEdit;
  ToolButtonSpb0.Visible := bShtMode and not bEdit;
  actModifyItem.Visible := bShtMode and not bEdit;
  actDeleteItem.Visible := bShtMode and not bEdit;
  actPrint.Visible := bShtMode and not bEdit;


  actNewItem.Visible := not bShtMode;
  actViewItem.Visible := not bShtMode;
  ToolButtonSpb1.Visible := not bShtMode;

  actQuery.Visible := not bShtMode;
  actExcelExp.Visible := not bShtMode;
  ToolButtonSpb2.Visible := not bShtMode;

  actFirstPage.Visible := not bShtMode;
  actPrevPage.Visible := not bShtMode;
  actNextPage.Visible := not bShtMode;
  actLastPage.Visible := not bShtMode;
  actPageSize.Visible := not bShtMode;
  ToolButtonSpb3.Visible := not bShtMode;

  actRefresh.Visible := not bShtMode;

  ToolButtonSpb4.Visible := not bShtMode;
  PanelFastSearch.Visible := not bShtMode;


  actPostItem.Visible := bShtMode and bEdit;
  actCanceItem.Visible := bShtMode and bEdit;
         
  actInsertNewField.Enabled := not FReadOnlyMode;

  SortTbs;
end;

procedure TFrameUIPreview.RefreshCatFields;
var
  cat: Integer;
  function IsCatField(fd: TCtMetaField): Boolean;
  begin
{
0All
1Grid
2Sheet
3Card
4Query
5Fast search
6Exportalbe
7Required
8Hidden
}
    Result := True;
    if cat<=0 then
      Exit;
    if (cat=1) and fd.CanDisplay('grid') then
      Exit; 
    if (cat=2) and fd.CanDisplay('sheet') then
      Exit;                             
    if (cat=3) and fd.CanDisplay('card') then
      Exit;
    if (cat=4) and fd.Queryable then
      Exit;
    if (cat=5) and fd.Searchable then
      Exit;     
    if (cat=6) and fd.Exportable then
      Exit;
    if (cat=7) then
    begin    
      if fd.Required then
        Exit;
      if fd.IsRequired then
      begin
        if fd.CanDisplay('sheet') then
          Exit;
      end;
    end;
    if (cat=8) and (fd.IsHidden or not fd.CanDisplay('grid,sheet,card')) then
      Exit;
    Result := False;
  end;
var
  I, sIdx: Integer;
  fd: TCtMetaField;
  sFn: String;
begin
  if FSkipCatRefreshTick <> 0 then
    if Abs(GetTickCount64 - FSkipCatRefreshTick) > 800 then
      FSkipCatRefreshTick := 0;
  if FSkipCatRefreshTick > 0 then
    Exit;

  if FFocusedCatIndex < 0 then
    FFocusedCatIndex := 0;
  cat := FFocusedCatIndex;
  Self.actCatAddField.Enabled:=(cat>0) and not FReadOnlyMode;
  Self.actCatRemoveField.Enabled:=(cat>0) and not FReadOnlyMode;    
  Self.actCatFieldMoveUp.Enabled:=not FReadOnlyMode;           
  Self.actCatFieldMoveDown.Enabled:=not FReadOnlyMode;
  sIdx := ListBoxFields.ItemIndex;
  sFn := '';
  if sIdx >= 0 then
  begin
    try
      if ListBoxFields.Selected[sIdx] then
      begin
        fd := TCtMetaField(ListBoxFields.Items.Objects[sIdx]);
        sFn := fd.Name;
      end
      else
        sIdx := -1;
    except
      sIdx := -1;
    end;
  end;

  ListBoxFields.Items.Clear;            
  ListBoxFields.ClearSelection;
  sIdx := -1;
  for I:=0 to FCtMetaTable.MetaFields.Count - 1 do
  begin
    fd := FCtMetaTable.MetaFields[I];
    if IsCatField(fd) then
    begin
      ListBoxFields.Items.AddObject(fd.NameCaption, fd);
      if sFn <> '' then
        if fd.Name=sFn then
          sIdx := ListBoxFields.Items.Count - 1;
    end;
  end;

  if sIdx>=0 then
  begin
    ListBoxFields.ItemIndex:= sIdx;
    ListBoxFields.Selected[sIdx] := True;
    ListBoxFieldsClick(nil);
  end
  else
    InitCatField(nil);
end;

procedure TFrameUIPreview.RefreshUIShape;    
  procedure SetListUIVisible(bVis: Boolean);
  begin
    if not bVis then
    begin
      ScrollBoxDataCard.Visible := False;
      StringGridData.Visible := False;
      PanelSummary.Visible := False;
      actCardView.Checked := False;
      ToolBarGrid.Visible := (FUIShapeType = 1);
      PanelDataQuery.Visible := False;
    end
    else
    begin
      if FUIShapeType > 1 then
      begin
        ScrollBoxDataCard.Visible := True;      
        PanelDataQuery.Visible := False;
        StringGridData.Visible := False;
        PanelSummary.Visible := False;
        ToolBarGrid.Visible := False;
        actCardView.Checked := True;
      end
      else
      begin
        ToolBarGrid.Visible := True;        
        PanelDataQuery.Visible := actQuery.Checked;
        ScrollBoxDataCard.Visible := False;
        PanelSummary.Visible := HeaderControlSummary.Sections.Count > 0;
        StringGridData.Visible := True;
        actCardView.Checked := False;
      end;
      CheckCardGridCtrls;
    end;
  end;
begin              
    //UI类型：1PC 2PAD 3PHONE
  case FUIShapeType of
    2:
      begin
        PanelDataGridCard.Width := 800;
        PanelDataGridCard.Height := 600;
      end;                             
    3:
      begin
        PanelDataGridCard.Width := 360;
        PanelDataGridCard.Height := 640;
      end;
    else
      begin
        PanelDataGridCard.Width := 1024;
        PanelDataGridCard.Height := 640;  
        PanelMobileHeader.Visible:=False;
      end;
  end;
                    
  case FUIShapeType of
    2, 3:
      begin
        lbStatusTime.Caption := FormatDateTime('h:nn AM/PM', Now);
        lbMobNavTitle.Caption := Self.FCtMetaTable.UIDisplayName;     
        sbtnMobNavAdd.Visible := (FUIOperateType = 1);
        sbtnMobNavEdit.Visible := (FUIOperateType = 2);   
        sbtnMobNavDel.Visible := (FUIOperateType = 2);
        sbtnMobNavSave.Visible := (FUIOperateType >= 3);
        sbtnMobNavSearch.Visible := (FUIOperateType = 1);
        PanelMobileHeader.Visible:=True;
      end;
  end;

  PaintBoxUIShape.Refresh;
               
    //操作类型：1列表 2查看 3修改 4新增
  case FUIOperateType of
    1:
      begin        
        SetListUIVisible(True);
        if FFrameUIPrvSheet.Visible then
        begin
          FFrameUIPrvSheet.Visible := False;
          PanelSheetContainer.Visible := False;
          if Assigned(SheetContainer) then
            SheetContainer.Visible := False;
          if Assigned(OnSheetVisibleChanged) then
            OnSheetVisibleChanged(Self);
          CheckSheetActs;
        end
      end;
     2, 3, 4:
       begin
        SetListUIVisible(False);

        case FUIOperateType of
          2:
            begin
              CreateControlList(FCtMetaTable, FSheetViewControls, '[VIEW_MODE]');       
              FFrameUIPrvSheet.ViewType := 'view';
              FFrameUIPrvSheet.ActivePage := 1;
            end;
          3:
            begin
              CreateControlList(FCtMetaTable, FSheetEditControls, '');
              FFrameUIPrvSheet.ViewType := 'modify';
              FFrameUIPrvSheet.ActivePage := 0;
            end;
          4:
            begin
              CreateControlList(FCtMetaTable, FSheetEditControls, '[NEW_MODE]');   
              FFrameUIPrvSheet.ViewType := 'new';
              FFrameUIPrvSheet.ActivePage := 0;
            end;
        end;
        FFrameUIPrvSheet.Visible := True;
        if Assigned(SheetContainer) then
          SheetContainer.Visible := True;
        if Assigned(OnSheetVisibleChanged) then
          OnSheetVisibleChanged(Self);
        FFrameUIPrvSheet.ReCalSizes;
        FFrameUIPrvSheet.TimerResize.Enabled := True;    
        CheckSheetActs;
       end;
  end;
end;

procedure TFrameUIPreview.FocusCatField(AField: string);
var
  I: Integer;
  fd: TCtMetaField;
begin                                 
  ListBoxFields.ClearSelection;
  for I:=0 to ListBoxFields.Count - 1 do
  begin
    fd := TCtMetaField(ListBoxFields.Items.Objects[I]);
    if UpperCase(fd.Name) = UpperCase(AField) then
    begin
      ListBoxFields.ItemIndex:= I;
      ListBoxFields.Selected[I] := True;
      InitCatField(fd);
      Break;
    end;
  end;
end;

procedure TFrameUIPreview.InitCatField(AField: TCtMetaField);
var
  vReadOnlyMode: boolean;

  function IntToStrSp(iv: integer): string;
  begin
    if iv = 0 then
      Result := ''
    else
      Result := IntToStr(iv);
  end;

  procedure SetControlReadOnly(AControl: TControl);
  begin
    if AControl is TCustomEdit then
    begin
      if vReadOnlyMode then
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
      AControl.Enabled := not vReadOnlyMode;
  end;

var
  I: integer;
begin
  if FFieldPropIniting then
    Exit;

  FFieldPropIniting := True;
  try
    FMetaField := AField;
    if FMetaField = nil then
      vReadOnlyMode := True
    else
      vReadOnlyMode := Self.FReadOnlyMode;

    for I := 0 to Self.PanelFieldProps.ControlCount - 1 do
      SetControlReadOnly(PanelFieldProps.Controls[I]);
    edtName.ReadOnly:=True;
    edtName.ParentColor:=True;

    if FMetaField = nil then
    begin
      edtName.Text := '';
      edtDisplayName.Text := '';
      edtHint.Text := '';
      Exit;
    end;


    {if Assigned(FMetaField.OwnerTable) then
      edtTitlePrompt.Text := FMetaField.OwnerTable.Name + '.' + FMetaField.Name
    else
      edtTitlePrompt.Text := FMetaField.Name;}
    // Label7.Caption:=FloatToStr(FMetaField.OrderNo);
    edtName.Text := FMetaField.Name;
    edtDisplayName.Text := FMetaField.DisplayName;
    edtHint.Text := FMetaField.Hint;


    combEditorType.Text := GetCtDropDownTextOfValue(FMetaField.EditorType,
      srFieldEditorTypes);
    edtLabelText.Text := FMetaField.LabelText;
    edtExplainText.Text := FMetaField.ExplainText;

    ckbEditorReadOnly.Checked := FMetaField.EditorReadOnly;
    ckbEditorEnabled.Checked := FMetaField.EditorEnabled;
    ckbIsHidden.Checked := FMetaField.IsHidden;
    memoDropDownItems.Lines.Text := FMetaField.DropDownItems;  
    memoDesignNotes.Lines.Text := FMetaField.DesignNotes;

    combVisibilty.Text := GetCtDropDownTextOfValue(IntToStr(FMetaField.Visibility),
      srFieldVisibiltys);
    combTextAlign.ItemIndex := integer(FMetaField.TextAlign);
    edtColWidth.Text := IntToStrSp(FMetaField.ColWidth);
    edtMaxLength.Text := IntToStrSp(FMetaField.MaxLength);
    ckbSearchable.Checked := FMetaField.Searchable;
    ckbQueryable.Checked := FMetaField.Queryable;      
    ckbExportable.Checked := FMetaField.Exportable;
    combValueFormat.Text := GetCtDropDownTextOfValue(FMetaField.ValueFormat,
      srFieldValueFormats);

    combAggregateFun.Text := GetCtDropDownTextOfValue(FMetaField.AggregateFun,
      srFieldAggregateFun);

    edtExplainText.Text := FMetaField.ExplainText;
    edtItemColCount.Text := IntToStrSp(FMetaField.ItemColCount);
    combFixColType.ItemIndex := integer(FMetaField.FixColType);
    ckbHideOnList.Checked := FMetaField.HideOnList;
    ckbHideOnEdit.Checked := FMetaField.HideOnEdit;
    ckbHideOnView.Checked := FMetaField.HideOnView;
    ckbAutoMerge.Checked := FMetaField.AutoMerge;
    edtColGroup.Text := FMetaField.ColGroup;
    ckbColSortable.Checked := FMetaField.ColSortable;
    ckbShowFilterBox.Checked := FMetaField.ShowFilterBox;
    ckbAutoTrim.Checked := FMetaField.AutoTrim;
    ckbRequired.Checked := FMetaField.Required;
    combTestDataType.Text := GetFullTextOfValue(FMetaField.TestDataType,
      GetDataGenRules.GetItemNameCaptions);
    memoTestDataRules.Text := FMetaField.TestDataRules; 
    if FMetaField.TestDataNullPercent=0 then
      edtTestDataNullPercent.Text := ''
    else
      edtTestDataNullPercent.Text := IntToStr(FMetaField.TestDataNullPercent);
    if Trim(memoTestDataRules.Text) = '' then
      if GetDataGenRules.ItemByCaption(FMetaField.TestDataType) <> nil then
      begin
        memoTestDataRules.Text :=
          GetDataGenRules.ItemByCaption(FMetaField.TestDataType).Content;
      end;
    memoTestDataRules.Modified := False;
           
    if not FIniting and Assigned(FMetaField) then
    begin
      if Assigned(Proc_OnUIPropChanged) then
      begin
        FSkipGridRefreshTick := GetTickCount;
        FSkipCatRefreshTick := GetTickCount;
        Proc_OnUIPropChanged(FMetaField.Name, 'selected', '1', '', '', '');
      end;
    end;
  finally
    FFieldPropIniting := False;
  end;
end;

procedure TFrameUIPreview.RefreshDesignNotes;
begin
  if FSkipDesNotesRefreshTick <> 0 then
    if Abs(GetTickCount64 - FSkipDesNotesRefreshTick) > 800 then
      FSkipDesNotesRefreshTick := 0;
  if FSkipDesNotesRefreshTick = 0 then
  begin
    MemoDesignNotesAll.Lines.Text := FCtMetaTable.GetFullDesignNotes(btnShowEmptyNotes.Down);
    MemoDesignNotesAll.Modified:=False;
  end;
  MemoDesignNotesAll.ReadOnly:=Self.ReadOnlyMode; 
  btnShowEmptyNotes.Visible:= MemoDesignNotesAll.Visible;
  TimerDesignNotesEdit.Enabled:=False;
end;

procedure TFrameUIPreview.FocusFieldDesignNotes(AField: string);
  function IsFieldStart(ALine, AName: string): boolean;
  var
    po: Integer;
    S1: string;
  begin
    Result := False;
    po := Pos('. ', ALine);
    if po=0 then
      Exit;
    S1 := Copy(ALine, 1, po-1);
    if TryStrToInt(S1, po) then
      if ALine = S1 + '. '+ AName then
        Result := True;
  end;
var
  ss: TStrings;
  S, T: String;
  I, po: Integer;
  fd: TCtMetaField;
  VA, VL, VS: WideString;
begin
  fd := FCtMetaTable.MetaFields.FieldByName(AField);
  T := fd.NameCaption;
  VA := '';
  ss := MemoDesignNotesAll.Lines;
  for I:=1 to ss.Count - 1 do
  begin
    S := ss[I];
    if IsFieldStart(S, T) then
    begin
      VA := ss.LineBreak + S+ ss.LineBreak;
      Break;
    end;
  end;
  if VA='' then
    Exit;
  VL := ss.LineBreak;
  VS := ss.Text+ ss.LineBreak;
  po := Pos(VA, VS);
  if po=0 then
    Exit;
  MemoDesignNotesAll.SelStart:=po + Length(VL) -1;
  MemoDesignNotesAll.SelLength:=Length(VA)-Length(VL)-Length(VL);
end;

procedure TFrameUIPreview.ScanDesignNotes;
var
  ss: TStrings;
  rowNo, rowCount: Integer;
  rowS: string;
  function NextLine: string;
  begin
    Inc(rowNo);
    Result := '';
    rowS := '';
    if rowNo>=rowCount then
      Exit;
    rowS := ss[rowNo];
    Result := rowS;
  end;

  function IsFieldRow(ALine: string): TCtMetaField;
  var
    I, po, vi: Integer;
    S1, S2: string;
    fd: TCtMetaField;
  begin
    Result := nil;
    po := Pos('. ', ALine);
    if po=0 then
      Exit;
    S1 := Copy(ALine, 1, po-1);
    if not TryStrToInt(S1, vi) then
      Exit;
    S2 := Trim(Copy(ALine, po+2, Length(ALine)));
    for I:=0 to FCtMetaTable.MetaFields.Count - 1 do
    begin
      fd := FCtMetaTable.MetaFields[I];
      if fd.DataLevel = ctdlDeleted then
        Continue;
      if fd.NameCaption = S2 then
      begin
        Result := fd;
        Exit;
      end;
    end;
  end;

  function GetNextFieldRowNo: Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I:=rowNo + 1 to rowCount - 1 do
    begin
      if IsFieldRow(ss[I]) <> nil then
      begin
        Result := I;
        Exit;
      end;
    end;
  end;

  function ReadNextPart(var sDN, sMm: string): boolean;
  var
    Ix: Integer;
    bComment: boolean;
  begin
    ix := GetNextFieldRowNo;
    if ix=-1 then
      ix := rowCount;
    sDN := '';
    sMm := '';
    bComment := False;
    while rowNo<ix-1 do
    begin
      NextLine;
      if not bComment then
        if (Trim(rowS) = '['+srComments+']')
          or (Trim(LowerCase(rowS)) = '[comments]')
          or (Trim(LowerCase(rowS)) = '[memo]')
          or (Trim(LowerCase(rowS)) = ':memo') then
        begin
          bComment := True;
          Continue;
        end;   
      if not bComment then
      begin
        sDN := sDN + rowS+ ss.LineBreak;
      end
      else
      begin
        sMm := sMm + rowS+ ss.LineBreak;
      end;
    end;
    sDN := TrimRight(sDN);   
    sMm := TrimRight(sMm);
  end;

  function ReadNextField(var sDN, sMm: string): TCtMetaField;
  var
    I: Integer;   
    fd: TCtMetaField;
  begin
    Result := nil;      
    while rowNo<rowCount do
    begin
      NextLine;
      fd := IsFieldRow(rowS);
      if fd <> nil then
      begin
        Result := fd;
        Break;
      end;
    end;
    if fd <> nil then
      ReadNextPart(sDN, sMm);
  end;

var
  S, S1, S2, vLastField: string;
  fd: TCtMetaField;
  bChg: Integer;
begin
  //扫描设计说明文本
  TimerDesignNotesEdit.Enabled := False;
  if Self.ReadOnlyMode then
    Exit;
  if not MemoDesignNotesAll.Modified then
    Exit;              
  if not MemoDesignNotesAll.Visible then
    Exit;
  if FIniting then
    Exit;
  if FCtMetaTable=nil then
    Exit;
  MemoDesignNotesAll.Modified := False;
  ss := MemoDesignNotesAll.Lines;
  rowNo := -1;
  rowCount := ss.Count;

  //第一行应该是表名
  S := NextLine;
  if Trim(S)<>Trim(FCtMetaTable.NameCaption) then
    Exit;
         
  //第二行应该是分隔线=======
  S := NextLine;
  if Copy(S,1,4)<>'====' then
    Exit;
         
  bChg := 0;
  vLastField := '';

  //表说明和注释
  ReadNextPart(S1, S2);  
  if (Trim(FCtMetaTable.DesignNotes)<>Trim(S1)) or
    (Trim(FCtMetaTable.Memo) <> Trim(S2)) then
  begin              
    FCtMetaTable.DesignNotes:=S1;
    FCtMetaTable.Memo:=S2;
    bChg := bChg + 2;
  end;

  while rowNo<rowCount do
  begin //读取字段
    fd := ReadNextField(S1, S2);
    if fd=nil then
      Break;
    if (Trim(fd.DesignNotes)<>Trim(S1)) or
      (Trim(fd.Memo) <> Trim(S2)) then
    begin
      fd.DesignNotes:=S1;
      fd.Memo:=S2;
      bChg := bChg + 1;
      vLastField := fd.Name;
    end;
  end;

  if bChg > 1 then
  begin        
    FSkipDesNotesRefreshTick := GetTickCount64;
    NotifyTbPropChanged;
  end
  else if bChg=1 then
  begin
    if Assigned(Proc_OnUIPropChanged) then
    begin
      FSkipDesNotesRefreshTick := GetTickCount64;
      Proc_OnUIPropChanged(vLastField, 'field_changed', '', '', '', '');
    end;
  end;
end;

procedure TFrameUIPreview.SaveCatFieldProp(Sender: TObject);
var
  vFieldChanged: Integer;
  vLastChgField: TCtMetaField;

  function StrToIntDefSp(str: string; def: integer): integer;
  begin
    Result := StrToIntDef(trim(str), def);
  end;

  procedure SaveFieldEx(vMetaField: TCtMetaField);
  var
    S, S1, S2, T, sRuleTp, sRuleCt: string;
  begin
    if vMetaField=nil then
      Exit;

    S1 := vMetaField.JsonStr;

    if Sender = edtName then
    begin
      if vMetaField.Name <> edtName.Text then
      begin
        vMetaField.Name := edtName.Text;
      end;
    end;
    if Sender = edtDisplayName then
      vMetaField.DisplayName := edtDisplayName.Text;
    if Sender = edtHint then
      vMetaField.Hint := edtHint.Text;


    if Sender = combEditorType then
      vMetaField.EditorType :=
        GetCtDropDownValueOfText(combEditorType.Text, srFieldEditorTypes);
    if Sender = edtLabelText then
      vMetaField.LabelText := edtLabelText.Text;
    if Sender = edtExplainText then
      vMetaField.ExplainText := edtExplainText.Text;

    if Sender = ckbEditorReadOnly then
      vMetaField.EditorReadOnly := ckbEditorReadOnly.Checked;
    if Sender = ckbEditorEnabled then
      vMetaField.EditorEnabled := ckbEditorEnabled.Checked;
    if Sender = ckbIsHidden then
      vMetaField.IsHidden := ckbIsHidden.Checked;
    if Sender = memoDropDownItems then
      vMetaField.DropDownItems := memoDropDownItems.Lines.Text;   
    if Sender = memoDesignNotes then
      vMetaField.DesignNotes := memoDesignNotes.Lines.Text;

    if Sender = combVisibilty then
      vMetaField.Visibility :=
        StrToIntDefSp(GetCtDropDownValueOfText(combVisibilty.Text, srFieldVisibiltys),
        vMetaField.Visibility);
    if Sender = combTextAlign then
      vMetaField.TextAlign := TCtTextAlignment(combTextAlign.ItemIndex);
    if Sender = edtColWidth then
      vMetaField.ColWidth := StrToIntDefSp(edtColWidth.Text, 0);
    if Sender = edtMaxLength then
      vMetaField.MaxLength := StrToIntDefSp(edtMaxLength.Text, 0);
    if Sender = ckbSearchable then
      vMetaField.Searchable := ckbSearchable.Checked;
    if Sender = ckbQueryable then
      vMetaField.Queryable := ckbQueryable.Checked;       
    if Sender = ckbExportable then
      vMetaField.Exportable := ckbExportable.Checked;
    if Sender = combValueFormat then
      vMetaField.ValueFormat :=
        GetCtDropDownValueOfText(combValueFormat.Text, srFieldValueFormats);

    if Sender = combAggregateFun then
      vMetaField.AggregateFun :=
        GetCtDropDownValueOfText(combAggregateFun.Text, srFieldAggregateFun);

    if Sender = edtExplainText then
      vMetaField.ExplainText := edtExplainText.Text;
    if Sender = edtItemColCount then
      vMetaField.ItemColCount :=
        StrToIntDefSp(edtItemColCount.Text, vMetaField.ItemColCount);
    if Sender = combFixColType then
      vMetaField.FixColType := TCtFieldFixColType(combFixColType.ItemIndex);
    if Sender = ckbHideOnList then
      vMetaField.HideOnList := ckbHideOnList.Checked;
    if Sender = ckbHideOnEdit then
      vMetaField.HideOnEdit := ckbHideOnEdit.Checked;
    if Sender = ckbHideOnView then
      vMetaField.HideOnView := ckbHideOnView.Checked;
    if Sender = ckbAutoMerge then
      vMetaField.AutoMerge := ckbAutoMerge.Checked;
    if Sender = edtColGroup then
      vMetaField.ColGroup := edtColGroup.Text;
    if Sender = ckbColSortable then
      vMetaField.ColSortable := ckbColSortable.Checked;
    if Sender = ckbShowFilterBox then
      vMetaField.ShowFilterBox := ckbShowFilterBox.Checked;
    if Sender = ckbAutoTrim then
      vMetaField.AutoTrim := ckbAutoTrim.Checked;
    if Sender = ckbRequired then
      vMetaField.Required := ckbRequired.Checked;
                                          
    if Sender = edtTestDataNullPercent then
      FMetaField.TestDataNullPercent := StrToIntDef(edtTestDataNullPercent.Text, 0);
    if Sender = combTestDataType then
    begin
      S := combTestDataType.Text;
      if Pos(':', S) > 1 then
        S := Copy(S, 1, Pos(':', S) - 1);
      if vMetaField.TestDataType <> S then
      begin
        if Trim(vMetaField.TestDataRules) <> '' then
          if Application.MessageBox(PChar(srClearTestDataRuleWarning),
            PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
          begin
            combTestDataType.SetFocus;
            Abort;
          end;                   
        sRuleTp := vMetaField.TestDataType;
        sRuleCt := vMetaField.TestDataRules;
        vMetaField.TestDataType := S;
        if GetDataGenRules.ItemByCaption(vMetaField.TestDataType) <> nil then
        begin
          memoTestDataRules.Text :=
            GetDataGenRules.ItemByCaption(vMetaField.TestDataType).Content;
        end
        else
          memoTestDataRules.Text := '';
        vMetaField.TestDataRules := '';  
        if S = 'from_db' then
        begin
          T := ShowDBDataRule(FCtMetaTable, vMetaField.Name);
          if T <> '' then
          begin
            if ListBoxFields.SelCount = 1 then
              memoTestDataRules.Text := T;
            vMetaField.TestDataRules := T;
          end
          else
          begin                               
            if ListBoxFields.SelCount = 1 then
            begin
              combTestDataType.Text := sRuleTp;
              memoTestDataRules.Text := sRuleCt;
            end;
            vMetaField.TestDataType := sRuleTp;
            vMetaField.TestDataRules := sRuleCt;
          end;
        end;
        memoTestDataRules.Modified := False;
      end;
    end;
    if Sender = memoTestDataRules then
      if memoTestDataRules.Modified then
        vMetaField.TestDataRules := memoTestDataRules.Text;

    S2 := vMetaField.JsonStr;
    if S1 <> S2 then
    begin
      Inc(vFieldChanged);
      vMetaField.SetCtObjModified(True);
      vLastChgField := vMetaField;
    end;

  end;
var
  I: Integer;          
  fd: TCtMetaField;
begin                            
  vFieldChanged := 0;
  if FFieldPropIniting then
    Exit;
  FFieldPropIniting := True;
  try
    with ListBoxFields.Items do
      for I:= Count - 1 downto 0 do
      if ListBoxFields.Selected[I] then
      begin
        fd := TCtMetaField(Objects[I]);
        SaveFieldEx(fd);
      end;

    if vFieldChanged > 1 then
    begin                                 
      FSkipCatRefreshTick := GetTickCount64;
      NotifyTbPropChanged;
    end
    else if vFieldChanged=1 then
    begin
      if Assigned(Proc_OnUIPropChanged) then
      begin                  
        FSkipCatRefreshTick := GetTickCount64;
        Proc_OnUIPropChanged(vLastChgField.Name, 'field_changed', '', '', '', '');
      end;
    end;
  finally
    FFieldPropIniting := False;
  end;
end;

procedure TFrameUIPreview.NotifyTbPropChanged;
begin
  if Assigned(Proc_OnUIPropChanged) then
  begin
    Proc_OnUIPropChanged('', 'table_changed', '', '', '', '');
  end;
end;

procedure TFrameUIPreview.DoSetFieldTestDataRule(fd: TCtMetaField; tp: String);
var
  S, T, sRuleTp, sRuleCt: String;
  vMetaField: TCtMetaField;
begin
  if fd=nil then
    Exit;
  vMetaField := fd;
  S := tp;
  if Pos(':', S) > 1 then
    S := Copy(S, 1, Pos(':', S) - 1);
  if vMetaField.TestDataType = S then
    Exit;

  if Trim(vMetaField.TestDataRules) <> '' then
    if Application.MessageBox(PChar(srClearTestDataRuleWarning),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    begin
      Exit;
    end;

  sRuleTp := vMetaField.TestDataType;
  sRuleCt := vMetaField.TestDataRules;

  vMetaField.TestDataType := S;
  vMetaField.TestDataRules := '';
  if S = 'from_db' then
  begin
    T := ShowDBDataRule(FCtMetaTable, vMetaField.Name);
    if T <> '' then
    begin
      vMetaField.TestDataRules := T;
    end
    else
    begin
      vMetaField.TestDataType := sRuleTp;
      vMetaField.TestDataRules := sRuleCt;
      Exit;
    end;
  end;

  vMetaField.SetCtObjModified(True);
  Proc_OnUIPropChanged(vMetaField.Name, 'field_changed', '', '', '', '');
end;

procedure TFrameUIPreview.ExportGridToCsv(fn: string);
  function EncodeCsv(s: string): string;
  var
    bCode: Boolean;
  begin
    Result :=s;
    bCode := False;
    if Pos(',', Result)>0 then
      bCode := True;  
    if Pos(#13, Result)>0 then
      bCode := True; 
    if Pos(#10, Result)>0 then
      bCode := True;
    if Pos('"', Result)>0 then
    begin
      bCode := True;
      Result := StringReplace(Result, '"', '""', [rfReplaceAll]);
    end;
    if bCode then
      Result := '"'+Result+'"';
  end;
var
  x, y, cCount, rCount: Integer;
  xl: TStringList;
  S, V: String;
begin
  xl := TStringList.Create;
  try
    cCount := StringGridData.ColCount;
    rCount := StringGridData.RowCount;

    for y:=0 to rCount -1 do
    begin
      S:='';
      for x:=1 to cCount - 1 do
      begin
        V := StringGridData.Cells[x, y];
        V := EncodeCsv(V);
        S:=S+V;
        if x<cCount-1 then
          S:=S+',';
      end;
      S:=CtUtf8Decode(S);
      xl.Add(S);
    end;
    xl.SaveToFile(fn);
  finally
    xl.Free;
  end;

  if Application.MessageBox(PChar(srConfirmOpenXlsAfterExport),
    PChar(Application.Title), MB_OKCANCEL) = IDOK then
     CtOpenDoc(PChar(fn));
end;

procedure TFrameUIPreview.PanelSheetEditResize(Sender: TObject);
begin
  FSheetEditControls.RealignControls;
end;

procedure TFrameUIPreview.PanelSheetViewEnter(Sender: TObject);
begin
  FSheetViewControls.ShowFocus := True;
end;

procedure TFrameUIPreview.PanelSheetViewExit(Sender: TObject);
begin
  FSheetViewControls.ShowFocus := False;
end;

procedure TFrameUIPreview.PanelDataQueryResize(Sender: TObject);
begin
  FDataQueryControls.RealignControls;
end;

procedure TFrameUIPreview.PanelDataCardResize(Sender: TObject);
begin
  FDataCardControls.RealignControls;
end;

procedure TFrameUIPreview.PanelSheetEditEnter(Sender: TObject);
begin
  FSheetEditControls.ShowFocus := True;
end;

procedure TFrameUIPreview.PanelSheetEditExit(Sender: TObject);
begin
  FSheetEditControls.ShowFocus := False;
end;

procedure TFrameUIPreview._OnSheetSizeChange(Sender: TObject);
begin
  if not FFrameUIPrvSheet.Visible then
    Exit;
  with FFrameUIPrvSheet do
  begin
    if ActivePage = 0 then
      FSheetEditControls.CheckGenControls
    else if ActivePage = 1 then
      FSheetViewControls.CheckGenControls;
  end;
end;

procedure TFrameUIPreview._OnSheetVisChange(Sender: TObject);
begin
  actShowSheet.Checked := FFrameUIPrvSheet.Visible;
  if FFrameUIPrvSheet.Visible then
    _OnSheetSizeChange(nil);
  CheckSheetActs;
end;

procedure TFrameUIPreview.PanelDataCardEnter(Sender: TObject);
begin
  FDataCardControls.ShowFocus := True;
end;

procedure TFrameUIPreview.PanelDataCardExit(Sender: TObject);
begin
  FDataCardControls.ShowFocus := False;
end;

procedure TFrameUIPreview.PanelDataGridCardResize(Sender: TObject);
var
  spL, spT, spR, spB: Integer;
begin
  StaticTextUIScrollBR.Left := PanelDataGridCard.Width div 4;
  StaticTextUIScrollBR.Top := PanelDataGridCard.Height + WindowFuncs.ScaleDPISize(150);

  case FUIShapeType of
    2:
      begin
        spL := 25;
        spT := 15;
        spR := 40;
        spB := 15;
      end;
    3:
      begin
        spL := 10;
        spT := 30;
        spR := 10;
        spB := 40;
      end;
    else
      begin
        PanelDataGridCard.Width := 1024;
        PanelDataGridCard.Height := 640; 
        spL := 20;
        spT := 20;
        spR := 20;
        spB := 80;
      end;
  end;

  PaintBoxUIShape.Left := PanelDataGridCard.Left - ScaleDPISize(spL);
  PaintBoxUIShape.Top := PanelDataGridCard.Top - ScaleDPISize(spT);
  PaintBoxUIShape.Width := PanelDataGridCard.Width + ScaleDPISize(spL + spR);
  PaintBoxUIShape.Height := PanelDataGridCard.Height + ScaleDPISize(spT + spB);

  MemoDesignNotesAll.Top := PanelDataGridCard.Top;     
  MemoDesignNotesAll.Left := PaintBoxUIShape.Left + PaintBoxUIShape.Width + ScaleDPISize(20);
  MemoDesignNotesAll.Height := PanelDataGridCard.Height;

  btnToggleDesignNotes.Left := MemoDesignNotesAll.Left;
  btnToggleDesignNotes.Top := MemoDesignNotesAll.Top - btnToggleDesignNotes.Height - ScaleDPISize(4);

  btnShowEmptyNotes.Left := MemoDesignNotesAll.Left;
  btnShowEmptyNotes.Top := MemoDesignNotesAll.Top+MemoDesignNotesAll.Height+ScaleDPISize(2);
end;

procedure TFrameUIPreview.PanelDataQueryEnter(Sender: TObject);
begin
  FDataQueryControls.ShowFocus := True;
end;

procedure TFrameUIPreview.PanelDataQueryExit(Sender: TObject);
begin
  FDataQueryControls.ShowFocus := False;
end;

procedure TFrameUIPreview.actCustItem1Execute(Sender: TObject);
begin

end;

procedure TFrameUIPreview.actExcelExpExecute(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
  try
    Filter := 'Csv file(*.csv)|*.csv';
    Options := Options + [ofOverwritePrompt];
    DefaultExt := 'csv';
    if Execute then
      ExportGridToCsv(FileName);
  finally
    Free;
  end;
end;

procedure TFrameUIPreview.actInsertNewFieldExecute(Sender: TObject);
begin 
  if ReadOnlyMode then
    Exit;
  DoUIPropChanged('(CurField)', 'insert_new_field', '', '', '', '');
end;

procedure TFrameUIPreview.actCatAddFieldExecute(Sender: TObject);

  procedure SetFieldCat(fd: TCtMetaField);
  var
    cat: Integer;
  begin
{
0All
1Grid
2Sheet
3Card
4Query
5Fast search  
6Exportalbe
7Required
8Hidden
}
    cat := FFocusedCatIndex;
    if cat <= 0 then
      Exit;
    if cat=1 then
    begin
      if fd.IsHidden then
        fd.IsHidden:= False;
      if fd.Visibility > 2 then
        fd.Visibility := 2
      else if (fd.Visibility=0) and not fd.CanDisplay('grid') then
        fd.Visibility:=2;
      Exit;
    end;
    if cat=2 then
    begin
      if fd.IsHidden then
        fd.IsHidden:= False;
      if fd.Visibility > 3 then
        fd.Visibility := 3
      else if (fd.Visibility=0) and not fd.CanDisplay('sheet') then
        fd.Visibility:=3;
      Exit;
    end;                
    if cat=3 then
    begin
      if fd.IsHidden then
        fd.IsHidden:= False;
      if fd.Visibility > 1 then
        fd.Visibility := 1
      else if (fd.Visibility=0) and not fd.CanDisplay('card') then
        fd.Visibility:=1;
      Exit;
    end;                
    if cat=4 then
    begin
      if not fd.Queryable then
        fd.Queryable:= True;
      Exit;
    end;
    if cat=5 then
    begin
      if not fd.Searchable then
        fd.Searchable:= True;
      Exit;
    end;
    if cat=6 then
    begin
      if not fd.Exportable then
        fd.Exportable:= True;
      Exit;
    end;
    if cat=7 then
    begin
      if not fd.IsRequired then
        fd.Required:= True;
      Exit;
    end;           
    if cat=8 then
    begin
      if not fd.IsHidden then
        fd.IsHidden:= True;
      Exit;
    end;
  end;
var
  I: Integer;
  fd, nfd: TCtMetaField;
  S: string;          
  tb: TCtMetaTable;
  ss: TStringList;
begin
  if FFocusedCatIndex <= 0 then
    Exit;

  tb := TCtMetaTable.Create;
  ss:= TStringList.Create;
  try
    tb.Describe:= Self.FCtMetaTable.Describe;
    with ListBoxFields.Items do
      for I:=0 to Count - 1 do
      begin
        fd := TCtMetaField(Objects[I]);
        nfd := tb.MetaFields.FieldByName(fd.Name);
        if nfd <> nil then
          tb.MetaFields.Remove(nfd);
      end;
    S := CtSelectFields(tb.Describe, '', '[CAN_SELECT_ALL]');
    if S = '' then
      Exit;
    ss.CommaText:=S;
    for I:=0 to ss.Count - 1 do
    begin
      fd := FCtMetaTable.MetaFields.FieldByName(ss[I]);
      if fd <> nil then
        SetFieldCat(fd);
    end;
  finally
    tb.Free;
    ss.Free;
  end;

  NotifyTbPropChanged;
end;

procedure TFrameUIPreview.actCanceItemExecute(Sender: TObject);
begin
  actShowSheet.Execute;
end;

procedure TFrameUIPreview.actBackToListExecute(Sender: TObject);
begin
  if UIOperateType > 1 then
    actShowSheet.Execute;
end;

procedure TFrameUIPreview.actCatFieldMoveDownExecute(Sender: TObject);
var
  fd: TCtMetaField;
  S: String;
  cat: Integer;
begin
  if ListBoxFields.ItemIndex < 0 then
    Exit;
  cat := FFocusedCatIndex;
  case cat of
    0: s:='all';
    1: s:='grid';
    2: s:='sheet';
    3: s:='card';
    4: s:='query';
    5: s:='fastsearch';
    6: s:='required';
    7: s:='hidden';
  else
    s:='all';
  end;
  fd := TCtMetaField(ListBoxFields.Items.Objects[ListBoxFields.ItemIndex]);
  DoUIPropChanged(fd.Name, 'move_index', 'down', S, '', '');
end;

procedure TFrameUIPreview.actCatFieldMoveUpExecute(Sender: TObject);
var
  fd: TCtMetaField;
  S: String;
  cat: Integer;
begin
  if ListBoxFields.ItemIndex < 0 then
    Exit;                                 
  cat := FFocusedCatIndex;
  case cat of
    0: s:='all';
    1: s:='grid';
    2: s:='sheet';
    3: s:='card';
    4: s:='query';
    5: s:='fastsearch';
    6: s:='required';
    7: s:='hidden';
  else
    s:='all';
  end;
  fd := TCtMetaField(ListBoxFields.Items.Objects[ListBoxFields.ItemIndex]);
  DoUIPropChanged(fd.Name, 'move_index', 'up', S, '', '');
end;

procedure TFrameUIPreview.actCatFieldPropExecute(Sender: TObject);
var
  fd: TCtMetaField;
begin
  if ListBoxFields.ItemIndex < 0 then
    Exit;
  fd := TCtMetaField(ListBoxFields.Items.Objects[ListBoxFields.ItemIndex]);
  DoUIPropChanged(fd.Name, 'show_props', '', '', '', '');
end;

procedure TFrameUIPreview.actCatRemoveFieldExecute(Sender: TObject);
  procedure UnSetFieldCat(fd: TCtMetaField);                            
  var
    cat: Integer;
  begin
{
0All
1Grid
2Sheet
3Card
4Query
5Fast search
6Required
7Hidden
}
    cat := FFocusedCatIndex;
    if cat <= 0 then
      Exit;
    if cat=1 then
    begin
      if not fd.CanDisplay('grid') then
        Exit;
      fd.Visibility:=3;
      Exit;
    end;
    if cat=2 then
    begin              
      if not fd.CanDisplay('sheet') then
        Exit;
      fd.Visibility:=6;
      Exit;
    end;
    if cat=3 then
    begin
      if not fd.CanDisplay('card') then
        Exit;
      fd.Visibility:=2;
      Exit;
    end;
    if cat=4 then
    begin
      if fd.Queryable then
        fd.Queryable:= False;
      Exit;
    end;
    if cat=5 then
    begin
      if fd.Searchable then
        fd.Searchable:= False;
      Exit;
    end;     
    if cat=6 then
    begin
      if fd.Exportable then
        fd.Exportable:= False;
      Exit;
    end;
    if cat=7 then
    begin
      if fd.IsRequired then
        fd.Required:= False;
      Exit;
    end;
    if cat=8 then
    begin
      if fd.IsHidden then
        fd.IsHidden:= False;
      if fd.Visibility > 3 then
        fd.Visibility := 3
      else if (fd.Visibility=0) and not fd.CanDisplay('sheet') then
        fd.Visibility:=3;
      Exit;
    end;
  end;
var
  I: Integer;            
  fd: TCtMetaField;
begin
  if FFocusedCatIndex <= 0 then
    Exit;
  with ListBoxFields.Items do
    for I:= Count - 1 downto 0 do
    if ListBoxFields.Selected[I] then
    begin
      fd := TCtMetaField(Objects[I]);
      UnSetFieldCat(fd);
    end;
  NotifyTbPropChanged;
end;

procedure TFrameUIPreview.actPageSizeExecute(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  S:=IntToStr(FGridPageSize);
  if not PvtInput.PvtInputQuery(actPageSize.Caption, actPageSize.Caption, S) then
    Exit;
  I := StrToIntDef(S, -1);
  if I<2 then
    Exit;
  if I>1000 then
    I := 1000;  
  if FGridPageSize = I then
    Exit;
  FGridPageSize := I;
  actRefresh.Execute;
end;

procedure TFrameUIPreview.actPostItemExecute(Sender: TObject);
begin
  actShowSheet.Execute;
end;

procedure TFrameUIPreview.actViewItemExecute(Sender: TObject);
begin
  UIOperateType := 2;
end;

procedure TFrameUIPreview.actModifyItemExecute(Sender: TObject);
begin             
  UIOperateType := 3;
end;

procedure TFrameUIPreview.actNewItemExecute(Sender: TObject);
begin     
  UIOperateType := 4;
end;

procedure TFrameUIPreview.actRefreshExecute(Sender: TObject);
begin
  FLastTbJson := '';
  FDataQueryControls.TextDesc := '';
  FDataCardControls.TextDesc := '';
  FSheetViewControls.TextDesc := '';
  FSheetEditControls.TextDesc := '';
  RefreshUI;
end;

procedure TFrameUIPreview.actQueryExecute(Sender: TObject);
begin
  if PanelDataQuery.Tag > 0 then
  begin
    PanelDataQuery.Visible := not PanelDataQuery.Visible;
    if PanelDataQuery.Visible then
      FDataQueryControls.CheckGenControls;
    actQuery.Checked := PanelDataQuery.Visible;
  end;                                         
  FShowSearchOnInit := PanelDataQuery.Visible;
end;

procedure TFrameUIPreview.actCardViewExecute(Sender: TObject);
begin
  if StringGridData.Visible then
  begin
    ScrollBoxDataCard.Visible := True;
    StringGridData.Visible := False;
    PanelSummary.Visible := False;
    actCardView.Checked := True;
  end
  else
  begin
    ScrollBoxDataCard.Visible := False;
    PanelSummary.Visible := HeaderControlSummary.Sections.Count > 0;
    StringGridData.Visible := True;
    actCardView.Checked := False;
  end;
  CheckCardGridCtrls;
end;

procedure TFrameUIPreview.actShowSheetExecute(Sender: TObject);
begin                    
    //操作类型：1列表 2查看 3修改 4新增
  if UIOperateType = 3 then
    UIOperateType := 2
  else if UIOperateType > 1 then
    UIOperateType := 1
  else
  begin
    UIOperateType := 2;
  end;
end;

procedure TFrameUIPreview.btnShowEmptyNotesClick(Sender: TObject);
begin
  Self.ScanDesignNotes;
  //btnShowEmptyNotes.Down := not btnShowEmptyNotes.Down;
  RefreshDesignNotes;
end;

procedure TFrameUIPreview.btnToggleDesignNotesClick(Sender: TObject);
begin
  MemoDesignNotesAll.Visible:=not MemoDesignNotesAll.Visible;
  btnShowEmptyNotes.Visible:= MemoDesignNotesAll.Visible;
  btnToggleDesignNotes.Down:= MemoDesignNotesAll.Visible;
end;

procedure TFrameUIPreview.btnToggleUISettingsClick(Sender: TObject);
begin
  TopPanelVisible := not TopPanelVisible;
end;

procedure TFrameUIPreview.btnUIShapePadClick(Sender: TObject);
begin
  UIShapeType := 2;
end;

procedure TFrameUIPreview.btnUIShapePCClick(Sender: TObject);
begin
  UIShapeType := 1;
end;

procedure TFrameUIPreview.btnUIShapePhoneClick(Sender: TObject);
begin
  UIShapeType := 3;
end;

procedure TFrameUIPreview.EditFastSearchEnter(Sender: TObject);
begin
  if EditFastSearch.Text = EditFastSearch.Hint then
    EditFastSearch.Text := '';
end;

procedure TFrameUIPreview.EditFastSearchExit(Sender: TObject);
begin
  if EditFastSearch.Text = '' then
    EditFastSearch.Text := EditFastSearch.Hint;
end;

procedure TFrameUIPreview.edtNameExit(Sender: TObject);
begin
  SaveCatFieldProp(Sender);
end;

procedure TFrameUIPreview.FrameResize(Sender: TObject);
begin
  if Self.Height >= 200 then
    if (FTopSplitPercent>=0.05) and (FTopSplitPercent<=0.95) then
      PanelTopDesign.Height := Round(Self.Height * FTopSplitPercent);
end;


procedure TFrameUIPreview.HeaderControlSummaryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  I: integer;
  pt: TPoint;
begin
  if Button = mbRight then
  begin
    pt := Point(X, Y);
    SetGridFucosColIndex(HeaderControlSummary.GetSectionAt(pt));
    pt := HeaderControlSummary.ClientToScreen(pt);
    PopupMenuGrid.PopUp(pt.X, pt.Y);
  end;
end;

procedure TFrameUIPreview.HeaderControlSummarySectionClick(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  if Section <> nil then
  begin
    SetGridFucosColIndex(Section.Index);
  end;
end;

procedure TFrameUIPreview.HeaderControlSummarySectionResize(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
var
  w, Index: integer;
  S: string;
begin
  if Section = nil then
    Exit;
  Index := Section.Index;
  if Index < 0 then
    Exit;
  if Index >= StringGridData.ColCount then
    Exit;
  StringGridData.ColWidths[Index] := Section.Width;

  if Index >= 1 then
  begin
    StringGridData.Col := Index;
    S := GetGridFieldName;
    w := ScaleDPISize(StringGridData.ColWidths[Index]);
    DoUIPropChanged(S, 'ColWidth', IntToStr(w), '', '', '[DONT_REFRESH_GRID]');
  end;
end;

procedure TFrameUIPreview.ListBoxFieldCategoryClick(Sender: TObject);
  procedure CheckCatUILayout;
  var
    cat: Integer;
  begin
    cat := FFocusedCatIndex;
{
0All
1Grid
2Sheet
3Card
4Query
5Fast search
6Exportable
7Required
8Hidden
}
    if cat<=0 then
    begin
      SetUITypes(1, 1);
      if PanelDataQuery.Visible then
        actQuery.Execute;
      if not FShowHiddenFields then
        MN_ShowHiddenFieldsClick(nil);
      Exit;
    end;
    if cat=1 then
    begin
      SetUITypes(1, 1);
      if PanelDataQuery.Visible then
        actQuery.Execute;
      if FShowHiddenFields then
        MN_ShowHiddenFieldsClick(nil);
      Exit;
    end;
    if cat=2 then
    begin
      UIOperateType := 3;
      Exit;
    end;
    if cat=3 then
    begin                        
      if UIShapeType = 1 then 
        SetUITypes(2, 1)
      else
        UIOperateType := 1;
      Exit;
    end;
    if cat = 4 then
    begin
      SetUITypes(1, 1);
      if not PanelDataQuery.Visible then
        actQuery.Execute;                 
      if FShowHiddenFields then
        MN_ShowHiddenFieldsClick(nil);
      Exit;
    end;
    if cat =5 then
    begin            
      SetUITypes(1, 1);
      if PanelDataQuery.Visible then
        actQuery.Execute;                   
      if FShowHiddenFields then
        MN_ShowHiddenFieldsClick(nil);
      Exit;
    end;  
    if cat=6 then
    begin
      SetUITypes(1, 1);
      Exit;
    end;     
    if cat=7 then
    begin
      UIOperateType := 3;
      Exit;
    end;
    if cat=8 then
    begin
      SetUITypes(1, 1);
      if PanelDataQuery.Visible then
        actQuery.Execute;
      if not FShowHiddenFields then
        MN_ShowHiddenFieldsClick(nil);
      Exit;
    end;
  end;
begin
  if Self.FIniting then
    Exit;
  FFocusedCatIndex := ListBoxFieldCategory.ItemIndex;
  RefreshCatFields;
  CheckCatUILayout;
end;

procedure TFrameUIPreview.ListBoxFieldsClick(Sender: TObject);
begin
  if ListBoxFields.ItemIndex < 0 then
    InitCatField(nil)
  else if not ListBoxFields.Selected[ListBoxFields.ItemIndex] then
  begin
    ListBoxFields.ItemIndex := -1;
    InitCatField(nil);
  end
  else
    InitCatField(TCtMetaField(ListBoxFields.Items.Objects[ListBoxFields.ItemIndex]));
end;

procedure TFrameUIPreview.ListBoxFieldsDblClick(Sender: TObject);
begin
  actCatFieldProp.Execute;
end;

procedure TFrameUIPreview.MemoDesignNotesAllChange(Sender: TObject);
begin
  TimerDesignNotesEdit.Enabled := False;
  if FIniting then
    Exit;
  TimerDesignNotesEdit.Enabled := True;
end;

procedure TFrameUIPreview.MemoDesignNotesAllExit(Sender: TObject);
begin
  ScanDesignNotes;
end;

procedure TFrameUIPreview.MNCard_BackToGridClick(Sender: TObject);
begin
  actCardView.Execute;
end;

procedure TFrameUIPreview.MNGrid_Aggr_SumClick(Sender: TObject);
  function MultiColSelected(R: TRect): boolean;
  begin
    Result := False;
    if r.Left = r.Right then
      Exit;
    if r.Left = 1 then
      if r.Right = StringGridData.ColCount - 1 then
        if r.Top = r.Bottom then
          Exit;
    Result := True;
  end;

var
  I, Index: integer;
  r: TRect;
  hnt: String;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;
  if FRefreshUpdateing then
    Exit;
  hnt := TMenuItem(Sender).Hint;

  r := StringGridData.Selection;
  if MultiColSelected(r) then
  begin
    FRefreshUpdateing := True;
    try
      for I := r.Left to r.Right do
      begin
        Index := I;
        if Index >= 1 then
        begin
          DoUIPropChanged(GetGridFieldName(Index),
            'AggregateFun', hnt, '', '', '');
        end;
      end;
    finally
      FRefreshUpdateing := False;
    end;
    RefreshUI;
    Exit;
  end;

  Index := StringGridData.Col;
  if Index >= 1 then
  begin
    DoUIPropChanged(GetGridFieldName, 'AggregateFun',
      hnt, '', '', '');
  end;
end;

procedure TFrameUIPreview.MNGrid_Align_Click(Sender: TObject);

  function MultiColSelected(R: TRect): boolean;
  begin
    Result := False;
    if r.Left = r.Right then
      Exit;
    if r.Left = 1 then
      if r.Right = StringGridData.ColCount - 1 then
        if r.Top = r.Bottom then
          Exit;
    Result := True;
  end;

var
  I, Index, tag: integer;
  r: TRect;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;
  if FRefreshUpdateing then
    Exit;
  tag := TMenuItem(Sender).Tag;

  r := StringGridData.Selection;
  if MultiColSelected(r) then
  begin
    FRefreshUpdateing := True;
    try
      for I := r.Left to r.Right do
      begin
        Index := I;
        if Index >= 1 then
        begin
          DoUIPropChanged(GetGridFieldName(Index),
            'TextAlignment', IntToStr(tag), '', '', '');
        end;
      end;
    finally
      FRefreshUpdateing := False;
    end;
    RefreshUI;
    Exit;
  end;

  Index := StringGridData.Col;
  if Index >= 1 then
  begin
    DoUIPropChanged(GetGridFieldName, 'TextAlignment',
      IntToStr(tag), '', '', '');
  end;
end;

procedure TFrameUIPreview.MNGrid_CopyAllClick(Sender: TObject);
var
  Y, X, C: integer;
  row, ss: TStrings;
  S, Ts: string;
begin
  ss := TStringList.Create;
  try
    C := StringGridData.ColCount;
    for Y := 0 to StringGridData.RowCount - 1 do
    begin
      row := StringGridData.Rows[Y];
      S := '';
      for X := 1 to C - 1 do
      begin
        if X > 1 then
          S := S + #9;
        if X < row.Count then
          S := S + row[X];
      end;
      ss.Add(S);
    end;
    Ts := ss.Text;
    if Ts <> '' then
    begin
      Clipboard.AsText := Ts;
    end;
  finally
    ss.Free;
  end;
end;

procedure TFrameUIPreview.MNGrid_CopyCellClick(Sender: TObject);
var          
  x, y: integer;
  r: TRect;
  Ts: string;
  bFirst: Boolean;
begin           
  r := StringGridData.Selection;
  if (r.Right>r.Left) or (r.Bottom > r.Top) then
  begin
    Ts := '';
    for y:=r.Top to r.Bottom do
    begin
      bFirst := True;
      for x:=r.Left to r.Right do
      begin
       if bFirst then
         bFirst := False
       else
         Ts := Ts+#9;
       Ts := Ts + StringGridData.Cells[x, y];
      end;
      Ts := Ts + #13#10;
    end;  
    Clipboard.AsText := Ts;
    Exit;
  end;

  if StringGridData.Col < 0 then
    Exit;         
  if StringGridData.Row < 0 then
    Exit;
  Ts := StringGridData.Cells[StringGridData.Col, StringGridData.Row];
  if Ts <> '' then
    Clipboard.AsText := Ts;
end;

procedure TFrameUIPreview.MNGrid_CopyColClick(Sender: TObject);
var
  ss: TStrings;
  Ts: string;
begin
  if StringGridData.Col < 0 then
    Exit;
  ss := StringGridData.Cols[StringGridData.Col];
  //Ts := StringGridData.Columns[StringGridData.Col].Title.Caption;
  Ts := ss.Text;
  Clipboard.AsText := Ts;
end;

procedure TFrameUIPreview.MNGrid_CopyFieldNameClick(Sender: TObject);
var
  fd: TCtMetaField;
begin
  if StringGridData.Col < 0 then
    Exit;
  fd := Self.GetGridField(StringGridData.Col);
  if fd <> nil then
    Clipboard.AsText := fd.NameCaption;
end;

procedure TFrameUIPreview.MNGrid_TestData_Click(Sender: TObject);
var
  Index: integer;
  fd: TCtMetaField;
  tp: String;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;
  if FRefreshUpdateing then
    Exit;
  tp := TMenuItem(Sender).Hint;

  Index := StringGridData.Col;
  if Index >= 1 then
  begin
    fd := GetGridField(Index);
    DoSetFieldTestDataRule(fd, tp);
  end;
end;
         
procedure TFrameUIPreview.MNSC_TestData_Click(Sender: TObject);
var
  tp: string;
  fd: TCtMetaField;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;           
  if FCtMetaTable = nil then
    Exit;
  if FLastScControlName='' then
    Exit;
  fd := FCtMetaTable.MetaFields.FieldByName(FLastScControlName);
  if fd = nil then
    Exit;
  tp := TMenuItem(Sender).Hint;
  DoSetFieldTestDataRule(fd, tp);
end;

procedure TFrameUIPreview.MNSc_Align_Click(Sender: TObject);
var
  tag: integer;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;
  tag := TMenuItem(Sender).Tag;
  DoUIPropChanged(FLastScControlName, 'TextAlignment', IntToStr(tag), '', '', '');
end;

procedure TFrameUIPreview.MNSc_CopyFieldNameClick(Sender: TObject);  var
  fd: TCtMetaField;
begin
  if StringGridData.Col < 0 then
    Exit;
  fd := FCtMetaTable.MetaFields.FieldByName(FLastScControlName);
  if fd <> nil then
    Clipboard.AsText := fd.NameCaption;
end;

procedure TFrameUIPreview.MNSC_Editor_Click(Sender: TObject);
var
  hnt: string;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;
  hnt := TMenuItem(Sender).Hint;
  DoUIPropChanged(FLastScControlName, 'EditorType', hnt, '', '', '');
end;


procedure TFrameUIPreview.MNSC_VisClick(Sender: TObject);
var
  tag: integer;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;
  tag := TMenuItem(Sender).Tag;
  DoUIPropChanged(FLastScControlName, 'Visibility', IntToStr(tag), '', '', '');
end;

procedure TFrameUIPreview.MNSC_MoveDownClick(Sender: TObject);
begin
  DoUIPropChanged(FLastScControlName, 'move_index', 'down', 'sheet', '', '');
end;

procedure TFrameUIPreview.MNSc_MoveToBottomClick(Sender: TObject);
begin
  DoUIPropChanged(FLastScControlName, 'move_index', 'bottom', 'sheet', '', '');
end;


procedure TFrameUIPreview.MNGrid_MoveToBackClick(Sender: TObject);
var
  sIndex, tIndex: integer;
  f1, f2: string;
begin
  if ReadOnlyMode then
    Exit;
  sIndex := StringGridData.Col;
  tIndex := StringGridData.ColCount - 1;
  if tIndex >= 1 then
  begin
    f1 := GetGridFieldName(tIndex);
    if tIndex < StringGridData.ColCount - 1 then
      f2 := GetGridFieldName(tIndex + 1)
    else
      f2 := '';
    DoUIPropChanged(GetGridFieldName(sIndex), 'index_position',
      '', f1, f2, '');
  end;
end;

procedure TFrameUIPreview.MNGrid_MoveToFrontClick(Sender: TObject);
var
  sIndex, tIndex: integer;
  f1, f2: string;
begin
  if ReadOnlyMode then
    Exit;
  sIndex := StringGridData.Col;
  tIndex := 1;
  if tIndex >= 1 then
  begin
    f1 := GetGridFieldName(tIndex - 1);
    if tIndex < StringGridData.ColCount - 1 then
      f2 := GetGridFieldName(tIndex)
    else
      f2 := '';
    DoUIPropChanged(GetGridFieldName(sIndex), 'index_position',
      '', f1, f2, '');
  end;
end;

procedure TFrameUIPreview.MNGrid_PropClick(Sender: TObject);

  function MultiColSelected(R: TRect): boolean;
  begin
    Result := False;
    if r.Left = r.Right then
      Exit;
    if r.Left = 1 then
      if r.Right = StringGridData.ColCount - 1 then
        if r.Top = r.Bottom then
          Exit;
    Result := True;
  end;

var
  I, Index: integer;
  r: TRect;
  s, v: string;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;
  if FRefreshUpdateing then
    Exit;
  r := StringGridData.Selection;

  if MultiColSelected(r) then
  begin
    FRefreshUpdateing := True;
    try
      if TMenuItem(Sender).Checked then
        v := '0'
      else
        v := '1';
      for I := r.Left to r.Right do
      begin
        Index := I;
        if Index >= 1 then
        begin
          DoUIPropChanged(GetGridFieldName(Index),
            TMenuItem(Sender).Hint, v, '', '', '[DONT_REFRESH_GRID]');
        end;
      end;
    finally
      FRefreshUpdateing := False;
    end;
    RefreshUI;
    Exit;
  end;

  Index := StringGridData.Col;
  if Index >= 1 then
  begin
    S := '';
    v := TMenuItem(Sender).Hint;
    if (v <> 'Hidden') and (v <> 'Sortable') and (v <> 'ShowFilterBox') then
      S := '[DONT_REFRESH_GRID]';
    DoUIPropChanged(GetGridFieldName, TMenuItem(Sender).Hint,
      'toggle', '', '', S);
  end;
end;

procedure TFrameUIPreview.MNGrid_PropertiesClick(Sender: TObject);
var
  Index: integer;
begin
  Index := StringGridData.Col;
  if Index >= 1 then
  begin
    DoUIPropChanged(GetGridFieldName, 'show_props', '', '', '', '');
  end;
end;


procedure TFrameUIPreview.MNGrid_VisResetAllClick(Sender: TObject);
begin
  if ReadOnlyMode then
    Exit;
  DoUIPropChanged('__ui_frame__', '__ui_frame__reset_visibilities', '', '', '', '');
end;

procedure TFrameUIPreview.MNGrid_Vis_Click(Sender: TObject);

  function MultiColSelected(R: TRect): boolean;
  begin
    Result := False;
    if r.Left = r.Right then
      Exit;
    if r.Left = 1 then
      if r.Right = StringGridData.ColCount - 1 then
        if r.Top = r.Bottom then
          Exit;
    Result := True;
  end;

var
  I, Index, tag: integer;
  r: TRect;
  fd: TCtMetaField;
begin
  if ReadOnlyMode then
    Exit;
  if Sender = nil then
    Exit;
  if FRefreshUpdateing then
    Exit;
  tag := TMenuItem(Sender).Tag;

  r := StringGridData.Selection;
  if MultiColSelected(r) then
  begin
    FRefreshUpdateing := True;
    try
      for I := r.Left to r.Right do
      begin
        Index := I;
        if Index >= 1 then
        begin
          if tag = -3 then
          begin
            fd := GetGridField(Index);
            if not fd.CanDisplay('grid') then
              Continue;  
            DoUIPropChanged(GetGridFieldName(Index),
              'Visibility', '3', '', '', '');
          end
          else
            DoUIPropChanged(GetGridFieldName(Index),
              'Visibility', IntToStr(tag), '', '', '');
        end;
      end;
    finally
      FRefreshUpdateing := False;
    end;
    RefreshUI;
    Exit;
  end;

  Index := StringGridData.Col;
  if Index >= 1 then
  begin         
    if tag = -3 then
    begin
      fd := GetGridField(Index);
      if fd.CanDisplay('grid') then
        DoUIPropChanged(GetGridFieldName(Index),
          'Visibility', '3', '', '', '');
    end
    else
      DoUIPropChanged(GetGridFieldName, 'Visibility',
        IntToStr(tag), '', '', '');
  end;
end;

procedure TFrameUIPreview.MNSc_MoveToTopClick(Sender: TObject);
begin
  DoUIPropChanged(FLastScControlName, 'move_index', 'top', 'sheet', '', '');
end;

procedure TFrameUIPreview.MNSc_MoveUpClick(Sender: TObject);
begin
  DoUIPropChanged(FLastScControlName, 'move_index', 'up', 'sheet', '', '');
end;

procedure TFrameUIPreview.MNSC_PropertiesClick(Sender: TObject);
begin
  DoUIPropChanged(FLastScControlName, 'show_props', '', '', '', '');
end;

procedure TFrameUIPreview.MNSc_PropClick(Sender: TObject);
begin
  DoUIPropChanged(FLastScControlName, TMenuItem(Sender).Hint, 'toggle', '', '', '');
end;

procedure TFrameUIPreview.MN_ShowHiddenFieldsClick(Sender: TObject);
begin
  FShowHiddenFields := not FShowHiddenFields;
  MN_ShowHiddenFields.Checked := FShowHiddenFields;
  actRefresh.Execute;
end;

procedure TFrameUIPreview.PaintBoxUIShapePaint(Sender: TObject);
var
  w, h, cx, cy, dw, rd: Integer;
begin
  with PaintBoxUIShape do
  begin          
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := clGray;
    Canvas.Pen.Color := Canvas.Brush.Color;
    rd := WindowFuncs.ScaleDPISize(24);
    w:=Width;
    h:=Height;
    if FUIShapeType=1 then
    begin
      h:=h-ScaleDPISize(50);      
      Canvas.RoundRect(0,0,w, h, rd, rd);

      cx := w div 2;
      dw := w div 40;
      Canvas.FillRect(cx - dw, h, cx+dw, h + ScaleDPISize(20));

      dw := w div 8;
      rd := WindowFuncs.ScaleDPISize(5);
      Canvas.RoundRect(cx - dw, h + ScaleDPISize(20), cx+dw, h + ScaleDPISize(36), rd, rd);
    end
    else if FUIShapeType=2 then
    begin
      Canvas.RoundRect(0,0,w, h, rd, rd);

      Canvas.Pen.Color := clWhite;
      cx := ScaleDPISize(12);
      cy := h div 2;
      dw := ScaleDPISize(3);
      Canvas.Ellipse(cx - dw, cy-dw, cx+dw+1, cy+dw+1);
    end
    else if FUIShapeType=3 then
    begin
      Canvas.RoundRect(0,0,w, h, rd, rd);

      Canvas.Pen.Color := clWhite;
      cx := w div 2;
      cy := ScaleDPISize(15);
      dw := ScaleDPISize(3);
      Canvas.Ellipse(cx - dw, cy-dw, cx+dw+1, cy+dw+1);
    end;
  end;
end;

procedure TFrameUIPreview.PanelSheetViewResize(Sender: TObject);
begin
  FSheetViewControls.RealignControls;
end;

procedure TFrameUIPreview.sbtnMobNavAddClick(Sender: TObject);
begin
  actNewItem.Execute;
end;

procedure TFrameUIPreview.sbtnMobNavEditClick(Sender: TObject);
begin
  actModifyItem.Execute;
end;


procedure TFrameUIPreview.sbtnMobNavSaveClick(Sender: TObject);
begin
  actPostItem.Execute;
end;

procedure TFrameUIPreview.ScrollBoxDataCardResize(Sender: TObject);
begin
  PanelDataCard.Width := ScrollBoxDataCard.ClientWidth - 2;
end;

procedure TFrameUIPreview.ScrollBoxUIPanelsResize(Sender: TObject);
begin
  //PanelToggleMaximize.Left := Self.ClientWidth - PanelToggleMaximize.Width - btnToggleUISettings.Width - 1;
  PanelToggleMaximize.Top := ScrollBoxUIPanels.Top + 3;
end;


procedure TFrameUIPreview.SplitterTopPanelMoved(Sender: TObject);
begin
  if Self.Height < 50 then
    Exit;            
  if PanelTopDesign.Height < 20 then
    Exit;
  FTopSplitPercent := PanelTopDesign.Height/Self.Height;
end;

constructor TFrameUIPreview.Create(AOwner: TComponent);
  procedure InitEditorTypeMenus;
  var
    ss: TStringList;
    S, V: string;
    I, po: Integer;
    mn: TMenuItem;
  begin
    ss:= TStringList.create;
    try
      ss.Text := srFieldEditorTypes;
      for I:=0 to ss.Count - 1 do
      begin
        S:=ss[I];
        po := Pos('=', S);
        if po>0 then
        begin
          V := Copy(S, po+1, Length(S));
          S := Copy(S, 1, po-1);
        end
        else
          V := S;   
        mn:= TMenuItem.Create(Self);
        mn.Caption := V;
        mn.Hint := S;
        mn.RadioItem:=True;
        mn.OnClick:=MNSC_Editor_Click;
        MNSC_EditorType.Add(mn);
      end;
    finally
      ss.Free;
    end;
  end;

  procedure InitTestDataTypeMenus(bSc: Boolean);
  var
    ss: TStringList;
    S, V: string;
    I, po: Integer;
    mn: TMenuItem;
  begin
    ss:= TStringList.create;
    try
      ss.Text := GetDataGenRules.GetItemNameCaptions;
      for I:=0 to ss.Count - 1 do
      begin
        S:=ss[I];
        if Trim(S)='' then
          Continue;
        po := Pos('=', S);
        if po>0 then
        begin
          V := Copy(S, po+1, Length(S));
          S := Copy(S, 1, po-1);
        end
        else
          V := S;
        mn:= TMenuItem.Create(Self);
        mn.Caption := V;
        mn.Hint := S;
        if bSc then
        begin
          mn.OnClick:=MNSC_TestData_Click;
          MNSC_TestDataType.Add(mn);
        end
        else
        begin             
          mn.OnClick:=MNGrid_TestData_Click;
          MNGrid_TestDataType.Add(mn);
        end;
      end;
    finally
      ss.Free;
    end;
  end;
begin
  inherited Create(AOwner);
  FTopSplitPercent := 0.7;
  FUIShapeType := 1;
  FUIOperateType := 1;

  FFrameUIPrvSheet := TFrameUIPrvSheet.Create(Self);
  with FFrameUIPrvSheet do
  begin
    PanelSheetEdit.OnEnter := PanelSheetEditEnter;
    PanelSheetEdit.OnExit := PanelSheetEditExit;
    PanelSheetEdit.OnResize := PanelSheetEditResize;
    PanelSheetView.OnEnter := PanelSheetViewEnter;
    PanelSheetView.OnExit := PanelSheetViewExit;
    PanelSheetView.OnResize := PanelSheetViewResize;
    OnSheetResized := Self._OnSheetSizeChange;
    OnShow := _OnSheetVisChange;
    OnHide := _OnSheetVisChange;   
    SheetContainer := PanelSheetContainer;
  end;

  StringGridData := TStringGridUI.Create(Self);
  StringGridData.Parent := PanelDataGridCard;
  with StringGridData do
  begin
    Align := alClient;
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
      goRangeSelect, goColSizing, goColMoving, goThumbTracking, goSmoothScroll];
    TabOrder := 0;
    TitleImageList := ImageListColTitle;
    TStringGridUI(StringGridData).OnUIScrolled := _OnGridUIScrolled;
    OnClick := StringGridDataClick;
    OnColRowMoved := StringGridDataColRowMoved;
    OnDblClick := StringGridDataDblClick;
    OnHeaderClick := StringGridDataHeaderClick;
    OnHeaderSized := StringGridDataHeaderSized;
    OnMouseDown := StringGridDataMouseDown;
    OnPrepareCanvas := StringGridDataPrepareCanvas;
    OnTopleftChanged := _OnGridUIScrolled;
  end;

  ListBoxFieldCategory.Items.Text := srUIFieldCategory;

  InitEditorTypeMenus;         
  InitTestDataTypeMenus(False);
  InitTestDataTypeMenus(True);

  FShowHiddenFields := False;
  FShowSearchOnInit := False;
  FGridPageSize := 25;

  FDataQueryControls := TDmlScriptControlList.Create;
  FDataCardControls := TDmlScriptControlList.Create;
  FSheetViewControls := TDmlScriptControlList.Create;
  FSheetEditControls := TDmlScriptControlList.Create;

  FDataCardControls.OnCtrlEvent := Self._OnCardScControlEvent;

  FDataQueryControls.OnCtrlEvent := Self._OnScriptControlEvent;
  FSheetViewControls.OnCtrlEvent := Self._OnScriptControlEvent;
  FSheetEditControls.OnCtrlEvent := Self._OnScriptControlEvent;

  FDataQueryControls.ItemLineHeight := 28;
  FDataCardControls.ColWidth := 280;
  FDataCardControls.FocusColor := clHighlight;
  FSheetViewControls.MaxColCount := 2;
  FSheetViewControls.ColWidth := 360;
  FSheetEditControls.MaxColCount := 2;
  FSheetEditControls.ColWidth := 360;

  FDataQueryControls.ParentWnd := PanelDataQuery;
  FDataCardControls.ParentWnd := PanelDataCard;
  FSheetViewControls.ParentWnd := FFrameUIPrvSheet.PanelSheetView;
  FSheetEditControls.ParentWnd := FFrameUIPrvSheet.PanelSheetEdit;

  FSheetViewControls.LabelDraggable := True;
  FSheetEditControls.LabelDraggable := True;

  Self.SpdBtnAddField.Caption := '';
  Self.SpdBtnDelField.Caption := '';
  Self.SpdBtnUpField.Caption := '';
  Self.SpdBtnDownField.Caption := '';

  combVisibilty.Items.Text := GetCtDropDownItemsText(srFieldVisibiltys);
  combEditorType.Items.Text := GetCtDropDownItemsText(srFieldEditorTypes);
  combFixColType.Items.Text := srFieldFixColType;
  combTextAlign.Items.Text := srFieldTextAlign;
  combAggregateFun.Items.Text := GetCtDropDownItemsText(srFieldAggregateFun);
  combValueFormat.Items.Text := GetCtDropDownItemsText(srFieldValueFormats);
  combTestDataType.Items.Text := GetDataGenRules.GetItemNameCaptions;

end;

destructor TFrameUIPreview.Destroy;
begin
  FreeAndNil(FDataQueryControls);
  FreeAndNil(FDataCardControls);
  FreeAndNil(FSheetViewControls);
  FreeAndNil(FSheetEditControls);
  inherited Destroy;
end;

procedure TFrameUIPreview.LoadConfig(secEx: string);
var
  fn, S: string;
  ini: TIniFile;
begin
  fn := GetConfFileOfApp;
  if FileExists(fn) then
  begin
    ini := TIniFile.Create(fn);
    try
      S := 'UIPreview' + secEx;
      FShowHiddenFields := ini.ReadBool(S, 'ShowHiddenFields', FShowHiddenFields);
      MN_ShowHiddenFields.Checked := FShowHiddenFields;
      FShowSearchOnInit := ini.ReadBool(S, 'ShowSearchPanel', FShowSearchOnInit);
      FGridPageSize := ini.ReadInteger(S, 'ListPageSize', FGridPageSize);
      FTopSplitPercent := ini.ReadFloat(S, 'TopSplitPercent', FTopSplitPercent);
      FFocusedCatIndex := ini.ReadInteger(S, 'FocusedCatIndex', 1);
      TopPanelVisible := ini.ReadBool(S, 'TopPanelVisible', False);

      FUIShapeType := ini.ReadInteger(S, 'UIShapeType', 1);
      FUIOperateType := ini.ReadInteger(S, 'UIOperateType', 1);
      if MemoDesignNotesAll.Visible <> ini.ReadBool(S, 'DesignNotesVisible', True) then
      begin
        MemoDesignNotesAll.Visible := not MemoDesignNotesAll.Visible;
        btnToggleDesignNotes.Down:= MemoDesignNotesAll.Visible;
      end;
    finally
      ini.Free;
    end;
  end
  else
  begin
    TopPanelVisible := False;
    FFocusedCatIndex := 1;
    FUIShapeType := 1;
    FUIOperateType := 1;
  end;
end;

procedure TFrameUIPreview.SaveConfig(secEx: string);
var
  fn, S: string;
  ini: TIniFile;
begin
  fn := GetConfFileOfApp;
  ini := TIniFile.Create(fn);
  try
    S := 'UIPreview' + secEx;
    ini.WriteBool(S, 'ShowHiddenFields', FShowHiddenFields);
    ini.WriteBool(S, 'ShowSearchPanel', FShowSearchOnInit);
    ini.WriteInteger(S, 'ListPageSize', FGridPageSize);     
    ini.WriteFloat(S, 'TopSplitPercent', FTopSplitPercent);
    ini.WriteInteger(S, 'FocusedCatIndex', FFocusedCatIndex);   
    ini.WriteBool(S, 'TopPanelVisible', TopPanelVisible);    
    ini.WriteInteger(S, 'UIShapeType', FUIShapeType);
    ini.WriteInteger(S, 'UIOperateType', FUIOperateType);  
    ini.WriteBool(S, 'DesignNotesVisible', MemoDesignNotesAll.Visible);
  finally
    ini.Free;
  end;
end;

procedure TFrameUIPreview.InitByTable(ATable: TCtMetaTable; bReadOnlyMode: boolean);
begin
  if FCtMetaTable <> ATable then
  begin
    FCtMetaTable := ATable;
    FLastTbJson := '';
  end;
  FReadOnlyMode := bReadOnlyMode;
  //InitByTableEx;
  TimerScDelayCmd.Enabled := False;
  TimerScDelayCmd.Tag := 4;
  TimerScDelayCmd.Enabled := True;
end;

procedure TFrameUIPreview.InitByTableEx;
var
  S, opt: string;
begin
  if FCtMetaTable = nil then
    Exit;
  if FRefreshUpdateing then
    Exit;
  if FIniting then
    Exit;
  S := FCtMetaTable.JsonStr;
  if S = FLastTbJson then
    Exit;
  FIniting := True;
  try
    Self.FFrameUIPrvSheet.Init;
    if SheetContainer <> nil then
      if FFrameUIPrvSheet.Parent = nil then
      begin
        FFrameUIPrvSheet.BorderStyle := bsNone;
        FFrameUIPrvSheet.Parent := SheetContainer;
        FFrameUIPrvSheet.Align := alClient;
      end;
    if Self.FReadOnlyMode then
    begin
      StringGridData.Options := StringGridData.Options - [goColSizing, goColMoving];
      FSheetViewControls.LabelDraggable := False;
      FSheetEditControls.LabelDraggable := False;
    end
    else
    begin
      StringGridData.Options := StringGridData.Options + [goColSizing, goColMoving];
      FSheetViewControls.LabelDraggable := True;
      FSheetEditControls.LabelDraggable := True;
    end;


    FLastTbJson := S;
    if FLastTableName <> FCtMetaTable.Name then
      FCurDemoDataIndex := Random(20);
    FLastTableName := FCtMetaTable.Name;

    if FSkipGridRefreshTick <> 0 then
      if Abs(GetTickCount64 - FSkipGridRefreshTick) > 800 then
        FSkipGridRefreshTick := 0;
    if FSkipGridRefreshTick = 0 then
    begin
      opt := '';
      if FShowHiddenFields then
        opt := opt + '[ShowHiddenFields]';
      GenGridDemoData(FCtMetaTable, StringGridData, HeaderControlSummary, FGridPageSize, '', opt);
      PanelSummary.Visible := HeaderControlSummary.Sections.Count > 0;
    end;
    _OnGridUIScrolled(nil);

    RefreshDesignNotes;

    ListBoxFieldCategory.ItemIndex := FFocusedCatIndex;
    RefreshCatFields;

    FSkipGridRefreshTick := 0;

    CreateDataCard(FCtMetaTable, FDataCardControls, '');

    CreateControlList(FCtMetaTable, FDataQueryControls, '[QUERY_FIELDS]');
    CreateControlList(FCtMetaTable, FSheetViewControls, '[VIEW_MODE]');
    CreateControlList(FCtMetaTable, FSheetEditControls, '');

    CheckCardGridCtrls();

    PanelDataQuery.Tag := FDataQueryControls.Count;
    if FDataQueryControls.Count = 0 then
      PanelDataQuery.Visible := False
    else if FShowSearchOnInit then
    begin
      if not PanelDataQuery.Visible then
      begin            
        actQuery.Execute;
      end;
    end;
    RefreshUIShape;

    if FFrameUIPrvSheet.Visible then
      FFrameUIPrvSheet.ReCalSizes;

    Self.FrameResize(nil);
    CheckSheetActs;
    PanelDataGridCard.Visible := True;
  finally
    FIniting := False;
  end;
end;

procedure TFrameUIPreview.HideProps;
begin
  if FFrameUIPrvSheet.Visible then
  begin
    FFrameUIPrvSheet.OnHide := nil;
    FFrameUIPrvSheet.Hide;
    FFrameUIPrvSheet.OnHide := _OnSheetVisChange;   
    if Assigned(SheetContainer) then
      SheetContainer.Visible := False;
    if Assigned(OnSheetVisibleChanged) then
      OnSheetVisibleChanged(Self);
  end;
  FLastTbJson := '';
end;


procedure TFrameUIPreview.CreateDataCard(ATable: TCtMetaTable;
  AScControls: TDmlScriptControlList; AOpt: string);

  function GetDisplayableFieldDesc(skipCount, len, row: integer): string;
  var
    I, J, C, foundCount: integer;
    fds: TCtMetaFieldList;
    fd: TCtMetaField;
  begin
    Result := '';
    C := 0;
    foundCount := 0;
    fds := ATable.MetaFields;
    for I := 0 to fds.Count - 1 do
      fds.Items[I].CalValue := 0;
    for J := 1 to 6 do
    begin
      {
        分N次查找：
        1.查找名称
        2.查找标题
        3.查找摘要
        4.查找列表
        5.查找表单
        6.查找其它可显示字段
      }
      for I := 0 to fds.Count - 1 do
      begin
        fd := fds.Items[I];
        if fd.CalValue = 1 then
          Continue;
        if not fd.CanDisplay('') then
          Continue;
        if (J = 1) and (fd.PossibleKeyFieldType <> cfktName) then
          Continue;
        if (J = 2) and (fd.PossibleKeyFieldType <> cfktCaption) then
          if not fd.CanDisplay('title') then
            Continue;
        if (J = 3) then
          if (fd.Visibility <> 1) then
            if not fd.CanDisplay('card') then
              if not fd.CanDisplay('subtitle') then
                Continue;
        if (J = 4) then
        begin
          if (fd.Visibility <> 2) then
            Continue;
          if not fd.CanDisplay('grid') then
            Continue;
          if skipCount >= 3 then
            Continue;
        end;
        if (J = 5) then
        begin
          if (fd.Visibility <> 3) then
            Continue;
          if skipCount >= 3 then
            Continue;
        end;
        if (J = 6) then
        begin
          if skipCount >= 3 then
            Continue;
        end;

        fd.CalValue := 1;
        Inc(foundCount);
        if foundCount <= skipCount then
          Continue;
        if Result <> '' then
          Result := Result + ' ';
        if fd.DataType in [cfdtInteger, cfdtFloat, cfdtBool] then
          Result := Result + fd.GetLabelText + ':';
        Result := Result + fd.GenDemoData(row, '[REMOVE_NULLS]', nil);
        Inc(C);
        if C >= len then
          Break;
      end;

      if C >= len then
        Break;
    end;
  end;

var
  Y, RC: integer;
  S, T, title, subtitle, describ: string;
  ss: TStringList;
begin
  ss := TStringList.Create;
  try
    RC := FGridPageSize; //最多生成50个卡片
    if RC > 50 then
      RC := 50;
    for Y := 0 to RC - 1 do
    begin
      title := GetDisplayableFieldDesc(0, 1, Y);
      subtitle := GetDisplayableFieldDesc(1, 2, Y);
      describ := GetDisplayableFieldDesc(3, 4, Y);

      S := title + '#10' + subtitle + '#10' + describ;
      T := 'Control="Panel_Card";Name="Card' + IntToStr(Y) + '";Items="' + S +
        '";Params=""';
      ss.Add(T);
    end;
    S := ss.Text;
    if AScControls.LastTextDesc = S then
      Exit;
    AScControls.ClearControls;
    AScControls.TextDesc := S;
  finally
    ss.Free;
  end;
end;

procedure TFrameUIPreview.CreateControlList(ATable: TCtMetaTable;
  AScControls: TDmlScriptControlList; AOpt: string);

  function GetEditorItemList(fd: TCtMetaField): string;
  var
    I: integer;
    ss: TStringList;
  begin
    Result := fd.GetDemoItemList;
    ss := TStringList.Create;
    try
      ss.Text := Result;
      for I := 0 to ss.Count - 1 do
        ss[I] := SccStrEncode(ss[I]);
      Result := ss.Text;
    finally
      ss.Free;
    end;
    Result := StringReplace(Result, #13#10, ',', [rfReplaceAll]);
    Result := StringReplace(Result, #10, ',', [rfReplaceAll]);
  end;

  function GetQueryEditorType(tp: string): string;
  const
    qedts= 'ButtonEdit' + #13#10 +
          'ComboBox' + #13#10 +
          'ListSelect=ComboBox' + #13#10 +
          'TagEdit=ComboBox' + #13#10 +
          'RadioBox=ComboBox' + #13#10 +
          'ButtonGroup=ComboBox' + #13#10 +
          'CheckBox=ComboBox' + #13#10 +
          'Switch=ComboBox' + #13#10 +
          'SpinEdit' + #13#10 +
          'NumberEdit' + #13#10 +
          'CalcEdit' + #13#10 +
          'CurrencyEdit' + #13#10 +
          'DateEdit=DateRange' + #13#10 +
          'DateRange' + #13#10 +
          'TimeEdit' + #13#10 +
          'DateTime' + #13#10 +
          'MonthSelect=ComboBox' + #13#10 +
          'QuarterSelect=ComboBox' + #13#10 +
          'YearSelect=ComboBox' + #13#10 +
          'ColorSelect=ComboBox';
  var
    ss: TStringList;
    S, T: string;
    I, po: Integer;
  begin
    Result := '';

    ss:= TStringList.create;
    try
      ss.Text := qedts;
      for I:=0 to ss.Count - 1 do
      begin
        S:=ss[I];
        po := Pos('=', S);
        if po>0 then
          T := Copy(S, 1, po-1)
        else
          T := S;
        if T=tp then
        begin
          if po>0 then
            Result := Copy(S, po+1, Length(S))
          else
            Result := T;
          Exit;
        end;
      end;
    finally
      ss.Free;
    end;
  end;

  function GetEditorCls(fd: TCtMetaField; var sCap, sVal, sItems, sPar: string): string;
  begin
    Result := fd.PossibleEditorType;
    if Result = '' then
      Result := 'TextEdit';    
    if Pos('[QUERY_FIELDS]', AOpt) > 0 then
    begin
      Result := GetQueryEditorType(Result); 
      if Result='' then
        Result := 'TextEdit';
    end;

    if Result = 'ComboBox' then
    begin
      sItems := GetEditorItemList(fd);
    end
    else if Result = 'RadioBox' then
    begin
      Result := 'Panel_RadioBoxes';
      sItems := GetEditorItemList(fd);
    end
    else if Result = 'CheckBox' then
    begin
      if (Trim(fd.DropDownItems) <> '') or (Trim(fd.DropDownSQL) <> '') then
      begin
        Result := 'Panel_CheckBoxes';
        sItems := GetEditorItemList(fd);
      end
      else
      begin
        sItems := sCap;
        sCap := ' ';
      end;
    end     
    else if Result = 'Button' then
    begin
      if (Trim(fd.DropDownItems) <> '') or (Trim(fd.DropDownSQL) <> '') then
      begin
        Result := 'Panel_Buttons';
        sItems := GetEditorItemList(fd);
      end;
    end
    else if Result = 'ListSelect' then
    begin
      Result := 'Panel_ToggleBoxes';
      sItems := GetEditorItemList(fd);
    end
    else if Result = 'TagEdit' then
    begin
      Result := 'Panel_ToggleBoxes';
      sItems := GetEditorItemList(fd);
      sPar := sPar + '[SHOW_CUSTOM_EDIT]';
    end
    else if Result = 'ButtonGroup' then
    begin
      Result := 'Panel_ButtonGroup';
      sItems := GetEditorItemList(fd);
    end
    else if Result = 'RichText' then
    begin
      Result := 'Memo';
      sPar := sPar + '[RichText]';
    end
    else if Result = 'Password' then
    begin
      Result := 'Edit';
      sPar := sPar + '[PASSWORD]';
    end
    else if Result = 'DataGrid' then
    begin
      sPar := sPar + '[TABLE:' + fd.RelateTable + ']';
      sPar := sPar + '[FIELDS:' + fd.RelateField + ']';
    end         
    else if Result = 'KeyValueList' then
    begin
      sVal := fd.GetRelateTableDemoJson(FCurDemoDataIndex, '[LABELTEXT]');
    end
    else if Result = 'GUID' then
    begin
      Result := 'ButtonEdit';
      sPar := sPar + '[GUID]';
    end;

    if fd.PossibleTextAlign = cftaRight then
    begin
      sPar := sPar + '[TextAlignRight]';
    end
    else if fd.PossibleTextAlign = cftaCenter then
    begin
      sPar := sPar + '[TextAlignCenter]';
    end;
  end;

  function CreateControlStr(fd: TCtMetaField): string;
  var
    sCap, sCls, sVal, sItems, sHint, sExplain, sPar: string;
  begin
    Result := '';
    sCap := fd.GetLabelText;
    sVal := '';
    if Pos('[QUERY_FIELDS]', AOpt) = 0 then
      if Pos('[NEW_MODE]', AOpt) = 0 then
        sVal := fd.GenDemoData(FCurDemoDataIndex, '[REMOVE_NULLS]', nil);
    sItems := '';
    sPar := '';
    sHint := '';
    sExplain := '';
    sCls := GetEditorCls(fd, sCap, sVal, sItems, sPar);
    if Pos('[QUERY_FIELDS]', AOpt) = 0 then
    begin
      sHint := fd.Hint;
      sExplain := fd.ExplainText;
    end;

    if Pos('[QUERY_FIELDS]', AOpt) = 0 then
    begin
      if fd.EditorReadOnly then
        sPar := sPar + '[READONLY]'
      else if Pos('[VIEW_MODE]', AOpt) > 0 then
        sPar := sPar + '[READONLY]';
      if not fd.EditorEnabled then
        sPar := sPar + '[DISABLED]';
      if fd.IsRequired then
        sPar := sPar + '[REQUIRED]';
    end;
    if (sCls = 'Memo') or (sCls = 'DataGrid') or (sCls = 'UploadFile') then
      sPar := sPar + '[FULLWIDTH]';

    Result := 'Control="' + sCls + '";';
    Result := Result + 'Name="' + fd.Name + '";';
    Result := Result + 'Caption="' + SccStrEncode(sCap) + '";';
    if sVal <> '' then
      Result := Result + 'Value="' + SccStrEncode(sVal) + '";';
    if sHint <> '' then
      Result := Result + 'Hint="' + SccStrEncode(sHint) + '";';
    if sExplain <> '' then
      Result := Result + 'Explain="' + SccStrEncode(sExplain) + '";';
    if sItems <> '' then
      Result := Result + 'Items="' + sItems + '";';
    if sPar <> '' then
      Result := Result + 'Params="' + sPar + '"';
  end;

var
  I: integer;
  fds: TCtMetaFieldList;
  fd: TCtMetaField;
  S, T, vm, btns: string;
  ss: TStringList;
begin
  if ATable = nil then
  begin
    AScControls.ClearControls;
    AScControls.TextDesc := '';
    Exit;
  end;
  vm := '';
  if Pos('[QUERY_FIELDS]', AOpt) > 0 then
    vm := ''
  else
    vm := 'sheet';

  if Pos('[QUERY_FIELDS]', AOpt) > 0 then
    btns := 'Control="Panel_Buttons";Name="btnsQuery";Caption=" ";Items="' +
      srCapSearch + ',' + srCapReset + '"'
  {else if Pos('[VIEW_MODE]', AOpt) > 0 then
    btns := 'Control="Panel_Buttons";Name="_UIPreview_OperPanel_View";Caption=" ";Items="'
      +
      srCapNew + ',' + srCapModify + ',' + srCapDelete + ',' + srCapClose+ '"'
  else
    btns := 'Control="Panel_Buttons";Name="_UIPreview_OperPanel_Edit";Caption=" ";Items="'
      +
      srCapOk + ',' + srCapCancel + '"';}
  else
    btns := '';
  btns := btns + ';Params="[NO_FOCUS][NO_DRAG][FULLWIDTH]"';

  fds := ATable.MetaFields;
  ss := TStringList.Create;
  try
    if Pos('[QUERY_FIELDS]', AOpt) = 0 then
      ;//ss.Add('Control="Label";Caption="' + ATable.UIDisplayName + '";Params="[FULLWIDTH][LARGE][NO_FOCUS][NO_DRAG]"');
    for I := 0 to fds.Count - 1 do
    begin
      fd := fds.Items[I];
      if not fd.CanDisplay(vm) then
        Continue;
      if Pos('[QUERY_FIELDS]', AOpt) > 0 then
      begin
        if not fd.Queryable then
          Continue;
      end
      else if Pos('[VIEW_MODE]', AOpt) > 0 then
      begin
        if fd.HideOnView then
          Continue;
      end
      else
      begin
        if fd.HideOnEdit then
          Continue;
      end;
      S := CreateControlStr(fd);
      if S <> '' then
        ss.Add(S);
    end;
    if Pos('[QUERY_FIELDS]', AOpt) > 0 then
      if ss.Count = 0 then
      begin
        for I := 0 to fds.Count - 1 do
        begin
          fd := fds.Items[I];
          if not fd.CanDisplay(vm) then
            Continue;
          S := CreateControlStr(fd);
          if S <> '' then
            ss.Add(S);
          if ss.Count >= 7 then
            Break;
        end;
      end;
    if ss.Count > 0 then
    begin       
      if Pos('[QUERY_FIELDS]', AOpt) > 0 then
        ss.Add(btns);
    end;
    S := ss.Text;
    if AScControls.LastTextDesc = S then
      Exit;
    if (Pos('[ResetValuesOnly]', AOpt) > 0) then
    begin
      AScControls.ResetCtrlValues(S);
    end
    else
    begin
      T := AScControls.FocusedItemName;
      AScControls.TextDesc := S;
      AScControls.FocusedItemName := T;
    end;
  finally
    ss.Free;
  end;
end;

procedure TFrameUIPreview.RefreshUI;
begin
  FSkipGridRefreshTick := 0;
  FSkipCatRefreshTick := 0;
  FSkipDesNotesRefreshTick := 0;
  InitByTable(Self.FCtMetaTable, Self.ReadOnlyMode);
end;

procedure TFrameUIPreview.SetUITypes(Shap, Oper: Integer);
begin         
  if FUIShapeType=Shap then
    if FUIOperateType = Oper then
      Exit;
  //UI类型：1PC 2PAD 3PHONE
  FUIShapeType := Shap;
  //操作类型：1列表 2查看 3修改 4新增
  FUIOperateType := Oper;
  RefreshUIShape;
end;


end.
