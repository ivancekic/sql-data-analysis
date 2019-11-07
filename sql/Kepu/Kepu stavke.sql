select * from
(
select dd.DODATNI_TIP,dd.BROJ_DOK,dd.GOD_DOK,dd.VRSTA_DOK,dd.STRANICA,dd.REDBRSTAVKE
     , dd.DATUM,dd.DATUM_DOK,dd.DOKUMENT,dd.NAZIV_PARTNERA,dd.tip_dok
     , abs(dd.ZADUZENJE) zad_kepu
     , abs(izn.rabat_izn) zad
     , abs(dd.RAZDUZENJE) razd_kepu
     , abs(izn.pdv_osn) razd


     , abs(dd.ZADUZENJE) + abs(dd.RAZDUZENJE) kepu
     , CASE WHEN DD.VRSTA_DOK = 80 THEN
                 (Select
                              sum(ROUND(sd2.kolicina*(NVL(sd2.cena1,0)-NVL(sd2.cena,0)),2))
                  from stavka_dok sd2
                  where sd2.broj_dok=dd.broj_dok and sd2.vrsta_Dok = '80' and sd2.godina = dd.god_dok
                 )
            WHEN DD.VRSTA_DOK = 90 THEN
(SELECT COUNT (*) FROM VEZNI_dok sd2 WHERE sd2.broj_dok=dd.broj_dok and sd2.vrsta_Dok = DD.VRSTA_DOK and sd2.godina = dd.god_dok)
--                 (Select ABS(Sum(ROUND(sd3.kolicina*(NVL(sd3.cena,0)-ROUND(NVL(sd3.cena1,0)*SD3.FAKTOR,4)),2)))
--                  from VEZNI_dok sd2, stavka_dok sd3
--                  where sd2.broj_dok=dd.broj_dok and sd2.vrsta_Dok = DD.VRSTA_DOK and sd2.godina = dd.god_dok
--                    AND SD2.ZA_BROJ_DOK = SD3.BROJ_DOK AND SD2.ZA_VRSTA_DOK=SD3.VRSTA_DOK AND SD2.ZA_GODINA= SD3.GODINA
--	                AND SD3.CENA<> ROUND(SD3.CENA1*SD3.FAKTOR,4)
--	             )

       ELSE
                 abs(izn.rabat_izn) + abs(izn.pdv_osn)

       END dok

--,
--               case when NVL(zad1,0) + NVL(rab1,0) <> 0 then
--                         nvl(abs(izn.pdv_osn),0) + nvl(abs(izn.rabat_izn),0)
--                    else
--                       0
--               end zadd,
--               --------------------------------------------------------------------------------------------
--               case when NVL(razd1,0) <> 0 then
--                         nvl(abs(izn.pdv_osn),0) + nvl(abs(izn.rabat_izn),0)
--                    else
--                       0
--               end razdd
--               -----------------------------
--     , zad1, rab1, razd1
from
(
        select dodatni_tip,broj_dok,god_dok,vrsta_dok,
               --------------------------------------------------------------------------------------------
               TRUNC((MOD(ROWNUM-1,&BrRedNaStranici)-ROWNUM)*(-1)/&BrRedNaStranici,0)+1 STRANICA,
               --------------------------------------------------------------------------------------------
               ROWNUM RedBrStavke,
               datum_unosa,org_Deo,
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
               tip_dok,
               zaduzenje zad1, rabat rab1, razduzenje razd1,
               --------------------------------------------------------------------------------------------
               case when NVL(zaduzenje,0) + NVL(rabat,0) <> 0 then
--                         nvl(zaduzenje,0) + nvl(rabat,0)
--                         nvl(zaduzenje,0) + nvl(rabat,0) + nvl(PDV_NA_ZADUZENJE,0)
                         nvl(zaduzenje,0) + nvl(PDV_NA_ZADUZENJE,0)
--                         (nvl(zaduzenje,0) + nvl(rabat,0)) * 1.18
--                         PDV_NA_RABAT

                    else
                       0
               end zaduzenje,

               --------------------------------------------------------------------------------------------
               case when NVL(razduzenje,0) <> 0 then
-- deja pdv
--                       nvl(razduzenje,0)+nvl(rabat,0)
                       nvl(razduzenje,0) + nvl(rabat,0) + nvl(PDV_RAZDUZENJE,0)
-- deja pdv
                    else
                       0
               end razduzenje


               --------------------------------------------------------------------------------------------
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
               end naziv_partnera,
               CASE WHEN D.VRSTA_DOK = 3 AND D.TIP_DOK = 10 THEN
                         (select ' (OTPR: '||TRIM(za_broj_dok)||')' from vezni_dok where vrsta_dok = d.vrsta_dok and broj_dok = d.broj_dok and godina = d.godina and za_vrsta_dok = '24')
                    WHEN D.VRSTA_DOK = 73 THEN
                         (select ' ('||TRIM(za_broj_dok)||'/'||za_godina||')' from vezni_dok where vrsta_dok = d.vrsta_dok and broj_dok = d.broj_dok and godina = d.godina and za_vrsta_dok = '24')
                    WHEN D.VRSTA_DOK = 90 THEN
                         (select '(UZROK:'
                                   ||
                                   case when dp.vrsta_dok = 13 then
                                            'POVR.'
                                        WHEN DP.VRSTA_dok = 12 then
                                            'STOR.'
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
	                        round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*ST.K_ROBE*st.cena1 *
	                                  PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'D',d.datum_dok)
	                                 ,0)
	                                 ,DECODE(D.PPARTNER, '206',2, '172',2, 4)
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
--                                        		(select case when vd3.za_vrsta_dok is null then -1 else 1 end
                	                            (
                	                             	select (case when vd3.za_vrsta_dok is null or vd3.za_vrsta_dok in (13) then -1
                	                                	     	 when vd3.za_vrsta_dok in (11,12,31,74) then 1
                	                               		    else 1
                	                               		    end
                	                               		   )

                     						 	 	from vezni_dok vd3
										     	 	where vd3.vrsta_dok = d.vrsta_dok
										              and vd3.godina    = d.godina
										              and vd3.broj_dok  = d.broj_dok
--										           and vd3.za_vrsta_dok = 11
										              and vd3.za_vrsta_dok in(11,12,13,31,74)
										        )
											,-1)

                                  ELSE
                                     1
                             END
                             *
                             ROUND(st.kolicina*(
							                    (Case When st.valuta <> 'YUD' Then
							                         (
							                           Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
							                               (

							                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
							                                           DECODE(D.PPARTNER, '206',2, '172',2, 4)
							                                           )
							                               )
							                           When D.Vrsta_Dok != '73' Then
							                                round(nvl(st.cena,0) *Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
							                           End
							                         )
							                     Else
							                         st.cena
							                     End
							                    )
                        -
                                      NVL(st.cena1*st.faktor,0)),2)
                        else
                           0
                   end
                   )                                                                                                                     ZADUZENJE,
               ----------------------------------------------------------------------------------------------------------------------------------------------
