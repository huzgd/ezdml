unit ezdmlstrs;

{$MODE Delphi}

interface
{
升级过程：
1.修改工程的版本号，以及下方的版本号版本日期
2.修改README.TXT中的版本号和版本说明
3.修改README_CHS.TXT中的版本号和版本说明
4.更新语言包
5.编译所有工程
6.修改安装包中的版本号
7.编译并测试安装包（英文系统也要）和绿色版
8.修改中英文HTML中的版本信息
9.上传
}

const
  srEzdmlVersionNum = '3.69';
  srEzdmlVersionDate = '2025-09-14';

{$ifdef EZDML_LITE}

{$ifdef WIN32}
  srEzdmlAppTitleOS = 'EZDML Lite (win32)';
{$else}
  srEzdmlAppTitleOS = 'EZDML Lite';
{$endif}

{$else}

{$ifdef WIN32}   
  srEzdmlAppTitleOS = 'EZDML for win32';
{$else}
  srEzdmlAppTitleOS = 'EZDML';
{$endif}

{$endif}


{$ifdef WINDOWS}  
{$ifdef WIN32}
  srEzdmlOSType = 'win32';
{$else}
  srEzdmlOSType = 'win64';
{$endif}
{$else}
{$IFDEF DARWIN}    
  srEzdmlOSType = 'mac64';
{$else}     
  srEzdmlOSType = 'linux64';
{$ENDIF}
{$endif}

  //srEzdmlAppTitle = 'EZDML';
  srEzdmlAppTitle = srEzdmlAppTitleOS;

