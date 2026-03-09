package com.grading.servlet;

import com.grading.dao.ProfesseurDAO;
import com.grading.model.Professeur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/professeurs")
public class ProfesseurServlet extends HttpServlet {
    private ProfesseurDAO professeurDAO = new ProfesseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                professeurDAO.delete(id);
            }
            List<Professeur> list = professeurDAO.getAll();
            request.setAttribute("professeurs", list);
            request.getRequestDispatcher("views/professeurs.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String nom = request.getParameter("nom");
        try {
            if ("add".equals(action)) {
                professeurDAO.add(nom);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                professeurDAO.update(id, nom);
            }
            response.sendRedirect("professeurs");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
