Declare
   cProAmb  Varchar2(7) := '399';
   cJedMere VarChar2( 3 ):= 'kom';
   nCena    Number;
   nAutomatskiDodaj Number := 0;--NULL;
   nGodina   Number := 2010;

   -- ################################################
   -- prijemnica mabalaze u magacin ambalaze kod kupca
   -- ################################################

   cLokacija VarChar2( 6 ) :='1';
   cBrojDok  VarChar2( 9 );
   cBrojDok1 VarChar2( 9 );
   nOrgDeo   NUmber := 2283;
   cBrojOtp  VarChar2( 9 ) := '3670';
   cVrOtp    Varchar2(2)   := '11';
   nKolAmb   Number := 1;

   -- #######################################################
   -- otpremnica mabalaze iz magacina odakle ide i roba kupcu
   -- #######################################################
   nOrgDeoM   Number;
   cLokacijaM VarChar2( 6 );
   cBrojDokM  VarChar2( 9 );
   cBrojDok1M VarChar2( 9 );
   nTipDok Number;

   -- ########################################################
   -- potrebno da proveri da li otpremnica ima nal. za otpremu
   -- ########################################################
   nGodinaVeznog        Number;
   cBrojVeznog          VarChar2(9);
   lPomocna             Boolean;-- Zbog poziva funkcije iz baze

   Cursor OtpRobe_cur is
     Select VRSTA_DOK,BROJ_DOK,GODINA,TIP_DOK,DATUM_DOK,DATUM_UNOSA,USER_ID,PPARTNER,REG_BROJ,STATUS,DATUM_STORNA,DATUM_VALUTE,PREVOZ
          , CENA_PREVOZA,ORG_DEO,NACIN_OTPREME,FRANKO,MESTO_ISPORUKE,PP_ISPORUKE,RADNI_NALOG,POSLOVNICA,VAZI_DO,VRSTA_IZJAVE,RABAT
          , SPEC_RABAT,KASA,TIP_KASE,ROK_KASE,DPO,VALUTA_PLACANJA,NACIN_PLACANJA,BROJ_DOK1
     From Dokument
     Where Godina    = nGodina
       And Vrsta_Dok = '11'
       And Broj_Dok  = cBrojOtp;
   OtpRobe OtpRobe_cur % Rowtype;
Begin

   -- ################################################
   -- prijemnica mabalaze u magacin ambalaze kod kupca
   -- ################################################

--   cBrojDok := To_Char( PSekvenca.NextVal( 'Broj_Prijemnice',nGodina ) );
--   cBrojDok1 := To_Char(PSekvencaOrg.NextVal('Broj_Prijemnice',nGodina, nOrgDeo ) );
----   cBrojDok  := '3322';
----   cBrojDok1 := '12';
   Open OtpRobe_cur;
   Fetch OtpRobe_cur INto OtpRobe;
