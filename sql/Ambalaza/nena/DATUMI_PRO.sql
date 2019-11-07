Select DAT_MIN,DAT_MAX,PRT,PRO,ULAZ,IZLAZ,STANJE,MAG,MAX_DAT_PS,MIN_DAT_PS
     , (Select count(*) from Dokument d7, Stavka_Dok sd7
        Where d7.Datum_dok > MAX_DAT_PS
          And d7.org_Deo = MAG and d7.vrsta_dok != 21
          And d7.Tip_Dok In ( 15, 203, 204, 99, 301, 402, 61, 60 )
          And d7.Status > 0
          And d7.Vrsta_Dok = sd7.Vrsta_Dok And d7.Broj_Dok = sd7.Broj_Dok And d7.Godina = sd7.Godina
          And sd7.Proizvod = PRO
       ) UK_DOK_POSLE_PS 
From
(
SELECT DAT_MIN,DAT_MAX,PRT,PRO,ULAZ,IZLAZ,STANJE,MAG
     , (Select Max(d3.Datum_dok) from dokument d3, Stavka_Dok sd3 where d3.vrsta_dok = 21 and d3.org_Deo = MAG and sd3.proizvod = PRO
               And d3.Vrsta_Dok = sd3.Vrsta_Dok And d3.Broj_Dok = sd3.Broj_Dok And d3.Godina = sd3.Godina
        Group by Datum_dok
       ) MAX_DAT_PS

     , (Select Min(d4.Datum_dok) from dokument d4, Stavka_Dok sd4 where d4.vrsta_dok = 21 and d4.org_Deo = MAG and sd4.proizvod = PRO
               And d4.Vrsta_Dok = sd4.Vrsta_Dok And d4.Broj_Dok = sd4.Broj_Dok And d4.Godina = sd4.Godina
       ) MIN_DAT_PS
FROM
(
     Select
            nvl((Select Max(d1.Datum_dok) from dokument d1, Stavka_Dok sd1 where d1.vrsta_dok = 21 and d1.org_Deo = d.org_deo
                        And sd1.proizvod = sd.proizvod
                        And d1.Vrsta_Dok = sd1.Vrsta_Dok And d1.Broj_Dok = sd1.Broj_Dok And d1.Godina = sd1.Godina
                 ),
                (Select Min(d11.Datum_dok) from dokument d11, Stavka_Dok sd11 where d11.vrsta_dok != 21
                        And d11.org_Deo = d.org_deo And sd11.proizvod = sd.proizvod
                        And d11.Vrsta_Dok = sd11.Vrsta_Dok And d11.Broj_Dok = sd11.Broj_Dok And d11.Godina = sd11.Godina
                )
               ) DAT_MIN
          , TO_DATE('31.12.'||
               TO_CHAR(TO_NUMBER(
               TO_CHAR(
                          nvl((Select Max(d2.Datum_dok) from dokument d2, Stavka_Dok sd2 where d2.vrsta_dok = 21 and org_Deo = d.org_deo
                                      And sd2.proizvod = sd.proizvod
                                      And d2.Vrsta_Dok = sd2.Vrsta_Dok And d2.Broj_Dok = sd2.Broj_Dok And d2.Godina = sd2.Godina
                                      ),
                              (Select Min(d22.Datum_dok) from dokument d22, Stavka_Dok sd22 where d22.vrsta_dok != 21 and d22.org_Deo = d.org_deo
                                      And sd22.proizvod = sd.proizvod
                                      And d22.Vrsta_Dok = sd22.Vrsta_Dok And d22.Broj_Dok = sd22.Broj_Dok And d22.Godina = sd22.Godina
                              )
                             )
                      ,'YYYY'
                      ) ))
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
                     nvl((Select Max(d5.Datum_dok) from dokument d5, Stavka_Dok sd5 where d5.vrsta_dok = 21 and d5.org_Deo = d.org_deo
                                 And d5.org_Deo = d.org_deo And sd5.proizvod = sd.proizvod
                                 And d5.Vrsta_Dok = sd5.Vrsta_Dok And d5.Broj_Dok = sd5.Broj_Dok And d5.Godina = sd5.Godina
                         ),
                         (Select Min(d55.Datum_dok) from dokument d55, Stavka_Dok sd55 where d55.vrsta_dok != 21 and d55.org_Deo = d.org_deo
                                 And d55.org_Deo = d.org_deo And sd55.proizvod = sd.proizvod
                                 And d55.Vrsta_Dok = sd55.Vrsta_Dok And d55.Broj_Dok = sd55.Broj_Dok And d55.Godina = sd55.Godina
                         )
                        )
                AND
                     TO_DATE('31.12.'||
                         TO_CHAR(TO_NUMBER(
                         TO_CHAR(
                                    nvl((Select Max(d6.Datum_dok) from dokument d6, Stavka_Dok sd6 where d6.vrsta_dok = 21 and d6.org_Deo = d.org_deo
                                                And d6.org_Deo = d.org_deo And sd6.proizvod = sd.proizvod
                                                And d6.Vrsta_Dok = sd6.Vrsta_Dok And d6.Broj_Dok = sd6.Broj_Dok And d6.Godina = sd6.Godina
                                        ),
                                        (Select MIN(d66.Datum_dok) from dokument d66, Stavka_Dok sd66 where d66.vrsta_dok != 21 and d66.org_Deo = d.org_deo
                                                And d66.org_Deo = d.org_deo And sd66.proizvod = sd.proizvod
                                                And d66.Vrsta_Dok = sd66.Vrsta_Dok And d66.Broj_Dok = sd66.Broj_Dok And d66.Godina = sd66.Godina
                                        )
                                       )
                                ,'YYYY'
                                ) ))
                              ,'DD.MM.YYYY'
                             )

       And sd.Proizvod In ( Select Sifra From Proizvod Where Tip_Proizvoda = '8' )
       And sd.K_Robe != 0
       And d.Vrsta_Dok = sd.Vrsta_Dok And d.Broj_Dok = sd.Broj_Dok And d.Godina = sd.Godina
       AND D.PPARTNER = 7767
     Group By d.Ppartner, sd.Proizvod, d.Org_Deo
)
)
ORDER BY DAT_MIN, PRT, PRO, MAG
