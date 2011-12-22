unit GameUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Dialogs;

type

  TKarta = record
    Typ: integer;
    Zobrazene, Najdene: boolean;
  end;
  TFinals = record
    Body: Integer;
    Meno: String;
  end;
  TKarty = array[0..4] of array[0..9] of TKarta;
  TFinale = array[1..11] of TFinals;

var
  Karta: TKarty;
  pocet, pom, pom1, X, Y: integer;
  Info: array[1..3] of integer;
  Nastavenie: array[1..3] of String;
  Final: TFinale;

{ TPlocha }
type

  TPlocha = class
    procedure Nakresli(Image: TCanvas);
    procedure Vytvor;
    procedure Zamiesaj;
    procedure Odber(Card: Integer; Image: TCanvas);
    procedure Naspat(Image: TCanvas);
    procedure Napoveda(Image: TCanvas);
    procedure Ukaz(Card,X,Y: Integer; Image: TCanvas);
    procedure VymazNacitane(Image: TCanvas);
    procedure Uloz;
    Procedure Nahraj;
    procedure UlozSkore;
    Procedure NahrajSkore;
    procedure Skore;
    function Parny(a,b : Integer): boolean;
  end;

implementation

procedure TPlocha.Vytvor;
var
  i, j: integer;
begin
  for j := 0 to 4 do
  begin
    for i := 0 to 9 do
    begin
      Karta[j][i].Typ := (j*10+i) div 2;
      Karta[j][i].Zobrazene := False;
      Karta[j][i].Najdene := False;
    end;
  end;
end;

procedure TPlocha.Zamiesaj;
var
  x, y: integer;
  rand_x, rand_y: integer;
  pomocna: integer;
begin
  Vytvor;
  randomize;
  for y := 0 to 4 do
    for x := 0 to 9 do
    begin
      rand_x := random(9);
      rand_y := random(4);
      pomocna := Karta[y][x].Typ;
      Karta[y][x].Typ := Karta[rand_y][rand_x].Typ;
      Karta[rand_y][rand_x].Typ := pomocna;
    end;
end;

procedure TPlocha.Nakresli(Image: TCanvas);
var
  X, Y: integer;
  Bmp: TBitmap;
begin
  Bmp:= Tbitmap.Create;
  Bmp.LoadFromFile('img/karta.bmp');
  Y := 0;
  while Y < 5 do
  begin
    X := 0;
    while X < 10 do
    begin
      Image.Draw(X*80+5, Y*100+5, Bmp);
      Inc(X);
    end;
    Inc(Y);
  end;
  Bmp.Free;
end;

procedure TPlocha.Odber(Card:Integer; Image:TCanvas);
var
  i,j: integer;
begin
  Image.Pen.Color:=clWhite;
  for i:=0 to 4 do
   for j:=0 to 9 do
    begin
      if Karta[i][j].Typ = Card then
      begin
      Karta[i][j].Zobrazene := False;
      Karta[i][j].Najdene := True;
      Image.Rectangle(j * 80 + 5, i * 100 + 5, j * 80 + 85, i * 100 + 105);
      end;
    end;
end;

procedure TPlocha.Naspat(Image: TCanvas);
var
  i, j: integer;
  Bmp: TBitmap;
begin
  for i := 0 to 4 do
    for j := 0 to 9 do
    begin
      if Karta[i][j].Zobrazene = True then
      begin
        Karta[i][j].Zobrazene := False;
        Bmp := TBitmap.Create;
        Bmp.LoadFromFile('img/karta.bmp');
        Image.Draw((j * 80) + 5, (i * 100) + 5, Bmp);
        Bmp.Free;
      end;
    end;
end;

function TPlocha.Parny(a, b:integer): boolean;
begin
  Result := (a = b);
end;

procedure TPlocha.Napoveda(Image: TCanvas);
var
  i,j: integer;
begin
  for i:=0 to 4 do
   for j:=0 to 9 do
  Image.TextOut((j * 80) + 5, (i * 100) + 5, inttostr(Karta[i][j].Typ));
end;

