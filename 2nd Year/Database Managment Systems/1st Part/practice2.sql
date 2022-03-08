
SELECT COUNT(a.isbn) AS "knygu skaicius", a.vardas, a.pavarde 
FROM stud.autorius AS a
GROUP BY a.vardas, a.pavarde
ORDER BY a.vardas, a.pavarde;

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

WITH KngEgzSkc AS 
	(SELECT Kng.pavadinimas, COUNT(Egz.isbn) AS egzSkc,
		CASE
			WHEN kng.verte IS NULL
				THEN COUNT(Egz.isbn) * 10.00
				ELSE COUNT(Egz.isbn) * Kng.verte
			END AS BendraVerte
	FROM stud.knyga AS kng, stud.egzempliorius AS Egz
	WHERE Kng.isbn = Egz.isbn
	GROUP BY pavadinimas, verte)
SELECT pavadinimas, egzskc
FROM KngEgzSkc
WHERE bendraverte >= ALL (SELECT KngEgzSkc.bendraverte
			FROM KngEgzSkc);

WITH Knyg AS
	(SELECT k.metai 
	FROM stud.knyga AS k
	LEFT JOIN stud.Egzempliorius AS e ON k.isbn = e.isbn)
SELECT COUNT(metai) AS "Visu knygų skaicius", metai
FROM Knyg
GROUP BY Knyg.metai;

WITH Knyg(metai, visos, paimtos) AS
	(SELECT metai, Count(*), COUNT(e.paimta)
	FROM stud.knyga AS k
	LEFT JOIN stud.Egzempliorius AS e ON k.isbn = e.isbn
	GROUP BY k.metai
	ORDER BY k.metai)
SELECT Knyg.visos, Knyg.paimtos, Knyg.metai
FROM Knyg;

WITH Knyg1(kiekis, suma, isbn) AS
	(SELECT COUNT(k.isbn), CASE 
			WHEN verte is NULL THEN 10 * COUNT(k.isbn)
			ELSE SUM(k.verte)
		END AS "suma", k.isbn, k.pavadinimas
	FROM stud.knyga AS k
	LEFT JOIN stud.Egzempliorius AS e ON k.isbn = e.isbn
	GROUP BY k.isbn)
SELECT * 
FROM Knyg1
WHERE Knyg1.suma >= ALL(SELECT suma FROM Knyg1);




WITH AutKnyg(vardpav, kiekis) AS
	(SELECT CONCAT(a.Vardas, a.Pavarde) AS vardpav, COUNT(k.isbn)
	FROM stud.autorius AS a
	LEFT JOIN  stud.Knyga AS k
	ON a.isbn = k.isbn
	GROUP BY vardpav)
SELECT vardpav AS "Vardas ir pavarde", kiekis AS "Knygu kiekis"
FROM AutKnyg AS ak
WHERE ak.kiekis >= ALL (SELECT kiekis 
			FROM AutKnyg);


WITH AutKnyg(vardpav, kiekis) AS
	(SELECT CONCAT(a.Vardas, a.Pavarde) AS vardpav, COUNT(k.isbn) 
	FROM stud.autorius AS a
	LEFT JOIN  stud.Knyga AS k
	ON a.isbn = k.isbn
	GROUP BY vardpav)
SELECT *
FROM AutKnyg AS ak;
WHERE ak.kiekis >= ALL (SELECT kiekis 
			FROM AutKnyg);

WITH AutKnyg(vardpav, kiekis, egzKiekis) AS
	(SELECT CONCAT(a.vardas, a.pavarde) AS vardpav, COUNT(DISTINCT a.ISBN), COUNT (a.isbn)
	FROM stud.autorius as a
	LEFT JOIN stud.egzempliorius AS e ON a.isbn = e.isbn
	GROUP BY vardpav)
SELECT *
FROM AutKnyg as ak
WHERE ak.kiekis >= ALL (SELECT kiekis FROM AutKnyg);


--aabb1122 3 uzkl
WITH skait(skait, paimta, nr) AS
	(SELECT CONCAT(s.Vardas, s.Pavarde) AS skait, e.paimta, s.nr
	FROM stud.skaitytojas AS s
	LEFT JOIN stud.egzempliorius AS e ON e.skaitytojas = s.nr
	GROUP BY skait, e.paimta, s.nr
	ORDER BY e.paimta)
-- SELECT *
SELECT sk.skait, sk.paimta, sk.nr, count (*)
FROM skait as sk
LEFT JOIN stud.egzempliorius  AS e ON e.skaitytojas = sk.nr AND e.paimta <= sk.paimta
GROUP BY sk.skait, sk.paimta, sk.nr, e.nr
ORDER BY sk.paimta;
-- aabb1122 3 uzkl
WITH skait(skait, paimta, nr) AS
	(SELECT CONCAT(s.Vardas, s.Pavarde) AS skait, e.paimta, s.nr
	FROM stud.skaitytojas AS s
	LEFT JOIN stud.egzempliorius AS e ON e.skaitytojas = s.nr
	GROUP BY skait, e.paimta, s.nr
	ORDER BY e.paimta)
----SELECT *
SELECT sk.skait, sk.paimta, sk.nr, CASE
	WHEN sk.paimta IS NULL THEN 0
--	ELSE count (*)
	END AS "Paimtos knygos"
