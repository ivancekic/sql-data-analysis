select D.ORG_DEO, sd.vrsta_Dok,sd.broj_dok, d.datum_dok, d1.broj_dok
     , sum(sd.kolicina) pri_amb
     , (Select ceil(sum(sd1.kolicina / amb.za_kolicinu))
        From stavka_dok sd1 , PROIZVOD P , pakovanje pak, ambalaza_za_stampu amb
        Where SD1.PROIZVOD  = P.SIFRA
          And pak.proizvod  = P.SIFRA
          And amb.proizvod  = P.SIFRA
          And sd1.vrsta_dok = 3
          And sd1.broj_dok  = d1.broj_dok
--        Group by sd1.broj_dok
       ) treba_amb

     , sum(sd.kolicina)  -
      (Select ceil(sum(sd1.kolicina / amb.za_kolicinu))
        From stavka_dok sd1 , PROIZVOD P , pakovanje pak, ambalaza_za_stampu amb
        Where SD1.PROIZVOD  = P.SIFRA
          And pak.proizvod  = P.SIFRA
          And amb.proizvod  = P.SIFRA
          And sd1.vrsta_dok = 3
          And sd1.broj_dok  = d1.broj_dok
--        Group by sd1.broj_dok
       ) RAZLIKA_amb


from stavka_dok sd , dokument d, vezni_dok vd , dokument d1--, stavka_dok sd1
Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  and vd.godina = d.godina and vd.vrsta_dok = d.vrsta_dok and vd.broj_dok = d.broj_dok
  and vd.za_godina = d1.godina and vd.za_vrsta_dok = d1.vrsta_dok and vd.za_broj_dok = d1.broj_dok
--  and sd1.godina = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
  -- prijemnice ambalaze
  and d.godina = 2008  and d.vrsta_dok in(3)  and d.tip_dok   = 10  and sd.proizvod in (399)
--  and d.datum_dok >= to_date('01.04.2008','dd.mm.yyyy')
--  and d.datum_dok <= to_date('07.04.2008','dd.mm.yyyy')

  and vd.za_vrsta_Dok = 3
  and D.ORG_DEO  = 107
  and d.broj_dok1 = -3
Group by D.ORG_DEO, sd.vrsta_Dok,sd.broj_dok, d.datum_dok, d1.broj_dok
order by d.datum_dok
