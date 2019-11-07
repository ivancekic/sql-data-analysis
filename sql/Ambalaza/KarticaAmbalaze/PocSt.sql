Select ( Sum ( Kolicina * Faktor * K_Robe ) )
From Dokument, Stavka_Dok
Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And
      Dokument.Broj_Dok = Stavka_Dok.Broj_Dok And
      Dokument.Godina = Stavka_Dok.Godina And
      Dokument.Godina = To_Number( To_Char( to_date('07.03.2008','dd.mm.yyyy'), 'yyyy' )) And
      Dokument.Status = 1 And
      Dokument.Org_Deo = 3773 And
      Dokument.Vrsta_Dok = '21' And
      Stavka_Dok.K_Robe != 0 And
      Stavka_Dok.Proizvod = 12679 And
      Dokument.Datum_Unosa = ( Select Max( C1.Datum_Unosa )
                               From Dokument C1
                               Where C1.Vrsta_Dok = '21' And
                                     C1.Status = 1 And
                                     Dokument.Godina = To_Number( To_Char( to_date('07.03.2008','dd.mm.yyyy'), 'yyyy' )) And
                                     C1.Org_Deo = 3773 )
