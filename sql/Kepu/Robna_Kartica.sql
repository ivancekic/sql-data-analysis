Select TO_CHAR(DATUM_DOK,'DD.MM.YYYY') DATUM, Datum_Unosa, D.VRSTA_DOK VRD, D.BROJ_DOK BRD, D.BROJ_DOK1 BRD1,
--       NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor
--                            * case when D.vrsta_dok = '90' then 0
--                              else K_ROBE
--                              end
--                     ,0) STANJE,
       SUM(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor*
                       (CASE WHEN D.VRSTA_DOK = '80' THEN (SD.CENA1-SD.CENA)
                             WHEN D.vrsta_dok  ='90' Then
                             ROUND((NVL(SD.cena,0)-NVL(SD.cena1,0)),2)
                        ELSE K_ROBE*( CASE WHEN D.VRSTA_DOK = 11 AND UPPER(OD.DODATNI_TIP) = 'VP2' THEN SD.CENA1
                                      ELSE SD.CENA1
                                      END
                                    )
                        END)
           ,0)) VREDNOST
--,              sum(NVL(round(nvl(sign(SD.K_ROBE)*SD.KOLICINA*SD.FAKTOR*SD.K_ROBE*SD.cena1
--                   *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,SD.K_ROBE,'D',d.datum_dok),0),2),0)*
--                   (case when UPPER(OD.dodatni_tip) = 'VP' AND D.VRSTA_DOK='90' THEN 0
--                    ELSE 1
--                    END
--                   )
--                   + case when d.vrsta_dok in (80) then ROUND(SD.kolicina*(NVL(SD.cena1,0)-NVL(SD.cena,0)),2)
--                          WHEN d.vrsta_dok in (90) then
--                               case when UPPER(OD.dodatni_tip) = 'VP' AND D.VRSTA_DOK='90' THEN 1
--                               ELSE 1
--                               END
--                               *
--                               ROUND(SD.kolicina*(NVL(SD.cena,0)-NVL(SD.cena1,0)),2)
--                          else 0
--                     end
--                   ) zaduzenje
From stavka_dok sd, dokument d, org_deo_osn_podaci od
Where sd.godina (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok (+)= d.broj_dok
 -----------------------------
  -- ostali uslovi
  and d.godina = 2009
  and d.org_deo = 160
  AND (K_ROBE <> 0 OR D.VRSTA_DOK IN (80,90))
  and d.org_deo = od.org_deo
  AND PROIZVOD = 6845
GROUP BY DATUM_DOK, Datum_Unosa, D.VRSTA_DOK, D.BROJ_DOK, D.BROJ_DOK1
Order By  To_Number( Proizvod ) , Datum_Dok, Datum_Unosa;
