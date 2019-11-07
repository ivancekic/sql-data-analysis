Declare
      cVrstaDok VarChar2 ( 2 );
      cBrojDok VarChar2( 9 );
      nGodina Number;
Begin
dbms_output.put_Line(lpad('robni dokument',25)              ||' '||
                     lpad('Proizv. ',7)         ||' '||
                     lpad('Datum',10)           ||' '||
                     lpad('Datum_unosa',19)     ||' '||
                     lpad('broj',7)             ||' '||
                     lpad('godi',5)             ||' '||

                     lpad('dokument',3)              ||' '||
                     lpad('broj',7)             ||' '||
                     lpad('godi',5)             ||' '||

                     lpad('tip',3)              ||' '||
                     lpad('cena',7)             ||' '||
                     lpad('k',2)                ||' '||
                     lpad('kolicina',10)
                    );
dbms_output.put_Line(lpad('-',25,'-')   ||' '||
                     lpad('-',7,'-')   ||' '||
                     lpad('-',10,'-')  ||' '||
                     lpad('-',19,'-')  ||' '||
                     lpad('-',7,'-')   ||' '||
                     lpad('-',5,'-')   ||' '||

                     lpad('-',3,'-')   ||' '||
                     lpad('-',7,'-')   ||' '||
                     lpad('-',5,'-')   ||' '||

                     lpad('-',3,'-')   ||' '||
                     lpad('-',7,'-')   ||' '||
                     lpad('-',2,'-')   ||' '||
                     lpad('-',10,'-')
                    );

For kartica in (
Select Stavka_Dok.Proizvod,
       Dokument.Datum_Dok, Dokument.Datum_Unosa,
       Dokument.Vrsta_Dok, Dokument.Broj_Dok, Dokument.Godina,
       Dokument.Tip_Dok,
       PPlanskiCenovnik.Cena(Stavka_Dok.Proizvod,
                             Dokument.Datum_Dok,'YUD',1) PCena,
--                Stavka_Dok.Cena PCena,
       K_Robe, ( Sum ( Kolicina * Faktor ) ) Kolicina
From Dokument, Stavka_Dok
Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And
      Dokument.Broj_Dok = Stavka_Dok.Broj_Dok And
      Dokument.Godina = Stavka_Dok.Godina And
      Dokument.Status > 0 And
      Dokument.Datum_Dok Between to_date('01.01.2008','dd.mm.yyyy') And to_date('07.03.2008','dd.mm.yyyy') And
      Dokument.Org_Deo = 3773 And
      Stavka_Dok.K_Robe != 0 And
      Stavka_Dok.Proizvod Like NVL( '12679', '%' )
Group By Stavka_Dok.Proizvod,
         Dokument.Datum_Dok, Dokument.Datum_Unosa,
         Dokument.Vrsta_Dok, Dokument.Broj_Dok, Dokument.Godina,
         Dokument.Tip_Dok, Cena, K_Robe
Order By Stavka_Dok.Proizvod,
         Dokument.Datum_Dok, Dokument.Datum_Unosa,
         Dokument.Vrsta_Dok, Dokument.Broj_Dok, Dokument.Godina,
         Dokument.Tip_Dok, Cena, K_Robe
)
Loop
         MagKartica.NadjiRobniDokument( kartica.Vrsta_Dok,
                                        kartica.Godina,
                                        kartica.Broj_Dok,
                                        cVrstaDok, nGodina, cBrojDok );
        dbms_output.put_Line(lpad(cVrstaDok,3)              ||' '||
                             Rpad(pvrstadok.naziv(cVrstaDok),21)              ||' '||
                             lpad(kartica.Proizvod,7)         ||' '||
                             lpad(to_char(kartica.Datum_dok,'dd.mm.yyyy'),10)           ||' '||
                             lpad(to_char(kartica.Datum_unosa,'dd.mm.yyyy hh24:mi:ss'),19)           ||' '||
                             lpad(cBrojDok,7)             ||' '||
                             lpad(to_char(nGodina),5)             ||' '||

                             lpad(kartica.vrsta_dok,3)              ||' '||
                             lpad(kartica.Broj_Dok,7)             ||' '||
                             lpad(to_char(kartica.Godina),5)             ||' '||

                             lpad(to_char(kartica.tip_dok),3)              ||' '||
                             lpad(to_char(kartica.pcena,'999.90'),7)             ||' '||
                             lpad(to_char(kartica.k_robe),2)                ||' '||
                             lpad(to_char(kartica.kolicina,'999999.90'),10)
                            );


End Loop;
End ;
