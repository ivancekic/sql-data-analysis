Declare

nStatusDokumenta number := 1;
--vVrstaMagacina varchar2(20) := POrganizacioniDeo.OrgDeoOsnPod( nOrgDeoM Number, cVratiPolje)--'VP4';
vVrsta_dok varchar2(20) := 3;
vBroj_dok varchar2(20) := '12528';
nGodina number := 2012;

        suma_troskova_1         number;
        kontrolna_suma_troskova number;
        z_troskovi_za_stavku    number;
        broj_stavki             number;
        UK_SUMA_DOK             number;
        i                       number;
        vrsta_Magacina          varchar2(100);

---deja
  nPreprodajniProcenat    Number;
  nOrgDeo                 Number;
  dDatumDok               Date;


  nCena1_Old Number;
  nCena1_New Number;
---


nZtroD Number;
cena1  Number;

begin


           ---------------deja
           Begin
             Select Org_deo,Datum_dok
             Into nOrgDeo, dDatumDok
             From Dokument
             Where Godina = nGodina And Vrsta_Dok = vVrsta_dok and broj_dok = vBroj_dok;
             nPreprodajniProcenat := PPreProdajniProcenat.Procenat(nOrgDeo, dDatumDok);
           End;

           vrsta_Magacina := TRIM(POrganizacioniDeo.OrgDeoOsnPod( nOrgDeo, 'DODTIP'));
           ---------------deja
           -------------------------------------------------------------------------------------------
           -- SABIRANJE UKUPNIH ZAVISNIH TROSKOVA SAMO PO FORMULI 1
           -- FORMULA 1 := RASPOREDJIVANJE UKUPNOG IZNOSA ZAVISNIH TROSKOVA NA SVE STAVKE PO VREDNOSTI
           -------------------------------------------------------------------------------------------
           suma_troskova_1 := 0 ;
           begin
              select sum(zts.iznos_troska)
                into suma_troskova_1
                from zavisni_troskovi_stavke zts, zavisni_troskovi_vrste ztv
               where zts.vrsta_dok      = vVrsta_dok
                 and zts.broj_dok       = vBroj_dok
                 and zts.godina         = nGodina
                 and zts.vrsta_troskova = ztv.vrsta_troskova
                 and ztv.formula        = 1;
           exception when others then
              suma_troskova_1 := 0 ;
           end;
           suma_troskova_1 := nvl(suma_troskova_1,0);
           -------------------------------------------------------------------------------------------

--           if suma_troskova_1 <> 0  or vrsta_Magacina = 'VP4'  then
           if suma_troskova_1 <> 0  then

              -------------------------------------------------------------------------------------------
              -- PRESABIRANJE BROJA STAVKI U DOKUMENTU I UKUPNE VREDNOSTI DOKUMENTA DA BI SE
              -- DOBILI PROCENTI ZA RASPOREDJIVANJE ZAVISNIH TROSKOVA PO VREDNOSTI
              -------------------------------------------------------------------------------------------
              broj_stavki := 0;
              uk_suma_dok := 0 ;
              begin
                          select COUNT(*),SUM(ROUND(ST.KOLICINA*st.cena*(100-nvl(st.rabat,0))/100,2))
--                          select COUNT(*),SUM(ROUND(ST.KOLICINA*16*(100-nvl(st.rabat,0))/100,2))
                            INTO BROJ_STAVKI,UK_SUMA_DOK
                            from stavka_dok st
                           where st.vrsta_dok      = vVrsta_dok
                             and st.broj_dok       = vBroj_dok
                             and st.godina         = nGodina;

              exception when others then
                broj_stavki:= 0;
                uk_suma_dok := 0 ;
              end;
              -------------------------------------------------------------------------------------------
              kontrolna_suma_troskova := 0;
              i:=1;

