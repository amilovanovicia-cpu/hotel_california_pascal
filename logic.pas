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

{Header UI}
procedure RenderRoomTableHeader;

begin

    TextColor(LightCyan);

    WriteLn('---------------------------------------------------------------------------------------');

    // Prints the table header for rooms with column titles
    WriteLn(Format('%-5s %-20s %-12s %-12s %-10s %-12s',
        ['ID', 'Name', 'Beds', 'Area', 'Balcony', 'Price']));

    WriteLn('---------------------------------------------------------------------------------------');

    TextColor(White);

end;

{Table UI}
procedure RenderRoomTable(room: TRoom);
begin
    WriteLn(Format('%-5d %-20s %-12d %-12d %-10s $%-12d',
        [room.ID, room.Name, room.NumberOfBeds, room.Area, room.Balcony, room.PricePN]));
end;

{Quick Sort}
procedure QuickSort(var A: TRoomArray; L, R, sortType, sortOrder: Integer);
var
  i, j: Integer;
  pivot, temp: TRoom;
begin
  i := L;
  j := R;
  pivot := A[(L + R) div 2];
 
  repeat
    if sortOrder = 1 then  // ASCENDING
    begin
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
    end
    else // DESCENDING
    begin
      case sortType of
        1: while A[i].NumberOfBeds > pivot.NumberOfBeds do Inc(i);
        2: while A[i].Area > pivot.Area do Inc(i);
        3: while A[i].PricePN > pivot.PricePN do Inc(i);
        4: while A[i].Balcony > pivot.Balcony do Inc(i);
      end;
 
      case sortType of
        1: while A[j].NumberOfBeds < pivot.NumberOfBeds do Dec(j);
        2: while A[j].Area < pivot.Area do Dec(j);
        3: while A[j].PricePN < pivot.PricePN do Dec(j);
        4: while A[j].Balcony < pivot.Balcony do Dec(j);
      end;
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
 
  if L < j then QuickSort(A, L, j, sortType, sortOrder);
  if i < R then QuickSort(A, i, R, sortType, sortOrder);
end;

{Pomocna funkcija koja renderuje samo jednu sobu}
// procedure RenderRoom(room: TRoom);
//     begin;
//         WriteLn('**************************************************************');
//         TextColor(Blue); 
//         WriteLn(UpCase(room.Name));
//         TextColor(White);
//         Write('Broj kreveta: ', room.NumberOfBeds, ' | ');
//         Write('Povrsina: ', room.Area, ' | ');
//         if room.Balcony = 'yes' then Write('Balkon: Da') 
//         else Write('Balkon: Ne');
//         WriteLn('Cena: $',room.PricePN, ' po danu.');
        
//         WriteLn('--------------------------------------------------------------');
//         WriteLn('ID sobe: ', room.ID);
//         delay(100);
//     end;

{Funkcija za centriranje stringa}
function CenterStr(const S: string; Width: Integer): string;
var pad: Integer;
begin
    pad := (Width - Length(S)) div 2;
    CenterStr := StringOfChar(' ', pad) + S + StringOfChar(' ', Width - pad - Length(S));
end;

{Pomocna funkcija koja renderuje samo jednu sobu}
procedure RenderRoomBig(room: TRoom);
begin
    TextColor(White);
    WriteLn('+==========================================+');

    TextColor(LightBlue);
    WriteLn('| ', CenterStr(UpCase(room.Name), 38), '  |');
    TextColor(White);

    WriteLn('+------------------------------------------+');
    WriteLn('| Broj kreveta : ', room.NumberOfBeds:2, '                       |');
    WriteLn('| Povrsina     : ', room.Area:3, ' m2                   |');

    if room.Balcony = 'yes' 
        then WriteLn('| Balkon       : Da                       |')
        else WriteLn('| Balkon       : Ne                       |');

    WriteLn('| Cena         : $', room.PricePN:0, ' po danu             |');
    WriteLn('+------------------------------------------+');
    WriteLn('| ID sobe      : ', room.ID:4, '                     |');
    WriteLn('+==========================================+');
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
    ys,ms,ds: Word;
    reservationDates: TReservationDateArray;
    startDate: String;
    endDate: String;
    userTempTDateTimeFrom: TDateTime;
    userTempTDateTimeTo: TDateTime;
    errorCounter: Integer;
    {Podaci za rezervaciju}
    JMBG: String;
    FirstName: String;
    LastName: String;
    InputDateFrom: String;
    InputDateTo:String;
    TotalPrice: Real;
    ReserveRecordTemp: TReservation;

