select sum(zaduzenje) zad, sum(razduzenje) razd, sum(zaduzenje - razduzenje) stanje

from(
        select dodatni_tip d_tip, broj_dok brd, god_dok god, vrsta_dok vrd,
               --------------------------------------------------------------------------------------------
               TRUNC((MOD(ROWNUM-1,&BrRedNaStranici)-ROWNUM)*(-1)/&BrRedNaStranici,0)+1 str,
               --------------------------------------------------------------------------------------------
               ROWNUM rbr,
               datum_unosa,org_Deo mag,
               --------------------------------------------------------------------------------------------
               TO_CHAR(datum_dok,'DD.MM.YY') DATUM,
               --------------------------------------------------------------------------------------------
               datum_dok,
               --------------------------------------------------------------------------------------------
               NVL(
               CASE WHEN zaduzenje<>0 and tip_dok in (10) and vrsta_dok not in ('4')  THEN
                       (
                        select 'KVPC:'||DX.ORG_DEO||'-'||DX.BROJ_DOK1||'/'||SUBSTR(DX.GODINA,3,2)
                          from vezni_dok VDX, DOKUMENT DX
                         where VDX.ZA_VRSTA_DOK = DX.VRSTA_DOK
                           AND VDX.ZA_BROJ_DOK  = DX.BROJ_DOK
                           AND VDX.ZA_GODINA    = DX.GODINA
                           AND VDX.vrsta_dok = vr_dok
                           and VDX.broj_dok  = br_dok
                           and VDX.godina    = GOD_DOK
                          and za_vrsta_dok = '85'

                       )
                    WHEN zaduzenje <> 0 and vrsta_dok in ('73') THEN
                           'KVPC:'||dokument
                    WHEN vrsta_dok = '13' THEN
                       'POVR:'||dokument
                    WHEN vrsta_dok = '4' THEN
                       'STPR:'||dokument
                    ELSE
                       dokument
               END,'-') dokument,
               --------------------------------------------------------------------------------------------
               naziv_partnera||po_dokumentu naziv_partnera,
               tip_dok
               ,
               --------------------------------------------------------------------------------------------
               case when NVL(zaduzenje,0) + NVL(rabat,0) <> 0 then
                         nvl(zaduzenje,0) + nvl(rabat,0)
                    else
                       0
               end zaduzenje,

               --------------------------------------------------------------------------------------------
               case when NVL(razduzenje,0) <> 0 then
                       nvl(razduzenje,0)+nvl(rabat,0)
                    else
                       0
               end razduzenje
               --------------------------------------------------------------------------------------------

               , ZADUZENJE ZAD, RAZDUZENJE RAZD, RAZD_old
               , RABAT RAB, RABAT_OLD
          from (

        select
               org_podaci.dodatni_tip,
               d.org_deo,
               d.vrsta_dok,vd.naziv vd_naziv,
               d.tip_dok, nf.naziv tip_naziv,
               d.broj_dok,d.broj_dok1,d.godina,
               D.GODINA GOD_DOK,
               D.BROJ_DOK BR_DOK,
               D.VRSTA_DOK VR_DOK,
               d.datum_dok,d.datum_unosa,
               to_char(d.datum_dok,'dd.mm.yyyy') datum,
               D.ORG_DEO||'-'||d.broj_dok1||'/'||substr(d.godina,3,4) dokument,
               case when d.vrsta_dok = (11) and d.tip_dok in (23,238) then 'Int.Otprema'
                    when d.vrsta_dok = (3) and d.tip_dok in (115) then 'Int.Prijem'
                    when d.vrsta_dok in (70) then 'Medjuskl.Izl'
                    when d.vrsta_dok in (71) then 'Medjuskl.Ul'
                    when d.vrsta_dok = (12) and d.tip_dok = 23 then 'STORNO INT.OTPR.'
                    when d.vrsta_dok in (21) then 'POCETNO STANJE'
                    when d.vrsta_dok in (90) then 'NIVEL.'
                    when d.vrsta_dok not in (80) then SUBSTR(pp.naziv,1,19)
                    else
                         'NIVELACIJA'
               end naziv_partnera,
               CASE WHEN D.VRSTA_DOK = 3 AND D.TIP_DOK = 10 THEN
                         (select ' (OTPR: '||TRIM(za_broj_dok)||')' from vezni_dok where vrsta_dok = d.vrsta_dok and broj_dok = d.broj_dok and godina = d.godina and za_vrsta_dok = '24')
                    WHEN D.VRSTA_DOK = 73 THEN
                         (select ' ('||TRIM(za_broj_dok)||'/'||za_godina||')' from vezni_dok where vrsta_dok = d.vrsta_dok and broj_dok = d.broj_dok and godina = d.godina and za_vrsta_dok = '24')
                    WHEN D.VRSTA_DOK = 90 THEN
                         (select '(UZROK:'
                                   ||
                                   case when dp.vrsta_dok = 13 then 'POVR.'
                                        WHEN DP.VRSTA_dok = 12 then 'STOR.'
                                        ELSE
                                             ' '
                                   END
                                   ||dp.org_deo||'-'||dp.broj_dok1||'/'||SUBSTR(za_godina,3,2)||')'
                            from vezni_dok VDP, DOKUMENT DP

                           where VDP.vrsta_dok    = d.vrsta_dok
                             and VDP.broj_dok     = d.broj_dok
                             and VDP.godina       = d.godina
                             AND VDP.ZA_vrsta_dok = dp.vrsta_dok
                             and vdp.za_godina    = dp.godina
                             and vdp.za_broj_dok  = dp.broj_dok)
                    WHEN D.VRSTA_DOK = 13 THEN
                         (
                            select
                                   '(RN-OT:'||DX.ORG_DEO||'-'||DX.BROJ_DOK1||'/'||SUBSTR(DX.GODINA,3,2)||')'
                              from vezni_dok VDX, DOKUMENT DX
                             where VDX.ZA_VRSTA_DOK = DX.VRSTA_DOK
                               AND VDX.ZA_BROJ_DOK  = DX.BROJ_DOK
                               AND VDX.ZA_GODINA    = DX.GODINA
                               AND VDX.vrsta_dok    = d.vrsta_dok
                               and VDX.broj_dok     = d.broj_dok
                               and VDX.godina       = d.godina
                              and za_vrsta_dok = '11'
                         )
                    ELSE

                    NULL
               END
               po_dokumentu,
               ----------------------------------------------------------------------------------------------------------------------------------------------
               sum(NVL(

--	                        round(nvl(sign(ST.K_ROBE) * ST.KOLICINA * ST.K_ROBE * round(st.cena1 * ST.FAKTOR,4) *

	                        round(nvl(sign(ST.K_ROBE) * ST.KOLICINA * ST.K_ROBE *
--	                                                               round(
	                                                                     st.cena1
--	                                                                     *
--	                                                                     Case when faktor < 1 Then
--	                                                                          st.faktor
--	                                                                     Else
--	                                                                          1/st.faktor
--	                                                                     End
--	                                                                     ,4)
	                                                                     *

	                                  PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'D',d.datum_dok)
	                                 ,0)
	                                 ,2
	                             )
                       ,0)*
	                   (case when UPPER(ORG_PODACI.dodatni_tip) like 'VP%' AND D.VRSTA_DOK='90' THEN
	                               0
	                         ELSE
	                               1
	                    END)
                            +
	                    case when d.vrsta_dok in (80) then
	                              ROUND(st.kolicina*(NVL(st.cena1,0)-NVL(st.cena,0)),2)
	                         WHEN d.vrsta_dok in (90) then
	                              case when UPPER(ORG_PODACI.dodatni_tip) like 'VP%' AND D.VRSTA_DOK='90' THEN
	                                        nvl(
	                	                            (
--	                	                             	select (case when vd3.za_vrsta_dok is null or vd3.za_vrsta_dok in (13) then -1
--	                	                                	     	 when vd3.za_vrsta_dok in (11,12,31,74) then 1

	                	                             	select (case when vd3.za_vrsta_dok is null or vd3.za_vrsta_dok in (13,31) then -1
	                	                                	     	 when vd3.za_vrsta_dok in (11,12,74) then 1


	                	                               		    else 1
	                	                               		    end
	                	                               		   )

	                     						 	 	from vezni_dok vd3
											     	 	where vd3.vrsta_dok = d.vrsta_dok
											              and vd3.godina    = d.godina
											              and vd3.broj_dok  = d.broj_dok
											              and vd3.za_vrsta_dok in(11,12,13,31,74)
											        )
												,-1)

	                                  ELSE
	                                     1
	                             END
	                             *
--	                             ROUND(st.kolicina*( st.cena - NVL(round(st.cena1*st.faktor,4),0)),2)
	                             ROUND(st.kolicina*( st.cena - NVL(round(st.cena1*
	                                                                     Case when faktor < 1 Then
	                                                                          st.faktor
	                                                                     Else
	                                                                          1/st.faktor
	                                                                     End
	                                                               ,4),0)),2)
	                        else
	                           0
	                   end
	                   )                                                                                                                 ZADUZENJE,
               ----------------------------------------------------------------------------------------------------------------------------------------------
               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                 st.cena
                               * st.rabat/100
                               * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)*(-1),0),2) ,0 ))               RABAT_OLD,
               ----------------------------------------------------------------------------------------------------------------------------------------------

