Declare
  Cursor k1 is
	Select godina, vrsta_dok, broj_dok, status, DATUM_DOK
	from dokument
	where godina = 2013
	  and vrsta_dok in ('3')
	  and org_deo between 113 and 119
	  and status > 0
	order by datum_dok, datum_unosa;
  kk1 k1 % rowtype;


  Cursor k2 is
			select BRD, VRD, GOD, STAT
			     , MAG,DOD,STAVKA,KOLICINA,CENA,RABAT,CENA1,Z_TRO,VRED,VRED_SA_RAB,ZTS,MAX_STAV,PP_PROC,UK_SUMA_DOK, DEC
			     , CENA1_1

			    ,      CASE WHEN STAVKA= MAX_STAV THEN
				                 ZTRO_STAV_F + zts_2 + ZTS - sum(ZTRO_STAV_F) over (partition by BRD order by vred)
				       ELSE
				                 ZTRO_STAV_F + zts_2
				       END
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
				Select BRD, VRD, GOD, STAT
				     , MAG, DOD, STAVKA, KOLICINA, CENA, RABAT, CENA1, Z_TRO, VRED, VRED_SA_RAB, ZTS, MAX_STAV, PP_PROC, UK_SUMA_DOK, DEC
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
						               where zts.vrsta_dok      = kk1.Vrsta_dok
						                 and zts.broj_dok       = kk1.Broj_dok
						                 and zts.godina         = kk1.Godina
						                 and zts.vrsta_troskova = ztv.vrsta_troskova
						                 and ztv.formula        = 1
						       )  zts
						     ,
						       (
									select max(sd2.stavka)
									from stavka_dok sd2
									where sd2.broj_dok       = kk1.Broj_dok
									  and sd2.vrsta_dok      = kk1.Vrsta_dok
									  and sd2.godina         = kk1.Godina
									  and (sd2.kolicina*sd2.cena) in
									  (
										select max(sd1.kolicina*sd1.cena) max_vred
										from stavka_dok sd1
										where sd1.broj_dok       = kk1.Broj_dok
										  and sd1.vrsta_dok      = kk1.Vrsta_dok
										  and sd1.godina         = kk1.Godina
									  )
						       ) max_stav
						    ,
						       (
							        Select pp1.Procenat
							          From dokument d3
							             , PreProdajni_Procenat pp1
							         Where
							               D3.broj_dok  = kk1.Broj_dok
							           and D3.vrsta_dok = kk1.Vrsta_dok
							           and D3.godina    = kk1.Godina
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
						               where sd4.broj_dok       = kk1.Broj_dok
						                 and sd4.vrsta_dok      = kk1.Vrsta_dok
						                 and sd4.godina         = kk1.Godina
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
						               where zts.vrsta_dok      = kk1.Vrsta_dok
						                 and zts.broj_dok       = kk1.Broj_dok
						                 and zts.godina         = kk1.Godina
						                 and zts.vrsta_troskova = ztv.vrsta_troskova
						                 and ztv.formula        = 2
						              Group by STAVKA_PRIJ
						       )  zts_2
						Where D.broj_dok       = kk1.Broj_dok--'12258'
						  and D.vrsta_dok      = kk1.Vrsta_dok--'3'
						  and D.godina         = kk1.Godina--2012
						  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
						  and d.org_deo = odop.org_deo (+)
						  and sd.stavka=zts_2.stavka(+)
					) S
				)
			)

			ORDER BY vred;

  kk2 k2 % rowtype;


Begin


  DBMS_OUTPUT.PUT_LINE(

                       RPAD('DATUM',8)
                       ||' '||
                       RPAD('STATUS',8)
                       ||' '||

                       RPAD('BROJ_DOK',8)
                       ||' '||
                       RPAD('CENA1',13)
                       ||' '||
                       RPAD('CENA1_L',13)
                       );


  DBMS_OUTPUT.PUT_LINE(
                       RPAD('-',8,'-')
                       ||' '||
                       RPAD('-',8,'-')
                       ||' '||

                       RPAD('-',8,'-')
                       ||' '||
                       RPAD('-',13,'-')
                       ||' '||
                       RPAD('-',13,'-')
                       );

  Open k1;
  loop
  fetch k1 into kk1;
  exit when k1 % notFound;

	  Open k2;
	  loop
	  fetch k2 into kk2;
	  exit when k2 % notFound;
		  IF KK2.CENA1 <> KK2.CENA1_L THEN


				  DBMS_OUTPUT.PUT_LINE(

				                       RPAD(TO_CHAR(KK1.DATUM_DOK,'DD.MM.YY'),8)
				                       ||' '||
				                       RPAD(KK1.STATUS,8)
				                       ||' '||

				                       LPAD(KK2.BRD,8)
				                       ||' '||
				                       LPAD(KK2.CENA1,13)
				                       ||' '||
				                       LPAD(KK2.CENA1_L,13)
				                       );

		  END IF;

	  End loop;
	  Close k2;


  End loop;
  Close k1;

End;
