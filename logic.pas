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
        close(Dat);
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
        close(Dat);
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
    {Umesto moje funkcije za renderovanje, pozvao sam Miloseve za render, zauzimaju manje prostora}
    RenderRoomTableHeader;
    RenderRoomTable(room);
    TextColor(LightCyan);
    WriteLn('---------------------------------------------------------------------------------------');
    TextColor(White);
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
    Dat: Text;

begin 
    ClrScr;
    {Apdejtovanje svih rezervacija}
    AssignFile(Dat, 'reservations.txt');
    Reset(Dat);
    numberOfReservations := ReadReservations('reservations.txt', reservations);
    CloseFile(Dat);
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
                            WriteLn('RESERVATIONS');
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
            WriteLn('|      ROOM DOESN''T HAVE RESERVATIONS     |');
            WriteLn('+==========================================+');
            TextColor(White);
        end;

        
    {Repeat petlja koja se ponavlja dok korisnik ne unese datum za kraj rezervacije koja je veca od pocetka rezervacije}
    repeat
        {Unos podataka o pocetku rezervacije - Proveravamo repeat petljom i da li je datum pre danasnjeg}
        repeat
            Write('Enter the start date for your reservation (YYYY-MM-DD): '); ReadLn(startDate);
            {Parsiranje i Poredjenje korisnikovih datuma sa postojecim rezervacijama}
            y := StrToInt(Copy(startDate, 1, 4));
            m := StrToInt(Copy(startDate, 6, 2));
            d := StrToInt(Copy(startDate, 9, 2));
            userTempTDateTimeFrom := EncodeDate(y, m, d);   
            if (userTempTDateTimeFrom < now) then 
                begin 
                    WriteLn('The reservation start date cannot be earlier than today. Please enter the dates again.')
                end;
        until (userTempTDateTimeFrom > now);

        {Unos podataka o kraju rezervacije}
        Write('Enter the end date for your reservation (YYYY-MM-DD): ');ReadLn(endDate);
        y := StrToInt(Copy(endDate, 1, 4));
        m := StrToInt(Copy(endDate, 6, 2));
        d := StrToInt(Copy(endDate, 9, 2));
        userTempTDateTimeTo := EncodeDate(y, m, d);
        
        if (userTempTDateTimeFrom >= userTempTDateTimeTo) then 
            WriteLn('The reservation end date cannot be earlier than the start date. Please re-enter the dates:');

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
            WriteLn('The room is not available for the selected time period.');
            WriteLn('Press <Enter> to return to the previous menu.'); ReadKey;
            writeln('Returning to previous menu...');
            delay(1000);
            exit;
        end
    else
        begin
            Write('Enter your Personal ID number:');ReadLn(JMBG);
            Write('Enter your first name: ');ReadLn(FirstName);
            Write('Enter your last name: ');ReadLn(LastName);
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

            AssignFile(Dat, 'reservations.txt');
            Append(Dat);

            WriteLn(Dat, ReserveRecordTemp.JMBG);
            WriteLn(Dat, ReserveRecordTemp.Name);
            WriteLn(Dat, ReserveRecordTemp.Surname);
            WriteLn(Dat, ReserveRecordTemp.RoomId);
            WriteLn(Dat, startDate);
            WriteLn(Dat, endDate);
            WriteLn(Dat, ReserveRecordTemp.TotalPrice:0:2);
            writeln(Dat);
            CloseFile(Dat);
            TextColor(Green);
            writeln('You have successfully reserved the room ', room.Name, ' from ', startDate, ' to ', endDate, '. Total price is $', ReserveRecordTemp.TotalPrice:0:2);
            TextColor(White);
            end;
            writeln('Press <Enter> to return to the previous menu.');
            ReadKey;
            ClrScr;
            exit;
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
        writeln('Sorting time: ', ElapsedMicro:0:2, ' microseconds');

        TextColor(Green);
        WriteLn('---------------------------------------------------------------------------------------');
        Write('Choose the ID of the room you want to reserve, or "E" to go the previous menu: ');
        ReadLn(roomID);
        textColor(White);
        if LowerCase(RoomID) = 'e' then
            begin
                writeln('Returning to previous menu...');
                delay(1000);
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
                    writeln('Sorting duration: ', ElapsedMicro:0:2, ' microseconds');  

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
                                    delay(1000);
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
                    writeln('Sorting duration: ', ElapsedMicro:0:2, ' microseconds');

                    if counter > 0 then
                        begin
                            TextColor(Green);
                            WriteLn('---------------------------------------------------------------------------------------');
                            Write('Choose the ID of the room you want to reserve, or "E" to go the previous menu: ');
                            ReadLn(roomID);
                            textColor(White);
                            if LowerCase(RoomID) = 'e' then
                                begin
                                    writeln;
                                    writeln('Returning to previous menu...');
                                    delay(1000);
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
                            writeln('Press <Enter> to return to the previous menu.');
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
                    writeln('Sorting duration: ', ElapsedMicro:0:2, ' mikrosekundi');

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
                                    delay(1000);
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
                        Write('Balcony (Y/N). This field is required. Press "E" to exit. ');ReadLn(userOptionString);
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
                            writeln;
                            writeln('Returning to previous menu...');
                            delay(1000);
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
            WriteLn('e) Press "E" to exit filter options');

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


