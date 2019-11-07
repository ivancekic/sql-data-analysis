Begin
For mag in (select distinct org_Deo
            from   stavka_dok_bckp_amb sd , dokument d
            Where sd.godina    (+)= d.godina and sd.vrsta_dok (+)= d.vrsta_dok and sd.broj_dok  (+)= d.broj_dok
              and d.datum_dok <= to_date('31.12.2007','dd.mm.yyyy') and sd.proizvod = '0333901'
              and org_deo not in (135)
              and org_deo not in (select magacin from partner_magacin_flag)
              Order By org_Deo
           )
Loop
   GenerisiStanjeZaliha(mag.org_Deo,sysdate,true);
End Loop;
End;
