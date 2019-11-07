Select * from zalihe
where org_deo in ( select distinct org_Deo
                   from   stavka_dok_bckp_amb sd , dokument d , PROIZVOD P , GRUPA_PR  GPR
                   Where sd.godina    (+)= d.godina  and sd.vrsta_dok (+)= d.vrsta_dok  and sd.broj_dok  (+)= d.broj_dok
                     AND SD.PROIZVOD = P.SIFRA  AND P.GRUPA_PROIZVODA=  GPR.ID
                     and d.datum_dok <= to_date('31.12.2007','dd.mm.yyyy') and sd.proizvod = '0333901'
                     and org_deo not in (135) and org_deo not in (select magacin from partner_magacin_flag)
                 )
                 and proizvod = '0333901'
Order By org_Deo
