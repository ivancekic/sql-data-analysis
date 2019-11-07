DECLARE
  nGodinaDok        Number      := 2012;
--  cBrojDok          Varchar2(9) := '6383';
  nOrgDeo           NUMBER      := 103;

  cDodatniTip       Varchar2(20);
  cBrojNivelacije   Varchar2(9);
  cBrojNivelacije1  Varchar2(9);
  cVrstaNivelacije  Varchar2(3);
  cTrebaNivelacija  Varchar2(2) := 'DA';
  nUk Number := 0;

  cPraviNiv  Varchar2(2) := 'NE';

  Cursor ZaNiv_cursor Is
	select
	d.broj_dok1,d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo, d.user_id
	from dokument d, stavka_dok sd
	where d.godina = nGodinaDok
--	  and d.vrsta_Dok in (11,12,13,31)
	  and d.vrsta_Dok in (11,12,13,31)

	  AND D.ORG_DEO =nOrgDeo
	  and (d.godina , d.vrsta_Dok, d.broj_dok )
	       not in (Select godina , vrsta_Dok, broj_dok from vezni_Dok where za_vrsta_dok = 90)
	  and sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
	  and sd.cena <> round(sd.cena1*sd.faktor,4)
	  And d.status >=1
	group by d.broj_dok1, d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo, d.user_id
	order by org_deo, datum_unosa, datum_dok, vrsta_dok;


  ZaNiv ZaNiv_cursor % Rowtype;

BEGIN

  cDodatniTip := trim(PorganizacioniDeo.OrgDeoOsnPod( nOrgDeo , 'DODTIP'));
--  If upper(cDodatniTip) = upper('VP2') or upper(cDodatniTip) = upper('VP3') Then
  Dbms_Output.Put_line(lpad('RBR.',4)||'god '||' '|| 'vrd'||' '||lpad('id otp',7));
  Dbms_Output.Put_line(lpad('=',4,'=')||' '|| '===='||' '|| '==='||' '||lpad('=',7,'='));
     OPEN ZaNiv_cursor ;
     LOOP
     FETCH ZaNiv_cursor INTO ZaNiv ;
     EXIT WHEN ZaNiv_cursor % NOTFOUND ;
          nUk := nUk + 1;
          cTrebaNivelacija := 'DA' ;
          Dbms_Output.Put_line(lpad(to_char(nUk),4)||' '||to_char(ZaNiv.godina)||' '|| lpad(ZaNiv.Vrsta_dok,3)||' '||lpad(ZaNiv.Broj_dok,7));
--          Dbms_Output.Put_line('RBR. '|| to_char(nUk)||' vr_dok '||ZaNiv.Vrsta_dok|| '  br otp '|| ZaNiv.Broj_dok);

          IF cTrebaNivelacija = 'DA' And cPraviNiv = 'DA' Then
             cBrojNivelacije  := To_Char( PSekvenca.NextVal( 'Broj_nivelacije_po_stavci', nGodinaDok ) );
             cBrojNivelacije1 := To_Char( PSekvencaOrg.NextVal( 'Broj_nivelacije_po_stavci', nGodinaDok ,nOrgDeo) );
             cVrstaNivelacije := '90';
             Insert Into Dokument ( VRSTA_DOK, BROJ_DOK, GODINA, TIP_DOK, DATUM_DOK, DATUM_UNOSA, USER_ID, STATUS , ORG_DEO , BROJ_DOK1 )
                         VALUES   ( cVrstaNivelacije, cBrojNivelacije, nGodinaDok, 99, ZaNiv.Datum_Dok, Sysdate, User, 1,
                                    nOrgDeo, cBrojNivelacije1 );
             Commit;
             Update Dokument
             Set Datum_Unosa = Datum_Unosa - 0.00001
             --SYSDATE--to_date(to_char(to_number(to_char(Sysdate,'ddmmyyyyhh24miss'))-1),'dd.mm.yyyy hh24:mi:ss')
             Where Godina    = nGodinaDok
               And Vrsta_Dok = cVrstaNivelacije
               And Broj_Dok  = cBrojNivelacije ;
             Commit;
             -- veza OTPREMNICA (sifra=11) - NIVELACIJA CENE PO STAVCI ( sifra = 90 )
             PVezniDok.DodajPar( ZaNiv.Vrsta_Dok             ,nGodinaDok, ZaNiv.Broj_Dok,
                                 cVrstaNivelacije ,nGodinaDok, cBrojNivelacije );
             Commit;
          End If;
     END LOOP;
     CLOSE ZaNiv_cursor ;
-- End If;
END;