--               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                    (Case When st.valuta <> 'YUD' Then
                         (
                           Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                               (
                                 round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                       DECODE(D.PPARTNER, '206',2, '172',2, 4)
							          )
                               )
                           When D.Vrsta_Dok != '73' Then
                                round(nvl(st.cena,0) *
                                Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                           End
                         )
                     Else
                         st.cena
                     End
                    )
                   *st.rabat/100
                   *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)*(-1),0),2) ,0 ))                            RABAT,
               ----------------------------------------------------------------------------------------------------------------------------------------------
--               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                    (Case When st.valuta <> 'YUD' Then
                         (
                           Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                               (
                                 round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                       DECODE(D.PPARTNER, '206',2, '172',2, 4)
							          )
                               )
                           When D.Vrsta_Dok != '73' Then
                                round(nvl(st.cena,0) *
                                Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                           End
                         )
                     Else
                         st.cena
                     End
                    )
                             * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)
                            ,0)
                   ,2),0)
                   )                                                                                                                     RAZDUZENJE,
               ----------------------------------------------------------------------------------------------------------------------------------------------
               sum( --ROUND(
                    CASE WHEN &nPrikaziPDV = 0 Then
                              0
                    ELSE
                        (
--                         NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                         NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                       (Case When st.valuta <> 'YUD' Then
                                            (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                  (
                                 round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                       DECODE(D.PPARTNER, '206',2, '172',2, 4)
							          )

                                                  )
                                              When D.Vrsta_Dok != '73' Then
                                                   round(nvl(st.cena,0) *
                                                   Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                              End
                                            )
                                        Else
                                            st.cena
                                        End
                                       )
                                       * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)
                                      ,0)
                                  ,2)
                             ,0)
                             --- RAZDUZENJE KRAJ
                       +
