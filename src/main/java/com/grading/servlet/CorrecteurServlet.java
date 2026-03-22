package com.grading.servlet;

import com.grading.dao.CorrecteurDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/correcteurs")
public class CorrecteurServlet extends HttpServlet {
    private CorrecteurDAO dao = new CorrecteurDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if ("delete".equals(request.getParameter("action")))
                dao.delete(Integer.parseInt(request.getParameter("id")));
            request.setAttribute("correcteurs", dao.getAll());
            request.getRequestDispatcher("views/correcteurs.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            dao.add(request.getParameter("nom"));
            response.sendRedirect("correcteurs");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
