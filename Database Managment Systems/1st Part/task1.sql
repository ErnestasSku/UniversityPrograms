-- 1 užklausa
--Visų skaitytojų, kurie yra paėmę bent po vieną egzempliorių, skaičius.
SELECT COUNT(DISTINCT (e.Skaitytojas)) AS "Skaitytoju skaicius"
FROM stud.Egzempliorius as e;


-- 2 užklausa
-- Vardai ir Pavardės visų skaitytojų, kurie skaito konkrečioje leidykloje išleistas knygas.
SELECT s.Vardas, s.Pavarde, k.Pavadinimas
FROM stud.Skaitytojas AS s
RIGHT JOIN stud.Egzempliorius AS e ON s.NR = e.Skaitytojas
INNER JOIN stud.Knyga as k ON k.ISBN = e.ISBN
WHERE lower(k.Leidykla) = 'juodoji'
ORDER BY s.ak;

--
--Skaitytojai kurie nieko neskaito
SELECT s.Vardas, s.Pavarde, e.NR
FROM stud.Skaitytojas AS s
LEFT JOIN stud.Egzempliorius AS e ON s.NR = e.Skaitytojas   
WHERE e.nr IS NULL;

