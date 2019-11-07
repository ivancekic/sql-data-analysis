          Select
          z.rowid, z.*
--          ,
--
--          Lokacija, Grupa, Proizvod,
--                 Lot_Serija, Za_popise.Rok, Kolicina, Kontrolna_Kolicina
          From Za_Popise z, Proizvod
          Where
          Org_Deo = &nOrg_Deo
--          And
--                NVL(Lokacija,' ') Like cLokacija And
--                Grupa Like cGrupa And
--                Proizvod Like cProizvod And
and Proizvod.Sifra = z.proizvod
          Order By Posebna_grupa,To_Number(Proizvod), Lokacija;
