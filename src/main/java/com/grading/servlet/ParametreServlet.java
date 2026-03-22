package com.grading.servlet;

import com.grading.dao.MatiereDAO;
import com.grading.dao.OperationDAO;
import com.grading.dao.ParametreDAO;
import com.grading.dao.ResolutionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/parametres")
public class ParametreServlet extends HttpServlet {
    private ParametreDAO parametreDAO = new ParametreDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();
    private OperationDAO operationDAO = new OperationDAO();
    private ResolutionDAO resolutionDAO = new ResolutionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if ("delete".equals(request.getParameter("action")))
                parametreDAO.delete(Integer.parseInt(request.getParameter("id")));
            request.setAttribute("parametres", parametreDAO.getAll());
            request.setAttribute("matieres", matiereDAO.getAll());
            request.setAttribute("operations", operationDAO.getAll());
            request.setAttribute("resolutions", resolutionDAO.getAll());
            request.getRequestDispatcher("views/parametres.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            parametreDAO.add(Integer.parseInt(request.getParameter("matiereId")),
                    Integer.parseInt(request.getParameter("operationId")),
                    Integer.parseInt(request.getParameter("resolutionId")),
                    Double.parseDouble(request.getParameter("valeurLimite")));
            response.sendRedirect("parametres");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
