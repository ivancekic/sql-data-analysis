Declare
   nGod    Number      := 2008 ;
   cVrDok  Varchar2(3) := 3 ;
   cBrDok  Varchar2(7) := 2 ;

   nStavki NUMBER;
   nUkupno NUMBER;
   nTipPro Number;


Begin
   PDokument.Ukupno( nGod, cBrDok, cVrDok, nStavki, nUkupno );
   If nStavki > 0 Then
      nTipPro := PDokument.TipProizvodaPrveStavke(  nGod, cBrDok, cVrDok);
   Else
      nTipPro := NULL;
   End If;
     DBMS_OUTPUT.PUT_LINE (' god  vr   BrDok uk st          Ukupno');
     DBMS_OUTPUT.PUT_LINE ('---- --- ------- ----- ---------------');

     DBMS_OUTPUT.PUT_LINE (LPAD(to_char(nGod),4)     ||' '||
                           LPAD(cVrDok,3)            ||' '||
                           LPAD(cBrDok,7)            ||' '||
                           LPAD(to_char(nStavki),5)  ||' '||
                           LPAD(to_char(nUkupno,'99999999999.90'),15)
                          );

End;
