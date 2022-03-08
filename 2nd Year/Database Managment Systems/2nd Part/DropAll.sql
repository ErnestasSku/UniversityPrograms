DROP TABLE IF EXISTS kambarys, darbuotojas, tvarko, klientas, kliento_kambariai, rezervacija, mokejimai;
DROP VIEW IF EXISTS  laisvi_kambariai, veluojancios_rezervacijos, gyventojai, vip_klientai;
DROP SEQUENCE IF EXISTS darbuotojas_darbuotojo_id_seq, kambarys_kambario_nr_seq, klientas_kambario_nr_seq, mmokejimai_mokejimo_nr_seq, rezervacija_rezervacijos_nr_seq;

DROP TRIGGER MaxDarbuKiekis ON tvarko;
DROP TRIGGER ApsigyvenimoTaisykle ON kliento_kambariai;