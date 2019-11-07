--15428 dokumenata
select distinct vrsta_dok,naziv_vr
from
(
	SELECT
		D.GODINA,D.VRSTA_DOK,vrd.naziv naziv_vr,D.BROJ_DOK,D.TIP_DOK,D.DATUM_DOK,D.DATUM_UNOSA,D.USER_ID,D.PPARTNER,D.STATUS, D.BROJ_DOK1
		, D.DATUM_IZVORNOG_DOK
		, vd.za_broj_dok, vd.za_vrsta_Dok, vd.za_godina
	FROM
	 dokument  d, vrsta_dok vrd
	 ,(SELECT * FROM VEZNI_DOK where za_vrsta_dok not in ('41','14','24','90','10','9','2') ) VD
	WHERE
	vrd.vrsta=d.vrsta_Dok
	and
	(
			D.VRSTA_DOK IN

			(
				SELECT VRSTA FROM VRSTA_DOK
				WHERE
				   INSTR(NAZIV,'POV')>0
				OR INSTR(NAZIV,'STOR')>0
	 		)
	--or		D.VRSTA_DOK = '90'
	)
	and d.vrsta_dok not in('64','62')
	and d.vrsta_dok not in('12','4')
	AND d.godina = vd.godina (+) and d.vrsta_dok = vd.vrsta_dok  (+) and d.broj_dok = vd.broj_dok (+)

	ORDER BY D.DATUM_DOK, D.DATUM_UNOSA
)
