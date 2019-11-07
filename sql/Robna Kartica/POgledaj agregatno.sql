select
case when VRD='3' and d1.status = 4 then
  (select za_broj_dok from vezni_dok where godina = GOD and vrsta_Dok=VRD and broj_dok=BRD and za_vrsta_dok='4')
end st_brd
,
d1.STATUS,PRO,PRO_NAZ
,nvl(d2.ppartner,'1') prt, pp.naziv prt_naz
,MAG
,to_char(d1.DATUM_DOK,'dd.mm.yy') dat,  d1.DATUM_UNOSA,d1.datum_storna,GOD,VRD,BRD,BRD1,TIPD,CENA,SD_VAL,RAB,CENA1,VP_CENA
,round(ULAZ,2) ULAZ, round(IZLAZ,2) IZLAZ, round(STANJE,2) STANJE
,round(DUGUJE,2) DUGUJE, round(POTRAZUJE,2) POTRAZUJE, round(SALDO,2) SALDO
--,PROS_KOL
--,AUTO_NIV_BRD,AUTO_NIV_GOD,FAK
--,PROS_CENA
--     , PPlanskiCenovnik.Cena (d1.pro , d1.Datum_Dok, 'YUD' , 1  ) Plan
--     , PravaProsCena(&nOrg,pro, to_date('01.01.'||to_char(&nGod),'dd.mm.yyyy'), datum_dok) pros_c
--     , IzProsecniCenovnik.Cena(&nOrg,pro,datum_dok,1) pros

from
(
	select status, PRO
	     , pproizvod.naziv(pro) pro_naz
	     ,  mag,DATUM_DOK,DATUM_UNOSA,datum_storna,god,vrd,brd, brd1, tipd
	     , cena
	     , sd_val, rab, CENA1, VP_CENA
	     , ulaz,izlaz,STANJE
	     , duguje, POTRAZUJE, saldo

         , STANJE 		 PROS_KOL
         , (select za_broj_dok
            from vezni_dok vd
            where vd.godina = god
              and vd.vrsta_dok = vrd
              and vd.broj_dok = brd
              and za_vrsta_dok = '90'
           ) auto_niv_brd
         , (select za_godina
            from vezni_dok vd
            where vd.godina = god
              and vd.vrsta_dok = vrd
              and vd.broj_dok = brd
              and za_vrsta_dok = '90'
           ) auto_niv_god
         , FAK
         ,
			ROUND(
			CASE WHEN STANJE <> 0 THEN
			     SALDO / STANJE
			ELSE
			     CENA1
			END,6)  PROS_CENA
----------
----------          , ROUND(
----------			CASE WHEN STANJE <> 0 THEN
----------			     round(SALDO,2) / STANJE
----------			ELSE
----------			     CENA1
----------			END,6)  PROS_CENA_2

--	     , neto_kg
--         , STANJE * CENA1 SALDO
--	     , (
--					select
--
--					       sum(kolicina*FAKTOR*K_ROBE)
--					from stavka_dok sd, dokument d
--					Where
--					  -- veza tabela
--					      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
--					  -- ostali uslovi
--					  and d.godina in (2013)
--					  AND D.VRSTA_DOK ='21'
--					  AND STATUS  > 0
--	                  and d.org_deo = d1.org_Deo
--	                  and sd.proizvod=d1.proizvod
--
--					  AND sd.K_ROBE <> 0
--				--	  AND ORG_DEO = 1094
--				--	  AND PROIZVOD = '223'
--	     ) kol_ps_2


--------, case when vrd in ('11','12','13','31') then
--------      (select za_broj_dok from vezni_dok vd where vd.godina =god and vd.vrsta_dok=vrd and vd.broj_dok=brd and vd.za_vrsta_dok='90')
--------  end  niv_stav



	from
	(
		select d.status, sd.proizvod pro,org_deo mag, d.datum_dok, D.DATUM_UNOSA,d.datum_storna, d.godina god, d.vrsta_Dok vrd, d.broj_dok brd, D.BROJ_DOK1 brd1, d.tip_dok tipd
		     , sd.rabat rab
		     , sd.cena
		     , neto_kg
--		     , kolicina*FAKTOR*K_ROBE KOLICINA
             ,
                 sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.k_robe,0)

                 *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok)

                 ulaz,



                 sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.k_robe,0)

                 *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok)

                 izlaz

		     , sum(kolicina*FAKTOR*K_ROBE)
		       OVER (PARTITION BY d.org_deo, SD.PROIZVOD ORDER BY org_deo, sd.proizvod, d.datum_dok, D.DATUM_UNOSA
		             ROWS UNBOUNDED PRECEDING) AS STANJE
             ,
                 case when d.vrsta_dok = '80' then
                     sd.kolicina*sd.faktor*(sd.cena1 - sd.cena)
                 else
                     sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.cena1,0)*nvl(sd.k_robe,0)
                     *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok)
                 end
                 duguje,

                 sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.cena1,0)*nvl(sd.k_robe,0)
                 *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok)
                 potrazuje
			, sum(
                 case when d.vrsta_dok = '80' then
                     sd.kolicina*sd.faktor*(sd.cena1 - sd.cena)
                 else
                     sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.cena1,0)*nvl(sd.k_robe,0)
                     *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok)
                 end
