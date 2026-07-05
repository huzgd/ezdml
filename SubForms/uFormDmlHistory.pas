unit uFormDmlHistory;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls;

type
  TDmlHistoryFile = record
    FileName: string;
    FileDate: TDateTime;
    FileSize: Int64;
  end;

  TDmlHistoryFiles = array of TDmlHistoryFile;

  { TfrmDmlHistory }

  TfrmDmlHistory = class(TForm)
    btnCancel: TButton;
    btnRestore: TButton;
    btnShowInExplorer: TButton;
    lbPrompt: TLabel;
    ListViewVersions: TListView;
    PanelBottom: TPanel;
    PanelTop: TPanel;
    procedure btnShowInExplorerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewVersionsDblClick(Sender: TObject);
    procedure ListViewVersionsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private                     
    FBackupDir: String;
    FBackupFiles: TStringList;
    procedure LoadBackupFiles(const ABackupDir, ABaseFileName: string);
    function GetBackupCount: Integer;
    function GetSelectedFile: string;
  public
    procedure Init(const ABackupDir, ABaseFileName, ACurrentFileName: string);
    property BackupCount: Integer read GetBackupCount;
    property SelectedFile: string read GetSelectedFile;
  end;

function ShowDmlHistoryDialog(const ABackupDir, ABaseFileName,
  ACurrentFileName: string; out ASelectedFile: string): Boolean;

implementation

uses
  Dialogs, ezdmlstrs, WindowFuncs;

{$R *.lfm}

function FormatHistoryFileSize(AFileSize: Int64): string;
begin
  if AFileSize < 1024 then
    Result := Format('%d B', [AFileSize])
  else if AFileSize < 1024 * 1024 then
    Result := FormatFloat('0.0 KB', AFileSize / 1024)
  else
    Result := FormatFloat('0.0 MB', AFileSize / 1024 / 1024);
end;

procedure SortHistoryFiles(var AFiles: TDmlHistoryFiles);
var
  I, J: Integer;
  V: TDmlHistoryFile;
begin
  for I := 0 to High(AFiles) - 1 do
    for J := I + 1 to High(AFiles) do
      if AFiles[J].FileDate > AFiles[I].FileDate then
      begin
        V := AFiles[I];
        AFiles[I] := AFiles[J];
        AFiles[J] := V;
      end;
end;

function ShowDmlHistoryDialog(const ABackupDir, ABaseFileName,
  ACurrentFileName: string; out ASelectedFile: string): Boolean;
var
  Frm: TfrmDmlHistory;
begin
  Result := False;
  ASelectedFile := '';
  Frm := TfrmDmlHistory.Create(Application);
  try
    Frm.Init(ABackupDir, ABaseFileName, ACurrentFileName);
    if Frm.BackupCount = 0 then
    begin
      MessageDlg(srEzdmlNoHistoryBackup, mtInformation, [mbOK], 0);
      Exit;
    end;
    if Frm.ShowModal <> mrOk then
      Exit;
    ASelectedFile := Frm.SelectedFile;
    Result := ASelectedFile <> '';
  finally
    Frm.Free;
  end;
end;

procedure TfrmDmlHistory.FormCreate(Sender: TObject);
begin
  FBackupFiles := TStringList.Create;
end;

procedure TfrmDmlHistory.btnShowInExplorerClick(Sender: TObject);
begin
  CtOpenDir(FBackupDir);
end;

procedure TfrmDmlHistory.FormDestroy(Sender: TObject);
begin
  FBackupFiles.Free;
end;

procedure TfrmDmlHistory.ListViewVersionsDblClick(Sender: TObject);
begin
  if GetSelectedFile <> '' then
    ModalResult := mrOk;
end;

procedure TfrmDmlHistory.ListViewVersionsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  btnRestore.Enabled := Selected;
end;

procedure TfrmDmlHistory.LoadBackupFiles(const ABackupDir,
  ABaseFileName: string);
var
  SearchRec: TSearchRec;
  Files: TDmlHistoryFiles;
  Item: TListItem;
  FileMask: string;
  I, Count: Integer;
begin
  FBackupFiles.Clear;
  ListViewVersions.Items.BeginUpdate;
  try
    ListViewVersions.Items.Clear;
    if not DirectoryExists(ABackupDir) then
      Exit;

    FileMask := IncludeTrailingPathDelimiter(ABackupDir) +
      ABaseFileName + '(*).~dmh';
    Count := 0;
    if FindFirst(FileMask, faAnyFile, SearchRec) = 0 then
    try
      repeat
        if (SearchRec.Attr and faDirectory) = 0 then
        begin
          SetLength(Files, Count + 1);
          Files[Count].FileName := IncludeTrailingPathDelimiter(ABackupDir) +
            SearchRec.Name;
          Files[Count].FileDate := FileDateToDateTime(SearchRec.Time);
          Files[Count].FileSize := SearchRec.Size;
          Inc(Count);
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;

    SortHistoryFiles(Files);
    for I := 0 to High(Files) do
    begin
      FBackupFiles.Add(Files[I].FileName);
      Item := ListViewVersions.Items.Add;
      Item.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss', Files[I].FileDate);
      Item.SubItems.Add(FormatHistoryFileSize(Files[I].FileSize));
    end;
    if ListViewVersions.Items.Count > 0 then
    begin
      ListViewVersions.Items[0].Selected := True;
      ListViewVersions.Items[0].Focused := True;
    end;
  finally
    ListViewVersions.Items.EndUpdate;
  end;
end;

function TfrmDmlHistory.GetBackupCount: Integer;
begin
  Result := FBackupFiles.Count;
end;

function TfrmDmlHistory.GetSelectedFile: string;
begin
  Result := '';
  if Assigned(ListViewVersions.Selected) then
    if ListViewVersions.Selected.Index < FBackupFiles.Count then
      Result := FBackupFiles[ListViewVersions.Selected.Index];
end;

procedure TfrmDmlHistory.Init(const ABackupDir, ABaseFileName,
  ACurrentFileName: string);
begin
  FBackupDir := ABackupDir;
  if ACurrentFileName <> '' then
    lbPrompt.Caption := Format(srEzdmlHistoryBackupPromptFmt,
      [ACurrentFileName]);
  LoadBackupFiles(ABackupDir, ABaseFileName);
  btnRestore.Enabled := GetSelectedFile <> '';
end;

end.
