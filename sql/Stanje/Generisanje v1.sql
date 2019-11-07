select
d.org_deo, sd.proizvod
     , sum(kolicina*faktor*k_robe)   stanje_dok
     , z.STANJE, z.REZERVISANA


from dokument d, stavka_Dok sd
   , zalihe z

where
      d.status > 0
  and d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok (+)
  and sd.k_robe <> 0
  and z.org_deo = d.org_deo
  and z.proizvod = sd.proizvod
Group by d.org_deo, sd.proizvod
     , z.STANJE, z.REZERVISANA
Having sum(kolicina*faktor*k_robe)   <> z.stanje
order by D.org_deo, sd.proizvod
