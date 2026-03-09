package com.grading.servlet;

import com.grading.dao.MatiereDAO;
import com.grading.model.Matiere;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/matieres")
public class MatiereServlet extends HttpServlet {
    private MatiereDAO matiereDAO = new MatiereDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                matiereDAO.delete(id);
            }
            List<Matiere> list = matiereDAO.getAll();
            request.setAttribute("matieres", list);
            request.getRequestDispatcher("views/matieres.jsp").forward(request, response);
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
                matiereDAO.add(nom);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                matiereDAO.update(id, nom);
            }
            response.sendRedirect("matieres");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
