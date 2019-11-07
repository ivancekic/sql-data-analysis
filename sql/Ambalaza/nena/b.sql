Select id
from organizacioni_deo
where id in (select magacin from partner_magacin_flag)
order by id
