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
                ReadLn(Dat, reservations[recordCounter].RoomId);
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

procedure QuickSort(var A: TRoomArray; L, R, sortType: Integer);
var
  i, j: Integer;
  pivot, temp: TRoom;
begin
  i := L;
  j := R;
  pivot := A[(L + R) div 2];
 
  repeat
    case sortType of
      1: while A[i].NumberOfBeds < pivot.NumberOfBeds do Inc(i);
      2: while A[i].Area < pivot.Area do Inc(i);
      3: while A[i].PricePN < pivot.PricePN do Inc(i);
      4: while A[i].Balcony < pivot.Balcony do Inc(i);
    end;
 
    case sortType of
      1: while A[j].NumberOfBeds > pivot.NumberOfBeds do Dec(j);
      2: while A[j].Area > pivot.Area do Dec(j);
      3: while A[j].PricePN > pivot.PricePN do Dec(j);
      4: while A[j].Balcony > pivot.Balcony do Dec(j);
    end;
 
    if i <= j then
    begin
      temp := A[i];
      A[i] := A[j];
      A[j] := temp;
      Inc(i);
      Dec(j);
    end;
 
  until i > j;
 
  if L < j then QuickSort(A, L, j, sortType);
  if i < R then QuickSort(A, i, R, sortType);
end;

{Pomocna funkcija koja renderuje samo jednu sobu}
procedure RenderRoom(room: TRoom);
    begin;
        WriteLn('**************************************************************');
        TextColor(Blue); 
        WriteLn(UpCase(room.Name));
        TextColor(White);
        Write('Broj kreveta: ', room.NumberOfBeds, ' | ');
        Write('Povrsina: ', room.Area, ' | ');
        if room.Balcony = 'yes' then Write('Balkon: Da') 
        else Write('Balkon: Ne');
        WriteLn('Cena: $',room.PricePN, ' po danu.');
        
        WriteLn('--------------------------------------------------------------');
        WriteLn('ID sobe: ', room.ID);
        delay(100);
    end;

{Pomocna funkcija koja renderuje samo jednu sobu}
procedure RenderRoomBig(room: TRoom);
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

{Funkcija za rezervaciju}
{Ovoj funkciji prosledjujemo ID sobe koju zelimo da rezervisemo / Videcu da prosledim i samo element niza TRoom}
{Ona na osnovu ID zeljene sobe, proverava "reservations.txt" datoteku i rezervacije za tu sobu kako bi korisniku prikazala slobodne dane}
{Korisnik nece moci da rezervise zauzete termine i bice mu ispisani isti}
{Ali ce moci da rezervise slobodne termine, koji ce se upisati u datoteku "reservations.txt"}
function Reserve(roomID: Integer; room:TRoom; var reservations: TReservationArray; numberOfReservations: Integer):Integer;
var
    i, j: Integer;
    howManyReservations: Integer;
    y,m,d: Word;
    reservationDates: TReservationDateArray;
    startDate: String;
    endDate: String;
    userTempTDateTime: TDateTime;
begin 
    ClrScr;
    {Proveravamo koliko rezervacija imamo za sobu koju je korisnik uneo}
    howManyReservations := 0;
    RenderRoomBig(room);
    
    for i:= 1 to numberOfReservations do
        begin
            if (reservations[i].RoomId = roomID) then
                begin
                    {Ako ovde imamo rezervaciju ovaj counter uvecavamo za jedan}
                    howManyReservations := howManyReservations + 1;

                    {Kada udjemo u ovaj if statement imamo rezervaciju, na prvom prolazu for loop-a, ispisujemo poruku "Rezervacije"}

                    if (howManyReservations = 1) then
                        begin
                            TextColor(Red);
                            WriteLn('REZERVACIJE');
                        end;

                    {Parsiramo i smestamo u rekord dan pocetka rezervacije}
                    y := StrToInt(Copy(reservations[i].CheckIn, 1, 4));
                    m := StrToInt(Copy(reservations[i].CheckIn, 6, 2));
                    d := StrToInt(Copy(reservations[i].CheckIn, 9, 2));
                    reservationDates[howManyReservations].fromDate := EncodeDate(y, m, d);
                    {Parsiramo i smestamo u rekord dan kraja rezervacije}
                    y := StrToInt(Copy(reservations[i].CheckOut, 1, 4));
                    m := StrToInt(Copy(reservations[i].CheckOut, 6, 2));
                    d := StrToInt(Copy(reservations[i].CheckOut, 9, 2));
                    reservationDates[howManyReservations].toDate := EncodeDate(y, m, d);

                    TextColor(Red);
                    WriteLn('---------------------------------------');
                    WriteLn('Od: ', reservations[i].CheckIn, ' Do: ', reservations[i].CheckOut);
                    WriteLn('---------------------------------------');
                    TextColor(White);
                end;
        end;
    
    if (howManyReservations = 0) then
        begin
            TextColor(Red);
            WriteLn('SOBA NEMA REZERVACIJA');
            WriteLn('---------------------------------------');
            TextColor(White);
        end;
    
    {Upit za korisnika od kada do kada zeli rezervaciju}
    Write('Unesite datum pocetka rezervacije (YYYY-MM-DD): ');ReadLn(startDate);
    Write('Unesite datum kraja rezervacije (YYYY-MM-DD): ');ReadLn(endDate);

    {Parsiranje i Poredjenje korisnikovih datuma sa postojecim rezervacijama}

    y := StrToInt(Copy(reservations[i].CheckIn, 1, 4));
    m := StrToInt(Copy(reservations[i].CheckIn, 6, 2));
    d := StrToInt(Copy(reservations[i].CheckIn, 9, 2));

    userTempTDateTime := EncodeDate(y, m, d);
    WriteLn(userTempTDateTime:0:4);
    WriteLn(reservationDates[1].fromDate:0:4);
    ReadLn;
