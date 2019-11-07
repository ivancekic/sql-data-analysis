select BRD, VRD, GOD, STAT
     , MAG,DOD,STAVKA,KOLICINA,CENA,RABAT,CENA1,Z_TRO,VRED,VRED_SA_RAB,ZTS,MAX_STAV,PP_PROC,UK_SUMA_DOK, DEC
     , CENA1_1
    ,  CASE WHEN DOD IN ('NAB','VP4') THEN
	       CASE WHEN STAVKA= MAX_STAV THEN
	                 ZTRO_STAV_F + ZTS - sum(ZTRO_STAV_F) over (partition by BRD order by vred)
	       ELSE
	                 ZTRO_STAV_F
	       END
	   ELSE
	       0
	   END ZTRO_STAV_F1

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

   , zts_2


    ,  CASE WHEN DOD IN ('NAB','VP4') THEN
	       CASE WHEN STAVKA= MAX_STAV THEN
	                 ZTRO_STAV_F + zts_2 + ZTS - sum(ZTRO_STAV_F) over (partition by BRD order by vred)
	       ELSE
	                 ZTRO_STAV_F + zts_2
	       END
	   ELSE
	       0
	   END ZTRO_STAV_F11

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

      CENA1_L1

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
	     , zts_2

	From

	(
		select BRD, VRD, GOD, STAT
		     , MAG, DOD, STAVKA, KOLICINA, CENA, RABAT, CENA1, Z_TRO, VRED, VRED_SA_RAB, NVL(ZTS,0) ZTS, MAX_STAV
		     , NVL(PP_PROC,0) PP_PROC, UK_SUMA_DOK, DEC
		     , round(s.cena*(100-nvl(s.rabat,0))/100,DEC) cena1_1
		     , zts_2
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
			     ,
			       (
			              select sum(zts.iznos_troska) uk_trosak
			                from zavisni_troskovi_stavke zts, zavisni_troskovi_vrste ztv
			               where zts.vrsta_dok      = &vVrsta_dok
			                 and zts.broj_dok       = &vBroj_dok
			                 and zts.godina         = &nGodina
			                 and zts.vrsta_troskova = ztv.vrsta_troskova
			                 and ztv.formula        = 1
			       )  zts
			     ,
			       (
						select max(sd2.stavka)
						from stavka_dok sd2
						where sd2.broj_dok       = &vBroj_dok
						  and sd2.vrsta_dok      = &vVrsta_dok
						  and sd2.godina         = &nGodina
						  and (sd2.kolicina*sd2.cena) in
						  (
							select max(sd1.kolicina*sd1.cena) max_vred
							from stavka_dok sd1
							where sd1.broj_dok       = &vBroj_dok
							  and sd1.vrsta_dok      = &vVrsta_dok
							  and sd1.godina         = &nGodina
						  )
			       ) max_stav
			    ,
			       (
				        Select pp1.Procenat
				          From dokument d3
				             , PreProdajni_Procenat pp1
				         Where
				               D3.broj_dok  = &vBroj_dok
				           and D3.vrsta_dok = &vVrsta_dok
				           and D3.godina    = &nGodina
				           and d3.org_deo   = pp1.org_Deo
				           AND pp1.Datum = (Select max( C1.Datum )
				                            From PreProdajni_Procenat C1
				                            Where C1.Org_deo = pp1.org_deo
				                              AND C1.Datum <= to_date(TO_CHAR(d3.datum_dok,'DD.MM.YYYY') ||' 23:59:59','DD.MM.YYYY HH24:MI:SS')
				                           )
			       ) pp_proc
			     ,
			       (
			              select sum( sd4.KOLICINA*sd4.cena*(100-nvl(sd4.rabat,0))/100 )
			                from stavka_Dok sd4
			               where sd4.broj_dok       = &vBroj_dok
			                 and sd4.vrsta_dok      = &vVrsta_dok
			                 and sd4.godina         = &nGodina
			       )  uk_suma_dok
		        ,
		          (
					select FORMAT from APLIKACIJA_FORME_DEF
					WHERE NAZIV='!!!_SVE_FORME'
					  AND BLOK='CENE'
					  AND POLJE='DECIMALE'
		          ) DEC
                , nvl(zts_2.uk_trosak,0) zts_2
			From DOKUMENT D, stavka_dok SD, ORG_DEO_OSN_PODACI odop
			     ,
			       (
			              select STAVKA_PRIJ stavka, sum(zts.iznos_troska) uk_trosak
			                from zavisni_troskovi_stavke zts, zavisni_troskovi_vrste ztv
			               where zts.vrsta_dok      = &vVrsta_dok
			                 and zts.broj_dok       = &vBroj_dok
			                 and zts.godina         = &nGodina
			                 and zts.vrsta_troskova = ztv.vrsta_troskova
			                 and ztv.formula        = 2
			              Group by STAVKA_PRIJ
			       )  zts_2
			Where D.broj_dok       = &vBroj_dok--'12258'
			  and D.vrsta_dok      = &vVrsta_dok--'3'
			  and D.godina         = &nGodina--2012
			  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
			  and d.org_deo = odop.org_deo (+)
			  and sd.stavka=zts_2.stavka(+)
		) S
	)
)

ORDER BY vred

