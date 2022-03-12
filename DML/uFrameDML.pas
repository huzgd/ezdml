unit uFrameDML;

{$MODE Delphi}
{$WARN 5057 off : Local variable "$1" does not seem to be initialized}
interface

{.$DEFINE USE_ORACLE}

uses
  LCLIntf, LCLType, LMessages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DMLObjs, DMLGraph, ComCtrls, ActnList, ImgList,
  Menus, StdCtrls, Dialogs, uWaitWnd,
  {uDMLTableProp, uDMLObjProp, }uColorStyles, Grids, ValEdit, Buttons, ExtCtrls
{$IFDEF USE_ORACLE}, Oracle, DMLOracleDb, Buttons, ExtCtrls, Grids, ValEdit{$ENDIF};

type

  { TFrameDML }

  TFrameDML = class(TFrame)
    actFullScreen: TAction;
    actFullTableView: TAction;
    actBatCopyTbName: TAction;
    actBatCopyFieldName: TAction;
    actBatCopyExcelText: TAction;
    actBatCopyDescText: TAction;
    actBatCopyFieldNType: TAction;
    actBatCopyCreateSQL: TAction;
    actBatCopySelectSQL: TAction;
    actBatCopyInsertSQL: TAction;
    actBatCopyUpdateSQL: TAction;
    actBatCopyFieldNameComma: TAction;
    actBatCopyJoinSelectSQL: TAction;
    actPasteAsCopy: TAction;
    actRun: TAction;
    btnShowInGraph: TBitBtn;
    ImageList2: TImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MN_PasteAsCopy: TMenuItem;
    MNAddLink1: TMenuItem;
    MN_GenSql: TMenuItem;
    MN_BatCopyFieldNType: TMenuItem;
    MN_BatCopyFieldName: TMenuItem;
    MN_BatCopyDescText: TMenuItem;
    MN_BatCopyExcelText: TMenuItem;
    MN_BatCopyTbName: TMenuItem;
    MN_BatchCopy: TMenuItem;
    MN_CheckwithMyDict: TMenuItem;
    MenuItem11: TMenuItem;
    MN_CommentstoLogicName: TMenuItem;
    MN_NametoLogicName: TMenuItem;
    MN_Capitalize: TMenuItem;
    MN_AutoCapitalize: TMenuItem;
    MN_AllUpperCase: TMenuItem;
    MN_AllLowerCase: TMenuItem;
    MN_CamelCasetoUnderline: TMenuItem;
    MN_UnderlinetoCamelCase: TMenuItem;
    MN_ConvertChinesetoPinYin: TMenuItem;
    StatusBar1: TStatusBar;
    ActionList2: TActionList;
    actPan: TAction;
    actZoomIn: TAction;
    actZoomOut: TAction;
    actAutoA: TAction;
    actBestFit: TAction;
    actRestore: TAction;
    actCopy: TAction;
    actFileSave: TAction;
    actFileNew: TAction;
    actFileOpen: TAction;
    actRectSelect: TAction;
    PopupMenu1: TPopupMenu;
    N35: TMenuItem;
    H2: TMenuItem;
    TimerDelayCmd: TTimer;
    ToolButtonRun: TToolButton;
    ToolButtonFullScrn: TToolButton;
    Z2: TMenuItem;
    X2: TMenuItem;
    N22: TMenuItem;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButtonDML03: TToolButton;
    ToolButtonDML18: TToolButton;
    ToolButtonDML19: TToolButton;
    ToolButtonDML20: TToolButton;
    ToolButtonDML21: TToolButton;
    ToolButtonDML22: TToolButton;
    ToolButtonDML23: TToolButton;
    ToolButtonDMLsp4: TToolButton;
    ToolButtonDML17: TToolButton;
    ToolButtonDMLsp6: TToolButton;
    ToolButtonDML01: TToolButton;
    ToolButtonDML02: TToolButton;
    ToolButtonDML07: TToolButton;
    actTest: TAction;
    actNewObj: TAction;
    actDeleteObj: TAction;
    ToolButtonDMLsp2: TToolButton;
    ToolButtonDML14: TToolButton;
    ToolButtonDML12: TToolButton;
    actAddLink: TAction;
    ToolButtonDML16: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    actImportDB: TAction;
    ToolButtonDMLSp1: TToolButton;
    ToolButtonDML09: TToolButton;
    ToolButtonDMLsp5: TToolButton;
    actRearrange: TAction;
    ToolButtonDML04: TToolButton;
    actNewText: TAction;
    ToolButtonDML15: TToolButton;
    actDMLObjProp: TAction;
    ToolButtonDML26: TToolButton;
    actShowFieldType: TAction;
    actCheckFKLinks: TAction;
    ToolButtonDML05: TToolButton;
    N1: TMenuItem;
    N2: TMenuItem;
    actColorStyles: TAction;
    ToolButtonDML25: TToolButton;
    actRefresh: TAction;
    N4: TMenuItem;
    ToolButtonDML24: TToolButton;
    ToolButtonDML10: TToolButton;
    actDBGenSql: TAction;
    splProperty: TSplitter;
    pnlProperty: TPanel;
    vleProperty: TValueListEditor;
    ToolButtonDML11: TToolButton;
    ToolButtonDMLsp3: TToolButton;
    sptHide: TSpeedButton;
    actShowHideProps: TAction;
    actNewFlowObj: TAction;
    ToolButtonDML13: TToolButton;
    actShowPhyView: TAction;
    actPaste: TAction;
    N5: TMenuItem;
    N6: TMenuItem;
    actCopyImage: TAction;
    N7: TMenuItem;
    actExportXls: TAction;
    ExporttoExcel1: TMenuItem;
    actSelectAll: TAction;
    Selectall1: TMenuItem;
    actFindObject: TAction;
    Find1: TMenuItem;
    ToolButtonFindObjs: TToolButton;
    actBriefMode: TAction;
    ToolButtonDML06: TToolButton;
    actBatchOps: TAction;
    Batchoperations1: TMenuItem;
    actSetEntityColor: TAction;
    MNSetEntityColor1: TMenuItem;
    ColorDialog1: TColorDialog;
    MNP_Newtable1: TMenuItem;
    MNP_Addtext1: TMenuItem;
    MNP_Delete1: TMenuItem;
    actResetObjLinks: TAction;
    resetobjectlinks1: TMenuItem;
    actCopyDmlText: TAction;
    MN_CopyText1: TMenuItem;
    actCamelCaseToUnderline: TAction;
    actUnderlineToCamelCase: TAction;
    actCapUppercase: TAction;
    actCapLowercase: TAction;
    actAutoCapitalize: TAction;
    actExchangeDispComm: TAction;
    actExchangeNameDisp: TAction;
    actCheckWithMyDict: TAction;
    actConvertChnToPy: TAction;  
    procedure actAutoCapitalizeExecute(Sender: TObject);
    procedure actBatCopyCreateSQLExecute(Sender: TObject);
    procedure actBatCopyDescTextExecute(Sender: TObject);
    procedure actBatCopyExcelTextExecute(Sender: TObject);
    procedure actBatCopyFieldNameCommaExecute(Sender: TObject);
    procedure actBatCopyFieldNameExecute(Sender: TObject);
    procedure actBatCopyFieldNTypeExecute(Sender: TObject);
    procedure actBatCopyInsertSQLExecute(Sender: TObject);
    procedure actBatCopyJoinSelectSQLExecute(Sender: TObject);
    procedure actBatCopySelectSQLExecute(Sender: TObject);
    procedure actBatCopyTbNameExecute(Sender: TObject);
    procedure actBatCopyUpdateSQLExecute(Sender: TObject);
    procedure actCamelCaseToUnderlineExecute(Sender: TObject);
    procedure actCapLowercaseExecute(Sender: TObject);
    procedure actCapUppercaseExecute(Sender: TObject);
    procedure actCheckWithMyDictExecute(Sender: TObject);
    procedure actConvertChnToPyExecute(Sender: TObject);
    procedure actExchangeDispCommExecute(Sender: TObject);
    procedure actExchangeNameDispExecute(Sender: TObject);
    procedure actFullTableViewExecute(Sender: TObject);
    procedure actPasteAsCopyExecute(Sender: TObject);
    procedure actResetObjLinksExecute(Sender: TObject);
    procedure actBriefModeExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actUnderlineToCamelCaseExecute(Sender: TObject);
    procedure btnShowInGraphClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actExportXlsExecute(Sender: TObject);
    procedure actCopyImageExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actRectSelectExecute(Sender: TObject);
    procedure actPanExecute(Sender: TObject);
    procedure actZoomInExecute(Sender: TObject);
    procedure actZoomOutExecute(Sender: TObject);
    procedure actAutoAExecute(Sender: TObject);
    procedure actBestFitExecute(Sender: TObject);
    procedure actRestoreExecute(Sender: TObject);
    procedure actFileNewExecute(Sender: TObject);
    procedure actFileOpenExecute(Sender: TObject);
    procedure actDeleteObjExecute(Sender: TObject);
    procedure actAddLinkExecute(Sender: TObject);
    procedure actNewObjExecute(Sender: TObject);
    procedure actFileSaveExecute(Sender: TObject);
    procedure actImportDBExecute(Sender: TObject);
    procedure actRearrangeExecute(Sender: TObject);
    procedure actNewTextExecute(Sender: TObject);
    procedure actDMLObjPropExecute(Sender: TObject);
    procedure ActionList2Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure actShowFieldTypeExecute(Sender: TObject);
    procedure actCheckFKLinksExecute(Sender: TObject);
    procedure actColorStylesExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actDBGenSqlExecute(Sender: TObject);
    procedure TimerDelayCmdTimer(Sender: TObject);
    procedure vlePropertySetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure vlePropertyValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: string);
    procedure vlePropertyGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure sptHideClick(Sender: TObject);
    procedure vlePropertyEditButtonClick(Sender: TObject);
    procedure vlePropertyDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure actShowHidePropsExecute(Sender: TObject);
    procedure actNewFlowObjExecute(Sender: TObject);
    procedure actShowPhyViewExecute(Sender: TObject);
    procedure actBatchOpsExecute(Sender: TObject);
    procedure actSetEntityColorExecute(Sender: TObject);
    procedure actCopyDmlTextExecute(Sender: TObject);

  public
    procedure DMLGraphMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DMLGraphDblClick(Sender: TObject);
    procedure DMLGraphKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DMLGraphViewChanged(Sender: TObject);
    procedure DMLGraphSelectObj(Sender: TObject);
    procedure _OnDMLObjProgress(Sender: TObject; const Prompt: string;
      Cur, All: Integer; var bContinue: Boolean);
    procedure _OnLinkObjSelected(Sender: TObject; Obj1, Obj2: TDMLObj);
  protected
    Validate: Integer; //是否为有效值
    validateOld: string; //原始值
    DMLProperty: TObject; //记录属性
    procedure SetDMLModified;
    procedure SetPropertyObj(vObj: TObject);
    procedure InitProperty();  
    procedure InitCustColorDialog;
  public
    { Public declarations }

    DMLGraph: TDMLGraph;
    //FfrmDMLTableProp: TfrmDMLTableProp;
    //FfrmDMLObjProp: TfrmDMLObjProp;
    FfrmColorStyles: TfrmColorStyles;
    FfrmDMLImport: TForm;
    FfrmDMLGenSQL: TForm;
    FWaitWnd: TfrmWaitWnd;
    DMLFileName: string;
{$IFDEF USE_ORACLE}
    OracleSession: TOracleSession;
    DMLOracleDb: TDMLOracleDb;
    procedure SetSession(ASession: TOracleSession);
{$ENDIF}
  public
    //Act: 1-add 2-remove
    Proc_OnObjAddOrRemove: function(Obj: TDMLObj; Act: Integer): Boolean of object;
    Proc_OnLinkObj: function(Obj1, Obj2: TDMLObj): Integer of object; //-1无 0line 1FK one2many 2FK_one2one 3ArrowLine 4Line
    Porc_OnStatusMsg: procedure(Msg: string; tp: Integer) of object;      
    Proc_DoCapitalize: procedure(sType: string) of object;
    Proc_DoBatCopy: procedure(sType: string) of object;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowTbProp(obj: TDMLTableObj);
    procedure ShowObjProp(obj: TDMLObj);
    procedure Checkacts;
    procedure CheckLinkLines; //当表的大小有变化时，检查连线是否需要延长或缩短
    //function SaveWmfImage(fn: String): String; //fn为空时保存到剪贴板，为(BASE64TEXT)时返回base64编码
    function SaveDmlImage(fn: string): string; //fn可为bmp jpg png wmf文件，去掉扩展名后为空时保存png到剪贴板，为(BASE64TEXT)时返回png的base64编码
    procedure ExportToExcel(fn: string);

    procedure LoadFromFile(fn: string);
    procedure SaveToFile(fn: string);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);

    procedure SetStatusBarMsg(msg: string; tp: Integer = -1);
    procedure ShowDMLInfoStatusMsg;

    procedure DelayCmd(cmd: Integer); 
    procedure DoCapitalizeProc(sType: string);     
    procedure DoBatCopyProc(sType: string);
  end;

