<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Devis | Forage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .detail-row { 
            display: grid; 
            grid-template-columns: 2fr 1fr 1fr 50px; 
            gap: 15px; 
            margin-bottom: 15px; 
            align-items: end;
        }
        .total-box { 
            font-size: 1.5rem; 
            font-weight: 700; 
            margin-top: 2rem; 
            color: var(--primary);
            background: #eff6ff;
            padding: 1.5rem;
            border-radius: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .total-value {
            font-family: 'Outfit', sans-serif;
            font-size: 2rem;
        }
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            font-size: 0.875rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-danger {
            background-color: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fee2e2;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div>
                <h1>Gestion des Devis</h1>
                <p style="color: var(--text-muted)">Créez et suivez vos propositions commerciales</p>
            </div>
            <nav style="display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Tableau de Bord</a>
                <a href="${pageContext.request.contextPath}/devis/stats" class="btn btn-primary">Chiffre d'Affaires</a>
            </nav>
        </header>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <strong>Erreur :</strong> ${errorMessage}
            </div>
        </c:if>

        <div class="card">
            <h2>Nouveau Devis</h2>
            <form action="${pageContext.request.contextPath}/devis/save" method="POST" id="devisForm">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 1.5rem;">
                    <div class="form-group">
                        <label for="demandeSearch">Demande (Client & Lieu)</label>
                        <div class="autocomplete-container">
                            <input type="text" id="demandeSearch" class="autocomplete-input" placeholder="Chercher par n°, client ou lieu..." autocomplete="off" required>
                            <input type="hidden" name="demandeId" id="demandeId" required>
                            <div id="demandeSuggestions" class="suggestions-list" style="display: none;"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="typeDevisId">Type de Devis</label>
                        <select name="typeDevisId" id="typeDevisId" required>
                            <option value="" disabled selected>Choisir un type...</option>
                            <c:forEach items="${types}" var="t">
                                <option value="${t.id}">${t.nomTypeDevis}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="dateDevis">Date du Devis</label>
                    <input type="date" name="dateDevis" id="dateDevis" required style="max-width: 300px;">
                </div>

                <div style="margin-top: 2.5rem; margin-bottom: 1rem; display: flex; justify-content: space-between; align-items: center;">
                    <h3 style="margin: 0; font-size: 1.125rem; font-weight: 600;">Détails du Devis</h3>
                    <button type="button" class="btn btn-secondary" style="padding: 0.5rem 1rem;" onclick="addRow()">+ Ligne</button>
                </div>

                <div id="detailsContainer">
                    <div class="detail-row">
                        <div class="form-group" style="margin-bottom: 0;">
                            <input type="text" name="libelles" placeholder="Désignation (ex: Étude de sol)" required>
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <input type="number" step="0.01" name="prixUnitaire" placeholder="P.U. (Ar)" required oninput="calculateTotal()" >
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <input type="number" step="1" name="quantite" placeholder="Qté" required oninput="calculateTotal()" >
                        </div>
                        <button type="button" class="btn btn-danger" style="padding: 0.75rem; width: 44px; height: 44px;" onclick="removeRow(this)">×</button>
                    </div>
                </div>

                <div class="total-box">
                    <span>Montant Total Estimé</span>
                    <div style="text-align: right;">
                        <span id="totalDisplay" class="total-value">0.00</span>
                        <span style="font-size: 1rem; margin-left: 0.5rem; color: var(--text-muted);">Ar</span>
                    </div>
                </div>

                <div style="margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1rem;">Enregistrer le Devis complet</button>
                </div>
            </form>
        </div>

        <div class="card">
            <h2>Devis enregistrés</h2>
            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date</th>
                            <th>Type</th>
                            <th>Client</th>
                            <th>Lieu</th>
                            <th>Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${devisList}" var="dev">
                            <tr>
                                <td style="color: var(--text-muted); font-weight: 500;">#${dev.id}</td>
                                <td>${dev.dateDevis}</td>
                                <td><span class="badge">${dev.typeDevis != null ? dev.typeDevis.nomTypeDevis : 'Non spécifié'}</span></td>
                                <td><strong>${dev.demande != null ? dev.demande.client.nom : 'Détaché'}</strong></td>
                                <td style="font-size: 0.875rem;">${dev.demande != null && dev.demande.lieu != null ? dev.demande.lieu.nomLieu : 'N/A'}</td>
                                <td style="font-weight: 600; color: var(--primary);">
                                    <fmt:formatNumber value="${dev.montantCalculé != null ? dev.montantCalculé : 0}" type="number" maxFractionDigits="2" /> <small>Ar</small>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="${pageContext.request.contextPath}/devis/details/${dev.id}" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.75rem;">Détails</a>
                                        <a href="${pageContext.request.contextPath}/devis/delete/${dev.id}" class="btn btn-danger" style="padding: 0.4rem 0.8rem; font-size: 0.75rem;" onclick="return confirm('Supprimer ce devis ?');">Supprimer</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Hidden data container for JS -->
    <div id="demandesData" style="display: none;">
        <c:forEach items="${demandes}" var="d">
            <span data-id="${d.id}" data-text="N°${d.id} - ${d.client.nom} (${d.lieu.nomLieu})"></span>
        </c:forEach>
    </div>

    <script>
        document.getElementById('dateDevis').valueAsDate = new Date();

        const rawDemandes = [];
        document.querySelectorAll('#demandesData span').forEach(el => {
            rawDemandes.push({
                id: el.getAttribute('data-id'),
                info: el.getAttribute('data-text')
            });
        });

        const searchInput = document.getElementById('demandeSearch');
        const hiddenInput = document.getElementById('demandeId');
        const suggestionsBox = document.getElementById('demandeSuggestions');

        if (searchInput && suggestionsBox) {
            searchInput.addEventListener('input', function() {
                const query = this.value.toLowerCase().trim();
                suggestionsBox.innerHTML = '';
                if (query.length === 0) {
                    suggestionsBox.style.display = 'none';
                    hiddenInput.value = '';
                    return;
                }
                const matches = rawDemandes.filter(d => d.info.toLowerCase().includes(query));
                if (matches.length > 0) {
                    matches.forEach(m => {
                        const item = document.createElement('div');
                        item.className = 'suggestion-item';
                        item.textContent = m.info;
                        item.addEventListener('click', () => {
                            searchInput.value = m.info;
                            hiddenInput.value = m.id;
                            suggestionsBox.style.display = 'none';
                        });
                        suggestionsBox.appendChild(item);
                    });
                    suggestionsBox.style.display = 'block';
                } else {
                    suggestionsBox.style.display = 'none';
                }
            });
            document.addEventListener('click', (e) => {
                if (!searchInput.contains(e.target) && !suggestionsBox.contains(e.target)) {
                    suggestionsBox.style.display = 'none';
                }
            });
        }

        function addRow() {
            const container = document.getElementById('detailsContainer');
            const newRow = document.createElement('div');
            newRow.className = 'detail-row';
            newRow.innerHTML = `
                <div class="form-group" style="margin-bottom: 0;">
                    <input type="text" name="libelles" placeholder="Désignation" required>
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <input type="number" step="0.01" name="prixUnitaire" placeholder="Prix Unitaire" required oninput="calculateTotal()" min="0">
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <input type="number" step="1" name="quantite" placeholder="Quantité" required oninput="calculateTotal()" min="0">
                </div>
                <button type="button" class="btn btn-danger" style="padding: 0.75rem; width: 44px; height: 44px;" onclick="removeRow(this)">×</button>
            `;
            container.appendChild(newRow);
            calculateTotal();
        }

        function removeRow(btn) {
            if(document.querySelectorAll('.detail-row').length > 1) {
                btn.closest('.detail-row').remove();
                calculateTotal();
            } else {
                alert('Un devis doit comporter au moins une ligne.');
            }
        }

        function calculateTotal() {
            const prixInputs = document.getElementsByName('prixUnitaire');
            const qteInputs = document.getElementsByName('quantite');
            let total = 0;
            for (let i = 0; i < prixInputs.length; i++) {
                let p = parseFloat(prixInputs[i].value) || 0;
                const q = parseFloat(qteInputs[i].value) || 0;
                
                // 10% discount if unit price >= 1,000,000 Ar
                if (p >= 1000000) {
                    p = p * 0.9;
                }
                
                total += (p * q);
            }
            document.getElementById('totalDisplay').innerText = total.toLocaleString('fr-FR', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });
        }
    </script>
</body>
</html>
