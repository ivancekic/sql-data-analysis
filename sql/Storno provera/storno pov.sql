SELECT
       D.VRSTA_DOK, D.BROJ_DOK, D.GODINA, d.datum_dok, D.TIP_DOK, d.status, d.DATUM_STORNA, d.org_deo, d.broj_dok1
--     , vd.*
     , sd.*
FROM
      dokument  d, (select * from vezni_dok where vrsta_dok = '31' and za_vrsta_dok='13') vd
    , stavka_dok sd
WHERE d.godina = 2013
  and d.VRSTA_DOK in (31)
--  and d.status = 1
  and d.tip_dok = 40
  and d.godina = VD.godina (+) and d.broj_dok = VD.broj_dok (+) AND VD.VRSTA_DOK (+) = D.VRSTA_DOK
  and d.godina = sd.godina (+) and d.broj_dok = sd.broj_dok (+) AND sd.VRSTA_DOK (+) = D.VRSTA_DOK

  and d.broj_dok='33'
