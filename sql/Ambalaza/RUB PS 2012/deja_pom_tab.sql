dECLARE
 cOldBrd varchar2(100);

 Cursor k1 is

  SELECT
    POLJE1
  FROM DEJA_POMOCNA_TAB
  WHERE POLJE79='2000'
    and polje80='AMB STAV'
  order by polje80, decode(polje1,'BRD',polje1,to_number(polje1)) ;

  kk1 k1 % rowtype;
  nBRD nuMBER;
BEGIN
  cOldBrd := NULL;
  nBRD := 0;
  OPEN k1 ;
  DBMS_OUTPUT.PUT_LINE (rpad('Brd',9)||' '||
                        rpad('old Brd',9)||' '||
                        rpad('brojac',9)
                       );
  DBMS_OUTPUT.PUT_LINE (rpad('-',9,'-') ||' '||
                        rpad('-',9,'-') ||' '||
                        rpad('-',9,'-')

                       );
  LOOP
  FETCH k1 INTO kk1 ;
  EXIT WHEN k1 % NOTFOUND ;
      IF NVL(cOldBrd,KK1.POLJE1) != KK1.POLJE1 Then
         nBrd := 1;
      else
         nBRD := nBRD + 1;
      end if;
	  DBMS_OUTPUT.PUT_LINE (
--	   rpad(kk1.polje1,9) ||' '||
--	                            rpad(NVL(cOldBrd,'xx'),9)  ||' '||
	                            nBRD
	                         );

--		  UPDATE DEJA_POMOCNA_TAB
--		  SET POLJE17=nBrd
--		  WHERE POLJE79='2000'
--		    and polje80='AMB STAV'
--		    and polje1=kk1.polje1;
--          COMMIT;

	  cOldBrd := KK1.POLJE1;
  End Loop;
  Close k1;


END;
