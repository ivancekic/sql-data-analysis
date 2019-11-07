select * from
(
SELECT
       d.datum_dok, d.datum_unosa, d.user_id, D.TIP_DOK, d.status, d.DATUM_STORNA, d.org_deo, d.broj_dok1
     , sd.*
FROM
      dokument  d, (select * from vezni_dok where vrsta_dok = '13' and za_vrsta_dok='31') vd
    , stavka_dok sd
WHERE d.godina = 2013
  and d.VRSTA_DOK in ('13')
  and d.status = 4
--  and d.tip_dok = 40
  and d.godina = VD.godina (+) and d.broj_dok = VD.broj_dok (+) AND VD.VRSTA_DOK (+) = D.VRSTA_DOK
  and d.broj_dok='1187'
  and d.godina = sd.godina (+) and d.broj_dok = sd.broj_dok (+) AND sd.VRSTA_DOK (+) = D.VRSTA_DOK
union

SELECT
       d.datum_dok, d.datum_unosa, d.user_id, D.TIP_DOK, d.status, d.DATUM_STORNA, d.org_deo, d.broj_dok1
     , sd.*
FROM
      dokument  d, (select * from vezni_dok where vrsta_dok = '31' and za_vrsta_dok='13') vd
    , stavka_dok sd
WHERE d.godina = 2013
  and d.VRSTA_DOK in ('31')
--  and d.status = 1
--  and d.tip_dok = 40
  and d.godina = VD.godina (+) and d.broj_dok = VD.broj_dok (+) AND VD.VRSTA_DOK (+) = D.VRSTA_DOK
  and d.godina = sd.godina (+) and d.broj_dok = sd.broj_dok (+) AND sd.VRSTA_DOK (+) = D.VRSTA_DOK

  and d.broj_dok='33'
)
order by proizvod, vrsta_dok
