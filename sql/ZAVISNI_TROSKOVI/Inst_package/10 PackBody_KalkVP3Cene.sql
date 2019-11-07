CREATE OR REPLACE PACKAGE BODY INVEJ.KalkulacijaVP3Cene IS
   lGotovo     Boolean;
   nMaxRow     Number;
   lPrva       Boolean;
   cBrojDok    VarChar2(9);
   cBrojDokP    VarChar2(9);
   nGodina     Number;
   
   bBoolean boolean:=false;
   nRekIznos    number;
   nRekRabat    number;
   nRekOsnovica number;
   nRekPDV      number;
   nRekFakturisano number;
   sStr1  varchar2(132);
   sStr2  varchar2(132);
   nKasa number := 0;   

   -- ovde ih definisemo jer nam trebaju u proceduri header1
   dDatumDok            Date;
   nStatus              Number;
   cPPartner            VarChar2(7);
   nOrgDeo              Number;
   dDatumValute         Date;
   dDatumStorna         Date;
   dDatumUnosa          Date;
   nPoslovnica          Number;
   nTipDok              Number;
   cValuta              VarChar2(3);
   cStampaValuta        VarChar2(3);
   cNewValuta           VarChar2(3);
   cUserId              VarChar2(30);
   cNazivTipaDokumenta  VarChar2(20);
   cNazivStatusa        VarChar2(25);
   cNazivOrgDela        VarChar2(40);
   cNazivPoslovnice     VarChar2(40);
   cNazivPPartnera      VarChar2(40);
   cAdresa              VarChar2(40);
   cMesto               VarChar2(40);
   cNazivValute         VarChar2(40) :=' ';
   nGodinaVeznog        Number;
   cBrojVeznog          VarChar2(9);             
   lPomocna             Boolean;-- Zbog poziva funkcije iz baze
   lHeader              Boolean;-- Zbog stampanja Header2 uvek posle Header1      
   
