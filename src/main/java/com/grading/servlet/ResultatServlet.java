package com.grading.servlet;

import com.grading.dao.CandidatDAO;
import com.grading.dao.MatiereDAO;
import com.grading.dao.NoteDAO;
import com.grading.dao.ParametreDAO;
import com.grading.model.Candidat;
import com.grading.model.Matiere;
import com.grading.model.FinalGradeDTO;
import com.grading.service.GradingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/resultats")
public class ResultatServlet extends HttpServlet {
    private GradingService gradingService = new GradingService();
    private NoteDAO noteDAO = new NoteDAO();
    private ParametreDAO parametreDAO = new ParametreDAO();
    private CandidatDAO candidatDAO = new CandidatDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<FinalGradeDTO> results = new ArrayList<>();
        try {
            List<Candidat> candidats = candidatDAO.getAll();
            List<Matiere> matieres = matiereDAO.getAll();

            for (Candidat c : candidats) {
                for (Matiere m : matieres) {
                    List<Double> notes = noteDAO.getValeursParCandidatEtMatiere(c.getId(), m.getId());
                    if (!notes.isEmpty()) {
                        int nbProfs = notes.size();
                        double sad = gradingService.calculerSAD(notes);
                        String res;
                        if (nbProfs >= 2) {
                            res = parametreDAO.getResolutionAppropriee(m.getId(), sad);
                        } else {
                            res = "Moyenne";
                        }

                        double noteFinale = gradingService.appliquerResolution(notes, res);
                        results.add(new FinalGradeDTO(c.getNom(), m.getLibelle(), noteFinale, res, sad, nbProfs));
                    }
                }
            }
            request.setAttribute("results", results);
            request.getRequestDispatcher("views/resultats.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
