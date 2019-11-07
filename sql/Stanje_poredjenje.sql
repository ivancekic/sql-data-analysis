select d.org_deo, sd.proizvod, sum(sd.kolicina*sd.faktor*sd.k_robe),
       z.stanje
from stavka_dok sd , dokument d, zalihe z --, zalihe_analitike za
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  and z.org_deo  = d.org_deo  and z.proizvod = sd.proizvod
  and d.godina = 2008 and k_robe <> 0 and status > 0
Group by d.org_deo, sd.proizvod, z.stanje
Having sum(sd.kolicina*sd.faktor*sd.k_robe) <> z.stanje
ORDER BY d.org_deo, to_char(sd.proizvod)

