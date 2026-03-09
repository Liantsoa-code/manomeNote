<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <title>Gestion des Étudiants</title>
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

                th {
                    background-color: #f8f9fa;
                }

                .btn {
                    padding: 8px 12px;
                    border-radius: 4px;
                    text-decoration: none;
                    font-size: 14px;
                    cursor: pointer;
                    border: none;
                }

                .btn-add {
                    background-color: #1a73e8;
                    color: white;
                    display: inline-block;
                    margin-bottom: 20px;
                }

                .btn-edit {
                    background-color: #f39c12;
                    color: white;
                }

                .btn-delete {
                    background-color: #d93025;
                    color: white;
                }

                .form-add {
                    margin-bottom: 30px;
                    padding: 20px;
                    background: #f8f9fa;
                    border-radius: 8px;
                }

                input[type="text"] {
                    padding: 10px;
                    width: 250px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
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
            </style>
        </head>

        <body>
            <div class="nav">
                <a href="index.jsp">Accueil</a>
                <a href="etudiants">Étudiants</a>
                <a href="professeurs">Professeurs</a>
                <a href="matieres">Matières</a>
            </div>
            <div class="container">
                <h1>Gestion des Étudiants</h1>

                <div class="form-add">
                    <h3>Ajouter un étudiant</h3>
                    <form action="etudiants?action=add" method="post">
                        <input type="text" name="nom" placeholder="Nom de l'étudiant" required>
                        <button type="submit" class="btn btn-add">Ajouter</button>
                    </form>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${etudiants}">
                            <tr>
                                <td>${e.id}</td>
                                <td>
                                    <form action="etudiants?action=update&id=${e.id}" method="post"
                                        style="display:inline;">
                                        <input type="text" name="nom" value="${e.nom}" style="width: auto;">
                                        <button type="submit" class="btn btn-edit">Modifier</button>
                                    </form>
                                </td>
                                <td>
                                    <a href="etudiants?action=delete&id=${e.id}" class="btn btn-delete"
                                        onclick="return confirm('Supprimer cet étudiant ?')">Supprimer</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </body>

        </html>