package com.grading.servlet;

import com.grading.dao.MatiereDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/matieres")
public class MatiereServlet extends HttpServlet {
    private MatiereDAO dao = new MatiereDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if ("delete".equals(request.getParameter("action")))
                dao.delete(Integer.parseInt(request.getParameter("id")));
            request.setAttribute("matieres", dao.getAll());
            request.getRequestDispatcher("views/matieres.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            dao.add(request.getParameter("libelle"));
            response.sendRedirect("matieres");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
