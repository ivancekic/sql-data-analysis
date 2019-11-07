-- cena1 = (cena-rab+z_tro) * prep_proc)
select
  sd.proizvod, p.naziv, sd.porez

, sd.Kolicina*sd.faktor*sd.K_Robe 																		kol

, sd.cena

, round(nvl(sd.Kolicina*sd.faktor*sd.K_Robe*sd.Cena*(1-sd.Rabat/100) + round(nvl(Z_TROSKOVI,0),2),0),2) nab_vred

, round(
         (
             nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.Cena*(1-sd.Rabat/100),0)
              + round(nvl(sd.Z_Troskovi,0),2)
         )
         / sd.kolicina*sd.faktor*sd.K_Robe
          ,2) 																							nab_cena
          
, round(sd.kolicina*sd.faktor*sd.K_Robe*sd.Cena,2) 														iznos

, round(nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.Cena*(sd.Rabat/100),0),2) 								iznos_rab

, round(nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.Cena*(1-sd.Rabat/100),0),2) 								neto_fakt

, round(nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.Cena*(1-sd.Rabat/100)*(sd.porez/100),0),2) 				fakt_PDV

, round(nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.Cena*(1-sd.Rabat/100),0),2)
  +
  round(nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.Cena*(1-sd.Rabat/100)*(sd.porez/100),0),2)				fakt_vred

, round(nvl(sd.Z_Troskovi,0),2) 																		zav_tro_stavke

, round(nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.cena1,0),2)
  -
  round(nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.Cena*(1-sd.Rabat/100),0),2)
  -
  round(nvl(sd.Z_Troskovi,0),2) 																		razlika_u_ceni

, round(nvl(sd.kolicina*sd.faktor*sd.K_Robe*sd.cena1,0),2)                                              vp_vrednost

, sd.cena1

From stavka_dok sd, dokument d , PROIZVOD P , GRUPA_PR  GPR

Where
  -- veza tabela
      d.godina = sd.godina and d.vrsta_dok = sd.vrsta_dok and d.broj_dok = sd.broj_dok
  AND SD.PROIZVOD = P.SIFRA AND P.GRUPA_PROIZVODA=  GPR.ID
  -----------------------------
  -- ostali uslovi
  and '2011' = d.godina
  and d.vrsta_dok in ('3')
  and d.broj_dok = 1994

order by sd.stavka
