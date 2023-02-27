DROP TABLE IF EXISTS programari;
DROP TABLE IF EXISTS repartizare_sali;
DROP TABLE IF EXISTS inventare;
DROP TABLE IF EXISTS livrari;
DROP TABLE IF EXISTS furnizori;
DROP TABLE IF EXISTS echipamente;
DROP TABLE IF EXISTS sali;
DROP TABLE IF EXISTS angajati;
DROP TABLE IF EXISTS joburi;
DROP TABLE IF EXISTS servicii;
DROP TABLE IF EXISTS pacienti;

CREATE TABLE servicii
(
id_serviciu INTEGER,
denumire VARCHAR(50) NOT NULL,
specializare VARCHAR(20) NOT NULL,
pret DOUBLE NOT NULL,
durata INTEGER NOT NULL,

CONSTRAINT PK_SERVICIU PRIMARY KEY (id_serviciu),
CONSTRAINT DENUMIRE_SERV_UQ UNIQUE (denumire),
CONSTRAINT SPECIALIZARE_CK CHECK (specializare IN
('stom_gen', 'ortodontie', 'implantologie', 'estetica', 'endodontie',
'pedodontie', 'protetica', 'chirurgie', 'radiologie', 'profilaxie')),
CONSTRAINT PRET_SERVICIU_CK CHECK (pret > 0),
CONSTRAINT DURATA_CK CHECK (durata > 0 AND durata <= 60)
);


CREATE TABLE pacienti
(
id_pacient INTEGER,
nume VARCHAR(20) NOT NULL,
prenume VARCHAR(20) NOT NULL,
data_nasterii date NOT NULL,
telefon VARCHAR(10) NOT NULL,
email VARCHAR(40) NOT NULL,

CONSTRAINT PK_PACIENT PRIMARY KEY (id_pacient),
CONSTRAINT EMAIL_PACIENT_CK CHECK (email LIKE '%@%.%')
);


CREATE TABLE joburi
(
id_job INTEGER,
titlu VARCHAR(30) NOT NULL,
salariu_min INTEGER NOT NULL,
salariu_max INTEGER NOT NULL,
studii_necesare VARCHAR(20),

CONSTRAINT PK_JOB PRIMARY KEY (id_job),
CONSTRAINT TITLU_JOB_UQ UNIQUE (titlu),
CONSTRAINT STUDII_CK CHECK (studii_necesare IN ('medii', 'superioare')),
CONSTRAINT SALARIU_MAX_CK CHECK (salariu_max >= salariu_min)
);


CREATE TABLE angajati
(
id_angajat INTEGER,
id_job INTEGER NOT NULL,
id_manager INTEGER,
nume VARCHAR(20) NOT NULL,
prenume VARCHAR(20) NOT NULL,
data_nasterii date NOT NULL,
telefon VARCHAR(10) NOT NULL,
email VARCHAR(40) NOT NULL,
salariu DOUBLE NOT NULL,

CONSTRAINT PK_ANGAJAT PRIMARY KEY (id_angajat),
CONSTRAINT FK_JOB_ANGAJAT FOREIGN KEY (id_job) REFERENCES joburi(id_job) ON DELETE CASCADE,
CONSTRAINT FK_MANAGER FOREIGN KEY (id_manager) REFERENCES angajati(id_angajat) ON DELETE SET NULL,
CONSTRAINT TELEFON_ANGAJAT_UQ UNIQUE (telefon),
CONSTRAINT EMAIL_ANGAJAT_UQ UNIQUE (email),
CONSTRAINT EMAIL_ANGAJAT_CK CHECK (email LIKE '%@%.%'),
CONSTRAINT SALARIU_VALID_CK CHECK (salariu > 0)
);


CREATE TABLE sali
(
id_sala INTEGER,
tip VARCHAR(10) NOT NULL,
suprafata DOUBLE NOT NULL,
etaj INTEGER NOT NULL,

CONSTRAINT PK_SALA PRIMARY KEY (id_sala),
CONSTRAINT TIP_CK CHECK (tip IN ('cabinet', 'laborator', 'birou', 'receptie')),
CONSTRAINT SUPRAFATA_CK CHECK (suprafata > 0),
CONSTRAINT ETAJ_CK CHECK (etaj >= 0 AND etaj <= 2)
);


