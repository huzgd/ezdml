unit uFrameCtTableDef;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls,
  CTMetaData, CtMetaTable, uFrameCtTableList, uFrameCtFieldDef, uFormCtDML,
  uFrameCtTableProp;

const
  HM_REFRESHPROP = WM_USER + $2432;
  HM_LOCTOCTOBJ = WM_USER + $2532;

type

  { TFrameCtTableDef }

  TFrameCtTableDef = class(TFrame)
    PanelCttbTree: TPanel;
    SplitterCttbTree: TSplitter;
    PanelTableProp: TPanel;
    PanelFieldProp: TPanel;
    PanelDMLGraph: TPanel;
  private
    { Private declarations }
    FCtDataModelList: TCtDataModelGraphList;
    FIsInitLoading: Boolean;
    FIsRefreshing: Boolean;
    FReadOnlyMode: boolean;
    FCurrentObject: TCtMetaObject;
    FShouldFocusUITick: Int64;
    FToLocCtObj: TCtMetaObject;
    FFrameModified: boolean;
    FFramePropRefreshing: boolean;
    function GetShowLeftTree: Boolean;
    procedure SetShowLeftTree(AValue: Boolean);
    procedure _actNewTableExecute(Sender: TObject);
    procedure _OnCtMetaNodeChange(Sender: TObject);
    procedure _OnCtFieldPropChange(Sender: TObject);
    procedure _OnCtObjShowProp(Sender: TObject);
    procedure _OnCtMetaNodeFindLocation(Sender: TObject; Node: TTreeNode);
    procedure _OnBatchAddFields(Sender: TObject);
    procedure _OnBatchRemoveFields(Sender: TObject);
    procedure _OnGenSqlSelected(Sender: TObject);
    procedure _OnGenCodeSelected(Sender: TObject);      
    procedure _OnChatGPTSelected(Sender: TObject);
    procedure _HM_REFRESHPROP(var msg: TMessage); message HM_REFRESHPROP;
    procedure _HM_LOCTOCTOBJ(var msg: TMessage); message HM_LOCTOCTOBJ;

    procedure ShowTableProp(ATb: TCtMetaTable);
    procedure ShowFieldProp(AFld: TCtMetaField);
    procedure ShowDMLGraph(mdl: TCtDataModelGraph);
  public
    FFrameCtTableList: TFrameCtTableList;
    FFrameCtTableProp: TFrameCtTableProp;
    FFrameCtFieldDef: TFrameCtFieldDef;
    FFrameDMLGraph: TfrmCtDML;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RefreshProp;

    procedure CheckSelectedObjects;
    function GetCurTable: TCtMetaTable;
    function GetCurObject: TCtMetaObject;
    procedure TryFocusGraph;
                                           
    //tp: 0=Obj1.Prop,1=move,2=Obj1.Child,3=Obj1.Prop&Child
    procedure _OnCtTablePropChange(Tp: integer; Obj1, Obj2: TCtMetaObject;
      param: string);
    procedure Init(ACtDataModelList: TCtDataModelGraphList; bReadOnly: boolean);

    procedure ViewModelInNewWnd;

    property FrameModified: boolean read FFrameModified;        
    property ShouldFocusUITick: Int64 read FShouldFocusUITick write FShouldFocusUITick;
    property IsInitLoading: Boolean read FIsInitLoading write FIsInitLoading;
    property ShowLeftTree: Boolean read GetShowLeftTree write SetShowLeftTree;
  end;

implementation


uses
  dmlstrs, uFormGenSql, {$ifndef EZDML_LITE}uFormGenCode, {$endif} WindowFuncs, ezdmlstrs;

{$R *.lfm}

{ TFrameCtTable }

procedure TFrameCtTableDef.CheckSelectedObjects;
var
  I: integer;
