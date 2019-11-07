			select

			       d.broj_dok BRD, D.VRSTA_DOK VRD, D.GODINA GOD, D.STATUS STAT, datum_dok, d.datum_unosa, d.user_id
			     , d.org_deo MAG
			     , odop.dodatni_tip DOD
			     , sd.proizvod
			     , sd.STAVKA
			     , sd.kolicina
			     , sd.cena
			     , nvl(sd.rabat,0) rabat
			     , sd.cena1
			     , NVL(sd.z_troskovi,0) Z_TRO
			     , case when d.org_Deo between 113 and 118 then 2 else 0 end pp_proc

			From DOKUMENT D, stavka_dok SD, ORG_DEO_OSN_PODACI odop


			Where 1=1
--			      nvl(D.broj_dok1,'0') <> '0'
--			  and D.vrsta_dok      in( '3','4','5','30')
			  and D.vrsta_dok      in( '3')
			  and D.godina         = 2014
			  and d.status > 0

			  and d.org_deo=23
			  and d.broj_dok1='227'
			  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
			  and d.org_deo = odop.org_deo (+)

--              and nvl(odop.dodatni_tip,'xx') in ('VP4','NAB')
--              and d.org_Deo not between 134 and 138
--              and d.org_Deo between 113 and 118

--and (
--       ( nvl(sd.rabat,0) = 0 and nvl(sd.z_troskovi,0) = 0 and sd.cena=sd.cena1)
--    )


order by d.datum_dok, d.datum_unosa
