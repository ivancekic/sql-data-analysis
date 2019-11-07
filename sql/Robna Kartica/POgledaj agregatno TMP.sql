declare
    nMax Number;
    cPro Varchar2(9):='6137';
Begin

		Delete report_tmp_pdf;
--		nMax := PUtility.MaxRowRepTmpDokPdf;
-- 		Insert into report_tmp_pdf(c1,c2,c3,c4)
--					Values(to_char(nMax),'Proizvod','Godina','Magacin');
		For p in(
			select
					distinct d.godina, org_Deo
			from stavka_dok sd, dokument d
			Where
			  -- veza tabela
			      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
			  AND (K_ROBE <> 0 or d.vrsta_dok = '80')
			  AND STATUS  > 0
	          and sd.proizvod=cPro
			Order by d.org_deo, d.godina
 		)

 		Loop
--	 		Putility.InsRepTmpDokPdfDok(cPro,p.godina,p.org_deo,null,null);
			nMax := PUtility.MaxRowRepTmpDokPdf;
	 		Insert into report_tmp_pdf(c1,c2,c3,c4)
						Values(to_char(nMax),'Proizvod','Godina','Magacin');

			nMax := PUtility.MaxRowRepTmpDokPdf;
	 		Insert into report_tmp_pdf(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27)
						Values(to_char(nMax),'STATUS','PRO','PRO_NAZ','MAG','DATUM_DOK','DATUM_UNOSA','GOD','VRD','BRD','BRD1','TIPD','CENA','RAB','CENA1','VP_CENA','ULAZ','IZLAZ','STANJE','DUGUJE','POTRAZUJE','SALDO','PROS_KOL','PROS_CENA','NETO_KG','NIV_STAV','PLAN');

	 		-----------------
	 		For RK in
				  (
					select d1.*
					     , PPlanskiCenovnik.Cena (d1.pro , d1.Datum_Dok, 'YUD' , 1  ) Plan

					from
					(
						select status, PRO, pproizvod.naziv(pro) pro_naz,  mag,DATUM_DOK,DATUM_UNOSA,god,vrd,brd, brd1, tipd
						     , cena, rab, CENA1, VP_CENA
						     , ulaz,izlaz,STANJE
						     , duguje, POTRAZUJE, saldo

					         , STANJE 		 PROS_KOL
					         ,
								ROUND(
								CASE WHEN STANJE <> 0 THEN
								     SALDO / STANJE
								ELSE
								     CENA1
								END,6)  PROS_CENA

						     , neto_kg

							, case when vrd='11' then
							      (select za_broj_dok from vezni_dok vd where vd.godina =god and vd.vrsta_dok=vrd and vd.broj_dok=brd and vd.za_vrsta_dok='90')
							  end  niv_stav

						from
						(
							select d.status, sd.proizvod pro,org_deo mag, d.datum_dok, D.DATUM_UNOSA, d.godina god, d.vrsta_Dok vrd, d.broj_dok brd, D.BROJ_DOK1 brd1, d.tip_dok tipd
							     , sd.rabat rab
							     , sd.cena
							     , neto_kg
					             ,
					                 sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.k_robe,0)

					                 *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok)

					                 ulaz,

					                 sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.k_robe,0)

					                 *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok)

					                 izlaz

							     , sum(kolicina*FAKTOR*K_ROBE)
							       OVER (PARTITION BY d.org_deo, SD.PROIZVOD ORDER BY org_deo, sd.proizvod, d.datum_dok, D.DATUM_UNOSA
							             ROWS UNBOUNDED PRECEDING) AS STANJE
					             ,
					                 case when d.vrsta_dok = '80' then
					                     sd.kolicina*sd.faktor*(sd.cena1 - sd.cena)
					                 else
					                     sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.cena1,0)*nvl(sd.k_robe,0)
					                     *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok)
					                 end
					                 duguje,

					                 sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.cena1,0)*nvl(sd.k_robe,0)
					                 *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok)
					                 potrazuje
								, sum(
					                 case when d.vrsta_dok = '80' then
					                     sd.kolicina*sd.faktor*(sd.cena1 - sd.cena)
					                 else
					                     sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.cena1,0)*nvl(sd.k_robe,0)
					                     *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'D',d.datum_dok)
					                 end
									-
					                 sign(sd.k_robe)*nvl(decode(d.tip_dok,14,kolicina,realizovano),0)*nvl(faktor,0)*nvl(sd.cena1,0)*nvl(sd.k_robe,0)
					                 *PDokument.ZokiUlazIzlaz(d.vrsta_dok,d.tip_dok,sd.K_ROBE,'P',d.datum_dok)

								     )
							       OVER (PARTITION BY d.org_deo, SD.PROIZVOD ORDER BY org_deo, sd.proizvod, d.datum_dok, D.DATUM_UNOSA
							             ROWS UNBOUNDED PRECEDING) AS saldo
					                , SD.CENA1
					                ,
					                 (select ROUND(cena/KOL_CENA/FAK_CENA,4) from prodajni_cenovnik
					                   where proizvod = sd.proizvod
					                     and valuta=sd.valuta
					                     and datum =  (select max(datum)
					                                     from prodajni_cenovnik
					                                    where proizvod = sd.proizvod
					                                      AND Datum <= TO_DATE( TO_CHAR(D.DATUM_DOK,'DD.MM.YYYY')||' '||'23:59:59','DD.MM.YYYY HH24.MI:SS')
					                                      and valuta=sd.valuta
					                                  )
					                 ) VP_CENA

							from stavka_dok sd, dokument d
							Where
							  -- veza tabela
							      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
							  -- ostali uslovi
					          and d.godina = p.godina
					          and d.org_Deo =p.org_deo
							  AND (K_ROBE <> 0 or d.vrsta_dok = '80')
							  AND STATUS  > 0
					          and sd.proizvod=cPro
						) d1

					) d1
					order by
					d1.mag, d1.datum_dok,d1.datum_unosa
					)
			Loop
			nMax := PUtility.MaxRowRepTmpDokPdf;
	 		Insert into report_tmp_pdf(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27)
						Values(to_char(nMax),rk.STATUS,rk.PRO,rk.PRO_NAZ,rk.MAG,to_char(rk.DATUM_DOK,'dd.mm.yy'),rk.DATUM_UNOSA,rk.GOD,rk.VRD,rk.BRD,rk.BRD1,rk.TIPD,rk.CENA,rk.RAB,rk.CENA1,rk.VP_CENA,rk.ULAZ,rk.IZLAZ,rk.STANJE,rk.DUGUJE,rk.POTRAZUJE,rk.SALDO,rk.PROS_KOL,rk.PROS_CENA,rk.NETO_KG,rk.NIV_STAV,rk.PLAN);
			End Loop;
	 		-----------------
 		End Loop;

End;
/
select c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27
from report_tmp_pdf
order by to_number(c1)
