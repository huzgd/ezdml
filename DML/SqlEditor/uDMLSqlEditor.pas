unit uDMLSqlEditor;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls
  {$ifndef EZDML_LITE}, uDMLSqlEditorNew, uDMLSqlTabs{$else}, uDMLSqlEditorO{$endif};

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
{$ifndef EZDML_LITE}   
  bRect: TRect;
  bModal: Boolean;
{$endif}
begin
{$ifdef EZDML_LITE}  
  vDmlSqlEditorForm := TfrmDmlSqlEditorN.Create(Application);
  vDmlSqlEditorForm.PanelTbs.Tag := 1;
  if initSql <> '' then
  begin
    vDmlSqlEditorForm.MemoSql.Text := initSql;
    vDmlSqlEditorForm.AutoExecSql := initSql;
  end;
  vDmlSqlEditorForm.ShowModal;
{$else}      
  bModal := Application.ModalLevel>0;  
  if bModal then
  begin             
    vDmlSqlEditorForm := TfrmDmlSqlEditorN.Create(Application);
    vDmlSqlEditorForm.PanelTbs.Tag := 1;
    if initSql <> '' then
    begin
      vDmlSqlEditorForm.MemoSql.Text := initSql;
      vDmlSqlEditorForm.AutoExecSql := initSql;
    end;
    vDmlSqlEditorForm.ShowModal;
    //if frmSqlTabs.FSwitchToViewMode then
    //begin
    //  frmSqlTabs.FSwitchToViewMode := False;
    //  frmSqlTabs.bbtnView.Visible:=False;
    //  frmSqlTabs.bbtnView.Tag:=1;
    //  frmSqlTabs.Position:=poDesigned;
    //  //frmSqlTabs.FormStyle:=fsStayOnTop;
    //  frmSqlTabs.ShowInTaskBar := stAlways;
    //  frmSqlTabs.Show;
    //end;
    Exit;
  end;

  if frmSqlTabs = nil then
  begin
    frmSqlTabs := TfrmSqlTabs.Create(Application);  
    vDmlSqlEditorForm := frmSqlTabs.frmDmlSqlEditorMain;
    frmSqlTabs.LoadIniFile;
    if initSql = '' then
      vDmlSqlEditorForm.CheckLoadLast;
  end
  else
  begin
    vDmlSqlEditorForm := frmSqlTabs.CreateNewSqlEditor(nil);
  end;
  vDmlSqlEditorForm.PanelTbs.Tag := 1;
  if initSql <> '' then
  begin
    vDmlSqlEditorForm.MemoSql.Text := initSql;
    vDmlSqlEditorForm.AutoExecSql := initSql;
    vDmlSqlEditorForm.RefreshTitle(initSql);
  end;
  if frmSqlTabs.Showing then
  begin
    frmSqlTabs.BringToFront;
    Exit;
  end;
  frmSqlTabs.FormStyle := fsStayOnTop;
  frmSqlTabs.Show;

{$endif}
end;

end.

