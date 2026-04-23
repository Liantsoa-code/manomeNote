package com.example.forage.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDate;

@Entity
@Table(name = "devis")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Devis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_demande")
    private Demande demande;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_type_devis")
    private TypeDevis typeDevis;
    
    @Column(name = "date_devis")
    private LocalDate dateDevis;

    @Transient
    private Double montantCalculé;
}
