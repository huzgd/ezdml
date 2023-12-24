unit uFrameCtTableList;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ImgList, ActnList,
  CTMetaData, CtMetaTable, StdCtrls, ExtCtrls;

type

  { TFrameCtTableList }

  TFrameCtTableList = class(TFrame)
    actCamelCaseToUnderline: TAction;
    actCnWordSegment: TAction;
    actPasteAsCopy: TAction;
    actUnderlineToCamelCase: TAction;
    MN_RESERVED5: TMenuItem;
    MNPasteAsCopy: TMenuItem;
    MN_CamelCasetoUnderline1: TMenuItem;
    MN_UnderlinetoCamelCase1: TMenuItem;
    TreeViewCttbs: TTreeView;
    ActionListCtTree: TActionList;
    actRefresh: TAction;
    actDelete: TAction;
    actRename: TAction;
    actProperty: TAction;
    actExpand: TAction;
    actNewTable: TAction;
    PopupMenuCtTree: TPopupMenu;
    MN_NewTable: TMenuItem;
    MN_Delete: TMenuItem;
    MN_Rename: TMenuItem;
    MN_Spxx0002: TMenuItem;
    MN_Expand: TMenuItem;
    MN_Refresh: TMenuItem;
    MN_Property: TMenuItem;
    MN_Spxx0001: TMenuItem;
    ImageListCttb: TImageList;
    actNewField: TAction;
    MN_NewField: TMenuItem;
    MN_RESERVED1: TMenuItem;
    MN_RESERVED2: TMenuItem;
    MN_Spxx0003: TMenuItem;
    actSelAll: TAction;
    N1: TMenuItem;
    PanelTop: TPanel;
    edtTbFilter: TEdit;
    actCopyTb: TAction;
    actPasteTb: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    actNewModel: TAction;
    actNewModel1: TMenuItem;
    actCapUppercase: TAction;
    actCapLowercase: TAction;
    actAutoCapitalize: TAction;
    actExchangeDispComm: TAction;
    actExchangeNameDisp: TAction;
    MN_Capitalize: TMenuItem;
    MN_AutoCapitalize1: TMenuItem;
    MNAllUpperCase1: TMenuItem;
    MnAllLowercase: TMenuItem;
    MNCommentstoLogicName1: TMenuItem;
    MNNametoLogicName1: TMenuItem;
    actCheckWithMyDict: TAction;
    MNCheckwithMyDicttxt1: TMenuItem;
    N4_Splite0004: TMenuItem;
    MN_RESERVED3: TMenuItem;
    actConvertChnToPy: TAction;
    MNConvertChinesetoPinYin1: TMenuItem;
    btnClearFilter: TButton;
    MN_RESERVED4: TMenuItem;
    actCopyText: TAction;
    MN_CopyText: TMenuItem;
    TimerTbFilter: TTimer;
    actSortTablesByName: TAction;
    MN_SortTbsByName: TMenuItem;
    actFindInGraph: TAction;
    MN_FindInGraph: TMenuItem;
    procedure actCamelCaseToUnderlineExecute(Sender: TObject);
    procedure actCnWordSegmentExecute(Sender: TObject);
    procedure actPasteAsCopyExecute(Sender: TObject);
    procedure actUnderlineToCamelCaseExecute(Sender: TObject);
    procedure TimerTbFilterTimer(Sender: TObject);
    procedure btnClearFilterClick(Sender: TObject);
    procedure actCheckWithMyDictExecute(Sender: TObject);
    procedure actExchangeNameDispExecute(Sender: TObject);
    procedure actExchangeDispCommExecute(Sender: TObject);
    procedure actAutoCapitalizeExecute(Sender: TObject);
    procedure actCapLowercaseExecute(Sender: TObject);
    procedure actCapUppercaseExecute(Sender: TObject);
    procedure actNewModelExecute(Sender: TObject);
    procedure PopupMenuCtTreePopup(Sender: TObject);
    procedure actPasteTbExecute(Sender: TObject);
    procedure actCopyTbExecute(Sender: TObject);
    procedure actSelAllExecute(Sender: TObject);
    procedure edtTbFilterExit(Sender: TObject);
    procedure edtTbFilterEnter(Sender: TObject);
    procedure edtTbFilterChange(Sender: TObject);
    procedure TreeViewCttbsKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure actDeleteExecute(Sender: TObject);
    procedure TreeViewCttbsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure TreeViewCttbsChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewCttbsEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure actExpandExecute(Sender: TObject);
    procedure actRenameExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actNewTableExecute(Sender: TObject);
    procedure TreeViewCttbsDragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: boolean);
    procedure actNewFieldExecute(Sender: TObject);
    procedure TreeViewCttbsDragDrop(Sender, Source: TObject; X, Y: integer);
    procedure actPropertyExecute(Sender: TObject);
    procedure TreeViewCttbsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure TreeViewCttbsEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: boolean);
    procedure actConvertChnToPyExecute(Sender: TObject);
    procedure TreeViewCttbsChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: boolean);
    procedure actCopyTextExecute(Sender: TObject);
    procedure actSortTablesByNameExecute(Sender: TObject);
    procedure edtTbFilterKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure actFindInGraphExecute(Sender: TObject);
    procedure TreeViewCttbsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: boolean);
  private
    FCtDataModelList: TCtDataModelGraphList;
    FRightClickNode: TTreeNode;
    FAltFocusNode: TTreeNode;
    FAltFocusTick: int64;
    FLastMouseDownTick: int64;
    FSettingSelectedNode: boolean;
    FOnSelectedChange: TNotifyEvent;
    FReadOnlyMode: boolean;
    FTbFilter: string;
    FFilterMode: integer; //1table 2field
    FTbFilterIniting: boolean;
    FOnShowNodeProp: TNotifyEvent;
    FTreeRefreshing: boolean;
    FOnAltNodeClick: TTVChangedEvent;
    function GetCtTableList: TCtMetaTableList;
    function GetCurCtNode: TCtMetaObject;
    function GetCurTreeNode: TTreeNode;
    function GetRightClickTreeNode: TCtMetaObject;
    function GetSelectedCtNode: TCtMetaObject;
    procedure SetOnShowNodeProp(const Value: TNotifyEvent);
    function GetImageIndexOfCtNode(Nd: TCtObject; bSelected: boolean = False): integer;
    procedure SetSelectedCtNode(const Value: TCtMetaObject);

    procedure DoCapitalizeProc(sType: string);
    procedure ExpandCtTreeNode(Node: TTreeNode); virtual;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init(ACtDataModelList: TCtDataModelGraphList; bReadOnly: boolean);

    procedure CheckActions;

    procedure RefreshTheTree; virtual;
    procedure RefreshSelected; virtual;
    procedure RefreshNode(ANode: TTreeNode); virtual;
    procedure RefreshNodeChild(ANode: TTreeNode); virtual;
    procedure MoveTreeNodeOnly(ACtNode1, ACtNode2: TCtMetaObject); virtual;
    procedure RefreshObj(ACtNode: TCtMetaObject); virtual;
    procedure RefreshOtherSameNameTbs(ACtNode: TCtMetaObject); virtual;

    function CheckCtObjFilter(ACtObj: TCtMetaObject): boolean;

    function AddNodeToTree(PNode: TTreeNode; ACtNode: TCtMetaObject): TTreeNode;
    procedure DeleteSelectedNodes(bConfirm: Boolean = True);

    function GetCtNodeOfTreeNode(Node: TTreeNode): TCtMetaObject;
    function GetTreeNodeOfCtNode(ACtobj: TCtMetaObject): TTreeNode;   
    procedure FocusToTable(ATbName: string);
    procedure FocusSibling(bUp: Boolean);

    procedure NewCtModelNode;
    procedure NewCtTableNode;
    procedure NewCtFieldNode;

    procedure DoCopyTb(bCutMode: Boolean);

    property CtDataModelList: TCtDataModelGraphList read FCtDataModelList;
    property CtTableList: TCtMetaTableList read GetCtTableList;
    property SelectedCtNode: TCtMetaObject read GetSelectedCtNode
      write SetSelectedCtNode;

    property RightClickNode: TTreeNode read FRightClickNode write FRightClickNode;
    property RightClickTreeNode: TCtMetaObject read GetRightClickTreeNode;
    property CurTreeNode: TTreeNode read GetCurTreeNode;
    property CurCtNode: TCtMetaObject read GetCurCtNode;
    property OnSelectedChange: TNotifyEvent read FOnSelectedChange
      write FOnSelectedChange;
    property OnShowNodeProp: TNotifyEvent read FOnShowNodeProp write SetOnShowNodeProp;
    property OnAltNodeClick: TTVChangedEvent read FOnAltNodeClick write FOnAltNodeClick;
  end;


implementation

{$R *.lfm}

uses
  CtObjXmlSerial, ClipBrd, dmlstrs, AutoNameCapitalize, WindowFuncs;

{ TFrameCtTree }

procedure TFrameCtTableList.actAutoCapitalizeExecute(Sender: TObject);
begin
  DoCapitalizeProc('AutoCapitalize');
end;

procedure TFrameCtTableList.actCapLowercaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('LowerCase');
end;

procedure TFrameCtTableList.actCapUppercaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('UpperCase');
end;

procedure TFrameCtTableList.actCheckWithMyDictExecute(Sender: TObject);
begin
  DoCapitalizeProc('CheckMyDict');
end;

procedure TFrameCtTableList.actConvertChnToPyExecute(Sender: TObject);
begin
  DoCapitalizeProc('ChnToPY');
end;

procedure TFrameCtTableList.actCopyTbExecute(Sender: TObject);     
begin
  DoCopyTb(False);