--              -1 *
--                  sum(VrednostiNaStavkama_new(
--
--                                    case when d.vrsta_dok in (80,90) then
--	                                          1
--	                                     -- izlazni
--	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) * SIGN(st.K_ROBE) > 0 then
--	                                          1
--	                                     -- ulazni
--	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
--	                                          2
--	                               end  , -- NACIN_OBRACUNA
--                                  'RABAT_KASA',
--                                  NVL(st.Kolicina,0),
--                                  NVL(st.Cena,0) ,
--                                  NVL(st.Faktor,0),
----                                  st.k_robe    ,
--                                  DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE),
--                                  NVL(st.Rabat,0),
--                                  NVL(D.Spec_rabat,0),
--                                  NVL(D.Kasa,0),
--                                  st.Porez,
--                                  NVL(st.Akciza,0),
--                                  NVL(st.Cena1,0),
--                                  NVL(st.Z_TROSKOVI,0),
--                           	      case when d.vrsta_dok in (80,90) then
--	                                        1
--                                       -- izlazni
--	                                   when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) * SIGN(st.K_ROBE) > 0 then
--	                                        -1
--                                       -- ulazni
--	                                   when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
--	                                        1
--	                              end --PlusMinus
--
--                                  ,st.proc_vlage,st.proc_necistoce,nvl(st.taksa,0),nvl(d.datum_dok,sysdate)
--
--                                  ,nvl(st.valuta,'YUD')
--                                  ,d.vrsta_dok
--                                  ,d.org_deo
--                                  ,d.ppartner
--                            )
--               )

             -1* sum(VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) * SIGN(st.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'RABAT',
                                  NVL(st.Kolicina,0), NVL(st.Cena,0),NVL(st.Faktor,0),DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE),
                                  NVL(st.Rabat,0),NVL(D.Spec_rabat,0),NVL(D.Kasa,0),st.Porez,NVL(st.Akciza,0),NVL(st.Cena1,0),NVL(st.Z_TROSKOVI,0),
                           	      case when d.vrsta_dok in (80,90) then
	                                        1
                                       -- izlazni
	                                   when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) * SIGN(st.K_ROBE) > 0 then
	                                        -1
                                       -- ulazni
	                                   when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                        1
	                              end --PlusMinus

                                  ,st.proc_vlage,st.proc_necistoce,nvl(st.taksa,0),nvl(d.datum_dok,sysdate),nvl(st.valuta,'YUD'),d.vrsta_dok
                                  ,d.org_deo,d.ppartner
                            )
               )																																RABAT,
               ----------------------------------------------------------------------------------------------------------------------------------------------
               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
			                    (Case When st.valuta <> 'YUD' Then
			                         (
			                           Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
			                                     round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'), DECODE(D.PPARTNER, '206',2, '172',2, 4))
			                                When D.Vrsta_Dok != '73' Then
			                                     round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
			                           End
			                         )
			                     Else
			                         st.cena
			                     End
			                    )

                               * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)
                            ,0)
                   ,2),0)
                   )                                                                                                                     RAZD_old
