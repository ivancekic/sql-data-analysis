create or replace PACKAGE TudjaRobaKartica IS
   Procedure SetParameter( nSifMag Number, cPPart VarChar2, cPro VarChar2,  dDatOd Date, dDatDo Date );
   Function Page( nStrana NUMBER ) Return Boolean;
END;
/
create or replace PACKAGE BODY TudjaRobaKartica IS
--OVO JE BILO

   cKontrolnaJedMere VarChar2(3) ;
   cProizvod         VarChar2(7);
   cProizvodOd       Varchar2(7);
   cProizvodDo       Varchar2(7);
   nSifraMag         Number;
   cNazivMag         VarChar2(40);
   cPartnerOd        Varchar2(7);
   cPartnerDo        Varchar2(7);
   cNazivPartnera    VarChar2( 40 );
   cOldPPart         Varchar2(8);
   nLeftOfset   Number  := 15;

-- boris: zbog magacina ambalaze kod kupca i broj_dok1
   cMagacinAmbalaze VarChar2(1) ;
--
   dDatumOd  Date;
   dDatumDo  Date;
   lGotovo Boolean;
   nMaxRow Number;
   lPrva Boolean;
   lPom Boolean;
   lDuziBroj Boolean;
   lNewPage Boolean; -- za ispis header-a kad predje na novu stranu

--   Procedure SetParameter( nSifMag Number, dDatOd Date, dDatDo Date, cPro VarChar2 ) Is
   Procedure SetParameter( nSifMag Number, cPPart VarChar2, cPro VarChar2,  dDatOd Date, dDatDo Date) Is

   Begin
      -- setovanje parametara izvestaja
      TudjaRobaKartica.dDatumOd := dDatOd;
      TudjaRobaKartica.dDatumDo := dDatDo;
      TudjaRobaKartica.cProizvod := cPro;
      TudjaRobaKartica.nSifraMag := nSifMag;

      TudjaRobaKartica.cPartnerOd := cPPart;
      If nvl(cPartnerOd,' ') <> ' '  Then
         cPartnerDo := cPartnerOd;
      Else
         cPartnerOd := 1;
         cPartnerDo := 9999999;
      End If;

      If cProizvod Is Null Then
         cProizvod   := '%';
         cProizvodOd := 1;
         cProizvodDo := 9999999;
      Else
         cProizvodOd := cProizvod;
         cProizvodDo := cProizvod;
      End If;

      cNazivMag := POrganizacioniDeo.Naziv( nSifraMag );
      Begin
         Select 'D' into cMagacinAmbalaze
         from partner_magacin_flag
         Where magacin = nSifMag ;
         Exception when no_data_found then
             cMagacinAmbalaze := 'N' ;
      End ;

      lGotovo := False;
      nMaxRow := PReport.MaxRows;
      lPrva := True;
      lNewPage := False;
      lPom := False;
      PReport.Comment( 'Robna kartica za magacin: '||
                        To_Char( nSifraMag ) );
   End;

   Procedure Naslov Is -- ispisuje naslov na prvoj strani
   Begin
      If lPrva = True Then
         -- Pmapiranje.MOJE_TUDJA_ROBA_CENOVNIK = 4
         If Pmapiranje.VLASNIK_CONN_STR = 'SUNCE' Then
            PReport.AddLine(
                              CPAD('T U D J A   R O B A:  R O B N A   K A R T I C A',132));
         Else
            PReport.AddLine(  CPAD('T U D J A  R O B A:  R O B N A - M A T E R I J A L N A  F I N A N S I J S K A   K A R T I C A',132));

         End If;
            PReport.AddLine(  CPAD( 'Z A  P E R I O D  OD: '||
                                    To_Char(dDatumOd,'dd.mm.yyyy')||'  DO: '||
                                    To_Char(dDatumDo,'dd.mm.yyyy')
                                   , 132
                                  )
                           );
            PReport.AddLine('            ');
      End If;

      lPom := True;
   End;

   Procedure Header( cPPartner In VarChar2, cSifraPro In VarChar2 ) IS -- Ispisuje nazive kolona i podvlaci ih,na svakoj strani
      cNazivPro VarChar2(30);
      cJedMere VarChar2(3) ;
   Begin
      If lPrva = True Or PReport.LastRow = nMaxRow Or lNewPage Then
         -- preuzme podatke o proizvodu
         cNazivPro := PProizvod.Naziv( cSifraPro );
         cJedmere := PProizvod.Jedmere( cSifraPro );
