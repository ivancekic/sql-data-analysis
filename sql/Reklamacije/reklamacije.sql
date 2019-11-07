Select * from reklamacija
where godina = 2012
  and vrsta_Dok = 5
  and broj_dok in (511,513,514,515,517,518,519)

order by broj_dok
