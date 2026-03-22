package com.grading.servlet;

import com.grading.dao.CandidatDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/candidats")
public class CandidatServlet extends HttpServlet {
    private CandidatDAO dao = new CandidatDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if ("delete".equals(request.getParameter("action")))
                dao.delete(Integer.parseInt(request.getParameter("id")));
            request.setAttribute("candidats", dao.getAll());
            request.getRequestDispatcher("views/candidats.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            dao.add(request.getParameter("nom"));
            response.sendRedirect("candidats");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
