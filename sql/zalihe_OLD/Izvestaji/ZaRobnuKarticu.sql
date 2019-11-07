select sd.rowid, d.godina, d.vrsta_dok, d.broj_dok,d.broj_dok1,
       d.datum_dok, sd.kolicina, sd.cena, sd.rabat, sd.cena1
from stavka_dok sd , dokument d
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  -- ostali uslovi
  and d.godina = 2008
  and d.org_deo = 22
  and proizvod in (160525)
  and k_robe <> 0
ORDER BY datum_dok, to_number(sd.vrsta_Dok),to_number(sd.broj_dok)

