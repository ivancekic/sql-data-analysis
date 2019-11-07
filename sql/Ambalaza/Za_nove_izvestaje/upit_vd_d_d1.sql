Select d.status, D.GODINA DGOD, d.vrsta_dok DVR, D.BROJ_DOK DBR, d.ppartner,
       PVRSTADOK.NAZIV(D.VRSTA_DOK) NAZIV, d.tip_dok DTIP, pnacinfakt.naziv(d.tip_dok) naziv,
       D1.GODINA D1GOD, D1.VRSTA_DOK D1VR, D1.BROJ_DOK D1BR, D1.TIP_DOK D1TIP, pnacinfakt.naziv(d1.tip_dok) naziv,
       SD1.PROIZVOD, SD1.KOLICINA, SD1.K_ROBE, SD1.FAKTOR, SD1.CENA
from vezni_dok vd, dokument d, DOKUMENT D1, stavka_dok sd1
where vd.godina     = 2009
  and vd.vrsta_dok  = 11
  -- 9929 ok                                          -- status 1
  -- 9727 stornirana                                  -- status 4
  -- 9728 ima povracaj - a povratnica nije stornirana -- status 5 , povratnica nije stornirana -- status 1
  -- 9730 ima povracaj - a povratnica je stornirana   -- status 1 , povratnica je stornirana   -- status 4
  and vd.broj_dok   in ( '9727', '9728', '9729', '9730')
  and za_vrsta_Dok not in (10,14,41)
  and vd.godina = d.godina and vd.vrsta_dok = d.vrsta_dok and vd.broj_dok = d.broj_dok
  and Vd.ZA_godina = d1.godina and vd.ZA_vrsta_dok = d1.vrsta_dok and vd.ZA_broj_dok = d1.broj_dok
  and d1.godina = Sd1.godina and d1.vrsta_dok = Sd1.vrsta_dok and d1.broj_dok = Sd1.broj_dok