end;

procedure TFrameCtTableList.DoCopyTb(bCutMode: Boolean);
var
  I, mdc, tbc, fldc: integer;
  vMd: TCtDataModelGraph;
  vTempMds: TCtDataModelGraphList;
  vTb: TCtMetaTable;
  vTempTbs: TCtMetaTableList;
  vFld: TCtMetaField;
  vTempFlds: TCtMetaFieldList;
  fs: TCtObjMemXmlStream;
  ss: TStringList;
begin
  mdc := 0;
  tbc := 0;
  fldc := 0;
  for I := 0 to TreeViewCttbs.Items.Count - 1 do
    if TreeViewCttbs.Items[I].Selected then
      if TreeViewCttbs.Items[I].Data <> nil then
      begin
        if TObject(TreeViewCttbs.Items[I].Data) is TCtDataModelGraph then
        begin
          Inc(mdc);
        end
        else if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
        begin
          Inc(tbc);
        end
        else if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaField then
        begin
          Inc(fldc);
        end;
      end;

  if mdc > 0 then
  begin
    vTempMds := TCtDataModelGraphList.Create;
    fs := TCtObjMemXmlStream.Create(False);
    ss := TStringList.Create;
    Screen.Cursor := crAppStart;
    try
      for I := 0 to TreeViewCttbs.Items.Count - 1 do
        if TreeViewCttbs.Items[I].Selected then
          if TreeViewCttbs.Items[I].Data <> nil then
            if TObject(TreeViewCttbs.Items[I].Data) is TCtDataModelGraph then
            begin
              vMd := vTempMds.NewModelItem;
              vMd.AssignFrom(TCtDataModelGraph(TreeViewCttbs.Items[I].Data));
            end;
      fs.RootName := 'DataModels';
      vTempMds.SaveToSerialer(fs);
      fs.Stream.Seek(0, soFromBeginning);
      ss.LoadFromStream(fs.Stream);
      Clipboard.AsText := ss.Text;
    finally
      vTempMds.Free;
      fs.Free;
      ss.Free;
      Screen.Cursor := crDefault;
    end;   
    if bCutMode then
      DeleteSelectedNodes(False);
    Exit;
  end;

  if tbc > 0 then
  begin
    vTempTbs := TCtMetaTableList.Create;
    fs := TCtObjMemXmlStream.Create(False);
    ss := TStringList.Create;
    Screen.Cursor := crAppStart;
    try
      for I := 0 to TreeViewCttbs.Items.Count - 1 do
        if TreeViewCttbs.Items[I].Selected then
          if TreeViewCttbs.Items[I].Data <> nil then
            if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
            begin
              vTb := vTempTbs.NewTableItem;
              vTb.AssignFrom(TCtMetaTable(TreeViewCttbs.Items[I].Data));
              vTb.GraphDesc := '';
            end;
      fs.RootName := 'Tables';
      vTempTbs.SaveToSerialer(fs);
      fs.Stream.Seek(0, soFromBeginning);
      ss.LoadFromStream(fs.Stream);
      Clipboard.AsText := ss.Text;
    finally
      vTempTbs.Free;
      fs.Free;
      ss.Free;
      Screen.Cursor := crDefault;
    end;   
    if bCutMode then
      DeleteSelectedNodes(False);
    Exit;
  end;

  if fldc > 0 then
  begin
    vTempFlds := TCtMetaFieldList.Create;
    fs := TCtObjMemXmlStream.Create(False);
    ss := TStringList.Create;
    try
      for I := 0 to TreeViewCttbs.Items.Count - 1 do
        if TreeViewCttbs.Items[I].Selected then
          if TreeViewCttbs.Items[I].Data <> nil then
            if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaField then
            begin
              vFld := vTempFlds.NewMetaField;
              vFld.AssignFrom(TCtMetaField(TreeViewCttbs.Items[I].Data));
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
    if bCutMode then
      DeleteSelectedNodes(False);
    Exit;
  end;
end;

procedure TFrameCtTableList.actCopyTextExecute(Sender: TObject);
var
  I: integer;
  S: string;
begin
  if not TreeViewCttbs.CanFocus then
    Exit;
  S := '';
  for I := 0 to TreeViewCttbs.Items.Count - 1 do
    if TreeViewCttbs.Items[I].Selected then
    begin
      if S <> '' then
        S := S + #13#10;
      S := S + TreeViewCttbs.Items[I].Text;
    end;
  if S <> '' then
    ClipBrd.Clipboard.AsText := S;
end;

procedure TFrameCtTableList.actDeleteExecute(Sender: TObject);
begin
  DeleteSelectedNodes;
end;

procedure TFrameCtTableList.actExchangeDispCommExecute(Sender: TObject);
begin
  DoCapitalizeProc('CommentToLogicName');
end;

procedure TFrameCtTableList.actExchangeNameDispExecute(Sender: TObject);
begin
  DoCapitalizeProc('NameToLogicName');
end;

procedure TFrameCtTableList.actExpandExecute(Sender: TObject);
begin
  if Assigned(CurTreeNode) then
    CurTreeNode.Expand(True);
end;

procedure TFrameCtTableList.actFindInGraphExecute(Sender: TObject);
begin
  FAltFocusNode := TreeViewCttbs.Selected;
  if FAltFocusNode <> nil then
  begin
    if Assigned(OnAltNodeClick) then
    begin
      OnAltNodeClick(Sender, FAltFocusNode);
    end;
  end;
end;

procedure TFrameCtTableList.actNewTableExecute(Sender: TObject);
begin
  NewCtTableNode;
end;

procedure TFrameCtTableList.actRefreshExecute(Sender: TObject);
begin
  RefreshTheTree;
end;

procedure TFrameCtTableList.actRenameExecute(Sender: TObject);
var
  vNode: TTreeNode;
begin
  if FReadOnlyMode then
    Exit;
  CheckCanEditMeta;
  vNode := CurTreeNode;
  if Assigned(vNode) then
  begin
    vNode.EditText;
  end;
end;

procedure TFrameCtTableList.actSelAllExecute(Sender: TObject);
var
  VNode: TTreeNode;
  I: integer;
begin
  vNode := CurTreeNode;
  if Assigned(vNode) and Assigned(vNode.Data) and
    (TObject(vNode.Data) is TCtMetaField) then
  begin
    vNode := vNode.Parent;
    if vNode <> nil then
    begin
      TreeViewCttbs.ClearSelection();
      for I := 0 to vNode.Count - 1 do
        TreeViewCttbs.Select(vNode.Items[I], [ssCtrl]);
      Exit;
    end;
  end;

  vNode := TreeViewCttbs.Items.GetFirstNode;
  if vNode <> nil then
  begin
    TreeViewCttbs.ClearSelection();
    for I := 0 to vNode.Count - 1 do
      TreeViewCttbs.Select(vNode.Items[I], [ssCtrl]);
    Exit;
  end;
end;

