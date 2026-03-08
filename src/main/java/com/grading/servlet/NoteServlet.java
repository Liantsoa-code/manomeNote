package com.grading.servlet;

import com.grading.service.GradingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/calculer")
public class NoteServlet extends HttpServlet {
    private GradingService gradingService = new GradingService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Données du formulaire
        String idCandidat = request.getParameter("idCandidat");
        String idMatiere = request.getParameter("idMatiere");

        // Simulation de notes pour la démonstration
        // Plus tard, ces notes viendront de la base de données PostgreSQL
        List<Double> notesProfs = Arrays.asList(12.0, 15.0, 11.0);

        // Calcul de la Somme des Différences Absolues (SAD)
        double sad = gradingService.calculerSAD(notesProfs);

        // Application de la règle métier :
        // Si somme des différences < 2 => Moyenne, sinon => Min
        String resolutionChoisie = (sad < 2) ? "moyenne" : "min";
        double noteFinale = gradingService.appliquerResolution(notesProfs, resolutionChoisie);

        // Envoi des résultats à la vue JSP
        request.setAttribute("sad", sad);
        request.setAttribute("noteFinale", noteFinale);
        request.setAttribute("resolution", resolutionChoisie);
        request.setAttribute("candidat", idCandidat);
        request.setAttribute("matiere", idMatiere);

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
