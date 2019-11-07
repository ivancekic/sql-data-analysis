select d.tip_dok, d.vrsta_Dok,d.org_Deo,od.dodatni_tip,d.datum_dok , d.datum_unosa,d.broj_dok --, vd.* --VD.ZA_VRSTA_DOK , VD.ZA_BROJ_DOK
--sD.ROWID , pjedmere.naziv(sd.proizvod) jm,pproizvod.naziv(sd.proizvod) , D.* , SD.*
--,       OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov
from stavka_dok sd , dokument d , org_deo_osn_podaci od --, VEZNI_DOK VD
Where sd.godina  = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  and od.org_deo = d.org_deo
--  AND Vd.godina (+)= d.godina and Vd.vrsta_dok (+)= d.vrsta_dok and Vd.broj_dok (+)= d.broj_dok
  ------------------------------
  -- ostali uslovi
  and d.godina = 2009
  and d.vrsta_dok  IN (11)
  AND NVL ( SD.CENA , 0 ) <> NVL ( SD.CENA1 , 0 )
  and od.dodatni_tip in ('VP2','VP3')
  AND (d.godina, d.vrsta_dok, d.broj_dok) not IN
      (SELECT d.godina, d.vrsta_dok, d.broj_dok
       FROM VEZNI_DOK D
       WHERE d.vrsta_dok  IN (11)
         AND D.ZA_VRSTA_dOK = 90
      )
--  AND VD.ZA_VRSTA_dOK = 90
Group by d.tip_dok, d.vrsta_Dok,d.org_Deo,od.dodatni_tip,d.datum_dok , d.datum_unosa,d.broj_dok
ORDER BY to_number(d.broj_dok)--stavka--TO_NUMBER(PROIZVOD)

