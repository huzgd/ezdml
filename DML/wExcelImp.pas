unit wExcelImp;

{$mode objfpc}{$H+}

interface

uses
  LCLType, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, Menus, CtMetaTable;

type

  { TfrmExcelImp }

  TfrmExcelImp = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    ckbSaveValuesInFieldParams: TCheckBox;
    ImageList1: TImageList;
    lbGridTip: TLabel;
    lbTxtTip: TLabel;
    MemoTxt: TMemo;
    mnAsDefaultValue: TMenuItem;
    mnAsPrecision: TMenuItem;
    mnIsUnique: TMenuItem;
    mnAsConstraintStr: TMenuItem;
    mnAsRequired: TMenuItem;
    mnAsNullable: TMenuItem;
    mnAsComment: TMenuItem;
    mnDataSize: TMenuItem;
    mnAsDataType: TMenuItem;
    mnAsDisplayName: TMenuItem;
    mnAsName: TMenuItem;
    MenuItem2: TMenuItem;
    mnColName: TMenuItem;
    PanelExcel1: TPanel;
    PanelBT: TPanel;
    PanelExcel2: TPanel;
    PopupMenuGrid: TPopupMenu;
    SplitterM1: TSplitter;
    StringGridRes: TStringGrid;
    TimerCheckParse: TTimer;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MemoTxtChange(Sender: TObject);
    procedure MemoTxtExit(Sender: TObject);
    procedure mnColNameClick(Sender: TObject);
    procedure SplitterM1Moved(Sender: TObject);
    procedure StringGridResHeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure TimerCheckParseTimer(Sender: TObject);
  private
    FLastParsedText: string;
    FFirstFieldCapRow: Integer;
    FSplitPercent: Double;
    dtNames: array[0..11] of String;
    procedure ParseTextToGrid;     
    procedure CheckParseText;
    procedure GuessColTypes;
    procedure DoImportTables;    
    procedure ImportTablesEx(tbs: TCtMetaTableList);
  public
    FCtTbList: TCtMetaTableList;
  end;


implementation

{$R *.lfm}

uses
  dmlstrs, WindowFuncs;

function EvalColType(str: string): Integer;
var
  I, J, res2: Integer;
  ss, tt: TStringList;
  S, T: String;
begin
  Result := 0;
  res2 := 0;
  str := LowerCase(Trim(str));
  if str='' then
    Exit;
  ss:= TStringList.Create;   
  tt:= TStringList.Create;
  try
    ss.Text := srImportFieldProps;
    for I:=0 to ss.Count -1 do
    begin
      if Trim(ss[I])='' then
        Continue;
      tt.CommaText:=ss[I]; 
      for J:=0 to tt.Count -1 do
      begin
        S:=LowerCase(Trim(tt[J]));
        if S = str then
        begin
          Result := I + 1;
          Exit;
        end;
        if res2=0 then
        begin
          if Pos(S, str)>0 then
            res2 := I + 1
          else
          begin
            S := StringReplace(S, ' ', '', [rfReplaceAll]);
            if Pos(S, str)>0 then
              res2 := I + 1;
          end;
        end;
      end;
    end;
  finally
    ss.Free;
    tt.Free;
  end;
  if res2>0 then
    Result := res2;
end;

{ TfrmExcelImp }

procedure TfrmExcelImp.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmExcelImp.btnOkClick(Sender: TObject);
begin
  DoImportTables;
  ModalResult := mrOk;
end;

procedure TfrmExcelImp.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  FSplitPercent := 1 - 0.618;

  i:=0;
  dtNames[i] := '';
  Inc(I);                      
  dtNames[i] := mnAsName.Caption;
  Inc(I);
  dtNames[i] := mnAsDisplayName.Caption;
  Inc(I);
  dtNames[i] := mnAsDataType.Caption;
  Inc(I);
  dtNames[i] := mnDataSize.Caption;
  Inc(I);
  dtNames[i] := mnAsNullable.Caption;
  Inc(I);
  dtNames[i] := mnAsRequired.Caption;
  Inc(I);
  dtNames[i] := mnIsUnique.Caption;
  Inc(I);
  dtNames[i] := mnAsConstraintStr.Caption;
  Inc(I);
  dtNames[i] := mnAsComment.Caption;
