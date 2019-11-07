Select zts.VRSTA_TROSKOVA, zts.IZNOS_TROSKA, zts.STAVKA_PRIJ
     , zf.formula, zf.VREDNOST, zf.OPIS
From zavisni_troskovi_stavke zts
   , zavisni_troskovi_vrste zv
   , zavisni_troskovi_formule zf
Where zts.broj_dok       = &vBroj_dok--'12258'
  and zts.vrsta_dok      = &vVrsta_dok--'3'
  and zts.godina         = &nGodina--2012
  and zts.vrsta_troskova = zv.vrsta_troskova
  and zv.formula = zf.formula
order by to_number(zts.broj_dok), stavka