begin
  with FFrameCtTableList do
    for I := 0 to TreeViewCttbs.Items.Count - 1 do
      if TreeViewCttbs.Items[I].Data <> nil then
        if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaObject then
          TCtMetaObject(TreeViewCttbs.Items[I].Data).IsSelected :=
            TreeViewCttbs.Items[I].Selected;
end;

constructor TFrameCtTableDef.Create(AOwner: TComponent);
begin
  inherited;

  TabStop := False;

  FFrameCtTableList := TFrameCtTableList.Create(Self);
  FFrameCtTableList.Name := 'FrameCtTableList';
  FFrameCtTableList.Parent := PanelCttbTree;
  PanelCttbTree.Caption := '';
  FFrameCtTableList.Align := alClient;
  //FFrameCtTableList.MN_RESERVED1.Action := Self.actTextDesc;
  //FFrameCtTableList.MN_NewField.Action := actAddSysFields;
  FFrameCtTableList.OnSelectedChange := _OnCtMetaNodeChange;
  FFrameCtTableList.OnShowNodeProp := _OnCtObjShowProp;
  FFrameCtTableList.OnAltNodeClick := _OnCtMetaNodeFindLocation;
  FFrameCtTableList.actNewTable.OnExecute := _actNewTableExecute;

  FFrameCtTableProp := TFrameCtTableProp.Create(Self);
  //FFrameCtTableProp.PanelFieldProps.Visible := True;      
  FFrameCtTableProp.PanelUIPreview.Visible := True;
  FFrameCtTableProp.actShowInGraph.Visible := True;     
  FFrameCtTableProp.btnShowInGraph.Visible := True;
  FFrameCtTableProp.btnRunGenCode.Visible := True;
  FFrameCtTableProp.Parent := Self.PanelTableProp;
  PanelTableProp.Caption := '';
  FFrameCtTableProp.Align := alClient;
  FFrameCtTableProp.PageControlTbProp.Align := alClient;
  FFrameCtTableProp.Proc_OnPropChange := _OnCtTablePropChange;
  FFrameCtTableProp.LoadColWidths('Main');

  //FFrameCtTableList.MN_NewField.Action := FFrameCtTableProp.actAddSysFields;
  FFrameCtTableList.actNewField.OnExecute := _OnBatchAddFields;
  FFrameCtTableList.actNewField.Caption := srBatchAddFields;   
  FFrameCtTableList.actNewField.OnExecute := _OnBatchAddFields;

  FFrameCtTableList.MN_RESERVED1.Caption := srBatchRemoveFields;
  FFrameCtTableList.MN_RESERVED1.Visible := True;
  FFrameCtTableList.MN_RESERVED1.OnClick := _OnBatchRemoveFields;

  FFrameCtTableList.MN_RESERVED2.Caption := srGenerateSql;
  FFrameCtTableList.MN_RESERVED2.Visible := True;
  FFrameCtTableList.MN_RESERVED2.OnClick := _OnGenSqlSelected;

  FFrameCtTableList.MN_RESERVED3.Caption := srGenerateCode;
  FFrameCtTableList.MN_RESERVED3.Visible := True;
  FFrameCtTableList.MN_RESERVED3.OnClick := _OnGenCodeSelected;
                                                   
  //FFrameCtTableList.MN_RESERVED4.Caption := srChatGPT;
  //FFrameCtTableList.MN_RESERVED4.Visible := True;
  //FFrameCtTableList.MN_RESERVED4.OnClick := _OnChatGPTSelected;

  FFrameCtFieldDef := TFrameCtFieldDef.Create(Self);
  FFrameCtFieldDef.Name := 'FrameCtFieldDef';
  FFrameCtFieldDef.Parent := Self.PanelFieldProp;
  PanelFieldProp.Caption := '';
  FFrameCtFieldDef.Align := alClient;
  FFrameCtFieldDef.PageControl1.Align := alClient;
  FFrameCtFieldDef.OnFieldPropChange := _OnCtFieldPropChange;

  FFrameDMLGraph := TfrmCtDML.Create(Self);
  FFrameDMLGraph.Name := 'FrameDMLGraph';
  FFrameDMLGraph.BorderStyle := bsNone;
  FFrameDMLGraph.FFrameCtDML.Parent := Self.PanelDMLGraph; 
  PanelDMLGraph.Caption := '';
  FFrameDMLGraph.FFrameCtDML.Align := alClient;
  FFrameDMLGraph.ReassignActionList;
  //FFrameDMLGraph.Visible := True;

  FFrameDMLGraph.Proc_OnPropChange := _OnCtTablePropChange;
  FFrameDMLGraph.Proc_OnRefresh := FFrameCtTableList.actRefreshExecute;
  FFrameDMLGraph.Proc_OnCanNotShowObjProp := FFrameCtTableList.actPropertyExecute;
  FFrameDMLGraph.Proc_OnCanNotCopyDmlText := FFrameCtTableList.actCopyTextExecute;

  PanelTableProp.Align := alClient;
  PanelFieldProp.Align := alClient;
  PanelDMLGraph.Align := alClient;
