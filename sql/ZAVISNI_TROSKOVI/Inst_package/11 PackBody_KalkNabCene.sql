CREATE OR REPLACE PACKAGE BODY INVEJ.KalkulacijaNABcene IS
   lGotovo         Boolean;
   nMaxRow         Number;
   lPrva           Boolean;
   cBrojDok        VarChar2(9);
   cBrojDokP       VarChar2(9);
   nGodina         Number;
   brojKalkulacije varchar2(50);
   
   bBoolean        boolean := false;
   nRekIznos       number;
   nRekRabat       number;
   nRekOsnovica    number;
   nRekPDV         number;
   nRekFakturisano number;
   nNeto_KG        number;
   nProc_Vlage     number;
   nProc_Necistoce number;
   nHTL            number;
   

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

   Procedure SetParameter( nGod In Number, cBr In VarChar2,
                           cVal In VarChar2 := NULL ) Is
   Begin
      -- inicijalizacija
      KalkulacijaNABcene.cBrojDok := cBr;
      KalkulacijaNABcene.nGodina := nGod;
      KalkulacijaNABcene.cNewValuta := cVal;

      Select Broj_dok1 Into KalkulacijaNABcene.cBrojDokP
      from Dokument
      where Godina = KalkulacijaNABcene.nGodina And 
            Broj_dok = KalkulacijaNABcene.cBrojDok And 
            Vrsta_dok = '3' ;
            
      KalkulacijaNABcene.cBrojDokP :=nvl(KalkulacijaNABcene.cBrojDokP,KalkulacijaNABcene.cBrojDok) ;     
      lGotovo := FALSE;
      nMaxRow := PReport.MaxRows ;
      lPrva := True;
      PReport.Comment( 'Kalkulacija NABAVNE CENE broj: '||'xx-yyyyy/gggg' );
   End;


   -- za RUBIN
   Procedure Header4 Is -- ispisuje zaglavlje prijemnice na svakoj strani
            AdresaMagacina varchar2(50):=' ';
            
   bPomocna boolean;
   vUgovor varchar2(50);
   Begin
     If --PReport.LastRow = nMaxRow OR 
         lPrva = True Then
            -- preuzima nazive iz odgovarajucih tabela pomocu f-ja iz baze
            cNazivOrgdela := POrganizacioniDeo.Naziv( nOrgDeo );
            cNazivPoslovnice := POrganizacioniDeo.Naziv( nPoslovnica );
            cNazivPPartnera := PPoslovniPartner.Naziv( cPPartner );
            cAdresa := PPoslovniPartner.Adresa( cPPartner );
            cMesto := PPOslovniPartner.Adresa2( cPPartner );
            cNazivStatusa := PStatus.Naziv( 3 , nStatus );
            cNazivTipaDokumenta := PNacinFakt.Naziv( nTipDok );
            -- oredjuje u kojoj valuti je cena,na osnovu prve stavke
            -- ako valuta nije definisana podrazumeva se da je YUD
            Begin
              Select valuta
              Into cValuta
              From Stavka_Dok
              Where Broj_Dok = cBrojDok AND godina = nGodina AND
                    vrsta_dok = '3' AND stavka = 1;
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
            
            preport.addline(rpad(Pvlasnik.Naziv(1)||' - '||PVlasnik.mesto(1),131,' ')||'.',bBoolean );
            preport.addline(rpad('PIB:'||pvlasnik.PIB(1),132,' ') ,bBoolean );
            preport.addline(rpad('MAGACIN ('||nOrgDeo||') : '||cNazivOrgDela,132,' '),bBoolean);
            begin
                select nvl(mesto,' ')||', '||nvl(adresa,' ') into Adresamagacina from org_deo_osn_podaci where org_deo = nOrgDeo;
            exception when others then
                AdresaMagacina := ' ';
            end;
            preport.addline(rpad(AdresaMagacina,132,' '),bBoolean);
            
            brojKalkulacije := 'RADNA_VERZIJA';
            for brojkalk in (   select d.broj_dok id_kalk,d.org_deo||'-'||d.broj_dok1||'/'||d.godina broj1_kalk 
                                 from vezni_dok vd, dokument d
                                where vd.broj_dok = cBrojDok
                                  and vd.godina   = nGodina
                                  and vd.vrsta_dok = 3
                                  and vd.za_vrsta_dok = 86
                                  and vd.za_broj_dok  = d.broj_dok
                                  and vd.za_godina    = d.godina
                                  and vd.za_vrsta_dok = d.vrsta_dok
                             ) loop
                 brojKalkulacije := brojkalk.broj1_kalk ;
            end loop;
            
            preport.addline(cpad('Kalkulacija NABAVNE cene broj: '||brojkalkulacije,132,' '),bBoolean );
            
            preport.addline(rpad(' ',132,' '),bBoolean);
            
            begin
               select case when za_vrsta_dok = '35' then
                                'UP-'
                           when za_vrsta_dok = '36' then
                                'UK-'     
                           else
                                ' '
                      end || ZA_BROJ_DOK ||'/'||ZA_GODINA
                 into vUgovor
                 from vezni_dok 
                where broj_dok  =  cBrojDok
                  and godina    =  nGodina
                  and vrsta_dok =  '3'
                  and za_vrsta_dok in (35,36);
            exception when others then
               vUgovor := ' ';
            end;
            
            PReport.AddLine(  rpad(case when nTipDok  in ( 115, 116, 117, 118 )  then
                                        '          OTKUPNI LIST BROJ :'
                                        else
                                        '          PO PRIJEMNICI BROJ: '
                                   end || nOrgDeo||'-'||cBrojDokP||'/'||nGodina||' (ID='||cBrojDok||')'
                              ,61,' ')
                            ||rpad(rpad('Dobavljac...('||NVL(cPPartner,' ')||')...',20,'.')||': '||rpad(NVL(cNazivPPartnera,' '),23,' ')
                                   ||CASE WHEN trim(vUgovor) is not null then 
                                               'UGOVOR BR:'||vUgovor
                                          else
                                               ' '
                                     end
                              ,71,' ')
                            
                           ,bBoolean);    

            PReport.AddLine(  rpad('          Tip prijema.......: '||nTipDok||'('||cNazivTipaDokumenta||')',61,' ')
                            ||rpad('Adresa dobavljaca...: '||cAdresa, 61,' '),bBoolean);
            PReport.AddLine(rpad(  '          Datum prijema.....: '||To_Char(dDatumDok,'dd.mm.yyyy')||'.god.',61,' ')||
                                   'Mesto dobavljaca....: '||cMesto,bBoolean);
                                   
            lPomocna := PVezniDok.NadjiVezu( '3', nGodina, cBrojDok,
                                            '24', nGodinaVeznog, cBrojVeznog );
                                            
            PReport.AddLine(rpad(  '          Status: '||To_Char(nStatus)||'('||cNazivStatusa||')',61,' ')||
                            'Dokument dobavljaca.: '||cBrojVeznog||'/'||To_Char(nGodinaVeznog),bBoolean);
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
       PReport.AddLine('R.Br. ŠIFRA   NAZIV PROIZVODA                JM      PDV-STOPA                     KOLIÈINA       NAB.CENA                          ',bBoolean);
       PReport.AddLine('                iznos        rabat   nab.vrednost     fakt.PDV    fakt.Vredn.  zav.troskovi   NAB.VREDNOST      KALKULISANA NAB.CENA',bBoolean);
       PReport.AddLine('--------------------- ------------ -------------- ------------ -------------- ------------- --------------    ----------------------',bBoolean);
       lHeader := False ;
     End if ;
   End ;

 -- Izvestaj za Zupu i ostale
 
 -- Izvestaj za Rubin
 Function Page2( nStrana NUMBER ) Return Boolean Is
      Cursor Prijemnica_cur IS  --Kursor nad tabelom Dokument
            -- izdvaja prijemnicu sa odgovarajucim brojem i godinom
            SELECT datum_dok,tip_dok,status,ppartner,
                   org_deo,datum_valute,poslovnica,
                   datum_storna,datum_unosa,user_id
            FROM Dokument
            WHERE vrsta_dok = '3' AND
                  godina = nGodina AND
                  broj_dok = cBrojDok;

      Cursor Stavka_cur IS  --Kursor nad tabelom Stavka_Dok
            -- izdvaja stavke za datu prijemnicu
            SELECT stavka,proizvod,kolicina,jed_mere,broj_koleta,lot_serija,
                   rok,lokacija,cena,faktor,kolicina_kontrolna,rabat,porez,cena1,k_robe,z_troskovi,
                                                                   
                                                                   round(round(kolicina*(cena1),4)
                                                                          -                                   
                                                                         round(kolicina*cena*(1-rabat/100),4)
                                                                        ,2) 
                                                                   
                                                                   ,Neto_KG,Proc_Vlage,Proc_Necistoce,HTL
            FROM Stavka_Dok
            WHERE broj_dok = cBrojDok AND godina = nGodina AND vrsta_dok = '3'
            ORDER By stavka;

            nStavka              Number ;
            cProizvod            VarChar2(7);
            nKolicina            Number;
            nKolicinaKontrolna   Number;
            nFaktor              Number;
            nKrobe               number;
            cJedMere             VarChar2(3);
            cKontrolnaJedMere    VarChar2(3);
            nBrojKoleta          Number;
            cLotSerija           VarChar2(10);
            dRok                 Date;
            cLokacija            VarChar2(6);
            nCena                Number;
            nCena1               Number;            
            cNazivProizvoda      VarChar2(30);
            nIznos               Number := 0;
            nZTroskovi           number:=0;
            nZTRoskoviUPrijemnici number := 0;
            --
            nUkupno              Number := 0;
            nRabat               Number := 0;
            nPorez               Number := 0; 
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

         Open Prijemnica_cur;
         Loop
            Fetch Prijemnica_cur INTO dDatumDok,nTipDok,nStatus,cPPartner,nOrgDeo,
                                      dDatumValute,nPoslovnica,dDatumStorna,
                                      dDatumUnosa,cUserId;
            Exit When Prijemnica_cur%NOTFOUND;
              nStavka := 0;-- za slucaj da prijemnica nema ni jednu stavku
              bStavkaDokPrviPut := true;
              Open Stavka_cur;
              Loop
                  Fetch Stavka_cur INTO nStavka,cProizvod,nKolicina,cJedMere,
                                        nBrojKoleta,cLotSerija,dRok,cLokacija,
                                        nCena,nFaktor,nKolicinaKontrolna,nRabat,nPorez,nCena1,nKrobe,
                                        nZTroskovi,nZTRoskoviUPrijemnici
                                        ,nNeto_KG,nProc_Vlage,nProc_Necistoce,nHTL;
                  Exit When Stavka_cur%NOTFOUND;
                    Header4;
                    HeaderRubin;
                    -- izvlaci naziv proizvoda iz tabele proizvod
                    cNazivProizvoda := PProizvod.Naziv( cProizvod );
                    nIznos := nIznos + round(NVL(nKolicina*nfaktor*nKRobe*nCena,0),2);
                    -- i ubacuje ga u ukopno
                    nUkupno     := nUkupno + nIznos;
                    nUNabavna   := nUNabavna + round(nvl(nKolicina*nfaktor*nKRobe*nCena*(1-nRabat/100),0),2);
                    nURabat     := nURabat + round(nvl(nKolicina*nfaktor*nKRobe*nCena*(nRabat/100),0),2) ;
                    nUPorez     := nUPorez + round(nvl(nKolicina*nfaktor*nKRobe*nCena*(1-nRabat/100)*(nporez/100),0),2);
                    nUZTroskovi := nvl(nUZTroskovi,0) + nvl(--nZTroskovi
                                                             nZTRoskoviUPrijemnici
                                                             ,0);
                    nUkRazUCeni := nUkRazUCeni +  
                                                  round(nvl(nKolicina*nFaktor*nKRobe*nCena1,0),2)
                                                  -
                                                  round(nvl(nKolicina*nfaktor*nKRobe*nCena*(1-nRabat/100),0),2)
                                                  -
                                                  round(nvl(nZTroskovi,0),2);
                    nUkVpVrednost := nUkVpVrednost + round(nvl(nKolicina*nFaktor*nKRobe*nCena1,0),2) ;
                    
                    if bStavkaDokPrviPut then
                       bStavkaDokPrviPut := false;
                    else
                       preport.addline(rpad(' ',132,' '),bBoolean);
                    end if;
                    PReport.AddLine(rpad(RPAD(nStavka||'.',6,' ')||
                                         RPAD(trim(cProizvod),8,' ')||
                                         RPAD(cNazivProizvoda,31,' ')||RPAD(cJedMere,3,' ')||'       '||
                                         to_char(nPorez,'90.90')||'%       '||
                                         RPAD(To_Char(nKolicina*nfaktor*nKRobe,'99,999,999.99999'),17,' ')||'('||RPAD(cJedMere,3,' ')||')'||
                                         RPAD(To_Char(nCena,'9,999,999.9999'),15,' ')
                                         ,132,' '),bBoolean);
