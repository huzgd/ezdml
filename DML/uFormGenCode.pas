unit uFormGenCode;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, CheckLst, Menus, StrUtils,
  ExtCtrls, ActnList, StdActns, Buttons,
  CtMetaTable, CTMetaData, CtMetaEzdmlFakeDb;

type

  { TfrmCtGenCode }

  TfrmCtGenCode = class(TForm)
    Bevel1: TBevel;
    btnBrowseFolder: TButton;
    btnGotoLocDest: TButton;
    btnGotoLocTmpl: TButton;
    btnListMenu: TBitBtn;
    ckbOverwriteExists: TCheckBox;
    cklbDbObjs: TCheckListBox;
    combTemplate: TComboBox;
    edtOutputDir: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    MN_CheckAll: TMenuItem;
    MN_CheckSelected: TMenuItem;
    MN_InverseSel: TMenuItem;
    Panel1: TPanel;
    LabelProg: TLabel;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    Panel2: TPanel;
    Splitter1: TSplitter;
    TimerAutoGen: TTimer;
    tpgAction: TPageControl;
    tbsExecRes: TTabSheet;
    memExecResult: TMemo;
    tbsResError: TTabSheet;
    memError: TMemo;
    chkPause: TCheckBox;
    btnCancel: TButton;
    btnGenCode: TButton;
    btnResum: TButton;
    combModels: TComboBox;
    SaveDialog1: TSaveDialog;
    procedure btnListMenuClick(Sender: TObject);
    procedure cklbDbObjsResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MN_CheckAllClick(Sender: TObject);
    procedure MN_CheckSelectedClick(Sender: TObject);
    procedure MN_InverseSelClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnGenCodeClick(Sender: TObject);
    procedure btnResumClick(Sender: TObject);
    procedure combModelsChange(Sender: TObject);
    procedure btnBrowseFolderClick(Sender: TObject);
    procedure btnGotoLocDestClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGotoLocTmplClick(Sender: TObject);
    procedure TimerAutoGenTimer(Sender: TObject);
  private
    FAborted: boolean;
    FCtDataModelList: TCtDataModelGraphList;
    FMetaObjList: TCtMetaObjectList;
    FLastTemplate: string;
    FAutoOpenOnFinished: string;
    FCreateRootFolder: Boolean;
    FSelectedTbCount: integer;
    FCurStepCount, FTotalStepCount: integer;

    procedure SetCtDataModelList(const Value: TCtDataModelGraphList);
    procedure SetMetaObjList(const Value: TCtMetaObjectList);

  protected
    procedure ExecCommands(bCountingOnly: boolean);
    procedure RunDmlTmplFile(tmplFn, outDir, outFn, vScript: string;
      curTb: TObject; bLoopTbs, bSkipExists: boolean; sEncoding: string; bCountingOnly: boolean);
    procedure RunDmlTmplFolder(tmplFolder, outParentFolder, newFolderName: string;
      curTb: TObject; bLoopTbs, bCountingOnly: boolean);
    function GetDmlScriptDir: string;
    function CheckSpecValue(str: string; cobj: TObject): string;
    function GetOutFileNameOfTemplate(tmpFn, defFn: string): string;
    function GetConfValOfTemplate(tmpFn, conf, def: string): string;
    function GetAutoOpenOnFinished(tmpFn, dstFn: string): string;
    procedure Log(msg: string);
    procedure RaiseErr(msg: string);
    function AddProgressStep(fn: string): boolean;
  public
    procedure InitListObj;
    procedure InitTemplates;
    procedure InitTbList;

    procedure LoadIniFile;
    procedure SaveIniFile;

    property MetaObjList: TCtMetaObjectList read FMetaObjList write SetMetaObjList;
    property CtDataModelList: TCtDataModelGraphList
      read FCtDataModelList write SetCtDataModelList;
  end;

var
  frmCtGenCode: TfrmCtGenCode;

implementation

uses
  uFormCtDbLogon, WindowFuncs, dmlstrs, CtObjSerialer, DB, AutoNameCapitalize,
  CtDataSetFile, CtObjXmlSerial, IniFiles, DmlScriptPublic;

{$R *.lfm}
          
var
  GenCode_CurObj: TCtMetaObject;
function GenCode_GetSelectedCtMetaObj: TCtMetaObject;
begin
  Result := GenCode_CurObj;
end;

procedure TfrmCtGenCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveIniFile;
end;

procedure TfrmCtGenCode.FormCreate(Sender: TObject);
begin
  cklbDbObjs.MultiSelect := True;
  LoadIniFile;
end;

procedure TfrmCtGenCode.btnListMenuClick(Sender: TObject);
begin
  PopupMenu1.PopUp;
end;

procedure TfrmCtGenCode.cklbDbObjsResize(Sender: TObject);
begin
  btnListMenu.Left := cklbDbObjs.Width - 22 - btnListMenu.Width;
