<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <title>ETU3623 | Récapitulatif des Notes Finales</title>
            <style>
                body {
                    font-family: 'Segoe UI', Arial, sans-serif;
                    background-color: #f0f2f5;
                    margin: 0;
                    padding: 20px;
                }

                .container {
                    max-width: 1000px;
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
                    background: white;
                    padding: 15px;
                    border-radius: 8px;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
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
                    padding: 15px;
                    border-bottom: 1px solid #ddd;
                    text-align: left;
                }

                th {
                    background-color: #f8f9fa;
                    color: #5f6368;
                    font-weight: 600;
                }

                .final-note {
                    color: #188038;
                    font-weight: bold;
                    font-size: 1.2em;
                }

                .badge {
                    padding: 5px 10px;
                    border-radius: 12px;
                    font-size: 12px;
                    font-weight: bold;
                    text-transform: capitalize;
                }

                .badge-moyenne {
                    background: #e8f0fe;
                    color: #1a73e8;
                }

                .badge-grand {
                    background: #e6f4ea;
                    color: #188038;
                }

                .badge-petit {
                    background: #fef7e0;
                    color: #f29900;
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
                <h1>Tableau de Bord des Résultats</h1>

                <table>
                    <thead>
                        <tr>
                            <th>Candidat</th>
                            <th>Matière</th>
                            <th>Écart (SAD)</th>
                            <th>Correction</th>
                            <th>Décision</th>
                            <th>Note Finale</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${results}">
                            <tr>
                                <td><strong>${r.candidatNom}</strong></td>
                                <td>${r.matiereNom}</td>
                                <td style="color: #666;">${r.sad}</td>
                                <td style="font-size: 0.9em; color: #888;">${r.nbProfs} correcteurs</td>
                                <td>
                                    <c:set var="bClass" value="badge-moyenne" />
                                    <c:if test="${r.resolution == 'Grand'}">
                                        <c:set var="bClass" value="badge-grand" />
                                    </c:if>
                                    <c:if test="${r.resolution == 'Petit'}">
                                        <c:set var="bClass" value="badge-petit" />
                                    </c:if>
                                    <span class="badge ${bClass}">${r.resolution}</span>
                                </td>
                                <td class="final-note">${r.noteFinale}/20</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </body>

        </html>