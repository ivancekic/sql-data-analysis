Select * from vezni_dok d
where godina = 2009
  and
      (
           (d.vrsta_dok = 1  and d.broj_dok in ('3','4'))
        or (d.vrsta_dok = 11 and d.broj_dok in ('9743'))
        or (d.vrsta_dok = 61 and d.broj_dok in ('9743'))
        or (d.vrsta_dok = 3  and d.broj_dok in ('6831'))
        or (d.vrsta_dok = 3  and d.broj_dok in ('6832'))
        or (d.vrsta_dok = 4  and d.broj_dok in ('40'))
        or (d.vrsta_dok = 1  and d.broj_dok in ('5','6'))
        or (d.vrsta_dok = 26 and d.broj_dok in ('1','2'))
        or (d.vrsta_dok = 11 and d.broj_dok in ('9744'))
        or (d.vrsta_dok = 61 and d.broj_dok in ('9744'))
        or (d.vrsta_dok = 12 and d.broj_dok in ('57'))
        or (d.vrsta_dok = 62 and d.broj_dok in ('13'))
        or (d.vrsta_dok = 1  and d.broj_dok in ('7','8'))
        or (d.vrsta_dok = 45 and d.broj_dok in ('1','2'))
      )
  and za_vrsta_dok <> 29
Order by rowid
