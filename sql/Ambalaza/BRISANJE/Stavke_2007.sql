select D.godina, d.vrsta_dok vr, pvrstadok.naziv(d.vrsta_dok) naziv ,d.broj_dok, d.tip_dok tip, pnacinfakt.naziv(d.tip_dok) naziv,
       d.org_deo od, porganizacionideo.naziv(d.org_deo) naziv,
       d.broj_dok1 br1 ,d.ppartner pp, d.pp_isporuke pp_isp,
       SD.proizvod, sd.jed_mere,sd.kolicina,sd.realizovano,sd.cena,sd.porez,sd.rabat,sd.cena1
from   stavka_dok sd , dokument d
Where sd.godina    (+)= d.godina  and sd.vrsta_dok (+)= d.vrsta_dok  and sd.broj_dok  (+)= d.broj_dok
 -----------------------------
  and d.datum_dok <= to_date('31.12.2007','dd.mm.yyyy')and sd.proizvod = '0333901'
  and org_deo not in (135)
  and org_deo not in (select magacin from partner_magacin_flag)
--Order By tip_dok --, org_Deo --D.TIP_DOK--, d.godina , to_number(d.vrsta_dok),to_number(d.broj_dok)


