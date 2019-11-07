Select sd.Proizvod, p.Naziv,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz,
       ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje,
       p.Jed_Mere JedMere
From Dokument d, Stavka_Dok sd, Proizvod p
Where d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina And
      sd.Proizvod = p.Sifra And d.Tip_Dok In ( 14, 15, 203, 204, 99, 301, 402, 61, 60 ) And
      d.Org_Deo In (Select Magacin From Partner_magacin_Flag Where PPartner = '1947') And
      d.Status > 0 And
      d.Datum_Dok Between To_Date('01.01.'||To_Char( sysdate, 'yyyy' ),'dd.mm.yyyy') And sysdate And
      sd.Proizvod In( Select Sifra From Proizvod Where Tip_Proizvoda = '8' ) And
      sd.Proizvod Like NVL( '399', '%' ) And
      sd.K_Robe != 0
Group By sd.Proizvod, p.Naziv, p.Jed_Mere
Order By p.Naziv;
