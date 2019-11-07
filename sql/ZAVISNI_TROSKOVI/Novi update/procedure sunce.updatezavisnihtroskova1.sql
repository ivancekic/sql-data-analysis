CREATE OR REPLACE
Procedure       UPDATEZAVISNIHTROSKOVA1 (nStatusDokumenta number,vVrstaMagacina varchar2, vVrsta_dok varchar2, vBroj_dok varchar2, nGodina number) is

-- Procedura za rasporedjivanje zavisnih troskova po stavkama
-- Autor Zamahajev Zoran
-- Datum: 03.06.2008

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
---

-- deja  01.04.2010 nije prvo aprilska shala
-- rad po formuli 2
-- stavka_zavisnog troska ide na stavku dokumenta
        suma_troskova_2           number;
        kontrolna_suma_troskova_2 number;
        z_troskovi_za_stavku_2    number;
        broj_stavki_2             number;
        UK_SUMA_DOK_2             number;
        i_2                       number;

Function UpdZtroFormula2 (x_Stavka Number) Return Number Is --(nGod Number, cVrd Varchar2, cBrd Varchar2, nStavka Number) Return Number Is
Begin
  Select sum(zts.iznos_troska)
  Into suma_troskova_2
  From zavisni_troskovi_stavke zts, zavisni_troskovi_vrste ztv
  Where zts.vrsta_dok      = vVrsta_dok
    And zts.broj_dok       = vBroj_dok
    And zts.godina         = nGodina
    And zts.STAVKA_PRIJ    = x_Stavka
    And zts.vrsta_troskova = ztv.vrsta_troskova
    And ztv.formula        = 2;   
  Return (suma_troskova_2);    
  
Exception when others then
  Return 0;
End;
        
--
begin

           vrsta_Magacina := upper(vVrstaMagacina);
           ---------------deja
           Begin
             Select Org_deo,Datum_dok
             Into nOrgDeo, dDatumDok
             From Dokument
             Where Godina = nGodina And Vrsta_Dok = vVrsta_dok and broj_dok = vBroj_dok;
             nPreprodajniProcenat := PPreProdajniProcenat.Procenat(nOrgDeo, dDatumDok);
           End;
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


           -- deja  01.04.2010 nije prvo aprilska shala
           -- rad po formuli 2
           -- stavka_zavisnog troska ide na stavku dokumenta
           -- rad po formuli 2 
           if suma_troskova_1 <> 0  or vrsta_Magacina = 'VP4'  then
              -------------------------------------------------------------------------------------------
              -- PRESABIRANJE BROJA STAVKI U DOKUMENTU I UKUPNE VREDNOSTI DOKUMENTA DA BI SE
              -- DOBILI PROCENTI ZA RASPOREDJIVANJE ZAVISNIH TROSKOVA PO VREDNOSTI
              -------------------------------------------------------------------------------------------
              broj_stavki := 0;
              uk_suma_dok := 0;
              begin
                          select COUNT(*),SUM(ROUND(ST.KOLICINA*ST.CENA1,2))
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

              for x in (  select st.*
                            from stavka_dok st
                           where st.vrsta_dok      = vVrsta_dok
                             and st.broj_dok       = vBroj_dok
                             and st.godina         = nGodina
                             order by st.kolicina*st.cena
                        ) loop
              suma_troskova_2 := nvl(UpdZtroFormula2 (x.stavka),0);
--              If  suma_troskova_2 = 0 Then  
               dbms_output.put_line('po formuli 1 stavka ' || to_char(i) || ' z_tro ' || to_char(suma_troskova_2));                     
                        if broj_stavki <> i then
                           z_troskovi_za_stavku := round(x.kolicina*x.cena1/uk_suma_dok * suma_troskova_1,2);

                           z_troskovi_za_stavku := round((round(
                                                               (x.kolicina * x.cena1 + z_troskovi_za_stavku) / x.kolicina
                                                               ,4)
                                                          -
                                                          x.cena1) * x.kolicina
                                                   ,2);
                        else
                           z_troskovi_za_stavku := suma_troskova_1 - kontrolna_suma_troskova;
                        end if;

                        --------------------deja
