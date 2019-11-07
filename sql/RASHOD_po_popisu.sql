Declare
      nGodina      Number := 2007;
      cBroj        Varchar2(7) := '19';
      dDatumPopisa Date   := to_date('31.12.2007','dd.mm.yyyy');
      nOrgDeo      Number := 17;

      cSkladisnaJM VarChar2( 3 );
      nTipCene     Number;
      nCena        Number ;

      cBrojViska   VarChar2 ( 9 );
      cBrojManjka  VarChar2 ( 9 );
      cBrojRashoda VarChar2 ( 9 );
      cBrojRashod1 Varchar2(7);

      nStavkaViska   Number;
      nStavkaManjka  Number;
      nStavkaRashoda Number;

Begin
      nStavkaViska   := 0;
      nStavkaManjka  := 0;
      nStavkaRashoda := 0;

      cBrojRashoda := To_Char( PSekvenca.NextVal ( 'Broj_Rashoda', nGodina ) );
      cBrojRashod1 := To_Char( PSekvencaOrg.NextVal( 'Broj_Rashoda', nGodina , nOrgDeo) );      
/*
      Begin
         Select to_char(Stanje + 1)
         Into cBrojRashoda
         from SEKVENCA
         where godina = nGodina
           and naziv = 'BROJ_RASHODA';

      Exception When No_data_found  Then
         cBrojRashoda := '1';
      End;

      Begin
         select to_char(Stanje + 1)
         Into cBrojRashod1
         from SEKVENCAorg
         where godina  = nGodina
           and naziv   = 'BROJ_RASHODA'
           and org_Deo = nOrgDeo ;

      Exception When No_data_found  Then
            cBrojRashod1 := '1';
      End;
*/
      Dbms_output.Put_line('br rashoda ' || cBrojRashoda || ' br1 ' || cBrojRashod1);

      Insert Into Dokument ( Vrsta_Dok , Broj_Dok , Godina , Tip_Dok , Datum_Dok , Status , Org_Deo , Broj_dok1 )
             Values        ( '33', cBrojRashoda , nGodina , '99' , dDatumPopisa , 1, nOrgDeo , cBrojRashod1 );

      PVezniDok.DodajPar ( '33', nGodina, cBrojRashoda,
                           '18', nGodina, cBroj );

      Dbms_output.Put_line('stav proizvod tip_c jm               cena');
      Dbms_output.Put_line('---- -------- ----- --- -----------------');

      For TipCene In( Select Proizvod.Sifra proizvod, Jed_Mere, Cena
                      From Proizvod, Tip_Proizvoda
                      Where Proizvod.Sifra in ('115402','114410','114412')
                        And Proizvod.Tip_Proizvoda = Tip_Proizvoda.Sifra
                    )
      Loop
      nStavkaRashoda := nStavkaRashoda + 1 ;
            If nTipCene = 1 Then
               nCena := PravaProsCena(nOrgDeo,tipcene.proizvod,
                                      to_date('01.01.'||to_char(dDatumPopisa ,'yyyy'),'dd.mm.yyyy'),dDatumPopisa )  ;
            ElsIf nTipCene = 2 Then
               nCena := PPlanskiCenovnik.Cena ( tipcene.proizvod, dDatumPopisa , 'YUD', 1 );
            Else
               nCena := PProdajniCenovnik.Cena ( tipcene.proizvod,dDatumPopisa , 'YUD', 1 );
            End If;
            Dbms_output.Put_line(lpad(nStavkaRashoda,4) ||' '||
                                 lpad(tipcene.proizvod,8)      ||' '||
                                 lpad(to_char(tipcene.Cena),5) ||' '||
                                 lpad(tipcene.jed_mere,3)      ||' '||
                                 lpad(to_char(nCena,'999,999,999.9990'),17)
                                ); 
               Insert Into Stavka_Dok ( Broj_Dok, Vrsta_Dok, Godina,
                                        Stavka, Proizvod,
--                                        Lot_Serija, Rok,
                                        Kolicina, Jed_Mere,
                                        Cena, Valuta, Lokacija,
                                        K_Rez, K_Robe, K_Ocek,
                                        Kontrola, Faktor, Realizovano,
                                        Kolicina_Kontrolna,Cena1 )
               Values ( cBrojRashoda, '33', nGodina,
                        nStavkaRashoda, tipcene.Proizvod,
--                        SlogStavke.Lot_Serija, SlogStavke.Rok,
                        NVL ( SlogStavke.Rashod, 0 ), tipcene.jed_mere,
                        NVL ( nCena,0 ), 'YUD', 1,
                        0, -1, 0,
                        1, 1, NVL ( SlogStavke.Rashod, 0 ),
                        NVL ( SlogStavke.Kontrolna_Rashod, 0 ), NVL ( nCena,0 ) );                                

      End Loop;
End;
