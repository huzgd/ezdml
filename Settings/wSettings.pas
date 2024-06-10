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
SQLITELIB                     String
QuotReservedNames             Bool    
QuotAllNames                  Bool
BackupBeforeAlterColumn       Bool
WriteConstraintToDescribeStr  Bool
FieldGridShowLines            Bool
AddColCommentToCreateTbSql    Bool    
CreateForeignkeys             Bool
CreateIndexForForeignkey      Bool
HiveVersion                   Integer   
MysqlVersion                  Integer
AutoCommit                    Bool
RetainAfterCommit             Bool     
ShowJdbcConsole               Bool
EnableCustomPropUI            Bool
CustomPropUICaption           String
ChatGPTKey                    String
EnableAdvTbProp               Bool
EnableTbPropGenerate          Bool
EnableTbPropData              Bool
EnableTbPropUIDesign          Bool
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
  ComCtrls, uFrameCustPhyFieldTypes;

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
    Bevel19: TBevel;
    Bevel20: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    BevelGen1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    BevelGen2: TBevel;
    btnCancel: TButton;
    btnOk: TButton;
    btnOracleLibBrs: TButton;
    btnMysqlLibBrs: TButton;
    btnPostgreLibBrs: TButton;
    btnSqlServerLibBrs: TButton;
    btnSqliteLibBrs: TButton;
    btnCustFldtpNew: TButton;
    btnCustFldtpRemove: TButton;
    btnTpnRepNew: TButton;
    btnFDGenNew: TButton;
    btnTpnRepRemove: TButton;
    btnFDGenRemove: TButton;
    ckbAutoCommit: TCheckBox;
    ckbShowJdbcConsole: TCheckBox;
    ckbBigIntForIntKeys: TCheckBox;
    ckbCheckForUpdates: TCheckBox;
    ckbCreateForeignkeys: TCheckBox;
    ckbCreateSeqForOracle: TCheckBox;
    ckbEnableAdvTbProp: TCheckBox;
    ckbEnableTbPropRelations: TCheckBox;
    ckbEnableCustomPropUI: TCheckBox;
    ckbEnableTbPropData: TCheckBox;
    ckbEnableTbPropGenerate: TCheckBox;
    ckbEnableTbPropUIDesign: TCheckBox;
    ckbAddColCommentToCreateTbSql: TCheckBox;
    ckbCreateIndexForForeignkey: TCheckBox;
    ckbRetainAfterCommit: TCheckBox;
    ckbTableDialogViewModeByDefault: TCheckBox;
    ckbQuotAllNames: TCheckBox;
    ckbSaveTempFileOnExit: TCheckBox;
    ckbWriteConstraintToDescribeStr: TCheckBox;
    ckbLogicNamesForTableData: TCheckBox;
    ckbQuotReservedNames: TCheckBox;
    ckbBackupBeforeAlterColumn: TCheckBox;
    ckbFieldGridShowLines: TCheckBox;
    combMysqlVersion: TComboBox;
    combLANG: TComboBox;
    combNLSLang: TComboBox;
    combHiveVersion: TComboBox;
    combOdbcCharset: TComboBox;
    edtDmlGraphDefScale: TComboBox;
    edtCustFldtpName: TEdit;
    edtCustFldtpPhyType: TEdit;
    edtCustomPropUICaption: TEdit;
    edtChatGPTKey: TEdit;
    edtScreenDpi: TEdit;
    edtPOSTGRESLIB: TComboBox;
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
    edtMYSQLLIB: TComboBox;
    edtSQLSERVERLIB: TComboBox;
    edtSQLITELIB: TComboBox;
    edtMaxRowCountForTableData: TEdit;
    edtOCILIB: TComboBox;
    edtTableFieldMaxDrawCount: TEdit;
    edtFDGenRule: TEdit;
    GroupBoxDBConnOthers: TGroupBox;
    GroupBoxOthers: TGroupBox;
    GroupBoxSQLDbSpec: TGroupBox;
    GroupBoxTbTabs: TGroupBox;
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
    lbGraphDefScale: TLabel;
    lbMysqlVersion: TLabel;
    lbNLSLang: TLabel;
    lbOdbcCharset: TLabel;
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
    lbHiveVersion: TLabel;
    lbTableDataPreviewRows1: TLabel;
    lbTpnReplacement1: TLabel;
    lbTpnReplaceTip: TLabel;
    lbDBConnNote1: TLabel;
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
    ListBoxDefPhyTypes: TListBox;
    ListBoxCustFldTps: TListBox;
    ListBoxTpNameReplaces: TListBox;
    ListBoxFDGenRules: TListBox;
    MemoKnownTbPrefixs: TMemo;
    MemoCustDict: TMemo;
    OpenDialogDbLib: TOpenDialog;
    PageControlMain: TPageControl;
    Panel1: TPanel;
    PanelPhyCustTps: TPanel;
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
    procedure btnOracleLibBrsClick(Sender: TObject);
    procedure btnPostgreLibBrsClick(Sender: TObject);
    procedure btnSqliteLibBrsClick(Sender: TObject);
    procedure btnSqlServerLibBrsClick(Sender: TObject);
    procedure btnTpnRepNewClick(Sender: TObject);
    procedure btnTpnRepRemoveClick(Sender: TObject);
    procedure ckbAutoCommitChange(Sender: TObject);
    procedure ckbEnableCustomPropUIChange(Sender: TObject);
    procedure edtCustFldtpNameChange(Sender: TObject);
    procedure edtFDGenRuleChange(Sender: TObject);
    procedure edtTpnRepPatternChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxCustFldTpsClick(Sender: TObject);
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
    FOdbcCharset: string;
    FBigIntForIntKeys: boolean;
    FQuotReservedNames: boolean;
    FQuotAllNames: boolean;
    FBackupBeforeAlterColumn: boolean;
    FWriteConstraintToDescribeStr: boolean;
    FFieldGridShowLines :Boolean;
    FAddColCommentToCreateTbSql: boolean;
    FCreateForeignkeys: boolean;
    FCreateIndexForForeignkey: boolean;
    FHiveVersion: Integer;     
    FMysqlVersion: Integer;
    FDmlGraphDefScale: String;
    FRetainAfterCommit: boolean;      
    FAutoCommit: boolean;
    FShowJdbcConsole: boolean;
    FEnableCustomPropUI: boolean;
    FCustomPropUICaption : String;   
    FChatGPTKey : String;
    FEnableAdvTbProp: boolean;       
    FEnableTbPropRelations: boolean;
    FEnableTbPropGenerate: boolean;
    FEnableTbPropData: boolean;
    FEnableTbPropUIDesign: boolean;
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
    FFrameCustPhyFieldTypes: TFrameCustPhyFieldTypes;

    FIsInitingFt: boolean;

    procedure BrowseLibFile(AEdit: TComboBox; ALibName1, ALibName2: string);
    procedure CheckCustFieldEditors;
  public
    procedure LoadSetting;
    procedure SaveSetting;

    procedure InitEditors;
  end;

