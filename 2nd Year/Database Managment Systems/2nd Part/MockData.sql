--Kambariai
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Vienvietis', 'Standartinis' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Dvivietis', 'Standartinis' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Trivietis', 'Standartinis' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Keturvietis', 'Standartinis' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Vienvietis', 'Liuksas' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Vienvietis', 'Geresnysis' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Vienvietis', 'Aukščiausias' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Vienvietis', 'Prezidentinis' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Vienvietis', 'Karališkas' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Vienvietis', 'Karališkas' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Dvivietis', 'Karališkas' );
INSERT INTO kambarys (dydis, tipas) VALUES ( 'Dvivietis', 'Liuksas' );

--Darbuoptojai
INSERT INTO darbuotojas ( vardas, pavarde, pareigos, darbo_dienos) VALUES ( 'Ona', 'Onaitienė', 'valytoja', 40 );
INSERT INTO darbuotojas ( vardas, pavarde, pareigos, darbo_dienos) VALUES ( 'Petras', 'Petraitis', 'valytojas', 20 );
INSERT INTO darbuotojas ( vardas, pavarde, pareigos, darbo_dienos) VALUES ( 'Jonas', 'Petraitis', 'valytojas', 20 );


--Tvarko
INSERT INTO tvarko VALUES(1,1);
INSERT INTO tvarko VALUES(1,2);
INSERT INTO tvarko VALUES(1,3);
INSERT INTO tvarko VALUES(1,4);
INSERT INTO tvarko VALUES(1,5);
INSERT INTO tvarko VALUES(1,6);
INSERT INTO tvarko VALUES(1,7);
INSERT INTO tvarko VALUES(1,8);
INSERT INTO tvarko VALUES(1,9);
INSERT INTO tvarko VALUES(1,10);
INSERT INTO tvarko VALUES(2,8);
INSERT INTO tvarko VALUES(2,9);
INSERT INTO tvarko VALUES(2,10);

--Klientai
INSERT INTO klientas (vardas, pavarde, gimimo_data) VALUES('Petras', 'Petraitis', '2001-11-02');
INSERT INTO klientas (vardas, pavarde, gimimo_data) VALUES('Janina', 'Petraitienė', '2001-11-20');
INSERT INTO klientas (vardas, pavarde, gimimo_data) VALUES('Algirdas', 'Onušauskas', '1980-7-04');
INSERT INTO klientas (vardas, pavarde, gimimo_data) VALUES('Gabija', 'Onaitytė', '2002-11-05');
INSERT INTO klientas (vardas, pavarde, gimimo_data) VALUES('Tadas', 'Petraitis', '1998-10-02');
INSERT INTO klientas (vardas, pavarde, gimimo_data) VALUES('Franzas', 'Kafka', '1984-07-03');

--kambariai
INSERT INTO kliento_kambariai VALUES(10, 6);
INSERT INTO kliento_kambariai VALUES(8, 5);
INSERT INTO kliento_kambariai VALUES(5, 4);
INSERT INTO kliento_kambariai VALUES(4, 3);
INSERT INTO kliento_kambariai VALUES(1, 2);

--Rezervacija
INSERT INTO rezervacija(pradžia, laikotarpis, rezervuotojas) VALUES ('2022-01-05', 5, 1);
INSERT INTO rezervacija(pradžia, laikotarpis, rezervuotojas) VALUES ('2021-11-25', 2, 1);


--mmokejimai
INSERT INTO mokejimai(mokejimo_budas, suma, korteles_nr, moketojas) VALUES ('grynieji', 155.60, NULL, 1);
INSERT INTO mokejimai(mokejimo_budas, suma, korteles_nr, moketojas) VALUES ('grynieji', 120.15, NULL, 1);
INSERT INTO mokejimai(mokejimo_budas, suma, korteles_nr, moketojas) VALUES ('debito kortelė', 200.50, 50185484, 3);
INSERT INTO mokejimai(mokejimo_budas, suma, korteles_nr, moketojas) VALUES ('kreditinė kortelė', 176.60, 40484958, 2);



