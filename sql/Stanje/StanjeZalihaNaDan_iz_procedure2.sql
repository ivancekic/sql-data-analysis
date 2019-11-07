select sum(vrednost) VRED
from
(
select s.*
--, vrednost/stanje
from
(
         Select Stavka_dok.Proizvod, Proizvod.posebna_grupa,
                round(Sum(NVL(decode(dokument.tip_dok,14,Kolicina,realizovano)*Faktor
                                * case when dokument.vrsta_dok = '90' then
                                         0
                                         --k_robe
                                       else
                                         K_ROBE
                                  end

                                ,0)),5) STANJE,

                round(Sum(NVL(decode(dokument.tip_dok,14,Kolicina,realizovano)*Faktor*
                                    (CASE WHEN DOKUMENT.VRSTA_DOK = '80' THEN
                                               (STAVKA_DOK.CENA1-STAVKA_DOK.CENA)
                                          WHEN dokument.vrsta_dok  ='90' then
                                               ROUND((NVL(stavka_dok.cena,0)-NVL(stavka_dok.cena1,0)),2)
                                     ELSE K_ROBE*(
                                                    CASE WHEN DOKUMENT.VRSTA_DOK = 11 AND UPPER(ORGD.DODATNI_TIP) = 'VP2' THEN
                                                              STAVKA_DOK.CENA1
                                                    ELSE
                                                              STAVKA_DOK.CENA1
                                                    END
                                                 )
                                    END)
                             ,0)),2) VREDNOST

               , (select sum(kolicina*faktor)
                   from dokument dx, stavka_dok stx
                  where dx.vrsta_dok = stx.vrsta_dok and dx.broj_dok = stx.broj_dok and dx.godina = stx.godina
                    and dx.vrsta_dok = 3
                    and dx.tip_dok   = 10
                    and dx.status in ('-8','-9') and dx.godina > 2008
                    --and dx.org_deo = dokument.org_deo
                    and stx.proizvod = stavka_dok.proizvod)
                  u_kontroli

               From Dokument,
                    (SELECT  BROJ_DOK,
                             VRSTA_DOK,
                             GODINA,
                             STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI

                       FROM STAVKA_DOK

                    ) Stavka_Dok,
                    Proizvod,
                    ORG_DEO_OSN_PODACI ORGD

         Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And
               Dokument.Broj_Dok = Stavka_Dok.Broj_Dok And
               Dokument.Godina = Stavka_Dok.Godina And
               DOKUMENT.ORG_DEO = ORGD.ORG_DEO (+) AND
               Dokument.Status > 0 And
               Dokument.Datum_Dok Between &dDatumPS And &dDatum And
               (Stavka_Dok.K_Robe != 0 OR DOKUMENT.VRSTA_DOK = '80') And
               Dokument.Org_Deo = &nOrgDeo And Proizvod.sifra=Stavka_dok.proizvod
         Group By Stavka_dok.Proizvod,Proizvod.tip_proizvoda,Proizvod.posebna_grupa,Proizvod.grupa_proizvoda,Proizvod.naziv
         Order By Proizvod.posebna_grupa,Stavka_dok.proizvod
) s
where stanje > 0
and proizvod !=399
)
