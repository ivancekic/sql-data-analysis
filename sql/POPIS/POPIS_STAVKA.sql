   Select

   sp.rowid,
   P.POPISNA_LISTA, p.org_deo, p.datum, p.DATUM_UNOSA, p.status
--   , count(*) uk_stavki
        , sp.STAVKA, sp.proizvod,  sp.lot_serija, sp.po_knjigama, sp.PO_popisu,sp.KONTROLNA_KNJIGE,sp.KONTROLNA_POPIS
		, pr.tip_proizvoda pro_tip
--		, Case when tp.cena = 1 Then
----		       PProsecniCenovnik.Cena( sp.Proizvod ,p.Datum , 1 )
--PravaProsCena(p.org_deo,sp.proizvod, to_date('01.01.'||to_char(&nGod),'dd.mm.yyyy'), to_date('31.12.'||to_char(&nGod),'dd.mm.yyyy'))
--		  when tp.cena = 2 Then
--   		       PPlanskiCenovnik.Cena( sp.Proizvod ,p.Datum , 'YUD' , 1 )
--		  when tp.cena = 3 Then
--		       PProdajniCenovnik.Cena( sp.Proizvod ,p.Datum , 'YUD' , 1 )
--		  End cena_odg
--
----        , PravaProsCena(p.org_deo,sp.proizvod, to_date('01.01.'||to_char(&nGod),'dd.mm.yyyy'), to_date('31.12.'||to_char(&nGod),'dd.mm.yyyy')) pros_c

   From STAVKA_POPISA SP, POPIS P, proizvod pr, tip_proizvoda tp
   WHERE
--   P.datum         = to_date('19.09.2009','dd.mm.yyyy')
         p.godina = &nGod
     AND P.POPISNA_LISTA = &nPopis
     AND P.POPISNA_LISTA = SP.POPISNA_LISTA
     AND P.GODINA        = SP.GODINA
--   Group by P.POPISNA_LISTA, p.org_deo, p.datum, p.DATUM_UNOSA
     and pr.sifra = sp.proizvod
     and tp.sifra = pr.tip_proizvoda


--and		  Case when tp.cena = 1 Then
----		       PProsecniCenovnik.Cena( sp.Proizvod ,p.Datum , 1 )
--PravaProsCena(p.org_deo,sp.proizvod, to_date('01.01.'||to_char(&nGod),'dd.mm.yyyy'), to_date('31.12.'||to_char(&nGod),'dd.mm.yyyy'))
--		  when tp.cena = 2 Then
--   		       PPlanskiCenovnik.Cena( sp.Proizvod ,p.Datum , 'YUD' , 1 )
--		  when tp.cena = 3 Then
--		       PProdajniCenovnik.Cena( sp.Proizvod ,p.Datum , 'YUD' , 1 )
--		  End < 0
   Order by to_number(P.POPISNA_LISTA)
