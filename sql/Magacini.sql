Select ID , NAZIV
from organizacioni_deo
Where tip = 'MAG'
  AND ID NOT IN (SELECT MAGACIN FROM PARTNER_MAGACIN_FLAG)

ORDER BY ID
