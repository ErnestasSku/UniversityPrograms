
--+Sukuriamas kambarys
CREATE  TABLE kambarys ( 
	kambario_nr          serial,
	dydis                char(60)  NOT NULL CHECK (dydis IN ('Vienvietis', 'Dvivietis', 'Trivietis', 'Keturvietis')) ,
	tipas                char(60)  NOT NULL CHECK( tipas IN ('Standartinis', 'Liuksas', 'Geresnysis', 'Aukščiausias', 'Prezidentinis', 'Karališkas')) ,
	CONSTRAINT pk_kambarys_kambario_nr PRIMARY KEY ( kambario_nr )
);


--Sukuriamas darbuotojas
CREATE  TABLE darbuotojas ( 
	darbuotojo_id        serial,
	vardas               varchar  NOT NULL ,
	pavarde              varchar  NOT NULL ,
	pareigos             varchar  NOT NULL DEFAULT 'valytojas',
	darbo_laikas         integer CHECK(darbo_laikas BETWEEN 20 AND 40),
	CONSTRAINT pk_darbuotojas_darbuotojo_id PRIMARY KEY ( darbuotojo_id )
 );

--Sukuriamas tvarko lentelė su foreign raktais
CREATE  TABLE tvarko ( 
	darbuotojo_id        integer  NOT NULL ,
	kambario_nr          integer  NOT NULL
	CONSTRAINT pk_tvarko_id PRIMARY KEY (darbuotojo_id, kambario_nr)
 );

ALTER TABLE tvarko ADD CONSTRAINT fk_tvarko_darbuotojas FOREIGN KEY ( darbuotojo_id ) REFERENCES darbuotojas( darbuotojo_id );
ALTER TABLE tvarko ADD CONSTRAINT fk_tvarko_kambarys FOREIGN KEY ( kambario_nr ) REFERENCES kambarys( kambario_nr );


--+Sukuriamas klientas
CREATE  TABLE klientas ( 
	kliento_nr           serial,
	vardas               varchar(100)  NOT NULL ,
	pavarde              varchar(100)  NOT NULL ,
	gimimo_data          date  NOT NULL ,
	korteles_nr			 integer,
	telefono_nr	 		 integer,
	CONSTRAINT pk_klientas_kliento_nr PRIMARY KEY ( kliento_nr )
 );


--+sukuriama kliento_kambariai ir foreign keys
CREATE  TABLE kliento_kambariai ( 
	kambario_nr          integer  CHECK(kambario_nr>0) ,
	kliento_nr           integer  CHECK(kliento_nr>0)
	CONSTRAINT pk_kliento_kambarys PRIMARY KEY (kambario_nr, kliento_nr)
 );

ALTER TABLE kliento_kambariai ADD CONSTRAINT fk_kliento_kambariai_kambarys FOREIGN KEY ( kambario_nr ) REFERENCES kambarys( kambario_nr );

ALTER TABLE kliento_kambariai ADD CONSTRAINT fk_kliento_kambariai_klientas FOREIGN KEY ( kliento_nr ) REFERENCES klientas( kliento_nr );

--Sukuriama rezerviacja
CREATE  TABLE rezervacija ( 
	rezervacijos_nr      serial,
	pradžia              date  NOT NULL ,
	laikotarpis          integer  NOT NULL CHECK(laikotarpis>0) DEFAULT 3,
	rezervuotojas        integer  NOT NULL ,
	CONSTRAINT pk_rezervacija_rezervacijos_nr PRIMARY KEY ( rezervacijos_nr )
 );

ALTER TABLE rezervacija ADD CONSTRAINT fk_rezervacija_klientas FOREIGN KEY ( rezervuotojas ) REFERENCES klientas( kliento_nr );

--Sukuriami mokėjimai ir foreign key
CREATE  TABLE mokejimai ( 
	mokejimo_nr          serial,
	mokejimo_budas       char(30)  NOT NULL CHECK(mokejimo_budas in ('kreditinė kortelė', 'debito kortelė', 'grynieji')) DEFAULT 'grynieji' ,
	suma                 float  NOT NULL CHECK(suma>0),
	korteles_nr			 integer,
	moketojas            integer  NOT NULL ,
	CONSTRAINT pk_mokejimai_mokejimo_nr PRIMARY KEY ( mokejimo_nr )
 );

