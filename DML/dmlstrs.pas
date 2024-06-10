unit dmlstrs;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, Graphics, SysUtils, Classes;

type

  TCtSpecCopyRepConfigs = array[0..11] of string;

function CopyTextAsLan(txt, lan: string): string;
function LangIsEnglish: boolean;
function ShouldUseEnglishForDML: Boolean;
function LangIsChinese: boolean;
function GetEzdmlLang: string;
procedure SetEzdmlLang(lang: string);

function GetCtDropDownItemsText(items: string): string;
function GetCtDropDownTextOfValue(val, items: string): string;
function GetCtDropDownValueOfText(txt, items: string): string;
function GetCtDropDownValueOfTextEx(txt, items: string; var iFound: Integer): string;
                                                     
function GetFullTextOfValue(val, items: string): string;

var
  CtFormatSettings: TFormatSettings = (
    CurrencyFormat: 1;
    NegCurrFormat: 5;
    ThousandSeparator: ',';
    DecimalSeparator: '.';
    CurrencyDecimals: 2;
    DateSeparator: '-';
    TimeSeparator: ':';
    ListSeparator: ',';
    CurrencyString: '$';
    ShortDateFormat: 'y-m-d';
    LongDateFormat: 'dd" "mmmm" "yyyy';
    TimeAMString: 'AM';
    TimePMString: 'PM';
    ShortTimeFormat: 'hh:nn';
    LongTimeFormat: 'hh:nn:ss';
    ShortMonthNames: ('Jan','Feb','Mar','Apr','May','Jun',
                      'Jul','Aug','Sep','Oct','Nov','Dec');
    LongMonthNames: ('January','February','March','April','May','June',
                     'July','August','September','October','November','December');
    ShortDayNames: ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
    LongDayNames:  ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
    TwoDigitYearCenturyWindow: 50;
  );

