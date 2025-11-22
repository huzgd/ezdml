unit uFormCtTableProp;

{$MODE Delphi}


interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  CtMetaTable, uFrameCtTableProp, ActnList, StdActns, Menus, Buttons;

type

  { TfrmCtTableProp }

  TfrmCtTableProp = class(TForm)
    actCameCaselToUnderline: TAction;
    actCnWordSegment: TAction;
    actUnderlineToCamelCase: TAction;
    bbtnView: TBitBtn;
    btnNewTbTemplate: TButton;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MNAI_GenPhyNames: TMenuItem;
    MNAI_GenSampleValues: TMenuItem;
    MNAI_GenFields: TMenuItem;
    MNAI_GenComments: TMenuItem;
    MenuItem_AI: TMenuItem;
    MNCnWordSegment: TMenuItem;
    Panel1: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    btnCapitalize: TButton;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    actCapUppercase: TAction;
    actCapLowercase: TAction;
    actAutoCapitalize: TAction;
    actExchangeDispComm: TAction;
    actExchangeNameDisp: TAction;
    AutoCapitalize1: TMenuItem;
    AllLowerCase1: TMenuItem;
    AllUpperCase1: TMenuItem;
    CommentstoDisplayName1: TMenuItem;
    N1: TMenuItem;
    NametoDisplayName1: TMenuItem;
    actCheckWithMyDict: TAction;
    CheckwithMyDicttxt1: TMenuItem;
    actConvertChnToPy: TAction;
    ConvertChinesetoPinYin1: TMenuItem;
    PopupMenuNewTbTmpls: TPopupMenu;
    TimerDelayCmd: TTimer;
    procedure actCameCaselToUnderlineExecute(Sender: TObject);
    procedure actCheckWithMyDictExecute(Sender: TObject);
    procedure actCnWordSegmentExecute(Sender: TObject);
    procedure actUnderlineToCamelCaseExecute(Sender: TObject);
    procedure bbtnViewClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnNewTbTemplateClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actExchangeNameDispExecute(Sender: TObject);
    procedure actAutoCapitalizeExecute(Sender: TObject);
    procedure actCapLowercaseExecute(Sender: TObject);
    procedure actCapUppercaseExecute(Sender: TObject);
    procedure btnCapitalizeClick(Sender: TObject);
    procedure actExchangeDispCommExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure actConvertChnToPyExecute(Sender: TObject);
    procedure MNAI_GenFieldsClick(Sender: TObject);
    procedure TimerDelayCmdTimer(Sender: TObject);
  private
    { Private declarations }
    FReadOnlyMode: boolean; 
    FModalWndClosed: Boolean;
    FModalResOk: Boolean;
    FConfirmedClose: Boolean;
    FMetaTable: TCtMetaTable;
    FTempMetaTable: TCtMetaTable;
    FFrameCtTableProp: TFrameCtTableProp;
    FOrginalCaption: string;
    FSaveColIni: string;
    FInitTbJson: string;
    procedure DoCapitalizeProc(sType: string);
    procedure _DoGridEscape(Sender: TObject);
    procedure CreateNewTbTmplMenus;    
    procedure MN_NewTbTmpl_Click(Sender: TObject);
  public
    { Public declarations }
    procedure LoadIni;
    procedure SaveIni;
    procedure Init(tb: TCtMetaTable; bReadOnly: boolean);
    procedure FocusToField(cf: TCtMetaField);
    procedure SaveToTb(tb: TCtMetaTable);

    function ShowModalEx: integer;
    function CheckModified: Boolean;
    procedure ForceRelease;
  end;

function ShowCtMetaTableDialog(ATb: TCtMetaTable;
  bReadOnly, bIsNew: boolean): boolean;
function ShowCtMetaTableDialogEx(ATb: TCtMetaTable; AField: TCtMetaField;
  bReadOnly, bIsNew, bViewModal: boolean): boolean;

var
  FfrmCtTableProp: TfrmCtTableProp;
  G_LastTbPropPointX, G_LastTbPropPointY: integer;

implementation

uses
  CTMetaData, dmlstrs, ezdmlstrs, AutoNameCapitalize, WindowFuncs, WSForms,
  InterfaceBase, IniFiles, DMLObjs;

{$R *.lfm}

function ShowCtMetaTableDialog(ATb: TCtMetaTable;
  bReadOnly, bIsNew: boolean): boolean;
begin
  Result := ShowCtMetaTableDialogEx(ATb, nil, bReadOnly, bIsNew, False);
end;

