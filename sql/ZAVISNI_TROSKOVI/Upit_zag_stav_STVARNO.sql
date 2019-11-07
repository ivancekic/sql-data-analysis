Select *
from ZAVISNI_TROSKOVI z , ZAVISNI_TROSKOVI_stavke zs
Where zs.godina     = z.godina
  and zs.vrsta_Dok  = z.vrsta_Dok
  and zs.broj_dok   = z.broj_dok

