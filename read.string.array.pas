function ReadStringArray(DatName: String; var x:array of TSoba): Integer;
{ Ucitava niz stringova iz tekstualne datoteke     }
{ DatName - ime tekstualne datoteka                }
{       format: na svakoj liniji po jedan string   }
{ x - niz stringova                                }
{ Povratna vrednost: broj ucitanih elemenata niza  }
{                    -1 u slucaju greske           }
{ Zavisnosti: zahteva                              }
{             - jedinicu SysUtils i                }
{             - ukljucenje $MODE OBJFPC direktive  }

var
    Dat:Text;   { datoteka iz koje se cita}
    n: Integer; { brojac clanova niza}
    ocitan_red: String; 
    broj_atributa_u_slogu: Integer;
    broj_elementa_u_nizu: Integer;
begin
    try
        begin

            Assign(Dat, DatName);
            Reset(Dat);

            broj_elementa_u_nizu    := 1;
            broj_atributa_u_slogu   := 1;

            while not(Eof(Dat)) do
                begin
                    {Ucitavanje pojedinacnih linija}
                    ReadLn(Dat, ocitan_red);

                    {Dok podataka u ocitanom redu, nalazimo se u rekordu}
                    if (ocitan_red <> '') then 
                        begin
                            case broj_atributa_u_slogu of
                                1: begin
                                    x[broj_elementa_u_nizu].id := ocitan_red;
                                end;
                                2: begin
                                    x[broj_elementa_u_nizu].name := ocitan_red;
                                end;
                                3: begin
                                    x[broj_elementa_u_nizu].number_of_beds := ocitan_red;
                                end;
                                4: begin
                                    x[broj_elementa_u_nizu].area := ocitan_red;
                                end;
                                5: begin
                                    x[broj_elementa_u_nizu].balcony := ocitan_red;
                                end;
                                6: begin
                                    x[broj_elementa_u_nizu].price_pn := ocitan_red;
                                end;
                                else:
                                    WriteLn('Greska');
                                broj_atributa_u_slogu := broj_atributa_u_slogu + 1;
                            end;
                        end;
                    {Ako je prazan red, preskacemo, uvecavamo counter i prelazimo u drugi element niza i drugi rekord}
                    else 
                        begin
                            broj_elementa_u_nizu := broj_elementa_u_nizu + 1;
                        end;
                    // n:=n+1;
                end;
        end
    except
        on E:Exception do n:=-1;
    end;
    Close(Dat);
    ReadStringArray:=n;
end;