        Select Akciza.Stopa, Akciza.Iznos
               Into nStopaBezIzjave, nIznosBezIzjave
        From Proizvod, Akciza
        Where Proizvod.Sifra = cProizvod And
              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
              Akciza.Datum = ( Select Max(T1.Datum)
                                      From Akciza T1
                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
                                            And T1.Datum <= dDatum );