begin 
    ClrScr;
    {Proveravamo koliko rezervacija imamo za sobu koju je korisnik uneo}
    howManyReservations := 0;
    errorCounter := 0;
    ys := 0;
    ms := 0;
    ds := 0;
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
                    WriteLn('+------------------------------------------+');

                    WriteLn('| Od: ', reservations[i].CheckIn:10, ' | Do: ', reservations[i].CheckOut:10,                           '|');

                    WriteLn('+------------------------------------------+');
                    TextColor(White);
                end;
        end;
    
    if howManyReservations = 0 then
        begin
            TextColor(LightRed);
            WriteLn('+==========================================+');
            WriteLn('|           SOBA NEMA REZERVACIJA          |');
            WriteLn('+==========================================+');
            TextColor(White);
        end;

        
    {Repeat petlja koja se ponavlja dok korisnik ne unese datum za kraj rezervacije koja je veca od pocetka rezervacije}
    repeat
        {Unos podataka o pocetku rezervacije - Proveravamo repeat petljom i da li je datum pre danasnjeg}
        repeat
            Write('Unesite datum pocetka rezervacije (YYYY-MM-DD): '); ReadLn(startDate);
            {Parsiranje i Poredjenje korisnikovih datuma sa postojecim rezervacijama}
            y := StrToInt(Copy(startDate, 1, 4));
            m := StrToInt(Copy(startDate, 6, 2));
            d := StrToInt(Copy(startDate, 9, 2));
            userTempTDateTimeFrom := EncodeDate(y, m, d);   
            if (userTempTDateTimeFrom < now) then 
                begin 
                    WriteLn('Ne mozete izabrati datum pocetka rezervacije pre danasnjeg dana. Molimo Vas da unesete datume ponovo.')
                end;
        until (userTempTDateTimeFrom > now);

        {Unos podataka o kraju rezervacije}
        Write('Unesite datum kraja rezervacije (YYYY-MM-DD): ');ReadLn(endDate);
        y := StrToInt(Copy(endDate, 1, 4));
        m := StrToInt(Copy(endDate, 6, 2));
        d := StrToInt(Copy(endDate, 9, 2));
        userTempTDateTimeTo := EncodeDate(y, m, d);
        
        if (userTempTDateTimeFrom >= userTempTDateTimeTo) then 
            WriteLn('Ne mozete uneti datum kraja rezervacije koji je pre pocetka rezervacije. Molimo Vas da uneste datume ponovo:');

    until (userTempTDateTimeFrom < userTempTDateTimeTo);

    for i := 1 to howManyReservations do
        begin
            // Ako se opseg uopšte preklapa sa postojećim
            if not ((userTempTDateTimeTo < reservationDates[i].fromDate) or (userTempTDateTimeFrom > reservationDates[i].toDate)) then
            begin
                errorCounter := errorCounter + 1;
            end;
        end;
    {Ako postoji greska}
    if errorCounter > 0 then
        begin 
            WriteLn('Ne mozete rezervisati sobu u zeljenom periodu.');
            WriteLn('Pritisnite <Enter> Da se vratite korak nazad.');
        end
    else
        begin
            Write('Unesite JMBG: ');ReadLn(JMBG);
            Write('Unesite ime: ');ReadLn(FirstName);
            Write('Unesite prezime: ');ReadLn(LastName);
            {startDate}
            {endDate}

            DecodeDate(userTempTDateTimeFrom, ys, ms, ds);
            InputDateFrom := IntToStr(ys) + '-' + IntToStr(ms) + '-' + IntToStr(ds);

            DecodeDate(userTempTDateTimeTo, ys, ms, ds);
            InputDateTo := IntToStr(ys) + '-' + IntToStr(ms) + '-' + IntToStr(ds);

            ReserveRecordTemp.JMBG := JMBG;
            ReserveRecordTemp.Name := FirstName;
            ReserveRecordTemp.Surname := LastName;
            ReserveRecordTemp.RoomId := RoomID;
            ReserveRecordTemp.CheckIn := InputDateFrom;
            ReserveRecordTemp.CheckOut := InputDateTo;
            ReserveRecordTemp.TotalPrice := room.PricePN * DaysBetween(userTempTDateTimeFrom, userTempTDateTimeTo);

            reservations[numberOfReservations + 1] := ReserveRecordTemp;
            writeln('Ukupno za placanje: $', ReserveRecordTemp.TotalPrice:0:2);
            WriteLn('Rezervacija uspesno dodata');
            
        end;

        {OVDE RADIM UNOS U FAJL}

        {OVDE KRAJ}
        writeln('Pritisni < Enter > da bi se vratio u prethodni meni');
