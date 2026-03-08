package com.grading.servlet;

import com.grading.dao.NoteDAO;
import com.grading.service.GradingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/calculer")
public class NoteServlet extends HttpServlet {
    private GradingService gradingService = new GradingService();
    private NoteDAO noteDAO = new NoteDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération et conversion des identifiants depuis le formulaire
        String idCandidatStr = request.getParameter("idCandidat");
        String idMatiereStr = request.getParameter("idMatiere");
        
        try {
            if (idCandidatStr == null || idMatiereStr == null) {
                request.setAttribute("erreur", "Les informations du formulaire sont manquantes.");
            } else {
                int idCandidat = Integer.parseInt(idCandidatStr);
                int idMatiere = Integer.parseInt(idMatiereStr);
                
                // RÉCUPÉRATION RÉELLE depuis PostgreSQL
                List<Double> notesProfs = noteDAO.getNotesParEtudiantEtMatiere(idCandidat, idMatiere);
                
                if (notesProfs.isEmpty()) {
                    request.setAttribute("erreur", "Aucune note trouvée pour ce candidat dans cette matière.");
                } else {
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
                }
            }
            
            request.setAttribute("candidat", idCandidatStr);
            request.setAttribute("matiere", idMatiereStr);

        } catch (NumberFormatException e) {
            request.setAttribute("erreur", "Les identifiants doivent être des nombres entiers.");
        }
        
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
