create or replace trigger AZURIRAJ_PROIZVOD_PODACI
  after insert on proizvod  
  for each row
declare
  -- local variables here
begin
  INSERT INTO INVEJ_RAZVOJ.PROIZVOD_PODACI(PROIZVOD,KOL_MIN,KOL_MAX,KOL_OPT,TIP_PROIZVODA,VAZI_OD)
                                    VALUES(:sifra,0,0,999,500,:tip_proizvoda, TRUNC(sysdate));
  COMMIT;
EXCEPTION 
     WHEN OTHERS THEN NULL;                                        
end AZURIRAJ_PROIZVOD_PODACI;
/
