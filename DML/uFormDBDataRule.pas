unit uFormDBDataRule;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  CtMetaTable;

type

  { TfrmDBDataRule }

  TfrmDBDataRule = class(TForm)
    btnDesc: TButton;
    btnBack: TButton;
    btnRandom: TButton;
    btnOk: TButton;
    btnNext: TButton;
    btnAsc: TButton;
    Button4: TButton;
    edtPrefix: TComboBox;
    edtSuffix: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MemoRes: TMemo;
    PanelSqlEditor: TPanel;
    PanelDataRule: TPanel;
    TimerStart: TTimer;
    procedure btnAscClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnDescClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnRandomClick(Sender: TObject);
    procedure edtPrefixExit(Sender: TObject);
    procedure edtSuffixExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
  private
    FHasData: Boolean;
    FOrigCaption: String;  
    FLastPSuffixStr: String;
    procedure SetWizStep(iSt:Integer);  
    procedure AfterSqlExeced(Sender: TObject);
    procedure SortRes(tp: Integer);
    procedure CheckPSuffixRuleGen;
  public    
    TbDataSqlForm: TCustomForm;

    procedure Init(tb: TCtMetaTable; fd: string);
    procedure GetResultRules;
  end;

var
  frmDBDataRule: TfrmDBDataRule;

function ShowDBDataRule(tb: TCtMetaTable; fd: string): string;

implementation

{$R *.lfm}

uses
  uDMLSqlEditor, uFormCtDbLogon;

function ShowDBDataRule(tb: TCtMetaTable; fd: string): string;
begin
  Result := '';
  if tb=nil then
    Exit;

  if frmDBDataRule=nil then
    frmDBDataRule := TfrmDBDataRule.Create(Application);

  frmDBDataRule.Init(tb, fd);
  if frmDBDataRule.ShowModal = mrOk then
  begin
    Result := frmDBDataRule.MemoRes.Lines.Text;
    if Trim(Result)='' then
      Result := '';
  end;
end;

{ TfrmDBDataRule }


procedure TfrmDBDataRule.FormShow(Sender: TObject);
begin
  TimerStart.Enabled := False;
  TimerStart.Enabled := True;
end;

procedure TfrmDBDataRule.btnNextClick(Sender: TObject);
begin
  GetResultRules;
  SetWizStep(2);
end;

procedure TfrmDBDataRule.btnRandomClick(Sender: TObject);
begin
  SortRes(3);
end;

procedure TfrmDBDataRule.edtPrefixExit(Sender: TObject);
begin
  CheckPSuffixRuleGen;
end;

procedure TfrmDBDataRule.edtSuffixExit(Sender: TObject);
begin         
  CheckPSuffixRuleGen;
end;

procedure TfrmDBDataRule.btnBackClick(Sender: TObject);
begin
  SetWizStep(1);
end;

procedure TfrmDBDataRule.btnDescClick(Sender: TObject);
begin
  SortRes(2);
end;

procedure TfrmDBDataRule.btnAscClick(Sender: TObject);
begin
  SortRes(1);
end;

procedure TfrmDBDataRule.TimerStartTimer(Sender: TObject);  
var
  fr: TfrmDmlSqlEditorN;
begin
  TimerStart.Enabled := False;

  SetWizStep(1);
  fr := TfrmDmlSqlEditorN(TbDataSqlForm);
  if fr.FCtMetaDatabase <> nil then
    if fr.FCtMetaDatabase.Connected then
      fr.actExec.Execute;
end;

procedure TfrmDBDataRule.SetWizStep(iSt: Integer);
begin
  if iSt = 1 then
  begin
    PanelSqlEditor.Visible := True;
    PanelDataRule.Visible := False;    
    btnBack.Enabled := False;
    btnNext.Enabled := FHasData;
    btnOk.Enabled := False;
  end
  else if iSt = 2 then
  begin
    PanelSqlEditor.Visible := False;
    PanelDataRule.Visible := True;
    btnBack.Enabled := True;
    btnNext.Enabled := False;
    btnOk.Enabled := FHasData;
  end;
end;

procedure TfrmDBDataRule.AfterSqlExeced(Sender: TObject);  
var
  fr: TfrmDmlSqlEditorN;
begin
  FHasData := False;
  try
    fr := TfrmDmlSqlEditorN(TbDataSqlForm);
    if fr.ResultDataSet = nil then
      Exit;
    if not fr.ResultDataSet.Active then
      Exit;
    if fr.ResultDataSet.RecordCount = 0 then
      Exit;
    FHasData := True;
  finally
    SetWizStep(1);
  end;
