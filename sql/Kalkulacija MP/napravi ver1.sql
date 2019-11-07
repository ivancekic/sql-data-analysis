declare
--PROCEDURE NAPRAVI_KALKULACIJU_MP (  nDokGod Number, cDokVrd Varchar2, cDokBrd Varchar2
--                                  , nIzvDokGod Number, cIzvDokVrd Varchar2, cIzvDokBrd Varchar2
--
--                                 ) IS

  nDokGod Number := 2014;
  cDokVrd Varchar2(2) := '12';
  cDokBrd Varchar2 (7) := '222956';
  nIzvDokGod Number := 2014;
  cIzvDokVrd Varchar2(2) :='11';
  cIzvDokBrd Varchar2 (7) := '222956';


  cDodatniTip       Varchar2(20);
  cBrojNivelacije   Varchar2(7);
  cBrojNivelacije1  Varchar2(7);
  cVrstaNivelacije  Varchar2(3);
  cTrebaNivelacija  Varchar2(2) := 'NE';
  cDatumNiv         Varchar2(20);
  cVremeNiv         Varchar2(20);
  dDatum	    date;

  lPomocna          Boolean;-- Zbog poziva funkcije iz baze
  nGodinaVeznog     Number;
  cBrojVeznog       VarChar2(9);

  nPorez Number;
  nPoslovnica Number;
  cVrIzjave Varchar2(3);
  cPPartner Varchar2(7);
  cPP_isporuke Varchar2(7);
  nTipDok Number;
  nVrstaPrometa Number;


  Cursor K1 Is
               select stavka, proizvod
                    , LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,1
                    , 0 n, 0 n1, 0 n2, 1 n3, faktor , realizovano , rabat , porez
                    , npolje5, 1 n5, nPolje4
              from stavka_dok
              where godina = nIzvDokGod
                AND VRSTA_DOK = cIzvDokVrd
                and broj_Dok= cIzvDokBrd


              ;
  KK1 K1 % Rowtype;

--  cVlasnik Varchar2
BEGIN


  Select Poslovnica,vrsta_izjave,PPartner, PP_Isporuke, Tip_Dok, datum_dok
  Into nPoslovnica
     , cVrIzjave
     , cPPartner
     , cPP_isporuke
     , nTipDok
     , dDatum
  From dokument d
  Where godina = nDokGod
    and vrsta_dok=cDokVrd
    and broj_dok=cDokBrd;

  cTrebaNivelacija := 'NE';

  -- Tip magacina da li je obican ili VP . Pogledati f-ju
--  cDodatniTip := ltrim(rtrim(POrganizacioniDeo.OrgDeoOsnPod(  nOrgDeo, 'DODTIP' ))) ;
  cDodatniTip := ltrim(rtrim(POrganizacioniDeo.OrgDeoOsnPod(  nPoslovnica , 'DODTIP' ))) ;

/*
 dbms_output.put_line('* pravi_kalk_mp : '|| cDokBrd || '/'  || cDokVrd  || ' / ' || to_char(nDokGod)

         || NewLine || cDodatniTip
         ||' tip dok '|| to_char(nTipDok)
         || ' izv dok '|| cIzvDokVrd
         );
*/

  If upper(cDodatniTip) = 'MP' and nTipDok in (231,431) Then

     If    cDokVrd ='11' Then nVrstaPrometa :=1;
     ElsIf cDokVrd ='13' Then nVrstaPrometa :=-1;
     ElsIf cDokVrd ='12' Then nVrstaPrometa :=-11;
     ElsIf cDokVrd ='31' Then nVrstaPrometa :=10;
     End If;

     -- Provera ako je vec postojala nivelacija a povratnica po otpremnici je vracana u radnu verziju -- POCETAK
     lPomocna := PVezniDok.NadjiVezu( cDokVrd, nDokGod, cDokBrd,
                                      '89', nGodinaVeznog, cBrojVeznog );
     If nGodinaVeznog IS Not Null Then
        cTrebaNivelacija := 'NE';
     Else
        cTrebaNivelacija := 'DA';
     End If;

     -- Provera ako je vec postojala nivelacija a otpremnica vracana u radnu verziju -- KRAJ

     -- Pravi nivelaciju stavki - kolicine
     IF cTrebaNivelacija = 'DA' Then
        cBrojNivelacije  := To_Char( PSekvenca.NextVal( 'BROJ_KALKULACIJE_MP_CENE', nDokGod ) );
        cBrojNivelacije1 := To_Char( PSekvencaOrg.NextVal( 'BROJ_KALKULACIJE_MP_CENE', nDokGod ,nPoslovnica ) );

