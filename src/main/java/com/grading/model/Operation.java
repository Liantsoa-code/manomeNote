package com.grading.model;

public class Operation {
    private int id;
    private String signe;

    public Operation() {
    }

    public Operation(int id, String signe) {
        this.id = id;
        this.signe = signe;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSigne() {
        return signe;
    }

    public void setSigne(String signe) {
        this.signe = signe;
    }
}
