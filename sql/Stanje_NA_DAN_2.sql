Select sd.Proizvod, p.posebna_grupa,
       Sum(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor*K_ROBE,0)) STANJE,
       Sum(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor*
          (CASE WHEN D.VRSTA_DOK = '80' THEN
                (sd.CENA1-sd.CENA)
           ELSE K_ROBE*(sd.CENA1)
       END),0)) VREDNOST,
round(
       Sum(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor*
          (CASE WHEN D.VRSTA_DOK = '80' THEN
                (sd.CENA1-sd.CENA)
           ELSE K_ROBE*(sd.CENA1)
       END),0)) / Sum(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor*K_ROBE,0)),2) cena
From Dokument d, Stavka_Dok sd,Proizvod p
Where Proizvod Like '260027'
  And D.Vrsta_Dok = sd.Vrsta_Dok And D.Broj_Dok = sd.Broj_Dok And D.Godina = sd.Godina
  And D.Status > 0
  And D.Datum_Dok Between (Select max(d.datum_dok) from dokument where vrsta_Dok = 21 and godina = 2009 and Org_Deo = 21)
                      And to_date('28.02.2009','dd.mm.yyyy')
  And (sd.K_Robe != 0 OR D.VRSTA_DOK = '80') And D.Org_Deo = 21 And p.sifra=sd.proizvod
Group By sd.Proizvod,p.tip_proizvoda,p.posebna_grupa,p.grupa_proizvoda,p.naziv
Order By p.posebna_grupa,sd.proizvod;
--         Order By  D.Datum_Dok,p.posebna_grupa, sd.Proizvod, TO_NUMBER(D.Vrsta_Dok), D.Datum_Unosa;
