# 📘 Documentation du Projet Forage

Ce document explique l'architecture du code et guide les développeurs sur la manière de modifier ou d'étendre les fonctionnalités de l'application.

---

## 🏗️ Architecture Globale

L'application est construite avec **Spring Boot** en suivant le patron de conception **MVC (Modèle-Vue-Contrôleur)** :

1.  **Modèle (`com.example.forage.model`)** : Classes Java (Entités JPA) représentant les tables de la base de données.
2.  **Vue (`src/main/webapp/WEB-INF/jsp`)** : Pages dynamiques JSP pour l'interface utilisateur.
3.  **Contrôleur (`com.example.forage.controller`)** : Gère les requêtes HTTP, traite les données via les services et renvoie les vues.
4.  **Service (`com.example.forage.service`)** : Contient la **logique métier** et les transactions complexes (ex: historique de statut).
5.  **Repository (`com.example.forage.repository`)** : Interfaces Spring Data JPA pour les opérations CRUD (Create, Read, Update, Delete).

---

## 🗄️ Structure de la Base de Données (Schéma Actuel)

L'application utilise 9 tables principales :
-   **Client** : Informations de base (nom, téléphone).
-   **District & Lieu** : Hiérarchie géographique pour les demandes.
-   **Demande** : Point d'entrée d'un projet, liée à un client et un lieu.
-   **Statut & StatusDemande** : Système d'historique (une demande change de statut au fil du temps).
-   **TypeDevis, Devis & DetailDevis** : Gestion des chiffrages financiers liés à une demande.

---

## 🛠️ Où toucher pour modifier le code ?

### 1. Ajouter un champ à une table (ex: Email au Client)
-   **Entité (`Client.java`)** : Ajoutez l'attribut avec les annotations JPA.
-   **SQL (`full_db.sql`)** : Ajoutez la colonne dans la commande `CREATE TABLE`.
-   **Vue (`dashboard.jsp`)** : Ajoutez un `<input>` dans le formulaire "Nouveau Client" et une `<td>` dans le tableau.

### 2. Ajouter une logique métier (ex: Validation ou Calcul)
-   **Service layer** : C'est ici que doit se trouver la logique. 
    -   *Exemple actuel* : `DemandeService.createDemandeWithInitialStatus` gère l'insertion simultanée dans `demande` et `status_demande` sous une seule transaction.
-   Utilisez l'annotation `@Transactional` pour garantir que si une opération échoue, tout est annulé.

### 3. Modifier le flux des statuts
-   Si vous voulez changer le statut par défaut ou ajouter des règles de transition :
    -   Modifiez `DemandeService.java`.
    -   Vérifiez que les nouveaux noms de statuts existent dans le script SEED de `full_db.sql`.

### 4. Modifier l'affichage ou l'interface
-   Les fichiers JSP se trouvent dans `src/main/webapp/WEB-INF/jsp/`.
-   Le style global est centralisé dans `src/main/resources/static/css/style.css`.
-   Pour les interactions dynamiques (Autocomplete, calculs en direct), regardez les balises `<script>` à la fin des fichiers JSP.

---

## 📋 Points Clés de l'Implémentation Actuelle

-   **Montant des Devis** : Le montant total n'est **pas stocké** dans la table `devis`. Il est recalculé à chaque affichage dans `DevisController` via `devisService.calculateTotalAmount(id)`. C'est le champ `@Transient` nommé `montantCalculé` dans l'entité `Devis` qui permet de transporter cette valeur vers la vue sans la sauvegarder en base.
-   **Historique des Statuts** : Au lieu d'un simple champ `status_id` dans la table `demande`, nous utilisons la table `status_demande` pour garder une trace de chaque changement (date et type de statut).
-   **Relations Lazy** : La plupart des relations sont en `FetchType.LAZY` pour optimiser les performances (on ne charge pas les données liées tant qu'on n'en a pas besoin).

---

## 🚀 Lancement Rapide
1. Executez le script `full_db.sql` sur votre serveur PostgreSQL/MariaDB.
2. Configurez `src/main/resources/application.properties` avec vos accès base de données.
3. Lancez l'application via votre IDE ou `mvn spring-boot:run`.
