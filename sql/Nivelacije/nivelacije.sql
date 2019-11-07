--Select STATUS,BROJ_DOK1,BROJ_DOK,VRSTA_DOK,GODINA,DATUM_DOK,DATUM_UNOSA,ORG_DEO,USER_ID,vrd,brd,god,brd1,  UK_RAZL
--From
--(
	Select
--	 d.status, d.broj_dok1,d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo, d.user_id
--	     , vd.za_vrsta_dok vrd, vd.za_broj_dok brd, vd.za_godina god
d.rowid, d.*, vd.*
	From dokument d, vezni_dok vd
	where d.broj_dok != '0'
	  and d.vrsta_Dok = '90'
	  and d.godina = &nGod
	  AND D.ORG_DEO BETWEEN 103 AND 108
	  and d.godina = vd.godina and d.vrsta_dok = vd.vrsta_dok and d.broj_dok = vd.broj_dok

and (Select count(*)
	        From Stavka_Dok sd
	        Where sd.Godina    = vd.za_Godina
	          And sd.Vrsta_dok = vd.za_vrsta_dok
	          And sd.Broj_Dok  = vd.za_broj_dok
	          And sd.cena <> round(sd.cena1*sd.faktor,4)
	      ) = 0
Order by d.datum_dok, d.datum_unosa
--)
--where uk_razl=0
--Order by datum_dok, datum_unosa