function ShowEzdmlSettings(initPg: Integer): boolean;

var
  MsSql_DBLIBDLL: string;

implementation

uses
  WindowFuncs, IniFiles, CtMetaTable, AutoNameCapitalize, dmlstrs, postgres3dyn,
  ocidyn, mysql57dyn, sqlite3dyn, CtMetaCustomDb;

{$R *.lfm}

function ShowEzdmlSettings(initPg: Integer): boolean;
var
  frm: TfrmSettings;
begin
  Result := False;
  frm := TfrmSettings.Create(Application.MainForm);
  try
    frm.LoadSetting;
    if (initPg >= 0) and (initPg < frm.PageControlMain.PageCount) then
      frm.PageControlMain.ActivePageIndex:=initPg;
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

procedure TfrmSettings.BrowseLibFile(AEdit: TComboBox; ALibName1, ALibName2: string
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
  bSelA, bSelC, bSelD: Boolean;
begin
  bSelA := ListBoxCustFldTps.ItemIndex >= 0;
  bSelC := ListBoxTpNameReplaces.ItemIndex >= 0;     
  bSelD := ListBoxFDGenRules.ItemIndex >= 0;

  edtCustFldtpName.Enabled := bSelA;
  edtCustFldtpPhyType.Enabled := bSelA;
  btnCustFldtpRemove.Enabled := bSelA;

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
  FFrameCustPhyFieldTypes := TFrameCustPhyFieldTypes.Create(Self);
  with FFrameCustPhyFieldTypes do
  begin                         
    Parent := PanelPhyCustTps;
    Align := alClient;
  end;
end;

procedure TfrmSettings.btnOracleLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtOCILIB, ocilib, 'dmoci.dll');
end;

