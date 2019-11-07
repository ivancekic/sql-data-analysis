-- delete deja_pomocna_tab
select rowid, d.* from deja_pomocna_tab d
where polje39 = '40'
  and polje3  in ('1959','SIFRA')
--  and polje40 = 'kolone pal izv'
order by polje40
