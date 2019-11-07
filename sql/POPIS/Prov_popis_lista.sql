Declare

dNaDan          Date := to_date('19.09.2009','dd.mm.yyyy');
cBrListOd       Varchar2(3) := '0';
cBrListDo       Varchar2(3) := '100';
dDatZaFunStanje Date;
nRazlika        Number ;--     := 0;

CURSOR  PopisLista_Wiew IS
   Select p.godina, P.POPISNA_LISTA, p.org_deo, p.datum, p.DATUM_UNOSA, count(sp.proizvod) uk_stavki
   From STAVKA_POPISA SP, POPIS P
   WHERE P.datum         = dNaDan
     and P.POPISNA_LISTA between cBrListOd and cBrListDo
     AND P.POPISNA_LISTA = SP.POPISNA_LISTA
     AND P.GODINA        = SP.GODINA

   Group by p.godina, P.POPISNA_LISTA, p.org_deo, p.datum, p.DATUM_UNOSA
   Order by to_number(P.POPISNA_LISTA);

PopisLista PopisLista_Wiew % ROWTYPE;

CURSOR  PopisListaSt_Wiew (nGod Number, cBr Varchar2) IS
   Select sp.proizvod, sp.po_knjigama
   From STAVKA_POPISA SP
   WHERE SP.GODINA        = nGod
     AND SP.POPISNA_LISTA = cBr
   Order by Stavka  ;

PopisListaSt PopisListaSt_Wiew % ROWTYPE;

----------------------------------------------------------------------------------------------------------------------------------------
Function ProDatZaStanje( nOrg Number, cPro Varchar2, dDatUnosa Date) return Date is
Cursor MaxDatPs_cur( nOrg Number, cPro Varchar2, dDatUnosa Date) Is
       Select max(d1.datum_dok) From Dokument d1, stavka_dok sd1
       Where d1.vrsta_dok = 21 and d1.org_deo   = nOrg
         and sd1.godina   = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
         and sd1.proizvod = cPro
         and d1.datum_dok   < dNaDan
         and d1.datum_unosa < dDatUnosa
       Group by d1.org_deo;

Cursor MinDatDok_cur( nOrg Number, cPro Varchar2, dDatUnosa Date) Is
       Select min(d1.datum_dok) From Dokument d1, stavka_dok sd1
       Where d1.org_deo   = nOrg and sd1.K_robe <> 0
         and sd1.godina   = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
         and sd1.proizvod = cPro
         and d1.datum_dok   < dNaDan
         and d1.datum_unosa < dDatUnosa
       Group by d1.org_deo;
dDatZaStanje date;

Begin
  OPEN MaxDatPs_cur ( nOrg, cPro, dDatUnosa) ;
  FETCH MaxDatPs_cur INTO dDatZaStanje ;
     If MaxDatPs_cur % NOTFOUND Then  -- Ne postoji proizvod u pocetnim stanjima za odgovarajuce parametre ( nOrg, cPro, dDatUnosa)
                                      -- onda trazimo najmanji datum dokumenta za proizvod sa istim parametrima
       ------------------------------------------------------------
       OPEN MinDatDok_cur ( nOrg, cPro, dDatUnosa) ;
       FETCH MinDatDok_cur INTO dDatZaStanje ;
          If MinDatDok_cur % NOTFOUND Then  -- Ne postoji min datum dok za proizvod za odgovarajuce parametre ( nOrg, cPro, dDatUnosa)
             dDatZaStanje := NULL;
          End If;
       Close MinDatDok_cur;
       ------------------------------------------------------------
    End If;
  Close MaxDatPs_cur;
  Return dDatZaStanje;
End;
----------------------------------------------------------------------------------------------------------------------------------------
Function ProStanjeNaDat(  nOrg Number, cPro Varchar2, dDatUnosa Date, dDat Date) return Number is
Cursor ProStanjeNaDat_cur(  nOrg Number, cPro Varchar2, dDatUnosa Date, dDat Date) Is
       Select sum(sd1.kolicina*sd1.faktor*sd1.k_robe) From Dokument d1, stavka_dok sd1
       Where d1.vrsta_dok = 21 and d1.org_deo   = nOrg
         and sd1.godina   = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
         and sd1.proizvod = cPro
         and d1.datum_dok   <= dNaDan
         and d1.datum_dok   >= dDat
         and d1.datum_unosa < dDatUnosa;
nStanje Number;
Begin
  OPEN ProStanjeNaDat_cur ( nOrg, cPro, dDatUnosa, dDat) ;
  FETCH ProStanjeNaDat_cur INTO nStanje ;
     If ProStanjeNaDat_cur % NOTFOUND Then  -- Ako proizvod nema stanje za
        nStanje := NULL;
     End If;
  Close ProStanjeNaDat_cur;
  Return nStanje;
