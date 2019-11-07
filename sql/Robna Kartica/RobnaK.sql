--select * from
--(
Select --+ INDEX( STAVKA_DOK STAVKA_DOK_PROIZVOD ) INDEX( DOKUMENT DOKUMENT_PK )
       Proizvod, Datum_Dok, sd.Godina, sd.Broj_Dok,
       sd.Vrsta_Dok, K_Robe, Kolicina, Faktor,
       Kontrola, Realizovano, Kolicina_Kontrolna,sd.Cena1,
       D.Tip_Dok,sd.cena, D.Broj_Dok1
--     ,(
--		select cena
----		datum_dok, DATUM_UNOSA
----		     , d1.godina god, d1.vrsta_dok vrd, d1.broj_dok brd, org_deo mag, sd1.proizvod pro, sd1.cena, sd1.cena1, kolicina kol, realizovano rlz
----		     , sd1.valuta VAL, sd1.k_robe KR, sd1.faktor FK
--		from stavka_dok sd1 , dokument d1
--		Where sd1.godina = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
--		 -----------------------------
--		  -- ostali uslovi
--		  and d1.godina = 2009 and d1.vrsta_dok = 80 and d1.org_deo = 103 and d1.status > 0 and proizvod = sd.proizvod
--		  and d.datum_dok = d1.datum_dok and to_char(d.DATUM_UNOSA,'dd.mm.yyyy') = to_char(d1.datum_unosa,'dd.mm.yyyy')
--      ) niv
From Stavka_Dok sd, Dokument d
Where
--Proizvod = 6845 And
      D.Vrsta_Dok = sd.Vrsta_Dok And D.Broj_Dok = sd.Broj_Dok And D.Godina = sd.Godina
 And  d.godina = 2012 and (sd.K_Robe != 0 OR d.vrsta_dok = '80') And D.Org_Deo = 103 And D.Status > 0 and proizvod <> 399
 And  D.Datum_Dok Between (Select max(d.datum_dok) from dokument where vrsta_Dok = 21 and godina = 2012 and Org_Deo = 103)
                      And sysdate--to_date('30.11.2009','dd.mm.yyyy') And

--)
--where niv is not null
Order By To_Number( Proizvod ), Datum_Dok,Datum_Unosa;
