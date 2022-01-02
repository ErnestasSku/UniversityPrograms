
--3. Kiekvieneriems metams. kuriais buvo išleista bent viena knyga, visų, ir paimtų egzempliorių skaičiai
SELECT metai, Count(*), COUNT(e.paimta)
FROM stud.knyga AS k
LEFT JOIN stud.Egzempliorius AS e ON k.isbn = e.isbn
GROUP BY k.metai
ORDER BY k.metai;




--4. Knygos, kurios visų egzempliorių bendra vertė yra didžiausia, pavadinimas ir visų egzempliorių skaičius.
-- Jei knygos vertė nenurodyta, laikyti, kad ji lygi 10. 


WITH Knyg1(kiekis, suma, isbn) AS
	(SELECT COUNT(k.isbn), SUM(COALESCE(k.verte, 10)) AS suma, k.isbn, k.pavadinimas
	FROM stud.knyga AS k
	JOIN stud.Egzempliorius AS e ON k.isbn = e.isbn
	GROUP BY k.isbn)
SELECT * 
FROM Knyg1
WHERE Knyg1.suma >= ALL(SELECT suma 
			FROM Knyg1);


WITH Knyg1(kiekis, suma, isbn) AS
	(SELECT COUNT(k.isbn), SUM(COALESCE(k.verte, 10)) AS suma, k.isbn, k.pavadinimas
	FROM stud.knyga AS k
	JOIN stud.Egzempliorius AS e ON k.isbn = e.isbn
	GROUP BY k.isbn),
    Did AS
	(SELECT MAX(suma) AS daugiausiai
	FROM Knyg1)
SELECT kiekis, suma, isbn, pavadinimas
FROM Knyg1, Did
WHERE suma = Did.daugiausiai;



--kiekvieniems knygos isleidmo metais, isvesti knyga, kurios egzemplioriu maziausiai
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
ORDER BY kn1.metai;
