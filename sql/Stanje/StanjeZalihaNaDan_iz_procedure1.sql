         Select Stavka_dok.Proizvod, Proizvod.posebna_grupa,
                round(Sum(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor                               
                                * case when D.vrsta_dok = '90' then 
                                         0
                                       else
                                         K_ROBE
                                  end                               
                                ,0)),5) STANJE,                               
                round(Sum(NVL(decode(D.tip_dok,14,Kolicina,realizovano)*Faktor*
                   (CASE WHEN D.VRSTA_DOK = '80' THEN 
                         (STAVKA_DOK.CENA1-STAVKA_DOK.CENA) 
                        WHEN D.vrsta_dok  ='90' then
                             ROUND((NVL(stavka_dok.cena,0)-NVL(stavka_dok.cena1,0)),2)
                    ELSE K_ROBE*(
                                     CASE WHEN D.VRSTA_DOK = 11 AND UPPER(ORGD.DODATNI_TIP) = 'VP2' THEN
                                             STAVKA_DOK.CENA1
                                          ELSE
                                             STAVKA_DOK.CENA1
                                     END 
                                 )
                END),0)),2) VREDNOST               
               From Dokument,
                    (SELECT  BROJ_DOK,
                             VRSTA_DOK,
                             GODINA,
                             STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,PAKOVANJE,BROJ_KOLETA,K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI

                       FROM STAVKA_DOK

                    ) Stavka_Dok,
                    Proizvod,
                    ORG_DEO_OSN_PODACI ORGD                   
         Where D.Vrsta_Dok = sd.Vrsta_Dok And D.Broj_Dok = sd.Broj_Dok And D.Godina = sd.Godina And
               D.ORG_DEO = ORGD.ORG_DEO (+) AND
               D.Status > 0 And (sd.K_Robe != 0 OR D.VRSTA_DOK = '80') And
               D.Datum_Dok Between dDatumPS And dDatum And              
               D.Org_Deo = nOrgDeo And Proizvod.sifra=sd.proizvod                
         Group By sd.Proizvod,Proizvod.tip_proizvoda,Proizvod.posebna_grupa,Proizvod.grupa_proizvoda,Proizvod.naziv
         Order By Proizvod.posebna_grupa,sd.proizvod;