end;

procedure TfrmExcelImp.FormResize(Sender: TObject);
begin
  PanelExcel1.Width := Round(Self.ClientWidth * FSplitPercent);
end;

procedure TfrmExcelImp.MemoTxtChange(Sender: TObject);
begin
  CheckParseText;
end;

procedure TfrmExcelImp.MemoTxtExit(Sender: TObject);
begin
  CheckParseText;
end;

procedure TfrmExcelImp.mnColNameClick(Sender: TObject);
var
  tg, Acol: Integer;
begin
  if Sender=nil then
    Exit;
  tg := TMenuItem(Sender).Tag;
  if tg<0 then
    Exit;
  ACol := StringGridRes.Col;
  StringGridRes.Columns.Items[ACol].Tag:=tg+200;
  if tg=0 then
  begin
    StringGridRes.Columns.Items[ACol].Title.Caption := 'C'+IntToStr(ACol+1);
  end
  else
  begin
    StringGridRes.Columns.Items[ACol].Title.Caption := TMenuItem(Sender).Caption;
  end;
end;

procedure TfrmExcelImp.SplitterM1Moved(Sender: TObject);
begin
  if PanelExcel1.Width > 10 then
    FSplitPercent := PanelExcel1.Width / Self.ClientWidth;
end;

procedure TfrmExcelImp.StringGridResHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
var
  pt: TPoint;
  rct : TRect;
  I: Integer;
  S: String;
begin
  StringGridRes.Col := Index;
  mnColName.Caption := 'C'+IntToStr(Index+1);
  S := StringGridRes.Columns.Items[Index].Title.Caption;
  for I:=0 to PopupMenuGrid.Items.Count - 1 do
    PopupMenuGrid.Items[I].Checked := PopupMenuGrid.Items[I].Caption = S;
  rct := StringGridRes.CellRect(Index, 0);
  pt.X := rct.Left;
  pt.Y := rct.Bottom;
  pt := StringGridRes.ClientToScreen(pt);
  PopupMenuGrid.PopUp(pt.X, pt.Y);
end;

procedure TfrmExcelImp.TimerCheckParseTimer(Sender: TObject);
begin
  TimerCheckParse.Enabled := False;
  if Trim(FLastParsedText) = Trim(MemoTxt.Lines.Text) then
    Exit;
  FLastParsedText := MemoTxt.Lines.Text;
  ParseTextToGrid;
end;

procedure TfrmExcelImp.ParseTextToGrid;

  function ReplaceExcelQuotLF(sIn: string): string;
  var
    I, L: Integer;
  begin  //替换掉双引号中的回车换行制表符
    Result := '';
    L := Length(sIn);
    I:=1;
    while I <= L do
    begin
      if sIn[I]='"' then
      begin
        Inc(I);
        while I <= L do
        begin
          if sIn[I]=#9 then
            Result := Result+'\t'
          else if sIn[I]=#10 then
            Result := Result+'\n'
          else if sIn[I]=#13 then
            Result := Result+'\r'
          else if sIn[I]='"' then
          begin
            if I=L then
              Break;
            if sIn[I+1]<>'"' then  //下一个是不是双引号？不是就结束了
            begin
              Inc(I);
              Break;
            end;
            Result := Result+'"';   //两个双引号? 转成一个
            Inc(I);
          end
          else
            Result := Result+sIn[I];
          Inc(I);
        end;
      end
      else
      begin
        Result := Result+sIn[I];
        Inc(I);
      end;
    end;
  end;

  procedure SetCellText(ARow, ACol: integer; AValue: string);
  var
    cap: string;
  begin
    if (ARow < 1) then
      Exit;
    while (StringGridRes.RowCount <= ARow) do
    begin
      StringGridRes.RowCount := ARow + 1;
      StringGridRes.Row := StringGridRes.RowCount - 1;
    end;        
    while (StringGridRes.ColCount <= ACol) do
    begin
      cap := 'C' + IntToStr(StringGridRes.ColCount+1);
      with StringGridRes.Columns.Add do
      begin
        Title.ImageIndex := 0;
        Title.Caption := cap;
      end;
      StringGridRes.Cells[ACol, 0] := cap;
    end;
    StringGridRes.Cells[ACol, ARow] := AValue;
  end;

