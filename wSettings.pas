unit wSettings;

{$mode delphi}

{
Settings
--------------------------------------
AutoSaveMinutes               Integer
SaveTempFileOnExit            Bool
HugeModeTableCount            Integer
MaxRowCountForTableData       Integer
LogicNamesForTableData        Bool
CreateSeqForOracle            Bool
OCILIB                        String
NLSLang                       String
MYSQLLIB                      String
POSTGRESLIB                   String
SQLSERVERLIB                  String 
UseOdbcDriverForMsSql         Bool
SQLITELIB                     String
QuotReservedNames             Bool    
QuotAllNames                  Bool
BackupBeforeAlterColumn       Bool
WriteConstraintToDescribeStr  Bool
FieldGridShowLines            Bool
AddColCommentToCreateTbSql    Bool    
CreateIndexForForeignkey      Bool
EnableCustomPropUI            Bool
CustomPropUICaption           String 
EnableAdvTbProp               Bool
LANG                          String
AppDefFontName                String
AppDefFontSize                Integer
AppFixWidthFontName           String
AppFixWidthFontSize           Integer
DmlGraphFontName              String
FieldNameMaxDrawSize          Integer
FieldTypeMaxDrawSize          Integer
TableFieldMaxDrawCount        Integer
TableDialogViewModeByDefault  Bool
}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls;

