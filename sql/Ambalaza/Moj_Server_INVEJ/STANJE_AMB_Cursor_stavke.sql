Select Stavka_Dok.Proizvod Sifra, Proizvod.Naziv,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz,
       ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje,
       Proizvod.Jed_Mere JedMere
From Dokument, Stavka_Dok, Proizvod
Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And
      Dokument.Broj_Dok = Stavka_Dok.Broj_Dok And
      Dokument.Godina = Stavka_Dok.Godina And
      Stavka_Dok.Proizvod = Proizvod.Sifra And
      Dokument.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 ) And
Dokument.Org_Deo In (Select Magacin
            From Partner_magacin_Flag, Poslovni_Partner
            Where PPartner = 11 )
--            And
--                  Teren = nSifraTerena And PPartner Like '%') And
     AND Dokument.Status > 0 And
      Dokument.Datum_Dok Between TO_DATE('01.01.2009','DD.MM.YYYY') And SYSDATE And
      Stavka_Dok.Proizvod In ( Select Sifra
                              From Proizvod
                              Where Tip_Proizvoda = '8' ) And
      Stavka_Dok.Proizvod Like NVL( '399' , '%' ) And
      Stavka_Dok.K_Robe != 0
Group By Stavka_Dok.Proizvod, Proizvod.Naziv, Proizvod.Jed_Mere
Order By Proizvod.Naziv;
