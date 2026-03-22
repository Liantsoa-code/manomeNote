<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <title>Paramètres de Calcul</title>
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

                .form-box {
                    background: #f8f9fa;
                    padding: 20px;
                    border-radius: 8px;
                    margin-bottom: 20px;
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
                <h1>Paramètres de Calcul</h1>
                <div class="form-box">
                    <form action="parametres" method="post">
                        <select name="matiereId" required>
                            <option value="">Matière</option>
                            <c:forEach var="m" items="${matieres}">
                                <option value="${m.id}">${m.libelle}</option>
                            </c:forEach>
                        </select>
                        <select name="operationId" required>
                            <option value="">Opération</option>
                            <c:forEach var="o" items="${operations}">
                                <option value="${o.id}">${o.signe}</option>
                            </c:forEach>
                        </select>
                        <input type="number" name="valeurLimite" step="0.1" placeholder="Seuil SAD" required>
                        <select name="resolutionId" required>
                            <option value="">Résolution</option>
                            <c:forEach var="r" items="${resolutions}">
                                <option value="${r.id}">${r.libelle}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn">Ajouter la règle</button>
                    </form>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Matière</th>
                            <th>Condition (SAD)</th>
                            <th>Résolution</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${parametres}">
                            <tr>
                                <td>${p.matiereNom}</td>
                                <td><strong>${p.comparateurSymbole} ${p.valeurLimite}</strong></td>
                                <td>${p.resolutionNom}</td>
                                <td><a href="parametres?action=delete&id=${p.id}" style="color:red;">Supprimer</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </body>

        </html>