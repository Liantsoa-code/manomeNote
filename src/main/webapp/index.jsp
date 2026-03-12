<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>manomeNote | Système de Notation</title>
        <style>
            body {
                background-color: #f0f2f5;
                font-family: 'Segoe UI', Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                color: #333;
            }

            .container {
                background: white;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 400px;
            }

            h1 {
                text-align: center;
                color: #1a73e8;
                margin: 0 0 10px 0;
            }

            .subtitle {
                text-align: center;
                color: #5f6368;
                margin-bottom: 30px;
                display: block;
                font-size: 14px;
            }

            .input-group {
                margin-bottom: 20px;
                text-align: left;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                font-size: 14px;
            }

            input {
                width: 100%;
                padding: 12px;
                border: 1px solid #dadce0;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 16px;
            }

            input:focus {
                outline: none;
                border-color: #1a73e8;
                box-shadow: 0 0 0 2px rgba(26, 115, 232, 0.2);
            }

            button {
                width: 100%;
                padding: 12px;
                background-color: #1a73e8;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                margin-top: 10px;
            }

            button:hover {
                background-color: #1557b0;
            }

            .result-card {
                margin-top: 30px;
                padding: 20px;
                background-color: #f8f9fa;
                border-radius: 8px;
                text-align: center;
            }

            .final-grade {
                font-size: 40px;
                font-weight: bold;
                color: #188038;
                display: block;
                margin: 10px 0;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                font-size: 14px;
                margin: 8px 0;
                color: #5f6368;
            }
        </style>
    </head>

    <body>
        <div
            style="font-size: 32px; font-weight: 900; color: #1a73e8; text-align: center; padding: 20px 0; background: #fff; letter-spacing: 2px;">
            ETU3623</div>
        <div
            style="text-align: center; padding: 20px; background: #fff; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
            <a href="index.jsp"
                style="margin: 0 15px; text-decoration: none; color: #1a73e8; font-weight: bold;">Accueil</a>
            <a href="candidats"
                style="margin: 0 15px; text-decoration: none; color: #1a73e8; font-weight: bold;">Candidats</a>
            <a href="correcteurs"
                style="margin: 0 15px; text-decoration: none; color: #1a73e8; font-weight: bold;">Correcteurs</a>
            <a href="matieres"
                style="margin: 0 15px; text-decoration: none; color: #1a73e8; font-weight: bold;">Matières</a>
            <a href="gestion-notes"
                style="margin: 0 15px; text-decoration: none; color: #1a73e8; font-weight: bold;">Notes</a>
            <a href="parametres"
                style="margin: 0 15px; text-decoration: none; color: #1a73e8; font-weight: bold;">Paramètres</a>
            <a href="resultats"
                style="margin: 0 15px; text-decoration: none; color: #1a73e8; font-weight: bold;">Résultats</a>
        </div>
        <div class="container">
            <h1>manomeNote</h1>
            <p class="subtitle">Calculateur de Note Finale (Optimisé)</p>

            <form action="calculer" method="post">
                <div class="input-group">
                    <label for="idCandidat">ID Candidat</label>
                    <input type="number" id="idCandidat" name="idCandidat" placeholder="Ex: 1" required>
                </div>
                <div class="input-group">
                    <label for="idMatiere">ID Matière</label>
                    <input type="number" id="idMatiere" name="idMatiere" placeholder="Ex: 1" required>
                </div>
                <button type="submit">Lancer le Calcul</button>
            </form>

            <% if(request.getAttribute("erreur") !=null) { %>
                <div
                    style="margin-top: 20px; padding: 15px; background: rgba(255,0,0,0.2); border-radius: 12px; border: 1px solid rgba(255,0,0,0.3);">
                    ${erreur}
                </div>
                <% } %>

                    <% if(request.getAttribute("noteFinale") !=null) { %>
                        <div class="result-card">
                            <div class="detail-row">
                                <span>Candidat :</span>
                                <strong>${candidat}</strong>
                            </div>
                            <div class="detail-row">
                                <span>Matière :</span>
                                <strong>${matiere}</strong>
                            </div>
                            <hr style="border: none; border-top: 1px solid rgba(255,255,255,0.1); margin: 15px 0;">
                            <span class="final-grade">${noteFinale}/20</span>
                            <div class="detail-row">
                                <span>Méthode appliquée :</span>
                                <span style="text-transform: capitalize;">${resolution}</span>
                            </div>
                            <div class="detail-row">
                                <span>Somme des Différences :</span>
                                <span>${sad}</span>
                            </div>
                        </div>
                        <% } %>
        </div>
    </body>

    </html>