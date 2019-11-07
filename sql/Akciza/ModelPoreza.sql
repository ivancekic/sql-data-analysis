        Select K_Akciza
        From Model_Poreza
        Where Vrsta_Izjave = 3 And
              Datum = ( Select Max( M1.Datum )
                        From Model_Poreza M1
                        Where M1.Vrsta_Izjave = 3
                              And M1.Datum <= to_date('14.09.2006','dd.mm.yyyy') );
