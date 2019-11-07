
	select d.org_deo, porganizacioniDeo.naziv(org_deo) naziv

	from zalihe d
	where

 org_deo not in (select magacin from partner_magacin_flag)
 and org_deo not in (9991)
 and stanje > 0
--		 and org_deo not in
--		 (
--
--			select d.org_deo
--
--			from dokument d, stavka_dok sd
--			where d.godina    = 2013
--			  and d.status    > 0
--			  and sd.vrsta_dok = d.vrsta_dok
--			  and sd.broj_dok  = d.broj_dok
--			  and sd.godina    = d.godina
--
--		and org_deo not in (select magacin from partner_magacin_flag)
--
--		group by org_deo
--
--		 )
group by org_deo
ORDER BY
d.org_deo
