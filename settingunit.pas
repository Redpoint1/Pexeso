unit SettingUnit; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls;

type

  { TMenu }

  TMenu = class(TForm)
    procedure TrackBar1Change(Sender: TObject);
    //procedure ZmenTimer(Cas: Integer);
  end;

implementation

{ TMenu }

procedure TMenu.TrackBar1Change(Sender: TObject);
begin
  //Timer1.Interval := Integer;
end;
end.
