# Explication des Fonctions Existantes

Ce document détaille le fonctionnement complet de l'algorithme de notation de votre application `manomeNote`. Il vous aidera à comprendre comment les différentes pièces du puzzle s'assemblent, du calcul mathématique jusqu'à l'affichage sur la page web.

---

## 1. Le Cœur du Calcul : `GradingService.java`

Ce fichier (situé dans `src/main/java/com/grading/service/`) contient toute la logique "métier" (mathématique) indépendante de la base de données. 

### A. La fonction `calculerSAD(List<Double> notes)`
Cette fonction prend en entrée la liste des notes attribuées à un étudiant pour une matière (par exemple: `[10.0, 11.0, 11.75]`) et renvoie la **Somme des Absolues des Différences (SAD)**.

**Comment elle marche ?**
Elle utilise une double boucle (un `for` imbriqué dans un autre `for`) pour comparer chaque note avec toutes les autres, sans jamais comparer une note avec elle-même, ni refaire une comparaison déjà effectuée en sens inverse.

Pour 3 notes (A=10, B=11, C=11.75) :
1. `i=0, j=1` -> |A - B| = |10 - 11| = 1.0
2. `i=0, j=2` -> |A - C| = |10 - 11.75| = 1.75
3. `i=1, j=2` -> |B - C| = |11 - 11.75| = 0.75
**Total renvoyé :** 1.0 + 1.75 + 0.75 = **3.5**

### B. La fonction `appliquerResolution(List<Double> notes, String resolution)`
Une fois que le système a décidé quelle règle appliquer ("Petit", "Grand", ou "Moyenne"), cette fonction exécute la sentence sur la liste des notes.

**Comment elle marche ?**
Elle utilise un bloc `switch` sur le mot (la résolution) passé en paramètre.
- Si le mot est **"min"** ou **"petit"** : Elle utilise les "Streams" de Java pour trouver la valeur minimum de la liste (`min()`).
- Si le mot est **"max"** ou **"grand"** : Elle trouve la valeur maximum (`max()`).
- Si le mot est **"moyenne"** ou **"avg"** : Elle calcule la moyenne de toutes les notes (`average()`).
- Par sécurité (le bloc `default`), si le mot n'est pas reconnu, elle fait une moyenne.

### C. La fonction `validerNotes(List<Double> notes)`
Très simple, elle parcourt la liste des notes et vérifie qu'aucune n'est inférieure à 0 ou supérieure à 20. Elle renvoie `true` si tout est bon, `false` sinon.

---

## 2. L'Accès aux Données : Les repertoires "DAO"

Les DAO (Data Access Object) sont les seuls autorisés à parler à votre base de données PostgreSQL. 

### A. Dans `NoteDAO.java` : `getValeursParCandidatEtMatiere(...)`
C'est elle qui va chercher les notes brutes pour l'algorithme. Elle prend l'ID d'un candidat et d'une matière, et fait une requête SQL :
`SELECT valeur FROM note WHERE candidat_id = ? AND matiere_id = ?`
Elle renvoie une `List<Double>` toute simple prête à être envoyée au `GradingService`.

### B. Dans `ParametreDAO.java` : Les méthodes `getAll()` et `getResolutionAppropriee()`
- `getAll()` : Elle récupère toutes les règles sous forme d'objets `Parametre` pour les afficher dans le tableau de votre page d'administration. Elle utilise des `JOIN` (jointures) SQL pour récupérer le vrai nom de la matière et de la résolution au lieu de justes récupérer des chiffres (les ID).
- `getResolutionAppropriee(matiereId, sadCalculée)` : *(C'est celle que nous avons modifiée !)* Elle récupère tous les seuils de la base de données et les compare avec le SAD pour déterminer si on doit utiliser "Petit", "Grand" ou "Moyenne" (Voir le fichier `explication_logique_SAD.md` pour le détail).

---

## 3. Le Chef d'Orchestre : `NoteServlet.java`

Ce fichier (situé dans `com/grading/servlet/`) fait le pont entre vos pages Web (`.jsp`) et votre code Java en arrière-plan. La méthode la plus importante est **`doPost()`** (qui se déclenche quand vous cliquez sur le bouton pour voir les résultats).

**Quel est son scénario (l'ordre d'exécution) ?**
1. Elle récupère les informations envoyées par la page Web : Quel est l'étudiant ? Quelle est la matière ? (`request.getParameter`)
2. Elle demande au **`NoteDAO`** : *"Donne-moi toutes les notes de cet étudiant pour cette matière."*
3. Elle vérifie s'il y a plus d'un correcteur. 
    - S'il y a 2 correcteurs ou plus, elle demande au **`GradingService`** de `calculerSAD()`.
    - Ensuite, elle envoie le résultat de ce calcul au **`ParametreDAO`** en lui disant : *"Voici l'écart d'un candidat sur cette matière, dis-moi si je dois être gentil (Grand) ou sévère (Petit) !"* (`getResolutionAppropriee`).
4. Une fois le mot ("Petit" ou "Grand") récupéré, elle le donne à nouveau au **`GradingService`** pour obtenir la **Note Finale** (`appliquerResolution`).
5. Enfin, elle met toutes ces informations en mémoire (`request.setAttribute("noteFinale", ...)`) et renvoie tout l'affichage vers la page web `index.jsp` pour que vous puissiez voir les résultats.
