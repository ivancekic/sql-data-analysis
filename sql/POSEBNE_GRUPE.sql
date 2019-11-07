Declare

  nOrgDeoOd number := 1 ;
  nOrgDeoDo number := 99999 ;
  datumPS Date;
  ZaMag Number;

      nKolicina Number;
      cProizvod VarChar2( 7 );
      cOldProizvod Varchar2(7);
      cNazivProizvoda VarChar2( 30 );
      dDatumPS Date := to_date( '01.01.2008','dd.mm.yyyy');
      cJedMere VarChar2( 3 );
      nPosebnaGrupa Number ;
      nKolicina1 Number;

      dDatum Date;

      Cursor Stanje_Cur( dDatumPS In Date , ZaMag Number ) Is
         Select Stavka_dok.Proizvod, Proizvod.posebna_grupa, Sum(Round(NVL(Kolicina*Faktor*K_Robe,0),2))
         From Dokument, Stavka_Dok, Proizvod
         Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And
               Dokument.Broj_Dok  = Stavka_Dok.Broj_Dok And
               Dokument.Godina    = Stavka_Dok.Godina And
               Dokument.Status > 0 And
               Dokument.Datum_Dok Between to_date('01.01.2008','DD.MM.YYYY')  And to_date( '25.02.2008','dd.mm.yyyy') And
               Stavka_Dok.K_Robe != 0 And
               Dokument.Org_Deo = ZaMag  And
               Proizvod.sifra = Stavka_dok.proizvod
         Group By Stavka_dok.Proizvod,Proizvod.posebna_grupa
         Order By Proizvod.posebna_grupa , Stavka_dok.Proizvod;



Begin
         dDatumPS := to_date( '01.01.2008','dd.mm.yyyy');

         nKolicina1 := 0;

           For magacini in (Select Distinct Org_deo From Dokument Where Status > 0 And Org_deo Between nOrgDeoOd And nOrgDeoDo order by Org_Deo)
           Loop
               Select Max(Datum_Dok) Into datumPS
               From Dokument
               Where Vrsta_Dok = '21' And Org_Deo =  magacini.Org_Deo  And
                     Status > 0 And
                     Datum_Dok = ( Select Max(D1.Datum_Dok)
                                   From Dokument D1
                                   Where D1.Vrsta_Dok = '21' And
                                         D1.Org_Deo = magacini.Org_Deo And
                                         D1.Status > 0 And
                                         D1.Datum_Dok <= to_date('25.02.2008','dd.mm.yyyy')
                                  )
               ;
               Open Stanje_Cur( dDatumPS , ZaMag );
               Loop
                 Fetch Stanje_Cur Into cProizvod, nPosebnaGrupa, nKolicina;
                 Exit When Stanje_Cur % NotFound;
                    cNazivProizvoda := PProizvod.Naziv( cProizvod );
                    cJedMere        := PProizvod.JedMere( cProizvod );

                    nKolicina1 := nKolicina1 + nKolicina;

                    Dbms_output.Put_line('Pro '||cProizvod|| '  jm '||cJedMere||' uk '||to_char(nKolicina));

               End loop;
               Close Stanje_Cur;
               Dbms_output.Put_line('Mag '||magacini.org_deo|| '  datumPS '||to_char(datumPS,'dd.mm.yyyy'));
           End Loop;
End;
