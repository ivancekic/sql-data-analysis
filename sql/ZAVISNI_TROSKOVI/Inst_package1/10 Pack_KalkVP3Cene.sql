CREATE OR REPLACE PACKAGE INVEJ.KalkulacijaVP3Cene IS
   Procedure SetParameter( nGod In Number, cBr In VarChar2 ,
                           cVal In VarChar2 := NULL );
   Function Page( nStrana NUMBER ) Return Boolean;
END;
/
CREATE PUBLIC SYNONYM KALKULACIJAVP3CENE
    FOR INVEJ.KALKULACIJAVP3CENE
/
GRANT EXECUTE ON Invej.KALKULACIJAVP3CENE TO EXE
