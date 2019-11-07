----77.0588
----

select kraj.org_deo kr_mag, kraj.proizvod kr_pro, kraj.stanje kr_stanje, kraj.vred kr_vred
     , round(kraj.vred / kraj.stanje, 4) cena_kraj
     , ps.org_deo, ps.proizvod, ps.stanje, ps.vred
     , round(ps.vred / ps.stanje, 4) cena_ps

from
	(
	select
	/*+ RULE */
	       d.org_deo
	     , proizvod
	     , sum(sd.kolicina*sd.faktor*k_robe) stanje
	     , round(sum(sd.kolicina*sd.faktor
	                 *
	                 (case when d.vrsta_dok = 80 then
	                           (sd.CENA1-sd.CENA)

	                  else k_robe*sd.cena
	                  end
	                 )
	                 ),2) vred
	from dokument d, stavka_dok sd
	Where
	  -- veza tabela
	      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
	  -----------------------------
	  -- ostali uslovi
	  and d.godina=&God
	  AND D.ORG_DEO = &Mag
	  and (k_robe <> 0 or d.vrsta_Dok = '80')
	Group by d.org_deo, proizvod
	) kraj
,
	(select
	/*+ RULE */
	       d.org_deo
	     , proizvod
	     , sum(sd.kolicina*sd.faktor*k_robe) stanje
	     , round(sum(sd.kolicina*sd.faktor*k_robe*sd.cena),2) vred
	from dokument d, stavka_dok sd
	Where
	  -- veza tabela
	      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
	  -----------------------------
	  -- ostali uslovi
	  and d.godina=&God+1
	  AND D.ORG_DEO = &Mag
	  and d.vrsta_dok in ('21')
	Group by d.org_deo, proizvod
	) ps

where kraj.org_deo = ps.org_deo
  and kraj.proizvod = ps.proizvod