end;

destructor TFrameCtTableDef.Destroy;
begin     
  FFrameCtTableProp.SaveColWidths('Main');

  inherited;
end;

function TFrameCtTableDef.GetCurObject: TCtMetaObject;
begin
  if PanelDMLGraph.Visible then
  begin
    FFrameDMLGraph.CheckSelectedTb;
    Result := FFrameDMLGraph.GetSelectedCtObj;
    if Result = nil then
    begin
      Result := FFrameCtTableList.SelectedCtNode;
    end;
  end
  else
  begin
    Result := FFrameCtTableList.SelectedCtNode;
  end;
end;

procedure TFrameCtTableDef.TryFocusGraph;
begin
  if not PanelDMLGraph.Visible then
    Exit;
  try
    FFrameDMLGraph.FFrameCtDML.DMLGraph.SetFocus;
  except
  end;
end;

function TFrameCtTableDef.GetCurTable: TCtMetaTable;
var
  ctNd: TCtMetaObject;
begin
  if PanelDMLGraph.Visible then
  begin
    FFrameDMLGraph.CheckSelectedTb;
    Result := FFrameDMLGraph.GetSelectedTable;
  end
  else
  begin
    ctNd := FFrameCtTableList.SelectedCtNode;
    if ctNd = nil then
      Result := nil
    else if ctNd is TCtMetaTable then
      Result := TCtMetaTable(ctNd)
    else if ctNd is TCtMetaField then
      Result := TCtMetaField(ctNd).OwnerTable
    else
      Result := nil;
  end;
end;

procedure TFrameCtTableDef.Init(ACtDataModelList: TCtDataModelGraphList;
  bReadOnly: boolean);
var
  I: integer;
begin
  FCtDataModelList := ACtDataModelList;
  FReadOnlyMode := bReadOnly;
  Self.FFrameCtTableList.TreeViewCttbs.Items.BeginUpdate;
  try
    with FFrameCtTableList.TreeViewCttbs.Items do
      for I := 0 to Count - 1 do
        Item[I].Data := nil;
    Self.FFrameCtTableList.TreeViewCttbs.Items.Clear;
    Self.FFrameCtTableList.edtTbFilter.Text := '';
    Self.FFrameCtTableProp.Init(nil, True);
    Self.FFrameCtFieldDef.Init(nil, True);
    Self.FFrameDMLGraph.Init(nil, True, False);
    Self.FFrameCtTableList.Init(ACtDataModelList, bReadOnly);
  finally
    Self.FFrameCtTableList.TreeViewCttbs.Items.EndUpdate;
  end;
  FFrameModified := not bReadOnly;
end;

procedure TFrameCtTableDef.ViewModelInNewWnd;
var
  vFrmDMLGraph: TfrmCtDML;