ALTER TABLE mokejimai ADD CONSTRAINT fk_mokejimai_klientas FOREIGN KEY ( moketojas ) REFERENCES klientas( kliento_nr );


--Views
CREATE MATERIALIZED VIEW laisvi_kambariai(kambario_nr, dydis, tipas) AS 
	WITH uz(nr) AS (
	SELECT kl.kambario_nr
	FROM kliento_kambariai AS kl
	JOIN kambarys AS k on k.kambario_nr = kl.kambario_nr
	)
SELECT kambario_nr, dydis, tipas
FROM kambarys AS k
LEFT JOIN uz AS uz ON uz.nr = k.kambario_nr
where uz.nr IS NULL;

--REFRESH MATERIALIZED VIEW laisvi_kambariai;

CREATE VIEW gyventojai(vardas, pavarde) AS 
	SELECT g.vardas, g.pavarde
	FROM klientas AS g
	JOIN kliento_kambariai AS k ON g.kliento_nr = k.kliento_nr;

CREATE VIEW vip_klientai(vardas, pavarde, kambario_nr) AS 
	SELECT g.vardas, g.pavarde, k.kambario_nr
	FROM klientas AS G
	JOIN kliento_kambariai AS k ON g.kliento_nr = k.kliento_nr
	JOIN kambarys AS a ON a.kambario_nr = k.kambario_nr
	WHERE a.tipas = 'Prezidentinis' OR a.tipas = 'Karališkas';

CREATE VIEW veluojancios_rezervacijos(vardas, pavarde, pradzia) AS
	SELECT k.vardas, k.pavarde, r.pradžia
	FROM klientas AS k
	JOIN rezervacija AS r ON r.rezervuotojas = k.kliento_nr
	WHERE r.pradžia < CURRENT_DATE;

--Indeksai

CREATE UNIQUE INDEX klientas_korteles_nr_idx ON mokejimai(korteles_nr);

CREATE INDEX klientas_vardas_pavarde_idx ON klientas(vardas, pavarde);

CREATE INDEX klientas_vardas_idx ON klientas(vardas);

--Trigeriai

CREATE OR REPLACE FUNCTION MaxDarbuKiekis()
RETURNS TRIGGER 
AS $$
BEGIN
IF( (SELECT COUNT(*) 
	FROM tvarko
	WHERE tvarko.darbuotojo_id=NEW.darbuotojo_id) >= 10
	

	OR 

	(SELECT COUNT(*) 
	FROM tvarko
	JOIN darbuotojas AS d ON d.darbuotojo_id = NEW.darbuotojo_id
	WHERE tvarko.darbuotojo_id=NEW.darbuotojo_id 
		AND d.darbo_laikas >= 25) >= 5
	)

THEN
	RAISE EXCEPTION 'virsytas darbo kiekis';
END IF;
RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER MaxDarbuSkaicius
BEFORE  INSERT OR 
		UPDATE OF darbuotojo_id ON tvarko
FOR EACH ROW 
EXECUTE PROCEDURE MaxDarbuKiekis();


--- Antras trigeris

CREATE OR REPLACE FUNCTION KlientoTaisyklesFunkcija()
RETURNS TRIGGER
AS $$
BEGIN
	IF (
		NEW.kliento_nr IN (SELECT kliento_nr FROM kliento_kambariai)
	)
THEN 
	RAISE EXCEPTION 'Negalima istrinti gyvenancio klienot';
END IF;
RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER KambarioTaisykle
BEFORE DELETE ON klientas
EXECUTE PROCEDURE KlientoTaisyklesFunkcija();

--

--Klientas negali turėti daugiau nei vieno kambario
CREATE OR REPLACE FUNCTION ApsigyvenimoTaisyklesFunkcija()
RETURNS TRIGGER
AS $$
BEGIN 
	IF (
		(SELECT COUNT(k.kambario_nr)
		FROM kliento_kambariai AS k
		WHERE k.kambario_nr = NEW.kambario_nr
		) >= 1
	)
THEN 
	RAISE EXCEPTION 'Kambaryje negali apsigyventi du skirtingi klientai';
END IF;
RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER ApsigyvenimoTaisykle
BEFORE INSERT OR
	   UPDATE OF kambario_nr ON kliento_kambariai
FOR EACH ROW 
EXECUTE PROCEDURE ApsigyvenimoTaisyklesFunkcija();