procedure TFrameCtTableList.actSortTablesByNameExecute(Sender: TObject);
begin
  if FCtDataModelList = nil then
    Exit
  else if FCtDataModelList.CurDataModel = nil then
    Exit;
  CheckCanEditMeta;
  if Application.MessageBox(PChar(srConfirmSortTablesByName),
    PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
    Exit;
  FCtDataModelList.CurDataModel.Tables.SortByName;
  FCtDataModelList.CurDataModel.Tables.SaveCurrentOrder;
  RefreshTheTree;
end;

function TFrameCtTableList.AddNodeToTree(PNode: TTreeNode;
  ACtNode: TCtMetaObject): TTreeNode;
var
  I: integer;
  VNode: TTreeNode;
  S: string;
begin
  Result := nil;
  if not Assigned(ACtNode) or (ACtNode.DataLevel = ctdlDeleted) or
    not CheckCtObjFilter(ACtNode) then
    Exit;
  S := ACtNode.NameCaption;
  vNode := TreeViewCttbs.Items.AddChild(PNode, S);
  with vNode do
  begin
    ImageIndex := GetImageIndexOfCtNode(ACtNode);
    SelectedIndex := GetImageIndexOfCtNode(ACtNode, True);
    Data := ACtNode;
  end;
  if ACtNode is TCtDataModelGraph then
  begin
    if FTbFilter <> '' then
    begin
      FFilterMode := 1;
      with TCtDataModelGraph(ACtNode).Tables do
        for I := 0 to Count - 1 do
          AddNodeToTree(VNode, Items[I]);
      FFilterMode := 2;
      with TCtDataModelGraph(ACtNode).Tables do
        for I := 0 to Count - 1 do
          AddNodeToTree(VNode, Items[I]);
    end
    else
      with TCtDataModelGraph(ACtNode).Tables do
        for I := 0 to Count - 1 do
          AddNodeToTree(VNode, Items[I]);
  end;

  if ACtNode is TCtMetaTable then
  begin
    VNode.HasChildren := True;
    {if FCtDataModelList.IsHuge then
      VNode.HasChildren := True
    else
      with TCtMetaTable(ACtNode).MetaFields do
        for I := 0 to Count - 1 do
          AddNodeToTree(VNode, Items[I]);}
  end;
  Result := vNode;
end;

procedure TFrameCtTableList.btnClearFilterClick(Sender: TObject);
begin
  edtTbFilter.Text := '';
  edtTbFilterChange(nil);
  edtTbFilter.SetFocus;
end;

constructor TFrameCtTableList.Create(AOwner: TComponent);
begin
  inherited;
  TabStop := False;
end;

procedure TFrameCtTableList.DeleteSelectedNodes(bConfirm: Boolean);

  function TreeNodePSelected(ANode: TTreeNode): boolean;
  begin
    Result := False;
    if ANode = nil then
      Exit;
    if ANode.Parent = nil then
      Exit;
    if ANode.Parent.Selected then
      Result := True
    else
      Result := TreeNodePSelected(ANode.Parent);
  end;

var
  vNode, sNode: TTreeNode;
  vCtNode: TCtMetaObject;
  I, mdc, tbc, fldc: integer;
  vDelNodes, vRefreshTbs: TList;
  S: string;
begin
  if FReadOnlyMode then
    Exit;
  CheckCanEditMeta;

  mdc := 0;
  tbc := 0;
  fldc := 0;
  S := '';
  for I := 0 to TreeViewCttbs.Items.Count - 1 do
    if TreeViewCttbs.Items[I].Selected then
    begin
      vNode := TreeViewCttbs.Items[I];
      if not TreeNodePSelected(vNode) then
      begin
        S := vNode.Text;
        if vNode.Data <> nil then
          if TObject(vNode.Data) is TCtDataModelGraph then
            Inc(mdc)
          else if TObject(vNode.Data) is TCtMetaTable then
            Inc(tbc)
          else if TObject(vNode.Data) is TCtMetaField then
            Inc(fldc);
      end;
    end;
  if (mdc + tbc + fldc) = 0 then
    Exit;
  if bConfirm then
  begin
    if ((mdc + tbc + fldc) = 1) and (S <> '') then
      S := Format(srConfirmDeleteSelectedNodeFmt, [S])
    else
      S := Format(srConfirmDeleteSelectedNodesFmt, [(mdc + tbc + fldc)]);
    if Application.MessageBox(PChar(S), PChar(Application.Title),
      MB_OKCANCEL or MB_ICONWARNING) <> idOk then
      Exit;
  end;
  if (mdc + tbc + fldc) = 1 then
  begin
    vNode := CurTreeNode;
    vCtNode := CurCtNode;
    if Assigned(vNode) then
    begin
      sNode := vNode.getPrevSibling;
      if Assigned(sNode) then
        TreeViewCttbs.Selected := sNode;
      vNode.Delete;
    end;
    if Assigned(vCtNode) then
    begin
      vCtNode.DataLevel := ctdlDeleted;
      if vCtNode is TCtMetaField then
      begin
        DoTablePropsChanged(TCtMetaField(vCtNode).OwnerTable);
        RefreshOtherSameNameTbs(vCtNode);
      end;
    end;
  end
  else
  begin
    vDelNodes := TList.Create;
    vRefreshTbs := TList.Create;
    try
      for I := TreeViewCttbs.Items.Count - 1 downto 0 do
        if TreeViewCttbs.Items[I].Selected then
          if TreeViewCttbs.Items[I].Data <> nil then
            if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaObject then
            begin
              vNode := TreeViewCttbs.Items[I];
              vCtNode := GetCtNodeOfTreeNode(vNode);
              if not TreeNodePSelected(vNode) then
              begin
                vDelNodes.Add(vNode);
                if Assigned(vCtNode) then
                begin
                  vCtNode.DataLevel := ctdlDeleted;
                  if vCtNode is TCtMetaField then
                    if TCtMetaField(vCtNode).OwnerTable <> nil then
                      if vRefreshTbs.IndexOf(TCtMetaField(vCtNode).OwnerTable) < 0 then
                        vRefreshTbs.Add(TCtMetaField(vCtNode).OwnerTable);
                end;
              end;
            end;

      for I := vDelNodes.Count - 1 downto 0 do
        TTreeNode(vDelNodes.Items[I]).Delete;
      for I := vRefreshTbs.Count - 1 downto 0 do
      begin
        DoTablePropsChanged(TCtMetaTable(vRefreshTbs.Items[I]));
        RefreshOtherSameNameTbs(TCtMetaTable(vRefreshTbs.Items[I]));
      end;
    finally
      vDelNodes.Free;
      vRefreshTbs.Free;
    end;
  end;

  if TreeViewCttbs.Items.Count = 0 then
    if CtDataModelList.CurDataModel <> nil then
      actRefresh.Execute;
end;

destructor TFrameCtTableList.Destroy;
begin
  inherited;
end;

procedure TFrameCtTableList.edtTbFilterChange(Sender: TObject);
var
  S: string;
begin
  if FTbFilterIniting then
    Exit;
  S := FTbFilter;
  FTbFilter := Trim(LowerCase(edtTbFilter.Text));
  if FTbFilter = srFilter then
  begin
    Exit;
  end;
  if FTbFilter = '' then
    btnClearFilter.Hide
  else
    btnClearFilter.Show;
  if S = FTbFilter then
    Exit;
  TimerTbFilter.Enabled := False;
  TimerTbFilter.Enabled := True;
end;

procedure TFrameCtTableList.edtTbFilterEnter(Sender: TObject);
begin
  if FTbFilterIniting then
    Exit;
  FTbFilterIniting := True;
  if edtTbFilter.Text = srFilter then
    edtTbFilter.Text := '';
  FTbFilterIniting := False;
end;

procedure TFrameCtTableList.edtTbFilterExit(Sender: TObject);
begin
  if FTbFilterIniting then
    Exit;
  FTbFilterIniting := True;
  if edtTbFilter.Text = '' then
    edtTbFilter.Text := srFilter;
  FTbFilterIniting := False;
end;

procedure TFrameCtTableList.edtTbFilterKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    edtTbFilter.Text := '';
    try
      TreeViewCttbs.SetFocus;
    except
    end;
  end
  else if Key = VK_RETURN then
  begin
    try
      TreeViewCttbs.SetFocus;
    except
    end;
  end;
end;

function TFrameCtTableList.GetCtNodeOfTreeNode(Node: TTreeNode): TCtMetaObject;
begin
  if Assigned(Node) and Assigned(Node.Data) then
    Result := TCtMetaObject(Node.Data)
  else
    Result := nil;
end;

function TFrameCtTableList.GetCtTableList: TCtMetaTableList;
begin
  if FCtDataModelList = nil then
    Result := nil
  else
    Result := FCtDataModelList.CurDataModel.Tables;
end;

function TFrameCtTableList.GetCurCtNode: TCtMetaObject;
begin
  Result := GetCtNodeOfTreeNode(CurTreeNode);
end;

function TFrameCtTableList.GetCurTreeNode: TTreeNode;
begin
  if Assigned(FRightClickNode) then
    Result := FRightClickNode
  else
    Result := TreeViewCttbs.Selected;
end;

function TFrameCtTableList.GetRightClickTreeNode: TCtMetaObject;
begin
  Result := GetCtNodeOfTreeNode(FRightClickNode);
end;

function TFrameCtTableList.GetSelectedCtNode: TCtMetaObject;
begin
  Result := GetCtNodeOfTreeNode(TreeViewCttbs.Selected);
end;

procedure TFrameCtTableList.NewCtTableNode;
var
  ctnode: TCtMetaTable;
  vNode: TTreeNode;
begin
  if FReadOnlyMode then
    Exit;
  CheckCanEditMeta;
  ctnode := CtTableList.NewTableItem;
  if Assigned(Proc_ShowCtTableProp) then
  begin
    if not Proc_ShowCtTableProp(ctnode, False, True) then
    begin
      CtTableList.Remove(ctnode);
      Exit;
    end;
  end;
  vNode := TreeViewCttbs.Selected;
  if vNode = nil then
    vNode := TreeViewCttbs.Items.GetFirstNode
  else
    while vNode.Parent <> nil do
      vNode := vNode.Parent;
  {vNode := } AddNodeToTree(vNode, ctnode);
end;

procedure TFrameCtTableList.PopupMenuCtTreePopup(Sender: TObject);
begin
  CheckActions;
end;

procedure TFrameCtTableList.RefreshSelected;
var
  Node: TTreeNode;
  ctNd: TCtMetaObject;
begin
  Node := TreeViewCttbs.Selected;
  ctNd := SelectedCtNode;
  if not Assigned(Node) or not Assigned(ctNd) then
    Exit;

  RefreshNode(Node);
  RefreshNodeChild(Node);
end;

procedure TFrameCtTableList.RefreshTheTree;
var
  I: integer;
  rNode, nd, psNode: TTreeNode;
  cto, cto1, cto2: TCtMetaObject;
  ctl: TCtMetaObjectList;
  bExped: boolean;
  cr: TCursor;
begin
  if FTreeRefreshing then
    Exit;
  ctl := TCtMetaObjectList.Create;
  TreeViewCttbs.Items.BeginUpdate;
  FTreeRefreshing := True;
  cr := Screen.Cursor;
  try
    ctl.AutoFree := False;
    for I := 0 to TreeViewCttbs.Items.Count - 1 do
      if TreeViewCttbs.Items[I].Selected then
        if TreeViewCttbs.Items[I].Data <> nil then
          if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
            ctl.Add(TreeViewCttbs.Items[I].Data);

    if Assigned(TreeViewCttbs.Selected) then
      bExped := TreeViewCttbs.Selected.Expanded
    else
      bExped := False;
    cto := SelectedCtNode;    
    cto1 := nil;
    cto2 := nil;

    if Assigned(TreeViewCttbs.Selected) and Assigned(cto) then
    begin
      if (cto is TCtMetaField) and Assigned(TreeViewCttbs.Selected.Parent) and Assigned(TreeViewCttbs.Selected.Parent.Parent) then
      begin
        cto1 := GetCtNodeOfTreeNode(TreeViewCttbs.Selected.Parent);
        cto2 := GetCtNodeOfTreeNode(TreeViewCttbs.Selected.Parent.Parent);
      end;
    end;
    if Assigned(TreeViewCttbs.Selected) and Assigned(cto) then
    begin
      if (cto is TCtMetaTable) and Assigned(TreeViewCttbs.Selected.Parent) then
      begin
        cto1 := GetCtNodeOfTreeNode(TreeViewCttbs.Selected.Parent);
      end;
    end;

    TreeViewCttbs.Items.Clear;

    rNode := nil;

    if FCtDataModelList = nil then
      Exit;

    if FCtDataModelList.IsHuge then
      Screen.Cursor := crAppStart;

    if FCtDataModelList.Count > 1 then
      TreeViewCttbs.ShowRoot := True
    else
      TreeViewCttbs.ShowRoot := False;

    CtDataModelList.SortByOrderNo;

    for I := 0 to CtDataModelList.Count - 1 do
    begin
      nd := AddNodeToTree(rNode, CtDataModelList.Items[I]);
      if nd <> nil then
        if Self.FTbFilter <> '' then
          if nd.Count = 0 then
            nd.Delete;
    end;

    psNode := nil;
    if Assigned(cto2) then
    begin
      rNode := GetTreeNodeOfCtNode(cto2);
      if rNode <> nil then
      begin
        ExpandCtTreeNode(rNode);
        rNode.Expand(False);
        psNode := rNode;
      end;
    end;
    if Assigned(cto1) then
    begin
      rNode := GetTreeNodeOfCtNode(cto1);
      if rNode <> nil then
      begin         
        ExpandCtTreeNode(rNode);
        rNode.Expand(False);
        psNode := rNode;
      end;
    end;

    rNode := GetTreeNodeOfCtNode(cto);
    if rNode <> nil then
    begin
      TreeViewCttbs.Selected := rNode;
      if bExped then
      begin
        ExpandCtTreeNode(rNode);
        rNode.Expand(False);
      end;
    end
    else if psNode <> nil then
      TreeViewCttbs.Selected := psNode
    else
      TreeViewCttbs.Selected := TreeViewCttbs.Items.GetFirstNode;

    if TreeViewCttbs.Selected = nil then
    begin
      if TreeViewCttbs.Items.GetFirstNode <> nil then
        TreeViewCttbs.Items.GetFirstNode.Expand(False);
    end
    else if TreeViewCttbs.Selected.Parent = nil then
      TreeViewCttbs.Selected.Expand(False);

    if ctl.Count > 0 then
    begin
      TreeViewCttbs.OnChange := nil;
      for I := 0 to TreeViewCttbs.Items.Count - 1 do
        if TreeViewCttbs.Items[I].Data <> nil then
          if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
            if ctl.IndexOf(TreeViewCttbs.Items[I].Data) >= 0 then
              if not TreeViewCttbs.Items[I].Selected then
                TreeViewCttbs.Select(TreeViewCttbs.Items[I], [ssCtrl]);
    end;
  finally
    TreeViewCttbs.OnChange := TreeViewCttbsChange;
    TreeViewCttbs.Items.EndUpdate;
    ctl.Free;
    FTreeRefreshing := False;
    Screen.Cursor := cr;
  end;
end;

procedure TFrameCtTableList.TimerTbFilterTimer(Sender: TObject);
begin
  TimerTbFilter.Enabled := False;
  RefreshTheTree;
end;

procedure TFrameCtTableList.actCamelCaseToUnderlineExecute(Sender: TObject);
begin
  DoCapitalizeProc('CamelCaseToUnderline');
end;

procedure TFrameCtTableList.actCnWordSegmentExecute(Sender: TObject);
begin
  DoCapitalizeProc('CnWordSegment');
end;

procedure TFrameCtTableList.actPasteAsCopyExecute(Sender: TObject);
begin
  actPasteTbExecute(nil);
end;

procedure TFrameCtTableList.actUnderlineToCamelCaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('UnderlineToCamelCase');
end;

procedure TFrameCtTableList.TreeViewCttbsChange(Sender: TObject; Node: TTreeNode);
var
  vNode: TTreeNode;
  I, iExp: Integer;
begin
  FRightClickNode := nil;
  vNode := TreeViewCttbs.Selected;
  if Assigned(vNode) then
  begin
    if vNode.Parent = nil then
      if Abs(GetTickCount64 - FLastMouseDownTick) < 500 then
      begin
        iExp := 0;
        for I:=0 to TreeViewCttbs.Items.Count - 1 do
          if TreeViewCttbs.Items[I].Parent = nil then
          begin
            if TreeViewCttbs.Items[I].Expanded then
            begin
              Inc(iExp);
            end;
          end;

        if iExp = 1 then
          for I:=0 to TreeViewCttbs.Items.Count - 1 do
            if TreeViewCttbs.Items[I].Parent = nil then
            begin
              if TreeViewCttbs.Items[I].Expanded then
              begin
                if TreeViewCttbs.Items[I] <> vNode then
                  TreeViewCttbs.Items[I].Collapse(False);
              end else
              begin
                if TreeViewCttbs.Items[I] = vNode then
                  TreeViewCttbs.Items[I].Expand(False);
              end;
            end;
      end;
    while vNode.Parent <> nil do
      vNode := vNode.Parent;
    if TObject(vNode.Data) is TCtDataModelGraph then
      FCtDataModelList.CurDataModel := TCtDataModelGraph(vNode.Data);
  end;
  CheckActions;
  if Assigned(FOnSelectedChange) and not FTreeRefreshing then
    FOnSelectedChange(Self);
end;

procedure TFrameCtTableList.TreeViewCttbsChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: boolean);
begin
  if FSettingSelectedNode then
    Exit;
  FAltFocusNode := nil;
  FAltFocusTick := 0;
  if (GetKeyState(VK_MENU) and $80) <> 0 then
  begin
    FAltFocusNode := Node;
    FAltFocusTick := GetTickCount64;
    AllowChange := False;
  end;
