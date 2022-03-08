



SELECT CONCAT(t.table_schema, t.table_name), COALESCE(MAX(c.character_maximum_length), 0)
FROM information_schema.tables AS t
JOIN information_schema.columns AS c ON c.table_name = t.table_name AND c.table_schema = t.table_schema
GROUP BY CONCAT(t.table_schema, t.table_name);


SELECT t.table_name, MAX(c.character_maximum_length)
FROM information_schema.tables AS t
JOIN information_schema.columns AS c ON c.table_name = t.table_name
WHERE t.table_schema = 'stud'
GROUP BY t.table_name;
