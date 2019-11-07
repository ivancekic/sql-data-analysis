select * from
(
	select d.org_deo, porganizacioniDeo.naziv(org_deo) naziv, 'DA' promet_2013

	from dokument d, stavka_dok sd
	where d.godina    = 2013
	  and d.status    > 0
	  and sd.vrsta_dok = d.vrsta_dok
	  and sd.broj_dok  = d.broj_dok
	  and sd.godina    = d.godina

and org_deo not in (select magacin from partner_magacin_flag)
--and org_deo in (6314,6324)

group by org_deo

union
select id org_deo, naziv, ' ' promet_2013 from organizacioni_deo
where id in (6314,6324)
)

ORDER BY
org_deo
