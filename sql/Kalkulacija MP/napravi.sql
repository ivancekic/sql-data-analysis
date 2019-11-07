Declare

  nOrgDeo NUmber;
  cDodatniTip       Varchar2(20);
  cBrojNivelacije   Varchar2(7);
  cBrojNivelacije1  Varchar2(7);
  cVrstaNivelacije  Varchar2(3);
  cTrebaNivelacija  Varchar2(2) := 'NE';
  cDatumNiv         Varchar2(20);
  cVremeNiv         Varchar2(20);

  lPomocna          Boolean;-- Zbog poziva funkcije iz baze
  nGodinaVeznog     Number;
  cBrojVeznog       VarChar2(9);

  nPoslov Number ;

  nProdObjekat NUmber;
  cUser VarChar2(30);
  cMisp Varchar2(7)  ;
  cPPart Varchar2(7) ;

  cDokVrd VarChar2(2) ;
  nDokGod Number ;
  cDokBrd VarChar2(9);
  dDokDatum Date;

  nVrstaPrometa Number;

BEGIN

  cTrebaNivelacija := 'NE';

  cDokVrd := '13';
  nDokGod := 2013;
  cDokBrd := '54';

  cUser :=
--  cUser		-- PEKARA
  'MILAN'	-- MBS
  ;

  cMisp := '3'; -- MBS;
--  cMisp := '4'; -- PEKARA;

  nProdObjekat :=1383;	-- MBS
--  nProdObjekat :=214;	-- PEKARA
  cPPart :='0';	--MBS
--  cPPart :='1';	--PEKARA

  nPoslov := 14;	-- MBS
--  nPoslov := 19;	-- PEKARA

  -- Tip magacina da li je obican ili VP . Pogledati f-ju
  cDodatniTip := trim(POrganizacioniDeo.OrgDeoOsnPod ( nProdObjekat,'DODTIP' ) ) ;

  If upper(cDodatniTip) = 'MP' Then
     If cDokVrd='11' Then nVrstaPrometa :=1;
     ElsIf cDokVrd='13' Then nVrstaPrometa :=-1;
     ElsIf cDokVrd='12' Then nVrstaPrometa :=10;
     ElsIf cDokVrd='31' Then nVrstaPrometa :=-11;
     End If;
     -- Provera ako je vec postojala nivelacija a otpremnica vracana u radnu verziju -- POCETAK
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
        cBrojNivelacije1 := To_Char( PSekvencaOrg.NextVal( 'BROJ_KALKULACIJE_MP_CENE', nDokGod ,nProdObjekat) );
        cVrstaNivelacije := '89';

        DBMS_OUTPUT.PUT_LINE('Napravio sekvencu');

        Select Datum_Dok into dDokDatum
        From dokument
        Where Godina = nDokGod
          and Vrsta_dok= cDokVrd
          and broj_dok=cDokBrd
        ;
        ----------------------------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- Upisujem kalkulaciju u tabelu dokument
        Insert Into Dokument (  VRSTA_DOK,  BROJ_DOK,  GODINA, TIP_DOK,   DATUM_DOK, DATUM_UNOSA,            USER_ID,
                                       STATUS,            ORG_DEO,        BROJ_DOK1
                                , ppartner, pp_isporuke, mesto_isporuke
                                , poslovnica, datum_valute, CENA_PREVOZA, NACIN_OTPREME,FRANKO
                                , VRSTA_IZJAVE, VALUTA_PLACANJA, nPolje1

                              )
        SELECT
--                    VALUES   (
                                cVrstaNivelacije, cBrojNivelacije, nDokGod,      99, Datum_Dok,     Sysdate, cUser
                                , 1, nProdObjekat, cBrojNivelacije1
                                , cPPart, cPPart, cMisp
                                , nPoslov, Datum_Dok , 0 , 5, 5
                                , VRSTA_IZJAVE, 0,nVrstaPrometa



--                             )
        FROM DOKUMENT
        WHERE GODINA=  nDokGod AND VRSTA_DOK=cDokVrd AND BROJ_DOK= cDokBrd
        ;
        DBMS_OUTPUT.PUT_LINE('Napravio dok');
        Commit;

        Update Dokument
        Set Datum_Unosa = Datum_Unosa - 0.00001
        Where Godina    = nDokGod
          And Vrsta_Dok = cVrstaNivelacije
          And Broj_Dok  = cBrojNivelacije ;

        Commit;
        DBMS_OUTPUT.PUT_LINE('Napravio datum');
        -- sada regulise stanje u tabeli veza
        -- veza OTPREMNICA (sifra=11) - NIVELACIJA CENE PO STAVCI ( sifra = 89 )
--        PVezniDok.DodajPar(             cDokVrd , nDokGod , cDokBrd,
--                            cVrstaNivelacije , nDokGod , cBrojNivelacije );

        PVezniDok.DodajPar(             cDokVrd , nDokGod , cDokBrd,
                            cVrstaNivelacije , nDokGod , cBrojNivelacije );



        -- veza KALKULACIJA MP CENE( sifra = 89 ) - izjava kupca (sifra=41)
--        PVezniDok.DodajPar( cVrstaNivelacije , nDokGod , cBrojNivelacije ,
--                            '41', nDokGod, '.' );
        PVezniDok.DodajPar( cVrstaNivelacije , 2013 , cBrojNivelacije ,
                            '41', 2013, '.' );


        Commit;
        DBMS_OUTPUT.PUT_LINE('Napravio vezni dok - kalk');


           Insert Into Stavka_dok (  VRSTA_DOK,         BROJ_DOK,            GODINA, STAVKA
                                   , PROIZVOD
                                   , LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA
                                   , K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ
                                   , cena1, npolje1, npolje2, npolje3
                                  )
           SELECT
--                                  (
                                     cVrstaNivelacije, cBrojNivelacije, nDokGod, stavka
                                   , PROIZVOD
                                   , LOT_SERIJA, ROK, KOLICINA, JED_MERE, CENA, VALUTA,1
                                   , 0 , 0 , 0 , 1 , FAKTOR, REALIZOVANO, RABAT, POREZ
                                   , npolje5, 1
--                                   , Pporez.ProcenatPoreza(nProdObjekat, Proizvod,dDokDatum,3)
                                   , 20
                                   , npolje4

--                                  )
--           FROM STAVKA_DOK WHERE GODINA=nDokGod AND VRSTA_DOK=cDokVrd AND BROJ_DOK=cDokBrd
           FROM STAVKA_DOK WHERE GODINA=2013 AND VRSTA_DOK='13' AND BROJ_DOK='54'
        ;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Napravio stavke');
        ----------------------------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------------------------
     End If;
--  Else
--     NULL ;
  End If;
END;
