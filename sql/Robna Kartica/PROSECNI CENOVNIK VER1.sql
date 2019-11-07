select PC.ROWID

, PC.*
from prosecni_cenovnik PC
   , DOKUMENT D
   , STAVKA_DOK SD
where pc.godina = 2015
and    PC.org_deo = 91
and PC.proizvod = '22192'
--AND D.ORG_DEO  = PC.ORG_DEO
AND D.GODINA=PC.GODINA
AND D.VRSTA_DOK=PC.VRSTA_dOK
AND D.BROJ_DOK=PC.BROJ_DOK
--
AND SD.GODINA=D.GODINA
AND SD.VRSTA_DOK=D.VRSTA_dOK
AND SD.BROJ_DOK=D.BROJ_DOK
AND SD.PROIZVOD = PC.PROIZVOD
order by D.datum_DOK, D.DATUM_UNOSA