end;

{********** MILOS SAVKOVIC **********}
{Ovde sam ti napravio ovu Universal Filter proceduru }
{Radi po istom principu kao i filter funkcija}
procedure UniversalSort(var roomsArray: TRoomArray; numberOfRooms: Integer; sortType: Integer; var reservationsArray: TReservationArray; numberOfReservations: Integer);
    var
    i: Integer;
    roomID: Char;
    roomIDInt: Integer;
    startTime, endTime: TDateTime;
    elapsedMS: Int64;
    sortOrder: Integer;  // 1 = ascending, 2 = descending
    begin
        textColor(Green);
        Write('Enter the sorting direction (1 for Ascending, 2 for Descending): ');
        textColor(White);

        ReadLn(sortOrder);

        {Uzimamo frekvenciju tajmera (npr. 3.1 GHz timer, zavisi od CPU)}
        QueryPerformanceFrequency(Freq);

        {Start merenja}
        QueryPerformanceCounter(StartC);
        {Sortiranje}
        QuickSort(roomsArray, 1, numberOfRooms, sortType, sortOrder); 
        {Kraj merenja}
        QueryPerformanceCounter(EndC);

        ClrScr;

        RenderRoomTableHeader;
        for i := 1 to numberOfRooms do
            RenderRoomTable(roomsArray[i]);

        {Ispis i izracunavanje brzine sortiranja}
        TextColor(LightCyan);
        WriteLn('---------------------------------------------------------------------------------------');
        {izračunavanje vremena u mikrosekundama}
        ElapsedMicro := (EndC - StartC) * 1e6 / Freq;
        writeln('Proteklo vreme sortiranja: ', ElapsedMicro:0:2, ' mikrosekundi');

        TextColor(Green);
        WriteLn('---------------------------------------------------------------------------------------');
        Write('Choose the ID of the room you want to reserve, or "E" to go the previous menu: ');
        ReadLn(roomID);
        textColor(White);
        if LowerCase(RoomID) = 'e' then
            begin
                writeln('Returning to previous menu...');
                delay(1500);
                exit;
            end;
        TextColor(White);
        val(roomID, roomIDInt);
        {Rezervacija Selektovane sobe}
        Reserve(roomIDInt, roomsArray[roomIDInt], reservationsArray, numberOfReservations);

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
        WriteLn('Sorting options by:');
        WriteLn('1) Number of beds');
        WriteLn('2) Room area');
        WriteLn('3) Price');
        WriteLn('4) Balcony availability');
        WriteLn('e) Press "e" to exit sorting options');
        
        TextColor(Green);
        WriteLn('---------------------------------------');
        Write('Select an option by pressing key: '); ReadLn(menuKey);
        writeln;
        TextColor(White);
 
        case menuKey of
            '1': UniversalSort(roomsArray, numberOfRooms, 1, reservationsArray, numberOfReservations);
            '2': UniversalSort(roomsArray, numberOfRooms, 2, reservationsArray, numberOfReservations);
            '3': UniversalSort(roomsArray, numberOfRooms, 3, reservationsArray, numberOfReservations);
            '4': UniversalSort(roomsArray, numberOfRooms, 4, reservationsArray, numberOfReservations);
        end;
 
    until (menuKey = 'e');
    writeln('Returning to previous menu...');
    delay(1000);
    ClrScr;
    exit;
end;
 