--   nOrgDeo           Number ;   
--   cTipIzvoza        Varchar2(30);
   cPPartnerDecimale VarChar2(7);
   cBrDecimalaCena   VarChar2(255);      

   Procedure SetParameter( nGod In Number, cBr In VarChar2,
                           cVal In VarChar2 := NULL ) Is
   Begin
      -- inicijalizacija
      KalkulacijaVP3Cene.cBrojDok   := cBr;
      KalkulacijaVP3Cene.nGodina    := nGod;
      KalkulacijaVP3Cene.cNewValuta := cVal;

      Select Broj_dok1 Into KalkulacijaVP3Cene.cBrojDokP
      from Dokument
      where Godina = KalkulacijaVP3Cene.nGodina And 
            Broj_dok = KalkulacijaVP3Cene.cBrojDok And 
            Vrsta_dok = '73' ;
            
      KalkulacijaVP3Cene.cBrojDokP :=nvl(KalkulacijaVP3Cene.cBrojDokP,KalkulacijaVP3Cene.cBrojDok) ;   
      
      Select PPartner Into cPPartnerDecimale From Dokument d Where d.Broj_Dok = cBrojDok AND d.Godina = nGodina AND d.Vrsta_Dok = '73';      
      cBrDecimalaCena := PMapiranje.BrojDecimalaNaseFirme( 'INVEJ' , '2',  cPPartnerDecimale);
        
      lGotovo := FALSE;
      nMaxRow := PReport.MaxRows ;
      lPrva := True;
      PReport.Comment( 'Kalkulacija VPC broj: '||'xx-yyyyy/gggg' );
   End;


   -- za RUBIN
   Procedure Header4 Is -- ispisuje zaglavlje prijemnice na svakoj strani
   Begin
     If --PReport.LastRow = nMaxRow OR 
         lPrva = True Then
            -- preuzima nazive iz odgovarajucih tabela pomocu f-ja iz baze
            cNazivOrgdela       := POrganizacioniDeo.Naziv( nOrgDeo );
            cNazivPoslovnice    := POrganizacioniDeo.Naziv( nPoslovnica );
            cNazivPPartnera     := PPoslovniPartner.Naziv( cPPartner );
            cAdresa             := PPoslovniPartner.Adresa( cPPartner );
            cMesto              := PPOslovniPartner.Adresa2( cPPartner );
            cNazivStatusa       := PStatus.Naziv( 3 , nStatus );
            cNazivTipaDokumenta := PNacinFakt.Naziv( nTipDok );
            -- oredjuje u kojoj valuti je cena,na osnovu prve stavke
            -- ako valuta nije definisana podrazumeva se da je YUD
            Begin
              Select valuta
              Into cValuta
              From Stavka_Dok
              Where Broj_Dok = cBrojDok AND godina = nGodina AND
                    vrsta_dok = '73' AND stavka = 1;
            Exception
              When NO_DATA_FOUND Then
              cValuta := 'YUD';
            End;
            cStampaValuta := cValuta;
            If cNewValuta Is Not Null And cValuta != cNewValuta Then
               cStampaValuta := cNewValuta;
            End If;
            -- sada izvlaci pun naziv valute
            cNazivValute := PValuta.Naziv( cStampaValuta );
            -- stampa zaglavlje
            
            sStr1 := Pvlasnik.Naziv(1)||'   (PIB:'||pvlasnik.PIB(1)||')';
            sStr2 := 'Status: '||cNazivStatusa;
            preport.addline(rpad(sStr1||rpad(' ',132-length(sStr1)-length(sstr2),' ')|| sStr2
                           ,132,' '),bBoolean );
            preport.addline(rpad(Pvlasnik.Adresa(1),132,' '),bBoolean);
            preport.addline(rpad(Pvlasnik.PBroj(1)||' '||Pvlasnik.Mesto(1),132,' '),bBoolean);                                  
            
            preport.addline(cpad('KALKULACIJA VELEPRODAJNE CENE BROJ: '||nOrgDeo||'-'||cBrojDokP||'/'||nGodina||' (ID='||cBrojDok||')    Od '||To_Char(dDatumDok,'dd.mm.yyyy'),132,' '),bBoolean );
            preport.addline(cpad('('||trim(cNazivOrgDela)||')',132,' '),bBoolean);
            
            preport.addline(rpad(' ',132,' '),bBoolean);           
            
            -----------------------------------------
            -----------------------------------------
            -----------------------------------------
            -----------------------------------------
            -----------------------------------------
            PReport.AddLine(  rpad(' ',39,' ')
                            ||rpad(rpad('Dobavljac...('||NVL(cPPartner,' ')||')...',20,'.')||': '||NVL(cNazivPPartnera,' ')||' (PIB:'||nvl(PPoslovniPartner.EanPib(cppartner),' ')||')',93,' ')
                           ,bBoolean);    

            PReport.AddLine(  rpad(' ',39,' ')
                            ||rpad('Adresa dobavljaca...: '||cAdresa, 61,' '),bBoolean);
            PReport.AddLine(rpad(  ' ',39,' ')||
                                   'Mesto dobavljaca....: '||cMesto,bBoolean);
                                   
            lPomocna := PVezniDok.NadjiVezu( '73', nGodina, cBrojDok,
                                            '24', nGodinaVeznog, cBrojVeznog );
                                            
            PReport.AddLine(rpad( ' ',39,' ')||
                            'Dokument dobavljaca.: '||cBrojVeznog||'/'||To_Char(nGodinaVeznog),bBoolean);
                            
                           
            PReport.AddLine(rpad( ' ',39,' ')||'Valuta: '||(cStampaValuta || ' ('|| cNazivValute ||')'));

            -----------------------------------------
            -----------------------------------------
            -----------------------------------------
            -----------------------------------------
            -----------------------------------------
            lHeader := True;
            lPrva := False;
     End If;
   End;

   Procedure Header5 Is -- ispisuje na kraju svake strane header5
                        -- i to u poslednjoj liniji (za Rubin)
   Begin
--     If PReport.LastRow = nMaxRow - 5  Then
       PReport.AddLine(rpad(' ',132,' '),bBoolean) ;
       PReport.AddLine(rpad(' ',132,' '),bBoolean) ;
       PReport.AddLine(cpad('    Sastavio                                                Kontrolisao    ',132,' '),bBoolean);
       PReport.AddLine(cpad('___________________                                     ___________________',132,' '),bBoolean);
       PReport.AddLine(rpad(' ',132,' '),bBoolean) ;
       lPrva := False ;
