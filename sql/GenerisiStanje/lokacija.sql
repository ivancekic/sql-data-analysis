select (select org_deo from dokument where broj_dok = sd.broj_dok and godina = sd.godina and vrsta_dok = sd.vrsta_Dok) org,
        sd.*
from stavka_dok sd
--Update stavka_dok sd
--Set Lokacija = 1
Where nvl(lokacija,0) <> 1
  and k_robe <> 0
  and (sd.godina,sd.vrsta_Dok, sd.broj_dok) in
      (select d.godina,d.vrsta_Dok, d.broj_dok
       From dokument d
       Where d.godina = 2008
         and d.org_deo not in (select magacin from partner_magacin_flag)
         and d.status >= 1
      )

--  ORDER BY TO_NUMBER(PROIZVOD)