--                         NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                         NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                       (Case When st.valuta <> 'YUD' Then
                                            (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                  (
                                 round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                       DECODE(D.PPARTNER, '206',2, '172',2, 4)
							          )


                                                  )
                                              When D.Vrsta_Dok != '73' Then
                                                   round(nvl(st.cena,0) *
                                                   Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                              End
                                            )
                                        Else
                                            st.cena
                                        End
                                       )
                                      * st.rabat/100
                                      * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)*(-1)
                                      ,0)
                                   ,2)
                             ,0 )
                             --- RABAT KRAJ
                         )
                       *
                                 -- posebno obradjeno kad nije unipasan pdv na stavkama
                                 -- po novom treba prikazti pdv za svaku vrstu dokumenta
                                 nvl(st.porez,PPorez.ProcenatPoreza( d.Poslovnica,St.Proizvod, D.Datum_Dok, '3' )) / 100
                    END
                    --,2)
                   )                                                                                                                     PDV_RAZDUZENJE,
               ----------------------------------------------------------------------------------------------------------------------------------------------
               CASE WHEN &nPrikaziPDV = 1 then
                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*ST.K_ROBE*st.cena1 *
--                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.K_ROBE*st.cena1 *
                                           PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'D',d.datum_dok)
                                       ,0)
                                       * nvl(st.porez,PPorez.ProcenatPoreza( d.Poslovnica,St.Proizvod, D.Datum_Dok, '3' )) / 100
                                   ,2)
                              ,0)
                      *
                      (case when UPPER(ORG_PODACI.dodatni_tip) like 'VP%' AND D.VRSTA_DOK='90' THEN
                                 0
                       ELSE
                                 1
                       END)
                      +
                       case when d.vrsta_dok in (80) then
                                 ROUND(st.kolicina*(NVL(st.cena1,0)-NVL(st.cena,0)),2)
                                 * nvl(st.porez,PPorez.ProcenatPoreza( d.Poslovnica,St.Proizvod, D.Datum_Dok, '3' )) / 100
                            WHEN d.vrsta_dok in (90) then
                                 case when UPPER(ORG_PODACI.dodatni_tip) like 'VP%' AND D.VRSTA_DOK='90' THEN
                                           nvl( (select case when vd3.za_vrsta_dok is null then -1 else 1 end
                     						     from vezni_dok vd3
										         where vd3.vrsta_dok = d.vrsta_dok
 										           and vd3.godina    = d.godina
										           and vd3.broj_dok  = d.broj_dok
										           and vd3.za_vrsta_dok = 11)
										       , -1)
                                 else
                                        1
                                 end
                                *
                                 ROUND(st.kolicina *
                                        (
                                          (Case When st.valuta <> 'YUD' Then
                                                (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                        (
                                 round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                       DECODE(D.PPARTNER, '206',2, '172',2, 4)
							          )
                                                        )
                                                      When D.Vrsta_Dok != '73' Then
                                                           round(nvl(st.cena,0) *
                                                           Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                                      End
                                                )
                                           Else
                                               st.cena
                                           End
                                         )
                                        -
                                          NVL(st.cena1*st.faktor,0)
                                        )
                                        * nvl(st.porez,PPorez.ProcenatPoreza( d.Poslovnica,St.Proizvod, D.Datum_Dok, '3' )) / 100
                                      ,2)
                       else
                           0
                       end
                       )
---------------------- rabat
                     +
--                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                        (Case When st.valuta <> 'YUD' Then
                                             (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                   (
                                 round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                       DECODE(D.PPARTNER, '206',2, '172',2, 4)
							          )
                                                   )
                                                   When D.Vrsta_Dok != '73' Then
                                                        round(nvl(st.cena,0) *
                                                        Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                                   End
                                             )
                                         Else
                                             st.cena
                                         End
                                        )
                                       * st.rabat/100
                                       * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)*(-1)
                                       * nvl(st.porez,PPorez.ProcenatPoreza( d.Poslovnica,St.Proizvod, D.Datum_Dok, '3' )) / 100
                                       ,0)
                                    ,2)
                              ,0 )
                         )
                     +
