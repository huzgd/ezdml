unit CtSysInfo;

{$mode delphi}

interface

uses
  Classes, {$IFDEF Windows}windows, {$ENDIF}SysUtils, process;
           
function GetThisComputerName: string;
var
  G_MyComputerId: string;

implementation

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