--         ( ( cKontrolnaJedMere Is Null And PReport.LastRow = nMaxRow ) OR
--           ( cKontrolnaJedMere Is Not Null And PReport.LastRow >= nMaxRow - 1 ) ) Then

--         If cKontrolnaJedMere Is Not Null And PReport.LastRow = nMaxRow - 1 Then
--            PReport.AddLine( '  ');
--         End If;

         PReport.AddLine(  '  '||'Magacin: '||
                           To_Char(nSifraMag)||'  '||
                           cNazivMag
                        );

         PReport.AddLine(  '  '||'Poslovni partner: '||
                           cPPartner ||'  '||
                           PPoslovniPartner.Naziv(cPPartner)
                        );

--         If cKontrolnaJedMere Is Null Then
            PReport.AddLine(  '  '||'Proizvod: '||
                              cSifraPro ||' '||
                              cNazivPro ||' '||
                              '( Skladi'||Y('{')||'na jedinica mere: '||cJedMere||' )');
--         Else
--            PReport.AddLine(  '  '||'P R O I Z V O D: '||
--                              RPAD( cProizvod, 7 )||'  '||
--                              RPAD( cNazivPro, 30 )||' '||
--                              'Skladi?na jedinica mere: '||cJedMere||'   '||
--                              'Kontrolna jedinica mere: '||cKontrolnaJedMere);
--         End If;
         PReport.AddLine('            ');
