select ps.*
     , ' '  razmak
     , prgod.*
from
(
select  d.org_deo
     , pp.sifra, pp.naziv  naziv_partner
     , sd.Proizvod pro
     , P.Naziv pro_naziv
     , ( Sum ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, 1, 1, 0 ) ) ) Ulaz
     , ( Sum ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, -1, 1, 0 ) ) ) Izlaz
     , ( Sum ( sd.Kolicina * sd.Faktor * sd.K_Robe ) ) Stanje
     , p.Jed_Mere JM

from dokument d, stavka_dok sd, PROIZVOD P, GRUPA_PR  GPR, poslovni_partner pp
Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
         and d.vrsta_Dok = '21'
         and d.godina = &nGod
         and d.datum_dok = To_Date('01.01.'||to_char(&nGod),'dd.mm.yyyy')

  and pp.sifra = d.ppartner
  and d.org_deo in (select magacin from partner_magacin_flag)
  -----------------------------
  And sd.K_Robe != 0

Group by  d.org_deo, pp.sifra, pp.naziv, sd.Proizvod, P.Naziv,p.Jed_Mere
) ps
, (
		select  d.org_deo
		     , pp.sifra
		     , sd.Proizvod pro
		     , ( Sum ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, 1, 1, 0 ) ) ) Ulaz
		     , ( Sum ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, -1, 1, 0 ) ) ) Izlaz
		     , ( Sum ( sd.Kolicina * sd.Faktor * sd.K_Robe ) ) Stanje
		     , p.Jed_Mere JM

		from dokument d, stavka_dok sd, PROIZVOD P, GRUPA_PR  GPR, poslovni_partner pp
		Where
		  -- veza tabela
		      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
		  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
		  and d.datum_dok Between To_Date('01.01.'||to_char(&nGod-1),'dd.mm.yyyy') and to_date('31.12.'||to_char(&nGod-1),'dd.mm.yyyy')
		  and pp.sifra = d.ppartner
		  and d.org_deo in (select magacin from partner_magacin_flag)
		  -----------------------------
		  And sd.K_Robe != 0

		Group by  d.org_deo, pp.sifra, pp.naziv, sd.Proizvod, P.Naziv,p.Jed_Mere
) prgod
Where
      ps.org_deo = prgod.org_deo (+)
  and ps.sifra = prgod.sifra (+)
  and ps.pro = prgod.pro (+)
  and ps.JM = prgod.JM (+)
and nvl(ps.stanje,0) <> nvl(prgod.stanje,0)
Order by  to_number(ps.sifra), to_number(ps.pro)
