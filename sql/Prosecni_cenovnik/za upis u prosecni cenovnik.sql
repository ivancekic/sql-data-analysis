select p.*


  -- dolazak do nove kolcine
--, PRETHODNA_KOLICINA +
--     (select kolicina*faktor from stavka_dok sd
--      where sd.broj_dok=p.broj_dok
--        and sd.vrsta_Dok=p.vrsta_Dok
--        and sd.godina=p.godina
--        and sd.stavka=p.stavka_dok)               kolicina_nova
--
--  -- dolazak do nove prosecne cene
--  -- nova vrednost
--, (
--     -- stara vrednost
--     p.prethodna_cena*PRETHODNA_KOLICINA
--        +
--     -- vrednost na stavci
--     (select cena1 from stavka_dok sd
--      where sd.broj_dok=p.broj_dok
--        and sd.vrsta_Dok=p.vrsta_Dok
--        and sd.godina=p.godina
--        and sd.stavka=p.stavka_dok) *(KOLICINA-PRETHODNA_KOLICINA)
--   )/KOLICINA cena_nova
from prosecni_cenovnik p
where org_Deo=91
and proizvod=7223
--and godina = 2012
--and org_Deo= 475
and datum >= to_date('01.01.2014','dd.mm.yyyy')

order by org_Deo, datum desc
