select d.org_deo ,
       sum(sd.kolicina * sd.faktor * sd.K_robe),
       sum(sd.realizovano * sd.faktor * sd.K_robe)


/*
distinct proizvod ,  d.broj_dok , P.TARIFNI_BROJ, stavka
*/
from stavka_dok sd, dokument d

where
      d.status not in (0) and
      d.godina     = 2006                         and
      d.datum_dok  >= to_date( '01.01.2006' , 'dd.mm.yyyy' ) and
      sd.proizvod in ( 14654 ) and
      sd.godina    = d.godina                     and
      sd.vrsta_dok = d.vrsta_dok                  and
      sd.broj_dok  = d.broj_dok
--      sd.valuta != 'YUD'

group by d.org_deo , sd.lokacija
--order by to_number(proizvod)
