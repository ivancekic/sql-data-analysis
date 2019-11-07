Update dokument
Set status = 1
where godina    = 2008
  and vrsta_dok = 73
  and broj_dok  = 275;

Update Stavka_Dok
Set realizovano = 0
where godina    = 2008
  and vrsta_dok = 73
  and broj_dok  = 275;
  
Update dokument
Set status = 0
where godina    = 2008
  and vrsta_dok = 74
  and broj_dok  = 276;

commit;