end;

procedure TfrmCtGenCode.MN_CheckAllClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := MN_CheckAll.Checked;
end;

procedure TfrmCtGenCode.MN_CheckSelectedClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    if cklbDbObjs.Selected[I] then
      cklbDbObjs.Checked[I] := MN_CheckSelected.Checked;
end;


procedure TfrmCtGenCode.MN_InverseSelClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    cklbDbObjs.Checked[I] := not cklbDbObjs.Checked[I];
end;

procedure TfrmCtGenCode.PopupMenu1Popup(Sender: TObject);
var
  I: integer;
begin
  I := cklbDbObjs.ItemIndex;
  if I > 0 then
    if cklbDbObjs.Selected[I] then
    begin
      MN_CheckSelected.Checked := cklbDbObjs.Checked[I];
      MN_CheckAll.Checked := cklbDbObjs.Checked[I];
      Exit;
    end;
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    if cklbDbObjs.Selected[I] then
    begin
      MN_CheckSelected.Checked := cklbDbObjs.Checked[I];
      MN_CheckAll.Checked := cklbDbObjs.Checked[I];
      Exit;
    end;
end;

procedure TfrmCtGenCode.SaveIniFile;
var
  AFileName, S: string;
  IniFile: TIniFile;
  I: Integer;
begin
  AFileName := GetConfFileOfApp;
  if not FileExists(AFileName) then
    Exit;

  IniFile := TIniFile.Create(AFileName);
  with IniFile do
    try
      WriteString('GenCode', 'LastTemplate', combTemplate.Text);

      S := edtOutputDir.Text;
      if S <> '' then
      begin
        I := edtOutputDir.Items.IndexOf(S);
        if I < 0 then
          edtOutputDir.Items.Add(S)
        else if I > 0 then
          edtOutputDir.Items.Move(I, 0);
        edtOutputDir.Text := S;
      end;
      WriteString('GenCode', 'LastOutputDir', S);
      WriteInteger('GenCode', 'OutputDir_Count', edtOutputDir.Items.Count);
      for I:=0 to edtOutputDir.Items.Count - 1 do      
        WriteString('GenCode', 'OutputDir_Item'+IntToStr(I), edtOutputDir.Items[I]);
    finally
      Free;
    end;
end;

procedure TfrmCtGenCode.SetCtDataModelList(const Value: TCtDataModelGraphList);
begin
  FCtDataModelList := Value;
  if FCtDataModelList <> nil then
    FMetaObjList := FCtDataModelList.CurDataModel.Tables;
end;

procedure TfrmCtGenCode.SetMetaObjList(const Value: TCtMetaObjectList);
begin
  FMetaObjList := Value;
  if FMetaObjList <> nil then
    FCtDataModelList := nil;
end;

procedure TfrmCtGenCode.FormShow(Sender: TObject);
begin                   
  btnResum.Left:= btnCancel.Left - btnResum.Width - 10;
  btnGenCode.Left:= btnResum.Left - btnGenCode.Width - 10;        
  ProgressBar1.Width:= btnGenCode.Left - ProgressBar1.Left - 10;

  chkPause.Left := Panel2.Width - chkPause.Width - 8;
  ckbOverwriteExists.Left := chkPause.Left - ckbOverwriteExists.Width - 8;


  ProgressBar1.Position := 0;
  InitListObj; 
  if TimerAutoGen.Tag <> 0 then
  begin
    TimerAutoGen.Tag := 0;
    TimerAutoGen.Enabled := True;
  end;
end;

function TfrmCtGenCode.GetAutoOpenOnFinished(tmpFn, dstFn: string): string;
var
  cfgFn, S: string;
  ini: TIniFile;
begin
  Result := '';
  if (tmpFn = '') or (dstFn = '') then
    Exit;
  cfgFn := tmpFn;
  cfgFn := FolderAddFileName(cfgFn, '_dml_config.INI');
  if FileExists(cfgFn) then
  begin
    ini := TIniFile.Create(cfgFn);
    with ini do
      try
        FCreateRootFolder := ReadBool('dml_settings','create_root_folder',True);
        S := '';
  {$IFDEF Windows}
        S := ReadString('dml_settings', 'auto_open_on_finished_windows', '');
  {$ELSE}
  {$IFDEF Darwin}
        S := ReadString('dml_settings', 'auto_open_on_finished_mac', '');
  {$ELSE}
        S := ReadString('dml_settings', 'auto_open_on_finished_linux', '');
  {$ENDIF}
  {$ENDIF}
        if S='' then
          S := ReadString('dml_settings', 'auto_open_on_finished', '');
        if S <> '' then
        begin
          Result := dstFn;
          Result := FolderAddFileName(Result, ExtractFileName(tmpFn));
          Result := FolderAddFileName(Result, S);
          Result := CheckFileNameSep(Result);
          Log('auto_open_on_finished: '+ Result);
        end;
      finally
        Free;
      end;
  end;
