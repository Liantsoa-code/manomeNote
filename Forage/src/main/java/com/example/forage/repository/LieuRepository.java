package com.example.forage.repository;

import com.example.forage.model.Lieu;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface LieuRepository extends JpaRepository<Lieu, Long> {
    List<Lieu> findByDistrictId(Long districtId);
}
