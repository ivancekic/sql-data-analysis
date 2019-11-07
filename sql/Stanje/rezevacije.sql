--SELECT DISTINCT ORG_dEO
--FROM
--(
select d.org_deo, sd.proizvod, sum (sd.kolicina *sd.faktor -sd.realizovano *sd.faktor ),
       z.rezervisana
from dokument d,stavka_dok sd, zalihe z
where d.godina=to_char(sysdate,'YYYY')
  and d.status in ('1','3')
  and d.vrsta_dok in ('9','10')
  and z.org_Deo = d.org_deo and z.proizvod = sd.proizvod
  and sd.vrsta_dok=d.vrsta_dok and sd.broj_dok=d.broj_dok and sd.godina=d.godina
Group by d.org_deo, sd.proizvod, z.rezervisana
Having sum (sd.kolicina *sd.faktor -sd.realizovano *sd.faktor ) <> z.rezervisana

order by d.org_deo, to_number(sd.proizvod)
--)
