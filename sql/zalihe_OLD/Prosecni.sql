select pc.* from prosecni_cenovnik pc
where pc.org_deo in (126,128,129)
and pc.datum_unosa in (select max(datum_unosa) from prosecni_cenovnik
                    where org_deo = pc.org_deo
                      and proizvod = pc.proizvod
                    )
order by pc.proizvod ,pc.org_deo,   pc.datum_unosa