type

  { TfrmSettings }

  TfrmSettings = class(TForm)
    Bevel1: TBevel;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Bevel13: TBevel;
    Bevel14: TBevel;
    Bevel15: TBevel;
    Bevel16: TBevel;
    Bevel17: TBevel;
    Bevel18: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    BevelGen1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    btnCancel: TButton;
    btnOk: TButton;
    btnOracleLibBrs: TButton;
    btnMysqlLibBrs: TButton;
    btnPostgreLibBrs: TButton;
    btnSqlServerLibBrs: TButton;
    btnSqliteLibBrs: TButton;
    btnCustFldtpNew: TButton;
    btnCustFldtpRemove: TButton;
    btnNewCustPhyTp: TButton;
    btnRemoveCustPhyTp: TButton;
    btnTpnRepNew: TButton;
    btnFDGenNew: TButton;
    btnTpnRepRemove: TButton;
    btnFDGenRemove: TButton;
    ckbEnableAdvTbProp: TCheckBox;
    ckbUseOdbcDriverForMsSql: TCheckBox;
    ckbAddColCommentToCreateTbSql: TCheckBox;
    ckbCheckForUpdates: TCheckBox;
    ckbCreateSeqForOracle: TCheckBox;
    ckbCreateIndexForForeignkey: TCheckBox;
    ckbTableDialogViewModeByDefault: TCheckBox;
    ckbQuotAllNames: TCheckBox;
    ckbSaveTempFileOnExit: TCheckBox;
    ckbWriteConstraintToDescribeStr: TCheckBox;
    ckbLogicNamesForTableData: TCheckBox;
    ckbEnableCustomPropUI: TCheckBox;
    ckbQuotReservedNames: TCheckBox;
    ckbBackupBeforeAlterColumn: TCheckBox;
    ckbFieldGridShowLines: TCheckBox;
    combLANG: TComboBox;
    combDefPhyTpLogicType: TComboBox;
    combNLSLang: TComboBox;
    edtCustomPropUICaption: TEdit;
    edtCustFldtpName: TEdit;
    edtCustFldtpPhyType: TEdit;
    edtCustomPhyType: TEdit;
    edtScreenDpi: TEdit;
    edtPOSTGRESLIB: TEdit;
    edtFDGenNames: TEdit;
    edtTpnRepPattern: TEdit;
    edtTpnReplacement: TEdit;
    edtAppDefFontName: TComboBox;
    edtAppDefFontSize: TEdit;
    edtAppFixWidthFontName: TComboBox;
    edtAppFixWidthFontSize: TEdit;
    edtAutoSaveMinutes: TEdit;
    edtDmlGraphFontName: TComboBox;
    edtFieldNameMaxDrawSize: TEdit;
    edtFieldTypeMaxDrawSize: TEdit;
    edtHugeModeTableCount: TEdit;
    edtMYSQLLIB: TEdit;
    edtSQLSERVERLIB: TEdit;
    edtSQLITELIB: TEdit;
    edtMaxRowCountForTableData: TEdit;
    edtOCILIB: TEdit;
    edtTableFieldMaxDrawCount: TEdit;
    edtFDGenRule: TEdit;
    GroupBoxDBConnPostgre: TGroupBox;
    GroupBoxKnownTbPrefix: TGroupBox;
    GroupBoxCustDict: TGroupBox;
    GroupBoxSysFldTypes: TGroupBox;
    GroupBoxCustomFldTypes: TGroupBox;
    GroupBoxTpNameReplaces: TGroupBox;
    GroupBoxDispDmlGraph: TGroupBox;
    GroupBoxMonoFont: TGroupBox;
    GroupBoxAutoSave: TGroupBox;
    GroupBoxDBConnMysql: TGroupBox;
    GroupBoxDBConnSqlServer: TGroupBox;
    GroupBoxDBConnSqlite: TGroupBox;
    GroupBoxHugeMode: TGroupBox;
    GroupBoxTableDataSQL: TGroupBox;
    GroupBoxDBConnOracle: TGroupBox;
    GroupBoxFieldDataGenRules: TGroupBox;
    GroupBoxUI: TGroupBox;
    GroupBoxSQLGen: TGroupBox;
    GroupBoxOthersTb: TGroupBox;
    GroupBoxBaseFont: TGroupBox;
    Label1: TLabel;
    lbNLSLang: TLabel;
    lbScreenDpiInfo: TLabel;
    lbKnownTbPrefixTip: TLabel;
    LabelLayoutSpacer1: TLabel;
    lbCustFldtpName: TLabel;
    lbCustFldtpPhyType: TLabel;
    lbCustPhyTpTip: TLabel;
    lbAutoSaveTip: TLabel;
    lbDispFontNote: TLabel;
    lbCustDictTip: TLabel;
    lbPostgreLib: TLabel;
    lbTpnReplacement1: TLabel;
    lbTpnReplaceTip: TLabel;
    lbDBConnNote1: TLabel;
    lbDefPhyTpLogicType: TLabel;
    lbCustomPhyType: TLabel;
    lbFDGenTip: TLabel;
    lbTpnRepPattern: TLabel;
    lbTpnReplacement: TLabel;
    lbCustFldtpTip: TLabel;
    lbDBConnNote: TLabel;
    LabelLayoutSpacer: TLabel;
    lbAutoSaveMinutes: TLabel;
    lbTableDataPreviewRows: TLabel;
    lbDmlMaxFieldNameSize: TLabel;
    lbDmlMaxFieldTypeSize: TLabel;
    lbMysqlLib: TLabel;
    lbSqlServerLib: TLabel;
    lbSqliteLib: TLabel;
    lbOciLib: TLabel;
    lbMonoFontSize: TLabel;
    lbMonoFontName: TLabel;
    lbDmlFontName: TLabel;
    lbDmlMaxTbFieldCount: TLabel;
    lbLanguage: TLabel;
    lbBaseFontName: TLabel;
    lbBaseFontSize: TLabel;
    lbAutoSaveMinutesTail: TLabel;
    lbLanguageTip: TLabel;
    lbHugeModeTableCount: TLabel;
    lbHugeModeTableCountTip: TLabel;
    lbTpnRepPattern1: TLabel;
    ListBoxCustFldTps: TListBox;
    ListBoxDefPhyTypes: TListBox;
    ListBoxTpNameReplaces: TListBox;
    ListBoxFDGenRules: TListBox;
    MemoKnownTbPrefixs: TMemo;
    MemoCustDict: TMemo;
    OpenDialogDbLib: TOpenDialog;
    PageControlMain: TPageControl;
    Panel1: TPanel;
    PanelFieldTypes: TPanel;
    PanelGen1: TPanel;
    PanelSQL: TPanel;
    PanelDBConn: TPanel;
    PanelOthers: TPanel;
    PanelDisp: TPanel;
    ScrollBoxFieldTypes: TScrollBox;
    tabshtFieldTypes: TTabSheet;
    tabshtOthers: TTabSheet;
    tabshtConnection: TTabSheet;
    tabshtSQL: TTabSheet;
    tabshtDisplay: TTabSheet;
    tabshtGeneral: TTabSheet;
    procedure btnCustFldtpNewClick(Sender: TObject);
    procedure btnCustFldtpRemoveClick(Sender: TObject);
    procedure btnFDGenNewClick(Sender: TObject);
    procedure btnFDGenRemoveClick(Sender: TObject);
    procedure btnMysqlLibBrsClick(Sender: TObject);
    procedure btnNewCustPhyTpClick(Sender: TObject);
    procedure btnOracleLibBrsClick(Sender: TObject);
    procedure btnPostgreLibBrsClick(Sender: TObject);
    procedure btnRemoveCustPhyTpClick(Sender: TObject);
    procedure btnSqliteLibBrsClick(Sender: TObject);
    procedure btnSqlServerLibBrsClick(Sender: TObject);
    procedure btnTpnRepNewClick(Sender: TObject);
    procedure btnTpnRepRemoveClick(Sender: TObject);
    procedure ckbEnableCustomPropUIChange(Sender: TObject);
    procedure edtCustFldtpNameChange(Sender: TObject);
    procedure edtCustomPhyTypeChange(Sender: TObject);
    procedure edtFDGenRuleChange(Sender: TObject);
    procedure edtTpnRepPatternChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxCustFldTpsClick(Sender: TObject);
    procedure ListBoxDefPhyTypesClick(Sender: TObject);
    procedure ListBoxFDGenRulesClick(Sender: TObject);
    procedure ListBoxTpNameReplacesClick(Sender: TObject);
  private        
    FCheckForUpdates: boolean;
    FAutoSaveMinutes: integer;
    FSaveTempFileOnExit: boolean;
    FHugeModeTableCount: integer;
    FMaxRowCountForTableData: integer;
    FLogicNamesForTableData: boolean;
    FCreateSeqForOracle: boolean;
    FOCILIB: string;
    FNLSLang: string;
    FMYSQLLIB: string;
    FSQLSERVERLIB: string;
    FPOSTGRESLIB: string;
    FSQLITELIB: string;
    FQuotReservedNames: boolean;
    FQuotAllNames: boolean;
    FBackupBeforeAlterColumn: boolean;
    FWriteConstraintToDescribeStr: boolean;
    FFieldGridShowLines :Boolean;
    FAddColCommentToCreateTbSql: boolean;   
    FCreateIndexForForeignkey: boolean;
    FEnableCustomPropUI: boolean;
    FCustomPropUICaption : String;
    FEnableAdvTbProp: boolean;
    FUseOdbcDriverForMsSql: boolean;
    FLANG: string;
    FAppDefFontName: string;
    FAppDefFontSize: integer;
    FAppFixWidthFontName: string;
    FAppFixWidthFontSize: integer;
    FDmlGraphFontName: string;
    FFieldNameMaxDrawSize: integer;
    FFieldTypeMaxDrawSize: integer;
    FTableFieldMaxDrawCount: integer;     
    FTableDialogViewModeByDefault : Boolean;

    FIsInitingFt: boolean;

    procedure BrowseLibFile(AEdit: TEdit; ALibName1, ALibName2: string);       
    procedure CheckCustFieldEditors;
  public
    procedure LoadSetting;
    procedure SaveSetting;

    procedure InitEditors;
  end;