-- BORIS
--         PReport.AddLine('R.br Broj dok.  Dok.  Datum Ulaz          Izlaz         Stanje           Cena       Duguje          Potra?uje       Saldo           ');
--         PReport.AddLine('---- ---------- ----- ----- ------------- ------------- ---------------- ---------- --------------- --------------- ----------------');
         If Pmapiranje.VLASNIK_CONN_STR = 'SUNCE' Then
            PReport.AddLine(rpad(' ',nLeftOfset,' ') || 'R.br     BrDok             Dokument      Datum            Ulaz           Izlaz           Stanje');
            PReport.AddLine(rpad(' ',nLeftOfset,' ') || '---- --------- -------------------- ---------- --------------- --------------- ----------------');
         Else
            PReport.AddLine('R.br     BrDok                  Dok.       Datum            Ulaz           Izlaz           Stanje        Cena          Duguje       Potrazuje            Saldo');
            PReport.AddLine('---- --------- --------------------- ---------- --------------- --------------- ---------------- ----------- --------------- --------------- ----------------');
         End If;

         lPrva := False;
         lNewPage := False;
      End if;
   End;

   -- procedura stampa ukupan ulaz, u kontroli, izlaz i stanje
   Procedure StampaUkupno( nSumaUlaz In Number, nSumaIzlaz In Number,
                           nSumaKontrola In Number, nStanje In Number,
                           nSumaDug In Number, nSumaPotr In Number,
                           nSumaSaldo In Number, cText In VarChar2 ) Is
   Begin
      -- da ne bi duplirao crtice za prethodno stanje
      If Pmapiranje.VLASNIK_CONN_STR = 'SUNCE' Then
         If cText != 'Prethodno stanje:  ' Then
            PReport.AddLine(  rpad(' ',nLeftOfset,' ') || RPAD(' ',47,' ')||RPAD('-',15,'-')||' '||RPAD('-',15,'-')||' '||
                              RPAD('-',16,'-'));
         End If;
         PReport.AddLine( rpad(' ',nLeftOfset,' ') || LPAD( cText, 47 )||
                          LPAD(To_Char(nSumaUlaz,'9999999990.990'),15)||' '||
                          LPAD(To_Char(nSumaIzlaz,'9999999990.990'),15)||' '||
                          LPAD(To_Char(nStanje,'9999999990.9990'),16));
      Else
         If cText != 'Prethodno stanje:  ' Then
            PReport.AddLine(  RPAD(' ',28,' ')||RPAD('-',15,'-')||' '||RPAD('-',15,'-')||' '||
                              RPAD('-',16,'-')||' '||
                              RPAD( ' ', 11, ' ' )||' '||
                              RPAD('-',15,'-')||' '||
                              RPAD('-',15,'-')||' '||
                              RPAD('-',16,'-') );
         End If;
         PReport.AddLine( LPAD( cText, 28 )||
                          LPAD(To_Char(nSumaUlaz,'9999999990.990'),15)||' '||
                          LPAD(To_Char(nSumaIzlaz,'9999999990.990'),15)||' '||
                          LPAD(To_Char(nStanje,'9999999990.9990'),16)||' '||
                          RPAD( ' ', 11, ' ' )||' '||
                          LPAD(To_Char(nSumaDug,'99999999990.99'),15)||' '||
                          LPAD(To_Char(nSumaPotr,'99999999990.99'),15)||' '||
                          LPAD(To_Char(nSumaSaldo,'999999999990.99'),16) );
      End If;

   End;

   -- procedura stampa ukupan ulaz, u kontroli, izlaz i stanje
   Procedure StampaUkupnoKontrolna( nSumaUlazKontrolna In Number, nSumaIzlazKontrolna In Number,
                           nSumaKontrolaKontrolna In Number, nStanjeKontrolna In Number ) Is
   Begin
       If cKontrolnaJedMere Is Not Null Then
         PReport.AddLine(  LPAD('Ukupno u kontrolnoj jedinici mere:   ',60,' ')||
                           LPAD(To_Char(nSumaUlazKontrolna,'999999990.99'),13)||' '||
                           LPAD(To_Char(nSumaKontrolaKontrolna,'999999990.99'),13)||' '||
                           LPAD(To_Char(nSumaIzlazKontrolna,'999999990.99'),13)||' '||
                           RPAD(' ',13,' ')||' '||
                           LPAD(To_Char(nStanjeKontrolna,'999999999990.99'),16));
       End If;


   End;

   -- Funkcija vraca pocetno stanje sa maksimalnim datumom u periodo
   -- od 01.01.tekuce godine do prosledjenog datuma, ili NULL ako ne postoji
   -- pocetno stanje u tom periodu

   -- funkcija vraca cenu za proizvod i org deo
   Function PreuzmiCenu( nOrgDeo In Number,cVrstaDok In VarChar2,nTipDok in Number,dDatum In Date,
                         cProizvod In VarChar2,nCenaStavke In Number,nCenaStavke1 In Number , nFaktor In Number ) Return Number Is


      cTip VarChar2( 2 );
      nCenovnik Number;
      nCena Number;
   Begin
      If Pmapiranje.MOJE_TUDJA_ROBA_CENOVNIK = 4 then
         nCena := Pmapiranje.MOJE_TUDJA_ROBA_FiksnaV;
      Else
          nCena := nCenaStavke1 ;
      End If;
      Return( nCena );
   End;

   Function Page( nStrana NUMBER ) Return Boolean Is
      cNazivDok VarChar2(20);
      cNazivRobnogDok VarChar2(20);
      nTipDok Number;

      -- Sledece tri promenljive su uvedene da bi se prikazivao
      -- robni dokument, a ne dokument ambalaze
      cVrstaRobnog VarChar2(2);
      nGodinaRobnog Number;
      cBrojRobnog  VarChar2(9);
      cBrojRobnog1 VarChar2(9);

      cFirma VarChar2(250);

      cVrstaStorno VarChar2(2);
      cBrojStorno VarChar2(9) :='0';
      nGodinaStorno Number;
      cVrstaStornoRobnog VarChar2(2);
      cBrojStornoRobnog VarChar2(9) :='0';
      nGodinaStornoRobnog Number;

      nStanje Number;
      nUlaz Number;
      nIzlaz Number;
      nKontrolaKontrolna Number;
      nStanjeKontrolna Number;
      nUlazKontrolna Number;
      nIzlazKontrolna Number;
      nRBroj Number;
      nRBrojKontrolna Number;

      cBrojDokPom VarChar2( 9 );

      nUlazIzlaz Number;
      nSumaUlaz Number;
      nSumaIzlaz Number;
      nSumaKontrola Number;
      nSumaUlazKontrolna Number;
      nSumaIzlazKontrolna Number;
      nSumaKontrolaKontrolna Number;

      dDatumPS Date; --max datum pocetnog stanja u periodu pre

      lPrethodnoStanje Boolean := True; -- da bi odredio trenutak kad se
                                        -- prikazuje prethodno stanje
      nPrethodnoStanje Number := 0;
      nPrethodniUlaz Number := 0;
      nPrethodniIzlaz Number := 0;
      nPrethodnaKontrola Number := 0;
      nPrethodnaSumaDug Number := 0;
      nPrethodnaSumaPotr Number := 0;
      nPrethodnaSumaSaldo Number := 0;

      -- Kursor koji izdvaja stavke dokumenta za zadati proizvod
