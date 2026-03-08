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

-- Insertion des données de base
INSERT INTO resolution (nom) VALUES ('Min'), ('Max'), ('Moyenne');
INSERT INTO comparateur (symbole) VALUES ('<'), ('>');
