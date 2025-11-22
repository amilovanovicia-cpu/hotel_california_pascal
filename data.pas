type
TRoom = record
    Id: String;
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
    RoomNumber: Integer;
    CheckIn: string;   // YYYY-MM-DD
    CheckOut: string;  // YYYY-MM-DD
    TotalPrice: Real;
end;

TRoomArray = array[1..12] of TRoom;