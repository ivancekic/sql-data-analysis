Select ORG_DEO,SIFRA partner,NAZIV_PARTNER,PROIZVOD,PRO_NAZIV,ULAZ,IZLAZ,STANJE,JEDMERE,PS_AMB_KOL from
(
select  d.org_deo
     , pp.sifra, pp.naziv  naziv_partner
     , sd.Proizvod
     , P.Naziv pro_naziv
     , ( Sum ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, 1, 1, 0 ) ) ) Ulaz
     , ( Sum ( sd.Kolicina * sd.Faktor * Decode( sd.K_Robe, -1, 1, 0 ) ) ) Izlaz
     , ( Sum ( sd.Kolicina * sd.Faktor * sd.K_Robe ) ) Stanje
     , p.Jed_Mere JedMere

    , (Select sd1.kolicina * sd1.k_robe
       From dokument d1 , stavka_dok sd1
       Where d1.godina = sd1.godina and d1.vrsta_dok = sd1.vrsta_dok and d1.broj_dok = sd1.broj_dok
         and d1.org_deo in (select magacin from partner_magacin_flag)
         and d1.vrsta_Dok = '21'
         and d1.godina = &nGod
         and d1.datum_dok = To_Date('01.01.'||to_char(&nGod),'dd.mm.yyyy')
         and d.org_deo   = D1.org_deo
         and sd.proizvod = SD1.proizvod
      ) ps_amb_kol


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
--,ps_amb.Pro, ps_amb.kol,ps_amb.d1_dat,ps_amb.d1_datu
)
where
stanje <> nvl(ps_amb_kol,-123456789)
--and sifra = 267
--sifra = 2527
Order by to_number(sifra), to_number(Proizvod)

