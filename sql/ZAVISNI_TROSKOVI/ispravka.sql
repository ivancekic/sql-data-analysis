select round( (ROUND(t.SREDNJI * 17.76, 4)

     + ( (select sum(iznos_troska)
          from ZAVISNI_TROSKOVI_STAVKE
          where godina = 2010
            and vrsta_Dok = 3 and broj_dok  = '12424'
          )

         /
          (select sum(kolicina)
           from stavka_dok
           where godina = 2010
             and vrsta_Dok = 3 and broj_dok  = '12424'
          )         )
    ) * 1.02,2) nova_cena1
from KURS t
where to_char(DATUM,'dd.mm.yyyy') = '23.07.2010'
  and val_id = 'EUR'
