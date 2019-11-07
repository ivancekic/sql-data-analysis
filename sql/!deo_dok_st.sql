select
--pposlovnipartner.naziv(ppartner),
d.status, d.datum_dok, d.godina, d.vrsta_dok, d.tip_dok, ppartner, d.broj_dok, d.broj_dok1, sd.proizvod, sd.cena, sd.valuta, sd.kolicina,
sd.k_robe, sd.realizovano, sd.rabat, sd.faktor, sd.cena1
,OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov

from   stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
 -----------------------------
  -- ostali uslovi
  and d.godina = 2008 and k_robe <> 0  and d.status > 0
  --and d.org_deo = 48
  and proizvod in (20436)
--  and d.broj_dok = 8824 and d.vrsta_dok = 10
--  and kolicina <> realizovano
ORDER BY datum_dok, to_number(d.vrsta_dok), to_number(d.broj_dok)--, stavka--TO_NUMBER(PROIZVOD)

