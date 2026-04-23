package com.example.forage.repository;

import com.example.forage.model.StatusDemande;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StatusDemandeRepository extends JpaRepository<StatusDemande, Long> {
    List<StatusDemande> findByDemandeIdOrderByDateStatutDesc(Long demandeId);
}