End;
----------------------------------------------------------------------------------------------------------------------------------------
Begin


--  DBMS_OUTPUT.PUT_LINE (rpad(' ',20,' ')||('POPISNE LISTE NA DAN '|| to_char(dNaDan,'dd.mm.yyyy')),100);
  DBMS_OUTPUT.PUT_LINE (rpad(' ',20,' ')||('POPISNE LISTE NA DAN '|| to_char(dNaDan,'dd.mm.yyyy')));
  DBMS_OUTPUT.PUT_LINE (rpad(' ',20,' '));

  OPEN PopisLista_Wiew ;
  LOOP
  FETCH PopisLista_Wiew INTO PopisLista ;
  EXIT WHEN PopisLista_Wiew % NOTFOUND ;

  DBMS_OUTPUT.PUT_LINE (lpad('God.',5)     ||' '||
                        lpad('Br PL.',6)   ||' '||
                        rpad('Datum',10)   ||' '||
                        rpad('Datum_un',19)||' '||
                        lpad('Mag',5)      ||' '||
                        rpad('Uk st',5));

  DBMS_OUTPUT.PUT_LINE (rpad('-',5,'-')    ||' '||
                        rpad('-',6,'-')    ||' '||
                        rpad('-',10,'-')   ||' '||
                        rpad('-',19,'-')   ||' '||
                        rpad('-',5,'-')    ||' '||
                        rpad('-',5,'-')
                       );

  DBMS_OUTPUT.PUT_LINE (rpad(to_char(PopisLista.godina,'9990'),5)                        ||' '||
                        lpad(PopisLista.POPISNA_LISTA,6)                                 ||' '||
                        rpad(to_char(PopisLista.Datum,'dd.mm.yyyy'),10)                  ||' '||
                        rpad(to_char(PopisLista.Datum_unosa,'dd.mm.yyyy hh24:mi:ss'),19) ||' '||
                        rpad(to_char(PopisLista.Org_deo,'9990'),5)                       ||' '||
                        rpad(to_char(PopisLista.Uk_stavki,'9990'),5)
                        );

      DBMS_OUTPUT.PUT_LINE (lpad('Proizv',7)         ||' '||
                            lpad('Po knjigama',18)   ||' '||
                            lpad('Dat stanja',10)    ||' '||
                            lpad('Stanje',18)        ||' '||
                            lpad('Razlika',18)
                           );
      DBMS_OUTPUT.PUT_LINE (rpad('-',7,'-')          ||' '||
                            rpad('-',18,'-')         ||' '||
                            rpad('-',10,'-')         ||' '||
                            rpad('-',18,'-')         ||' '||
                            rpad('-',18,'-')
                           );

      OPEN PopisListaSt_Wiew (PopisLista.godina, PopisLista.POPISNA_LISTA) ;
      LOOP
      FETCH PopisListaSt_Wiew INTO PopisListaSt ;
      EXIT WHEN PopisListaSt_Wiew % NOTFOUND ;
           dDatZaFunStanje := ProDatZaStanje( PopisLista.Org_deo, PopisListaSt.Proizvod, PopisLista.Datum_unosa);
           nRazlika := 0;
           If nvl(PopisListaSt.Po_knjigama,0) -
              nvl(ProStanjeNaDat( PopisLista.Org_deo,PopisListaSt.Proizvod,PopisLista.Datum_unosa,dDatZaFunStanje),0) <> 0 Then
              nRazlika := nvl(PopisListaSt.Po_knjigama,0) -
                          nvl(ProStanjeNaDat( PopisLista.Org_deo,PopisListaSt.Proizvod,PopisLista.Datum_unosa,dDatZaFunStanje),0);
           End If;
           DBMS_OUTPUT.PUT_LINE (Lpad(PopisListaSt.Proizvod,7) ||' '||
                                 rpad(to_char(PopisListaSt.Po_knjigama,'999,999,990.99990'),18) ||' '||
                                 rpad(to_char(ProDatZaStanje( PopisLista.Org_deo,
                                                              PopisListaSt.Proizvod,
                                                              PopisLista.Datum_unosa),'dd.mm.yyyy'),10)||' '||
                                 rpad(to_char(ProStanjeNaDat( PopisLista.Org_deo,
                                                              PopisListaSt.Proizvod,
                                                              PopisLista.Datum_unosa,
                                                              dDatZaFunStanje),'999,999,990.99990'),18)||' '||
                                 rpad(to_char(nRazlika,'999,999,990.99990'),18)
                                );
      END lOOP;
      CLOSE PopisListaSt_Wiew ;
            DBMS_OUTPUT.PUT_LINE ('---------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE (rpad(' ',20,' '));
  END lOOP;
  CLOSE PopisLista_Wiew ;
End;