-- jos jedna ispravka za prosecni cenovnik
      Cursor Stavka_Cur ( cPro In VarChar2, dOdDat In Date, dDoDat In Date ) Is
         Select PPartner, Proizvod, Datum_Dok, Godina, Broj_Dok,
                Vrsta_Dok, K_Robe, Kol Kolicina, Faktor,
                Kontrola, Realizovano, Kolicina_Kontrolna, Cena1,
                Tip_Dok, cena, Broj_Dok1
         From TUDJAROBALAGER
         Where --Org_Deo = nSifraMag
               Org_Deo in (select org_deo from org_deo_osn_podaci where mag_tudje_robe = nSifraMag and org_Deo = mag_tudje_robe)
           and ppartner between cPartnerOd And cPartnerDo
           And Datum_Dok Between dOdDat and dDoDat
           And Proizvod Between cProizvodOd And cProizvodDo
         Order By to_number(ppartner), To_Number( Proizvod ), Datum_Dok, Datum_Unosa;

      Slog Stavka_Cur % RowType;
      cProizvodPom VarChar2( 9 ) := Null;
      lNewProizvod Boolean := False; -- uzima u obzir samo proizvode
                                    -- koji se javljaju u dokumentima
      cPartnerPom VarChar2( 9 ) := Null;
      lNewPartner Boolean := False; -- uzima u obzir samo proizvode
                                    -- koji se javljaju u dokumentima

      nCena Number;

      nSumaDug Number;
      nSumaPotr Number;
      nSumaSaldo Number;
      cVezProizvod VarChar2( 2 );

      -- procedura resetuje promenljive za novi proizvod
      Procedure Reset Is
      Begin
         lPom := False;
         nStanje := 0;
         nRBroj := 0;
         nSumaUlaz := 0;
         nSumaIzlaz := 0;
         nSumaKontrola := 0;
         nStanjeKontrolna := 0;
         nRBrojKontrolna := 0;
         nSumaUlazKontrolna := 0;
         nSumaIzlazKontrolna := 0;
         nSumaKontrolaKontrolna := 0;
         lPrethodnoStanje := True;
         nPrethodnoStanje := 0; -- ove promenljive su potrebne zbog
         nPrethodniUlaz := 0;   -- prethodnog stanja i medjustanja
         nPrethodniIzlaz := 0;
         nPrethodnaKontrola := 0;
         nPrethodnaSumaDug := 0;
         nPrethodnaSumaPotr := 0;
         nPrethodnaSumaSaldo := 0;
         nSumaDug := 0;
         nSumaPotr := 0;
         nSumaSaldo := 0;
      End;

   Begin
      If Not lGotovo Then  -- ako izvestaj nije izgenerisan
         -- GENERISE GA KOMPLETNO !

         cFirma := PConfig.Vrednost('KORISNIK', 'FIRMA_KUPAC');

         dDatumPS := to_date( '01.01.0001','dd.mm.yyyy');

         OPEN Stavka_cur( cProizvod, dDatumPS, dDatumDo );

         Loop

            FETCH Stavka_Cur INTO Slog;
            Exit When Stavka_cur%NOTFOUND;



------            -- Zbog otpreme sa lagera
------            If Slog.Vrsta_Dok = 11 and Slog.Tip_Dok = 257 Then
------                nUlazIzlaz := 2;
------            ElsIf Slog.Vrsta_Dok = 12 and Slog.Tip_Dok = 257 Then
------                nUlazIzlaz := 2;
------            ElsIf Slog.Vrsta_Dok = 13 and Slog.Tip_Dok = 257 Then
------                nUlazIzlaz := 1;
------            ElsIf Slog.Vrsta_Dok = 31 and Slog.Tip_Dok = 257 Then
------                nUlazIzlaz := -1;
------            Else
------                nUlazIzlaz := PDokument.UlazIzlaz( Slog.Vrsta_Dok, Slog.Tip_Dok, Slog.K_Robe,Slog.Datum_Dok );
------            End If;
------            -- Zbog otpreme sa lagera


               nUlazIzlaz := PDokument.UlazIzlaz( Slog.Vrsta_Dok, Slog.Tip_Dok, Slog.K_Robe,Slog.Datum_Dok );

