-- ==========================================================
-- SCRIPT DE RÉINITIALISATION (Version Image)
-- ==========================================================

TRUNCATE TABLE 
    candidat, 
    correcteur, 
    matiere, 
    note, 
    resolution, 
    operation, 
    parametre 
RESTART IDENTITY CASCADE;

-- Insertion des données de l'image
INSERT INTO candidat (nom) VALUES ('Candidat1'), ('Candidat2');
INSERT INTO matiere (libelle) VALUES ('JAVA'), ('PHP');
INSERT INTO correcteur (nom) VALUES ('Correcteur1'), ('Correcteur2'), ('Correcteur3');
INSERT INTO resolution (libelle) VALUES ('Petit'), ('Grand'), ('Moyenne');
INSERT INTO operation (signe) VALUES ('<'), ('<='), ('>'), ('>=');

-- Exemple de paramètre par défaut
INSERT INTO parametre (matiere_id, operation_id, resolution_id, valeur_limite) 
VALUES (1, 1, 3, 2.0); -- JAVA, SAD < 2.0 -> Moyenne

-- Suppression des anciennes tables pour repartir à zéro
DROP TABLE IF EXISTS parametre, note, operation, resolution, matiere, correcteur, candidat CASCADE;

-- Création des nouvelles tables (version Image)
CREATE TABLE candidat (id SERIAL PRIMARY KEY, nom VARCHAR(100));
CREATE TABLE correcteur (id SERIAL PRIMARY KEY, nom VARCHAR(100));
CREATE TABLE matiere (id SERIAL PRIMARY KEY, libelle VARCHAR(100));
CREATE TABLE resolution (id SERIAL PRIMARY KEY, libelle VARCHAR(50));
CREATE TABLE operation (id SERIAL PRIMARY KEY, signe VARCHAR(5));

CREATE TABLE note (
    id SERIAL PRIMARY KEY, 
    candidat_id INT REFERENCES candidat(id), 
    correcteur_id INT REFERENCES correcteur(id), 
    matiere_id INT REFERENCES matiere(id), 
    valeur DECIMAL(5,2), 
    date_heure TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE parametre (
    id SERIAL PRIMARY KEY, 
    matiere_id INT REFERENCES matiere(id), 
    operation_id INT REFERENCES operation(id), 
    resolution_id INT REFERENCES resolution(id), 
    valeur_limite DECIMAL(5,2)
);

INSERT INTO candidat (nom) VALUES ('Candidat1'), ('Candidat2');
INSERT INTO matiere (libelle) VALUES ('JAVA'), ('PHP');
INSERT INTO correcteur (nom) VALUES ('Correcteur1'), ('Correcteur2'), ('Correcteur3');
INSERT INTO resolution (libelle) VALUES ('Petit'), ('Grand'), ('Moyenne');
INSERT INTO operation (signe) VALUES ('<'), ('<='), ('>'), ('>=');

-- Exemple de paramètre (JAVA, SAD < 2.0 -> Moyenne)
INSERT INTO parametre (matiere_id, operation_id, resolution_id, valeur_limite) 
VALUES (1, 1, 3, 2.0);
