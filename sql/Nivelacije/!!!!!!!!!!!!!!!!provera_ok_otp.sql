select sd.rowid, d.godina, d.broj_dok, d.vrsta_dok
     , sd.proizvod, sd.cena, sd.kolicina, sd.rabat, sd.porez, sd.cena1
from stavka_dok sd, dokument d
Where sd.godina    (+)= d.godina
  and sd.vrsta_dok (+)= d.vrsta_dok
  and sd.broj_dok  (+)= d.broj_dok
  and d.godina = 2011
  and d.vrsta_Dok = 11
  and sd.cena <> sd.cena1
  and d.org_Deo in (select org_Deo from ORG_DEO_OSN_PODACI where substr(DODATNI_TIP,1,2) ='VP')
  and (d.godina , d.vrsta_Dok, d.broj_dok )
       not in (Select godina , vrsta_Dok, broj_dok from vezni_Dok where za_vrsta_dok = 90)