function ShowEzdmlSettings: boolean;

implementation

uses
  WindowFuncs, IniFiles, CtMetaTable, AutoNameCapitalize, dmlstrs, postgres3dyn,
  ocidyn, mysql57dyn, mssqlconn, dblib, sqlite3dyn, CtMetaCustomDb;

{$R *.lfm}

function ShowEzdmlSettings: boolean;
var
  frm: TfrmSettings;
begin
  Result := False;
  frm := TfrmSettings.Create(Application.MainForm);
  try
    frm.LoadSetting;
    if frm.ShowModal = mrOk then
    begin
      frm.SaveSetting;
      Result := True;
    end;
  finally
    frm.Free;
  end;
end;

{ TfrmSettings }

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  btnOk.Left := btnCancel.Left - btnOk.Width - 10; 
  edtCustomPropUICaption.Left:=ckbEnableCustomPropUI.Left+ckbEnableCustomPropUI.Width+12;
end;

procedure TfrmSettings.ListBoxCustFldTpsClick(Sender: TObject);
var
  I, po: integer;
  S, V: string;
begin
  I := ListBoxCustFldTps.ItemIndex;
  if I < 0 then
    S := ''
  else
    S := ListBoxCustFldTps.Items[I];
  V := '';
  po := Pos(':', S);
  if po > 0 then
  begin
    V := Copy(S, po + 1, Length(S));
    S := Copy(S, 1, po - 1);
  end;
  FIsInitingFt := True;
  edtCustFldtpName.Text := S;
  edtCustFldtpPhyType.Text := V;
  FIsInitingFt := False;
  CheckCustFieldEditors;
end;

procedure TfrmSettings.ListBoxDefPhyTypesClick(Sender: TObject);
var
  I, po: integer;
  S, V: string;
begin
  I := ListBoxDefPhyTypes.ItemIndex;
  if I < 0 then
    S := ''
  else
    S := ListBoxDefPhyTypes.Items[I];
  V := '';
  po := Pos(':', S);
  if po > 0 then
  begin
    V := Copy(S, po + 1, Length(S));
    S := Copy(S, 1, po - 1);
  end;
  FIsInitingFt := True;
  combDefPhyTpLogicType.ItemIndex := combDefPhyTpLogicType.Items.IndexOf(S);
  edtCustomPhyType.Text := V;
  FIsInitingFt := False;
  CheckCustFieldEditors;
end;

procedure TfrmSettings.ListBoxFDGenRulesClick(Sender: TObject);
var
  I, po: integer;
  S, V: string;
begin
  I := ListBoxFDGenRules.ItemIndex;
  if I < 0 then
    S := ''
  else
    S := ListBoxFDGenRules.Items[I];
  V := '';
  po := Pos(':', S);
  if po > 0 then
  begin
    V := Copy(S, po + 1, Length(S));
    S := Copy(S, 1, po - 1);
  end;
  FIsInitingFt := True;
  edtFDGenRule.Text := S;
  edtFDGenNames.Text := V;
  FIsInitingFt := False;
  CheckCustFieldEditors;
end;

procedure TfrmSettings.ListBoxTpNameReplacesClick(Sender: TObject);
var
  I, po: integer;
  S, V: string;
begin
  I := ListBoxTpNameReplaces.ItemIndex;
  if I < 0 then
    S := ''
  else
    S := ListBoxTpNameReplaces.Items[I];
  V := '';
  po := Pos(':', S);
  if po > 0 then
  begin
    V := Copy(S, po + 1, Length(S));
    S := Copy(S, 1, po - 1);
  end;
  FIsInitingFt := True;
  edtTpnRepPattern.Text := S;
  edtTpnReplacement.Text := V;
  FIsInitingFt := False;
  CheckCustFieldEditors;
end;

procedure TfrmSettings.BrowseLibFile(AEdit: TEdit; ALibName1, ALibName2: string
  );
var
  S: string;
begin
  if AEdit = nil then
    Exit;
  if ALibName2 = ALibName1 then
    ALibName2 := '';
  S := '';
  if ALibName1 <> '' then
    S := ALibName1 + '|' + ALibName1;
  if ALibName2 <> '' then
    S := S + '|' + ALibName2 + '|' + ALibName2;
  if S <> '' then
    S := S + '|';
  S := S + 'All files(*.*)|*.*';
  with OpenDialogDbLib do
  begin
    Filter := S;
    FileName := AEdit.Text;
    if Execute then
      AEdit.Text := FileName;
  end;
end;

procedure TfrmSettings.CheckCustFieldEditors;
var
  bSelA, bSelB, bSelC, bSelD: Boolean;
