Select rowid , PROIZVOD.SIFRA, PROIZVOD.NAZIV, substr(naziv,-15) kraj_naziva,
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
