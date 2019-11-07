Declare
 nRbr Number := 0 ;
Begin
  Dbms_output.put_line(lpad('redbr',5)||' '||lpad('vr_d',4)||' '||lpad('broj_dok',8)||' '||lpad('datum_dok',10)||' '||lpad('brd_roba',8));
  Dbms_output.put_line(lpad('-',5,'-')||' '||lpad('-',4,'-')||' '||lpad('-',8,'-')||' '||lpad('-',10,'-')||' '||lpad('-',8,'-'));


  For prijem in
      (Select sd.vrsta_Dok,sd.broj_dok, d.datum_dok, d1.broj_dok d1_brd
       From stavka_dok sd , dokument d, vezni_dok vd , dokument d1--, stavka_dok sd1
Where sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  and vd.godina = d.godina and vd.vrsta_dok = d.vrsta_dok and vd.broj_dok = d.broj_dok
  and vd.za_godina = d1.godina and vd.za_vrsta_dok = d1.vrsta_dok and vd.za_broj_dok = d1.broj_dok
--  and sd1.godina = d1.godina and sd1.vrsta_dok = d1.vrsta_dok and sd1.broj_dok = d1.broj_dok
  -- prijemnice ambalaze
  and d.godina = 2008  and d.vrsta_dok in(3)  and d.tip_dok   = 10  and sd.proizvod in (399)
  and d.datum_dok <= to_date('31.03.2008','dd.mm.yyyy')
  and vd.za_vrsta_Dok = 3
--  and d.broj_dok = 2
Group by sd.vrsta_Dok,sd.broj_dok, d.datum_dok, d1.broj_dok
       Order by d.datum_dok
      )
  Loop
    nRbr := nRbr + 1 ;
--    Dbms_output.put_line(lpad(to_char(nRbr),5)   ||' '||
--                         lpad(prijem.vrsta_dok,4)||' '||
--                         lpad(prijem.broj_dok,8) ||' '||
--                         lpad(to_char(prijem.datum_dok,'dd.mm.yyyy'),10)||' '||
--                         lpad(prijem.d1_brd,8) );
    For amb_roba in ( Select ceil(sum(sd1.kolicina / amb.za_kolicinu)) uk_amb_roba
                     From stavka_dok sd1 , PROIZVOD P , pakovanje pak, ambalaza_za_stampu amb
                     Where SD1.PROIZVOD  = P.SIFRA
                       And pak.proizvod  = P.SIFRA
                       And amb.proizvod  = P.SIFRA
                       And sd1.vrsta_dok = 3
                       And sd1.broj_dok  = prijem.d1_brd
                     Group by sd1.broj_dok
                   )
    Loop
       Dbms_output.put_line(lpad(to_char(nRbr),5)   ||' '||
                            lpad(prijem.vrsta_dok,4)||' '||
                            lpad(prijem.broj_dok,8) ||' '||
                            lpad(to_char(prijem.datum_dok,'dd.mm.yyyy'),10)||' '||
                            lpad(prijem.d1_brd,8)   ||' '||
                            lpad(to_char(amb_roba.uk_amb_roba),5));
    End Loop;
  End Loop;
End;
