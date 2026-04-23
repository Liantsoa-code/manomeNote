package com.example.forage.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "lieu")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Lieu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_district")
    private District district;
    
    private String adresse;
    
    @Column(name = "nom_lieu")
    private String nomLieu;
}
