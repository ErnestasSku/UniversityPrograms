
SELECT *
FROM stud.knyga;


SELECT * 
FROM stud.egzempliorius;


SELECT *
FROM stud.autorius;


SELECT vardas, pavarde
FROM stud.autorius
WHERE vardas='Jonas' or vardas='Simas';


SELECT DISTINCT vardas
FROM stud.autorius;

SELECT  COUNT(vardas)
FROM stud.autorius;


SELECT COUNT(DISTINCT vardas) AS "Kiekis"
FROM stud.autorius;

SELECT A.pavarde, A.vardas, A.isbn
FROM stud.autorius AS A
ORDER BY 3, 2, 1 DESC;

SELECT EXTRACT(YEAR FROM Gimimas) as metai,
EXTRACT(DAY from Gimimas) as diena
FROM stud.skaitytojas
ORDER BY 2, 1 DESC;

-------
SELECT Vardas, ISBN
FROM stud.Autorius
WHERE Vardas LIKE 'J%' OR Vardas LIKE '%as%';

SELECT stud.Knyga.ISBN, Vardas
FROM stud.Knyga, stud.Autorius


SELECT A.ISBN, B.Vardas, B.Pavarde
FROM stud.Knyga as A, stud.Autorius as B
WHERE A.ISBN = B.ISBN

SELECT A.ISBN, A.Pavadinimas, B.Vardas, B.Pavarde
FROM stud.Knyga as A, stud.Autorius as B
WHERE A.ISBN = B.ISBN


SELECT A.ISBN, A.Pavadinimas, CONCAT (B.Vardas, B.Pavarde) AS "Autorius"
FROM stud.Knyga as A, stud.Autorius as B
WHERE A.ISBN = B.ISBN;



--Pasirinkti autoriu poras kurie dirbo prie tos pacios knygos
SELECT A.Vardas, B.Vardas
FROM stud.Autorius as A, stud.Autorius as B
WHERE A.ISBN = B.ISBN AND A.Vardas <> B.Vardas


SELECT CONCAT (A.Vardas, A.Pavarde) AS "Pirmas autorius", CONCAT (B.Vardas, B.Pavarde) AS "Antras autorius"
FROM stud.Autorius as A, stud.Autorius as B
WHERE A.ISBN = B.ISBN AND CONCAT (A.Vardas, A.Pavarde) <> CONCAT (B.Vardas, B.Pavarde);




SELECT A.Vardas || B.Vardas
FROM stud.Autorius as A, stud.Autorius as B
WHERE A.ISBN = B.ISBN AND A.Vardas <> B.Vardas;

SELECT skait.Nr, skait.Vardas, Skait.Pavarde, egz.isbn
FROM stud.skaitytojas as skait 
JOIN stud.egzempliorius as egz ON skait.Nr = egz.skaitytojas;


--Skaitotojų vardas pavarde, knygos isbn ir pavadinimas

SELECT skait.Nr, skait.Vardas, Skait.Pavarde, egz.isbn, knyg.Pavadinimas
FROM stud.skaitytojas as skait, stud.egzempliorius as egz, stud.knyga as knyg
WHERE skait.nr = egz.skaitytojas AND egz.ISBN = knyg.ISBN;




---- left and right join
SELECT egz.ISBN, egz.Skaitytojas, skait.Vardas, knyg.Pavadinimas
FROM stud.egzempliorius AS egz
LEFT JOIN stud.Skaitytojas AS skait ON egz.Skaitytojas = skait.nr
JOIN stud.Knyga as knyg ON egz.ISBN = knyg.ISBN;


SELECT egz.ISBN, egz.Skaitytojas, skait.Vardas
FROM stud.egzempliorius AS egz
RIGHT JOIN stud.Skaitytojas AS skait
ON egz.Skaitytojas = skait.nr;


SELECT skait.Vardas, skait.Nr, knyg.Pavadinimas
FROM stud.Skaitytojas AS skait
LEFT JOIN stud.Egzempliorius as egz
ON skait.Nr = egz.Skaitytojas;


SELECT CAST (AVG (Knyg.Puslapiai) AS Int), SUM(Knyg.Verte)
FROM stud.knyga as Knyg;


