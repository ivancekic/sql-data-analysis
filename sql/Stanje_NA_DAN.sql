Declare
   dDatumPS Date;
   nGodinaPS Number;
   cBrojPS VarChar2( 9 );
   lImaPS Boolean;      -- da li uopste postoji PS ili ne

   nOrg_Deo  Number      := 159;
   dDatum    Date        := Sysdate;
   cProizvod Varchar2(7) := 

   Cursor StanjePS( nOrg_deo Number, dDatumPS Date , cProizvod Varchar2 ) is
   Select Org_Deo , Proizvod,
          Sum( Round( Decode( D.Vrsta_Dok || Tip_Dok,
                              '314', Kolicina,
                              '414', Kolicina,
                              Realizovano ) * Faktor * K_Robe, 5 ) ) Stanje
--                              ,
--          Sum( Round( NVL(Kolicina_Kontrolna, 0 ) * K_Robe, 5 ) ) Kontrolna
   From Dokument d , Stavka_Dok sd
   Where D.Vrsta_Dok = SD.Vrsta_Dok And
         D.Broj_Dok  = SD.Broj_Dok And
         D.Godina    = SD.Godina And
         Org_Deo = nOrg_Deo And  Status > 0 And
         D.Vrsta_Dok = '21' And
         Datum_Dok = dDatumPS
   Group By Org_Deo , Proizvod
   ORDER BY TO_NUMBER(PROIZVOD);

   Cursor Stanje( nOrg_deo Number, dDatumPS Date , cProizvod Varchar2  ) is
   Select Org_deo , Proizvod,                      -- Lokacija, Lot_Serija, Rok,
          Sum( Round( Decode( D.Vrsta_Dok || Tip_Dok,
                              '314', Kolicina,
                              '414', Kolicina,
                              Realizovano ) * Faktor * K_Robe, 5 ) ) Stanje
--                              ,
--          Sum( Round( NVL(Kolicina_Kontrolna, 0 ) * K_Robe, 5 ) ) Kontrolna
   From Dokument d , Stavka_Dok sd
   Where D.Vrsta_Dok = SD.Vrsta_Dok And
         D.Broj_Dok = SD.Broj_Dok And
         D.Godina = SD.Godina And
         Org_Deo = nOrg_Deo And  Status > 0 And
         Datum_Dok Between dDatumPS And dDatum
         And K_Robe != 0
   Group By Org_Deo , Proizvod  -- , Lokacija, Lot_Serija, Rok;
   ORDER BY TO_NUMBER(PROIZVOD);

/*
   Cursor Zaliha( nOrg_Deo Number ) Is
   Select Proizvod,
          Sum( Kolicina ) Stanje,
          Sum( Kolicina_Kontrolna ) Kontrolna
   From Zalihe_Analitika
   Where Org_Deo = nOrg_Deo
   Group By Proizvod;
*/
   nDummy Number;
Begin
   -- odredjuje se datum poslednjeg pocetnog stanja
   Select Max( Datum_Dok )
   Into dDatumPS
   From Dokument
   Where Vrsta_Dok = '21' And
         Org_Deo = nOrg_Deo And
         Status > 0 And
         Datum_Dok <= dDatum;

   If dDatumPS Is NOT NULL Then
      lImaPS := TRUE;

      Select Max( Broj_Dok ), Max( Godina )
      Into cBrojPS, nGodinaPS
      From Dokument
      Where Vrsta_Dok = '21' And
            Org_Deo   = nOrg_Deo And
            Datum_Dok = dDatumPS;
   Else
      lImaPS := FALSE;

      Select NVL( Min( Datum_Dok ), dDatum )
      Into dDatumPS
      From Dokument
      Where Org_Deo = nOrg_Deo And
            Status > 0 And
            Datum_Dok <= dDatum;

      If dDatumPS Is NULL Then
         dDatumPS := dDatum;
      End If;
   End If;

If lImaPS Then
   Dbms_Output.Put_Line (' datum poslednjeg PS za mag '||to_char(nOrg_Deo)|| ' je ' || to_char(dDatumPS,'dd.mm.yyyy'));
   Dbms_Output.Put_Line (' MAGACIN PROIZVOD                 STANJE');
   Dbms_Output.Put_Line (' ------- -------- ----------------------');
   For Slog In StanjePS( nOrg_Deo, dDatumPS ) Loop
       Dbms_Output.Put_Line ( LPAD(to_char(Slog.Org_Deo),7) ||' '||
                              LPAD(SLOG.PROIZVOD,7)         ||' '||
                              LPAD(to_char(Slog.Stanje,'9,999,999,999.90000'),22));
   End Loop;
Else
   Dbms_Output.Put_Line (' MAGACIN PROIZVOD                 STANJE');
   Dbms_Output.Put_Line (' ------- -------- ----------------------');
   For Slog In Stanje( nOrg_Deo, dDatumPS ) Loop
       Dbms_Output.Put_Line ( LPAD(to_char(Slog.Org_Deo),7) ||' '||
                              LPAD(SLOG.PROIZVOD,7)         ||' '||
                              LPAD(to_char(Slog.Stanje,'9,999,999,999.90000'),22));
   End Loop;
   Dbms_Output.Put_Line (' nema PS , datum prvog za mag '||to_char(nOrg_Deo)|| ' je ' || to_char(dDatumPS,'dd.mm.yyyy'));
End If;



End;