begin
  bSelA := ListBoxCustFldTps.ItemIndex >= 0;
  bSelB := ListBoxDefPhyTypes.ItemIndex >= 0;
  bSelC := ListBoxTpNameReplaces.ItemIndex >= 0;     
  bSelD := ListBoxFDGenRules.ItemIndex >= 0;

  edtCustFldtpName.Enabled := bSelA;
  edtCustFldtpPhyType.Enabled := bSelA;
  btnCustFldtpRemove.Enabled := bSelA;

  combDefPhyTpLogicType.Enabled := bSelB;
  edtCustomPhyType.Enabled := bSelB;
  btnRemoveCustPhyTp.Enabled := bSelB;

  edtTpnRepPattern.Enabled := bSelC;
  edtTpnReplacement.Enabled := bSelC;
  btnTpnRepRemove.Enabled := bSelC;

  edtFDGenRule.Enabled := bSelD;
  edtFDGenNames.Enabled := bSelD;
  btnFDGenRemove.Enabled := bSelD;
end;


procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  PageControlMain.ActivePageIndex := 0;
end;

procedure TfrmSettings.btnOracleLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtOCILIB, ocilib, '');
end;

procedure TfrmSettings.btnPostgreLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtPOSTGRESLIB, pqlib, '');
end;

procedure TfrmSettings.btnRemoveCustPhyTpClick(Sender: TObject);
var
  I: integer;
begin
  I := ListBoxDefPhyTypes.ItemIndex;
  if I >= 0 then
  begin
    ListBoxDefPhyTypes.Items.Delete(I);
    if I > ListBoxDefPhyTypes.Items.Count - 1 then
      I := ListBoxDefPhyTypes.Items.Count - 1;
    if I >= 0 then
      ListBoxDefPhyTypes.ItemIndex := I;
    ListBoxDefPhyTypesClick(nil);
    btnNewCustPhyTp.Enabled := True;
  end;
end;

procedure TfrmSettings.btnSqliteLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtSQLITELIB, Sqlite3Lib, '');
end;

procedure TfrmSettings.btnSqlServerLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtSQLSERVERLIB, DBLIBDLL, '');
end;

procedure TfrmSettings.btnTpnRepNewClick(Sender: TObject);
var
  S: string;
begin
  S := Trim(InputBox(srNewFieldTypeItemTitle, srNewFieldTypeItemPrompt, ''));
  if S <> '' then
  begin
    ListBoxTpNameReplaces.ItemIndex := ListBoxTpNameReplaces.Items.Add(S);
    ListBoxTpNameReplacesClick(nil);
  end;
end;

procedure TfrmSettings.btnTpnRepRemoveClick(Sender: TObject);
var
  I: integer;
begin
  I := ListBoxTpNameReplaces.ItemIndex;
  if I >= 0 then
  begin
    ListBoxTpNameReplaces.Items.Delete(I);
    if I > ListBoxTpNameReplaces.Items.Count - 1 then
      I := ListBoxTpNameReplaces.Items.Count - 1;
    if I >= 0 then
      ListBoxTpNameReplaces.ItemIndex := I;
    ListBoxTpNameReplacesClick(nil);
  end;
end;

procedure TfrmSettings.ckbEnableCustomPropUIChange(Sender: TObject);
begin
  edtCustomPropUICaption.Visible:=ckbEnableCustomPropUI.Checked;
end;

procedure TfrmSettings.edtCustFldtpNameChange(Sender: TObject);
var
  I: integer;
  S, V: string;
begin
  if FIsInitingFt then
    Exit;
  I := ListBoxCustFldTps.ItemIndex;
  if I < 0 then
    Exit;
  S := Trim(edtCustFldtpName.Text);
  if S = '' then
    Exit;
  V := Trim(edtCustFldtpPhyType.Text);
  if V <> '' then
    S := S + ':' + V;
  ListBoxCustFldTps.Items[I] := S;
end;

procedure TfrmSettings.edtCustomPhyTypeChange(Sender: TObject);
var
  I: integer;
  S, V: string;
begin
  if FIsInitingFt then
    Exit;
  I := ListBoxDefPhyTypes.ItemIndex;
  if I < 0 then
    Exit;
  S := Trim(combDefPhyTpLogicType.Text);
  if S = '' then
    Exit;
  V := Trim(edtCustomPhyType.Text);
  if V <> '' then
    S := S + ':' + V;
  ListBoxDefPhyTypes.Items[I] := S;
end;

procedure TfrmSettings.edtFDGenRuleChange(Sender: TObject);
var
  I: integer;
  S, V: string;
begin
  if FIsInitingFt then
    Exit;
  I := ListBoxFDGenRules.ItemIndex;
  if I < 0 then
    Exit;
  S := Trim(edtFDGenRule.Text);
  if S = '' then
    Exit;
  V := Trim(edtFDGenNames.Text);
  if V <> '' then
    S := S + ':' + V;
  ListBoxFDGenRules.Items[I] := S;
end;

procedure TfrmSettings.edtTpnRepPatternChange(Sender: TObject);
var
  I: integer;
  S, V: string;
begin
  if FIsInitingFt then
    Exit;
  I := ListBoxTpNameReplaces.ItemIndex;
  if I < 0 then
    Exit;
  S := Trim(edtTpnRepPattern.Text);
  if S = '' then
    Exit;
  V := Trim(edtTpnReplacement.Text);
  if V <> '' then
    S := S + ':' + V;
  ListBoxTpNameReplaces.Items[I] := S;
end;


procedure TfrmSettings.btnMysqlLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtMYSQLLIB, mysqllib, mysqlvlib);
end;

