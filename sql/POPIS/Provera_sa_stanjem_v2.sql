select POPISNA_LISTA,PL_ORG_DEO,PL_DATUM,STATUS,PL_PROIZVOD,PO_KNJIGAMA, PO_POPISU
     , stanje stanje_kraj
     , d1.kolicina kol_ps
from
(
	select P.POPISNA_LISTA, p.org_deo pl_org_deo, P.datum pl_datum, p.status
	     , sp.proizvod pl_proizvod, sp.po_knjigama, sp.PO_POPISU

	from STAVKA_POPISA SP, POPIS P
	WHERE
	      P.GODINA = &nGod
	  and p.org_deo = NVL(&nOrgDeo,p.org_deo)
	  AND P.POPISNA_LISTA = SP.POPISNA_LISTA
	  AND P.GODINA = SP.GODINA
) p

	    ,(
	        Select org_deo, proizvod, round(sum(kolicina*faktor*k_robe),5) stanje
	        From Dokument d1, stavka_dok sd1
	        Where d1.godina = &nGod and d1.status > 0 and sd1.k_robe <> 0
	          and sd1.godina   = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
	          and k_robe <> 0
	        Group by d1.org_deo, sd1.proizvod
	       ) d

	    ,(
	        Select org_deo, proizvod, kolicina
	        From Dokument d1, stavka_dok sd1
	        Where d1.godina = &nGod + 1 and d1.status > 0 and d1.vrsta_dok='21'
	          and sd1.godina   = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
	          and k_robe <> 0
	       ) d1

Where d.org_Deo (+)  = p.pl_org_deo
  and d.proizvod (+) = p.pl_proizvod
  and d1.org_Deo (+)  = p.pl_org_deo
  and d1.proizvod (+) = p.pl_proizvod

  and
  (
		  nvl(stanje,0) <> PO_POPISU
	  or
		  nvl(stanje,0) <> PO_KNJIGAMA
  )
  and PO_POPISU<>STANJE
--and pl_proizvod in (399,10088)
order by to_number(p.popisna_lista)
