type
TRoom = record
    Id: Integer;
    Name: String;
    NumberOfBeds: Integer;
    Area: Byte;
    Balcony: String;
    PricePN: Word;
end;

TReservation = record
    JMBG: string;
    Name: string;
    Surname: string;
    RoomId: Integer;
    CheckIn: string;   // YYYY-MM-DD
    CheckOut: string;  // YYYY-MM-DD
    TotalPrice: Real;
end;

TDateHelper = record
    fromDate: TDateTime;
    toDate:   TDateTime;
end;

TRoomArray = array[1..12] of TRoom;
TReservationArray = array[1..100] of TReservation;
TReservationDateArray = array[1..100] of TDateHelper;