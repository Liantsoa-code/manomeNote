package com.example.forage.service;

import com.example.forage.model.Demande;
import com.example.forage.model.DemandeStatut;
import com.example.forage.model.Status;
import com.example.forage.repository.DemandeRepository;
import com.example.forage.repository.DemandeStatutRepository;
import com.example.forage.repository.StatusRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class DemandeService {

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private DemandeStatutRepository demandeStatutRepository;

    @Autowired
    private StatusRepository statusRepository;

    /**
     * Crée une demande et lui assigne automatiquement le statut initial "Créée" de façon transactionnelle.
     */
    @Transactional
    public Demande createDemandeWithInitialStatus(Demande demande) {
        // Enregistrer la demande d'abord
        Demande savedDemande = demandeRepository.save(demande);

        // Trouver le statut initial "Créée"
        Status initialStatus = statusRepository.findByLibelle("Créée")
                .orElseThrow(() -> new RuntimeException("Statut 'Créée' non trouvé en base. Veuillez vérifier l'initialisation de la table status."));

        // Créer l'entrée dans demandeStatut
        DemandeStatut ds = new DemandeStatut();
        ds.setDemande(savedDemande);
        ds.setStatus(initialStatus);
        ds.setDateStatut(LocalDateTime.now());

        demandeStatutRepository.save(ds);

        return savedDemande;
    }
}
