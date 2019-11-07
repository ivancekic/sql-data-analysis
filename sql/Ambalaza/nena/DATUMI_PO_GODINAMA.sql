--PROBAJ DA SECES PO GODINAMA

     Select D.GODINA, PPartner PRT, sd.Proizvod PRO
          , (Select Max(d3.Datum_dok) from dokument d3, Stavka_Dok sd3 where d3.vrsta_dok = 21 and d3.org_Deo = d.org_deo and sd3.proizvod = sd.proizvod
               And d3.Vrsta_Dok = sd3.Vrsta_Dok And d3.Broj_Dok = sd3.Broj_Dok And d3.Godina = sd3.Godina
               And d3.godina = d.godina
             Group by Datum_dok
            ) MAX_DAT_PS
          , ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz
          , ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz
          , ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje
          , D.ORG_DEO MAG
     From Dokument d, Stavka_Dok sd
     Where d.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 )
       And d.Status > 0
       And d.Org_Deo In (Select Magacin From Partner_magacin_Flag)
       And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
       And sd.K_Robe != 0
       And d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
--       AND D.PPARTNER = 7767
     Group By D.GODINA, d.Ppartner, sd.Proizvod, d.Org_Deo
ORDER BY to_number(d.Ppartner), d.Org_Deo, D.GODINA, to_number(sd.Proizvod)

