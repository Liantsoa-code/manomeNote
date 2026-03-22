package com.grading.servlet;

import com.grading.dao.NoteDAO;
import com.grading.dao.ParametreDAO;
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
    private ParametreDAO parametreDAO = new ParametreDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idCandidatStr = request.getParameter("idCandidat");
        String idMatiereStr = request.getParameter("idMatiere");

        try {
            if (idCandidatStr == null || idMatiereStr == null) {
                request.setAttribute("erreur", "Les informations du formulaire sont manquantes.");
            } else {
                int idCandidat = Integer.parseInt(idCandidatStr);
                int idMatiere = Integer.parseInt(idMatiereStr);

                // 1. RÉCUPÉRATION des notes stockées
                List<Double> notesProfs = noteDAO.getValeursParCandidatEtMatiere(idCandidat, idMatiere);
                int nbProfs = notesProfs.size();

                if (notesProfs.isEmpty()) {
                    request.setAttribute("erreur", "Aucune note trouvée pour ce candidat.");
                } else {
                    String resolutionChoisie;
                    double sad = 0;

                    if (nbProfs >= 2) {
                        // RÈGLE : Utilise le seuil (SAD) dès qu'il y a au moins 2 correcteurs
                        sad = gradingService.calculerSAD(notesProfs);
                        resolutionChoisie = parametreDAO.getResolutionAppropriee(idMatiere, sad);
                    } else {
                        // Cas 1 seul professeur (au cas où)
                        resolutionChoisie = "Moyenne";
                        sad = 0;
                    }

                    // CALCUL de la note finale
                    double noteFinale = gradingService.appliquerResolution(notesProfs, resolutionChoisie);

                    request.setAttribute("sad", sad);
                    request.setAttribute("noteFinale", noteFinale);
                    request.setAttribute("resolution", resolutionChoisie);
                    request.setAttribute("nbProfs", nbProfs);
                }
            }
            request.setAttribute("candidat", idCandidatStr);
            request.setAttribute("matiere", idMatiereStr);
        } catch (NumberFormatException e) {
            request.setAttribute("erreur", "Les identifiants doivent être des nombres.");
        }

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