function ShowCtMetaTableDialogEx(ATb: TCtMetaTable; AField: TCtMetaField;
  bReadOnly, bIsNew, bViewModal: boolean): boolean;
var
  frm: TfrmCtTableProp;
  fn, S, oTbJson: string;
  ss: TStrings;
  bOk, hHasOthers: Boolean;
  I, mrs: Integer;
  nw, nh: Double;
  szObj: TDMLEntityObj;
begin
  Result := False;
  szObj := nil;

  if not bReadOnly and bIsNew then
  begin
    CheckCanEditMeta;
    if (ATb.IsTable) then
      if ATb.MetaFields.Count = 0 then
      begin
        fn := GetFolderPathOfAppExe('Templates');
        fn := FolderAddFileName(fn, 'new_table.txt');
        fn := GetConfigFile_OfLang(fn);
        if FileExists(fn) then
        begin
          ss := TStringList.Create;
          try
            ss.LoadFromFile(fn);
            S := ss.Text;
            if Copy(S, 1, 2) = #$FE#$FF then
              Delete(S, 1, 2)
            else if Copy(S, 1, 2) = #$FE#$FE then
              Delete(S, 1, 2)
            else if Copy(S, 1, 3) = #$EF#$BB#$BF then
              Delete(S, 1, 3);
            ATb.Describe := S;
          finally
            ss.Free;
          end;
        end
        else
          ATb.Describe := srNewTableDesc;
        if Assigned(GProc_OnEzdmlCmdEvent) then
        begin
          GProc_OnEzdmlCmdEvent('NEW_TABLE', '', '', ATb, nil);
        end;
      end;
  end
  else if not bReadOnly then
    CheckCanEditMeta;

  if ATb.UserObject['SIZE_DMLENTITY'] <> nil then
    szObj := TDMLEntityObj(ATb.UserObject['SIZE_DMLENTITY']);

  hHasOthers := False;
  for I:=Screen.FormCount - 1 downto 0 do
  begin
    if Screen.Forms[I] is TfrmCtTableProp then
    begin
      hHasOthers := True;
      Break;
    end;
  end;

  if not bReadOnly then
  try
    BeginTbPropUpdate(ATb);
  except
    on E: Exception do
    begin
      Application.HandleException(nil);
      bReadOnly := True;
    end;
  end;

  if not Assigned(FfrmCtTableProp) then
  begin
    FfrmCtTableProp := TfrmCtTableProp.Create(Application);
    FfrmCtTableProp.LoadIni; 
    frm := FfrmCtTableProp;
  end
  else if FfrmCtTableProp.Showing or bReadOnly or bViewModal then
  begin
    frm := TfrmCtTableProp.Create(Application);
  end
  else
    frm := FfrmCtTableProp;


  oTbJson := '';
  if not bReadOnly and not bIsNew then
    oTbJson := atb.JsonStr;
  bOk := False;
  with frm do
    try              
      if not bReadOnly then
        EditMetaAcquire(ATb, frm);

      if bIsNew and atb.IsTable then
      begin
        CreateNewTbTmplMenus;
      end;
      if bReadOnly then
        FSaveColIni := 'DialogView'
      else
        FSaveColIni := 'Dialog';
                                 
      if not bReadOnly and bIsNew then
        FFrameCtTableProp.CreatingNewTable := True
      else
        FFrameCtTableProp.CreatingNewTable := False;
      FFrameCtTableProp.OwnerDialog := frm;
      Init(ATb, bReadOnly);
      FocusToField(AField);
      with FFrameCtTableProp do
      if szObj <> nil then
      begin
        if ATb.IsTable then
        begin
          lbTbSize.Visible := True;
          lbTbSizeX.Visible := True;
          edtTbSizeW.Visible := True;    
          edtTbSizeH.Visible := True;
          edtTbSizeW.Text := IntToStr(Trunc(szObj.Width));
          edtTbSizeH.Text := IntToStr(Trunc(szObj.Height));
          if not szObj.IsResizable then
          begin
            edtTbSizeW.Enabled := False;
            edtTbSizeH.Enabled := False;
          end
          else
          begin
            edtTbSizeW.Enabled := True;
            edtTbSizeH.Enabled := True;
          end;
        end;
        if ATb.IsText or ATb.IsGroup then
        begin
          PanelTxtBottom.Visible := True;    
          edtTxtSizeW.Text := IntToStr(Trunc(szObj.Width));
          edtTxtSizeH.Text := IntToStr(Trunc(szObj.Height));
          if not szObj.IsResizable then
          begin
            edtTxtSizeW.Enabled := False;
            edtTxtSizeH.Enabled := False;
          end
          else
          begin
            edtTxtSizeW.Enabled := True;
            edtTxtSizeH.Enabled := True;
          end;
        end;
      end
      else
      begin
        if ATb.IsTable then
        begin
          lbTbSize.Visible := False;
          lbTbSizeX.Visible := False;
          edtTbSizeW.Visible := False;
          edtTbSizeH.Visible := False;
        end;  
        if ATb.IsText or ATb.IsGroup then
        begin
          PanelTxtBottom.Visible := False;
        end;
      end;
      if bIsNew then
      begin
        if ATb.IsTable then
          FFrameCtTableProp.PageControlTbProp.ActivePageIndex := 0;
        Caption := srNewDmlTable + ' - ' + ATb.NameCaption;
      end;
      if Assigned(GProc_OnEzdmlCmdEvent) then
      begin
        GProc_OnEzdmlCmdEvent('TABLE_PROP_DIALOG', 'SHOW', '', ATb, frm);
      end;
      if bReadOnly then
      begin
        if atb = G_WMZ_CUSTCMD_Object then
        begin
          //BoundsRect := G_WMZ_CUSTCMD_WndRect;
          Left := G_WMZ_CUSTCMD_WndRect.Left;
          Top := G_WMZ_CUSTCMD_WndRect.Top;
          G_WMZ_CUSTCMD_Object := nil;
          Position := poDesigned;
        end
        else if (G_LastTbPropPointX <> 0) or (G_LastTbPropPointY <> 0) then
        begin
          Position := poDesigned;
          if G_LastTbPropPointX > Screen.Width - Width - 20 then
            Left := 100
          else
            Left := G_LastTbPropPointX + 50;
          if G_LastTbPropPointY > Screen.Height - Height - 20 then
            Top := 60
          else
            Top := G_LastTbPropPointY + 20;
        end
        else
        begin
          //Position := poDefaultPosOnly;
        end;
        if bViewModal then
        begin
          btnOk.Visible := False;
          ShowModal;
        end
        else
        begin
          FormStyle := fsStayOnTop;
          Show;
        end;
      end
      else
      begin
        if atb = G_WMZ_CUSTCMD_Object then
        begin
          //BoundsRect := G_WMZ_CUSTCMD_WndRect;
          Left := G_WMZ_CUSTCMD_WndRect.Left;
          Top := G_WMZ_CUSTCMD_WndRect.Top;
          G_WMZ_CUSTCMD_Object := nil;
          Position := poDesigned;
        end;
        if hHasOthers then
        begin
          FormStyle := fsStayOnTop;
          mrs := ShowModalEx;
        end
        else
          mrs := ShowModal;
        if (mrs = mrOk) or FModalResOk then
        begin
          if not FReadOnlyMode then
          begin
            SaveToTb(atb);  
            if (szObj <> nil) and szObj.IsResizable then
            with FFrameCtTableProp do
            begin
              if ATb.IsTable then
              begin
                nw := StrToFloatDef(edtTbSizeW.Text, szObj.Width);
                nh := StrToFloatDef(edtTbSizeH.Text, szObj.Height);
                if (Trunc(szObj.Width) <> Trunc(nw)) or (Trunc(szObj.Height)<>Trunc(nh)) then
                begin
                  szObj.Width := nw;
                  szObj.Height := nh;
                  szObj.AutoSize:=False;
                end;
              end;
              if ATb.IsText or ATb.IsGroup then
              begin                   
                nw := StrToFloatDef(edtTxtSizeW.Text, szObj.Width);
                nh := StrToFloatDef(edtTxtSizeH.Text, szObj.Height);
                if (Trunc(szObj.Width) <> Trunc(nw)) or (Trunc(szObj.Height)<>Trunc(nh)) then
                begin
                  szObj.Width := nw;
                  szObj.Height := nh;
                  szObj.AutoSize:=False;
                end;
              end;
            end;
            Result := True;
            if Assigned(GProc_OnEzdmlCmdEvent) then
            begin
              GProc_OnEzdmlCmdEvent('TABLE_PROP_DIALOG', 'HIDE', 'SAVE', ATb, frm);
            end;
            G_WMZ_CUSTCMD_Object := atb;
            PostMessage(Application.MainForm.Handle, WM_USER + $1001{WMZ_CUSTCMD}, 6, 0);
          end
          else
          if Assigned(GProc_OnEzdmlCmdEvent) then
          begin
            GProc_OnEzdmlCmdEvent('TABLE_PROP_DIALOG', 'HIDE', 'CLOSE', ATb, frm);
          end;
        end
        else
        begin
          if Assigned(GProc_OnEzdmlCmdEvent) then
          begin
            GProc_OnEzdmlCmdEvent('TABLE_PROP_DIALOG', 'HIDE', 'CANCEL', ATb, frm);
          end;
        end;
      end;
      //bOk := True; //bOk为false则将窗口FREE，避免重复使用
    finally
      if not bReadOnly then
      begin
        if Result then
        begin
          if bIsNew then
            DoMetaPropsChanged(ATb, cmctNew);
          S := ATb.JsonStr;
          if oTbJson <> S then
            EndTbPropUpdate(ATb)
          else
            EndTbPropUpdate(nil);
        end
        else
          EndTbPropUpdate(nil);
        EditMetaRelease(ATb, frm);
        if frm <> FfrmCtTableProp then
          frm.Free
        else if not bOk then
          frm.Free;
      end;
    end;
