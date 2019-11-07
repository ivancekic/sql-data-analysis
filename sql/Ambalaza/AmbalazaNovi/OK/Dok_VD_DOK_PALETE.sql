select d.status,d.Godina god , d.vrsta_dok vr, d.tip_dok,d.Broj_Dok br, d.org_deo , d.broj_dok1 br1, d.datum_dok,
       sd.proizvod , sd.cena , sd.valuta,sd.kolicina , sd.realizovano,sd.cena1,SD.FAKTOR
       , vd.za_vrsta_dok , vd.za_broj_dok , d1.tip_dok  , d1.org_deo,
       sd1.proizvod , sd1.cena , sd1.valuta,sd1.kolicina , sd1.realizovano,sd1.cena1,SD1.FAKTOR
from   stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR , vezni_Dok vd , dokument d1 ,stavka_dok sd1
--from   dokument d , stavka_dok sd , PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      sd.godina    (+)= d.godina
  and sd.vrsta_dok (+)= d.vrsta_dok
  and sd.broj_dok  (+)= d.broj_dok

  and vd.godina    (+)= d.godina
  and vd.vrsta_dok (+)= d.vrsta_dok
  and vd.broj_dok  (+)= d.broj_dok

  and vd.za_godina    = d1.godina
  and vd.za_vrsta_dok = d1.vrsta_dok
  and vd.za_broj_dok  = d1.broj_dok

  and sd1.godina    = d1.godina
  and sd1.vrsta_dok = d1.vrsta_dok
  and sd1.broj_dok  = d1.broj_dok

  and  sd.proizvod =  sd1.proizvod



  AND SD.PROIZVOD = P.SIFRA
  AND P.GRUPA_PROIZVODA=  GPR.ID

 -----------------------------
  and d.vrsta_dok  not IN ( 1 , 2 , 8 )
--  and d.vrsta_dok     = 63
  and p.tip_proizvoda = 8
  and d.tip_dok = 14
  and sd.proizvod = '0333901'
order by d.godina , to_number(d.vrsta_dok), to_number(sd.broj_dok)
