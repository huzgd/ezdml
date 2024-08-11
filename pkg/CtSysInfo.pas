unit CtSysInfo;

{$mode delphi}

interface

uses
  Classes, {$IFDEF Windows}windows, {$ENDIF}SysUtils, process;
           
function GetThisComputerName: string;   
function GetMyComputerId: string;

implementation

uses
  IniFiles, WindowFuncs;

var
  G_MyComputerId: string;

function GetMyComputerId: string;
var
  ini: TIniFile;
begin
  if G_MyComputerId=''then
  begin     
    ini := TIniFile.Create(GetConfFileOfApp);
    try              
      G_MyComputerId := ini.ReadString('Updates', 'UID', '');
      if G_MyComputerId=''then
      begin
        G_MyComputerId := CtGenGuid;
        ini.WriteString('Updates', 'UID', G_MyComputerId);
      end;
    finally
      ini.Free;
    end;
  end;
  Result := G_MyComputerId;
end;

function GetThisComputerName: string;
var
  c: array[0..127] of Char;
  computer: string;
  sz: dword;
  AProcess: TProcess;
  AStringList: TStringList;
begin
{$IFDEF Windows}
  sz := SizeOf(c);
  GetComputerName(c, sz);
  Result := c;
{$ELSE}
  AProcess := TProcess.Create(nil);
  AStringList := TStringList.Create;
  AProcess.CommandLine := 'echo $HOSTNAME';
  AProcess.Options := AProcess.Options + [poWaitOnExit, poUsePipes];
  AProcess.Execute;
  AStringList.LoadFromStream(AProcess.Output);
  Result:=Trim(AStringList.Strings[0]);
  AStringList.Free;
  AProcess.Free;
{$ENDIF}
end;

end.

