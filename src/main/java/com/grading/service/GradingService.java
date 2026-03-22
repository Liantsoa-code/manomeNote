package com.grading.service;

import java.util.List;

public class GradingService {

    /**
     * Calcule la Somme des Valeurs Absolues des Différences (SAD)
     * Formule : Σ |note_i - note_j| pour toutes les paires uniques
     */
    public double calculerSAD(List<Double> notes) {
        double sad = 0;
        for (int i = 0; i < notes.size(); i++) {
            for (int j = i + 1; j < notes.size(); j++) {
                sad += Math.abs(notes.get(i) - notes.get(j));
            }
        }
        return sad;
    }

    /**
     * Détermine la note finale en fonction de la résolution (Petit, Grand, Moyenne)
     */
    public double appliquerResolution(List<Double> notes, String resolution) {
        if (notes == null || notes.isEmpty()) return 0;
        
        switch (resolution.toLowerCase()) {
            case "min":
            case "petit":
                return notes.stream().mapToDouble(v -> v).min().orElse(0);
            case "max":
            case "grand":
                return notes.stream().mapToDouble(v -> v).max().orElse(0);
            case "moyenne":
            case "avg":
                return notes.stream().mapToDouble(v -> v).average().orElse(0);
            default:
                // Par défaut on applique la moyenne
                return notes.stream().mapToDouble(v -> v).average().orElse(0);
        }
    }

    public boolean validerNotes(List<Double> notes) {
        if (notes == null || notes.isEmpty()) return false;
        for (double n : notes) {
            if (n < 0 || n > 20) return false;
        }
        return true;
    }
}
