package com.grading.model;

public class GenericEntity {
    private int id;
    private String nom;
    private String symbole; // Pour comparateur

    public GenericEntity(int id, String nom) {
        this.id = id;
        this.nom = nom;
    }

    public int getId() {
        return id;
    }

    public String getNom() {
        return nom;
    }

    public String getSymbole() {
        return symbole;
    }

    public void setSymbole(String symbole) {
        this.symbole = symbole;
    }
}
