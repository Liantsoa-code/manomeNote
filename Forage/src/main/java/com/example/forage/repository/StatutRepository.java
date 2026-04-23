package com.example.forage.repository;

import com.example.forage.model.Statut;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface StatutRepository extends JpaRepository<Statut, Long> {
    Optional<Statut> findByNomStatut(String nomStatut);
}
