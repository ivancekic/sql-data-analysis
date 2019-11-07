Select * from zalihe
WHERE ORG_DEO not IN (SELECT MAGACIN FROM PARTNER_MAGACIN_FLAG)
  and stanje < 0
