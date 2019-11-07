select  d.org_deo
, d.vrsta_Dok,d.broj_dok
, d.datum_dok

     , pp.sifra, pp.naziv  naziv_partner
     , sd.Proizvod
     , P.Naziv pro_naziv
     , ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, 1, 1, 0 ) ) Ulaz
     , ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, -1, 1, 0 ) ) Izlaz
     , ( sd.Kolicina * sd.Faktor * sd.K_Robe ) Stanje
     , p.Jed_Mere JedMere
from dokument d, stavka_dok sd, PROIZVOD P, GRUPA_PR  GPR, poslovni_partner pp
Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  and pp.sifra = d.ppartner
  and d.org_deo in (select magacin from partner_magacin_flag)
  -----------------------------
  And sd.K_Robe != 0

  and pp.sifra = 267
  and sd.proizvod = 259
Order by datum_dok --to_number(sifra), to_number(Proizvod)

