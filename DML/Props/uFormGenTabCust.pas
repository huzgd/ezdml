unit uFormGenTabCust;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, CheckLst;

type

  { TfrmGenTabCust }

  TfrmGenTabCust = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnUp: TButton;
    btnDown: TButton;
    btnTop: TButton;
    btnBottom: TButton;
    ckbSelectAll: TCheckBox;
    ckblsTabs: TCheckListBox;
    Label1: TLabel;
    procedure btnBottomClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnTopClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure ckbSelectAllChange(Sender: TObject);
  private
    procedure MoveSelected(step: Integer);
  public
    procedure Init(conf, def: TStrings);      
    procedure GetConfigResult(conf: TStrings);
  end;

implementation

{$R *.lfm}

{ TfrmGenTabCust }

procedure TfrmGenTabCust.ckbSelectAllChange(Sender: TObject);
var
  I: Integer;
begin
  for I:=0 to ckblsTabs.Items.Count - 1 do
    ckblsTabs.Checked[I] := ckbSelectAll.Checked;
end;

procedure TfrmGenTabCust.MoveSelected(step: Integer);
var
  idx, tidx: Integer;
  ck1, ck2: Boolean;
begin
  idx := ckblsTabs.ItemIndex;
  if idx < 0 then
    Exit;
  tidx :=idx+step;
  if tidx<0 then
    tidx := 0
  else if tidx > ckblsTabs.Count - 1 then
    tidx := ckblsTabs.Count - 1;
  if idx=tidx then
    Exit;
  ck1 := ckblsTabs.Checked[idx];
  ck2 := ckblsTabs.Checked[tidx];
  ckblsTabs.Items.Exchange(idx, tidx); 
  ckblsTabs.Checked[idx] := ck2;
  ckblsTabs.Checked[tidx] := ck1;
  ckblsTabs.ItemIndex := tidx;
end;

procedure TfrmGenTabCust.btnUpClick(Sender: TObject);
begin
  MoveSelected(-1);
end;

procedure TfrmGenTabCust.btnDownClick(Sender: TObject);
begin
  MoveSelected(1);
end;

procedure TfrmGenTabCust.btnTopClick(Sender: TObject);
begin
  MoveSelected(-99999);
end;

procedure TfrmGenTabCust.btnBottomClick(Sender: TObject);
begin
  MoveSelected(99999);
end;

procedure TfrmGenTabCust.Init(conf, def: TStrings);
var
  I: Integer;
  bDef: Boolean;
begin
  ckblsTabs.Items.Clear;
  for I:=0 to conf.Count - 1 do
  begin
    if Trim(conf[I])='' then
      Continue;
    ckblsTabs.Items.Add(conf[I]);
  end;     
  for I:=0 to ckblsTabs.Items.Count - 1 do
  begin
    ckblsTabs.Checked[I] := True;
  end;

  bDef := (ckblsTabs.Items.Count = 0);

  for I:=0 to def.Count - 1 do
  begin
    if Trim(def[I])='' then
      Continue;       
    if ckblsTabs.Items.IndexOf(def[I])>=0 then
      Continue;
    ckblsTabs.Items.Add(def[I]);
  end;

  if bDef then
  begin
    ckbSelectAll.Checked := True;
    for I:=0 to ckblsTabs.Items.Count - 1 do
      ckblsTabs.Checked[I] := ckbSelectAll.Checked;
  end;
end;

procedure TfrmGenTabCust.GetConfigResult(conf: TStrings);  
var
  I: Integer;
begin
  conf.Clear; 
  for I:=0 to ckblsTabs.Items.Count - 1 do
    if ckblsTabs.Checked[I] then
    begin
      conf.Add(ckblsTabs.Items[I]);
    end;
end;

end.

