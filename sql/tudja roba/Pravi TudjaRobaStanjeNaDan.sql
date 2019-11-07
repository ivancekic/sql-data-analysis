create or replace
PACKAGE TudjaRobaStanjeNaDan Is
   Procedure SetParameter( nOrgDeo Number, cPartner Varchar2, dDatum Date );
   Function Page( nStrana NUMBER ) Return Boolean;
END;
/
create or replace
PACKAGE BODY TudjaRobaStanjeNaDan IS

   nOrgDeoOd    Number;
   nOrgDeoDo    Number;
   cNazivOrg    VarChar2( 41 );
   cPartnerOd   Varchar2(7);
   cPartnerDo   Varchar2(7);
   dDatum       Date;
   nLeftOfset   Number  := 25;
   lGotovo      Boolean;
   nMaxRow      Number;
   lPrva        Boolean := True;
   BrojDecimala number  := 4;

   Procedure SetParameter( nOrgDeo Number, cPartner Varchar2, dDatum Date ) Is

   Begin
      -- inicijalizacija
      TudjaRobaStanjeNaDan.nOrgDeoOd  := nOrgDeo;
      If nvl(nOrgDeoOd,-9080) <> -9080 Then
         nOrgDeoDo := nOrgDeoOd;
      Else
         nOrgDeoOd := 1;
         nOrgDeoDo := 9999999;
      End If;
      TudjaRobaStanjeNaDan.dDatum     := dDatum;
      TudjaRobaStanjeNaDan.cPartnerOd := cPartner;
      If nvl(cPartnerOd,' ') <> ' '  Then
         cPartnerDo := cPartnerOd;
      Else
         cPartnerOd := 1;
         cPartnerDo := 9999999;
      End If;


      lGotovo := FALSE;
      nMaxRow := PReport.MaxRows ;
      lPrva := True;
      PReport.Comment(  'Stanje zaliha na dan: '||
                        To_Char( dDatum, 'dd.mm.yyyy' ) );

   End;

   Procedure Naslov Is
   Begin
      If lPrva Then
         if nOrgDeoOd Is Not Null Then
            cNazivOrg := POrganizacioniDeo.Naziv( nOrgDeoOd );
         Else
            cNazivOrg := 'SVE MAGACINI TUDJE ROBE';
         End if;
         PReport.AddLine(  CPAD('S T A Nj E  Z A L I H A  T U Dj E  R O B E',132) );
         PReport.AddLine(  CPAD('------------------------------------------',132) );

         if nOrgDeoOd Is Not Null Then
            PReport.AddLine( RPAD( ' ', 10, ' ' )||
                             'Za magacin: '||
                             RPAD(to_char(nOrgDeoOd)||' '||cNazivOrg, 40 ) );
         else
            PReport.AddLine( RPAD( ' ', 10, ' ' )||
                             'ZA ' || cNazivOrg );
         end if;

         PReport.AddLine(  RPAD( ' ', 10, ' ' )||
                          'Na dan: '||
                          RPAD( To_Char( dDatum, 'dd.mm.yyyy'), 10 ) );
         PReport.AddLine(  '         ' );
      End If;
         lPrva := False;
   End;

   -- Procedure za ispis naziva kolona na svakoj strani
   Procedure Header Is
   Begin
--         PReport.AddLine( rpad(' ',nLeftOfset,' ') || 'Proizvod Naziv proizvoda                Koli'||Y('~')||'ina           JM              Cena            Vrednost' );
--         PReport.AddLine( rpad(' ',nLeftOfset,' ') || '-------- ------------------------------ ------------------ --- ---------------- -------------------' );
         PReport.AddLine( rpad(' ',nLeftOfset,' ') || 'Proizvod Naziv proizvoda                          Koli'||Y('~')||'ina  JM' );
         PReport.AddLine( rpad(' ',nLeftOfset,' ') || '-------- ------------------------------ ------------------ ---' );
   End;


   Function Page( nStrana NUMBER ) Return Boolean Is

      Cursor Stanje_Cur( dDatumPS In Date ) Is
----------
         SELECT PPartner, proizvod, Posebna_grupa, sum(Kol*faktor*k_robe) kol, sum(Vred) vred
         FROM TudjaRobaLager
         Where Org_Deo in (select org_deo from org_deo_osn_podaci where mag_tudje_robe = nOrgDeoOd and org_Deo = mag_tudje_robe)
           and ppartner between cPartnerOd And cPartnerDo
           and datum_dok between dDatumPS And dDatum
         Group by  PPartner, proizvod, Posebna_grupa
         HAVING sum(Kol) <> 0
         ORDER BY to_number(ppartner), to_number(proizvod);
----------
--         ORDER BY ppartner, posebna_grupa;
------------------------
      nKolicina       Number;
      nPVrednost      Number ;
      nCena           Number;
      nVrednost       Number;
      nOrg            Number;
      cPPart          VarChar2( 8 );
      cNazivPartnera  VarChar2( 40 );
      cOldPPart       Varchar2(8);
      cProizvod       VarChar2(8);
      cNazivProizvoda VarChar2(30);
      dDatumPS        Date;
      cJedMere        VarChar2( 3 );
      nUkupno         Number;
      nPosebnaGrupa   Number ;
      nUkupnoPPart    Number;
      nPPartMedjuS    Number := 0;
      lPPartMedjuS    Boolean := FALSE;
