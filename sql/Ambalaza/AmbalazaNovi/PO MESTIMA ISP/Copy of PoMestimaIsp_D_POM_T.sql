declare
   -- promenljive o robnom dokumentu za dokument ambalaze
   cVrstaDok VarChar2 ( 2 );
   cBrojDok  VarChar2( 9 );
   nGodina   Number;
   nMisp     Number;

   lPomocna Boolean;
   nGodinaVeznog Number;
   cBrojVeznog VarChar2( 9 );

Cursor MOJ_cur IS
    Select pp.teren, obl.naziv naziv_ter,
	       pp.sifra, pp.naziv naziv_partner,
	       d.Godina ,d.vrsta_dok, d.broj_dok,
	       d.tip_dok,
	       sd.Proizvod, P.Naziv pro_naziv,
	       ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz,
	       ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz,
	       ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje,
	       p.Jed_Mere JedMere,
	       (case when Tip_dok != 204 Then
	             (case when d.vrsta_dok = '3' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '11'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '11' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '3'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '12' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '4'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '5' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '13'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '30' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '31'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '13' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '5'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '31' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '30'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '61' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '3'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '63' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '3'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '62' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '4'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when d.vrsta_dok = '64' Then -- za prijemnicu -- trazi otpremnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '4'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       when cVrstaDok = '4' Then -- za storno prijemnicu
                       (select d1.mesto_isporuke From vezni_dok vd, dokument d1
                        where vd.za_Vrsta_dok = '4'
                          and d.vrsta_dok = vd.Vrsta_Dok And d.broj_dok = vd.Broj_Dok And d.Godina = vd.Godina
                          and d1.Vrsta_Dok = vd.za_Vrsta_Dok And d1.Broj_Dok = vd.za_Broj_Dok And d1.Godina = vd.za_Godina
                       )
                       
            cVrstaPom := '3';      -- trazi prijemnicu
            lPomocna := PVezniDok.NadjiVezu( cVrstaDok, nGodinaDok, cBrojDok,
                                             cVrstaPom, nGodinaVeznog, cBrojVeznog);
            cVrstaPom := '11';      -- trazi otpremnicu
            lPomocna := PVezniDok.NadjiVezu( '3', nGodinaVeznog, cBrojVeznog,
                                             cVrstaPom, nGodinaVeznog, cBrojVeznog);
            cVrstaPom := '12';      -- trazi storno otpremnicu
            lPomocna := PVezniDok.NadjiVezu( '11', nGodinaVeznog, cBrojVeznog,
                                             cVrstaPom, nGodinaVeznog, cBrojVeznog);
                       
                       
	              End
	              )
	        else
	           Mesto_isporuke
	        End) mesto_isporuke,
	       
	From Dokument d, Stavka_Dok sd, Proizvod p, Poslovni_partner pp, Oblast Obl
	Where d.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 )
	  And d.Status > 0
	  And d.Org_Deo In (Select Magacin From Partner_magacin_Flag, Poslovni_Partner pp
	                    Where PPartner Between '0' And '9999999' And Teren Between 0 And 9999999 )
	  And d.Datum_Dok Between To_Date('01.01.'||To_Char( sysdate, 'yyyy' ),'dd.mm.yyyy') And sysdate
	  And Teren Between  0 And 9999999
	  And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
	  And sd.Proizvod Between  '0' And '9999999' And sd.K_Robe != 0
	  And d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
	  And sd.Proizvod = p.Sifra And d.ppartner = pp.sifra and Obl.Id = pp.Teren
	Group By pp.teren, obl.naziv, pp.sifra, pp.naziv, d.Godina, d.vrsta_dok, d.broj_dok, d.tip_dok, sd.Proizvod, P.Naziv, Mesto_isporuke, P.Jed_Mere
	Order By pp.teren, pp.naziv, P.Naziv;
    Moj MOJ_cur % Rowtype;
Begin
   DELETE FROM DEJA_POMOCNA_TAB WHERE POLJE39 = '40' AND POLJE40 <> '40 kolone pal izv';
   COMMIT;
   Open MOJ_cur;
   Loop
   Fetch MOJ_cur Into MOJ;
   Exit When MOJ_cur % NotFound;
            -- tip 204 je razduzenje ambalaze i on nema robni dokument
--        If Moj.Tip_Dok != 204 Then
--            MagKartica.NadjiRobniDokument( MOJ.Vrsta_Dok,MOJ.Godina,MOJ.Broj_Dok,
--                                           cVrstaDok, nGodina, cBrojDok );
--        End If;
--        Select Mesto_isporuke into nMisp From Dokument
--        Where Vrsta_dok = cVrstaDok And godina = nGodina And Broj_dok = cBrojDok;

        insert into deja_pomocna_tab(polje1,polje2,polje3,polje4,polje5,polje6,polje7,polje8,polje9,polje10,polje11,
                                     polje12,polje13,POLJE14,POLJE15,POLJE16,POLJE17,polje39,polje40)
                              VALUES(MOJ.TEREN,MOJ.NAZIV_TER,MOJ.SIFRA,MOJ.NAZIV_PARTNER,MOJ.VRSTA_DOK,MOJ.BROJ_DOK,MOJ.TIP_DOK,
                                     nGodina,cVrstaDok,	cBrojDok,
                                     MOJ.PROIZVOD,MOJ.PRO_NAZIV,MOJ.ULAZ,MOJ.IZLAZ,MOJ.STANJE,MOJ.JEDMERE,Moj.mesto_isporuke,'40','kolone pal izv');
   End Loop;
   Close MOJ_cur;
End;
/
SELECT polje1,polje2,polje3,polje4,polje5,polje6,polje7,polje8,polje9,polje10,polje11,polje12,polje13,POLJE14,POLJE15,POLJE16,POLJE17,polje39,polje40
FROM DEJA_POMOCNA_TAB
WHERE POLJE39 = '40'
ORDER BY POLJE40;
