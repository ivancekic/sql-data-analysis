Select
       sd.Proizvod, D.Tip_Dok,TO_CHAR(DATUM_DOK,'DD.MM.YYYY') DATUM,
       SD.Vrsta_Dok, SD.Broj_Dok,sd.Kolicina, SD.cena,SD.Cena1, sd.Faktor,K_Robe
       sd.

--       SD.Godina, D.Broj_Dok1
--       , Datum_Unosa, sd.Realizovano, sd.Kontrola, sd.Kolicina_Kontrolna
From stavka_dok sd, dokument d
Where sd.godina (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok (+)= d.broj_dok
 -----------------------------
  -- ostali uslovi
  and d.godina = 2009
  and d.org_deo = 103
  AND (K_ROBE <> 0 OR D.VRSTA_DOK = 80)
  And D.Datum_Dok Between (SELECT MAX(d1.DATUM_DOK)
                           From stavka_dok sd1, dokument d1
                           Where sd1.godina (+)= d1.godina and sd1.vrsta_dok (+)= d1.vrsta_dok and sd1.broj_dok (+)= d1.broj_dok
                             and d1.godina = d.GODINA and d1.org_deo = d1.org_deo and d1.vrsta_Dok = 21 and sd1.proizvod = sd.proizvod
                          )
                          And SYSDATE
  And D.Status > 0
Order By  To_Number( Proizvod ) , Datum_Dok, Datum_Unosa;
