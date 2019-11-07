Select sd.Proizvod,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz,
       ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje
From Dokument d, Stavka_Dok sd
Where d.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 )
  And d.Status > 0
  And d.Org_Deo = 2002
  AND PPARTNER = 172
  --And d.Datum_Dok Between To_Date('01.01.'||To_Char( dNaDan, 'yyyy' ),'dd.mm.yyyy') And SYSDATE
  And sd.Proizvod = 399
  and d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
Group By sd.Proizvod
Order By SD.PROIZVOD
