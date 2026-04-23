<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forage Dashboard | Système de Gestion</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .grid-layout { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 2rem; 
        }
        @media (max-width: 900px) { 
            .grid-layout { grid-template-columns: 1fr; } 
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .stat-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
            transition: all 0.3s ease;
            position: relative;
            cursor: default;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.12);
        }
        .stat-card h3 {
            font-size: 0.875rem;
            color: var(--text-muted);
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .stat-card .value {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary);
        }
        .stat-card .detail-popover {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 1rem;
            z-index: 100;
            opacity: 0;
            visibility: hidden;
            transition: all 0.2s ease;
            margin-top: 10px;
            border: 1px solid var(--border-color);
        }
        .stat-card:hover .detail-popover {
            opacity: 1;
            visibility: visible;
        }
        .popover-item {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            padding: 4px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .popover-item:last-child { border-bottom: none; }
        
        .progress-container {
            height: 8px;
            background: #e2e8f0;
            border-radius: 4px;
            overflow: hidden;
            margin-top: 4px;
        }
        .progress-bar {
            height: 100%;
            background: var(--primary);
            transition: width 0.5s ease-out;
        }
        
        .revenue-comparison {
            margin-top: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.75rem;
            color: var(--text-muted);
        }
        .revenue-comparison-bar {
            flex-grow: 1;
            height: 4px;
            background: #e2e8f0;
            border-radius: 2px;
            position: relative;
        }
        .revenue-comparison-fill {
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            background: #059669;
            border-radius: 2px;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .stat-card { animation: slideUp 0.4s ease-out both; }
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }

        .form-section { 
            background: #f8fafc; 
            padding: 1.5rem; 
            border-radius: 8px; 
            border: 1px dashed var(--border-color); 
            margin-bottom: 2rem; 
        }
        .badge-status {
            display: inline-block;
            padding: 0.25rem 0.6rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div>
                <h1>Système Forage</h1>
                <p style="color: var(--text-muted)">Gestion des projets et suivi des demandes</p>
            </div>
            <nav style="display: flex; gap: 10px;">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Tableau de Bord</a>
                <a href="${pageContext.request.contextPath}/devis" class="btn btn-secondary">Gestion des Devis</a>
                <a href="${pageContext.request.contextPath}/status/change" class="btn btn-secondary">Changer Statuts</a>
            </nav>
        </header>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Chiffre d'Affaire</h3>
                <div class="value">
                    <fmt:formatNumber value="${totalRawRevenue}" type="currency" currencySymbol="Ar" />
                </div>
            </div>
            
            <div class="stat-card">
                <h3>CA Prévisionnel</h3>
                <div class="value" style="color: #059669;">
                    <fmt:formatNumber value="${totalForecastedRevenue}" type="currency" currencySymbol="Ar" />
                </div>
                <div class="revenue-comparison">
                    <div class="revenue-comparison-bar">
                        <div class="revenue-comparison-fill" style="width: ${totalRawRevenue > 0 ? (totalForecastedRevenue / totalRawRevenue * 100) : 0}%"></div>
                    </div>
                    <span><fmt:formatNumber value="${totalRawRevenue > 0 ? (totalForecastedRevenue / totalRawRevenue * 100) : 0}" maxFractionDigits="0" />% du total</span>
                </div>
            </div>
            
            <div class="stat-card">
                <h3>Clients</h3>
                <div class="value">${clientCount}</div>
                <div class="detail-popover">
                    <strong style="display: block; margin-bottom: 8px; font-size: 0.8rem;">Détails Clients</strong>
                    <c:forEach items="${clients}" var="c" varStatus="loop">
                        <c:if test="${loop.index < 8}">
                            <div class="popover-item">
                                <a href="${pageContext.request.contextPath}/client/details/${c.id}" 
                                   style="color: inherit; text-decoration: none; flex: 1;"
                                   onmouseover="this.style.textDecoration='underline'; this.style.color='var(--primary)';"
                                   onmouseout="this.style.textDecoration='none'; this.style.color='inherit';">
                                    ${c.nom}
                                </a>
                                <span style="font-weight: 600; color: var(--primary);"><span style="font-size: 0.7rem; color: var(--text-muted); font-weight: 400;">ID:</span> ${c.id}</span>
                            </div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${clientCount > 8}">
                        <div style="text-align: center; margin-top: 8px; font-size: 0.75rem; color: var(--text-muted);">+ ${clientCount - 8} autres clients</div>
                    </c:if>
                </div>
            </div>
            
            <div class="stat-card">
                <h3>États des Demandes</h3>
                <div class="value">${demandes.size()}</div>
                <div class="detail-popover" style="width: 250px;">
                    <strong style="display: block; margin-bottom: 12px; font-size: 0.8rem;">Répartition par Statut</strong>
                    <c:forEach items="${statusDistribution}" var="entry">
                        <div style="margin-bottom: 10px;">
                            <div class="popover-item" style="border: none; padding-bottom: 0;">
                                <span style="font-size: 0.8rem;">${entry.key}</span>
                                <span style="font-weight: 700; font-size: 0.8rem;">${entry.value}</span>
                            </div>
                            <div class="progress-container">
                                <div class="progress-bar" style="width: ${demandes.size() > 0 ? (entry.value * 100 / demandes.size()) : 0}%"></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="grid-layout">
            <!-- CARTE CLIENTS -->
            <div class="card">
                <h2>
                    <span>Clients</span>
                    <button class="btn btn-primary" style="padding: 0.5rem 1rem;" onclick="toggleForm('clientForm')">+ Nouveau</button>
                </h2>

                <div id="clientForm" class="form-section" style="display: none;">
                    <form action="${pageContext.request.contextPath}/client/save" method="POST">
                        <div class="form-group">
                            <label for="nomClient">Nom du Client</label>
                            <input type="text" id="nomClient" name="nom" placeholder="Ex: Jean Dupont" required>
                        </div>
                        <div class="form-group">
                            <label for="telephoneClient">Téléphone</label>
                            <input type="text" id="telephoneClient" name="telephone" placeholder="Ex: 034 12..." required>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%">Enregistrer le Client</button>
                    </form>
                </div>

                <div style="overflow-x: auto;">
                    <table>
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Téléphone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${clients}" var="client">
                                <tr>
                                    <td style="font-weight: 600;">
                                        <a href="${pageContext.request.contextPath}/client/details/${client.id}" 
                                           style="color: var(--primary); text-decoration: none; transition: color 0.2s ease;"
                                           onmouseover="this.style.color='#2563eb'; this.style.textDecoration='underline';"
                                           onmouseout="this.style.color='var(--primary)'; this.style.textDecoration='none';">
                                            ${client.nom}
                                        </a>
                                    </td>
                                    <td style="color: var(--text-muted);">${client.telephone}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/client/details/${client.id}" 
                                           class="btn btn-secondary" 
                                           style="padding: 0.4rem 0.8rem; font-size: 0.75rem; margin-right: 0.5rem;">
                                            Détails
                                        </a>
                                        <a href="${pageContext.request.contextPath}/client/delete/${client.id}" 
                                           class="btn btn-danger" 
                                           style="padding: 0.4rem 0.8rem; font-size: 0.75rem;" 
                                           onclick="return confirm('Supprimer ce client ?');">
                                            Supprimer
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- CARTE DEMANDES -->
            <div class="card">
                <h2>
                    <span>Demandes</span>
                    <button class="btn btn-primary" style="padding: 0.5rem 1rem;" onclick="toggleForm('demandeForm')">+ Nouvelle</button>
                </h2>

                <div id="demandeForm" class="form-section" style="display: none;">
                    <form action="${pageContext.request.contextPath}/demande/save" method="POST">
                        <div class="form-group">
                            <label for="clientSearch">Client</label>
                            <div class="autocomplete-container">
                                <input type="text" id="clientSearch" class="autocomplete-input" placeholder="Rechercher un client..." autocomplete="off" required>
                                <input type="hidden" name="clientId" id="clientId" required>
                                <div id="clientSuggestions" class="suggestions-list" style="display: none;"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="lieuId">Lieu (District)</label>
                            <select name="lieuId" id="lieuId" required>
                                <option value="">-- Sélectionner un lieu --</option>
                                <c:forEach items="${lieus}" var="l">
                                    <option value="${l.id}">${l.nomLieu} (${l.district.nomDistrict})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="dateInput">Date</label>
                            <input type="date" name="dateDemande" id="dateInput" required>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%">Enregistrer la Demande</button>
                    </form>
                </div>

                <div style="overflow-x: auto;">
                    <table>
                        <thead>
                            <tr>
                                <th>Client</th>
                                <th>Lieu / District</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${demandes}" var="demande">
                                <tr>
                                    <td>
                                        <span style="font-weight: 500;">${demande.client != null ? demande.client.nom : 'Détaché'}</span><br>
                                        <small style="color: var(--text-muted);">${demande.dateDemande}</small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${demande.lieu != null}">
                                                <span>${demande.lieu.nomLieu}</span><br>
                                                <small style="color: var(--text-muted); font-size: 0.75rem;">${demande.lieu.district.nomDistrict}</small>
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; flex-direction: column; gap: 4px;">
                                            <span class="badge" style="background-color: #eff6ff; color: var(--primary); width: fit-content;">
                                                ${statusEntries[demande.id] != null ? statusEntries[demande.id].statut.nomStatut : 'N/A'}
                                            </span>
                                            <c:if test="${statusEntries[demande.id] != null}">
                                                <small style="color: var(--text-muted); font-size: 0.7rem;">
                                                    ${statusEntries[demande.id].formattedDate}
                                                </small>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/demande/delete/${demande.id}" class="btn btn-danger" style="padding: 0.4rem 0.8rem; font-size: 0.75rem;" onclick="return confirm('Confirmer la suppression ?');">Supprimer</a>
                                        <a href="${pageContext.request.contextPath}/status/change?demandeId=${demande.id}" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.75rem;">Changer statut</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 4rem; padding-top: 2rem; border-top: 1px solid var(--border-color);">
            <div style="font-size: 2rem; font-weight: 900; color: var(--border-color); letter-spacing: 0.5rem; margin-bottom: 0.5rem;">ETU3623</div>
        </div>
    </div>

    <!-- Hidden data container for JS -->
    <div id="clientsData" style="display: none;">
        <c:forEach items="${clients}" var="c">
            <span data-id="${c.id}" data-nom="<c:out value='${c.nom}'/>"></span>
        </c:forEach>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            window.toggleForm = function(id) {
                const el = document.getElementById(id);
                if (el) {
                    el.style.display = (el.style.display === 'none' || el.style.display === '') ? 'block' : 'none';
                }
            };

            const dateInput = document.getElementById('dateInput');
            if (dateInput) { dateInput.valueAsDate = new Date(); }

            const rawClients = [];
            document.querySelectorAll('#clientsData span').forEach(el => {
                rawClients.push({
                    id: el.getAttribute('data-id'),
                    nom: el.getAttribute('data-nom')
                });
            });

            const searchInput = document.getElementById('clientSearch');
            const hiddenInput = document.getElementById('clientId');
            const suggestionsBox = document.getElementById('clientSuggestions');

            if (searchInput && suggestionsBox) {
                searchInput.addEventListener('input', function() {
                    const query = this.value.toLowerCase().trim();
                    suggestionsBox.innerHTML = '';
                    if (query.length === 0) {
                        suggestionsBox.style.display = 'none';
                        hiddenInput.value = '';
                        return;
                    }
                    const matches = rawClients.filter(c => c.nom.toLowerCase().includes(query));
                    if (matches.length > 0) {
                        matches.forEach(m => {
                            const item = document.createElement('div');
                            item.className = 'suggestion-item';
                            item.innerHTML = m.nom;
                            item.addEventListener('click', () => {
                                searchInput.value = m.nom;
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
        });
    </script>
</body>
</html>
