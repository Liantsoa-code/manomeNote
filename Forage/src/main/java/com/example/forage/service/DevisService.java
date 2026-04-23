package com.example.forage.service;

import com.example.forage.model.Devis;
import com.example.forage.model.DetailsDevis;
import com.example.forage.repository.DevisRepository;
import com.example.forage.repository.DetailsDevisRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class DevisService {

    @Autowired
    private DevisRepository devisRepository;

    @Autowired
    private DetailsDevisRepository detailsDevisRepository;

    @Transactional
    public Devis saveDevis(Devis devis, List<DetailsDevis> details) {
        // Enregistre d'abord le devis pour générer l'ID
        boolean isNew = devis.getId() == null;
        Devis savedDevis = devisRepository.save(devis);
        
        // Si c'est une modification, on supprime les anciens détails
        if (!isNew) {
            detailsDevisRepository.deleteByDevisId(savedDevis.getId());
        }

        // On enregistre les détails
        for (DetailsDevis d : details) {
            d.setDevis(savedDevis);
            detailsDevisRepository.save(d);
        }
        
        return savedDevis;
    }
    
   
    public double calculateTotalAmount(Long devisId) {
        return detailsDevisRepository.findByDevisId(devisId).stream()
                .mapToDouble(this::calculateItemAmount)
                .sum();
    }

    
    public double calculateTotalRawRevenue() {
        return detailsDevisRepository.findAll().stream()
                .mapToDouble(d -> (d.getPrixUnitaire() != null ? d.getPrixUnitaire() : 0.0) * (d.getQuantite() != null ? d.getQuantite() : 0.0))
                .sum();
    }

    public double calculateTotalForecastedRevenue() {
        return detailsDevisRepository.findAll().stream()
                .mapToDouble(this::calculateItemAmount)
                .sum();
    }

    private double calculateItemAmount(DetailsDevis details) {
        double prix = details.getPrixUnitaire() != null ? details.getPrixUnitaire() : 0.0;
        double qte = details.getQuantite() != null ? details.getQuantite() : 0.0;
        
        if (prix >= 1000000) {
            prix = prix * 0.9;
        }
        
        return prix * qte;
    }
    
    public double calculateGlobalRevenue() {
        return calculateTotalForecastedRevenue();
    }
}
