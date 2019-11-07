Select distinct
       'Exec GenerisiStanjeZaliha('||org_deo||',sysdate,true);' 	gen_zal
     , 'Exec GenerisiRezervisane('||org_deo||');' 					gen_rez
from dokument
where org_Deo not in (select magacin from partner_magacin_flag)
and godina = 2013
order by 'Exec GenerisiStanjeZaliha('||org_deo||',sysdate,true);'
