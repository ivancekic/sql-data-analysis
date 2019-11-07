select D.godina god, d.vrsta_dok vr, --pvrstadok.naziv(d.vrsta_dok) naziv ,
       d.broj_dok br, d.tip_dok tip, --pnacinfakt.naziv(d.tip_dok) naziv,
       d.org_deo od, --porganizacionideo.naziv(d.org_deo) naziv,
       d.broj_dok1 br1 ,d.ppartner pp, d.pp_isporuke pp_isp,
       SD.proizvod, sd.jed_mere,sd.kolicina,sd.k_robe,sd.realizovano,sd.cena,sd.porez,sd.rabat,sd.cena1
from   stavka_dok sd , dokument d
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
  and d.status >= 1 and sd.proizvod = '0333901' and org_deo in (135) and k_robe <> 0
Order by d.godina