const
  c_boolitems = 'True'#13#10'False';
  c_Typeitems = '未知'#13#10'主键'#13#10'外键'#13#10'字符串'#13#10'整数'#13#10'小整数'#13#10'浮点数'#13#10'日期'#13#10'真假'#13#10'二进制数据'#13#10'对象'#13#10'计算字段'#13#10'其它';
  c_FieldTypeExItems = '计算[pkg_celltree.getusername(工作人员编号)]'#13#10'对象[MDSYS.SDO_GEOMETRY]'#13#10'其它[VARCHAR2(500)]'#13#10'其它[VARCHAR2(1000)]'#13#10'其它[NUMBER(4)]'#13#10'其它[CLOB]';
  c_EditorItems = '普通'#13#10'按钮'#13#10'下拉框[A,B,C]'#13#10'单选钮[A,B,C]'#13#10'核选钮'#13#10'微调钮';
  c_LinkTypeItems = '直线'#13#10'外键'#13#10'箭头';
implementation

uses
  ImgView, PvtInput, {uDMLImportDB, }WindowFuncs, dmlstrs, ClipBrd,
  XLSfile, base64, DmlScriptPublic;

{$R *.lfm}

{ TFrameDML }

constructor TFrameDML.Create(AOwner: TComponent);
begin
  inherited;
  sptHide.Parent := vleProperty;
  InitProperty;
  Validate := -1;
  validateOld := '';

  DMLGraph := TDMLGraph.Create(Self);
  with DMLGraph do
  begin
    MouseAction := vaRectSelect;
    Parent := Self;
    Align := alClient;
    Images := ImageList2;
    ImgPopupMenu := PopupMenu1;
    OnMouseMove := DMLGraphMouseMove;
    OnDblClick := DMLGraphDblClick;
    OnKeyDown := DMLGraphKeyDown;
    OnViewChanged := DMLGraphViewChanged;
    OnSelectObj := DMLGraphSelectObj;
    OnLinkObjSelected := _OnLinkObjSelected;
    DMLObjs.OnObjProgress := _OnDMLObjProgress;
  end;
  DMLGraph.DMLDrawer.ShowPhyFieldName := 0;
  if Screen.Width > DMLGraph.DMLDrawer.DrawerWidth then
  begin
    DMLGraph.DMLDrawer.DrawerWidth := Screen.Width;
    if DMLGraph.DMLDrawer.DrawerWidth > 1500 then
      DMLGraph.DMLDrawer.DrawerWidth := 1500;
    DMLGraph.DMLDrawer.DrawerHeight := Screen.Width * 3 div 2;
  end;
  InitCustColorDialog;
end;

destructor TFrameDML.Destroy;
begin
  inherited;
end;

procedure TFrameDML.DMLGraphDblClick(Sender: TObject);
var
  pt: TPoint;
  xx, yy: Double;
  bSel: Boolean;
begin
  bSel := (DMLGraph.DMLObjs.SelectedCount > 0);
  if GetCursorPos(pt) then
  begin
    pt := DMLGraph.ScreenToClient(pt);
    xx := DMLGraph.ScreenToImageX(pt.X);
    yy := DMLGraph.ScreenToImageY(pt.Y);
    if DMLGraph.DMLObjs.FindItemAt(xx, yy) >= 0 then
      bSel := True;
    if bSel and (DMLGraph.ViewScale < 0.33) then
    begin
      if (GetKeyState(VK_CONTROL) and $80) = 0 then
        bSel := False;
    end;
    if (GetKeyState(VK_MENU) and $80) <> 0 then
      bSel := False;
    if bSel then
      DelayCmd(1)
    else
    begin
      if DMLGraph.IsBestFitScale then
      begin
        DMLGraph.SetViewXYSc(xx - DMLGraph.DMLDrawer.DrawerWidth / 2, yy - DMLGraph.DMLDrawer.DrawerHeight / 2, Forms.Screen.PixelsPerInch/96);
      end
      else
        DMLGraph.BestFit;
    end;
  end
  else
    DelayCmd(1);
end;

procedure TFrameDML.DMLGraphMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  {SetStatusBarMsg(Format('%d, %d', [
    Round(DMLGraph.ScreenToImageX(X)),
      Round(DMLGraph.ScreenToImageY(Y))]),2);
      }
end;

procedure TFrameDML.ShowTbProp(obj: TDMLTableObj);
begin
  if not Assigned(obj) then
    Exit;
  {if not Assigned(FfrmDMLTableProp) then
    FfrmDMLTableProp := TfrmDMLTableProp.Create(Self);
  FfrmDMLTableProp.LoadFromDMLTable(obj);
  if FfrmDMLTableProp.ShowModal = mrOk then
  begin
    SetDMLModified;
    DMLGraph.Refresh;
  end;}
end;

procedure TFrameDML.actRectSelectExecute(Sender: TObject);
begin
  DMLGraph.MouseAction := vaRectSelect;
  DMLGraph.Repaint;
end;

procedure TFrameDML.actPanExecute(Sender: TObject);
begin
  DMLGraph.MouseAction := vaPan;
end;

procedure TFrameDML.actPasteExecute(Sender: TObject);
begin
  ;
end;

procedure TFrameDML.actZoomInExecute(Sender: TObject);
begin
  with DMLGraph do
    ViewScale := GetStepScale(ViewScale * ScaleStep, 1);
  if (GetKeyState(VK_CONTROL) and $80) <> 0 then
  begin
    DMLGraph.MouseAction := vaZoomIn;
    actZoomIn.Checked := True;
  end;
end;

procedure TFrameDML.actZoomOutExecute(Sender: TObject);
begin                   
  with DMLGraph do
    ViewScale := GetStepScale(ViewScale / ScaleStep, -1);  
  if (GetKeyState(VK_CONTROL) and $80) <> 0 then   
  begin
    DMLGraph.MouseAction := vaZoomOut;  
    actZoomOut.Checked := True;
  end;
end;

procedure TFrameDML.actAutoAExecute(Sender: TObject);
begin
  DMLGraph.MouseAction := vaAuto;
end;

procedure TFrameDML.actBatchOpsExecute(Sender: TObject);
begin
//
end;

procedure TFrameDML.actBestFitExecute(Sender: TObject);
begin           
  if not DMLGraph.CanFocus then
    Exit;
  if DMLGraph.IsBestFitScale then
    DMLGraph.Reset
  else
    DMLGraph.BestFit;
end;

procedure TFrameDML.actBriefModeExecute(Sender: TObject);
var
  I: Integer;
  bNeedConfirm: Boolean;
begin
  if not DMLGraph.CanFocus then
    Exit;
  if not DMLGraph.DMLObjs.BriefMode then
  begin
    bNeedConfirm := False;
    with DMLGraph.DMLObjs do
      for I := 0 to Count - 1 do
        if Items[I] is TDMLLinkObj then
          if TDMLLinkObj(Items[I]).IsDefPosChanged then
          begin
            //bNeedConfirm := True;
            Break;
          end;
    if bNeedConfirm then
      if Application.MessageBox(PChar(srConfirmDMLBriefMode),
        PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
        Exit;
  end;
  DMLGraph.DMLObjs.BriefMode := not DMLGraph.DMLObjs.BriefMode;
  DMLGraph.Refresh;
end;

procedure TFrameDML.actRunExecute(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD},  3, 0);
end;

procedure TFrameDML.actUnderlineToCamelCaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('UnderlineToCamelCase');
end;

procedure TFrameDML.btnShowInGraphClick(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 2, 0);
end;

procedure TFrameDML.actResetObjLinksExecute(Sender: TObject);
var
  C, I, J, oLV: Integer;
  ls: TList;
