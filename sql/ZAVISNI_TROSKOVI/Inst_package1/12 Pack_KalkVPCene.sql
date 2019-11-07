CREATE OR REPLACE PACKAGE INVEJ.KalkulacijaVPCene IS
   Procedure SetParameter( nGod In Number, cBr In VarChar2 ,
                           cVal In VarChar2 := NULL );
   Function Page( nStrana NUMBER ) Return Boolean;
END;
/
CREATE PUBLIC SYNONYM KalkulacijaVPCene
    FOR INVEJ.KALKULACIJANABCENE
/
GRANT EXECUTE ON Invej.KalkulacijaVPCene TO EXE