begin
  if FCtDataModelList = nil then
    Exit;
  if FCtDataModelList.CurDataModel = nil then
    Exit;
  vFrmDMLGraph := TfrmCtDML.Create(Application);
  vFrmDMLGraph.Position := poDefault;
  vFrmDMLGraph.BrowseMode := True;
  vFrmDMLGraph.ShowInTaskBar := stAlways;
  vFrmDMLGraph.Caption := vFrmDMLGraph.Caption + ' - ' + FCtDataModelList.CurDataModel.NameCaption;
  vFrmDMLGraph.Show;
  vFrmDMLGraph.Init(FCtDataModelList.CurDataModel, True, True);
end;

procedure TFrameCtTableDef._OnCtMetaNodeChange(Sender: TObject);
begin
  if FFramePropRefreshing then
    Exit;
  FFramePropRefreshing := True;
  PostMessage(Handle, HM_REFRESHPROP, 0, 0);
end;

function TFrameCtTableDef.GetShowLeftTree: Boolean;
begin
  Result := PanelCttbTree.Visible;
end;

procedure TFrameCtTableDef.SetShowLeftTree(AValue: Boolean);
begin
  if PanelCttbTree.Visible=AValue then
    Exit;
  if AValue then
  begin
    PanelCttbTree.Visible := True;
    SplitterCttbTree.Visible := True;
    SplitterCttbTree.Left := PanelCttbTree.Width + 1;
    FFrameDMLGraph.FFrameCtDML.actShowHideList.ImageIndex := FFrameDMLGraph.FFrameCtDML.actShowHideList.Tag;
  end
  else
  begin
    SplitterCttbTree.Visible := False; 
    PanelCttbTree.Visible := False;
    FFrameDMLGraph.FFrameCtDML.actShowHideList.ImageIndex := FFrameDMLGraph.FFrameCtDML.actShowHideList.Tag + 1;  
    TryFocusGraph;
  end;
end;

procedure TFrameCtTableDef._actNewTableExecute(Sender: TObject);
begin
  if PanelDMLGraph.Visible then
  begin
    FFrameDMLGraph.FFrameCtDML.actNewObj.Execute;
  end
  else
  begin
    FFrameCtTableList.actNewTableExecute(Sender);
  end;
end;

procedure TFrameCtTableDef._OnCtMetaNodeFindLocation(Sender: TObject; Node: TTreeNode);
begin
  if (Node = nil) or (Node.Data = nil) then
    Exit;
  FToLocCtObj := TCtMetaObject(Node.Data);
  PostMessage(Handle, HM_LOCTOCTOBJ, 0, 0);
end;

