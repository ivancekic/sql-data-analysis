SELECT
       D.GODINA, D.VRSTA_DOK, D.BROJ_DOK, D.ORG_DEO, D.BROJ_DOK1, TO_CHAR(D.DATUM_DOK,'DD.MM.YY') DAT
,      UK_NIV
FROM
      dokument  d
   , (SELECT VD.GODINA, VD.VRSTA_DOK, VD.BROJ_DOK, COUNT(*) UK_NIV
      FROM VEZNI_DOK VD
      WHERE VD.ZA_VRSTA_DOK = 90 AND VD.vrsta_dok in ('11','12','13','31') AND VD.GODINA = 2012
      GROUP BY VD.GODINA, VD.VRSTA_DOK, VD.BROJ_DOK
      ) VD
WHERE d.godina = 2012
  AND D.STATUS > 0
  AND D.ORG_DEO = 104
  AND D.DATUM_DOK <= to_date('29.02.2012','dd.mm.yyyy')
  AND D.VRSTA_DOK IN ('11','12','13','31')
  AND (D.GODINA,D.VRSTA_DOK,D.BROJ_DOK) IN
      (select sd1.godina, sd1.vrsta_Dok, sd1.broj_dok
	   from DOKUMENT D1, stavka_Dok sd1
	   where D1.vrsta_dok in ('11','12','13','31')
	     and sd1.cena != round(sd1.cena1*faktor,4)
	     AND d1.godina = sd1.godina and d1.vrsta_dok = sd1.vrsta_dok and d1.broj_dok = sd1.broj_dok
	   group by sd1.godina, sd1.vrsta_Dok, sd1.broj_dok
	   HAVING count(*) > 0
      )


   AND D.godina = VD.godina and D.vrsta_dok = VD.vrsta_dok and D.broj_dok = VD.broj_dok