end;

{********** MILOS SAVKOVIC **********}
{Ovde sam ti napravio ovu Universal Filter proceduru }
{Radi po istom principu kao i filter funkcija}
procedure UniversalSort(var roomsArray: TRoomArray; numberOfRooms: Integer; sortType: Integer; var reservationsArray: TReservationArray; numberOfReservations: Integer);
var
  i: Integer;
  roomID: Integer;
begin
  QuickSort(roomsArray, 1, numberOfRooms, sortType);
 
  //ClrScr;
//   WriteLn('*** SORTIRANE SOBE ***');
//   WriteLn;
 
  for i := 1 to numberOfRooms do
    RenderRoom(roomsArray[i]);

    TextColor(Green);
    Write('Izaberite ID sobe zelite da rezervisete: '); ReadLn(roomID);
    TextColor(White);

    {Rezervacija Selektovane sobe}
    Reserve(roomID, roomsArray[roomID], reservationsArray, numberOfReservations);
 
//   WriteLn;
//   TextColor(Green);
//   WriteLn('Pritisni bilo koji taster za povratak u meni...');
//   TextColor(White);
  WriteLn('Press <Enter> to exit');
  ReadKey;
end;

{********** MILOS SAVKOVIC **********}
{Funkcija koja nam nudi opcije za sortiranje}
{1) Broj osoba - Broj kreveta}
{2) Povrsina }
{3) Cena}
{4) Postojanje balkona}
procedure Sort(var roomsArray: TRoomArray; numberOfRooms: Integer; var reservationsArray: TReservationArray; numberOfReservations: Integer);
var
    menuKey: Char;
begin
    repeat
        ClrScr;
        WriteLn('****************************************');
        WriteLn('**********  HOTEL CALIFORNIA  **********');
        WriteLn('****************************************');
        WriteLn('Opcije za sortiranje po:');
        WriteLn('1) Broju osoba');
        WriteLn('2) Povrsini sobe');
        WriteLn('3) Ceni');
        WriteLn('4) Postojanju balkona');
        WriteLn('e) Izlazak iz sortiranja');
 
        TextColor(Green);
        WriteLn('---------------------------------------');
        Write('Izaberite opciju pritiskom na taster: '); menuKey := ReadKey;
        TextColor(White);
 
        case menuKey of
            '1': UniversalSort(roomsArray, numberOfRooms, 1, reservationsArray, numberOfReservations);
            '2': UniversalSort(roomsArray, numberOfRooms, 2, reservationsArray, numberOfReservations);
            '3': UniversalSort(roomsArray, numberOfRooms, 3, reservationsArray, numberOfReservations);
            '4': UniversalSort(roomsArray, numberOfRooms, 4, reservationsArray, numberOfReservations);
        end;
 
    until (menuKey = 'e');
    ReadLn;
end;
 

{Pomocna filter funkcija koja obavlja proces filtriranja, na osnovu zadatih parametara}
procedure UniversalFilter(var roomsArray: TRoomArray; numberOfRooms: Integer; filterType: Integer; var reservationsArray: TReservationArray; numberOfReservations: Integer);
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

                    TextColor(Red);
                    Write('Unesite broj kreveta: ');ReadLn(userOption);
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
                    TextColor(Red);
                    Write('Unesite maksimalnu povrsinu: ');ReadLn(userOption);
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
                    TextColor(Red);
                    Write('Maksimalna cena: ');ReadLn(userOption);
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
                        TextColor(Red);
                        Write('Balkon Y/N. Pritisni "E" za izlazak? ');ReadLn(userOptionString);
                        TextColor(White);
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
procedure Filter(var roomsArray: TRoomArray; numberOfRooms: Integer; var reservationsArray: TReservationArray; numberOfReservations: Integer);
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
                    '1': UniversalFilter(roomsArray, numberOfRooms, 1, reservationsArray, numberOfReservations); 
                    '2': UniversalFilter(roomsArray, numberOfRooms, 2, reservationsArray, numberOfReservations); 
                    '3': UniversalFilter(roomsArray, numberOfRooms, 3, reservationsArray, numberOfReservations);
                    '4': UniversalFilter(roomsArray, numberOfRooms, 4, reservationsArray, numberOfReservations);
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