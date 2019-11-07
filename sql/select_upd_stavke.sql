select lokacija from stavka_dok sd
--Update stavka_dok sd
-- set lokacija = 1
where sd.godina = 2007
  and sd.vrsta_dok  NOT IN (2,9,10)
  and LOKACIJA IS NULL
  and ( sd.godina , sd.vrsta_dok , sd.broj_dok ) in
           ( Select sd.godina , sd.vrsta_dok , sd.broj_dok
             From Dokument sd
             Where sd.godina = 2007
               and sd.vrsta_dok  NOT IN (2,9,10)
               and sd.status != 0 )