procedure TfrmSettings.btnNewCustPhyTpClick(Sender: TObject);
var
  I, J: integer;
  S, T: string;
  bExists: boolean;
begin
  for I := 0 to combDefPhyTpLogicType.Items.Count - 1 do
  begin
    S := combDefPhyTpLogicType.Items[I];
    bExists := False;
    for J := 0 to ListBoxDefPhyTypes.Items.Count - 1 do
    begin
      T := ListBoxDefPhyTypes.Items[J];
      if (T = S) or (Pos(S, T) = 1) then
      begin
        bExists := True;
        Break;
      end;
    end;
    if not bExists then
    begin
      ListBoxDefPhyTypes.ItemIndex := ListBoxDefPhyTypes.Items.Add(S);
      ListBoxDefPhyTypesClick(nil);
      Exit;
    end;
  end;
  btnNewCustPhyTp.Enabled := False;
end;

procedure TfrmSettings.btnCustFldtpNewClick(Sender: TObject);
var
  S: string;
begin
  S := Trim(InputBox(srNewFieldTypeItemTitle, srNewFieldTypeItemPrompt, ''));
  if S <> '' then
  begin
    ListBoxCustFldTps.ItemIndex := ListBoxCustFldTps.Items.Add(S);
    ListBoxCustFldTpsClick(nil);
  end;
end;

procedure TfrmSettings.btnCustFldtpRemoveClick(Sender: TObject);
var
  I: integer;
begin
  I := ListBoxCustFldTps.ItemIndex;
  if I >= 0 then
  begin
    ListBoxCustFldTps.Items.Delete(I);
    if I > ListBoxCustFldTps.Items.Count - 1 then
      I := ListBoxCustFldTps.Items.Count - 1;
    if I >= 0 then
      ListBoxCustFldTps.ItemIndex := I;
    ListBoxCustFldTpsClick(nil);
  end;
end;

procedure TfrmSettings.btnFDGenNewClick(Sender: TObject);
var
  S: string;
begin
  S := Trim(InputBox(srNewFieldTypeItemTitle, srNewFieldTypeItemPrompt, ''));
  if S <> '' then
  begin
    ListBoxFDGenRules.ItemIndex := ListBoxFDGenRules.Items.Add(S);
    ListBoxFDGenRulesClick(nil);
  end;
end;

procedure TfrmSettings.btnFDGenRemoveClick(Sender: TObject);
var
  I: integer;
begin
  I := ListBoxFDGenRules.ItemIndex;
  if I >= 0 then
  begin
    ListBoxFDGenRules.Items.Delete(I);
    if I > ListBoxFDGenRules.Items.Count - 1 then
      I := ListBoxFDGenRules.Items.Count - 1;
    if I >= 0 then
      ListBoxFDGenRules.ItemIndex := I;
    ListBoxFDGenRulesClick(nil);
  end;
end;



procedure TfrmSettings.LoadSetting;

  procedure LoadFtList(AList: TStrings; ini: TIniFile; ASec: string);
  var
    I: integer;
    S: string;
  begin
    I := 0;
    AList.Clear;
    while True do
    begin
      Inc(I);
      S := Trim(ini.ReadString(ASec, IntToStr(I), ''));
      if S = '' then
        Break;
      AList.Add(S);
    end;
  end;

  procedure LoadCustDict;
  var
    S, fn: string;
  begin
    MemoCustDict.Lines.Clear;
    fn := 'MyDict.txt';
    S := GetFolderPathOfAppExe;
    S := FolderAddFileName(S, fn);
    if FileExists(S) then
      MemoCustDict.Lines.LoadFromFile(S);
    MemoCustDict.Modified := False;
  end;

var
  ini: TIniFile;
  S: string;