,
              sum(VrednostiNaStavkama_new(
                                    case when d.vrsta_dok in (80,90) then
	                                          1
	                                     -- izlazni
	                                     when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) * SIGN(st.K_ROBE) > 0 then
	                                          1
	                                     -- ulazni
	                                     when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                          2
	                               end  , -- NACIN_OBRACUNA
                                  'VREDNOST',
                                  NVL(st.Kolicina,0), NVL(st.Cena,0),NVL(st.Faktor,0),DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE),
                                  NVL(st.Rabat,0),NVL(D.Spec_rabat,0),NVL(D.Kasa,0),st.Porez,NVL(st.Akciza,0),NVL(st.Cena1,0),NVL(st.Z_TROSKOVI,0),
                           	      case when d.vrsta_dok in (80,90) then
	                                        1
                                       -- izlazni
	                                   when 0-PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) * SIGN(st.K_ROBE) > 0 then
	                                        -1
                                       -- ulazni
	                                   when PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok) <> 0 and d.vrsta_dok not in (11,12,61) then
	                                        1
	                              end --PlusMinus

                                  ,st.proc_vlage,st.proc_necistoce,nvl(st.taksa,0),nvl(d.datum_dok,sysdate),nvl(st.valuta,'YUD'),d.vrsta_dok
                                  ,d.org_deo,d.ppartner
                            )
               )RAZDUZENJE
               ----------------------------------------------------------------------------------------------------------------------------------------------
          from dokument d,(SELECT  sd.BROJ_DOK,sd.VRSTA_DOK,sd.GODINA,sd.STAVKA,
                                   sd.PROIZVOD,sd.LOT_SERIJA,sd.ROK,sd.KOLICINA,sd.JED_MERE,sd.CENA,sd.VALUTA,
                                   sd.LOKACIJA,sd.PAKOVANJE,sd.BROJ_KOLETA,sd.K_REZ,sd.K_ROBE,sd.K_OCEK,sd.KONTROLA,sd.FAKTOR,
                                   sd.REALIZOVANO,sd.RABAT,sd.POREZ,sd.KOLICINA_KONTROLNA,sd.AKCIZA,sd.TAKSA,
                                   sd.CENA1,sd.Z_TROSKOVI
                                   , SD.PROC_VLAGE, SD.PROC_NECISTOCE
                           FROM STAVKA_DOK sd

                           UNION ALL

                           SELECT VDP.ZA_BROJ_DOK,VDP.ZA_VRSTA_DOK,VDP.ZA_GODINA,STAVKA,
                                  PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,
                                  VALUTA,LOKACIJA,PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI
                                  , STP.PROC_VLAGE, STP.PROC_NECISTOCE
                           FROM STAVKA_DOK STP, VEZNI_DOK VDP
                           WHERE VDP.VRSTA_DOK = STP.VRSTA_DOK
                             AND VDP.GODINA    = STP.GODINA
                             AND VDP.BROJ_DOK  = STP.BROJ_DOK
                             AND VDP.ZA_VRSTA_DOK = '90'
                             AND STP.CENA<>ROUND(STP.CENA1*STP.FAKTOR,4)) ST
               , proizvod p, poslovni_partner pp, organizacioni_deo orgd, vrsta_dok vd, nacin_fakt nf, org_deo_osn_podaci org_podaci
         where d.broj_dok  = st.broj_dok and d.vrsta_dok = st.vrsta_dok  and d.godina    = st.godina

           and d.vrsta_dok = vd.vrsta
           and d.tip_dok   = nf.tip
           and st.proizvod = p.sifra
           and d.ppartner  = pp.sifra (+)
           and d.org_deo   = orgd.id
