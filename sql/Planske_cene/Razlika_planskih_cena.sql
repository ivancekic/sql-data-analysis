select sd.rowid,d.status,
D.vrsta_Dok vrd, d.broj_dok brd, d.datum_dok, d.org_Deo mag, d.broj_dok1 brd1, d.tip_dok tip,
       sd.proizvod pro, sd.cena, sd.valuta, sd.kolicina, sd.realizovano re, sd.k_robe,sd.faktor, sd.cena1,
--sd.*,
OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, decode(sd.valuta,'EUR','YUD','YUD'),0) odgov
--       ,
--       (Select Cena
--         From Planski_Cenovnik
--         Where Proizvod = sd.Proizvod AND
--               Valuta = sd.valuta AND
--               Datum = ( Select max( C1.Datum )
--                         From Planski_Cenovnik C1
--                         Where C1.Proizvod = sd.Proizvod AND
--                               C1.Valuta = sd.valuta AND
--                               C1.Datum <= d.datum_dok )
--         )  planska
from stavka_dok sd ,  dokument d ,PROIZVOD P , GRUPA_PR  GPR
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
 -----------------------------
  -- ostali uslovi
  and d.godina = 2008
  and p.tip_proizvoda = 8
  and OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, decode(sd.valuta,'EUR','YUD','YUD'),0)  <> sd.cena1
  and sd.k_robe != 0
--  and cena1 is not null
--  and sd.proizvod != 257
--  and d.org_deo != 90


ORDER BY TO_NUMBER(PROIZVOD), d.org_deo, d.godina, d.datum_dok, d.vrsta_dok, d.broj_dok