--                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                        (Case When st.valuta <> 'YUD' Then
                                            (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                  (
                                 round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                       DECODE(D.PPARTNER, '206',2, '172',2, 4)
							          )
                                                  )
                                                  When D.Vrsta_Dok != '73' Then
                                                       round(nvl(st.cena,0) *
                                                       Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                              End
                                            )
                                         Else
                                             st.cena
                                         End
                                        )
                                      * st.rabat/100
                                      * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)*(-1)
                                       ,0)
                                   ,2)
                              ,0)
                  )
 -- prikaz bez pdv
               ELSE
--                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                        (Case When st.valuta <> 'YUD' Then
                                            (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                  (
                                 round(nvl(st.cena,0) * Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                       DECODE(D.PPARTNER, '206',2, '172',2, 4)
							          )
                                                  )
                                                  When D.Vrsta_Dok != '73' Then
                                                       round(nvl(st.cena,0) *
                                                       Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                             End
                                            )
                                         Else
                                             st.cena
                                         End
                                        )
                                      * st.rabat/100
                                      * PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)*(-1)
                                      ,0)
                                   ,2)
                             ,0 )
                         )
               END                                                                                                                        PDV_NA_ZADUZENJE
               ----------------------------------------------------------------------------------------------------------------------------------------------
          from dokument d,(SELECT  BROJ_DOK,VRSTA_DOK,GODINA,STAVKA,
                                   PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,
                                   LOKACIJA,PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,
                                   CENA1,Z_TROSKOVI
                             FROM STAVKA_DOK

                            UNION ALL

                            SELECT VDP.ZA_BROJ_DOK,VDP.ZA_VRSTA_DOK,VDP.ZA_GODINA,STAVKA,
                                   PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,
                                   VALUTA,LOKACIJA,PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI
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
           and d.vrsta_dok not in (2,9,10,61,62)
           and orgd.id     = org_podaci.org_deo
           and p.tip_proizvoda not in (8)
           and d.org_deo   like &vZa_Magacin
           and d.datum_dok between  &DatumPocetnogStanja and &dDatumDo --to_date('31.12.'||to_char(dDatumOd,'yyyy'),'dd.mm.yyyy')
           AND D.STATUS > 0

        group by  d.org_deo,org_podaci.dodatni_tip,
                  d.vrsta_dok,vd.naziv ,
                  d.tip_dok, nf.naziv ,
                  d.broj_dok,d.broj_dok1,d.godina,
                  d.datum_dok,d.datum_unosa,
                  to_char(d.datum_dok,'dd.mm.yyyy') ,
                  d.org_deo||'-'||d.broj_dok1||'/'||d.godina ,
                  pp.naziv

        order by d.org_deo,d.datum_dok,d.datum_unosa)

)        dd
,(

		SELECT broj_dok, vrsta_Dok, godina, org_Deo, broj_dok1
		     , SUM(VRED) VRED,SUM(RABAT_IZN) RABAT_IZN,SUM(PDV_OSN) PDV_OSN, SUM(PDV_IZNOS) PDV_IZNOS, SUM(ZA_KUPCA) ZA_KUPCA
		FROM
		(
		select VRSTA_DOK,STATUS,BROJ_DOK,ORG_DEO,BROJ_DOK1,GODINA,DATUM_DOK,PPARTNER,PRT_NAZIV
		     , TIP_DOK, tip_naziv
		     , PROIZVOD,PRO_NAZIV,JED_MERE,VAL,cena,KOL,RABAT, porez
		     , VRED
		     , RABAT_IZN,KASA
		     , akciza_iznos
		     , (Vred-RABAT_IZN)*(1- nvl(Kasa,0)/100) + akciza_iznos PDV_OSN
		     , PDV_IZNOS,TAKSA_IZNOS
		     , (Vred-RABAT_IZN)*(1- nvl(Kasa,0)/100)+ akciza_iznos + PDV_IZNOS + taksa_iznos za_kupca
		from
		(
			Select
			       d.vrsta_dok,
			       d.status,
			       d.broj_dok, D.ORG_DEO , D.BROJ_DOK1,
			       d.Godina,d.datum_dok,
			       d.PPartner, pp.naziv prt_naziv,
			       d.tip_dok, nf.naziv tip_naziv,
			       sd.proizvod,p.naziv pro_naziv,
			       p.Jed_mere,
			       nvl(sd.Valuta,'YUD') val,
			       sd.cena,
--			       Sum(Round(NVL((-1)*sd.K_Robe*sd.Kolicina,0),2)) 															kol,
--			       sd.rabat,
--			       sd.Porez,
--			       Sum(Round(NVL((-1)*sd.K_Robe*sd.Kolicina*sd.Cena,0),2)) 													vred,
--
--			       Sum(Round(NVL((-1)*sd.K_Robe*sd.Kolicina*sd.Cena*sd.Rabat/100,0),2)) 										rabat_izn,
--			       Sum(Round(NVL((-1)*sd.K_Robe*sd.Kolicina*sd.Cena*(1-sd.Rabat/100)*
--			           Decode( d.Tip_Kase, 'A', d.Kasa, 0 )/100,0),2)) 															kasa,
--			       Sum(NVL((-1)*sd.K_Robe*sign(sd.Kolicina)*sd.Akciza,0))														akciza_iznos,
--			       Sum(Round(NVL((-1)*sd.K_Robe*(sd.Kolicina*sd.Cena*(1-sd.Rabat/100-
--			           Decode(d.Tip_Kase,'A',d.Kasa,0)/100)+sign(sd.Kolicina)*NVL( sd.Akciza, 0))*sd.Porez/100,0),2)) 			pdv_iznos,
--			       Sum(NVL((-1)*sd.K_Robe*sd.Taksa,0))																		    taksa_iznos


			       Sum(Round(NVL(sd.K_Robe*sd.Kolicina,0),2)) 															kol,
			       sd.rabat,
			       sd.Porez,
			       Sum(Round(NVL(sd.K_Robe*sd.Kolicina*sd.Cena,0),2)) 													vred,

			       Sum(Round(NVL(sd.K_Robe*sd.Kolicina*sd.Cena*sd.Rabat/100,0),2)) 										rabat_izn,
			       Sum(Round(NVL(sd.K_Robe*sd.Kolicina*sd.Cena*(1-sd.Rabat/100)*
			           Decode( d.Tip_Kase, 'A', d.Kasa, 0 )/100,0),2)) 															kasa,
			       Sum(NVL(sd.K_Robe*sign(sd.Kolicina)*sd.Akciza,0))														akciza_iznos,
			       Sum(Round(NVL(sd.K_Robe*(sd.Kolicina*sd.Cena*(1-sd.Rabat/100-
			           Decode(d.Tip_Kase,'A',d.Kasa,0)/100)+sign(sd.Kolicina)*NVL( sd.Akciza, 0))*sd.Porez/100,0),2)) 			pdv_iznos,
			       Sum(NVL(sd.K_Robe*sd.Taksa,0))																		    taksa_iznos


			From Dokument d, Stavka_Dok sd, Poslovni_Partner pp, Proizvod p, nacin_fakt nf
			Where d.Status > 0 And d.org_Deo = &vZa_Magacin
		      and (k_robe <> 0 or d.vrsta_Dok = 80)and d.Org_deo not in ( select magacin from Partner_magacin_flag) and
			      sd.Vrsta_Dok = d.Vrsta_Dok And sd.Broj_Dok = d.Broj_Dok And sd.Godina = d.Godina And
			      pp.Sifra = d.Ppartner and p.Sifra = sd.Proizvod and nf.tip=d.tip_dok and d.godina = 2011

			Group by
			         d.vrsta_dok,
			         d.status,
			         nvl(sd.Valuta,'YUD'),
			         sd.cena,
			         d.broj_dok, D.ORG_DEO , D.BROJ_DOK1,
			         d.Godina,d.datum_dok,
		             d.PPartner, pp.Naziv,
			         d.tip_dok,nf.naziv,
			         sd.proizvod,p.naziv,
			         p.Jed_mere, sd.rabat, sd.Porez
		)
		)
		group by broj_dok, vrsta_Dok, godina, org_Deo, broj_dok1

 )izn

where dd.broj_dok  = izn.broj_dok (+) and dd.vrsta_dok = izn.vrsta_dok (+) and dd.god_dok    = izn.godina (+)

order by dd.org_deo,dd.datum_dok,dd.datum_unosa
)
--where zad_kepu = 1968 or razd_kepu = 1968

--where vrsta_Dok='90'
