Select distinct org_deo, 'Exec generisiStanjeZaliha(' || org_deo || ', sysdate, true );'  gen
from dokument
where godina = 2015
  and org_Deo not in (select magacin from partner_magacin_flag)
order by org_Deo
