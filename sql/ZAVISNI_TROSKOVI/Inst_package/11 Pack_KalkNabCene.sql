CREATE OR REPLACE PACKAGE INVEJ.KalkulacijaNABcene IS
   Procedure SetParameter( nGod In Number, cBr In VarChar2 ,
                           cVal In VarChar2 := NULL );
   Function Page( nStrana NUMBER ) Return Boolean;
END;
/
CREATE PUBLIC SYNONYM KALKULACIJANABCENE
    FOR INVEJ.KALKULACIJANABCENE
/
GRANT EXECUTE ON Invej.KALKULACIJANABCENE TO EXE
