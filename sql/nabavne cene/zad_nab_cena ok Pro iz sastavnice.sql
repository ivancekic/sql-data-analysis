				Select
                       d.godina, d.vrsta_dok, d.broj_dok,d.org_deo,d.tip_dok,
				       SD.PROIZVOD, d.datum_dok,d.datum_unosa, P.NAZIV,
				       p.ZAD_NAB_CENA_DOK_VRED, p.ZAD_NAB_CENA_DOK_DAT,
				       SD.CENA, Z_TROSKOVI,
                       SD.RABAT, SD.POREZ,
				       sd.kolicina*sd.faktor*sd.k_robe kol_sklad,
				       sd.valuta val,
				       round(sd.cena * nvl(sd.rabat,0)/100,4) RabIznos,
				       round(sd.cena * (1 - nvl(sd.rabat,0)/100),4) CenaSaRab,
				       round(nvl(sd.Z_Troskovi,0) / sd.kolicina,4) ZTro,
				       round((sd.cena * (1 - nvl(sd.rabat,0)/100) +
				                                   (nvl(sd.Z_Troskovi,0) / sd.kolicina)),4) CenaZtro
				From dokument d
				   , stavka_dok sd
				   , PROIZVOD P
				Where d.broj_dok> 0
				  and d.vrsta_dok = '3'
				  and d.godina > 0
				  and d.tip_dok  in( 10,16)
				  and d.status   in (1,3)
				  and sd.valuta = 'YUD'
                  and ppartner is not null
				  and d.ppartner <> '0'
				  and org_deo != 2461
				  and org_deo not in (select magacin from partner_magacin_flag)
				  and d.broj_dok  = sd.broj_dok and d.vrsta_dok = sd.vrsta_dok and d.godina = sd.godina
				  and P.SIFRA=SD.PROIZVOD
				  and P.TIP_PROIZVODA !='1'
				  and P.TIP_PROIZVODA !='2'
				  and (sd.proizvod, d.datum_dok,d.datum_unosa) in
				      (
						Select SD.PROIZVOD,max(d.datum_dok), max(d.datum_unosa)
						From dokument d
						   , stavka_dok sd
						   , PROIZVOD P
						Where d.broj_dok> 0
						  and d.vrsta_dok = '3'
						  and d.godina > 0
						  and d.tip_dok  in( 10,16)
		                  and ppartner is not null
						  and d.status   in (1,3)
						  and d.ppartner != '0'
						  and d.broj_dok  = sd.broj_dok and d.vrsta_dok = sd.vrsta_dok and d.godina = sd.godina
						  AND P.SIFRA=SD.PROIZVOD
						  And P.TIP_PROIZVODA !='1'
						  And P.TIP_PROIZVODA !='2'
						  and sd.valuta = 'YUD'
						  and org_deo != 2461
						  and org_deo not in (select magacin from partner_magacin_flag)
						  and sd.proizvod in
						  (

							select distinct ss.proizvod
							from SASTAVNICA_ZAG sz, proizvod p
							   , SASTAVNICA_STAVKA ss, proizvod p1
							WHERE
							      upper(nvl(DEFAULT_PLAN,'N')) ='D'
							  and p.sifra = sz.proizvod
							  and sz.broj_dok = ss.broj_dok
							--and sz.jed_mere <> p.jed_mere
							  and p1.sifra = ss.proizvod
						  )
						Group by SD.PROIZVOD
				      )
				  and sd.proizvod in
				  (

					select distinct ss.proizvod
					from SASTAVNICA_ZAG sz, proizvod p
					   , SASTAVNICA_STAVKA ss, proizvod p1
					WHERE
					      upper(nvl(DEFAULT_PLAN,'N')) ='D'
					  and p.sifra = sz.proizvod
					  and sz.broj_dok = ss.broj_dok
					--and sz.jed_mere <> p.jed_mere
					  and p1.sifra = ss.proizvod
				  )
				Order by SD.PROIZVOD, d.datum_dok, d.datum_unosa desc
