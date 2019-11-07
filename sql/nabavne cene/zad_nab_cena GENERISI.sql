				Select
d.godina, d.vrsta_dok, d.broj_dok,
d.org_deo,d.tip_dok,
				       SD.PROIZVOD, d.datum_dok, P.NAZIV
				     , p.ZAD_NAB_CENA_DOK_VRED, p.ZAD_NAB_CENA_DOK_DAT
				     , SD.RABAT, SD.POREZ, SD.CENA, Z_TROSKOVI

				     , D.TIP_DOK

				     , VD.ZA_VRSTA_DOK
				     , CASE WHEN P.TIP_PROIZVODA = 8 THEN
				                 CASE WHEN NVL(Z_TROSKOVI,0) > 0 THEN
				                      ((SD.CENA*SD.KOLICINA)*(1-NVL(SD.RABAT,0)/100) + Z_TROSKOVI) / SD.KOLICINA
				                 ELSE
                                      (SD.CENA)*(1-NVL(SD.RABAT,0)/100)
                                 END
                       ELSE
                            SD.CENA1
				       END Cena1
				     , SD.KOLICINA
				From dokument d
				   , stavka_dok sd
				   , PROIZVOD P
				   , VEZNI_DOK VD
				Where d.broj_dok> 0
				  and d.vrsta_dok = '3'
				  and d.godina > 0
				  and d.tip_dok  in( 10,16)
				  and d.status   in (1,3)
				  and d.ppartner not in (select vrednost from PLANIRANJE_MAPIRANJE  where VRSTA ='SIFRA_NASE_FIRME_U_PARTNERIMA' )
				  and d.broj_dok  = sd.broj_dok and d.vrsta_dok = sd.vrsta_dok and d.godina = sd.godina
				  AND P.SIFRA=SD.PROIZVOD
				  And P.TIP_PROIZVODA NOT IN (select vrednost from PLANIRANJE_MAPIRANJE
                                                 where vrsta in ('GOT_PROIZVODI_TIPOVI','POLUPROIZVODI_TIPOVI')                                                )

				  and d.broj_dok  = Vd.broj_dok and d.vrsta_dok = Vd.vrsta_dok and d.godina = Vd.godina
				  AND (VD.ZA_VRSTA_DOK='24' OR VD.ZA_VRSTA_DOK='2' )
				Order by SD.PROIZVOD, d.datum_dok desc
