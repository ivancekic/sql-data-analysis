--SELECT * FROM ZALIHE_ANALITIKA
--WHERE LOKACIJA IS NULL
--AND ORG_DEO NOT IN (SELECT MAGACIN FROM PARTNER_MAGACIN_FLAG)

SELECT * --org_deo , porganizacionideo.naziv(org_deo) , PROIZVOD , pproizvod.naziv(proizvod)
FROM ZALIHE_ANALITIKA
WHERE LOKACIJA IS NULL
--AND ORG_DEO IN (SELECT MAGACIN FROM PARTNER_MAGACIN_FLAG)
--GROUP BY org_deo , PROIZVOD
ORDER BY TO_NUMBER(PROIZVOD)