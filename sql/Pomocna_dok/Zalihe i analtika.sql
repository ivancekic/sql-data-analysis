---- za zalihe
--select d.ORG_DEO, PROIZVOD, 1 MIN_KOL, 999 MAX_KOL, 1 KOL_NAR, 0 STANJE
--   	, 0 REZERVISANA, 0 U_KONTROLI, 0 OCEKIVANA, 0 STANJE_KONTROLNA
--from stavka_dok sd , dokument d
--Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
--  and d.godina = 2009 and d.vrsta_dok  = 13 and d.broj_dok = 180
--  and sd.proizvod not in (Select z.proizvod from zalihe z where z.org_deo = d.ORG_DEO and z.proizvod = sd.proizvod)


-- za zalihe_nalitika
select ORG_DEO, PROIZVOD, SD.LOKACIJA, SD.LOT_SERIJA, SD.ROK, 0, SD.KOLICINA_KONTROLNA
from stavka_dok sd , dokument d
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  and d.godina = 2009 and d.vrsta_dok  = 13 and d.broj_dok = 180
  and sd.proizvod not in (Select z.proizvod from zalihe_ANALITIKA z where z.org_deo = d.ORG_DEO and z.proizvod = sd.proizvod)
