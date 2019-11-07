Declare
  nGodina Number := 2011;

  Cursor StavSlog_CUR Is
		select * from
		(
		Select d.broj_dok1,d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo
		from dokument d
		where godina = nGodina
		  and vrsta_Dok = 90
		  AND D.ORG_DEO BETWEEN 104 AND 104
		  and (d.godina , d.vrsta_Dok, d.broj_dok ) not in (Select godina , vrsta_Dok, broj_dok from vezni_Dok)

		union

		select d.broj_dok1,d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo
		from dokument d, stavka_dok sd
		where d.godina = nGodina
		  and d.vrsta_Dok in (11,12,13,31)
		  AND D.ORG_DEO BETWEEN 104 AND 104
		  and (d.godina , d.vrsta_Dok, d.broj_dok )
		       not in (Select godina , vrsta_Dok, broj_dok from vezni_Dok where za_vrsta_dok = 90)
		  and sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
		  and sd.cena <> sd.cena1

		group by d.broj_dok1, d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo
		)
		order by org_deo, datum_unosa, datum_dok, vrsta_dok;
  StavSlog StavSlog_CUR % Rowtype;

  cBrojNivelacije   Varchar2(7);
  cBrojNivelacije1  Varchar2(7);
  cVrstaNivelacije  Varchar2(3);
  cTrebaNivelacija  Varchar2(2) := 'NE';
  cDatumNiv         Varchar2(20);
  cVremeNiv         Varchar2(20);

  lPomocna          Boolean;-- Zbog poziva funkcije iz baze
  nGodinaVeznog     Number;
  cBrojVeznog       VarChar2(9);

Begin

    dbms_output.put_line( lpad('BR1',9)||' '||
                          lpad('BRD',9)||' '||
                          lpad('VRD',3)||' '||
                          lpad('GOD',4)||' '||
                          lpad('DATUM_DOK',10)||' '||
                          lpad('DATUM_UNOSA',19)||' '||
                          lpad('MAG',5)
                         );

    dbms_output.put_line( lpad('-',9,'-')||' '||
                          lpad('-',9,'-')||' '||
                          lpad('-',3,'-')||' '||
                          lpad('-',4,'-')||' '||
                          lpad('-',10,'-')||' '||
                          lpad('-',19,'-')||' '||
                          lpad('-',5,'-')
                         );
    OPEN StavSlog_CUR ;
    LOOP
    FETCH StavSlog_CUR INTO StavSlog ;
    EXIT WHEN StavSlog_CUR % NOTFOUND ;
    dbms_output.put_line( lpad(StavSlog.Broj_dok1,9)||' '||
                          lpad(StavSlog.Broj_dok,9)||' '||
                          lpad(StavSlog.vrsta_dok,3)||' '||
                          lpad(to_char(StavSlog.godina,'0000'),4)||' '||
                          lpad(to_char(StavSlog.DATUM_DOK,'dd.mm.yyyy'),10)||' '||
                          lpad(to_char(StavSlog.DATUM_unosa,'dd.mm.yyyy mm:hh24:ss'),19)||' '||
                          lpad(to_char(StavSlog.org_deo),5)
                         );

     IF cTrebaNivelacija = 'DA' Then
        cBrojNivelacije  := To_Char( PSekvenca.NextVal( 'Broj_nivelacije_po_stavci', StavSlog.Godina ) );
        cBrojNivelacije1 := To_Char( PSekvencaOrg.NextVal( 'Broj_nivelacije_po_stavci', StavSlog.Godina ,StavSlog.Org_Deo) );
        cVrstaNivelacije := '90';
        ----------------------------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- Upisujem kalkulaciju u tabelu dokument
        Insert Into Dokument (        VRSTA_DOK,         BROJ_DOK,            GODINA, TIP_DOK,            DATUM_DOK, DATUM_UNOSA,            USER_ID,
                                       STATUS,            ORG_DEO,        BROJ_DOK1 )
                    VALUES   (  cVrstaNivelacije, cBrojNivelacije, StavSlog.Godina,      99, StavSlog.Datum_Dok,     Sysdate, USER,
                                            1, StavSlog.Org_deo, cBrojNivelacije1 );
        Commit;

        cDatumNiv := to_char(sysdate,'yyyymmdd');
        cVremeNiv := to_char(to_number(to_char(sysdate,'hh24miss'))-1);

        Update Dokument
        Set Datum_Unosa = to_date(to_char(to_date(cDatumNiv || cVremeNiv,'yyyymmddhh24miss'),'dd.mm.yyyy hh24:mi:ss'),'dd.mm.yyyy hh24:mi:ss')
        Where Godina    = StavSlog.Godina
          And Vrsta_Dok = cVrstaNivelacije
          And Broj_Dok  = cBrojNivelacije ;

        Commit;

        -- sada regulise stanje u tabeli veza
        -- veza OTPREMNICA (sifra=11) - NIVELACIJA CENE PO STAVCI ( sifra = 90 )
        PVezniDok.DodajPar( StavSlog.vrsta_dok , StavSlog.Godina , StavSlog.Broj_Dok,
                            cVrstaNivelacije   , StavSlog.Godina , cBrojNivelacije   );

        Commit;

        dbms_output.put_line('Desila se nivelacija stavke br.: '||
                 to_char(StavSlog.Org_deo) ||'-'|| cBrojNivelacije1 ||' (id.dok.'|| cBrojNivelacije ||') /'|| to_char(StavSlog.Godina)||' !');
        ----------------------------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------------------------
     End If;
    End loop;
    Close StavSlog_CUR ;

End;
