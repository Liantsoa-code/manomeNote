CREATE DATABASE manomenote;
\c manomenote;
CREATE TABLE etudiant (id SERIAL PRIMARY KEY, nom VARCHAR(100));
CREATE TABLE professeur (id SERIAL PRIMARY KEY, nom VARCHAR(100));
CREATE TABLE matiere (id SERIAL PRIMARY KEY, nom VARCHAR(100));
CREATE TABLE resolution (id SERIAL PRIMARY KEY, nom VARCHAR(50)); -- Min, Max, Avg
CREATE TABLE comparateur (id SERIAL PRIMARY KEY, symbole VARCHAR(5)); -- <, >
CREATE TABLE note (
    id SERIAL PRIMARY KEY, 
    etudiant_id INT REFERENCES etudiant(id), 
    professeur_id INT REFERENCES professeur(id), 
    matiere_id INT REFERENCES matiere(id), 
    valeur DECIMAL(5,2), 
    date_heure TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE parametre (
    id SERIAL PRIMARY KEY, 
    matiere_id INT REFERENCES matiere(id), 
    comparateur_id INT REFERENCES comparateur(id), 
    resolution_id INT REFERENCES resolution(id), 
    valeur_limite DECIMAL(5,2)
);

-- Vidage des tables (nécessite CASCADE pour les clés étrangères)
TRUNCATE TABLE etudiant, professeur, matiere, note, resolution, comparateur, parametre RESTART IDENTITY CASCADE;

-- 1. Données de configuration (Essentiel pour la logique)
INSERT INTO resolution (nom) VALUES ('Min'), ('Max'), ('Moyenne');
INSERT INTO comparateur (symbole) VALUES ('<'), ('>');

-- 2. Données de test (Étudiants, Matières, Professeurs)
INSERT INTO etudiant (nom) VALUES ('Rakoto'), ('Rabe');
INSERT INTO matiere (nom) VALUES ('Mathématiques'), ('Physique');
INSERT INTO professeur (nom) VALUES ('Prof A'), ('Prof B'), ('Prof C');

-- 3. Configuration des paramètres (Règles métiers)
-- Mathématiques (ID 1) : Si SAD < 2.0 alors Moyenne (ID 3), sinon Min (ID 1)
INSERT INTO parametre (matiere_id, comparateur_id, resolution_id, valeur_limite) VALUES (1, 1, 3, 2.0);
INSERT INTO parametre (matiere_id, comparateur_id, resolution_id, valeur_limite) VALUES (1, 2, 1, 2.0);

-- 4. Insertion des notes réelles
-- Rakoto (ID 1) en Math (ID 1) : 12, 15, 11 (Différences importantes)
INSERT INTO note (etudiant_id, professeur_id, matiere_id, valeur) VALUES 
(1, 1, 1, 12.0), 
(1, 2, 1, 15.0), 
(1, 3, 1, 11.0);

-- Rabe (ID 2) en Physique (ID 2) : 14.0, 14.5, 14.2 (Différences faibles)
INSERT INTO note (etudiant_id, professeur_id, matiere_id, valeur) VALUES 
(2, 1, 2, 14.0), 
(2, 2, 2, 14.5), 
(2, 3, 2, 14.2);