--        cBrojNivelacije  := '7';
--        cBrojNivelacije1 := '7';

        cVrstaNivelacije := '89';

 dbms_output.put_line('1 napravi_kalkulaciju_mp  *** '|| cBrojVeznog || ' *** ');
        ----------------------------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- Upisujem kalkulaciju u tabelu dokument
        Insert Into Dokument (        VRSTA_DOK,         BROJ_DOK,            GODINA, TIP_DOK,            DATUM_DOK, DATUM_UNOSA,            USER_ID,
                                       STATUS,            ORG_DEO,        BROJ_DOK1
                                , ppartner, pp_isporuke, mesto_isporuke
                                , poslovnica, datum_valute, CENA_PREVOZA, NACIN_OTPREME,FRANKO
                                , VRSTA_IZJAVE, VALUTA_PLACANJA, nPolje1
                              )
                    VALUES   (  cVrstaNivelacije, cBrojNivelacije, nDokGod,      99, dDatum,     Sysdate, USer,
                                            1, nPoslovnica, cBrojNivelacije1
                                , cPPartner, cPP_isporuke, 0
                                , 19, dDatum , 0 , 5, 5
                                , cVrIzjave, 0,nVrstaPrometa

                             );
        Commit;

 dbms_output.put_line('2 napravi_kalkulaciju_mp  *** '|| cBrojVeznog || ' *** ');
        Update Dokument
        Set Datum_Unosa = Datum_Unosa - 0.00001
        Where Godina    = nDokGod
          And Vrsta_Dok = cVrstaNivelacije
          And Broj_Dok  = cBrojNivelacije ;

        Commit;

 dbms_output.put_line('3 napravi_kalkulaciju_mp  *** '|| cBrojVeznog || ' *** ');
        -- sada regulise stanje u tabeli veza
        -- veza dokument koji se stornira(sifra=cDokVrd) - KALKULACIAJ MP CENE ( sifra = 89 )
        PVezniDok.DodajPar(             cDokVrd , nDokGod , cDokBrd,
                            cVrstaNivelacije , nDokGod , cBrojNivelacije );


        Commit;


 dbms_output.put_line('4 napravi_kalkulaciju_mp  *** '|| cBrojVeznog || ' *** ');
        -- PRavi vezu kalulaciaj MP cene - izjava kupca

 dbms_output.put_line('napravi_kalkulaciju_mp  *** '|| cBrojVeznog || ' *** ');


        -- veza KALKULACIJA MP CENE( sifra = 89 ) - izjava kupca (sifra=41)
        PVezniDok.DodajPar( cVrstaNivelacije , nDokGod , cBrojNivelacije ,
                            '41', nDokGod, '.' );


        Commit;

 dbms_output.put_line('5 napravi_kalkulaciju_mp  *** '|| cBrojVeznog || ' *** ');


        -- pravljenje stavki
        Open K1;
        Loop
        Fetch K1 into KK1;
        Exit When K1 % NotFound;

           nPorez := Pporez.ProcenatPoreza(nPoslovnica, kk1.Proizvod,dDatum,3);

--          IF :BUTTON_PALETTE.C_MALOPRODAJA_PO_CENI = '1' Then
             Insert Into Stavka_dok (  VRSTA_DOK,         BROJ_DOK,            GODINA, STAVKA
                                     , PROIZVOD
                                     , LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA
                                     , K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ
                                     , cena1, npolje1, npolje2, npolje3
                                    )
                             Values (
                                       cVrstaNivelacije, cBrojNivelacije, nDokGod, kk1.stavka
                                     , kk1.PROIZVOD
                                     , kk1.LOT_SERIJA, kk1.ROK, kk1.KOLICINA, kk1.JED_MERE, kk1.CENA, kk1.VALUTA,1
                                     , 0 , 0 , 0 , 1 , kk1.FAKTOR, kk1.REALIZOVANO, kk1.RABAT, kk1.POREZ
--                                     , kk1.npolje5, 1, nPorez, kk1.npolje4
--mbs?
--                                     , kk1.npolje4, 1, nPorez, kk1.npolje5

--ostali
                                     , kk1.cena1, 1, nPorez, kk1.npolje5

                                    );
--MBS
--          ELSE
--
--             Insert Into Stavka_dok (  VRSTA_DOK,         BROJ_DOK,            GODINA, STAVKA
--                                     , PROIZVOD
--                                     , LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA
--                                     , K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ
--                                     , cena1, npolje1, npolje2, npolje3
--                                    )
--                             Values (
--                                       cVrstaNivelacije, cBrojNivelacije, nDokGod, kk1.stavka
--                                     , kk1.PROIZVOD
--                                     , kk1.LOT_SERIJA, kk1.ROK, kk1.KOLICINA, kk1.JED_MERE, kk1.CENA, kk1.VALUTA,1
--                                     , 0 , 0 , 0 , 1 , kk1.FAKTOR, kk1.REALIZOVANO, kk1.RABAT, kk1.POREZ
--                                     , kk1.npolje4, 1, nPorez, kk1.npolje5
--                                    );
--          END IF;
        End loop;
        close K1;

        Commit;

 dbms_output.put_line('10 napravi_kalkulaciju_mp  *** '|| cBrojVeznog || ' *** ');
        ----------------------------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------------------------
     End If;
--  Else
--     NULL ;
  End If;
END;
