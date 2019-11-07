select d2.mesto_isporuke
from vezni_dok vd, vezni_dok vd1,vezni_dok vd2, dokument d2
Where vd.godina = 2009
  and vd.vrsta_dok  = 4
  and vd.broj_dok   = '14'
--  and d.org_deo in (select magacin from partner_magacin_flag)
  and vd.za_vrsta_dok = 3
--  and vd.godina = d.godina and vd.vrsta_dok = d.vrsta_dok and vd.broj_dok = d.broj_dok
  and vd1.za_vrsta_dok = 11
  and vd.za_godina = vd1.godina and vd.za_vrsta_dok = vd1.vrsta_dok and vd.za_broj_dok = vd1.broj_dok
  and vd2.za_vrsta_dok = 12
  and vd2.godina = vd1.za_godina and vd2.vrsta_dok = vd1.za_vrsta_dok and vd2.broj_dok = vd1.za_broj_dok
  and d2.godina = vd2.za_godina and d2.vrsta_dok = vd2.za_vrsta_dok and d2.broj_dok = vd2.za_broj_dok

