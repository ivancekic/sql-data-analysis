Create or Replace Procedure INVEJ.NivelacijaPrijemnice ( pGodina Number, pVrstaDok Varchar2, pBrojDok Varchar2, pOrgDeo Number ) Is

cursor c1 is
   SELECT
		  d.datum_dok, d.datum_unosa, d.org_deo, d.broj_dok1
        , sd.*

	 FROM dokument d, stavka_dok sd
	WHERE d.godina    = pGodina
	  AND d.vrsta_dok = pVrstaDok
	  AND d.broj_dok  = pBrojDok
	  AND d.org_deo   = pOrgDeo

	  AND d.godina    = sd.godina
	  AND d.vrsta_dok = sd.vrsta_dok
	  AND d.broj_dok  = sd.broj_dok

	ORDER BY stavka
;
slogc1 c1 % rowtype;

cStanjeZalihe Number;
cStanje Number;
cCena   Number;
cValuta VarChar2(3);

nDokNivel    Number := 0;
nSekvenca    Number;
nMaxBrojDok1 Number;
nStavkaNivelacije Number := 1;


BEGIN


open c1;
  loop
	fetch c1 into slogc1;
	exit when c1 % NOTFOUND;


        DBMS_OUTPUT.PUT_LINE ('================================' );


        Begin
          Select stanje Into cStanjeZalihe
            From Zalihe
           Where org_deo  = slogc1.org_deo
             And proizvod = slogc1.proizvod
          ;
        Exception
        When No_Data_Found Then

          cStanjeZalihe := 0;
        End;
        --------
        		UPDATE PRODAJNI_CENOVNIK_2
	        	   SET stanje = cStanjeZalihe
	        	 WHERE org_deo  = slogc1.org_deo
	        	   AND proizvod = slogc1.proizvod
	            ;


        Begin
          Select stanje,  cena,  valuta
            Into cStanje, cCena, cValuta
            From PRODAJNI_CENOVNIK_2
           Where org_deo  = slogc1.org_deo
             And proizvod = slogc1.proizvod
          ;
        Exception
        When No_Data_Found Then
            cStanje := -10;

            If cStanjeZalihe != 0 Then
               cCena := nvl(PCena1MagVP4.MagVP4Cena1(slogc1.org_deo, slogc1.proizvod), 0);
            ElsIf cStanjeZalihe = 0 Then
               cCena := slogc1.cena1;
            End If;


	        INSERT INTO PRODAJNI_CENOVNIK_2(PROIZVOD,DATUM,ORG_DEO,STANJE,VALUTA,CENA,RABAT,REGRES,KOL_CENA,JM_CENA,FAK_CENA)
	             VALUES (slogc1.proizvod, slogc1.datum_dok, slogc1.org_deo, cStanjeZalihe,
	                     slogc1.valuta, cCena, null, null, 1,slogc1.jed_mere,1)
	        ;

--        COMMIT;

        DBMS_OUTPUT.PUT_LINE ('==== INSERTOVANO :  proizv: ' ||slogc1.proizvod||' orgd: '||slogc1.org_deo);
        End;


        -- Ako IMA nesto na zalihama
        IF cStanjeZalihe != 0 THEN
	        IF cCena != slogc1.cena1 AND cCena < slogc1.cena1 THEN

	            If nDokNivel = 0 Then

	                --- ** SEKVENCA **
	                Begin
		                select stanje + 1 Into nSekvenca
		                  from sekvenca
						 where naziv like 'BROJ_NIVELACIJE'
						   and godina = slogc1.godina
						 ;
					Exception
					When No_Data_Found Then
					     nSekvenca := 1;

					     Insert Into SEKVENCA(NAZIV,GODINA,STANJE,INIT,INC)
					          Values ('BROJ_NIVELACIJE', slogc1.godina, 1, 1, 1)
					     ;
