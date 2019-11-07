select d.STATUS,d.DATUM_DOK,d.GODINA,d.VRSTA_DOK,d.BROJ_DOK,d.ORG_DEO,d.BROJ_DOK1, d.tip_dok
    , sd.STAVKA,sd.PROIZVOD, sd.kolicina, sd.akciza, sd.taksa
from   stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok  (+)
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  -----------------------------
  -- ostali uslovi
  and '2010' = d.godina
--  AND TIP_DOK = 11
--AND D.ORG_DEO = 680
--and sd.faktor <> 1
--  and (
--         ('3' = d.vrsta_dok  and '21028' = d.broj_dok  )
------or         (d.vrsta_dok  = 10 and d.broj_dok = 3897 )
----
--      )
--and proizvod in (select proizvod from stavka_dok
--where godina = 2010
-- and vrsta_dok = 3
-- and broj_dok = 21028)

--  AND NVL ( SD.CENA , 0 ) <>  NVL ( SD.CENA1 , 0 )
--
--  and d.status >= 1
--  and ( nvl(sd.cena1,0) <= 0 or nvl(sd.cena,0) <= 0 )
--  and d.vrsta_dok  IN ( 1,26,45,46,
--                        8,27,28,32 )
--  and tip_dok = 23
--  and sd.stavka = 1
--  and d.broj_dok in (10)
-- and d.broj_dok1 in (1595)
--   AND SD.CENA <> 18
-- PProdajniCenovnik.Cena( SD.Proizvod,D.Datum_Dok,SD.Valuta,SD.Faktor)
--  and d.datum_dok >= to_date('29.09.2009','dd.mm.yyyy')
--  and sd.proizvod = 9302
  and k_robe <> 0
  and d.tip_dok like '2%' and d.tip_dok <> 23
--and nvl(sd.cena1,0) = 0
  and proizvod in ('21686')
--order by --to_number(sd.proizvod),
----d.datum_dok ,
--to_number(sd.broj_dok)
--to_number(sd.proizvod)--,sd.stavka -- ,
--
----, d.broj_dok , stavka
--ORDER BY TO_NUMBER(PROIZVOD),
--         D.DATUM_UNOSA,
--         TO_NUMBER(d.vrsta_dok),
--         TO_NUMBER(d.BROJ_dok)
--         --datum_dok--, stavka--
--
--and sd.stavka = 98
order by --SD.PROIZVOD
--, d.vrsta_dok, d.godina,d.org_deo,
sd.proizvod,d.broj_dok--d.datum_dok,d.datum_unosa;
