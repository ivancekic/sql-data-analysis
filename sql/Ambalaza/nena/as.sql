--DELETE FROM STAVKA_DOK
--WHERE VRSTA_DOK = 21
--AND (GODINA,BROJ_DOK)
--    IN ( Select GODINA,BROJ_DOK from dokument Where Vrsta_dok = 21 and ORG_DEO In (Select Magacin From Partner_magacin_Flag) )
--/
--DELETE FROM dokument
--Where Vrsta_dok = 21
--  and ORG_DEO In (Select Magacin From Partner_magacin_Flag)
--/
--commit
--/
Select d.godina, min(datum_dok), max(datum_dok), min(datum_unosa),max(datum_unosa), count(*)--D.ROWID, D.USER_ID, D.org_deo,d.ppartner,SD.proizvod,sd.kolicina,faktor,k_robe, psa.*
from  dokument d, stavka_dok sd
   --, ps_ambalaze psa
where
--d.godina = 2009
--  and
d.vrsta_dok = 21
  and d.org_deo in (select magacin from partner_magacin_flag)
  and sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
-- and d.godina = psa.godina and d.ppartner = psa.partner and sd.proizvod = psa.proizvod

group by d.godina
order by d.godina