procedure TfrmSettings.btnPostgreLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtPOSTGRESLIB, pqlib, '');
end;

procedure TfrmSettings.btnSqliteLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtSQLITELIB, Sqlite3Lib, '');
end;

procedure TfrmSettings.btnSqlServerLibBrsClick(Sender: TObject);
begin
  BrowseLibFile(edtSQLSERVERLIB, MsSql_DBLIBDLL, '');
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

procedure TfrmSettings.ckbAutoCommitChange(Sender: TObject);
begin
  ckbRetainAfterCommit.Enabled := ckbAutoCommit.Checked;
end;

procedure TfrmSettings.ckbEnableCustomPropUIChange(Sender: TObject);
begin
  edtCustomPropUICaption.Visible:=ckbEnableCustomPropUI.Checked and ckbEnableCustomPropUI.Visible;
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

  procedure LoadComboHist(Combo: TComboBox; dbType: string);
  begin
    LoadFtList(Combo.Items, Ini, 'DbLibHist_'+dbType);
  end;
begin
  InitEditors;

  S := GetAppDefTempPath;
  if not DirectoryExists(S) then
    ForceDirectories(S);

  ini := TIniFile.Create(GetConfFileOfApp);
  try                
    LoadComboHist(edtOCILIB, 'ORACLE');
    LoadComboHist(edtMYSQLLIB, 'MYSQL');
    LoadComboHist(edtPOSTGRESLIB, 'POSTGRESQL');
    LoadComboHist(edtSQLSERVERLIB, 'SQLSERVER');
    LoadComboHist(edtSQLITELIB, 'SQLITE');

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
    FPOSTGRESLIB := ini.ReadString('Options', 'POSTGRESLIB', FPOSTGRESLIB);
    FSQLITELIB := ini.ReadString('Options', 'SQLITELIB', FSQLITELIB);   
    FOdbcCharset := ini.ReadString('Options', 'OdbcCharset', '');
    FBigIntForIntKeys := ini.ReadBool('Options', 'BigIntForIntKeys',
      False);
    FQuotReservedNames := ini.ReadBool('Options', 'QuotReservedNames',
      False);
    FQuotAllNames := ini.ReadBool('Options', 'QuotAllNames',
      False);
    FBackupBeforeAlterColumn := ini.ReadBool('Options', 'BackupBeforeAlterColumn',
      False);
    FWriteConstraintToDescribeStr :=
      ini.ReadBool('Options', 'WriteConstraintToDescribeStr',
      True);      
    FFieldGridShowLines :=
      ini.ReadBool('Options', 'FieldGridShowLines',
      True);
    FAddColCommentToCreateTbSql :=
      ini.ReadBool('Options', 'AddColCommentToCreateTbSql', True);    
    FCreateForeignkeys :=
      ini.ReadBool('Options', 'CreateForeignkeys', True);
    FCreateIndexForForeignkey :=
      ini.ReadBool('Options', 'CreateIndexForForeignkey', False);     
    FHiveVersion :=
      ini.ReadInteger('Options', 'HiveVersion', 2);
    FMysqlVersion :=
      ini.ReadInteger('Options', 'MysqlVersion', 5);
    FRetainAfterCommit :=
      ini.ReadBool('Options', 'RetainAfterCommit', False);     
    FAutoCommit :=
      ini.ReadBool('Options', 'AutoCommit', True);
    FShowJdbcConsole :=
      ini.ReadBool('Options', 'ShowJdbcConsole', True);
    FEnableCustomPropUI := ini.ReadBool('Options', 'EnableCustomPropUI',
      False);       
    FCustomPropUICaption := ini.ReadString('Options', 'CustomPropUICaption', '');   
    FChatGPTKey := ini.ReadString('Options', 'ChatGPTKey', '');
    FEnableAdvTbProp := ini.ReadBool('Options', 'EnableAdvTbProp',
      False);              
    FEnableTbPropRelations := ini.ReadBool('Options', 'EnableTbPropRelations',
      True);
    FEnableTbPropGenerate := ini.ReadBool('Options', 'EnableTbPropGenerate',
      True);
    FEnableTbPropData := ini.ReadBool('Options', 'EnableTbPropData',
      False);
    FEnableTbPropUIDesign := ini.ReadBool('Options', 'EnableTbPropUIDesign',
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
    FDmlGraphDefScale :=  ini.ReadString('Options', 'DmlGraphDefScale',
      '');

    LoadFtList(ListBoxCustFldTps.Items, Ini, 'CustFieldTypes');
    LoadFtList(ListBoxDefPhyTypes.Items, Ini, 'DefaultFieldTypes');
    FFrameCustPhyFieldTypes.Load(ListBoxDefPhyTypes.Items);
    LoadFtList(ListBoxTpNameReplaces.Items, Ini, 'CustDataTypeReplaces');     
    LoadFtList(ListBoxFDGenRules.Items, Ini, 'CustFieldDataGenRules');

    LoadFtList(MemoKnownTbPrefixs.Lines, Ini, 'TbNamePrefixDefs');
  finally
    ini.Free;
  end;

  combLANG.Text := FLANG;
  ckbEnableCustomPropUI.Checked := FEnableCustomPropUI;
  edtCustomPropUICaption.Text := FCustomPropUICaption;    
  edtChatGPTKey.Text := FChatGPTKey;
  ckbEnableAdvTbProp.Checked := FEnableAdvTbProp;       
  ckbEnableTbPropGenerate.Checked := FEnableTbPropGenerate;       
  ckbEnableTbPropRelations.Checked := FEnableTbPropRelations;
  ckbEnableTbPropData.Checked := FEnableTbPropData;
  ckbEnableTbPropUIDesign.Checked := FEnableTbPropUIDesign;
  edtCustomPropUICaption.Visible:=ckbEnableCustomPropUI.Checked and ckbEnableCustomPropUI.Visible;
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
  edtDmlGraphDefScale.Text := FDmlGraphDefScale;

  edtScreenDpi.Text := IntToStr(Screen.PixelsPerInch);

  ckbBigIntForIntKeys.Checked := FBigIntForIntKeys;
  ckbQuotReservedNames.Checked := FQuotReservedNames;
  ckbQuotAllNames.Checked := FQuotAllNames;
  ckbBackupBeforeAlterColumn.Checked := FBackupBeforeAlterColumn;
  ckbAddColCommentToCreateTbSql.Checked := FAddColCommentToCreateTbSql;       
  ckbCreateForeignkeys.Checked := FCreateForeignkeys;
  combHiveVersion.Text := IntToStr(FHiveVersion);     
  combMysqlVersion.Text := IntToStr(FMysqlVersion);
  ckbRetainAfterCommit.Checked := FRetainAfterCommit;     
  ckbAutoCommit.Checked := FAutoCommit;
  ckbRetainAfterCommit.Enabled:= FAutoCommit;
  ckbShowJdbcConsole.Checked := FShowJdbcConsole;
  ckbCreateIndexForForeignkey.Checked := FCreateIndexForForeignkey;
  ckbCreateSeqForOracle.Checked := FCreateSeqForOracle;

  edtMaxRowCountForTableData.Text := IntToStr(FMaxRowCountForTableData);
  ckbLogicNamesForTableData.Checked := FLogicNamesForTableData;

  edtOCILIB.Text := FOCILIB;
  combNLSLang.Text := FNLSLang;
  edtMYSQLLIB.Text := FMYSQLLIB;
  edtSQLSERVERLIB.Text := FSQLSERVERLIB;
  edtPOSTGRESLIB.Text := FPOSTGRESLIB;
  edtSQLITELIB.Text := FSQLITELIB;    
  combOdbcCharset.Text := FOdbcCharset;


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

  procedure SaveComboHist(Combo: TComboBox; dbType: string);
  var
    I: Integer;
  begin
    S:=Combo.Text;
    if S<> '' then
    begin
      I := Combo.Items.IndexOf(S);
      if I>0 then
        Combo.Items.Move(I, 0)
      else if I < 0 then
        Combo.Items.Insert(0, S);
    end;
    SaveFtList(Combo.Items, Ini, 'DbLibHist_'+dbType);
  end;
begin
  FLANG := combLANG.Text;
  FEnableCustomPropUI := ckbEnableCustomPropUI.Checked;
  FCustomPropUICaption := edtCustomPropUICaption.Text;   
  FChatGPTKey := edtChatGPTKey.Text;
  FEnableAdvTbProp := ckbEnableAdvTbProp.Checked;           
  FEnableTbPropGenerate := ckbEnableTbPropGenerate.Checked;     
  FEnableTbPropRelations := ckbEnableTbPropRelations.Checked;
  FEnableTbPropData := ckbEnableTbPropData.Checked;
  FEnableTbPropUIDesign := ckbEnableTbPropUIDesign.Checked;
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
  FDmlGraphDefScale := edtDmlGraphDefScale.Text;

  FBigIntForIntKeys := ckbBigIntForIntKeys.Checked;
  FQuotReservedNames := ckbQuotReservedNames.Checked;
  FQuotAllNames := ckbQuotAllNames.Checked;
  FBackupBeforeAlterColumn := ckbBackupBeforeAlterColumn.Checked;
  FAddColCommentToCreateTbSql := ckbAddColCommentToCreateTbSql.Checked;    
  FCreateIndexForForeignkey := ckbCreateIndexForForeignkey.Checked;
  FCreateForeignkeys := ckbCreateForeignkeys.Checked;
  FHiveVersion := StrToIntDef(combHiveVersion.Text, FHiveVersion);   
  FMysqlVersion := StrToIntDef(combMysqlVersion.Text, FMysqlVersion);  
  FRetainAfterCommit := ckbRetainAfterCommit.Checked;                    
  FAutoCommit := ckbAutoCommit.Checked;
  FShowJdbcConsole := ckbShowJdbcConsole.Checked;
  FCreateSeqForOracle := ckbCreateSeqForOracle.Checked;

  FMaxRowCountForTableData := StrToIntDef(edtMaxRowCountForTableData.Text,
    FMaxRowCountForTableData);
  FLogicNamesForTableData := ckbLogicNamesForTableData.Checked;

  FOCILIB := edtOCILIB.Text;
  FMYSQLLIB := edtMYSQLLIB.Text;
  FPOSTGRESLIB := edtPOSTGRESLIB.Text;
  FSQLSERVERLIB := edtSQLSERVERLIB.Text;
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
  FOdbcCharset := combOdbcCharset.Text;


  FWriteConstraintToDescribeStr := ckbWriteConstraintToDescribeStr.Checked;        
  FFieldGridShowLines := ckbFieldGridShowLines.Checked;  
  FTableDialogViewModeByDefault := ckbTableDialogViewModeByDefault.Checked;


  S := GetAppDefTempPath;
  if not DirectoryExists(S) then
    ForceDirectories(S);

  ini := TIniFile.Create(GetConfFileOfApp);
  try
    SaveComboHist(edtOCILIB, 'ORACLE');
    SaveComboHist(edtMYSQLLIB, 'MYSQL');
    SaveComboHist(edtPOSTGRESLIB, 'POSTGRESQL');
    SaveComboHist(edtSQLSERVERLIB, 'SQLSERVER');
    SaveComboHist(edtSQLITELIB, 'SQLITE');

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
    ini.WriteString('Options', 'POSTGRESLIB', FPOSTGRESLIB);
    ini.WriteString('Options', 'SQLITELIB', FSQLITELIB);
    ini.WriteString('Options', 'OdbcCharset', FOdbcCharset);
    ini.WriteBool('Options', 'BigIntForIntKeys', FBigIntForIntKeys);
    ini.WriteBool('Options', 'QuotReservedNames', FQuotReservedNames);
    ini.WriteBool('Options', 'QuotAllNames', FQuotAllNames);
    ini.WriteBool('Options', 'BackupBeforeAlterColumn', FBackupBeforeAlterColumn);
    ini.WriteBool('Options', 'WriteConstraintToDescribeStr',
      FWriteConstraintToDescribeStr);                         
    ini.WriteBool('Options', 'FieldGridShowLines', FFieldGridShowLines);
    ini.WriteBool('Options', 'AddColCommentToCreateTbSql', FAddColCommentToCreateTbSql);     
    ini.WriteBool('Options', 'CreateForeignkeys', FCreateForeignkeys);
    ini.WriteBool('Options', 'CreateIndexForForeignkey', FCreateIndexForForeignkey);
    ini.WriteBool('Options', 'EnableCustomPropUI', FEnableCustomPropUI);               
    ini.WriteInteger('Options', 'HiveVersion', FHiveVersion);
    ini.WriteInteger('Options', 'MysqlVersion', FMysqlVersion);
    ini.WriteBool('Options', 'RetainAfterCommit', FRetainAfterCommit);    
    ini.WriteBool('Options', 'AutoCommit', FAutoCommit);
    ini.WriteBool('Options', 'ShowJdbcConsole', FShowJdbcConsole);
    ini.WriteString('Options', 'CustomPropUICaption', FCustomPropUICaption);   
    ini.WriteString('Options', 'ChatGPTKey', FChatGPTKey);
    ini.WriteBool('Options', 'EnableAdvTbProp', FEnableAdvTbProp);        
    ini.WriteBool('Options', 'EnableTbPropGenerate', FEnableTbPropGenerate);     
    ini.WriteBool('Options', 'EnableTbPropRelations', FEnableTbPropRelations);
    ini.WriteBool('Options', 'EnableTbPropData', FEnableTbPropData);
    ini.WriteBool('Options', 'EnableTbPropUIDesign', FEnableTbPropUIDesign);
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
    ini.WriteString('Options', 'DmlGraphDefScale', FDmlGraphDefScale);

    SaveFtList(ListBoxCustFldTps.Items, Ini, 'CustFieldTypes');  
    FFrameCustPhyFieldTypes.Save(ListBoxDefPhyTypes.Items);
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
    S, AFolderName: string;

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

begin

  edtAppDefFontName.Items.Assign(Screen.Fonts);
  edtAppFixWidthFontName.Items.Assign(Screen.Fonts);
  edtDmlGraphFontName.Items.Assign(Screen.Fonts);

  InitLangs;
    
  CheckCustFieldEditors;

  {$ifdef EZDML_LITE}
  ckbEnableTbPropUIDesign.Visible:=False;
  ckbEnableCustomPropUI.Visible:=False;
  edtCustomPropUICaption.Visible:=False;    
  GroupBoxOthers.Visible:=False;
  if MsSql_DBLIBDLL='' then
    GroupBoxDBConnSqlServer.Visible:=False;
  {$endif}
end;

end.