{Pomocna filter funkcija koja obavlja proces filtriranja, na osnovu zadatih parametara}
procedure UniversalFilter(var roomsArray: TRoomArray; numberOfRooms: Integer; filterType: Integer; var reservationsArray: TReservationArray; numberOfReservations: Integer);
    var
        i: Integer;
        userOption: Integer;
        roomID: Char;
        roomIDInt: Integer;
        counter: Integer;
 
        {userOptionString varijabla nam je potrebna zbog Balkon filtera}
        {Korisnik unosi Y ili N - Zapravo da li zeli balkon ili ne}
        {I zato smo morali da napravimo i string varijablu}
        userOptionString: String; 
    begin
        case filterType of
            {Broj Soba Filter}
            1:  begin
                    ClrScr;
                    counter := 0;
                    TextColor(Red);
                    Write('Enter number of beds: ');ReadLn(userOption);
                    RenderRoomTableHeader;

                    {Uzimamo frekvenciju tajmera (npr. 3.1 GHz timer, zavisi od CPU)}
                    QueryPerformanceFrequency(Freq);

                    {Start merenja}
                    QueryPerformanceCounter(StartC);
                    for i:= 1 to numberOfRooms do
                        begin 
                            if roomsArray[i].NumberOfBeds = userOption then
                                begin
                                    counter := counter + 1;
                                    // WriteLn(roomsArray[i].Name);
                                    // {Ovde bi trebalo uneti funkciju koja renderuje sobe}
                                    // RenderRoom(roomsArray[i]);
                                    WriteLn(Format('%-5d %-20s %-12d %-12d %-10s $%-12d',
                                            [roomsArray[i].Id, roomsArray[i].Name, roomsArray[i].NumberOfBeds, roomsArray[i].Area, roomsArray[i].Balcony, roomsArray[i].PricePN]));

                                end;
                        end;
                    QueryPerformanceCounter(EndC);

                    {Ispis i izracunavanje brzine sortiranja}
                    TextColor(LightCyan);
                    WriteLn('---------------------------------------------------------------------------------------');
                    {izračunavanje vremena u mikrosekundama}
                    ElapsedMicro := (EndC - StartC) * 1e6 / Freq;
                    writeln('Sorting time: ', ElapsedMicro:0:2, ' microseconds');  

                    if counter > 0 then
                        begin
                            TextColor(Green);
                            WriteLn('---------------------------------------------------------------------------------------');
                            Write('Choose the ID of the room you want to reserve, or "E" to go the previous menu: ');
                            ReadLn(roomID);
                            TextColor(White);
                            if LowerCase(RoomID) = 'e' then
                                begin
                                    writeln('Returning to previous menu...');
                                    delay(1500);
                                    exit;
                                end;
                            TextColor(White);
                            val(roomID, roomIDInt);
                            {Rezervacija Selektovane sobe}
                            Reserve(roomIDInt, roomsArray[roomIDInt], reservationsArray, numberOfReservations);
                        end
                    else
                        begin
                            TextColor(LightRed);
                            WriteLn('---------------------------------------------------------------------------------------');
                            WriteLn('There are no rooms matching your criteria.');
                            write('Press <Enter> to return to the previous menu.');
                            TextColor(White);
                            ReadKey;
                        end;
                end;
            {Povrsina Filter}
            {Ovde filtriramo do odredjene povrsine, trazimo sobe koje su manje ili jednake od korisnikovog unosa}
            2:  begin
                    ClrScr;
                    counter := 0;   

                    TextColor(Red);
                    Write('Enter minimum area of room: ');ReadLn(userOption);
                    TextColor(White);
                    RenderRoomTableHeader;

                    {Uzimamo frekvenciju tajmera (npr. 3.1 GHz timer, zavisi od CPU)}
                    QueryPerformanceFrequency(Freq);

                    {Start merenja}
                    QueryPerformanceCounter(StartC);
                    {Filter za pronalazak soba do povrsine koje je korisnik uneo}
                    for i:= 1 to numberOfRooms do
                        begin 
                            if roomsArray[i].Area >= userOption then
                                begin
                                    counter := counter + 1;
                                    // WriteLn(roomsArray[i].Name);
                                    // {Ovde bi trebalo uneti funkciju koja renderuje sobe}
                                      WriteLn(Format('%-5d %-20s %-12d %-12d %-10s $%-12d',
                                            [roomsArray[i].Id, roomsArray[i].Name, roomsArray[i].NumberOfBeds, roomsArray[i].Area, roomsArray[i].Balcony, roomsArray[i].PricePN]));

                                end;
                        end;
                    QueryPerformanceCounter(EndC);

                    {Ispis i izracunavanje brzine sortiranja}
                    TextColor(LightCyan);
                    WriteLn('---------------------------------------------------------------------------------------');
                    {izračunavanje vremena u mikrosekundama}
                    ElapsedMicro := (EndC - StartC) * 1e6 / Freq;
                    writeln('Proteklo vreme sortiranja: ', ElapsedMicro:0:2, ' mikrosekundi');

                    if counter > 0 then
                        begin
                            TextColor(Green);
                            WriteLn('---------------------------------------------------------------------------------------');
                            Write('Choose the ID of the room you want to reserve, or "E" to go the previous menu: ');
                            ReadLn(roomID);
                            textColor(White);
                            if LowerCase(RoomID) = 'e' then
                                begin
                                    writeln('Returning to previous menu...');
                                    delay(1500);
                                    exit;
                                end;
                            TextColor(White);
                            val(roomID, roomIDInt);
                            {Rezervacija Selektovane sobe}
                            Reserve(roomIDInt, roomsArray[roomIDInt], reservationsArray, numberOfReservations);
                        end
                    else
                        begin
                            TextColor(LightRed);
                            WriteLn('---------------------------------------------------------------------------------------');
                            WriteLn('There are no rooms matching your criteria.');
                            write('Press <Enter> to return to the previous menu.');
                            TextColor(White);
                            ReadKey;
                        end;
                end;
            {Cena Filter}
            {Ovde filtriramo sve sobe do cene koju je korisnik uneo}
            3:  begin
                    ClrScr;
                    counter := 0;
                    TextColor(Red);
                    Write('Maximum price per night: ');ReadLn(userOption);
                    TextColor(White);
                    RenderRoomTableHeader;

                    {Uzimamo frekvenciju tajmera (npr. 3.1 GHz timer, zavisi od CPU)}
                    QueryPerformanceFrequency(Freq);

                    {Start merenja}
                    QueryPerformanceCounter(StartC);

                    {Filter za pronalazak soba do povrsine koje je korisnik uneo}
                    for i:= 1 to numberOfRooms do
                        begin 
                            if roomsArray[i].PricePN >= userOption then
                                begin
                                    counter := counter + 1;
                                    {Renderovanje sobe}
                                    WriteLn(Format('%-5d %-20s %-12d %-12d %-10s $%-12d',
                                            [roomsArray[i].Id, roomsArray[i].Name, roomsArray[i].NumberOfBeds, roomsArray[i].Area, roomsArray[i].Balcony, roomsArray[i].PricePN]));
                                end;
                        end;
                    
                    QueryPerformanceCounter(EndC);
                    
                    {Ispis i izracunavanje brzine sortiranja}
                    TextColor(LightCyan);
                    WriteLn('---------------------------------------------------------------------------------------');
                    {izračunavanje vremena u mikrosekundama}
                    ElapsedMicro := (EndC - StartC) * 1e6 / Freq;
                    writeln('Proteklo vreme sortiranja: ', ElapsedMicro:0:2, ' mikrosekundi');

                    if counter > 0 then
                        begin
                            TextColor(Green);
                            WriteLn('---------------------------------------------------------------------------------------');
                            Write('Choose the ID of the room you want to reserve, or "E" to go the previous menu: ');
                            ReadLn(roomID);
                            textColor(White);
                            if LowerCase(RoomID) = 'e' then
                                begin
                                    writeln('Returning to previous menu...');
                                    delay(1500);
                                    exit;
                                end;
                            TextColor(White);
                            val(roomID, roomIDInt);
                            {Rezervacija Selektovane sobe}
                            Reserve(roomIDInt, roomsArray[roomIDInt], reservationsArray, numberOfReservations);
                        end
                    else
                        begin
                            TextColor(LightRed);
                            WriteLn('---------------------------------------------------------------------------------------');
                            WriteLn('There are no rooms matching your criteria.');
                            write('Press <Enter> to return to the previous menu.');
                            TextColor(White);
                            ReadKey;
                        end;
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

                    RenderRoomTableHeader;

                    {Ako je korisnik uneo 'Y' - Izlistavamo sobe SA balkonom}
                    if LowerCase(userOptionString[1]) = 'y' then
                        begin 

                            for i:= 1 to numberOfRooms do
                            begin 
                                if roomsArray[i].Balcony = 'yes' then
                                    begin
                                        WriteLn(Format('%-5d %-20s %-12d %-12d %-10s $%-12d',
                                                [roomsArray[i].Id, roomsArray[i].Name, roomsArray[i].NumberOfBeds, roomsArray[i].Area, roomsArray[i].Balcony, roomsArray[i].PricePN]));
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
                                        WriteLn(Format('%-5d %-20s %-12d %-12d %-10s $%-12d',
                                                [roomsArray[i].Id, roomsArray[i].Name, roomsArray[i].NumberOfBeds, roomsArray[i].Area, roomsArray[i].Balcony, roomsArray[i].PricePN]));
                                    end;
                            end;
                        end;

                
                    TextColor(Green);
                    WriteLn('---------------------------------------------------------------------------------------');
                    Write('Choose the ID of the room you want to reserve, or "E" to go the previous menu: ');
                    ReadLn(roomID);
                    textColor(White);
                    if LowerCase(RoomID) = 'e' then
                        begin
                            writeln('Returning to previous menu...');
                            delay(1500);
                            exit;
                        end;
                    TextColor(White);
                    val(roomID, roomIDInt);
                    {Rezervacija Selektovane sobe}
                    Reserve(roomIDInt, roomsArray[roomIDInt], reservationsArray, numberOfReservations);
                        
                  
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
            WriteLn('Filter options:');
            WriteLn('1) By number of beds');
            WriteLn('2) By minimum room area');
            WriteLn('3) By minimum price');
            WriteLn('4) By balcony availability');
            WriteLn('e) Press "e" to exit filter options');

            {Option selection - User must press 1, 2, 3, 4 or "e" to exit}
            TextColor(Green);
            WriteLn('---------------------------------------');
            Write('Select an option by pressing a key: '); ReadLn(menuKey);
            writeln;
            TextColor(White);

                case menuKey of
                    '1': UniversalFilter(roomsArray, numberOfRooms, 1, reservationsArray, numberOfReservations); 
                    '2': UniversalFilter(roomsArray, numberOfRooms, 2, reservationsArray, numberOfReservations); 
                    '3': UniversalFilter(roomsArray, numberOfRooms, 3, reservationsArray, numberOfReservations);
                    '4': UniversalFilter(roomsArray, numberOfRooms, 4, reservationsArray, numberOfReservations);
                end;
            
        until (menuKey = 'e');
        writeln('Returning to previous menu...');
        delay(1000);
        ClrScr;
        exit;
    end;


