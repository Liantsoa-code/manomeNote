<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>manomeNote | Système de Notation</title>
    <style>
        :root {
            --glass: rgba(255, 255, 255, 0.1);
            --gold: #fdbb2d;
            --deep-blue: #1a2a6c;
        }
        body {
            background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Outfit', 'Segoe UI', sans-serif;
            color: white;
            margin: 0;
        }
        .container {
            background: var(--glass);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            padding: 3rem;
            border-radius: 24px;
            border: 1px solid rgba(255,255,255,0.2);
            box-shadow: 0 15px 35px rgba(0,0,0,0.4);
            width: 100%;
            max-width: 450px;
            text-align: center;
        }
        h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
            letter-spacing: -1px;
            background: linear-gradient(to right, #fff, var(--gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        p.subtitle {
            margin-bottom: 2.5rem;
            opacity: 0.8;
            font-size: 0.9rem;
        }
        .input-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.9;
        }
        input {
            width: 100%;
            padding: 14px 18px;
            background: rgba(255,255,255,0.07);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            color: white;
            box-sizing: border-box;
            outline: none;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        input:focus {
            background: rgba(255,255,255,0.12);
            border-color: var(--gold);
            box-shadow: 0 0 15px rgba(253, 187, 45, 0.2);
        }
        button {
            width: 100%;
            padding: 16px;
            margin-top: 1rem;
            border: none;
            border-radius: 12px;
            background: linear-gradient(to right, var(--gold), #f39c12);
            color: var(--deep-blue);
            font-weight: 800;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(253,187,45,0.4);
        }
        .result-card {
            margin-top: 2.5rem;
            padding: 20px;
            background: rgba(255,255,255,0.05);
            border: 1px dashed rgba(255,255,255,0.2);
            border-radius: 16px;
            animation: fadeIn 0.6s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .final-grade {
            display: block;
            font-size: 3rem;
            font-weight: 800;
            color: var(--gold);
            margin: 10px 0;
            text-shadow: 0 0 20px rgba(253, 187, 45, 0.3);
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin: 5px 0;
            font-size: 0.85rem;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>manomeNote</h1>
        <p class="subtitle">Système Intégré de Notation Candidat</p>
        
        <form action="calculer" method="post">
            <div class="input-group">
                <label for="idCandidat">Numéro Candidat</label>
                <input type="text" id="idCandidat" name="idCandidat" placeholder="Ex: CAN-2024-001" required>
            </div>
            <div class="input-group">
                <label for="idMatiere">Code Matière</label>
                <input type="text" id="idMatiere" name="idMatiere" placeholder="Ex: MATH-01" required>
            </div>
            <button type="submit">Calculer la Note</button>
        </form>

        <% if(request.getAttribute("noteFinale") != null) { %>
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
