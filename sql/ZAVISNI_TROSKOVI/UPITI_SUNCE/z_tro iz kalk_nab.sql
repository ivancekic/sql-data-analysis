Select stavka,proizvod,kolicina,jed_mere,broj_koleta,lot_serija
     , rok,lokacija,cena,faktor,kolicina_kontrolna,rabat,porez,cena1,k_robe
     , z_troskovi
     , round( round(kolicina*(cena1),4)
              -
              round(kolicina*cena*(1-rabat/100),4)
            ,2) z_tro_pr
      ,Neto_KG,Proc_Vlage,Proc_Necistoce,HTL
FROM Stavka_Dok
WHERE broj_dok in (188,211) AND godina = 2010 AND vrsta_dok = '3'
