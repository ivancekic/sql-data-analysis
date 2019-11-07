select distinct proizvod , pproizvod.naziv(proizvod)
from   stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR
--from   dokument d , stavka_dok sd , PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      sd.godina    (+)= d.godina
  and sd.vrsta_dok (+)= d.vrsta_dok
  and sd.broj_dok  (+)= d.broj_dok

  AND SD.PROIZVOD = P.SIFRA
  AND P.GRUPA_PROIZVODA=  GPR.ID

 -----------------------------
  -- ostali uslovi
  and d.godina = 2007
  and d.vrsta_dok  NOT IN (2,9,10)
  --and proizvod in ( 97,6909,7418,8368,9416,11087,11426,11568,11570,12951,13676,14557,14776,15148,15660,15987,
--                    16224,16649,16990,17488,17832,18087 )
  AND LOKACIJA IS NULL
order by to_number(sd.proizvod)

