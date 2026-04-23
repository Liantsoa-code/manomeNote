# Projet Forage - Documentation et Fonctionnement du Code

Cette documentation détaille l'architecture et le fonctionnement technique de l'application de gestion de forage.

## 1. Architecture Générale
L'application est construite sur le framework **Spring Boot (Java)** avec l'approche **MVC (Modèle-Vue-Contrôleur)** :
- **Modèle (JPA/Hibernate)** : Représente les tables SQL sous forme d'objets Java.
- **Vue (JSP)** : Affiche l'interface utilisateur dans le navigateur.
- **Contrôleur (Spring Web)** : Gère le flux de navigation et les actions des formulaires.
- **Service** : Couche intermédiaire pour la logique métier automatisée.

## 2. Base de Données (PostgreSQL)
Le fichier [database.sql](file:///d:/fianarana/Forage/database.sql) définit la structure pour stocker :
- **Clients** : `nom` et `contact`.
- **Demandes** : Liées à un client avec localisation et **référence directe au statut**.
- **Statuts** : États possibles pour les demandes et les travaux.
- **Devis** : Liaison entre une demande et un calcul financier.

## 3. Logique Applicative (Java)

### 3.1 Les Contrôleurs principaux
- **[DashboardController.java](file:///d:/fianarana/Forage/src/main/java/com/example/forage/controller/DashboardController.java)** : Affiche la liste des demandes et leur statut actuel récupéré directement de l'objet Demande.

### 3.2 Les Services transactionnels
- **[DemandeService.java](file:///d:/fianarana/Forage/src/main/java/com/example/forage/service/DemandeService.java)** : Lors de la sauvegarde d'une nouvelle demande, le service lui assigne directement le statut **"Créée"**.
- **[DevisService.java](file:///d:/fianarana/Forage/src/main/java/com/example/forage/service/DevisService.java)** : Calcule la somme totale des lignes de détails avant de valider l'enregistrement final du devis.

## 4. Frontend et Expérience Utilisateur

### 4.1 Interface Moderne (JSP)
Toutes les vues se trouvent dans [WEB-INF/jsp/](file:///d:/fianarana/Forage/src/main/webapp/WEB-INF/jsp). J'ai activé `trimDirectiveWhitespaces="true"` pour éviter le **Quirks Mode** (mélange de standards HTML anciens et récents) et assurer un affichage rapide et moderne.

### 4.2 Système d'Autocomplete (JavaScript)
Pour éviter de chercher un client dans une longue liste déroulante :
- Un champ texte suggestif est présent dans [dashboard.jsp](file:///d:/fianarana/Forage/src/main/webapp/WEB-INF/jsp/dashboard.jsp).
- **Logique** : Le script JavaScript compare les lettres tapées avec les noms des clients chargés en mémoire (via un conteneur HTML caché).
- **Flexibilité** : La recherche est insensible à la casse et permet une sélection rapide par clic.

## 5. Points Techniques Clés corrigés
- **Mapping de tables** : Correction des noms de tables entre Java et SQL (ex: `DemandeStatut` vers `demandestatut`).
- **Encodage** : Gestion des caractères accentués (Utilisation de "Créée" au lieu de "Creee") pour correspondre exactement aux données en base de données SQL.
- **Suppression (CRUD)** : Uniformisation des liens de suppression en méthodes `GET` pour une navigation plus fluide pour l'utilisateur.

---
*Documentation générée pour faciliter la maintenance et l'évolution du projet Forage.*