--                    if nTipDok in ( 115, 116, 117, 118 )  then
                    If Nvl(nProc_Vlage,0) <> 0 Then
                       preport.addline(rpad('              PARAMETRI OBRAÈUNA JUS-KG:  NETO='||
                                                      rpad(trim(to_char(nNeto_kg,'99,999,999.9999')||'(kg)'),17,' ')||
                                                      '   VLAGA='||rpad(trim(to_char(nProc_Vlage,'999.99'))||'(%)',10,' ')||
                                                      '   NEÈISTOÆA='||rpad(trim(to_char(nProc_Necistoce,'999.99')||'(%)'),11,' ')||
                                                      case when nvl(nHTL,0) <> 0 then
                                                           '   HTL='||rpad(trim(to_char(nHTL,'999.99')||'(kg)'),11,' ')
                                                           else
                                                           ' '
                                                      end    
                                             ,132,' ')
                                      );
                    end if;
                                    
                    PReport.AddLine('      '||
                                    RPAD(To_Char(round(nKolicina*nfaktor*nKRobe*nCena,2),'999,999,999.99'),15,' ')||
                                    RPAD(To_Char(round(nvl(nKolicina*nfaktor*nKRobe*nCena*(nRabat/100),0),2),'9,999,999.99'),13,' ')||
                                    RPAD(To_Char(round(nvl(nKolicina*nfaktor*nKRobe*nCena*(1-nRabat/100),0),2),'999,999,999.99'),15,' ')||
                                    RPAD(To_Char(round(nvl(nKolicina*nfaktor*nKRobe*nCena*(1-nRabat/100)*(nporez/100),0),2),'99999,999.99'),13,' ')||
                                    RPAD(To_Char(round(nvl(nKolicina*nfaktor*nKRobe*nCena*(1-nRabat/100),0),2)+round(nvl(nKolicina*nfaktor*nKRobe*nCena*(1-nRabat/100)*(nporez/100),0),2),'999,999,999.99'),15,' ')||
                                    RPAD(To_Char(round(nvl(--nZTroskovi
                                                           nZTRoskoviUPrijemnici
                                                           ,0),2),'99,999,990.90'),14,' ')||
                                    RPAD(To_Char(  round(nvl(nKolicina*nFaktor*nKRobe*nCena1,0),2),'999,999,990.90'),15,' ')||
                                    '         '||
                                    RPAD(To_Char(nCena1,'999,999,990.9999'),18,' ')
                                    ,bBoolean);
                                    
                                    
                    If nKolicinaKontrolna Is Not Null Then
                       ckontrolnaJedMere := PProizvod.KontrolnaJedMere( cProizvod );
                       PReport.AddLine( LPAD( 'Kolicina u kontrolnoj JM:',36)||
                                        RPAD( cKontrolnaJedMere, 3) ||
                                        LPAD(To_Char(NVL(nKolicinaKontrolna,-2),'9999,999,990.99990'),18) ||' '||'  ( jacina:'||
                                        LPAD( To_Char( Round(nKolicina / nKolicinaKontrolna *100 , 3),'990.9999'),10)||'%'||' )',bBoolean);
                    End If;

               End Loop;
               Close Stavka_cur;
               
            If nStavka != 0 Then
        
               PReport.AddLine('--------------------- ------------ -------------- ------------ -------------- ------------- --------------    ----------------------',bBoolean);
               PReport.AddLine('SVEGA:'||
                                TO_CHAR(nIznos,'999,999,990.90')||
                                TO_CHAR(nURabat,'9,999,990.90')||
                                TO_CHAR(nUNabavna,'999,999,990.90')||
                                TO_CHAR(nUPorez,'99999,990.90')||
                                TO_CHAR(nUNabavna+nUPorez,'999,999,990.90')||
                                TO_CHAR(nUZTroskovi,'99,999,990.90')||
--                                TO_CHAR(nUkRazUCeni,'999,999,990.90')||
                                TO_CHAR(nUkVpVrednost,'999,999,990.90')
                               ,bBoolean);



               preport.addline(rpad(' ',132,' '));
               for x in ( select  trim(substr(komentar,1,132))   komentar1
                                 ,trim(substr(komentar,133,132)) komentar2
                                 ,trim(substr(komentar,265,132)) komentar3
                            from komentar
                           where broj_dok = cBrojDok AND godina = nGodina AND vrsta_dok = '3'
                             and stavka = -3000) loop
                             
                             
                    if x.komentar1 is not null then
                       preport.addline(x.komentar1);
                    end if;
                    if x.komentar2 is not null then
                       preport.addline(x.komentar2);
                    end if;
                    if x.komentar3 is not null then
                       preport.addline(x.komentar3);
                    end if;
               end loop;


               nUZTroStavkeIznos  := 0;
               nUZTroStavkePDV    := 0;
               nUZTroStavkeUKUPNO := 0;
               
               
               
               preport.addline(cpad(' ',132,' '));
               preport.addline(cpad(' ',132,' '));
               preport.addline(Rpad('       ==============================================================================================================',132,' '));
               preport.addline(Cpad('REKAPITULACIJA PO PORESKIM STOPAMA',132,' '));
               preport.addline(Rpad('                             IZNOS             RABAT          OSNOVICA  STOPA                PDV    FAKTURNA_VREDNOST',132,' '));
               preport.addline(Rpad('       =========================== ================= =================  ======= ================    =================',132,' '));

               nRekIznos       :=0;
               nRekRabat       :=0;
               nRekOsnovica    :=0;
               nRekPDV         :=0;
               nRekFakturisano :=0;
               
               for po_stopama in ( SELECT sum(NVL(round(kolicina*cena*faktor*k_robe,2),0))        iznos,
                                          sum(round(nvl(Kolicina*faktor*K_Robe*Cena*(Rabat/100),0),2))   rabat,
                                          sum(round(nvl(Kolicina*faktor*K_Robe*Cena*(1-Rabat/100),0),2)) osnovica,
                                          porez stopa,
                                          sum(round(nvl(Kolicina*faktor*K_Robe*Cena*(1-Rabat/100)*(porez/100),0),2)) PDV,

                                          sum(round(nvl(Kolicina*faktor*K_Robe*Cena*(1-Rabat/100),0),2)) +
                                          sum(round(nvl(Kolicina*faktor*K_Robe*Cena*(1-Rabat/100)*(porez/100),0),2)) fakturisano
                                     FROM Stavka_Dok
                                    WHERE broj_dok  = cBrojDok
                                      AND godina    = nGodina
                                      AND vrsta_dok = '3'
                                    group by porez
                                    order by porez
                        
                                 ) loop

                nRekIznos       := nRekIznos       + po_stopama.iznos ;
                nRekRabat       := nRekRabat       + po_stopama.RABAT ;
                nRekOsnovica    := nRekOsnovica    + po_stopama.OSNOVICA;
                nRekPDV         := nRekPDV         + po_stopama.PDV;
                nRekFakturisano := nRekFakturisano + po_stopama.FAKTURISANO;

                 preport.addline(RPAD('                '||
                                  to_char(po_stopama.iznos    , '99,999,999,999.99')||
                                  to_char(po_stopama.RABAT    , '99,999,999,999.99')||
                                  to_char(po_stopama.OSNOVICA , '99,999,999,999.99')||' '||
                                  to_char(po_stopama.STOPA    , '999.99')||'%'||
                                  to_char(po_stopama.PDV      , '9,999,999,999.99')||'   '||
                                  to_char(po_stopama.FAKTURISANO , '99,999,999,999.99')
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
                                    and ztst.vrsta_dok = '3'
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
--                     nUZTroStavkePDV    := nUZTroStavkePDV    + nvl(ztrosk.POREZ_VR_TRO_IZNOS,0) ;
                     nUZTroStavkePDV    := nUZTroStavkePDV    + nvl(round(ztrosk.iznos_troska*ztrosk.porez_vr_tro_proc/100,2),0) ;
                     nUZTroStavkeUKUPNO := nUZTroStavkeUKUPNO + nvl(ztrosk.iznos_troska+round(ztrosk.iznos_troska*ztrosk.porez_vr_tro_proc/100,2),0) ;
                     
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
--                                                   TO_CHAR(ztrosk.POREZ_VR_TRO_IZNOS,'99,999,990.90')
                                                   TO_CHAR(round(ztrosk.iznos_troska*ztrosk.porez_vr_tro_proc/100,2),'99,999,990.90')
                                            else
                                                   '              '
                                       end
--                                     ||nvl(TO_CHAR(ztrosk.iznos_troska+ztrosk.POREZ_VR_TRO_IZNOS,'999,999,990.90'),'               ')
                                     ||nvl(TO_CHAR(ztrosk.iznos_troska+round(ztrosk.iznos_troska*ztrosk.porez_vr_tro_proc/100,2),'999,999,990.90'),'               ')
                                     
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
         Close Prijemnica_cur;
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
