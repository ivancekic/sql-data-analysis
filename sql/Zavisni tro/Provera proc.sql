Declare

nStatusDokumenta number := 1;
vVrstaMagacina varchar2(20) := 'VP4';
vVrsta_dok varchar2(20) := 3;
vBroj_dok varchar2(20) := '17540';
nGodina number := 2010;

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


nZtroD Number;
cena1  Number;

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

           if suma_troskova_1 <> 0  or vrsta_Magacina = 'VP4'  then

              -------------------------------------------------------------------------------------------
              -- PRESABIRANJE BROJA STAVKI U DOKUMENTU I UKUPNE VREDNOSTI DOKUMENTA DA BI SE
              -- DOBILI PROCENTI ZA RASPOREDJIVANJE ZAVISNIH TROSKOVA PO VREDNOSTI
              -------------------------------------------------------------------------------------------
              broj_stavki := 0;
              uk_suma_dok := 0 ;
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

                        CASE WHEN vrsta_Magacina like 'VP%' And vrsta_Magacina <> 'VP4' THEN
                              nZtroD := nvl(z_troskovi_za_stavku,0);
                              cena1  := round(((x.kolicina * x.cena * (1-x.rabat/100) + nvl(z_troskovi_za_stavku,0)) / x.kolicina)*
                                               (100 + nPreprodajniProcenat ) / 100,2);
                              WHEN vrsta_Magacina = 'VP4' THEN
                                  If nStatusDokumenta = -8 then
                                     nZtroD := nvl(z_troskovi_za_stavku,0);
                                     cena1  := round(((x.kolicina * x.cena * (1-x.rabat/100) + nvl(z_troskovi_za_stavku,0)) / x.kolicina)*
                                                      (100 + nPreprodajniProcenat ) / 100,2);
                                  End if;
                             --------------------deja
                             WHEN vrsta_Magacina = 'NAB'    THEN
                                  if nStatusDokumenta = -8 then
                                     nZtroD := nvl(z_troskovi_za_stavku,0);
                                     cena1  := round(((x.kolicina * x.cena * (1-x.rabat/100) + nvl(z_troskovi_za_stavku,0)) / x.kolicina)*
                                                      (100 + nPreprodajniProcenat ) / 100,2);
                                 else
                                     nZtroD := nvl(z_troskovi_za_stavku,0);
                                     cena1  := round(((x.kolicina * x.cena * (1-x.rabat/100) + nvl(z_troskovi_za_stavku,0)) / x.kolicina)*
                                                      (100 + nPreprodajniProcenat ) / 100,2);
                                 end if;
                             ELSE
                                  NULL;
                        END CASE;


Dbms_Output.Put_line( ' cena ' || to_char(cena1) || '  z_tro  ' || to_char(nZtroD) );

                        kontrolna_suma_troskova := kontrolna_suma_troskova +  z_troskovi_za_stavku;
                        i:=i+1;

              end loop;
--              commit;
           end if;


END;