end;


procedure TfrmCtTableProp.Init(tb: TCtMetaTable; bReadOnly: boolean);
begin
  FReadOnlyMode := bReadOnly;
  FMetaTable := tb;
  if FMetaTable = nil then
  begin
    FReadOnlyMode := True;
    if Assigned(FTempMetaTable) then
      FreeAndNil(FTempMetaTable);
  end
  else
  begin
    if FTempMetaTable = nil then
      FTempMetaTable := TCtMetaTable.Create;
    FTempMetaTable.AssignFrom(FMetaTable);
  end;

  if bReadOnly then
  begin
    btnOK.Caption := srCapModify;
    btnCapitalize.Visible := False;
    if bbtnView.Visible then
      FFrameCtTableProp.btnToggleTabs.Left:=FFrameCtTableProp.btnToggleTabs.Left+FFrameCtTableProp.btnToggleTabs.Width;
    bbtnView.Visible := False;
    btnCancel.Caption := srCapClose;
  end
  else
  begin
    btnOK. Caption := srCapOk;
    btnCapitalize.Visible := (Assigned(FTempMetaTable) and FTempMetaTable.IsTable); 
    if not bbtnView.Visible then
      FFrameCtTableProp.btnToggleTabs.Left:=FFrameCtTableProp.btnToggleTabs.Left-FFrameCtTableProp.btnToggleTabs.Width;
    bbtnView.Visible := True;
    bbtnView.BringToFront;
    btnCancel.Caption := srCapCancel;
  end;
  {$ifdef EZDML_LITE}      
  actCnWordSegment.Visible:=False;
  {$endif}

  FInitTbJson := FTempMetaTable.JsonStr;

  FFrameCtTableProp.Init(FTempMetaTable, FReadOnlyMode);
  if Assigned(FTempMetaTable) then
  begin                    
    if FTempMetaTable.IsGroup then
      Caption := srGroup + ' - ' + FTempMetaTable.Name
    else if FTempMetaTable.IsText then
      Caption := srText + ' - ' + FTempMetaTable.Name
    else
      Caption := FOrginalCaption + ' - ' + FTempMetaTable.NameCaption;
  end
  else
    Caption := FOrginalCaption;