begin
  InitEditors;

  S := GetAppDefTempPath;
  if not DirectoryExists(S) then
    ForceDirectories(S);

  ini := TIniFile.Create(GetConfFileOfApp);
  try
    //{1} := ini.Read{3}('Options', '{1}', F{1});    
    FCheckForUpdates := ini.ReadBool('Options', 'CheckForUpdates',
      True);
    FAutoSaveMinutes := ini.ReadInteger('Options', 'AutoSaveMinutes', 5);
    FSaveTempFileOnExit := ini.ReadBool('Options', 'SaveTempFileOnExit',
      True);
    FHugeModeTableCount := ini.ReadInteger('Options', 'HugeModeTableCount',
      500);
    FMaxRowCountForTableData := ini.ReadInteger('Options', 'MaxRowCountForTableData',
      25);
    FLogicNamesForTableData := ini.ReadBool('Options', 'LogicNamesForTableData',
      False);
    FCreateSeqForOracle := ini.ReadBool('Options', 'CreateSeqForOracle',
      False);
    FOCILIB := ini.ReadString('Options', 'OCILIB', '');
    if FOCILIB = '' then
      FOCILIB := ini.ReadString('Options', 'OCIDLL', ''); 
    FNLSLang := ini.ReadString('Options', 'NLSLang', '');
    FMYSQLLIB := ini.ReadString('Options', 'MYSQLLIB', FMYSQLLIB);
    FSQLSERVERLIB := ini.ReadString('Options', 'SQLSERVERLIB', FSQLSERVERLIB);
    FUseOdbcDriverForMsSql := ini.ReadBool('Options', 'UseOdbcDriverForMsSql',
      False);
    FPOSTGRESLIB := ini.ReadString('Options', 'POSTGRESLIB', FPOSTGRESLIB);
    FSQLITELIB := ini.ReadString('Options', 'SQLITELIB', FSQLITELIB);
    FQuotReservedNames := ini.ReadBool('Options', 'QuotReservedNames',
      True);                                      
    FQuotAllNames := ini.ReadBool('Options', 'QuotAllNames',
      False);
    FBackupBeforeAlterColumn := ini.ReadBool('Options', 'BackupBeforeAlterColumn',
      False);
    FWriteConstraintToDescribeStr :=
      ini.ReadBool('Options', 'WriteConstraintToDescribeStr',
      True);      
    FFieldGridShowLines :=
      ini.ReadBool('Options', 'FieldGridShowLines',
      False);
    FAddColCommentToCreateTbSql :=
      ini.ReadBool('Options', 'AddColCommentToCreateTbSql', True);    
    FCreateIndexForForeignkey :=
      ini.ReadBool('Options', 'CreateIndexForForeignkey', False);
    FEnableCustomPropUI := ini.ReadBool('Options', 'EnableCustomPropUI',
      False);       
    FCustomPropUICaption := ini.ReadString('Options', 'CustomPropUICaption', '');  
    FEnableAdvTbProp := ini.ReadBool('Options', 'EnableAdvTbProp',
      False);
    FLANG := ini.ReadString('Options', 'LANG', '');
    FAppDefFontName := ini.ReadString('Options', 'AppDefFontName', '');
    FAppDefFontSize := ini.ReadInteger('Options', 'AppDefFontSize', 0);
    FAppFixWidthFontName := ini.ReadString('Options', 'AppFixWidthFontName',
      '');
    FAppFixWidthFontSize := ini.ReadInteger('Options', 'AppFixWidthFontSize',
      0);
    FDmlGraphFontName := ini.ReadString('Options', 'DmlGraphFontName',
      '');
    FFieldNameMaxDrawSize := ini.ReadInteger('Options', 'FieldNameMaxDrawSize',
      64);
    FFieldTypeMaxDrawSize := ini.ReadInteger('Options', 'FieldTypeMaxDrawSize',
      48);
    FTableFieldMaxDrawCount := ini.ReadInteger('Options', 'TableFieldMaxDrawCount',
      50);      
    FTableDialogViewModeByDefault :=
      ini.ReadBool('Options', 'TableDialogViewModeByDefault',
      False);

    LoadFtList(ListBoxCustFldTps.Items, Ini, 'CustFieldTypes');
    LoadFtList(ListBoxDefPhyTypes.Items, Ini, 'DefaultFieldTypes');
    LoadFtList(ListBoxTpNameReplaces.Items, Ini, 'CustDataTypeReplaces');     
    LoadFtList(ListBoxFDGenRules.Items, Ini, 'CustFieldDataGenRules');

    LoadFtList(MemoKnownTbPrefixs.Lines, Ini, 'TbNamePrefixDefs');
  finally
    ini.Free;
  end;

  combLANG.Text := FLANG;
  ckbEnableCustomPropUI.Checked := FEnableCustomPropUI;
  edtCustomPropUICaption.Text := FCustomPropUICaption;
  ckbEnableAdvTbProp.Checked := FEnableAdvTbProp;
  edtCustomPropUICaption.Visible:=ckbEnableCustomPropUI.Checked;
  ckbCheckForUpdates.Checked := FCheckForUpdates;


  edtAutoSaveMinutes.Text := IntToStr(FAutoSaveMinutes);
  ckbSaveTempFileOnExit.Checked := FSaveTempFileOnExit;
  edtHugeModeTableCount.Text := IntToStr(FHugeModeTableCount);

  edtAppDefFontName.Text := FAppDefFontName;
  edtAppDefFontSize.Text := IntToStr(FAppDefFontSize);
  edtAppFixWidthFontName.Text := FAppFixWidthFontName;
  edtAppFixWidthFontSize.Text := IntToStr(FAppFixWidthFontSize);

  edtDmlGraphFontName.Text := FDmlGraphFontName;
  edtFieldNameMaxDrawSize.Text := IntToStr(FFieldNameMaxDrawSize);
  edtFieldTypeMaxDrawSize.Text := IntToStr(FFieldTypeMaxDrawSize);
  edtTableFieldMaxDrawCount.Text := IntToStr(FTableFieldMaxDrawCount);

  edtScreenDpi.Text := IntToStr(Screen.PixelsPerInch);

  ckbQuotReservedNames.Checked := FQuotReservedNames;  
  ckbQuotAllNames.Checked := FQuotAllNames;
  ckbBackupBeforeAlterColumn.Checked := FBackupBeforeAlterColumn;
  ckbAddColCommentToCreateTbSql.Checked := FAddColCommentToCreateTbSql;       
  ckbCreateIndexForForeignkey.Checked := FCreateIndexForForeignkey;
  ckbCreateSeqForOracle.Checked := FCreateSeqForOracle;

  edtMaxRowCountForTableData.Text := IntToStr(FMaxRowCountForTableData);
  ckbLogicNamesForTableData.Checked := FLogicNamesForTableData;

  edtOCILIB.Text := FOCILIB;
  combNLSLang.Text := FNLSLang;
  edtMYSQLLIB.Text := FMYSQLLIB;
  edtSQLSERVERLIB.Text := FSQLSERVERLIB;  
  ckbUseOdbcDriverForMsSql.Checked := FUseOdbcDriverForMsSql;
  edtPOSTGRESLIB.Text := FPOSTGRESLIB;
  edtSQLITELIB.Text := FSQLITELIB;


  ckbWriteConstraintToDescribeStr.Checked := FWriteConstraintToDescribeStr;        
  ckbFieldGridShowLines.Checked := FFieldGridShowLines;       
  ckbTableDialogViewModeByDefault.Checked := FTableDialogViewModeByDefault;
            
