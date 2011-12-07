unit GameUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type

  TKarta = record
    Typ: integer;
    Zobrazene, Najdene: boolean;
  end;
  TKarty = array[0..3] of array[0..5] of TKarta;



var
  Karta: TKarty;
  pocet, pom, pom1, X, Y: integer;

{ TPlocha }
type

  TPlocha = class
    constructor Create;
    procedure Nakresli(Image: TCanvas; Bmp: TBitmap);
    procedure Vymaz(A: TCanvas);
    procedure Vytvor;
    procedure Zamiesaj;
    procedure Odber(Card: Integer; Image: TCanvas);
    procedure Naspat(Image: TCanvas);
    procedure Napoveda(Image: TCanvas);
    procedure Ukaz(Card,X,Y: Integer; Image: TCanvas);
    procedure VymazNacitane(Image: TCanvas);
    function Parny(a,b : Integer): boolean;

  end;

implementation



{ TPlocha }

constructor TPlocha.Create;
begin
  pocet := 0;
end;

procedure TPlocha.Vytvor;
var
  i, j: integer;
begin
  for j := 0 to 3 do
  begin
    for i := 0 to 5 do
    begin
      Karta[j][i].Typ := (j * 6 + i) div 2;
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
  for y := 0 to 3 do
    for x := 0 to 5 do
    begin
      rand_x := random(5);
      rand_y := random(3);
      pomocna := Karta[y][x].Typ;
      Karta[y][x].Typ := Karta[rand_y][rand_x].Typ;
      Karta[rand_y][rand_x].Typ := pomocna;
    end;
end;

procedure TPlocha.Nakresli(Image: TCanvas; Bmp: TBitmap);
var
  X, Y: integer;
begin
  Y := 0;
  while Y < 4 do
  begin
    X := 0;
    while X < 6 do
    begin
      Image.Draw(X*80+5, Y*100+5, Bmp);
      Inc(X);
    end;
    Inc(Y);
  end;
  Bmp.Free;
end;

procedure TPlocha.Vymaz(A: TCanvas);
begin

end;

procedure TPlocha.Odber(Card:Integer; Image:TCanvas);
var
  i,j: integer;
begin
  Image.Pen.Color:=clWhite;
  for i := 0 to 3 do
   for j:=0 to 5 do
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
  for i := 0 to 3 do
    for j := 0 to 5 do
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
  for i:=0 to 3 do
   for j:=0 to 5 do
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
  for i := 0 to 3 do
   for j:=0 to 5 do
    begin
      if Karta[i][j].Najdene then
      begin
      Image.Rectangle(j * 80 + 5, i * 100 + 5, j * 80 + 85, i * 100 + 105);
      end;
    end;
end;

end.
