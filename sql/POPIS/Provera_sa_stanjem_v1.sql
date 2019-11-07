Select POPISNA_LISTA, pl_org_deo, pl_DATUM, pl_proizvod, PO_KNJIGAMA
     , ( case when MAX_DAT_PS != NULL Then
              MAX_DAT_PS
         else
	       (Select min(d1.datum_dok) From Dokument d1, stavka_dok sd1
	        Where d1.vrsta_dok != 21 and d1.org_deo = pl_org_deo and k_robe <> 0
	          and sd1.godina   = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
	          and sd1.proizvod = pl_proizvod
	          and d1.datum_dok < pl_datum
	        Group by d1.org_deo
	       )
         end
       ) dat_stanja

From
(
	select P.POPISNA_LISTA, p.org_deo pl_org_deo, P.datum pl_datum
	     , sp.proizvod pl_proizvod, sp.po_knjigama
	     , (Select max(d1.datum_dok) From Dokument d1, stavka_dok sd1
	        Where d1.vrsta_dok = 21 and d1.org_deo   = p.org_deo
	          and sd1.godina   = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
	          and sd1.proizvod = sp.proizvod
	          and d1.datum_dok < p.datum
	        Group by d1.org_deo
	       ) max_dat_ps
	--SP.ROWID, SP.*,P.*
	from STAVKA_POPISA SP, POPIS P
	WHERE P.POPISNA_LISTA = 7
	  AND P.GODINA = 2009
	--      P.datum = to_date('19.09.2009','dd.mm.yyyy')
	  AND P.POPISNA_LISTA = SP.POPISNA_LISTA
	  AND P.GODINA = SP.GODINA
	--  AND PROIZVOD = 350134
)