function SearchReservations(roomsArray: TRoomArray; numberOfRooms: Integer; var reservationsArray: TReservationArray; numberOfReservations: Integer):TRoomArray;
var
    personalID: String;
    i: Integer;
    ID: Char;
    IDInt: Integer;
    error: Integer;
    ReservationsToDelete: TReservationArray;
    ReservationsToCancel: TReservationArray;
begin
    error := 0;
    ClrScr;
    WriteLn('Please enter your Personal ID number: ');ReadLn(personalID);
    ClrScr;
    WriteLn('*** RESERVATIONS ***');
    textColor(LightCyan);
    WriteLn('---------------------------------------------------------------------------------------------');
    for i := 1 to numberOfRooms do
        begin
            if reservationsArray[i].JMBG = personalID then
                begin
                    writeln('Room ID: ', reservationsArray[i].RoomId, ' | Name: ', reservationsArray[i].Name ,' | Check-In: ', reservationsArray[i].CheckIn, ' | Check-Out: ', reservationsArray[i].CheckOut, ' | Total Price: $', reservationsArray[i].TotalPrice:0:2);
                    WriteLn('---------------------------------------------------------------------------------------------');
                end;
        end;
    textColor(White);
    TextColor(Green);
    Write('Select ID of the reservation you want to cancel the reservation for, or "E" to go back to the previous menu: ');
    textColor(White);
    ReadLn(ID);

    
    if LowerCase(ID) = 'e' then
        begin
            writeln('Returning to previous menu...');
            delay(1000);
            ClrScr;
            exit;
        end;

    {Brisanje rezervacije}
    val(ID, IDInt, error);

    while error <> 0 do
        begin
            write('Select ID of the reservation you want to cancel the reservation for');ReadLn(ID);
        end;

    for i := 1 to numberOfReservations do
        begin
            if (reservationsArray[i].RoomId = IDInt) AND (reservationsArray[i].JMBG = personalID) then
                begin
                    writeln('You have successfully canceled your reservation for room ID ', reservationsArray[i].RoomId, ' from ', reservationsArray[i].CheckIn, ' to ', reservationsArray[i].CheckOut, '.');
                end;
        end;

  
end;

procedure SearchRooms(var roomsArray: TRoomArray; numberOfRooms: Integer;
                      var reservationsArray: TReservationArray; numberOfReservations: Integer);
var
  startDateStr, endDateStr: string;
  startDate, endDate: TDateTime;
  y, m, d: Word;
  numberOfGuests, error: Integer;
  guestsStr: string;
  i, j: Integer;
  roomAvailable: Boolean;
  resCheckIn, resCheckOut: TDateTime;
  roomID: String;
  roomIDInt: Integer;
  roomCounter: Integer;
