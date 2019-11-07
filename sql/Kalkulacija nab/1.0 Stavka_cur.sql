            SELECT stavka,proizvod,kolicina,jed_mere,broj_koleta,lot_serija,
                   rok,lokacija,cena,faktor,kolicina_kontrolna,rabat,porez,cena1,k_robe,z_troskovi,

                                                                   round(round(kolicina*(cena1),4)
                                                                          -
                                                                         round(kolicina*cena*(1-rabat/100),4)
                                                                        ,2)

                                                                   ,Neto_KG,Proc_Vlage,Proc_Necistoce,HTL
            FROM Stavka_Dok
            WHERE broj_dok = &cBrojDok AND godina = &nGodina AND vrsta_dok = '3'
--            ORDER By stavka;
