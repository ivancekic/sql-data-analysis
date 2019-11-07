Select sd.* ,d.tip_dok from zavisni_troskovi sd , dokument d
Where sd.godina    = d.godina
  and sd.vrsta_dok = d.vrsta_dok
  and sd.broj_dok  = d.broj_dok

order by to_number (sd.broj_dok)