--     End if ;
   End ;

   Procedure HeaderRubin Is -- ispisuje nazive kolona stavke(ispod zaglavlja)
                        -- i podvlaci ih
   Begin
     If PReport.LastRow > 60 or lHeader = True 
        Then
        
       if not lheader then 
          preport.NewPage ;
       end if; 
       preport.addline('------------------------------------------------------------------------------------------------------------------------------------',bBoolean);
       PReport.AddLine('R.Br. ŠIFRA   NAZIV PROIZVODA              JM    PDV-STOPA                    KOLIÈINA        NAB.CENA                          ',bBoolean);
       PReport.AddLine('            iznos    rabat/kasa      osnovica    PDV-IZNOS    fakt.Vredn. zav.troskovi     razl.u ceni      VP vrednost      VP cena',bBoolean);
       PReport.AddLine('----------------- ------------- ------------- ------------ -------------- ------------ --------------- ---------------- ------------',bBoolean);

       lHeader := False ;
     End if ;
   End ;

 -- Izvestaj za Zupu i ostale
 
 -- Izvestaj za Rubin
 Function Page2( nStrana NUMBER ) Return Boolean Is
      Cursor KalkVP3cene_cur IS  --Kursor nad tabelom Dokument
            -- izdvaja prijemnicu sa odgovarajucim brojem i godinom
            SELECT datum_dok,tip_dok,status,ppartner,
                   org_deo,datum_valute,poslovnica,
                   datum_storna,datum_unosa,user_id,NVL(KASA,0) KASA
            FROM Dokument
            WHERE vrsta_dok = '73' AND
                  godina = nGodina AND
                  broj_dok = cBrojDok;

      Cursor KalkVP3ceneStav1_cur IS  --Kursor nad tabelom Stavka_Dok
			 select st.STAVKA,st.PROIZVOD,st.NAZIV,st.JED_MERE,st.PDV_STOPA, st.KOLICINA, 
			        st.CENA,
			        st.IZNOS, st.PROC_RABATA, st.PROC_KASE, st.RABAT+st.KASA RABAT_KASA,
			        st.OSNOVICA, st.PDV PDV_IZNOS, st.osnovica+st.pdv FAKT_VREDNOST, st.Z_TROSKOVI, ST.VP_VREDNOST-ST.OSNOVICA-ST.Z_troskovi raz_u_ceni, st.VP_VREDNOST,
			        st.VPCENA      
                    from ( SELECT st.stavka, st.proizvod, p.naziv,st.jed_mere, st.kolicina, 
--                           st.cena, 
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End) Cena,
--                           (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
--                                 (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
--                                  Else st.cena
--                                  End)
--                            Else st.cena
--                            End     
--                           )Cena,
                           st.cena1 VPCENA, st.rabat proc_rabata, nvl(d.kasa,0) proc_kase,
                           nvl(st.z_troskovi,0) z_troskovi,
                           ---------------------------------------------------------------------------------------------------------------
--                           round(NVL(st.Kolicina*st.faktor*st.K_Robe*st.Cena,0),2) IZNOS,
                           round(NVL(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End)                            ,0),2) IZNOS,
                           ---------------------------------------------------------------------------------------------------------------
