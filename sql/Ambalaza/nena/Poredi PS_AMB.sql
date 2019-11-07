     Select d.godina, d.vrsta_dok, d.broj_dok, d.tip_dok, d.datum_Dok
          , d.org_deo, PPartner PRT, sd.Proizvod PRO
          , Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 )    Ulaz
          , Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 )  Izlaz
          --     , ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje
     From Dokument d, Stavka_Dok sd
     Where d.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 )
       And d.Status > 0
       And d.Org_Deo In (Select Magacin From Partner_magacin_Flag)
       And d.Datum_Dok Between nvl((Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = d.org_deo), to_date('01.01.0001','dd.mm.yyyy'))
       And to_date('31.12.2009','dd.mm.yyyy')--sysdate
       And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
       And sd.K_Robe != 0
       And d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
     Order By d.godina, to_number(d.Ppartner),  d.Org_Deo, sd.Proizvod ;
