
SELECT *
FROM information_schema.tables;


SELECT *
FROM information_schema.columns;

SELECT *
FROM information_schema.triggers;

SELECT * 
FROM information_schema.views;

SELECT Column_Name, Data_Type, Table_Schema
FROM Information_Schema.Columns
WHERE Table_Schema = 'information_schema' AND Table_Name = 'tables';

SELECT t.table_name, MAX(c.character_maximum_length)
FROM information_schema.tables AS t
JOIN information_schema.columns AS c ON c.table_name = t.table_name
WHERE t.table_schema = 'stud'
GROUP BY t.table_name;

SELECT t.table_name, COALESCE(MAX(c.character_maximum_length), 0)
FROM information_schema.tables AS t
JOIN information_schema.columns AS c ON c.table_name = t.table_name
GROUP BY t.table_name;

--Kiekvienam stulpelio tipui skaičius lentelių, turinčių bent vieną tokio tipi stulpelį.
SELECT Data_Type, COUNT(DISTINCT Table_Schema || Table_name) AS sk
FROM information_schema.Columns
GROUP BY Data_Type;
--
--
--Kiekvienam stulpelio tipui, skaičius lentelių neturinčių nė vieno tokio tipo stulpelių skaičius.
--SELECT Data_Type, COUNT(*) 
SELECT Data_Type, COUNT(DISTINCT Table_name) AS sk
FROM information_schema.Columns
GROUP BY Data_Type;

SELECT COUNT(*)
FROM information_schema.tables;

SELECT Data_Type, COUNT(DISTINCT c.Table_name) AS sk, COUNT(*)
FROM information_schema.Columns AS c
JOIN information_schema.tables AS t ON t.table_name = c.table_name
GROUP BY Data_Type;


----
SELECT Data_Type, COUNT(*) 
FROM information_schema.Columns
GROUP BY Data_Type;

SELECT v.table_name, COUNT(DISTINCT c.data_type)
FROM information_schema.views AS v
LEFT JOIN information_schema.columns AS c ON v.table_name = c.table_name
GROUP BY v.table_name;

SELECT *
FROM information_schema.table_privileges
WHERE grantee = '..';


SELECT *
FROM information_schema.table_privileges
WHERE lower(grantee) = 'public';

SELECT p.grantee, COUNT(*)
FROM information_schema.table_privileges AS p
JOIN information_schema.tables AS t ON p.table_name = t.table_name
WHERE lower(t.table_type) = 'view'
GROUP BY p.grantee;

SELECT COUNT(table_name) 
FROM information_schema.tables
WHERE table_name NOT IN (SELECT table_name FROM information_schema.key_column_usage WHERE constraint_name LIKE 'i%');



SELECT COUNT(table_name)
FROM information_schema.tables
WHERE table_name NOT IN (SELECT table_name FROM information_schema.key_column_usage WHERE constraint_name NOT LIKE 'i%');


SELECT t.table_name, COUNT(k.constraint_name) AS kiekis 
FROM information_schema.tables AS t
JOIN information_schema.key_column_usage AS k ON k.table_name = t.table_name AND k.table_schema = t.table_schema
WHERE k.table_schema = 'stud'
--WHERE k.constraint_name LIKE 'i%' AND k.table_schema = 'stud' 
GROUP BY t.table_schema, t.table_name;


SELECT t.table_name, COUNT(*)
FROM information_schema.tables AS t
JOIN information_schema.key_column_usage AS k ON k.table_name = t.table_name
WHERE k.constraint_name LIKE 'i%'
GROUP BY t.table_name
HAVING COUNT(*) > 1;


SELECT *
FROM information_schema.triggers;

SELECT Table_Name, COUNT(table_schema)
FROM information_schema.tables
GROUP BY table_name;

SELECT *
FROM information_schema.attributes;

SELECT * FROM information_schema.applicable_roles;

SELECT * FROM information_schema.collations;a

SELECT * FROM information_schema.domains;

SELECT COUNT(*)
FROM information_schema.columns AS c
JOIN information_schema.table_privileges AS p ON c.table_name = p.table_name
WHERE p.grantee = '...';
