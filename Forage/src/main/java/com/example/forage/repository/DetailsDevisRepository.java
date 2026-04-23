package com.example.forage.repository;

import com.example.forage.model.DetailsDevis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

public interface DetailsDevisRepository extends JpaRepository<DetailsDevis, Long> {
    List<DetailsDevis> findByDevisId(Long devisId);
    
    @Modifying
    @Transactional
    void deleteByDevisId(Long devisId);
}
