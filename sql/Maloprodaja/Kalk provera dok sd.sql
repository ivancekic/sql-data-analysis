select
--round (kolicina,5)
d.VRSTA_DOK,d.BROJ_DOK,d.GODINA,d.TIP_DOK,d.USER_ID,d.PPARTNER,d.status,d.datum_Dok,d.org_deo,d.poslovnica
, vd.ZA_BROJ_DOK,ZA_VRSTA_DOK,ZA_GODINA
, odop.DODATNI_TIP
--, sd.*
from dokument d, (select * from vezni_Dok where vrsta_dok in ('11','13') and za_vrsta_dok='89') vd
   , org_Deo_osn_podaci odop
--, stavka_Dok sd
where d.godina = 2014
  and (
       ( d.vrsta_dok='11' and d.tip_Dok=231)
       or
       ( d.vrsta_dok='13' and d.tip_Dok=431)
      )
--and d.org_Deo = 137
and d.status > 0
and vd.BROJ_DOK(+)=d.BROJ_DOK
and vd.VRSTA_DOK(+)=d.VRSTA_DOK
and vd.godina(+)=d.godina

and odop.org_deo(+)=d.poslovnica
and za_broj_dok is null

order by datum_dok, datum_unosa

--and sd.godina(+)=d.godina
--and sd.VRSTA_DOK(+)=d.VRSTA_DOK
--and sd.BROJ_DOK(+)=d.BROJ_DOK
