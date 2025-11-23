function ReadRooms(DatName: String; var rooms: TRoomArray): Integer;
    var 
        recordCounter: Integer;
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
        {Ovde oduzimam 1 od countera jer on uvek daje jedan vise}
        {Razlog, counter na poslednjem true uslovu se ipak povecava}
        {I poslednji counter je zapravo false}
        ReadRooms := recordCounter - 1;
    end;

function ReadReservations(DatName: String; var reservations: TReservationArray): Integer;
    var 
        recordCounter: Integer;
        Dat:Text; 
        
    begin 
        recordCounter := 1;
        Assign(Dat, DatName);
        Reset(Dat);

        while not eof(Dat) do 
            begin 
                ReadLn(Dat, reservations[recordCounter].JMBG);
                ReadLn(Dat, reservations[recordCounter].Name);
                ReadLn(Dat, reservations[recordCounter].Surname);
                ReadLn(Dat, reservations[recordCounter].RoomNumber);
                ReadLn(Dat, reservations[recordCounter].CheckIn);
                ReadLn(Dat, reservations[recordCounter].CheckOut);
                ReadLn(Dat, reservations[recordCounter].TotalPrice);
                ReadLn(Dat);
                recordCounter := recordCounter + 1;
        end;
        {Ovde oduzimam 1 od countera jer on uvek daje jedan vise}
        {Razlog, counter na poslednjem true uslovu se ipak povecava}
        {I poslednji counter je zapravo false}
        ReadReservations := recordCounter-1;
    end;

{Funkcija za rezervaciju}
{Ovoj funkciji prosledjujemo ID sobe koju zelimo da rezervisemo / Videcu da prosledim i samo element niza TRoom}
{Ona na osnovu ID zeljene sobe, proverava "reservations.txt" datoteku i rezervacije za tu sobu kako bi korisniku prikazala slobodne dane}
{Korisnik nece moci da rezervise zauzete termine i bice mu ispisani isti}
{Ali ce moci da rezervise slobodne termine, koji ce se upisati u datoteku "reservations.txt"}
function Reserve(roomID: Integer; room:TRoom; var reservations: TReservationArray; numberOfReservations: Integer):Integer;
var
    i, j: Integer;
begin 
    WriteLn('izabrali ste ovu sobu za rezervaciju: ID: ', roomID);
    ReadLn();
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
        WriteLn('ID sobe: ', room.ID);
        WriteLn('---------------------------------------');
    end;

{********** MILOS SAVKOVIC **********}
{Ovde sam ti napravio ovu Universal Filter proceduru }
{Radi po istom principu kao i filter funkcija}
procedure UniversalSort(var roomsArray: TRoomArray; numberOfRooms: Integer; sortType: Integer);
begin
    {********** MILOS SAVKOVIC **********}
    {Ovde pises kod koji je manje-vise slican filter univerzalnoj funckiji, s'tim sto umesto filtriranja radis sortiranje. }
    {Svaki case u univerzalnom sortu ce ti koristiti "RenderRoom" proceduru koja izlistava pojedinacnu sobu}
    {Primer:}
    {Ako sortiras po broju osoba, prvo sortiras taj niz, pa prodjdes for loop-om kroz ceo sortirani niz, i svaki element sortiranog niza je (nastavljam u redu ispod)}
    {je tipa TRoom, ti prosledis samo taj element "Render Room" proceduri i ona sve odradi za tebe}
end;

{********** MILOS SAVKOVIC **********}
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
            WriteLn('Opcije za sortiranje po:');
            WriteLn('1) Broju osoba');
            WriteLn('2) Povrsini sobe');
            WriteLn('3) Ceni');
            WriteLn('4) Postojanju balkona'); {Jbg, ne znam kada napisem sortiranje po, kako da kazem za balkon :)}
            WriteLn('e) Izlazak iz sortiranja');

            {Odabir opcije - Korisnik mora da pritisne 1, 2, 3, 4 ili "e" za izlazak}
            TextColor(Green);
            WriteLn('---------------------------------------');
            Write('Izaberite opciju pritiskom na taster: '); menuKey := ReadKey;
            TextColor(White);

            {********** MILOS SAVKOVIC **********}
            {Ovde umesto WriteLn pozivas UniversalSort funkciju}
            {Kao u filter sto poziva universal filter}
            case menuKey of
                '1': WriteLn('Proba');
                '2': WriteLn('Proba');
                '3': WriteLn('Proba');
                '4': WriteLn('Proba');
            end;

        until (menuKey = 'e');
        ClrScr;
    end;

