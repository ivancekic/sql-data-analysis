-- Package body PPreProdajniProcenat
CREATE OR REPLACE PACKAGE BODY INVEJ.PPreProdajniProcenat Is
   Function Procenat( nOrg_deo Number, dDatum Date ) Return Number Is
      Cursor PPreProdajniProcenat_cursor(  nOrg_deo Number, dDatum Date ) Is
        Select Procenat
          From PreProdajni_Procenat
         Where Org_deo = nOrg_deo
           AND Datum = (Select max( C1.Datum )
                          From PreProdajni_Procenat C1
                         Where C1.Org_deo = nOrg_deo
                           AND C1.Datum <= TO_DATE( TO_CHAR(dDatum,'DD.MM.YYYY')||' 23:59:59','DD.MM.YYYY HH24:MI:SS')
                        );
         nProcenat Number;

   Begin
      Open PPreProdajniProcenat_cursor( nOrg_deo , dDatum ) ;
      Fetch  PPreProdajniProcenat_cursor Into nProcenat;
      If PPreProdajniProcenat_cursor % NOTFOUND Then
         nProcenat := 0;
      End If;
      Close PPreProdajniProcenat_cursor;            

      Return (nProcenat);

   End;

End;


