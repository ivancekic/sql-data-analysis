select d.org_deo, porganizacionideo.naziv(d.org_deo) naziv, sd.proizvod, sum(sd.kolicina * K_Robe * faktor) stanje_stavka, z.stanje
from stavka_dok sd, dokument d, zalihe z
where d.GODINA = 2008
  and d.status > 0
  and ( k_robe <> 0 or d.tip_dok = 14 )
--  and d.org_Deo = 970
  and sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok  = d.broj_dok
  and z.org_deo = d.org_deo and z.proizvod = sd.proizvod
Group by d.org_deo, sd.proizvod, z.stanje
Having sum(sd.kolicina * K_Robe * faktor) <> z.stanje
order by d.org_deo, to_number(sd.proizvod)
