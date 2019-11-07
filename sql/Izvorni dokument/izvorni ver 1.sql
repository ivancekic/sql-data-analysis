--select d.GODINA,d.VRSTA_DOK,d.NAZIV_VR,d.BROJ_DOK,d.TIP_DOK,d.DATUM_DOK,d.DATUM_UNOSA,d.USER_ID,d.PPARTNER,d.STATUS,d.BROJ_DOK1,d.DATUM_IZVORNOG_DOK
--     , d.ZA_BROJ_DOK,d.ZA_VRSTA_DOK,d.ZA_GODINA
--     , d1.datum_dok
--from
--(
	SELECT
  		   D.GODINA,D.VRSTA_DOK,vrd.naziv naziv_vr,D.BROJ_DOK,D.TIP_DOK,d.org_deo, D.DATUM_DOK,D.DATUM_UNOSA,D.USER_ID,D.PPARTNER,D.STATUS, D.BROJ_DOK1
  		 , D.DATUM_IZVORNOG_DOK
		 , vd.za_broj_dok, vd.za_vrsta_Dok, vd.za_godina, vd.datum_dok dat_izv_dok

	FROM
	 dokument  d, vrsta_dok vrd
	 ,(SELECT VD.BROJ_DOK, VD.VRSTA_DOK, VD.GODINA, vd.ZA_BROJ_DOK,vd.ZA_VRSTA_DOK,vd.ZA_GODINA, d1.datum_dok
	   FROM VEZNI_DOK vd, dokument d1
	   where za_vrsta_dok not in ('41','14','24','90','10','9','2')
         and vd.za_broj_dok = d1.broj_dok (+) and vd.za_godina = d1.godina (+) and vd.za_vrsta_dok = d1.vrsta_dok (+)
      ) VD
	WHERE
	vrd.vrsta=d.vrsta_Dok
--	and
--	(
--			D.VRSTA_DOK IN
--
--			(
--				SELECT VRSTA FROM VRSTA_DOK
--				WHERE
--				   INSTR(NAZIV,'POV')>0
--				OR INSTR(NAZIV,'STOR')>0
--	 		)
--	--or		D.VRSTA_DOK = '90'
--	)
	and d.vrsta_dok not in('64','62')
--	and d.vrsta_dok not in('30')
--	and d.vrsta_dok not in('12')
--	and d.vrsta_Dok IN ('1','26','45','46')
    and d.godina = 2012
AND d.DATUM_DOK > TO_DATE('19.01.2012','dd.mm.yyyy')
AND d.DATUM_UNOSA>TO_DATE('20.01.2012 14:30:00','dd.mm.yyyy hh24:mi:ss')
	and d.vrsta_Dok IN ('13')

	AND d.godina = vd.godina (+) and d.vrsta_dok = vd.vrsta_dok  (+) and d.broj_dok = vd.broj_dok (+)
--
--) d
--
--
ORDER BY d.DATUM_DOK, d.DATUM_UNOSA

