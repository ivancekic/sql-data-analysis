-- Package PPreProdajniProcenat
CREATE OR REPLACE PACKAGE INVEJ.PPreProdajniProcenat Is
   -- Funkcija vraca cenu proizvoda na osnovu sifre proizvoda,datuma,valute
   -- i faktora ili NULL ako ne postoji cena za prosledjene parametre
   Function Procenat( nOrg_deo Number, dDatum Date ) Return Number ;
   Pragma Restrict_References( Procenat,  WNDS, WNPS );
End;
/      
CREATE PUBLIC SYNONYM PPREPRODAJNIPROCENAT
    FOR INVEJ.PPREPRODAJNIPROCENAT
/
GRANT EXECUTE ON Invej.PPREPRODAJNIPROCENAT TO EXE