{Pomocna filter funkcija koja obavlja proces filtriranja, na osnovu zadatih parametara}
procedure UniversalFilter(var roomsArray: TRoomArray; numberOfRooms: Integer; filterType: Integer);
    var
        i: Integer;
        userOption: Integer;
        roomID: Integer;

        {userOptionString varijabla nam je potrebna zbog Balkon filtera}
        {Korisnik unosi Y ili N - Zapravo da li zeli balkon ili ne}
        {I zato smo morali da napravimo i string varijablu}
        userOptionString: String; 
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

                    {Upit korisniku koju sobu zeli da rezervise} 
                    TextColor(Green);
                    Write('Izaberite ID sobe zelite da rezervisete: '); ReadLn(roomID);
                    TextColor(White);

                    {Rezervacija Selektovane sobe}
                    Reserve(roomID, roomsArray[roomID], reservations, numberOfReservations);
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

                    {Upit korisniku koju sobu zeli da rezervise} 
                    TextColor(Green);
                    Write('Izaberite ID sobe zelite da rezervisete: '); ReadLn(roomID);
                    TextColor(White);

                    {Rezervacija Selektovane sobe}
                    Reserve(roomID, roomsArray[roomID], reservations, numberOfReservations);
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
                    
                    {Upit korisniku koju sobu zeli da rezervise} 
                    TextColor(Green);
                    Write('Izaberite ID sobe zelite da rezervisete: '); ReadLn(roomID);
                    TextColor(White);

                    {Rezervacija Selektovane sobe}
                    Reserve(roomID, roomsArray[roomID], reservations, numberOfReservations);
                end;
                {Balkon - Filter}
                {Filter prikazuje sobe sa balkonom ili bez na osnovu korisnikovog unosa}
            4:  begin
                    ClrScr;
                    repeat
                        Write('Balkon Y/N. Pritisni "E" za izlazak? ');ReadLn(userOptionString);
                    until ((LowerCase(userOptionString[1]) = 'y') OR (LowerCase(userOptionString[1]) = 'n') OR (LowerCase(userOptionString[1]) = 'e'));

                    if LowerCase(userOptionString) = 'e' then exit;


                    {Ako je korisnik uneo 'Y' - Izlistavamo sobe SA balkonom}
                    if LowerCase(userOptionString[1]) = 'y' then
                    begin 
                        for i:= 1 to numberOfRooms do
                        begin 
                            if roomsArray[i].Balcony = 'yes' then
                                begin
                                    RenderRoom(roomsArray[i]);
                                end;
                        end;
                    end;

                    {Ako je korisnik uneo 'N' - Izlistavamo sobe BEZ balkona}
                    if LowerCase(userOptionString[1]) = 'n' then
                    begin 
                        for i:= 1 to numberOfRooms do
                        begin 
                            if roomsArray[i].Balcony = 'no' then
                                begin
                                    RenderRoom(roomsArray[i]);
                                end;
                        end;
                    end;

                    {Upit korisniku koju sobu zeli da rezervise} 
                    TextColor(Green);
                    Write('Izaberite ID sobe zelite da rezervisete: '); ReadLn(roomID);
                    TextColor(White);

                    {Rezervacija Selektovane sobe}
                    Reserve(roomID, roomsArray[roomID], reservations, numberOfReservations);
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
            WriteLn('e) Pritisni "e" za izlazak iz filter opcije');

            {Odabir opcije - Korisnik mora da pritisne 1, 2, 3, 4 ili "e" za izlazak}
            TextColor(Green);
            WriteLn('---------------------------------------');
            Write('Izaberite opciju pritiskom na taster: '); menuKey := ReadKey;
            TextColor(White);

                case menuKey of
                    '1': UniversalFilter(roomsArray, numberOfRooms, 1); 
                    '2': UniversalFilter(roomsArray, numberOfRooms, 2); 
                    '3': UniversalFilter(roomsArray, numberOfRooms, 3);
                    '4': UniversalFilter(roomsArray, numberOfRooms, 4);
                end;
            
        until (menuKey = 'e');
        ClrScr;
    end;


function RenderAllRooms(roomsArray: TRoomArray; numberOfRooms: Integer):TRoomArray;
begin
    ClrScr;
    WriteLn('Render All Rooms');
    RenderAllRooms := roomsArray;
    ReadKey;
end;