select sd.rowid,
d.godina, d.vrsta_dok, d.broj_dok, d.tip_dok
     , sd.proizvod, sd.cena, sd.faktor, sd.porez, sd.cena1
     , PPlanskiCenovnik.Cena(sd.Proizvod ,d.Datum_Dok,'YUD', 1 ) planski
from stavka_dok sd, dokument d, PROIZVOD P, GRUPA_PR  GPR
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  AND SD.PROIZVOD = P.SIFRA  AND P.GRUPA_PROIZVODA=  GPR.ID
 -----------------------------
  and d.godina = 2010
  and sd.cena1 <> PPlanskiCenovnik.Cena(sd.Proizvod ,d.Datum_Dok,'YUD', 1 )
  and sd.proizvod in ( Select sd.proizvod from planski_cenovnik
                       where to_char(datum,'yyyy') = '2010'
                     )
  and p.tip_proizvoda in ('01','02')
--  and sd.porez is null
