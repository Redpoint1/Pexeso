unit PlochaUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Dialogs;

type

  { TPlocha }

  TPlocha = class
    procedure Nakresli(Image: TCanvas);
  end;

implementation

{ TPlocha }

procedure TPlocha.Nakresli(Image: TCanvas);
var
  X, Y: integer;
  Bmp: TBitmap;
begin
  Bmp := Tbitmap.Create;
  Bmp.LoadFromFile('img/karta.bmp');
  Y := 0;
  while Y < 5 do
  begin
    X := 0;
    while X < 10 do
    begin
      Image.Draw(X * 80 + 5, Y * 100 + 5, Bmp);
      Inc(X);
    end;
    Inc(Y);
  end;
  Bmp.Free;
end;

end.

