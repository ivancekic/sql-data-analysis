-- Package Body PVrstaTroskovaKalk
CREATE OR REPLACE PACKAGE BODY INVEJ.PVrstaTroskovaKalk Is
   -- Funkcija vraca naziv dokumenta za zadatu sifru
   -- ili NULL ako ne postoji dokument za zadatu sifru
   Function Naziv( cVrsta VarChar2 ) Return VarChar2 Is
      -- kursor za izdvajanje Naziva
      Cursor Vrsta_Cursor( cVrsta VarChar2 ) Is
         select naziv
         from ZAVISNI_TROSKOVI_VRSTE
         where VRSTA_TROSKOVA = cVrsta;
           cNaziv VarChar2( 30 );
   Begin
      -- otvori kursor
      Open Vrsta_Cursor( cVrsta );
      -- preuzme naziv , ako postoji
      Fetch Vrsta_cursor Into cNaziv;
      If Vrsta_cursor % NOTFOUND Then  -- ako naziv ne postoji
         cNaziv := NULL;
      End If;
      Close Vrsta_cursor;            -- zatvara kursor
      Return ( cNaziv );
   End;
End;