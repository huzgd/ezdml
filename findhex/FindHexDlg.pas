unit FindHexDlg;

{$MODE Delphi}
interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, StdActns, ExtCtrls, ComCtrls;

type

  { TfrmFindHex }

  TfrmFindHex = class(TForm)
    ActionList1: TActionList;
    btnExecLRChg: TButton;
    btnFormatXml: TButton;
    ckbLRSpKeepLeftSpace: TCheckBox;
    edtKeepOnRight: TEdit;
    edtSplitter: TEdit;
    EditSelectAll1: TEditSelectAll;
    Label4: TLabel;
    lbSwitchLRSplitter: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lbSwitchLRSpKeepR: TLabel;
    MemoXml: TMemo;
    MemoLRChgCode: TMemo;
    MemoOtherEncode: TMemo;
    PageControl1: TPageControl;
    TabSheetCharCode: TTabSheet;
    TabSheetJson: TTabSheet;
    lbText: TLabel;
    lbNumber: TLabel;
    lbHex: TLabel;
    Label1: TLabel;
    edtText: TMemo;
    MemoNum: TMemo;
    MemoHex: TMemo;
    combNumDig: TComboBox;
    combCharset: TComboBox;
    btnULCase: TButton;
    MemoJson: TMemo;
    btnFormatJson: TButton;
    ckbEncode: TCheckBox;
    Label2: TLabel;
    btnOK: TButton;
    TabSheetMd5: TTabSheet;
    lbMd5TxtIn: TLabel;
    MemoMD5TxtIn: TMemo;
    lbMd5FileIn: TLabel;
    edtMd5FileIn: TEdit;
    btnMD5FileBrs: TButton;
    edtMD5Res: TEdit;
    Label3: TLabel;
    TabSheetLRChg: TTabSheet;
    TabSheetXML: TTabSheet;
    TabSheetOthes: TTabSheet;
    edtGUID: TEdit;
    btnGuid: TButton;
    edtRandStr: TEdit;
    lbRandStr: TLabel;
    ckbRandStrAZUpper: TCheckBox;
    ckbRandStrAZLower: TCheckBox;
    ckbRandStrDigits: TCheckBox;
    ckbRandStrSymbols: TCheckBox;
    TrackBarRandStrLen: TTrackBar;
    lbRandStrLenPrompt: TLabel;
    btnGenRandStr: TButton;
    lbRandStrLen: TLabel;
    OpenDialog1: TOpenDialog;
    edtMd5ResLower: TEdit;
    edtGuid2: TEdit;
    TabSetOtherEnc: TTabControl;
    procedure btnExecLRChgClick(Sender: TObject);
    procedure btnFormatXmlClick(Sender: TObject);
    procedure lbSwitchLRSpKeepRClick(Sender: TObject);
    procedure lbSwitchLRSplitterClick(Sender: TObject);
    procedure TabSetOtherEncChange(Sender: TObject);
    procedure btnULCaseClick(Sender: TObject);
    procedure MemoOtherEncodeChange(Sender: TObject);
    procedure btnFormatJsonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MemoHexChange(Sender: TObject);
    procedure ckbUnicodeClick(Sender: TObject);
    procedure edtTextChange(Sender: TObject);
    procedure MemoNumChange(Sender: TObject);
    procedure edtTextKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure TabSheetOthesShow(Sender: TObject);
    procedure btnGuidClick(Sender: TObject);
    procedure TrackBarRandStrLenChange(Sender: TObject);
    procedure btnGenRandStrClick(Sender: TObject);
    procedure MemoMD5TxtInChange(Sender: TObject);
    procedure edtMd5FileInChange(Sender: TObject);
    procedure btnMD5FileBrsClick(Sender: TObject);
  private
    { Private declarations }
    FUpdatingData: boolean;
    FLastEditor: TCustomEdit;
    FOtherEncType: integer;
    function GetFindTextStr: string;
    procedure SetFindTextStr(const Value: string);
    function DoOtherEncode(buf: string): string;
    function DoOtherDecode(buf: string): string;
  public
    { Public declarations }
    property FindTextStr: string read GetFindTextStr write SetFindTextStr;
  end;

implementation

{$R *.lfm}

uses
  uJson, WindowFuncs, MD5, Base64,
  Laz2_DOM, laz2_XMLRead, laz2_XMLWrite;

procedure TfrmFindHex.SetFindTextStr(const Value: string);
begin
  if Pos('[HEX]', Value) <> 1 then
    edtText.Text := Value
  else
    MemoHex.Lines.Text := Copy(Value, 6, Length(Value));
