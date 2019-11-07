-- tabela ZAVISNI_TROSKOVI_FORMULE
CREATE TABLE INVEJ.ZAVISNI_TROSKOVI_FORMULE
(
    FORMULA  NUMBER        NOT NULL,
    VREDNOST VARCHAR2(100) NOT NULL,
    OPIS     VARCHAR2(30)      NULL
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
ALTER TABLE INVEJ.ZAVISNI_TROSKOVI_FORMULE
    ADD CONSTRAINT ZAVISNI_TRO_FORMULA_PK
    PRIMARY KEY (FORMULA)
    USING INDEX TABLESPACE DES2
                PCTFREE 10
                INITRANS 2
                MAXTRANS 255
                STORAGE(INITIAL 24K
                        BUFFER_POOL DEFAULT)
    LOGGING
    ENABLE
    VALIDATE
/
GRANT ALTER ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT DEBUG ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT DELETE ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT FLASHBACK ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT INSERT ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT ON COMMIT REFRESH ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT QUERY REWRITE ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT SELECT ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT UPDATE ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO FULL_ACCESS
/
GRANT SELECT ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO RESTRICT_ACCESS
/
GRANT SELECT ON INVEJ.ZAVISNI_TROSKOVI_FORMULE TO ZA_PROGRAMERE
/                                                              
CREATE PUBLIC SYNONYM ZAVISNI_TROSKOVI_FORMULE
    FOR INVEJ.ZAVISNI_TROSKOVI_FORMULE
/
