Select Z.ORG_DEO,porganizacionideo.naziv(Z.org_deo) naziv , Z.proizvod proizv_invej ,
       (SELECT UL06
        FROM MAPIRANJE M
        WHERE M.firma = 'INVEJ'
          AND M.MODUL = 'MAGACIN'
          AND M.UL02 = 'ZA_LINK'
          AND M.UL03 = Z.ORG_DEO ) POSLOVNI_P,
       (SELECT nabavna_sifra
        FROM katalog k
        WHERE k.dobavljac = (SELECT UL06
                             FROM MAPIRANJE M
                             WHERE M.firma = 'INVEJ'
                               AND M.MODUL = 'MAGACIN'
                               AND M.UL02 = 'ZA_LINK'
                               AND M.UL03 = Z.ORG_DEO
                             )
          And proizvod = z.proizvod
        ) dob_sifra ,
        pproizvod.naziv(Z.proizvod) naziv ,
        (select prodajna_jm from proizvod where sifra = z.proizvod ) prod_jm , 'xxx' fab_prod_jm ,
        Z.stanje * ( select faktor_prodajne from proizvod where sifra = z.proizvod ) stanje_prod_jm ,
        Z.rezervisana * ( select faktor_prodajne from proizvod where sifra = z.proizvod ) rezer_prod_jm,
        ( Z.stanje-Z.rezervisana ) * ( select faktor_prodajne from proizvod where sifra = z.proizvod ) rasp_prod_jm

from zalihe z --, MAPIRANJE m
--     KATALOG K
Where Z.ORG_DEO   = 104
  And Z.org_deo not in (select magacin from partner_magacin_flag)
  And Z.org_Deo in (select distinct org_deo from ORG_DEO_OSN_PODACI )
---  And
--  AND Z.ORG_DEO   = M.UL03
--  and m.firma     = 'INVEJ' AND M.MODUL = 'MAGACIN' AND UL02 = 'ZA_LINK'

order by org_deo
