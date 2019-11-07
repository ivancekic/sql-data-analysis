Select d.status st , D.DATUM_DOK , D.DATUM_UNOSA , D.ORG_DEO mag , d.tip_dok tip ,d.mesto_isporuke mesto , d.franko fran , D.USER_ID ,
       vd.broj_dok otp ,vd.vrsta_dok vrotp, vd.godina gotp, vd.za_vrsta_dok nal , vd.za_godina gnal,
       d1.status st1 , D1.DATUM_DOK , D1.DATUM_UNOSA , D1.ORG_DEO mag , d1.tip_dok tip ,d1.mesto_isporuke mesto , d1.franko fran , D1.USER_ID
from dokument d , vezni_dok vd , dokument d1
Where vd.godina       = 2008
  and vd.vrsta_Dok    = 11
  and vd.za_vrsta_Dok = 10

  and vd.godina       = d.godina
  and vd.vrsta_Dok    = d.vrsta_dok
  and vd.broj_Dok     = d.broj_dok

  and vd.za_godina    = d1.godina
  and vd.za_vrsta_Dok = d1.vrsta_dok
  and vd.za_broj_Dok  = d1.broj_dok

order by to_number(d.broj_dok)
