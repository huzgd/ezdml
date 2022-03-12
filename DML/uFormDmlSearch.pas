unit uFormDmlSearch;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst,
  CtMetaTable, ActnList, StdActns, Menus,
  ImgList, Grids, Types;

type

  { TfrmDmlSearch }

  TfrmDmlSearch = class(TForm)
    PanelBottom: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    PopupMenu1: TPopupMenu;
    AutoCapitalize1: TMenuItem;
    PanelTop: TPanel;
    lbSearchCap: TLabel;
    edtSearch: TEdit;
    lbSearchTip: TLabel;
    ImageListCttb: TImageList;
    combRange: TComboBox;
    lbRangeCap: TLabel;
    StringGridSearchRes: TStringGrid;
    TimerAutoSearch: TTimer;
    actViewProp: TAction;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actViewPropExecute(Sender: TObject);
    procedure combRangeChange(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure StringGridSearchResDblClick(Sender: TObject);
    procedure StringGridSearchResDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure TimerAutoSearchTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDmList: TCtDataModelGraphList;

    FTimerCounter: Integer; //500ºÁÃëºó¿ªÊ¼ËÑË÷
    FSearching_Range: TObject;
    FSearching_Keywords: array of string;
    FSearching_Matchs: array of Boolean;
    FSearching_Model: Integer;
    FSearching_Table: Integer;
    FSearching_Field: Integer;
    FSearching_Found: Integer;
    FIsInSearching: Boolean;

    FNeedSelectionResult: Boolean;

    procedure ResetSearch;
    procedure InitSearch;
    procedure DoSearch;
    function SearchMatch(dm, tb_n, tb_c, fd_n, fd_d, fd_m: string): Boolean;
    procedure AddResultField(AField: TCTMetaField);
    procedure SetDxFieldNode(AField: TCtMetaField; ARowIndex: Integer); 
    function FieldOfGridRow(ARowIndex: Integer): TCtMetaField;

  public
    { Public declarations }

    procedure Init(dm: TCtDataModelGraphList);      
    function GetSelectionCount: Integer;
    procedure GetSelectionResult(res: TCtMetaObjectList);
                
    procedure LoadColWidths(secEx: String);
    procedure SaveColWidths(secEx: String);
  end;

function ShowDmlSearchDialog(dm: TCtDataModelGraphList; res: TCtMetaObjectList): Boolean;

var
  FfrmDmlSearch: TfrmDmlSearch;

implementation

uses
  dmlstrs, IniFiles, WindowFuncs;

{$R *.lfm}

function ShowDmlSearchDialog(dm: TCtDataModelGraphList; res: TCtMetaObjectList): Boolean;
var
  frm: TfrmDmlSearch;
begin
  Result := False;
  if FfrmDmlSearch = nil then
    FfrmDmlSearch := TfrmDmlSearch.Create(Application);
  if not FfrmDmlSearch.Showing then
    frm := FfrmDmlSearch
  else
    frm := TfrmDmlSearch.Create(Application);
  with frm do
  try
    Init(dm);
    if res <> nil then
      FNeedSelectionResult := True
    else
      FNeedSelectionResult := False;
    if ShowModal = mrOk then
    begin
      Result := True;
      if res <> nil then
        GetSelectionResult(res);
    end;
  finally
    if frm <> FfrmDmlSearch then
      frm.Free;
  end;
end;

function TfrmDmlSearch.FieldOfGridRow(ARowIndex: Integer): TCtMetaField;
begin
  if ARowIndex <= 0 then
    Result := nil
  else
    Result := TCtMetaField(StringGridSearchRes.Objects[0, ARowIndex]);
end;

procedure TfrmDmlSearch.actViewPropExecute(Sender: TObject);   
var
  AField: TCtMetaField;
  ARowIndex: Integer;
begin
  ARowIndex := StringGridSearchRes.Row;
  if ARowIndex <= 0 then
    Exit;

  AField := FieldOfGridRow(ARowIndex);

  if not Assigned(Proc_ShowCtFieldProp) then
    raise Exception.Create('Proc_ShowCtFieldProp not defined');
  if Proc_ShowCtFieldProp(AField, IsEditingMeta) then
  begin
    SetDxFieldNode(AField, ARowIndex);
  end;
end;

procedure TfrmDmlSearch.AddResultField(AField: TCTMetaField);
var
  row: Integer;
begin
  if not Assigned(AField) then
    Exit;

  row := StringGridSearchRes.RowCount;
  StringGridSearchRes.RowCount := row + 1;
  SetDxFieldNode(AField, row);
end;

procedure TfrmDmlSearch.combRangeChange(Sender: TObject);
begin
  ResetSearch;
end;

procedure TfrmDmlSearch.DoSearch;
var
  I, J, K, C: Integer;
  dm: TCtDataModelGraph;
  tb: TCtMetaTable;
  fd: TCTMetaField;
begin
  C := 0;
  for I := FSearching_Model to FDmList.Count - 1 do
  begin
    dm := FDmList[I];
    if FSearching_Range <> nil then
      if dm <> FSearching_Range then
        Continue;
    for J := FSearching_Table to dm.Tables.Count - 1 do
    begin
      tb := dm.Tables[J];
      for K := FSearching_Field to tb.MetaFields.Count - 1 do
      begin
        Inc(FSearching_Field);
        fd := tb.MetaFields[K];
        if SearchMatch(dm.Name, tb.Name, tb.Caption, fd.Name, fd.DisplayName, fd.Memo) then
        begin
          AddResultField(fd);
          Inc(FSearching_Found);
          Inc(C);
          if C > 20 then
          begin
            Exit;
          end;
        end;
      end;
      Inc(FSearching_Table);
      FSearching_Field := 0;
    end;
    Inc(FSearching_Model);
    FSearching_Table := 0;
  end;
  TimerAutoSearch.Enabled := False;
  if FSearching_Found = 0 then
  begin
    StringGridSearchRes.RowCount:=2;
    with StringGridSearchRes.Rows[1] do
    begin
      Clear;
      Add('');
      Add(srDmlSearchNotFound);
    end;
  end;
end;


procedure TfrmDmlSearch.edtSearchChange(Sender: TObject);
begin
  ResetSearch;
end;

procedure TfrmDmlSearch.StringGridSearchResDblClick(Sender: TObject);
begin
  if FNeedSelectionResult then
    ModalResult := mrOk
  else
    actViewProp.Execute;
end;

procedure TfrmDmlSearch.StringGridSearchResDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState); 
  function GetImageIndexOfCtNode(Nd: TCtMetaField): Integer;
  begin
    if Nd=nil then
      Result := -1
    else if Nd.KeyFieldType = cfktID then
      Result := 20
    else
      Result := 2 + Integer(Nd.DataType);
  end;
