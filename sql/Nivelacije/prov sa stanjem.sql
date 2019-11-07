select
--Sd.ROWID , --pjedmere.naziv(sd.proizvod) jm,
--pproizvod.naziv(sd.proizvod) ,
d.user_id,
SD.BROJ_DOK, sd.vrsta_dok, sd.godina,
D.org_deo, d.broj_dok1,d.datum_dok, d.datum_unosa,
sd.proizvod, sd.kolicina,sd.cena,sd.cena1
, (select sum(kolicina*faktor*k_robe) from dokument d1, stavka_dok sd1
   where sd1.proizvod=sd.proizvod and (sd1.k_robe <> 0 or d1.vrsta_Dok=80)
     and d1.godina = sd1.godina and d1.vrsta_dok = sd1.vrsta_dok and d1.broj_dok = sd1.broj_dok
     and d1.status > 0 and d1.org_Deo=103 and d1.datum_dok <= d.datum_dok
     and d1.datum_unosa < to_date(to_char(d.datum_dok,'dd.mm.yyyy')||' '|| to_char(d.datum_unosa,'hh24:mi:ss'),'dd.mm.yyyy hh24:mi:ss')
     and d1.godina = 2011

  ) st
from stavka_dok sd, dokument d
Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok

--  AND D.VRSTA_DOK <> 11
  -----------------------------
  -- ostali uslovi
  and '2011' = d.godina
----  AND TIP_DOK = 11
  AND D.ORG_DEO = 103
  and (k_robe <>0 or d.vrsta_Dok = 80)
  and      d.vrsta_dok in ('80')
order by d.datum_dok,d.datum_unosa;
