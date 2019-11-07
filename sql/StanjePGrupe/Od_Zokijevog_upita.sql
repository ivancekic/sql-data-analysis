SELECT /*+ RULE */ MAG_PR_DatPS.org_deo,
       MAG_PR_DatPS.datum_ps dat_ps,
       MAG_PR_DatPS.proizvod,
--       SrediNazivDok(od.naziv, NULL, 3, 20, null, null, null, null) ORG_NAZIV,
       pg.grupa pos_gr ,pg.naziv pg_naziv, p.sifra , gr_pr.ID grupa , gr_pr.naziv gr_naziv ,
       p.sifra , p.naziv p_naziv,
       p.jed_mere,
       (Select Sum(Round(NVL(Kolicina * Faktor * K_Robe, 0), 4))
          From Dokument,
               Stavka_Dok
         Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And Dokument.Broj_Dok = Stavka_Dok.Broj_Dok And Dokument.Godina = Stavka_Dok.Godina
           And Dokument.Status > 0 And Stavka_Dok.K_Robe != 0 And Dokument.Datum_Dok Between MAG_PR_DatPS.datum_ps and sysdate
           And Dokument.Org_Deo = MAG_PR_DatPS.ORG_DEO and stavka_dok.proizvod = MAG_PR_DatPS.Proizvod
         Group By dokument.org_deo, stavka_dok.proizvod
       ) AS kolicina,
       rezer_proizvod_datum (MAG_PR_DatPS.org_deo, MAG_PR_DatPS.proizvod,
                                                   (Select nvl(Max(Datum_Dok),to_date( '01.01.'||To_Char(sysdate, 'yyyy') ,'dd.mm.yyyy'))
                                                   From Dokument
                                                   Where Vrsta_Dok = '21' And Org_Deo =  MAG_PR_DatPS.org_deo  And Status > 0 And
                                                         Datum_Dok = ( Select Max(D1.Datum_Dok)
                                                                       From Dokument D1
                                                                       Where D1.Vrsta_Dok = '21' And
                                                                             D1.Org_Deo = MAG_PR_DatPS.org_deo And
                                                                             D1.Status > 0 And
                                                                             D1.Datum_Dok <= sysdate
                                                                     )
                                                   )
        , sysdate )  AS rezervisana ,
        ocek_proizvod_datum (MAG_PR_DatPS.org_deo, MAG_PR_DatPS.proizvod,
                                                   (Select nvl(Max(Datum_Dok),to_date( '01.01.'||To_Char(sysdate, 'yyyy') ,'dd.mm.yyyy'))
                                                   From Dokument
                                                   Where Vrsta_Dok = '21' And Org_Deo =  MAG_PR_DatPS.org_deo  And Status > 0 And
                                                         Datum_Dok = ( Select Max(D1.Datum_Dok)
                                                                       From Dokument D1
                                                                       Where D1.Vrsta_Dok = '21' And
                                                                             D1.Org_Deo = MAG_PR_DatPS.org_deo And
                                                                             D1.Status > 0 And
                                                                             D1.Datum_Dok <= sysdate
                                                                     )
                                                   )
        , sysdate )  AS ocekivana
  FROM (SELECT distinct D1.ORG_DEO, SD1.PROIZVOD,
               (SELECT nvl(MAX(DATUM_DOK), to_date('01.01.' || to_char(sysdate , 'yyyy'), 'dd.mm.yyyy'))
                  FROM DOKUMENT D2
                 WHERE 0 < D2.status AND 21 = D2.VRSTA_DOK AND D2.DATUM_DOK <= sysdate
                   and nvl(instr(',48,91,', ',' || d2.org_deo || ','), 1) <> 0) DATUM_PS
          FROM DOKUMENT D1, STAVKA_DOK SD1
         WHERE SD1.VRSTA_DOK = D1.VRSTA_DOK AND SD1.BROJ_DOK = D1.BROJ_DOK AND SD1.GODINA = D1.GODINA
           AND 0 < D1.status AND D1.DATUM_DOK <= sysdate and nvl(instr(',48,91,', ',' || d1.org_deo || ','), 1) <> 0 AND K_ROBE <> 0) MAG_PR_DatPS,
       proizvod p,posebna_grupa pg,ORGANIZACIONI_DEO OD , grupa_pr gr_pr
 WHERE p.sifra = MAG_PR_DatPS.PROIZVOD AND OD.ID = MAG_PR_DatPS.ORG_DEO and PG.grupa = p.posebna_grupa
   and gr_pr.ID = p.GRUPA_PROIZVODA
 ORDER BY MAG_PR_DatPS.ORG_DEO,
          pg.naziv,
          p_naziv;
