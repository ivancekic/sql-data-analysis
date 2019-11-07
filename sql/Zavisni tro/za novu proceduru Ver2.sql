select
       ORG_DEO,DODATNI_TIP,STAVKA,KOLICINA,CENA,RABAT,CENA1,Z_TROSKOVI,VRED,VRED_SA_RAB,ZTS,MAX_STAV,PP_PROC,UK_SUMA_DOK,DECIMALE
     , CENA1_1,ZTRO_STAV,ZTRO_STAV_F
--     , sum(ZTRO_STAV_F) over (partition by stavka order by STAVKA) cum_ZTRO_STAV_F
--     , (case when STAVKA  = MAX(STAVKA) over (partition by broj_dok) then
--            sum(CENA)+ 640 - (sum(CENA) over (partition by broj_dok order by STAVKA))
--        else CENA
--        end) nova_ZTRO_STAV_F


From
(
	Select ORG_DEO, DODATNI_TIP, STAVKA, KOLICINA, CENA, RABAT, CENA1, Z_TROSKOVI, VRED, VRED_SA_RAB, ZTS, MAX_STAV, PP_PROC, UK_SUMA_DOK, DECIMALE
	     , cena1_1
	--     , VRED / UK_SUMA_DOK ZTRO_PROC
	     , round( kolicina* cena1_1 / UK_SUMA_DOK * zts,DECIMALE) ZTRO_STAV
	     , round(
	              (round
	                      (
	                          (kolicina * cena1_1 + round( kolicina* cena1_1 / UK_SUMA_DOK * zts,DECIMALE)   ) / kolicina
	                           ,4)
	                       -
	                           cena1_1) * kolicina
	            ,2) ZTRO_STAV_F

	From

	(
		select ORG_DEO, DODATNI_TIP, STAVKA, KOLICINA, CENA, RABAT, CENA1, Z_TROSKOVI, VRED, VRED_SA_RAB, ZTS, MAX_STAV, PP_PROC, UK_SUMA_DOK, DECIMALE
		     , round(s.cena*(100-nvl(s.rabat,0))/100,decimale) cena1_1
		from
		(
			select
			       d.org_deo
			     , odop.dodatni_tip
			     , sd.STAVKA
			     , sd.kolicina
			     , sd.cena
			     , nvl(sd.rabat,0) rabat
			     , sd.cena1
			     , sd.z_troskovi
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
		          ) DECIMALE

			From DOKUMENT D, stavka_dok SD, ORG_DEO_OSN_PODACI odop
			Where D.broj_dok       = &vBroj_dok--'12258'
			  and D.vrsta_dok      = &vVrsta_dok--'3'
			  and D.godina         = &nGodina--2012
			  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
			  and d.org_deo = odop.org_deo (+)
		) S

	)
)
ORDER BY vred

