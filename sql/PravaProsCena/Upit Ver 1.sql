select ORG_DEO,PROIZVOD,ULAZ,IZLAZ,STANJE,DUGUJE,DUGUJE1,POTRAZUJE,SALDO, saldo1
     , (saldo/stanje) pros_cena
     , (saldo1/stanje) pros_cena
From
(
     Select
                d.org_deo,
                sd.proizvod,
                Sum(Realizovano*faktor*
                    PDokument.ZokiUlazIzlaz( d.vrsta_dok, d.tip_dok,sd.k_robe,'D',d.datum_dok)
                    ) Ulaz,
                Sum(Realizovano*faktor*
                    PDokument.ZokiUlazIzlaz( d.vrsta_dok, d.tip_dok,sd.k_robe,'P',d.datum_dok)
                    ) Izlaz,
                Sum(Realizovano*faktor*k_robe) Stanje,
                Sum(Realizovano*faktor*
                    PDokument.ZokiUlazIzlaz( d.vrsta_dok, d.tip_dok,sd.k_robe,'D',d.datum_dok)
                    *sd.Cena1
                    ) Duguje,

                Sum(case when d.vrsta_dok != '80' then
		                    Realizovano*faktor*
		                    PDokument.ZokiUlazIzlaz( d.vrsta_dok, d.tip_dok,sd.k_robe,'D',d.datum_dok)
		                    *sd.Cena1
		            else
		                    Realizovano*faktor*
--		                    PDokument.ZokiUlazIzlaz( d.vrsta_dok, d.tip_dok,sd.k_robe,'D',d.datum_dok)
		                    (sd.Cena1  - sd.cena)
		            end
                    ) Duguje1,

                Sum(Realizovano*faktor*
                    PDokument.ZokiUlazIzlaz( d.vrsta_dok, d.tip_dok,sd.k_robe,'P',d.datum_dok)
                    *sd.Cena1
                    ) Potrazuje,
                Sum(Realizovano*faktor*k_robe*sd.Cena1) Saldo

,               Sum(
                     case when d.vrsta_dok != '80' then
                          Realizovano*faktor*k_robe*sd.Cena1
                     else
                          Realizovano*(sd.Cena1-sd.Cena)
                     end
                   ) Saldo1
         From Dokument d,Stavka_Dok sd,Proizvod p
         Where d.Vrsta_Dok = sd.Vrsta_Dok
               And d.Broj_Dok = sd.Broj_Dok
               And d.Godina = sd.Godina
               And sd.Proizvod = p.Sifra
               And d.Status > 0
               And d.Org_deo = &nMagacin
               And Datum_Dok Between &odDatuma And &doDatuma
--               And datum_dok between to_date('01.01.2010','dd.mm.yyyy') and to_date('31.12.2010','dd.mm.yyyy')
--               And sd.K_robe != 0
               and (sd.K_Robe != 0 OR d.VRSTA_DOK = '80')
               and sd.proizvod = &cProizvod
     group by d.org_deo,sd.proizvod
) s
