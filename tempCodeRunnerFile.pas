
      WriteLn('Greška pri čitanju datoteke.');
    end;

    on E: Exception do
    begin
      WriteLn('Moramo prekinuti rad.');
      WriteLn('Poruka: ', E.Message);
    end;
  end;
end.
