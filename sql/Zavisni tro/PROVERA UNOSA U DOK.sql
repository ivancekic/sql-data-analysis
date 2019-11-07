SELECT BROJ_DOK,VRSTA_DOK,GODINA,STATUS,DATUM_DOK,DATUM_UNOSA,USER_ID
FROM
(
	Select BROJ_DOK,VRSTA_DOK,GODINA,STATUS,DATUM_DOK,DATUM_UNOSA,USER_ID
	from dokument
	where
	      (
	          (broj_dok='5256'  and vrsta_dok='2')
	       or
	          (broj_dok='11927'  and vrsta_dok='3')
	      )

	  and godina =2012

	UNION

	Select BROJ_DOK,VRSTA_DOK||'_Z',GODINA,STATUS,DATUM_UNOSA DATUM_DOK,DATUM_UNOSA,USER_ID
	from zavisni_troskovi
	where
	      (broj_dok='11927'  and vrsta_dok='3')
	  and godina =2012
)
ORDER BY DATUM_DOK, DATUM_UNOSA
