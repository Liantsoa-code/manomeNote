-- ==========================================================
-- SCHEMA DE BASE DE DONNÉES - manomeNote (Version Image)
-- ==========================================================

-- 1. Candidat (Anciennement Etudiant)
CREATE TABLE candidat (
    id SERIAL PRIMARY KEY, 
    nom VARCHAR(100)
);

-- 2. Correcteur (Anciennement Professeur)
CREATE TABLE correcteur (
    id SERIAL PRIMARY KEY, 
    nom VARCHAR(100)
);

-- 3. Matiere
CREATE TABLE matiere (
    id SERIAL PRIMARY KEY, 
    libelle VARCHAR(100)
);

-- 4. Resolution
CREATE TABLE resolution (
    id SERIAL PRIMARY KEY, 
    libelle VARCHAR(50) -- Petit, Grand, Moyenne
);

-- 5. Operation (Anciennement Comparateur)
CREATE TABLE operation (
    id SERIAL PRIMARY KEY, 
    signe VARCHAR(5) -- <, <=, >, >=
);

-- 6. Note
CREATE TABLE note (
    id SERIAL PRIMARY KEY, 
    candidat_id INT REFERENCES candidat(id), 
    correcteur_id INT REFERENCES correcteur(id), 
    matiere_id INT REFERENCES matiere(id), 
    valeur DECIMAL(5,2), 
    date_heure TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Parametre
CREATE TABLE parametre (
    id SERIAL PRIMARY KEY, 
    matiere_id INT REFERENCES matiere(id), 
    operation_id INT REFERENCES operation(id), 
    resolution_id INT REFERENCES resolution(id), 
    valeur_limite DECIMAL(5,2)
);
