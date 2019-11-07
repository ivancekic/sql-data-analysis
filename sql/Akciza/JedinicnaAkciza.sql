-- Cisto da imate za proveru
-- Ovako se odredjuje akciza koja se posle upisuje u stavka_dok
        Select p.KOLICINA_ZA_TAKSU * A.Iznos
        From Proizvod p, Akciza a
        Where P.Sifra = 19277 And
              P.Grupa_Poreza = A.Grupa_Poreza And
              A.Datum = ( Select Max(T1.Datum)
                          From Akciza T1
                          Where T1.Grupa_Poreza = P.Grupa_Poreza
                            And T1.Datum <=
                            sysdate)
--                                            to_date('06.09.2006','dd.mm.yyyy') );
