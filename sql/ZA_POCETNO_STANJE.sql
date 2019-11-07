SELECT * FROM POPIS
WHERE GODINA = 2007
  AND ORG_DEO IN
   (
    Select ID from organizacioni_deo
    Where tip = 'MAG'
      AND ID NOT IN (SELECT MAGACIN FROM PARTNER_MAGACIN_FLAG)
--    ORDER BY ID
   )
ORDER BY ORG_DEO
