select k.zad KEPU_ZAD, k.razd KEPU_RAZD, k.stanje KEPU_STANJE
     , s.ST ZAL_STANJE, s.VRED ZAL_VRED, s.KONT ZAL_KONTROLA

     , k.stanje - s.VRED RAZL_KEPU_ZAL
from
(
	Select sum( ZADUZENJE ) zad
	     , sum( RAZDUZENJE ) razd
	     , sum( ZADUZENJE - RAZDUZENJE ) stanje
	from
	(
        select dodatni_tip,broj_dok,god_dok,vrsta_dok,
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
                         nvl(zaduzenje,0) + nvl(PDV_NA_ZADUZENJE,0)
                    else
                       0
               end zaduzenje,
               --------------------------------------------------------------------------------------------
               case when NVL(razduzenje,0) <> 0 then
                         nvl(razduzenje,0) + nvl(rabat,0) + nvl(PDV_RAZDUZENJE,0)
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
                                 Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                           round(nvl(st.cena,0) *
                                           Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                      Else
                                           round(nvl(st.cena,0) *
                                           Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                           Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                      End
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
                                      NVL(st.cena1*st.faktor,0)),2)
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
                                 Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                           round(nvl(st.cena,0) *
                                           Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                      Else
                                           round(nvl(st.cena,0) *
                                           Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                           Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                      End
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
                                 Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                           round(nvl(st.cena,0) *
                                           Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                      Else
                                           round(nvl(st.cena,0) *
                                           Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                           Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                      End
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
                                                    Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                                              round(nvl(st.cena,0) *
                                                              Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                                    Else
                                                              round(nvl(st.cena,0) *
                                                              Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                                              Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                                    End
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
                         NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                       (Case When st.valuta <> 'YUD' Then
                                            (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                  (
                                                    Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                                              round(nvl(st.cena,0) *
                                                              Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                                    Else
                                                              round(nvl(st.cena,0) *
                                                              Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                                              Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                                    End
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
                                                        (Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                                                    round(nvl(st.cena,0) *
                                                                    Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                                         Else
                                                                    round(nvl(st.cena,0) *
                                                                    Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                                                    Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                                         End
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
                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                        (Case When st.valuta <> 'YUD' Then
                                             (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                   (Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                                              round(nvl(st.cena,0) *
                                                              Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                                    Else
                                                              round(nvl(st.cena,0) *
                                                              Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                                              Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                                    End
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
                      sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
                                        (Case When st.valuta <> 'YUD' Then
                                            (Case When (upper(VratiTipIzvoza(d.org_deo)) = 'DA' or d.org_deo = 200) And D.Vrsta_Dok = 73 Then
                                                  (Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                                             round(nvl(st.cena,0) *
                                                             Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                                   Else
                                                             round(nvl(st.cena,0) *
                                                             Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                                             Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                                   End
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
                                                  (Case When Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner) = -2 Then
                                                             round(nvl(st.cena,0) *
                                                             Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),4)
                                                   Else
                                                             round(nvl(st.cena,0) *
                                                             Pkurs.KursNaDan(valuta, d.Datum_dok, 'S'),
                                                             Pmapiranje.BrojDecimalaNaseFirme(PMapiranje.VLASNIK_CONN_STR,D.vrsta_dok,D.PPartner))
                                                   End
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
                               AND STP.CENA<>STP.CENA1) ST
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
           and d.org_deo   = &vZa_Magacin
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
	)
) k
,
(
	select sum(STANJE) st
	     , sum(VREDNOST) vred
	     , sum(U_KONTROLI) kont
	from
	(
	         Select Stavka_dok.Proizvod, Proizvod.posebna_grupa,
	                round(Sum(NVL(decode(dokument.tip_dok,14,Kolicina,realizovano)*Faktor

	                                * case when dokument.vrsta_dok = '90' then
	                                         0
	                                       else
	                                         K_ROBE
	                                  end

	                                ,0)),5) STANJE,

	                round(Sum(NVL(decode(dokument.tip_dok,14,Kolicina,realizovano)*Faktor*
	                   (CASE WHEN DOKUMENT.VRSTA_DOK = '80' THEN
	                         (STAVKA_DOK.CENA1-STAVKA_DOK.CENA)
	                        WHEN dokument.vrsta_dok  ='90' then
	                             ROUND((NVL(stavka_dok.cena,0)-NVL(stavka_dok.cena1,0)),2)
	                    ELSE K_ROBE*(
	                                     CASE WHEN DOKUMENT.VRSTA_DOK = 11 AND UPPER(ORGD.DODATNI_TIP) = 'VP2' THEN
	                                             STAVKA_DOK.CENA1
	                                          ELSE
	                                             STAVKA_DOK.CENA1
	                                     END
	                                 )
	                END),0)),2) VREDNOST

	               , (select sum(kolicina*faktor)
	                   from dokument dx, stavka_dok stx
	                  where dx.vrsta_dok = stx.vrsta_dok and dx.broj_dok = stx.broj_dok and dx.godina = stx.godina
	                    and dx.vrsta_dok = 3
	                    and dx.tip_dok   = 10
	                    and dx.status in ('-8','-9') and dx.godina > 2008
	                    and stx.proizvod = stavka_dok.proizvod)
	                  u_kontroli

	               From Dokument,
	                    (SELECT  BROJ_DOK,
	                             VRSTA_DOK,
	                             GODINA,
	                             STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI
	                       FROM STAVKA_DOK
	                    ) Stavka_Dok,
	                    Proizvod,
	                    ORG_DEO_OSN_PODACI ORGD

	         Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And
	               Dokument.Broj_Dok = Stavka_Dok.Broj_Dok And
	               Dokument.Godina = Stavka_Dok.Godina And
	               DOKUMENT.ORG_DEO = ORGD.ORG_DEO (+) AND
	               Dokument.Status > 0 And
	               dokument.datum_dok between  &DatumPocetnogStanja and &dDatumDo and

	               (Stavka_Dok.K_Robe != 0 OR DOKUMENT.VRSTA_DOK = '80') And
	               Dokument.Org_Deo = &vZa_Magacin And Proizvod.sifra=Stavka_dok.proizvod
	           and dokument.vrsta_dok not in (2,9,10,61,62)
	           and proizvod.tip_proizvoda not in (8)
	         Group By Stavka_dok.Proizvod,Proizvod.tip_proizvoda,Proizvod.posebna_grupa,Proizvod.grupa_proizvoda,Proizvod.naziv
	         Order By Proizvod.posebna_grupa,Stavka_dok.proizvod
	)

) s
