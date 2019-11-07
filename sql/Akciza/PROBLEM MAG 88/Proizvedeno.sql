select sd.proizvod, P.NAZIV, ROUND(SUM(sd.kolicina * sd.faktor * sd.k_robe),5) KOL,
       z.stanje,z.rezervisana
from stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR, ZALIHE Z
Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  and SD.PROIZVOD = z.proizvod and d.org_deo = z.org_deo
  -----------------------------
  -- ostali uslovi
  and d.godina = 2009 and d.vrsta_dok  IN (1,26,45,46)
  and d.datum_dok >= to_date('03.06.2009','dd.mm.yyyy') and d.datum_dok <= to_date('07.07.2009','dd.mm.yyyy')
  and p.GRUPA_POREZA in (20,22,24) AND D.ORG_DEO = 88
GROUP BY sd.proizvod, P.NAZIV, z.stanje,z.rezervisana
order by TO_NUMBER(SD.PROIZVOD)
