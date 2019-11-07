select dat_do
     , PROIZVOD,pproizvod.naziv(proizvod) pro_naz, STANJE,pproizvod.jedmere(proizvod) pro_jm
from
(
select to_date('31.07.2011','dd.mm.yyyy') dat_do, stx.proizvod, sum(kolicina*faktor*k_robe) stanje
from dokument dx, stavka_dok stx
where dx.vrsta_dok = stx.vrsta_dok and dx.broj_dok = stx.broj_dok and dx.godina = stx.godina
  and k_robe<>0
  and dx.status >0

  and stx.proizvod in  (select sifra from proizvod where POSEBNA_GRUPA IN (45, 139, 153, 154, 158 )  )

  and dx.datum_dok between to_date('01.01.2011','dd.mm.yyyy') and to_date('31.07.2011','dd.mm.yyyy')

group by proizvod
union
select to_date('06.10.2012','dd.mm.yyyy') dat_do, stx.proizvod, sum(kolicina*faktor*k_robe) stanje
from dokument dx, stavka_dok stx
where dx.vrsta_dok = stx.vrsta_dok and dx.broj_dok = stx.broj_dok and dx.godina = stx.godina
  and k_robe<>0
  and dx.status >0

  and stx.proizvod in  (select sifra from proizvod where POSEBNA_GRUPA IN (45, 139, 153, 154, 158 )  )

  and dx.datum_dok between to_date('01.01.2012','dd.mm.yyyy') and to_date('06.10.2012','dd.mm.yyyy')

group by proizvod

) order by dat_do, to_number(proizvod)
