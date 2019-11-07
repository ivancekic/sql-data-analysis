Select DISTINCT SD.PROIZVOD , PC.CENA
from  stavka_dok SD, PROIZVOD P , PLANSKI_CENOVNIK PC
--Update stavka_dok
--set cena1  = 150


where
      SD.PROIZVOD = P.SIFRA    AND
      SD.godina     = 2006                         and
--      vrsta_dok not in (2,9,10) and
      P.TIp_PROIZVODA in ( 8 , 81 ) AND
      SD.PROIZVOD = PC.PROIZVOD
      AND DATUM >= to_date( '01.01.2006' , 'dd.mm.yyyy' )
--and cena1 !=326.7
ORDER BY TO_NUMBER(SD.PROIZVOD)
