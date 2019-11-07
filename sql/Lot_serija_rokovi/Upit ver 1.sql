		select
sd.lot_Serija,

		       d.godina, d.vrsta_Dok, VRD.NAZIV VRSTA_NAZIV
		     , d.broj_dok, d.tip_dok, NF.NAZIV TIP_NAZIV

		     , SrediNazivDok(VRD.NAZIV,
		                     NF.NAZIV,
		                     4,
		                     10,
		                     3,
		                     9,
		                     '(',
		                     ')') NAZIV_DOK
		     , d.org_Deo MAG, OD.NAZIV MAG_NAZIV, d.broj_dok1
		     , upper(OD1.TIP) ORG_2_TIP
		     , D.POSLOVNICA ORG_2, OD1.NAZIV ORG_2_NAZ
		     , d.status, (SELECT DISTINCT NAZIV FROM STATUS WHERE TIP_STAT_SIFRA = 3 AND ID=D.STATUS) STATUS_NAZIV
		     , d.datum_dok, d.datum_unosa, d.user_id
		     , d.ppartner, PP.NAZIV PP_NAZIV
		     , d.pp_isporuke, PP1.NAZIV PP_ISP_NAZIV
		     , d.mesto_isporuke, MISP.NAZIV_KORISNIKA MISP_NAZIV, MISP.ADRESA MISP_ADRESA
		     , MISP.ADRESA1 MISP_ADRESA1, MISP.ADRESA2 MISP_ADRESA2, MISP.ADRESA3 MISP_ADRESA3
		     , sd.proizvod, p.naziv pro_naziv
		     , P.JED_MERE SKL_JM, sd.kolicina, SD.JED_MERE SD_JM, sd.faktor, sd.k_robe, sd.lot_Serija--, SD.ROK

		from VRSTA_DOK VRD, NACIN_FAKT NF, dokument d, stavka_dok sd, PROIZVOD P, ORGANIZACIONI_DEO OD, POSLOVNI_PARTNER PP, POSLOVNI_PARTNER PP1
		   , MESTO_ISPORUKE MISP, ORGANIZACIONI_DEO OD1
		Where
		  -- veza tabela
		      vrd.vrsta= nvl(&cVrd,vrd.vrsta)
		  And VRD.VRSTA=D.VRSTA_DOK
		  And NF.TIP=nvl(&nTipD,NF.TIP)
		  And NF.TIP=D.TIP_DOK
--		  And D.STATUS > 0
		  And D.STATUS = nvl(&nStat,d.status)
		  And D.ORG_DEO = nvl(&norgD,d.org_Deo)
		  And nvl(d.PPartner,'PRAZNO')=nvl(&cPrt,nvl(d.PPartner,'PRAZNO'))
		  And nvl(d.PP_isporuke,'PRAZNO')=nvl(&cPPIsp,nvl(d.PP_isporuke,'PRAZNO'))
		  And nvl(d.Mesto_isporuke,'PRAZNO')=nvl(&cMisp,nvl(d.Mesto_isporuke,'PRAZNO'))
          And d.datum_dok between &dDatOd And &dDatDo
		  And d.godina = sd.godina And d.vrsta_dok = sd.vrsta_dok And d.broj_dok = sd.broj_dok
          And P.SIFRA = nvl(&cPro,P.SIFRA)
		  And P.SIFRA = SD.PROIZVOD
--		  And sd.lot_Serija = nvl(&cLot,sd.lot_Serija)
--		  And sd.rok = nvl(dRok,sd.rok)
		--  And sd.lot_Serija = 'b.n.1561'
		  And SD.K_REZ=0
		  And SD.K_ROBE <>0
		  And SD.K_OCEK=0
		  And OD.ID= D.ORG_DEO
		  And OD1.ID= D.POSLOVNICA
		  And PP.SIFRA(+)=D.PPARTNER
		  And PP1.SIFRA(+)=D.PP_ISPORUKE

		  And MISP.PPARTNER(+)=D.PP_ISPORUKE
		  And MISP.SIFRA_MESTA(+)=D.MESTO_ISPORUKE
		order by  SD.PROIZVOD, nvl(sd.lot_serija,'ASDFJKL')
		        , d.datum_dok,d.datum_unosa;
