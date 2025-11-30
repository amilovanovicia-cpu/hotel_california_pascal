{$mode objfpc}{$H+}
program Hotel;

uses
Crt, SysUtils, DateUtils, Windows;
{$i data.pas}

var
  rooms:          TRoomArray;
  reservations:   TReservationArray;
  numberOfRooms, numberOfReservations: Integer;
  menuKey:        Char;
  Freq: Int64;
  StartC, EndC: Int64;
  ElapsedMicro: Double;

{Ucitavanje funkcija}
{$i logic.pas}
begin

  ClrScr;

  try
    {*** POCETAK APLIKACIJE ***}
    {Ucitavanje svih soba u rooms niz}
    numberOfRooms         := ReadRooms('hotel_rooms.txt', rooms);
    numberOfReservations  := ReadReservations('reservations.txt', reservations);
    
    
    {Provera izlistavanja rezervacija}
    // WriteLn(numberOfReservations);
    {Provera izlistavanje broja soba}
    // WriteLn(numberOfRooms); 

    {Glavni Menu - Izlistavanje opcija}
    repeat
      // ClrScr;

      WriteLn('==============================================');
      WriteLn('                HOTEL CALIFORNIA              ');
      WriteLn('==============================================');
      WriteLn(' 1) Search Rooms');
      WriteLn(' 2) Sorting Options');
      WriteLn(' 3) Filter Options');
      WriteLn(' 4) List All Rooms');
      WriteLn('----------------------------------------------');
      WriteLn(' e) Exit');

      {Odabir opcije - Korisnik mora da pritisne 1, 2, 3 ili "e" za izlazak}
      TextColor(Green);
      WriteLn('----------------------------------------------');
      Write('Press the corresponding key to select an option: '); ReadLn(menuKey);
      TextColor(White);

      {Na osnovu odabira vodimo korisnika na podmenije}
      case menuKey of
        '1': SearchRooms(rooms, numberOfRooms, reservations, numberOfReservations);
        '2': Sort(rooms, numberOfRooms, reservations, numberOfReservations);    
        '3': Filter(rooms, numberOfRooms, reservations, numberOfReservations);
        '4': RenderAllRooms(rooms, numberOfRooms);
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
