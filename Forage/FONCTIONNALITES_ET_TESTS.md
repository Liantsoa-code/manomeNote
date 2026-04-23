# 📋 Guide des Fonctionnalités et Plan de Test - Projet Forage

Ce document répertorie les fonctionnalités du système de forage et le plan de recette organisé par catégories.

## 2. Périmètre (Scope) des Tests

| ✅ Inclus dans les tests | ❌ Exclus des tests |
| :--- | :--- |
| **Gestion des Demandes** (Création & Liaison) | Authentification / Session (Hors Phase 1) |
| **Suivi des Statuts** (Logique de mise à jour) | Tests de charge & Performance |
| **Calcul des Devis** (Remises de 10% si PU >= 1M) | Sécurité avancée (Injection, CSRF) |
| **Validation des données** (Prix négatifs) | Compatibilité Mobile avancée |
| **Dashboard** (KPI Financiers) | Export PDF & Notifications |

---

## 3. Plan de Test Détaillé

### 3.1 Tests fonctionnels

| ID | Intitulé | Préconditions | Étapes | Données de test | Résultat attendu | Statut |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-001** | Ajout d'un nouveau client | Dashboard ouvert. | 1. Remplir nom et contact<br>2. Valider | Nom: "RAKOTO"<br>Tél: "032001" | Client ajouté en base. | ✅ Passé |
| **TC-002** | Création d'une demande | Client existant. | 1. Choisir client/lieu<br>2. Valider | Client: 1, Lieu: 1 | Demande créée (Statut: Créée). | ✅ Passé |
| **TC-003** | Remise automatique 10% | Création devis. | 1. Saisir PU >= 1M | PU: 1.200.000 | Remise appliquée sur le total. | ✅ Passé |
| **TC-004** | Changement de statut | Demande existante. | 1. Modifier le statut | Nouveau: "En cours" | Historique mis à jour. | ✅ Passé |
| **TC-005** | Calcul CA Prévisionnel | Stats devis. | 1. Voir stats | - | Somme des devis avec remise. | ✅ Passé |
| **TC-006** | Calcul CA Brut | Dashboard. | 1. Voir dash | - | Somme des devis sans remise. | ✅ Passé |
| **TC-007** | Autocomplete Client | Recherche active. | 1. Taper "RA" | "RA" | Suggestions filtrées affichées. | ✅ Passé |
| **TC-008** | Ajout de ligne devis | Formulaire devis. | 1. Cliquer "+ Ligne" | N/A | Champ de saisie ajouté en JS. | ✅ Passé |
| **TC-009** | Somme des lignes devis | Multiples détails. | 1. Remplir 2 lignes | L1=10k, L2=20k | Total affiché = 30k. | ✅ Passé |
| **TC-010** | Compteur Dashboard | Demandes en base. | 1. Ouvrir dash | 5 demandes | Le bloc stat indique "5". | ✅ Passé |

### 3.2 Tests négatifs

| ID | Intitulé | Préconditions | Étapes | Données de test | Résultat attendu | Statut |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-011** | Prix unitaire négatif | Création devis. | 1. Saisir PU = -1000 | PU: -1000 | Erreur affichée. Bloqué. | ✅ Passé |
| **TC-012** | Quantité négative | Création devis. | 1. Saisir Qté = -5 | Qté: -5 | Erreur affichée. Bloqué. | ✅ Passé |
| **TC-013** | Client non sélectionné | Formulaire demande. | 1. Laisser vide | N/A | Validation HTML ou serveur. | ✅ Passé |
| **TC-014** | Lieu non sélectionné | Formulaire demande. | 1. Laisser vide | N/A | Validation HTML ou serveur. | ✅ Passé |
| **TC-015** | Suppression client actif | Client avec demande. | 1. Supprimer | ID: 1 | Erreur d'intégrité (SQL). | ✅ Passé |
| **TC-016** | Libellé devis manquant | Ligne devis. | 1. Saisir PU/Qté uniquement | PU: 100 | Ligne ignorée ou bloquée. | ✅ Passé |

### 3.3 Tests de navigation et session

| ID | Intitulé | Préconditions | Étapes | Données de test | Résultat attendu | Statut |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-017** | Redirection Dashboard | Après enregistrement. | 1. Créer demande | N/A | Retour automatique à l'index. | ✅ Passé |
| **TC-018** | Retour liste Devis | Depuis détail devis. | 1. Cliquer "Retour" | N/A | Retour à la liste des devis. | ✅ Passé |
| **TC-019** | Accès détails Devis | Devis existant. | 1. Cliquer "Détails" | ID: 4 | Page spécifique affichée. | ✅ Passé |
| **TC-020** | Rafraîchissement Dashboard | Après action. | 1. Ajouter demande | N/A | Statut et listes à jour. | ✅ Passé |

---

## 4. Résumé Technique
- **Stack** : Spring Boot, PostgreSQL, JSP, Jetty.
- **Validation** : Double vérification Client (HTML5) + Serveur (Java).
- **Logique** : Remises calculées à la volée (Transient JPA).
