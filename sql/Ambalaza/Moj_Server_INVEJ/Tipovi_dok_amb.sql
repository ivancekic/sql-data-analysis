sELECT *
FROM NACIN_FAKT
-- u upitima se uzima bez 13 i 14
WHERE TIP IN (13,14,15, 203, 204, 99, 301, 401, 402, 61, 60)
