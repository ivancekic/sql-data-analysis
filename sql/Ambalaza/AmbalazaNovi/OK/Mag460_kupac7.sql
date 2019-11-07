select d.tip_dok, sd.proizvod , pproizvod.naziv(sd.proizvod)
--distinct sd.proizvod
--SD.ROWID , D.* , SD.*
--sd.rowid , d.status,d.Godina god , d.vrsta_dok vr, d.Broj_Dok br, d.org_deo mag1, d.poslovnica mag2, d.broj_dok1 br1, d.datum_dok,
--       sd.proizvod , sd.cena , sd.valuta,sd.kolicina , sd.realizovano,sd.rabat,sd.cena1, pproizvod.tip(sd.proizvod) tip ,
--       SD.AKCIZA,SD.FAKTOR
--,       OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov
--,Kolicina * Faktor * 100 / Kolicina_Kontrolna jacina
--d.tip_dok,pproizvod.naziv(sd.proizvod),--sd.*
--sd.proizvod , pproizvod.naziv(sd.proizvod),sum (sd.kolicina * sd.faktor * sd.k_robe)
from   stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR
--from   dokument d , stavka_dok sd , PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      sd.godina    (+)= d.godina
  and sd.vrsta_dok (+)= d.vrsta_dok
  and sd.broj_dok  (+)= d.broj_dok

  AND SD.PROIZVOD = P.SIFRA
  AND P.GRUPA_PROIZVODA=  GPR.ID

 -----------------------------
  -- ostali uslovi
--  and d.godina = 2007
--  and d.vrsta_dok  IN ( 3 )

  and p.tip_proizvoda = 8
--  and d.status != 0
--  AND D.TIP_DOK NOT IN (23)
--  and ppartner = 4074
--  and d.broj_dok in (2618,2621,2628)

  and org_deo = 460
--  and d.broj_dok1 in (6050)

--  or ( d.vrsta_dok  = 11 and d.broj_dok = 64  ) )
--  and d.tip_dok != 23
--  and datum_dok > to_date('22.09.2007','dd.mm.yyyy')
--  and sd.cena = 25.8
--  and sd.cena1 is not null
--  and SD.K_Robe != 0
--  and d.status < 8
--  and proizvod in (select sifra from proizvod where jed_mere = 'HLO')--( 10588 )
--  and proizvod in --(4928,4929,4930,4931,4932)
--      ( 2 )
group by d.tip_dok, sd.proizvod
order by d.tip_dok, to_number(sd.proizvod)
--d.datum_dok ,
--to_number(sd.broj_dok)
--to_number(sd.proizvod)--,sd.stavka -- ,

--, d.broj_dok , stavka
