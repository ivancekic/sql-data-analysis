select
sd.rowid, d.BROJ_DOK,d.VRSTA_DOK,d.GODINA,d.STATUS,DATUM_DOK,tip_Dok, ORG_DEO,BROJ_DOK1
,PROIZVOD, KOLICINA,sd.JED_MERE,CENA,VALUTA
,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,sd.RABAT,POREZ,AKCIZA,TAKSA

--,Obracunaj_JUS(sd.proizvod, sd.neto_kg, sd.proc_vlage, sd.proc_necistoce,nvl(sd.htl,0))
--, (sd.kolicina * 2) z_t_osn, round((sd.kolicina * 2 * 1.18),2) z_t_uk
--, OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum, sd.faktor, sd.valuta,0) odgov
--, PProdajniCenovnikGrKup.Cena ('GKNEU', sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) neu
--, Pporez.ProcenatPoreza(d.Poslovnica,sd.Proizvod,d.Datum_dok,d.Vrsta_izjave) treba_por
, p.KOLICINA_ZA_TAKSU
--,
--(
--       Select Akciza.Stopa
--        From Proizvod, Akciza
--        Where Proizvod.Sifra = sd.proizvod And
--              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
--              Akciza.Datum = ( Select Max(T1.Datum)
--                                      From Akciza T1
--                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
--                                            And T1.Datum <= d.datum_dok )
--)akc_st
--,
--(
--       Select Akciza.Iznos
--        From Proizvod, Akciza
--        Where Proizvod.Sifra = sd.proizvod And
--              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
--              Akciza.Datum = ( Select Max(T1.Datum)
--                                      From Akciza T1
--                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
--                                            And T1.Datum <= d.datum_dok )
--)*p.KOLICINA_ZA_TAKSU * (sd.kolicina*sd.faktor) akc_izn
--,
--(
--       Select Akciza.Iznos
--        From Proizvod, Akciza
--        Where Proizvod.Sifra = sd.proizvod And
--              Proizvod.Grupa_Poreza = Akciza.Grupa_Poreza And
--              Akciza.Datum = ( Select Max(T1.Datum)
--                                      From Akciza T1
--                                      Where T1.Grupa_Poreza = Proizvod.Grupa_Poreza
--                                            And T1.Datum <= d.datum_dok )
--) jedinicna_akc_izn


from   stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      d.godina = sd.godina (+) and d.vrsta_dok = sd.vrsta_dok (+) and d.broj_dok = sd.broj_dok  (+)
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  -----------------------------
  -- ostali uslovi
  and '2010' = d.godina
--  AND TIP_DOK = 11
--AND D.ORG_DEO = 680
--and sd.faktor <> 1
--  and (
--         ('3' = d.vrsta_dok  and '21028' = d.broj_dok  )
------or         (d.vrsta_dok  = 10 and d.broj_dok = 3897 )
----
--      )

--and d.vrsta_dok = 11
and tip_dok like '2%' and tip_dok <> 23
-- PProdajniCenovnik.Cena( SD.Proizvod,D.Datum_Dok,SD.Valuta,SD.Faktor)
--  and d.datum_dok >= to_date('29.09.2009','dd.mm.yyyy')
and sd.proizvod = 21686
--and k_robe <> 0
and d.vrsta_Dok in(9,10)
and d.status = 1
order by d.datum_dok,d.datum_unosa;
