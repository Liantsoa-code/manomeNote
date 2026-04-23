
TRUNCATE TABLE detail_devis RESTART IDENTITY CASCADE;
TRUNCATE TABLE devis RESTART IDENTITY CASCADE;
TRUNCATE TABLE status_demande RESTART IDENTITY CASCADE;
TRUNCATE TABLE demande RESTART IDENTITY CASCADE;
TRUNCATE TABLE client RESTART IDENTITY CASCADE;
TRUNCATE TABLE lieu RESTART IDENTITY CASCADE;
TRUNCATE TABLE district RESTART IDENTITY CASCADE;
TRUNCATE TABLE type_devis RESTART IDENTITY CASCADE;
TRUNCATE TABLE statut RESTART IDENTITY CASCADE;


INSERT INTO statut (nom_statut) VALUES 
('demande_cree'), 
('devis_etude_propose'), 
('devis_forage_propose'),
('devis_forage en cours'),
('devis_etude en cours'),
('devis_foragerefusé'),
('devis_etude_refusé'),
('devis_forage terminé'),
('devis etude terminer');

INSERT INTO type_devis (nom_type_devis) VALUES 
('Devis Analyse'), 
('Devis Forage');

INSERT INTO district (nom_district) VALUES 
('Analamanga'), 
('Vakinankaratra'),
('Atsinanana');

INSERT INTO lieu (id_district, nom_lieu, adresse) VALUES 
(1, 'Antananarivo Centre', 'Analakely'),
(1, 'Ivato', 'Près de l''aéroport'),
(2, 'Antsirabe', 'Centre ville');


INSERT INTO client (nom, telephone) VALUES 
('Client de Test', '034 00 000 00');

SELECT 'Base de données réinitialisée avec succès' AS message;


CREATE OR REPLACE VIEW v_consultation_devis AS
SELECT 
    d.id AS devis_id,
    c.nom AS client,
    l.nom_lieu AS lieu,
    td.nom_type_devis AS type,
    d.date_devis,
    (SELECT SUM(
        CASE 
            WHEN dd.prix_unitaire >= 1000000 THEN (dd.prix_unitaire * 0.9) * dd.quantite
            ELSE dd.prix_unitaire * dd.quantite
        END
    ) FROM detail_devis dd WHERE dd.id_devis = d.id) AS total_ttc_remise_incluse
FROM devis d
JOIN demande dem ON d.id_demande = dem.id
JOIN client c ON dem.id_client = c.id
JOIN lieu l ON dem.id_lieu = l.id
JOIN type_devis td ON d.id_type_devis = td.id;