end;

procedure TFrameCtTableList.TreeViewCttbsEdited(Sender: TObject;
  Node: TTreeNode; var S: string);
var
  vCtNode: TCtMetaObject;
  po, len: integer;
  str, cap: string;
begin
  if FReadOnlyMode then
    Exit;
  CheckCanEditMeta;
  vCtNode := GetCtNodeOfTreeNode(Node);
  if Assigned(vCtNode) then
  begin            
    if vCtNode.NameCaption=S then
      Exit;
    po := Pos('(', S);
    len := Length(S);
    if (po > 1) and (s[len] = ')') then
    begin
      str := Copy(S, 1, po - 1);
      cap := Copy(S, po + 1, len - po - 1);
    end
    else
    begin
      str := S;
      cap := '';
    end;  
    if vCtNode.Name=str then
    begin
      if cap='' then
        Exit;       
      if vCtNode is TCtMetaField then
        if TCtMetaField(vCtNode).DisplayName = cap then
          Exit;
      if vCtNode.Caption = cap then
        Exit;
    end;
    if vCtNode is TCtMetaTable then
      if not CheckCanRenameTable(TCtMetaTable(vCtNode), str, False) then
      begin
        RefreshNode(Node);
        Abort;
      end; 
    if vCtNode is TCtMetaField then
    begin
      if not TCtMetaField(vCtNode).CheckCanRenameTo(str) then
      begin
        RefreshNode(Node);
        Abort;
      end;
      if TCtMetaField(vCtNode).OldName = '' then
        TCtMetaField(vCtNode).OldName:=vCtNode.Name;
    end;

    if vCtNode is TCtDataModelGraph then
      if not TCtDataModelGraph(vCtNode).CheckCanRenameTo(str) then
      begin
        RefreshNode(Node);
        Abort;
      end;

    vCtNode.Name := str;
    if cap <> '' then
    begin
      if vCtNode is TCtMetaField then
        TCtMetaField(vCtNode).DisplayName := cap
      else
        vCtNode.Caption := cap;
    end;        
    if vCtNode is TCtMetaField then
    begin
      DoTablePropsChanged(TCtMetaField(vCtNode).OwnerTable);
    end;
    if Assigned(FOnSelectedChange) then
      FOnSelectedChange(Self);
  end;
end;

procedure TFrameCtTableList.TreeViewCttbsKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
      VK_F2:
        actRename.Execute;
      VK_DELETE:
        if not TreeViewCttbs.IsEditing then
          actDelete.Execute;
    end;

  if [ssCtrl] = Shift then
  begin
    case Key of
      Ord('C'):
        DoCopyTb(False);
      Ord('X'):
        DoCopyTb(True);
      Ord('V'):
        actPasteTb.Execute;
    end;
  end
end;

procedure TFrameCtTableList.TreeViewCttbsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  pt: TPoint;
  tk: int64;
begin
  FRightClickNode := nil;
  if Button = mbRight then
  begin
    FRightClickNode := TreeViewCttbs.Selected;
    pt := TreeViewCttbs.ClientToScreen(Point(X, Y));
    PopupMenuCtTree.Popup(pt.X, pt.Y);
  end;

  if Button = mbLeft then
    if ssAlt in Shift then
      if FAltFocusNode <> nil then
      begin
        if TreeViewCttbs.GetNodeAt(X, Y) <> FAltFocusNode then
        begin
          FAltFocusNode := nil;
        end;
        tk := GetTickCount64;
        if Abs(tk - FAltFocusTick) > 1000 then
        begin
          FAltFocusNode := nil;
        end;
        if FAltFocusNode <> nil then
        begin
          if Assigned(OnAltNodeClick) then
          begin
            OnAltNodeClick(Sender, FAltFocusNode);
          end;
        end;
      end;
end;

procedure TFrameCtTableList.TreeViewCttbsDragOver(Sender, Source: TObject;
  X, Y: integer; State: TDragState; var Accept: boolean);
begin
  Accept := (Source = TreeViewCttbs) and not FReadOnlyMode;
end;

