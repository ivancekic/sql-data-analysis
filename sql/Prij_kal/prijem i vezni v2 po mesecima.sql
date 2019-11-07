select
		   to_char(d.datum_dok,'mm') mes,
		   to_char(d.datum_dok,'yyyy.mon') god_mes
--		 , ppartner, pposlovniPartner.naziv(ppartner)   prt_naz
		 , round(sum(cena*kolicina),2) 								vred_nabavke
		 , round(sum(cena*kolicina*(nvl(sd.rabat,0))/100),2) 		vred_rabata
		 , round(sum(cena*kolicina*(100-nvl(sd.rabat,0))/100),2) 	vred_nabavke_rab
		 , round(sum(Z_TROSKOVI),2)									vred_z_tro
		 , round(sum(cena1*kolicina),2) 						    vred_nabavna
from
(
	SELECT d1.*
	FROM DOKUMENT D1
	WHERE d1.VRSTA_DOK in ( '3','4')
	  and d1.tip_dok = 10
	  and d1.ppartner is not null
	  and d1.status > 0
	  and substr(d1.broj_dok,1,1) <> '-'
	  and d1.datum_dok between to_date('01.09.2013','dd.mm.yyyy') and to_date('31.12.2013','dd.mm.yyyy')

	union

	SELECT d2.*
	FROM DOKUMENT D2
	   , (SELECT * FROM VEZNI_DOK WHERE ZA_VRSTA_DOK IN ('5','30')) VD1
	   , (SELECT * FROM DOKUMENT d4
	      WHERE VRSTA_DOK IN ('5','30')
	        and d4.status > 0
       	    and substr(d4.broj_dok,1,1) <> '-'
	        and d4.datum_dok between to_date('01.09.2013','dd.mm.yyyy') and to_date('31.12.2013','dd.mm.yyyy')
	      )D3
	WHERE d2.VRSTA_DOK in ( '3','4')
	  and d2.tip_dok = 10
	  and d2.status > 0

	  and Vd1.godina = d2.godina and Vd1.vrsta_dok = d2.vrsta_dok and Vd1.broj_dok = d2.broj_dok
	  and d3.godina = Vd1.ZA_godina and d3.vrsta_dok = Vd1.ZA_vrsta_dok and d3.broj_dok = Vd1.ZA_broj_dok
	  and d3.tip_dok <> 301
) d
, stavka_dok sd
where 1=1
  and substr(d.broj_dok,1,1) <> '-'
  and d.org_deo not in (64,1383)
  and sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
group by to_char(d.datum_dok,'yyyy.mon')
       , to_char(d.datum_dok,'mm')
--, ppartner, pposlovniPartner.naziv(ppartner)
order by to_number(to_char(d.datum_dok,'mm'))
