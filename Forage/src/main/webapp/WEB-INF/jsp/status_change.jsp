<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Changer de Statut | Forage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-card { background: #f9fafb; border: 1px solid var(--border-color); border-radius: 12px; padding: 1.5rem; margin-bottom: 2rem; }
        .messages { margin-bottom: 1rem; }
        .message-success { background: #e6ffed; color: #1f5b24; padding: 0.9rem 1rem; border-radius: 8px; }
        .message-error { background: #ffe5e5; color: #811a1a; padding: 0.9rem 1rem; border-radius: 8px; }
        .history-table th, .history-table td { text-align: left; padding: 0.8rem; }
        .history-table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        .history-table th { background: #f3f4f6; }
        .history-table tr + tr { border-top: 1px solid var(--border-color); }
        .status-date { font-size: 0.85rem; color: var(--text-muted); white-space: nowrap; }
        .history-section { margin-top: 3rem; }
        .badge-status { padding: 4px 10px; border-radius: 20px; font-weight: 600; font-size: 0.8rem; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div>
                <h1>Changer les statuts</h1>
                <p style="color: var(--text-muted)">Sélectionnez une demande, choisissez un nouveau statut et saisissez une observation.</p>
            </div>
            <nav style="display: flex; gap: 10px;">
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Tableau de Bord</a>
                <a href="${pageContext.request.contextPath}/devis" class="btn btn-secondary">Gestion des Devis</a>
                <a href="${pageContext.request.contextPath}/status/change" class="btn btn-primary">Rafraîchir</a>
            </nav>
        </header>

        <div class="messages">
            <c:if test="${not empty successMessage}">
                <div class="message-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="message-error">${errorMessage}</div>
            </c:if>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/status/change" method="POST">
                <div class="form-group">
                    <label for="demandeId">Demande</label>
                    <select id="demandeId" name="demandeId" onchange="window.location.href='${pageContext.request.contextPath}/status/change?demandeId=' + this.value" required>
                        <option value="">-- Choisir une demande --</option>
                        <c:forEach items="${demandes}" var="demande">
                            <option value="${demande.id}" ${demande.id == selectedDemandeId ? 'selected' : ''}>
                                N°${demande.id} - ${demande.client.nom} (${demande.lieu.nomLieu})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="statutId">Nouveau statut</label>
                    <select id="statutId" name="statutId" required>
                        <option value="">-- Choisir un statut --</option>
                        <c:forEach items="${statuts}" var="statut">
                            <option value="${statut.id}">${statut.nomStatut}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="observation">Observation</label>
                    <textarea id="observation" name="observation" rows="4" placeholder="Raison du changement (ex : mise à jour par l'administrateur)"></textarea>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">Enregistrer le changement</button>
            </form>
        </div>

        <c:if test="${not empty statusHistory}">
            <div class="card history-section">
                <h2>Historique de la demande #${selectedDemandeId}</h2>
                <div style="overflow-x: auto;">
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>Date & Heure</th>
                                <th>Statut</th>
                                <th>Observation</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${statusHistory}" var="history">
                                <tr>
                                    <td class="status-date">
                                        ${history.formattedDate}
                                    </td>
                                    <td><span class="badge-status" style="background: #e0f2fe; color: #0369a1;">${history.statut.nomStatut}</span></td>
                                    <td><c:out value="${history.observation}" default="-"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <div class="card">
            <h2>Demandes et statuts actuels</h2>
            <div style="overflow-x: auto;">
                <table class="history-table">
                    <thead>
                        <tr>
                            <th>Demande</th>
                            <th>Client</th>
                            <th>Statut actuel</th>
                            <th>Date & Heure</th>
                            <th>Observation</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${demandes}" var="demande">
                            <tr>
                                <td>#${demande.id}</td>
                                <td>${demande.client.nom}</td>
                                <td><span class="badge-status" style="background: #f1f5f9; color: #475569;">${currentStatuses[demande.id]}</span></td>
                                <td class="status-date">
                                    <c:choose>
                                        <c:when test="${not empty latestStatusEntries[demande.id]}">
                                            ${latestStatusEntries[demande.id].formattedDate}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty latestStatusEntries[demande.id]}">
                                            <c:out value="${latestStatusEntries[demande.id].observation}" default="-"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><a href="${pageContext.request.contextPath}/status/change?demandeId=${demande.id}" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.75rem;">Voir/Modifier</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
