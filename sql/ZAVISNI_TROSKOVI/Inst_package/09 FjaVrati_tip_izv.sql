CREATE OR REPLACE FUNCTION INVEJ.VRATITIPIZVOZA(BrMagacina In Number) Return VarChar2 Is
-- funkcija vraca tip izvoza za dati magacin

 TipIzvoza VarChar2(30) ;
 Begin
 
   Select ORG_DEO_OSN_PODACI.DIREKTAN_IZVOZ into TipIzvoza
   From ORG_DEO_OSN_PODACI
   Where ORG_DEO_OSN_PODACI.ORG_DEO = BrMagacina ;
   return TipIzvoza;
   exception
	when no_data_found then
	return 'NE';
 End ;
/
CREATE PUBLIC SYNONYM VRATITIPIZVOZA
    FOR INVEJ.VRATITIPIZVOZA
/
GRANT EXECUTE ON INVEJ.VRATITIPIZVOZA TO EXE