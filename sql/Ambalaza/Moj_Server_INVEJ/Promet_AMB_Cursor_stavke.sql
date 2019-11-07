
select SD.Proizvod Sifra, P.Naziv,
                ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz,
                ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz,
                ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje,
                P.Jed_Mere JedMere
from stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR
--from   dokument d , stavka_dok sd , PROIZVOD P , GRUPA_PR  GPR
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
 -----------------------------
 -- bez tipova 13 i 14
 and d.Tip_Dok In ( 15, 203, 204, 99, 301, 401, 402, 61, 60 ) 
 and d.Org_Deo In (Select Magacin
                          From Partner_magacin_Flag, Poslovni_Partner
                          Where PPartner = 11)
--                           And
--                                Teren = nSifraTerena And PPartner Like '%') And
  AND D.Status > 0
  And D.Datum_Dok Between TO_DATE('01.01.2009','DD.MM.YYYY') And SYSDATE
--  And D.Org_Deo = 2013
  And SD.K_Robe != 0
  -- And SD.Proizvod Like NVL( cProizvod, '%' )
Group By SD.Proizvod, P.Naziv, P.Jed_Mere
         Order By P.Naziv;
