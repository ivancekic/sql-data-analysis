Select count(*)
from dokument d, stavka_dok sd
where d.godina = 2010
  and d.vrsta_dok = 21
--  and d.org_deo in (select magacin from partner_magacin_flag)
  and sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok


