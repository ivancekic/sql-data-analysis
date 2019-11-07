select p1.VRSTA_DOK,p1.BROJ_DOK,p1.GODINA,p1.ORG_DEO,p1.BRD1,p1.DATUM_DOK,p1.USER_ID,p1.DATUM_UNOSA,p1.Z_TRO,p1.Z_TRO_TRO,p1.status
     , p1.NAR_BRD,p1.NAR_VRD,p1.NAR_GOD
     , d1.datum_dok, d1.user_id, d1.datum_unosa
from
(
	SELECT p.VRSTA_DOK, p.BROJ_DOK, p.GODINA, p.ORG_DEO, p.BRD1, p.DATUM_DOK, p.USER_ID, p.DATUM_UNOSA, p.Z_TRO, p.Z_TRO_TRO, p.status
	     , vd.za_broj_dok nar_brd, vd.za_vrsta_Dok nar_vrd, vd.za_godina nar_god
	FROM
	(
		Select SD.VRSTA_DOK,SD.BROJ_DOK,SD.GODINA, d.org_deo, d.broj_dok1 BRD1, d.datum_dok, d.user_id, d.datum_unosa, d.status
		     , SUM(NVL(Z_TROSKOVI,0)) Z_TRO, Z_TRO_TRO

		from  dokument d
		    , STAVKA_DOK SD
		    , (SELECT VRSTA_DOK,BROJ_DOK,GODINA, SUM(NVL(iznos_troska,0)) Z_TRO_TRO
		       FROM ZAVISNI_TROSKOVI_STAVKE
		       GROUP BY VRSTA_DOK,BROJ_DOK,GODINA
		       ) ZT
		where
		      D.GODINA = 2012
		  and D.vrsta_Dok = '3'
		  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
		  AND Sd.godina = ZT.godina and Sd.vrsta_dok = ZT.vrsta_dok and Sd.broj_dok = ZT.broj_dok
		GROUP BY SD.VRSTA_DOK,SD.BROJ_DOK,SD.GODINA,d.org_deo, d.broj_dok1, Z_TRO_TRO, d.datum_dok, d.user_id, d.datum_unosa, d.status
	) p
	,
	( select * from vezni_dok where vrsta_Dok = '3' and za_vrsta_dok = '2') vd

	WHERE p.Z_TRO != p.Z_TRO_TRO
	  and p.godina = vd.godina (+) and p.vrsta_dok = vd.vrsta_dok (+) and p.broj_dok = vd.broj_dok (+)
) p1
,
(select * from dokument where vrsta_Dok = '2') d1
where p1.NAR_BRD = d1.broj_dok (+) and p1.NAR_VRD = d1.vrsta_dok (+) and p1.NAR_GOD = d1.godina (+)
ORDER BY TO_NUMBER(p1.BROJ_DOK)
