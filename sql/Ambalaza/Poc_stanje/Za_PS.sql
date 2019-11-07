Select od.id , od.naziv, ma.ppartner
,d.*
, ps.*
from organizacioni_Deo od
     , partner_magacin_flag ma
     , ps_ambalaze ps
     , dokument d
where ps.godina = 2010
  and ps.partner = ma.ppartner
  and od.id = ma.magacin
  and d.org_Deo = od.id
  and d.vrsta_Dok = 21
  and d.godina = 2016
order by id
