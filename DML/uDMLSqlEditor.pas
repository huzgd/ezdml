unit uDMLSqlEditor;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, uDMLSqlEditorNew;

type
  TfrmDmlSqlEditorN = TfrmDmlSqlEditor;

procedure ShowSqlEditorNew;

implementation

procedure ShowSqlEditorNew;
var
  vDmlSqlEditorForm: TfrmDmlSqlEditorN;
  bRect: TRect;
begin
  vDmlSqlEditorForm := TfrmDmlSqlEditorN.Create(Application);
  vDmlSqlEditorForm.PanelTbs.Tag := 1;
  vDmlSqlEditorForm.ShowModal;
  if G_LastSqlText <> '' then
  begin
    bRect :=  vDmlSqlEditorForm.BoundsRect;
    vDmlSqlEditorForm := TfrmDmlSqlEditorN.Create(Application);
    vDmlSqlEditorForm.PanelTbs.Tag := 1;
    if Trim(G_LastSqlText) <> '' then
      vDmlSqlEditorForm.MemoSql.Text := G_LastSqlText;
    G_LastSqlText := '';
    vDmlSqlEditorForm.Position:=poDesigned;
    vDmlSqlEditorForm.BoundsRect := bRect;
    vDmlSqlEditorForm.FormStyle:=fsStayOnTop;
    vDmlSqlEditorForm.Show;
  end;
end;

end.