CREATE TABLE furnizori
(
id_furnizor INTEGER,
nume VARCHAR(30) NOT NULL,
telefon VARCHAR(10) NOT NULL,
email VARCHAR(30) NOT NULL,

CONSTRAINT PK_FURNIZOR PRIMARY KEY (id_furnizor),
CONSTRAINT NUME_FURNIZOR_UQ UNIQUE (nume),
CONSTRAINT TELEFON_FURN_UQ UNIQUE (telefon),
CONSTRAINT EMAIL_FURN_UQ UNIQUE (email),
CONSTRAINT EMAIL_FURN_CK CHECK (email LIKE '%@%.%')
);


CREATE TABLE echipamente
(
id_echipament INTEGER,
denumire VARCHAR(50) NOT NULL,
categorie VARCHAR(30) NOT NULL,
pret DOUBLE NOT NULL,

CONSTRAINT PK_ECHIPAMENT PRIMARY KEY (id_echipament),
CONSTRAINT DENUMIRE_ECHIP_UQ UNIQUE (denumire),
CONSTRAINT PRET_ECHIP_CK CHECK (pret > 0)
);


CREATE TABLE livrari
(
id_livrare INTEGER,
id_echipament INTEGER,
id_furnizor INTEGER,
data_livrare date NOT NULL,
cantitate INTEGER NOT NULL,

CONSTRAINT PK_LIVRARE PRIMARY KEY (id_livrare),
CONSTRAINT FK_ECHIP_LIV FOREIGN KEY (id_echipament) REFERENCES echipamente(id_echipament) ON DELETE SET NULL,
CONSTRAINT FK_FURN_LIV FOREIGN KEY (id_furnizor) REFERENCES furnizori(id_furnizor) ON DELETE SET NULL,
CONSTRAINT CANT_LIVRARE_CK CHECK (cantitate > 0)
);


CREATE TABLE inventare
(
id_inventar INTEGER,
id_sala INTEGER,
id_echipament INTEGER,
data_inventar date NOT NULL,
cantitate INTEGER NOT NULL,

CONSTRAINT PK_INVENTAR PRIMARY KEY (id_inventar),
CONSTRAINT FK_SALA_INVENTAR FOREIGN KEY (id_sala) REFERENCES sali(id_sala) ON DELETE SET NULL,
CONSTRAINT FK_ECHIP_INVENTAR FOREIGN KEY (id_echipament) REFERENCES echipamente(id_echipament) ON DELETE SET NULL,
CONSTRAINT CANTITATE_INVENTAR_CK CHECK (cantitate > 0)
);


CREATE TABLE repartizare_sali
(
id_repartizare INTEGER,
id_angajat INTEGER,
id_sala INTEGER NOT NULL,
data_repartizare date NOT NULL,

CONSTRAINT PK_REPARTIZARE PRIMARY KEY (id_repartizare),
CONSTRAINT FK_ANGAJAT_REP FOREIGN KEY (id_angajat) REFERENCES angajati(id_angajat) ON DELETE SET NULL,
CONSTRAINT FK_SALA_REP FOREIGN KEY (id_sala) REFERENCES sali(id_sala) ON DELETE CASCADE,
CONSTRAINT REPARTIZARE_UQ UNIQUE (id_sala, data_repartizare)
);


CREATE TABLE programari
(
id_programare INTEGER,
id_pacient INTEGER,
id_serviciu INTEGER,
id_angajat INTEGER,
data_programare date NOT NULL,
ora INTEGER NOT NULL,

CONSTRAINT PK_PROGRAMARI PRIMARY KEY (id_programare),
CONSTRAINT FK_PACIENT_PROG FOREIGN KEY (id_pacient) REFERENCES pacienti(id_pacient) ON DELETE SET NULL,
CONSTRAINT FK_SERVICIU_PROG FOREIGN KEY (id_serviciu) REFERENCES servicii(id_serviciu) ON DELETE SET NULL,
CONSTRAINT FK_ANGAJAT_PROG FOREIGN KEY (id_angajat) REFERENCES angajati(id_angajat) ON DELETE SET NULL,
CONSTRAINT PROGRAMARE_UQ UNIQUE (id_angajat, data_programare, ora),
CONSTRAINT ORA_PROG_CK CHECK (ora >= 9 AND ora <= 16)
);

-- INSERARI

