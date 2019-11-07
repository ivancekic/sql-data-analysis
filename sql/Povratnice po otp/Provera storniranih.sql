SELECT
       D.VRSTA_DOK,D.BROJ_DOK,D.GODINA,D.TIP_DOK, d.DATUM_DOK,d.DATUM_UNOSA,d.USER_ID,d.PPARTNER,d.STATUS, d.org_deo, d.pp_isporuke, d.broj_dok1
--d.*
     , vd.ZA_BROJ_DOK, vd.ZA_VRSTA_DOK, vd.ZA_GODINA
     , SD.PROIZVOD, sd.kolicina, sd.faktor, sd.cena, sd.cena1

FROM dokument d

   , (select vd.* from VEZNI_DOK vd where vd.broj_dok!='0' and vd.vrsta_dok=13 and vd.godina != 0
         and vd.za_vrsta_Dok = '31'
     ) vd
   , stavka_Dok SD
WHERE
d.godina = 2011
--and d.org_deo = 104
--and d.proizvod=10989
and
d.VRSTA_DOK in(13)
and d.status = 4

AND D.TIP_DOK!=401

and d.godina = vd.godina (+) and d.vrsta_dok = vd.vrsta_dok (+) and d.broj_dok = vd.broj_dok (+)
AND d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok (+)
--ORDER BY D.DATUM_DOK, D.DATUM_UNOSA
