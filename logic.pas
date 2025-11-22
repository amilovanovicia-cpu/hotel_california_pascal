function ReadStringArray(DatName: String; var rooms: TRoomArray): Integer;
    var 
        recordCounter: Integer;
        ocitana_linija: String;
        Dat:Text; 
        
    begin 
        recordCounter := 1;
        Assign(Dat, DatName);
        Reset(Dat);

        while not eof(Dat) do 
            begin 
                ReadLn(Dat, rooms[recordCounter].Id);
                ReadLn(Dat, rooms[recordCounter].Name);
                ReadLn(Dat, rooms[recordCounter].NumberOfBeds);
                ReadLn(Dat, rooms[recordCounter].Area);
                ReadLn(Dat, rooms[recordCounter].Balcony);
                ReadLn(Dat, rooms[recordCounter].PricePN);
                ReadLn(Dat);
                recordCounter := recordCounter + 1;
        end;
        ReadStringArray := recordCounter - 1;
    end;

{Pomocna funkcija koja renderuje samo jednu sobu}
procedure RenderRoom(room: TRoom);
    begin;
        WriteLn('****************************************');
        TextColor(Blue);
        WriteLn(UpCase(room.Name));
        TextColor(White);
        WriteLn('Broj kreveta: ', room.NumberOfBeds);
        WriteLn('Povrsina: ', room.Area);
        if room.Balcony = 'yes' then WriteLn('Balkon: Da') 
        else WriteLn('Balkon: Ne');
        WriteLn('Cena: $',room.PricePN, ' po danu.');
        
        WriteLn('---------------------------------------');
        WriteLn('Rezervisi Funkcija - ID sobe: ', room.ID);
        WriteLn('---------------------------------------');

    end;

{Funkcija koja nam nudi opcije za sortiranje}
{1) Broj osoba - Broj kreveta}
{2) Povrsina }
{3) Cena}
{4) Postojanje balkona}
procedure Sort(var roomsArray: TRoomArray; numberOfRooms: Integer);
    var
        menuKey: Char;
    begin

        {Izlistavanje menija za opcije sortiranja}
        repeat
            ClrScr;
            WriteLn('****************************************');
            WriteLn('**********  HOTEL CALIFORNIA  **********');
            WriteLn('****************************************');
            WriteLn('Opcije za sortiranje:');
            WriteLn('1) Broj osoba rastuce');
            WriteLn('2) Povrsina sobe rastuce');
            WriteLn('3) Cena rastuca');
            WriteLn('4) Ima balkon');
            WriteLn('e) Izlazak iz sortiranja');

            case menuKey of
                '1': WriteLn('Proba');
                '2': WriteLn('Proba');
                '3': WriteLn('Proba');
                '4': WriteLn('Proba');
            end;

            {Korisnik bira neku od opcija za sortiranje}
            WriteLn('****************************************');
            Write('Izaberite opciju: ');    
            menuKey := ReadKey;

        until (menuKey = 'e');

    end;

{Pomocna filter funkcija koja obavlja proces filtriranja, na osnovu zadatih parametara}
procedure UniversalFilter(var roomsArray: TRoomArray; numberOfRooms: Integer; filterType: Integer);
    var
        i: Integer;
        userOption: Integer;
        // codeErrorForVal: Integer;
        // {Ova varijabla sluza za privremeno konvertovanje stringa u broj}
        // {Za sada su opcije u rekordu sve string}
        // tempNum: LongInt;
    begin
        case filterType of
            {Broj Soba Filter}
            1:  begin
                    ClrScr;
                    Write('Unesite broj kreveta: ');ReadLn(userOption);

                    {Poruka koliko je korisnik izabrao soba}
                    TextColor(Red);
                    WriteLn('Izabrani broj kreveta: ', userOption);
                    TextColor(White);

                    {Filter za pronalazak soba}
                    for i:= 1 to numberOfRooms do
                        begin 
                            if roomsArray[i].NumberOfBeds = userOption then
                                begin
                                    // WriteLn(roomsArray[i].Name);
                                    // {Ovde bi trebalo uneti funkciju koja renderuje sobe}
                                    RenderRoom(roomsArray[i]);
                                end;
                        end;
                end;
            {Povrsina Filter}
            {Ovde filtriramo do odredjene povrsine, trazimo sobe koje su manje ili jednake od korisnikovog unosa}
            2:  begin
                    ClrScr;
                    Write('Unesite maksimalnu povrsinu: ');ReadLn(userOption);

                    {Poruka o maksimalnoj povrsini koju je korisnik izabrao}
                    TextColor(Red);
                    WriteLn('Izabrana maksimalna povrsina: ', userOption, 'm2');
                    TextColor(White);

                    {Filter za pronalazak soba do povrsine koje je korisnik uneo}
                    for i:= 1 to numberOfRooms do
                        begin 
                            if roomsArray[i].Area <= userOption then
                                begin
                                    // WriteLn(roomsArray[i].Name);
                                    // {Ovde bi trebalo uneti funkciju koja renderuje sobe}
                                    RenderRoom(roomsArray[i]);
                                end;
                        end;
                end;
            {Cena Filter}
            {Ovde filtriramo sve sobe do cene koju je korisnik uneo}
            3:  begin
                    ClrScr;
                    Write('Maksimalna cena: ');ReadLn(userOption);

                    {Poruka o maksimalnoj ceni koju je korisnik uneo}
                    TextColor(Red);
                    WriteLn('Izabrana maksimalna cena sobe: $', userOption);
                    TextColor(White);

                    {Filter za pronalazak soba do povrsine koje je korisnik uneo}
                    for i:= 1 to numberOfRooms do
                        begin 
                            if roomsArray[i].PricePN <= userOption then
                                begin
                                    // WriteLn(roomsArray[i].Name);
                                    // {Ovde bi trebalo uneti funkciju koja renderuje sobe}
                                    RenderRoom(roomsArray[i]);
                                end;
                        end;
                end;
        end;
    end;

{Funkcija koja nam nudi opcije za filtriranje}
{Imamo 4 opcije za filtriranje}
{1) Broj osoba - Broj kreveta}
{2) Povrsina }
{3) Cena}
{4) Postojanje balkona}
procedure Filter(var roomsArray: TRoomArray; numberOfRooms: Integer);
    var
        menuKey: Char;
    begin 

        {Izlistavanje menija za opcije sortiranja}
        repeat
            ClrScr;
            WriteLn('****************************************');
            WriteLn('**********  HOTEL CALIFORNIA  **********');
            WriteLn('****************************************');
            WriteLn('Opcije za filtriranje:');
            WriteLn('1) Broj Soba');
            WriteLn('2) Povrsina sobe');
            WriteLn('3) Cena');
            WriteLn('4) Ima balkon');
            WriteLn('e) Izlazak iz sortiranja');

                case menuKey of
                    '1': UniversalFilter(roomsArray, numberOfRooms, 1); 
                    '2': UniversalFilter(roomsArray, numberOfRooms, 2); 
                    '3': UniversalFilter(roomsArray, numberOfRooms, 3);
                    '4': WriteLn('Proba'); 
                end;

            {Korisnik bira neku od opcija za sortiranje}
            WriteLn('****************************************');
            Write('Izaberite opciju: ');    
            menuKey := ReadKey;
        until (menuKey = 'e');

    end;


function RenderAllRooms(roomsArray: TRoomArray; numberOfRooms: Integer):TRoomArray;
begin
    ClrScr;
    WriteLn('Render All Rooms');
    RenderAllRooms := roomsArray;
    ReadKey;
end;