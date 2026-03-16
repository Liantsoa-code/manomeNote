# Explication de la Logique de Rapprochement du SAD (Sprint 2)

Ce document explique les modifications apportées à votre code lors du "Sprint 2" pour corriger le calcul de la décision finale basée sur le SAD (Somme des Absolues des Différences), ainsi que le correctif pour la suppression des matières.

---

## 1. Correction de la Suppression d'une Matière (`MatiereDAO.java`)

### **Le Problème initial : Erreur de Clé Étrangère**
Lorsque vous essayiez de supprimer une matière (ex: JAVA), la base de données (PostgreSQL) bloquait l'opération en déclenchant une **violation de contrainte de clé étrangère**. 
Pourquoi ? Parce que la table `matiere` est liée à d'autres tables, notamment `parametre` (les règles de SAD) et `note`. Si on supprime la matière alors que des paramètres pointent encore vers elle, ces derniers deviennent des "orphelins", ce qui casse l'intégrité de la base de données.

### **La Solution : Les Transactions**
Nous avons modifié la méthode `delete(int id)` dans `MatiereDAO.java` pour utiliser une **transaction SQL**.

```java
conn.setAutoCommit(false); // On désactive l'enregistrement automatique

// 1. On supprime toutes les notes liées à cette matière
pstmtNote.executeUpdate();

// 2. On supprime tous les paramètres liés à cette matière
pstmtParam.executeUpdate();

// 3. Enfin, on supprime la matière elle-même
pstmtMatiere.executeUpdate();

conn.commit(); // Si tout s'est bien passé, on valide l'ensemble
```

**Comment ça marche ?**
Le principe d'une transaction est le "Tout ou Rien". Le code dit à la base de données de supprimer d'abord les dépendances (les notes et paramètres) de manière temporaire. Si et seulement si ces deux suppressions réussissent, on supprime la matière. Le `conn.commit()` valide tout d'un coup. S'il y a la moindre erreur en cours de route, un `conn.rollback()` (dans le bloc `catch`) annule tout pour que la base de données reste dans un état propre.

---

## 2. La Logique du SAD en Java (`ParametreDAO.java`)

### **Le Problème initial : La zone neutre**
L'application possédait deux règles pour JAVA :
- `SAD <= 2.0` -> Choisir **Petit**
- `SAD >= 5.0` -> Choisir **Grand**

Si un étudiant avait un SAD de **3.5** (exactement au milieu), la requête SQL d'origine disait : *"3.5 n'est ni inférieur à 2, ni supérieur à 5, donc je ne renvoie rien"*. 
Face à ce vide, le code Java retournait par défaut la valeur de secours : **Moyenne**.

### **L'Objectif du Sprint 2**
Il fallait introduire l'intelligence suivante :
1. Si le SAD est "entre" les règles, il faut trouver le seuil **le plus proche**.
2. Si le SAD est exactement à la même distance de deux seuils, il faut prendre la condition qui a le **seuil le plus bas**.

### **La Solution : Évaluation en Java avec `getResolutionAppropriee`**
Au lieu de laisser la base de données faire le tri (qui est trop binaire), nous avons transformé la méthode pour charger **toutes** les règles d'une matière et de faire le calcul en Java.

Voici comment la méthode réfléchit maintenant, étape par étape :

#### **Étape 1 : Lire les règles et vérifier les correspondances exactes**
Le code parcourt toutes les règles de la base de données (`rs.next()`). Pour chaque règle, il vérifie le signe ( `<`, `<=`, `>=`, etc.) avec un bloc `switch`.
Si le SAD d'un étudiant vérifie une condition (ex: SAD=1.5 est bien `>= 2.0`), cette règle est mise de côté dans la liste `validResolutions`.

#### **Étape 2 : Que fait-on s'il y a une ou plusieurs correspondances exactes ?**
Si une seule règle est contournée, on la renvoie tout de suite.
*(C'est la logique classique. ex: SAD=6.0 renverra tout de suite "Grand" car il est supérieur à 5.0).*

#### **Étape 3 : Que fait-on s'il y a une "Zone d'ombre" (Aucune correspondance) ?**
C'est là que réside la magie du Sprint 2. Si aucune règle n'a été validée (ex: SAD=3.5 n'est répertorié nulle part), la liste `validResolutions` est vide.
Le code décide alors de comparer ce SAD de 3.5 avec **tous les seuils existants** (`allLimites`) pour voir lequel est le plus proche.

```java
int bestIndex = 0;
// minEcart stocke la distance avec le premier seuil (ex: |3.5 - 2.0| = 1.5)
double minEcart = Math.abs(sadCalculée - limToCompare.get(0));

// On parcourt les autres seuils
for (int i = 1; i < resToCompare.size(); i++) {
    // On calcule l'écart avec le seuil suivant (ex: |3.5 - 5.0| = 1.5)
    double ecart = Math.abs(sadCalculée - limToCompare.get(i));
    
    // Si la distance est plus courte, on retient ce nouveau seuil
    if (ecart < minEcart) {
        minEcart = ecart;
        bestIndex = i;
    } 
    // LA RÈGLE D'ÉGALITÉ : Si les deux seuils sont à même distance (1.5 == 1.5)
    else if (ecart == minEcart) {
        // On compare la valeur brute des deux limites (ex: 5.0 < 2.0 ? Faux, donc on garde 2.0)
        if (limToCompare.get(i) < limToCompare.get(bestIndex)) {
            bestIndex = i; // On prend le seuil le plus petit
        }
    }
}
return resToCompare.get(bestIndex); // On renvoie la résolution (ex: "Petit")
```

### **Résumé du test à même distance (SAD = 3.5)**
1. Java voit les seuils : **2.0** et **5.0**.
2. Il calcule la distance de 3.5 vers 2.0 : Distance = **1.5**
3. Il calcule la distance de 3.5 vers 5.0 : Distance = **1.5**
4. Les distances sont **égales**. Le code entre dans le bloc `else if (ecart == minEcart)`.
5. Il compare alors les seuils initiaux : `5.0` est-il plus petit que `2.0` ? Non. Donc le "gagnant" reste celui du seuil **2.0**.
6. Le seuil 2.0 est lié à la résolution **Petit**.
7. Le programme retourne "Petit". La note finale choisie par le service de grading (`GradingService.java`) sera alors la note minimum parmi les 3 correcteurs.
