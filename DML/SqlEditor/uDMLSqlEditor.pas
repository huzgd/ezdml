unit uDMLSqlEditor;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls{$ifndef EZDML_LITE}, uDMLSqlEditorNew{$else}, uDMLSqlEditorO{$endif};

type                     
{$ifndef EZDML_LITE}
  TfrmDmlSqlEditorN = TfrmDmlSqlEditor;
{$else}      
  TfrmDmlSqlEditorN = TfrmDmlSqlEditorO;
{$endif}

procedure ShowSqlEditor(initSql: string='');

implementation

procedure ShowSqlEditor(initSql: string);
var
  vDmlSqlEditorForm: TfrmDmlSqlEditorN;
  bRect: TRect;
begin
  vDmlSqlEditorForm := TfrmDmlSqlEditorN.Create(Application);
  vDmlSqlEditorForm.PanelTbs.Tag := 1;
  if initSql <> '' then
  begin
    vDmlSqlEditorForm.MemoSql.Text := initSql;      
    vDmlSqlEditorForm.AutoExecSql := initSql;
  end;
  vDmlSqlEditorForm.ShowModal;
{$ifndef EZDML_LITE}
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
    //vDmlSqlEditorForm.FormStyle:=fsStayOnTop;     
    vDmlSqlEditorForm.ShowInTaskBar := stAlways;
    vDmlSqlEditorForm.Show;
  end;   
{$endif}
end;

end.