--
-- boris menja po cenovniku -> sa stavka_dok
--
            nCena := PreuzmiCenu( nSifraMag,Slog.Vrsta_Dok, Slog.Tip_Dok,Slog.Datum_Dok,
                                  Slog.Proizvod,Slog.cena,Slog.Cena1,Slog.Faktor );
               -- ovo radi samo za dokumente koji se ispisuju
               If Slog.Datum_Dok >= dDatumOd Then
                  -- preuzima naziv dokumenta ,jer to prikazujemo umesto vrste
                  cNazivDok := PVrstaDok.Naziv( Slog.Vrsta_Dok );

--                   -- provera dali prelazi na novu stranu,zbog novog proizvoda
--                   If lPom = False And lPrva = False Then
--                      PReport.NewPage;
--                      lPom := True;
--                      lNewPage := True;
--                   End If;
               End If;

            -- Samo ako je tip proizvoda 'ambalaza' ispitaj da li postoji
            -- odgovarajuci 'robni' dokument (samo za RUBIN)
-- boris : samo za magacin ambalaze kod kupaca
--            If ( PProizvod.Tip( Slog.Proizvod ) = '8' ) And ( cFirma = 'RUBIN' ) Then
            If ( PProizvod.Tip( Slog.Proizvod ) = '8' ) And  cMagacinAmbalaze = 'D' Then
               MagKartica.NadjiRobniDokument( Slog.Vrsta_Dok, Slog.Godina, Slog.Broj_Dok,
                                   cVrstaRobnog, nGodinaRobnog, cBrojRobnog );
               cNazivRobnogDok := PVrstaDok.Naziv( cVrstaRobnog );
            Else -- ako tip proizvoda nije 'ambalaza'
               -- tekuci dokument je 'robni'
               cVrstaRobnog := Slog.Vrsta_Dok;
               nGodinaRobnog := Slog.Godina;
-- boris broj_dok1              cBrojRobnog := Slog.Broj_Dok;
               cBrojRobnog := Slog.Broj_Dok1;
               cNazivRobnogDok := cNazivDok;
            End If;

--            If Slog.Proizvod != NVL( cProizvodPom, ' ' ) Then
            If Slog.Proizvod != NVL( cProizvodPom, ' ' )
               Or Slog.PPartner != NVL( cPartnerPom, ' ' ) Then
               -- prikaze sume za prethodni proizvod
--               If cProizvodPom Is Not Null And lNewProizvod Then
               If (cProizvodPom Is Not Null And lNewProizvod) Or (cPartnerPom Is Not Null And lNewPartner) Then
                  StampaUkupno( nSumaUlaz - nPrethodniUlaz,
                                nSumaIzlaz - nPrethodniIzlaz,
                                nSumaKontrola - nPrethodnaKontrola,
                                nStanje - nPrethodnoStanje,
                                nSumaDug - nPrethodnaSumaDug,
                                nSumaPotr - nPrethodnaSumaPotr,
                                nSumaSaldo - nPrethodnaSumaSaldo,
                                'MEDjUSTANjE:   ' );

                  StampaUkupno( nSumaUlaz, nSumaIzlaz, nSumaKontrola, nStanje,
                                nSumaDug, nSumaPotr, nSumaSaldo,
                                'UKUPNO:   ' );
                  PReport.NewPage;
                  lNewPage := True;
                  lNewProizvod := False;
               End If;
               -- resetuje stanje kad naidje na novi proizvod
               Reset;

               cProizvodPom := Slog.Proizvod;
               cPartnerPom  := Slog.PPartner;
            End If;

            -- za kompenzaciju ambalaze
            If ( Slog.Vrsta_Dok = '3' And Slog.Tip_Dok = 14 ) Or
               ( Slog.Vrsta_Dok = '4' And Slog.Tip_Dok = 14 ) or
               ( Slog.Vrsta_Dok = '80' ) Then
               Slog.Realizovano := Slog.Kolicina;
            End If;

--             If Slog.Datum_Dok <= dDatumDo And Slog.Datum_Dok >= dDatumPS Then

               -- ako je dokument pocetno stanje treba resetovati stanje
               -- i sve ostale brojace ulaz, izlaz, analitika
               If Slog.Vrsta_Dok = '21' And
                  NVL( cBrojDokPom, '-1' ) != Slog.Broj_Dok Then

                  -- ispisuje samo za dokumente sa datumom vecim od DatumOd
                  -- i nismo presli na novi proizvod, jer ako smo presli na
                  -- novi proizvod i ako je prvi dokument pocetno stanje
                  -- ne treba ispisati sume, jer su na nuli

                  If Not lNewPage And Not lPrva And
                                                Slog.Datum_Dok >= dDatumOd Then
                     StampaUkupno( nSumaUlaz, nSumaIzlaz, nSumaKontrola,
                                   nStanje, nSumaDug, nSumaPotr, nSumaSaldo,
                                   'UKUPNO:   ' );
