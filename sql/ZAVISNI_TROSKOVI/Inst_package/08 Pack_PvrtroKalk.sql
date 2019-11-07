-- Package PVrstaTroskovaKalk
CREATE OR REPLACE PACKAGE INVEJ.PVrstaTroskovaKalk Is
   -- Funkcija vraca naziv dokumenta na osnovu sifre dokumenta
   -- ili NULL ako ne postoji naziv za prosledjenu sifru
   Function Naziv( cVrsta VarChar2 ) return VarChar2 ;
End; 
/              
CREATE PUBLIC SYNONYM PVRSTATROSKOVAKALK
    FOR INVEJ.PVRSTATROSKOVAKALK
/
GRANT EXECUTE ON Invej.PVRSTATROSKOVAKALK TO EXE
