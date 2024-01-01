unit PasGen_JDBCServer;

{$mode delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs, Variants, DB, Menus,
  CtMetaTable, CTMetaData, CtObjSerialer, DmlScriptPublic, DmlPasScriptLite;

type

  { TDmlPasScriptorLite_JDBCServer }

  TDmlPasScriptorLite_JDBCServer=class(TDmlPasScriptorLite)
  public
    { Public declarations }
    procedure Exec(ARule, AScript: string); override;
  end;

implementation

uses
  StdCtrls, WindowFuncs;

{ TDmlPasScriptorLite_JDBCServer }


procedure TDmlPasScriptorLite_JDBCServer.Exec(ARule, AScript: string);
// 以下代码来源于EZDML自定义工具脚本模板Add all tables.pas

function ShowConfigForm(fn: String): Boolean; //执行窗体代码
var
  frm: TForm;
  fx, fy, fw, dy: Integer;
  lang, S, res: String;
  bIsChn: Boolean;
begin
  Result := False;
  res := '';
  lang := GetEnv('LANGUAGE');
  if (lang='ch') or (lang='zh') or (lang='CHS') then
    bIsChn:=True
  else
    bIsChn:=False;

  frm:=TForm.Create(nil); //创建窗体
  try
    with frm do //设置窗体属性
    begin
      BorderStyle := bsDialog; //默认为bsSizeable
      Position := poMainFormCenter;
      Font.Assign(Application.MainForm.Font);
      Caption := 'HTTP_JDBC Configure';
      if bIsChn then
        Caption := 'HTTP_JDBC配置';
      Width := 700;
      Height := 500;
    end;

    fx := 20;
    fy := 20;
    fw := 650;
    dy := 10;

    with TLabel.Create(frm) do //名字
    begin
      Parent := frm;
      Left := fx;
      Top := fy;
      Caption := 'Please edit and confirm following configures:';
      if bIsChn then
        Caption := '请编辑确认以下配置信息：';
      fy := fy + Height + dy;
    end;

    with TMemo.Create(frm) do
    begin
      Parent := frm;
      Name := 'memoConfig';
      Lines.Text := '';
      Left := fx;
      Top := fy;
      Width := fw;
      Height := 300;
      Lines.LoadFromFile(fn);
      res := Lines.Text;
      ScrollBars := ssBoth;

      fy := fy + Height + dy;
    end;

    with TLabel.Create(frm) do //名字
    begin
      Parent := frm;
      Left := fx;
      Top := fy;
      Caption := 'Config-file location:';
      if bIsChn then
        Caption := '配置文件路径：';
      fy := fy + Height + dy;
    end;

    with TEdit.Create(frm) do //文件位置
    begin
      Parent := frm;
      Left := fx;
      Top := fy;
      Width := fw;
      Text :=fn;
      ReadOnly := True;
      ParentColor := True;
      fy := fy + Height + dy;
    end;

    fy := fy + 10 + dy;

    with TButton.Create(frm) do //确定
    begin
      Parent := frm;
      //Name := 'btnOK';
      Caption := 'Run';
      if bIsChn then
        Caption := '运行';
      ModalResult := mrOk; //点此按钮将关闭窗口并返回mrOk
      Left := (frm.Width -150) div 2;
      Top := fy;
      Width := 70;
      //fy := fy + Height + dy;
    end;

    with TButton.Create(frm) do //取消
    begin
      Parent := frm;
      //Name := 'btnCancel';
      Caption := 'Cancel';
      if bIsChn then
        Caption := '取消';
      Cancel := True; //表示按ESC时执行此按钮
      ModalResult := mrCancel; //点此按钮将关闭窗口并返回mrCancel
      Left := (frm.Width -150) div 2+80;
      Top := fy;
      Width := 70;
      //fy := fy + Height + dy;
    end;


    if frm.ShowModal = mrOk then
    begin
      S := TMemo(FindChildComp(frm, 'memoConfig')).Lines.Text;
      if Trim(res) <> Trim(S) then
        TMemo(FindChildComp(frm, 'memoConfig')).Lines.SaveToFile(fn);
      Result :=True;  //返回结果
    end;
  finally
    frm.Free;
  end;
end;
var
  sys, cmd, conf, pth, cmdline: String;
begin
  pth := GetEnv('APPFOLDER');
  if pth <> '' then
    if (pth[Length(pth)] = '\') or (pth[Length(pth)] = '/') then
      Delete(pth, Length(pth), 1);

  sys := GetEnv('SYSTEMTYPE');
  if (sys='DARWIN') or (sys='UNIX') then
  begin
    cmd := '/jdbc/ezjdbc.sh';
    conf := '/jdbc/conf.sh';
    SetCurrentDir(pth+'/jdbc');
    if (sys='DARWIN') then
      cmdline := 'open -a Terminal "'+pth+cmd+'"'
    else
      cmdline := 'xterm -e bash -c '''+pth+cmd+''' &';
  end
  else
  begin
    cmd := '\jdbc\ezjdbc.bat';
    conf := '\jdbc\conf.bat';
    SetCurrentDir(pth+'\jdbc');
    cmdline := pth+cmd;
  end;

  if not FileExists(pth+cmd) then
  begin
    alert('Command file not found: '+pth+cmd);
    Exit;
  end;
  if not FileExists(pth+conf) then
  begin
    alert('Config file not found: '+pth+conf);
    Exit;
  end;
  if ShowConfigForm(pth+conf) then
  begin
    if (sys='DARWIN') or (sys='UNIX') then
      RunCmd(cmdline, 1)
    else
      ShellOpen(cmdline, '', '');
  end;

end;

initialization
  RegisterPasLite('JDBC server', TDmlPasScriptorLite_JDBCServer, 'Tool');

end.

