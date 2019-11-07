SELECT   O_DAT,
              O_DAT_UN,
              O_GOD,
              O_VRD,
              O_BRD,
              O_TIP,
              O_PRT,
              O_MAG,
              O_BRD1,
              O_ST,
              k.DATUM_DOK k_dat,
              k.datum_unosa k_dat_un,
              K_GOD,
              K_VRD,
              K_BRD,
              k.tip_dok k_tip,
              k.ppartner k_prt,
              k.org_Deo k_prodavnica,
              k.broj_Dok1 k_brd1,
              k.status k_st
       FROM   (SELECT   O.DATUM_DOK o_dat,
                        o.datum_unosa o_dat_un,
                        o.GODINA o_god,
                        o.vrsta_dok o_vrd,
                        o.broj_dok o_brd,
                        o.tip_dok o_tip,
                        o.ppartner o_prt,
                        o.org_Deo o_mag,
                        o.broj_Dok1 o_brd1,
                        o.status o_st,
                        VD.ZA_GODINA k_god,
                        VD.ZA_VRSTA_DOK k_vrd,
                        VD.ZA_BROJ_DOK k_brd
                 FROM   dokument o,
                        (SELECT   *
                           FROM   vezni_Dok
                          WHERE   vrsta_dok IN ('11', '12', '13', '31')
                                  AND za_vrsta_dok = '89') vd
                WHERE       o.godina = 2013
                        AND o.vrsta_dok IN ('11', '12', '13', '31')
                        AND o.tip_dok IN (231, 431)
                        AND o.godina = vd.godina(+)
                        AND o.vrsta_dok = vd.vrsta_dok(+)
                        AND o.broj_dok = vd.broj_dok(+) --    and o.status > 0
                                                  --and VD.ZA_BROJ_DOK is null
              ) o,
              dokument k
      WHERE       k.godina(+) = K_GOD
              AND k.vrsta_dok(+) = K_VRD
              AND k.broj_dok(+) = K_BRD
   ORDER BY   o_DAT, o_dat_un

