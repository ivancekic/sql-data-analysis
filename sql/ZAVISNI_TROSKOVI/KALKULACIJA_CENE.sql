DROP TABLE VITAL.KALKULACIJA_CENE CASCADE CONSTRAINTS;

CREATE TABLE VITAL.KALKULACIJA_CENE
(
  BROJ_DOK             VARCHAR2(9 BYTE)         NOT NULL,
  VRSTA_DOK            VARCHAR2(2 BYTE)         NOT NULL,
  GODINA               NUMBER(4)                NOT NULL,
  STAVKA               NUMBER                   NOT NULL,
  PROIZVOD             VARCHAR2(7 BYTE),
  KOLICINA             NUMBER,
  JED_MERE             VARCHAR2(3 BYTE),
  CENA                 NUMBER(19,4),
  VALUTA               VARCHAR2(3 BYTE),
  FAKTOR               NUMBER(11,5),
  VRSTA_TROSKOVA       VARCHAR2(5 BYTE),
  DOBAVLJAC_VR_TRO     VARCHAR2(7 BYTE),
  DOKUMENT_DOBAVLJACA  VARCHAR2(20 BYTE),
  POREZ_VR_TRO_PROC    NUMBER(2,2),
  POREZ_VR_TRO_IZNOS   NUMBER(10),
  DATUM_DOK            DATE,
  VALUTA_PLACANJA      NUMBER,
  USER_ID              VARCHAR2(30 BYTE)        NOT NULL,
  DAUTM_UNOSA          DATE                     NOT NULL
)
TABLESPACE DES2
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          32K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX VITAL.KALKULACIJA_CENE_PK1 ON VITAL.KALKULACIJA_CENE
(STAVKA, GODINA, VRSTA_DOK, BROJ_DOK)
LOGGING
TABLESPACE DES2
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          24K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE VITAL.KALKULACIJA_CENE ADD (
  FOREIGN KEY (STAVKA, GODINA, VRSTA_DOK, BROJ_DOK) 
 REFERENCES VITAL.STAVKA_DOK (STAVKA,GODINA,VRSTA_DOK,BROJ_DOK));

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON VITAL.KALKULACIJA_CENE TO FULL_ACCESS;

GRANT SELECT ON VITAL.KALKULACIJA_CENE TO RESTRICT_ACCESS;