begin
  if not DMLGraph.CanFocus then
    Exit;
  C := DMLGraph.DMLObjs.SelectedCount;
  if C = 0 then
    Exit;
  oLV := DMLGraph.DMLObjs.DMLDrawer.FLinkOptimizeLevel;
  DMLGraph.DMLObjs.DMLDrawer.FLinkOptimizeLevel := 9;
  Screen.Cursor := crAppStart;
  try
    with DMLGraph.DMLObjs do
      for I := Count - 1 downto 0 do
        Items[I].UserVal := 1;
    with DMLGraph.DMLObjs do
      for I := Count - 1 downto 0 do
        if Items[I].Selected then
        begin
          if Items[I] is TDMLEntityObj then
          begin          
            Items[I].BLeft := 0;
            Items[I].BTop := 0;
            ls := TDMLEntityObj(Items[I]).Links;
            for J := 0 to ls.Count - 1 do
            begin
              if TDMLLinkObj(ls.Items[J]).UserVal = 1 then
              begin
                TDMLLinkObj(ls.Items[J]).ResetPositionEx;
                TDMLLinkObj(ls.Items[J]).UserVal := 2;
              end;
            end;
          end
          else if Items[I] is TDMLLinkObj then
          begin
            if Items[I].UserVal = 1 then
            begin
              TDMLLinkObj(Items[I]).ResetPositionEx;
              Items[I].UserVal := 2;
            end;
          end;
        end;
  finally
    Screen.Cursor := crDefault;
    DMLGraph.DMLObjs.DMLDrawer.FLinkOptimizeLevel := oLV;
  end;
  if Assigned(DMLGraph.OnMoveObj) then
    DMLGraph.OnMoveObj(Self);
  SetDMLModified;
  DMLGraphSelectObj(nil);
  DMLGraph.Refresh;
end;

procedure TFrameDML.actFullTableViewExecute(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 2, 0);
end;

procedure TFrameDML.actPasteAsCopyExecute(Sender: TObject);
begin
  if Assigned(actPaste.OnExecute) then
    actPaste.OnExecute(nil);
end;

procedure TFrameDML.actCapUppercaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('UpperCase');
end;

procedure TFrameDML.actCheckWithMyDictExecute(Sender: TObject);
begin
  DoCapitalizeProc('CheckMyDict');
end;

procedure TFrameDML.actConvertChnToPyExecute(Sender: TObject);
begin
  DoCapitalizeProc('ChnToPY');
end;

procedure TFrameDML.actExchangeDispCommExecute(Sender: TObject);
begin
  DoCapitalizeProc('CommentToLogicName');
end;

procedure TFrameDML.actExchangeNameDispExecute(Sender: TObject);
begin
  DoCapitalizeProc('NameToLogicName');
end;

procedure TFrameDML.actCapLowercaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('LowerCase');
end;

procedure TFrameDML.actAutoCapitalizeExecute(Sender: TObject);
begin
  DoCapitalizeProc('AutoCapitalize');
end;

procedure TFrameDML.actBatCopyCreateSQLExecute(Sender: TObject);
begin
  DoBatCopyProc('CreateSQL');
end;

procedure TFrameDML.actBatCopyDescTextExecute(Sender: TObject);
begin
  DoBatCopyProc('DescText');
end;

procedure TFrameDML.actBatCopyExcelTextExecute(Sender: TObject);
begin
  DoBatCopyProc('ExcelText');
end;

procedure TFrameDML.actBatCopyFieldNameCommaExecute(Sender: TObject);
begin
  DoBatCopyProc('FieldNameComma');
end;

procedure TFrameDML.actBatCopyFieldNameExecute(Sender: TObject);
begin
  DoBatCopyProc('FieldName');
end;

procedure TFrameDML.actBatCopyFieldNTypeExecute(Sender: TObject);
begin
  DoBatCopyProc('FieldAndType');
end;

procedure TFrameDML.actBatCopyInsertSQLExecute(Sender: TObject);
begin
  DoBatCopyProc('InsertSQL');
end;

procedure TFrameDML.actBatCopyJoinSelectSQLExecute(Sender: TObject);
begin
  DoBatCopyProc('JoinSelectSQL');
end;

procedure TFrameDML.actBatCopySelectSQLExecute(Sender: TObject);
begin
  DoBatCopyProc('SelectSQL');
end;

procedure TFrameDML.actBatCopyTbNameExecute(Sender: TObject);
begin
  DoBatCopyProc('TableName');
end;

procedure TFrameDML.actBatCopyUpdateSQLExecute(Sender: TObject);
begin
  DoBatCopyProc('UpdateSQL');
end;

procedure TFrameDML.actCamelCaseToUnderlineExecute(Sender: TObject);
begin
  DoCapitalizeProc('CamelCaseToUnderline');
end;

procedure TFrameDML.actRestoreExecute(Sender: TObject);
begin
  DMLGraph.Reset;
end;