procedure TFrameCtTableList.actNewFieldExecute(Sender: TObject);
begin
  NewCtFieldNode;
end;

procedure TFrameCtTableList.actNewModelExecute(Sender: TObject);
begin
  NewCtModelNode;
end;

procedure TFrameCtTableList.NewCtFieldNode;
var
  pctnode: TCtMetaObject;
  ctnode: TCtMetaField;
  vNode: TTreeNode;
begin
  if FReadOnlyMode then
    Exit;
  pctnode := CurCtNode;
  if not Assigned(pctnode) then
    Exit;
  CheckCanEditMeta;

  vNode := CurTreeNode;
  if not Assigned(vNode) then
    Exit;
  if pctnode is TCtMetaTable then
  begin
    ctnode := TCtMetaTable(pctnode).MetaFields.NewMetaField;
    vNode := AddNodeToTree(vNode, ctnode);
    if Assigned(vNode) then     
    begin
      TreeViewCttbs.ClearSelection;
      TreeViewCttbs.Selected := vNode;
    end;
  end
  else if pctnode is TCtMetaField then
  begin
    ctnode := TCtMetaField(pctnode).OwnerList.NewMetaField;
    vNode := AddNodeToTree(vNode.Parent, ctnode);
    if Assigned(vNode) then
    begin
      TreeViewCttbs.ClearSelection;
      TreeViewCttbs.Selected := vNode;
    end;
  end;
end;

procedure TFrameCtTableList.NewCtModelNode;
var
  ctnode: TCtDataModelGraph;
  vNode: TTreeNode;
begin
  if FReadOnlyMode then
    Exit;
  CheckCanEditMeta;
  ctnode := FCtDataModelList.NewModelItem;
  if Assigned(GProc_OnEzdmlCmdEvent) then
  begin
    GProc_OnEzdmlCmdEvent('NEW_MODEL', '', '', ctnode, nil);
  end;
  vNode := AddNodeToTree(nil, ctnode);
  if FCtDataModelList.Count > 1 then
    TreeViewCttbs.ShowRoot := True
  else
    TreeViewCttbs.ShowRoot := False;
  if Assigned(vNode) then
  begin
    TreeViewCttbs.ClearSelection;
    TreeViewCttbs.Selected := vNode;
    vNode.EditText;
  end;
end;

procedure TFrameCtTableList.Init(ACtDataModelList: TCtDataModelGraphList;
  bReadOnly: boolean);
begin
  FCtDataModelList := ACtDataModelList;
  FReadOnlyMode := bReadOnly;
  actRename.Visible := not FReadOnlyMode;
  actNewTable.Visible := not FReadOnlyMode;
  actNewField.Visible := not FReadOnlyMode;
  actDelete.Visible := not FReadOnlyMode;
  edtTbFilter.Width := PanelTop.Width;

  FTbFilterIniting := True;
  edtTbFilter.Text := srFilter;
  btnClearFilter.Hide;
  FTbFilterIniting := False;

  RefreshTheTree;

  if Assigned(FOnSelectedChange) then
    FOnSelectedChange(Self);
end;

procedure TFrameCtTableList.RefreshObj(ACtNode: TCtMetaObject);
var
  vNode: TTreeNode;
begin
  CheckAbort(' ');
  vNode := GetTreeNodeOfCtNode(ACtNode);
  if vNode <> nil then
  begin
    RefreshNode(vNode);
    RefreshOtherSameNameTbs(ACtNode);
    Exit;
  end;

  if ACtNode is TCtMetaTable then
  begin
    vNode := GetTreeNodeOfCtNode(TCtMetaTable(ACtNode).OwnerList.OwnerModel);
    if Assigned(vNode) then
    begin
      AddNodeToTree(vNode, ACtNode);
      if not vNode.Expanded then
        vNode.Expand(False);
    end;
  end
  else if ACtNode is TCtMetaField then
  begin
    vNode := GetTreeNodeOfCtNode(TCtMetaField(ACtNode).OwnerTable);
    if Assigned(vNode) then
      AddNodeToTree(vNode, ACtNode);
  end;  
  RefreshOtherSameNameTbs(ACtNode);
end;

procedure TFrameCtTableList.RefreshOtherSameNameTbs(ACtNode: TCtMetaObject);
var
  tb: TCtMetaTable;
  I: integer;
  dt: TObject;
  ls: TList;
  vNode: TTreeNode;
begin
  //刷新同名的其它表
  if ACtNode = nil then
    Exit;

  //找到该节点对应的表
  tb := nil;
  if ACtNode is TCtMetaTable then
  begin
    tb := TCtMetaTable(ACtNode);
    if tb.DataLevel = ctdlDeleted then
      Exit;
  end
  else if ACtNode is TCtMetaField then
  begin
    tb := TCtMetaField(ACtNode).OwnerTable;
  end;
  if tb = nil then
    Exit;

  //再找同名的其它表
  ls := TList.Create;
  try
    for I := 0 to Self.TreeViewCttbs.Items.Count - 1 do
    begin
      try
        //这里判断只处理表（通过ImageIndex判断），要排除字段，因为字段很可能已经被释放了
        if TreeViewCttbs.Items[I].ImageIndex <> 1 then
          Continue;
        dt := TObject(TreeViewCttbs.Items[I].Data);
        if dt <> nil then
          if dt is TCtMetaTable then
            if TCtMetaTable(dt).Name = tb.Name then
              if dt <> tb then
                ls.Add(TreeViewCttbs.Items[I]);
      except
        //Application.MainForm.Caption := Format('%d : %s',[I, TreeViewCttbs.Items[I].Text]);
      end;
    end;

    //刷新其它表对应的节点，并刷新其子节点
    Self.TreeViewCttbs.Items.BeginUpdate;
    try
      for I := 0 to ls.Count - 1 do
      begin
        vNode := TTreeNode(ls[I]);
        Self.RefreshNode(vNode);
        vNode.Expanded := False;
        Self.RefreshNodeChild(vNode);
      end;
    finally
      Self.TreeViewCttbs.Items.EndUpdate;
    end;
  finally
    ls.Free;
  end;

end;

procedure TFrameCtTableList.RefreshNode(ANode: TTreeNode);
var
  ACtNode: TCtMetaObject;
begin
  if ANode = nil then
    Exit;
  ACtNode := TCtMetaObject(ANode.Data);
  if ACtNode = nil then
    Exit;
  if ACtNode.DataLevel = ctdlDeleted then
    ANode.Delete
  else
    with ANode do
    begin
      Text := ACtNode.NameCaption;
      ImageIndex := GetImageIndexOfCtNode(ACtNode);
      SelectedIndex := GetImageIndexOfCtNode(ACtNode, True);
      Data := ACtNode;
    end;
end;

procedure TFrameCtTableList.TreeViewCttbsDragDrop(Sender, Source: TObject;
  X, Y: integer);
