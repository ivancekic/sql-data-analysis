select
D.godina god, d.vrsta_dok vr, pvrstadok.naziv(d.vrsta_dok) naziv ,d.broj_dok br, d.tip_dok tip, pnacinfakt.naziv(d.tip_dok) naziv,
       d.org_deo od, porganizacionideo.naziv(d.org_deo) naziv,
       d.broj_dok1 br1 ,--d.ppartner pp, d.pp_isporuke pp_isp,
       SD.STAVKA,SD.proizvod, sd.jed_mere,sd.kolicina,SD.K_ROBE,sd.realizovano,sd.cena--,sd.porez,sd.rabat,sd.cena1
from dokument d , stavka_dok sd
Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
 -----------------------------
  AND ( (D.GODINA = 2008 AND D.VRSTA_DOK = 21 and d.status >= 1)
       OR
        (D.GODINA = 2007 AND D.VRSTA_DOK IN ( 19,20) and d.status >= 1)
      )
  and sd.proizvod = '0333901'
  and org_deo not in (135)
  and org_deo not in (select magacin from partner_magacin_flag)

Order By org_Deo --D.TIP_DOK--, d.godina , to_number(d.vrsta_dok),to_number(d.broj_dok)


