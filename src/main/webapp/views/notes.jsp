<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <title>Saisie des Notes</title>
            <style>
                body {
                    font-family: 'Segoe UI', Arial, sans-serif;
                    background-color: #f0f2f5;
                    margin: 0;
                    padding: 20px;
                }

                .container {
                    max-width: 900px;
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

                select,
                input {
                    padding: 10px;
                    margin: 5px;
                    border-radius: 4px;
                    border: 1px solid #ddd;
                }

                .btn {
                    padding: 10px 20px;
                    background: #1a73e8;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
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
                <h1>Saisie des Notes</h1>
                <form action="gestion-notes" method="post"
                    style="background:#f8f9fa; padding:20px; border-radius:8px; margin-bottom:20px;">
                    <select name="candidatId" required>
                        <option value="">Candidat</option>
                        <c:forEach var="c" items="${candidats}">
                            <option value="${c.id}">${c.nom}</option>
                        </c:forEach>
                    </select>
                    <select name="correcteurId" required>
                        <option value="">Correcteur</option>
                        <c:forEach var="c" items="${correcteurs}">
                            <option value="${c.id}">${c.nom}</option>
                        </c:forEach>
                    </select>
                    <select name="matiereId" required>
                        <option value="">Matière</option>
                        <c:forEach var="m" items="${matieres}">
                            <option value="${m.id}">${m.libelle}</option>
                        </c:forEach>
                    </select>
                    <input type="number" name="valeur" step="0.01" placeholder="Note /20" required>
                    <button type="submit" class="btn">Enregistrer</button>
                </form>
                <table>
                    <thead>
                        <tr>
                            <th>Candidat</th>
                            <th>Correcteur</th>
                            <th>Matière</th>
                            <th>Note</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="n" items="${notes}">
                            <tr>
                                <td>${n.etudiantNom}</td>
                                <td>${n.professeurNom}</td>
                                <td>${n.matiereNom}</td>
                                <td>${n.valeur}/20</td>
                                <td><a href="gestion-notes?action=delete&id=${n.id}" style="color:red;">Supprimer</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </body>

        </html>