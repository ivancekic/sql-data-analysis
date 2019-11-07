-- OVAJ SELECT POKAZUJE REZERVACIJU PROIZVODA PO DOKUMENTU I KO JE I KADA PRAVIO DOKUMENT
select D.ORG_DEO , sd.proizvod, pproizvod.naziv(sd.proizvod) naziv_proizvoda,
sum ( sd.kolicina * sd.faktor - sd.realizovano * sd.faktor ) rezervisano_DOK ,
Z.REZERVISANA REZERVISANO_ZAL
from dokument d, stavka_dok sd , ZALIHE Z
where d.godina    = to_char(sysdate,'YYYY')
  and d.status    in ('1','3')
  and d.vrsta_dok in ('9','10')
--  and d.org_deo   = 48
--  and sd.proizvod =17927
--  and sd.proizvod  IN (SELECT DISTINCT PROIZVOD
--                       FROM STAVKA_DOK
--                       WHERE GODINA    = 2007
--                         AND VRSTA_DOK = 10
--                         AND BROJ_DOK  = 115
--                         )
  and sd.vrsta_dok = d.vrsta_dok
  and sd.broj_dok  = d.broj_dok
  and sd.godina    = d.godina
  AND Z.ORG_DEO    = D.ORG_DEO
  AND Z.PROIZVOD   = SD.PROIZVOD

Having sum ( sd.kolicina * sd.faktor - sd.realizovano * sd.faktor ) <> Z.REZERVISANA
Group by D.ORG_DEO, sd.proizvod , Z.REZERVISANA
ORDER BY D.ORG_DEO, TO_NUMBER(PROIZVOD)
