Select d.tip_dok, vd.*,
       vd1.za_godina, vd1.za_vrsta_dok, vd1.za_broj_dok
from dokument d, vezni_dok vd, vezni_dok vd1
where vd.godina     = 2009
  and (
          ( vd.vrsta_dok  = 11 and vd.broj_dok   in ('9727', '9728', '9729', '9730'))
       or
          ( vd.za_vrsta_dok  = 11 and vd.za_broj_dok   in ( '9727', '9728', '9729', '9730'))
      )
  and vd.za_vrsta_Dok not in (10,11,14,41)
  and vd.vrsta_Dok not in (10,14,41)

  and d.godina = vd.godina and d.vrsta_dok = vd.vrsta_dok and d.broj_dok = vd.broj_dok
  and vd1.godina = vd.za_godina and vd1.vrsta_dok = vd.za_vrsta_dok and vd1.broj_dok = vd.za_broj_dok
  and vd1.za_vrsta_Dok not in (10,41)