end;

procedure TfrmCtTableProp.FocusToField(cf: TCtMetaField);
begin
  if cf = nil then
    Exit;
  if FTempMetaTable = nil then
    Exit;
  cf := FTempMetaTable.MetaFields.FieldByName(cf.Name);
  if cf = nil then
    Exit;
  FFrameCtTableProp.FocusToField(cf);
end;

procedure TfrmCtTableProp.SaveToTb(tb: TCtMetaTable);
begin
  if not Assigned(tb) then
    Exit;
end;

function TfrmCtTableProp.ShowModalEx: integer;

  procedure CloseModal;
  var
    CloseAction: TCloseAction;
  begin
    try
      CloseAction := caNone;
      if CloseQuery then
      begin
        CloseAction := caHide;
        DoClose(CloseAction);
      end;
      case CloseAction of
        caNone: ModalResult := 0;
        caFree: Release;
      end;
      { do not call widgetset CloseModal here, but in ShowModal to
        guarantee execution of it }
    except
      ModalResult := 0;
      Application.HandleException(Self);
    end;
  end;

var
  SavedFocusState: TFocusState;
  ActiveWindow: HWnd;
  SavedCursor: TCursor;
  bModal: integer;
begin
{$ifdef WINDOWS}
  bModal := 1;
{$else}
{$IFDEF DARWIN}
  bModal := 2;
{$else}
  bModal := 3;
{$ENDIF}
{$endif}
  FModalWndClosed := False;
  FModalResOk := False;
  if Self = nil then
    raise EInvalidOperation.Create('TCustomForm.ShowModal Self = nil');
  if Application.Terminated then
    ModalResult := 0;
  // cancel drags
  DragManager.DragStop(False);
  // close popupmenus
  if ActivePopupMenu <> nil then
    ActivePopupMenu.Close;
  if Visible or (not Enabled) or (fsModal in FFormState) or (FormStyle = fsMDIChild) then
    raise Exception.Create('Can not make this form modal');
  // Kill capture when opening another dialog
  if GetCapture <> 0 then
    SendMessage(GetCapture, LM_CANCELMODE, 0, 0);
  ReleaseCapture;

  //Application.ModalStarted;
  try
    if bModal <> 3 then  // not good in linux , removed by huz 20201018
      Include(FFormState, fsModal);
    if (PopupMode = pmNone) and HandleAllocated then
      RecreateWnd(Self);
    // need to refresh handle for pmNone because ParentWindow changes if (fsModal in FFormState) - see GetRealPopupParent
    ActiveWindow := GetActiveWindow;
    SavedFocusState := SaveFocusState;
    SavedCursor := Screen.Cursor;
    ///Screen.FSaveFocusedList.Insert(0, Screen.FFocusedForm);
    ///Screen.FFocusedForm := Self;
    //Screen.MoveFormToFocusFront(Self);
    Screen.Cursor := crDefault;
    ModalResult := 0;

    try
      Show;
      try
        // activate must happen after show
        Perform(CM_ACTIVATE, 0, 0);
        TWSCustomFormClass(WidgetSetClass).ShowModal(Self);
        repeat
          { Delphi calls Application.HandleMessage
            But HandleMessage processes all pending events and then calls idle,
            which will wait for new messages. Under Win32 there is always a next
            message, so it works there. The LCL is OS independent, and so it uses
            a better way: }
          try
            WidgetSet.AppProcessMessages; // process all events
          except
            if Application.CaptureExceptions then
              Application.HandleException(Self)
            else
              raise;
          end;
          if Application.Terminated then
            ModalResult := mrCancel;
          if ModalResult <> 0 then
          begin
            CloseModal;
            if ModalResult <> 0 then
              break;
          end;

          Application.Idle(True);
        until False;

        if FModalResOk then
          Result := mrOk
        else
          Result := ModalResult;
        if HandleAllocated and (GetActiveWindow <> Handle) then
          ActiveWindow := 0;
      finally
        { guarantee execution of widgetset CloseModal }
        TWSCustomFormClass(WidgetSetClass).CloseModal(Self);
        // set our modalresult to mrCancel before hiding.
        if ModalResult = 0 then
          ModalResult := mrCancel;
        // We should always re-enabled the forms before issuing Hide()
        // Because otherwise we will for a short amount of time have
        // all forms disabled, and some systems, like WinCE, will interprete this
        // as a problem in the application and hide it.
        // See bug 22718
        //Screen.EnableForms(DisabledList);
        Hide;
        ///RestoreFocusedForm;
      end;
    finally
      RestoreFocusState(SavedFocusState);
      Screen.Cursor := SavedCursor;
      if LCLIntf.IsWindow(ActiveWindow) then
        SetActiveWindow(ActiveWindow);
      if bModal <> 3 then
        Exclude(FFormState, fsModal);
      if ((PopupMode = pmNone) and HandleAllocated) and not
        (csDestroying in ComponentState) then
        RecreateWnd(Self);
      // need to refresh handle for pmNone because ParentWindow changes if (fsModal in FFormState) - see GetRealPopupParent
    end;
  finally
    //Application.ModalFinished;
  end;
