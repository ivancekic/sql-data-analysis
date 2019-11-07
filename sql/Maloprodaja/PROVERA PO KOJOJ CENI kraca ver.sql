select
			D.GODINA, D.VRSTA_DOK, D.BROJ_DOK, D.DATUM_DOK
			, SD.STAVKA
			, SD.PROIZVOD
			, SD.CENA
			, SD.CENA1
			, PProdajniCenovnikGrKup.Cena ('GKMP', sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) GK_MP
			, SD.CENA
			  -
			  PProdajniCenovnikGrKup.Cena ('GKMP', sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) RAZL
			, PProdajniCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) PROD
--			--,PPlanskiCenovnik.Cena (sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  ) Plan
--			, Pporez.ProcenatPoreza(d.Poslovnica,sd.Proizvod,d.Datum_dok,3) treba_por
--
			, PProdajniCenovnikMP.Cena_MP( sd.Proizvod , d.Datum_Dok , sd.Valuta , sd.Faktor)          MP_C-- Stavka.nPOlje4
			, PProdajniCenovnikMP.Cena( sd.Proizvod , d.Datum_Dok , sd.Valuta , sd.Faktor)             MC_CENA-- Stavka_nPOlje5

from stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR, tip_proizvoda tp
--from dokument d, stavka_dok sd, PROIZVOD P , GRUPA_PR  GPR, tip_proizvoda tp
Where 1= 1
AND D.GODINA = 2014
and d.vrsta_dok = '11'
AND D.TIP_DOK = 231
--and d.datum_dok >= to_date('01.07.2014','dd.mm.yyyy')
--and d.datum_dok <= to_date('01.07.2014','dd.mm.yyyy')

and d.datum_dok BETWEEN to_date('20.07.2014','dd.mm.yyyy') and to_date('05.08.2014','dd.mm.yyyy')


--AND SD.CENA <> PProdajniCenovnikGrKup.Cena ('GKMP', sd.proizvod , d.Datum_Dok, 'YUD' , sd.Faktor  )
--  and
--     (
--	      (d.godina = 2013
--		 	  and d.vrsta_Dok = '11'
--			  and d.broj_dok IN ( '144256')
--	      )
--      OR
--	      (d.godina = 2014
--		 	  and d.vrsta_Dok = '11'
--			  and d.broj_dok IN ( '2163','160872' , '192787' )
--	      )
--      )
--
  -- veza tabela
  and d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  and tp.sifra = p.tip_proizvoda
  -----------------------------
  and d.status > 0
order by
--stavka
--TO_NUMBER(SD.PROIZVOD),
d.datum_dok,
d.datum_unosa;
--ORDER BY STAVKA



--393.76
--393.76

--388.73
--388.73

