Select to_number(substr(p.sifra,2,5)) sif
     , p.sifra
--     , pl.PROIZVOD
     ,to_date('01.01.2012','dd.mm.yyyy') dat,pl.VALUTA,pl.CENA,pl.KOL_CENA,pl.JM_CENA,pl.FAK_CENA,pl.PPARTNER
from proizvod p

,
(
select *
from planski_cenovnik p1
where proizvod in (

                    Select to_number(substr(sifra,2,5)) sif
                    from proizvod
                    where length(sifra) > 5

                   )
  and datum=(select max(datum)
             from planski_cenovnik p2
             where p2.proizvod=p1.proizvod
            )
) pl
where length(p.sifra) > 5
  and to_number(substr(p.sifra,2,5))=pl.proizvod