var
  dd, idx: Integer;
  AField: TCtMetaField;
begin
  if (ACol=0) and (ARow>0) then
  begin
    AField := FieldOfGridRow(aRow);
    idx := GetImageIndexOfCtNode(AField);
    if idx>=0 then
    begin
      dd := StringGridSearchRes.DefaultRowHeight - ImageListCttb.Height;
      dd := dd div 2;
      ImageListCttb.Draw(StringGridSearchRes.Canvas, ARect.Left + dd, ARect.Top + dd, idx, True);
    end;
  end;
end;

procedure TfrmDmlSearch.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveColWidths('');
  if ModalResult = mrOk then
    if FNeedSelectionResult then
      if GetSelectionCount=0 then
      begin
        CanClose := False;
      end;
end;

procedure TfrmDmlSearch.FormCreate(Sender: TObject);
begin           
  with StringGridSearchRes do
  begin
    Columns[1].Title.Caption := srFieldName;
    Columns[2].Title.Caption := srLogicName;
    Columns[3].Title.Caption := srDataType;
    Columns[4].Title.Caption := srDataLength;
    Columns[5].Title.Caption := srConstraint;
    Columns[6].Title.Caption := srComments;
  end;
  LoadColWidths('');
end;

procedure TfrmDmlSearch.FormShow(Sender: TObject);
begin
  try
    btnOk.Left:= btnCancel.Left - btnOk.Width - 10;
    if edtSearch.CanFocus then
      edtSearch.SetFocus;
  except
  end;