--                      If cKontrolnaJedMere Is Not Null Then
--                         StampaUkupnoKontrolna( nSumaUlazKontrolna, nSumaIzlazKontrolna, nSumaKontrolaKontrolna, nStanjeKontrolna );
--                      End If;
                     PReport.AddLine( '            ' );
                  End If;

                  nSumaUlaz := 0;
                  nSumaIzlaz := 0;
                  nStanje := 0;
                  nSumaUlazKontrolna := 0;
                  nSumaIzlazKontrolna := 0;
                  nStanjeKontrolna := 0;
                  nSumaDug := 0;
                  nSumaPotr := 0;
                  nSumaSaldo := 0;

               End If;

               nStanje := nStanje + Slog.K_Robe * Slog.Faktor * Slog.Realizovano;

--               If Slog.K_Robe = 1 Then

If nUlazIzlaz = 1 Then
                  nUlaz := nUlazIzlaz * Slog.K_Robe * Slog.Faktor * Slog.Kolicina;
                  nIzlaz := 0;
--               ElsIf Slog.K_Robe = -1 Then
ElsIf nUlazIzlaz = -1 Then
                  nIzlaz := nUlazIzlaz * Slog.K_Robe * Slog.Faktor * Slog.Kolicina;
                  nUlaz := 0;
ElsIf nUlazIzlaz = 2  And Slog.K_Robe = 1 Then
                     nUlaz := Slog.Faktor * Slog.Kolicina;
                     nIzlaz := 0;
ElsIf nUlazIzlaz = 2  And Slog.K_Robe = -1 Then
                     nIzlaz := Slog.Faktor * Slog.Kolicina;
                     nUlaz := 0;
ElsIf nUlazIzlaz = 2  And Slog.K_Robe = 0 Then
                     nUlaz := Slog.Faktor * Slog.Kolicina;
                     nIzlaz := 0;
               End If;

               -- azurira sume
               nSumaUlaz := nSumaUlaz + nUlaz;
               nSumaIzlaz := nSumaIzlaz + nIzlaz;
               nSumaKontrola :=  nSumaKontrola + ( Slog.Kolicina - Slog.Realizovano ) * Slog.Faktor;

               if slog.vrsta_dok != '80' then
                  nSumaDug := nSumaDug + nUlaz * NVL( nCena, 0 );
               else
                  nSumaDug := nSumaDug + nUlaz * NVL(nCena-slog.cena, 0 );
               end if;
               nSumaPotr := nSumaPotr + nIzlaz * NVL( nCena, 0 );
               nSumaSaldo := nSumaDug - nSumaPotr;

               -- ispisuje samo za dokumente sa datumom vecim od DatumOd
               If Slog.Datum_Dok >= dDatumOd Then

                  lDuziBroj := False;
                  -- da bi izvukao izvorni dokument od kog je nastao storno dokument
                  If Slog.Vrsta_Dok In( '4', '12', '26', '27', '30', '31', '32', '34', '46' ) Then
                     Begin
                        Select Vrsta_Dok, Broj_Dok, Godina
                        Into cVrstaStorno, cBrojStorno, nGodinaStorno
                        From Vezni_Dok
                        Where Vezni_Dok.Za_Vrsta_Dok = Slog.Vrsta_Dok And
                              Vezni_Dok.Za_Broj_Dok  = Slog.Broj_Dok And
                              Vezni_Dok.Za_Godina    = Slog.Godina And
                              Vezni_Dok.Vrsta_Dok In ( Decode( Slog.Vrsta_Dok,
                                 '26', '1', '4', '3', '30', '5', '27', '8',
                                 '12', '11', '31', '13', '32', '28',
                                 '34', '33', '46', '45' ) );
                     Exception
                        When No_Data_Found Then
                           cVrstaStorno := '0';
                           nGodinaStorno := '0';
                           cBrojStorno := '0';
                     End;
                     If cFirma = 'RUBIN' Then
                        MagKartica.NadjiRobniDokument( cVrstaStorno, nGodinaStorno, cBrojStorno,
                           cVrstaStornoRobnog, nGodinaStornoRobnog, cBrojStornoRobnog );
                     Else
                        cVrstaStornoRobnog := cVrstaStorno;
                        nGodinaStornoRobnog := nGodinaStorno;
                        cBrojStornoRobnog := cBrojStorno;
                     End If;
                     If Length( cBrojStornoRobnog ) <= 4 Then
                        lDuziBroj := False;
                        nGodinaRobnog := To_Number( cBrojStornoRobnog );
                     Else
                        lDuziBroj := True;
                     End If;

                  End If;

                  nRBroj := nRBroj + 1;