-- SERVICII
INSERT INTO servicii
VALUES (200, 'obturatie', 'stom_gen', 150, 20);
INSERT INTO servicii
VALUES (201, 'implant dentar', 'implantologie', 3000, 60);
INSERT INTO servicii
VALUES (202, 'albire', 'estetica', 1000, 30);
INSERT INTO servicii
VALUES (203, 'proteza fixa', 'protetica', 5000, 40);
INSERT INTO servicii
VALUES (204, 'detartraj', 'profilaxie', 150, 15);
INSERT INTO servicii
VALUES (205, 'aparat dentar fix', 'ortodontie', 3000, 30);
INSERT INTO servicii
VALUES (206, 'tratament de canal', 'endodontie', 900, 60);
INSERT INTO servicii
VALUES (207, 'consultatie copii', 'pedodontie', 100, 15);
INSERT INTO servicii
VALUES (208, 'radiografie', 'radiologie', 100, 10);
INSERT INTO servicii
VALUES (209, 'extractie molar de minte', 'chirurgie', 500, 30);


-- PACIENTI
INSERT INTO pacienti
VALUES (1000, 'Stanescu', 'Rares', '2005/10/8', '0746211019', 'rares.stanescu@yahoo.com');
INSERT INTO pacienti
VALUES (1001, 'Stoica', 'Monica', '1970/9/24', '0772171807', 'monica.stoica@gmail.com');
INSERT INTO pacienti
VALUES (1002, 'Ene', 'Ana', '2013/4/18', '0757889161', 'aene@gmail.com');
INSERT INTO pacienti
VALUES (1003, 'Vladu', 'Alex', '1984/2/21', '0755135413', 'alex.vladu@yahoo.com');
INSERT INTO pacienti
VALUES (1004, 'Marin', 'Delia', '1999/4/10', '0743654692', 'dmarin@yahoo.com');
INSERT INTO pacienti
VALUES (1005, 'Simion', 'Alexandra', '1978/8/9', '0728212663', 'alexandra.simion@gmail.com');
INSERT INTO pacienti
VALUES (1006, 'Popescu', 'Ioana', '1996/5/3', '0790056823', 'ipopescu@yahoo.com');
INSERT INTO pacienti
VALUES (1007, 'Dumitrache', 'Radu', '2006/12/20', '0772362311', 'rdumitrache@yahoo.com');
INSERT INTO pacienti
VALUES (1008, 'Dumitru', 'Maria', '1975/6/7', '0730267423', 'mdumitru@gmail.com');
INSERT INTO pacienti
VALUES (1009, 'Ionescu', 'Petru', '2004/5/20', '0747272573', 'pionescu@yahoo.com');
INSERT INTO pacienti
VALUES (1010, 'Popovici', 'Gigel', '2008/11/20', '0775777709', 'gpopovici@gmail.com');
INSERT INTO pacienti
VALUES (1011, 'Albu', 'Robert', '1970/11/3', '0798743468', 'ralbu@gmail.com');
INSERT INTO pacienti
VALUES (1012, 'Rotaru', 'Cosmina', '2009/5/12', '0775011076', 'crotaru@gmail.com');
INSERT INTO pacienti
VALUES (1013, 'Mihai', 'Ionel', '2009/11/19', '0773000484', 'ionel.mihai@yahoo.com');
INSERT INTO pacienti
VALUES (1014, 'Teodorescu', 'Silviu', '2001/5/8', '0723499352', 'steodorescu@gmail.com');
INSERT INTO pacienti
VALUES (1015, 'Sava', 'Larisa', '2000/10/8', '0787043170', 'larisa.sava@gmail.com');


-- JOBURI
INSERT INTO joburi
VALUES (10, 'CEO', 8000, 10000, 'superioare');
INSERT INTO joburi
VALUES (11, 'manager', 7000, 9000, 'superioare');
INSERT INTO joburi
VALUES (12, 'medic stom generala', 4500, 6000, 'superioare');
INSERT INTO joburi
VALUES (13, 'medic ortodontie', 5000, 7000, 'superioare');
INSERT INTO joburi
VALUES (14, 'medic implantologie', 7000, 9000, 'superioare');
INSERT INTO joburi
VALUES (15, 'medic estetica', 5500, 7000, 'superioare');
INSERT INTO joburi
VALUES (16, 'medic pedodontie', 5000, 7000, 'superioare');
INSERT INTO joburi
VALUES (17, 'medic protetica', 6000, 8000, 'superioare');
INSERT INTO joburi
VALUES (18, 'medic chirurgie', 7000, 9000, 'superioare');
INSERT INTO joburi
VALUES (19, 'medic profilaxie', 5500, 8000, 'superioare');
INSERT INTO joburi
VALUES (20, 'radiolog', 4000, 5000, 'superioare');
INSERT INTO joburi
VALUES (21, 'tehnician dentar', 4000, 5000, 'superioare');
INSERT INTO joburi
VALUES (22, 'asistent', 4000, 5000, 'medii');
INSERT INTO joburi
VALUES (23, 'receptioner', 3000, 4000, 'medii');