end;

function TfrmCtTableProp.CheckModified: Boolean;
begin
  if Self.ActiveControl <> nil then
    if Assigned(Self.ActiveControl.OnExit) then
      Self.ActiveControl.OnExit(Self.ActiveControl);
  if FInitTbJson = FTempMetaTable.JsonStr then
    Result := False
  else
    Result := True;
end;

procedure TfrmCtTableProp.ForceRelease;
begin
  FConfirmedClose := True;
  Close;
end;

procedure TfrmCtTableProp.FormCreate(Sender: TObject);
begin
  FFrameCtTableProp := TFrameCtTableProp.Create(Self);
  FFrameCtTableProp.Parent := Self;
  FFrameCtTableProp.Align := alClient;
  FFrameCtTableProp.BorderSpacing.Around := 8;
  FOrginalCaption := Caption;
  FFrameCtTableProp.Proc_GridEscape := _DoGridEscape;
  MenuItem_AI.Visible := FFrameCtTableProp.MenuItem_AI.Visible;
  CheckFormScaleDPI(Self);
end;

procedure TfrmCtTableProp.FormDestroy(Sender: TObject);
begin
  if FfrmCtTableProp = Self then
    FfrmCtTableProp := nil;
  if Assigned(FTempMetaTable) then
    FreeAndNil(FTempMetaTable);
