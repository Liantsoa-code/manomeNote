# Modifications apportées à la gestion des statuts

## Problème identifié
Lorsqu'on changeait un statut, cela créait systématiquement une nouvelle ligne dans la table `status_demande`, même si on modifiait seulement la date ou l'observation. Après avoir changé le statut, on ne pouvait plus le modifier.

## Solution implémentée

### Fichier modifié
`src/main/java/com/example/forage/service/DemandeService.java`

### Méthode concernée
`addStatusToDemande(Long demandeId, Long statutId, String observation)`

### Logique avant modification
```java
@Transactional
public StatusDemande addStatusToDemande(Long demandeId, Long statutId, String observation) {
    Demande demande = demandeRepository.findById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée."));
    Statut statut = statutRepository.findById(statutId)
            .orElseThrow(() -> new RuntimeException("Statut non trouvé."));

    StatusDemande statusDemande = new StatusDemande();
    statusDemande.setDemande(demande);
    statusDemande.setStatut(statut);
    statusDemande.setDateStatut(LocalDateTime.now());
    statusDemande.setObservation(observation != null ? observation.trim() : null);

    return statusDemandeRepository.save(statusDemande);
}
```

### Logique après modification
```java
@Transactional
public StatusDemande addStatusToDemande(Long demandeId, Long statutId, String observation) {
    Demande demande = demandeRepository.findById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée."));
    Statut statut = statutRepository.findById(statutId)
            .orElseThrow(() -> new RuntimeException("Statut non trouvé."));

    // Récupérer le dernier statut pour cette demande
    StatusDemande lastStatus = statusDemandeRepository.findByDemandeIdOrderByDateStatutDesc(demandeId)
            .stream()
            .findFirst()
            .orElse(null);

    // Si le dernier statut a le même statutId, on met à jour la ligne existante
    if (lastStatus != null && lastStatus.getStatut().getId().equals(statutId)) {
        lastStatus.setObservation(observation != null ? observation.trim() : null);
        lastStatus.setDateStatut(LocalDateTime.now());
        return statusDemandeRepository.save(lastStatus);
    }
    // Sinon, on crée une nouvelle ligne
    else {
        StatusDemande statusDemande = new StatusDemande();
        statusDemande.setDemande(demande);
        statusDemande.setStatut(statut);
        statusDemande.setDateStatut(LocalDateTime.now());
        statusDemande.setObservation(observation != null ? observation.trim() : null);

        return statusDemandeRepository.save(statusDemande);
    }
}
```

## Comportement attendu

1. **Si le statut est le même** : La méthode met à jour la dernière ligne existante (date et observation)
2. **Si le statut est différent** : La méthode crée une nouvelle ligne dans l'historique

## Avantages de cette modification

- Évite la création de lignes inutiles dans la base de données
- Permet de modifier l'observation et la date du dernier statut
- Conserve l'historique complet des changements de statut réels
- Le dernier statut est toujours identifié par le dernier ID

## Test recommandé

1. Changer un statut pour une demande
2. Modifier l'observation du même statut
3. Vérifier qu'une seule nouvelle ligne a été créée lors du changement de statut
4. Vérifier que la modification d'observation met à jour la ligne existante
