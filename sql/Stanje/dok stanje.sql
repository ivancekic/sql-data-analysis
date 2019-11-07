select * from
(
	select d.org_deo, sd.proizvod, sum(sd.kolicina*sd.faktor*sd.k_robe) kol
	from dokument d, stavka_dok sd
	Where
	  -- veza tabela
	      sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok

	  and d.godina in (2013)
	  and d.status > 0
	  and d.org_deo in (103,104,105,106,107,108)
	  and sd.k_robe <> 0
	group by
	d.org_Deo,SD.PROIZVOD
) d
,
zalihe z
where z.org_deo (+) = d.org_Deo
and z.proizvod (+) = d.proizvod
and z.stanje <> d.kol
order by
d.org_Deo,D.PROIZVOD