--                   nRBrojKontrolna := nRBrojKontrolna + 1;

                  Naslov;
                  Header( Slog.PPartner, Slog.Proizvod );

                  -- prikaze prethodno stanje
                  If lPrethodnoStanje = True Then
                     lNewProizvod := True;
                     nPrethodnoStanje := nStanje -
                                          Slog.K_Robe * Slog.Faktor * Slog.Realizovano;
                     nPrethodniUlaz := nSumaUlaz - nUlaz;
                     nPrethodniIzlaz := nSumaIzlaz - nIzlaz;
                     nPrethodnaKontrola := nSumaKontrola - ( Slog.Kolicina -
                                             Slog.Realizovano ) * Slog.Faktor;
                     nPrethodnaSumaDug := nSumaDug - nUlaz * NVL( nCena, 0 );
                     nPrethodnaSumaPotr := nSumaPotr - nIzlaz * NVL( nCena, 0 );
                     nPrethodnaSumaSaldo := nPrethodnaSumaDug - nPrethodnaSumaPotr;

                     StampaUkupno( nPrethodniUlaz, nPrethodniIzlaz,
                                    nPrethodnaKontrola, nPrethodnoStanje,
                                    nPrethodnaSumaDug, nPrethodnaSumaPotr, nPrethodnaSumaSaldo,
                                    'Prethodno stanje:  ' );

                     lPrethodnoStanje := False;
                  End If;
                  If Pmapiranje.VLASNIK_CONN_STR = 'SUNCE' Then
                     If Not lDuziBroj Then
                        PReport.AddLine(  rpad(' ',nLeftOfset,' ') ||
                                          LPAD(To_Char(nRBroj),4)||' '||
                                          LPAD(cBrojRobnog , 9 )
                                          ||' '||RPAD(cNazivRobnogDok,20)||' '||
                                          RPAD(To_Char(Slog.Datum_Dok,'dd.mm.yyyy'),10)||' '||
                                          case when slog.vrsta_dok != '80' then
                                                LPAD(To_Char(nUlaz,'9999999990.990'),15)
                                               else
                                                LPAD(To_Char(0,'9999999990.990'),15)
                                          end ||' '||
                                          LPAD(To_Char(nIzlaz,'9999999990.990'),15)||' '||
                                          LPAD(To_Char(nStanje,'9999999990.9990'),16) );
                     Else
                        PReport.AddLine(  rpad(' ',nLeftOfset,' ') ||
                                          LPAD(To_Char(nRBroj),4)||' '||
                                          LPAD(Substr(LTRIM(cBrojRobnog),1,4)||'/'||
                                          RPAD(Substr(cBrojStornoRobnog,1,5),5), 10 )
                                          ||RPAD(cNazivRobnogDok,20)||' '||
                                          RPAD(To_Char(Slog.Datum_Dok,'dd.mm.yyyy'),10)||
                                          LPAD(To_Char(nUlaz,'999999990.990'),14)||' '||
                                          LPAD(To_Char(nIzlaz,'999999990.990'),15)||' '||
                                          LPAD(To_Char(nStanje,'999999990.9990'),16) );
                     End If;
                  Else
                     If Not lDuziBroj Then
                        PReport.AddLine(  LPAD(To_Char(nRBroj),4)||' '||
                                          LPAD(cBrojRobnog , 5 )
                                          ||' '||RPAD(cNazivRobnogDok,20)||' '||
                                          RPAD(To_Char(Slog.Datum_Dok,'dd.mm.yyyy'),10)||' '||
                                          case when slog.vrsta_dok != '80' then
                                                LPAD(To_Char(nUlaz,'9999999990.990'),15)
                                               else
                                                LPAD(To_Char(0,'9999999990.990'),15)
                                          end ||' '||
                                          LPAD(To_Char(nIzlaz,'9999999990.990'),15)||' '||
                                          LPAD(To_Char(nStanje,'9999999990.9990'),16)||
                                          LPAD(To_Char(NVL( nCena, 0 ),'999990.9999'),12)||' '||
                                          case when slog.vrsta_dok != '80' then
                                                 LPAD(To_Char(nUlaz * NVL( nCena, 0 ),'99999999990.99'),15)
                                               else
                                                 LPAD(To_Char(nUlaz * NVL( nCena - slog.cena, 0 ),'99999999990.99'),15)
                                          end  ||' '||
                                          LPAD(To_Char(nIzlaz * NVL( nCena, 0 ),'99999999990.99'),15)||' '||
                                          LPAD(To_Char(nvl(nSumaSaldo,0),'999999999990.99'),16) );
                     Else
                        PReport.AddLine(  LPAD(To_Char(nRBroj),4)||' '||
                                          LPAD(Substr(LTRIM(cBrojRobnog),1,4)||'/'||
                                          RPAD(Substr(cBrojStornoRobnog,1,5),5), 10 )
                                          ||RPAD(cNazivRobnogDok,20)||' '||
                                          RPAD(To_Char(Slog.Datum_Dok,'dd.mm.yyyy'),10)||
                                          LPAD(To_Char(nUlaz,'999999990.990'),14)||' '||
                                          LPAD(To_Char(nIzlaz,'999999990.990'),15)||' '||
                                          LPAD(To_Char(nStanje,'999999990.9990'),16)||' '||
                                          LPAD(To_Char(NVL( nCena, 0 ),'99990.9990'),11)||' '||
                                          LPAD(To_Char(nUlaz * NVL( nCena, 0 ),'99999999990.99'),15)||' '||
                                          LPAD(To_Char(nIzlaz * NVL( nCena, 0 ),'99999999990.99'),15)||' '||
                                          LPAD(To_Char(nvl(nSumaSaldo,0),'999999999990.99'),16) );
                     End If;
                  End If;



