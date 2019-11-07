select sd.Proizvod,
       D.Datum_Dok, D.Datum_Unosa,
       D.Vrsta_Dok, D.Broj_Dok, D.Godina,
       D.Tip_Dok,
       PPlanskiCenovnik.Cena(sd.Proizvod,
                             D.Datum_Dok,'YUD',1) PCena,
       K_Robe, ( Sum ( Kolicina * Faktor ) ) Kolicina

from stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR
--from   dokument d , stavka_dok sd , PROIZVOD P , GRUPA_PR  GPR
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
 -----------------------------
  AND D.Status > 0
  And D.Datum_Dok Between TO_DATE('01.01.2009','DD.MM.YYYY') And SYSDATE
  And D.Org_Deo = 2013
  And SD.K_Robe != 0
  -- And SD.Proizvod Like NVL( cProizvod, '%' )
  Group By SD.Proizvod,
           D.Datum_Dok, D.Datum_Unosa,
           D.Vrsta_Dok, D.Broj_Dok, D.Godina,
           D.Tip_Dok, Cena, K_Robe
  Order By SD.Proizvod,
           D.Datum_Dok, D.Datum_Unosa,
           D.Vrsta_Dok, D.Broj_Dok, D.Godina,
           D.Tip_Dok, Cena, K_Robe;
