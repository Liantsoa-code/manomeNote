package com.example.forage.service;

import com.example.forage.model.Demande;
import com.example.forage.model.Statut;
import com.example.forage.model.StatusDemande;
import com.example.forage.repository.DemandeRepository;
import com.example.forage.repository.StatutRepository;
import com.example.forage.repository.StatusDemandeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
public class DemandeService {

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private StatutRepository statutRepository;

    @Autowired
    private StatusDemandeRepository statusDemandeRepository;

    @Transactional
    public Demande createDemandeWithInitialStatus(Demande demande) {
        // maka demande
        Demande savedDemande = demandeRepository.save(demande);
        
        // mitady "demande_cree"
        Statut initialStatus = statutRepository.findByNomStatut("demande_cree")
                .orElseThrow(() -> new RuntimeException("Statut 'demande_cree' non trouvé en base."));

        //historique status
        StatusDemande statusDemande = new StatusDemande();
        statusDemande.setDemande(savedDemande);
        statusDemande.setStatut(initialStatus);
        statusDemande.setDateStatut(LocalDateTime.now());
        statusDemande.setObservation(null);
        
        statusDemandeRepository.save(statusDemande);
        
        return savedDemande;
    }

    @Transactional
    public StatusDemande addStatusToDemande(Long demandeId, Long statutId, String observation) {
        Demande demande = demandeRepository.findById(demandeId)
                .orElseThrow(() -> new RuntimeException("Demande non trouvée."));
        Statut statut = statutRepository.findById(statutId)
                .orElseThrow(() -> new RuntimeException("Statut non trouvé."));

        // maka status farany
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

    public Statut getLatestStatus(Long demandeId) {
        return statusDemandeRepository.findByDemandeIdOrderByDateStatutDesc(demandeId)
                .stream()
                .findFirst()
                .map(StatusDemande::getStatut)
                .orElse(null);
    }
}