procedure TFrameCtTableDef.RefreshProp;
begin
  if IsInitLoading then
    Exit;
  if FIsRefreshing then
    Exit;
  FIsRefreshing := True;
  try

    if FFrameCtTableList = nil then
      FCurrentObject := nil
    else
      FCurrentObject := FFrameCtTableList.CurCtNode;

    FFrameDMLGraph.FFrameCtDML.SetStatusBarMsg('', 1);
    FFrameDMLGraph.FFrameCtDML.SetStatusBarMsg('', 2);

    if not Assigned(FCurrentObject) then
    begin
      //ShowTableProp(nil)
      FFrameCtTableList.actNewField.Visible := False;
      FFrameCtTableList.MN_RESERVED1.Visible := False;
      FFrameCtTableList.MN_RESERVED2.Visible := False;
      FFrameCtTableList.MN_RESERVED3.Visible := False;
      ShowDMLGraph(nil);
    end
    else if FCurrentObject is TCtDataModelGraph then
    begin
      if TCtDataModelGraph(FCurrentObject).IsCatalog then
      begin
        FFrameCtTableList.actNewField.Visible := False;
        FFrameCtTableList.MN_RESERVED1.Visible := False;
        FFrameCtTableList.MN_RESERVED2.Visible := False;
        FFrameCtTableList.MN_RESERVED3.Visible := False;
        ShowDMLGraph(nil);
      end
      else
      begin
        //FFrameCtTableProp.actAddSysFields.Visible := False;
        FFrameCtTableList.actNewField.Visible := False;
        FFrameCtTableList.MN_RESERVED1.Visible := False;
        FFrameCtTableList.MN_RESERVED2.Visible := True;
        FFrameCtTableList.MN_RESERVED3.Visible := True;
        ShowDMLGraph(TCtDataModelGraph(FCurrentObject));
      end;
    end
    else
    begin
      if FCurrentObject is TCtMetaTable then
      begin
        FFrameCtTableList.actNewField.Visible := True;
        FFrameCtTableList.MN_RESERVED1.Visible := True;
        FFrameCtTableList.MN_RESERVED2.Visible := True;
        FFrameCtTableList.MN_RESERVED3.Visible := True;
        ShowTableProp(TCtMetaTable(FCurrentObject));
      end
      else if FCurrentObject is TCtMetaField then
      begin
        //FFrameCtTableProp.actAddSysFields.Visible := False;
        FFrameCtTableList.actNewField.Visible := False;
        FFrameCtTableList.MN_RESERVED1.Visible := False;
        FFrameCtTableList.MN_RESERVED2.Visible := False;
        FFrameCtTableList.MN_RESERVED3.Visible := False;
        ShowFieldProp(TCtMetaField(FCurrentObject));
      end;
    end; 
  finally
    FIsRefreshing := False;
  end;
end;

procedure TFrameCtTableDef.ShowTableProp(ATb: TCtMetaTable);
begin
  PanelTableProp.Visible := True;
  PanelFieldProp.Visible := False;
  PanelDMLGraph.Visible := False;

  FFrameCtTableProp.Init(ATb, IsEditingMeta or FReadOnlyMode or (ATb = nil));
  FFrameCtTableProp.SetActsEnable(True);

  if Abs(FShouldFocusUITick-GetTickCount64) < 2000 then
  try
    if FFrameCtTableProp.PageControlTbProp.ActivePage = FFrameCtTableProp.TabSheetTable then
      Self.FFrameCtTableProp.StringGridTableFields.SetFocus
    else if FFrameCtTableProp.PageControlTbProp.ActivePage = FFrameCtTableProp.TabSheetDesc then
      Self.FFrameCtTableProp.MemoDesc.SetFocus
    else if FFrameCtTableProp.PageControlTbProp.ActivePage = FFrameCtTableProp.TabSheetText then
      Self.FFrameCtTableProp.MemoTextContent.SetFocus;
  except
  end;
end;

procedure TFrameCtTableDef.ShowFieldProp(AFld: TCtMetaField);
var
  bReadOnly: boolean;
begin
  PanelFieldProp.Visible := True;
  PanelTableProp.Visible := False;
  FFrameCtTableProp.HideProps;
  PanelDMLGraph.Visible := False;
  FFrameCtTableProp.SetActsEnable(False);
  bReadOnly := FReadOnlyMode or (AFld = nil) or IsEditingMeta;
  Self.FFrameCtFieldDef.Init(AFld, bReadOnly);  
  if Abs(FShouldFocusUITick-GetTickCount64) < 2000 then
  try
    if FFrameCtFieldDef.PageControl1.ActivePage = FFrameCtFieldDef.TabSheet1 then
      Self.FFrameCtFieldDef.edtName.SetFocus;
  except
  end;
end;

procedure TFrameCtTableDef._HM_LOCTOCTOBJ(var msg: TMessage);
var
  fd: TCtMetaField;
  tb: TCtMetaTable;
  dml: TCtDataModelGraph;
  I: Integer;