SELECT COUNT(*) AS "skaitytoju kiekis"
FROM stud.Skaitytojas as skait;



SELECT *
FROM stud.Skaitytojas AS skait
WHERE skait.Nr IN (SELECT egz.Skaitytojas
		FROM stud.Egzempliorius AS egz
		WHERE egz.ISBN IN 
			(SELECT knyg.ISBN 
			FROM stud.Knyga AS knyg
			WHERE knyg.Leidykla = 'Raudonoji')
		);

SELECT COUNT(DISTINCT (e.Skaitytojas)) AS "Skaitytoju skaicius"
FROM stud.Egzempliorius as e;

SELECT DISTINCT s.Vardas, s.Pavarde
FROM stud.Skaitytojas AS s
INNER JOIN stud.Egzempliorius AS e ON s.NR = e.Skaitytojas
INNER JOIN stud.Knyga as k ON k.ISBN = e.ISBN
WHERE lower(k.Leidykla) = 'juodoji';

-------------

SELECT egz.ISBN, egz.Skaitytojas, skait.Vardas, knyg.Pavadinimas
FROM stud.egzempliorius AS egz
LEFT JOIN stud.Skaitytojas AS skait ON egz.Skaitytojas = skait.nr
JOIN stud.Knyga as knyg ON egz.ISBN = knyg.ISBN;


SELECT egz.ISBN, egz.Skaitytojas, skait.Vardas
FROM stud.egzempliorius AS egz
RIGHT JOIN stud.Skaitytojas AS skait
ON egz.Skaitytojas = skait.nr;


SELECT skait.Vardas, skait.Nr, knyg.Pavadinimas
FROM stud.Skaitytojas AS skait
LEFT JOIN stud.Egzempliorius as egz
ON skait.Nr = egz.Skaitytojas;

SELECT skait.Vardas, skait.Nr, knyg.Pavadinimas
FROM stud.Skaitytojas AS skait
LEFT JOIN stud.Egzempliorius as egz
ON skait.Nr = egz.Skaitytojas;

SELECT COUNT(a.isbn) AS "knygu skaicius", concat(a.vardas, a.pavarde) AS autorius
FROM stud.autorius AS a
GROUP BY autorius
ORDER BY autorius;

SELECT COUNT(k.isbn) AS "knygu skaicius", k.leidykla
FROM stud.knyga AS k
GROUP BY k.leidykla
ORDER BY 1 DESC;

SELECT ROUND(AVG(k.verte), 2) AS "vidutine verte", k.leidykla
FROM stud.knyga AS k
GROUP BY k.leidykla;

SELECT k.pavadinimas, SUM (puslapiai) AS "Egzemplioriu puslapiai"
FROM stud.knyga AS k, stud.egzempliorius AS e
WHERE e.isbn = k.isbn
GROUP BY k.leidykla, k.pavadinimas;

SELECT pavadinimas, verte,
CASE 
	WHEN verte IS NULL THEN 'Kainos nera'
	ELSE to_char(verte, '99D99')
END AS "null pakeiciamas i teksta"
FROM stud.Knyga;


WITH Vidurkis(vid) AS 
	(SELECT AVG(k.puslapiai) FROM stud.knyga as k)
SELECT a.pavadinimas, a.puslapiai, vid as "puslapiu vidurkis"
FROM stud.Knyga as a, Vidurkis
WHERE a.puslapiai > vid;

WITH temp1 AS 
	(SELECT isbn
	FROM stud.knyga
	WHERE lower(leidykla) = 'juodoji')
SELECT vardas, pavarde
FROM stud.autorius, temp1
WHERE autorius.isbn = temp1.isbn;


WITH Skait(Vardas, Pavarde) AS 
	(SELECT s.vardas, s.pavarde, e.isbn
	FROM stud.skaitytojas AS s
	LEFT JOIN stud.egzempliorius AS e ON e.skaitytojas = s.nr)
SELECT Skait.Vardas, Pavarde, k.Pavadinimas
FROM Skait
INNER JOIN stud.knyga as k ON Skait.isbn = k.isbn;


