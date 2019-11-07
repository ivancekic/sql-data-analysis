select PROIZVOD,POSEBNA_GRUPA,STANJE,VREDNOST,PO_KNJIGAMA,PO_POPISU,TP_CENA,PRAVAPROSVRED
,VREDNOST-PRAVAPROSVRED razlika
from
(
select PROIZVOD,POSEBNA_GRUPA,STANJE,VREDNOST,PO_KNJIGAMA,PO_POPISU, tp_cena
, round(PravaProsCena(&nOrgDeo,Proizvod, to_date('01.01.'||TO_CHAR(&dDatum,'yyyy'),'dd.mm.yyyy'),&dDatum ) * STANJE,2)PravaProsVred
from
(
         Select Stavka_dok.Proizvod, Proizvod.posebna_grupa,
                round(Sum(NVL(decode(d.tip_dok,14,Kolicina,realizovano)*Faktor* case when d.vrsta_dok = '90' then 0 else K_ROBE end,0)),5) STANJE,
                round(Sum(NVL(decode(d.tip_dok,14,Kolicina,realizovano)*Faktor*
                                    (CASE WHEN d.VRSTA_DOK = '80' THEN
                                               (STAVKA_DOK.CENA1-STAVKA_DOK.CENA)
                                          WHEN d.vrsta_dok  ='90' then
                                               ROUND((NVL(stavka_dok.cena,0)-NVL(stavka_dok.cena1,0)),2)
                                     ELSE K_ROBE*(
                                                    CASE WHEN d.VRSTA_DOK = 11 AND UPPER(ORGD.DODATNI_TIP) = 'VP2' THEN
                                                              STAVKA_DOK.CENA1
                                                    ELSE
                                                              STAVKA_DOK.CENA1
                                                    END
                                                 )
                                    END)
                             ,0)),2) VREDNOST
,PO_KNJIGAMA,PO_POPISU
, tp.cena tp_cena

         From Dokument d,
                    (SELECT  BROJ_DOK,
                             VRSTA_DOK,
                             GODINA,
                             STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI

                       FROM STAVKA_DOK

                    ) Stavka_Dok,
                    Proizvod,
                    ORG_DEO_OSN_PODACI ORGD
               ,(Select proizvod,PO_KNJIGAMA,PO_POPISU  from popis p, stavka_popisa sp
					where p.org_deo= &nOrgDeo
					  and p.godina=2011
					  and p.POPISNA_LISTA=sp.POPISNA_LISTA
					  and p.godina=sp.godina
					  and p.datum=&dDatum
                ) sp
               , tip_proizvoda tp
         Where d.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And
               d.Broj_Dok = Stavka_Dok.Broj_Dok And
               d.Godina = Stavka_Dok.Godina And
               d.ORG_DEO = ORGD.ORG_DEO (+) AND
               d.Status > 0 And
               d.Datum_Dok Between &dDatumPS And &dDatum And
               (Stavka_Dok.K_Robe != 0 OR d.VRSTA_DOK = '80') And
               d.Org_Deo = &nOrgDeo And Proizvod.sifra=Stavka_dok.proizvod
               and Stavka_Dok.proizvod =sp.proizvod  (+)
               and proizvod.tip_proizvoda=tp.sifra
         Group By Stavka_dok.Proizvod, Proizvod.posebna_grupa
         ,PO_KNJIGAMA,PO_POPISU, tp.cena
)

--where PO_KNJIGAMA<>STANJE
--   or PO_KNJIGAMA<>PO_POPISU
)
--where
----VREDNOST<>PRAVAPROSVRED
--abs(VREDNOST)-abs(PRAVAPROSVRED) > 2
         Order By posebna_grupa,proizvod