--					     COMMIT;
					End;
					--- ** KRAJ SEKVENCE **
					--- ** MAX BROJ_DOK1 -- SEKVENCAORG **
					Begin

					    select stanje + 1 Into nMaxBrojDok1
		                  from sekvencaorg
						 where naziv like 'BROJ_NIVELACIJE'
						   and godina = slogc1.godina
						   and org_deo = slogc1.org_deo
					     ;
					Exception
					When No_Data_Found Then
						 nMaxBrojDok1 := 1;

					     Insert Into SEKVENCAORG(ORG_DEO,NAZIV,GODINA,STANJE,INIT,INC)
					          Values (slogc1.org_deo, 'BROJ_NIVELACIJE', slogc1.godina, 1, 1, 1)
					     ;
--					     COMMIT;
					End;
					--- ** KRAJ BROJ_DOK1 **



	            	INSERT INTO DOKUMENT(VRSTA_DOK,BROJ_DOK,GODINA,TIP_DOK,DATUM_DOK,DATUM_UNOSA,STATUS,ORG_DEO,POSLOVNICA,VRSTA_IZJAVE,BROJ_DOK1)
	            	     VALUES ('80', to_char(nSekvenca), slogc1.godina, 90, slogc1.datum_dok, sysdate, 1, slogc1.org_deo, 18, 3, to_char(nMaxBrojDok1) )
	            	;
--	            	COMMIT;
	            	DBMS_OUTPUT.PUT_LINE ('==== INSERTOVAN DOKUMENT 80 :  brdok: ' ||nSekvenca||' orgd: '||slogc1.org_deo||' brdok1'||nMaxBrojDok1);

                        -- Ovaj UPDATE je zbog vremena upisa nivelacije
	            	    UPDATE DOKUMENT
	            	       SET datum_unosa = slogc1.datum_unosa - 0.00010
	            	     WHERE godina    = slogc1.godina
	            	       AND vrsta_dok = '80'
	            	       AND broj_dok  = to_char(nSekvenca)
	            	     ;

                        UPDATE sekvenca
                           SET stanje = nSekvenca
						 WHERE naziv like 'BROJ_NIVELACIJE'
						   AND godina = slogc1.godina
						;
--						COMMIT;

                        UPDATE sekvencaorg
                           SET stanje = nMaxBrojDok1
						 WHERE naziv like 'BROJ_NIVELACIJE'
						   AND godina = slogc1.godina
						   AND org_deo = slogc1.org_deo
						;
--						COMMIT;

	            	nDokNivel := 1;
	            End If;


	                INSERT INTO STAVKA_DOK (BROJ_DOK,VRSTA_DOK,GODINA,STAVKA,PROIZVOD,KOLICINA,JED_MERE
	                                       ,CENA,VALUTA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,POREZ,CENA1)
	                     VALUES (  to_char(nSekvenca), '80', slogc1.godina, nStavkaNivelacije, slogc1.proizvod, cStanjeZalihe, slogc1.jed_mere
	                             , cCena, slogc1.valuta, 0, 0, 0, 1, 1, cStanjeZalihe, slogc1.porez, slogc1.cena1 )
	                ;
--	                COMMIT;
	                nStavkaNivelacije := nStavkaNivelacije + 1;




	        	UPDATE PRODAJNI_CENOVNIK_2
	        	   SET cena = slogc1.cena1, datum = sysdate
	        	 WHERE org_deo  = slogc1.org_deo
	        	   AND proizvod = slogc1.proizvod
	            ;
--	            COMMIT;

	            DBMS_OUTPUT.PUT_LINE ('** proiz: ' ||slogc1.proizvod ||' bila cena : '|| cCena ||' nova cena : '|| slogc1.cena1);

                   -- ****  LOG  ****
	                INSERT INTO PRODAJNI_CENOVNIK_2_LOG ( DATUM_IZMENE,VRSTA_DOK,BROJ_DOK,GODINA,ORG_DEO,NIV_VRSTA_DOK,NIV_BROJ_DOK,NIV_GODINA
	                                                     ,PROIZVOD,ZALIHA,KOLICINA,CENA1_OLD,CENA1_NEW,NAPOMENA)
	                     VALUES ( sysdate, '3', slogc1.broj_dok, slogc1.godina, slogc1.org_deo, '80', to_char(nSekvenca), slogc1.godina
	                            , slogc1.proizvod, cStanjeZalihe, slogc1.kolicina, cCena, slogc1.cena1, 'Zaliha >0 i cena je < od prijema. Uradjena nivelacija.' )

	                ;
