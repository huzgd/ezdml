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

procedure ShowSqlEditor;

implementation

uses
  ezdmlstrs;

procedure ShowSqlEditor;
var
  vDmlSqlEditorForm: TfrmDmlSqlEditorN;
  bRect: TRect;
begin
  vDmlSqlEditorForm := TfrmDmlSqlEditorN.Create(Application);
  vDmlSqlEditorForm.PanelTbs.Tag := 1;
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
    vDmlSqlEditorForm.FormStyle:=fsStayOnTop;
    vDmlSqlEditorForm.Show;
  end;   
{$endif}
end;

end.

