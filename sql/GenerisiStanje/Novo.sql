Select distinct org_deo
, 'exec GenerisiStanjeZaliha('||org_Deo||',sysdate,true);' gen_stanje
, 'exec GenerisiRezervisane('||org_Deo||');' gen_rez
, 'exec GenerisiOcekivane('||org_Deo||');' gen_rez
from dokument
where godina = 2015
  and org_deo not in (select magacin from partner_magacin_flag)
order by org_deo
