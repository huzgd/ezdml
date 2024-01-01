unit uFrameCustPhyFieldTypes;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Grids, CtMetaTable;

type

  { TFrameCustPhyFieldTypes }

  TFrameCustPhyFieldTypes = class(TFrame)
    StringGridPT: TStringGrid;
    procedure StringGridPTPrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
  private
    FOrigCell: array[1..7,1..7] of string;
  public
    procedure Load(src: TStrings);
    procedure Save(src: TStrings);
  end;


implementation

{$R *.lfm}

uses
  ezdmlstrs;

const
  FCPField_dbNames: array[0..7] of String=('','Default','ORACLE','MYSQL','SQLSERVER','SQLITE','POSTGRESQL','HIVE');

{ TFrameCustPhyFieldTypes }

procedure TFrameCustPhyFieldTypes.StringGridPTPrepareCanvas(sender: TObject;
  aCol, aRow: Integer; aState: TGridDrawState);
var
  S: String;
begin
  if gdSelected in aState then
    Exit;

  if aCol >= 1 then
    if aRow >= 1 then
    begin
      S := StringGridPT.Cells[aCol, aRow];
      if S <> '' then
        if FOrigCell[aCol][aRow] <> S then
        begin
          StringGridPT.Canvas.Brush.Color := clYellow;
        end;
    end;
end;

procedure TFrameCustPhyFieldTypes.Load(src: TStrings);
  function GetCustFieldTp(tp: TCtFieldDataType; db: Integer; ft: String): String;
  var
    dbType, fk, S, V: string;
    I, po: Integer;
  begin
    Result := ft;
    dbType := '';
    if db>1 then
      dbType := FCPField_dbNames[db];
    fk := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[tp];
    if dbType <> '' then
      fk := fk+'_'+dbType;
    for I := 0 to src.Count-1 do
    begin
      po := Pos(':', src[I]);
      S := Copy(src[I], 1, po - 1);
      V := Trim(Copy(src[I], po + 1, Length(src[I])));
      if UpperCase(fk) = UpperCase(S) then
      begin
        if V <> '' then
          Result := V;
        Exit;
      end;
    end;
  end;
var
  AllCtFieldDataTypeNames: array[0..7] of TCtFieldDataTypeNames;
  t: TCtFieldDataType;
  X,Y: integer;
  ft: string;
begin
  AllCtFieldDataTypeNames[0] := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG;   
  AllCtFieldDataTypeNames[1] := DEF_CTMETAFIELD_DATATYPE_NAMES_STD;
  AllCtFieldDataTypeNames[2] := DEF_CTMETAFIELD_DATATYPE_NAMES_ORACLE;
  AllCtFieldDataTypeNames[3] := DEF_CTMETAFIELD_DATATYPE_NAMES_MYSQL;
  AllCtFieldDataTypeNames[4] := DEF_CTMETAFIELD_DATATYPE_NAMES_SQLSERVER;
  AllCtFieldDataTypeNames[5] := DEF_CTMETAFIELD_DATATYPE_NAMES_SQLITE;
  AllCtFieldDataTypeNames[6] := DEF_CTMETAFIELD_DATATYPE_NAMES_POSTGRESQL; 
  AllCtFieldDataTypeNames[7] := DEF_CTMETAFIELD_DATATYPE_NAMES_HIVE;

  StringGridPT.ColCount:= Length(AllCtFieldDataTypeNames);        
  StringGridPT.RowCount:= 8;
  for X := 0 to High(AllCtFieldDataTypeNames) do
  begin                               
    StringGridPT.Cells[X, 0] := FCPField_dbNames[X];
    for t := cfdtString to cfdtBlob do
    begin
      Y := Integer(T);
      ft := AllCtFieldDataTypeNames[X][t];
      if X=0 then
        if ft <> DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t] then
          ft := DEF_CTMETAFIELD_DATATYPE_NAMES_CHN[t] + '('+ft+')';

      if X = 1 then
        ft := ''
      else if t=cfdtString then
      begin
       if (X>1) and (X<=4) then
         ft := ft+'(4000)';
      end
      else if t = cfdtInteger then
      begin
        if X = 2 then
          ft := ft + '(10)';
      end;

      if X > 0 then
      begin
        FOrigCell[X][Y] := ft;
        ft := GetCustFieldTp(t, X, ft);
      end;
      StringGridPT.Cells[X, Y] := ft;
    end;
  end;            
  StringGridPT.Cells[1, 0] := srEzdmlDefault;
  StringGridPT.AutoSizeColumns;

  if StringGridPT.ColWidths[1] < 80 then
    StringGridPT.ColWidths[1] := 80;
end;

procedure TFrameCustPhyFieldTypes.Save(src: TStrings);  
  procedure AddCustTp(tp: TCtFieldDataType; db: Integer; ft: String);
  var
    dbType, fk, S: string;
  begin
    dbType := '';
    if db>1 then
      dbType := FCPField_dbNames[db];
    fk := DEF_CTMETAFIELD_DATATYPE_NAMES_ENG[tp];
    if dbType <> '' then
      fk := fk+'_'+dbType;
    S := fk+':'+ft;
    src.ADD(S);
  end;
var
  t: TCtFieldDataType;
  X,Y: integer;
  ft, V: string;
begin
  src.Clear;
  for X := 1 to High(FCPField_dbNames) do
  begin
    for t := cfdtString to cfdtBlob do
    begin
      Y := Integer(T);
      ft :=FOrigCell[X][Y];
      V := StringGridPT.Cells[X, Y];
      if V <> '' then
        if V <> ft then
          AddCustTp(T, X, V);
    end;
  end;
end;

end.

