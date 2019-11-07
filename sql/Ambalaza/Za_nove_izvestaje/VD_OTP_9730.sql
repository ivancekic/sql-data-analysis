Select vd.* from vezni_dok vd
where vd.godina    = 2009
  and vd.vrsta_dok = 11
  and vd.broj_dok   in ( '9730' )
  and za_vrsta_Dok not in (10,14,41)