end;

function TfrmCtGenCode.GetDmlScriptDir: string;
begin
  Result := GetFolderPathOfAppExe('Templates');
end;


function TfrmCtGenCode.GetOutFileNameOfTemplate(tmpFn, defFn: string): string;
begin
  Result := GetConfValOfTemplate(tmpFn, 'rename', defFn);
end;

function TfrmCtGenCode.GetConfValOfTemplate(tmpFn, conf, def: string): string;
var
  cfgFn, S: string;
  ini: TIniFile;
begin
  Result := def;
  cfgFn := ExtractFilePath(tmpFn);
  cfgFn := FolderAddFileName(cfgFn, '_dml_config.INI');
  if FileExists(cfgFn) then
  begin
    ini := TIniFile.Create(cfgFn);
    with ini do
      try
        S := Trim(ReadString(ExtractFileName(tmpFn), conf, ''));
        if S <> '' then
          Result := S;
      finally
        Free;
      end;
  end;
end;

function TfrmCtGenCode.AddProgressStep(fn: string): boolean;
var
  s: string;
begin
  Inc(FCurStepCount);
  if FTotalStepCount = 0 then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  s := fn;
  if Pos(DirectorySeparator, S) > 0 then
    S := ExtractFileName(S);
  ProgressBar1.Position := FCurStepCount * 100 div FTotalStepCount;
  LabelProg.Caption := Format(srGeneratingCodeFmt, [FCurStepCount, FTotalStepCount, S]);
  Application.ProcessMessages;
  if FAborted then
    Exit;
  CheckAbort(' ');
  Result := True;
end;

procedure TfrmCtGenCode.btnBrowseFolderClick(Sender: TObject);
begin
  SaveDialog1.FileName := '__DIR';
  if SaveDialog1.Execute then
    edtOutputDir.Text := ExtractFilePath(SaveDialog1.FileName);
end;

procedure TfrmCtGenCode.btnCancelClick(Sender: TObject);
begin
  if btnCancel.Caption = srCapCancel then
  begin
    if MessageBox(Handle, PChar(srConfirmAbort), PChar(Application.Title),
      MB_YESNO or MB_ICONQUESTION) = idYes then
      FAborted := True;
  end
  else
    Close;
end;

procedure TfrmCtGenCode.InitListObj;
var
  i: integer;
  S: string;
begin
  InitTemplates;

  combModels.Tag := 0;
  combModels.Items.Clear;
  if Assigned(FCtDataModelList) then
  begin
    for i := 0 to FCtDataModelList.Count - 1 do
    begin
      S := FCtDataModelList[I].Name;
      if FCtDataModelList[I].Caption <> '' then
        S := S + '(' + FCtDataModelList[I].Caption + ')';
      combModels.Items.AddObject(S, FCtDataModelList[I]);
    end;
    combModels.Enabled := True;
    combModels.ItemIndex := FCtDataModelList.IndexOf(FCtDataModelList.CurDataModel);
    combModels.Tag := 1;
  end
  else
    combModels.Enabled := False;

  InitTbList;
end;

procedure TfrmCtGenCode.InitTbList;
var
  i: integer;
  S: string;
begin
  cklbDbObjs.Clear;
  for i := 0 to MetaObjList.Count - 1 do
    if (MetaObjList[i] is TCtMetaTable) and TCtMetaTable(MetaObjList[i]).IsTable
      and TCtMetaTable(MetaObjList[i]).GenCode then
      if MetaObjList[i].DataLevel <> ctdlDeleted then
      begin
        S := TCtMetaTable(MetaObjList[i]).Name;
        cklbDbObjs.Items.AddObject(S, TObject((MetaObjList[i])));
      end;

  for I := 0 to cklbDbObjs.Items.Count - 1 do
  begin
    if TCtMetaTable(cklbDbObjs.Items.Objects[I]).IsManyToManyLinkTable then
      cklbDbObjs.Checked[I] := False
    else
      cklbDbObjs.Checked[I] := True;
  end;
  MN_CheckAll.Checked := True;
end;


procedure TfrmCtGenCode.InitTemplates;
var
  Sr: TSearchRec;
  cfgFn, otmp, S, AFolderName: string;
  tmplFiles: TStringList;
  ini: TIniFile;
