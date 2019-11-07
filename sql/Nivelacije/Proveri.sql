DECLARE
  nGodinaDok        Number      := 2009;
  cBrojDok          Varchar2(9) := '6383';
  nOrgDeo           NUMBER      := 198;

  cDodatniTip       Varchar2(20);
  cBrojNivelacije   Varchar2(7);
  cBrojNivelacije1  Varchar2(7);
  cVrstaNivelacije  Varchar2(3);
  cTrebaNivelacija  Varchar2(2) := 'NE';

BEGIN
  Begin
    Select DODATNI_TIP
    Into cDodatniTip
    From ORG_DEO_OSN_PODACI
    Where ORG_DEO = nOrgDeo;

    Exception When No_data_found Then
       cDodatniTip := '-1' ;
  End ;

  Dbms_output.Put_line('Dodatni tip '|| cDodatniTip );

--  cDodatniTip := ORG_DEO_DODATNI_TIP ( nOrgDeo );
  If upper(cDodatniTip) = upper('VP2') Then--or upper(cDodatniTip) = upper('VP3') Then
     For ZaNivelaciju in (Select Cena , Cena1
                          From Stavka_Dok
                          Where Godina    = nGodinaDok
                            And Vrsta_dok = '11'
                            And Broj_Dok  = cBrojDok
                         )
     Loop
       If nvl(ZaNivelaciju.Cena,0) <>  nvl(ZaNivelaciju.Cena1,0) Then
          cTrebaNivelacija := 'DA' ;
          IF cTrebaNivelacija = 'DA' Then
          --        cBrojNivelacije  := To_Char( PSekvenca.NextVal( 'Broj_nivelacije_po_stavci', :Zaglavlje.Godina ) );
          --        cBrojNivelacije1 := To_Char( PSekvencaOrg.NextVal( 'Broj_nivelacije_po_stavci', :Zaglavlje.Godina ,:Zaglavlje.Org_Deo) );
          --        cVrstaNivelacije := '90';
             GoTo NapraviNivelaciju ;
          End If;
       End If;
     End loop;
  Else
--     GoTo KRAJ ;
    Dbms_output.Put_line('NIJE se desila nivelacija. Hvala.');
  End If;

  <<NapraviNivelaciju>>
  -- Upisujem kalkulaciju u tabelu dokument
--  Insert Into Dokument ( VRSTA_DOK, BROJ_DOK, GODINA, TIP_DOK, DATUM_DOK, DATUM_UNOSA, USER_ID, STATUS , ORG_DEO , BROJ_DOK1 )
--              VALUES   ( cVrstaNivelacije, cBrojNivelacije, :Zaglavlje.Godina, 99, :Zaglavlje.Datum_Dok, Sysdate, :Zaglavlje.User_Id, 1,
--                         :Zaglavlje.Org_deo, cBrojNivelacije1 );
--  Update Dokument
--  Set Datum_Unosa = to_date(to_char(to_number(to_char(Sysdate,'ddmmyyyyhh24miss'))-1),'dd.mm.yyyy hh24:mi:ss')
--  Where Godina    = :Zaglavlje.Godina
--    And Vrsta_Dok = cVrstaNivelacije
--    And Broj_Dok  = cBrojNivelacije ;
--
---- to_date(to_char(to_number(to_char(Sysdate,'ddmmyyyyhh24miss'))-1),'dd.mm.yyyy hh24:mi:ss')
--  -- sada regulise stanje u tabeli veza
--  -- veza OTPREMNICA (sifra=11) - NIVELACIJA CENE PO STAVCI ( sifra = 90 )
--  DodajVezu( '11'       , :Zaglavlje.Godina , :Zaglavlje.Broj_Dok,
--             cVrstaNivelacije , :Zaglavlje.Godina , cBrojNivelacije );
--
--  Commit;
  Dbms_output.Put_line('Desila se nivelacija. Odstampajte je. Hvala.');

--  <<KRAJ>>
--  Dbms_output.Put_line('NIJE se desila nivelacija. Hvala.');
END;
