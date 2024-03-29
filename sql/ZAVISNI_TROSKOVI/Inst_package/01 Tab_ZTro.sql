----------------------------------------------------------------------------------
-- tabela ZAVISNI_TROSKOVI
CREATE TABLE INVEJ.ZAVISNI_TROSKOVI
(
    BROJ_DOK    VARCHAR2(7)  NOT NULL,
    VRSTA_DOK   VARCHAR2(2)  NOT NULL,
    GODINA      NUMBER(4,0)  NOT NULL,
    STATUS      NUMBER(2,0)  NOT NULL,
    USER_ID     VARCHAR2(30) NOT NULL,
    DATUM_UNOSA DATE         NOT NULL
)
ORGANIZATION HEAP
TABLESPACE DES2
NOLOGGING
PCTFREE 10
PCTUSED 0
INITRANS 1
MAXTRANS 255
STORAGE(BUFFER_POOL DEFAULT)
NOPARALLEL
NOCACHE
/
COMMENT ON COLUMN INVEJ.ZAVISNI_TROSKOVI.BROJ_DOK IS
'Redni broj zavisnog troska isti je kao broj prijemnice za koju se pravi'
/
COMMENT ON COLUMN INVEJ.ZAVISNI_TROSKOVI.VRSTA_DOK IS
'Vrsta zavisnog troska isti je kao broj prijemnice za koju se pravi'
/
COMMENT ON COLUMN INVEJ.ZAVISNI_TROSKOVI.GODINA IS
'Godina zavisnog troska isti je kao broj prijemnice za koju se pravi'
/
COMMENT ON COLUMN INVEJ.ZAVISNI_TROSKOVI.STATUS IS
'Status zavisnog troska'
/
COMMENT ON COLUMN INVEJ.ZAVISNI_TROSKOVI.USER_ID IS
'Korisnik koji je poslednji menjao dokument'
/
COMMENT ON COLUMN INVEJ.ZAVISNI_TROSKOVI.DATUM_UNOSA IS
'Datum zadnje promene dokumenta'
/
ALTER TABLE INVEJ.ZAVISNI_TROSKOVI
    ADD CONSTRAINT ZAVISNI_TROSKOVI_PK
    PRIMARY KEY (BROJ_DOK,VRSTA_DOK,GODINA)
    USING INDEX TABLESPACE DES2
                PCTFREE 10
                INITRANS 2
                MAXTRANS 255
                STORAGE(BUFFER_POOL DEFAULT)
    NOLOGGING
    ENABLE
    VALIDATE
/
ALTER TABLE INVEJ.ZAVISNI_TROSKOVI
    ADD CONSTRAINT ZAVISNI_TROSKOVI_FK
    FOREIGN KEY (BROJ_DOK,VRSTA_DOK,GODINA)
    REFERENCES INVEJ.DOKUMENT (BROJ_DOK,VRSTA_DOK,GODINA)
    ENABLE
/
GRANT DELETE ON INVEJ.ZAVISNI_TROSKOVI TO FULL_ACCESS
/
GRANT INSERT ON INVEJ.ZAVISNI_TROSKOVI TO FULL_ACCESS
/
GRANT SELECT ON INVEJ.ZAVISNI_TROSKOVI TO FULL_ACCESS
/
GRANT UPDATE ON INVEJ.ZAVISNI_TROSKOVI TO FULL_ACCESS
/
GRANT SELECT ON INVEJ.ZAVISNI_TROSKOVI TO RESTRICT_ACCESS
/
GRANT SELECT ON INVEJ.ZAVISNI_TROSKOVI TO ZA_PROGRAMERE
/
-- pub synonym
CREATE PUBLIC SYNONYM ZAVISNI_TROSKOVI
    FOR INVEJ.ZAVISNI_TROSKOVI
/