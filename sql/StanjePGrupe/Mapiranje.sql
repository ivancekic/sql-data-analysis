select --PMF.MAGACIN,PMF.PPARTNER ,
M.*
from MAPIRANJE M
----, PARTNER_MAGACIN_FLAG PMF

--Delete from MAPIRANJE
WHERE Modul = 'ZALIHE'
  And Vrsta = 'PROMET PO POS GR NA DAN'
order by to_number(ul01),TO_NUMBER(UL02),TO_NUMBER(UL03)
--
