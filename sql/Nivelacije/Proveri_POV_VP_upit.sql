SELECT D.DATUM_DOK, SD.broj_dok,SD.vrsta_dok,SD.godina,d.org_deo,
       SD.CENA, SD.CENA1, OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov
from stavka_dok sd , dokument d, ORG_DEO_OSN_PODACI ORG
Where (SD.broj_dok,SD.vrsta_dok,SD.godina)
       in ( select distinct broj_dok,vrsta_dok,godina
             from ( select * from vezni_dok where za_vrsta_dok = 11 and vrsta_dok = 13
                    UNION ALL
                    select BROJ_DOK,VRSTA_DOK,GODINA,BROJ_DOK,VRSTA_DOK,GODINA from vezni_dok where vrsta_dok = 11
                  )
             where za_vrsta_dok = 11
          )
  AND SD.CENA<>SD.CENA1
  AND (SD.broj_dok,SD.vrsta_dok,SD.godina)
       NOT IN (SELECT broj_dok, vrsta_dok, godina FROM VEZNI_DOK WHERE ZA_VRSTA_DOK = '90' )
  AND DODATNI_TIP in( 'VP')
  AND sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  AND D.ORG_dEO = ORG.ORG_DEO
  AND datum_dok >= to_date('01.01.2009','dd.mm.yyyy')
ORDER BY D.DATUM_DOK, SD.godina, TO_NUMBER(SD.vrsta_dok),TO_NUMBER(SD.broj_dok)
