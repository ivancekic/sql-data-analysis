select ORG_DEO,PROIZVOD,POSEBNA_GRUPA,STANJE,VREDNOST,U_KONTROLI,CENA,cena_pros
     , CENA - cena_pros razlika
from
(
	select p.org_deo, p.PROIZVOD,p.POSEBNA_GRUPA,p.STANJE,p.VREDNOST,p.U_KONTROLI
	    , case when p.stanje <> 0 Then round(p.vrednost/p.stanje,4) else 0 end cena
	    , round(pc1.cena,4) cena_pros
	from
	(
		SELECT P.ORG_DEO,P.SIFRA,P.PROIZVOD,P.POSEBNA_GRUPA,P.STANJE,P.VREDNOST
		,U_KONTROLI
		FROM
		(
		         Select d.org_deo, p.sifra, sd.Proizvod, P.posebna_grupa,
		                round(Sum(NVL(decode(d.tip_dok,14,Kolicina,realizovano)*Faktor
		                                * case when d.vrsta_dok = '90' then 0 else K_ROBE end
		                                ,0)),5) STANJE,
		                round(Sum(NVL(decode(d.tip_dok,14,Kolicina,realizovano)*Faktor*
		                                    (CASE WHEN d.VRSTA_DOK = '80' THEN
		                                               (sd.CENA1-sd.CENA)
		                                          WHEN d.vrsta_dok  ='90' then
		                                               ROUND((NVL(sd.cena,0)-NVL(sd.cena1,0)),2)
		                                     ELSE K_ROBE*(
		                                                    CASE WHEN d.VRSTA_DOK = 11 AND UPPER(ORGD.DODATNI_TIP) = 'VP2' THEN
		                                                              sd.CENA1
		                                                    ELSE
		                                                              sd.CENA1
		                                                    END
		                                                 )
		                                    END)
		                             ,0)),2) VREDNOST

		               From Dokument d,
		                    (SELECT  BROJ_DOK, VRSTA_DOK, GODINA,
		                             STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,PAKOVANJE,BROJ_KOLETA,
		                             K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI
		                       FROM STAVKA_DOK
		                    ) sd,
		                    Proizvod p,
		                    ORG_DEO_OSN_PODACI ORGD
		                    , TIP_PROIZVODA TP

		         Where d.Vrsta_Dok = sd.Vrsta_Dok And
		               d.Broj_Dok = sd.Broj_Dok And
		               d.Godina = sd.Godina And
		               d.ORG_DEO = ORGD.ORG_DEO (+) AND
		               d.Status > 0 And
		               d.Datum_Dok between to_date('01.01.'||to_char(&nGod),'dd.mm.yyyy') and to_date('31.12.'||to_char(&nGod),'dd.mm.yyyy') and
		               (sd.K_Robe != 0 OR d.VRSTA_DOK = '80') And
		               d.Org_Deo = NVL(&nOrgDeo,D.ORG_DEO) And
		               P.sifra=sd.proizvod
	      AND TP.SIFRA=P.TIP_PROIZVODA
		  AND TP.CENA=1
		  and sd.k_robe <> 0
		  and d.org_deo <> 1376

		         Group By d.org_deo, p.sifra, sd.Proizvod,P.tip_proizvoda,P.posebna_grupa,P.grupa_proizvoda,P.naziv
		) P
		,
		(

		        select DX.ORG_DEO, STX.PROIZVOD, sum(kolicina*faktor) U_KONTROLI
		         from dokument dx, stavka_dok stx
		        where dx.vrsta_dok = stx.vrsta_dok and dx.broj_dok = stx.broj_dok and dx.godina = stx.godina
		          and dx.vrsta_dok = 3 and dx.tip_dok   = 10 and dx.status in ('-8','-9') and dx.godina > 2008
		        GROUP BY DX.ORG_DEO, STX.PROIZVOD
		)  K

		WHERE K.ORG_DEO (+) = P.ORG_DEO
		  AND K.PROIZVOD (+) = P.PROIZVOD

	)   P
	,
	(
		Select pc.org_deo,pc.proizvod, MAX(pc.DATUM) max_dat, pc1.CENA
		from prosecni_cenovnik pc
		   , prosecni_cenovnik pc1
		Where pc1.org_deo (+)= pc.org_deo
		  and pc1.proizvod (+) = pc.proizvod
		Group by pc.org_deo,pc.proizvod,pc1.CENA
	)  pc1


	WHERE STANJE <> 0
	  and pc1.org_deo (+)= p.org_deo
	  and pc1.proizvod (+) = p.proizvod

) p
where CENA <> cena_pros
Order By P.posebna_grupa,p.proizvod
