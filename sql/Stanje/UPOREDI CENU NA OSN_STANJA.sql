SELECT * FROM
(
	SELECT PRO, STANJE, VREDNOST
	     , (CASE WHEN STANJE = 0 THEN
	                  VREDNOST
	        ELSE
	                  ROUND(VREDNOST / STANJE,4)
	        END
	       ) CENA_IZVEDENA
	     , PPRODAJNICENOVNIK.Cena( PRO , SYSDATE , 'YUD', 1) CENA_PROD
	FROM
	(
	Select SD.Proizvod pro,
	       round(Sum(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor
	                       * case when D.vrsta_dok = '90' then
	                                0
	                         else
	                                K_ROBE
	                         end
	           ,0)),5) STANJE,
	       round(Sum(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor*
	          (CASE WHEN D.VRSTA_DOK = '80' THEN
	                (SD.CENA1-SD.CENA)
	               WHEN D.vrsta_dok  ='90' then
	                ROUND((NVL(SD.cena,0)-NVL(SD.cena1,0)),4)
	           ELSE K_ROBE*(
	                        CASE WHEN D.VRSTA_DOK = 11 AND UPPER(ORGD.DODATNI_TIP) = 'VP2' THEN
	                                  SD.CENA1
	                        ELSE
	                                  SD.CENA1
	                        END
	                       )
	       END),0)),2) VREDNOST
	      From Dokument d,
	           (SELECT BROJ_DOK,VRSTA_DOK,GODINA,STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,
	                   PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI
	            FROM STAVKA_DOK
	           ) SD, Proizvod P, ORG_DEO_OSN_PODACI ORGD
	Where D.Vrsta_Dok = SD.Vrsta_Dok And D.Broj_Dok = SD.Broj_Dok And D.Godina = SD.Godina And D.ORG_DEO = ORGD.ORG_DEO (+)
	  AND D.Status > 0 And D.Datum_Dok Between (SELECT MAX(DATUM_DOK) FROM DOKUMENT WHERE GODINA = 2009 and org_deo = 103 and vrsta_Dok = 21) And SYSDATE
	  And (SD.K_Robe != 0 OR D.VRSTA_DOK = '80')
	  And D.Org_Deo = 105 And P.sifra = SD.proizvod
	--Group By d.godina, d.vrsta_dok,d.broj_dok, d.tip_dok, d.status, d.datum_dok, d.datum_unosa, sd.proizvod
	         --SD.Proizvod,P.tip_proizvoda, P.posebna_grupa,P.grupa_proizvoda,P.naziv
	Group By sd.proizvod
	)
)
WHERE STANJE >0 AND VREDNOST >0 --AND CENA_IZVEDENA <> CENA_PROD
Order By to_number(PRO)