begin
  if Self.FToLocCtObj = nil then
    Exit;
  fd := nil;
  tb := nil;
  dml := nil;
  if FToLocCtObj is TCtMetaField then
  begin
    fd := TCtMetaField(FToLocCtObj);
    tb := fd.OwnerTable;
    if tb = nil then
      Exit;
    if tb.OwnerList = nil then
      Exit;
    dml := tb.OwnerList.OwnerModel;
  end;
  if FToLocCtObj is TCtMetaTable then
  begin
    tb := TCtMetaTable(FToLocCtObj);
    if tb.OwnerList = nil then
      Exit;
    dml := tb.OwnerList.OwnerModel;
  end;
  if dml = nil then
    Exit;
  if tb = nil then
    Exit;

  if not PanelDMLGraph.Visible or (Self.FFrameDMLGraph.MetaTableModel <> dml) then
  begin
    Self.FFrameCtTableList.SelectedCtNode := dml;
    for I:=0 to 20 do
    begin
      Application.ProcessMessages;
      if PanelDMLGraph.Visible and (Self.FFrameDMLGraph.MetaTableModel = dml) then
        Break;
      Sleep(50);
    end;
  end;
  if PanelDMLGraph.Visible and (Self.FFrameDMLGraph.MetaTableModel = dml) then
  begin
    if fd <> nil then
      Self.FFrameDMLGraph.LocToCtObj(fd)
    else if tb <> nil then
      Self.FFrameDMLGraph.LocToCtObj(tb);
  end;
end;

procedure TFrameCtTableDef._HM_REFRESHPROP(var msg: TMessage);
begin
  FFramePropRefreshing := False;
  RefreshProp;
end;

procedure TFrameCtTableDef._OnBatchAddFields(Sender: TObject);
var
  I, C, fid: integer;
  fd, fdn: TCtMetaField;
  tb: TCtMetaTable;
  S: string;
begin    
  CheckCanEditMeta;
  C := 0;
  with FFrameCtTableList do
    for I := 0 to TreeViewCttbs.Items.Count - 1 do
      if TreeViewCttbs.Items[I].Selected then
        if TreeViewCttbs.Items[I].Data <> nil then
          if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
            if TCtMetaTable(TreeViewCttbs.Items[I].Data).IsTable then
            begin
              Inc(C);
            end;
  if C <= 1 then
    raise Exception.Create(srBatchTablesNotSelected);

  fd := TCtMetaField.Create;
  try
    fd.CreateDate := Now;
    fd.DataType := cfdtString;
    fd.MetaModified := True;
    if not Proc_ShowCtFieldProp(fd, False) then
      Exit;

    C := 0;
    with FFrameCtTableList do
      for I := 0 to TreeViewCttbs.Items.Count - 1 do
        if TreeViewCttbs.Items[I].Selected then
          if TreeViewCttbs.Items[I].Data <> nil then
            if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
              if TCtMetaTable(TreeViewCttbs.Items[I].Data).IsTable then
              begin
                tb := TCtMetaTable(TreeViewCttbs.Items[I].Data);
                if tb.MetaFields.FieldByName(fd.Name) = nil then
                begin
                  fdn := tb.MetaFields.NewMetaField;
                  fid := fdn.Id;
                  fdn.AssignFrom(fd);
                  fdn.ID := fid;
                  DoTablePropsChanged(tb);
                  Inc(C);
                end;
              end;
    FFrameCtTableList.RefreshTheTree;
    S := srBatchAddFields + ': ' + Format(srBatchOpResultFmt, [C]);
    Application.MessageBox(PChar(S), PChar(Application.Title), MB_OK or
      MB_ICONINFORMATION);
  finally
    fd.Free;
  end;
end;

procedure TFrameCtTableDef._OnCtFieldPropChange(Sender: TObject);
begin
  FFrameModified := True;
  if Sender is TCtMetaObject then
    _OnCtTablePropChange(0, TCtMetaObject(Sender), nil, '')
  else
    FFrameCtTableList.RefreshObj(FCurrentObject);
