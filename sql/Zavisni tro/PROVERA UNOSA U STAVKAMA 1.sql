select

  sd.broj_dok,sd.VRSTA_DOK,sd.GODINA,d.org_deo,d.broj_dok1,
  sd.STAVKA,sd.PROIZVOD,p.naziv naziv_pro,
  sd.kolicina,
  sd.cena,
  sd.rabat,
  SD.CENA1,
  sd.Z_TROSKOVI

from stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID

--  AND D.VRSTA_DOK <> 11
  -----------------------------
  -- ostali uslovi
  and d.godina = 2012
  and d.vrsta_dok = 3
  and d.tip_dok = 10
  and d.org_deo between 113 and 118
  and to_number(nvl(d.broj_dok1,0)) > 0

--and (
----          ( d.VRSTA_DOK = 2 And d.BROJ_DOK in(6806)) --1351--
----      or
--          ( d.VRSTA_DOK = 3 And d.BROJ_DOK in('30361')) --1351--
--    )
ORDER BY STAVKA