FROM skait as sk
LEFT JOIN stud.egzempliorius  AS e ON e.skaitytojas = sk.nr AND e.paimta <= sk.paimta
GROUP BY sk.skait, sk.paimta, sk.nr
ORDER BY sk.paimta;

WITH Knyg(isbn, kiekis, metai) AS 
	(SELECT k.isbn, COUNT(k.isbn), k.metai
	FROM stud.Knyga AS k
	JOIN stud.Egzempliorius AS e ON e.isbn = k.isbn
	GROUP BY k.isbn)
SELECT Knyg.metai, MIN(Knyg.kiekis) AS maziausiai
FROM Knyg
--LEFT JOIN stud.Knyga AS k ON k.isbn = Knyg.isbn
GROUP BY Knyg.metai;
WHERE maziausiai IN (SELECT Knyg.kiekis
		    FROM Knyg
		    WHERE Knyg.kiekis = maziausiai);
WHERE Knyg.kiekis <= ALL(SELECT kiekis FROM Knyg);

----aaaa0001 3

WITH Skait AS
	(SELECT	EXTRACT(YEAR FROM s.gimimas) AS metai, COUNT( DISTINCT s.gimimas)
	FROM stud.Skaitytojas AS s
	INNER JOIN stud.Egzempliorius AS e ON e.Skaitytojas = s.nr
	GROUP BY metai)

SELECT *
FROM Skait AS sk;


--aaaa0002 3

WITH Knyg AS
	(SELECT k.isbn, k.pavadinimas, k.leidykla, COUNT(*)
	FROM stud.Knyga AS k
	LEFT JOIN stud.Autorius as a ON a.isbn = k.isbn
	GROUP BY k.isbn)
SELECT *
FROM Knyg;

----aaaa0002 4
--
WITH knyg AS
	(SELECT k.leidykla, COUNT(*) AS kiekis
	FROM stud.knyga AS k
	JOIN stud.egzempliorius AS e ON k.isbn = e.isbn
	GROUP BY k.leidykla)
SELECT *
FROM knyg
WHERE knyg.kiekis < ALL(SELECT AVG(kiekis) FROM knyg);

----aaaa0003 3

WITH Knyg AS
	(SELECT k.metai, CONCAT(a.vardas, a.pavarde) AS vardpav, COUNT(k.isbn)
	FROM stud.knyga AS k
	JOIN stud.autorius AS a ON a.isbn = k.isbn
	GROUP BY k.metai, vardpav)
SELECT *
FROM Knyg AS kn;

SELECT k.metai, CONCAT(a.vardas, a.pavarde)  AS vardpav, COUNT(k.isbn)
FROM stud.knyga AS k
JOIN stud.autorius AS a ON a.isbn = k.isbn
GROUP BY k.metai, vardpav;

----aaaa0004 4 (Kartojasi)


kiekvieniems knygos isleidmo metais, isvesti knyga, kurios egzemplioriu maziausiai
WITH Knyg(isbn, kiekis, metai, pavadinimas) AS 
	(SELECT k.isbn, COUNT(k.isbn), k.metai, k.pavadinimas
	FROM stud.Knyga AS k
	JOIN stud.Egzempliorius AS e ON e.isbn = k.isbn
	GROUP BY k.isbn),
   Kn1(metai, kiekis) AS
	(
	SELECT Knyg.metai, MIN(Knyg.kiekis) AS maz 
	FROM Knyg
	GROUP BY Knyg.metai)
SELECT * 
FROM Kn1, Knyg
WHERE Kn1.kiekis = Knyg.kiekis AND Kn1.metai = Knyg.metai
ORDER BY kn1.metai


--aaaaa0003 4

WITH knyg(isbn, kiekis, metai, leidykla) AS 
	(SELECT k.isbn, COUNT(k.isbn), k.metai, k.leidykla
	FROM stud.Knyga AS k
	JOIN stud.Egzempliorius AS e ON e.isbn = k.isbn
	GROUP BY k.isbn),
    vidurkis(vid) AS 
	(SELECT AVG(kiekis)
	FROM knyg)
SELECT k.kiekis, k.leidykla
FROM knyg AS k, vidurkis AS v
WHERE k.kiekis >= v.vid;



WITH knyg(isbn, puslapiai, metai, leidykla) AS 
	(SELECT k.isbn, SUM(puslapiai), k.metai, k.leidykla
	FROM stud.Knyga AS k
	JOIN stud.Egzempliorius AS e ON e.isbn = k.isbn
	GROUP BY k.isbn),
    vidurkis(vid) AS 
	(SELECT AVG(puslapiai)
	FROM knyg)
SELECT *
FROM knyg AS k, vidurkis AS v
WHERE k.puslapiai >= v.vid;


WITH knyg(isbn, puslapiai, metai, leidykla) AS 
	(SELECT k.isbn, SUM(puslapiai), k.metai, k.leidykla
	FROM stud.Knyga AS k
	JOIN stud.Egzempliorius AS e ON e.isbn = k.isbn
	GROUP BY k.isbn),
    vidurkis(maz) AS 
	(SELECT MIN(puslapiai)
	FROM knyg)
SELECT *
FROM knyg AS k, vidurkis AS v
WHERE k.puslapiai = v.maz;
