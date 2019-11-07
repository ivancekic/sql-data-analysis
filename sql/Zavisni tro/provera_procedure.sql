		select BRD, VRD, GOD, STAT
		     , MAG,DOD,STAVKA,KOLICINA,CENA,RABAT,CENA1,Z_TRO,VRED,VRED_SA_RAB,ZTS,MAX_STAV,PP_PROC,UK_SUMA_DOK, DEC
		     , CENA1_1
		     , CASE WHEN STAVKA= MAX_STAV THEN
		                 ZTRO_STAV_F + ZTS - sum(ZTRO_STAV_F) over (partition by BRD order by vred)
		       ELSE
		                 ZTRO_STAV_F
		       END

               ZTRO_STAV_F1

		    ,  CASE WHEN DOD IN ('NAB','VP4') THEN
		       round(
		               (
		                   (  kolicina * CENA1_1
		                    + nvl(
		                           CASE WHEN STAVKA= MAX_STAV THEN
		                                ZTRO_STAV_F + ZTS - sum(ZTRO_STAV_F) over (partition by BRD order by vred)
		                           ELSE
		                                ZTRO_STAV_F
		                           END
		                          ,0)
		                   )
		                 /  kolicina
		               )
		              *(100 + PP_PROC )
		              / 100
		            ,DEC)
		      ELSE
		            CENA1
		      END

		      CENA1_L

		From
		(
			Select BRD, VRD, GOD, STAT
			     , MAG, DOD, STAVKA, KOLICINA, CENA, RABAT, CENA1, Z_TRO, VRED, VRED_SA_RAB, ZTS, MAX_STAV, PP_PROC, UK_SUMA_DOK, DEC
			     , cena1_1
			     , round( kolicina* cena1_1 / UK_SUMA_DOK * zts,DEC) ZTRO_STAV
			     , round(
			              (round
			                      (
			                          (kolicina * cena1_1 + round( kolicina* cena1_1 / UK_SUMA_DOK * zts,DEC)   ) / kolicina
			                           ,4)
			                       -
			                           cena1_1) * kolicina
			            ,2) ZTRO_STAV_F

			From

			(
				select BRD, VRD, GOD, STAT
				     , MAG, DOD, STAVKA, KOLICINA, CENA, RABAT, CENA1, Z_TRO, VRED, VRED_SA_RAB, NVL(ZTS,0) ZTS, MAX_STAV
				     , NVL(PP_PROC,0) PP_PROC, UK_SUMA_DOK, DEC
				     , round(s.cena*(100-nvl(s.rabat,0))/100,DEC) cena1_1
				from
				(
					select
					       d.broj_dok BRD, D.VRSTA_DOK VRD, D.GODINA GOD, D.STATUS STAT
					     , d.org_deo MAG
					     , odop.dodatni_tip DOD
					     , sd.STAVKA
					     , sd.kolicina
					     , sd.cena
					     , nvl(sd.rabat,0) rabat
					     , sd.cena1
					     , NVL(sd.z_troskovi,0) Z_TRO
					     , sd.kolicina*sd.cena vred
					     , ROUND(sd.KOLICINA*sd.cena*(100-nvl(sd.rabat,0))/100,2) VRED_SA_RAB
                         , zts
                         , max_stav
					     ,
					       nvl(pp_proc,0) pp_proc
					     , uk_suma_dok
 				         , DEC

					From DOKUMENT D, stavka_dok SD, ORG_DEO_OSN_PODACI odop
					     ,
					       (
					            select zts.godina, zts.vrsta_dok, zts.broj_dok, sum(zts.iznos_troska) zts
					            from vrsta_dok vrd, zavisni_troskovi_stavke zts, zavisni_troskovi_vrste ztv
					            where vrd.vrsta      = '3'
					              and vrd.vrsta      = zts.vrsta_dok
   					              and zts.godina > 2011
					              and zts.vrsta_troskova = ztv.vrsta_troskova
					              and ztv.formula   = 1
					              and zts.stavka > 0
                                group by zts.godina, zts.vrsta_dok, zts.broj_dok
					       )  zts
					     ,
					       (
				                select sd2.godina, sd2.vrsta_dok, sd2.broj_dok, max(sd2.stavka) max_stav
								from vrsta_dok vrd, stavka_dok sd2
								where vrd.vrsta      = '3'
					              and vrd.vrsta= sd2.vrsta_dok
					              and sd2.godina > 2011
					              and (sd2.godina, sd2.vrsta_dok, sd2.broj_dok, sd2.kolicina*sd2.cena) in

								  (
									select godina, vrsta_dok, broj_dok, max(sd1.kolicina*sd1.cena) max_vred
									from stavka_dok sd1
									where sd1.broj_dok       = sd2.Broj_dok
									  and sd1.vrsta_dok      = sd2.Vrsta_dok
									  and sd1.godina         = sd2.Godina
									Group by godina, vrsta_dok, broj_dok
								  )
                                group by godina, vrsta_dok, broj_dok
					       ) max_stav
					     ,
					       (
					            select godina, vrsta_dok, broj_dok,  sum( sd4.KOLICINA*sd4.cena*(100-nvl(sd4.rabat,0))/100 ) uk_suma_dok
				                from vrsta_dok vrd, stavka_dok sd4
								where vrd.vrsta = '3'
					              and vrd.vrsta = sd4.vrsta_dok
                                group by godina, vrsta_dok, broj_dok
					       )  uk_suma_dok

					     ,
					       (
						        Select ORG_DEO,DATUM,PROCENAT pp_proc
						          From PreProdajni_Procenat pp1
					       ) pp_proc
                         ,
				          (
							select NAZIV, BLOK, POLJE, FORMAT dec
							from APLIKACIJA_FORME_DEF
							WHERE NAZIV='!!!_SVE_FORME'
							  AND BLOK='CENE'
							  AND POLJE='DECIMALE'
				          ) DEC

					Where
--					      D.broj_dok       =
-- to_char(d.datum_unosa,'dd.mm.yyyy') = '06.06.2012'
 d.datuM_dok = to_date('28.05.2012','dd.mm.yyyy')
					  and D.vrsta_dok      = '3'
					  and D.godina         = 2012
					  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
 					  and d.godina = zts.godina and d.vrsta_dok = zts.vrsta_dok and d.broj_dok = zts.broj_dok
					  and sd.godina = max_stav.godina and sd.vrsta_dok = max_stav.vrsta_dok and sd.broj_dok = max_stav.broj_dok
					  and sd.godina = uk_suma_dok.godina and sd.vrsta_dok = uk_suma_dok.vrsta_dok and sd.broj_dok = uk_suma_dok.broj_dok
					  and d.org_deo=pp_proc.org_deo (+)
--					  and to_date(TO_CHAR(d.datum_dok,'DD.MM.YYYY') ||' 23:59:59','DD.MM.YYYY HH24:MI:SS') >
--					      nvl(pp_proc.datum,to_date('01.01.2012','dd.mm.yyyy'))
					  and d.org_deo = odop.org_deo (+)

					  and sd.proizvod !='399'
				) S
			)
		)

		ORDER BY vred
