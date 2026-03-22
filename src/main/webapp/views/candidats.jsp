<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <title>Gestion des Candidats</title>
            <style>
                body {
                    font-family: 'Segoe UI', Arial, sans-serif;
                    background-color: #f0f2f5;
                    margin: 0;
                    padding: 20px;
                }

                .container {
                    max-width: 800px;
                    margin: auto;
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }

                h1 {
                    color: #1a73e8;
                    text-align: center;
                }

                .nav {
                    margin-bottom: 20px;
                    text-align: center;
                }

                .nav a {
                    margin: 0 10px;
                    color: #1a73e8;
                    text-decoration: none;
                    font-weight: bold;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    padding: 12px;
                    border-bottom: 1px solid #ddd;
                    text-align: left;
                }

                .btn {
                    padding: 8px 12px;
                    border-radius: 4px;
                    text-decoration: none;
                    font-size: 14px;
                    cursor: pointer;
                    border: none;
                    color: white;
                }

                .btn-add {
                    background-color: #1a73e8;
                }

                .btn-delete {
                    background-color: #d93025;
                }
            </style>
        </head>

        <body>
            <div
                style="font-size: 32px; font-weight: 900; color: #1a73e8; text-align: center; padding: 20px 0; background: #fff; letter-spacing: 2px;">
                ETU3623</div>
            <div class="nav">
                <a href="index.jsp">Accueil</a>
                <a href="candidats">Candidats</a>
                <a href="correcteurs">Correcteurs</a>
                <a href="matieres">Matières</a>
                <a href="gestion-notes">Notes</a>
                <a href="parametres">Paramètres</a>
                <a href="resultats">Résultats</a>
            </div>
            <div class="container">
                <h1>Gestion des Candidats</h1>
                <form action="candidats" method="post" style="margin-bottom: 20px;">
                    <input type="text" name="nom" placeholder="Nom du candidat" required
                        style="padding: 10px; width: 250px; border: 1px solid #ddd; border-radius: 4px;">
                    <button type="submit" class="btn btn-add">Ajouter</button>
                </form>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${candidats}">
                            <tr>
                                <td>${c.id}</td>
                                <td>${c.nom}</td>
                                <td><a href="candidats?action=delete&id=${c.id}" class="btn btn-delete">Supprimer</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </body>

        </html>