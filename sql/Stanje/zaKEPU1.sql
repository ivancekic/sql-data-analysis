Select SD.Proizvod, sd.cena, count (*)
      From Dokument d,
           (SELECT BROJ_DOK,VRSTA_DOK,GODINA,STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,
                   PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI
            FROM STAVKA_DOK
           ) SD, Proizvod P, ORG_DEO_OSN_PODACI ORGD
Where D.Vrsta_Dok = SD.Vrsta_Dok And D.Broj_Dok = SD.Broj_Dok And D.Godina = SD.Godina And D.ORG_DEO = ORGD.ORG_DEO (+)
  AND D.Status > 0 And D.Datum_Dok Between (SELECT MAX(DATUM_DOK) FROM DOKUMENT WHERE GODINA = 2009 and org_deo = 502 and vrsta_Dok = 21) And SYSDATE
  And (SD.K_Robe != 0 OR D.VRSTA_DOK = '80')
  And D.Org_Deo = 103 And P.sifra = SD.proizvod
  and sd.proizvod not in (1612,1614,1638,1639,2684,3288)

Group By sd.proizvod, sd.cena
Order By to_number(sd.proizvod), sd.cena
