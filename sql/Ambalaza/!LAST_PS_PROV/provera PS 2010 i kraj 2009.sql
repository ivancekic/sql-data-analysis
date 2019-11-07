Select ORG_DEO,PPARTNER,NAZIV_PARTNER,PROIZVOD,PRO_NAZIV,KOLICINA,FAKTOR,K_ROBE,JEDMERE,UL_09,IZ_09,ST_09
From
(
select  d.org_deo
     , d.ppartner, pp.naziv  naziv_partner
     , sd.Proizvod
     , P.Naziv pro_naziv
	 , sd.kolicina,sd.faktor, sd.k_robe
     , p.Jed_Mere JedMere

	,(
		select sum(sd2.Kolicina * sd2.Faktor * Decode( sd2.K_Robe, 1, 1, 0 )) from dokument d2, stavka_dok sd2
		Where d2.org_deo in (select magacin from partner_magacin_flag)
		  and d2.godina = sd2.godina and d2.vrsta_dok = sd2.vrsta_dok and d2.broj_dok = sd2.broj_dok
		  and d2.datum_dok Between To_Date('01.01.2009','dd.mm.yyyy') and to_date('31.12.2009','dd.mm.yyyy')
		  -----------------------------
		  And sd2.K_Robe != 0     and d.org_deo   = d2.org_deo and sd.proizvod = sd2.PROIZVOD

	) Ul_09

	,(
		select Sum ( sd2.Kolicina * sd2.Faktor * Decode( sd2.K_Robe, -1, 1, 0 ) ) from dokument d2, stavka_dok sd2
		Where d2.org_deo in (select magacin from partner_magacin_flag)
		  and d2.godina = sd2.godina and d2.vrsta_dok = sd2.vrsta_dok and d2.broj_dok = sd2.broj_dok
		  and d2.datum_dok Between To_Date('01.01.2009','dd.mm.yyyy') and to_date('31.12.2009','dd.mm.yyyy')
		  -----------------------------
		  And sd2.K_Robe != 0     and d.org_deo   = d2.org_deo and sd.proizvod = sd2.PROIZVOD

	) Iz_09

	,(
		select Sum ( sd2.Kolicina * sd2.Faktor * sd2.K_Robe ) from dokument d2, stavka_dok sd2
		Where d2.org_deo in (select magacin from partner_magacin_flag)
		  and d2.godina = sd2.godina and d2.vrsta_dok = sd2.vrsta_dok and d2.broj_dok = sd2.broj_dok
		  and d2.datum_dok Between To_Date('01.01.2009','dd.mm.yyyy') and to_date('31.12.2009','dd.mm.yyyy')
		  -----------------------------
		  And sd2.K_Robe != 0     and d.org_deo = d2.org_deo and sd.proizvod = sd2.PROIZVOD

	) St_09


from dokument d, stavka_dok sd, PROIZVOD P, poslovni_partner pp

Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA
  and d.datum_dok = To_Date('01.01.2010','dd.mm.yyyy')
  and pp.sifra = d.ppartner
  and d.org_deo in (select magacin from partner_magacin_flag)
  -----------------------------
  And sd.K_Robe != 0

)
where st_09 is null
Order by to_number(org_Deo), to_number(Proizvod)