var
  S, T, V, sCrLf: string;
  ss, sv: TStringList;
  I, J, x, y, po, maxC: integer;
  bCrLf: Boolean;
begin
  S := MemoTxt.Lines.Text;
  if Trim(S) = '' then
    Exit;       
  StringGridRes.Clear;
  maxC := 1;
  ss := TStringList.Create;
  sv := TStringList.Create;
  try
    sCrLf := '<crlf>';
    bCrLf := False;
    if (Pos(sCrLf+#9, S+#9) > 0) or (Pos(sCrLf+#10, S+#10) > 0) or (Pos(sCrLf+#13, S+#13) > 0) then
    begin  //对用<crlf>分隔的进行替换处理
      S := Trim(S);
      S := StringReplace(S, #13#10'<crlf>', '<crlf>', [rfReplaceAll]);
      S := StringReplace(S, #13'<crlf>', '<crlf>', [rfReplaceAll]);
      S := StringReplace(S, #10'<crlf>', '<crlf>', [rfReplaceAll]);
      S := StringReplace(S, '<crlf>'#9, '<crlf>', [rfReplaceAll]);
      S := StringReplace(S, #13, '\r', [rfReplaceAll]);
      S := StringReplace(S, #10, '\n', [rfReplaceAll]);
      S := StringReplace(S, '<crlf>', #13#10, [rfReplaceAll]);
      bCrLf := True;
    end
    else
    begin
      if (Pos(#9'"', #9+S)>0) or (Pos(#10'"', #10+S)>0) then
      begin
        S := ReplaceExcelQuotLF(S); //对有双引号的进行处理
        bCrLf := True;
      end;

      //对于多行备注可能跨行的情况进行处理，如果一行数据只有备注有值，则将内容归到上一行，并清空本行
     { ss.Text := S;
      for I := ss.Count - 1 downto 0 do
      begin
        V := ss[I];
        po := Pos('\n', V);
        if po>0 then
        begin
          //忽略回车符后面的制表符
          T := Copy(V, po+1, Length(V));
          V := Copy(V, 1, po);
          T := StringReplace(T, #9, ' ', [rfReplaceAll]);
          V := V+ T;
        end;
        sv.Text := StringReplace(V, #9, #10, [rfReplaceAll]);
        if sv.Count >= 6 then
        begin
          if Trim(sv[0]+sv[1]+sv[2]+sv[3]+sv[4]) = '' then
          begin
            ss[I-1] := ss[I-1] + '\n' + Trim(V);
            ss.Delete(I);
            bCrLf := True;
          end;
        end;
      end;
      S := ss.Text; }
    end;

    ss.Text := S;
    while ss.Count > 0 do
      if Trim(ss[0])='' then
        ss.Delete(0)
      else if Trim(ss[ss.Count-1])='' then
        ss.Delete(ss.Count-1)
      else
        Break;
    x := 0;
    y := 1;
    for I := 0 to ss.Count - 1 do
    begin
      V := ss[I];
      //if Trim(V) = '' then
        //Continue;
      {po := Pos('\n', V);
      if po>0 then
      begin
        //忽略回车符后面的制表符
        T := Copy(V, po+1, Length(V));
        V := Copy(V, 1, po);
        T := StringReplace(T, #9, ' ', [rfReplaceAll]);
        V := V+ T;
      end; }
      sv.Text := StringReplace(V, #9, #10, [rfReplaceAll]);

      for J := 0 to sv.Count - 1 do
      begin
        try
          V := sv[J];
          if bCrLf then
          begin
            V := StringReplace(V, '\r', #13, [rfReplaceAll]);
            V := StringReplace(V, '\n', #10, [rfReplaceAll]);
          end;
          if maxC < x+J+1 then
            maxC := x+J+1;
          SetCellText(y, x + J, V);
        except
        end;
      end;
      Inc(y);
    end;

  finally
    ss.Free;
    sv.Free;
  end;
  while (StringGridRes.ColCount > maxC) do
    StringGridRes.Columns.Delete(StringGridRes.ColCount - 1);
  GuessColTypes;
end;

procedure TfrmExcelImp.CheckParseText;
begin
  TimerCheckParse.Enabled := False;
  TimerCheckParse.Enabled := True;
end;

procedure TfrmExcelImp.GuessColTypes;
var
  I, x, y: Integer;
  bFlag : boolean;
begin
  //找到第一行是所有列都有数据的
  y := -1;
  for I:=1 to StringGridRes.RowCount -1 do
  begin
    bFlag := False;
    for x := 0 to StringGridRes.ColCount - 1 do
    begin
      if Trim(StringGridRes.Cells[x, I])='' then
      begin
        bFlag := True;
        Break;
      end;
    end;
    if not bFlag then
    begin
      y := I;
      Break;
    end;
  end;
        
  FFirstFieldCapRow := y;
  if y<=0 then //没找到？
    Exit;

    
  for x := 0 to StringGridRes.ColCount - 1 do
    if StringGridRes.Columns.Items[x].Tag < 200 then
    begin
      I := EvalColType(StringGridRes.Cells[x, y]);
      if I > 0 then
      begin
        StringGridRes.Columns.Items[x].Tag := 100 + I;
        StringGridRes.Columns.Items[x].Title.Caption := dtNames[I];
      end
      else
      begin  
        StringGridRes.Columns.Items[x].Tag := 0;
        StringGridRes.Columns.Items[x].Title.Caption := 'C'+IntToStr(x+1);
      end;
    end;
end;

procedure TfrmExcelImp.DoImportTables;
var
  tbs: TCtMetaTableList;
  tb: TCtMetaTable;
  I: Integer;
  S, T: String;
begin
  if StringGridRes.ColCount < 2 then
    Abort;
  tbs := TCtMetaTableList.Create;
  try
    ImportTablesEx(tbs);
    T := '';
    for I:=0 to tbs.Count - 1 do
    begin
      if T<>'' then
        T :=T+', ';
      T := T +tbs[I].Name;
      if HasSameNameTables(tbs[I], tbs[I].Name) then
      begin
        S := Format(srRenameToExistsError, [tbs[I].Name]);
        Application.MessageBox(PChar(S), PChar(Application.Title),
          MB_OK or MB_ICONERROR);
        Abort;
      end;
    end;

    if tbs.Count = 0 then
      Abort;
    S := Format(srImportingTbConfirm, [tbs.Count, T]);  
    if Application.MessageBox(PChar(S), PChar(Application.Title),
      MB_OKCANCEL or MB_ICONQUESTION)<>IDOK then
      Abort;
         
    for I:=0 to tbs.Count - 1 do
    begin
      tb := FCtTbList.NewTableItem();
      tb.AssignFrom(tbs[I]);
    end;
  finally
    tbs.Free;
  end;
end;

procedure TfrmExcelImp.ImportTablesEx(tbs: TCtMetaTableList);
  function OnlyFirstColVal(row: integer): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    if Trim(StringGridRes.Cells[0, row]) = '' then
      Exit;
    for I:=1 to StringGridRes.ColCount - 1 do
    begin
      if Trim(StringGridRes.Cells[I, row])<>'' then
       Exit;
    end;
    Result := True;
  end;

  function IsFieldCapRow(row: Integer): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    if FFirstFieldCapRow<=0 then
      Exit;
    for I:=0 to StringGridRes.ColCount - 1 do
    begin
      if LowerCase(Trim(StringGridRes.Cells[I, row]))
       <> LowerCase(Trim(StringGridRes.Cells[I, FFirstFieldCapRow])) then
       Exit;
    end;
    Result := True;
  end;

  procedure SetTbNameCap(tb: TCtMetaTable; str: string);
  var
    po: Integer;
    S, T: String;
  begin
    s := Trim(str);

    po := Pos('.', s);
    if po>0 then
    begin
      T := Trim(Copy(S, 1, po-1));
      if StrToIntDef(T, -9999) >= 0 then
      begin
        s:=Trim(Copy(S, po+1, Length(S)));
      end;
    end;

    po := Pos('(', s);
    if po=0 then      
      po := Pos(' ', s);
    if po=0 then
      po := Pos(#9, s); 
    if po=0 then
      po := Pos('[', s);
    if po=0 then
      po := Pos(':', s);
    if po>0 then
    begin
      T := Copy(S, po, Length(S));
      S := Copy(S, 1, po-1);
    end
    else
    begin
      T := '';
    end;
    tb.Name:=S;

    if (Copy(T, 1, 1)='(') and (Copy(T, Length(T), 1)=')') then
      T:=Copy(T, 2, Length(T)-2)
    else if (Copy(T, 1, 1)='[') and (Copy(T, Length(T), 1)=']') then
      T:=Copy(T, 2, Length(T)-2);
    tb.Caption:=T;
  end;

  procedure SetTbComment(tb: TCtMetaTable; str: string);
  var
    J: Integer;
    ss, tt: TStringList;
    S, T: String;
  begin
    str :=Trim(str);
    T := LowerCase(str);
    ss:= TStringList.Create;
    tt:= TStringList.Create;
    try
      ss.Text := srImportFieldProps;
      if ss.Count >= 9 then
      begin
        tt.CommaText:=ss[8];
        for J:=0 to tt.Count -1 do
        begin
          S:=LowerCase(Trim(tt[J]));
          if Pos(S+':', T)=1 then
          begin
            str := Copy(str, Length(S) + 2, Length(str));
            Break;
          end;     
          if Pos(S+' ', T)=1 then
          begin
            str := Copy(str, Length(S) + 2, Length(str));
            Break;
          end;
        end;
      end;
    finally
      ss.Free;
      tt.Free;
    end;

    tb.Memo := Trim(str);
  end;

  function GetSpecCol(vIdx: Integer): Integer;
  var
    I, ti: Integer;
  begin
    Result := -1;
    if vIdx<=0 then
      Exit;      
    if vIdx>9 then
      Exit;
    for I:=0 to StringGridRes.ColCount - 1 do
    begin
      ti :=StringGridRes.Columns.Items[I].Tag;
      if ti>200 then
      begin
        ti := ti - 200;
      end
      else if ti>100 then
        ti := ti - 100;
      if ti=vIdx then
      begin
        Result := I;
        Exit;
      end;
    end;
  end;

  function GetSpecVal(vIdx, row: Integer): string;
  var
    ti: Integer;
  begin
    Result := '';
    ti := GetSpecCol(vIdx);
    if ti>=0 then
      Result := Trim(StringGridRes.Cells[ti, row]);
  end;
    
  function OnlyCommentVal(row: Integer): Boolean;
  var
    I, ti: Integer;
  begin
    Result := False;
    ti := GetSpecCol(9);
    if ti < 0 then
      Exit;
    if StringGridRes.Cells[ti, row] = '' then
      Exit;
    for I:=0 to StringGridRes.ColCount - 1 do
    if ti <> I then
    begin
      if Trim(StringGridRes.Cells[I, row])<>'' then
       Exit;
    end;
    Result := True;
  end;

  procedure SetDataSize(fd: TCtMetaField; str: string);
  var
    T: string;
    po: Integer;
  begin
    T := Trim(str);
    po := Pos(',', T);
    if po = 0 then
    begin
      if T = 'LONG' then
        fd.DataLength := DEF_TEXT_CLOB_LEN
      else
        fd.DataLength := StrToIntDef(T, 0);
      fd.DataScale := 0;
    end
    else
    begin
      fd.DataLength := StrToIntDef(Trim(Copy(T, 1, po - 1)), 0);
      fd.DataScale := StrToIntDef(Trim(Copy(T, po + 1, Length(T))), 0);
    end;
  end;
  procedure SetDataType(fd: TCtMetaField; str: string);
  var
    vTp, vSz: string;
    po: Integer;
  begin
    if (Pos('(', str) > 0) and (str[Length(str)] = ')') then
    begin   //类似String(255)的类型，包含了长度
      po := Pos('(', str);
      vTp := Trim(Copy(str, 1, po - 1));
      vSz := Trim(Copy(str, po + 1, Length(str) - po - 1));
    end
    else
    begin
      vTp:=str;
      vSz := '';
    end;

    if vTp='' then
      Exit;
    fd.DataType := GetCtFieldDataTypeOfName(vTp); 
    if fd.DataType = cfdtUnknow then
    begin
      fd.DataTypeName := vTp;
      fd.DataType := GetCtFieldDataTypeOfAlias(vTp);
    end
    else
      fd.DataTypeName := '';

    if vSz='' then
      Exit;
    SetDataSize(fd, vSz);
  end;
            
  procedure SetConstraints(AField: TCtMetaField; str: string);
  var
    sDtName, sIdxFds, sRelTb, sRelFd: string;
  begin
    sDtName := AField.DataTypeName;
    sIdxFds := AField.IndexFields;
    sRelTb := AField.RelateTable;
    sRelFd := AField.RelateField;
    AField.SetConstraintStr(str);
    AField.DataTypeName:=sDtName;
    AField.IndexFields:=sIdxFds;
    AField.RelateTable:=sRelTb;
    AField.RelateField:=sRelFd;
  end;

var
  x, y, i, c: Integer;
  S, T, V: string;  
  tb: TCtMetaTable;
  fd: TCtMetaField;
  bLastRowIsEmpty: Boolean;
  iStat: Integer;//0NewTb 1CapFound 2TbCommentFound 3ColCapFound 4FieldFound 5FieldCommentFound
begin
  y := 0;
  iStat := 0;
  bLastRowIsEmpty:=True;
  tb:=nil;
  fd := nil;
  while y<StringGridRes.RowCount-1 do
  begin
    Inc(y);
    if OnlyFirstColVal(y) and ((iStat=0) or (iStat>=3)) then //只有第一列有内容？
    begin
      if bLastRowIsEmpty then //上一行是空的，本行可能是新表
      begin
        iStat := 1;
      end
      else if IsFieldCapRow(y+1) then//下一行有列头，本行也可能是新表
      begin
        iStat := 1;
      end
      else if OnlyFirstColVal(y+1) and IsFieldCapRow(y+2) then//下一行只有第一列有内容（备注），且下二行有列头，本行也可能是新表
      begin
        iStat := 1;
      end;

      if iStat = 1 then
      begin
        tb:=tbs.NewTableItem();
        fd := nil;
        SetTbNameCap(tb,StringGridRes.Cells[0,y]);
        if OnlyFirstColVal(y+1) and IsFieldCapRow(y+2) then//下一行只有第一列有内容（备注），且下二行有列头，本行也可能是新表
        begin
          Inc(y);
          SetTbComment(tb,StringGridRes.Cells[0,y]); 
          iStat := 2;
        end;
        Continue;
      end;
    end;

    if IsFieldCapRow(y) then //列头？
    begin
      if tb <> nil then   //表头应该已经读入
        if iStat < 3 then
          iStat := 3;
      Continue;
    end;

    if tb=nil then
      Continue;

    //名称必须有值
    S := GetSpecVal(1, y);
    if S='' then
    begin
      if OnlyCommentVal(y) then
      begin
        S := GetSpecVal(9, y);
        fd.Memo:=fd.Memo+#13#10+S;
      end;
      Continue;
    end;
    fd := tb.MetaFields.NewMetaField;
    fd.Name := S;
    fd.DisplayName:=GetSpecVal(2, y);   
    fd.Memo:=GetSpecVal(9, y);

    S := GetSpecVal(3, y); //datatype
    if S <> '' then
      SetDataType(fd, S);
                     
    S := GetSpecVal(4, y); //datasize
    if S <> '' then
      SetDataSize(fd, S);

    S := GetSpecVal(10, y); //data Precision
    if S <> '' then
    begin
      i := StrToIntDef(S, -1);
      if i>=0 then
        fd.DataScale:=i;
    end;

    S := GetSpecVal(5, y); //nullable
    if S <> '' then
      fd.Nullable := CtStringToBool(S);
               
    S := GetSpecVal(6, y); //not nullable
    if S <> '' then
      fd.Nullable := not CtStringToBool(S);
                   
    S := GetSpecVal(7, y); //unique
    if S <> '' then
      if CtStringToBool(S) then
        fd.IndexType:= cfitUnique;

    S := GetSpecVal(8, y); //Constraints
    if S <> '' then
      SetConstraints(fd, S);
                    
    S := GetSpecVal(11, y); //default val
    if S <> '' then
    begin
      fd.DefaultValue:=S;
    end;

    if ckbSaveValuesInFieldParams.Checked then
    begin
      for I:=0 to StringGridRes.ColCount - 1 do
      begin
        S := StringGridRes.Cells[I, y];
        fd.Param['C'+IntToStr(I+1)] := S;
      end;
    end;
  end;
end;


end.