end;

procedure TfrmFindHex.TabSetOtherEncChange(Sender: TObject);
var
  S: string;
begin
  if FUpdatingData then
    Exit;
  FUpdatingData := True;
  try
    S := DoOtherDecode(MemoOtherEncode.Lines.Text);
    FOtherEncType := TabSetOtherEnc.TabIndex;
    MemoOtherEncode.Lines.Text := DoOtherEncode(S);
  finally
    FUpdatingData := False;
  end;
end;

procedure TfrmFindHex.btnExecLRChgClick(Sender: TObject);
  function GetNotSpacePos(str: String): Integer;
  var
    I,L: Integer;
  begin
    L:=Length(str);
    Result:=0;
    for I:=1 to L do
      if (str[I]=' ') or (str[I]=#9) or (str[I]=#10) or (str[I]=#13) then
        Continue
      else
      begin
        Result := I;
        Exit;
      end;
    Result := L;
  end;
var
  I, J, po1, po2: Integer;
  S, sKL, sL, sR, sKR, sp, kr: String;
begin
  sp := edtSplitter.Text;
  kr := edtKeepOnRight.Text;
  with MemoLRChgCode.Lines do
  for I:=0 to Count - 1 do
  begin
    S := Strings[I];
                             
    sKL := '';
    if ckbLRSpKeepLeftSpace.Checked then
    begin
      po1 := GetNotSpacePos(S);
      if po1>0 then
      begin
        sKL:= Copy(S, 1, po1-1);
        S:=Copy(S, po1, Length(S));
      end;
    end;


    po1 := Pos(sp, S);
    if po1=0 then
      Continue;
    sL := Copy(S, 1, po1-1);
    sR := Copy(S, po1+Length(sp),Length(S));

    po2 := Pos(kr, sR);
    if po2>0 then
    begin
      sKR := Copy(sR, po2, Length(sr));
      sR := Copy(sR, 1, po2-1);
    end else
    begin
      sKR := '';
    end;

    S:=sKL+sR+sp+sL+sKR;
    Strings[I] := S;
  end;
end;

procedure TfrmFindHex.btnFormatXmlClick(Sender: TObject);
var
  ms: TMemoryStream;
  S: String;
  vXmlDoc: TXMLDocument;
begin
  S := MemoXml.Lines.Text;
  if Trim(S)='' then
    Exit;
  vXmlDoc:=nil;
  ms:= TMemoryStream.Create;
  try
    ms.WriteBuffer(PChar(S)^, Length(S)); 
    ms.Position := 0;    
    ReadXmlFile(vXmlDoc, ms);

    ms.Clear;
    WriteXmlFile(vXmlDoc, ms); 
    ms.Position := 0;    
    MemoXml.Lines.LoadFromStream(ms);
  finally
    ms.Free;
    if vXmlDoc<>nil then
      vXmlDoc.Free;
  end;
end;

procedure TfrmFindHex.lbSwitchLRSpKeepRClick(Sender: TObject);
var
  S: String;
begin
  S:=lbSwitchLRSpKeepR.Caption;
  if S=';' then
  begin
    edtKeepOnRight.Text := S;
    S:='--';
  end   
  else if S='--' then
  begin
    edtKeepOnRight.Text := S;
    S:='//';
  end
  else if S='//' then
  begin
    edtKeepOnRight.Text := S;
    S:='#';
  end        
  else if S='#' then
  begin
    edtKeepOnRight.Text := S;
    S:=';';
  end
  else
    S := ';';
  lbSwitchLRSpKeepR.Caption:=S;
end;

procedure TfrmFindHex.lbSwitchLRSplitterClick(Sender: TObject);
var
  S: String;
begin
  S:=lbSwitchLRSplitter.Caption;
  if S=':=' then
  begin
    edtSplitter.Text := S;
    S:='=';
  end
  else if S='=' then
  begin
    edtSplitter.Text := S;
    S:=':=';
  end
  else
    S := '=';
  lbSwitchLRSplitter.Caption:=S;
end;

procedure TfrmFindHex.TabSheetOthesShow(Sender: TObject);
begin
  if edtGUID.Text = '' then
    btnGuidClick(nil);
  if edtRandStr.Text = '' then
    TrackBarRandStrLenChange(nil);
end;

procedure TfrmFindHex.TrackBarRandStrLenChange(Sender: TObject);
var
  I, sz: integer;
begin
  sz := 2;
  for I := 1 to TrackBarRandStrLen.Position do
    sz := sz * 2;
  lbRandStrLen.Caption := IntToStr(sz);
  btnGenRandStrClick(nil);
end;

function TfrmFindHex.GetFindTextStr: string;
begin
  if (combCharset.ItemIndex = 2) and (FLastEditor = edtText) then
    Result := edtText.Text
  else
    Result := '[HEX]' + MemoHex.Lines.Text;
end;

procedure TfrmFindHex.btnFormatJsonClick(Sender: TObject);
var
  S: string;
  jo: TJSONObject;
  ja: TJSONArray;
  bSU: boolean;
begin
  S := Trim(MemoJson.Lines.Text);
  if S = '' then
    Exit;
  bSU := stringsAsUtf8Encode;
  stringsAsUtf8Encode := not ckbEncode.Checked;
  try
    if Copy(S, 1, 1) = '[' then
    begin
      ja := TJSONArray.Create(S);
      try
        MemoJson.Lines.Text := ja.toString(2);
      finally
        ja.Free;
      end;
    end
    else
    begin
      jo := TJSONObject.Create(S);
      try
        MemoJson.Lines.Text := jo.toString(2);
      finally
        jo.Free;
      end;
    end;
  finally
    stringsAsUtf8Encode := bSU;
  end;
end;

procedure TfrmFindHex.btnGenRandStrClick(Sender: TObject);
var
  I, sz, n: integer;
  src, res: string;
begin
  sz := StrToIntDef(lbRandStrLen.Caption, 8);
  src := '';
  if ckbRandStrAZUpper.Checked then
  begin
    for I := Ord('A') to Ord('Z') do
      src := src + char(I);
  end;

  if ckbRandStrAZLower.Checked then
  begin
    for I := Ord('a') to Ord('z') do
      src := src + char(I);
  end;

  if ckbRandStrDigits.Checked then
  begin
    for I := Ord('0') to Ord('9') do
      src := src + char(I);
  end;

  if ckbRandStrSymbols.Checked then
  begin
    for I := Ord('!') to Ord('/') do
      src := src + char(I);
    for I := Ord(':') to Ord('@') do
      src := src + char(I);
    for I := Ord('[') to Ord('`') do
      src := src + char(I);
    for I := Ord('{') to Ord('~') do
      src := src + char(I);
  end;

  if src = '' then
    Exit;

  res := '';
  Randomize;
  for I := 0 to sz - 1 do
  begin
    n := Random(Length(src));
    res := res + src[n + 1];
  end;
  edtRandStr.Text := res;
end;

procedure TfrmFindHex.btnGuidClick(Sender: TObject);

  function GetGUID: string;
  var
    LTep: TGUID;
  begin
    CreateGUID(LTep);
    Result := GUIDToString(LTep);
  end;

var
  S: string;
begin
  S := GetGUID;
  edtGUID.Text := S;

  S := LowerCase(S);
  S := Copy(S, 2, Length(S) - 2);
  S := StringReplace(S, '-', '', [rfReplaceAll]);
  edtGuid2.Text := S;
end;

procedure TfrmFindHex.btnMD5FileBrsClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edtMd5FileIn.Text := OpenDialog1.FileName;
end;

procedure TfrmFindHex.btnULCaseClick(Sender: TObject);
begin
  if btnULCase.Tag = 0 then
  begin
    btnULCase.Tag := 1;
    edtText.Text := UpperCase(edtText.Text);
  end
  else
  begin
    btnULCase.Tag := 0;
    edtText.Text := LowerCase(edtText.Text);
  end;
end;

procedure TfrmFindHex.ckbUnicodeClick(Sender: TObject);
begin
  if FLastEditor = edtText then
    edtTextChange(nil)
  else if FLastEditor = MemoNum then
    MemoNumChange(nil)
  else if FLastEditor = MemoHex then
    MemoHexChange(nil)
  else if FLastEditor = MemoOtherEncode then
    MemoOtherEncodeChange(nil);
end;

function TfrmFindHex.DoOtherDecode(buf: string): string;
begin
  Result := buf;
  if buf = '' then
    Exit;
  if FOtherEncType = 0 then
    Result := URLDecode(buf)
  else if FOtherEncType = 1 then
    Result := DecodeStringBase64(buf);
end;

function TfrmFindHex.DoOtherEncode(buf: string): string;
begin
  Result := buf;
  if FOtherEncType = 0 then
    Result := URLEncode(buf)
  else if FOtherEncType = 1 then
    Result := EncodeStringBase64(buf);
end;

procedure TfrmFindHex.edtMd5FileInChange(Sender: TObject);
var
  S: string;
begin
  S := edtMd5FileIn.Text;
  if S = '' then
    Exit;
  if not FileExists(S) then
    Exit;
  edtMD5Res.Text := UpperCase(MD5Print(MD5File(S)));
  edtMd5ResLower.Text := LowerCase(edtMd5Res.Text);
end;

procedure TfrmFindHex.edtTextChange(Sender: TObject);
var
  S, R, V, T, SNum, SHex: string;
  WS: WideString;
  Buf: string;
  I: integer;

  L, iType, iB, iU: integer;
begin
  if FUpdatingData then
    Exit;
  FUpdatingData := True;
  try
    S := edtText.Text;
    FLastEditor := edtText;

    if combCharset.ItemIndex = 1 then
    begin
      WS := S;
      SetLength(Buf, Length(WS) * 2);
      Move(Pointer(WS)^, Pointer(Buf)^, Length(WS) * 2);
    end
    else if combCharset.ItemIndex = 0 then
    begin
      buf := CtUTF8Decode(S);
    end
    else
    begin
      Buf := S;
    end;

    MemoOtherEncode.Lines.Text := DoOtherEncode(Buf);

    iType := combNumDig.ItemIndex;
    case iType of
      0:
        iB := 1;
      1:
        iB := 2;
      2:
        iB := 4;
      3:
        iB := 4;
      4:
        iB := 8;
      5:
        iB := 8;
      else
        iB := 1;
    end;
    R := Buf;
    L := Length(R);
    I := 1;
    while I <= L do
    begin
      V := '';
      for iU := 1 to iB do
      begin
        if I <= L then
          V := V + R[I];
        Inc(I);
      end;

      case iType of
        0:
          T := Format('%0.3d', [byte(Pointer(V)^)]);
        1:
          T := Format('%0.5d', [word(Pointer(V)^)]);
        2:
          T := IntToStr(integer(Pointer(V)^));
        3:
          T := FloatToStr(single(Pointer(V)^));
        4:
          T := IntToStr(int64(Pointer(V)^));
        5:
          T := FloatToStr(double(Pointer(V)^));
        else
          T := IntToStr(byte(Pointer(V)^));
      end;
      SNum := SNum + T + ' ';
    end;
    MemoNum.Lines.Text := Trim(SNum);

    SHex := '';
    for I := 1 to Length(Buf) do
      SHex := SHex + IntToHex(byte(Buf[I]), 2) + ' ';
    MemoHex.Lines.Text := Trim(SHex);
  finally
    FUpdatingData := False;
  end;
end;

procedure TfrmFindHex.edtTextKeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TfrmFindHex.FormShow(Sender: TObject);
begin
  try
    PageControl1.ActivePageIndex := 0;
    edtText.SelectAll;
    edtText.SetFocus;
  except
  end;
end;

procedure TfrmFindHex.MemoNumChange(Sender: TObject);

  function GetHexStrByte(const Buf; sz: integer): string;
  var
    I: integer;
  begin
    Result := '';
    for I := 0 to sz - 1 do
      Result := Result + IntToHex(PByte(integer(@Buf) + I)^, 2) + ' ';
    Result := Trim(Result);
  end;

  function GetTxtStrByte(const Buf; sz: integer; var SR: string): string;
  var
    I: integer;
    b: byte;
  begin
    Result := '';
    for I := 0 to sz - 1 do
    begin
      b := PByte(integer(@Buf) + I)^;
      if (b >= 32) and (b <= 254) then
        SR := SR + char(b)
      else
        SR := SR + '?';
      Result := Result + char(b);
    end;
  end;

var
  S, R, T, V: string;
  WS: WideString;
  STxt, SHex: string;
  po, iType, L: integer;
  iUni: integer;

  pv1: byte;
  pv2: word;
  pv3: integer;
  pv4: single;
  pv5: int64;
  pv6: double;
begin
  if FUpdatingData then
    Exit;
  FUpdatingData := True;
  try
    FLastEditor := MemoNum;

    S := Trim(MemoNum.Lines.Text);
    S := StringReplace(S, ',', ' ', [rfReplaceAll]);
    S := StringReplace(S, #9, ' ', [rfReplaceAll]);
    S := StringReplace(S, #10, ' ', [rfReplaceAll]);
    S := StringReplace(S, #13, ' ', [rfReplaceAll]);
    STxt := '';
    SHex := '';
    R := '';
    iUni := combCharset.ItemIndex;
    iType := combNumDig.ItemIndex;

    while S <> '' do
    begin
      S := Trim(S);
      po := Pos(' ', S);
      if po > 0 then
      begin
        T := Copy(S, 1, po - 1);
        S := Trim(Copy(S, po + 1, Length(S)));
      end
      else
      begin
        T := S;
        S := '';
      end;
      pv3 := StrToIntDef(T, 0);
      if (pv3 >= 0) and (pv3 <= High(byte)) then
        pv1 := pv3
      else
        pv1 := byte(pv3 and $FF);
      if (pv3 >= 0) and (pv3 <= High(word)) then
        pv2 := pv3
      else
        pv2 := word(pv3 and $FF);
      pv4 := StrToFloatDef(T, 0);
      pv5 := StrToInt64Def(T, 0);
      pv6 := StrToFloatDef(T, 0);

      case iType of
        0:
          V := GetHexStrByte(pv1, 1);
        1:
          V := GetHexStrByte(pv2, 2);
        2:
          V := GetHexStrByte(pv3, 4);
        3:
          V := GetHexStrByte(pv4, 4);
        4:
          V := GetHexStrByte(pv5, 8);
        5:
          V := GetHexStrByte(pv6, 8);
        else
          V := GetHexStrByte(pv1, 1);
      end;
      SHex := SHex + V + ' ';

      case iType of
        0:
          V := GetTxtStrByte(pv1, 1, STxt);
        1:
          V := GetTxtStrByte(pv2, 2, STxt);
        2:
          V := GetTxtStrByte(pv3, 4, STxt);
        3:
          V := GetTxtStrByte(pv4, 4, STxt);
        4:
          V := GetTxtStrByte(pv5, 8, STxt);
        5:
          V := GetTxtStrByte(pv6, 8, STxt);
        else
          V := GetTxtStrByte(pv1, 1, STxt);
      end;
      R := R + V;
    end;


    MemoOtherEncode.Lines.Text := DoOtherEncode(R);

    if iUni = 1 then
    begin
      L := Length(R);
      if (L mod 2) <> 0 then
        L := L - 1;
      if L < 0 then
        L := 0;
      SetLength(WS, L div 2);
      Move(Pointer(R)^, Pointer(WS)^, L);
      STxt := WS;
    end
    else if iUni = 0 then
    begin
      //STxt := Utf8Encode(R);
    end;


    {if bUni then
    begin
      WS := ' ';
      Word(Pointer(WS)^) := pv2;
      STxt := STxt + WS;
    end
    else
    begin
      if (pv2 >= 32) and (pv2 <= 254) then
        STxt := STxt + Char(pv1)
      else
        STxt := STxt + '?';
    end;   }

    edtText.Text := STxt;
    MemoHex.Lines.Text := Trim(sHex);
  finally
    FUpdatingData := False;
  end;
end;

procedure TfrmFindHex.MemoOtherEncodeChange(Sender: TObject);
var
  S, R, V, T, SNum, SHex: string;
  WS: WideString;
  Buf: string;
  I: integer;

  L, iType, iB, iU: integer;
begin
  if FUpdatingData then
    Exit;
  FUpdatingData := True;
  try
    S := DoOtherDecode(MemoOtherEncode.Lines.Text);
    FLastEditor := MemoOtherEncode;

    Buf := S;

    iType := combNumDig.ItemIndex;
    case iType of
      0:
        iB := 1;
      1:
        iB := 2;
      2:
        iB := 4;
      3:
        iB := 4;
      4:
        iB := 8;
      5:
        iB := 8;
      else
        iB := 1;
    end;
    R := Buf;
    L := Length(R);
    I := 1;
    while I <= L do
    begin
      V := '';
      for iU := 1 to iB do
      begin
        if I <= L then
          V := V + R[I];
        Inc(I);
      end;

      case iType of
        0:
          T := Format('%0.3d', [byte(Pointer(V)^)]);
        1:
          T := Format('%0.5d', [word(Pointer(V)^)]);
        2:
          T := IntToStr(integer(Pointer(V)^));
        3:
          T := FloatToStr(single(Pointer(V)^));
        4:
          T := IntToStr(int64(Pointer(V)^));
        5:
          T := FloatToStr(double(Pointer(V)^));
        else
          T := IntToStr(byte(Pointer(V)^));
      end;
      SNum := SNum + T + ' ';
    end;
    MemoNum.Lines.Text := Trim(sNum);

    SHex := '';
    for I := 1 to Length(Buf) do
      SHex := SHex + IntToHex(byte(Buf[I]), 2) + ' ';
    MemoHex.Lines.Text := Trim(SHex);

    if combCharset.ItemIndex = 1 then
    begin
      WS := S;
      SetLength(Buf, Length(WS) * 2);
      Move(Pointer(WS)^, Pointer(Buf)^, Length(WS) * 2);
    end
    else if combCharset.ItemIndex = 0 then
    begin
      buf := CtUTF8Encode(S);
    end
    else
    begin
      Buf := S;
    end;
    edtText.Text := buf;

  finally
    FUpdatingData := False;
  end;
end;

procedure TfrmFindHex.MemoHexChange(Sender: TObject);
var
  S, R, T, V: string;
  WS: WideString;
  STxt, SNum: string;
  po, L, iType, iB, iU, I: integer;
  iUni: integer;

  pv1: byte;
  pv3: integer;
begin
  if FUpdatingData then
    Exit;
  FUpdatingData := True;
  try
    FLastEditor := MemoHex;

    S := Trim(MemoHex.Lines.Text);
    S := StringReplace(S, ',', ' ', [rfReplaceAll]);
    S := StringReplace(S, #9, ' ', [rfReplaceAll]);
    S := StringReplace(S, #10, ' ', [rfReplaceAll]);
    S := StringReplace(S, #13, ' ', [rfReplaceAll]);
    STxt := '';
    SNum := '';
    iUni := combCharset.ItemIndex;
    iType := combNumDig.ItemIndex;

    R := '';
    while S <> '' do
    begin
      S := Trim(S);
      po := Pos(' ', S);
      if ((po = 0) or (po > 3)) and (Length(S) > 2) then
      begin
        T := Trim(Copy(S, 1, 2));
        S := Trim(Copy(S, 3, Length(S)));
      end
      else if po > 0 then
      begin
        T := Trim(Copy(S, 1, po - 1));
        S := Trim(Copy(S, po + 1, Length(S)));
      end
      else
      begin
        T := S;
        S := '';
      end;
      pv3 := StrToIntDef('$' + T, 0);
      if (pv3 >= 0) and (pv3 <= High(byte)) then
        pv1 := pv3
      else
        pv1 := 0;
      R := R + char(pv1);
      if (pv3 >= 32) and (pv3 <= 254) then
        STxt := STxt + char(pv1)
      else
        STxt := STxt + '?';
    end;

    MemoOtherEncode.Lines.Text := DoOtherEncode(R);

    if iUni = 1 then
    begin
      L := Length(R);
      if (L mod 2) <> 0 then
        L := L - 1;
      if L < 0 then
        L := 0;
      SetLength(WS, L div 2);
      Move(Pointer(R)^, Pointer(WS)^, L);
      STxt := WS;
    end
    else if iUni = 0 then
    begin
      STxt := CtUTF8Encode(R);
    end;


    {if bUni then
      iType := 1;}
    case iType of
      0:
        iB := 1;
      1:
        iB := 2;
      2:
        iB := 4;
      3:
        iB := 4;
      4:
        iB := 8;
      5:
        iB := 8;
      else
        iB := 1;
    end;
    L := Length(R);
    I := 1;
    while I <= L do
    begin
      V := '';
      for iU := 1 to iB do
      begin
        if I <= L then
          V := V + R[I];
        Inc(I);
      end;

      case iType of
        0:
          T := Format('%0.3d', [byte(Pointer(V)^)]);
        1:
          T := Format('%0.5d', [word(Pointer(V)^)]);
        2:
          T := IntToStr(integer(Pointer(V)^));
        3:
          T := FloatToStr(single(Pointer(V)^));
        4:
          T := IntToStr(int64(Pointer(V)^));
        5:
          T := FloatToStr(double(Pointer(V)^));
        else
          T := IntToStr(byte(Pointer(V)^));
      end;
      SNum := SNum + T + ' ';
    end;

    edtText.Text := STxt;
    MemoNum.Lines.Text := Trim(sNum);
  finally
    FUpdatingData := False;
  end;

end;

procedure TfrmFindHex.MemoMD5TxtInChange(Sender: TObject);
var
  S: string;
begin
  S := MemoMD5TxtIn.Lines.Text;
  if S = '' then
    Exit;

  edtMD5Res.Text := UpperCase(MD5Print(MD5String(S)));
  edtMd5ResLower.Text := LowerCase(edtMd5Res.Text);
end;

end.