{$ifdef WIN32}
  lbDBConnNote.Caption := StringReplace(lbDBConnNote.Caption, '64', '32', []);
{$endif}
  LoadCustDict;
end;

procedure TfrmSettings.SaveSetting;

  procedure SaveFtList(AList: TStrings; ini: TIniFile; ASec: string);
  var
    I: integer;
  begin
    ini.EraseSection(ASec);
    with AList do
      for I := 0 to Count - 1 do
        ini.WriteString(ASec, IntToStr(I + 1), Strings[I]);
  end;

  procedure SaveCustDict;
  var
    S, fn: string;
  begin
    if not MemoCustDict.Modified then
      Exit;
    fn := 'MyDict.txt';
    S := GetFolderPathOfAppExe;
    S := FolderAddFileName(S, fn);
    if FileExists(S) then
      MemoCustDict.Lines.SaveToFile(S)
    else if Trim(MemoCustDict.Lines.Text) <> '' then
      MemoCustDict.Lines.SaveToFile(S);
    GetAutoNameCapitalizer.ReloadDictFile;
  end;

var
  ini: TIniFile;
  S: string;
begin
  FLANG := combLANG.Text;
  FEnableCustomPropUI := ckbEnableCustomPropUI.Checked;
  FCustomPropUICaption := edtCustomPropUICaption.Text;  
  FEnableAdvTbProp := ckbEnableAdvTbProp.Checked;
  FCheckForUpdates := ckbCheckForUpdates.Checked;


  FAutoSaveMinutes := StrToIntDef(edtAutoSaveMinutes.Text, FAutoSaveMinutes);
  FSaveTempFileOnExit := ckbSaveTempFileOnExit.Checked;
  FHugeModeTableCount := StrToIntDef(edtHugeModeTableCount.Text, FHugeModeTableCount);

  FAppDefFontName := edtAppDefFontName.Text;
  FAppDefFontSize := StrToIntDef(edtAppDefFontSize.Text, FAppDefFontSize);
  FAppFixWidthFontName := edtAppFixWidthFontName.Text;
  FAppFixWidthFontSize := StrToIntDef(edtAppFixWidthFontSize.Text, FAppFixWidthFontSize);
  FDmlGraphFontName := edtDmlGraphFontName.Text;
  FFieldNameMaxDrawSize := StrToIntDef(edtFieldNameMaxDrawSize.Text,
    FFieldNameMaxDrawSize);
  FFieldTypeMaxDrawSize := StrToIntDef(edtFieldTypeMaxDrawSize.Text,
    FFieldTypeMaxDrawSize);
  FTableFieldMaxDrawCount := StrToIntDef(edtTableFieldMaxDrawCount.Text,
    FTableFieldMaxDrawCount);

  FQuotReservedNames := ckbQuotReservedNames.Checked;   
  FQuotAllNames := ckbQuotAllNames.Checked;
  FBackupBeforeAlterColumn := ckbBackupBeforeAlterColumn.Checked;
  FAddColCommentToCreateTbSql := ckbAddColCommentToCreateTbSql.Checked;    
  FCreateIndexForForeignkey := ckbCreateIndexForForeignkey.Checked;
  FCreateSeqForOracle := ckbCreateSeqForOracle.Checked;

  FMaxRowCountForTableData := StrToIntDef(edtMaxRowCountForTableData.Text,
    FMaxRowCountForTableData);
  FLogicNamesForTableData := ckbLogicNamesForTableData.Checked;

  FOCILIB := edtOCILIB.Text;
  FMYSQLLIB := edtMYSQLLIB.Text;
  FPOSTGRESLIB := edtPOSTGRESLIB.Text;
  FSQLSERVERLIB := edtSQLSERVERLIB.Text;   
  FUseOdbcDriverForMsSql := ckbUseOdbcDriverForMsSql.Checked;
  FSQLITELIB := edtSQLITELIB.Text;

  {$ifndef WINDOWS}
  if FNLSLang <> combNLSLang.Text then
  begin
    if combNLSLang.Text<>'' then
    begin
      //ShowMessage('Please manually add/set "export NLS_LANG='+combNLSLang.Text+'" in ~/.bash_profile');
    end else
    begin
      //ShowMessage('Please manually remove "export NLS_LANG=xxx" in ~/.bash_profile');
    end;
  end;
  {$endif}  
  FNLSLang := combNLSLang.Text;


  FWriteConstraintToDescribeStr := ckbWriteConstraintToDescribeStr.Checked;        
  FFieldGridShowLines := ckbFieldGridShowLines.Checked;  
  FTableDialogViewModeByDefault := ckbTableDialogViewModeByDefault.Checked;


  S := GetAppDefTempPath;
  if not DirectoryExists(S) then
    ForceDirectories(S);

  ini := TIniFile.Create(GetConfFileOfApp);
  try                                    
    ini.WriteBool('Options', 'CheckForUpdates', FCheckForUpdates);
    //ini.Write{3}('Options', '{1}', F{1});
    ini.WriteInteger('Options', 'AutoSaveMinutes', FAutoSaveMinutes);
    ini.WriteBool('Options', 'SaveTempFileOnExit', FSaveTempFileOnExit);
    ini.WriteInteger('Options', 'HugeModeTableCount', FHugeModeTableCount);
    ini.WriteInteger('Options', 'MaxRowCountForTableData', FMaxRowCountForTableData);
    ini.WriteBool('Options', 'LogicNamesForTableData', FLogicNamesForTableData);
    ini.WriteBool('Options', 'CreateSeqForOracle', FCreateSeqForOracle);
    ini.WriteString('Options', 'OCILIB', FOCILIB);                        
    ini.WriteString('Options', 'NLSLang', FNLSLang);
    ini.WriteString('Options', 'MYSQLLIB', FMYSQLLIB);
    ini.WriteString('Options', 'SQLSERVERLIB', FSQLSERVERLIB);
    ini.WriteBool('Options', 'UseOdbcDriverForMsSql', FUseOdbcDriverForMsSql);
    ini.WriteString('Options', 'POSTGRESLIB', FPOSTGRESLIB);
    ini.WriteString('Options', 'SQLITELIB', FSQLITELIB);
    ini.WriteBool('Options', 'QuotReservedNames', FQuotReservedNames);   
    ini.WriteBool('Options', 'QuotAllNames', FQuotAllNames);
    ini.WriteBool('Options', 'BackupBeforeAlterColumn', FBackupBeforeAlterColumn);
    ini.WriteBool('Options', 'WriteConstraintToDescribeStr',
      FWriteConstraintToDescribeStr);                         
    ini.WriteBool('Options', 'FieldGridShowLines', FFieldGridShowLines);
    ini.WriteBool('Options', 'AddColCommentToCreateTbSql', FAddColCommentToCreateTbSql);     
    ini.WriteBool('Options', 'CreateIndexForForeignkey', FCreateIndexForForeignkey);
    ini.WriteBool('Options', 'EnableCustomPropUI', FEnableCustomPropUI);  
    ini.WriteString('Options', 'CustomPropUICaption', FCustomPropUICaption);  
    ini.WriteBool('Options', 'EnableAdvTbProp', FEnableAdvTbProp);
    ini.WriteString('Options', 'LANG', FLANG);
    ini.WriteString('Options', 'AppDefFontName', FAppDefFontName);
    ini.WriteInteger('Options', 'AppDefFontSize', FAppDefFontSize);
    ini.WriteString('Options', 'AppFixWidthFontName', FAppFixWidthFontName);
    ini.WriteInteger('Options', 'AppFixWidthFontSize', FAppFixWidthFontSize);
    ini.WriteString('Options', 'DmlGraphFontName', FDmlGraphFontName);
    ini.WriteInteger('Options', 'FieldNameMaxDrawSize', FFieldNameMaxDrawSize);
    ini.WriteInteger('Options', 'FieldTypeMaxDrawSize', FFieldTypeMaxDrawSize);
    ini.WriteInteger('Options', 'TableFieldMaxDrawCount', FTableFieldMaxDrawCount);  
    ini.WriteBool('Options', 'TableDialogViewModeByDefault',
      FTableDialogViewModeByDefault);

    SaveFtList(ListBoxCustFldTps.Items, Ini, 'CustFieldTypes');
    SaveFtList(ListBoxDefPhyTypes.Items, Ini, 'DefaultFieldTypes');
    SaveFtList(ListBoxTpNameReplaces.Items, Ini, 'CustDataTypeReplaces');
    SaveFtList(ListBoxFDGenRules.Items, Ini, 'CustFieldDataGenRules');

    SaveFtList(MemoKnownTbPrefixs.Lines, Ini, 'TbNamePrefixDefs');
  finally
    ini.Free;
  end;
  SaveCustDict;
