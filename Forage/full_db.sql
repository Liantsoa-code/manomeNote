-- NOUVELLE BASE DE DONNEES FORAGE
DROP TABLE IF EXISTS detail_devis CASCADE;
DROP TABLE IF EXISTS devis CASCADE;
DROP TABLE IF EXISTS type_devis CASCADE;
DROP TABLE IF EXISTS status_demande CASCADE;
DROP TABLE IF EXISTS statut CASCADE;
DROP TABLE IF EXISTS demande CASCADE;
DROP TABLE IF EXISTS lieu CASCADE;
DROP TABLE IF EXISTS district CASCADE;
DROP TABLE IF EXISTS client CASCADE;


CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    telephone VARCHAR(50)
);


CREATE TABLE district (
    id SERIAL PRIMARY KEY,
    nom_district VARCHAR(255) NOT NULL
);


CREATE TABLE lieu (
    id SERIAL PRIMARY KEY,
    id_district INTEGER REFERENCES district(id) ON DELETE CASCADE,
    adresse TEXT,
    nom_lieu VARCHAR(255) NOT NULL
);


CREATE TABLE demande (
    id SERIAL PRIMARY KEY,
    id_client INTEGER REFERENCES client(id) ON DELETE CASCADE,
    id_lieu INTEGER REFERENCES lieu(id) ON DELETE CASCADE,
    date_demande DATE DEFAULT CURRENT_DATE
);


CREATE TABLE statut (
    id SERIAL PRIMARY KEY,
    nom_statut VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE status_demande (
    id SERIAL PRIMARY KEY,
    id_demande INTEGER REFERENCES demande(id) ON DELETE CASCADE,
    id_statut INTEGER REFERENCES statut(id) ON DELETE CASCADE,
    date_statut TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observation TEXT
);


CREATE TABLE type_devis (
    id SERIAL PRIMARY KEY,
    nom_type_devis VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE devis (
    id SERIAL PRIMARY KEY,
    id_demande INTEGER REFERENCES demande(id) ON DELETE CASCADE,
    id_type_devis INTEGER REFERENCES type_devis(id) ON DELETE CASCADE,
    date_devis DATE DEFAULT CURRENT_DATE
);


CREATE TABLE detail_devis (
    id SERIAL PRIMARY KEY,
    id_devis INTEGER REFERENCES devis(id) ON DELETE CASCADE,
    libelle VARCHAR(255),
    prix_unitaire DECIMAL(15, 2) NOT NULL,
    quantite DECIMAL(15, 2) NOT NULL
);

INSERT INTO statut (nom_statut) VALUES 
('demande_cree'), 
('devis_etude_propose'), 
('devis_forage_proposer'),
('devis_forage en cours'),
('devis_etude en cours'),
('devis_foragerefusé'),
('devis_etude_refusé'),
('devis_forage terminé'),
('devis etude terminer');
-- ('en_attente')

INSERT INTO type_devis (nom_type_devis) VALUES 
('Devis Analyse'), 
('Devis Forage');

INSERT INTO district (nom_district) VALUES ('Analamanga'), ('Vakinankaratra');
INSERT INTO lieu (id_district, nom_lieu, adresse) VALUES (1, 'Antananarivo', 'Analakely');
INSERT INTO client (nom, telephone) VALUES ('Jean Dupont', '034 00 000 00');


SELECT SUM(
    CASE 
        WHEN prix_unitaire >= 1000000 THEN (prix_unitaire * 0.9) * quantite
        ELSE prix_unitaire * quantite
    END
) AS chiffre_affaire_previsionnel
FROM detail_devis;
