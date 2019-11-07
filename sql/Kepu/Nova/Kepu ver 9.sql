select sum(zad) zad, sum(razd) razd, sum(zad-razd) stanje
from
--(
--select * from
(
select d.DODATNI_TIP,d.BROJ_DOK,d.GOD_DOK,d.VRSTA_DOK
--     ,d.STRANICA,d.REDBRSTAVKE
     , d.DATUM,d.DATUM_DOK
     , d.DOKUMENT,d.NAZIV_PARTNERA,d.DATUM_UNOSA,d.TIP_DOK,d.ORG_DEO,d.BROJ_DOK1,d.PPARTNER,d.PO_DOKUMENTU
     , d.ST_BRD,d.ST_VRD,d.ST_GOD

--, D.PROIZVOD, d.kolicina, d.cena, d.valuta, d.faktor, d.rabat, d.cena1
--, ZADUZENJE
--, RAB
--, RAZDUZENJE
,
sum(
               case when NVL(zaduzenje,0) + NVL(rab,0) <> 0 then
                         nvl(zaduzenje,0) + nvl(rab,0)
                    else
                       0
               end
   )
               zad,

sum(
               case when NVL(razduzenje,0) <> 0 then
                       nvl(razduzenje,0)+nvl(rab,0)
                    else
                       0
               end
    )
               razd
, sum(zaduzenje) zad_c
, sum(razduzenje) razd_c
, sum(rab) rab_c

from
(
	Select
	       d.dodatni_tip, d.broj_dok, d.godina god_dok, d.vrsta_dok
	       ,
--	       TRUNC((MOD(ROWNUM-1,&BrRedNaStranici)-ROWNUM)*(-1)/&BrRedNaStranici,0)+1 STRANICA,
--	       ROWNUM RedBrStavke,
	       to_char(d.datum_dok,'dd.mm.yy') datum, d.datum_dok,
	       to_char(d.org_deo) ||'-'||d.broj_dok1||'/'||substr(d.godina,3,2) dokument,
	       d.naziv_partnera,
	--       d.zaduzenje,
--            SUM(
               CASE WHEN D.VRSTA_DOK = '80' THEN
                             ROUND(d.kolicina*(NVL(d.cena1,0)-NVL(d.cena,0)),2)
                    WHEN D.VRSTA_DOK = '90' and nvl(d.cena,0) <> NVL(round(d.cena1*d.faktor,4),0) THEN
                             case when vd_niv_stav.za_vrsta_dok=13 then
                                       -1 * ROUND(d.kolicina*(NVL(d.cena,0)-NVL(round(d.cena1*d.faktor,4),0)),2)
                             else
                                       ROUND(d.kolicina*(NVL(d.cena,0)-NVL(round(d.cena1*d.faktor,4),0)),2)
                             end
                    WHEN D.VRSTA_DOK = '90' and nvl(d.cena,0) = NVL(round(d.cena1*d.faktor,4),0) THEN
                                       0
               Else

--                                       ROUND(sign(d.K_ROBE)*d.kolicina*NVL(d.cena1,0)*d.faktor,2)*d.k_robe
--                                       * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,d.K_ROBE,'D',d.datum_dok)

                                      round(nvl(sign(D.K_ROBE) * D.KOLICINA * D.K_ROBE * round(D.cena1 * D.FAKTOR,4) *
	                                            PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,D.K_ROBE,'D',d.datum_dok)
   	                                           ,0)
	                                       ,2
	                                       )

               END
--                  )
                  ZADUZENJE,
--            SUM(
               CASE WHEN D.VRSTA_DOK = '80' THEN
                         0
                    WHEN D.VRSTA_DOK = '90' THEN
                         0
               Else
--                         -1 * ROUND(sign(d.K_ROBE)*d.kolicina*NVL(d.cena,0)* d.rabat / 100,2)
--                            * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,d.K_ROBE,'P',d.datum_dok)


               NVL(round(nvl(sign(D.K_ROBE)*D.KOLICINA*DECODE(D.VRSTA_DOK,'90',0,D.K_ROBE)*
                                 D.cena
                               * D.rabat/100
                               * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,D.K_ROBE,'P',d.datum_dok)*(-1),0),2), 0 )
               END