end;

procedure TfrmSettings.InitEditors;

  procedure InitLangs;
  var
    Sr: TSearchRec;
    otmp, S, AFolderName: string;

  begin
    combLANG.Clear;

    AFolderName := GetFolderPathOfAppExe('languages');
    if not DirectoryExists(AFolderName) then
      Exit;

    if FindFirst(FolderAddFileName(AFolderName, '*.*'), SysUtils.faAnyFile,
      Sr) = 0 then
      try
        repeat
          if (Sr.Name = '.') or (Sr.Name = '..') then
            Continue;
          if (Sr.Attr and SysUtils.faDirectory) <> 0 then
          begin
            Continue;
          end
          else
          begin
            S := SR.Name;
            if (Pos('ezdml_x.', LowerCase(S)) = 1) and
              (LowerCase(ExtractFileExt(S)) = '.po') then
            begin
              if LowerCase(S) = 'ezdml_x.po' then
                combLANG.Items.Add('en')
              else
              begin
                S := Copy(S, 9, Length(S));
                S := Copy(S, 1, Length(S) - 3);
                if S <> '' then
                  combLANG.Items.Add(S);
              end;
            end;
          end;
        until FindNext(Sr) <> 0;
      finally
        FindClose(Sr);
      end;

  end;

  procedure InitDataTypes;
  var
    t: TCtFieldDataType;
  begin
    combDefPhyTpLogicType.Items.Clear;
    for t := cfdtString to cfdtList do
      combDefPhyTpLogicType.Items.Add(DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[t]);
    combDefPhyTpLogicType.ItemIndex := 0;
  end;

begin

  edtAppDefFontName.Items.Assign(Screen.Fonts);
  edtAppFixWidthFontName.Items.Assign(Screen.Fonts);
  edtDmlGraphFontName.Items.Assign(Screen.Fonts);

  InitLangs;
  InitDataTypes;
    
  CheckCustFieldEditors;
end;

end.
