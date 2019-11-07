Select sd.godina, sd.vrsta_Dok, sd.broj_dok
     , sum(sd.z_troskovi) z_tro_st
     , round(sum( round(kolicina*(cena1),4)
                  -
                  round(kolicina*cena*(1-rabat/100),4)
                )
            ,2 ) z_tro_pr
     , (Select sum(z.IZNOS_TROSKA)
        From ZAVISNI_TROSKOVI_stavke z
        where z.godina = sd.godina and z.vrsta_Dok = sd.vrsta_Dok and z.broj_dok = sd.broj_dok
       )
       z_tro_z
From stavka_dok sd
Where (sd.godina, sd.vrsta_Dok, sd.broj_dok)
       in (Select d.godina, d.vrsta_Dok, d.broj_dok
           From ZAVISNI_TROSKOVI_stavke d
          )
Group by sd.godina, sd.vrsta_Dok, sd.broj_dok
