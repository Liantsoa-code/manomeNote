<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Client - ${client.nom} | Forage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .client-header {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            padding: 2rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .client-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 20s infinite ease-in-out;
        }
        
        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(-30px, -30px) rotate(180deg); }
        }
        
        .client-info {
            position: relative;
            z-index: 1;
        }
        
        .client-name {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .client-phone {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: var(--text-muted);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .section-title::before {
            content: '';
            width: 4px;
            height: 24px;
            background: var(--primary);
            border-radius: 2px;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-muted);
            background: #f8fafc;
            border-radius: 12px;
            border: 2px dashed var(--border-color);
        }
        
        .empty-state-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        .badge-status {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            background: #eff6ff;
            color: #1e40af;
            border: 1px solid #bfdbfe;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }
        
        .back-link:hover {
            color: var(--primary);
        }
        
        .card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        .mini-table {
            font-size: 0.9rem;
        }
        
        .mini-table th {
            background: #f8fafc;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }
        
        .mini-table td {
            padding: 0.75rem;
        }
        
        .amount {
            font-weight: 600;
            color: #059669;
        }
        
        .date-badge {
            background: #f1f5f9;
            color: #64748b;
            padding: 0.25rem 0.5rem;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <header style="margin-bottom: 2rem;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div style="display: flex; gap: 1rem; align-items: center;">
                    <a href="${pageContext.request.contextPath}/" class="back-link">
                        <span>«</span> Retour au tableau de bord
                    </a>
                    <div style="display: flex; gap: 0.5rem; align-items: center; color: var(--text-muted); font-size: 0.9rem;">
                        <span>></span>
                        <a href="${pageContext.request.contextPath}/client/details/${client.id}" style="color: var(--primary); text-decoration: none;">
                            ${client.nom}
                        </a>
                    </div>
                </div>
                <nav style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Tableau de Bord</a>
                    <a href="${pageContext.request.contextPath}/devis" class="btn btn-secondary">Gestion des Devis</a>
                    <a href="${pageContext.request.contextPath}/status/change" class="btn btn-secondary">Changer Statuts</a>
                </nav>
            </div>
        </header>
        
        <div class="client-header">
            <div class="client-info">
                <h1 class="client-name">${client.nom}</h1>
                <div class="client-phone"> ${client.telephone}</div>
            </div>
        </div>
        
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-number">${demandes.size()}</div>
                <div class="stat-label">Demandes</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${devis.size()}</div>
                <div class="stat-label">Devis</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <fmt:formatNumber value="${devis.stream().map(d -> d.montantCalculé != null ? d.montantCalculé : 0).sum()}" type="currency" currencySymbol="Ar" />
                </div>
                <div class="stat-label">Montant Total</div>
            </div>
        </div>
        
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/demande/save?clientId=${client.id}" class="btn btn-primary">
                + Nouvelle Demande
            </a>
            <a href="${pageContext.request.contextPath}/devis/save?clientId=${client.id}" class="btn btn-secondary">
                + Nouveau Devis
            </a>
        </div>
        
        <!-- DEVIS SECTION - AFFICHÉ EN PREMIER -->
        <c:if test="${not empty devis}">
            <div class="card">
                <h2 class="section-title">Devis du Client</h2>
                <div class="table-responsive">
                    <table class="mini-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Type</th>
                                <th>Montant</th>
                                <th>Demande Associée</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${devis}" var="dev">
                                <tr>
                                    <td>
                                        <span class="date-badge">${dev.dateDevis}</span>
                                    </td>
                                    <td>
                                        <c:if test="${dev.typeDevis != null}">
                                            ${dev.typeDevis.nomTypeDevis}
                                        </c:if>
                                        <c:if test="${dev.typeDevis == null}">
                                            Standard
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="amount">
                                            <fmt:formatNumber value="${dev.montantCalculé}" type="currency" currencySymbol="Ar" />
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${dev.demande != null}">
                                            <a href="${pageContext.request.contextPath}/client/details/${client.id}?focus=demande-${dev.demande.id}" 
                                               class="btn btn-outline" 
                                               style="padding: 0.25rem 0.5rem; font-size: 0.75rem; text-decoration: none;">
                                                Voir demande
                                            </a>
                                        </c:if>
                                        <c:if test="${dev.demande == null}">
                                            <span style="color: var(--text-muted); font-size: 0.8rem;">Aucune</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="${pageContext.request.contextPath}/devis/details/${dev.id}" 
                                               class="btn btn-secondary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;">
                                                Détails
                                            </a>
                                            <a href="${pageContext.request.contextPath}/devis/delete/${dev.id}" 
                                               class="btn btn-danger" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;"
                                               onclick="return confirm('Supprimer ce devis ?');">
                                                Supprimer
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
        
        <c:if test="${empty devis}">
            <div class="card">
                <h2 class="section-title">Devis du Client</h2>
                <div class="empty-state">
                    <div class="empty-state-icon">:)</div>
                    <h3>Aucun devis</h3>
                    <p>Ce client n'a pas encore de devis enregistrés.</p>
                    <a href="${pageContext.request.contextPath}/devis/save?clientId=${client.id}" class="btn btn-primary">
                        + Créer le premier devis
                    </a>
                </div>
            </div>
        </c:if>
        
        <!-- DEMANDES SECTION - AFFICHÉE EN DEUXIÈME -->
        <c:if test="${not empty demandes}">
            <div class="card">
                <h2 class="section-title">Demandes du Client</h2>
                <div class="table-responsive">
                    <table class="mini-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Lieu / District</th>
                                <th>Statut</th>
                                <th>Devis Associés</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${demandes}" var="demande">
                                <tr id="demande-${demande.id}">
                                    <td>
                                        <span class="date-badge">${demande.dateDemande}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${demande.lieu != null}">
                                                <div>${demande.lieu.nomLieu}</div>
                                                <small style="color: var(--text-muted);">${demande.lieu.district.nomDistrict}</small>
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; flex-direction: column; gap: 4px;">
                                            <span class="badge-status">
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
                                        <c:set var="devisCount" value="0"/>
                                        <c:forEach items="${devis}" var="dev">
                                            <c:if test="${dev.demande != null and dev.demande.id == demande.id}">
                                                <c:set var="devisCount" value="${devisCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:choose>
                                            <c:when test="${devisCount > 0}">
                                                <a href="${pageContext.request.contextPath}/client/details/${client.id}?focus=devis" 
                                                   class="btn btn-outline" 
                                                   style="padding: 0.25rem 0.5rem; font-size: 0.75rem; text-decoration: none;">
                                                    ${devisCount} devis
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted); font-size: 0.8rem;">Aucun</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="${pageContext.request.contextPath}/status/change?demandeId=${demande.id}" 
                                               class="btn btn-secondary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;">
                                                Changer statut
                                            </a>
                                            <a href="${pageContext.request.contextPath}/demande/delete/${demande.id}" 
                                               class="btn btn-danger" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;"
                                               onclick="return confirm('Supprimer cette demande ?');">
                                                Supprimer
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
        
        <c:if test="${empty demandes}">
            <div class="card">
                <h2 class="section-title">Demandes du Client</h2>
                <div class="empty-state">
                    <div class="empty-state-icon">:)</div>
                    <h3>Aucune demande</h3>
                    <p>Ce client n'a pas encore de demandes enregistrées.</p>
                    <a href="${pageContext.request.contextPath}/demande/save?clientId=${client.id}" class="btn btn-primary">
                        + Créer la première demande
                    </a>
                </div>
            </div>
        </c:if>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Gérer le focus automatique basé sur le paramètre URL
            const urlParams = new URLSearchParams(window.location.search);
            const focus = urlParams.get('focus');
            
            if (focus) {
                setTimeout(() => {
                    if (focus === 'devis') {
                        // Scroller vers la section des devis
                        const devisSection = document.querySelector('h2.section-title');
                        if (devisSection && devisSection.textContent.includes('Devis du Client')) {
                            devisSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                            // Mettre en évidence la section
                            devisSection.parentElement.style.backgroundColor = '#f0f9ff';
                            setTimeout(() => {
                                devisSection.parentElement.style.backgroundColor = '';
                            }, 2000);
                        }
                    } else if (focus.startsWith('demande-')) {
                        // Scroller vers une demande spécifique
                        const demandeId = focus.replace('demande-', '');
                        const demandeElement = document.getElementById('demande-' + demandeId);
                        if (demandeElement) {
                            demandeElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            // Mettre en évidence la ligne
                            demandeElement.style.backgroundColor = '#fef3c7';
                            demandeElement.style.transition = 'background-color 0.3s ease';
                            setTimeout(() => {
                                demandeElement.style.backgroundColor = '';
                            }, 3000);
                        }
                    }
                }, 300);
            }
            
            // Ajouter des animations de hover pour les liens de navigation
            const navigationLinks = document.querySelectorAll('a[href*="focus="]');
            navigationLinks.forEach(link => {
                link.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.05)';
                });
                link.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
                });
            });
            
            // Améliorer l'accessibilité avec des tooltips
            const tooltips = document.querySelectorAll('[title]');
            tooltips.forEach(element => {
                element.style.position = 'relative';
                element.style.cursor = 'help';
            });
        });
    </script>
</body>
</html>
