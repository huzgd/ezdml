unit uFrameCtFieldDef;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, MaskEdit,
  CtMetaTable, CTMetaData, Buttons, ColorBox;

type

  { TFrameCtFieldDef }

  TFrameCtFieldDef = class(TFrame)
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    btnHideFieldProp: TBitBtn;
    ckbRequired: TCheckBox;
    ckbShowFilterBox: TCheckBox;
    ckbAutoMerge: TCheckBox;
    ckbHideOnView: TCheckBox;
    ckbHideOnList: TCheckBox;
    ckbHideOnEdit: TCheckBox;
    ckbColSortable: TCheckBox;
    ckbIsHidden: TCheckBox;
    ckbAutoTrim: TCheckBox;
    colobForeColor: TColorBox;
    colobBackColor: TColorBox;
    combAggregateFun: TComboBox;
    combFixColType: TComboBox;
    combTestDataType: TComboBox;
    combFontName: TComboBox;
    edtColGroup: TEdit;
    edtSheetGroup: TEdit;
    edtTextClipSize: TEdit;
    edtExplainText: TEdit;
    edtIndexFields: TEdit;
    edtItemColCount: TEdit;
    Label13: TLabel;
    Label17: TLabel;
    Label27: TLabel;
    Label56: TLabel;
    lbDemoData: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    memoDropDownItems: TMemo;
    memoDropDownSql: TMemo;
    memoEditorProps: TMemo;
    memoDBCheck: TMemo;
    MemoUILogic: TMemo;
    memoTestDataRules: TMemo;
    memoBusinessLogic: TMemo;
    memoValidateRule: TMemo;
    PageControl1: TPageControl;
    PanelCustomScriptDef: TPanel;
    sbtnSelIndexFields: TSpeedButton;
    sbtnSelRelateFields: TSpeedButton;
    ScrollBoxOperLogic: TScrollBox;
    ScrollBoxEditorUI: TScrollBox;
    ScrollBoxFieldDef: TScrollBox;
    ScrollBoxCustomScriptDef: TScrollBox;
    stFieldName: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    combDataType: TComboBox;
    combKeyFieldType: TComboBox;
    memoMemo: TMemo;
    edtDataLength: TEdit;
    combIndexType: TComboBox;
    Label8: TLabel;
    edtDefaultValue: TEdit;
    Label21: TLabel;
    edtRelateTable: TComboBox;
    Label1: TLabel;
    ckbNullable: TCheckBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    combMeasureUnit: TComboBox;
    Label14: TLabel;
    combEditorType: TComboBox;
    Label16: TLabel;
    edtLabelText: TEdit;
    Label5: TLabel;
    edtDisplayName: TEdit;
    Label19: TLabel;
    ckbEditorReadOnly: TCheckBox;
    ckbEditorEnabled: TCheckBox;
    Label20: TLabel;
    edtDisplayFormat: TEdit;
    Label22: TLabel;
    edtEditFormat: TEdit;
    Label28: TLabel;
    combDropDownMode: TComboBox;
    TabSheet3: TTabSheet;
    Label10: TLabel;
    Label11: TLabel;
    edtResType: TEdit;
    edtURL: TEdit;
    edtFormula: TEdit;
    Label2: TLabel;
    memoFormulaCondition: TMemo;
    Label12: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    edtFontSize: TEdit;
    Label25: TLabel;
    Label26: TLabel;
    ckbFontStyleB: TCheckBox;
    Bevel3: TBevel;
    Bevel4: TBevel;
    edtName: TEdit;
    Label7: TLabel;
    edtDataTypeName: TEdit;
    Label15: TLabel;
    edtRelateField: TEdit;
    Label29: TLabel;
    sbtnSearchFields: TSpeedButton;
    ckbAutoIncrement: TCheckBox;
    Label30: TLabel;
    MemoGraphicDesc: TMemo;
    Label18: TLabel;
    edtHint: TEdit;
    combVisibilty: TComboBox;
    Label32: TLabel;
    combTextAlign: TComboBox;
    Label31: TLabel;
    Label33: TLabel;
    edtInitValue: TEdit;
    Label34: TLabel;
    edtColWidth: TEdit;
    ckbSearchable: TCheckBox;
    edtMaxLength: TEdit;
    Label35: TLabel;
    Label36: TLabel;
    combValueFormat: TComboBox;
    edtValMin: TEdit;
    Label37: TLabel;
    edtValMax: TEdit;
    Label38: TLabel;
    ckbQueryable: TCheckBox;
    Label39: TLabel;
    memoExtraProps: TMemo;
    TabSheetCust: TTabSheet;
    lbCustomSCTip: TLabel;
    procedure combEditorChange(Sender: TObject);
    procedure combFontNameDropDown(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PanelCustomScriptDefResize(Sender: TObject);
    procedure sbtnSelIndexFieldsClick(Sender: TObject);
    procedure sbtnSelRelateFieldsClick(Sender: TObject);
    procedure ScrollBoxCustomScriptDefResize(Sender: TObject);
    procedure TabSheetCustShow(Sender: TObject);
    procedure ckbAutoIncrementClick(Sender: TObject);
    procedure edtDefaultValueChange(Sender: TObject);
    procedure sbtnSearchFieldsClick(Sender: TObject);
    procedure edtRelateTableChange(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
    procedure combForeColorKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure combDataTypeChange(Sender: TObject);
  private
    { Private declarations }
    FReadOnlyMode: boolean;
    FMetaField: TCtMetaField;
    FInited: boolean;
    FSCInited: boolean;
    FSavingChg: boolean;
    FFieldTpChanging: boolean;
    FOnFieldPropChange: TNotifyEvent;
    FCustDmlScControls: TObject; //TDmlScriptControlList
    FSelTable: TCtMetaTable;

    procedure _OnCustDmlCtrlValueExec(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetDataTypeLines: string;

    procedure Init(AField: TCtMetaField; bReadOnly: boolean);
    procedure SaveChange(Sender: TObject);

    procedure RunCustomScriptDef(bReInitSettings: boolean);

    property OnFieldPropChange: TNotifyEvent
      read FOnFieldPropChange write FOnFieldPropChange;
    property SelTable: TCtMetaTable read FSelTable write FSelTable;
  end;

implementation

uses
  dmlstrs, CtObjXmlSerial, DmlScriptPublic, DmlScriptControl,
  WindowFuncs, uFormSelectFields, CtTestDataGen;

{$R *.lfm}



{ TFrameCtFieldDef }

constructor TFrameCtFieldDef.Create(AOwner: TComponent);
var
  v: TCtKeyFieldType;
  ss: TStringList;
  S: string;
begin
  inherited;

  TabStop := False;

  //TabSheet2.TabVisible := False;
  //TabSheet3.TabVisible := False;

  PageControl1.ActivePageIndex := 0;

  ss := TStringList.Create;

  combDataType.Items.Text := GetDataTypeLines;

  ss.Clear;
  for v := Low(TCtKeyFieldType) to High(TCtKeyFieldType) do
  begin
    if ShouldUseEnglishForDML then
      S := DEF_CTMETAFIELD_KEYFIELD_NAMES_ENG[v]
    else
      S := DEF_CTMETAFIELD_KEYFIELD_NAMES_CHN[v];
    if v = cfktId then
      S := S + '(' + srDmlPrimaryKey + ')';
    if v = cfktRid then
      S := S + '(' + srDmlForeignKey + ')';
    ss.Add(S);
  end;
  combKeyFieldType.Items.Text := ss.Text;

  ss.Clear;
  ss.Add(srDmlNoIndex);
  ss.Add(srDmlUniqueIndex);
  ss.Add(srDmlNormalIndex);
  combIndexType.Items.Text := ss.Text;

(*
combEditorType
普通编辑框
按钮编辑框
微调编辑框
整数
浮点
货币
日期
日期时间
下拉框
单选框
复选框
图像
HTML
文件

MeasureUnit
个
台
箱
包
辆
本
片
双
米
千米
厘米
毫米
尺
英尺
英寸
毫克
克
斤
公斤
吨
平方米
升
毫升
立方米
元
港元
美元
欧元

DropDownMode
无
固定下拉列表
可编辑
可添加

Aggre
无
求和
计数
平均值
标准差


*)
  ss.Free;


  combVisibilty.Items.Text := GetCtDropDownItemsText(srFieldVisibiltys);
  combEditorType.Items.Text := GetCtDropDownItemsText(srFieldEditorTypes);
  combFixColType.Items.Text := srFieldFixColType;
  combTextAlign.Items.Text := srFieldTextAlign;
  combDropDownMode.Items.Text := GetCtDropDownItemsText(srFieldDropDownMode);
  combAggregateFun.Items.Text := GetCtDropDownItemsText(srFieldAggregateFun);
  combValueFormat.Items.Text := GetCtDropDownItemsText(srFieldValueFormats);
  combTestDataType.Items.Text := GetDataGenRules.GetItemNameCaptions;

  combMeasureUnit.Items.Text := srFieldMeasureUnits;

  FCustDmlScControls := TDmlScriptControlList.Create;
  TDmlScriptControlList(FCustDmlScControls).OnCtrlValueExec :=
    Self._OnCustDmlCtrlValueExec;
end;

destructor TFrameCtFieldDef.Destroy;
begin

  FreeAndNil(FCustDmlScControls);
  inherited;
end;

procedure TFrameCtFieldDef.Init(AField: TCtMetaField; bReadOnly: boolean);

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
  I: integer;
  ATbList: TCtMetaTableList;
  S: string;
begin
  if FFieldTpChanging then
    Exit;
               
  if G_CustomPropUICaption <> '' then
    TabSheetCust.Caption := G_CustomPropUICaption;
  FInited := False;
  FSCInited := False;
  FReadOnlyMode := bReadOnly;
  FMetaField := AField;
  if FMetaField = nil then
    FReadOnlyMode := True;

  edtRelateTable.Items.Clear;

  for I := 0 to TabSheet1.ControlCount - 1 do
    SetControlReadOnly(TabSheet1.Controls[I]);
  for I := 0 to TabSheet2.ControlCount - 1 do
    SetControlReadOnly(TabSheet2.Controls[I]);
  for I := 0 to TabSheet3.ControlCount - 1 do
    SetControlReadOnly(TabSheet3.Controls[I]);

  if FMetaField = nil then
  begin
    edtName.Text := '';
    stFieldName.Caption := '';
    edtDisplayName.Text := '';
    edtHint.Text := '';
    memoMemo.Lines.Text := '';   
    memoDBCheck.Lines.Text := '';
    Exit;
  end;


  ATbList := nil;
  if Assigned(FMetaField.OwnerTable) then
    ATbList := FMetaField.OwnerTable.OwnerList;
  if not Assigned(ATbList) then
    if Assigned(FGlobeDataModelList) then
      ATbList := FGlobeDataModelList.CurDataModel.Tables;
  if Assigned(ATbList) then
    for I := 0 to ATbList.Count - 1 do
      if ATbList[I].DataLevel <> ctdlDeleted then
        edtRelateTable.Items.AddObject(ATbList[I].Name, ATbList[I]);


  {if Assigned(FMetaField.OwnerTable) then
    edtTitlePrompt.Text := FMetaField.OwnerTable.Name + '.' + FMetaField.Name
  else
    edtTitlePrompt.Text := FMetaField.Name;}
  // Label7.Caption:=FloatToStr(FMetaField.OrderNo);
  edtName.Text := FMetaField.Name;
  stFieldName.Caption := FMetaField.NameCaption;
  edtDisplayName.Text := FMetaField.DisplayName;
  edtHint.Text := FMetaField.Hint;
  memoMemo.Lines.Text := FMetaField.Memo;   
  memoDBCheck.Lines.Text := FMetaField.DBCheck;

  combDataType.Items.Text := GetDataTypeLines;
  I := integer(FMetaField.DataType);
  if (FMetaField.DataTypeName <> '') and
    (combDataType.Items.IndexOf(FMetaField.DataTypeName) >= 0) then
    I := combDataType.Items.IndexOf(FMetaField.DataTypeName);
  combDataType.ItemIndex := I;

  edtDataTypeName.Text := FMetaField.DataTypeName;
  if (FMetaField.DataLength = 0) and (FMetaField.DataScale = 0) then
    edtDataLength.Text := ''
  else if (FMetaField.DataType <> cfdtFloat) or (FMetaField.DataScale = 0) then
    edtDataLength.Text := IntToStrSp(FMetaField.DataLength)
  else
    edtDataLength.Text := IntToStr(FMetaField.DataLength) + ','
      + IntToStr(FMetaField.DataScale);
  combKeyFieldType.ItemIndex := integer(FMetaField.KeyFieldType);

  edtDefaultValue.Text := FMetaField.DefaultValue;
  edtDefaultValueChange(nil);
  ckbNullable.Checked := FMetaField.Nullable;
  ckbNullable.Enabled := FMetaField.KeyFieldType <> cfktId;
  combIndexType.ItemIndex := integer(FMetaField.IndexType);
  edtIndexFields.ReadOnly := (FMetaField.IndexType = cfitNone) or
    (FMetaField.DataType <> cfdtFunction);
  sbtnSelIndexFields.Enabled := not edtIndexFields.ReadOnly;
  Label40.Enabled := not edtIndexFields.ReadOnly;
  edtIndexFields.Text := FMetaField.IndexFields;
  edtRelateTable.Text := FMetaField.RelateTable;
  edtRelateField.Text := FMetaField.RelateField;
  edtRelateField.Modified := False;

  combEditorType.Text := GetCtDropDownTextOfValue(FMetaField.EditorType,
    srFieldEditorTypes);
  edtLabelText.Text := FMetaField.LabelText;
  edtExplainText.Text := FMetaField.ExplainText;
  combMeasureUnit.Text := FMetaField.MeasureUnit;

  edtDisplayFormat.Text := FMetaField.DisplayFormat;
  edtEditFormat.Text := FMetaField.EditFormat;
  ckbEditorReadOnly.Checked := FMetaField.EditorReadOnly;
  ckbEditorEnabled.Checked := FMetaField.EditorEnabled;
  ckbIsHidden.Checked := FMetaField.IsHidden;
  memoDropDownItems.Lines.Text := FMetaField.DropDownItems;
  S := IntToStr(integer(FMetaField.DropDownMode));
  combDropDownMode.Text := GetCtDropDownTextOfValue(S, srFieldDropDownMode);

  combVisibilty.Text := GetCtDropDownTextOfValue(IntToStr(FMetaField.Visibility),
    srFieldVisibiltys);
  combTextAlign.ItemIndex := integer(FMetaField.TextAlign);
  edtColWidth.Text := IntToStrSp(FMetaField.ColWidth);
  edtMaxLength.Text := IntToStrSp(FMetaField.MaxLength);
  ckbSearchable.Checked := FMetaField.Searchable;
  ckbQueryable.Checked := FMetaField.Queryable;
  edtInitValue.Text := FMetaField.InitValue;
  combValueFormat.Text := GetCtDropDownTextOfValue(FMetaField.ValueFormat,
    srFieldValueFormats);
  edtValMin.Text := FMetaField.ValueMin;
  edtValMax.Text := FMetaField.ValueMax;
  memoExtraProps.Text := FMetaField.ExtraProps;

  combFontName.Text := FMetaField.FontName;
  if Abs(FMetaField.FontSize) < 0.0001 then
    edtFontSize.Text := ''
  else
    edtFontSize.Text := FloatToStr(FMetaField.FontSize);
  ckbFontStyleB.Checked := FMetaField.FontStyle > 0;
  colobForeColor.Selected := FMetaField.ForeColor;
  colobBackColor.Selected := FMetaField.BackColor;

  edtURL.Text := FMetaField.Url;
  edtResType.Text := FMetaField.ResType;
  edtFormula.Text := FMetaField.Formula;
  memoFormulaCondition.Lines.Text := FMetaField.FormulaCondition;
  combAggregateFun.Text := GetCtDropDownTextOfValue(FMetaField.AggregateFun,
    srFieldAggregateFun);
  memoValidateRule.Lines.Text := FMetaField.ValidateRule;
  MemoGraphicDesc.Lines.Text := FMetaField.GraphDesc;

  edtExplainText.Text := FMetaField.ExplainText;
  edtTextClipSize.Text := IntToStrSp(FMetaField.TextClipSize);
  memoDropDownSQL.Text := FMetaField.DropDownSQL;
  edtItemColCount.Text := IntToStrSp(FMetaField.ItemColCount);
  combFixColType.ItemIndex := integer(FMetaField.FixColType);
  ckbHideOnList.Checked := FMetaField.HideOnList;
  ckbHideOnEdit.Checked := FMetaField.HideOnEdit;
  ckbHideOnView.Checked := FMetaField.HideOnView;
  ckbAutoMerge.Checked := FMetaField.AutoMerge;
  edtColGroup.Text := FMetaField.ColGroup;
  edtSheetGroup.Text := FMetaField.SheetGroup;
  ckbColSortable.Checked := FMetaField.ColSortable;
  ckbShowFilterBox.Checked := FMetaField.ShowFilterBox;
  ckbAutoTrim.Checked := FMetaField.AutoTrim;
  ckbRequired.Checked := FMetaField.Required;
  memoEditorProps.Text := FMetaField.EditorProps;
  combTestDataType.Text := GetFullTextOfValue(FMetaField.TestDataType,
    GetDataGenRules.GetItemNameCaptions);
  memoTestDataRules.Text := FMetaField.TestDataRules;
  if Trim(memoTestDataRules.Text) = '' then
    if GetDataGenRules.ItemByCaption(FMetaField.TestDataType) <> nil then
    begin
      memoTestDataRules.Text :=
        GetDataGenRules.ItemByCaption(FMetaField.TestDataType).Content;
    end;
  memoTestDataRules.Modified := False;
  memoUILogic.Text := FMetaField.UILogic;
  memoBusinessLogic.Text := FMetaField.BusinessLogic;

  try
    lbDemoData.Caption := FMetaField.GenDemoData(0, '', nil) + #13#10
      + FMetaField.GenDemoData(1, '', nil) + ', ' +
      FMetaField.GenDemoData(2, '', nil) + '...';
  except
    Application.HandleException(Self);
  end;

  FInited := True;
  lbCustomSCTip.Caption := '';
  lbCustomSCTip.Visible := False;

  TabSheetCust.TabVisible := G_EnableCustomPropUI;
  if Self.PageControl1.ActivePage = TabSheetCust then
  begin
    Self.TabSheetCustShow(TabSheetCust);
  end;
  PageControl1Change(nil);
end;

procedure TFrameCtFieldDef.RunCustomScriptDef(bReInitSettings: boolean);
var
  FileTxt, AOutput: TStrings;
  S, fn: string;
begin
  if FMetaField = nil then
    Exit;
  if not G_EnableCustomPropUI then
    Exit;
  fn := 'CustomFieldDef';
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
    SetGParamValue('CurFieldPropReadOnly', '1')
  else
    SetGParamValue('CurFieldPropReadOnly', '0');
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

        Init('DML_SCRIPT', FMetaField, AOutput, FCustDmlScControls);
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

procedure TFrameCtFieldDef.SaveChange(Sender: TObject);

  function StrToIntDefSp(str: string; def: integer): integer;
  begin
    Result := StrToIntDef(trim(str), def);
  end;

var
  S, S1, S2: string;
  po: integer;
  dt: TCtFieldDataType;
  bNL: boolean;
begin
  if not FInited then
    Exit;
  if FSavingChg then
    Exit;
  FSavingChg := True;
  try

    S1 := FMetaField.JsonStr;

    if Sender = edtName then
    begin
      if FMetaField.Name <> edtName.Text then
      begin
        FMetaField.Name := edtName.Text;
      end;
      stFieldName.Caption := FMetaField.NameCaption;
    end;
    if Sender = edtDisplayName then
      FMetaField.DisplayName := edtDisplayName.Text;
    if Sender = edtHint then
      FMetaField.Hint := edtHint.Text;
    if Sender = memoMemo then
      FMetaField.Memo := memoMemo.Lines.Text;    
    if Sender = memoDBCheck then
      FMetaField.DBCheck := memoDBCheck.Lines.Text;

    if (Sender = combDataType) and (combDataType.ItemIndex <=
      integer(High(TCtFieldDataType))) then
      if FMetaField.DataType <> TCtFieldDataType(combDataType.ItemIndex) then
      begin
        FMetaField.DataType := TCtFieldDataType(combDataType.ItemIndex);
        edtIndexFields.ReadOnly :=
          (FMetaField.IndexType = cfitNone) or (FMetaField.DataType <> cfdtFunction);
        sbtnSelIndexFields.Enabled := not edtIndexFields.ReadOnly;
        Label40.Enabled := not edtIndexFields.ReadOnly;
      end;
    if Sender = edtDataTypeName then
    begin
      FMetaField.DataTypeName := Trim(edtDataTypeName.Text);
      dt := GetCtFieldDataTypeOfAlias(FMetaField.DataTypeName);
      if (dt <> cfdtUnknow) and (dt <> FMetaField.DataType) then
      begin
        FMetaField.DataType := dt;
        combDataType.ItemIndex := integer(FMetaField.DataType);
      end;
    end;
    if Sender = edtDataLength then
    begin
      S := edtDataLength.Text;
      if Trim(S) = '' then
      begin
        FMetaField.DataLength := 0;
        FMetaField.DataScale := 0;
      end
      else
      begin
        S := StringReplace(S, '，', ',', [rfReplaceAll]);
        po := Pos(',', S);
        if po > 0 then
        begin
          FMetaField.DataLength :=
            StrToIntDefSp(Trim(Copy(S, 1, po - 1)), FMetaField.DataLength);
          S := Trim(Copy(S, po + 1, Length(S)));
          FMetaField.DataScale := StrToIntDefSp(S, FMetaField.DataScale);
        end
        else
        begin
          FMetaField.DataLength := StrToIntDefSp(S, FMetaField.DataLength);
          FMetaField.DataScale := 0;
        end;
      end;
    end;
    if Sender = combKeyFieldType then
      if FMetaField.KeyFieldType <> TCtKeyFieldType(combKeyFieldType.ItemIndex) then
      begin
        bNL := FMetaField.Nullable;
        FMetaField.KeyFieldType := TCtKeyFieldType(combKeyFieldType.ItemIndex);
        ckbNullable.Enabled := FMetaField.KeyFieldType <> cfktId;
        if FMetaField.KeyFieldType = cfktId then
        begin
          if ckbNullable.Checked then
          begin
            ckbNullable.Checked := False;
            FMetaField.Nullable := bNL;
          end;
        end
        else
          ckbNullable.Checked := FMetaField.Nullable;
      end;
    if Sender = edtDefaultValue then
      FMetaField.DefaultValue := edtDefaultValue.Text;
    if Sender = ckbNullable then
    begin
      FMetaField.Nullable := ckbNullable.Checked;
      if FMetaField.Nullable <> ckbNullable.Checked then
        ckbNullable.Checked := FMetaField.Nullable;
    end;
    if Sender = combIndexType then
    begin
      FMetaField.IndexType := TCtFieldIndexType(combIndexType.ItemIndex);
      edtIndexFields.ReadOnly :=
        (FMetaField.IndexType = cfitNone) or (FMetaField.DataType <> cfdtFunction);
      sbtnSelIndexFields.Enabled := not edtIndexFields.ReadOnly;
      Label40.Enabled := not edtIndexFields.ReadOnly;
    end;
    if Sender = edtIndexFields then
      FMetaField.IndexFields := edtIndexFields.Text;
    if Sender = edtRelateTable then
      FMetaField.RelateTable := edtRelateTable.Text;
    if Sender = edtRelateField then
      FMetaField.RelateField := edtRelateField.Text;

    if Sender = combEditorType then
      FMetaField.EditorType :=
        GetCtDropDownValueOfText(combEditorType.Text, srFieldEditorTypes);
    if Sender = edtLabelText then
      FMetaField.LabelText := edtLabelText.Text;
    if Sender = edtExplainText then
      FMetaField.ExplainText := edtExplainText.Text;
    if Sender = combMeasureUnit then
      FMetaField.MeasureUnit := combMeasureUnit.Text;

    if Sender = edtDisplayFormat then
      FMetaField.DisplayFormat := edtDisplayFormat.Text;
    if Sender = edtEditFormat then
      FMetaField.EditFormat := edtEditFormat.Text;
    if Sender = ckbEditorReadOnly then
      FMetaField.EditorReadOnly := ckbEditorReadOnly.Checked;
    if Sender = ckbEditorEnabled then
      FMetaField.EditorEnabled := ckbEditorEnabled.Checked;
    if Sender = ckbIsHidden then
      FMetaField.IsHidden := ckbIsHidden.Checked;
    if Sender = memoDropDownItems then
      FMetaField.DropDownItems := memoDropDownItems.Lines.Text;
    if Sender = combDropDownMode then
    begin
      FMetaField.DropDownMode :=
        TCtFieldDropDownMode(StrToIntDefSp(GetCtDropDownValueOfText(
        combDropDownMode.Text, srFieldDropDownMode), integer(FMetaField.DropDownMode)));
    end;

    if Sender = combVisibilty then
      FMetaField.Visibility :=
        StrToIntDefSp(GetCtDropDownValueOfText(combVisibilty.Text, srFieldVisibiltys),
        FMetaField.Visibility);
    if Sender = combTextAlign then
      FMetaField.TextAlign := TCtTextAlignment(combTextAlign.ItemIndex);
    if Sender = edtColWidth then
      FMetaField.ColWidth := StrToIntDefSp(edtColWidth.Text, 0);
    if Sender = edtMaxLength then
      FMetaField.MaxLength := StrToIntDefSp(edtMaxLength.Text, 0);
    if Sender = ckbSearchable then
      FMetaField.Searchable := ckbSearchable.Checked;
    if Sender = ckbQueryable then
      FMetaField.Queryable := ckbQueryable.Checked;
    if Sender = edtInitValue then
      FMetaField.InitValue := edtInitValue.Text;
    if Sender = combValueFormat then
      FMetaField.ValueFormat :=
        GetCtDropDownValueOfText(combValueFormat.Text, srFieldValueFormats);
    if Sender = edtValMin then
      FMetaField.ValueMin := edtValMin.Text;
    if Sender = edtValMax then
      FMetaField.ValueMax := edtValMax.Text;
    if Sender = memoExtraProps then
      FMetaField.ExtraProps := memoExtraProps.Text;

    if Sender = combFontName then
      FMetaField.FontName := combFontName.Text;
    if Sender = edtFontSize then
      FMetaField.FontSize := StrToFloatDef(edtFontSize.Text, FMetaField.FontSize);
    if Sender = ckbFontStyleB then
      FMetaField.FontStyle := integer(ckbFontStyleB.Checked);
    if Sender = colobForeColor then
      FMetaField.ForeColor := colobForeColor.Selected;
    if Sender = colobBackColor then
      FMetaField.BackColor := colobBackColor.Selected;

    if Sender = edtURL then
      FMetaField.Url := edtURL.Text;
    if Sender = edtResType then
      FMetaField.ResType := edtResType.Text;
    if Sender = edtFormula then
      FMetaField.Formula := edtFormula.Text;
    if Sender = memoFormulaCondition then
      FMetaField.FormulaCondition := memoFormulaCondition.Lines.Text;
    if Sender = combAggregateFun then
      FMetaField.AggregateFun :=
        GetCtDropDownValueOfText(combAggregateFun.Text, srFieldAggregateFun);
    if Sender = memoValidateRule then
      FMetaField.ValidateRule := memoValidateRule.Lines.Text;
    if Sender = MemoGraphicDesc then
      FMetaField.GraphDesc := MemoGraphicDesc.Lines.Text;

    if Sender = edtExplainText then
      FMetaField.ExplainText := edtExplainText.Text;
    if Sender = edtTextClipSize then
      FMetaField.TextClipSize :=
        StrToIntDefSp(edtTextClipSize.Text, FMetaField.TextClipSize);
    if Sender = memoDropDownSQL then
      FMetaField.DropDownSQL := memoDropDownSQL.Text;
    if Sender = edtItemColCount then
      FMetaField.ItemColCount :=
        StrToIntDefSp(edtItemColCount.Text, FMetaField.ItemColCount);
    if Sender = combFixColType then
      FMetaField.FixColType := TCtFieldFixColType(combFixColType.ItemIndex);
    if Sender = ckbHideOnList then
      FMetaField.HideOnList := ckbHideOnList.Checked;
    if Sender = ckbHideOnEdit then
      FMetaField.HideOnEdit := ckbHideOnEdit.Checked;
    if Sender = ckbHideOnView then
      FMetaField.HideOnView := ckbHideOnView.Checked;
    if Sender = ckbAutoMerge then
      FMetaField.AutoMerge := ckbAutoMerge.Checked;
    if Sender = edtColGroup then
      FMetaField.ColGroup := edtColGroup.Text;
    if Sender = edtSheetGroup then
      FMetaField.SheetGroup := edtSheetGroup.Text;
    if Sender = ckbColSortable then
      FMetaField.ColSortable := ckbColSortable.Checked;
    if Sender = ckbShowFilterBox then
      FMetaField.ShowFilterBox := ckbShowFilterBox.Checked;
    if Sender = ckbAutoTrim then
      FMetaField.AutoTrim := ckbAutoTrim.Checked;
    if Sender = ckbRequired then
      FMetaField.Required := ckbRequired.Checked;
    if Sender = memoEditorProps then
      FMetaField.EditorProps := memoEditorProps.Text;
    if Sender = combTestDataType then
    begin
      S := combTestDataType.Text;
      if Pos(':', S) > 1 then
        S := Copy(S, 1, Pos(':', S) - 1);
      if FMetaField.TestDataType <> S then
      begin
        if Trim(FMetaField.TestDataRules) <> '' then
          if Application.MessageBox(PChar(srClearTestDataRuleWarning),
            PChar(Application.Title), MB_OKCANCEL or MB_ICONWARNING) <> idOk then
          begin
            combTestDataType.SetFocus;
            Abort;
          end;
        FMetaField.TestDataType := S;
        if GetDataGenRules.ItemByCaption(FMetaField.TestDataType) <> nil then
        begin
          memoTestDataRules.Text :=
            GetDataGenRules.ItemByCaption(FMetaField.TestDataType).Content;
        end
        else
          memoTestDataRules.Text := '';
        FMetaField.TestDataRules := '';
        memoTestDataRules.Modified := False;
      end;
    end;
    if Sender = memoTestDataRules then
      if memoTestDataRules.Modified then
        FMetaField.TestDataRules := memoTestDataRules.Text;
    if Sender = memoUILogic then
      FMetaField.UILogic := memoUILogic.Text;
    if Sender = memoBusinessLogic then
      FMetaField.BusinessLogic := memoBusinessLogic.Text;

    S2 := FMetaField.JsonStr;
    if S1 <> S2 then
    begin          
      FMetaField.SetCtObjModified(True);
      FFieldTpChanging := True;
      try
        DoTablePropsChanged(FMetaField.OwnerTable);
        if Assigned(FOnFieldPropChange) then
          FOnFieldPropChange(FMetaField);
      finally
        FFieldTpChanging := False;
      end;
    end;

    if (Sender = combTestDataType) or (Sender = memoTestDataRules) or
      (Sender = combValueFormat)
      or (Sender = combDataType) or (Sender = edtDataTypeName) then
    begin
      lbDemoData.Caption := FMetaField.GenDemoData(0, '', nil) + #13#10
        + FMetaField.GenDemoData(1, '', nil) + ', ' +
        FMetaField.GenDemoData(2, '', nil) + '...';
    end;

  finally
    FSavingChg := False;
  end;
end;

procedure TFrameCtFieldDef.sbtnSearchFieldsClick(Sender: TObject);
var
  res: TCtMetaObjectList;
  I: integer;
begin
  if not Assigned(Proc_ShowCtDmlSearch) then
    raise Exception.Create('Proc_ShowCtDmlSearch not defined');

  res := TCtMetaObjectList.Create;
  try
    Proc_ShowCtDmlSearch(FGlobeDataModelList, res);
    if FMetaField.OwnerTable = nil then
      Exit;

    for I := 0 to res.Count - 1 do
    begin
      if res[I] is TCtMetaField then
      begin
        FMetaField.AssignFrom(res[I] as TCtMetaField);
        Init(FMetaField, FReadOnlyMode);
        Break;
      end;
    end;
  finally
    res.Free;
  end;
end;

procedure TFrameCtFieldDef.TabSheetCustShow(Sender: TObject);
begin
  if not FSCInited then
    RunCustomScriptDef(True);
end;

procedure TFrameCtFieldDef.sbtnSelIndexFieldsClick(Sender: TObject);
var
  S, T, V: string;
begin
  if not FInited then
    Exit;
  if FSelTable = nil then
    FSelTable := FMetaField.OwnerTable;
  if FSelTable = nil then
    Exit;
  S := edtIndexFields.Text;
  V := CtSelectFields(FSelTable.Describe, S, '');
  if V = '' then
    Exit;
  if V = S then
    Exit;
  edtIndexFields.Text := V;
  SaveChange(edtIndexFields);

  T := Trim(memoMemo.Lines.Text);
  if (T = '') or (T = S) then
  begin
    memoMemo.Lines.Text := V;
    SaveChange(memoMemo);
  end;
end;

procedure TFrameCtFieldDef.sbtnSelRelateFieldsClick(Sender: TObject); var
  S, T, V: string;
var
  tb: TCtMetaTable;
begin
  if not FInited then
    Exit;
  tb := FMetaField.GetRelateTableObj;
  if tb = nil then
    tb := FMetaField.OwnerTable;
  if tb = nil then
    Exit;
  S := edtRelateField.Text;
  V := CtSelectFields(tb.Describe, S, '');
  if V = '' then
    Exit;
  if V = S then
    Exit;
  edtRelateField.Text := V;
  SaveChange(edtRelateField);
end;

procedure TFrameCtFieldDef.ScrollBoxCustomScriptDefResize(Sender: TObject);
begin
  PanelCustomScriptDef.Width := ScrollBoxCustomScriptDef.ClientWidth - 2;
end;

procedure TFrameCtFieldDef.PanelCustomScriptDefResize(Sender: TObject);
begin
  TDmlScriptControlList(FCustDmlScControls).RealignControls;
end;

procedure TFrameCtFieldDef.PageControl1Change(Sender: TObject);
begin
  if stFieldName.Tag = 1 then
    if PageControl1.ActivePage <> TabSheet1 then
    begin
      stFieldName.Visible := True;
    end
    else
      stFieldName.Visible := True;//False;
end;

procedure TFrameCtFieldDef.combEditorChange(Sender: TObject);
begin
  if Sender = nil then
    Exit;
  if not (Sender is TComboBox) then
    Exit;
  if TComboBox(Sender).ItemIndex < 0 then
    Exit;
  edtNameExit(Sender);
end;

procedure TFrameCtFieldDef.combFontNameDropDown(Sender: TObject);
begin
  if combFontName.Items.Count = 0 then
    combFontName.Items.Assign(Screen.Fonts);
end;


procedure TFrameCtFieldDef._OnCustDmlCtrlValueExec(Sender: TObject);
begin
  RunCustomScriptDef(False);
end;

procedure TFrameCtFieldDef.edtDefaultValueChange(Sender: TObject);
begin
  if ckbAutoIncrement.Checked then
  begin
    if Trim(edtDefaultValue.Text) <> DEF_VAL_auto_increment then
      ckbAutoIncrement.Checked := False;
  end
  else
  if Trim(edtDefaultValue.Text) = DEF_VAL_auto_increment then
    ckbAutoIncrement.Checked := True;
end;

procedure TFrameCtFieldDef.edtNameExit(Sender: TObject);
begin
  SaveChange(Sender);
end;

procedure TFrameCtFieldDef.edtRelateTableChange(Sender: TObject);
var
  S: string;
begin
  if not edtRelateField.Modified then
  begin
    if edtRelateTable.ItemIndex >= 0 then
    begin
      if FMetaField.KeyFieldType = cfktRid then
      begin
        S := TCtMetaTable(edtRelateTable.Items.Objects[edtRelateTable.ItemIndex]).KeyFieldName;
        if S <> '' then
        begin
          edtRelateField.Text := S;
          edtRelateField.Modified := False;
          SaveChange(edtRelateField);
        end;
      end;
    end
    else if edtRelateTable.Text = '' then
    begin
      edtRelateField.Text := '';
      edtRelateField.Modified := False;
      SaveChange(edtRelateField);
    end;
  end;
end;

function TFrameCtFieldDef.GetDataTypeLines: string;
var
  ss: TStringList;
  t: TCtFieldDataType;
  I: integer;
begin
  ss := TStringList.Create;
  try

    for t := Low(TCtFieldDataType) to High(TCtFieldDataType) do
      if ShouldUseEnglishForDML then
        ss.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t])
      else if DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t] =
        DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t] then
        ss.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t])
      else
        ss.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t] + '(' +
          DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t] + ')');
    for I := 0 to High(CtCustFieldTypeList) do
      ss.Add(CtCustFieldTypeList[I]);
    Result := ss.Text;

  finally
    ss.Free;
  end;
