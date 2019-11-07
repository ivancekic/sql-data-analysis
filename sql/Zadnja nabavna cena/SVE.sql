alter table invej.proizvod add zad_nab_cena_dok_vred number null;
alter table invej.proizvod add zad_nab_cena_dok_dat  date null;
alter table invej.proizvod add zad_nab_cena_rucni_unos  number null;

CREATE TABLE invej.PLANIRANJE_MAPIRANJE
(
    VRSTA    VARCHAR2(100) NOT NULL,
    RED_BROJ NUMBER        NOT NULL,
    VREDNOST VARCHAR2(50)  NOT NULL
)
ORGANIZATION HEAP
TABLESPACE DES2
NOLOGGING
PCTFREE 10
PCTUSED 0
INITRANS 1
MAXTRANS 255
STORAGE(BUFFER_POOL DEFAULT)
NOPARALLEL
NOCACHE
/
ALTER TABLE invej.PLANIRANJE_MAPIRANJE
    ADD CONSTRAINT PLANIRANJE_MAPIRANJE_PK
    PRIMARY KEY (VRSTA,RED_BROJ,VREDNOST)
    USING INDEX TABLESPACE DES2
                PCTFREE 10
                INITRANS 2
                MAXTRANS 255
                STORAGE(BUFFER_POOL DEFAULT)
    LOGGING
    ENABLE
    VALIDATE
/


Create public synonym PLANIRANJE_MAPIRANJE FOR invej.PLANIRANJE_MAPIRANJE ;
/
-- ako je paket ili funkcija
--GRANT EXECUTE ON invej.PLANIRANJE_MAPIRANJE TO EXE
/

----------------------------------------------------
----------------------------------------------------
-- FULL_ACCESS      -- PL / SQL
-- RESTRICT_ACCESS  -- FORMS

-- ako je PLANIRANJE_MAPIRANJE, view
GRANT DELETE ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
GRANT INSERT ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
GRANT SELECT ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
GRANT UPDATE ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
GRANT ALTER ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
GRANT ON COMMIT REFRESH ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
GRANT QUERY REWRITE ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
GRANT DEBUG ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
GRANT FLASHBACK ON invej.PLANIRANJE_MAPIRANJE TO FULL_ACCESS
/
----
GRANT SELECT ON invej.PLANIRANJE_MAPIRANJE TO RESTRICT_ACCESS

/

CREATE OR REPLACE
Procedure GenerisiZadnjuNabavnuCenu Is

  cOldPro Varchar2(7);
  cZnak Varchar2(7);
  nRbr Number ;
  Cursor vratizadnabcenu_cur is
				Select
				       SD.PROIZVOD, d.datum_dok, P.NAZIV
				     , p.ZAD_NAB_CENA_DOK_VRED, p.ZAD_NAB_CENA_DOK_DAT
				     , SD.RABAT, SD.POREZ, SD.CENA, Z_TROSKOVI

				     , D.TIP_DOK

				     , VD.ZA_VRSTA_DOK
				     , CASE WHEN P.TIP_PROIZVODA = 8 THEN
				                 CASE WHEN NVL(Z_TROSKOVI,0) > 0 THEN
				                      ((SD.CENA*SD.KOLICINA)*(1-NVL(SD.RABAT,0)/100) + Z_TROSKOVI) / SD.KOLICINA
				                 ELSE
                                      (SD.CENA)*(1-NVL(SD.RABAT,0)/100)
                                 END
                       ELSE
                            SD.CENA1
				       END Cena1
				     , SD.KOLICINA
				From dokument d
				   , stavka_dok sd
				   , PROIZVOD P
				   , VEZNI_DOK VD
				Where d.broj_dok> 0
				  and d.vrsta_dok = '3'
				  and d.godina > 0
				  and d.tip_dok  in( 10,16)
				  and d.status   in (1,3)
				  and d.ppartner not in (select vrednost from PLANIRANJE_MAPIRANJE  where VRSTA ='SIFRA_NASE_FIRME_U_PARTNERIMA' )
				  and d.broj_dok  = sd.broj_dok and d.vrsta_dok = sd.vrsta_dok and d.godina = sd.godina
				  AND P.SIFRA=SD.PROIZVOD
				  And P.TIP_PROIZVODA NOT IN (select vrednost from PLANIRANJE_MAPIRANJE
                                                 where vrsta in ('GOT_PROIZVODI_TIPOVI','POLUPROIZVODI_TIPOVI')                                                )

				  and d.broj_dok  = Vd.broj_dok and d.vrsta_dok = Vd.vrsta_dok and d.godina = Vd.godina
				  AND (VD.ZA_VRSTA_DOK='24' OR VD.ZA_VRSTA_DOK='2' )
				Order by SD.PROIZVOD, d.datum_dok desc;

  vratizadnabcenu vratizadnabcenu_cur % rowtype;
  nCena Number;
  nCommit Number;
