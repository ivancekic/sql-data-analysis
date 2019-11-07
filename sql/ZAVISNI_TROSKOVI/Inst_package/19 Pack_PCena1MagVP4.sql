Create or replace Package rubin.PCena1MagVP4 Is
   -- funkcija poslednju vraca cenu1 za proizvod koji je u VP4
   -- ili 0 ako cena1 ne postoji
   -- u nalogu kod magacina VP4 su cena i cena1 iste
   Function MagVP4Cena1( nOrgDeo Number, cProizvod Varchar2 ) Return Number;
End;

/
CREATE PUBLIC SYNONYM PCena1MagVP4
    FOR rubin.PCena1MagVP4
/
GRANT EXECUTE ON rubin.PCena1MagVP4 TO EXE
