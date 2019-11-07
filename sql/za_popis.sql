Select pproizvod.naziv(sp.proizvod),sp.* ,
       DECODE(NVL(PravaProsCena(17, sp.proizvod, to_date('01.01.2007','dd.mm.yyyy'), to_date('31.12.2007','dd.mm.yyyy'),4 ),0),
              0,OdgovarajucaCena(17, SP.proizvod , to_date('01.01.2007','dd.mm.yyyy'), 1, 'YUD',0),
              PravaProsCena(17, sp.proizvod, to_date('01.01.2007','dd.mm.yyyy'), to_date('31.12.2007','dd.mm.yyyy'),4)
              )
         prava_pros ,
       DECODE(NVL(PravaProsCena(17, sp.proizvod, to_date('01.01.2007','dd.mm.yyyy'), to_date('31.12.2007','dd.mm.yyyy'),4 ),0),
              0,OdgovarajucaCena(17, SP.proizvod , to_date('01.01.2007','dd.mm.yyyy'), 1, 'YUD',0),
              PravaProsCena(17, sp.proizvod, to_date('01.01.2007','dd.mm.yyyy'), to_date('31.12.2007','dd.mm.yyyy'),4)
              )*PO_KNJIGAMA VRED_POPISA
from stavka_popisa sp
where godina = 2007
  and popisna_lista = 19
  and proizvod in ('115402','114410','114412')
--  AND PROIZVOD IN ( '2651093','2648000','2661000')

--and PravaProsCena(17,sp.proizvod, to_date('01.01.2007','dd.mm.yyyy'), to_date('31.12.2007','dd.mm.yyyy') ) <= 0
--and sp.proizvod = 221101
ORDER BY TO_NUMBER(PROIZVOD)