--                           round(nvl(st.Kolicina*st.faktor*st.K_Robe*st.Cena*(st.Rabat/100),0),2) RABAT,
                           round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End)*(st.Rabat/100),0),2) RABAT,
                           ---------------------------------------------------------------------------------------------------------------
                           round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End)*(1-st.Rabat/100),0) * (CASE WHEN nvl(ST.RABAT,0)<>0 THEN
                                                         nvl(d.kasa,0)/100
                                                    ELSE 0
													END)
                           ,2) KASA,
                           ---------------------------------------------------------------------------------------------------------------
                           round(NVL(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End),0),2) - 
                           round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End)*(st.Rabat/100),0),2) -
                           round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End)*(1-st.Rabat/100),0) * (CASE WHEN nvl(ST.RABAT,0)<>0 THEN
  														 nvl(d.kasa,0)/100
													ELSE 0
 													END),2) OSNOVICA,
                           ---------------------------------------------------------------------------------------------------------------
                           st.porez PDV_STOPA,
                           ---------------------------------------------------------------------------------------------------------------
                           ROUND(
                                  (round(NVL(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End)                                   ,0),2) -
                                   round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End)
                                   *(st.Rabat/100),0),2) -
                                   round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
                                     (Case When cBrDecimalaCena = 2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                           When cBrDecimalaCena = -2 Then
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
                                      else
                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
                                      End
                                     )
                                 Else st.cena
                                 End)
                          Else st.cena
                          End)
                                   *(1-st.Rabat/100),0) * (CASE WHEN nvl(ST.RABAT,0)<>0 THEN
 											  				    nvl(d.kasa,0)/100
														   ELSE 0
														   END),2)
								  ) * ST.POREZ/100
								  ,2) PDV,
                           ---------------------------------------------------------------------------------------------------------------
                           round(NVL(st.Kolicina*st.faktor*st.K_Robe*st.Cena1,0),2) VP_VREDNOST
                           ---------------------------------------------------------------------------------------------------------------
                           FROM Dokument d, Stavka_Dok st, proizvod p
                           WHERE d.vrsta_dok = st.vrsta_dok and d.godina    = st.godina and d.broj_dok  = st.broj_dok
                             and st.proizvod = p.sifra
                           ------------------------------------------------------------
							 and d.vrsta_dok = '73'
							 and d.godina    = nGodina
							 and d.broj_dok  = cBrojDok
                           ------------------------------------------------------------
   						   ORDER By stavka
                           ) st;
														 
			 Stavka KalkVP3ceneStav1_cur % ROWTYPE;

             nStavka              Number ;
             cProizvod            VarChar2(7);
             nKolicina            Number;
             nKolicinaKontrolna   Number;
             cKontrolnaJedMere    VarChar2(3);
                        
             cNazivProizvoda      VarChar2(30);
             nIznos               Number := 0;
             --
             nUkupno              Number := 0;
             --
             nUNabavna            Number := 0;
             nURabat              Number := 0;
						
             nUPorez              Number := 0;
             nUZTroskovi          number := 0;
             ---------------
             nUZTroStavkeIznos    number := 0;
             nUZTroStavkePDV      number := 0;
             nUZTroStavkeUKUPNO   number := 0;
             cTekstZavisnihTroskova varchar2(132);
             bZTroskoviPrviPut    boolean;
             bStavkaDokPrviPut    boolean;
             nUkRazUCeni          number := 0;
             nUkVpVrednost        number := 0;

   Begin
      If Not lGotovo Then  -- ako izvestaj nije izgenerisan
         -- GENERISE GA KOMPLETNO !

         Open KalkVP3cene_cur;
         Loop
            Fetch KalkVP3cene_cur INTO dDatumDok,nTipDok,nStatus,cPPartner,nOrgDeo,
                                       dDatumValute,nPoslovnica,dDatumStorna,
                                       dDatumUnosa,cUserId,nKasa;
            Exit When KalkVP3cene_cur%NOTFOUND;
              nStavka := 0;-- za slucaj da prijemnica nema ni jednu stavku
              bStavkaDokPrviPut := true;
              Open KalkVP3ceneStav1_cur;
              Loop
                  Fetch KalkVP3ceneStav1_cur INTO stavka;
                  Exit When KalkVP3ceneStav1_cur%NOTFOUND;

  				    nstavka := nstavka + 1;
                    Header4;
                    HeaderRubin;
                    -- izvlaci naziv proizvoda iz tabele proizvod
                    cNazivProizvoda := PProizvod.Naziv( cProizvod );
                    nIznos := nIznos + stavka.iznos;
                    -- i ubacuje ga u ukopno
                    nUkupno       := nUkupno         + stavka.Iznos;
                    nUNabavna     := nUNabavna       + stavka.osnovica;
                    nURabat       := nURabat         + stavka.rabat_kasa ;
                    nUPorez       := nUPorez         + stavka.pdv_iznos;
                    nUZTroskovi   := nUZTroskovi     + stavka.z_troskovi;
                    nUkRazUCeni   := nUkRazUCeni     + stavka.raz_u_ceni;
                    nUkVpVrednost := nUkVpVrednost   + stavka.vp_vrednost ;
                    
                    if bStavkaDokPrviPut then
                       bStavkaDokPrviPut := false;
                    end if;              
                    PReport.AddLine(rpad(RPAD(Stavka.stavka||'.',6,' ')||
                                         RPAD(trim(stavka.Proizvod),6,' ')||
                                         RPAD(stavka.naziv,30,' ')||LPAD(stavka.jed_mere,3,' ')||'      '||
                                         to_char(stavka.pdv_stopa,'90.90')||'%      '||
                                         RPAD(To_Char(stavka.kolicina,'99,999,999.99999'),17,' ')||'('||RPAD(stavka.jed_mere,3,' ')||')'||
                                         RPAD(To_Char(stavka.cena,'99,999,999.9990'),16,' ')
                                         ,132,' '),bBoolean);                                    
                    PReport.AddLine('   '||
                                        RPAD(To_Char(stavka.iznos,'999999,999.90'),14,' ')||
                                        LPAD(To_Char(stavka.rabat_kasa,'9,999,999.90'),14,' ')||
                                        RPAD(To_Char(stavka.osnovica,'99,999,999.90'),14,' ')||
                                        RPAD(To_Char(stavka.pdv_iznos,'9,999,999.90'),13,' ')||
                                        RPAD(To_Char(stavka.fakt_vrednost,'999,999,999.90'),15,' ')||
                                        RPAD(To_Char(round(nvl(stavka.Z_Troskovi,0),2),'99999,990.90'),13,' ')||
                                        RPAD(To_Char(stavka.raz_u_ceni,'9999,999,990.90'),16,' ')||                                                  
                                        RPAD(To_Char(stavka.vp_vrednost,'99999,999,990.90'),17,' ')||
                                        RPAD(To_Char(stavka.vpcena,'9999990.9990'),13,' ')
                                        ,bBoolean);
                    If nKolicinaKontrolna Is Not Null Then
                       ckontrolnaJedMere := PProizvod.KontrolnaJedMere( cProizvod );
                       PReport.AddLine( LPAD( 'Kolicina u kontrolnoj JM:',36)||
                                        RPAD( cKontrolnaJedMere, 3) ||
                                        LPAD(To_Char(NVL(nKolicinaKontrolna,-2),'9999,999,990.99990'),18) ||' '||'  ( jacina:'||
                                        LPAD( To_Char( Round(nKolicina / nKolicinaKontrolna *100 , 3),'990.9999'),10)||'%'||' )',bBoolean);
                    End If;  
               End Loop;
               Close KalkVP3ceneStav1_cur;
            If nStavka != 0 Then       
       PReport.AddLine('----------------- ------------- ------------- ------------ -------------- ------------ --------------- ---------------- ------------',bBoolean);
               PReport.AddLine('UK:'||
                                TO_CHAR(nIznos,'999999,999.90')||
                                TO_CHAR(nURabat,'999999,990.90')||
                                TO_CHAR(nUNabavna,'999999,990.90')||
                                TO_CHAR(nUPorez,'99999,990.90')||
                                TO_CHAR(nUNabavna+nUPorez,'999,999,990.90')||
                                TO_CHAR(nUZTroskovi,'99999,990.90')||
                                TO_CHAR(nUkRazUCeni,'99999999,990.90')||
                                TO_CHAR(nUkVpVrednost,'99999,999,990.90')
                               ,bBoolean);                               

               nUZTroStavkeIznos  := 0;
               nUZTroStavkePDV    := 0;
               nUZTroStavkeUKUPNO := 0;                           
               
               preport.addline(cpad(' ',132,' '));
               preport.addline(cpad(' ',132,' '));
               preport.addline(Rpad('       ==============================================================================================================',132,' '));
               preport.addline(Cpad('REKAPITULACIJA PO PORESKIM STOPAMA',132,' '));
               preport.addline(Rpad('                             IZNOS        RABAT/KASA          OSNOVICA    STOPA              PDV    FAKTURNA_VREDNOST',132,' '));
               preport.addline(Rpad('       =========================== ================= =================  ======= ================    =================',132,' '));

               nRekIznos       :=0;
               nRekRabat       :=0;
               nRekOsnovica    :=0;
               nRekPDV         :=0;
               nRekFakturisano :=0;
               
               for po_stopama in ( select st.PDV_STOPA, 
                                          sum(st.IZNOS) iznos, sum(st.RABAT+st.KASA) RABAT_KASA,
										  sum(st.OSNOVICA) osnovica, sum(st.PDV) PDV_IZNOS,
										  sum(st.osnovica+st.pdv) FAKT_VREDNOST
                                          --st.STAVKA, st.PROIZVOD, st.NAZIV, st.JED_MERE,  st.KOLICINA, st.CENA, st.PROC_RABATA, st.PROC_KASE,  
                                          -- st.Z_TROSKOVI,  ST.VP_VREDNOST-ST.OSNOVICA-ST.Z_troskovi raz_u_ceni, st.VP_VREDNOST, st.VPCENA
                                   from ( SELECT st.stavka, st.proizvod, p.naziv, st.jed_mere, st.kolicina, 
--                                                 (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
--                                                       (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then 
--                                                             round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
--                                                        Else st.cena
--                                                        End)
--                                                  Else st.cena
--                                                  End) cena,
						                          (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                     (Case When cBrDecimalaCena = 2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                           When cBrDecimalaCena = -2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                      else
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                      End
						                                     )
						                                 Else st.cena
						                                 End)
						                          Else st.cena
						                          End) cena,                                                 
                                                  
                                                 st.cena1 VPCENA, st.rabat proc_rabata,
                                                 nvl(d.kasa,0) proc_kase, nvl(st.z_troskovi,0) z_troskovi,
                                                 ---------------------------------------------------------------------------------------------------------------
                                                 round(NVL(st.Kolicina*st.faktor*st.K_Robe*
                                                 (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                     (Case When cBrDecimalaCena = 2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                           When cBrDecimalaCena = -2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                      else
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                      End
						                                     )
						                                 Else st.cena
						                                 End)
						                          Else st.cena
						                          End) 
                                                 ,0),2) IZNOS,
                                                 ---------------------------------------------------------------------------------------------------------------
                                                 round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                                                      (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                     (Case When cBrDecimalaCena = 2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                           When cBrDecimalaCena = -2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                      else
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                      End
						                                     )
						                                 Else st.cena
						                                 End)
						                          Else st.cena
						                          End) 
                                                 *(st.Rabat/100),0),2) RABAT,
                                                 ---------------------------------------------------------------------------------------------------------------
                                                 round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                                                      (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                     (Case When cBrDecimalaCena = 2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                           When cBrDecimalaCena = -2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                      else
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                      End
						                                     )
						                                 Else st.cena
						                                 End)
 						                               Else st.cena
						                               End) 
                                                 *(1-st.Rabat/100),0) * (CASE WHEN nvl(ST.RABAT,0)<>0 THEN
																			  nvl(d.kasa,0)/100
												                         ELSE 0
												                         END),2) KASA,
                                                 ---------------------------------------------------------------------------------------------------------------
                                                 round(NVL(st.Kolicina*st.faktor*st.K_Robe*
                                                 (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                     (Case When cBrDecimalaCena = 2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                           When cBrDecimalaCena = -2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                      else
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                      End
						                                     )
						                                 Else st.cena
						                                 End)
						                          Else st.cena
						                          End) 
                                                 ,0),2) -
                                                 round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                                                 (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                     (Case When cBrDecimalaCena = 2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                           When cBrDecimalaCena = -2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                      else
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                      End
						                                     )
						                                 Else st.cena
						                                 End)
						                          Else st.cena
						                          End)
                                                 *(st.Rabat/100),0),2) -												
                                                 round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                                                 (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                     (Case When cBrDecimalaCena = 2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                           When cBrDecimalaCena = -2 Then
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                      else
						                                           round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                      End
						                                     )
						                                 Else st.cena
						                                 End)
						                          Else st.cena
						                          End)*(1-st.Rabat/100),0) * (CASE WHEN nvl(ST.RABAT,0)<>0 THEN 
                                                                                   nvl(d.kasa,0)/100
												                              ELSE 0
												                              END),2) OSNOVICA,
                                                 ---------------------------------------------------------------------------------------------------------------
                                                 st.porez PDV_STOPA,
                                                 ---------------------------------------------------------------------------------------------------------------
                                                 ROUND( 
                                                        (round(NVL(st.Kolicina*st.faktor*st.K_Robe*
                                                              (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                           (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                                 (Case When cBrDecimalaCena = 2 Then
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                                       When cBrDecimalaCena = -2 Then
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                                  else
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                                  End)
						                                           Else st.cena
						                                           End)
						                                       Else st.cena
						                                       End)                                                         
						                                 ,0),2) -
                                                         round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                                                              (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                           (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                                 (Case When cBrDecimalaCena = 2 Then
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                                       When cBrDecimalaCena = -2 Then
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                                  else
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                                  End)
						                                           Else st.cena
						                                           End)
						                                       Else st.cena
						                                       End)                                                                    
                                                         *(st.Rabat/100),0),2) -
                                                         round(nvl(st.Kolicina*st.faktor*st.K_Robe*
                                                              (Case When upper(VratiTipIzvoza(nOrgDeo)) = 'DA' Then
						                                           (Case When cNewValuta = 'YUD' And cNewValuta <> st.Valuta Then
						                                                 (Case When cBrDecimalaCena = 2 Then
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                                       When cBrDecimalaCena = -2 Then
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),2)
						                                                  else
						                                                       round(nvl(st.cena,0) * Pkurs.KursNaDan(st.Valuta, dDatumDok, 'S'),4)
						                                                  End)
						                                           Else st.cena
						                                           End)
						                                       Else st.cena
						                                       End)
                                                         *(1-st.Rabat/100),0) * (CASE WHEN nvl(ST.RABAT,0)<>0 THEN
                                                                                      nvl(d.kasa,0)/100																																																														
                                                                                 ELSE 0
 																				 END),2) ) * ST.POREZ/100
                                                      ,2) PDV,
                                                 ---------------------------------------------------------------------------------------------------------------
                                                 round(NVL(st.Kolicina*st.faktor*st.K_Robe*st.Cena1,0),2) VP_VREDNOST
                                                 ---------------------------------------------------------------------------------------------------------------
                                          FROM Dokument d, Stavka_Dok st, proizvod p
                                          WHERE d.vrsta_dok = st.vrsta_dok
                                            and d.godina    = st.godina and d.broj_dok  = st.broj_dok and st.proizvod = p.sifra
                                          ------------------------------------------------------------
                                            and d.vrsta_dok = '73'
											and d.godina    = nGodina
											and d.broj_dok  = cBrojDok
                                          ------------------------------------------------------------
                                          ORDER By stavka
                                          ) st GROUP BY st.pdv_stopa ORDER BY st.pdv_stopa                       
                                 ) loop

                 nRekIznos       := nRekIznos       + po_stopama.iznos ;
                 nRekRabat       := nRekRabat       + po_stopama.RABAT_kasa ;
                 nRekOsnovica    := nRekOsnovica    + po_stopama.OSNOVICA;
                 nRekPDV         := nRekPDV         + po_stopama.PDV_iznos;
                 nRekFakturisano := nRekFakturisano + po_stopama.FAKT_vrednost;

                 preport.addline(RPAD('                '||
                                  to_char(po_stopama.iznos    , '99,999,999,999.99')||
                                  to_char(po_stopama.RABAT_kasa    , '99,999,999,999.99')||
                                  to_char(po_stopama.OSNOVICA , '99,999,999,999.99')||' '||
                                  to_char(po_stopama.pdv_STOPA    , '999.99')||'%'||
                                  to_char(po_stopama.PDV_iznos      , '9,999,999,999.99')||'   '||
                                  to_char(po_stopama.FAKT_vrednost , '99,999,999,999.99')
                                  ,132,' ')
                                 );
               end loop;
               
               preport.addline(Rpad('       =========================== ================= =================  ======= ================    =================',132,' '));
               preport.addline(RPAD('       SVEGA:   '||
                                  to_char(nRekIznos    , '99,999,999,999.99')||
                                  to_char(nRekRabat    , '99,999,999,999.99')||
                                  to_char(nRekOsnovica , '99,999,999,999.99')||' '||
                                  '        '||
                                  to_char(nRekPDV     , '9,999,999,999.99')||'   '||
                                  to_char(nRekFakturisano , '99,999,999,999.99')
                                  ,132,' ')
                                 );

