select d.org_deo, d.vrsta_dok, d.broj_dok, d.status,d.datum_dok, d.ppartner, pposlovnipartner.naziv(d.ppartner) naziv,
       sd.proizvod, pproizvod.naziv(sd.proizvod) naziv, sd.kolicina, sd.realizovano
from dokument d,stavka_dok sd
where d.godina=to_char(sysdate,'YYYY')
  and d.status in ('1','3')
  and d.vrsta_dok in ('9','10')
  and
     (
        ( d.org_deo = 103 and sd.proizvod in (3322,3323,4111,4147))
      OR
        ( d.org_deo = 104 and sd.proizvod in (3193,3199,3200,4053,4088))
      )
  and sd.kolicina <> sd.realizovano
  and sd.vrsta_dok=d.vrsta_dok and sd.broj_dok=d.broj_dok and sd.godina=d.godina
order by d.org_deo, to_number(sd.proizvod)
