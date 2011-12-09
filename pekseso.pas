unit pekseso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, GameUnit;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image1: TImage;
    Memo1: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Timer1: TTimer;
    Timer2: TTimer;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Casovac;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Pexeso: TPlocha;
  Obr, Obr1: TBitmap;
  Povolenie : boolean;
  Cas: Integer;
  Nastavenie: array[1..3] of integer;

implementation


Uses
  SettingUnit;
{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  povolenie:= False;
  Obr := TBitmap.Create;
  with Image1.Canvas do
  begin
   FillRect(Image1.clientRect);
   Obr.LoadFromFile('img/logo.bmp');
   Draw(200, 150, Obr);
   Font.Style := [fsBold];
   TextOut(Image1.Width-100, Image1.Height-15, 'Richard Rozar');
   Obr.Free;
  end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if povolenie then
    begin
    x := (x - 5) div 80;
    y := (y - 5) div 100;
    if (X < 6) and (Y < 4) then
    begin
      if not(Karta[y][x].Najdene) then
      begin
       if Karta[y][x].Zobrazene = false then
       begin
        pocet := pocet + 1;
        Pexeso.Ukaz(Karta[y][x].Typ,X,Y,Image1.Canvas);
       end;
       if pocet=1 then
       begin
        pom := Karta[y][x].Typ;
        Karta[y][x].Zobrazene := True;
       end;
       if (pocet = 2) and (Karta[y][x].Zobrazene = false)then
       begin
        povolenie:= False;
        pom1 := Karta[y][x].Typ;
        Karta[y][x].Zobrazene := True;
        Timer1.Enabled := True;
       end;
      end;
    end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if Pexeso.Parny(pom, pom1) then
   begin
    Pexeso.Odber(pom, Image1.Canvas);
    pocet:= 0;
    Nastavenie[3] := Nastavenie[3]+2;
    if Nastavenie[3] = 24 then
     begin
      Timer2.Enabled:=False;
      Button4.Enabled:=False;
      ShowMessage('Vyhrali ste, SKORE: ' + IntToStr(Nastavenie[2]+1));
     end;
   end
  else
   begin
    Pexeso.Naspat(Image1.Canvas);
    pocet:= 0;
   end;
   povolenie := True;
   Nastavenie[2] := Nastavenie[2] +1;
   Edit1.Text := inttostr(Nastavenie[2]);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Nastavenie[1] := Nastavenie[1]-1;
  Edit3.Text := inttostr(Nastavenie[1]);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
 Timer1.Interval := TrackBar1.Position;
 Edit2.Text := inttostr(TrackBar1.Position);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Image1.Canvas.FillRect(Image1.ClientRect);
  Povolenie := True;
  Edit1.Visible:= True;
  Edit3.Visible:= True;
  StaticText1.Visible := True;
  StaticText2.Visible := True;
  Button4.Visible  := True;
  Button4.Enabled  := True;
  Obr1:= Tbitmap.Create;
  Obr1.LoadFromFile('img/karta.bmp');
  Pexeso.Nakresli(Image1.Canvas, Obr1);
  Pexeso.Zamiesaj;
  Pexeso.Napoveda(Image1.Canvas);
  Nastavenie[1] := 120;
  Nastavenie[2] := 0;
  Nastavenie[3] := 0;
  Casovac;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Image1.Canvas.FillRect(Image1.ClientRect);
  Povolenie := False;
  Edit1.Visible:= False;
  Edit2.Visible:= True;
  Edit2.Text:= IntToStr(Timer1.Interval);
  Edit3.Visible:= False;
  Edit4.Visible:= True;
  Edit4.Text:= IntToStr(Nastavenie[1]);
  StaticText1.Visible := False;
  StaticText2.Visible := False;
  StaticText3.Visible := True;
  StaticText4.Visible := True;
  TrackBar1.Visible:= True;
  TrackBar1.Position:= Timer1.Interval;
  CheckBox1.Visible:= True;
  Button1.Enabled:= False;
  Button3.Enabled:= False;
  Button4.Visible:= False;
  Button5.Visible:= True;
  Timer2.Enabled:= False;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
Subor: TextFile;
i,j: integer;
Obrazok, Nasiel: String;
Nasiel1: boolean;
begin
Image1.Canvas.FillRect(Image1.ClientRect);
  Povolenie := True;
  Edit1.Visible:= True;
  Edit3.Visible:= True;
  StaticText1.Visible := True;
  StaticText2.Visible := True;
  Button4.Visible  := True;
  Casovac;
  Obr1:= Tbitmap.Create;
  Obr1.LoadFromFile('img/karta.bmp');
  Pexeso.Nakresli(Image1.Canvas, Obr1);

  AssignFile(Subor, 'save.txt');
  reset(subor);
   for i:= 0 to 3 do
    for j:= 0 to 5 do
     begin
      readln(Subor, Obrazok);
      readln(Subor, Nasiel);
      Nasiel1:=strtobool(Nasiel);
      Karta[i][j].Typ:= strtoint(Obrazok);
      Karta[i][j].Zobrazene:= False;
      Karta[i][j].Najdene:= Nasiel1;
     end;
   for i:= 1 to 3 do
     readln(Subor, Nastavenie[i]);
  closefile(subor);
  Pexeso.VymazNacitane(Image1.Canvas);
  Edit1.Text:=IntToStr(Nastavenie[2]);
  Edit3.Text:=IntToStr(Nastavenie[1]);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
i,j: integer;
begin
  if Nastavenie[3] < 24 then
   begin
    Memo1.Clear;
    for j := 0 to 3 do
     for i := 0 to 5 do
      begin
       Memo1.Lines.Append(inttostr(Karta[j][i].Typ));
        Memo1.Lines.Append(BoolToStr(Karta[j][i].Najdene));
      end;
    for i:=1 to 3 do
     Memo1.Lines.Append(inttostr(Nastavenie[i]));
    Memo1.Lines.SaveToFile('save.txt');
    ShowMessage('Uspesne ulozene');
   end
  else
   ShowMessage('Neda sa ulozit');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Image1.Canvas.FillRect(Image1.ClientRect);
  Povolenie := True;
  Edit1.Visible:= True;
  Edit2.Visible:= False;
  Edit3.Visible:= True;
  Edit4.Visible:= False;
  StaticText1.Visible := True;
  StaticText2.Visible := True;
  StaticText3.Visible := False;
  StaticText4.Visible := False;
  TrackBar1.Visible:= False;
  CheckBox1.Visible:= False;
  Button1.Enabled:= True;
  Button3.Enabled:= True;
  Button4.Visible:= True;
  Button5.Visible:= False;
  Obr1:= Tbitmap.Create;
  Obr1.LoadFromFile('img/karta.bmp');
  Pexeso.Nakresli(Image1.Canvas, Obr1);
  Pexeso.VymazNacitane(Image1.Canvas);
  Edit1.Text:=IntToStr(Nastavenie[2]);
  Edit3.Text:=IntToStr(Nastavenie[1]);
  Casovac;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.Checked then
   begin
    Edit4.Enabled:= True;
    Edit4.ReadOnly:= True;
   end
  else
   begin
    Edit4.Enabled:= False;
    Edit4.ReadOnly:= False;
   end;
end;

procedure TForm1.Casovac;
begin
  if CheckBox1.Checked then
   begin
    Edit3.Enabled:= True;
    Timer2.Enabled:= True;
   end
  else
   begin
    Edit3.Enabled:= False;
    Timer2.Enabled:= False;
   end;
end;

end.

