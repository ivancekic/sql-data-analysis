Select d.godina , d.vrsta_dok , d.broj_dok , d.org_Deo , d.broj_dok1
From Dokument d
Where d.vrsta_dok = 3
  and d.tip_dok   = 10      
  and 
order by to_number (broj_dok)

