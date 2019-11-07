--select sum(vrednost) VRED
--from
--(

select org_deo, PROIZVOD,POSEBNA_GRUPA,STANJE,VREDNOST,U_KONTROLI, case when stanje <> 0 Then round(vrednost/stanje,4) else 0 end cena
from
(
         Select d.org_deo, p.sifra, sd.Proizvod, P.posebna_grupa,
                round(Sum(NVL(decode(d.tip_dok,14,Kolicina,realizovano)*Faktor
                                * case when d.vrsta_dok = '90' then 0 else K_ROBE end
                                ,0)),5) STANJE,
                round(Sum(NVL(decode(d.tip_dok,14,Kolicina,realizovano)*Faktor*
                                    (CASE WHEN d.VRSTA_DOK = '80' THEN
                                               (sd.CENA1-sd.CENA)
                                          WHEN d.vrsta_dok  ='90' then
                                               ROUND((NVL(sd.cena,0)-NVL(sd.cena1,0)),2)
                                     ELSE K_ROBE*(
                                                    CASE WHEN d.VRSTA_DOK = 11 AND UPPER(ORGD.DODATNI_TIP) = 'VP2' THEN
                                                              sd.CENA1
                                                    ELSE
                                                              sd.CENA1
                                                    END
                                                 )
                                    END)
                             ,0)),2) VREDNOST

               , (select sum(kolicina*faktor)
                   from dokument dx, stavka_dok stx
                  where dx.vrsta_dok = stx.vrsta_dok and dx.broj_dok = stx.broj_dok and dx.godina = stx.godina
                    and dx.vrsta_dok = 3 and dx.tip_dok   = 10 and dx.status in ('-8','-9') and dx.godina > 2008
                    and dx.org_deo = &nOrgDeo
                    and stx.proizvod = sd.proizvod)
                  u_kontroli

               From Dokument d,
                    (SELECT  BROJ_DOK, VRSTA_DOK, GODINA,
                             STAVKA,PROIZVOD,LOT_SERIJA,ROK,KOLICINA,JED_MERE,CENA,VALUTA,LOKACIJA,PAKOVANJE,BROJ_KOLETA,
                             K_REZ,K_ROBE,K_OCEK,KONTROLA,FAKTOR,REALIZOVANO,RABAT,POREZ,KOLICINA_KONTROLNA,AKCIZA,TAKSA,CENA1,Z_TROSKOVI
                       FROM STAVKA_DOK
                    ) sd,
                    Proizvod p,
                    ORG_DEO_OSN_PODACI ORGD

         Where d.Vrsta_Dok = sd.Vrsta_Dok And
               d.Broj_Dok = sd.Broj_Dok And
               d.Godina = sd.Godina And
               d.ORG_DEO = ORGD.ORG_DEO (+) AND
               d.Status > 0 And
               d.Datum_Dok between to_date('01.01.'||to_char(&nGod),'dd.mm.yyyy') and to_date('31.12.'||to_char(&nGod),'dd.mm.yyyy') and
               (sd.K_Robe != 0 OR d.VRSTA_DOK = '80') And
               d.Org_Deo = &nOrgDeo And P.sifra=sd.proizvod
         Group By d.org_deo, p.sifra, sd.Proizvod,P.tip_proizvoda,P.posebna_grupa,P.grupa_proizvoda,P.naziv
         Order By P.posebna_grupa,p.sifra
) s
--where stanje != 0
--and proizvod !=399
--)
