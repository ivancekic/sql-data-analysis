select sum(zaduzenje - razduzenje) stanje
from(
        select dodatni_tip,broj_dok,god_dok,vrsta_dok,
               --------------------------------------------------------------------------------------------
               TRUNC((MOD(ROWNUM-1,&BrRedNaStranici)-ROWNUM)*(-1)/&BrRedNaStranici,0)+1 STRANICA,
               --------------------------------------------------------------------------------------------
               ROWNUM RedBrStavke,
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
               sum(NVL(
	                        round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*ST.K_ROBE*st.cena1 *
	                                  PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'D',d.datum_dok)
	                                 ,0)
	                              ,
	                              DECODE(D.PPARTNER, '206',2
	                                               , '172',2
	                                               , 4
	                                    )

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
	                              DECODE(D.PPARTNER, '206',2
	                                               , '172',2
	                                               , 4
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
                                      NVL(round(st.cena1*st.faktor,4),0)),2)
                        else
                           0
                   end
                   )                                                                                                                     ZADUZENJE,
               ----------------------------------------------------------------------------------------------------------------------------------------------
               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                    (Case When st.valuta <> 'YUD' Then
                         (
                           Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                               (
	                              DECODE(D.PPARTNER, '206',2
	                                               , '172',2
	                                               , 4
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
               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                    (Case When st.valuta <> 'YUD' Then
                         (
                           Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                               (
	                              DECODE(D.PPARTNER, '206',2
	                                               , '172',2
	                                               , 4
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
                         NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                       (Case When st.valuta <> 'YUD' Then
                                            (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
		                                                  (
								                              DECODE(D.PPARTNER, '206',2
								                                               , '172',2
								                                               , 4
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
								                              DECODE(D.PPARTNER, '206',2
								                                               , '172',2
								                                               , 4
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
						                              DECODE(D.PPARTNER, '206',2
						                                               , '172',2
						                                              , 4
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
                                          NVL(round(st.cena1*st.faktor,4),0)
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
							                              DECODE(D.PPARTNER, '206',2
							                                               , '172',2
							                                               , 4
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
						                              DECODE(D.PPARTNER, '206',2
						                                               , '172',2
						                                               , 4
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
                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                        (Case When st.valuta <> 'YUD' Then
                                            (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
							                              DECODE(D.PPARTNER, '206',2
							                                               , '172',2
							                                               , 4
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
          from dokument d,(
                            (
                            SELECT SD1.BROJ_DOK,SD1.VRSTA_DOK,SD1.GODINA,SD1.STAVKA,
                                   SD1.PROIZVOD,SD1.LOT_SERIJA,SD1.ROK,SD1.KOLICINA,SD1.JED_MERE,SD1.CENA,SD1.VALUTA,
                                   SD1.LOKACIJA,SD1.PAKOVANJE,SD1.BROJ_KOLETA,SD1.K_REZ,SD1.K_ROBE,SD1.K_OCEK,SD1.KONTROLA,SD1.FAKTOR,SD1.REALIZOVANO,SD1.RABAT,SD1.POREZ,
                                   SD1.KOLICINA_KONTROLNA,SD1.AKCIZA,SD1.TAKSA,
                                   SD1.CENA1,SD1.Z_TROSKOVI
                             FROM STAVKA_DOK sd1
                                , dokument d1
                             Where d1.broj_dok != '0' and d1.vrsta_Dok not in ('2','9','10') and d1.godina != 0
                               and d1.org_deo   like &vZa_Magacin
                               and d1.datum_dok between &DatumPocetnogStanja and &dDatumDo
                               and d1.godina = SD1.godina and d1.vrsta_dok = SD1.vrsta_dok and d1.broj_dok = SD1.broj_dok
                            )

                            UNION ALL
                           (
                            SELECT VDP.ZA_BROJ_DOK,VDP.ZA_VRSTA_DOK,VDP.ZA_GODINA,SD1.STAVKA,
                                   SD1.PROIZVOD,SD1.LOT_SERIJA,SD1.ROK,SD1.KOLICINA,SD1.JED_MERE,SD1.CENA,SD1.VALUTA,
                                   SD1.LOKACIJA,SD1.PAKOVANJE,SD1.BROJ_KOLETA,SD1.K_REZ,SD1.K_ROBE,SD1.K_OCEK,SD1.KONTROLA,SD1.FAKTOR,SD1.REALIZOVANO,SD1.RABAT,SD1.POREZ,
                                   SD1.KOLICINA_KONTROLNA,SD1.AKCIZA,SD1.TAKSA,
                                   SD1.CENA1,SD1.Z_TROSKOVI
                              FROM dokument d1, STAVKA_DOK SD1, VEZNI_DOK VDP
                             WHERE d1.broj_dok != '0' and d1.vrsta_Dok not in ('2','9','10') and d1.godina != 0
                               and d1.org_deo   like &vZa_Magacin
                               and d1.datum_dok between &DatumPocetnogStanja and &dDatumDo
                               AND D1.VRSTA_DOK = VDP.VRSTA_DOK AND D1.GODINA    = VDP.GODINA AND D1.BROJ_DOK  = VDP.BROJ_DOK
                               AND VDP.ZA_VRSTA_DOK = '90'
                               AND d1.godina = SD1.godina and d1.vrsta_dok = SD1.vrsta_dok and d1.broj_dok = SD1.broj_dok
--                               AND SD1.CENA<>SD1.CENA1
                               and sd1.cena <> round(sd1.cena1*sd1.faktor,4)
                            )
                           ) ST
                         , proizvod p, poslovni_partner pp, organizacioni_deo orgd, vrsta_dok vd, nacin_fakt nf, org_deo_osn_podaci org_podaci
         where d.vrsta_dok = st.vrsta_dok
           and d.godina    = st.godina
           and d.broj_dok  = st.broj_dok
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
--9535.1400
--9527.4033
--   7.7367
--4510,4539
and proizvod in(4510)
--				and proizvod not in (
---- '4510'
----,
---- '4539'
--
----				'4421','4422','4430','4431','4432','4433','4434','4441','4442','4449','4450','4452','4454','4455','4456'
----				                 '4457','4458','4459','4460','4461','4462','4463','4464','4465','4466','4467','4468','4469','4471','4472',
----				                 '4473','4474','4476','4483','4484','4485','4487','4488','4489','4490','4491','4492','4493','4494','4495',
----				                 '4496','4497','4499','4500','4501','4503','4506','4507','4508','4509','4510','4511','4512','4513','4514'
----				                 ,
----				                 '4515','4516','4518','4519','4520','4521','4522','4539','6021','6022','6978','6979','10778'
--)
--

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
