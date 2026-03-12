-- ==========================================================
-- SCRIPT DE DONNÉES FINALES - manomeNote (Version Image 2)
-- ==========================================================

-- 1. Nettoyage complet
TRUNCATE TABLE candidat, correcteur, matiere, note, resolution, operation, parametre RESTART IDENTITY CASCADE;

-- 2. Données de base (Statiques selon l'image)
INSERT INTO candidat (nom) VALUES ('Candidat1'), ('Candidat2');
INSERT INTO matiere (libelle) VALUES ('JAVA'), ('PHP');
INSERT INTO correcteur (nom) VALUES ('Correcteur1'), ('Correcteur2'), ('Correcteur3');
INSERT INTO resolution (libelle) VALUES ('Petit'), ('Grand'), ('Moyenne');
INSERT INTO operation (signe) VALUES ('<'), ('<='), ('>'), ('>=');

-- 3. PARAMÈTRES (Image : Tableau de Gauche)
-- JAVA (ID 1)
INSERT INTO parametre (matiere_id, operation_id, resolution_id, valeur_limite) VALUES 
(1, 1, 2, 3.0), -- JAVA, Écart < 3.0 -> Grand
(1, 4, 3, 3.0); -- JAVA, Écart >= 3.0 -> Moyenne

-- PHP (ID 2)
INSERT INTO parametre (matiere_id, operation_id, resolution_id, valeur_limite) VALUES 
(2, 2, 1, 2.0), -- PHP, Écart <= 2.0 -> Petit
(2, 3, 2, 2.0); -- PHP, Écart > 2.0 -> Grand

-- 4. NOTES (Image : Tableau de Droite)
-- Candidat1 (ID 1)
INSERT INTO note (candidat_id, matiere_id, correcteur_id, valeur) VALUES 
(1, 1, 1, 12.0), -- JAVA, Corr1 -> 12
(1, 1, 2, 11.0), -- JAVA, Corr2 -> 11
(1, 2, 1, 7.0),  -- PHP, Corr1 -> 7
(1, 2, 2, 11.0); -- PHP, Corr2 -> 11

-- Candidat2 (ID 2)
INSERT INTO note (candidat_id, matiere_id, correcteur_id, valeur) VALUES 
(2, 1, 1, 13.0), -- JAVA, Corr1 -> 13
(2, 1, 2, 10.0), -- JAVA, Corr2 -> 10
(2, 2, 1, 14.0), -- PHP, Corr1 -> 14
(2, 2, 2, 16.0); -- PHP, Corr2 -> 16