--                  )
                  RAB,
--            SUM(
                  NVL(round(nvl(sign(D.K_ROBE)*D.KOLICINA*DECODE(D.VRSTA_DOK,'90',0,D.K_ROBE)*
                                D.cena *
                                PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,D.K_ROBE,'P',d.datum_dok)
                      ,0)
                      ,2),0)
--                  )
                  RAZDUZENJE,
	       d.datum_unosa, d.tip_dok, d.org_deo, d.broj_dok1,
	       d.ppartner

	     , CASE WHEN D.VRSTA_DOK = 3 AND D.TIP_DOK = 10 THEN
	                 '(OTPR: '||TRIM(vd_prij.za_broj_dok)||')'
	            WHEN D.VRSTA_DOK = 73 THEN
	                 '('||vd_prij_tr.za_broj_dok||'/'||vd_prij_tr.za_godina||')'
	            WHEN D.VRSTA_DOK = 90 THEN
	                 '(UZROK:'
	                               ||
	                               case when vd_niv_stav.za_vrsta_dok = 13 then
	                                        'POVR.'
	                                    WHEN vd_niv_stav.za_VRSTA_dok = 12 then
	                                        'STOR.'
	                                    ELSE
	                                         ' '
	                               END

	                  ||vd_niv_stav_mag||'-'||vd_niv_stav_brd1||'/'||SUBSTR(vd_niv_stav.za_godina,3,2)||')'
	            WHEN D.VRSTA_DOK = 13 THEN
	                 '(RN-OT:'||vd_pov_otp_mag||'-'||vd_pov_otp_brd1||'/'||SUBSTR(vd_pov_otp.za_godina,3,2)||')'
	            WHEN D.VRSTA_DOK = 5 THEN
	                 '(PRIJ:'||vd_pov_prij_mag||'-'||vd_pov_prij_brd1||'/'||SUBSTR(vd_pov_prij.za_godina,3,2)||')'
	       ELSE
	                 NULL
	       END																										PO_DOKUMENTU
	     , case when d.vrsta_dok = 90 Then
	                 vd_niv_stav.za_broj_dok
	       else
	                 d.broj_dok
	       end  st_brd
	     , case when d.vrsta_dok = 90 Then
	                 vd_niv_stav.za_vrsta_dok
	       else
	                 d.vrsta_dok
	       end  st_vrd
	     , case when d.vrsta_dok = 90 Then
	                 vd_niv_stav.za_godina
	       else
	                 d.godina
	       end  st_god

