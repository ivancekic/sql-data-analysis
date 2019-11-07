select d.godina , d.vrsta_dok , D.TIP_DOK,d.broj_dok ,D.STATUS ,D.DATUM_DOK,D.ORG_DEO,
       sd.proizvod , sd.cena , sd.valuta, sd.faktor, sd.cena1
, OdgovarajucaCena(D.Org_deo , Sd.proizvod , d.datum_dok, sd.faktor, sd.valuta,0) odgov
, ROUND(CENA1 * FAKTOR,4) PROVERA_C


from   stavka_dok sd , dokument d , PROIZVOD P , GRUPA_PR  GPR
Where
  -- veza tabela
      sd.godina    (+)= d.godina
  and sd.vrsta_dok (+)= d.vrsta_dok
  and sd.broj_dok  (+)= d.broj_dok

  AND SD.PROIZVOD = P.SIFRA
  AND P.GRUPA_PROIZVODA=  GPR.ID

 -----------------------------
  -- ostali uslovi
  and d.godina = 2007
--  and d.vrsta_dok  IN ( 10 )
--  and d.status != 0
  AND D.TIP_DOK IN (23,12)
  and sd.faktor != 1
  AND CENA != ROUND(CENA1 * FAKTOR,4)
