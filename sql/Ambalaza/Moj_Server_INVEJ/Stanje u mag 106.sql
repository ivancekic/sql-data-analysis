SELECT PPROIZVOD.NAZIV(PROIZVOD), Z.* FROM ZALIHE Z
WHERE ORG_DEO = 106
  AND PROIZVOD IN (3181,399)
