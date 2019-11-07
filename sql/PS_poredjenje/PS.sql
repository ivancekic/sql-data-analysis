select sum(nvl(VRED_2009,0)), sum(nvl(PS_2010,0))
from
(
select sd.proizvod
    , sum(kolicina*faktor*k_robe*cena1) vred_2009
    , (Select sum(kolicina*faktor*k_robe*cena1) vred
       From stavka_dok sd1, dokument d1
       Where sd1.godina    (+)= d1.godina and sd1.vrsta_dok (+)= d1.vrsta_dok and sd1.broj_dok  (+)= d1.broj_dok
         and d1.org_deo = 110
         and d1.godina = 2010
         and k_robe <> 0
         and d1.vrsta_dok = 21
         and d1.status > 0
         and sd1.proizvod = sd.proizvod
      ) ps_2010
from stavka_dok sd, dokument d
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  and d.org_deo = 110
  and d.godina = 2009
  and k_robe <> 0
  and d.status > 0
--  and d.datum_dok >= to_date('01.01.2010','dd.mm.yyyy')
--  and d.datum_unosa < to_date('01.01.2010','dd.mm.yyyy')
Group by sd.proizvod
)
--where  nvl(VRED_2009,0) <> nvl(PS_2010,0)
Order by to_number(proizvod)