, D.PROIZVOD, d.kolicina, d.cena, d.valuta, d.faktor, d.rabat, d.cena1

	From
	(

	Select
	          org_podaci.dodatni_tip,
	          d.datum_dok, d.datum_unosa, d.godina, d.broj_dok, d.tip_dok, d.vrsta_dok, d.org_deo, d.broj_dok1, d.ppartner
	     ,
	               case when d.vrsta_dok = (11) and d.tip_dok in (23,238) then
	                         'Int.Otprema'
	                    when d.vrsta_dok = (3) and d.tip_dok in (115) then
	                         'Int.Prijem'
	                    when d.vrsta_dok in (70) then
	                         'Medjuskl.Izl'
	                    when d.vrsta_dok in (71) then
	                         'Medjuskl.Ul'
	                    when d.vrsta_dok = (12) and d.tip_dok = 23 then
	                         'STORNO INT.OTPR.'
	                    when d.vrsta_dok in (21) then
	                         'POCETNO STANJE'
	                    when d.vrsta_dok in (90) then
	                         'NIVEL.'
	                    when d.vrsta_dok not in (80) then
	                         SUBSTR(pp.naziv,1,19)
	                    else
	                         'NIVELACIJA'
	               end naziv_partnera
, SD.PROIZVOD, sd.kolicina, sd.cena, sd.valuta, sd.faktor, sd.rabat, sd.cena1, sd.k_robe
	--     , SD.PROIZVOD
	from dokument d
	   , poslovni_partner pp
	   , org_deo_osn_podaci org_podaci
	,
	------------------------------------------------------------------------------------------------------------------------------------------------
	(

								select
								       ds.BROJ_DOK,ds.VRSTA_DOK,ds.GODINA,ds.V_BRD,ds.V_VRD,ds.V_GOD
								     , ds.PROIZVOD,ds.KOLICINA,ds.CENA,ds.valuta,ds.FAKTOR,ds.K_ROBE,ds.RABAT,ds.CENA1
								From
								(
									Select d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.V_BRD, d.V_VRD, d.V_GOD
									     , case when d.vrsta_dok ='90' then
									                 case when  nvl(sd.cena,0) <> NVL(round(sd.cena1*sd.faktor,4),0) Then
									                      sd.proizvod
									                 end
									       else
									                 sd.proizvod
									       end       proizvod

									     , sd.kolicina, sd.cena, sd.valuta, sd.faktor, sd.k_robe, nvl(sd.rabat,0) rabat, sd.cena1
									From
									(
										Select d.broj_dok, d.vrsta_Dok, d.godina--, d.datum_dok, d.broj_dok1
										     , case when d.vrsta_dok='90' then vd.za_broj_dok else d.broj_Dok end 		V_Brd
										     , case when d.vrsta_dok='90' then vd.za_vrsta_dok else d.vrsta_dok end 	V_Vrd
										     , case when d.vrsta_dok='90' then vd.za_godina else d.godina end 			V_God

										--     , vd.za_vrsta_dok, vd.za_godina
										--     , sd.STAVKA,sd.PROIZVOD,sd.LOT_SERIJA,sd.ROK,sd.KOLICINA,sd.JED_MERE,sd.CENA,sd.VALUTA,sd.LOKACIJA
										--     , sd.PAKOVANJE,sd.BROJ_KOLETA,sd.K_REZ,sd.K_ROBE,sd.K_OCEK,sd.KONTROLA,sd.FAKTOR,sd.REALIZOVANO
										--     , sd.RABAT,POREZ,sd.KOLICINA_KONTROLNA,sd.AKCIZA,sd.TAKSA,sd.CENA1,sd.Z_TROSKOVI
										--     , sd.NETO_KG,sd.PROC_VLAGE,sd.PROC_NECISTOCE,sd.HTL
										From dokument d
										   , (Select vd.* From dokument d, vezni_dok vd--, dokument d1
										      Where d.broj_dok !='0'
										        and d.vrsta_dok = '90'
										        and d.godina != 0
										        and d.org_deo = &vZa_Magacin
										        and d.datum_dok between  &DatumPocetnogStanja and &dDatumDo
										        and d.STATUS > 0
										        and d.godina = vd.godina and d.vrsta_dok = vd.vrsta_dok and d.broj_dok = vd.broj_dok
										     ) vd
										Where d.broj_dok !='0'
										  and d.vrsta_dok not in (2,9,10,61,62,63,64, 85, 86)
										  and d.godina != 0
										  and d.org_deo = &vZa_Magacin
										  and d.datum_dok between  &DatumPocetnogStanja and &dDatumDo
										  and d.STATUS > 0
										  and d.broj_dok = vd.broj_dok (+) and d.vrsta_dok = vd.vrsta_dok (+) and d.godina = vd.godina (+)
									) d
									, (Select sd.*, p.tip_proizvoda
									   From stavka_dok sd, proizvod p
									   Where (sd.broj_dok,sd.vrsta_Dok,sd.godina) in
									         (Select d1.broj_dok,d1.vrsta_Dok,d1.godina From dokument d1
									          Where d1.broj_dok !='0'
									            and d1.vrsta_dok not in (2,9,10,61,62,63,64, 85, 86)
									            and d1.godina != 0
									            and d1.org_deo = &vZa_Magacin
									            and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
									            and D1.STATUS > 0
									         )
									     and (sd.k_robe <>0 or sd.vrsta_Dok  in( '80', '90' ) )
									     and p.sifra=sd.proizvod(+)
									     and p.tip_proizvoda not in (8)
									  ) sd
									Where d.v_brd = sd.broj_dok and d.v_vrd = sd.vrsta_dok and d.v_god = sd.godina
	--								  and d.vrsta_dok = '90'
								) ds
								where ds.proizvod is not null

	) sd

	------------------------------------------------------------------------------------------------------------------------------------------------
	where          d.broj_dok <> '0'
	           and d.vrsta_dok not in (2,9,10,61,62,63,64)
	           and d.godina != 0
	--           and orgd.id     = org_podaci.org_deo
	--           and p.tip_proizvoda not in (8)
	           and d.org_deo   = &vZa_Magacin
	           and d.datum_dok between  &DatumPocetnogStanja and &dDatumDo
	           and d.status > 0
	           and d.ppartner = pp.sifra (+)
	           and d.broj_dok = sd.broj_dok (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.godina = sd.godina (+)

	           and (sd.k_robe <>0 or d.vrsta_Dok  in( '80', '90' ) )

	--           and orgd.id     = org_podaci.org_deo
	           and d.org_deo = org_podaci.org_deo (+)
	--and d.vrsta_Dok = '85'
	Group by

	         d.datum_dok, d.datum_unosa, d.godina, d.broj_dok, d.tip_dok, d.vrsta_dok, d.org_deo, d.broj_dok1, d.ppartner
	       , pp.naziv, org_podaci.dodatni_tip
	       , SD.PROIZVOD, sd.kolicina, sd.cena, sd.valuta, sd.faktor, sd.rabat, sd.cena1, sd.k_robe
	) d

	, (Select vd.*
	   From vezni_dok vd
	   Where (vd.broj_dok,vd.vrsta_Dok,vd.godina) in
	         (Select d1.broj_dok,d1.vrsta_Dok,d1.godina From dokument d1
	          Where d1.broj_dok !='0'
	            and d1.godina != 0
	            and d1.org_deo = &vZa_Magacin
	            and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
	            and D1.STATUS > 0
	            and vrsta_dok = '3'
	         )
	     and za_vrsta_dok = '24'
	  ) vd_prij

	, (Select vd.*
	   From vezni_dok vd
	   Where (vd.broj_dok,vd.vrsta_Dok,vd.godina) in
	         (Select d1.broj_dok,d1.vrsta_Dok,d1.godina From dokument d1
	          Where d1.broj_dok !='0'
	            and d1.godina != 0
	            and d1.org_deo = &vZa_Magacin
	            and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
	            and D1.STATUS > 0
	            and vrsta_dok = '73'
	         )
	     and za_vrsta_dok = '24'
	  ) vd_prij_tr

	, (Select vd.broj_dok, vd.vrsta_Dok, vd.godina, vd.za_broj_dok, vd.za_vrsta_Dok, vd.za_godina
	        , d2.org_deo vd_niv_stav_mag, d2.broj_dok1 vd_niv_stav_brd1
	   From vezni_dok vd, dokument d2
	   Where d2.broj_dok !='0'
	     and d2.godina != 0
	     and d2.org_deo = &vZa_Magacin
	     and d2.datum_dok between  &DatumPocetnogStanja and &dDatumDo
	     and d2.STATUS > 0
	     and vd.vrsta_dok = '90'
	     and d2.godina = vd.za_godina (+) and d2.vrsta_dok = vd.za_vrsta_dok (+) and d2.broj_dok = vd.za_broj_dok (+)
	  ) vd_niv_stav

	, (Select vd.broj_dok, vd.vrsta_Dok, vd.godina, vd.za_broj_dok, vd.za_vrsta_Dok, vd.za_godina
	        , d2.org_deo vd_pov_otp_mag, d2.broj_dok1 vd_pov_otp_brd1
	   From dokument d1, vezni_dok vd, dokument d2
	   Where d1.broj_dok !='0'
	     and d1.godina != 0
	     and d1.org_deo = &vZa_Magacin
	     and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
	     and d1.STATUS > 0
	     and d1.vrsta_dok = '13'
	     and vd.za_vrsta_dok = '11'
	     and d1.godina = vd.godina and d1.vrsta_dok = vd.vrsta_dok and d1.broj_dok = vd.broj_dok
	     and d2.godina = vd.za_godina (+) and d2.vrsta_dok = vd.za_vrsta_dok (+) and d2.broj_dok = vd.za_broj_dok (+)
	  ) vd_pov_otp

	, (Select vd.broj_dok, vd.vrsta_Dok, vd.godina, vd.za_broj_dok, vd.za_vrsta_Dok, vd.za_godina
	        , d2.org_deo vd_pov_prij_mag, d2.broj_dok1 vd_pov_prij_brd1
	   From dokument d1, vezni_dok vd, dokument d2
	   Where d1.broj_dok !='0'
	     and d1.godina != 0
	     and d1.org_deo = &vZa_Magacin
	     and d1.datum_dok between  &DatumPocetnogStanja and &dDatumDo
	     and d1.STATUS > 0
	     and d1.vrsta_dok = '5'
	     and vd.za_vrsta_dok = '3'
	     and d1.godina = vd.godina and d1.vrsta_dok = vd.vrsta_dok and d1.broj_dok = vd.broj_dok
	     and d2.godina = vd.za_godina (+) and d2.vrsta_dok = vd.za_vrsta_dok (+) and d2.broj_dok = vd.za_broj_dok (+)
	  ) vd_pov_prij

	Where
	      d.godina = vd_prij.godina (+) and d.vrsta_dok = vd_prij.vrsta_dok (+) and d.broj_dok = vd_prij.broj_dok (+)
	  and d.godina = vd_prij_tr.godina (+) and d.vrsta_dok = vd_prij_tr.vrsta_dok (+) and d.broj_dok = vd_prij_tr.broj_dok (+)
	  and d.godina = vd_niv_stav.godina (+) and d.vrsta_dok = vd_niv_stav.vrsta_dok (+) and d.broj_dok = vd_niv_stav.broj_dok (+)
	  and d.godina = vd_pov_otp.godina (+) and d.vrsta_dok = vd_pov_otp.vrsta_dok (+) and d.broj_dok = vd_pov_otp.broj_dok (+)
	  and d.godina = vd_pov_prij.godina (+) and d.vrsta_dok = vd_pov_prij.vrsta_dok (+) and d.broj_dok = vd_pov_prij.broj_dok (+)

--	Group by d.BROJ_DOK,d.VRSTA_DOK,d.GODINA, ROWNUM, DODATNI_TIP,d.DATUM_DOK
--	       , NAZIV_PARTNERA
--	--       , d.zaduzenje
--	       , DATUM_UNOSA,TIP_DOK,ORG_DEO,BROJ_DOK1,PPARTNER
--
--	       , vd_prij.za_broj_dok, vd_prij.za_godina
--
--	       , vd_prij_tr.za_broj_dok, vd_prij_tr.za_godina
--
--	       , vd_niv_stav.za_broj_dok, vd_niv_stav.za_vrsta_dok, vd_niv_stav.za_godina, vd_niv_stav_mag, vd_niv_stav_brd1
--
--	       , vd_pov_otp.vd_pov_otp_mag, vd_pov_otp.vd_pov_otp_brd1, vd_pov_otp.za_godina
--
--	       , vd_pov_prij.vd_pov_prij_mag, vd_pov_prij.vd_pov_prij_brd1, vd_pov_prij.za_godina
) d
--where d.vrsta_Dok = '5'
--WHERE RAZDUZENJE < 0
--where d.vrsta_dok = 21
Group by d.DODATNI_TIP,d.BROJ_DOK,d.GOD_DOK,d.VRSTA_DOK
--       , d.STRANICA,d.REDBRSTAVKE
       , d.DATUM,d.DATUM_DOK
       , d.DOKUMENT,d.NAZIV_PARTNERA,d.DATUM_UNOSA,d.TIP_DOK,d.ORG_DEO,d.BROJ_DOK1,d.PPARTNER,d.PO_DOKUMENTU
       , d.ST_BRD,d.ST_VRD,d.ST_GOD
order by d.org_deo,d.datum_dok,d.datum_unosa
)
--where (   abs(zad) = 37182
--       or abs(razd) = 37182
--       or abs(zad-razd)=37182
--       or abs(zad+razd)=37182
--      )

