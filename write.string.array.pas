function WriteStringArray(DatName: String; var x:array of String; N:Integer): Integer;
{ Upisuje niz stringova u tekstualnu datoteke          }
{ DatName - ime tekstualne datoteka                    }
{       format: na svakoj liniji po jedan string       }
{ x - niz stringova                                    }
{ Povratna vrednost: broj upisanih elemenata niza      }
{                    -1 u slucaju greske               }
{ Zavisnosti: zahteva                                  }
{             - jedinicu SysUtils i                    }
{             - ukljucenje $MODE OBJFPC direktive      }

var
    Dat:Text;   { datoteka u koju se pise }
    nOut: Integer; { brojac clanova niza }
begin
    try
        begin
            Assign(Dat, DatName);
            Rewrite(Dat);
            for nOut:= 0 to N-2 do
                    WriteLn(Dat,x[nOut]);
            Write(Dat,x[N-1]); { iza poslednjeg reda ne dodajemo novu liniju }
        end
    except
        on E:Exception do nOut:=-1;
    end;
    Close(Dat);
    WriteStringArray:=N;
end;