begin
  otmp := combTemplate.Text;
  if otmp = '' then
    otmp := FLastTemplate;
  combTemplate.Clear;

  AFolderName := GetDmlScriptDir;
  if not DirectoryExists(AFolderName) then
    Exit;
   //CtAlert(AFolderName) ;
  if FindFirst(FolderAddFileName(AFolderName, '*'), SysUtils.faAnyFile, //先添加目录
    Sr) = 0 then
    try
      repeat
        if (Sr.Name = '.') or (Sr.Name = '..') then
          Continue;
        if (Sr.Attr and SysUtils.faDirectory) <> 0 then
        begin
          combTemplate.Items.Add(Sr.Name);
        end;
      until FindNext(Sr) <> 0;
    finally
      FindClose(Sr);
    end;
        
  //读取配置文件，获取模板文件列表
  cfgFn := FolderAddFileName(AFolderName, '_dml_config.INI');
  if FileExists(cfgFn) then
  begin
    ini := TIniFile.Create(cfgFn);  
    tmplFiles:= TStringList.Create;
    try
      ini.ReadSections(tmplFiles);

      if FindFirst(FolderAddFileName(AFolderName, '*.*'), SysUtils.faAnyFile, //再添加PAS
        Sr) = 0 then
        try
          repeat
            if (Sr.Name = '.') or (Sr.Name = '..') then
              Continue;
            if (Sr.Attr and SysUtils.faDirectory) <> 0 then
            begin
              //combTemplate.Items.Add(Sr.Name);
            end
            else
            begin
              S := SR.Name;
              if (LowerCase(ExtractFileExt(S)) = '.pas') or
                (LowerCase(ExtractFileExt(S)) = '.js') then
              begin
                if tmplFiles.IndexOf(S) >= 0 then
                  combTemplate.Items.Add(S);
              end;
            end;
          until FindNext(Sr) <> 0;
        finally
          FindClose(Sr);
        end;    
    finally
      ini.Free;
      tmplFiles.Free;
    end;
  end;

  if otmp <> '' then
    combTemplate.ItemIndex := combTemplate.Items.IndexOf(otmp);

  if combTemplate.ItemIndex = -1 then
    if combTemplate.Items.Count > 0 then
      combTemplate.ItemIndex := 0;
end;

procedure TfrmCtGenCode.LoadIniFile;
var
  AFileName, S: string;
  IniFile: TIniFile;
  I, C: Integer;
begin
  AFileName := GetConfFileOfApp;
  if not FileExists(AFileName) then
    Exit;

  IniFile := TIniFile.Create(AFileName);
  with IniFile do
    try
      FLastTemplate := ReadString('GenCode', 'LastTemplate', '');
      C := ReadInteger('GenCode', 'OutputDir_Count', 0);
      edtOutputDir.Items.Clear;
      for I:=0 to C - 1 do
      begin
        S := ReadString('GenCode', 'OutputDir_Item'+IntToStr(I), '');
        edtOutputDir.Items.Add(S);
      end;
      edtOutputDir.Text := ReadString('GenCode', 'LastOutputDir', '');
    finally
      Free;
    end;
end;

procedure TfrmCtGenCode.Log(msg: string);
begin
  memExecResult.Lines.Add(msg);
end;

procedure TfrmCtGenCode.RaiseErr(msg: string);
begin
  Log(msg);
  memError.Lines.Add(msg);
  raise Exception.Create(msg);
end;

procedure TfrmCtGenCode.btnGenCodeClick(Sender: TObject);
var
  bFinish: boolean;
  I, C, idx: integer;
  vSaveLastModel: TCtDataModelGraph;
  cTb: TCtMetaTable;   
  vSvGetCurObj: function: TCtMetaObject;
