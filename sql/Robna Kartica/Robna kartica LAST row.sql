select
	   STATUS,MAG,MAG_NAZ,PRT,PRT_NAZ
	 , POS_GR,POS_GR_NAZ,PRO,PRO_NAZ, JM_Sklad
	 , DATUM_DOK, d1.datum_unosa, GOD,VRD,BRD,BRD1,TIPD

	 , CENA,RAB,CENA1,ULAZ,IZLAZ,STANJE,DUGUJE,POTRAZUJE,SALDO

     , PROS_CENA

	 , VD_BRD, VD_VRD, VD_GOD
	         , sd_val
	, (select za_godina from vezni_Dok
	   where godina = VD_GOD
	     and vrsta_dok = VD_VRD
	     and broj_dok = VD_BRD
	     and vrsta_dok in ('1','27','45','46','8','27','28','32')
	     and za_vrsta_dok='29'
	  ) rn_god

	, (select za_broj_dok from vezni_Dok
	   where godina = VD_GOD
	     and vrsta_dok = VD_VRD
	     and broj_dok = VD_BRD
	     and vrsta_dok in ('1','27','45','46','8','27','28','32')
	     and za_vrsta_dok='29'
	  ) rn_brd

, VP_CENA
from
(
	select
			d1.STATUS
			, MAG
			, od.naziv mag_naz
			, d1.prt
			, pp.naziv prt_naz
			, pg.grupa pos_gr
			, pg.naziv pos_gr_naz

			, pro_last

			, PRO
			, p.naziv PRO_NAZ
			, p.jed_mere JM_Sklad

			,DATUM_DOK, d1.datum_unosa
			,GOD,VRD,BRD,BRD1,TIPD,CENA,RAB,CENA1
			, round(ULAZ,5) 		ULAZ
			, round(IZLAZ,5) 		IZLAZ
			, round(STANJE,5) 		STANJE
			, round(DUGUJE,2)		DUGUJE
			, round(POTRAZUJE,2)	POTRAZUJE
			, round(SALDO,2)		SALDO
			--,PROS_KOL
			, vd_brd
			, vd_vrd
			, vd_god
	         , sd_val
         ,
			ROUND(
			CASE WHEN STANJE <> 0 THEN
			     SALDO / STANJE
			ELSE
			     CENA1
			END,6)  PROS_CENA
,VP_CENA

	from
	(
		select status, PRO,pro_last, prt
	--	     , pproizvod.naziv(pro) pro_naz
		     ,  mag,DATUM_DOK,DATUM_UNOSA,god,vrd,brd, brd1, tipd
		     , cena, rab, CENA1, VP_CENA
		     , ulaz,izlaz,STANJE
		     , duguje, POTRAZUJE, saldo
	         , STANJE 		 PROS_KOL

	         , vd_brd
	         , vd_vrd
	         , vd_god
	         , sd_val

		from
		(
			select d.ppartner prt, d.status, sd.proizvod pro,org_deo mag, d.datum_dok, D.DATUM_UNOSA, d.godina god, d.vrsta_Dok vrd, d.broj_dok brd, D.BROJ_DOK1 brd1, d.tip_dok tipd
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
	                 (select ROUND(cena/KOL_CENA/FAK_CENA, &nDecimale) from prodajni_cenovnik
	                   where proizvod = sd.proizvod
	                     and valuta=sd.valuta
	                     and datum =  (select max(datum)
	                                     from prodajni_cenovnik
	                                    where proizvod = sd.proizvod
	                                      AND Datum <= TO_DATE( TO_CHAR(D.DATUM_DOK,'DD.MM.YYYY')||' '||'23:59:59','DD.MM.YYYY HH24.MI:SS')
	                                      and valuta=sd.valuta
	                                  )
	                 ) VP_CENA

				, LAST_VALUE(proizvod)    over
				     (ORDER BY org_deo, sd.proizvod, d.datum_dok, D.DATUM_UNOSA ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)  pro_last

				,		case
						when d.vrsta_dok in ('8','27','28','32')
						then
						       case when d.VRSTA_DOK in ('8','27') then
						                 d.broj_dok
						       Else
						                 (select vd.za_broj_dok
						                  from vezni_dok vd
						                  where vd.za_vrsta_dok='8'
						                    and vd.broj_dok=d.broj_dok
						                    and vd.vrsta_dok=d.vrsta_dok
						                    and vd.godina=d.godina
						                 )
						       end
						when d.vrsta_dok in ('1','27','45','46')
						then
							case when d.VRSTA_DOK in ('1','27') then
						                 d.broj_dok
						       Else
						                 (select vd.za_broj_dok
						                  from vezni_dok vd
						                  where vd.za_vrsta_dok='1'
						                    and vd.broj_dok=d.broj_dok
						                    and vd.vrsta_dok=d.vrsta_dok
						                    and vd.godina=d.godina
						                 )
						       end
						else
							null
						End vd_brd

				,		case when d.vrsta_dok in ('8','27','28','32')
						then
						    case when d.VRSTA_DOK in ('8','27') then
						                 d.vrsta_dok
						       Else
						                 (select vd.za_vrsta_dok
						                  from vezni_dok vd
						                  where vd.za_vrsta_dok='8'
						                    and vd.broj_dok=d.broj_dok
						                    and vd.vrsta_dok=d.vrsta_dok
						                    and vd.godina=d.godina
						                 )
						       end
						when d.vrsta_dok in ('1','27','45','46')
						then
							case when d.VRSTA_DOK in ('1','27') then
						                 d.vrsta_dok
						       Else
						                 (select vd.za_vrsta_dok
						                  from vezni_dok vd
						                  where vd.za_vrsta_dok='1'
						                    and vd.broj_dok=d.broj_dok
						                    and vd.vrsta_dok=d.vrsta_dok
						                    and vd.godina=d.godina
						                 )
						       end

						else
							null
						End vd_vrd

				,		case when d.vrsta_dok in ('8','27','28','32')
						then
						      case when d.VRSTA_DOK in ('8','27') then
						                 d.godina
						       Else
						                 (select vd.za_godina
						                  from vezni_dok vd
						                  where vd.za_vrsta_dok='8'
						                    and vd.broj_dok=d.broj_dok
						                    and vd.vrsta_dok=d.vrsta_dok
						                    and vd.godina=d.godina
						                 )
						       end
						when d.vrsta_dok in ('1','27','45','46')
						then
						       case when d.VRSTA_DOK in ('1','27') then
						                 d.godina
						       Else
						                 (select vd.za_godina
						                  from vezni_dok vd
						                  where vd.za_vrsta_dok='1'
						                    and vd.broj_dok=d.broj_dok
						                    and vd.vrsta_dok=d.vrsta_dok
						                    and vd.godina=d.godina
						                 )
						       end
						else
							null
						End vd_god
               ,sd.valuta sd_val
			from stavka_dok sd, dokument d
			Where
			  -- veza tabela
			      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
			  -- ostali uslovi
	          and d.godina in (to_char(&dat_od,'yyyy'),to_char(&dat_do,'yyyy'))
              and d.datum_dok between &dat_od and &dat_do
	          and d.org_Deo
--	          =
--	          &nOrg
	           in (  select distinct d.org_deo
	                 from dokument d
	                 where d.godina in (to_char(&dat_od,'yyyy'),to_char(&dat_do,'yyyy'))
	                   and d.vrsta_dok not in ('2','9','10')
	                   and org_Deo not in(select magacin from partner_magacin_flag)
	             )

	          --1105
			--  AND D.VRSTA_DOK ='21'
			  AND (K_ROBE <> 0 or d.vrsta_dok = '80')
			  AND STATUS  > 0
	--		  and to_char(d.org_deo) IN (Select distinct polje1 from deja_pomocna_tab where polje79='304' AND polje1!='magacin')

	          and sd.proizvod=
	          NVL(&cPro,SD.PROIZVOD)
		) d1

	) d1
	, organizacioni_Deo od
	, poslovni_partner pp
	, proizvod p
	, POSEBNA_GRUPA pg
	where od.id= d1.mag
	  and pp.sifra (+) = d1.prt
	  and p.sifra (+) = d1.pro
	  and pg.grupa (+) = p.posebna_grupa
	  and pro_last <> pro
	--and pro = '3006'
) d1

--where
--
--   PROS_CENA <> cena1
--
--or (stanje = 0 and saldo <> 0)
--pro not in ()

order by
--god,
--pos_gr,
to_number(pro),
mag,
d1.datum_dok,d1.datum_unosa;
