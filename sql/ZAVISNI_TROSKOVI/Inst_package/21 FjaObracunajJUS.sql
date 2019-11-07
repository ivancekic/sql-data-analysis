Create or replace function Rubin.Obracunaj_JUS(vproizvod      in varchar2,
                                         neto_kg        in number,
                                         proc_vlage     in number,
                                         proc_necistoce in number,
                                         hekt_masa      in number) return number is
  Rezultat         number;
  pravi_proc_vlage number;
  procenat         number;
  prava_hekt_masa  number;
  nacin            number:=0;
begin


  begin
    select posebna_grupa into nacin from proizvod where sifra = vproizvod;
  exception when others then
     nacin := 0;
  end;


  case when nacin = 40 then    -- SUNCOKRET   11% -  min 8%,  3%



/*
--            if nvl(proc_vlage,0) < 8 then               --PROMENJENO JER NIJE TACNO
--               pravi_proc_vlage := 8 ;
--            else
--               pravi_proc_vlage := nvl(proc_vlage,0) ;
--            end if;


            pravi_proc_vlage := nvl(proc_vlage,0) ;


            --procenat := 11 + 3 - pravi_proc_vlage - nvl(proc_necistoce,0);

            procenat := 9 + 2 - pravi_proc_vlage - nvl(proc_necistoce,0);


            Rezultat := nvl(neto_kg,0) * ( 1 + procenat/100  ) ;
*/





            --if nvl(proc_vlage,0) < 8 then               --PROMENJENO JER NIJE TACNO
            --   pravi_proc_vlage := 8 ;
            --else
            --   pravi_proc_vlage := nvl(proc_vlage,0) ;
            --end if;


            pravi_proc_vlage := nvl(proc_vlage,0) ;


            --procenat := 11 + 3 - pravi_proc_vlage - nvl(proc_necistoce,0);

            procenat := 9 + 2 - pravi_proc_vlage - nvl(proc_necistoce,0);


            Rezultat := nvl(neto_kg,0) * ( 1 + procenat/100  ) ;





       when nacin = 41 then    -- SOJA        13% -  min 8%,  2%
            if nvl(proc_vlage,0) < 8 then
               pravi_proc_vlage := 8 ;
            else
               pravi_proc_vlage := nvl(proc_vlage,0) ;
            end if;

            procenat := 13 + 2 - pravi_proc_vlage - nvl(proc_necistoce,0);

            Rezultat := nvl(neto_kg,0) * ( 1 + procenat/100  ) ;
       when nacin  = 39 then    -- PSENICA     13%          ,  2%
            if nvl(hekt_masa,0) > 80 then
               prava_hekt_masa := 80 ;
            else
               prava_hekt_masa := nvl(hekt_masa,0);
            end if;

            procenat := 13 + 2 - nvl(proc_vlage,0) - nvl(proc_necistoce,0);

            Rezultat := nvl(neto_kg,0) * ( 1 + (procenat+ (prava_hekt_masa - 76)*0.5)/100);

       when nacin  = 105 then    -- JEÈAM
            Rezultat := nvl(neto_kg,0);
       else
            Rezultat := 0;
  end case;


  return(round(Rezultat,0));
end Obracunaj_JUS;
/
CREATE PUBLIC SYNONYM Obracunaj_JUS
    FOR RUBIN.Obracunaj_JUS
/
GRANT EXECUTE ON RUBIN.Obracunaj_JUS TO EXE