end;

procedure TfrmCtTableProp.FormShow(Sender: TObject);
begin
  G_LastTbPropPointX := Left;
  G_LastTbPropPointY := Top;
  if FSaveColIni <> '' then
    FFrameCtTableProp.LoadColWidths(FSaveColIni);
  try
    bbtnView.Left := Self.Width - bbtnView.Width - 10;
    btnCancel.Left := Panel1.Width - btnCancel.Width - 20;
    btnOk.Left := btnCancel.Left - btnOk.Width - 10;
    if FFrameCtTableProp.StringGridTableFields.CanFocus then
      FFrameCtTableProp.StringGridTableFields.SetFocus
    else if FFrameCtTableProp.MemoDesc.CanFocus then
      FFrameCtTableProp.MemoDesc.SetFocus
    else if FFrameCtTableProp.MemoTextContent.CanFocus then
      FFrameCtTableProp.MemoTextContent.SetFocus
    else if FFrameCtTableProp.MemoCodeGen.CanFocus then
      FFrameCtTableProp.MemoCodeGen.SetFocus;
  except
  end;
  TimerDelayCmd.Tag := 1;
  TimerDelayCmd.Enabled := True;
end;

procedure TfrmCtTableProp.actAutoCapitalizeExecute(Sender: TObject);
begin
  DoCapitalizeProc('AutoCapitalize');
end;

procedure TfrmCtTableProp.actCapLowercaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('LowerCase');
end;

procedure TfrmCtTableProp.actCapUppercaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('UpperCase');
end;

procedure TfrmCtTableProp.actCheckWithMyDictExecute(Sender: TObject);
begin
  DoCapitalizeProc('CheckMyDict');
end;

procedure TfrmCtTableProp.actCnWordSegmentExecute(Sender: TObject);
begin
  DoCapitalizeProc('CnWordSegment');
end;

procedure TfrmCtTableProp.actUnderlineToCamelCaseExecute(Sender: TObject);
begin
  DoCapitalizeProc('UnderlineToCamelCase');
end;

const
  WMZ_CUSTCMD = WM_USER + $1001;

procedure TfrmCtTableProp.bbtnViewClick(Sender: TObject);
begin          
  if CheckModified then
  begin
    case Application.MessageBox(PChar(srEzdmlConfirmCloseModified), PChar(Self.Caption),
      MB_YESNOCANCEL or MB_ICONWARNING or MB_DEFBUTTON3) of
      IDYES:
      begin
        if not FReadOnlyMode then
        begin
          try
            btnOk.SetFocus;
          except
          end;
          if FMetaTable.Name <> FTempMetaTable.Name then
            CheckCanRenameTable(FMetaTable, FTempMetaTable.Name, True);
          FMetaTable.AssignFrom(FTempMetaTable);
          DoTablePropsChanged(FMetaTable);
          FModalResOk := True;
          FConfirmedClose := True;
          ModalResult := mrOk;
        end;
      end;
      IDNO:
        FConfirmedClose := True;
    else
      Abort;
    end;
  end;
  G_WMZ_CUSTCMD_Object := FMetaTable;
  G_WMZ_CUSTCMD_WndRect := Self.BoundsRect;
  PostMessage(Application.MainForm.Handle, WMZ_CUSTCMD, 5, 1);
  Close;
end;


procedure TfrmCtTableProp.btnCancelClick(Sender: TObject);
begin
  FConfirmedClose := True;
  Close;
end;

procedure TfrmCtTableProp.btnNewTbTemplateClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := btnNewTbTemplate.ClientToScreen(Point(0, btnNewTbTemplate.Height));
  PopupMenuNewTbTmpls.Popup(pt.X, pt.Y);
end;

procedure TfrmCtTableProp.btnOkClick(Sender: TObject);
var
  ATb: TCtMetaTable;
