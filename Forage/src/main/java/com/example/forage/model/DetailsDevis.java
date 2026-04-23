package com.example.forage.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "detail_devis")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DetailsDevis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_devis")
    private Devis devis;
    
    private String libelle;
    
    @Column(name = "prix_unitaire")
    private Double prixUnitaire;
    
    private Double quantite;
}