--                        CASE WHEN vrsta_Magacina like 'VP%' THEN
                        CASE WHEN vrsta_Magacina like 'VP%' And vrsta_Magacina <> 'VP4' THEN
                                  UPDATE STAVKA_DOK
                                     SET Z_TROSKOVI = z_troskovi_za_stavku
                                   WHERE vrsta_dok = vVrsta_dok
                                     and broj_dok  = vBroj_dok
                                     and godina    = nGodina
                                     and stavka    = x.stavka;
                             --------------------deja
                             WHEN vrsta_Magacina = 'VP4' THEN
                                  If nStatusDokumenta = -8 then
                                     UPDATE STAVKA_DOK
                                        SET Z_TROSKOVI = nvl(z_troskovi_za_stavku,0)
                                            --,cena1     = round(((x.kolicina * x.cena + nvl(z_troskovi_za_stavku,0)) / x.kolicina)*(100 + nPreprodajniProcenat ) / 100,2)
                                            ,cena1     = round(((x.kolicina * x.cena * (1-x.rabat/100) + nvl(z_troskovi_za_stavku,0)) / x.kolicina)*(100 + nPreprodajniProcenat ) / 100,2)
                                           WHERE vrsta_dok = vVrsta_dok
                                             and broj_dok  = vBroj_dok
                                             and godina    = nGodina
                                             and stavka    = x.stavka;
                                  End if;
                             --------------------deja
                             WHEN vrsta_Magacina = 'NAB'    THEN
                                  if nStatusDokumenta = -8 then
                                          UPDATE STAVKA_DOK
                                             SET Z_TROSKOVI = z_troskovi_za_stavku
                                                ,cena1      = round(
                                                                    (x.kolicina * x.cena1 + z_troskovi_za_stavku) / x.kolicina
                                                                    ,4)
                                           WHERE vrsta_dok = vVrsta_dok
                                             and broj_dok  = vBroj_dok
                                             and godina    = nGodina
                                             and stavka    = x.stavka;
                                 else
                                          UPDATE STAVKA_DOK
                                             SET Z_TROSKOVI = z_troskovi_za_stavku
                                           WHERE vrsta_dok = vVrsta_dok
                                             and broj_dok  = vBroj_dok
                                             and godina    = nGodina
                                             and stavka    = x.stavka;
                                 end if;
                             ELSE
                                  NULL;
                        END CASE;

                        kontrolna_suma_troskova := kontrolna_suma_troskova +  z_troskovi_za_stavku;
                        i:=i+1;   
--              end if;          
              end loop;                           
              commit;
           end if;


           -- deja  01.04.2010 nije prvo aprilska shala
           -- rad po formuli 2 -- pocetak obrade
           -- stavka_zavisnog troska ide na stavku dokumenta
           for x1 in (  Select st.*
                        From stavka_dok st
                        Where st.vrsta_dok = vVrsta_dok
                          And st.broj_dok  = vBroj_dok
                          And st.godina    = nGodina
                        Order by st.kolicina*st.cena
                        ) loop

                          suma_troskova_2 := nvl(UpdZtroFormula2 (x1.stavka),0);
                          If suma_troskova_2 <> 0 Then
                             dbms_output.put_line('po formuli 2');                                               
                             CASE WHEN vrsta_Magacina like 'VP%' And vrsta_Magacina <> 'VP4' THEN
                                       UPDATE STAVKA_DOK
                                       SET Z_TROSKOVI = suma_troskova_2 + nvl(x1.Z_TROSKOVI,0)
                                       WHERE vrsta_dok = vVrsta_dok
                                         and broj_dok  = vBroj_dok
                                         and godina    = nGodina
                                         and stavka    = x1.stavka;
                             WHEN vrsta_Magacina = 'VP4' THEN
                                  If nStatusDokumenta = -8 then
                                     UPDATE STAVKA_DOK
                                        SET Z_TROSKOVI = suma_troskova_2 + nvl(x1.Z_TROSKOVI,0)
                                            ,cena1     = round(((x1.kolicina * x1.cena * (1-x1.rabat/100) + nvl(suma_troskova_2,0) + nvl(x1.Z_TROSKOVI,0)) / x1.kolicina)*(100 + nPreprodajniProcenat ) / 100,2)
                                           WHERE vrsta_dok = vVrsta_dok
                                             and broj_dok  = vBroj_dok
                                             and godina    = nGodina
                                             and stavka    = x1.stavka;
                                  End if;                                         
                             WHEN vrsta_Magacina = 'NAB'    THEN
                                  if nStatusDokumenta = -8 then
                                          UPDATE STAVKA_DOK
                                             SET Z_TROSKOVI = suma_troskova_2 + nvl(x1.Z_TROSKOVI,0)
                                                ,cena1      = round(
--                                                                    (x1.kolicina * x1.cena1 + suma_troskova_2 + nvl(x1.Z_TROSKOVI,0)) / x1.kolicina
                                                                    (x1.kolicina * x1.cena1 + suma_troskova_2) / x1.kolicina
                                                                    ,4)
                                           WHERE vrsta_dok = vVrsta_dok
                                             and broj_dok  = vBroj_dok
                                             and godina    = nGodina
                                             and stavka    = x1.stavka;
                                 else
                                          dbms_output.put_line('po formuli 2 z_tro ' || to_char(suma_troskova_2));                     
                                          UPDATE STAVKA_DOK
                                             SET Z_TROSKOVI = suma_troskova_2 + nvl(x1.Z_TROSKOVI,0)
                                           WHERE vrsta_dok = vVrsta_dok
                                             and broj_dok  = vBroj_dok
                                             and godina    = nGodina
                                             and stavka    = x1.stavka;
                                 end if;
                             ELSE
                                  NULL;
                             End Case;
                             kontrolna_suma_troskova_2 := kontrolna_suma_troskova_2 +  nvl(x1.Z_TROSKOVI,0);                             
                          End If;  
                          commit;          
            END LOOP;              
           -- rad po formuli 2  -- kraj obrade   

END;
/
