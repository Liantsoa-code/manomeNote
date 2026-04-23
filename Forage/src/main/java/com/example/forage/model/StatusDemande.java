package com.example.forage.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "status_demande")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StatusDemande {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_demande")
    private Demande demande;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_statut")
    private Statut statut;
    
    @Column(name = "date_statut")
    private LocalDateTime dateStatut;

    @Column(name = "observation")
    private String observation;

    public String getFormattedDate() {
        if (dateStatut == null) return "-";
        return dateStatut.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
    }
}