-- ANGAJATI
INSERT INTO angajati
VALUES (100, 10, null, 'Stoica', 'Alex', '1974/6/18', '0734029494', 'astoica@gmail.com', 8300);
INSERT INTO angajati
VALUES (101, 11, 100, 'Munteanu', 'Ionela', '1980/10/14', '0768902436', 'munteanu_ionela@gmail.com', 7000);
INSERT INTO angajati
VALUES (102, 11, 100, 'Sava', 'Delia', '1981/6/21', '0767930880', 'delia.sava@gmail.com', 8900);
INSERT INTO angajati
VALUES (103, 11, 100, 'Moraru', 'Catinca', '1990/12/17', '0738192157', 'moraru_catinca@gmail.com', 8700);
INSERT INTO angajati
VALUES (104, 15, 101, 'Ionescu', 'Iulia', '1976/12/17', '0712343818', 'ionescu_iulia@yahoo.com', 6400);
INSERT INTO angajati
VALUES (105, 12, 102, 'Albu', 'Monica', '1978/11/12', '0726410305', 'malbu@yahoo.com', 7000);
INSERT INTO angajati
VALUES (106, 19, 101, 'Anton', 'Maria', '1976/5/21', '0788769574', 'maria.anton@gmail.com', 7500);
INSERT INTO angajati
VALUES (107, 13, 101, 'Ene', 'Virgil', '1989/9/1', '0747254744', 'vene@yahoo.com', 6000);
INSERT INTO angajati
VALUES (108, 16, 102, 'Iacob', 'Larisa', '1976/6/28', '0763973708', 'larisa.iacob@gmail.com', 6400);
INSERT INTO angajati
VALUES (109, 20, 101, 'Popa', 'Ioana', '1983/6/26', '0734760981', 'ioana.popa@gmail.com', 4500);
INSERT INTO angajati
VALUES (110, 22, 102, 'Stanescu', 'Mihai', '1990/12/8', '0779690556', 'mstanescu@yahoo.com', 4200);
INSERT INTO angajati
VALUES (111, 13, 103, 'Alexandrescu', 'Ionel', '1988/5/9', '0750939134', 'ionel.alexandrescu@gmail.com', 5400);
INSERT INTO angajati
VALUES (112, 20, 101, 'Dumitrache', 'Dan', '1979/9/28', '0731264176', 'dan.dumitrache@gmail.com', 4600);
INSERT INTO angajati
VALUES (113, 14, 102, 'Teodorescu', 'Costel', '1983/3/26', '0715731666', 'cteodorescu@yahoo.com', 7300);
INSERT INTO angajati
VALUES (114, 23, 101, 'Cazacu', 'Daria', '1972/9/18', '0778585466', 'cazacu_daria@yahoo.com', 7400);
INSERT INTO angajati
VALUES (115, 21, 103, 'Iorga', 'Diana', '1972/11/25', '0700556374', 'diana.iorga@gmail.com', 4300);
INSERT INTO angajati
VALUES (116, 17, 103, 'Paun', 'Robert', '1972/9/7', '0772463896', 'robert.paun@yahoo.com', 7400);
INSERT INTO angajati
VALUES (117, 22, 102, 'Petre', 'Clara', '1990/4/22', '0738464128', 'petre_clara@gmail.com', 5600);
INSERT INTO angajati
VALUES (118, 14, 101, 'Stan', 'Cosmina', '1983/12/22', '0789816799', 'cstan@gmail.com', 7200);
INSERT INTO angajati
VALUES (119, 18, 103, 'Nastase', 'Bogdan', '1983/9/1', '0792769367', 'bnastase@gmail.com', 7700);
INSERT INTO angajati
VALUES (120, 16, 101, 'Popovici', 'Vlad', '1988/4/19', '0712397463', 'popovici_vlad@yahoo.com', 5500);


