--Select distinct GODINA,ORG_DEO,VRSTA_DOK,BROJ_DOK1,BROJ_DOK,TIP_DOK,DATUM_DOK
--from
--
--(
select
sd.rowid,
--sd.rowid,
d.status,
d.godina, d.org_deo, d.vrsta_Dok, d.broj_dok1, d.broj_dok, d.tip_dok
, d.datum_dok, d.datum_izvornog_dok
, to_char(datum_dok,'dd.mm.yy') dat, to_char(d.datum_izvornog_dok,'dd.mm.yy')  dat_izv
--     , d.org_deo, d.broj_dok1
     , sd.proizvod, p.naziv, sd.jed_mere, sd.kolicina, sd.faktor, sd.cena, sd.rabat,sd.porez, sd.k_robe,
--       (Select Akciza.Iznos
--        From Proizvod, Akciza
--        Where Proizvod.Sifra = sd.proizvod And
--              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
--              Akciza.Datum = ( Select Max(T1.Datum)
--                                      From Akciza T1
--                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
--                                            And T1.Datum <= d.datum_dok )
--       ) akciza_jed,
         sd.akciza
--       , abs(nvl(SD.akciza, 0)) akc
--       ,
--       abs(
--       round(
--       (Select Akciza.Iznos
--        From Proizvod, Akciza
--        Where Proizvod.Sifra = sd.proizvod And
--              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
--              Akciza.Datum = ( Select Max(T1.Datum)
--                                      From Akciza T1
--                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
--                                            And T1.Datum <= nvl(d.datum_izvornog_dok, d.datum_dok) )
--       ) * sd.kolicina * sd.faktor * p.kolicina_za_taksu ,2)
--       )
--        akciza_ok
----       ,
----       sd.porez
----
----,  p.faktor_trebovne       , sd.faktor
----, round(sd.akciza / sd.kolicina * p.kolicina_za_taksu / p.faktor_trebovne,2) jed_akc_uneto
--
------------------------------------------------------------------------------------------------------
--
--, round(( sd.Kolicina * sd.Cena + sd.Akciza ) * (100 + sd.Porez) / (100 * sd.Kolicina),1) cena_11
----, round(( sd.Kolicina * sd.Cena + sd.Akciza ) * (100 + sd.Porez) / (100 * sd.Kolicina),0) cena_11
--
----, 100-100*(((100 * sd.Kolicina * sd.Cena - sd.Rabat * sd.Kolicina *
----               sd.Cena)/100)+ sd.Akciza)*((100+sd.Porez)/100)/(sd.Kolicina*sd.Cena1) 				RAB_BRUTO
--
----, 100 - (( sd.Kolicina * sd.Cena2 * ( 100 - sd.Bruto_rabat) /
----                            (100 + sd.Porez)) - sd.Akciza ) * 100 / ( sd.Kolicina * sd.Cena) rabat_ok
--
--, 100 - (( sd.Kolicina *
--          round(( sd.Kolicina * sd.Cena + sd.Akciza ) * (100 + sd.Porez) / (100 * sd.Kolicina),1)				-- cena_11
--
--                                    * ( 100 - 6) /
--                            (100 + sd.Porez)) - sd.Akciza ) * 100 / ( sd.Kolicina * sd.Cena) rabat_ok
--, PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) prod
--from dokument d, stavka_dok sd, proizvod p
from stavka_dok sd, dokument d, proizvod p

Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  and sd.proizvod = p.sifra
  and d.godina = 2015
  and d.vrsta_dok  = 10
--  and d.vrsta_dok  IN (11)
--  and d.status >= 1
--and org_Deo = 139
--  and d.datum_dok >= to_date('07.04.2009','dd.mm.yyyy')
--  and
--      abs(
--      round((Select Akciza.Iznos
--        From Proizvod, Akciza
--        Where Proizvod.Sifra = sd.proizvod And
--              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
--              Akciza.Datum = ( Select Max(T1.Datum)
--                                      From Akciza T1
--                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
--                                            And T1.Datum <=nvl(d.datum_izvornog_dok, d.datum_dok) )
--        ) * sd.kolicina * sd.faktor * p.kolicina_za_taksu,2)) <> abs(sd.akciza)


--  and
--      abs(abs(
--      round((Select Akciza.Iznos
--        From Proizvod, Akciza
--        Where Proizvod.Sifra = sd.proizvod And
--              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
--              Akciza.Datum = ( Select Max(T1.Datum)
--                                      From Akciza T1
--                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
--                                            And T1.Datum <=nvl(d.datum_izvornog_dok, d.datum_dok) )
--        ) * sd.kolicina * sd.faktor * p.kolicina_za_taksu,2)) - abs(sd.akciza)) >.01

--  and  abs(
--  (Select Akciza.Iznos
--        From Proizvod, Akciza
--        Where Proizvod.Sifra = sd.proizvod And
--              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
--              Akciza.Datum = ( Select Max(T1.Datum)
--                                      From Akciza T1
--                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
--                                            And T1.Datum <= nvl(d.datum_izvornog_dok, d.datum_dok) )
--        ) * sd.kolicina * sd.faktor * p.kolicina_za_taksu) <> abs(sd.akciza)

--  and sd.akciza <> 0
  and p.kolicina_za_taksu <> 0
--  and sd.proizvod in ('4502')

--  AND
--  (
--	  ( d.vrsta_Dok = '11' and D.BROJ_DOK in (13,20))
--or
--	  ( d.vrsta_Dok = '10' and D.BROJ_DOK='16')
--  )

--AND D.BROJ_DOK='13'
--) d
  AND D.DATUM_DOK >= TO_DATE('08.08.2015','DD.MM.YYYY')

ORDER BY datum_dok,
         TO_NUMBER(d.vrsta_dok),
         TO_NUMBER(d.BROJ_dok)