end;

procedure TFrameCtTableDef._OnCtObjShowProp(Sender: TObject);
var
  tb: TCtMetaTable;
  AField: TCtMetaField;
begin
  CheckSelectedObjects;
  if FCurrentObject is TCtMetaTable then
  begin
    tb := TCtMetaTable(FCurrentObject);
    if not Assigned(Proc_ShowCtTableProp) then
      raise Exception.Create('Proc_ShowCtTableProp not defined');
    if Proc_ShowCtTableProp(tb, FReadOnlyMode or IsTbPropDefViewMode, False) then
    begin
      _OnCtTablePropChange(0, tb, nil, '');
      RefreshProp;
    end;
    Exit;
  end;

  if FCurrentObject is TCtMetaField then
  begin
    AField := TCtMetaField(FCurrentObject);

    if not Assigned(Proc_ShowCtFieldProp) then
      raise Exception.Create('Proc_ShowCtFieldProp not defined');
    if Proc_ShowCtFieldProp(AField, FReadOnlyMode or IsEditingMeta) then
    begin
      FFrameModified := True;
      RefreshProp;
    end;
    Exit;
  end;
               
  if FCtDataModelList = nil then
    Exit;
  if FFrameDMLGraph.MetaTableModel=nil then
  begin
    if FCurrentObject is TCtDataModelGraph then
      FFrameDMLGraph.ShowModelProps(TCtDataModelGraph(FCurrentObject), False);
  end
  else
    FFrameDMLGraph.FFrameCtDML.actColorStyles.Execute;
end;

procedure TFrameCtTableDef._OnCtTablePropChange(Tp: integer;
  Obj1, Obj2: TCtMetaObject; param: string);
var
  vNode: TTreeNode;
begin
  FFrameModified := True;
  CheckAbort(' ');
  //tp: 0=Obj1.Prop,1=move,2=Obj1.Child 991BeginUpdate 992EndUpdate
  case tp of
    0:
      FFrameCtTableList.RefreshObj(Obj1);
    1:
      FFrameCtTableList.MoveTreeNodeOnly(Obj1, Obj2);
    2:
    begin
      vNode := FFrameCtTableList.GetTreeNodeOfCtNode(Obj1);
      if Assigned(vNode) then
      begin
        FFrameCtTableList.RefreshNode(vNode);
        FFrameCtTableList.RefreshNodeChild(vNode);
      end;
    end;
    991:
      FFrameCtTableList.TreeViewCttbs.Items.BeginUpdate;
    992:
      FFrameCtTableList.TreeViewCttbs.Items.EndUpdate;
  end;
end;

procedure TFrameCtTableDef._OnGenCodeSelected(Sender: TObject);
var
  I: integer;
  tbs: TCtMetaTableList;
begin           
  {$ifndef EZDML_LITE}
  tbs := TCtMetaTableList.Create;
  try
    tbs.AutoFree := False;
    with FFrameCtTableList do
      for I := 0 to TreeViewCttbs.Items.Count - 1 do
        if TreeViewCttbs.Items[I].Selected then
          if TreeViewCttbs.Items[I].Data <> nil then
            if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
              if TCtMetaTable(TreeViewCttbs.Items[I].Data).IsTable then
              begin
                tbs.Add(TCtMetaTable(TreeViewCttbs.Items[I].Data));
              end;

    if not Assigned(frmCtGenCode) then
      frmCtGenCode := TfrmCtGenCode.Create(Self);
    if tbs.Count > 0 then
      frmCtGenCode.MetaObjList := tbs
    else
      frmCtGenCode.CtDataModelList := FCtDataModelList;

    if frmCtGenCode.ShowModal = mrOk then
    begin
    end;
    frmCtGenCode.CtDataModelList := FCtDataModelList;
  finally
    tbs.Free;
  end;    
  {$else}
    raise Exception.Create(srEzdmlLiteNotSupportFun);
  {$endif}
