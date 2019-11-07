		Select p.POPISNA_LISTA P_BR, p.GODINA P_GOD
		     , p.org_deo P_MAG, od.naziv p_naziv_mag
		     , p.DATUM P_DATUM, p.user_id
		     , sp.STAVKA P_STAV
		     , pr.tip_proizvoda p_tp, tp.cena p_tc
		     , sp.PROIZVOD P_PRO--,pr.naziv naziv_pro
		     , PO_KNJIGAMA P_KNJ, PO_POPISU P_POP, RASHOD P_RAS
	--	     , ps.status ps12_stat, ps.broj_dok  ps12_brd
	,(SELECT STANJE FROM ZALIHE z WHeRe z.ORG_dEO = P.ORG_dEO ANd z.proizvod = sp.proizvod) stanje
		from popis p, organizacioni_Deo od
		   , stavka_popisa sp, proizvod pr
		   , TIP_PROIZVODA TP
		where p.godina = 2012
--		  and p.status =
          and p.POPISNA_LISTA=10

		  and od.id=p.org_deo

		  and p.godina = sp.godina
		  and p.popisna_lista = sp.popisna_lista

		  and pr.sifra=sp.proizvod
		  and TP.SIFRA=pr.tip_proizvoda

--		  and tp.cena=1
and PO_KNJIGAMA != (SELECT STANJE FROM ZALIHE z WHeRe z.ORG_dEO = P.ORG_dEO ANd z.proizvod = sp.proizvod)
order by Proizvod
