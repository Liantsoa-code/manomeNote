- Student
    - id
    - name

- Teacher
    - id
    - name

- Subject
    - id
    - name

- Resolution
    - id
    - StringValue[Min, Max, Avg]
    - Ref[Minimum, Maximum, Average]

- Comparator
    - id
    - StringValue[<, >]
    - Ref[under, above]

- Notes
    - Student_id
    - Teacher_id
    - Subject_id
    - Value
    - DateHeure

- Parameter
    - id
    - Subject_id
    - Comparator_id
    - Resolution_id
    - Limit[MaxValue or MinValue(selon le comparator)]


-> NotaBene :
- Chose à noter
    - une matière d'un étudiant peut être noté par plusieurs professeurs

- Règles de gestion
    - on compare seuil à la des somme |des différences| entre les notes donnés par les professeurs

- Questions : 
    - on parle de la différence entre la note de tout les professeurs, ou juste la différence par paire de professeur ?
    - la somme des différences, ou la somme en valeur absolu des différences ?

-> à Faire :
- Créer un formulaire avec pour input :
    - idCandidature
    - idMatiere




- sommeDif < 2 => Moyenne
- sommeDif > 2 => Min

- chercher toutes les combinaisons possibles entre la différence de deux professeurs
à chaque combinaison, on obtient une différence,
    - mettre cette différence en valeur absolu

Faire la somme de ces valeurs absolus

Les données doivent être logique


Matiere(1) -> Paramètre(N)



dataForm



Table Resolution
Min
Max
Avg

Table Comparator
<
>

Table parameter
SubjectA < 5 Min
SubjectA < 10 Min
SubjectA < 15 Min
SubjectA < 20 Min


Si comparator < :
20 < 5  false
20 < 10 false
20 < 15 false
20 < 20 false
20 < 25 true (bon paramètre)
20 < 30 true


Si comparator > :
20 > 5  true
20 > 10 true
20 > 15 true
20 > 20 false (bon paramètre)
20 > 25 false
20 > 30 false