end;

procedure TfrmDmlSearch.GetSelectionResult(res: TCtMetaObjectList);
var
  I, J: Integer;
  rc: TGridRect;
  fd: TCtMetaField;
begin
  res.Clear;
  res.AutoFree := False; 
  with StringGridSearchRes do
  begin
    for I := 0 to SelectedRangeCount - 1 do
    begin
      rc := SelectedRange[I];
      for J := rc.Top to rc.Bottom do
      begin
        fd := Self.FieldOfGridRow(J);
        if fd<>nil then
          res.Add(fd);
      end;
    end;
  end;
end;

procedure TfrmDmlSearch.LoadColWidths(secEx: String);
var
  fn,S: String;
  ini : TIniFile;
  I, w: Integer;
begin
  fn := GetConfFileOfApp;
  if FileExists(fn) then
  begin
    ini := TIniFile.Create(fn);
    try
      S := 'DmlSearch'+secEx;
      for I:=1 to StringGridSearchRes.Columns.Count-1 do
      begin
        w := ini.ReadInteger(S, 'ColWidth'+IntToStr(I), 0);
        if w>10 then
          StringGridSearchRes.Columns[I].Width := w;
      end;
    finally
      ini.Free;
    end;
  end;
end;

procedure TfrmDmlSearch.SaveColWidths(secEx: String);
var
  fn,S: String;
  ini : TIniFile;
  I, w: Integer;
begin
  fn := GetConfFileOfApp;
  ini := TIniFile.Create(fn);
  try
    S := 'DmlSearch'+secEx;
    for I:=1 to StringGridSearchRes.Columns.Count-1 do
    begin
      w := StringGridSearchRes.Columns[I].Width;
      ini.WriteInteger(S, 'ColWidth'+IntToStr(I), w);
    end;
  finally
    ini.Free;
  end;

end;

procedure TfrmDmlSearch.Init(dm: TCtDataModelGraphList);
var
  I: Integer;
  S: string;
begin
  FDmList := dm;

  S := combRange.Text;
  combRange.Items.Clear;
  if FDmList.Count > 1 then
    combRange.Items.Add(srDmlAll);
  for I := 0 to FDmList.Count - 1 do
    combRange.Items.AddObject(FDmList[I].Name, FDmList[I]);
  if S <> '' then
    combRange.ItemIndex := combRange.Items.IndexOf(S);
  if combRange.ItemIndex < 0 then
    combRange.ItemIndex := 0;
  ResetSearch;
end;

function TfrmDmlSearch.GetSelectionCount: Integer;
var
  I, J: Integer;
  rc: TGridRect;
  fd: TCtMetaField;
begin
  Result := 0;
  with StringGridSearchRes do
  begin
    for I := 0 to SelectedRangeCount - 1 do
    begin
      rc := SelectedRange[I];
      for J := rc.Top to rc.Bottom do
      begin
        fd := Self.FieldOfGridRow(J);
        if fd<>nil then
          Inc(Result);
      end;
    end;
  end;
end;

procedure TfrmDmlSearch.InitSearch;
var
  S, V: string;
  po, L: Integer;
begin
  L := 0;
  SetLength(FSearching_Keywords, L);
  FSearching_Model := 0;
  FSearching_Table := 0;
  FSearching_Field := 0;
  FSearching_Found := 0;
  if (combRange.Items.Count > 1) and (combRange.ItemIndex <= 0) then
    FSearching_Range := nil
  else
    FSearching_Range := combRange.Items.Objects[combRange.ItemIndex];

  S := edtSearch.Text;
  while S <> '' do
  begin
    S := Trim(S);
    po := Pos(' ', S);
    if po > 0 then
    begin
      V := Trim(Copy(S, 1, po - 1));
      S := Trim(Copy(S, po + 1, Length(S)));
    end
    else
    begin
      po := Pos('¡¡', S);
      if po > 0 then
      begin
        V := Trim(Copy(S, 1, po - 1));
        S := Trim(Copy(S, po + 2, Length(S)));
      end
      else
      begin
        V := S;
        S := '';
      end;
    end;
    if V <> '' then
    begin
      Inc(L);
      SetLength(FSearching_Keywords, L);
      FSearching_Keywords[L - 1] := LowerCase(V);
    end;
  end;
  SetLength(FSearching_Matchs, L);
