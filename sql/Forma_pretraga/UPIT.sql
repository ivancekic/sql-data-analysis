SELECT GODINA , VRSTA_DOK , BROJ_DOK , ORG_DEO , BROJ_DOK  FROM DOKUMENT
WHERE VRSTA_DOK = 3
AND (          
      ORG_DEO IN (Select distinct ID from ORGANIZACIONI_DEO 
                  WHERE ID IN (103,104,106)                
                  OR ( '(Upper(' || Naziv || ') Like Upper(''' || '%SU' || ''') AND ' ||
                       '(' || Naziv || ' Like ''' || 
                          Upper( SubStr( '%SU', 1, 1 ) ) ||
                          Lower( SubStr( '%SU', 2, 1 ) ) || '%'' OR ' ||
                 Naziv || ' Like ''' || 
                          Lower( SubStr( '%SU', 1, 1 ) ) ||
                          Upper( SubStr( '%SU', 2, 1 ) ) || '%'' OR ' ||
                 Naziv || ' Like ''' || 
                          Upper( SubStr( '%SU', 1, 1 ) ) ||
                          Upper( SubStr( '%SU', 2, 1 ) ) || '%'' OR ' ||
                 Naziv || ' Like ''' || 
                          Lower( SubStr( '%SU', 1, 1 ) ) ||
                          Lower( SubStr( '%SU', 2, 1 ) ) || '%''))' )
order by to_number (org_deo)