begin
  SaveIniFile;
  tpgAction.TabIndex := 0;
  bFinish := False;

  GenCode_CurObj := nil;
  vSaveLastModel := FGlobeDataModelList.CurDataModel;
  vSvGetCurObj := Proc_GetSelectedCtMetaObj;
  Proc_GetSelectedCtMetaObj := GenCode_GetSelectedCtMetaObj;
  try
    FAborted := False;

    memExecResult.Lines.Clear;
    Self.Refresh;

    btnGenCode.Enabled := False;
    btnCancel.Caption := srCapCancel;
    cklbDbObjs.Enabled := False;
    try
      idx := combModels.ItemIndex;
      if idx >= 0 then
        if (combModels.Items.Objects[idx] is TCtDataModelGraph) then
          FGlobeDataModelList.CurDataModel :=
            TCtDataModelGraph(combModels.Items.Objects[idx]);

      C := 0;
      for I := 0 to cklbDbObjs.Items.Count - 1 do
      begin
        cTb := TCtMetaTable(cklbDbObjs.Items.Objects[I]);
        if cklbDbObjs.Checked[I] then
        begin
          Inc(C);
          cTb.IsChecked := True;
        end
        else
          cTb.IsChecked := False;
      end;
      if C = 0 then
        for I := 0 to cklbDbObjs.Items.Count - 1 do
          if cklbDbObjs.Selected[I] then
          begin
            cklbDbObjs.Checked[I] := True;
            Inc(C);
          end;
      if C = 0 then
        Exit;     
      if Assigned(GProc_OnEzdmlCmdEvent) then
      begin
        GProc_OnEzdmlCmdEvent('FORM_GEN_CODE', 'GEN_CODE', 'BEGIN',
          cklbDbObjs, memExecResult.Lines);
      end;
      FSelectedTbCount := C;
      FTotalStepCount := 0;
      FCurStepCount := 0;
      FAutoOpenOnFinished := '';
      FCreateRootFolder := True;

      try  
        Log('Calculating total steps...');
        ExecCommands(True); //获取总数
        FTotalStepCount := FCurStepCount;
        FCurStepCount := 0;
        Log('Total steps: ' + IntToStr(FTotalStepCount) + '. Generating...');
        ExecCommands(False); //执行
      except
        on E: Exception do
        begin
          Log('Error: '+E.Message);   
          memError.Lines.Add(E.Message);
          Application.HandleException(Self);
          FAborted := True;
        end;
      end;
      if not FAborted then
      begin
        ProgressBar1.Position := 100;
        memExecResult.Lines.Add(srStrFinished);
      end;
      if Assigned(GProc_OnEzdmlCmdEvent) then
      begin
        GProc_OnEzdmlCmdEvent('FORM_GEN_CODE', 'GEN_CODE', 'END',
          cklbDbObjs, memExecResult.Lines);
      end;    
      for I := 0 to cklbDbObjs.Items.Count - 1 do
      begin
        cTb := TCtMetaTable(cklbDbObjs.Items.Objects[I]);
        cTb.IsChecked := False;
      end;
    finally
      btnGenCode.Enabled := True;
      btnCancel.Caption := srCapClose;
      cklbDbObjs.Enabled := True;
    end;
    if not FAborted then
      bFinish := True;
  finally                           
    Proc_GetSelectedCtMetaObj := vSvGetCurObj;
    FGlobeDataModelList.CurDataModel := vSaveLastModel;
    if bFinish then
      LabelProg.Caption := LabelProg.Caption + ' ' + srStrFinished
    else
      LabelProg.Caption := LabelProg.Caption + ' ' + srStrAborted;
  end;
  if not FAborted then
  begin                  
    if Assigned(GProc_OnEzdmlCmdEvent) then
      GProc_OnEzdmlCmdEvent('FORM_GEN_CODE', 'GEN_CODE_FINISHED', FAutoOpenOnFinished,
        nil, nil);
    if FAutoOpenOnFinished <> '' then
    begin
      Log('running auto_open_on_finished: '+ FAutoOpenOnFinished);     
      if FileExists(FAutoOpenOnFinished) then
        CtOpenDoc(PChar(FAutoOpenOnFinished)) { *Converted from ShellExecute* }
      else if LowerCase(ExtractFileName(FAutoOpenOnFinished))='null' then
        Log('null')
      else   
        Log('file not found: '+ FAutoOpenOnFinished);
      if Sender = nil then
        Close;
    end       
    else if Sender = nil then
    begin
      btnGotoLocDestClick(nil);
      Close;
    end
    else if Application.MessageBox(PChar(srConfirmOpenAfterGenCode),
      PChar(srGenerateCode), MB_OKCANCEL or MB_ICONINFORMATION) = idOk then
    begin
      btnGotoLocDestClick(nil);
    end;
  end;
end;


procedure TfrmCtGenCode.btnGotoLocDestClick(Sender: TObject);
var
  fn, df: string;
begin
  fn := TrimFileName(edtOutputDir.Text);
  if (fn = '') then
  begin
    fn := GetAppDefTempPath;
  end;
  if not DirectoryExists(fn) then
    ForceDirectories(fn);

  df := combTemplate.Text;
  df := FolderAddFileName(fn, df); 
  if DirectoryExists(df) then
    fn := df;

  CtOpenDir(fn);
end;

procedure TfrmCtGenCode.btnGotoLocTmplClick(Sender: TObject);
var
  fn: string;
begin
  fn := combTemplate.Text;
  if fn = '' then
    Exit;
  fn := FolderAddFileName(GetDmlScriptDir, fn);

  if DirectoryExists(fn) then
  begin
    CtOpenDir(fn);
  end
  else
  begin
    CtBrowseFile(fn);
  end;
end;

procedure TfrmCtGenCode.TimerAutoGenTimer(Sender: TObject);
begin
  TimerAutoGen.Enabled := False;
  if btnGenCode.Enabled then
  try
    btnGenCodeClick(nil);
  except
    Application.HandleException(Self);
  end;
end;

