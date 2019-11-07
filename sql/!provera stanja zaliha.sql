select d.org_deo, porganizacionideo.naziv(d.org_deo) naziv, sd.proizvod, Sum(kolicina*faktor*k_robe) sum_kol, z.stanje, z.rezervisana
from stavka_dok sd, dokument d, zalihe z
Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  and d.godina = 2009 and d.org_deo not in (select magacin from partner_magacin_flag)
  and k_robe <> 0 and d.status > 0
  and d.org_deo = z.org_deo and sd.proizvod = z.proizvod
Group by d.org_deo, sd.proizvod, z.stanje, z.rezervisana
Having
    (    ( Sum(kolicina*faktor*k_robe) <> z.stanje )
      or ( z.stanje < z.rezervisana )
      or z.stanje < 0
    )
Order by d.org_deo, to_number (sd.proizvod)

