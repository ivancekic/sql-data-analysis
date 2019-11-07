select
--broj_dok, count(broj_dok) uk
d.*
,
sd.*
from
(
	SELECT d1.*
	FROM DOKUMENT D1
	WHERE d1.VRSTA_DOK in ( '3','4')
	  and d1.tip_dok = 10
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
where substr(d.broj_dok,1,1) <> '-'
  and sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
--group by broj_dok
