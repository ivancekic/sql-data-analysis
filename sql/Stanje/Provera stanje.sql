--Exec generisiStanjeZaliha(68,sysdate,true)
SELECT * FROM
(
  Select 'INVEJ' FIRMA, OD.NAZIV, P.NAZIV P_NAZ, z.ORG_DEO,z.PROIZVOD,z.MIN_KOL,z.MAX_KOL,z.KOL_NAR,z.STANJE,z.REZERVISANA,z.U_KONTROLI,z.OCEKIVANA,z.STANJE_KONTROLNA,z.STANJE-z.REZERVISANA rasp


  From zalihe z, ORGANIZACIONI_DEO OD, PROIZVOD P
  where ( Z.stanje < 0 or Z.stanje < Z.rezervisana ) and org_deo not in (select magacin from partner_magacin_flag)
    and Z.org_deo not between 299 and 517
    AND Z.org_deo = OD.ID AND P.SIFRA = Z.PROIZVOD
--UNION
--  Select 'RUBIN' FIRMA, OD.NAZIV, P.NAZIV P_NAZ, z.ORG_DEO,z.PROIZVOD,z.MIN_KOL,z.MAX_KOL,z.KOL_NAR,z.STANJE,z.REZERVISANA,z.U_KONTROLI,z.OCEKIVANA,z.STANJE_KONTROLNA,z.STANJE-z.REZERVISANA rasp
--  From zalihe@RUBIN z, ORGANIZACIONI_DEO@RUBIN OD, PROIZVOD@RUBIN P
--  where ( Z.stanje < 0 or Z.stanje < Z.rezervisana ) and Z.org_deo not in (select magacin from partner_magacin_flag@RUBIN)
--    AND Z.org_deo = OD.ID AND P.SIFRA = Z.PROIZVOD
--UNION
--  Select 'ALBUS' FIRMA, OD.NAZIV,P.NAZIV P_NAZ, z.ORG_DEO,z.PROIZVOD,z.MIN_KOL,z.MAX_KOL,z.KOL_NAR,z.STANJE,z.REZERVISANA,z.U_KONTROLI,z.OCEKIVANA,z.STANJE_KONTROLNA,z.STANJE-z.REZERVISANA rasp
--  From zalihe@ALBUS z, ORGANIZACIONI_DEO@ALBUS OD, PROIZVOD@ALBUS P
--  where ( Z.stanje < 0 or Z.stanje < Z.rezervisana ) and Z.org_deo not in (select magacin from partner_magacin_flag@ALBUS)
--    AND Z.org_deo = OD.ID AND P.SIFRA = Z.PROIZVOD
--UNION
--  Select 'VITAL' FIRMA, OD.NAZIV,P.NAZIV P_NAZ,z.ORG_DEO,z.PROIZVOD,z.MIN_KOL,z.MAX_KOL,z.KOL_NAR,z.STANJE,z.REZERVISANA,z.U_KONTROLI,z.OCEKIVANA,z.STANJE_KONTROLNA,z.STANJE-z.REZERVISANA rasp
--  From zalihe@VITAL z, ORGANIZACIONI_DEO@VITAL OD, PROIZVOD@VITAL P
--  where ( Z.stanje < 0 or Z.stanje < Z.rezervisana ) and Z.org_deo not in (select magacin from partner_magacin_flag@VITAL)
--    AND Z.org_deo = OD.ID AND P.SIFRA = Z.PROIZVOD
--UNION
--  Select 'MONUS' FIRMA, OD.NAZIV,P.NAZIV P_NAZ,z.ORG_DEO,z.PROIZVOD,z.MIN_KOL,z.MAX_KOL,z.KOL_NAR,z.STANJE,z.REZERVISANA,z.U_KONTROLI,z.OCEKIVANA,z.STANJE_KONTROLNA,z.STANJE-z.REZERVISANA rasp
--  From zalihe@MONUS z, ORGANIZACIONI_DEO@MONUS OD, PROIZVOD@MONUS P
--  where ( Z.stanje < 0 or Z.stanje < Z.rezervisana ) and Z.org_deo not in (select magacin from partner_magacin_flag@MONUS)
--    AND Z.org_deo = OD.ID AND P.SIFRA = Z.PROIZVOD
--UNION
--  Select 'KOSAVA' FIRMA, OD.NAZIV, P.NAZIV P_NAZ, z.ORG_DEO,z.PROIZVOD,z.MIN_KOL,z.MAX_KOL,z.KOL_NAR,z.STANJE,z.REZERVISANA,z.U_KONTROLI,z.OCEKIVANA,z.STANJE_KONTROLNA,z.STANJE-z.REZERVISANA rasp
--  From zalihe@KOSAVA z, ORGANIZACIONI_DEO@KOSAVA OD, PROIZVOD@KOSAVA P
--  where ( Z.stanje < 0 or Z.stanje < Z.rezervisana ) and Z.org_deo not in (select magacin from partner_magacin_flag@KOSAVA)
--    AND Z.org_deo = OD.ID AND P.SIFRA = Z.PROIZVOD
)

ORDER BY FIRMA, org_deo, TO_NUMBER(PROIZVOD)



