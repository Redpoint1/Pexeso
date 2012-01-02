unit GameUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Dialogs;

type

  TKarta = record
    Typ: integer;
    Zobrazene, Najdene: boolean;
    Hrac: integer;
  end;

  TFinals = record
    Body: integer;
    Meno: string;
  end;
  TKarty = array[0..4] of array[0..9] of TKarta;
  TFinale = array[1..11] of TFinals;

var
  Karta: TKarty;
  pocet, pom, pom1, X, Y: integer;
  Info, Player: array[1..3] of integer;
  Nastavenie: array[1..5] of string;
  Narade: integer;
  Final: TFinale;

{ THra }
type

  THra = class
    procedure Vytvor;
    procedure Zamiesaj;
    procedure Odber(Card: integer; Image: TCanvas);
    procedure Naspat(Image: TCanvas);
    procedure Napoveda(Image: TCanvas);
    procedure Ukaz(Card, X, Y: integer; Image: TCanvas);
    procedure VymazNacitane(Image: TCanvas);
    procedure Uloz;
    procedure Nahraj;
    procedure UlozSkore;
    procedure NahrajSkore;
    procedure Skore;
    function Parny(a, b: integer): boolean;
  end;

implementation

procedure Thra.Vytvor;
var
  i, j: integer;
begin
  for j := 0 to 4 do
  begin
    for i := 0 to 9 do
    begin
      Karta[j][i].Typ := (j * 10 + i) div 2;
      Karta[j][i].Zobrazene := False;
      Karta[j][i].Najdene := False;
      Karta[j][i].Hrac := 0;
    end;
  end;
end;

procedure THra.Zamiesaj;
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

procedure THra.Odber(Card: integer; Image: TCanvas);
var
  i, j: integer;
begin
  Image.Pen.Color := clWhite;
  for i := 0 to 4 do
    for j := 0 to 9 do
    begin
      if Karta[i][j].Typ = Card then
      begin
        Karta[i][j].Zobrazene := False;
        Karta[i][j].Najdene := True;
        Karta[i][j].Hrac := NaRade;
        Image.Rectangle(j * 80 + 5, i * 100 + 5, j * 80 + 85, i * 100 + 105);
      end;
    end;
end;

procedure THra.Naspat(Image: TCanvas);
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

function THra.Parny(a, b: integer): boolean;
begin
  Result := (a = b);
end;

procedure THra.Napoveda(Image: TCanvas);
var
  i, j: integer;
begin
  for i := 0 to 4 do
    for j := 0 to 9 do
      Image.TextOut((j * 80) + 5, (i * 100) + 5, IntToStr(Karta[i][j].Typ));
end;

procedure THra.Ukaz(Card, X, Y: integer; Image: TCanvas);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  Bmp.LoadFromFile('img/' + IntToStr(Card) + '.bmp');
  Image.Draw(X * 80 + 5, Y * 100 + 5, Bmp);
  Bmp.Free;
end;

procedure THra.VymazNacitane(Image: TCanvas);
var
  i, j: integer;
begin
  Image.Pen.Color := clWhite;
  for i := 0 to 4 do
    for j := 0 to 9 do
    begin
      if Karta[i][j].Najdene then
      begin
        Image.Rectangle(j * 80 + 5, i * 100 + 5, j * 80 + 85, i * 100 + 105);
      end;
    end;
end;

procedure THra.Uloz;
var
  Subor: TextFile;
  i, j: integer;
begin
  if Info[3] < 50 then
  begin
    AssignFile(Subor, 'save.txt');
    rewrite(Subor);
    for j := 0 to 4 do
      for i := 0 to 9 do
      begin
        Write(Subor, Karta[j][i].Typ, ' ');
        writeln(Subor, BoolToStr(Karta[j][i].Najdene));
      end;
    for i := 1 to 3 do
      Write(Subor, Info[i], ' ');
    CloseFile(Subor);
    ShowMessage('Úšpešne uložené');
  end
  else
    ShowMessage('Nedá sa uložiť');
end;

procedure THra.Nahraj;
var
  Subor: TextFile;
  Nasiel: string;
  i, j, Obrazok: integer;

begin
  AssignFile(Subor, 'save.txt');
  Reset(Subor);
  for i := 0 to 4 do
    for j := 0 to 9 do
    begin
      Read(Subor, Obrazok);
      ReadLn(Subor, Nasiel);
      Karta[i][j].Typ := Obrazok;
      Karta[i][j].Zobrazene := False;
      Karta[i][j].Najdene := StrToBool(Nasiel);
    end;
  for i := 1 to 3 do
    Read(Subor, Info[i]);
  CloseFile(subor);
end;

procedure THra.UlozSkore;
var
  i: integer;
  Subor: TextFile;
begin
  AssignFile(Subor, 'skore.txt');
  Rewrite(Subor);
  for i := 1 to 10 do
  begin
    Write(Subor, Final[i].Body, ' ');
    writeln(Subor, Final[i].Meno);
  end;
  CloseFile(Subor);
end;

procedure THra.NahrajSkore;
var
  i: integer;
  medzera: char;
  Subor: TextFile;
begin
  if FileExists('skore.txt') then
  begin
    AssignFile(Subor, 'skore.txt');
    Reset(Subor);
    for i := 1 to 10 do
    begin
      Read(Subor, Final[i].Body);
      Read(Subor, medzera);
      readln(Subor, Final[i].Meno);
    end;
    CloseFile(Subor);
  end;
end;

procedure THra.Skore;
var
  pomoc, i: integer;
  dalsiapom: string;
begin
  NahrajSkore;
  for i := 1 to 10 do
  begin
    if Final[i].Meno = '' then
    begin
      Final[i].Body := 0;
      Final[i].Meno := '-nikto-';
    end;
  end;
  Final[11].Body := Info[2];
  Final[11].Meno := Nastavenie[4];
  for i := 10 downto 1 do
  begin
    if (Final[i].Body = 0) and (Final[i].Body < Final[i + 1].Body) then
    begin
      pomoc := Final[i].Body;
      dalsiapom := Final[i].Meno;
      Final[i].Body := Final[i + 1].Body;
      Final[i].Meno := Final[i + 1].Meno;
      Final[i + 1].Body := pomoc;
      Final[i + 1].Meno := dalsiapom;
    end
    else
    begin
      if (Final[i].Body > Final[i + 1].Body) then
      begin
        pomoc := Final[i].Body;
        dalsiapom := Final[i].Meno;
        Final[i].Body := Final[i + 1].Body;
        Final[i].Meno := Final[i + 1].Meno;
        Final[i + 1].Body := pomoc;
        Final[i + 1].Meno := dalsiapom;
      end;
    end;
  end;
  UlozSkore;

end;

end.