function RenderAllRooms(roomsArray: TRoomArray; numberOfRooms: Integer):TRoomArray;
begin
    ClrScr;
    WriteLn('Render All Rooms');
    RenderAllRooms := roomsArray;
    ReadKey;
end;

procedure SearchRooms(var roomsArray: TRoomArray; numberOfRooms: Integer; var reservationsArray: TReservationArray; numberOfReservations: Integer);
    var
        y,m,d: Word;
        userTempTDateTimeFrom: TDateTime;
        userTempTDateTimeTo: TDateTime;
        startDate, endDate: String;
        guestsUI: String;
        numberOfGuests, error: Integer; 
        roomsTemp: TRoomArray;
    begin 
        ClrScr;
        repeat
            {Unos podataka o pocetku rezervacije - Proveravamo repeat petljom i da li je datum pre danasnjeg}
            repeat
                Write('Enter the reservation start date (YYYY-MM-DD): '); ReadLn(startDate);
                {Parsiranje i Poredjenje korisnikovih datuma sa postojecim rezervacijama}
                y := StrToInt(Copy(startDate, 1, 4));
                m := StrToInt(Copy(startDate, 6, 2));
                d := StrToInt(Copy(startDate, 9, 2));
                userTempTDateTimeFrom := EncodeDate(y, m, d);   
                if (userTempTDateTimeFrom < now) then 
                    begin 
                         WriteLn('You cannot choose a reservation start date earlier than today. Please enter the dates again.');
                    end;
            until (userTempTDateTimeFrom > now);

            {Unos podataka o kraju rezervacije}
            Write('Enter the reservation end date (YYYY-MM-DD): '); ReadLn(endDate);
            y := StrToInt(Copy(endDate, 1, 4));
            m := StrToInt(Copy(endDate, 6, 2));
            d := StrToInt(Copy(endDate, 9, 2));
            userTempTDateTimeTo := EncodeDate(y, m, d);
        
            if (userTempTDateTimeFrom >= userTempTDateTimeTo) then 
            WriteLn('You cannot enter a reservation end date that is earlier than the start date. Please enter the dates again.');

        until (userTempTDateTimeFrom < userTempTDateTimeTo);

        {Upit za broj osoba}
        repeat
            Write('Number of guests: ');
            ReadLn(guestsUI);
            val(guestsUI, numberOfGuests, error);        
        until (error = 0);

        {ROOMS - sve sobe}
          

        writeln;
        writeln;
        writeln('Press <Enter> to go back'); ReadKey;
        ClrScr;
    end;