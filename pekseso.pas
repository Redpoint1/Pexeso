unit pekseso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, GameUnit, PlochaUnit;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Casovac;
    procedure TrackBar2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Pexeso: THra;
  Plocha: TPlocha;
  Obr: TBitmap;
  Povolenie, HrajeSa, Zvacsuje: boolean;
  Cas, nasobic: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Povolenie := False;
  HrajeSa := False;
  with Image1.Canvas do
  begin
    FillRect(Image1.clientRect);
    Font.Style := [fsBold];
    TextOut(Image1.Width - 100, Image1.Height - 15, 'Richard Rožár');
  end;
  Info[1] := 120;
  Nastavenie[1] := IntToStr(Trackbar1.Position * 100);
  Nastavenie[2] := Edit4.Text;
  Nastavenie[3] := BoolToStr(CheckBox1.Checked);
  Nastavenie[4] := Edit5.Text;
  Nastavenie[5] := IntToStr(Trackbar2.Position);
  NaRade := 1;
  Memo3.Lines.Clear;
  Timer3.Enabled := True;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if povolenie and (Shift = [ssLeft]) then
  begin
    x := (x - 5) div 80;
    y := (y - 5) div 100;
    if (X < 10) and (Y < 5) then
    begin
      if not (Karta[y][x].Najdene) then
      begin
        if Karta[y][x].Zobrazene = False then
        begin
          pocet := pocet + 1;
          Pexeso.Ukaz(Karta[y][x].Typ, X, Y, Image1.Canvas);
        end;
        if pocet = 1 then
        begin
          pom := Karta[y][x].Typ;
          Karta[y][x].Zobrazene := True;
        end;
        if (pocet = 2) and (Karta[y][x].Zobrazene = False) then
        begin
          povolenie := False;
          pom1 := Karta[y][x].Typ;
          Karta[y][x].Zobrazene := True;
          Timer1.Enabled := True;
        end;
      end;
    end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  k: integer;
begin
  Timer1.Enabled := False;
  if (Pexeso.Parny(pom, pom1)) and (Info[1] > 0) then
  begin
    Pexeso.Odber(pom, Image1.Canvas);
    pocet := 0;
    Info[2] := Info[2] + 1;
    Info[3] := Info[3] + 2;
    povolenie := True;
    Edit1.Text := IntToStr(Info[2]);
    if StrToInt(Nastavenie[5]) > 1 then
    begin
      Inc(Player[NaRade]);
      Memo3.Lines.Clear;
      for k := 1 to StrToInt(Nastavenie[5]) do
        Memo3.Lines.Append('Hráč ' + IntToStr(k) + ': ' + IntToStr(Player[k]));
    end;
    if Info[3] = 50 then
    begin
      Timer2.Enabled := False;
      Button4.Enabled := False;
      if StrToInt(Nastavenie[5]) = 1 then
      begin
        ShowMessage('Vyhrali ste, SKORE: ' + IntToStr(Info[2]));
        Pexeso.Skore;
      end
      else
        ShowMessage('Koniec hry.');
    end;
  end
  else
  begin
    Pexeso.Naspat(Image1.Canvas);
    if NaRade = StrToInt(Nastavenie[5]) then
      NaRade := 1
    else
      Inc(NaRade);
    Label1.Caption := 'Hráč' + IntToStr(NaRade);
    Memo3.Lines.Clear;
    for k := 1 to StrToInt(Nastavenie[5]) do
      Memo3.Lines.Append('Hráč' + IntToStr(k) + ': ' + IntToStr(Player[k]));
    pocet := 0;
    Info[2] := Info[2] + 1;
    Edit1.Text := IntToStr(Info[2]);
    if Info[2] > 0 then
      povolenie := True;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Info[1] := Info[1] - 1;
  Edit3.Text := IntToStr(Info[1]);
  if Info[1] = 0 then
  begin
    Button2.Enabled := False;
    Button4.Enabled := False;
    Povolenie := False;
    Timer2.Enabled := False;
    ShowMessage('Nestihli ste!');
  end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var
  x2, x4, y2, y4: real;
  x3, x5, y3, y5: integer;
begin
  if zvacsuje then
    Inc(nasobic)
  else
    Dec(Nasobic);
  Obr := TBitmap.Create;
  Obr.LoadFromFile('img/logo.bmp');
  x2 := (Image1.Width div 2) - Obr.Width div 2 +
    ((Image1.Width / Image1.Height) * nasobic);
  y2 := (Image1.Height div 2) - Obr.Height div 2 +
    ((Image1.Height / Image1.Width) * nasobic);
  x4 := (Image1.Width div 2) + Obr.Width div 2 -
    ((Image1.Width / Image1.Height) * nasobic);
  y4 := (Image1.Height div 2) + Obr.Height div 2 -
    ((Image1.Height / Image1.Width) * nasobic);
  x3 := Round(x2);
  y3 := Round(y2);
  x5 := Round(x4);
  y5 := Round(y4);
  Image1.Canvas.StretchDraw(Rect(x3, y3, x5, y5), Obr);
  Obr.Free;
  if nasobic >= 25 then
    zvacsuje := False
  else if nasobic <= 0 then
    zvacsuje := True;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Timer1.Interval := Trackbar1.Position * 100;
  Edit2.Text := IntToStr(Trackbar1.Position * 100);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  k: integer;