end;

procedure TfrmDmlSearch.ResetSearch;
begin
  FTimerCounter := 0;       
  TimerAutoSearch.Enabled := False;
  StringGridSearchRes.RowCount := 1;
  TimerAutoSearch.Enabled := True;
end;

function TfrmDmlSearch.SearchMatch(dm, tb_n, tb_c, fd_n, fd_d, fd_m: string): Boolean;
  procedure StrMatch(str: string);
  var
    K: Integer;
  begin
    if str = '' then
      Exit;
    str := LowerCase(str);
    for K := 0 to High(FSearching_Keywords) do
    begin
      if Pos(FSearching_Keywords[K], str) > 0 then
        FSearching_Matchs[K] := True;
    end;
  end;
var
  I: Integer;
begin
  for I := 0 to High(FSearching_Keywords) do
  begin
    FSearching_Matchs[I] := False;
  end;
  if FSearching_Range = nil then
    StrMatch(dm);
  StrMatch(tb_n);
  StrMatch(tb_c);
  StrMatch(fd_n);
  StrMatch(fd_d);
  StrMatch(fd_m);

  Result := True;
  for I := 0 to High(FSearching_Keywords) do
    if not FSearching_Matchs[I] then
    begin
      Result := False;
      Break;
    end;
end;

procedure TfrmDmlSearch.SetDxFieldNode(AField: TCtMetaField; ARowIndex: Integer);
var
  rss: TStringList;
  sA, sB, S: string;   
  dm: TCtDataModelGraph;
  tb: TCtMetaTable;
begin
  rss:= TStringList.Create;
  try      
    tb := AField.OwnerTable;
    dm := tb.OwnerList.OwnerModel;
         
    if FSearching_Range = nil then
      sA := dm.Name + '.'
    else
      sA := '';

    S := tb.Name;
    if S = '' then
      S := tb.DisplayText;
    sB := S + '.';

    rss.Add('');
    rss.Add(sA + sB + AField.Name);
    rss.Add(AField.DisplayName);

    S := AField.DataTypeName;
    if S = '' then
    begin
      if ShouldUseEnglishForDML then
        S := AField.GetLogicDataTypeName
      else
        S := DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[AField.DataType];
    end;
    rss.Add(S);

    S := '';
    if AField.DataLength > 0 then
    begin
      if AField.DataScale > 0 then
        S := S + Format('%d,%d', [AField.DataLength, AField.DataScale])
      else if AField.DataLength >= DEF_TEXT_CLOB_LEN then
        S := S + 'LONG'
      else
        S := S + Format('%d', [AField.DataLength])
    end;
    rss.Add(S);
    rss.Add(AField.GetConstraintStr);
    rss.Add(AField.Memo);
    StringGridSearchRes.Rows[ARowIndex] := rss;
    StringGridSearchRes.Objects[0, ARowIndex] := AField;
  finally
    rss.Free;
  end;
end;

procedure TfrmDmlSearch.TimerAutoSearchTimer(Sender: TObject);
begin
  Inc(FTimerCounter);
  if FTimerCounter < 5 then
    Exit;
  if FTimerCounter = 5 then
    InitSearch;      
  if GetSelectionCount>1 then
    Exit;
  if FIsInSearching then
    Exit;
  FIsInSearching := True;
  try
    DoSearch;
  finally
    FIsInSearching := False;
  end;
end;

initialization
  Proc_ShowCtDmlSearch := ShowDmlSearchDialog;

end.