resourcestring
  {srEzdmlAppTitle = '表结构设计器';
  srEzdmlExiting = '正在退出..';
  srEzdmlLoading = '正在加载..';
  srEzdmlOpeningFileFmt = '正在加载文件 %s...';
  srEzdmlOpenFile = '打开文件';
  srEzdmlOpening = '正在打开...';
  srEzdmlAbortOpening = '确定要中止打开吗?';
  srEzdmlConfirmClearAll = '新建文件将清除模型中的所有表，确定要继续吗？';
  srEzdmlConfirmClearOnOpen = '打开前是否要清除现有表模型？';
  srEzdmlSaveingFileFmt = '正在保存文件 %s...';
  srEzdmlSaveFile = '保存文件';
  srEzdmlSaving = '正在保存...';
  srEzdmlAbortSaving = '确定要中止保存吗?';
  srEzdmlSaved = '已保存: ';
  srEzdmlNew = '新文件'; }

  srEzdmlDefaultFontName = 'default';
  srEzdmlDefaultFontSize = '0';  
  srEzdmlFixWidthFontName = 'default';  
  srEzdmlFixWidthFontSize = '0';
  srEzdmlAbortSaving = 'Are you sure to abort saving?';
  srEzdmlSaved = 'Saved: ';
  srEzdmlExiting = 'Exiting..';
  srEzdmlLoading = 'Loading..';
  srEzdmlOpeningFileFmt = 'Opening file %s...';             
  srEzdmlOpenLastFileFmt = 'Open last recent file %s?';      
  srEzdmlPromptOpenDemoFile = 'Open demo file?';
  srEzdmlOpenFile = 'Open file';
  srEzdmlOpening = 'Opening...';
  srEzdmlAbortOpening = 'Are you sure to abort opening file?';
  srEzdmlConfirmNewFile = 'Will create a new file, please ensure your work has been saved. Are you sure to continue?';
  srEzdmlConfirmReOpenFile = 'Do you want to force the current file to be reopened (will skip the temp file)?';
  srEzdmlConfirmClearOnOpen = 'Please ensure your work has been saved before opening file. Are you sure to continue?';
  srEzdmlConfirmOpenDbTmpFile = 'Database file is not ready, open local temporary file instead?';
  //srEzdmlConfirmClearOnLoad = 'Do you want to clear current model before load new models?';    
  //srEzdmlConfirmSyncWithDbFile = 'Since current file has the same name (%s) as the DB file being loaded, do you want to import the content into the current file (overwrite content but keep the local file name)?';
  srEzdmlPromptSaveFile = 'Save current file before continue?';         
  srEzdmlPromptReloadOnFileDateSizeChanged = 'Current file is changed by other program, do you want to re-open it?'; 
  srEzdmlPromptReloadDbFileChanged = 'Current file is changed in database by %s (%s), do you want to re-open it?';
  srEzdmlPromptDbFileDisconnected = 'Database file is disconnected and will enter offline mode. Do you want to reconnect now?';
  srEzdmlDbOfflineTip = '(Offline)';
  srEzdmlConfirmCloseModified = 'Do you want to save and apply changes before close?';
  srEzdmlSaveingFileFmt = 'Saving file %s...';
  srEzdmlSaveFile = 'Save file';    
  srEzdmlSaveTemporFile = 'Save temporary file';
  srEzdmlSaving = 'Saving...'; 
  srEzdmlDbFileSavedFmt = 'Database file saved: %s. Do you want to open the Generate-Database dialog?';
  srEzdmlNew = 'New File';
  srEzdmlDefault = 'Default';
  srEzdmlFileNotFoundFmt = 'File not found %s';
  srEzdmlTmpFileIgnoredFmt = '%s - the temp file is out of date and will be skipped';
  srEzdmlDbTmpFileIgnoredFmt = '%s - the database file has been modified by %s (%s), thus the temp file is out of date and will be skipped';
  srEzdmlLoadTmpFileFailFmt ='Failed to load tmp file: %s'#13#10'Error info: %s'#13#10'This may cause by version error or file damage. Please try newer version or delete the tmp file';
  srEzdmlConfirmOpenUrlFmt = 'Are you sure to open URL %s with your internet explorer?';
  srEzdmlConfirmEditTextFmt = 'Open %s to edit now?';
  srEzdmlConfirmEditedTextFmt = '%s opened, please edit it now, and click OK to apply it when finished.';
  srEzdmlConfirmExit = 'Do you want to save data before exit?';
  srEzdmlCreateGScriptTipFmt = 'Global Script file (%s) not found, do you want to create it?';
  srEzdmlFileAlreadyOpenedFmt = 'File %s is already open in another EZDML process.';     
  srEzdmlConfirmAlreadyOpenedFileFmt = 'Warning: File %s can not be locked and may have been opened in another EZDML process, continue operation may lead to unexpected consequences! Do you still want to forcibly open it?';
  srEzdmlTempFileFmt = 'Temporary file - %s';
  srEzdmlFunOnlyInWin32Ver = 'Sorry, this function is not available in EZDML of x64 version yet. Please take EZDML for win32 instead.'; 
  srEzdmlCheckingForUpdates = 'Checking for updates...';
  srEzdmlChatGPTProcessing = 'AI request is being processed, please be patient and wait...';
  srEzdmlChatAITip_GenModel = 'Generate New Model: please specify the system name and requirement description, AI will generate the new model and add it to the list';
  srEzdmlChatAITip_GenTables = 'Add More Tables: AI will supplement and add new tables to the model based on the system description and existing table information.'#13#10'Exists tables:';
  srEzdmlChatAITip_GenFields = 'Add More Fields: AI will supplement and add new fields to the selected tables based on the system description and existing tables/fields information.'#13#10'Existing tables/fields:';
  srEzdmlChatAITip_GenComments = 'Generate Comments: AI will add logical names and comments to the selected tables/fields based on the system description and existing tables/fields information.'#13#10'Existing tables/fields:';
  srEzdmlChatAITip_GenSampleValues = 'Generate Sample Values: AI will generate some example data and candidate values for the selected fields based on the system description and existing tables/fields information.'#13#10'Existing tables/fields:';
  srEzdmlChatAITip_GenFKLinks = 'Generate Foreign Keys: AI will add foreign key links to the selected table based on the system description and existing table information.'#13#10'Existing tables:';
  srEzdmlNoUpdateFound = 'No updatable version present.'; 
  srEzdmlDmjUnicodePropmt = 'Save json data with \uXXXX unicode format?';
  srEzdmlPromptNeverShown = '(Shift+Action = Don''t prompt again)';
  srEzdmlGlobalScriptError = 'Error running global-script function %s: %s';
  srEzdmlLiteNotSupportFun = 'This function is not supported in Lite Version';
  srEzdmlNoModelChecked = 'Please check at least one model';
  srEzdmlShareWithoutPwdWarning = 'Without password protection, the model data will be transmitted and stored in plaintext over the network. Are you sure to continue?';
  srEzdmlCommitShareError = 'Share error';
  srEzdmlOnlineFiltTypes = 'Public Share'#13#10'History';
  srEzdmlSharedByMe = 'Shared by me';
  srEzdmlError = 'Error';
  srEzdmlConfirmForceReconnDb = 'This database is already connected. Do you want to force a disconnection and reconnection?';

implementation

end.

