select * from dokument vd
where (	vd.BROJ_DOK,vd.VRSTA_DOK,vd.GODINA)
in
(

	SELECT
	vd.BROJ_DOK,vd.VRSTA_DOK,vd.GODINA
--	D.org_deo,d.datum_dok,
--	VD.*
--	, sd.*
--	, sd1.uk_razl
	FROM DOKUMENT D, VEZNI_DOK VD
	   , (select sd.godina, sd.vrsta_Dok, sd.broj_dok, count(*) uk_isti
	      from stavka_Dok sd
	      where vrsta_dok in ('11','12','13','31')
	        and sd.cena = round(sd.cena1*faktor,4)
	      group by sd.godina, sd.vrsta_Dok, sd.broj_dok
	     ) sd

	   , (select sd.godina, sd.vrsta_Dok, sd.broj_dok, count(*) uk_razl
	      from stavka_Dok sd
	      where vrsta_dok in ('11','12','13','31')
	        and sd.cena != round(sd.cena1*faktor,4)
	      group by sd.godina, sd.vrsta_Dok, sd.broj_dok
	     ) sd1

	WHERE VD.GODINA = 2012 AND VD.VRSTA_DOK='90' and org_deo between 103 and 108
	  AND d.godina = Vd.godina and d.vrsta_dok = Vd.vrsta_dok and d.broj_dok = Vd.broj_dok
	  AND vd.za_godina = sd.godina (+) and vd.za_vrsta_dok = sd.vrsta_dok (+) and vd.za_broj_dok = sd.broj_dok (+)
	  AND vd.za_godina = sd1.godina (+) and vd.za_vrsta_dok = sd1.vrsta_dok (+) and vd.za_broj_dok = sd1.broj_dok (+)
and sd1.uk_razl is null
)
--Order by org_deo, datum_dok, datum_unosa