begin        
  btnOk.SetFocus;
  if FReadOnlyMode then
  begin
    atb := FGlobeDataModelList.GetTableOfName(Self.FTempMetaTable.Name);
    if atb=nil then
    begin
      btnOk.Enabled:=False;
      Exit;
    end;
    CheckCanEditMeta;
    G_WMZ_CUSTCMD_Object := atb;
    G_WMZ_CUSTCMD_WndRect := Self.BoundsRect;
    PostMessage(Application.MainForm.Handle, WMZ_CUSTCMD, 5, 0);
    FConfirmedClose := True;
    Self.Close;
    //TimerDelayCmd.Tag := 2;
    //TimerDelayCmd.Enabled := True;
  end
  else
  begin         
{$IFDEF DARWIN}
    TimerDelayCmd.Tag := 3;
    TimerDelayCmd.Enabled := True;
{$else}
    ModalResult := mrOk;
{$ENDIF}
  end;
end;

procedure TfrmCtTableProp.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FConfirmedClose := False;
  FFrameCtTableProp.HideProps;
  if Self.ModalResult = mrNone then
    Self.ModalResult := mrCancel;
  //if Self <> FfrmCtTableProp then
  CloseAction := caFree;
end;

procedure TfrmCtTableProp.FormDeactivate(Sender: TObject);
begin
  G_LastTbPropPointX := Left;
  G_LastTbPropPointY := Top;
  if FSaveColIni <> '' then
    FFrameCtTableProp.SaveColWidths(FSaveColIni);
end;

procedure TfrmCtTableProp.actCameCaselToUnderlineExecute(Sender: TObject);
begin
  DoCapitalizeProc('CamelCaseToUnderline');
end;

procedure TfrmCtTableProp.actConvertChnToPyExecute(Sender: TObject);
begin
  DoCapitalizeProc('ChnToPY');
end;

procedure TfrmCtTableProp.MNAI_GenFieldsClick(Sender: TObject);
begin
  FFrameCtTableProp.CallAI(TMenuItem(Sender).Tag, '');
end;

procedure TfrmCtTableProp.TimerDelayCmdTimer(Sender: TObject);
var             
  ATb: TCtMetaTable;
  tg: integer;
begin
  TimerDelayCmd.Enabled := False;
  tg := TimerDelayCmd.Tag;
  TimerDelayCmd.Tag := 0;
  if tg = 1 then
  begin
    //init modal form
  end
  else if tg = 2 then
  begin
    if FReadOnlyMode then
    begin
      ATb := FMetaTable;
      ShowCtMetaTableDialog(ATb, False, False);
    end;    
  end
  else if tg = 3 then
  begin
    ModalResult := mrOk;
  end;
end;

procedure TfrmCtTableProp.DoCapitalizeProc(sType: string);
var
  I: integer;
begin
  DoAutoCapProcess(FTempMetaTable, sType);
  with FTempMetaTable.MetaFields do
    for I := 0 to Count - 1 do
    begin
      DoAutoCapProcess(Items[I], sType);
    end;
  FFrameCtTableProp.Init(FTempMetaTable, FReadOnlyMode);
end;

procedure TfrmCtTableProp._DoGridEscape(Sender: TObject);
begin
  Close;
end;

procedure TfrmCtTableProp.CreateNewTbTmplMenus;
  procedure AddNtMenu(AFn, ADir: string);
  var
    S, tfn: String;
    mn: TMenuItem;
  begin
    tfn := FolderAddFileName(ADir, AFn);   
    mn:= TMenuItem.Create(Self);
    S:=ChangeFileExt(AFn,'');
    S:=Copy(S, 11, Length(S));
    mn.Caption := S;
    mn.Hint := tfn;
    mn.OnClick:=MN_NewTbTmpl_Click;
    PopupMenuNewTbTmpls.Items.Add(mn);
  end;
var
  Sr: TSearchRec;
  AFolderName, fn, ext: string;
begin
  AFolderName := GetFolderPathOfAppExe('Templates');
  if not DirectoryExists(AFolderName) then
    Exit;
  PopupMenuNewTbTmpls.Items.Clear;
  if FindFirst(FolderAddFileName(AFolderName, 'new_table_*.txt'),
    SysUtils.faAnyFile,
    //SysUtils.faAnyFile + SysUtils.faHidden + SysUtils.faSysFile + SysUtils.faDirectory + SysUtils.faArchive,
    Sr) = 0 then
    try
      repeat
        if (Sr.Name = '.') or (Sr.Name = '..') then
          Continue;
        if (Sr.Attr and SysUtils.faDirectory) <> 0 then
          Continue;
        fn := LowerCase(Sr.Name);
        if Pos('new_table_',fn)<>1 then
          Continue;
        ext := ExtractFileExt(fn);
        if (ext <> '.txt') then
          Continue;

        AddNtMenu(Sr.Name, AFolderName);
      until FindNext(Sr) <> 0;
    finally
      FindClose(Sr);
    end;
  if PopupMenuNewTbTmpls.Items.Count > 0 then
    btnNewTbTemplate.Visible := True;
