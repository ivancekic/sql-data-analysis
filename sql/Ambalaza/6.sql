--Select * FROM stavka_dok SD
Update stavka_dok SD
set SD.cena1  = 11.63
where
      SD.PROIZVOD = 257 AND
      SD.godina     = 2006                         and
      SD.vrsta_dok not in (2,9,10)
--and cena1 !=326.7
--ORDER BY TO_NUMBER(SD.PROIZVOD)
