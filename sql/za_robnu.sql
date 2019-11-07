select --user_id,d.datum_unosa,
--SD.PROIZVOD,
d.godina,d.vrsta_dok,d.broj_dok,d.status,d.tip_dok,d.datum_dok,
--d.poslovnica,porganizacionideo.naziv(d.poslovnica),
sd.cena,
--sd.jed_mere,
sd.faktor,sd.kolicina,k_robe,sd.cena1   ,
PDokument.UlazIzlaz( d.Vrsta_Dok, d.Tip_Dok, sd.K_Robe,d.Datum_Dok ) nUlzaIzlaz
from   stavka_dok sd , dokument d
Where sd.godina    (+)= d.godina  and sd.vrsta_dok (+)= d.vrsta_dok  and sd.broj_dok  (+)= d.broj_dok
 -----------------------------
and d.org_Deo = 64
and d.status > 0
  and d.vrsta_dok  NOT IN ( 2 , 9 , 10 , 73 , 74 )
  and proizvod in('211972')
--Order By d.Datum_Unosa
Order by d.godina , To_Number( Proizvod ), d.Datum_Dok, TO_NUMBER(D.Vrsta_Dok) , d.Datum_Unosa
