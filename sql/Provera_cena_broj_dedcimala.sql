select
sD.ROWID , --pjedmere.naziv(sd.proizvod) jm,pproizvod.naziv(sd.proizvod) ,
D.*,
SD.*
from stavka_dok sd , dokument d
Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
 -----------------------------
  -- ostali uslovi
--  and d.godina = 2009
  and d.status > 1
  and length(sd.cena1-trunc(sd.cena1)) > 5

