select * from
(
		Select distinct
			  1 Akcija
			, 'Gen Stanje' akc_naz
			, d.org_deo mag, od.naziv mag_naz
			, 'exec GenerisiStanjeZaliha('||org_Deo||',sysdate,true);' gen
		from dokument d, organizacioni_Deo od
		where d.godina = 2016
		  and d.org_Deo =nvl(&Org,d.org_deo)
		  and d.org_deo not in (select magacin from partner_magacin_flag)
		  and od.id = d.org_deo
	union
		Select distinct
			  2 Akcija
			, 'Gen Rez' akc_naz
			, d.org_deo mag, od.naziv mag_naz
			, 'exec GenerisiRezervisane('||org_Deo||');' gen
		from dokument d, organizacioni_Deo od
		where d.godina = 2016
		  and d.org_Deo =nvl(&Org,d.org_deo)
		  and d.org_deo not in (select magacin from partner_magacin_flag)
		  and od.id = d.org_deo
	union
		Select distinct
			  3 Akcija
			, 'Gen Ocek' akc_naz
			, d.org_deo mag, od.naziv mag_naz
			, 'exec GenerisiOcekivane('||org_Deo||');' gen
		from dokument d, organizacioni_Deo od
		where d.godina = 2016
		  and d.org_Deo =nvl(&Org,d.org_deo)
		  and d.org_deo not in (select magacin from partner_magacin_flag)
		  and od.id = d.org_deo
)

order by akcija, mag