--      nRBrPPart       Number := 0;
--      nOldRBrPPart    Number := 0;

   Begin

      If Not lGotovo Then  -- ako izvestaj nije izgenerisan
         -- GENERISE GA KOMPLETNO !

         nUkupno := 0;
         nUkupnoPPart := 0;

         dDatumPS := to_date( '01.01.0001','dd.mm.yyyy');

         Open Stanje_Cur( dDatumPS );
         Loop
            Fetch Stanje_Cur Into cPPart, cProizvod, nPosebnaGrupa, nKolicina, nPVrednost;
            Exit When Stanje_Cur % NotFound;

            Naslov;

            cNazivPartnera  := PPoslovniPartner.Naziv(cPPart);
            cNazivProizvoda := PProizvod.Naziv( cProizvod );
            cJedMere        := PProizvod.JedMere( cProizvod );

--            nOldRBrPPart := nRBrPPart;

--                  PReport.AddLine( rpad(' ',nLeftOfset,' ') || RPAD( ' ', 58, ' ' )||
--                                   'OLD prt je '|| nvl(cOldPPart,'xxx') || ' New prt: '|| cPPart );
            If nvl(cOldPPart,cPPart) <> cPPart Then
               lPPartMedjuS := TRUE;
--               PReport.AddLine( rpad(' ',nLeftOfset,' ') || RPAD( ' ', 58, ' ' )||
--                                   'OLD prt je '|| nvl(cOldPPart,cPPart) || ' New prt: '|| cPPart ||' pro ' || cProizvod);

            Else
               lPPartMedjuS := FALSE;
            End If;

            If nvl(cOldPPart,' ') = ' ' Or cOldPPart <> cPPart Then
               PReport.AddLine( 'Poslovni partner: '|| LPAD( cPPart, 8 )||' '||
                                RPAD( cNazivPartnera, 30 ));
               Header;
            End If;

            -- izracuna cenu
            if nKolicina = 0 then
               nCena := nPVrednost;
            else
               nCena := round(nPVrednost/nKolicina,BrojDecimala) ;
            end if;

            -- faktor je 1 jer je kolicina prevedena u SJM
            nVrednost := nPVrednost;

            nUkupno   := nUkupno + nVrednost;


            If nVrednost != 0 Then
               PReport.AddLine( rpad(' ',nLeftOfset,' ') ||
                                LPAD( cProizvod, 8 )||' '||
                                RPAD( cNazivProizvoda, 30 )||
                                LPAD( To_Char( nKolicina,
                                    '9,999,999,990.9999' ), 19 )||' '||
                                LPAD( cJedMere, 3 )
--                                ||' '||
--                                RPAD( To_Char( NVL( nCena, 0 ),
--                                    '99,999,990.9999' ), 16 )||' '||
--                                RPAD( To_Char( NVL( nVrednost, 0 ),
--                                    '999,999,999,990.99' ), 19 ) ||' '||
--                               RPAD( '('||ltrim(rtrim(To_Char(nPosebnaGrupa,'999')))||')',5 )
                             );


                                   --||' old rbr ' || to_char(nOldRBrPPart) || ' rbr ' || to_char(nRBrPPart) );

--               If nPPartMedjuS = 0 Then
--                  PReport.AddLine( rpad(' ',nLeftOfset,' ') || RPAD( ' ', 78, ' ' )||
--                          RPAD( '-', 21, '-' ) );
--                  PReport.AddLine( rpad(' ',nLeftOfset,' ') || RPAD( ' ', 58, ' ' )||
--                          'Ukupno za partnera: '||
--                          RPAD( To_Char( NVL( nUkupnoPPart, 0 ),
--                                   '9,999,999,999,990.99' ), 21 ) );
--               End If;
            End If;
--
            cOldPPart := cPPart;


         End Loop;
         Close Stanje_Cur;

--         PReport.AddLine( rpad(' ',nLeftOfset,' ') || RPAD( ' ', 78, ' ' )||
--                          RPAD( '=', 21, '=' ) );
--         PReport.AddLine( rpad(' ',nLeftOfset,' ') || RPAD( ' ', 70, ' ' )||
--                          'Ukupno: '||
--                          RPAD( To_Char( NVL( nUkupno, 0 ),
--                                   '9,999,999,999,990.99' ), 21 ) );


         If lPrva = False Then
            PReport.NewPage;
         End If;

         lGotovo := TRUE ;
      End If;
      If nStrana >= 0 And nStrana <= PReport.LastPage Then
         Return TRUE;      -- znak da je trazena stranica izgenerisana
      Else
         Return NULL;      -- znak da trazena stranica ne postoji
      End If;
   End;

   END;

/
Drop public synonym TudjaRobaStanjeNaDan

/

Create public synonym TudjaRobaStanjeNaDan FOR vital.TudjaRobaStanjeNaDan ;
/
---- ako je paket ili funkcija
GRANT EXECUTE ON vital.TudjaRobaStanjeNaDan TO EXE
/
