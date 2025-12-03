AssignFile(Dat, 'reservations.txt');
                    {Brisemo staru datoteku i pravimo novu bez otkazane rezervacije}
                    Rewrite(Dat);
                    {Upisujemo sve rezervacije iz niza nazad u fajl, osim one koja je obrisana}
                    for j := 1 to (numberOfReservations - 1) do
                        begin
                            WriteLn(Dat, reservationsArray[j].JMBG);
                            WriteLn(Dat, reservationsArray[j].Name);
                            WriteLn(Dat, reservationsArray[j].Surname);
                            WriteLn(Dat, reservationsArray[j].RoomId);
                            WriteLn(Dat, reservationsArray[j].CheckIn);
                            WriteLn(Dat, reservationsArray[j].CheckOut);    
                            WriteLn(Dat, reservationsArray[j].TotalPrice:0:2);
                            writeln(Dat);
                        end;
                     CloseFile(Dat);   


{Prebacujemo otkazanu rezervaciju u tekstualni fajl cancelovane rezervacije}
                    AssignFile(Dat, 'canceled_reservations.txt');
                    Append(Dat);
                    WriteLn(Dat, reservationsArray[i].JMBG);
                    WriteLn(Dat, reservationsArray[i].Name);
                    WriteLn(Dat, reservationsArray[i].Surname);
                    WriteLn(Dat, reservationsArray[i].RoomId);
                    WriteLn(Dat, reservationsArray[i].CheckIn);
                    WriteLn(Dat, reservationsArray[i].CheckOut);    
                    WriteLn(Dat, reservationsArray[i].TotalPrice:0:2);
                    writeln(Dat);   
                    CloseFile(Dat);
                    TextColor(Red);
                    writeln('You have successfully canceled your reservation for room ID ', reservationsArray[i].RoomId, ' from ', reservationsArray[i].CheckIn, ' to ', reservationsArray[i].CheckOut, '.');
                    TextColor(White);