procedure TFrameDML.actFileNewExecute(Sender: TObject);
begin
  if DMLGraph.DMLObjs.Count > 0 then
    if Application.MessageBox(PChar('确定要清空当前内容吗？'),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
      Exit;
  SetStatusBarMsg('', 2);
  DMLGraph.DMLObjs.Clear;
  DMLGraph.Reset;
  DMLGraph.Refresh;

  actShowFieldType.Checked := DMLGraph.DMLDrawer.ShowFieldType;
end;

procedure TFrameDML.actFileOpenExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadFromFile(OpenDialog1.FileName);
  actShowFieldType.Checked := DMLGraph.DMLDrawer.ShowFieldType;
end;

procedure TFrameDML.DMLGraphKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE:
      actDeleteObj.Execute;
    VK_RETURN:
      actDMLObjProp.Execute;
    67: //'C'
      if ssCtrl in Shift then
        actCopy.Execute;
    86: //'V'
      if ssCtrl in Shift then
        actPaste.Execute;  
    VK_ESCAPE:
      if actFullScreen.Checked then
        actFullScreen.Execute;
  end;
end;

procedure TFrameDML.actDeleteObjExecute(Sender: TObject);
var
  C, I: Integer;
  Obj: TDMLObj;
begin
  with DMLGraph.DMLObjs do
    for I := Count - 1 downto 0 do
      if Items[I].Selected and (Items[I] is TDMLLinkObj) then
      begin
        Obj := Items[I];
        //连线旁边的对象被选中时，不删除连线
        if TDMLLinkObj(Obj).Obj2 <> nil then
          if TDMLLinkObj(Obj).Obj2.Selected then
          begin
            Obj.Selected := False;
          end;
        if TDMLLinkObj(Obj).Obj1 <> nil then
          if TDMLLinkObj(Obj).Obj1.Selected then
          begin
            Obj.Selected := False;
          end;
      end;
  C := DMLGraph.DMLObjs.SelectedCount;
  if C = 0 then
    Exit;
  if C = 1 then
    if Application.MessageBox(PChar(Format(srConfirmDeleteObjFmt, [DMLGraph.DMLObjs.SelectedObj.Name])),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
      Exit;
  if C > 1 then
    if Application.MessageBox(PChar(Format(srConfirmDeleteCountFmt, [C])),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
      Exit;
  if Assigned(Proc_OnObjAddOrRemove) then
  begin
    Proc_OnObjAddOrRemove(nil, 991);
    try
      with DMLGraph.DMLObjs do
        for I := Count - 1 downto 0 do
          if Items[I].Selected then
            if not Proc_OnObjAddOrRemove(Items[I], 2) then
              Exit;
    finally
      Proc_OnObjAddOrRemove(nil, 992);
    end;
  end;
  DMLGraph.DMLObjs.DeleteSelected;
  SetDMLModified;
  DMLGraphSelectObj(nil);
  DMLGraph.Refresh;
end;

procedure TFrameDML.actAddLinkExecute(Sender: TObject);
var
  S: String;
begin
  if DMLGraph.DMLObjs.SelectedCount = 2 then
    if (DMLGraph.DMLObjs.GetSelectedItem(0) is TDMLEntityObj) and
       (DMLGraph.DMLObjs.GetSelectedItem(1) is TDMLEntityObj) then
    begin
      _OnLinkObjSelected(DMLGraph, DMLGraph.DMLObjs.GetSelectedItem(0), DMLGraph.DMLObjs.GetSelectedItem(1));
      Exit;
    end;
  if (DMLGraph.DMLObjs.SelectedObj is TDMLEntityObj) and
    actAddLink.Checked then
  begin
    DMLGraph.SelectLinkingObj := True;
    S := DMLGraph.DMLObjs.SelectedObj.Name;
    if DMLGraph.DMLObjs.SelectedObj is TDMLTableObj then
      S := TDMLTableObj(DMLGraph.DMLObjs.SelectedObj).Get_PhyTbName;
    PvtMsgBox('DmlLinkToRelateTable', '', Format(srDmlLinkToRelateTableFmt,[S]), 0, 0, 5);
  end
  else
  begin
    DMLGraph.SelectLinkingObj := False;
    ctalert(srDmlLinkToSelectTip);
  end;
end;

procedure TFrameDML.actNewObjExecute(Sender: TObject);
var
  S: string;
  o: TDMLTableObj;
begin
  if not Assigned(Proc_OnObjAddOrRemove) then
  begin
    S := PvtInputBox(srNewDmlTable, srNewDmlTbPrompt, '');
    if S = '' then
      Exit;
  end
  else
    S := srNewDmlTable;

  SetDMLModified;

  o := TDMLTableObj(DMLGraph.DMLObjs.CreateDMLObj(''));
  o.Name := S;

  if (DMLGraph.LastMouseDownPos.X <> DEF_INIT_LAST_IMGV_MOUSE_POS_X)
    and (DMLGraph.LastMouseDownPos.Y <> DEF_INIT_LAST_IMGV_MOUSE_POS_Y) then
  begin
    o.Left := DMLGraph.LastMouseDownPos.X;
    o.Top := DMLGraph.LastMouseDownPos.Y;
  end;

  if Assigned(Proc_OnObjAddOrRemove) then
    if not Proc_OnObjAddOrRemove(o, 1) then
    begin
      o.PrepareDelete(DMLGraph.DMLObjs);
      DMLGraph.DMLObjs.Remove(o);
      Exit;
    end;

  {with o.NewField do
  begin
    Name :=  'ID';
    FieldType := dmlfPK;
  end;
  with o.NewField do
  begin
    Name := 'Name';
    FieldType := dmlfString;
  end;    }
  {
  with o.NewField do
  begin
    Name := '输入时间';
    FieldType := dmlfDate;
  end;
  with o.NewField do
  begin
    Name := '工作人员编号';
    FieldType := dmlfInteger;
  end;
  with o.NewField do
  begin
    Name := 'INSNO';
    FieldType := dmlfInteger;
  end;
  with o.NewField do
  begin
    Name := 'PROCID';
    FieldType := dmlfInteger;
  end;
  with o.NewField do
  begin
    Name := 'DATALEVEL';
    FieldType := dmlfEnum;
  end;}
  o.CheckResize;
  DMLGraph.DMLObjs.ClearSelection;
  o.Selected := True;
  DMLGraphSelectObj(nil);
  DMLGraph.MakeObjVisible(o);
  DMLGraph.Refresh;

end;

procedure TFrameDML.actFileSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveToFile(SaveDialog1.FileName);
  actShowFieldType.Checked := DMLGraph.DMLDrawer.ShowFieldType;
end;

procedure TFrameDML.actImportDBExecute(Sender: TObject);
begin
 { if not Assigned(FfrmDMLImport) then
    FfrmDMLImport := TfrmDMLImport.Create(Self);
  TfrmDMLImport(FfrmDMLImport).DMLObjList := DMLGraph.DMLObjs;
  if FfrmDMLImport.ShowModal = mrOk then
  begin
    SetDMLModified;
    DMLGraph.DMLObjs.ReArrange;
    DMLGraphSelectObj(nil);
    DMLGraph.Refresh;
    actShowFieldType.Checked := DMLGraph.DMLDrawer.ShowFieldType;
  end; }
end;

procedure TFrameDML.DMLGraphViewChanged(Sender: TObject);
begin
  SetStatusBarMsg(Format(srDmlGraphStatusFmt, [
    Round(DMLGraph.ViewScale * 100),
      Round(DMLGraph.ViewCenterX + DMLGraph.DMLDrawer.DrawerWidth / 2),
      Round(DMLGraph.ViewCenterY + DMLGraph.DMLDrawer.DrawerHeight / 2)]), 1);
end;

procedure TFrameDML.DMLGraphSelectObj(Sender: TObject);
var
  C, ec, lc: Integer;
  I: Integer;
begin
  C := DMLGraph.DMLObjs.SelectedCount;
  if C > 1 then
  begin
    ec := 0;
    lc := 0;
    for I := 0 to DMLGraph.DMLObjs.Count - 1 do
      if DMLGraph.DMLObjs.Items[I].Selected then
      begin
        if DMLGraph.DMLObjs.Items[I] is TDMLEntityObj then
          Inc(ec)
        else if DMLGraph.DMLObjs.Items[I] is TDMLLinkObj then
          Inc(lc);
      end;
    if ec > 0 then
    begin
      if lc > 0 then
        SetStatusBarMsg(Format(srDmlSelectedObjectsCountFmt, [EC, lc]), 2)
      else
        SetStatusBarMsg(Format(srDmlSelectedEntitiesCountFmt, [EC]), 2);
    end
    else if lc > 0 then
    begin
      SetStatusBarMsg(Format(srDmlSelectedLinksCountFmt, [lc]), 2)
    end
    else      
      ShowDMLInfoStatusMsg();
  end
  else if C = 1 then
  begin //modied by cha
    if DMLGraph.DMLObjs.SelectedObj is TDMLTableObj then
      with TDMLTableObj(DMLGraph.DMLObjs.SelectedObj) do
      begin
        if SelectedFieldIndex > 0 then
        begin
          SetStatusBarMsg(Format(srDmlSelectedTableFieldFmt, [Get_PhyTbName, Field[SelectedFieldIndex - 1].Get_PhyName]), 2);
        end
        else
          SetStatusBarMsg(Format(srDmlSelectedTableInfoFmt, [Get_PhyTbName, FieldCount]), 2);
      end
    else
      SetStatusBarMsg(srDmlSelectedObj + DMLGraph.DMLObjs.SelectedObj.Name, 2);
    SetPropertyObj(DMLGraph.DMLObjs.SelectedObj);
  end
  else
  begin
    ShowDMLInfoStatusMsg();
    SetPropertyObj(nil);
  end;
end;

procedure TFrameDML._OnDMLObjProgress(Sender: TObject;
  const Prompt: string; Cur, All: Integer; var bContinue: Boolean);
begin
  if All > 0 then
  begin
    if Assigned(FWaitWnd) then
    begin
      if (All > 0) then
        FWaitWnd.SetPercentMsg(Cur * 100 / All, Prompt, True)
      else
        FWaitWnd.SetPercentMsg(-1, Prompt, True);
      if FWaitWnd.Canceled then
        bContinue := False;
    end
    else
    begin
      if (All > 0) and (Cur = All) then
        SetStatusBarMsg(Format('%s %s', [Prompt, srDmlProgressFinished]), 0)
      else
        SetStatusBarMsg(Format('%s %d/%d', [Prompt, Cur, All]), 0);
      CheckAbort(' ');
    end;
  end;
end;

procedure TFrameDML.actRearrangeExecute(Sender: TObject);
var
  C: Integer;
begin
  if Sender <> nil then
  begin
    C := DMLGraph.DMLObjs.SelectedCount;
    if C = 0 then
      if Application.MessageBox(PChar(srConfirmRearrangeAll),
        PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
        Exit;
    if C > 0 then
    begin
      if Application.MessageBox(PChar(Format(srConfirmRearrangeSelectedFmt, [C])),
        PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
        Exit;
    end;
  end;        
  if DMLGraph.DMLDrawer.FIsHugeMode then
    Toast(srHugeModeArrangeHint, 2000);
  Screen.Cursor := crAppStart;
  try

    if DMLGraph.DMLObjs.BriefMode then
      DMLGraph.DMLObjs.BriefMode := False;

    if (GetKeyState(VK_SHIFT) and $80) <> 0 then
      DMLGraph.DMLObjs.ReArrange
    else
      DMLGraph.DMLObjs.ReArrangeV2;

  finally
    Screen.Cursor := crDefault;
  end;
  if DMLGraph.DMLObjs.SelectedCount > 0 then
    DMLGraph.Reset
  else
    DMLGraph.BestFit;
  SetDMLModified;
end;

procedure TFrameDML.actNewTextExecute(Sender: TObject);
var
  S: string;
  o: TDMLTextObj;
begin
  S := '';
  if not Assigned(Proc_OnObjAddOrRemove) then
  begin
    if not PvtMemoQuery(srNewDmlText, srNewDmlTextPrompt, S, False) then
      Exit;
  end
  else
    S := srNewDmlText;

  o := TDMLTextObj(DMLGraph.DMLObjs.CreateDMLObj('TEXT'));
  if (DMLGraph.LastMouseDownPos.X <> DEF_INIT_LAST_IMGV_MOUSE_POS_X)
    and (DMLGraph.LastMouseDownPos.Y <> DEF_INIT_LAST_IMGV_MOUSE_POS_Y) then
  begin
    o.Left := DMLGraph.LastMouseDownPos.X;
    o.Top := DMLGraph.LastMouseDownPos.Y;
  end;
  SetDMLModified;
  o.Comment := S;

  if Assigned(Proc_OnObjAddOrRemove) then
    if not Proc_OnObjAddOrRemove(o, 1) then
    begin
      o.PrepareDelete(DMLGraph.DMLObjs);
      DMLGraph.DMLObjs.Remove(o);
      Exit;
    end;

  o.CheckResize;
  DMLGraph.DMLObjs.ClearSelection;
  o.Selected := True;
  DMLGraphSelectObj(nil);
  DMLGraph.MakeObjVisible(o);
  DMLGraph.Refresh;
end;

procedure TFrameDML.actDMLObjPropExecute(Sender: TObject);
var
  obj: TDMLObj;
begin
  if not DMLGraph.CanFocus then
    Exit;
  obj := DMLGraph.DMLObjs.SelectedObj;
  if Assigned(obj) and (obj is TDMLTableObj) then
    ShowTbProp(obj as TDMLTableObj)
  else
    ShowObjProp(obj);
  SetPropertyObj(obj);
end;

procedure TFrameDML.actExportXlsExecute(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
  try
    Filter := 'Excel file(*.xls)|*.xls';
    Options := Options + [ofOverwritePrompt];
    DefaultExt := 'xls';
    if Execute then
      ExportToExcel(FileName);
  finally
    Free;
  end;
end;

procedure TFrameDML.ShowObjProp(obj: TDMLObj);
begin
  if not Assigned(obj) then
    Exit;
  {if not Assigned(FfrmDMLObjProp) then
    FfrmDMLObjProp := TfrmDMLObjProp.Create(Self);
  FfrmDMLObjProp.LoadFromObj(obj);
  if FfrmDMLObjProp.ShowModal = mrOk then
  begin
    SetDMLModified;
    DMLGraph.Refresh;
  end;  }
end;

procedure TFrameDML.Checkacts;
var
  C: Integer;
begin
  C := DMLGraph.DMLObjs.SelectedCount;
  //actDMLObjProp.Enabled := (C = 1);
  actSetEntityColor.Enabled := (C > 0);    
  actFullTableView.Enabled := (C = 1) and (DMLGraph.DMLObjs.SelectedObj is TDMLTableObj);
  actAddLink.Enabled := (C=0) or ((C<=2) and (DMLGraph.DMLObjs.GetSelectedItem(0) is TDMLEntityObj));
  actAddLink.Checked := DMLGraph.SelectLinkingObj;
  actDeleteObj.Enabled := (C > 0);
  actCopy.Enabled := (C > 0);

  actCamelCaseToUnderline.Enabled := (C > 0);
  actUnderlineToCamelCase.Enabled := (C > 0);
  actCapUppercase.Enabled := (C > 0);
  actCapLowercase.Enabled := (C > 0);
  actAutoCapitalize.Enabled := (C > 0);
  actExchangeDispComm.Enabled := (C > 0);
  actExchangeNameDisp.Enabled := (C > 0);
  actCheckWithMyDict.Enabled := (C > 0);
  actConvertChnToPy.Enabled := (C > 0);
  MN_Capitalize.Enabled := (C > 0);

  actBatCopyTbName.Enabled := (C > 0);    
  actBatCopyFieldName.Enabled := (C > 0);       
  actBatCopyFieldNType.Enabled := (C > 0);
  actBatCopyExcelText.Enabled := (C > 0);
  actBatCopyDescText.Enabled := (C > 0);
  actBatCopyFieldNType.Enabled := (C > 0);
  actBatCopyCreateSQL.Enabled := (C > 0);
  actBatCopySelectSQL.Enabled := (C > 0);       
  actBatCopyJoinSelectSQL.Enabled := (C > 0);
  actBatCopyInsertSQL.Enabled := (C > 0);
  actBatCopyUpdateSQL.Enabled := (C > 0);
  actBatCopyFieldNameComma.Enabled := (C > 0);
  MN_BatchCopy.Enabled := (C > 0);
end;

procedure TFrameDML.CheckLinkLines;
begin
  DMLGraph.DMLObjs.CheckLinkLines;
end;

procedure TFrameDML.ActionList2Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  Checkacts;
end;

procedure TFrameDML._OnLinkObjSelected(Sender: TObject; Obj1,
  Obj2: TDMLObj);
var
  o: TDMLLinkObj;
  tp: Integer;
begin
  if Obj1 = Obj2 then
    Exit;
  if (Obj1 is TDMLEntityObj) and (Obj2 is TDMLEntityObj) then
  begin
    tp := 1;
    if Assigned(Proc_OnLinkObj) then
    begin
      tp := Proc_OnLinkObj(Obj1, Obj2);
      if tp = -1 then
        Exit;
    end;
    Obj1.Selected := False;
    DMLGraph.SelectLinkingObj := False;

    o := TDMLLinkObj(DMLGraph.DMLObjs.CreateDMLObj('LINK'));
    o.Obj1 := TDMLEntityObj(Obj1);
    o.Obj2 := TDMLEntityObj(Obj2);
    if tp = 1 then
      o.LinkType := dmllFKNormal
    else if tp = 2 then
      o.LinkType := dmllFKUnique   
    else if tp = 3 then
      o.LinkType := dmllLine
    else if tp = 4 then
      o.LinkType := dmllDirect
    else if tp = 5 then
      o.LinkType := dmllOppDirect;
    o.CheckPosition;

    if Assigned(Proc_OnObjAddOrRemove) then
      Proc_OnObjAddOrRemove(o, 1);

    SetDMLModified;
    DMLGraph.Refresh;
    Checkacts;
  end
  else
    raise Exception.Create(srErrCanOnlyLinkTwoEntities);
end;

procedure TFrameDML.LoadFromFile(fn: string);
begin
  FWaitWnd := TfrmWaitWnd.Create(Self);
  try
    FWaitWnd.Init('打开文件', '正在打开...',
      '确定要中止打开吗?');
    DMLGraph.LoadFromFile(fn);
    DMLFileName := fn;
  finally
    FWaitWnd.Release;
    FWaitWnd := nil;
  end;
end;

function TFrameDML.SaveDmlImage(fn: string): string;
const
  bufsize = 128;
var
  graph, grp2: TGraphic;
  cnv: TCanvas;
  w, h: Integer;
  x0, y0, x1, y1, w0, h0: Double;
  b64s: TBase64EncodingStream;
  os: TStringStream;
  S: string;     
  I: Integer;       
  buf: array[0..bufsize - 1] of Char;
  bMultiLine: Boolean;
begin
  Result := '';

  if fn = '' then
    S := '.bmp'
  else if fn[1] = '.' then
  begin
    S := LowerCase(fn);
    fn := '';
  end
  else
    S := LowerCase(ExtractFileExt(fn));
  if S = '' then
    S := '.png';

  if not ((S = '.png') or (S = '.bmp') or (S = '.jpg') or (S = '.jpeg') {or (S = '.wmf')}) then
  begin
    Exit;
  end;


  if DMLGraph.DMLObjs.SelectedCount = 0 then
  begin
    DMLGraph.DMLObjs.GetAllObjsRect(x0, y0, x1, y1);
  end
  else
  begin        
    DMLGraph.DMLObjs.CheckSelLinksOfSelectedEntities;
    DMLGraph.Refresh;
    DMLGraph.DMLObjs.GetSelectionRect(x0, y0, x1, y1);
  end;

  x0 := x0 - 4;
  y0 := y0 - 4;
  x1 := x1 + 4;
  y1 := y1 + 4;

  w0 := x1 - x0;
  h0 := y1 - y0;
  w := DMLGraph.ImageToScreenX(x1) - DMLGraph.ImageToScreenX(x0);
  h := DMLGraph.ImageToScreenY(y1) - DMLGraph.ImageToScreenY(y0);

  {if S = '.wmf' then
  begin
    graph := TMetafile.Create;
    graph.Width := w;
    graph.Height := h;
    cnv := TMetafileCanvas.Create(TMetafile(graph), 0);
  end
  else }
  begin
    graph := TBitmap.Create;
    graph.Width := w;
    graph.Height := h;
    cnv := TBitmap(graph).Canvas;
  end;
  try
    DMLGraph.DMLDrawer.DrawSelectedOnly := (DMLGraph.DMLObjs.SelectedCount > 0);
    try
      DMLGraph.ExportImage(cnv, x0, y0, w0, h0);
    finally
      DMLGraph.DMLDrawer.DrawSelectedOnly := False;
      if s = '.wmf' then
        cnv.Free;
    end;

    grp2 := nil;
    if s = '.png' then
    begin
      grp2 := TPortableNetworkGraphic.Create;
    end
    else if (s = '.jpg') or (s = '.jpeg') then
    begin
      grp2 := TJPEGImage.Create;
    end;

    if grp2 <> nil then
    begin
      grp2.Assign(graph);
      graph.Free;
      graph := grp2;
    end;

    if Pos('(BASE64TEXT)', fn) = 1 then
    begin                        
      os:= TStringStream.Create('');
      b64s := TBase64EncodingStream.Create(os);
      try
        //if Pos('(SINGLELINE)', fn) > 0 then
        //  b64s.CharCountPerLine := 0;      
        if Pos('(MULTILINE)', fn) > 0 then
          bMultiLine := True
        else
          bMultiLine := False;
        graph.SaveToStream(b64s);
        os.Seek(0,soFromBeginning);
        I := os.Read(Buf, BufSize);
        while I > 0 do
        begin
          Result := Result + Copy(Buf, 1, I);
          I := os.Read(Buf, BufSize);
          if bMultiLine and (I > 0) then
            Result := Result + #13#10;
        end;
      finally
        b64s.Free;
        os.Free;
      end;
    end
    else
    if fn <> '' then
      graph.SaveToFile(fn)
    else
    begin
      Clipboard.Assign(graph); //DMLGraph.BufferBitmap
    end;
  finally
    graph.Free;
  end;
end;

procedure TFrameDML.ExportToExcel(fn: string);
var
  I, J, C, row: Integer;
  o: TDMLTableObj;
  S: string;
  bAll: Boolean;
  xl: TXLSfile;
  att, att_val, att_title, att_header, att_pk, att_fk: TSetOfAtribut;
begin
  C := 0;
  with DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
        if Items[I] is TDMLTableObj then
        begin
          Inc(C);
        end;

  if C = 0 then
    bAll:=True
  else
    bAll:=False;
    //raise Exception.Create(srCannotExportEmptySelection);

  xl := TXLSfile.Create(nil);
  try
    xl.FileName := fn;

    xl.AddFont('宋体', 11, [], 0); //val
    xl.AddFont('宋体', 11, [], 2); //title
    xl.AddFont('宋体', 11, [fsBold], 10); //header
    xl.AddFont('宋体', 11, [], 0); //FK

    att_val := [acBottomBorder, acTopBorder, acRightBorder, acLeftBorder, acFont0];
    att_title := [acBottomBorder, acTopBorder, acRightBorder, acLeftBorder, acFont1];
    att_header := [acBottomBorder, acTopBorder, acRightBorder, acLeftBorder, acShaded, acFont2];
    att_pk := [acBottomBorder, acTopBorder, acRightBorder, acLeftBorder, acFont0];
    att_fk := [acBottomBorder, acTopBorder, acRightBorder, acLeftBorder, acFont3];

    xl.SetColWidths(0, 0, 18 * 14 * 20); //物理名称
    xl.SetColWidths(1, 1, 18 * 14 * 20); //逻辑名
    xl.SetColWidths(2, 2, 12 * 14 * 20); //类型
    xl.SetColWidths(3, 3, 24 * 14 * 20); //备注

    row := 1;

    with DMLGraph.DMLObjs do
      for I := 0 to Count - 1 do
        if Items[I].Selected or bAll then
          if Items[I] is TDMLTableObj then
          begin
            o := TDMLTableObj(Items[I]);

            //写表名和注释
            xl.AddStrCell(1, row, att_title - [acRightBorder], o.Get_PhyTbName);
            xl.AddBlankCell(2, row, att_title - [acLeftBorder, acRightBorder]);
            xl.AddBlankCell(3, row, att_title - [acLeftBorder, acRightBorder]);
            xl.AddBlankCell(4, row, att_title - [acLeftBorder]);
            xl.AddStrCell(5, row, [acLeftBorder], '');
            row := row + 1;
            S := o.Name;
            if S = o.Get_PhyTbName then
              S := '';
            S := Trim(S + ' ' + o.Comment);
            //if S <> '' then
            begin
              xl.AddStrCell(1, row, att_val - [acRightBorder, acTopBorder], S);
              xl.AddBlankCell(2, row, att_val - [acLeftBorder, acRightBorder, acTopBorder]);
              xl.AddBlankCell(3, row, att_val - [acLeftBorder, acRightBorder, acTopBorder]);
              xl.AddBlankCell(4, row, att_val - [acLeftBorder, acTopBorder]);
              xl.AddStrCell(5, row, [acLeftBorder], '');
              row := row + 1;
            end;

            //写表头
            xl.AddStrCell(1, row, att_header, srFieldName);
            xl.AddStrCell(2, row, att_header, srLogicName);
            xl.AddStrCell(3, row, att_header, srDataType);
            xl.AddStrCell(4, row, att_header, srComments);
            xl.AddStrCell(5, row, [acLeftBorder], '');
            row := row + 1;

            //写字段
            for J := 0 to o.FieldCount - 1 do
              with o.Field[J] do
              begin
                if FieldType = dmlfPK then
                  att := att_pk
                else if FieldType = dmlfFK then
                  att := att_fk
                else
                  att := att_val;

                xl.AddStrCell(1, row, att, Get_PhyName);
                S := Name;
                if S = Get_PhyName then
                  S := '';
                xl.AddStrCell(2, row, att, S);
                xl.AddStrCell(3, row, att, Get_FieldTypeStr(DMLGraph.DMLDrawer.ShowPhyFieldName = 1));
                xl.AddStrCell(4, row, att, Comment);
                xl.AddStrCell(5, row, [acLeftBorder], '');
                row := row + 1;
              end;

            //插空行
            row := row + 1;
            row := row + 1;
          end;

    xl.write;

  finally
    xl.Free;
  end;

  if Application.MessageBox(PChar(srConfirmOpenXlsAfterExport),
    PChar(Application.Title), MB_OKCANCEL) = IDOK then
     CtOpenDoc(PChar(fn)); { *Converted from ShellExecute* }
end;

procedure TFrameDML.SaveToFile(fn: string);
begin
  FWaitWnd := TfrmWaitWnd.Create(Self);
  try
    FWaitWnd.Init('保存文件', '正在保存...',
      '确定要中止保存吗?');
    DMLGraph.SaveToFile(fn);
    DMLFileName := fn;
  finally
    FWaitWnd.Release;
    FWaitWnd := nil;
  end;
end;

procedure TFrameDML.actSelectAllExecute(Sender: TObject);
begin
  DMLGraph.DMLObjs.SelectAll((GetKeyState(VK_SHIFT) and $80) <> 0);
  DMLGraph.Refresh;
end;

procedure TFrameDML.actSetEntityColorExecute(Sender: TObject);
var
  C, I: Integer;
begin
  C := DMLGraph.DMLObjs.SelectedCount;
  if C = 0 then
    Exit;
  with DMLGraph.DMLObjs do
    for I := 0 to Count - 1 do
      if Items[I].Selected then
      begin
        ColorDialog1.Color := Items[I].FillColor;
        Break;
      end;
  if not ColorDialog1.Execute then
    Exit;
  with DMLGraph.DMLObjs do
    for I := Count - 1 downto 0 do
      if Items[I].Selected then
      begin
        if ColorDialog1.Color <> clBlack then
        begin
          Items[I].FillColor := ColorDialog1.Color;
          Items[I].UserPars := AddOrModifyCompStr(Items[I].UserPars, '1', '[CUSTOM_BKCOLOR=', ']');
        end
        else
        begin
          Items[I].FillColor := DMLGraph.DMLDrawer.DefaultObjectColor;
          Items[I].UserPars := AddOrModifyCompStr(Items[I].UserPars, '0', '[CUSTOM_BKCOLOR=', ']');
        end;
      end;
  if Assigned(DMLGraph.OnMoveObj) then
    DMLGraph.OnMoveObj(DMLGraph);
  SetDMLModified;
  DMLGraph.Refresh;
end;

procedure TFrameDML.actShowFieldTypeExecute(Sender: TObject);
begin
  DMLGraph.DMLDrawer.ShowFieldType := actShowFieldType.Checked;
  DMLGraph.Refresh;
end;

procedure TFrameDML.actCheckFKLinksExecute(Sender: TObject);
var
  I: Integer;
var
  C: Integer;
begin
  C := DMLGraph.DMLObjs.SelectedCount;
  if C = 0 then
    if Application.MessageBox(PChar('确定要对所有对象查找外键关联吗？'),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
      Exit;
  if C > 0 then
    if Application.MessageBox(PChar('确定要对选中的 ' + IntToStr(C) + ' 个对象查找外键关联吗？'),
      PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
      Exit;
  for I := 0 to DMLGraph.DMLObjs.Count - 1 do
    if (C = 0) or DMLGraph.DMLObjs[I].Selected then
      if DMLGraph.DMLObjs[I] is TDMLTableObj then
      begin
        CheckAbort(' ');
        TDMLTableObj(DMLGraph.DMLObjs[I]).FindFKLinks(DMLGraph.DMLObjs);
      end;
  SetDMLModified;
  DMLGraph.Refresh;
end;

procedure TFrameDML.actColorStylesExecute(Sender: TObject);
var
  i: integer;
begin
  if not Assigned(FfrmColorStyles) then
    FfrmColorStyles := TfrmColorStyles.Create(Self);
  FfrmColorStyles.SetColor(5, DMLGraph.Color); //设置原背景色
  FfrmColorStyles.SetColor(8, DMLGraph.DMLDrawer.DefaultPKColor); //
  FfrmColorStyles.SetColor(7, DMLGraph.DMLDrawer.DefaultFKColor); //
  FfrmColorStyles.SetColor(6, DMLGraph.DMLDrawer.SelectedColor);
  FfrmColorStyles.SetColor(1, DMLGraph.DMLDrawer.DefaultTitleColor);
  FfrmColorStyles.SetWorkSpaceWidth(DMLGraph.GraphWidth);
  FfrmColorStyles.SetWorkSpaceHeight(DMLGraph.GraphHeight);
  FfrmColorStyles.SetShowFieldIcon(DMLGraph.DMLDrawer.ShowFieldIcon);
  FfrmColorStyles.SetShowFieldType(DMLGraph.DMLDrawer.ShowFieldType);
  FfrmColorStyles.SetColor(3, DMLGraph.DMLDrawer.DefaultObjectColor);
  FfrmColorStyles.SetColor(4, DMLGraph.DMLDrawer.DefaultBorderColor);
  FfrmColorStyles.SetColor(9, DMLGraph.DMLDrawer.DefaultLineColor); //
  FfrmColorStyles.SetDbEngine(DMLGraph.DMLDrawer.DatabaseEngine);  
  FfrmColorStyles.ckbIndependPosForOverviewMode.Checked := DMLGraph.DMLDrawer.IndependPosForOverviewMode;

  if FfrmColorStyles.ShowModal = mrCancel then
    Exit;
  SetDMLModified;

  //全局属性
  DMLGraph.Color := FfrmColorStyles.GetColor(5); //设置背景色
  DMLGraph.DMLDrawer.WorkAreaColor := DMLGraph.Color;
  DMLGraph.DMLDrawer.DefaultPKColor := FfrmColorStyles.GetColor(8); //主键色
  DMLGraph.DMLDrawer.DefaultFKColor := FfrmColorStyles.GetColor(7); //外键色
  DMLGraph.DMLDrawer.SelectedColor := FfrmColorStyles.GetColor(6); //选择色
  DMLGraph.DMLDrawer.DefaultTitleColor := FfrmColorstyles.GetColor(1);
  DMLGraph.DMLDrawer.DrawerWidth := FfrmColorStyles.GetWorkSpaceWidth;
  DMLGraph.DMLDrawer.DrawerHeight := FfrmColorStyles.GetWorkSpaceHeight;
  DMLGraph.DMLDrawer.ShowFieldIcon := FfrmColorStyles.GetShowFieldIcon;
  DMLGraph.DMLDrawer.ShowFieldType := FfrmColorStyles.GetShowFieldType;
  DMLGraph.DMLDrawer.DefaultObjectColor := FfrmColorStyles.GetColor(3);
  DMLGraph.DMLDrawer.DefaultBorderColor := FfrmColorStyles.GetColor(4);
  DMLGraph.DMLDrawer.DefaultLineColor := FfrmColorStyles.GetColor(9);
  DMLGraph.DMLDrawer.DatabaseEngine := FfrmColorStyles.GetDbEngine;    
  DMLGraph.DMLDrawer.IndependPosForOverviewMode := FfrmColorStyles.ckbIndependPosForOverviewMode.Checked;

  actShowFieldType.Checked := DMLGraph.DMLDrawer.ShowFieldType;

  for i := 0 to DMLGraph.DMLObjs.Count - 1 do
  begin
    DMLGraph.DMLDrawer.SetDefaultProps(DMLGraph.DMLObjs[I]);
  end;
  CurrentDmlDbEngine := DMLGraph.DMLDrawer.DatabaseEngine;

  DMLGraph.Refresh;

end;

procedure TFrameDML.actCopyDmlTextExecute(Sender: TObject);
var
  obj: TDMLObj;
begin
  if not DMLGraph.CanFocus then
    Exit;
  obj := DMLGraph.DMLObjs.SelectedObj;
  if not Assigned(obj) then
    Exit;
  if obj is TDMLTableObj then
    Clipboard.AsText := TDMLTableObj(obj).GetSelectedText(DMLGraph.DMLDrawer)
  else if obj is TDMLTextObj then
    Clipboard.AsText := TDMLTextObj(obj).Comment
  else if obj is TDMLLinkObj then
    Clipboard.AsText := TDMLLinkObj(obj).GetDescText
  else
    Clipboard.AsText := obj.Name;
end;

procedure TFrameDML.actCopyExecute(Sender: TObject);
begin
  ;
end;

procedure TFrameDML.actCopyImageExecute(Sender: TObject);
begin
  if (GetKeyState(VK_SHIFT) and $80) <> 0 then
    SaveDmlImage('.wmf')
  else
    SaveDmlImage('');
end;

procedure TFrameDML.actRefreshExecute(Sender: TObject);
begin
  DMLGraph.Refresh;
end;

procedure TFrameDML.actDBGenSqlExecute(Sender: TObject);
begin
 { if not Assigned(FfrmDMLGenSQL) then
    FfrmDMLGenSQL := TfrmDMLGenSQL.Create(Self);
  TfrmDMLGenSQL(FfrmDMLGenSQL).DMLObjList := DMLGraph.DMLObjs;

  if FfrmDMLGenSQL.ShowModal = mrOk then
  begin

  end;  }
end;

procedure TFrameDML.TimerDelayCmdTimer(Sender: TObject);
var
  tg: Integer;
begin
  TimerDelayCmd.Enabled := False;
  tg := TimerDelayCmd.Tag;
  TimerDelayCmd.Tag := 0;
  if tg = 1 then
  begin         
    if (GetKeyState(VK_CONTROL) and $80) <> 0 then
    begin
      PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 2, 0);
      Exit;
    end;
    actDMLObjProp.Execute;
  end;
end;


procedure TFrameDML.LoadFromStream(AStream: TStream);
begin
  try
    DMLGraph.LoadFromStream(AStream);
  finally
  end;
end;

procedure TFrameDML.PopupMenu1Popup(Sender: TObject);
begin
  if DMLGraph.SelectLinkingObj then
    DMLGraph.SelectLinkingObj := False;
end;

procedure TFrameDML.SaveToStream(AStream: TStream);
begin
  try
    DMLGraph.SaveToStream(AStream);
  finally
  end;
end;


{$IFDEF USE_ORACLE}

procedure TFrameDML.SetSession(ASession: TOracleSession);
begin
  //Exit; //disable oracle support.
  if GetDMLDbReg('ORACLE[NSDOA]')^.DbImpl = nil then
  begin
    DMLOracleDb := TDMLOracleDb.Create;
    GetDMLDbReg('ORACLE[NSDOA]')^.DbImpl := DMLOracleDb;
  end
  else
    DMLOracleDb := TDMLOracleDb(GetDMLDbReg('ORACLE[NSDOA]')^.DbImpl);
  OracleSession := ASession;
  DMLOracleDb.Session := OracleSession;
end;

{$ENDIF}

procedure TFrameDML.SetStatusBarMsg(msg: string; tp: Integer);
begin
  if Assigned(Porc_OnStatusMsg) then
    Porc_OnStatusMsg(msg, tp);
  if (tp >= 0) and (tp < StatusBar1.Panels.Count) then
    StatusBar1.Panels[tp].Text := msg
  else
    StatusBar1.Panels[0].Text := msg;
end;

procedure TFrameDML.ShowDMLInfoStatusMsg;
var
  S: String;
begin
  S:=  Format(srDmlTotalObjectsCountFmt,
    [DMLGraph.DMLObjs.EnitiesCount, DMLGraph.DMLObjs.LinksCount]);
  if DMLGraph.DMLDrawer.FIsHugeMode then
    S := S+' '+srHugeMode;
  SetStatusBarMsg(S, 2);
end;

procedure TFrameDML.DelayCmd(cmd: Integer);
begin
  TimerDelayCmd.Tag := cmd;
  TimerDelayCmd.Enabled := True;
end;

procedure TFrameDML.DoCapitalizeProc(sType: string);
begin
  if Assigned(Proc_DoCapitalize) then
    Proc_DoCapitalize(sType);
end;

procedure TFrameDML.DoBatCopyProc(sType: string);
begin
  if Assigned(Proc_DoBatCopy) then
    Proc_DoBatCopy(sType);
end;

procedure TFrameDML.SetDMLModified;
begin
  DMLGraph.Modified := True;
end;

procedure TFrameDML.SetPropertyObj(vObj: TObject);
var
  vDMLField: TDMLField;
  vDMLTable: TDMLTableObj;
  vDMLLink: TDMLLinkObj;
begin
  DMLProperty := vObj;
  vleProperty.Strings.Clear;
  if vObj = nil then
  begin
    vleProperty.Enabled := false;
    exit;
  end
  else
    vleProperty.Enabled := true;


  if vObj.ClassNameIs('TDMLField') then
  begin
    vDMLField := TDMLField(vObj);
    vleProperty.InsertRow('字段名称', vDMLField.Name, true);
    vleProperty.InsertRow('物理名称', vDMLField.Get_PhyName, true);

    if vDMLField.FieldType = dmlfUnknow then
      vleProperty.InsertRow('类型', '未知', true)
    else if
      vDMLField.FieldType = dmlfPK then
      vleProperty.InsertRow('类型', '主键', true)
    else if
      vDMLField.FieldType = dmlfFK then
      vleProperty.InsertRow('类型', '外键', true)
    else if
      vDMLField.FieldType = dmlfString then
      vleProperty.InsertRow('类型', '字符串', true)
    else if
      vDMLField.FieldType = dmlfInteger then
      vleProperty.InsertRow('类型', '整数', true)
    else if
      vDMLField.FieldType = dmlfEnum then
      vleProperty.InsertRow('类型', '小整数', true)
    else if
      vDMLField.FieldType = dmlfFloat then
      vleProperty.InsertRow('类型', '浮点数', true)
    else if
      vDMLField.FieldType = dmlfDate then
      vleProperty.InsertRow('类型', '日期', true)
    else if
      vDMLField.FieldType = dmlfBool then
      vleProperty.InsertRow('类型', '真假', true)
    else if
      vDMLField.FieldType = dmlfBlob then
      vleProperty.InsertRow('类型', '二进制数据', true)
    else if
      vDMLField.FieldType = dmlfObject then
      vleProperty.InsertRow('类型', '对象', true)
    else if
      vDMLField.FieldType = dmlfCalculate then
      vleProperty.InsertRow('类型', '计算字段', true)
    else if
      vDMLField.FieldType = dmlfOther then
      vleProperty.InsertRow('类型', '其它', true);

    vleProperty.ItemProps['类型'].EditStyle := esPickList;
    vleProperty.ItemProps['类型'].PickList.Text := c_Typeitems;
    vleProperty.ItemProps['类型'].ReadOnly := true;
    if vDMLField.FieldType = dmlfString then
    begin
      vleProperty.InsertRow('长度', IntToStr(vDMLField.FieldLen), true);
    end
    else
    begin
      vleProperty.InsertRow('长度', '', true);
      vleProperty.ItemProps['长度'].ReadOnly := true;
    end;
    vleProperty.InsertRow('类型补充', vDMLField.FieldTypeEx, true);
    vleProperty.ItemProps['类型补充'].EditStyle := esPickList;
    vleProperty.ItemProps['类型补充'].PickList.Text := c_FieldTypeExItems;
    vleProperty.ItemProps['类型补充'].ReadOnly := true;
    vleProperty.InsertRow('控件类型', vDMLField.Editor, true);
    vleProperty.ItemProps['控件类型'].EditStyle := esPickList;
    vleProperty.ItemProps['控件类型'].PickList.Text := c_editorItems;
    vleProperty.ItemProps['控件类型'].ReadOnly := true;
    if vDMLField.Nullable then
      vleProperty.InsertRow('允许为空', 'True', true)
    else
      vleProperty.InsertRow('允许为空', 'False', true);
    vleProperty.ItemProps['允许为空'].EditStyle := esPickList;
    vleProperty.ItemProps['允许为空'].PickList.text := c_boolitems;
    vleProperty.ItemProps['允许为空'].ReadOnly := true;
    vleProperty.InsertRow('备注', vDMLField.Comment, true);
    vleProperty.ItemProps['备注'].EditStyle := esEllipsis;
    //vleProperty.RowHeights[vleProperty.RowCount - 1] := 50;

  end
  else if vObj.ClassNameIs('TDMLTableObj') then
  begin

    vDMLTable := TDMLTableObj(vObj);
    if vDMLTable.SelectedFieldIndex > 0 then
    begin
      vDMLField := vDMLTable.Field[VDMLTable.SelectedFieldIndex - 1];
      vleProperty.InsertRow('字段名称', vDMLField.Name, true);
      vleProperty.InsertRow('物理名称', vDMLField.Get_PhyName, true);

      if vDMLField.FieldType = dmlfUnknow then
        vleProperty.InsertRow('类型', '未知', true)
      else if
        vDMLField.FieldType = dmlfPK then
        vleProperty.InsertRow('类型', '主键', true)
      else if
        vDMLField.FieldType = dmlfFK then
        vleProperty.InsertRow('类型', '外键', true)
      else if
        vDMLField.FieldType = dmlfString then
        vleProperty.InsertRow('类型', '字符串', true)
      else if
        vDMLField.FieldType = dmlfInteger then
        vleProperty.InsertRow('类型', '整数', true)
      else if
        vDMLField.FieldType = dmlfEnum then
        vleProperty.InsertRow('类型', '枚举', true)
      else if
        vDMLField.FieldType = dmlfFloat then
        vleProperty.InsertRow('类型', '浮点数', true)
      else if
        vDMLField.FieldType = dmlfDate then
        vleProperty.InsertRow('类型', '日期', true)
      else if
        vDMLField.FieldType = dmlfBool then
        vleProperty.InsertRow('类型', '真假', true)
      else if
        vDMLField.FieldType = dmlfBlob then
        vleProperty.InsertRow('类型', '二进制数据', true)
      else if
        vDMLField.FieldType = dmlfObject then
        vleProperty.InsertRow('类型', '对象', true)
      else if
        vDMLField.FieldType = dmlfCalculate then
        vleProperty.InsertRow('类型', '计算字段', true)
      else if
        vDMLField.FieldType = dmlfList then
        vleProperty.InsertRow('类型', '列表', true)
      else if
        vDMLField.FieldType = dmlfFunction then
        vleProperty.InsertRow('类型', '函数', true)
      else if
        vDMLField.FieldType = dmlfEvent then
        vleProperty.InsertRow('类型', '事件', true)
      else if
        vDMLField.FieldType = dmlfOther then
        vleProperty.InsertRow('类型', '其它', true);

      vleProperty.ItemProps['类型'].EditStyle := esPickList;
      vleProperty.ItemProps['类型'].PickList.Text := c_Typeitems;
      vleProperty.ItemProps['类型'].ReadOnly := true;
      if vDMLField.FieldType = dmlfString then
      begin
        vleProperty.InsertRow('长度', IntToStr(vDMLField.FieldLen), true);
      end
      else
      begin
        vleProperty.InsertRow('长度', '', true);
        vleProperty.ItemProps['长度'].ReadOnly := true;
      end;
      vleProperty.InsertRow('类型补充', vDMLField.FieldTypeEx, true);
      vleProperty.ItemProps['类型补充'].EditStyle := esPickList;
      vleProperty.ItemProps['类型补充'].PickList.Text := c_FieldTypeExItems;
      vleProperty.ItemProps['类型补充'].ReadOnly := true;
      vleProperty.InsertRow('控件类型', vDMLField.Editor, true);
      vleProperty.ItemProps['控件类型'].EditStyle := esPickList;
      vleProperty.ItemProps['控件类型'].PickList.Text := c_editorItems;
      vleProperty.ItemProps['控件类型'].ReadOnly := true;
      if vDMLField.Nullable then
        vleProperty.InsertRow('允许为空', 'True', true)
      else
        vleProperty.InsertRow('允许为空', 'False', true);
      vleProperty.ItemProps['允许为空'].EditStyle := esPickList;
      vleProperty.ItemProps['允许为空'].PickList.text := c_boolitems;
      vleProperty.ItemProps['允许为空'].ReadOnly := true;
      vleProperty.InsertRow('备注', vDMLField.Comment, true);
      vleProperty.ItemProps['备注'].EditStyle := esEllipsis;
      //vleProperty.RowHeights[vleProperty.RowCount - 1] := 50;
      exit;
    end;

    vleProperty.InsertRow('表名称', vDMLTable.Name, true);
    vleProperty.InsertRow('物理表名', vDMLTable.Get_PhyTbName, true);
    vleProperty.InsertRow('序列号', 'SEQ_' + vDMLTable.Get_PhyTbName, true);
    vleProperty.ItemProps['序列号'].ReadOnly := true;
    vleProperty.InsertRow('高度', floatToStr(vDMLTable.Height), true);
    vleProperty.InsertRow('宽度', floatToStr(vDMLTable.Width), true);
    if vDMLTable.AutoSize then
      vleProperty.InsertRow('自动大小', 'True', true)
    else
      vleProperty.InsertRow('自动大小', 'False', true);
    vleProperty.ItemProps['自动大小'].EditStyle := esPickList;
    vleProperty.ItemProps['自动大小'].PickList.Text := c_boolitems;
    vleProperty.ItemProps['自动大小'].ReadOnly := true;
    if vDMLTable.IsView then
      vleProperty.InsertRow('视图', 'True', true)
    else
      vleProperty.InsertRow('视图', 'False', true);
    vleProperty.ItemProps['视图'].EditStyle := esPickList;
    vleProperty.ItemProps['视图'].PickList.Text := c_boolitems;
    vleProperty.ItemProps['视图'].ReadOnly := true;
    vleProperty.InsertRow('描述', VDMLTable.Comment, true);
    vleProperty.ItemProps['描述'].EditStyle := esEllipsis;
    //vleProperty.RowHeights[vleProperty.RowCount - 1] := 50;
  end
  else if vObj.ClassNameIs('TDMLLinkObj') then
  begin
    vDMLLink := TDMLLinkObj(DMLProperty);
    vleProperty.InsertRow('对象名称', vDMLLink.Name, true);
    if (vDMLLink.LinkType = dmllLine) then
      vleProperty.InsertRow('连线类型', '直线', true)
    else if (vDMLLink.LinkType = dmllFKNormal) then
      vleProperty.InsertRow('连线类型', '外键（一对多）', true)
    else if (vDMLLink.LinkType = dmllFKUnique) then
      vleProperty.InsertRow('连线类型', '外键（一对一）', true)
    else
      vleProperty.InsertRow('连线类型', '箭头', true);
    vleProperty.ItemProps['连线类型'].PickList.Text := c_LinkTypeItems;
    vleProperty.InsertRow('内容', vDMLLink.Comment, true);
    vleProperty.ItemProps['内容'].EditStyle := esEllipsis;
    //vleProperty.RowHeights[vleProperty.RowCount - 1] := 50;
  end
  else
  begin
    //vleProperty.InsertRow('对象名称', DMLProperty.Name, true);
    //vleProperty.InsertRow('内容', DMLProperty.Comment, true);
    //vleProperty.ItemProps['内容'].EditStyle := esEllipsis;

    //vleProperty.RowHeights[vleProperty.RowCount - 1] := 50;
  end;

end;

procedure TFrameDML.vlePropertySetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  keysv: string;
  I: Integer;
begin
  keysv := vleProperty.Keys[ARow];
  if (Keysv = '高度') or
    (Keysv = '宽度') or
    (Keysv = '长度') then
  begin
    if TryStrToInt(Value, I) then
    begin
      Validate := -1;
      ValidateOld := Value;
    end
    else
      Validate := ARow;
  end
  else
    Validate := -1;
  if (Keysv = '备注') or (keysv = '描述') or (keysv = '内容') then
  begin
    if DMLProperty = nil then exit;
    if DMLProperty.ClassNameIs('TDMLTableObj') then
    begin
      if TDMLTableObj(DMLProperty).SelectedFieldIndex > 0 then
        TDMLtableObj(DMLProperty).Field[TDMLTableObj(DMLProperty).SelectedFieldIndex - 1].Comment := Value
      else
        TDMLTableObj(DMLProperty).Comment := Value;
    end
    else
      TDMLField(DMLProperty).Comment := Value;
  end;
end;

//初始化属性列表

procedure TFrameDML.InitProperty();
begin
  Exit;
  vleProperty.InsertRow('表名称', '', true);
  vleProperty.InsertRow('物理表名', '', true);
  vleProperty.InsertRow('序列号', 'SEQ_' + '', true);
  vleProperty.InsertRow('高度', '', true);
  vleProperty.InsertRow('宽度', '', true);
  vleProperty.InsertRow('自动大小', 'True', true);
  vleProperty.ItemProps['自动大小'].EditStyle := esPickList;
  vleProperty.ItemProps['自动大小'].PickList.text := c_boolitems;
  vleProperty.InsertRow('视图', 'False', true);
  vleProperty.ItemProps['视图'].EditStyle := esPickList;
  vleProperty.ItemProps['视图'].PickList.text := c_boolitems;
  vleProperty.InsertRow('备注', '', true);
  //vleProperty.RowHeights[vleProperty.RowCount - 1] := 50;
  vleProperty.ItemProps['表名称'].ReadOnly := true;

end;

procedure TFrameDML.InitCustColorDialog;
var
  cols: string;
  I: Integer;
  procedure AddCL(cl: string);
  begin
    cols := cols + 'Color' + Char(Ord('A') + I) + '=' + cl + #13#10;
    Inc(I);
  end;
begin
  cols := '';
  I := 0;
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
  ColorDialog1.CustomColors.Text := Trim(cols);
end;

procedure TFrameDML.vlePropertyValidate(Sender: TObject; ACol,
  ARow: Integer; const KeyName, KeyValue: string);
var
  dmlTbl: TDMLTableObj;
  dmlFld: TDMLField;
  dmlLink: TDMLLinkObj;
begin
  if validate <> -1 then
    vleProperty.Values[vleProperty.Keys[validate]] := validateOld;
  if not Assigned(DMLProperty) then exit;
  if DMLProperty.ClassNameIs('TDMLTableObj') then
  begin
    dmlTbl := TDMLTableObj(DMLProperty);
    if dmlTbl.SelectedFieldIndex > 0 then
    begin
      dmlFld := TDMLField(dmlTbl.Field[dmlTbl.SelectedFieldIndex - 1]);
      if KeyName = '字段名称' then
      begin
        dmlFld.Name := KeyValue;
      end
      else if KeyName = '物理名称' then
      begin
        dmlFld.PhyName := KeyValue;
      end
      else if KeyName = '类型' then
      begin
        if KeyValue <> '字符串' then
        begin
          vleProperty.Values['长度'] := '';
          vleProperty.ItemProps[3].ReadOnly := true
        end
        else
        begin
          vleProperty.ItemProps[3].ReadOnly := false;
        end;
        if KeyValue = '未知' then
          dmlFld.FieldType := dmlfUnknow
        else if
          KeyValue = '主键' then
          dmlFld.FieldType := dmlfPK
        else if
          KeyValue = '外键' then
          dmlFld.FieldType := dmlfFK
        else if
          KeyValue = '字符串' then
          dmlFld.FieldType := dmlfString
        else if
          KeyValue = '整数' then
          dmlFld.FieldType := dmlfInteger
        else if
          KeyValue = '枚举' then
          dmlFld.FieldType := dmlfEnum
        else if
          KeyValue = '浮点数' then
          dmlFld.FieldType := dmlfFloat
        else if
          KeyValue = '日期' then
          dmlFld.FieldType := dmlfDate
        else if
          KeyValue = '二进制数据' then
          dmlFld.FieldType := dmlfBlob
        else if
          KeyValue = '对象' then
          dmlFld.FieldType := dmlfObject
        else if
          KeyValue = '计算字段' then
          dmlFld.FieldType := dmlfCalculate
        else if
          KeyValue = '列表' then
          dmlFld.FieldType := dmlfList
        else if
          KeyValue = '函数' then
          dmlFld.FieldType := dmlfFunction
        else if
          KeyValue = '事件' then
          dmlFld.FieldType := dmlfEvent
        else if
          KeyValue = '其它' then
          dmlFld.FieldType := dmlfOther;
      end
      else if KeyName = '长度' then
      begin
        dmlFld.FieldLen := StrToIntDef(KeyValue, dmlFld.FieldLen);
      end
      else if KeyName = '类型补充' then
      begin
        dmlFld.FieldTypeEx := KeyValue;
      end
      else if KeyName = '控件类型' then
      begin
        dmlFld.Editor := KeyValue;
      end
      else if KeyName = '可为空' then
      begin
        if KeyValue = 'True' then
          dmlFld.Nullable := true
        else
          dmlFld.Nullable := false;
      end
      else if KeyName = '描述' then
      begin
        dmlFld.Comment := KeyValue;
      end;
    end
    else
    begin
      if KeyName = '表名称' then
      begin
        dmlTbl.Name := KeyValue;
      end
      else if KeyName = '物理表名' then
      begin
        dmlTbl.PhyTbName := KeyValue;
        vleProperty.values['序列号'] := 'SEQ_' + KeyValue;
      end
      else if KeyName = '高度' then
      begin
        dmlTbl.Height := StrToIntDef(KeyValue, Round(dmlTbl.Height));
      end
      else if KeyName = '宽度' then
      begin
        dmlTbl.Width := StrToIntDef(KeyValue, Round(dmlTbl.Width));
      end
      else if KeyName = '自动大小' then
      begin
        if KeyValue = 'True' then
        begin
          dmlTbl.AutoSize := true;
          dmlTbl.CheckResize;
        end
        else
        begin
          dmlTbl.AutoSize := false;
          dmlTbl.CheckResize;
        end;
      end
      else if KeyName = '视图' then
      begin
        if KeyValue = 'True' then
          dmlTbl.IsView := true
        else
          dmlTbl.IsView := false;
        if KeyValue = 'True' then
          dmlTbl.IsView := true
        else
          dmlTbl.IsView := false;
      end
      else if KeyName = '备注' then
      begin
        dmlTbl.Comment := KeyValue;
      end;
    end;
  end
  else if DMLProperty.ClassNameIs('TDMLLinkObj') then
  begin
    dmlLink := TDMLLinkObj(DMLProperty);
    if KeyName = '对象名称' then
      dmlLink.Name := KeyValue
    else if keyName = '连线类型' then
    begin
      if KeyValue = '直线' then
        dmlLink.LinkType := dmllLine
      else if KeyValue = '外键' then
        dmlLink.LinkType := dmllFKNormal
      else if KeyValue = '外键（一对多）' then
        dmlLink.LinkType := dmllFKNormal
      else if KeyValue = '外键（一对一）' then
        dmlLink.LinkType := dmllFKUnique
      else if KeyValue = '箭头' then
        dmlLink.LinkType := dmllDirect;
    end
    else if KeyName = '内容' then
    begin
      dmlLink.Comment := KeyValue;
    end;
  end
  else
  begin
    //if KeyName = '对象名称' then
    //  DMLProperty.Name := KeyValue
    //else if KeyName = '内容' then
    //  DMLProperty.Comment := KeyValue;
  end;
  SetDMLModified;
  DMLGraph.Refresh;

end;

procedure TFrameDML.vlePropertyGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
begin
  Validate := ARow;
  ValidateOld := Value;
end;

procedure TFrameDML.sptHideClick(Sender: TObject);
begin
  pnlProperty.Hide;
  splProperty.Hide;
  actShowHideProps.Checked := false;
end;

procedure TFrameDML.vlePropertyEditButtonClick(Sender: TObject);
var
  s: string;
begin
  S := '';
  if not PvtMemoQuery('备注', '请输入要添加的文字:', S, False) then
    Exit;
  vleProperty.Values[vleProperty.Keys[vleProperty.Row]] := s;
  if DMLProperty = nil then exit;
  if DMLProperty.ClassNameIs('TDMLTableObj') then
  begin
    if TDMLTableObj(DMLProperty).SelectedFieldIndex > 0 then
      TDMLtableObj(DMLProperty).Field[TDMLTableObj(DMLProperty).SelectedFieldIndex - 1].Comment := S
    else
      TDMLTableObj(DMLProperty).Comment := S;
  end
  else
    TDMLField(DMLProperty).Comment := S;
end;

procedure TFrameDML.vlePropertyDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  sptHide.Left := vleProperty.Width - 20;
  sptHide.Top := 1;
end;

procedure TFrameDML.actShowHidePropsExecute(Sender: TObject);
begin
  if actShowHideProps.Checked then
  begin
    pnlProperty.Show;
    splProperty.Show;
  end
  else
  begin
    splProperty.Hide;
    pnlProperty.Hide;
  end;
end;

procedure TFrameDML.actNewFlowObjExecute(Sender: TObject);
var
  S: string;
  o: TDMLFlowStepObj;
begin
  S := '';
  if not PvtInputQuery('新增流程步骤', '请输入流程步骤的名称:', S) then
    Exit;
  if S = '' then
    Exit;
  o := TDMLFlowStepObj(DMLGraph.DMLObjs.CreateDMLObj('STEP'));
  SetDMLModified;
  o.Name := S;
  o.CheckResize;
  DMLGraph.DMLObjs.ClearSelection;
  o.Selected := True;
  DMLGraphSelectObj(nil);
  DMLGraph.MakeObjVisible(o);
  DMLGraph.Refresh;
  if Assigned(Proc_OnObjAddOrRemove) then
    Proc_OnObjAddOrRemove(o, 1);
end;

procedure TFrameDML.actShowPhyViewExecute(Sender: TObject);
begin
  case DMLGraph.DMLDrawer.ShowPhyFieldName of
    0: DMLGraph.DMLDrawer.ShowPhyFieldName := 1;
    1: DMLGraph.DMLDrawer.ShowPhyFieldName := 2;
    2: DMLGraph.DMLDrawer.ShowPhyFieldName := 0;
  else
    DMLGraph.DMLDrawer.ShowPhyFieldName := 0;
  end;
  DMLGraph.Refresh;
end;

end.