begin
  Timer3.Enabled := False;
  Povolenie := True;
  HrajeSa := True;
  Edit1.Visible := True;
  Edit3.Visible := True;
  Button2.Enabled := True;
  Button4.Visible := True;
  Button4.Enabled := True;
  if StrToInt(Nastavenie[5]) > 1 then
  begin
    Label1.Visible := True;
    Memo3.Visible := True;
    Memo3.Lines.Clear;
    for k := 1 to StrToInt(Nastavenie[5]) do
      Memo3.Lines.Append('Hráč' + IntToStr(k) + ': ' + IntToStr(Player[k]));
  end;
  StaticText1.Visible := True;
  StaticText2.Visible := True;
  Memo1.Visible := False;
  Memo2.Visible := False;
  Image1.Canvas.FillRect(Image1.clientRect);
  Plocha.Nakresli(Image1.Canvas);
  Pexeso.Zamiesaj;
  Info[1] := StrToInt(Edit4.Text);
  Info[2] := 0;
  Info[3] := 0;
  Edit1.Text := IntToStr(Info[2]);
  Edit3.Text := IntToStr(Info[1]);
  Casovac;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Timer3.Enabled := False;
  Image1.Canvas.FillRect(Image1.ClientRect);
  Povolenie := False;
  Edit1.Visible := False;
  Edit2.Visible := True;
  Edit2.Text := IntToStr(Timer1.Interval);
  Edit3.Visible := False;
  Edit4.Visible := True;
  Edit5.Visible := True;
  Edit6.Visible := True;
  Edit6.Text := Nastavenie[5];
  Label1.Visible := False;
  StaticText1.Visible := False;
  StaticText2.Visible := False;
  StaticText3.Visible := True;
  StaticText4.Visible := True;
  StaticText5.Visible := True;
  StaticText6.Visible := True;
  StaticText7.Visible := True;
  Memo1.Visible := False;
  Memo2.Visible := False;
  Memo3.Visible := False;
  TrackBar1.Visible := True;
  TrackBar2.Visible := True;
  TrackBar1.Position := Timer1.Interval div 100;
  CheckBox1.Visible := True;
  Button1.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;
  Button8.Enabled := False;
  Button5.Visible := True;
  Button6.Visible := True;
  Button7.Visible := True;
  Timer2.Enabled := False;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if StrToInt(Nastavenie[5]) < 2 then
  begin
    if FileExists('save.txt') then
    begin
      Timer3.Enabled := False;
      Povolenie := True;
      HrajeSa := True;
      Edit1.Visible := True;
      Edit3.Visible := True;
      StaticText1.Visible := True;
      StaticText2.Visible := True;
      Button2.Enabled := True;
      Button4.Visible := True;
      Button4.Enabled := True;
      Memo1.Visible := False;
      Memo2.Visible := False;
      Casovac;
      Plocha.Nakresli(Image1.Canvas);
      Pexeso.Nahraj;
      Pexeso.VymazNacitane(Image1.Canvas);
      Edit1.Text := IntToStr(Info[2]);
      Edit3.Text := IntToStr(Info[1]);
    end
    else
      ShowMessage('Nenašla sa uložená požícia!');
  end
  else
    ShowMessage('V režime viacerých hráčov sa nedá nahrávať!');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if StrToInt(Nastavenie[5]) < 2 then
  begin
    Timer3.Enabled := False;
    Pexeso.Uloz;
  end
  else
    ShowMessage('V režime viacerých hráčov sa nedá uložiť!');
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  k: integer;
begin
  Image1.Canvas.FillRect(Image1.ClientRect);
  Edit2.Visible := False;
  Edit4.Visible := False;
  Edit5.Visible := False;
  Edit6.Visible := False;
  StaticText3.Visible := False;
  StaticText4.Visible := False;
  StaticText5.Visible := False;
  StaticText6.Visible := False;
  StaticText7.Visible := False;
  TrackBar1.Visible := False;
  TrackBar2.Visible := False;
  CheckBox1.Visible := False;
  Button1.Enabled := True;
  Button3.Enabled := True;
  Button8.Enabled := True;
  Button5.Visible := False;
  Button6.Visible := False;
  Button7.Visible := False;
  Memo1.Visible := False;
  Memo2.Visible := False;

  Info[1] := StrToInt(Edit4.Text);
  Edit1.Text := IntToStr(Info[2]);
  Edit3.Text := IntToStr(Info[1]);
  if HrajeSa then
  begin
    Povolenie := True;
    Edit1.Visible := True;
    Edit3.Visible := True;
    if StrToInt(Nastavenie[5]) > 1 then
    begin
      Label1.Visible := True;
      Memo3.Visible := True;
      Memo3.Lines.Clear;
      for k := 1 to StrToInt(Nastavenie[5]) do
        Memo3.Lines.Append('Hráč' + IntToStr(k) + ': ' + IntToStr(Player[k]));
    end;
    StaticText1.Visible := True;
    StaticText2.Visible := True;
    Button4.Enabled := True;
    Plocha.Nakresli(Image1.Canvas);
    Pexeso.VymazNacitane(Image1.Canvas);
    Casovac;
  end
  else
  begin
    povolenie := False;
    Image1.Canvas.FillRect(Image1.clientRect);
    Timer3.Enabled := True;
    Font.Style := [fsBold];
    Image1.Canvas.TextOut(Image1.Width - 100, Image1.Height - 15, 'Richard Rožár');
    Font.Style := [];
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  Subor: TextFile;
  i: integer;
  Nastavenia: string;
