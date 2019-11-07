SELECT Sifra, Naziv
FROM Poslovni_Partner
WHERE Sifra LIKE NVL( cPar, '%' ) AND
      Teren = nTeren
ORDER BY Naziv;