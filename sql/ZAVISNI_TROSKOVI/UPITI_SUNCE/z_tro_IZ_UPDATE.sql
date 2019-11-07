Select DATUM_DOK, Org, GOD,VRD,BRD,BROJ_STAVKI,UK_SUMA_DOK,SUMA_TROSKOVA_1,KOLICINA,CENA1_OK,Z_TROSKOVI_ZA_STAVKU, Z_TROSKOVI_ZA_STAVKU_1
     , SUMA_TROSKOVA_1 - Z_TROSKOVI_ZA_STAVKU_1 Z_TO_LAST
     , round(
             (
                 (kolicina * cena * (1-rabat/100) + nvl(z_troskovi_za_stavku,0)) / kolicina)
               * (100 + PPreProdajniProcenat.Procenat(org,datum_dok) ) / 100
            ,4) CENA1_LAST
From
(
	Select DATUM_DOK, Org, GOD,VRD,BRD,BROJ_STAVKI,UK_SUMA_DOK,SUMA_TROSKOVA_1,KOLICINA,CENA1_OK,Z_TROSKOVI_ZA_STAVKU
	     ,
	     round(
	            (
	             round((kolicina * cena1_ok + z_troskovi_za_stavku) / kolicina,4)
	             -
	             cena1_ok
	            ) * kolicina
	          ,2) Z_TROSKOVI_ZA_STAVKU_1, cena, rabat
	From
	(
		Select DATUM_DOK,Org, GOD,VRD,BRD,BROJ_STAVKI,UK_SUMA_DOK,SUMA_TROSKOVA_1,KOLICINA,CENA1_OK
--		     , round(kolicina*cena1_ok/uk_suma_dok * suma_troskova_1,2) z_troskovi_za_stavku
		     , round(kolicina*cena1_ok/uk_suma_dok * suma_troskova_1,2) z_troskovi_za_stavku
		     , cena, rabat
		From
		(
			Select DATUM_DOK,Org, god, vrd, brd, BROJ_STAVKI, UK_SUMA_DOK
			     , (Select sum(zts.iznos_troska)
			        From zavisni_troskovi_stavke zts, zavisni_troskovi_vrste ztv
			        Where zts.vrsta_dok      = vrd
			          And zts.broj_dok       = brd
			          And zts.godina         = god
			          And zts.vrsta_troskova = ztv.vrsta_troskova
			          And ztv.formula        = 1
			       ) suma_troskova_1
			     , kolicina, cena1_OK, cena, rabat
			From
			(
				Select d.DATUM_DOK, D.Org_deo Org, d.godina god, d.vrsta_dok vrd, d.broj_dok brd, COUNT(*) BROJ_STAVKI
				     , SUM(ROUND(sd.KOLICINA*(sd.CENA*(1-sd.rabat/100)),2)) UK_SUMA_DOK
				     , kolicina, round(cena*(1-sd.rabat/100),4) cena1_OK
				     , cena, sd.rabat
				From stavka_dok sd, DOKUMENT D
				Where sd.vrsta_dok      = 3
				  And sd.broj_dok       = 211
				  And sd.godina         = 2010
				  And sd.godina    (+)= d.godina  and sd.vrsta_dok (+)= d.vrsta_dok  and sd.broj_dok  (+)= d.broj_dok
				Group by d.DATUM_DOK, d.org_deo, d.godina, d.vrsta_dok, d.broj_dok, kolicina, cena, sd.rabat
			)
		)
	)
)
