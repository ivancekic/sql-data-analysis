Declare
  nBrojac    Number := 0 ;
  nStavka    Number :=   1 ;
  cRadnik    Varchar2(7);
  nMagacin   Number := 68;
  nIzmenjeno Number := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE (' rbr  god  vr tip      datum   BrDok st   org  BrDok1 mag2');
  DBMS_OUTPUT.PUT_LINE ('---- ---- --- --- ---------- ------- -- ----- ------- ----');

    for intotp in (Select d.godina , d.vrsta_dok, d.tip_dok,d.datum_dok , d.broj_dok,d.status, d.org_deo, d.broj_dok1,d.poslovnica
                   From dokument d
                   Where d.vrsta_dok  IN ( 11 )
                     and d.tip_dok = 23
                     and to_char(DATUM_UNOSA,'dd.mm.yyyy') = '04.01.2008'
                   order by d.godina,to_number(d.vrsta_dok),to_number(d.broj_dok)--,sd.stavka
                  )
  LOOP
  nBrojac    := nBrojac + 1 ;
  nIzmenjeno := nIzmenjeno + 1 ;
       DBMS_OUTPUT.PUT_LINE (LPAD(to_char(nBrojac),4)        ||' '||
                             lpad(to_char(intotp.godina),4)  ||' '||
                             LPAD(intotp.vrsta_dok,3)        ||' '||
                             lpad(to_char(intotp.tip_dok),3) ||' '||
                             lpad(to_char(intotp.datum_dok,'dd.mm.yyyy'),10) ||' '||
                             LPAD(intotp.broj_dok,7)         ||' '||
                             lpad(to_char(intotp.status),2)  ||' '||
                             lpad(to_char(intotp.org_deo),5) ||' '||
                             LPAD(intotp.broj_dok1,7)        ||' '||
                             lpad(to_char(intotp.poslovnica),4)
                            );
  DBMS_OUTPUT.PUT_LINE ('      Proizvod  jm   kolicina     cena  fakt    cena1       vrednost');
  DBMS_OUTPUT.PUT_LINE ('      -------- --- ---------- -------- ----- -------- --------------');
    for intotpstavke in (Select sd.proizvod, sd.jed_mere, sd.kolicina,
                                sd.cena, sd.faktor,sd.cena1
                         From Stavka_dok sd
                         Where intotp.godina    = Godina
                           and intotp.vrsta_dok = Vrsta_dok
                           and intotp.broj_dok  = broj_dok

                        )

    loop
--             ,pproizvod.naziv(sd.proizvod)
             DBMS_OUTPUT.PUT_LINE (LPAD(intotpstavke.proizvod,14)    ||' '||
                                   LPAD(intotpstavke.jed_mere,3 )    ||' '||
                                   lpad(to_char(intotpstavke.kolicina),10) ||' '||
                                   lpad(to_char(intotpstavke.cena),8) ||' '||
                                   lpad(to_char(intotpstavke.faktor),5)    ||' '||
                                   lpad(to_char(intotpstavke.cena1),8) ||' '||
                                   lpad(to_char(round(intotpstavke.cena1 * intotpstavke.kolicina,2),'9999999999.90'),14)
                                  );

    end loop;

    For vezni in(Select za_godina , za_vrsta_dok , za_broj_dok
                 From Vezni_dok
                 Where intotp.godina    = Godina
                   and '24'             = Vrsta_dok
                   and intotp.broj_dok  = broj_dok
                   and za_vrsta_dok     = 3
                )
    loop
          DBMS_OUTPUT.PUT_LINE (' VEZNI  god  vr   BrDok');
          DBMS_OUTPUT.PUT_LINE ('       ---- --- -------');
          DBMS_OUTPUT.PUT_LINE (LPAD(' ',6)        ||' '||
                                lpad(to_char(vezni.ZA_godina),4)  ||' '||
                                LPAD(vezni.ZA_vrsta_dok,3)        ||' '||
                                LPAD(vezni.ZA_broj_dok,7)
                             );
              DBMS_OUTPUT.PUT_LINE ('      Proizvod  jm   kolicina     cena  fakt    cena1       vrednost');
              DBMS_OUTPUT.PUT_LINE ('      -------- --- ---------- -------- ----- -------- --------------');

          FOR intprij in (Select sd.proizvod, sd.jed_mere, sd.kolicina,
                                sd.cena, sd.faktor,sd.cena1
                         From Stavka_dok sd
                         Where vezni.za_godina    = Godina
                           and vezni.za_vrsta_dok = Vrsta_dok
                           and vezni.za_broj_dok  = broj_dok
                         )
          Loop
             DBMS_OUTPUT.PUT_LINE (LPAD(intprij.proizvod,14)    ||' '||
                                   LPAD(intprij.jed_mere,3 )    ||' '||
                                   lpad(to_char(intprij.kolicina),10) ||' '||
                                   lpad(to_char(intprij.cena),8) ||' '||
                                   lpad(to_char(intprij.faktor),5)    ||' '||
                                   lpad(to_char(intprij.cena1),8) ||' '||
                                   lpad(to_char(round(intprij.cena1 * intprij.kolicina,2),'9999999999.90'),14)
                                  );

          End Loop;
    end loop;
  DBMS_OUTPUT.PUT_LINE ('--------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE (' rbr  god  vr tip      datum   BrDok st   org  BrDok1 mag2');
  DBMS_OUTPUT.PUT_LINE ('---- ---- --- --- ---------- ------- -- ----- ------- ----');

  END lOOP;

END;
