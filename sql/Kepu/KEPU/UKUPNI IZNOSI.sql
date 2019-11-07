Select
        Case when NVL(zaduzenje,0) + NVL(rabat,0) <> 0 then
                  nvl(zaduzenje,0) + nvl(rabat,0)
        Else
             0
        End ZADUZENJE
     ,  Case when NVL(razduzenje,0) <> 0 then
                  nvl(razduzenje,0)+nvl(rabat,0)
        Else
             0
        End RAZDUZENJE
From
(
	SELECT
	               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*ST.K_ROBE*st.cena1 *
	                                 PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'D',d.datum_dok),0)
	                                 ,2),0)*
	                   (case when UPPER(ORG_PODACI.dodatni_tip) = 'VP' AND D.VRSTA_DOK='90' THEN
	                               0
	                         ELSE
	                               1
	                    END)
	                            +
	                    case when d.vrsta_dok in (80) then
	                              ROUND(st.kolicina*(NVL(st.cena1,0)-NVL(st.cena,0)),2)
	                         WHEN d.vrsta_dok in (90) then
	                              case when UPPER(ORG_PODACI.dodatni_tip) = 'VP' AND D.VRSTA_DOK='90' THEN
	                                        nvl((select case when vd3.za_vrsta_dok is null then -1 else 1 end
	                     										       from vezni_dok vd3
											                          where vd3.vrsta_dok = d.vrsta_dok
											                            and vd3.godina    = d.godina
											                            and vd3.broj_dok  = d.broj_dok
											                            and vd3.za_vrsta_dok = 11),-1)
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
	                                      NVL(st.cena1,0)),2)
	                        else
	                           0
	                   end
	                   )                                                                                                                     ZADUZENJE,
	               ------------------------------------------------------------------------------------------------------------------------------------
	               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
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
	                   *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,st.K_ROBE,'P',d.datum_dok)*(-1),0),2) ,0 ))                                RABAT,
	               ------------------------------------------------------------------------------------------------------------------------------------
	               sum(NVL(round(nvl(sign(ST.K_ROBE)*ST.KOLICINA*ST.FAKTOR*DECODE(ST.VRSTA_DOK,'90',0,ST.K_ROBE)*
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
	                   )                                                                                                                     RAZDUZENJE

	FROM DOKUMENT D, STAVKA_DOK ST, ORG_DEO_OSN_PODACI ORG_PODACI
	WHERE d.godina = ST.godina and d.vrsta_dok = ST.vrsta_dok and d.broj_dok = ST.broj_dok
	  AND D.ORG_DEO = ORG_PODACI.ORG_DEO
	  AND D.ORG_DEO = 160
	--  AND D.GODINA  = 2010
	  AND D.DATUM_DOK BETWEEN to_date('01.01.2010','dd.mm.yyyy') AND to_date('31.05.2010','dd.mm.yyyy')
)