procedure TfrmCtGenCode.RunDmlTmplFile(tmplFn, outDir, outFn, vScript: string;
  curTb: TObject; bLoopTbs, bSkipExists: boolean; sEncoding: string; bCountingOnly: boolean);     
  procedure DeterminCRLF(ss: TStrings);
  var
    I: Integer;
    S: String;
  begin
    for I:=0 to ss.Count - 1 do
    begin
      S := ss[I];
      if Pos(#10, S)>0 then
        if Pos(#13, S)=0 then
        begin           
          //log('TextLineBreakStyle tlbsLF: ' + S);
          ss.TextLineBreakStyle:=tlbsLF;
          Exit;
        end;
    end;
  end;
var
  FileTxt, AOutput: TStrings;
  S, ofn: string;
  I, vLoopCounter: integer;
  cTb: TCtMetaTable;
  bSaveFile: boolean;
begin
  //bCountingOnly为True表示只计数，不会真正执行
  vLoopCounter := 0;
  for I := 0 to cklbDbObjs.Items.Count - 1 do
    if cklbDbObjs.Checked[I] then
    begin

      cTb := TCtMetaTable(cklbDbObjs.Items.Objects[I]);
      if not bLoopTbs then
        if curTb <> nil then
          if curTb is TCtMetaTable then
            cTb := TCtMetaTable(curTb);
      if cTb = nil then
        Continue;

      Inc(vLoopCounter);
      if not bLoopTbs then
        if vLoopCounter > 1 then
          Exit;

      S := CheckSpecValue(outFn, cTb);
      ofn := FolderAddFileName(outDir, S);
      if not AddProgressStep(ofn) then
        Exit;
      if bCountingOnly then
        Continue;
      if FileExists(ofn) then
      begin
        if bSkipExists or not ckbOverwriteExists.Checked then
        begin
          log('Skip exists: ' + ofn);
          Continue;
        end;
      end;
      log('Generate: ' + ofn);
      S := ExtractFilePath(ofn);
      if not DirectoryExists(S) then
      begin
        if ForceDirectories(S) then    
          log('create folder: ' + S)
        else
          log('Failed to create: ' + S);
      end;

      if vScript <> '' then
      begin

        FileTxt := TStringList.Create;
        AOutput := TStringList.Create;
        with CreateScriptForFile(tmplFn + '.' + vScript) do
          try
            ActiveFile := tmplFn;
            FileTxt.LoadFromFile(tmplFn);
            S := FileTxt.Text;
            //if sEncoding = '' then
            //begin
            //  if Length(S) > 3 then
            //    if (Ord(S[1]) = $EF) and (Ord(S[2]) = $BB) and (Ord(S[3]) = $BF) then
            //    begin
            //      S := Copy(S, 4, Length(S));
            //      sEncoding := 'UTF-8';
            //    end;
            //  if sEncoding = '' then
            //    if Pos('UTF-8', UpperCase(S)) >= 0 then
            //      sEncoding := 'UTF-8';
            //  if sEncoding = '' then
            //    if Pos('UTF8', UpperCase(S)) >= 0 then
            //      sEncoding := 'UTF-8';
            //end;
            //if (UpperCase(sEncoding) = 'UTF-8') or (UpperCase(sEncoding) = 'UTF8') then
            //begin
            //  S := Utf8Decode(S);
            //end;
            if IsSPRule(S) then
            begin
              S := PreConvertSP(S);
              FileTxt.Text := S;
            end;  
            if HasIncludes(S) then
            begin
              S := ProcessIncludes(S);
              FileTxt.Text := S;
            end;

            SetGParamValue('GCODE_SRC_FILENAME', tmplFn);
            SetGParamValue('GCODE_DST_FILETEMPLATE', outFn);
            SetGParamValue('GCODE_DST_FILENAME', ofn);
            SetGParamValue('GCODE_ENCODING', sEncoding);

            if Assigned(GProc_OnEzdmlCmdEvent) then
              GProc_OnEzdmlCmdEvent('FORM_GEN_CODE', 'GEN_CODE_FILE', tmplFn,
                cTb, nil);

            bSaveFile := True;
            try
              Init('DML_SCRIPT', cTb, AOutput, nil);
              Exec('DML_SCRIPT', FileTxt.Text);
            except
              on EA: EAbort do
                bSaveFile := False;
              on E: Exception do
                raise;
            end;
            if bSaveFile then
            begin
              ofn := GetGParamValue('GCODE_DST_FILENAME');
              sEncoding := GetGParamValue('GCODE_ENCODING');
              DeterminCRLF(AOutput);
              if (sEncoding='') or (UpperCase(sEncoding) = 'UTF-8') or (UpperCase(sEncoding) = 'UTF8') then
              begin
              end
              else
                AOutput.Text := Utf8Decode(AOutput.Text);
              if ofn <> '' then
                AOutput.SaveToFile(ofn);
            end;

          finally
            FileTxt.Free;
            AOutput.Free;
            Free;
          end;
      end
      else
      begin
        if not CtCopyFile(PChar(tmplFn), PChar(ofn), False) then     
          RaiseErr('Failed to copy file from: ' + tmplFn+#10'to: '+ofn);
      end;

    end;
end;


procedure TfrmCtGenCode.RunDmlTmplFolder(tmplFolder, outParentFolder,
  newFolderName: string; curTb: TObject; bLoopTbs, bCountingOnly: boolean);

var
  dir1, dir2, cfgFn, S, t1, t2, vScript, vRename, vEncoding: string;
  ini: TIniFile;
  tmplFiles, dirFiles: TStringList;
  Sr: TSearchRec;
  I, J, K, vLoopCounter, vLoop, vSkipExists: integer;
  cTb: TCtMetaTable;
begin
  //bCountingOnly为True表示只计数，不会真正执行
  vLoopCounter := 0;
  for K := 0 to cklbDbObjs.Items.Count - 1 do
    if cklbDbObjs.Checked[K] then
    begin

      cTb := TCtMetaTable(cklbDbObjs.Items.Objects[K]);
      if not bLoopTbs then
        if curTb <> nil then
          if curTb is TCtMetaTable then
            cTb := TCtMetaTable(curTb);
      if cTb = nil then
        Continue;
      GenCode_CurObj := cTb;

      Inc(vLoopCounter);
      if not bLoopTbs then
        if vLoopCounter > 1 then
          Exit;
      tmplFiles := TStringList.Create;
      dirFiles := TStringList.Create;
      try
        dir1 := TrimFileName(tmplFolder);
        dir2 := TrimFileName(outParentFolder);
        S := newFolderName;
        S := CheckSpecValue(S, cTb);
        if S <> '' then
          dir2 := FolderAddFileName(dir2, S);
        if not DirectoryExists(dir2) then
          ForceDirectories(dir2);

        //获取所有文件列表
        if FindFirst(FolderAddFileName(dir1, '*'), SysUtils.faAnyFile, Sr) = 0 then
          try
            repeat
              if (Sr.Name = '.') or (Sr.Name = '..') then
                Continue;
              S := SR.Name;
              if LowerCase(S) <> '_dml_config.ini' then
                if dirFiles.IndexOf(S) < 0 then
                  dirFiles.Add(S);
            until FindNext(Sr) <> 0;
          finally
            FindClose(Sr);
          end;

        //读取配置文件，获取模板文件列表
        cfgFn := FolderAddFileName(dir1, '_dml_config.INI');
        if FileExists(cfgFn) then
        begin
          ini := TIniFile.Create(cfgFn);
          try
            ini.ReadSections(tmplFiles);
          finally
            ini.Free;
          end;
        end;

        //处理普通文件、文件夹
        for I := 0 to dirFiles.Count - 1 do
        begin
          S := dirFiles[I];
          //文件名未出现在模板文件列表中，即为普通文件(夹)，直接复制
          for J := 0 to tmplFiles.Count - 1 do
            if UpperCase(S) = UpperCase(tmplFiles[J]) then
            begin
              S := '';
            end;
          if S <> '' then
          begin
            t1 := FolderAddFileName(dir1, S);
            t2 := FolderAddFileName(dir2, S);
                       
            if DirectoryExists(t1) then
            begin
              RunDmlTmplFolder(t1, dir2, S, cTb, False, bCountingOnly);
            end
            else if FileExists(t1) then
            begin
              if not AddProgressStep(t2) then
                Exit;
              if bCountingOnly then
                Continue;
              if FileExists(t2) then
                if not ckbOverwriteExists.Checked then
                begin
                  log('Skip exists: ' + t2);
                  Continue;
                end;
              log('Copy: ' + t2);
              if not CtCopyFile(PChar(t1), PChar(t2), False) then
              begin
                RaiseErr('Failed to copy file from: ' + t1+#10'to: '+t2);
              end;
            end   ;
          end;
        end;


        //遍历模板文件列表，执行模板生成
        if FileExists(cfgFn) then
        begin
          ini := TIniFile.Create(cfgFn);
          try
            for I := 0 to tmplFiles.Count - 1 do
            begin
              S := tmplFiles[I];
              t1 := FolderAddFileName(dir1, S);
              if ini.ReadInteger(S, 'skip', 0) = 1 then
              begin   
                log('Skip: ' + t1);
                Continue;
              end;
              vRename := Trim(ini.ReadString(S, 'rename', ''));
              vLoop := ini.ReadInteger(S, 'loop_each_table', 0);       
              vSkipExists := ini.ReadInteger(S, 'skip_exists', 0);
              vScript := Trim(ini.ReadString(S, 'run_as_script', ''));
              if vScript = '1' then
                vScript := 'pas';
              vEncoding := Trim(ini.ReadString(S, 'encoding', ''));
              if vEncoding = '' then
              begin
                vEncoding := Trim(ini.ReadString(S, 'utf8', ''));
                if vEncoding = '0' then
                  vEncoding := 'ANSI'
                else if vEncoding = '1' then
                  vEncoding := 'UTF-8';
              end;
              if vRename = '' then
              begin
                if vLoop = 1 then
                  vRename := ChangeFileExt(S, '') + '_#curtable_name#' +
                    ExtractFileExt(S)
                else
                  vRename := S;
              end;       
              if DirectoryExists(t1) then
              begin
                RunDmlTmplFolder(t1, dir2, vRename, cTb, vLoop = 1, bCountingOnly);
              end
              else if FileExists(t1) then
                RunDmlTmplFile(t1, dir2, vRename, vScript, cTb, vLoop =
                  1, vSkipExists=1, vEncoding, bCountingOnly);
            end;
          finally
            ini.Free;
          end;
        end;

      finally
        tmplFiles.Free;
        dirFiles.Free;
      end;
    end;
end;

procedure TfrmCtGenCode.ExecCommands(bCountingOnly: boolean);
var
  S, tmplFn, outDir: string;
begin
  //bCountingOnly为True表示只计数，不会真正执行
  //输出文件夹
  outDir := edtOutputDir.Text;
  if (outDir = '') then
  begin
    outDir := GetAppDefTempPath;
  end;
  outDir := TrimFileName(outDir);
  if not DirectoryExists(outDir) then
    ForceDirectories(outDir);
  if not DirectoryExists(outDir) then
    RaiseErr('Failed to create output folder: ' + outDir);

  //模板类型
  S := combTemplate.Text;
  if S = '' then
    RaiseErr('Template not assigned');
  tmplFn := GetDmlScriptDir;
  tmplFn := FolderAddFileName(tmplFn, S);
  SetGParamValue('GCODE_SRC_ROOT', TrimFileName(tmplFn));
  SetGParamValue('GCODE_DST_ROOT', TrimFileName(outDir));
  if DirectoryExists(tmplFn) then
  begin                       
    FAutoOpenOnFinished := GetAutoOpenOnFinished(tmplFn, outDir);
    if not FCreateRootFolder then
    begin
      if edtOutputDir.Text = '' then 
        RaiseErr('Output folder must be assigned for this template');
      S := '';
    end;
    RunDmlTmplFolder(tmplFn, outDir, S, nil, False, bCountingOnly);
  end
  else if FileExists(tmplFn) then
  begin
    S := GetOutFileNameOfTemplate(tmplFn, ChangeFileExt(S, '') + '_#curtable_name#.txt');
    RunDmlTmplFile(tmplFn, outDir, S, GetDmlScriptType(tmplFn), nil,
      True, False, GetConfValOfTemplate(tmplFn, 'encoding', ''), bCountingOnly);
  end;
end;


procedure TfrmCtGenCode.btnResumClick(Sender: TObject);
begin
  btnResum.Enabled := False;
end;

function TfrmCtGenCode.CheckSpecValue(str: string; cobj: TObject): string;
  function CalFun(AName, AFun: String):String;
  begin
    Result:=AutoCapProc(AName, AFun);
  end;
  function SpecReplace(Src, Tgr, AName: String): string;
  var
    p1, p2, p3: Integer;
    S1, S2, T, V, U: String;
  begin
    Result := Src;
    while True do
    begin
      p1 := Pos('#'+Tgr, Result);
      if p1=0 then
        Exit;
      S1 := Copy(Result, 1, p1-1);
      S2 := Copy(Result, p1+1, Length(Result));
      p2 := Pos('#', S2);
      if p2=0 then
        Break;
      T:=Copy(S2, 1, p2-1);
      S2 := Copy(S2, p2+1, Length(S2));
         
      p3 := Pos(':', T);
      if p3=0 then
      begin
        if T<>Tgr then
          Exit;
        Result := S1 + AName + S2;
        Continue;
      end;

      V := Copy(T, 1, p3-1);
      T := Copy(T, p3+1, Length(T));    
      if V<>Tgr then
        Exit;
      V:= AName;

      while T<>'' do
      begin
        p3 := Pos(':', T);
        if p3=0 then
        begin
          U := T;
          T := '';
        end
        else
        begin
          U := Copy(T, 1, p3-1);
          T := Copy(T, p3+1, Length(T));
        end;
        V:= CalFun(V, U);
      end;
      Result := S1+V+S2;
    end;
  end;
var
  S: string;
begin
  Result := str;
  if cobj <> nil then
    if cobj is TCtMetaTable then
    begin
      S := TCtMetaTable(cobj).Name;
      Result := SpecReplace(Result, 'curtable_name', S);
    end;
  if Pos('#curmodel_name', Result) > 0 then
  begin
    S := FGlobeDataModelList.CurDataModel.Name;     
    Result := SpecReplace(Result, 'curmodel_name', S);
    //Result := StringReplace(Result, '#curmodel_name#', S, [rfReplaceAll]);
  end;
end;

procedure TfrmCtGenCode.combModelsChange(Sender: TObject);
var
  idx: integer;
  obj: TObject;
begin
  if combModels.Tag <> 1 then
    Exit;
  idx := combModels.ItemIndex;
  if idx < 0 then
    Exit;
  obj := combModels.Items.Objects[idx];
  if obj = nil then
    Exit;
  if not (obj is TCtDataModelGraph) then
    Exit;

  FMetaObjList := TCtDataModelGraph(obj).Tables;
  InitTbList;
end;

end.