--               cTekstZavisnihTroskova := 'NEMA ZAVISNIH TROŠKOVA';
               cTekstZavisnihTroskova := ' ';
               bZTroskoviPrviPut := true;
               for ztrosk    in (select ztst.*,pp.*,ztvr.naziv naziv_vt from zavisni_troskovi_stavke ztst, poslovni_partner pp, zavisni_troskovi_vrste ztvr
                                  where ztst.vrsta_troskova = ztvr.vrsta_troskova
                                    and ztst.dobavljac_vr_tro = pp.sifra
                                    and ztst.broj_dok  = cBrojDok
                                    and ztst.vrsta_dok = '73'
                                    and ztst.godina    = nGodina
                                  order by ztst.stavka
                                    ) loop

                     cTekstZavisnihTroskova := NULL;
                     
                     if bZTroskoviPrviPut then
                         PREPORT.ADDLINE(RPAD(' ',132,' '),bBoolean);
                         PREPORT.ADDLINE(RPAD(' ',132,' '),bBoolean);
                         PREPORT.ADDLINE(rpad('------------------------------------------------------------------------------------------------------------------------------------',132,' '),bBoolean);
                         preport.addline     (cpad('PRIKAZ ZAVISNIH TROSKOVA',132,' '),bBoolean);
                         PREPORT.ADDLINE(rpad('R.B vrsta                dobavljac                dob.dokum. dat.dok. valuta             iznos  stopa             PDV         ukupno',132,' '),bBoolean);
                         PREPORT.ADDLINE(rpad('--- -------------------- ------------------------ ---------- -------- -------- --------------- -------- ------------- --------------',132,' '),bBoolean);
                        bZTroskoviPrviPut := false;
                     end if;
                     
                     nUZTroStavkeIznos  := nUZTroStavkeIznos  + nvl(ztrosk.iznos_troska,0) ;
                     nUZTroStavkePDV    := nUZTroStavkePDV    + nvl(ztrosk.POREZ_VR_TRO_IZNOS,0) ;
                     nUZTroStavkeUKUPNO := nUZTroStavkeUKUPNO + nvl(ztrosk.iznos_troska+ztrosk.POREZ_VR_TRO_IZNOS,0) ;
                     
                     Preport.Addline(rpad(ztrosk.stavka||'.',4,' ')
                                     ||rpad(substr(ztrosk.naziv_vt,1,20),21,' ')
                                     ||rpad(substr(ztrosk.naziv,1,25),25,' ')
                                     ||rpad(nvl(substr(ztrosk.dokument_dobavljaca,1,11),' '),11,' ')
                                     ||nvl(TO_CHAR(ztrosk.dobavljac_DATUM_DOK,'DD.MM.YY '),'        ')
                                     ||nvl(TO_CHAR(ztrosk.dobavljac_DATUM_DOK+ztrosk.valuta_placanja,'DD.MM.YY '),'         ')
                                     ||nvl(TO_CHAR(ztrosk.iznos_troska,'999,999,990.90'),'               ')||' '
                                     ||case when ztrosk.POREZ_VR_TRO_PROC is null then
                                               '       '
                                            else
                                               TO_CHAR(ztrosk.POREZ_VR_TRO_PROC,'90.90')||'% '
                                       end
                                     ||case when nvl(ztrosk.POREZ_VR_TRO_IZNOS,0) <> 0 then
                                                   TO_CHAR(ztrosk.POREZ_VR_TRO_IZNOS,'99,999,990.90')
                                            else
                                                   '              '
                                       end
                                     ||nvl(TO_CHAR(ztrosk.iznos_troska+ztrosk.POREZ_VR_TRO_IZNOS,'999,999,990.90'),'               ')
                                     
                                    ,bBoolean);
               end loop;
               IF cTekstZavisnihTroskova is not null then
                  preport.addline(rpad(' ',132,' '),bBoolean);
                  preport.addline(rpad(' ',132,' '),bBoolean);
                  preport.addline(cpad(' ',132,' '),bBoolean);
                  preport.addline(cpad(cTekstZavisnihTroskova,132,' '),bBoolean);
                  preport.addline(cpad(' ',132,' '),bBoolean);
               else
                   PREPORT.ADDLINE(rpad('                                       --------------------------------------- --------------- -------- ------------- --------------',132,' '),bBoolean);
                   PREPORT.ADDLINE(rpad('                                                       SVEGA ZAVISNI TROŠKOVI: '
                                        ||to_char(nvl(nUZTroStavkeIznos,0),'999,999,990.90')||'         '
                                        ||to_char(nvl(nUZTroStavkePDV,0),'99,999,990.90')
                                        ||to_char(nvl(nUZTroStavkeUKUPNO,0),'999,999,990.90')
                                        ,132,' '),bBoolean);
                   PREPORT.ADDLINE(rpad('                                       --------------------------------------- ---------------          ------------- --------------',132,' '),bBoolean);
                   PREPORT.ADDLINE(rpad('                                       OBRAÈUNATI Z.TROŠKOVI U PRIJEMNICI    : '||TO_CHAR(nUZTroskovi,'999,999,990.90'),132,' '),bBoolean);
                   PREPORT.ADDLINE(rpad('                                       --------------------------------------- ---------------',132,' '),bBoolean);
                   PREPORT.ADDLINE(rpad('                                       RAZLIKA UK.Z.TROSK.OD Z.T.U PRIJEMNICI: '||TO_CHAR(nUZTroStavkeIznos-nUZTroskovi,'999,999,990.90'),132,' '),bBoolean);
                   PREPORT.ADDLINE(rpad('                                       --------------------------------------- ---------------',132,' '),bBoolean);
                end if;


            Else
               PReport.AddLine('             PRIJEMNICA NEMA NI JEDNU STAVKU',bBoolean);
            End If;
                  -- ovo za slucaj da na poslednjoj strani nije odstampan
                  -- header5 , treba ga odstampati u poslednjoj liniji
                  --Loop
                  --    Exit When PReport.LastRow = nMaxRow;
                  --    PReport.AddLine('   ',bBoolean);
                  --End Loop;
                  
                  Header5;
         End Loop;
         Close KalkVP3cene_cur;
         If lPrva = False Then
             PReport.NewPage;
         End if;
         lGotovo := TRUE ;
      End If;
      If nStrana >= 0 And nStrana <= PReport.LastPage Then
         Return TRUE;      -- znak da je trazena stranica izgenerisana
      Else
         Return NULL;      -- znak da trazena stranica ne postoji
      End If;
   End;

 Function Page( nStrana NUMBER ) Return Boolean Is
   lPom Boolean;
 Begin
   If PReport.Firma( TRUE ) = 'RUBIN' Then
      lPom := Page2( nStrana );
   End If;
   return lPom;
 End;

END;