const
  DEF_REP_STRS_JAVA: TCtSpecCopyRepConfigs = ('"', '";',
    '\', '\\',
    '"', '\"',
    #13, '',
    #10, '\n" + '#13#10'"',
    #9, '\t');
  DEF_REP_STRS_CSHARP: TCtSpecCopyRepConfigs = ('"', '";',
    '\', '\\',
    '"', '\"',
    #13, '',
    #10, '\n" + '#13#10'"',
    #9, '\t');
  DEF_REP_STRS_C: TCtSpecCopyRepConfigs = ('"', '";',
    '\', '\\',
    '"', '\"',
    #13, '',
    #10, '\n',
    #9, '\t');
  DEF_REP_STRS_CPP: TCtSpecCopyRepConfigs = ('String("', '");',
    '\', '\\',
    '"', '\"',
    #13, '',
    #10, '\n") + '#13#10'String("',
    #9, '\t');
  DEF_REP_STRS_DELPHI: TCtSpecCopyRepConfigs = ('''', ''';',
    '''', '''''',
    #13, '',
    #10, ''' + #13#10 +'#13#10'''',
    #9, ''' + #9 + ''',
    '', '');
  DEF_REP_STRS_PLSQL: TCtSpecCopyRepConfigs = ('''', ''';',
    '''', '''''',
    #13, '',
    #10, ''' || chr(10) ||'#13#10'''',
    '', '',
    '', '');

var
  ezsrIsEnglish: boolean = True;
  ezsrLanguage: string = '';

resourcestring

  srDmlSelectedObj = 'Selected: ';
  srDmlProgressFinished = 'Finish';
  srConfirmRearrangeAll = 'Are you sure to re-arrange all objects?';
  srConfirmRearrangeSelectedFmt = 'Are you sure to re-arrange selected %d objects?';
  srErrCanOnlyLinkTwoEntities = 'You can only add link between two entities';
  srConfirmDeleteObjFmt = 'Are you sure to delete object %s?';
  srConfirmDeleteCountFmt = 'Are you sure to delete selected %d objects?';    
  srConfirmDeleteCurRec = 'Are you sure to delete current record?';
  srNewDmlTable = 'NewTable';
  srNewDmlTbPrompt = 'Enter the name of the new table:';
  srNewDmlText = 'NewText';
  srNewDmlTextPrompt = 'Enter the content of the new text:';   
  srNewDmlGroup = 'NewGroup';
  srNewDmlGroupPrompt = 'Enter the name of the new group:';
  srConfirmDMLBriefMode =
    'Entering brief mode may cause the position of links reset. Continue?';
  srDmlGraphStatusFmt = 'Scale:%d%% Center:%d, %d';
  srDmlTotalObjectsCountFmt = '%d entities, %d links';
  srDmlSelectedObjectsCountFmt = 'Selected: %d entities, %d links';
  srDmlSelectedEntitiesCountFmt = 'Selected: %d entities';
  srDmlSelectedLinksCountFmt = 'Selected: %d links';
  srDmlSelectedTableInfoFmt = 'Selected: table %s with %d fields';
  srDmlSelectedTableFieldFmt = 'Selected: table %s, field %s';
  srImportingObjsFmt = '%d/%d Importing...%s';
  srNewTableNameFmt = 'Table%d';
  srNewTextNameFmt = 'Text%d';   
  srNewGroupNameFmt = 'Group%d';
  srNewFieldNameFmt = 'Field%d';
  srNewDiagramNameFmt = 'Model%d';  
  srNewComplexIndexNameFmt = 'CpxIndex%d';
  srNewComplexIndexDispName = 'ComplexIndex';
  srNewTableDesc = 'Id PKInteger'#13#10'Rid FKInteger'#13#10'Name S';
  srConfirmDeleteSelectedNodeFmt = 'Are you sure to delete object %s ?';
  srConfirmDeleteSelectedNodesFmt = 'Are you sure to delete selected %d objects?';
  srCannotExportEmptySelection = 'Please choose objects to export';
  srConfirmOpenXlsAfterExport = 'Export success. Open exported file now?';
  srConfirmSortTablesByName =
    'Warning: this operation CANNOT be undone!'#13#10'Are you sure to sort tables in current model by thire names?';
  srConfirmSortFieldsByName = 'Are you sure to sort fields by thire names?';
  srFilter = 'Filter';
  srFieldName = 'Field Name';
  srLogicName = 'Logic Name';
  srDataType = 'Data Type';
  srDataLength = 'Length';
  srConstraint = 'Constraint';
  srComments = 'Comments'; 
  srDesignNotes = 'Design notes';
  srGeneratingSqlFmt = '%d/%d Generating SQL...%s';
  srCheckingDataFmt = '%d/%d Checking data...%s';
  srExecutingSqlFmt = '%d/%d Executing SQL...%s';
  srGeneratingCodeFmt = '%d/%d Generating Code...%s';
  srConfirmSkipErrorFmt = 'Error:'#13#10'%s'#13#10'Continue?';
  srStrAborted = 'Aborted';
  srStrFinished = 'Finished';         
  srNoFilePrompt = 'No file found';
  srRefreshingPrompt = 'Refreshing, please wait..';
  srDays = 'Days';
  srHours = 'Hours';
  srMinutes = 'Minutes';
  srSeconds = 'Seconds';
  srEstimating = 'Estimating';
  srCanInitWaitWnd =
    'Can not init waiting window, it may already be displayed or disabled.';
  srCreateDbFileSystemPrompt = 'The program will open the Generate Database window to create/sync the ezdml file system tables. Do you want to continue?';
  srDbFileComment = 'File comment:';
  srDbFileEditSave = 'edit and save';
  srDbFileRenamePrompt = 'Rename database file to:';
  srConfirmDeleteDbFileFmt = 'Are you sure to delete database file %s?';    
  srOverwriteDbFileWarning = 'Database file %s already exists, are you sure to OVERWRITE?';
  srOverwriteSameDbFileWarning = 'Database file %s (%s) already exists and its contents are exactly the same as those to be saved. Continue saving anyway?';
  srUnlockMyDbFilePromptFmt = 'Unlock database file %s?';
  srForceUnlockDbFilePromptFmt = 'Database file %s is currently locked by %s. Do you want to forcibly unlock it?';    
  srForceLockDbFilePromptFmt = 'Database file %s is currently locked by %s. Do you want to forcibly lock it?';
  srDbFileLockComment = 'File lock comment:';   
  srNeedUnlockDbFilePromptFmt = 'Database file %s is currently locked by %s. Please unlock it before continue';
  srNoLock = 'Not locked';
  srLockByMe = 'Locked by me';
  srLockByUserFmt = 'Locked by %s';
  srViewModelInNewWnd = 'View in new window';
  srViewProperties = 'View properties';
  srConfirmAbort = 'Are you sure to abort current process?';
  srCapAbort = 'Abort';
  srInvalidTableNameWarningFmt = 'Warning: Table name may be invalid - %s';
  srInvalidFieldNameWarningFmt = 'Warning: Field name may be invalid - %s';
  srDuplicateFieldNameWarningFmt = 'Warning: Duplicate field name - %s';
  srPasteFromExcelPrompt = 'Copy content from EXCEL and paste here (may use <crlf> as row seperator):';   
  srPasteJsonStrPrompt = 'Copy content with JSON format and paste here:';
  srPasteOverwriteWarning = 'Warning: This operation may OVERWRITE exists record and cause data lost! This operation cannot be undone! Are you sure to continue?';
  srCtobjFuns = 'CT Object Functions';
  srListNameFmt = '%sList';
  srListName2Fmt = 'List class %s';
  srRearrangeObjs = 'Re-arrange objects';
  srProcessing = 'Processing...';
  srModel = 'Model';
  srTable = 'Table';
  srText = 'Text';
  srLink = 'Link';
  srLink_OneToMany = 'one to many';
  srLink_OneToOne = 'one to one';
  srStep = 'Step';   
  srGroup = 'Group';
  srDmlGraphFontName = 'default';   
  srDmlDefaultColor = 'Auto';        
  srDmlCustomColor = 'Custom Color...';
  srCapClose = 'Close';
  srCapOk = 'OK';
  srCapCancel = 'Cancel';    
  srCapNew = 'New';
  srCapModify = 'Modify';
  srCapQuery = 'Query';
  srCapSearch = 'Search';
  srCapReset = 'Reset';   
  srCapDelete = 'Delete';
  srDmlPrimaryKey = 'PK';
  srDmlForeignKey = 'FK';
  srDmlNoIndex = 'No Index';
  srDmlUniqueIndex = 'Unique Index';
  srDmlNormalIndex = 'Normal Index';
  srDmlDataTypeNames = 'Unknow'#10'String'#10'Integer'#10'Float'#10'Date'#10'Bool'#10'Enum'#10'Blob'#10'Object'#10'Calculate'#10'List'#10'Function'#10'Event'#10'Other';
  srDmlConstraintNames = ''#10'NotNull'#10'PK'#10'FK'#10'UniqueIndex'#10'NormalIndex'#10'Default'#10'AutoInc'#10'Relation'#10'TypeName';
  srDmlKeyFieldNames = 'Normal'#10'Id'#10'Pid'#10'Rid'#10'Name'#10'Caption'#10'Memo'#10'TypeName'#10'OrgId'#10'Period'#10'CreatorId'#10'CreatorName'#10'CreateDate'#10'ModifierId'#10'ModifierName'#10'ModifyDate'#10'VersionNo'#10'HistoryId'#10'LockStamp'#10'InsNo'#10'ProcID'#10'URL'#10'DataLevel'#10'DataStatus'#10'OrderNo'#10'Others';
  srDmlPossibleKeyFieldNames = 'Normal'#10'Id'#10'Pid,ParentId'#10'Rid,RelateId'#10'Name,Title'#10'Caption,SubTitle'#10'Memo,Comment,Desc,Description,Note,Notes,Remark'#10'TypeName'#10'OrgId'#10'Period'#10'CreatorId,Creator'#10'CreatorName'#10'CreateDate'#10'ModifierId,Modifier'#10'ModifierName'#10'ModifyDate'#10'VersionNo'#10'HistoryId'#10'LockStamp'#10'InsNo'#10'ProcID'#10'URL'#10'DataLevel'#10'DataStatus'#10'OrderNo'#10'Others';
  srDmlAddLink = 'Add Link';
  srDmlEditLink = 'Edit Link';
  srDmlShowLink = 'Link Info';
  srDmlLinkTypeNames = 'Foreign key'#10'Line'#10'Direct'#10'Opposite direct';
  srDmlConfirmEditLinkFmt = 'Warning: Field "%s" already linked with object "%s", continue operation will cause the old link to be overwritten! Are you sure to OVERWRITE?';
  srDmlLinkToRelateTableFmt = 'Table %s selected as master, please select the slave table to link';
  srDmlLinkToSelectTip = 'Please select one or two tables first';
  srDmlPasteExistsTableFmt = 'Table %s exists in other models and is different from the pasting one, do you want to overwrite?'#10'(Yes=Overwrite No=Auto-rename Cancel=Abort)';
  srDmlAll = 'All';
  srDmlSearchNotFound = 'Not found';
  srBatchAddFields = 'Batch add fields';
  srBatchRemoveFields = 'Batch remove fields';
  srBatchTablesNotSelected = 'Please select at least two tables';
  srBatchRemoveFieldNamePrompt = 'Please enter a field-name to remove:';
  srBatchOpResultFmt = '%d fields processed';
  srImportDatabase = 'Import Database';
  srGenerateSql = 'Generate Database';
  srGenerateCode = 'Generate Code'; 
  srChatGPT = 'ChatGPT';
  srNeedEngineType = 'Please select an DB-Engine-Type first';
  srClearCompareDmlPrompt = 'Clear current EZDMLFILE?';
  srBackupDatabase = 'Backup database';
  srRestoreDatabase = 'Restore database';
  srWritingDataFmt = '%d/%d Backing up data...%s';
  srReadingDataFmt = '%d/%d Restoring data...%s';
  srConfirmOpenAfterGenCode = 'Generate-code success. Open output folder now?';  
  srConfirmOpenFileLocation = 'Operation success. Open target folder now?';
  srModifyDatabaseWarning =
    'Warning: The database is about to be modified, make sure you have backed up your data before continue. Do you still want to modify database now?';
  srRestoreDatabaseWarning =
    'Warning: The database is about to be restored, all data in selected tables will be lost. Do you still want to restore tables now?';
  srInvalidTbNameError = 'Error: object name "%s" contains invalid characters';
  srRenameToExistsError = 'Error: Objects "%s" already exists, please choose another name';
  srRenameToExistsFeildError = 'Error: Field "%s" already exists, please choose another name';
  //srRenameToDulObjleWarning =
  //  'Warning: Objects "%s" already exist, continue operation will cause those objects to be overwritten!!! Are you sure to OVERWRITE? (Yes=OVERWRITE No=SKIP Cancel=ABORT. If not sure, abort and backup before continue)';
  //srRenameFromDulObjlePrompt = 'Warning: There are %d linked objects with the SAME NAME "%s". Do you want to RENAME THEM ALL to "%s"? (YES=RENAME ALL, No=Just Rename Current, Cancel=ABORT. If not sure, abort and backup before continue)';
  srSqlEditorRunning = 'Running...';
  srSqlEditorRunError = 'Error: ';
  srSqlEditorExecTip = 'Hold Ctrl key to execute SQL command only (no Result-Set)';
  srSqlEditorRunFinishedFmt = 'Execute finished in %f seconds';
  srSqlEditorRunFinishedRowFmt = 'Execute finished in %f seconds, %d rows affected';
  srNewFieldTypeItemTitle = 'New item';     
  srNewFieldTypeItemPrompt = 'Please enter new item:';
  srHugeMode = '(Huge mode)';    
  srPasBeginEndNeededTip = 'Seems that then <begin-end.> symbol needed for pascal script is missing. Add <begin-end.> before continue?';
  srCheckEditingMetaFailedFmt = 'Please close the editing window (%s) before continue';
  srHugeModeArrangeHint = 'Hint: Using fast layout algorithms for model diagrams under Huge-Mode';
  srPasteCopySuffix = 'Copy';
  srClearTestDataRuleWarning =
    'Warning: Old test data rule will be clear, are you sure to continue?';
  srBoolName_True = 'yes';
  srBoolName_False = 'no';
  srDictKey='Key';
  srDictValue='Value';
  srTbRelateInfo='%s - references: %d objects, referenced by: %d objects.';
  srTbRelateInfoWeak = 'Weakly related: %d objects';
  srDBObjectNotExists = 'Object %s not exists in the database';
  srDBObjectNotSynced = 'Object %s is not synchronized with the database';
  srIdFieldNames = 'Id,Pid,ParentId,Rid,RelateId';
  srChooseDbType = 'Database engine type:';

  srFieldEditorTypes='TextEdit' + #13#10 +
    'Memo' + #13#10 +
    'RichText' + #13#10 +
    'Password' + #13#10 +    
    'GUID' + #13#10 +
    'ButtonEdit' + #13#10 +
    'ComboBox' + #13#10 +
    'ListSelect' + #13#10 +
    'TagEdit' + #13#10 +
    'RadioBox' + #13#10 +
    'ButtonGroup' + #13#10 +
    'CheckBox' + #13#10 +
    'Switch' + #13#10 +
    'SpinEdit' + #13#10 +
    'NumberEdit' + #13#10 +
    'CalcEdit' + #13#10 +
    'TrackBar' + #13#10 +
    'ScoreRate' + #13#10 +
    'CurrencyEdit' + #13#10 +
    'DateEdit' + #13#10 +
    'DateRange' + #13#10 +
    'TimeEdit' + #13#10 +
    'DateTime' + #13#10 +
    'WeekSelect' + #13#10 +
    'MonthSelect' + #13#10 +
    'QuarterSelect' + #13#10 +
    'YearSelect' + #13#10 +
    'ColorSelect' + #13#10 +   
    'DataGrid' + #13#10 +       
    'KeyValueList' + #13#10 +
    'FileNameEdit' + #13#10 +
    'ImageFile' + #13#10 +
    'UploadFile' + #13#10 +
    'LocationMap' + #13#10 +
    'Button' + #13#10 +
    'HyperLink' + #13#10 +
    'Picture' + #13#10 +
    'BarCode' + #13#10 +   
    'QRCode' + #13#10 +
    'Chart';

  srTbFieldCountFmt = '(%d total)';   
  srTbCountFmt = '(%d total)';

  srFieldWeights=     
    '1=High' + #13#10 +
    '0=Normal' + #13#10 +
    '-1=Low' + #13#10 +
    '-9=Hidden';

  srFieldVisibiltys=
    '0=Auto' + #13#10 +
    '1=High: card, grid and sheet' + #13#10 +
    '2=Mid: grid and sheet' + #13#10 +
    '3=Low: sheet only';

  srFieldFixColType=
    'None' + #13#10 +
    'Left' + #13#10 +
    'Right';

  srFieldTextAlign=
    'Auto' + #13#10 +
    'Left' + #13#10 +
    'Right' + #13#10 +
    'Center';

  srFieldDropDownMode=
    '0=None' + #13#10 +
    '1=Fixed' + #13#10 +
    '2=Editable' + #13#10 +
    '3=Appendable' + #13#10 +
    '4=AutoComplete' + #13#10 +
    '5=AutoCompleteFixed';
          
  srFieldAggregateFun=
    'Sum' + #13#10 +
    'Count' + #13#10 +
    'Avg' + #13#10 +
    'Max' + #13#10 +
    'Min' + #13#10 +
    'StdDev'+ #13#10 +          
    'Text:Summary line'+ #13#10 +
    'Text:Count: %Count%'+ #13#10 +
    'Text:Sum: %Sum%'+ #13#10 +       
    'Text:Average: %Avg%'+ #13#10 +
    'Text:Max: %Max%'+ #13#10 +      
    'Text:Min: %Min%'+ #13#10 +
    'Text:StdDev: %StdDev%'+ #13#10 +
    'SQL:''Count is ''||count(*)';
          
  srFieldValueFormats=
    'Integer' + #13#10 +
    'PosiInteger' + #13#10 +
    'Numeric' + #13#10 +
    'UserName' + #13#10 +
    'Email' + #13#10 +
    'Url' + #13#10 +
    'Zipcode' + #13#10 +
    'Mobile' + #13#10 +
    'Tel' + #13#10 +
    'IdCard' + #13#10 +
    'Json' + #13#10 +
    'Regexp' + #13#10 +
    'Custom';

  srFieldMeasureUnits=
    'meter (m)' + #13#10 +
    'millimeter (mm)' + #13#10 +
    'foot (ft)' + #13#10 +
    'inch (in)' + #13#10 +
    'radian (rad)' + #13#10 +
    'degree (°)' + #13#10 +
    'celsius (°C)' + #13#10 +
    'fahrenheit (F)' + #13#10 +
    'pounds' + #13#10 +
    'million pascal (MPa)' + #13#10 +
    'bar' + #13#10 +
    'kilogram (kg)' + #13#10 +
    'gram (g)' + #13#10 +
    'newton (N)' + #13#10 +
    'ton (t)' + #13#10 +
    'kilopound (kip)' + #13#10 +
    'square meter (m^2)' + #13#10 +
    'square millimeter (mm^2)' + #13#10 +
    'cubic meter (m^3)' + #13#10 +
    'liter (L)' + #13#10 +
    'joule (J)' + #13#10 +
    'kilowatt (kW)' + #13#10 +
    'volt (V)' + #13#10 +
    'ampere (A)' + #13#10 +
    'ohm (Ω)' + #13#10 +
    'hour (h)' + #13#10 +
    'minute (min)' + #13#10 +
    'second (s)' + #13#10 +    
    'US Dollar (USD/$)' + #13#10 +
    'Euro (EUR/€)' + #13#10 +
    'Chinese Yuan (CNY/¥)' + #13#10 +
    'bag' + #13#10 +
    'bale' + #13#10 +
    'bottle' + #13#10 +
    'box' + #13#10 +
    'carton' + #13#10 +
    'case' + #13#10 +
    'coil' + #13#10 +
    'container' + #13#10 +
    'crate' + #13#10 +
    'dozen' + #13#10 +
    'gross' + #13#10 +
    'drum' + #13#10 +
    'lot' + #13#10 +
    'package' + #13#10 +
    'pallet' + #13#10 +
    'pieces' + #13#10 +
    'ream' + #13#10 +
    'roll' + #13#10 +
    'set' + #13#10 +
    'sheet' + #13#10 +
    'strand' + #13#10 +
    'unit' + #13#10 +
    'vial';

  srFieldItemListKey=
    'Items:' + #13#10 +
    'ItemList:' + #13#10 +
    'Options:' + #13#10 +
    'Values:' + #13#10 +
    'ValueList:' + #13#10 +  
    'OptionalValues:' + #13#10 +
    'DropdownList:'+ #13#10 +
    'DropdownItems:'+ #13#10 +
    'DropdownValues:';

  srTbDescInputDemo =
    'input demo:' + #13#10 +
    '' + #13#10 +
    'TSTB TestTable' + #13#10 +
    '//a test table' + #13#10 +
    '--------' + #13#10 +
    'ID  PKInc' + #13#10 +
    'RID FK //relate to xx' + #13#10 +
    'Title S(200)' + #13#10 +
    'OrderNo I(20)' + #13#10 +
    'ItemCount I' + #13#10 +
    'ItemPrice F(10,2)' + #13#10 +
    'OrderDate D' + #13#10 +
    'Desc Description' + #13#10 +
    'TpNa TypeName String:NCLOB' + #13#10 +
    'Icon BL' + #13#10 +
    'RichText S(99999)' + #13#10 +
    'IsEnabled BO' + #13#10 +
    'Memo';

  srUIFieldCategory =
    'All' + #13#10 +
    'Grid' + #13#10 +
    'Sheet' + #13#10 +
    'Card' + #13#10 +
    'Query' + #13#10 +
    'Fast search' + #13#10 +   
    'Exportable' + #13#10 +
    'Required' + #13#10 +
    'Hidden';

  srImportFieldProps =
    'Name, Field name' + #13#10 +
    'Display name, logical Name' + #13#10 +
    'Data type' + #13#10 +
    'Data size, Data Length, Size, Length' + #13#10 +
    'Nullable, Is nullable' + #13#10 +
    'Not Nullable,' + #13#10 +
    'Unique, Is Unique,' + #13#10 +
    'Constraints' + #13#10 +
    'Comment, remarks' + #13#10 +
    'Precision, accuracy, Data Scale, Scale' + #13#10 +
    'Default, Default value,';

  srImportingTbConfirm = '%d tables will be imported: ' +#13#10 +'%s'#13#10'Are you sure to continue?';
  srChatGPTReqFailed = 'Request for ChatGPT service failed';
  srChatGPTRecoFailed = 'The content returned by ChatGPT service is not recognized. Please modify the text or try again later';
  srSqlLogEnabled = 'SQL log enabled';

  srEzJdbcDriverList = 'ORACLE=driver=oracle.jdbc.OracleDriver;url=jdbc:oracle:thin:@127.0.0.1:1521:{database}' + #13#10 +
    'MYSQL=driver=com.mysql.jdbc.Driver;url=jdbc:mysql://127.0.0.1:3306/{database}' + #13#10 +
    'POSTGRESQL=driver=org.postgresql.Driver;url=jdbc:postgresql://127.0.0.1:5432/{database}' + #13#10 +
    'SQLSERVER=driver=com.microsoft.sqlserver.jdbc.SQLServerDriver;url=jdbc:sqlserver://127.0.0.1:1433#59#DatabaseName={database}' + #13#10 +
    'H2=driver=org.h2.Driver;url=jdbc:h2:{file}' + #13#10 +
    'DAMENG=driver=dm.jdbc.driver.DmDriver;url=jdbc:dm://127.0.0.1:5236' + #13#10 +
    'HIVE=driver=org.apache.hive.jdbc.HiveDriver;url=jdbc:hive2://127.0.0.1:10000/default';


implementation

function CopyTextAsLan(txt, lan: string): string;
var
  ps: TCtSpecCopyRepConfigs;
  I: integer;
begin
  Result := txt;
  if (lan = '') then
    Exit;
  lan := UpperCase(lan);
  if lan = 'C' then
    ps := DEF_REP_STRS_C
  else if lan = 'CPP' then
    ps := DEF_REP_STRS_CPP
  else if lan = 'CSHARP' then
    ps := DEF_REP_STRS_CSHARP
  else if lan = 'DELPHI' then
    ps := DEF_REP_STRS_DELPHI
  else if lan = 'JAVA' then
    ps := DEF_REP_STRS_JAVA
  else if lan = 'PLSQL' then
    ps := DEF_REP_STRS_PLSQL
  else
    Exit;
  for I := 1 to (High(ps) div 2) do
  begin
    if ps[I * 2] <> '' then
      Result := StringReplace(Result, ps[I * 2], ps[I * 2 + 1], [rfReplaceAll]);
  end;
  Result := ps[0] + Result + ps[1];
end;

function LangIsEnglish: boolean;
begin
  Result := ezsrIsEnglish;
end;

function ShouldUseEnglishForDML: Boolean;
begin
  Result := not LangIsChinese;
end;

function LangIsChinese: boolean;
begin
  if (ezsrLanguage = 'zh') or (ezsrLanguage = 'ch')
    or (Pos('zh', ezsrLanguage) = 1) or (Pos('ch', ezsrLanguage) = 1) then
    Result := True
  else
    Result := False;
end;

function GetEzdmlLang: string;
begin
  Result := ezsrLanguage;
end;

procedure SetEzdmlLang(lang: string);
begin
  ezsrLanguage := lang;
  if (ezsrLanguage = '') or (ezsrLanguage = 'en') or (Pos('en', ezsrLanguage) = 1) then
    ezsrIsEnglish := True
  else
    ezsrIsEnglish := False;
end;
       
function GetCtDropDownItemsText(items: string): string;
var
  ss: TStringList;
  S: string;
  I, po: Integer;
begin
  if Pos('=', items)=0 then
  begin
    Result := items;
    Exit;
  end;

  ss:= TStringList.create;
  try
    ss.Text := items;
    for I:=0 to ss.Count - 1 do
    begin
      S:=ss[I];
      po := Pos('=', S);
      if po>0 then
        ss[I] := Copy(S, po+1, Length(S));
    end;
    Result := ss.Text;
  finally
    ss.Free;
  end;
end;
function GetCtDropDownTextOfValue(val, items: string): string;  
var
  ss: TStringList;
  S, T: string;
  I, po: Integer;
begin      
  Result := val;
  if Pos('=', items)=0 then
    Exit;
            
  ss:= TStringList.create;
  try
    ss.Text := items;
    for I:=0 to ss.Count - 1 do
    begin
      S:=ss[I];
      po := Pos('=', S);
      if po>0 then
        T := Copy(S, 1, po-1)
      else
        T := S;
      if T=val then
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

function GetCtDropDownValueOfTextEx(txt, items: string; var iFound: Integer): string;
var
  ss: TStringList;
  S, T: string;
  I, po: Integer;
begin
  iFound := -1;
  Result := txt;
  if Trim(items)='' then
    Exit;

  ss:= TStringList.create;
  try
    ss.Text := items;
    for I:=0 to ss.Count - 1 do
    begin
      S:=ss[I];
      po := Pos('=', S);
      if po>0 then
        T := Copy(S, po+1,Length(S))
      else
        T := S;
      if T=txt then
      begin
        iFound := I;
        if po>0 then
          Result := Copy(S, 1, po-1)
        else
          Result := T;
        Exit;
      end;
    end;
  finally
    ss.Free;
  end;
end;

function GetCtDropDownValueOfText(txt, items: string): string;
var
  ss: TStringList;
  S, T: string;
  I, po: Integer;
begin
  Result := txt;
  if Pos('=', items)=0 then
    Exit;

  ss:= TStringList.create;
  try
    ss.Text := items;
    for I:=0 to ss.Count - 1 do
    begin
      S:=ss[I];
      po := Pos('=', S);
      if po>0 then
        T := Copy(S, po+1,Length(S))
      else
        T := S;
      if T=txt then
      begin
        if po>0 then
          Result := Copy(S, 1, po-1)
        else
          Result := T;
        Exit;
      end;
    end;
  finally
    ss.Free;
  end;
end;

function GetFullTextOfValue(val, items: string): string;
var
  ss: TStringList;
  S, T: string;
  I, po: Integer;
begin
  Result := val;
  if Pos(':', items)=0 then
    Exit;

  ss:= TStringList.create;
  try
    ss.Text := items;
    for I:=0 to ss.Count - 1 do
    begin
      S:=ss[I];
      po := Pos(':', S);
      if po>0 then
        T := Copy(S, 1, po-1)
      else
        T := S;
      if T=val then
      begin
        Result := S;
        Exit;
      end;
    end;
  finally
    ss.Free;
  end;
end;

end.
