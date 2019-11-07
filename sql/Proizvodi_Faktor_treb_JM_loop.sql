DECLARE
 nRedniBroj Number := 0;
 cNazivKol Varchar2(10);
procedure naslov is
begin
Dbms_output.put_line(lpad('rbr.',4)         ||' '||
                     lpad('proizvod',8)     ||' '||
                     Rpad('naziv',30)       ||' '||
                     Rpad('kraj_naziva',15) ||' '||
                     Rpad('na_mestu',9)     ||' '||
                     Rpad('naz_kol',10)     ||' '||
                     Rpad('fak_treb',9)
                     );
Dbms_output.put_line(Rpad('-',4,'-')  ||' '||
                     Rpad('-',8,'-')  ||' '||
                     Rpad('-',30,'-') ||' '||
                     Rpad('-',15,'-') ||' '||
                     Rpad('-',9,'-')  ||' '||
                     Rpad('-',10,'-')  ||' '||
                     Rpad('-',9,'-'));
end;

BEGIN
naslov;
For provera in (Select rowid , PROIZVOD.SIFRA, PROIZVOD.NAZIV, substr(naziv,-15) kraj_naziva,
                decode ( instr(NAZIV,'0.'),
                               0,decode ( instr(NAZIV,'0,'),
                                                0,decode( instr(NAZIV,'1/1'),
                                                                0,'nema: kroz, tacka , zarez',
                                                          instr(NAZIV,'1/1')||'/zarez'
                                                        ),
                                          instr(NAZIV,'0,')||'/tack'),
                         instr(NAZIV,'0.')||'/kroz'
                       ) na_mestu,
                substr(naziv,
                        decode ( instr(NAZIV,'1/1'),
                                       0,decode ( instr(NAZIV,'0.'),
                                                        0,decode( instr(NAZIV,'0,'),
                                                                        0,'0',
                                                                  instr(NAZIV,'0,')
                                                                ),
                                                  instr(NAZIV,'0.')),
                                 instr(NAZIV,'1/1')
                               )
                      ,4
                      )NAZIV_KOLICINA,
                PROIZVOD.JED_MERE, PROIZVOD.TREBOVNA_JM t_jm, PROIZVOD.FAKTOR_TREBOVNE f_treb
                from proizvod
                where tip_proizvoda = 1
                  and sifra not in ('0','47', 9289 , 10268 , 18071)
                  and upper(naziv) not like upper('%jabuka%')
                  and
                     (    naziv like '%1/1%'
                       or naziv like '%0.%'
                       or naziv like '%0,%'
                )--       or naziv like '%1/%' )
                order by to_number(sifra)
)
Loop
nRedniBroj := nRedniBroj + 1 ;

If ascii(substr(provera.NAZIV_KOLICINA,-1)) < 48 or ascii(substr(provera.NAZIV_KOLICINA,-1)) > 57 Then
   cNazivKol := substr(provera.NAZIV_KOLICINA,1,-1) ;
Else
   cNazivKol := provera.NAZIV_KOLICINA;
End If;

Dbms_output.put_line(lpad(to_char(nRedniBroj),4)            ||' '||
                     lpad(provera.sifra,8)                  ||' '||
                     rpad(provera.naziv,30)                 ||' '||
                     lpad(to_char(provera.kraj_naziva),15)  ||' '||
                     rpad(provera.na_mestu,9)               ||' '||
                     rpad(cNazivKol,10)        ||' '||
                     rpad(ascii(substr(provera.NAZIV_KOLICINA,1)),5) ||' '||
                     lpad(to_char(provera.f_treb,'9990.990'),9)
                     );
--       for kolicina ()
--       Loop
--
--       End loop;
End Loop;
END;
