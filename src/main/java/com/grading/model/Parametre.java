package com.grading.model;

public class Parametre {
    private int id;
    private int matiereId;
    private int comparateurId;
    private int resolutionId;
    private double valeurLimite;

    // Jointures pour l'affichage
    private String matiereNom;
    private String comparateurSymbole;
    private String resolutionNom;

    public Parametre() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMatiereId() {
        return matiereId;
    }

    public void setMatiereId(int matiereId) {
        this.matiereId = matiereId;
    }

    public int getComparateurId() {
        return comparateurId;
    }

    public void setComparateurId(int comparateurId) {
        this.comparateurId = comparateurId;
    }

    public int getResolutionId() {
        return resolutionId;
    }

    public void setResolutionId(int resolutionId) {
        this.resolutionId = resolutionId;
    }

    public double getValeurLimite() {
        return valeurLimite;
    }

    public void setValeurLimite(double valeurLimite) {
        this.valeurLimite = valeurLimite;
    }

    public String getMatiereNom() {
        return matiereNom;
    }

    public void setMatiereNom(String matiereNom) {
        this.matiereNom = matiereNom;
    }

    public String getComparateurSymbole() {
        return comparateurSymbole;
    }

    public void setComparateurSymbole(String comparateurSymbole) {
        this.comparateurSymbole = comparateurSymbole;
    }

    public String getResolutionNom() {
        return resolutionNom;
    }

    public void setResolutionNom(String resolutionNom) {
        this.resolutionNom = resolutionNom;
    }
}
