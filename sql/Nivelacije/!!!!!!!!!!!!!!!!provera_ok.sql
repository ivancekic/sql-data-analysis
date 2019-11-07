select * from
(
Select d.status, d.broj_dok1,d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo, d.user_id
from dokument d
where godina = &nGod
  and vrsta_Dok = 90
  AND D.ORG_DEO BETWEEN &nOrgOd AND &nOrgDO
  and (d.godina , d.vrsta_Dok, d.broj_dok ) not in (Select godina , vrsta_Dok, broj_dok from vezni_Dok)

union

select d.status, d.broj_dok1,d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo, d.user_id
from dokument d, stavka_dok sd
where d.godina = &nGod
  and d.vrsta_Dok in (11,12,13,31)
  AND D.ORG_DEO BETWEEN &nOrgOd AND &nOrgDO
  and (d.godina , d.vrsta_Dok, d.broj_dok )
       not in (Select godina , vrsta_Dok, broj_dok from vezni_Dok where za_vrsta_dok = 90)
  and sd.godina = d.godina and sd.vrsta_dok = d.vrsta_dok and sd.broj_dok = d.broj_dok
  and sd.cena <> round(sd.cena1*sd.faktor,4)
group by d.status, d.broj_dok1, d.BROJ_DOK, d.VRSTA_DOK, d.GODINA, d.datum_dok, d.datum_unosa , d.org_deo, d.user_id
)
order by status, org_deo, datum_unosa, datum_dok, vrsta_dok