begin
  if FileExists('nastavenie.txt') then
  begin
    AssignFile(Subor, 'nastavenie.txt');
    Reset(Subor);
    for i := 1 to 5 do
    begin
      readln(Subor, Nastavenia);
      Nastavenie[i] := Nastavenia;
    end;
    CloseFile(Subor);
    TrackBar1.Position := StrToInt(Nastavenie[1]) div 100;
    Edit2.Text := Nastavenie[1];
    Edit4.Text := Nastavenie[2];
    Edit4.Enabled := StrToBool(Nastavenie[3]);
    CheckBox1.Checked := StrToBool(Nastavenie[3]);
    if Nastavenie[4] = '' then
      Nastavenie[4] := 'Hráč';
    Edit5.Text := Nastavenie[4];
    Trackbar2.Position := StrToInt(Nastavenie[5]);
    Edit6.Text := Nastavenie[5];
  end
  else
    ShowMessage('Neboli nájdené uložené nastavenia!');
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  Subor: TextFile;
  i: integer;
begin
  Nastavenie[1] := IntToStr(Trackbar1.Position * 100);
  Nastavenie[2] := Edit4.Text;
  Nastavenie[3] := BoolToStr(CheckBox1.Checked);
  Nastavenie[4] := Edit5.Text;
  Nastavenie[5] := IntToStr(Trackbar2.Position);
  AssignFile(Subor, 'nastavenie.txt');
  Rewrite(Subor);
  for i := 1 to 5 do
    writeln(Subor, Nastavenie[i]);
  ShowMessage('Nastavenie uložené!');
  CloseFile(Subor);
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  i: integer;
begin
  if FileExists('skore.txt') then
  begin
    Timer3.Enabled := False;
    Povolenie := False;
    StaticText1.Visible := False;
    StaticText2.Visible := False;
    Button2.Enabled := True;
    Button4.Enabled := False;
    Button5.Visible := True;
    Edit1.Visible := False;
    Edit3.Visible := False;
    Timer2.Enabled := False;
    Memo1.Visible := True;
    Memo2.Visible := True;
    Memo3.Visible := False;
    Image1.Canvas.FillRect(Image1.ClientRect);
    Pexeso.NahrajSkore;
    Memo1.Lines.Clear;
    Memo2.Lines.Clear;
    Memo1.Lines.Append('Meno:');
    Memo1.Lines.Append('');
    Memo2.Lines.Append('Skore:');
    Memo2.Lines.Append('');
    for i := 1 to 10 do
    begin
      Memo1.Lines.Append(Final[i].Meno);
      Memo2.Lines.Append(IntToStr(Final[i].Body));
    end;
  end
  else
    ShowMessage('Žiadne skore sa nenašlo.');
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.Checked then
    Edit4.Enabled := True
  else
    Edit4.Enabled := False;
end;

procedure TForm1.Casovac;
begin
  if CheckBox1.Checked then
  begin
    Edit3.Enabled := True;
    Timer2.Enabled := True;
  end
  else
  begin
    Edit3.Enabled := False;
    Timer2.Enabled := False;
  end;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  Nastavenie[5] := IntToStr(Trackbar2.Position);
  Edit6.Text := Nastavenie[5];
  HrajeSa := False;
  if Trackbar2.Position = 1 then
    Edit5.Enabled := True
  else
    Edit5.Enabled := False;
end;

end.