--           and d.vrsta_dok not in (2,9,10,61,62)
           and (st.k_robe <>0 or d.vrsta_Dok = 80)
           and orgd.id     = org_podaci.org_deo
           and p.tip_proizvoda not in (8)
           and d.org_deo   = &vZa_Magacin
           and d.datum_dok between  &DatumPocetnogStanja and &dDatumDo --to_date('31.12.'||to_char(dDatumOd,'yyyy'),'dd.mm.yyyy')
           AND D.STATUS > 0
--and d.vrsta_Dok = '80'
--      and (
----              (d.vrsta_dok = 11 and d.broj_dok='14037')
----              or
----              (d.vrsta_dok = 3 and d.broj_dok in ('8568','8043'))
--              (d.vrsta_dok = 3 and d.broj_dok in ('8043'))
--              or
--              (d.vrsta_dok = 5 and d.broj_dok='1847')
----              or
----              (d.vrsta_dok = 12 and d.broj_dok='87')
--          )

        group by  d.org_deo,org_podaci.dodatni_tip,
                  d.vrsta_dok,vd.naziv ,
                  d.tip_dok, nf.naziv ,
                  d.broj_dok,d.broj_dok1,d.godina,
                  d.datum_dok,d.datum_unosa,
                  to_char(d.datum_dok,'dd.mm.yyyy') ,
                  d.org_deo||'-'||d.broj_dok1||'/'||d.godina ,
                  pp.naziv

        order by d.org_deo,d.datum_dok,d.datum_unosa)

)
