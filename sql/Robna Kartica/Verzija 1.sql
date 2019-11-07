select
        VRSTA_DOK,TIP_DOK,BROJ_DOK,GODINA,DATUM_DOK,datum_unosa
      , KOLICINA,CENA1,NULAZIZLAZ,K_ROBE,NULAZ,NIZLAZ
      , NSTANJE,NDUG,NPOTR

,
lag(nStanje,1,0) Over ( PARTITION BY nStanje
                        ORDER by DATUM_DOK, datum_unosa) as nPretStanje

,
nstanje + lag(nStanje,1,0) Over ( PARTITION BY NSTANJE
                                  ORDER by DATUM_DOK, datum_unosa) as nStanje1

from
	(
	SELECT

	       VRSTA_dOK, TIP_DOK, BROJ_DOK, GODINA, DATUM_DOK,datum_unosa
	     , KOLICINA, CENA1
	     , nUlazIzlaz
	     , k_robe
	     , case when nUlazIzlaz = 1 Then
	                 nUlazIzlaz * K_Robe * Faktor * Kolicina
	            when nUlazIzlaz = -1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = 1 Then
	                 Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = -1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = 0 Then
	                 Faktor * Kolicina
	       End nUlaz

	     , case when nUlazIzlaz = 1 Then
	                 0
	            when nUlazIzlaz = -1 Then
	                 nUlazIzlaz * K_Robe * Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = 1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = -1 Then
	                 Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = 0 Then
	                 0
	       End nIzlaz

	     , case when nUlazIzlaz = 1 Then
	                 nUlazIzlaz * K_Robe * Faktor * Kolicina
	            when nUlazIzlaz = -1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = 1 Then
	                 Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = -1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = 0 Then
	                 Faktor * Kolicina
	       End
	       -
	       case when nUlazIzlaz = 1 Then
	                 0
	            when nUlazIzlaz = -1 Then
	                 nUlazIzlaz * K_Robe * Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = 1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = -1 Then
	                 Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = 0 Then
	                 0
	       End nStanje

	     , case when nUlazIzlaz = 1 Then
	                 nUlazIzlaz * K_Robe * Faktor * Kolicina
	            when nUlazIzlaz = -1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = 1 Then
	                 Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = -1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = 0 Then
	                 Faktor * Kolicina
	       End * cena1 nDug

	     , case when nUlazIzlaz = 1 Then
	                 0
	            when nUlazIzlaz = -1 Then
	                 nUlazIzlaz * K_Robe * Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = 1 Then
	                 0
	            when nUlazIzlaz = 2  And K_Robe = -1 Then
	                 Faktor * Kolicina
	            when nUlazIzlaz = 2  And K_Robe = 0 Then
	                 0
	       End * cena1 nPotr

	FROM
	(
					SELECT d1.VRSTA_DOK,d1.BROJ_DOK,d1.GODINA,d1.TIP_DOK,d1.DATUM_DOK,d1.DATUM_UNOSA,d1.USER_ID
					     , d1.PPARTNER
					     , d1.PP_ISPORUKE
					     , d1.ORG_DEO
					     , d1.REG_BROJ,d1.STATUS,d1.POSLOVNICA,d1.VAZI_DO,d1.VRSTA_IZJAVE,d1.D_RABAT,d1.SPEC_RABAT,d1.KASA
					     , d1.TIP_KASE,d1.ROK_KASE,d1.DPO,d1.VALUTA_PLACANJA,d1.NACIN_PLACANJA,d1.BROJ_DOK1
					     , d1.STAVKA,d1.PROIZVOD,d1.NAZIV_PRO,d1.LOT_SERIJA,d1.ROK,d1.KOLICINA,d1.JED_MERE,d1.CENA,d1.VALUTA,d1.LOKACIJA,d1.K_ROBE,d1.KONTROLA
					     , d1.FAKTOR,d1.REALIZOVANO
					     , d1.SD_RABAT,d1.POREZ,d1.KOLICINA_KONTROLNA,d1.AKCIZA,d1.TAKSA,d1.CENA1,d1.Z_TROSKOVI,d1.NETO_KG,d1.PROC_VLAGE,d1.PROC_NECISTOCE,d1.HTL
					     , d1.SD_NAPOMENA,d1.UNOS_USERNAME,d1.UNOS_DATUM

	                     , PDokument.UlazIzlaz( D1.Vrsta_Dok, D1.Tip_Dok, D1.K_Robe,D1.Datum_Dok ) nUlazIzlaz
					FROM
					(
						select d.VRSTA_DOK,d.BROJ_DOK,d.GODINA,d.TIP_DOK,d.DATUM_DOK,d.DATUM_UNOSA,d.USER_ID
						     , d.PPARTNER
						     , d.pp_isporuke
						     , d.org_deo
						     , d.REG_BROJ,d.STATUS
						     , D.POSLOVNICA,D.VAZI_DO,D.VRSTA_IZJAVE
						     , D.RABAT D_RABAT, D.SPEC_RABAT, D.KASA,D.TIP_KASE,D.ROK_KASE
						     , D.DPO,D.VALUTA_PLACANJA,D.NACIN_PLACANJA,D.BROJ_DOK1,D.SKLOP,D.JM_UG,D.IZNOS_UG,D.CENA_UG_JM
						     , D.DATUM_IZVORNOG_DOK
						     , sd.STAVKA,sd.PROIZVOD, p.naziv naziv_pro
						     , sd.LOT_SERIJA,sd.ROK,sd.KOLICINA,sd.JED_MERE,sd.CENA,sd.VALUTA,sd.LOKACIJA
						     , sd.K_ROBE,sd.KONTROLA,sd.FAKTOR,sd.REALIZOVANO
						     , sd.RABAT SD_RABAT, sd.POREZ,sd.KOLICINA_KONTROLNA
						     , sd.AKCIZA,sd.TAKSA,sd.CENA1,sd.Z_TROSKOVI,sd.NETO_KG,sd.PROC_VLAGE,sd.PROC_NECISTOCE,sd.HTL
						     , sd.NAPOMENA sd_napomena
						     , sd.UNOS_USERNAME,sd.UNOS_DATUM

						from vrsta_dok vrd, nacin_fakt nf, dokument d, stavka_dok sd, PROIZVOD P , GRUPA_PR  GPR

						Where
						      vrd.vrsta=d.vrsta_dok
						  and nf.tip=d.tip_dok
						  and d.status > 0
						  -- veza tabela
						  and
						      d.broj_dok = sd.broj_dok and d.vrsta_dok = sd.vrsta_dok and d.godina = sd.godina
						  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
						  -----------------------------
						  -- ostali uslovi
						  and (SD.k_robe <>0 or vrd.vrsta='80')


						  and org_deo= &c_org_sifra
						  and sd.proizvod= &c_pr_sifra
	--					  and d.godina = 2012
						  and d.datum_dok between &c_dat_od and &c_dat_do

					) D1
					order by datum_dok,datum_unosa
	)
)
order by
--to_number(vlasnik),
datum_dok,datum_unosa