var
  chgTbs: array of TCtMetaTable;
  bFieldCopied, bTbCopied: boolean;

  procedure AddChgTb(tb: TCtMetaTable);
  var
    I: integer;
  begin
    for I := 0 to High(chgTbs) do
    begin
      if ChgTbs[I] = tb then
        Exit;
    end;
    SetLength(chgTbs, Length(chgTbs) + 1);
    chgTbs[High(chgTbs)] := tb;
  end;

  procedure DoDragNode(SrcNode, TgNode: TTreeNode);
  var
    ctNodeP, ctNodeC, ctNodeD: TCtMetaObject;
    i1, i2, I: integer;
    oList: TCtObjectList;
  begin
    if SrcNode = nil then
      Exit;
    if SrcNode.Data = nil then
      Exit;

    if TgNode = nil then
      Exit;
    if TgNode = SrcNode then
      Exit;
    if TgNode.Data = nil then
      Exit;

    ctNodeP := GetCtNodeOfTreeNode(TgNode);
    ctNodeC := GetCtNodeOfTreeNode(SrcNode);
    if ctNodeC is TCtDataModelGraph then
    begin
      if not (ctNodeP is TCtDataModelGraph) or not Assigned(TgNode) then
        Exit;
      i1 := FCtDataModelList.IndexOf(ctNodeC);
      i2 := FCtDataModelList.IndexOf(ctNodeP);
      if i1 = -1 then
        Exit;
      if i1 > i2 then
      begin
        FCtDataModelList.Move(i1, i2);
        SrcNode.MoveTo(TgNode, naInsert);
      end
      else
      begin
        FCtDataModelList.Move(i1, i2);
        if TgNode.getNextSibling = nil then
          SrcNode.MoveTo(TgNode, naAdd)
        else
          SrcNode.MoveTo(TgNode.getNextSibling, naInsert);
      end;
      FCtDataModelList.SaveCurrentOrder;
    end
    else if ctNodeC is TCtMetaTable then
    begin
      if (ctNodeP is TCtDataModelGraph) then
      begin
        if (TCtDataModelGraph(ctNodeP).Tables <> TCtMetaTable(ctNodeC).OwnerList) then
        begin
          oList := TCtDataModelGraph(ctNodeP).Tables;
          if oList.ItemByName(ctNodeC.Name) = nil then
          begin
            ctNodeD := TCtMetaTableList(oList).NewTableItem;
            ctNodeD.AssignFrom(ctNodeC);
            TCtMetaTable(ctNodeD).GraphDesc := '';
            with TCtMetaTable(ctNodeD).MetaFields do
              for I := 0 to Count - 1 do
                Items[I].GraphDesc := '';
            AddChgTb(TCtMetaTable(ctNodeD));
            bTbCopied := True;
          end;
        end;
      end
      else
      begin
        if ctNodeP is TCtMetaField then
        begin
          ctNodeP := TCtMetaField(ctNodeP).OwnerTable;
          TgNode := TgNode.Parent;
        end;
        if not (ctNodeP is TCtMetaTable) or not Assigned(TgNode) then
          Exit;
        if TCtMetaTable(ctNodeP).ParentList <> TCtMetaTable(ctNodeC).ParentList then
          Exit;
        i1 := CtTableList.IndexOf(ctNodeC);
        i2 := CtTableList.IndexOf(ctNodeP);
        if i1 = -1 then
          Exit;
        if i1 > i2 then
        begin
          CtTableList.Move(i1, i2);
          SrcNode.MoveTo(TgNode, naInsert);
        end
        else
        begin
          CtTableList.Move(i1, i2);
          if TgNode.getNextSibling = nil then
            SrcNode.MoveTo(TgNode, naAdd)
          else
            SrcNode.MoveTo(TgNode.getNextSibling, naInsert);
        end;
        CtTableList.SaveCurrentOrder;
      end;
    end
    else if (ctNodeP is TCtMetaField) and (ctNodeC is TCtMetaField) then
    begin
      if (TCtMetaField(ctNodeP).OwnerList = TCtMetaField(ctNodeC).OwnerList) then
      begin
        oList := TCtMetaField(ctNodeP).OwnerList;
        i1 := oList.IndexOf(ctNodeC);
        i2 := oList.IndexOf(ctNodeP);
        if i1 = -1 then
          Exit;
        if i1 > i2 then
        begin
          oList.Move(i1, i2);
          SrcNode.MoveTo(TgNode, naInsert);
        end
        else
        begin
          oList.Move(i1, i2);
          if TgNode.getNextSibling = nil then
            SrcNode.MoveTo(TgNode, naAdd)
          else
            SrcNode.MoveTo(TgNode.getNextSibling, naInsert);
        end;
        oList.SaveCurrentOrder;

        AddChgTb(TCtMetaField(ctNodeP).OwnerTable);
      end
      else if (TCtMetaField(ctNodeP).OwnerTable.Name <>
        TCtMetaField(ctNodeC).OwnerTable.Name) then
      begin
        oList := TCtMetaField(ctNodeP).OwnerTable.MetaFields;
        if oList.ItemByName(ctNodeC.Name) = nil then
        begin
          i2 := oList.IndexOf(ctNodeP);
          ctNodeD := TCtMetaFieldList(oList).NewMetaField;
          ctNodeD.AssignFrom(ctNodeC);
          i1 := oList.IndexOf(ctNodeD);
          if i1 <> -1 then
            oList.Move(i1, i2);

          AddChgTb(TCtMetaField(ctNodeP).OwnerTable);
          bFieldCopied := True;
        end;
      end;
    end
    else if (ctNodeP is TCtMetaTable) and (ctNodeC is TCtMetaField) then
    begin
      if (TCtMetaTable(ctNodeP).Name <> TCtMetaField(ctNodeC).OwnerTable.Name) then
      begin
        oList := TCtMetaTable(ctNodeP).MetaFields;
        if oList.ItemByName(ctNodeC.Name) = nil then
        begin
          ctNodeD := TCtMetaFieldList(oList).NewMetaField;
          ctNodeD.AssignFrom(ctNodeC);
          AddChgTb(TCtMetaTable(ctNodeP));
          bFieldCopied := True;
        end;
      end;
    end;
  end;

  procedure DoSortNodes(var sNodes: array of TTreeNode);
  var
    I, J: integer;
    tNode: TTreeNode;
  begin
    for I := 0 to High(sNodes) do
      for J := I to High(sNodes) do
      begin
        if sNodes[J].Index < sNodes[I].Index then
        begin
          tNode := sNodes[I];
          sNodes[I] := sNodes[J];
          sNodes[J] := tNode;
        end;
      end;
  end;

  procedure DoFreshTb(tb: TCtMetaTable);
  var
    vNode: TTreeNode;
  begin
    if not bFieldCopied and not bTbCopied then
    begin
      RefreshOtherSameNameTbs(tb);
    end
    else
    begin
      vNode := GetTreeNodeOfCtNode(tb);
      if vNode <> nil then
      begin
        RefreshNode(vNode);
        RefreshNodeChild(vNode);
        RefreshOtherSameNameTbs(tb);
      end
      else
        RefreshObj(tb);
    end;
    if bFieldCopied or not bTbCopied then
      DoTablePropsChanged(tb);
  end;

var
  SrcNode, TgNode: TTreeNode;
  selNodes: array of TTreeNode;
  I: integer;
begin

  if FReadOnlyMode then
    Exit;
  if Source <> Self.TreeViewCttbs then
    Exit;
                    
  if TreeViewCttbs.SelectionCount > 1 then
    SrcNode := TreeViewCttbs.Selections[0]
  else
    SrcNode := TreeViewCttbs.Selected;
  if SrcNode = nil then
  begin
    Exit;
  end; 
    //Application.MainForm.Caption := 'drop3..'+TimeToStr(now);

  TgNode := TreeViewCttbs.GetNodeAt(X, Y);
  if TgNode = nil then
    Exit;
  if TgNode = SrcNode then
    Exit;
  if TgNode.Data = nil then
    Exit;

  CheckCanEditMeta;

  SetLength(chgTbs, 0);
  bFieldCopied := False;
  bTbCopied := False;

  TreeViewCttbs.Items.BeginUpdate;
  try

    if TreeViewCttbs.SelectionCount = 1 then
      DoDragNode(SrcNode, TgNode)
    else
    begin
      SetLength(selNodes, TreeViewCttbs.SelectionCount);
      for I := 0 to TreeViewCttbs.SelectionCount - 1 do
      begin
        selNodes[I] := TreeViewCttbs.Selections[I];
      end;
      DoSortNodes(selNodes);

      if SrcNode.Parent = TgNode.Parent then
      begin
        if SrcNode.AbsoluteIndex > TgNode.AbsoluteIndex then
        begin
          for I := 0 to High(selNodes) do
            DoDragNode(selNodes[I], TgNode);
        end
        else
        begin
          for I := High(selNodes) downto 0 do
            DoDragNode(selNodes[I], TgNode);
        end;
      end
      else
      begin
        for I := 0 to High(selNodes) do
          DoDragNode(selNodes[I], TgNode);
      end;
    end;

    if Length(chgTbs) > 0 then
    begin
      for I := 0 to High(chgTbs) do
      begin
        DoFreshTb(chgTbs[I]);
      end;
    end;

  finally
    TreeViewCttbs.Items.EndUpdate;
  end;
                    
  if TreeViewCttbs.SelectionCount = 1 then
  begin
    SrcNode := TreeViewCttbs.Selections[0];
    TreeViewCttbs.ClearSelection();
    SrcNode.Selected := True;
  end;
end;

procedure TFrameCtTableList.RefreshNodeChild(ANode: TTreeNode);
var
  ACtNode: TCtMetaTable;
  I: integer;
  bExpanded: boolean;
begin
  if (ANode = nil) or not (GetCtNodeOfTreeNode(ANode) is TCtMetaTable) then
    Exit;
  bExpanded := ANode.Expanded;
  ANode.DeleteChildren;
  ACtNode := TCtMetaTable(ANode.Data);
  TreeViewCttbs.Items.BeginUpdate;
  try
    with ACtNode.MetaFields do
      for I := 0 to Count - 1 do
        AddNodeToTree(ANode, Items[I]);
    if bExpanded then
      ANode.Expand(False);
  finally
    TreeViewCttbs.Items.EndUpdate;
  end;
end;

procedure TFrameCtTableList.MoveTreeNodeOnly(ACtNode1, ACtNode2: TCtMetaObject);
var
  vNode1, vNode2: TTreeNode;
begin
  vNode1 := GetTreeNodeOfCtNode(ACtNode1);
  vNode2 := GetTreeNodeOfCtNode(ACtNode2);
  if (vNode1 <> nil) and (vNode2 <> nil) then
  begin
    if vNode1.Index > vNode2.Index then
      vNode1.MoveTo(vNode2, naInsert)
    else
    begin
      if vNode2.getNextSibling = nil then
        vNode1.MoveTo(vNode2, naAdd)
      else
        vNode1.MoveTo(vNode2.getNextSibling, naInsert);
    end;
  end;
end;

function TFrameCtTableList.GetTreeNodeOfCtNode(ACtobj: TCtMetaObject): TTreeNode;
var
  I: integer;
begin
  Result := nil;
  if ACtobj = nil then
    Exit;
  for I := 0 to Self.TreeViewCttbs.Items.Count - 1 do
    if TreeViewCttbs.Items[I].Data = ACtobj then
    begin
      Result := TreeViewCttbs.Items[I];
      Exit;
    end;
end;

procedure TFrameCtTableList.FocusToTable(ATbName: string);
var
  cto: TCtMetaObject;
  tb: TCtMetaTable;
begin
  cto:=SelectedCtNode;
  tb := nil;
  if cto <> nil then
  begin
    if cto is TCtDataModelGraph then
      tb := TCtMetaTable(TCtDataModelGraph(cto).Tables.ItemByName(ATbName));
  end;
  if tb=nil then
    if CtTableList <> nil then
      tb := TCtMetaTable(CtTableList.ItemByName(ATbName));
  if tb=nil then
    Exit;
  Self.SelectedCtNode := tb;
end;

procedure TFrameCtTableList.FocusSibling(bUp: Boolean);    
var
  Node, fNode: TTreeNode;
