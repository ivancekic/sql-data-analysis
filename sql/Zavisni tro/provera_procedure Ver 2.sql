select
       BRD,VRD,GOD,STAT,TIP_DOK,dat,dat_un,MAG,DOD
     , STAVKA,proizvod, KOLICINA,CENA,RABAT,CENA1,Z_TRO,VRED,VRED_SA_RAB,ZTS,MAX_STAV,PP_PROC,UK_SUMA_DOK,DEC,CENA1_1,ZTRO_STAV_F1,CENA1_L
from
(
			select BRD, VRD, GOD, STAT, tip_dok,dat,dat_un
			     , MAG,DOD,STAVKA,proizvod, KOLICINA,CENA,RABAT,CENA1,Z_TRO,VRED,VRED_SA_RAB,ZTS,MAX_STAV,PP_PROC,UK_SUMA_DOK, DEC
			     , CENA1_1

			    ,
--                 CASE WHEN DOD IN ('NAB','VP4') THEN
				       CASE WHEN STAVKA= MAX_STAV THEN
				                 ZTRO_STAV_F + zts_2 + ZTS - sum(ZTRO_STAV_F) over (partition by BRD order by vred)
				       ELSE
				                 ZTRO_STAV_F + zts_2
				       END
--				   ELSE
--				       0
--				   END
                   ZTRO_STAV_F1

			    ,  CASE WHEN DOD IN ('NAB','VP4') THEN
			       round(
			               (
			                   (  kolicina * CENA1_1
			                    + nvl(
			                           CASE WHEN STAVKA= MAX_STAV THEN
			                                ZTRO_STAV_F + zts_2 + ZTS - sum(ZTRO_STAV_F) over (partition by BRD order by vred)
			                           ELSE
			                                ZTRO_STAV_F + zts_2
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
				Select BRD, VRD, GOD, STAT, tip_dok,dat,dat_un
				     , MAG, DOD, STAVKA,proizvod,  KOLICINA, CENA, RABAT, CENA1, Z_TRO, VRED, VRED_SA_RAB, ZTS, MAX_STAV, PP_PROC, UK_SUMA_DOK, DEC
				     , cena1_1
				     , round( kolicina* cena1_1 / UK_SUMA_DOK * zts,2) ZTRO_STAV
				     , round(
				              (round
				                      (
				                          (kolicina * cena1_1 + round( kolicina* cena1_1 / UK_SUMA_DOK * zts,2)   ) / kolicina
				                           ,4)
				                       -
				                           cena1_1) * kolicina
				            ,2) ZTRO_STAV_F
				     , zts_2

				From

				(
					select BRD, VRD, GOD, STAT, tip_dok,dat,dat_un
					     , MAG, DOD, s.STAVKA,s.proizvod,  KOLICINA, CENA, RABAT, CENA1, Z_TRO, VRED, VRED_SA_RAB, NVL(ZTS,0) ZTS, MAX_STAV
					     , NVL(PP_PROC,0) PP_PROC, UK_SUMA_DOK, DEC
					     , round(s.cena*(100-nvl(s.rabat,0))/100,DEC) cena1_1

		                 , nvl(zts_2.zts_2,0) zts_2
					from
					(
						select
						       d.broj_dok BRD, D.VRSTA_DOK VRD, D.GODINA GOD, D.STATUS STAT, d.tip_dok
						     , to_char(d.datum_dok,'dd.mm.yy') dat, d.datum_unosa dat_un
						     , d.org_deo MAG
						     , odop.dodatni_tip DOD
						     , sd.STAVKA, sd.proizvod
						     , sd.kolicina
						     , sd.cena
						     , nvl(sd.rabat,0) rabat
						     , sd.cena1
						     , NVL(sd.z_troskovi,0) Z_TRO
						     , sd.kolicina*sd.cena vred
						     , ROUND(sd.KOLICINA*sd.cena*(100-nvl(sd.rabat,0))/100,2) VRED_SA_RAB
, ZTS
, max_stav
, pp_proc
, uk_suma_dok
					        ,
					          (
								select FORMAT from APLIKACIJA_FORME_DEF
								WHERE NAZIV='!!!_SVE_FORME'
								  AND BLOK='CENE'
								  AND POLJE='DECIMALE'
					          ) DEC
						From DOKUMENT D, stavka_dok SD, ORG_DEO_OSN_PODACI odop

						     ,
						       (
						              select ZTS.broj_dok, ZTS.VRSTA_DOK, ZTS.GODINA, sum(zts.iznos_troska) zts
						                from zavisni_troskovi_stavke zts, zavisni_troskovi_vrste ztv
						               where zts.vrsta_troskova = ztv.vrsta_troskova
						                 and ztv.formula        = 1
						              Group by ZTS.broj_dok, ZTS.VRSTA_DOK, ZTS.GODINA
						       )  zts

						    ,
						       (
							        Select pp1.org_deo, pp1.Procenat pp_proc
							          From PreProdajni_Procenat pp1
						       ) pp_proc
						    ,
						       (
						              select sd4.broj_dok, sd4.VRSTA_DOK, sd4.GODINA
						                   , sum( sd4.KOLICINA*sd4.cena*(100-nvl(sd4.rabat,0))/100 ) uk_suma_dok
						                from stavka_Dok sd4
						              Group by  sd4.broj_dok, sd4.VRSTA_DOK, sd4.GODINA
						       )  uk_suma_dok
						     ,
						       (
									select sd2.broj_dok, sd2.VRSTA_DOK, sd2.GODINA, max(sd2.stavka) max_stav
									from stavka_dok sd2
									where (sd2.kolicina*sd2.cena) in
									  (
										select max(sd1.kolicina*sd1.cena) max_vred
										from stavka_dok sd1
										where sd1.broj_dok       = sd2.Broj_dok
										  and sd1.vrsta_dok      = sd2.Vrsta_dok
										  and sd1.godina         = sd2.Godina
									  )
									Group by sd2.broj_dok, sd2.VRSTA_DOK, sd2.GODINA
						       ) max_stav


						Where
						D.broj_dok       in ( &vBroj_dok )
--                              d.datum_dok > to_date('31.05.2012','dd.mm.yyyy')
						  and D.vrsta_dok      = &vVrsta_dok
						  and D.godina         = &nGodina
                          and d.tip_dok = 10
						  and d.org_deo not in (select magacin from partner_magacin_flag)
						  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok

						  and d.godina = zts.godina (+) and d.vrsta_dok = zts.vrsta_dok  (+) and d.broj_dok = zts.broj_dok  (+)
						  and d.godina = uk_suma_dok.godina and d.vrsta_dok = uk_suma_dok.vrsta_dok and d.broj_dok = uk_suma_dok.broj_dok

						  and d.org_deo = odop.org_deo (+)
						  and d.org_deo = pp_proc.org_deo (+)



						  and d.godina = max_stav.godina and d.vrsta_dok = max_stav.vrsta_dok and d.broj_dok = max_stav.broj_dok

					) S
			     ,
			       (
			              select zts.broj_dok, zts.VRSTA_DOK, zts.GODINA, STAVKA_PRIJ stavka
			                   , sum(zts.iznos_troska) zts_2
			                from zavisni_troskovi_stavke zts, zavisni_troskovi_vrste ztv
			               where zts.vrsta_troskova = ztv.vrsta_troskova
			                 and ztv.formula        = 2
			              Group by zts.broj_dok, zts.VRSTA_DOK, zts.GODINA, STAVKA_PRIJ
			       )  zts_2
                   where s.god = zts_2.godina (+) and s.vrd = zts_2.vrsta_dok (+) and s.brd = zts_2.broj_dok (+)
					 and s.stavka=zts_2.stavka(+)
				)
			)
)
--where nvl(cena1,0) <> nvl(CENA1_L,0)
--   or nvl(Z_TRO,0) <> nvl(ZTRO_STAV_F1,0)
--   or brd in ('15514')

--and stat in (-9,1)
ORDER BY dat, dat_un
--god,vrd,brd,vred