--                   If cKontrolnaJedMere Is Not Null And Slog.Kolicina_Kontrolna Is Not Null Then
--                      PReport.AddLine(  LPAD('  u kontrolnoj jedinici mere:  ',60)||
--                                        LPAD(To_Char(nUlazKontrolna,'999999990.99'),13)||'  '||
--                                        LPAD( ' ',13)||
--                                        LPAD(To_Char(nIzlazKontrolna,
--                                        '999999990.99'),13)||' '||
--                                        LPAD(To_Char(nStanjeKontrolna,
--                                        '999999999990.99'),16));
--                   End If;
               End If;
            --End If;
            cBrojDokPom := Slog.Broj_Dok;
         End Loop;

         Close Stavka_cur;

--          If lPom And Slog.Datum_Dok >= dDatumOd Then
            StampaUkupno( nSumaUlaz - nPrethodniUlaz,
                           nSumaIzlaz - nPrethodniIzlaz,
                           nSumaKontrola - nPrethodnaKontrola,
                           nStanje - nPrethodnoStanje,
                           nSumaDug - nPrethodnaSumaDug,
                           nSumaPotr - nPrethodnaSumaPotr,
                           nSumaSaldo - nPrethodnaSumaSaldo,
--                           nSumaDug, nSumaPotr, nSumaSaldo,
                           'MEDjUSTANjE:   ' );

            StampaUkupno( nSumaUlaz, nSumaIzlaz, nSumaKontrola, nStanje,
                          nSumaDug, nSumaPotr, nSumaSaldo,
                           'UKUPNO:   ' );

--             If cKontrolnaJedMere Is Not Null Then
--                StampaUkupnoKontrolna( nSumaUlazKontrolna,
--                                        nSumaIzlazKontrolna,
--                                        nSumaKontrolaKontrolna,
--                                        nStanjeKontrolna );
--             End If;
            PReport.AddLine( '            ' );
--          End If;


         If lPrva = False Then
            Preport.NewPage;
         End If;

         lGotovo := TRUE;

      End If;  -- pocetni if Not lGotovo Then ...

      If nStrana >= 0 And nStrana <= PReport.LastPage Then
           Return TRUE;      -- znak da je trazena stranica izgenerisana
      Else
           Return NULL;      -- znak da trazena stranica ne postoji
      End If;
   End;
END;


/
Drop public synonym TudjaRobaKartica

/

Create public synonym TudjaRobaKartica FOR vital.TudjaRobaKartica ;
/
---- ako je paket ili funkcija
GRANT EXECUTE ON vital.TudjaRobaKartica TO EXE
/
