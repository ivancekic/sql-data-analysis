CREATE TABLE rubin.PRODAJNI_CENOVNIK_2_LOG
(
    DATUM_IZMENE  DATE              NULL,
    VRSTA_DOK     VARCHAR2(2)       NULL,
    BROJ_DOK      VARCHAR2(9)       NULL,
    GODINA        NUMBER(4,0)       NULL,
    ORG_DEO       NUMBER            NULL,
    NIV_VRSTA_DOK VARCHAR2(2)       NULL,
    NIV_BROJ_DOK  VARCHAR2(9)       NULL,
    NIV_GODINA    NUMBER(4,0)       NULL,
    PROIZVOD      VARCHAR2(7)       NULL,
    ZALIHA        NUMBER            NULL,
    KOLICINA      NUMBER            NULL,
    CENA1_OLD     NUMBER            NULL,
    CENA1_NEW     NUMBER            NULL,
    NAPOMENA      VARCHAR2(100)     NULL
)
ORGANIZATION HEAP
TABLESPACE DES2
LOGGING
PCTFREE 10
PCTUSED 0
INITRANS 1
MAXTRANS 255
STORAGE(BUFFER_POOL DEFAULT)
NOPARALLEL
NOCACHE
/
GRANT DELETE ON rubin.PRODAJNI_CENOVNIK_2_LOG TO FULL_ACCESS
/
GRANT INSERT ON rubin.PRODAJNI_CENOVNIK_2_LOG TO FULL_ACCESS
/
GRANT SELECT ON rubin.PRODAJNI_CENOVNIK_2_LOG TO FULL_ACCESS
/
GRANT UPDATE ON rubin.PRODAJNI_CENOVNIK_2_LOG TO FULL_ACCESS
/
GRANT SELECT ON rubin.PRODAJNI_CENOVNIK_2_LOG TO RESTRICT_ACCESS
/
CREATE PUBLIC SYNONYM PRODAJNI_CENOVNIK_2_LOG
    FOR RUBIN.PRODAJNI_CENOVNIK_2_LOG
/
----
GRANT SELECT ON RUBIN.PRODAJNI_CENOVNIK_2_LOG TO RESTRICT_ACCESS
/