procedure TPlocha.Ukaz(Card,X,Y: Integer; Image: TCanvas);
var
  Bmp:TBitmap;
begin
   Bmp := TBitmap.Create;
   Bmp.LoadFromFile('img/' + IntToStr(Card) + '.bmp');
   Image.Draw(X * 80 + 5, Y * 100 + 5, Bmp);
   Bmp.Free;
end;

procedure TPlocha.VymazNacitane(Image: TCanvas);
var
  i,j: integer;
begin
  Image.Pen.Color:=clWhite;
  for i:=0 to 4 do
   for j:=0 to 9 do
    begin
      if Karta[i][j].Najdene then
      begin
      Image.Rectangle(j * 80 + 5, i * 100 + 5, j * 80 + 85, i * 100 + 105);
      end;
    end;
end;

procedure TPlocha.Uloz;
var
  Subor: TextFile;
  i,j: Integer;
begin
  if Info[3] < 50 then
   begin
    AssignFile(Subor, 'save.txt');
    rewrite(Subor);
    for j := 0 to 4 do
     for i := 0 to 9 do
      begin
       write(Subor, Karta[j][i].Typ, ' ');
       writeln(Subor, BoolToStr(Karta[j][i].Najdene));
      end;
    for i:=1 to 3 do
     write(Subor, Info[i], ' ');
    CloseFile(Subor);
    ShowMessage('Úšpešne uložené');
      end
  else
   ShowMessage('Nedá sa uložiť');
end;

procedure TPlocha.Nahraj;
var
  Subor: TextFile;
  Nasiel: string;
  i,j,Obrazok: Integer;

begin
  AssignFile(Subor, 'save.txt');
  Reset(Subor);
   for i:= 0 to 4 do
    for j:= 0 to 9 do
     begin
      Read(Subor, Obrazok);
      ReadLn(Subor, Nasiel);
      Karta[i][j].Typ:= Obrazok;
      Karta[i][j].Zobrazene:= False;
      Karta[i][j].Najdene:= StrToBool(Nasiel);
     end;
   for i:= 1 to 3 do
     Read(Subor, Info[i]);
  CloseFile(subor);
end;

procedure TPlocha.UlozSkore;
var
  i: integer;
  Subor: TextFile;
begin
  AssignFile(Subor, 'skore.txt');
  Rewrite(Subor);
  for i:=1 to 10 do
   begin
     write(Subor, Final[i].Body, ' ');
     writeln(Subor, Final[i].Meno);
   end;
  CloseFile(Subor);
end;

procedure TPlocha.NahrajSkore;
var
  i: integer;
  medzera: char;
  Subor: TextFile;
begin
  if FileExists('skore.txt') then
   begin
    AssignFile(Subor, 'skore.txt');
    Reset(Subor);
    for i:=1 to 10 do
     begin
      read(Subor, Final[i].Body);
      read(Subor, medzera);
      readln(Subor, Final[i].Meno);
     end;
    CloseFile(Subor);
   end
  else
  ShowMessage('Žiadne skore sa nenašlo');

end;

procedure TPlocha.Skore;
var
  pomoc, i: Integer;
begin
 NahrajSkore;
 for i:=1 to 10 do
  begin
   if Final[i].Meno = '' then
    begin
     Final[i].Body := 0;
     Final[i].Meno := '-nikto-';
    end;
  end;
 Final[11].Body:= Info[2];
 for i:=10 downto 1 do
  begin
   if Final[i].Body = 0 then
    begin
     if (Final[i].Body < Final[i+1].Body) then
      begin
       pomoc := Final[i].Body;
       Final[i].Body := Final[i+1].Body;
       Final[i+1].Body := pomoc;
       Final[i].Meno := '-nikto-';
      end;
    end
   else
   begin
    if (Final[i].Body > Final[i+1].Body) then
     begin
      pomoc := Final[i].Body;
      Final[i].Body := Final[i+1].Body;
      Final[i+1].Body := pomoc;
      Final[i].Meno := '-nikto-';
     end;
   end;
  end;
 UlozSkore;


end;

end.