end;

procedure TFrameCtTableDef._OnChatGPTSelected(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 8, 0);
end;

procedure TFrameCtTableDef._OnGenSqlSelected(Sender: TObject);
var
  I: integer;
  tbs: TCtMetaTableList;
begin
  tbs := TCtMetaTableList.Create;
  try
    tbs.AutoFree := False;
    with FFrameCtTableList do
      for I := 0 to TreeViewCttbs.Items.Count - 1 do
        if TreeViewCttbs.Items[I].Selected then
          if TreeViewCttbs.Items[I].Data <> nil then
            if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
              if TCtMetaTable(TreeViewCttbs.Items[I].Data).IsTable then
              begin
                tbs.Add(TCtMetaTable(TreeViewCttbs.Items[I].Data));
              end;

    if not Assigned(frmCtGenSQL) then
      frmCtGenSQL := TfrmCtGenSQL.Create(Self);
    if tbs.Count > 0 then
      frmCtGenSQL.MetaObjList := tbs
    else
      frmCtGenSQL.CtDataModelList := FCtDataModelList;
    frmCtGenSQL.SetWorkMode(0);

    if frmCtGenSQL.ShowModal = mrOk then
    begin
    end;
    frmCtGenSQL.CtDataModelList := FCtDataModelList;
  finally
    tbs.Free;
  end;
end;

procedure TFrameCtTableDef._OnBatchRemoveFields(Sender: TObject);
var
  I, C: integer;
  fd: TCtMetaField;
  tb: TCtMetaTable;
  S: string;
begin   
  CheckCanEditMeta;
  C := 0;
  with FFrameCtTableList do
    for I := 0 to TreeViewCttbs.Items.Count - 1 do
      if TreeViewCttbs.Items[I].Selected then
        if TreeViewCttbs.Items[I].Data <> nil then
          if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
            if TCtMetaTable(TreeViewCttbs.Items[I].Data).IsTable then
            begin
              Inc(C);
            end;
  if C <= 1 then
    raise Exception.Create(srBatchTablesNotSelected);

  S := InputBox(srBatchRemoveFields, srBatchRemoveFieldNamePrompt, '');
  if S = '' then
    Exit;

  C := 0;
  with FFrameCtTableList do
    for I := 0 to TreeViewCttbs.Items.Count - 1 do
      if TreeViewCttbs.Items[I].Selected then
        if TreeViewCttbs.Items[I].Data <> nil then
          if TObject(TreeViewCttbs.Items[I].Data) is TCtMetaTable then
            if TCtMetaTable(TreeViewCttbs.Items[I].Data).IsTable then
            begin
              tb := TCtMetaTable(TreeViewCttbs.Items[I].Data);
              fd := tb.MetaFields.FieldByName(S);
              if fd <> nil then
              begin
                tb.MetaFields.Remove(fd);
                DoTablePropsChanged(tb);
                Inc(C);
              end;
            end;
  FFrameCtTableList.RefreshTheTree;
  S := srBatchRemoveFields + ': ' + Format(srBatchOpResultFmt, [C]);
  Application.MessageBox(PChar(S), PChar(Application.Title), MB_OK or
    MB_ICONINFORMATION);
end;

procedure TFrameCtTableDef.ShowDMLGraph(mdl: TCtDataModelGraph);
begin
  PanelDMLGraph.Visible := True;
  PanelFieldProp.Visible := False;
  PanelTableProp.Visible := False;
  FFrameCtTableProp.HideProps;
  FFrameCtTableProp.SetActsEnable(False);
  Self.FFrameDMLGraph.Init(mdl, FReadOnlyMode, False);
  Self.FFrameDMLGraph.RewriteGraphDesc;   
  if Abs(FShouldFocusUITick-GetTickCount64) < 2000 then
    TryFocusGraph;
end;

end.
