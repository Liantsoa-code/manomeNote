package com.grading.servlet;

import com.grading.dao.CandidatDAO;
import com.grading.dao.CorrecteurDAO;
import com.grading.dao.MatiereDAO;
import com.grading.dao.NoteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/gestion-notes")
public class NoteManagementServlet extends HttpServlet {
    private NoteDAO noteDAO = new NoteDAO();
    private CandidatDAO candidatDAO = new CandidatDAO();
    private CorrecteurDAO correcteurDAO = new CorrecteurDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if ("delete".equals(request.getParameter("action")))
                noteDAO.delete(Integer.parseInt(request.getParameter("id")));
            request.setAttribute("notes", noteDAO.getAllWithNames());
            request.setAttribute("candidats", candidatDAO.getAll());
            request.setAttribute("correcteurs", correcteurDAO.getAll());
            request.setAttribute("matieres", matiereDAO.getAll());
            request.getRequestDispatcher("views/notes.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            noteDAO.add(Integer.parseInt(request.getParameter("candidatId")),
                    Integer.parseInt(request.getParameter("correcteurId")),
                    Integer.parseInt(request.getParameter("matiereId")),
                    Double.parseDouble(request.getParameter("valeur")));
            response.sendRedirect("gestion-notes");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
