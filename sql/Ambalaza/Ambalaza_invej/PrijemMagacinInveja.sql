select d.org_deo, porganizacionideo.naziv(d.org_deo) mag_naziv,
       sd.proizvod, sum(sd.kolicina*k_robe) , 1 ul_izl
from stavka_dok sd , dokument d
Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  -- ostali uslovi
  -- prijemnice ambalaze
  and d.godina = 2008  and d.vrsta_dok in(3,4,5,30)  and d.tip_dok   = 10  and sd.proizvod in (399)
  --and d.datum_dok >= to_date('01.04.2008','dd.mm.yyyy')
  and d.datum_dok <= to_date('31.03.2008','dd.mm.yyyy')


Group by d.org_deo ,sd.proizvod

union

select d.org_deo, porganizacionideo.naziv(d.org_deo) mag_naziv,
       sd.proizvod, sum(sd.kolicina*k_robe),-1 ul_izl
from stavka_dok sd , dokument d
Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  -- ostali uslovi
  -- otpremnice ambalaze
  and d.godina = 2008  and d.vrsta_dok in (61,62) and sd.proizvod in (399)
--  and d.datum_dok >= to_date('01.04.2008','dd.mm.yyyy')
  and d.datum_dok <= to_date('31.03.2008','dd.mm.yyyy')
Group by d.org_deo ,sd.proizvod