end;

procedure TFrameCtFieldDef.ckbAutoIncrementClick(Sender: TObject);
begin
  if ckbAutoIncrement.Checked then
    edtDefaultValue.Text := DEF_VAL_auto_increment
  else if Trim(edtDefaultValue.Text) = DEF_VAL_auto_increment then
    edtDefaultValue.Text := '';
  SaveChange(edtDefaultValue);
end;

procedure TFrameCtFieldDef.combDataTypeChange(Sender: TObject);
var
  S: string;
begin
  if not FInited or FFieldTpChanging then
    Exit;
  FFieldTpChanging := True;
  try
    if combDataType.ItemIndex <= integer(High(TCtFieldDataType)) then
    begin
      SaveChange(Sender);
      Exit;
    end;

    S := Trim(combDataType.Text);
    if S = '' then
      Exit;
    FMetaField.DataType := GetCtFieldDataTypeOfName(S);
    if FMetaField.DataType = cfdtUnknow then
    begin
      FMetaField.DataTypeName := S;
      FMetaField.DataType := GetCtFieldDataTypeOfAlias(S);
    end
    else if FMetaField.DataType = cfdtOther then
      FMetaField.DataTypeName := S
    else
      FMetaField.DataTypeName := '';
    edtDataTypeName.Text := FMetaField.DataTypeName; 
    FMetaField.SetCtObjModified(True);
    if Assigned(FOnFieldPropChange) then
      FOnFieldPropChange(Sender);
  finally
    FFieldTpChanging := False;
  end;
end;

procedure TFrameCtFieldDef.combForeColorKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
      VK_DELETE, VK_BACK:
        ; //TRzColorComboBox(Sender).ItemIndex := 0;
    end;
end;

end.
