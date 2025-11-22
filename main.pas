{$MODE OBJFPC}
program Hotel;

uses
Crt, SysUtils, DateUtils;
{$i data.pas}

var
  rooms: TRoomArray;
  numberOfRooms: Integer;
  menuKey: Char;

{Ucitavanje funkcija}
{$i logic.pas}
begin

  ClrScr;

  try
    {*** POCETAK APLIKACIJE ***}
    {Ucitavanje svih soba u rooms niz}
    numberOfRooms := ReadStringArray('hotel_rooms.txt', rooms);

    {Provera izlistavanje broja soba}
    // WriteLn(numberOfRooms); {Vraca 13 proveri - Oduzeo 1}

    {Glavni Menu - Izlistavanje opcija}
    repeat
      ClrScr;

      WriteLn('****************************************');
      WriteLn('**********  HOTEL CALIFORNIA  **********');
      WriteLn('****************************************');
      WriteLn('1) Sortiraj');
      WriteLn('2) Filteri');
      WriteLn('3) Izlistaj sve sobe');
      WriteLn('e) Pritisni "e" za izlazak iz aplikacije');

      {Odabir opcije - Korisnik mora da pritisne 1, 2 ili 3}
      menuKey := ReadKey;

      {Na osnovu odabira vodimo korisnika na podmenije}
      case menuKey of
        '1': Sort(rooms, numberOfRooms);    
        '2': Filter(rooms, numberOfRooms);
        '3': RenderAllRooms(rooms, numberOfRooms);
      end;
    until (menuKey = 'e');
  {*** KRAJ APLIKACIJE ***}

  except
    on E: EInOutError do
    begin
      WriteLn('Moramo prekinuti rad.');
      WriteLn('Greška pri čitanju datoteke.');
    end;

    on E: Exception do
    begin
      WriteLn('Moramo prekinuti rad.');
      WriteLn('Poruka: ', E.Message);
    end;
  end;
end.