begin
  ClrScr;
  roomCounter := 0;  
  // Input and validate start and end date
  repeat
    // Input start date
    repeat
      Write('Enter reservation start date (YYYY-MM-DD): ');
      ReadLn(startDateStr);
 
      try
        y := StrToInt(Copy(startDateStr, 1, 4));
        m := StrToInt(Copy(startDateStr, 6, 2));
        d := StrToInt(Copy(startDateStr, 9, 2));
        startDate := EncodeDate(y, m, d);
 
        if startDate < Date then
          WriteLn('Error: Start date cannot be in the past.')
        else
          break;
      except
        WriteLn('Error: Invalid date format! Use YYYY-MM-DD.');
      end;
    until False;
 
    // Input end date
    repeat
      Write('Enter reservation end date (YYYY-MM-DD): ');
      ReadLn(endDateStr);
 
      try
        y := StrToInt(Copy(endDateStr, 1, 4));
        m := StrToInt(Copy(endDateStr, 6, 2));
        d := StrToInt(Copy(endDateStr, 9, 2));
        endDate := EncodeDate(y, m, d);
 
        if endDate <= startDate then
          WriteLn('Error: End date must be after start date.')
        else
          break;
      except
        WriteLn('Error: Invalid date format! Use YYYY-MM-DD.');
      end;
    until False;
  until True;
 
  // Input number of guests (cannot be 0)
  repeat
    Write('Enter number of guests: ');
    ReadLn(guestsStr);
    Val(guestsStr, numberOfGuests, error);
    if (error <> 0) or (numberOfGuests <= 0) then
      WriteLn('Error: Enter a valid number greater than 0.')
    else
      break;
  until False;
 
  ClrScr;
  WriteLn('*** AVAILABLE ROOMS ***');
  WriteLn;
 
  RenderRoomTableHeader;
 
  // Loop through all rooms
  for i := 1 to numberOfRooms do
  begin
    // Check if room has enough beds
    if roomsArray[i].NumberOfBeds < numberOfGuests then
      continue;
 
    // Check availability for selected period
    roomAvailable := True;
 
    for j := 1 to numberOfReservations do
    begin
      if reservationsArray[j].RoomId = roomsArray[i].Id then
      begin
        // Parse reservation dates
        y := StrToInt(Copy(reservationsArray[j].CheckIn, 1, 4));
        m := StrToInt(Copy(reservationsArray[j].CheckIn, 6, 2));
        d := StrToInt(Copy(reservationsArray[j].CheckIn, 9, 2));
        resCheckIn := EncodeDate(y, m, d);
 
        y := StrToInt(Copy(reservationsArray[j].CheckOut, 1, 4));
        m := StrToInt(Copy(reservationsArray[j].CheckOut, 6, 2));
        d := StrToInt(Copy(reservationsArray[j].CheckOut, 9, 2));
        resCheckOut := EncodeDate(y, m, d);
 
        // If periods overlap, room is not available
        if not ((endDate < resCheckIn) or (startDate > resCheckOut)) then
        begin
          roomAvailable := False;
          break;
        end;
      end;
    end;

        // Display Room
        if roomAvailable then
            begin 
                roomCounter := roomCounter + 1;
                RenderRoomTable(roomsArray[i]);
            end;
    end;

    if (roomCounter > 0) then 
        begin 
            TextColor(Green);
            WriteLn('---------------------------------------------------------------------------------------');
            Write('Choose the ID of the room you want to reserve, or "E" to go the previous menu: ');
            ReadLn(roomID);
            TextColor(White);
            if LowerCase(RoomID) = 'e' then
                begin
                    writeln('Returning to previous menu...');
                    ClrScr;
                    delay(1000);
                    exit;
                end;
            TextColor(White);
            val(roomID, roomIDInt);
            {Rezervacija Selektovane sobe}
            Reserve(roomIDInt, roomsArray[roomIDInt], reservationsArray, numberOfReservations);
        end
    else 
        begin 
            ClrScr;
            TextColor(Red);
            writeln('No rooms available for the selected criteria. Press <Enter> to return to the previous menu.'); 
            TextColor(White);
            ReadKey;
            writeln('Returning to previous menu...');
            delay(1000);
            ClrScr;
            exit;
        end; 
end;