-- ==========================================================
-- SCRIPT DE RÉINITIALISATION DES DONNÉES - manomeNote
-- ==========================================================

-- 1. Nettoyage total (vide les tables et remet les compteurs à 1)
TRUNCATE TABLE 
    etudiant, 
    professeur, 
    matiere, 
    note, 
    resolution, 
    comparateur, 
    parametre 
RESTART IDENTITY CASCADE;

-- 2. Insertion des Résolutions (id, nom/Value, ref)
INSERT INTO resolution (nom, ref) VALUES 
('Min', 'Minimum'), 
('Max', 'Maximum'), 
('Moyenne', 'Average');

-- 3. Insertion des Comparateurs (id, symbole/Value, ref)
INSERT INTO comparateur (symbole, ref) VALUES 
('<', 'under'), 
('>', 'above');

-- 4. Insertion des Étudiants
INSERT INTO etudiant (nom) VALUES 
('Rakoto'), 
('Rabe');

-- 5. Insertion des Matières
INSERT INTO matiere (nom) VALUES 
('Mathématiques'), 
('Physique');

-- 6. Insertion des Professeurs
INSERT INTO professeur (nom) VALUES 
('Prof A'), 
('Prof B'), 
('Prof C');

-- 7. Configuration des Paramètres de calcul
-- Math (ID 1) : Si SAD < 2.0 (id 1, limite 2) alors Moyenne (id 3)
INSERT INTO parametre (matiere_id, comparateur_id, resolution_id, valeur_limite) 
VALUES (1, 1, 3, 2.0);

-- Math (ID 1) : Si SAD > 2.0 (id 2, limite 2) alors Min (id 1)
INSERT INTO parametre (matiere_id, comparateur_id, resolution_id, valeur_limite) 
VALUES (1, 2, 1, 2.0);

-- 8. Insertion des Notes de test
-- Rakoto (ID 1) en Math (ID 1)
INSERT INTO note (etudiant_id, professeur_id, matiere_id, valeur) VALUES 
(1, 1, 1, 12.0), 
(1, 2, 1, 15.0), 
(1, 3, 1, 11.0);

-- Rabe (ID 2) en Physique (ID 2)
INSERT INTO note (etudiant_id, professeur_id, matiere_id, valeur) VALUES 
(2, 1, 2, 14.0), 
(2, 2, 2, 14.5), 
(2, 3, 2, 14.2);

-- INFO : Script terminé avec succès.