end;

procedure TfrmDBDataRule.SortRes(tp: Integer);
var
  ss, ss2: TStringList;
  I: Integer;
begin
  ss:= TStringList.Create;  
  ss2:= TStringList.Create;
  try
    ss.Assign(MemoRes.Lines);
    if tp=1 then
    begin
      ss.Sorted := True;
      MemoRes.Lines.Assign(ss);
    end
    else if tp=2 then
    begin
      ss.Sorted := True;
      MemoRes.Lines.Clear;
      for I:=ss.Count - 1 downto 0 do
        ss2.Add(ss[I]);
      MemoRes.Lines.Assign(ss2);
    end
    else if tp=3 then
    begin
      Randomize;
      MemoRes.Lines.Clear;
      while ss.Count>0 do
      begin
        I := Random(ss.Count);
        ss2.Add(ss[I]);
        ss.Delete(I);
      end;   
      MemoRes.Lines.Assign(ss2);
    end;
  finally
    ss.Free;    
    ss2.Free;
  end;
end;

procedure TfrmDBDataRule.CheckPSuffixRuleGen;
var
  S: String;
begin
  S := edtPrefix.Text + #13#10 + edtSuffix.Text;
  if FLastPSuffixStr = S then
    Exit;
  GetResultRules;
end;

procedure TfrmDBDataRule.Init(tb: TCtMetaTable; fd: string);   
var
  sql, dbType: string;
  idx: integer;
  fr: TfrmDmlSqlEditorN;
begin          
  MemoRes.Lines.Clear;        
  edtPrefix.Text := '';       
  edtSuffix.Text := '';
  FLastPSuffixStr := '';
  SetWizStep(1);

  if FOrigCaption = '' then
    FOrigCaption := Caption;
  Caption := FOrigCaption + ' - ' + fd;

  if TbDataSqlForm = nil then
  begin
    fr := TfrmDmlSqlEditorN.Create(Self);
    TbDataSqlForm := fr;
    fr.BorderStyle := bsNone;
    fr.Parent := PanelSqlEditor;
    fr.Align := alClient;
    fr.SplitPercent := 65;
    fr.Visible := True;
    fr.AfterExec := Self.AfterSqlExeced;
  end
  else
    fr := TfrmDmlSqlEditorN(TbDataSqlForm);

  dbType := '';
  if fr.FCtMetaDatabase <> nil then
    dbType := fr.FCtMetaDatabase.EngineType
  else
  begin
    idx := GetLastCtDbConn(False);
    if idx >= 0 then
    begin
      dbType := CtMetaDBRegs[Idx].DbImpl.EngineType;
      if CtMetaDBRegs[Idx].DbImpl.Connected then
        fr.FCtMetaDatabase := CtMetaDBRegs[Idx].DbImpl;
    end;
  end;

  sql := tb.GenSelectSqlEx(500, ' distinct '+fd, '','', fd, dbType, fr.FCtMetaDatabase);
  fr.AutoExecSql := sql;
  fr.MemoSql.Lines.Text := sql;
end;

procedure TfrmDBDataRule.GetResultRules;
var
  fr: TfrmDmlSqlEditorN;
  ss: TStringList;
  S, S1, S2: String;
  I: Integer;
begin
  fr := TfrmDmlSqlEditorN(TbDataSqlForm);
  if fr.ResultDataSet = nil then
    Exit;
  if not fr.ResultDataSet.Active then
    Exit;   
  ss:= TStringList.Create;
  fr.ResultDataSet.DisableControls;
  try
    with fr.ResultDataSet do
    begin
      First;
      while not EOF do
      begin
        S := Fields[0].AsString;
        if S='' then
          S := '_null';
        if ss.IndexOf(S) = -1 then
          ss.Add(S);
        Next;
      end;
    end;

    S1 := edtPrefix.Text;
    S2 := edtSuffix.Text;
    MemoRes.Clear;
    for I:=0 to ss.Count - 1 do
    begin
      S := ss[I];
      if Trim(S)='' then
        Continue;
      if S <> '_null' then
      begin
        if (S1 <> '') or (S2<>'') then
          S:=S1+S+S2;
      end;
      MemoRes.Lines.Add(S);
    end;

    FLastPSuffixStr := edtPrefix.Text + #13#10 + edtSuffix.Text;
  finally
    ss.Free;  
    fr.ResultDataSet.EnableControls;
  end;
end;

end.

