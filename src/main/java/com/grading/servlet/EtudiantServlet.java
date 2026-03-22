package com.grading.servlet;

import com.grading.dao.EtudiantDAO;
import com.grading.model.Etudiant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/etudiants")
public class EtudiantServlet extends HttpServlet {
    private EtudiantDAO etudiantDAO = new EtudiantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                etudiantDAO.delete(id);
            }
            List<Etudiant> list = etudiantDAO.getAll();
            request.setAttribute("etudiants", list);
            request.getRequestDispatcher("views/etudiants.jsp").forward(request, response);
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
                etudiantDAO.add(nom);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                etudiantDAO.update(id, nom);
            }
            response.sendRedirect("etudiants");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
