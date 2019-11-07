 Select sd.Proizvod Sifra, Proizvod.Naziv,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz,
       ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz,
       ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje,
       Proizvod.Jed_Mere JedMere
 From Dokument d, Stavka_Dok sd, Proizvod
 Where d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok  = sd.Broj_Dok And d.Godina    = sd.Godina
   And sd.Proizvod = Proizvod.Sifra
   And d.Tip_Dok In ( 15, 203, 204, 99, 301, 401, 402, 61, 60 )
--   And d.PPartner Is Not Null
   And d.Org_Deo In (Select Magacin From Partner_Magacin_Flag Where PPartner like '%')
   And d.Status > 0
 --  And d.Datum_Dok Between To_Date ( '01.01.'||To_Char( dNaDan, 'yyyy' ),'dd.mm.yyyy' )
 --   And dNaDan
   And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
   And sd.K_Robe != 0
   And d.godina   = 2008
--   And proizvod   in (257,12679)
   And proizvod   in (12679)
--   And d.vrsta_dok <> 2
 Group By sd.Proizvod, Proizvod.Naziv, Proizvod.Jed_Mere
 Order By Proizvod.Naziv;
