SELECT DAT_MIN,DAT_MAX,PRT,PRO,ULAZ,IZLAZ,STANJE,MAG
     , (Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = MAG) MAX_DAT_PS
     , (Select Min(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = MAG) MIN_DAT_PS
FROM
(
     Select
            nvl((Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = d.org_deo),
                (Select Min(Datum_dok) from dokument where vrsta_dok != 21 and org_Deo = d.org_deo)
               ) DAT_MIN
          , TO_DATE('31.12.'||
               TO_CHAR(TO_NUMBER(
               TO_CHAR(
                          nvl((Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = d.org_deo),
                              (Select Min(Datum_dok) from dokument where vrsta_dok != 21 and org_Deo = d.org_deo)
                             )
                      ,'YYYY'
                      ) )) ----- - 1 ))

                    ,'DD.MM.YYYY'
                   ) DAT_MAX
          , PPartner PRT, sd.Proizvod PRO
          , ( Sum ( Kolicina * Faktor * Decode( K_Robe, 1, 1, 0 ) ) ) Ulaz
          , ( Sum ( Kolicina * Faktor * Decode( K_Robe, -1, 1, 0 ) ) ) Izlaz
          , ( Sum ( Kolicina * Faktor * K_Robe ) ) Stanje
          , D.ORG_DEO MAG
     From Dokument d, Stavka_Dok sd
     Where d.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 )
       And d.Status > 0
       And d.Org_Deo In (Select Magacin From Partner_magacin_Flag)
       And d.Datum_Dok
       Between
                     nvl((Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = d.org_deo),
                         (Select Min(Datum_dok) from dokument where vrsta_dok != 21 and org_Deo = d.org_deo)
                        )
                AND

--                     nvl((Select Max(Datum_dok) from dokument where vrsta_dok != 21 and org_Deo = d.org_deo),
--                         (Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = d.org_deo)
--                        )
                     TO_DATE('31.12.'||
                         TO_CHAR(TO_NUMBER(
                         TO_CHAR(
                                    nvl((Select Max(Datum_dok) from dokument where vrsta_dok = 21 and org_Deo = d.org_deo),
                                        (Select MIN(Datum_dok) from dokument where vrsta_dok != 21 and org_Deo = d.org_deo)
                                       )
                                ,'YYYY'
                                ) )) ----- - 1 ))
                              ,'DD.MM.YYYY'
                             )
--

       And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
       And sd.K_Robe != 0
       And d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
--       AND D.GODINA = 2006
       AND D.PPARTNER = 7767
     Group By d.Ppartner, sd.Proizvod, d.Org_Deo
)
ORDER BY DAT_MIN, PRT, PRO, MAG
