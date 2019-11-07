select
--d.*
  d.kolicina,
  d.cena,
  d.rabat,
  d.Z_TROSKOVI
, d.kolicina * d.cena vred
, (100-nvl(d.rabat,0)/100) rab
, round(

         (
           (d.kolicina * d.cena * (100-nvl(d.rabat,0)/100) + nvl(Z_TROSKOVI,0)) / d.kolicina
          )

          *

          (100 + 2 ) / 100

        ,2)
(100-nvl(x.rabat,0))/100        
from
--DOKUMENT D
STAVKA_DOK D
--ZAVISNI_TROSKOVI d
--ZAVISNI_TROSKOVI_STAVKE D
Where
  -- ostali uslovi
     d.godina = 2012

and (
--          ( d.VRSTA_DOK = 2 And d.BROJ_DOK in(6806,6807,6808)) --1351--
--          ( d.VRSTA_DOK = 2 And d.BROJ_DOK in(6809)) --1351--
--      or
--          ( d.VRSTA_DOK = 3 And d.BROJ_DOK in('30362')) --1351--

          ( d.VRSTA_DOK = 3 And d.BROJ_DOK in('12528')) --1351--
    )