end;

procedure TfrmCtTableProp.MN_NewTbTmpl_Click(Sender: TObject);
var
  S, fn: String;
  ss: TStringList;
begin
  fn:=TMenuItem(Sender).Hint;
  if not FileExists(fn) then
    Exit;
  ss := TStringList.Create;
  try
    ss.LoadFromFile(fn);
    S := ss.Text;
    if Copy(S, 1, 2) = #$FE#$FF then
      Delete(S, 1, 2)
    else if Copy(S, 1, 2) = #$FE#$FE then
      Delete(S, 1, 2)
    else if Copy(S, 1, 3) = #$EF#$BB#$BF then
      Delete(S, 1, 3);
    FTempMetaTable.Describe := S;
    FFrameCtTableProp.Init(FTempMetaTable, FReadOnlyMode);
  finally
    ss.Free;
  end;
end;

procedure TfrmCtTableProp.LoadIni;
var
  fn, S: string;
  ini: TIniFile;
  lf, tp: Integer;
begin
  if Self <> FfrmCtTableProp then
    Exit;

  fn := GetConfFileOfApp;
  if FileExists(fn) then
  begin
    ini := TIniFile.Create(fn);
    try
      S := 'TablePropDialog';
      lf := ini.ReadInteger(S, 'Left', Left);
      tp := ini.ReadInteger(S, 'Top', Top);
      if (lf >= Screen.DesktopLeft) and (lf <= Screen.DesktopLeft + Screen.DesktopWidth) then
        Left := lf;
      if (tp >= Screen.DesktopTop) and (tp <= Screen.DesktopTop + Screen.DesktopHeight) then
        Top := tp;
      Width := ini.ReadInteger(S, 'Width', Width);
      Height := ini.ReadInteger(S, 'Height', Height);
    finally
      ini.Free;
    end;
  end;
end;

procedure TfrmCtTableProp.SaveIni;
var
  fn, S: string;
  ini: TIniFile;
begin
  if Self <> FfrmCtTableProp then
    Exit;

  fn := GetConfFileOfApp;
  if FileExists(fn) then
  begin
    ini := TIniFile.Create(fn);
    try
      S := 'TablePropDialog';
      if Self.WindowState = wsNormal then
      begin
        ini.WriteInteger(S, 'Left', Left);
        ini.WriteInteger(S, 'Top', Top);
        ini.WriteInteger(S, 'Width', Width);
        ini.WriteInteger(S, 'Height', Height);
      end;
    finally
      ini.Free;
    end;
  end;
end;

procedure TfrmCtTableProp.actExchangeDispCommExecute(Sender: TObject);
begin
  DoCapitalizeProc('CommentToLogicName');
end;

procedure TfrmCtTableProp.actExchangeNameDispExecute(Sender: TObject);
begin
  DoCapitalizeProc('NameToLogicName');
end;

procedure TfrmCtTableProp.btnCapitalizeClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := btnCapitalize.ClientToScreen(Point(0, btnCapitalize.Height));
  PopupMenu1.Popup(pt.X, pt.Y);
end;

procedure TfrmCtTableProp.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
var
  bOk: Boolean;
begin
  if FModalWndClosed then
    Exit;
  if FSaveColIni <> '' then
    FFrameCtTableProp.SaveColWidths(FSaveColIni);    
  if Self = FfrmCtTableProp then
    SaveIni;
  bOk := False;
  if ModalResult = mrOk then
    bOk := True
  else if not FConfirmedClose then
  begin
    if CheckModified then
    begin
      case Application.MessageBox(PChar(srEzdmlConfirmCloseModified), PChar(Self.Caption),
        MB_YESNOCANCEL or MB_ICONWARNING or MB_DEFBUTTON3) of
        IDYES:
          bOk := True;
        IDNO:;
      else
        Abort;
      end;
    end;
  end;
  if bOk then
  begin
    if not FReadOnlyMode then
    begin
      try
        btnOk.SetFocus;
      except
      end;
      if FMetaTable.Name <> FTempMetaTable.Name then
        CheckCanRenameTable(FMetaTable, FTempMetaTable.Name, True);
      FMetaTable.AssignFrom(FTempMetaTable);
      DoTablePropsChanged(FMetaTable);
      FModalResOk := True;
    end;
  end;
  if CanClose then
    FModalWndClosed := True;
end;

initialization
  Proc_ShowCtTableProp := ShowCtMetaTableDialog;
  Proc_ShowCtTableOfField := ShowCtMetaTableDialogEx;

end.
