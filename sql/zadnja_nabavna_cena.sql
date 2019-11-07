SELECT PRO, NAZIV, ZADNJI_DATUM, ZADNJI_UNOS
,
       ( --SELECT ROUND(SD1.CENA*(1-NVL(SD1.RABAT,0) /100),2)
--         Select ROUND(sum(SD1.CENA*(1-NVL(SD1.RABAT,0) /100)*sd1.kolicina)/(sum(sd1.kolicina)),4)
         Select ROUND(sum(SD1.CENA*(1-NVL(SD1.RABAT,0) /100)),4)
         FROM dokument D1, stavka_dok SD1
         WHERE D1.godina = SD1.godina and D1.vrsta_dok = SD1.vrsta_dok and D1.broj_dok = SD1.broj_dok
 	       and D1.vrsta_dok = '3' AND D1.TIP_DOK = 10 AND D1.BROJ_DOK1 > 0
           AND (D1.DATUM_DOK = ZADNJI_DATUM AND D1.DATUM_UNOSA = ZADNJI_UNOS AND SD1.PROIZVOD = PRO)
       ) ZADNJA_NABAVNA_CENA
FROM
(
	Select P.SIFRA PRO, p.naziv NAZIV, MAX(D.DATUM_DOK) ZADNJI_DATUM, MAX(D.DATUM_UNOSA) ZADNJI_UNOS--, SD.KOLICINA UKUPNO
	From dokument D, stavka_dok SD, proizvod P
	Where D.godina = SD.godina and D.vrsta_dok = SD.vrsta_dok and D.broj_dok = SD.broj_dok
	  and SD.proizvod = P.sifra
	  --------------------------
	  and D.vrsta_dok   = '3' AND D.TIP_DOK = 10 AND D.BROJ_DOK1 > 0
	  and D.org_deo not in (select partner_magacin_flag.magacin
	                                 from partner_magacin_flag)
      AND SD.PROIZVOD in ('0331101','0329021','0333901','0331102','0331315','0341107','0329009','0312004','0313001','0331616','0333309',
                          '0333201','0323011','0342205','0333102','0333101','0323014','0331201','0333104','0331617','0312002','0331202',
                          '0329013','0331943','0341210','0341201','0329002','0331309','0331103','0331947','0331907')
	GROUP BY P.SIFRA, p.naziv--, KOLICINA
)
ORDER BY TO_NUMBER(PRO)
