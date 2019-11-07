declare
  cVrstaDok Varchar2(3);
  nGodina   Number;
  cBrojDok  Varchar2(9);

  nUpisDejaPTab Number := 1000 ;
  cursor Palete_cur is
     Select d.godina, d.vrsta_dok, d.broj_dok, d.tip_dok, d.datum_Dok
          , d.org_deo, PPartner PRT, sd.Proizvod PRO
          , Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 )    Ulaz
          , Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 )  Izlaz
          --     , ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje
     From Dokument d, Stavka_Dok sd
     Where d.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 )
       And d.Status > 0
       And d.Org_Deo In (Select Magacin From Partner_magacin_Flag)
       And d.Datum_Dok Between nvl((Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = d.org_deo), to_date('01.01.0001','dd.mm.yyyy'))
       And to_date('31.12.2009','dd.mm.yyyy')--sysdate
       And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
       And sd.K_Robe != 0
       And d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
     Order By d.godina, to_number(d.Ppartner),  d.Org_Deo, sd.Proizvod ;

     Palete Palete_cur  % rowtype;

  cursor IzMag_cur(cVrd Varchar2, nGod Number, cBrojDok Varchar2) is
     Select * from dokument
     where godina = nGod And Vrsta_dok = cVrd And Broj_Dok = cBrojDok ;

     IzMag IzMag_cur % Rowtype;
begin
     Delete
     From Deja_pomocna_tab
     Where Polje39 = '1000';
     commit;

      Open Palete_cur;
      Loop
      Fetch Palete_cur Into Palete;
      Exit When Palete_cur % NOTFOUND;

           MagKartica.NadjiRobniDokument( Palete.Vrsta_Dok,
                                          Palete.Godina,
                                          Palete.Broj_Dok,
                                          cVrstaDok, nGodina, cBrojDok );

           Open IzMag_cur(cVrstaDok, nGodina, cBrojDok);
           Fetch IzMag_cur Into IzMag;
--                 dbms_output.put_line(to_char(Palete.GODINA)                       ||' '||
--                                      lpad(Palete.VRSTA_DOK,3)                     ||' '||
--                                      lpad(Palete.BROJ_DOK,5)                      ||' '||
--                                      lpad(to_char(Palete.TIP_DOK),3)              ||' '||
--                                      lpad(to_char(Palete.DATUM_DOK,'dd.mm.yy'),8) ||' '||
--                                      lpad(to_char(Palete.ORG_DEO),5)              ||' '||
--                                      lpad(Palete.PRT,7)                           ||' '||
--                                      lpad(Palete.PRO,7)                           ||' '||
--                                      lpad(to_char(Palete.ULAZ),5)                 ||' '||
--                                      lpad(to_char(Palete.IZLAZ),5)                ||' '||
--                                      lpad(to_char(IzMag.Org_Deo),5)
--                                     );


            Insert into deja_pomocna_tab(Polje1,Polje2,Polje3,Polje4,Polje5,Polje6,Polje7,Polje8,Polje9,Polje10,Polje11, polje39, polje40)
            Values(Palete.GODINA, Palete.VRSTA_DOK, Palete.BROJ_DOK, Palete.TIP_DOK, Palete.DATUM_DOK,
                   Palete.ORG_DEO, Palete.PRT, Palete.PRO, Palete.ULAZ, Palete.IZLAZ, IzMag.Org_Deo,
                   to_char(nUpisDejaPTab), to_char(nUpisDejaPTab)|| ' palete'
                   );
     commit;
           Close IzMag_cur;
      End Loop;
      Close Palete_cur;


end;
/
Select Polje1,Polje2,Polje3,Polje4,Polje5,Polje6,Polje7,Polje8,Polje9,Polje10,Polje11, polje39, polje40
From Deja_pomocna_tab
where Polje39 = '1000';
