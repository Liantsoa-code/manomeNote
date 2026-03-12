package com.grading.model;

public class FinalGradeDTO {
    private String candidatNom;
    private String matiereNom;
    private double noteFinale;
    private String resolution;
    private double sad;
    private int nbProfs;

    public FinalGradeDTO(String candidatNom, String matiereNom, double noteFinale, String resolution, double sad,
            int nbProfs) {
        this.candidatNom = candidatNom;
        this.matiereNom = matiereNom;
        this.noteFinale = noteFinale;
        this.resolution = resolution;
        this.sad = sad;
        this.nbProfs = nbProfs;
    }

    public String getCandidatNom() {
        return candidatNom;
    }

    public String getMatiereNom() {
        return matiereNom;
    }

    public double getNoteFinale() {
        return noteFinale;
    }

    public String getResolution() {
        return resolution;
    }

    public double getSad() {
        return sad;
    }

    public int getNbProfs() {
        return nbProfs;
    }
}
