Select d.status, cena, cena1,sd.rabat,z_troskovi
from stavka_dok sd, dokument d
WHERE sd.BROJ_DOK   = 6418 AND  sd.VRSTA_DOK = 3 AND  sd.GODINA = 2009
  and sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