-- SALI
INSERT INTO sali
VALUES (1, 'cabinet', 40, 0);
INSERT INTO sali
VALUES (2, 'cabinet', 20, 0);
INSERT INTO sali
VALUES (3, 'cabinet', 40, 0);
INSERT INTO sali
VALUES (4, 'cabinet', 20, 1);
INSERT INTO sali
VALUES (5, 'cabinet', 30, 1);
INSERT INTO sali
VALUES (6, 'cabinet', 30, 1);
INSERT INTO sali
VALUES (7, 'receptie', 45, 0);
INSERT INTO sali
VALUES (8, 'receptie', 25, 0);
INSERT INTO sali
VALUES (9, 'birou', 30, 1);
INSERT INTO sali
VALUES (10, 'birou', 30, 1);
INSERT INTO sali
VALUES (11, 'laborator', 30, 1);


-- ECHIPAMENTE
INSERT INTO echipamente
VALUES (50, 'autoclava','sterilizare', 50);
INSERT INTO echipamente
VALUES (51, 'lampa albire', 'echipament albire', 10000);
INSERT INTO echipamente
VALUES (52, 'compozit fotopolimerizabil', 'consumabile',  350);
INSERT INTO echipamente
VALUES (53, 'cleste extractie', 'instrumentar chirurgie', 170);
INSERT INTO echipamente
VALUES (54, 'seringa', 'instrumentar chirurgie', 80);
INSERT INTO echipamente
VALUES (55, 'pachet 5 freze', 'instrumentar', 250);
INSERT INTO echipamente
VALUES (56, 'adeziv coroane', 'consumabile', 40);
INSERT INTO echipamente
VALUES (57, 'folie diga', 'consumabile',  55);


-- FURNIZORI
INSERT INTO furnizori
VALUES (20, 'DoriotDent', '0222310508', 'office@doriotdent.ro');
INSERT INTO furnizori
VALUES (21, 'DentStore', '0216025201', 'office@dentstore.ro');
INSERT INTO furnizori
VALUES (22, 'HeliosDental', '0229222792', 'office@heliosdental.ro');
INSERT INTO furnizori
VALUES (23, 'Medident', '0218608619', 'office@medident.ro');
INSERT INTO furnizori
VALUES (24, 'TerraDent', '0295887001', 'office@terradent.ro');


-- PROGRAMARI
INSERT INTO programari
VALUES (1, 1003, 200, 105, '2021-12-23', 13);
INSERT INTO programari
VALUES (2, 1007, 207, 108, '2021-11-11', 16);
INSERT INTO programari
VALUES (3, 1011, 201, 118, '2021-12-15', 9);
INSERT INTO programari
VALUES (4, 1014, 202, 104, '2021-10-29', 11);
INSERT INTO programari
VALUES (5, 1005, 200, 105, '2021-12-23', 10);
INSERT INTO programari
VALUES (6, 1005, 209, 119, '2021-08-08', 14);


-- REPARTIZARE SALI
INSERT INTO repartizare_sali
VALUES (10, 105, 1, '2021-12-23');
INSERT INTO repartizare_sali
VALUES (11, 117, 1, '2021-08-10');
INSERT INTO repartizare_sali
VALUES (12, 110, 1, '2021-12-20');
INSERT INTO repartizare_sali
VALUES (13, 118, 2, '2021-12-15');
INSERT INTO repartizare_sali
VALUES (14, 104, 3, '2021-10-29');
INSERT INTO repartizare_sali
VALUES (15, 119, 4, '2021-10-09');
INSERT INTO repartizare_sali
VALUES (16, 117, 2, '2021-12-17');
INSERT INTO repartizare_sali
VALUES (17, 110, 4, '2021-08-09');
INSERT INTO repartizare_sali
VALUES (18, 108, 3, '2021-11-11');

-- INVENTARE
INSERT INTO inventare
VALUES (10, 1, 50, '2021-12-23', 1);
INSERT INTO inventare
VALUES (11, 2, 51, '2021-11-30', 1);
INSERT INTO inventare
VALUES (12, 4, 55, '2021-10-01', 3);
INSERT INTO inventare
VALUES (13, 3, 57, '2021-08-05', 20);
INSERT INTO inventare
VALUES (14, 5, 53, '2021-11-15', 2);


-- LIVRARI
INSERT INTO livrari
VALUES (10, 53, 20, '2021-08-03', 10);
INSERT INTO livrari
VALUES (11, 53, 21, '2021-10-02', 8);
INSERT INTO livrari
VALUES (12, 50, 21, '2021-05-05', 2);
INSERT INTO livrari
VALUES (13, 52, 23, '2021-10-10', 5);
INSERT INTO livrari
VALUES (14, 57, 23, '2021-12-02', 15);
INSERT INTO livrari
VALUES (15, 54, 24, '2021-11-15', 20);

COMMIT;