begin
  if TreeViewCttbs.Items.Count = 0 then
    Exit;
  Node := TreeViewCttbs.Selected;
  if Node = nil then
  begin                     
    TreeViewCttbs.ClearSelection();
    TreeViewCttbs.Selected := TreeViewCttbs.Items[0];
    Exit;
  end;
  if bUp then
    fNode := Node.GetPrevSibling
  else
    fNode :=Node.GetNextSibling;
  if fNode = nil then
    Exit;        
  TreeViewCttbs.ClearSelection();
  TreeViewCttbs.Selected := fNode;
end;

procedure TFrameCtTableList.SetOnShowNodeProp(const Value: TNotifyEvent);
begin
  FOnShowNodeProp := Value;
  Self.actProperty.Visible := Assigned(FOnShowNodeProp);
end;

procedure TFrameCtTableList.SetSelectedCtNode(const Value: TCtMetaObject);
var
  Node: TTreeNode;
begin
  if FSettingSelectedNode then
    Exit;
  FSettingSelectedNode := True;
  try                          
    if Value <> nil then
     if GetCtNodeOfTreeNode(TreeViewCttbs.Selected) = Value then
       if TreeViewCttbs.SelectionCount = 1 then
         Exit;

    TreeViewCttbs.ClearSelection();
    if Value = nil then
      Self.TreeViewCttbs.Selected := nil
    else if GetCtNodeOfTreeNode(TreeViewCttbs.Selected) <> Value then
    begin
      Node := GetTreeNodeOfCtNode(Value);
      if Node <> nil then
      begin
        Self.TreeViewCttbs.Selected := Node;
        Node.Selected := True;
      end;
    end;
  finally
    FSettingSelectedNode := False;
  end;
end;

procedure TFrameCtTableList.DoCapitalizeProc(sType: string);
var
  I, J, K: Integer;
  field: TCTMetaField;
  tb: TCtMetaTable;
  md: TCtDataModelGraph;
  ts: TStringList;
  bHasSelTb: Boolean;
begin
  CheckCanEditMeta;

  ts:= TStringList.Create;
  try
    bHasSelTb:=False;
    for I := 0 to TreeViewCttbs.Items.Count - 1 do
      if TreeViewCttbs.Items[I].Selected then
        if TreeViewCttbs.Items[I].Data <> nil then
        begin
          if TObject(TreeViewCttbs.Items[I].Data) is TCtDataModelGraph then
          begin
            bHasSelTb := True;
            Break;
          end
          else if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
          begin
            bHasSelTb := True;
            Break;
          end;
        end;

    for I := 0 to TreeViewCttbs.Items.Count - 1 do
      if TreeViewCttbs.Items[I].Selected then
        if TreeViewCttbs.Items[I].Data <> nil then
        begin
          if TObject(TreeViewCttbs.Items[I].Data) is TCtDataModelGraph then
          begin
            md := TCtDataModelGraph(TreeViewCttbs.Items[I].Data);
            DoAutoCapProcess(md, sType);
            for K := 0 to md.Tables.Count - 1 do
            begin
              tb := md.Tables[K];
              if ts.IndexOf(tb.Name)>=0 then
                Continue;
              ts.AddObject(tb.Name, tb);    
              DoAutoCapProcess(tb, sType);
              with tb.MetaFields do
                for J := 0 to Count - 1 do
                begin
                  field := Items[J];
                  DoAutoCapProcess(field, sType);
                end;
            end;
          end
          else if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
          begin
            tb := TCtMetaTable(TreeViewCttbs.Items[I].Data);
            if ts.IndexOf(tb.Name)>=0 then
              Continue;
            ts.AddObject(tb.Name, tb);
            DoAutoCapProcess(tb, sType);
            with tb.MetaFields do
              for J := 0 to Count - 1 do
              begin
                field := Items[J];
                DoAutoCapProcess(field, sType);
              end;
          end
          else if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaField then
          begin
            if bHasSelTb then
              Continue;
            field := TCtMetaField(TreeViewCttbs.Items[I].Data);
            DoAutoCapProcess(field, sType);   
            tb := field.OwnerTable;
            if ts.IndexOf(tb.Name)<0 then
              ts.AddObject(tb.Name, tb);
          end;
        end;

  finally   
    for I := 0 to ts.Count - 1 do
    begin
      tb := TCtMetaTable(ts.Objects[I]);
      if tb<>nil then
        DoTablePropsChanged(tb);
    end;
    if ts.Count>0 then
    begin
      if (TreeViewCttbs.SelectionCount > 1) or (ts.Count>1) then
        RefreshTheTree
      else
      begin
        RefreshSelected;
        RefreshObj(TCtMetaObject(ts.Objects[0]));
      end;
    end;
    ts.Free;
  end;

end;

procedure TFrameCtTableList.ExpandCtTreeNode(Node: TTreeNode);
var
  vCtNode: TCtMetaObject;
  I: integer;
begin
  if Node = nil then
    Exit;
  if not Node.HasChildren then
    Exit;
  if Node.Count > 0 then
    Exit;

  vCtNode := GetCtNodeOfTreeNode(Node);
  if vCtNode = nil then
    Exit;
  if vCtNode is TCtMetaTable then
  begin
    with TCtMetaTable(vCtNode).MetaFields do
      for I := 0 to Count - 1 do
        AddNodeToTree(Node, Items[I]);
  end;
end;

procedure TFrameCtTableList.actPasteTbExecute(Sender: TObject);

  procedure CheckHasDiffTb(tb: TCtMetaTable);
  var
    ctb: TCtMetaTable;
    n: integer;
  begin
    //如果本模型中没有，但其它模型有，且内容不一样：1 覆盖 2 改名
    ctb := FGlobeDataModelList.GetTableOfName(tb.Name);
    if ctb = nil then
      Exit;
    if ctb.MaybeSame(tb) then
      Exit;
    case Application.MessageBox(PChar(Format(srDmlPasteExistsTableFmt,[tb.Name])),
      PChar(Application.Title), MB_YESNOCANCEL or MB_ICONWARNING) of
      IDYES:
        Exit;
      IDNO:
        begin
          n := 1;
          while HasSameNameTables(tb, tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n))) do
            Inc(n);
          tb.Name := tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));   
          if tb.Caption <> '' then
             tb.Caption :=  tb.Caption + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));
        end;
      else
        Abort;
    end;
  end;


  procedure RenameTbIfExists(tb: TCtMetaTable);
  var
    n: integer;
  begin
    if Sender = nil then
      Exit;

    if tb.IsTable then
      if CtTableList.ItemByName(tb.Name) = nil then
      begin
        CheckHasDiffTb(tb);
        Exit;
      end;
    if not HasSameNameTables(tb, tb.Name) then
      Exit;

    n := 1;
    while HasSameNameTables(tb, tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n))) do
      Inc(n);
    tb.Name := tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));   
    if tb.Caption <> '' then
       tb.Caption :=  tb.Caption + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));
  end;

  procedure RenameAllTbs(vTempTbs: TCtMetaTableList);
  var
    n, I, J, K: integer;
    tb, vtb: TCtMetaTable;
    AOldName: string;
  begin
    for I:=0 to vTempTbs.Count - 1 do
    begin
      tb := vTempTbs[I];
      AOldName := tb.Name;

      n := 1;
      while HasSameNameTables(tb, tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n))) do
        Inc(n);
      tb.Name := tb.Name + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n)); 
      if tb.Caption <> '' then
         tb.Caption :=  tb.Caption + '_' + srPasteCopySuffix + IfElse(n=1, '', IntToStr(n));

      for J:=0 to vTempTbs.Count - 1 do
      begin
        vtb := vTempTbs[J];
        for K := 0 to vtb.MetaFields.Count - 1 do
          if UpperCase(vtb.MetaFields[K].RelateTable) = UpperCase(AOldName) then
          begin
            vtb.MetaFields[K].RelateTable := tb.Name;
          end;
      end;

    end;
  end;

var
  I, J, idx: integer;
  vTempMds: TCtDataModelGraphList;
  vTempTbs: TCtMetaTableList;
  vTempFlds: TCtMetaFieldList;
  fs: TCtObjMemXmlStream;
  ss: TStringList;
  S: string;
  md: TCtDataModelGraph;
  tb: TCtMetaTable;
  fd: TCtMetaField; 
  cto: TCtMetaObject;
  rNode: TTreeNode;
