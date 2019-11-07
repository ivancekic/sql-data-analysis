select
rowid,
       ORG_DEO 					mag
     , PROIZVOD 				pro
--     , DATUM
--     , DATUM_UNOSA
     , KOLICINA					kol
     , CENA
     , PRETHODNA_KOLICINA		kol_pre
     , PRETHODNA_CENA			cena_pre
     , VRSTA_DOK				vrd
     , BROJ_DOK					brd
     , GODINA					god
     , STAVKA_DOK

--     , (PRETHODNA_CENA*PRETHODNA_KOLICINA)	  vred_pre
--     , (KOLICINA-PRETHODNA_KOLICINA)
--       * 1650
--       vred_dok
--
--     ,                 (PRETHODNA_CENA*PRETHODNA_KOLICINA)
--            +   (KOLICINA-PRETHODNA_KOLICINA)
--                *(select cena1 from stavka_Dok sd
--                  where sd.godina = p.godina and sd.vrsta_dok=p.vrsta_dok and sd.broj_dok = p.broj_dok And sd.stavka=p.STAVKA_DOK
--                  )
--
--          saldo
--     , (
--                (PRETHODNA_CENA*PRETHODNA_KOLICINA)
--            +   (KOLICINA-PRETHODNA_KOLICINA)
--                *(select cena1 from stavka_Dok sd
--                  where sd.godina = p.godina and sd.vrsta_dok=p.vrsta_dok and sd.broj_dok = p.broj_dok And sd.stavka=p.STAVKA_DOK
--                  )
--
--        ) / KOLICINA   cena_nova
from prosecni_cenovnik p
where org_Deo = 789
  and godina = 2014
  and proizvod in (
--  6809
--,
'6063'
)

order by proizvod
