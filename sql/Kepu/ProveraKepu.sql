select broj_dok, vrsta_dok, godina, za_vrsta_dok, za_godina, count(*)
from vezni_dok
where (godina,vrsta_Dok,broj_dok) in
      (Select d.godina,d.vrsta_Dok,d.broj_dok from dokument d
       where d.godina = 2011
--         and d.datum_dok = TO_DATE('11.11.2009','DD.MM.YYYY')
--         and d.org_deo = 114
         and d.vrsta_Dok not in (2,9,10)
      )
Group by broj_dok, vrsta_dok, godina, za_vrsta_dok, za_godina
Having count(*) > 1
--order by rowid
