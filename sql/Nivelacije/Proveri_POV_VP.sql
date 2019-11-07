DECLARE
  nGodinaDok        Number      := 2009;
  cBrojDok          Varchar2(9) := '6383';
  nOrgDeo           NUMBER      := -15;
  nOldOrgDeo        Number      := -5;

  cOldBrojDok       Varchar2(9) := '-987456';

  cDodatniTip       Varchar2(20);
  cBrojNivelacije   Varchar2(7);
  cBrojNivelacije1  Varchar2(7);
  cVrstaNivelacije  Varchar2(3);
  cTrebaNivelacija  Varchar2(2) := 'NE';


BEGIN
--  Begin
--    Select DODATNI_TIP
--    Into cDodatniTip
--    From ORG_DEO_OSN_PODACI
--    Where ORG_DEO = nOrgDeo;
--
--    Exception When No_data_found Then
--       cDodatniTip := '-1' ;
--  End ;
--
--  Dbms_output.Put_line('Dodatni tip '|| cDodatniTip );

--  cDodatniTip := ORG_DEO_DODATNI_TIP ( nOrgDeo );
--  If upper(cDodatniTip) = upper('VP') Then--or upper(cDodatniTip) = upper('VP3') Then
     For ZaNivelaciju in (SELECT D.DATUM_DOK, SD.broj_dok,SD.vrsta_dok,SD.godina, SD.CENA, SD.CENA1, d.org_deo
                          FROM stavka_dok sd , dokument d, ORG_DEO_OSN_PODACI ORG
                          WHERE (SD.broj_dok,SD.vrsta_dok,SD.godina)
                                 in ( Select distinct broj_dok,vrsta_dok,godina
                                      From ( select * from vezni_dok where za_vrsta_dok = 11 and vrsta_dok = 13
                                      UNION ALL
                                      Select BROJ_DOK,VRSTA_DOK,GODINA,BROJ_DOK,VRSTA_DOK,GODINA from vezni_dok where vrsta_dok = 11
                                    )
                                 Where za_vrsta_dok = 11
                                )
                          AND SD.CENA<>SD.CENA1
                          AND (SD.broj_dok,SD.vrsta_dok,SD.godina)
                               NOT IN (SELECT broj_dok, vrsta_dok, godina FROM VEZNI_DOK WHERE ZA_VRSTA_DOK = '90' )
                               AND DODATNI_TIP in( 'VP')
                               AND datum_dok >= to_date('01.01.2009','dd.mm.yyyy')
                               AND sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
                               AND D.ORG_dEO = ORG.ORG_DEO
                               ORDER BY D.DATUM_DOK, SD.godina, TO_NUMBER(SD.vrsta_dok),TO_NUMBER(SD.broj_dok)
                         )
     Loop
       If nvl(ZaNivelaciju.Cena,0) <>  nvl(ZaNivelaciju.Cena1,0) Then
--          cTrebaNivelacija := 'DA' ;
--          IF cTrebaNivelacija = 'DA' Then
          --        cBrojNivelacije  := To_Char( PSekvenca.NextVal( 'Broj_nivelacije_po_stavci', ZaNivelaciju.Godina ) );
          --        cBrojNivelacije1 := To_Char( PSekvencaOrg.NextVal( 'Broj_nivelacije_po_stavci', ZaNivelaciju.Godina ,ZaNivelaciju.Org_Deo) );
          --        cVrstaNivelacije := '90';
--             GoTo NapraviNivelaciju ;
             If nvl(cOldBrojDok,'-987456') <> nvl(ZaNivelaciju.Broj_dok,'-987456') then
                Dbms_output.Put_line('Desice se nivelacija. Odstampajte je. Hvala.');
             End if;
                cOldBrojDok := ZaNivelaciju.Broj_dok;
--          End If;
       End If;
     End loop;
--  Else
--    Dbms_output.Put_line('NIJE se desila nivelacija. Hvala.');
--  End If;

--------  <<NapraviNivelaciju>>
--------  -- Upisujem kalkulaciju u tabelu dokument
----------  Insert Into Dokument ( VRSTA_DOK, BROJ_DOK, GODINA, TIP_DOK, DATUM_DOK, DATUM_UNOSA, USER_ID, STATUS , ORG_DEO , BROJ_DOK1 )
----------              VALUES   ( cVrstaNivelacije, cBrojNivelacije, :Zaglavlje.Godina, 99, :Zaglavlje.Datum_Dok, Sysdate, :Zaglavlje.User_Id, 1,
----------                         :Zaglavlje.Org_deo, cBrojNivelacije1 );
----------  Update Dokument
----------  Set Datum_Unosa = to_date(to_char(to_number(to_char(Sysdate,'ddmmyyyyhh24miss'))-1),'dd.mm.yyyy hh24:mi:ss')
----------  Where Godina    = :Zaglavlje.Godina
----------    And Vrsta_Dok = cVrstaNivelacije
----------    And Broj_Dok  = cBrojNivelacije ;
----------
------------ to_date(to_char(to_number(to_char(Sysdate,'ddmmyyyyhh24miss'))-1),'dd.mm.yyyy hh24:mi:ss')
----------  -- sada regulise stanje u tabeli veza
----------  -- veza OTPREMNICA (sifra=11) - NIVELACIJA CENE PO STAVCI ( sifra = 90 )
----------  DodajVezu( '11'       , :Zaglavlje.Godina , :Zaglavlje.Broj_Dok,
----------             cVrstaNivelacije , :Zaglavlje.Godina , cBrojNivelacije );
----------
----------  Commit;
--------  Dbms_output.Put_line('Desila se nivelacija. Odstampajte je. Hvala.');
END;
