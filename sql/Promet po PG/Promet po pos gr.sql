select p.posebna_grupa pos_gr, PPosebnaGrupa.Naziv(p.posebna_grupa) naziv
     , SD.PROIZVOD, PPROIZVOD.NAZIV(SD.PROIZVOD) NAZIV, PPROIZVOD.JEDMERE(SD.PROIZVOD) JM
     , ( CASE WHEN SUM(SD.KOLICINA*SD.FAKTOR*SD.K_ROBE) >= 0 THEN  SUM(SD.KOLICINA*SD.FAKTOR*SD.K_ROBE)
         ELSE NULL
         END
       ) USLO
     , ( CASE WHEN SUM(SD.KOLICINA*SD.FAKTOR*SD.K_ROBE) < 0 THEN  SUM(SD.KOLICINA*SD.FAKTOR*SD.K_ROBE)
         ELSE NULL
         END
       ) IZASLO
     , SUM(SD.KOLICINA*SD.FAKTOR*SD.K_ROBE) stanje
--select d.*, sd.*
from stavka_dok sd, dokument d, Proizvod p
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  and p.sifra = sd.proizvod
  and d.godina = 2010
  and d.org_deo = 104
  AND D.VRSTA_DOK IN (3,4,5,30,11,12,13,31,61,62 )
  and d.datum_dok >= to_date('01.01.2010','dd.mm.yyyy') and d.datum_dok <= to_date('13.01.2010','dd.mm.yyyy')
  AND D.STATUS > 0
--  and sd.proizvod = 399
GROUP BY p.posebna_grupa, SD.PROIZVOD
order by p.posebna_grupa, TO_NUMBER(SD.PROIZVOD)