Begin
    nRbr := 1;
    nCommit := 0;
    dbms_output.put_line(rpad('red br',8)||' '||
                         rpad('proizvod',8)||' '||
                         Lpad('cena',10)||' '||
                         Rpad('datum',10)||' '||
                         Rpad('NAZIV',40)
                         ||' '||
                         lpad('ZBNC.DOK',10)||' '||
                         Rpad('ZBNC.DOK.DAT',10)

                         );
    dbms_output.put_line(rpad('-',8,'-')||' '||
                         rpad('-',8,'-')||' '||
                         Lpad('-',10,'-')||' '||
                         Lpad('-',10,'-')||' '||
                         Lpad('-',40,'-')
                         ||' '||
                         Lpad('-',10,'-')||' '||
                         Lpad('-',10,'-')
                         );

    Open vratizadnabcenu_cur;
    LOOP
    -- preuzme podatke , ako postoje
    Fetch vratizadnabcenu_cur Into vratizadnabcenu;
       EXIT WHEN vratizadnabcenu_cur % NOTFOUND ;
     If vratizadnabcenu_cur % NOTFOUND Then  -- ako podaci ne postoji
        nCena := 0;
     Else
        nCena := vratizadnabcenu.Cena1;
     End If;

        If nvl(cOldPro,'AA') <> vratizadnabcenu.proizvod then

           dbms_output.put_line(Lpad(nRbr,7)||'. '||
                                rpad(vratizadnabcenu.proizvod,8)||' '||
                                Lpad(vratizadnabcenu.cena1,10)||' '||
                                Lpad(TO_CHAR(vratizadnabcenu.datum_dok,'dd.mm.yyyy'),10)||' '||
                                RPAD(vratizadnabcenu.NAZIV,40)
||' '||
                                Lpad(NVL(to_char(vratizadnabcenu.ZAD_NAB_CENA_DOK_VRED),' '),10, ' ')
                                ||' '||
                                Lpad(nvl(to_char(vratizadnabcenu.ZAD_NAB_CENA_DOK_DAT,'dd.mm.yyyy'),' '),10,' ')
||'   '||to_char(nCommit)
--			                               || '     '||cOldPro
                               );
           nRbr := nRbr + 1;
           if vratizadnabcenu.datum_dok > nvl(vratizadnabcenu.ZAD_NAB_CENA_DOK_DAT,to_date('01.01.0001','dd.mm.yyyy')) then
		       update proizvod
		       set ZAD_NAB_CENA_DOK_VRED =vratizadnabcenu.cena1
		         , ZAD_NAB_CENA_DOK_DAT  =vratizadnabcenu.datum_dok
		       where sifra = vratizadnabcenu.proizvod;
               nCommit := nCommit + 1;
dbms_output.put_line('comm');
           end if;

           if nCommit = 101 then
              commit;
              nCommit := 1;
           end If;
        End If;
           cOldPro := vratizadnabcenu.proizvod;
    end loop;
    Close vratizadnabcenu_cur ;            -- zatvara kursor

    if nCommit > 0 then
              commit;
    end If;

--	      INSERT INTO DEJA_POMOCNA_TAB(POLJE1,POLJE2,POLJE79,,POLJE80)


END;
/


Create public synonym GenerisiZadnjuNabavnuCenu FOR invej.GenerisiZadnjuNabavnuCenu ;
/
-- ako je paket ili funkcija
GRANT EXECUTE ON invej.GenerisiZadnjuNabavnuCenu TO EXE
/