--              for x in (  select st.*
              for x in (  select st.BROJ_DOK, st.VRSTA_DOK, st.GODINA, st.STAVKA, st.PROIZVOD, st.LOT_SERIJA, st.ROK, st.KOLICINA
                               , st.JED_MERE
--                               , st.CENA
, 16 cena
                               , st.VALUTA, st.LOKACIJA, st.PAKOVANJE, st.BROJ_KOLETA, st.K_REZ, st.K_ROBE
                               , st.K_OCEK, st.KONTROLA, st.FAKTOR, st.REALIZOVANO, st.RABAT, st.POREZ, st.KOLICINA_KONTROLNA
                               , st.AKCIZA, st.TAKSA, st.CENA1, st.Z_TROSKOVI, st.NETO_KG, st.PROC_VLAGE, st.PROC_NECISTOCE
                               , st.HTL, st.NAPOMENA
                            from stavka_dok st
                           where st.vrsta_dok      = vVrsta_dok
                             and st.broj_dok       = vBroj_dok
                             and st.godina         = nGodina
                             order by st.kolicina*st.cena
                        ) loop

                        if broj_stavki <> i then
Dbms_Output.Put_line( ' U1');
                           z_troskovi_za_stavku := round(x.kolicina * x.cena * (1-nvl(x.rabat,0)/100) / uk_suma_dok * suma_troskova_1,2);

                           z_troskovi_za_stavku := round(
                                                          (round
                                                            (
                                                              (x.kolicina * x.cena * (1-nvl(x.rabat,0)/100) + z_troskovi_za_stavku) / x.kolicina
                                                          ,4)
                                                          -
                                                          x.cena * (1-nvl(x.rabat,0)/100)) * x.kolicina
                                                   ,2);
                        else
Dbms_Output.Put_line( ' U2');
                           z_troskovi_za_stavku := suma_troskova_1 - kontrolna_suma_troskova;
                        end if;

                        CASE WHEN vrsta_Magacina like 'VP%' And vrsta_Magacina <> 'VP4' THEN
Dbms_Output.Put_line( ' U3');
                              nZtroD := nvl(z_troskovi_za_stavku,0);
                              cena1  := round(
                                               (
                                                 (  x.kolicina * x.cena * (1-nvl(x.rabat,0)/100)
                                                  + nvl(z_troskovi_za_stavku,0)
                                                 ) / x.kolicina
                                                )
                                               *
                                                (100 + nPreprodajniProcenat ) / 100
                                              ,2);
                              WHEN vrsta_Magacina = 'VP4' THEN
Dbms_Output.Put_line( ' U4');

                                   If nStatusDokumenta = -8 then
Dbms_Output.Put_line( ' U5');
                                     nZtroD := nvl(z_troskovi_za_stavku,0);
                                     cena1  := round(
                                                      (
                                                       (x.kolicina * x.cena * (1-nvl(x.rabat,0)/100) + nvl(z_troskovi_za_stavku,0)) / x.kolicina
                                                      )
                                                      *
                                                       (100 + nPreprodajniProcenat ) / 100
                                                    ,2);
                                  End if;
                             --------------------deja
                             WHEN vrsta_Magacina = 'NAB'    THEN
Dbms_Output.Put_line( ' U6');
                                  if nStatusDokumenta = -8 then
Dbms_Output.Put_line( ' U7');
                                     nZtroD := nvl(z_troskovi_za_stavku,0);
                                     cena1  := round(
                                                       (
                                                         (x.kolicina * x.cena * (1-nvl(x.rabat,0)/100) + nvl(z_troskovi_za_stavku,0)) / x.kolicina
                                                       )
                                                     *
                                                       (100 + nPreprodajniProcenat ) / 100
                                                    ,2);
                                 else
Dbms_Output.Put_line( ' U8');
                                     nZtroD := nvl(z_troskovi_za_stavku,0);
                                     cena1  := round(
                                                      (
                                                        (x.kolicina * x.cena * (1-nvl(x.rabat,0)/100) + nvl(z_troskovi_za_stavku,0)) / x.kolicina
                                                      )
                                                     *
                                                      (100 + nPreprodajniProcenat ) / 100
                                                    ,2);
                                 end if;
                             ELSE
Dbms_Output.Put_line( ' U9');
                                  NULL;
                        END CASE;


Dbms_Output.Put_line( ' PROVERE:' || vrsta_Magacina|| ':');


                        kontrolna_suma_troskova := kontrolna_suma_troskova +  z_troskovi_za_stavku;
                        i:=i+1;

Dbms_Output.Put_line( ' cena:' || to_char(x.cena*(1-nvl(x.rabat,0))/100) || ' :z_tro:' || to_char(nZtroD) || ': KONTROLA Z TRO:' || TO_CHAR(kontrolna_suma_troskova));

              end loop;
--              commit;
else
--              for y in (  select st.*
              for y in (  select st.BROJ_DOK, st.VRSTA_DOK, st.GODINA, st.STAVKA, st.PROIZVOD, st.LOT_SERIJA, st.ROK, st.KOLICINA
                               , st.JED_MERE
                               , st.CENA
--, 16 cena
                               , st.VALUTA, st.LOKACIJA, st.PAKOVANJE, st.BROJ_KOLETA, st.K_REZ, st.K_ROBE
                               , st.K_OCEK, st.KONTROLA, st.FAKTOR, st.REALIZOVANO, st.RABAT, st.POREZ, st.KOLICINA_KONTROLNA
                               , st.AKCIZA, st.TAKSA, st.CENA1, st.Z_TROSKOVI, st.NETO_KG, st.PROC_VLAGE, st.PROC_NECISTOCE
                               , st.HTL, st.NAPOMENA
                            from stavka_dok st
                           where st.vrsta_dok      = vVrsta_dok
                             and st.broj_dok       = vBroj_dok
                             and st.godina         = nGodina
                             order by st.kolicina*st.cena
                        ) loop
                          nCena1_Old := y.cena1;
                          nCena1_New  := round(((y.kolicina * y.cena * (1-nvl(y.rabat,0)/100) + nvl(z_troskovi_za_stavku,0)) / y.kolicina)*
                                                (100 + nPreprodajniProcenat ) / 100,2);


Dbms_Output.Put_line( ' Nema Z tro: '|| ' old cena1 '|| to_char(nCena1_OLD) || ' new cena ' || to_char(nCena1_New));

              end loop;

           end if;


END;
