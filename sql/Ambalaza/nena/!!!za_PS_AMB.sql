-- PRVO PROVERI DA LI POSTOJE :: POCETNA STANJA U DOK I PS_AMBLAZE
--  

declare

      dDatum Date;
      nMagacin Number;
      nGodina Number := 2010;
      cBrojDok VarChar2(9);
      nStavka Number;
      nCena Number;
      cJM VarChar2(3);
      nKolicina Number;
      nKRobe Number;


      Cursor Partner_Cur( nGodina In Number ) IS
         Select Distinct Partner
         From PS_Ambalaze
         Where Godina = nGodina
         Order by to_number(Partner);

      SlogPartner Partner_Cur % ROWTYPE;

      Cursor Proizvod_Cur( cPartner In VarChar2, nGodina In Number ) IS
         Select Proizvod, Ulaz, Izlaz
         From PS_Ambalaze
         Where Partner = cPartner And Godina = nGodina
         Order By Proizvod;

      SlogProizvod Proizvod_Cur % ROWTYPE;

Begin
  --PRVO SE NAPUNI POMOCNA TABLE ZA PS_AMBALAZE
--  Insert into PS_AMBALAZE
--  (
--     Select nGodina, PPartner PRT, sd.Proizvod PRO
--          , ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz
--          , ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz
--          --     , ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje
--     From Dokument d, Stavka_Dok sd
--     Where d.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 )
--       And d.Status > 0
--       And d.Org_Deo In (Select Magacin From Partner_magacin_Flag)
--       And d.Datum_Dok Between nvl((Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = d.org_deo), to_date('01.01.0001','dd.mm.yyyy'))
--       And to_date('31.12.'||To_Char(nGodina-1),'dd.mm.yyyy')--sysdate
--       And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
--       And sd.K_Robe != 0
----       and ppartner != 1
--       And d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
--     Group By d.Ppartner, sd.Proizvod, d.Org_Deo
--     );
--     COMMIT;

      dDatum := To_Date('01.01.'||To_Char(nGodina),'dd.mm.yyyy');

      Open Partner_Cur( nGodina);
      Loop
      Fetch Partner_Cur Into SlogPartner;
      Exit When Partner_Cur % NOTFOUND;
         Begin
            Select Magacin
            Into nMagacin
            From Partner_Magacin_Flag
            Where PPartner = SlogPartner.Partner And Flag = 'A';
         Exception
            When No_Data_Found Then
               nMagacin := Null;
         End;
         -- ako nema, pravi magacin partnera
         If nMagacin Is Null Then
            NapraviMagacinPartnera( SlogPartner.Partner );
            Begin
               Select Magacin
               Into nMagacin
               From Partner_Magacin_Flag
               Where PPartner = SlogPartner.Partner And Flag = 'A';
            Exception
               When No_Data_Found Then
                  null;
                  --Raise_Application_Error ( '-20998' , 'Ne postoji magacin partnera ! obavestite nadlezno lice .' );
            End;
         End If;
         -- pravi zaglavlje dokumenta
         cBrojDok := To_Char ( PSekvenca.NextVal( 'Broj_PocetnogStanja', nGodina ) );

         Insert Into Dokument ( Vrsta_dok , Broj_dok , Godina, Tip_dok, Datum_Dok, Datum_Unosa, User_id,
                                PPartner, Org_Deo, Status,Broj_dok1 )
         Values ( '21' , cBrojDok, nGodina, 99, dDatum , sysdate, User,
                  SlogPartner.Partner,nMagacin , 0,1 );

         -- stavke dokumenta
         nStavka := 0;
         Open Proizvod_Cur( SlogPartner.Partner, nGodina );
         Loop
         Fetch  Proizvod_Cur Into SlogProizvod;
         Exit When Proizvod_Cur % NOTFOUND;

            nStavka := nStavka + 1;

            nCena := NVL( PPlanskiCenovnik.Cena( SlogProizvod.Proizvod, dDatum, 'YUD' , 1 ), 0 );
            cJM := PProizvod.JedMere(SlogProizvod.Proizvod);

            nKolicina := NVL(SlogProizvod.Ulaz, 0) - NVL(SlogProizvod.Izlaz, 0);

            -- u zavisnosti od kolicine se odredjuje k. robe
            -- zbog prikaza u izvestajima (+) kao ulaz i (-) kao izlaz
            If nKolicina > 0 Then
               nKRobe := 1;
            Else
               nKRobe := -1;
            End If;

            Insert Into Stavka_Dok( Vrsta_dok , Broj_dok , Godina, Stavka,
                                    Proizvod, Kolicina, Jed_mere, Lokacija,
                                    K_Rez, K_Robe, K_Ocek, Faktor, Realizovano,
                                    Cena, Valuta, Kontrola )
            Values ( '21', cBrojDok, nGodina, nStavka, SlogProizvod.Proizvod,
                     nKolicina * nKRobe, cJM,
                     '1', 0, nKRobe, 0, 1, nKolicina * nKRobe, nCena, 'YUD',1 );
         End Loop;
         Close Proizvod_Cur;

         PKonacnaVerzija.PocetnoStanje( nGodina, cBrojDok, nMagacin, 0, FALSE );

         Update Dokument
         Set Status = 1
         Where Vrsta_dok = '21' And Godina = nGodina And Broj_dok = cBrojDok;
      End Loop;
      Close Partner_Cur;



End;

