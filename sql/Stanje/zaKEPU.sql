Select d.godina, d.vrsta_dok vr,d.broj_dok brd, d.tip_dok, d.datum_dok, d.datum_unosa, d.broj_dok1 brd1,
       SD.Proizvod, sd.cena, sd.rabat, sd.cena1,
       NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor
                       * case when D.vrsta_dok = '90' then
                                0
                         else
                                K_ROBE
                         end
           ,0) STANJE,
       NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor*
          (CASE WHEN D.VRSTA_DOK = '80' THEN
                (SD.CENA1-SD.CENA)
               WHEN D.vrsta_dok  ='90' then
                             ROUND((NVL(SD.cena,0)-NVL(SD.cena1,0)),4)
           ELSE K_ROBE*(
                           CASE WHEN D.VRSTA_DOK = 11 AND UPPER(ORGD.DODATNI_TIP) = 'VP2' THEN
                                     SD.CENA1
                           ELSE
                                     SD.CENA1
                           END
                        )
          END),0) VREDNOST
      From Dokument d,
           (SELECT BROJ_DOK,VRSTA_DOK,GODINA,STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,
                   PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI
            FROM STAVKA_DOK
           ) SD, Proizvod P, ORG_DEO_OSN_PODACI ORGD
Where D.Vrsta_Dok = SD.Vrsta_Dok And D.Broj_Dok = SD.Broj_Dok And D.Godina = SD.Godina And D.ORG_DEO = ORGD.ORG_DEO (+)
  AND D.Status > 0 And D.Datum_Dok Between (SELECT MAX(DATUM_DOK) FROM DOKUMENT WHERE GODINA = 2009 and org_deo = 502 and vrsta_Dok = 21) And SYSDATE
  And (SD.K_Robe != 0 OR D.VRSTA_DOK = '80')
  And D.Org_Deo = 103 And P.sifra = SD.proizvod
--  and sd.proizvod not in (1612,1614,1638,1639,2684,3288)
--  and sd.proizvod = 3289
  and (sd.cena*faktor<>sd.cena1 and D.VRSTA_DOK <> '80')
Order By sd.proizvod,
         to_date(to_char(Datum_Dok,'dd.mm.yyyy')||' '||to_char(Datum_Unosa,'hh24:mi:ss'),'dd.mm.yyyy hh24:mi:ss'),
         d.godina, d.vrsta_dok,d.broj_dok