begin
  S := Clipboard.AsText;
  if S = '' then
    Exit;
  if Copy(S, 1, 5) <> '<?xml' then
    Exit;
  CheckCanEditMeta;

  I := Pos('<DataModels>', S);
  if (I > 0) and (I < 100) then
  begin
    vTempMds := TCtDataModelGraphList.Create;
    fs := TCtObjMemXmlStream.Create(True);
    ss := TStringList.Create;
    Screen.Cursor := crAppStart;
    try
      ss.Text := S;
      ss.SaveToStream(fs.Stream);
      fs.Stream.Seek(0, soFromBeginning);
      fs.RootName := 'DataModels';
      vTempMds.LoadFromSerialer(fs);

      idx := -1;
      rNode := TreeViewCttbs.Selected;
      cto := nil;
      while rNode <> nil do
      begin
        cto := GetCtNodeOfTreeNode(rNode);
        if (cto <> nil) and (cto is TCtDataModelGraph) then
          Break;
        rNode := rNode.Parent;
      end;
      if cto <> nil then
        idx := FCtDataModelList.IndexOf(cto);

      for I := 0 to vTempMds.Count - 1 do
      begin
        md := FCtDataModelList.NewModelItem;
        md.AssignFrom(vTempMds[I]);  
        if (idx >= 0) and (idx < FCtDataModelList.Count - 1) then
        begin
          Inc(idx);
          FCtDataModelList.Move(FCtDataModelList.Count - 1, idx);
        end;
      end;
      FCtDataModelList.SaveCurrentOrder;
      RefreshTheTree;
    finally
      vTempMds.Free;
      fs.Free;
      ss.Free;
      Screen.Cursor := crDefault;
    end;
    Exit;
  end;

  I := Pos('<Tables>', S);
  if (I > 0) and (I < 100) then
  begin
    vTempTbs := TCtMetaTableList.Create;
    fs := TCtObjMemXmlStream.Create(True);
    ss := TStringList.Create;
    Screen.Cursor := crAppStart;
    try
      ss.Text := S;
      ss.SaveToStream(fs.Stream);
      fs.Stream.Seek(0, soFromBeginning);
      fs.RootName := 'Tables';
      vTempTbs.LoadFromSerialer(fs);

      idx := -1;
      rNode := TreeViewCttbs.Selected;
      cto := nil;
      while rNode <> nil do
      begin
        cto := GetCtNodeOfTreeNode(rNode);
        if (cto <> nil) and (cto is TCtMetaTable) then
          Break;
        rNode := rNode.Parent;
      end;
      if cto <> nil then
        idx := CtTableList.IndexOf(cto);
                          
      if Sender = nil then
        RenameAllTbs(vTempTbs);
      for I := 0 to vTempTbs.Count - 1 do
      begin                  
        RenameTbIfExists(vTempTbs[I]);
        tb := CtTableList.NewTableItem;
        tb.AssignFrom(vTempTbs[I]);
        tb.GraphDesc := '';
        for J := 0 to tb.MetaFields.Count - 1 do
          tb.MetaFields[J].GraphDesc := '';

        if (idx >= 0) and (idx < CtTableList.Count - 1) then
        begin
          Inc(idx);
          CtTableList.Move(CtTableList.Count - 1, idx);
        end;
        DoTablePropsChanged(tb);
      end;
      CtTableList.SaveCurrentOrder;
      RefreshTheTree;
    finally
      vTempTbs.Free;
      fs.Free;
      ss.Free;
      Screen.Cursor := crDefault;
    end;
    Exit;
  end;


  I := Pos('<Fields>', S);
  if (I > 0) and (I < 100) then
  begin
    if SelectedCtNode is TCtMetaTable then
      tb := TCtMetaTable(SelectedCtNode)
    else if SelectedCtNode is TCtMetaField then
      tb := TCtMetaField(SelectedCtNode).OwnerTable
    else
      Exit;

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
      rNode := TreeViewCttbs.Selected;
      cto := GetCtNodeOfTreeNode(rNode);    
      if (cto <> nil) and (cto is TCtMetaTable) then
      begin
        if not rNode.Expanded then
          rNode.Expand(False);
      end;
      if (cto <> nil) and (cto is TCtMetaField) then
        idx := tb.MetaFields.IndexOf(cto);

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
      DoTablePropsChanged(tb);
      RefreshTheTree;
    finally
      vTempFlds.Free;
      fs.Free;
      ss.Free;
    end;
  end;
end;

procedure TFrameCtTableList.actPropertyExecute(Sender: TObject);
begin
  if Assigned(FOnShowNodeProp) then
    FOnShowNodeProp(CurCtNode);
end;

procedure TFrameCtTableList.TreeViewCttbsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  nd: TTreeNode;
begin
  if Button = mbRight then
  begin
    nd := TreeViewCttbs.GetNodeAt(X, Y);
    if Assigned(nd) and not nd.Selected then
    begin
      TreeViewCttbs.ClearSelection();
      TreeViewCttbs.Selected := nd;
    end;
  end;
  if Button = mbLeft then
  begin
    FLastMouseDownTick := GetTickCount64;
    if ssAlt in Shift then
    begin
      if FAltFocusNode <> nil then
      begin
        if TreeViewCttbs.GetNodeAt(X, Y) <> FAltFocusNode then
        begin
          FAltFocusNode := nil;
        end;
      end
      else
      begin
        FAltFocusNode := TreeViewCttbs.GetNodeAt(X, Y);
        if FAltFocusNode <> nil then
          FAltFocusTick := GetTickCount64;
      end;
    end;
  end;
end;

procedure TFrameCtTableList.CheckActions;
var
  bSelObj, bMultiSel: boolean;
  S: string;
  obj: TCtMetaObject;
  I: Integer;
begin
  obj := CurCtNode;
  bSelObj := obj <> nil;
  bMultiSel := Self.TreeViewCttbs.SelectionCount > 0;
  actNewTable.Enabled := not FReadOnlyMode;
  actNewField.Enabled := (bSelObj or bMultiSel) and not FReadOnlyMode;
  actDelete.Enabled := (bSelObj or bMultiSel) and not FReadOnlyMode;
  actRename.Enabled := bSelObj and not FReadOnlyMode;
  actExpand.Enabled := CurTreeNode <> nil;
                              
  if (obj=nil) and (TreeViewCttbs.SelectionCount > 0) then
    obj := GetCtNodeOfTreeNode(TreeViewCttbs.Selections[0]);
  actCopyTb.Enabled := (obj<>nil) and ((obj is TCtDataModelGraph) or (obj is TCtMetaTable) or
    (obj is TCtMetaField));

  if FReadOnlyMode then
  begin
    actPasteTb.Enabled := False;
    actPasteAsCopy.Enabled := False;
  end
  else
  begin
    S := Clipboard.AsText;
    if Copy(S, 1, 5) <> '<?xml' then
    begin
      actPasteTb.Enabled := False;
      actPasteAsCopy.Enabled := False;
    end
    else
    begin                         
      I := Pos('<Fields>', S);
      if (I > 0) and (I < 100) then
      begin                
        actPasteTb.Enabled := (obj<>nil) and ((obj is TCtMetaTable) or (obj is TCtMetaField));
        actPasteAsCopy.Enabled := False;
      end
      else
      begin
        actPasteTb.Enabled := True;
        I := Pos('<Tables>', S);
        if (I > 0) and (I < 100) then
          actPasteAsCopy.Enabled := True
        else
          actPasteAsCopy.Enabled := False;
      end;
    end;
  end;
end;

function TFrameCtTableList.CheckCtObjFilter(ACtObj: TCtMetaObject): boolean;
  function CheckMatch(AKeyword: string): Boolean;
  var
    S: string;
    I: Integer;
  begin
    Result := True;
    if AKeyword = '' then
      Exit;
    if ACtObj is TCtMetaTable then
    begin
      S := TCtMetaTable(ACtObj).Name;
      if FFilterMode = 1 then //只检查表
      begin
        if Pos(AKeyword, LowerCase(S)) > 0 then
          Exit;
        S := TCtMetaTable(ACtObj).Caption;
        if Pos(AKeyword, LowerCase(S)) > 0 then
          Exit;             
        S := TCtMetaTable(ACtObj).NameCaption;
        if Pos(AKeyword, LowerCase(S)) > 0 then
          Exit;
      end;
      if FFilterMode = 2 then //只检查字段，排除表（表已经在阶段1加了）
      begin
        if Pos(AKeyword, LowerCase(S)) > 0 then
        begin
          Result := False;
          Exit;
        end;
        S := TCtMetaTable(ACtObj).Caption;
        if Pos(AKeyword, LowerCase(S)) > 0 then
        begin
          Result := False;
          Exit;
        end;
        S := TCtMetaTable(ACtObj).NameCaption;
        if Pos(AKeyword, LowerCase(S)) > 0 then
        begin
          Result := False;
          Exit;
        end;
        with TCtMetaTable(ACtObj).MetaFields do
          for I := 0 to Count - 1 do
            if Items[I].DataLevel <> ctdlDeleted then
            begin
              S := Items[I].Name;
              if Pos(AKeyword, LowerCase(S)) > 0 then
                Exit;
              S := Items[I].DisplayName;
              if Pos(AKeyword, LowerCase(S)) > 0 then
                Exit;       
              S := Items[I].NameCaption;
              if Pos(AKeyword, LowerCase(S)) > 0 then
                Exit;
            end;
      end;

      Result := False;
    end;
  end;
var
  k1, k2: string;
  po: Integer;
begin
  k1 := Trim(FTbFilter);
  Result := True;
  while k1 <> '' do
  begin
    po := Pos(' ', k1);
    if po > 0 then
    begin
      k2 := Trim(Copy(k1, po + 1, Length(k1)));
      k1 := Trim(Copy(k1, 1, po - 1));
    end
    else
    begin
      k2 := Trim(k1);
      k1 := '';
    end;
    if not CheckMatch(k2) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function TFrameCtTableList.GetImageIndexOfCtNode(Nd: TCtObject;
  bSelected: boolean): integer;
begin
  Result := 0;
  if (Nd is TCtMetaTable) then
  begin
    if TCtMetaTable(Nd).IsText then
      Result := 21
    else
      Result := 1;
  end
  else if (Nd is TCtMetaField) then
  begin
    if TCtMetaField(Nd).KeyFieldType = cfktID then
      Result := 20
    else
    begin
      Result := 2 + integer(TCtMetaField(Nd).DataType);
    end;
  end;
end;

procedure TFrameCtTableList.TreeViewCttbsEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: boolean);
var
  tk: int64;
begin
  CheckCanEditMeta;
  if (GetKeyState(VK_MENU) and $80) <> 0 then
    AllowEdit := False
  else if FReadOnlyMode or (Node.Data = nil) then
    AllowEdit := False
  else if FAltFocusNode <> nil then
  begin
    tk := GetTickCount64;
    if Abs(tk - FAltFocusTick) > 1000 then
    begin
      FAltFocusNode := nil;
    end
    else
      AllowEdit := False;
  end;
end;

procedure TFrameCtTableList.TreeViewCttbsExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: boolean);
begin
  ExpandCtTreeNode(Node);
end;

end.