--	                COMMIT;


	          -- Ako je cena na prijemnici manja od cene u PRODAJNI_CENOVNIK_2 => UPDATE na STAVKA_DOK polje Cena1
            ELSIF cCena != slogc1.cena1 AND cCena > slogc1.cena1 THEN

                    -- ****  LOG  ****
	                INSERT INTO PRODAJNI_CENOVNIK_2_LOG ( DATUM_IZMENE,VRSTA_DOK,BROJ_DOK,GODINA,ORG_DEO,NIV_VRSTA_DOK,NIV_BROJ_DOK,NIV_GODINA
	                                                     ,PROIZVOD,ZALIHA,KOLICINA,CENA1_OLD,CENA1_NEW,NAPOMENA)
	                     VALUES ( sysdate, '3', slogc1.broj_dok, slogc1.godina, slogc1.org_deo, '3', slogc1.broj_dok, slogc1.godina
	                            , slogc1.proizvod, cStanjeZalihe, slogc1.kolicina, slogc1.cena1, cCena, 'Zaliha >0 i cena je > od prijema. Update CENA1 na prijemnici.' )

	                ;
--	                COMMIT;

	        	UPDATE STAVKA_DOK
	        	   SET cena1 = cCena
	        	 WHERE godina    = pGodina
				   AND vrsta_dok = pVrstaDok
				   AND broj_dok  = pBrojDok
				   AND proizvod  = slogc1.proizvod
	           ;
--	            COMMIT;



	        END IF;


        -- Ako NEMA nista na zalihama = 0 samo radimo UPDATE cene u slucaju da se razlikuje

        ELSIF cStanjeZalihe = 0 THEN

           IF cCena != slogc1.cena1 THEN
                    -- ****  LOG  ****
	                INSERT INTO PRODAJNI_CENOVNIK_2_LOG ( DATUM_IZMENE,VRSTA_DOK,BROJ_DOK,GODINA,ORG_DEO,NIV_VRSTA_DOK,NIV_BROJ_DOK,NIV_GODINA
	                                                     ,PROIZVOD,ZALIHA,KOLICINA,CENA1_OLD,CENA1_NEW,NAPOMENA)
	                     VALUES ( sysdate, '3', slogc1.broj_dok, slogc1.godina, slogc1.org_deo, '3', slogc1.broj_dok, slogc1.godina
	                            , slogc1.proizvod, cStanjeZalihe, slogc1.kolicina, cCena, slogc1.cena1, 'Zaliha =0, cena nebitna. Update CENA u PRODAJNI_CENOVNIK_2.' )

	                ;
--	                COMMIT;

	        	UPDATE PRODAJNI_CENOVNIK_2
	        	   SET cena = slogc1.cena1, datum = sysdate
	        	 WHERE org_deo  = slogc1.org_deo
	        	   AND proizvod = slogc1.proizvod
	            ;
--	            COMMIT;

           END IF;


         /*
	        IF cCena != slogc1.cena1 AND cCena < slogc1.cena1 THEN

	        	UPDATE PRODAJNI_CENOVNIK_2
	        	   SET cena = slogc1.cena1, datum = sysdate
	        	 WHERE org_deo  = slogc1.org_deo
	        	   AND proizvod = slogc1.proizvod
	            ;
--	            COMMIT;

            ELSIF cCena != slogc1.cena1 AND cCena > slogc1.cena1 THEN

	        	UPDATE STAVKA_DOK
	        	   SET cena1 = cCena
	        	 WHERE godina    = pGodina
				   AND vrsta_dok = pVrstaDok
				   AND broj_dok  = pBrojDok
				   AND proizvod  = slogc1.proizvod
	           ;
--	            COMMIT;

            END IF;
         */


        END IF;




  end loop;

--  COMMIT;
	    DBMS_OUTPUT.PUT_LINE ('================================' );
close c1;



EXCEPTION
WHEN OTHERS THEN

ROLLBACK;

END;
/
/
CREATE PUBLIC SYNONYM NivelacijaPrijemnice
    FOR INVEJ.NivelacijaPrijemnice
/
GRANT EXECUTE ON Invej.NivelacijaPrijemnice TO EXE
