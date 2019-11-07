select sum(vrednost)
from
(
				SELECT z.PROIZVOD, p.naziv naziv_pro, p.jed_mere, p.tip_proizvoda, p.cena
				     , z.POSEBNA_GRUPA,z.STANJE,z.VREDNOST,U_KONTROLI
				     , pak.za_kol
				     , pak.pak_sif
				     , case when nvl(pak.za_kol,0) <> 0 then
				                 round( z.stanje / pak.za_kol ,0)
				       end stanje_pak
				     , fir_rez
				     , INVEJ_REZ_21_22
				     , fir_rez + INVEJ_REZ_21_22 uk_rez
                     , case when z.STANJE <> 0 then round(z.VREDNOST / z.STANJE,dec.dec) else 0 end cena_pro
                     , z.STANJE - (nvl(fir_rez,0) + nvl(INVEJ_REZ_21_22,0)) uk_raspolozivo
				FROM
				(
				         Select Stavka_dok.Proizvod, Proizvod.posebna_grupa,
				/*
				ZORAN PROMENIO ZBOG PRIKAZA NIVELACIJE
				                Sum(NVL(decode(dokument.tip_dok,14,Kolicina,realizovano)*Faktor*K_Robe,0)),
				                Sum(Round(NVL(decode(dokument.tip_dok,14,Kolicina,realizovano)*Faktor*K_Robe*Cena1,0),2))
				*/

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


				         Where Dokument.Vrsta_Dok = Stavka_Dok.Vrsta_Dok And
				               Dokument.Broj_Dok = Stavka_Dok.Broj_Dok And
				               Dokument.Godina = Stavka_Dok.Godina And
				               DOKUMENT.ORG_DEO = ORGD.ORG_DEO (+) AND
				               Dokument.Status > 0 And
				               Dokument.Datum_Dok Between &dDatumPS And &dDatum And
				               (Stavka_Dok.K_Robe != 0 OR DOKUMENT.VRSTA_DOK = '80') And
				               Dokument.Org_Deo = &nOrg And Proizvod.sifra=Stavka_dok.proizvod

				         Group By Stavka_dok.Proizvod,Proizvod.tip_proizvoda,Proizvod.posebna_grupa,Proizvod.grupa_proizvoda,Proizvod.naziv
				) Z
				,
				                (select STX.PROIZVOD, sum(kolicina*faktor) U_KONTROLI
				                   from dokument dx, stavka_dok stx
				                  where

				--                    and nvl(dx.broj_dok, ' ') <> ' '
				--                    and
				                        dx.vrsta_dok = '3'
				--                    and dx.godina > 2008
				                    and dx.tip_dok   = '10'
				                    and dx.status in ('-8','-9')
				                    and dx.org_deo = &nOrg

				                    and dx.broj_dok = stx.broj_dok and dx.vrsta_dok = stx.vrsta_dok and dx.godina = stx.godina
				                  GROUP BY STX.PROIZVOD
				                    )
				                  u_kon
				,
				(

				       Select pak.proizvod
				            , (Select pak1.za_kolicinu
				               From pakovanje pak1
				               Where pak1.proizvod = pak.proizvod
				              ) za_kol
				            , (Select pak1.pak_sifra
				               From pakovanje pak1
				               Where pak1.proizvod = pak.proizvod
				              ) pak_sif
				       From PAKOVANJE pak
				       Group by pak.proizvod
				       Having COUNT(pak.proizvod) = 1
				) pak
				,
				(
				         Select proizvod, round(Sum(NVL(decode(d.tip_dok,14, Kolicina, Kolicina - Realizovano) * Faktor,0)),5) fir_rez
				         From stavka_dok sd, dokument d
				         Where d.vrsta_dok in (9,10)
				           And d.status in (1,3)
				           And d.org_Deo = &nOrg
				--           And proizvod = cPro
				           And sd.kolicina != sd.realizovano
				           And d.datum_dok between &dDatumPS And &dDatum
				           And d.godina = sd.godina And d.vrsta_dok = sd.vrsta_dok And d.broj_dok = sd.broj_dok
				         group by proizvod
				) rez
				,
				(
				            Select proizvod
				            , INVEJ_REZ_21_22
				            From ZALIHE_UNION_REZ_INVEJ_MAG
				            Where ORG_DEO = &nOrg
				--         group by proizvod, INVEJ_REZ_21_22
				) inv_rez
				, ( select p1.sifra, p1.naziv, p1.jed_mere, p1.tip_proizvoda, tp1.cena
				    from proizvod p1, Tip_Proizvoda tp1
				    where p1.tip_proizvoda = tp1.sifra
				   ) p
				,
				(
				  Select to_number(format) dec from aplikacija_forme_def where naziv='!!!_SVE_FORME'
				)  dec
				WHERE
				      p.sifra = z.proizvod
				  and Z.proizvod = u_kon.proizvod (+)
				  and Z.proizvod = pak.proizvod (+)
				  and Z.proizvod = rez.proizvod (+)
				  and Z.proizvod = inv_rez.proizvod (+)

--				Order By posebna_grupa, proizvod

)