-
                 sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.cena1,0)*nvl(sd.k_robe,0)
                 *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok)

			     )
		       OVER (PARTITION BY d.org_deo, SD.PROIZVOD ORDER BY org_deo, sd.proizvod, d.datum_dok, D.DATUM_UNOSA
		             ROWS UNBOUNDED PRECEDING) AS saldo
                , SD.CENA1
                ,
                 (select ROUND(cena/KOL_CENA/FAK_CENA,4) from prodajni_cenovnik
                   where proizvod = sd.proizvod
                     and valuta=sd.valuta
                     and datum =  (select max(datum)
                                     from prodajni_cenovnik
                                    where proizvod = sd.proizvod
                                      AND Datum <= TO_DATE( TO_CHAR(D.DATUM_DOK,'DD.MM.YYYY')||' '||'23:59:59','DD.MM.YYYY HH24.MI:SS')
                                      and valuta=sd.valuta
                                  )
                 ) VP_CENA
           , sd.valuta sd_val
           , SD.FAKTOR FAK
		from stavka_dok sd, dokument d
		Where
		  -- veza tabela
		      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
		  -- ostali uslovi
          and d.godina = &nGod
--          and d.org_Deo =
--          nvl(
--          &nOrg
--          ,
--          d.org_deo)
and d.org_deo in (22)
          --1105
		--  AND D.VRSTA_DOK ='21'
		  AND (K_ROBE <> 0 or d.vrsta_dok = '80')
		  AND STATUS  > 0
--		  and to_char(d.org_deo) IN (Select distinct polje1 from deja_pomocna_tab where polje79='304' AND polje1!='magacin')
		  and d.org_deo not in (select magacin from partner_magacin_flag)

--          and sd.proizvod=
--          NVL(&cPro,SD.PROIZVOD)

and sd.proizvod in (150394,
150405,
150410,
160771,
160770,
160772)

--          '686'
          --'1972'

AND D.DATUM_DOK > to_date('29.03.2016','dd.mm.yyyy')
--	  AND ORG_DEO = 1283
--	  AND PROIZVOD = '95566'
--and d.tip_dok=231
	) d1

--where VP_cena <> ROUND(
--			            CASE WHEN STANJE <> 0 THEN
--			                 SALDO / STANJE
--              			ELSE
--			                 CENA1
--			           END,6)
) d1
, dokument d2
, poslovni_partner pp
where 1=1
  and d2.broj_dok=d1.brd
  and d2.vrsta_dok=d1.vrd
  and d2.godina=d1.god
  and pp.sifra=nvl(d2.ppartner,'1')

--  and auto_niv_brd is not null
--and cena1 <> PPlanskiCenovnik.Cena (d1.pro , d1.Datum_Dok, 'YUD' , 1  )
--and cena <> PPlanskiCenovnik.Cena (d1.pro , d1.Datum_Dok, 'YUD' , 1  )

--and (   cena1 <> PPlanskiCenovnik.Cena (d1.pro , d1.Datum_Dok, 'YUD' , 1  )
--     or cena <> PPlanskiCenovnik.Cena (d1.pro , d1.Datum_Dok, 'YUD' , 1  )
--    )

--cena <> cena1
--and cena1<>pros_cena
--and pro not in (7026,10150)
--and pro not in (7026,10150)



order by
--god,mag,
to_number(pro),
d1.datum_dok,d1.datum_unosa;