--
--           -- upise novu prijemnicu u tabelu dokument
--           Insert Into Dokument( Vrsta_Dok, Broj_Dok,  Godina, Tip_Dok,         Datum_Dok, Datum_Unosa, User_Id, PPartner,
--                                 Status,         Datum_Valute, Org_Deo, Poslovnica        , Broj_Dok1 )
--                         Values(       '3',   '3322', nGodina,      15, OtpRobe.Datum_Dok,        Null,    Null, OtpRobe.PP_Isporuke,
--                                      0, OtpRobe.Datum_Valute, nOrgDeo, OtpRobe.Poslovnica,       '12');
--
--           commit;
--           -- sada napravi vezu otpremnice i prijemnice za ambalazu
--           PVezniDok.DodajPar( cVrOtp, nGodina, cBrojOtp,
--                                  '3', nGodina, '3322') ; --cBrojDok );
--
--
--
--          nCena := PPlanskiCenovnik.Cena( cProAmb, OtpRobe.Datum_Dok , 'YUD', 1 );
--          -- upise stavku ambalaze u stavku prijemnce
--          Insert Into Stavka_Dok( Vrsta_Dok, Broj_Dok, Godina, Stavka, Proizvod, Kolicina, Jed_Mere,
--                                  K_Rez, K_Robe, K_Ocek, Faktor, Kontrola,
--                                  Realizovano, Cena, Valuta, Lokacija ,Cena1)
--                          Values(       '3', cBrojDok, nGodina,     1,  cProAmb,  nKolAmb, cJedMere,
--                                      0,      1,      0,      1,        1,
--                                      nKolAmb, NVL( nCena, 0 ), 'YUD', cLokacija, NVL( nCena, 0 ) );
--
--
--          PKonacnaVerzija.Prijemnica( nGodina,
--                                      cBrojDok,
--                                      nOrgDeo,
--                                      nAutomatskiDodaj );
--------          GenerisiStanjeZaliha(nOrgDeo,sysdate,true);
--
--          -- ako je sve proslo bez greske, promeni status
--          Update Dokument Set Status = 1
--          Where Vrsta_Dok = '3' And Broj_Dok = cBrojDok And Godina = nGodina;
--
--          -- sada formira vezu da ne bi pravio probleme pri prevodjenju
--          -- u konacnu verziju
--          PVezniDok.DodajPar(  '3', nGodina, cBrojDok,
--                               '11',nGodina, cBrojOtp );
--
--          commit;
--
--   -- #######################################################
--   -- otpremnica mabalaze iz magacina odakle ide i roba kupcu
--   -- #######################################################
-- 	        If OtpRobe.Tip_Dok = 23 Then
--	           nTipDok := 23;
--       	    Else
--	           nTipDok := 201;
-- 	        End If;
--
--	        cBrojDokM  := OtpRobe.Broj_Dok;
--	        cBrojDok1M := OtpRobe.Broj_Dok1;
--
--            -- upise novu otpremnicu u tabelu dokument
--            Insert Into Dokument( Vrsta_Dok,  Broj_Dok, Godina, Tip_Dok,         Datum_Dok, Datum_Unosa, User_Id,
--                                          Org_Deo,        Poslovnica,         PPartner,          PP_Isporuke,
--                                          Mesto_Isporuke, Status, Datum_Valute, Cena_Prevoza, Nacin_Otpreme, Franko, Prevoz,
--                                           Vrsta_Izjave,   Broj_Dok1 )
--                          Values(      '61', cBrojDokM, nGodina, nTipDok, OtpRobe.Datum_Dok,       Null,    Null,
--                                  OtpRobe.Org_Deo, OtpRobe.Poslovnica, OtpRobe.PPartner, OtpRobe.PP_Isporuke,
--                                  OtpRobe.Mesto_Isporuke,      0,      SysDate,            0,             1,      1,    'P',
--                                  OtpRobe.Vrsta_Izjave, cBrojDok1M );
--
--            -- sada napravi vezu izvornog dokumenta i dokumenta za ambalazu
--            PVezniDok.DodajPar( '11', nGodina, OtpRobe.Broj_Dok,
--                                '61', nGodina,       cBrojDokM );
--            -- upise stavku ambalaze u otp ambalazu
--            Insert Into Stavka_Dok( Vrsta_Dok, Broj_Dok,   Godina, Stavka, Proizvod, Kolicina, Jed_Mere,
--                                    K_Rez, K_Robe, K_Ocek, Faktor, Kontrola,
--                                    Realizovano,            Cena, Valuta,   Lokacija,
--                                    Rabat, Porez,           Cena1 )
--                            Values(      '61', cBrojDokM, nGodina, 1, cProAmb, nKolAmb, cJedMere,
--                                        0,      1,      0,      1,        1,
--                                        nKolAmb, NVL( nCena, 0 ),   'YUD', cLokacija,
--                                        0,     0, NVL( nCena, 0 ) );
--        -- azuriranje tabela Zalihe i Zalihe_Analitika
--        -- pojava greske se obradjuje u Exception delu
--        PKonacnaVerzija.OtpremnicaAmbalaze(nGodina,
--                                           cBrojDokM,
--                                           OtpRobe.Org_Deo,
--                                           nAutomatskiDodaj );
--        -- ako je sve proslo bez greske, promeni status
--        Update Dokument Set Status = 1
--        Where Vrsta_Dok = '61' And Broj_Dok = cBrojDokM And Godina = nGodina;
--
--
--        -- ########################################################
--        -- potrebno da proveri da li otpremnica ima nal. za otpremu
--        -- ########################################################
--
--        lPomocna := PVezniDok.NadjiVezu( '11', nGodina, cBrojDokM,
--                                         '10', nGodinaVeznog, cBrojVeznog );
--
--        If cBrojVeznog Is Not Null And nGodinaVeznog Is Not Null Then
--           PVezniDok.DodajPar(  '61',       nGodina,   cBrojDokM,
--                                '10', nGodinaVeznog, cBrojVeznog );
--        End If;


        -- na kraju upis u tabelu iz koje se stampa ambalaza na otpremnicama i fakturama
--        Insert into stavka_ambalaze( VRSTA_DOK,  BROJ_DOK,  GODINA, STAVKA_AMBALAZE,STAVKA_DOK,   SIFRA, KOLICINA)
--                             values(      '11', cBrojDokM, nGodina,               1,         1, cProAmb,  nKolAmb);
--        commit;

   Close OtpRobe_cur;
End;

