     Select
                dokument.org_deo,
                stavka_dok.proizvod,
                Sum(Realizovano*faktor*
                    PDokument.ZokiUlazIzlaz( dokument.vrsta_dok, dokument.tip_dok,stavka_dok.k_robe,'D',dokument.datum_dok)
                    ) Ulaz,
                Sum(Realizovano*faktor*
                    PDokument.ZokiUlazIzlaz( dokument.vrsta_dok, dokument.tip_dok,stavka_dok.k_robe,'P',dokument.datum_dok)
                    ) Izlaz,
                Sum(Realizovano*faktor*k_robe) Stanje,
                Sum(Realizovano*faktor*
                    PDokument.ZokiUlazIzlaz( dokument.vrsta_dok, dokument.tip_dok,stavka_dok.k_robe,'D',dokument.datum_dok)
                    *Stavka_dok.Cena1
                    ) Duguje,
                Sum(Realizovano*faktor*
                    PDokument.ZokiUlazIzlaz( dokument.vrsta_dok, dokument.tip_dok,stavka_dok.k_robe,'P',dokument.datum_dok)
                    *Stavka_dok.Cena1
                    ) Potrazuje,
                Sum(Realizovano*faktor*k_robe*Stavka_dok.Cena1) Saldo
         From Dokument,Stavka_Dok,Proizvod
         Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok
               And Dokument.Broj_Dok = Stavka_Dok.Broj_Dok
               And Dokument.Godina = Stavka_Dok.Godina
               And Stavka_dok.Proizvod = Proizvod.Sifra
               And Dokument.Status > 0
               And Dokument.Org_deo = &nMagacin
               And Datum_Dok Between &odDatuma And &doDatuma
--               And datum_dok between to_date('01.01.2010','dd.mm.yyyy') and to_date('31.12.2010','dd.mm.yyyy')
               And stavka_dok.K_robe != 0
               and stavka_dok.proizvod = &cProizvod
group by dokument.org_deo,stavka_dok.proizvod;
