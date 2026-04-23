<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détails du Devis #${devis.id}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .detail-header { border-bottom: 2px solid #1a73e8; margin-bottom: 20px; padding-bottom: 10px; }
        .meta-info { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .total-row { font-size: 1.4rem; font-weight: bold; text-align: right; margin-top: 20px; color: #2e7d32; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Détails du Devis #${devis.id}</h1>
            <a href="${pageContext.request.contextPath}/devis" class="btn btn-secondary">← Retour à la liste</a>
        </header>

        <div class="card">
            <div class="detail-header">
                <h2>Informations Générales</h2>
            </div>
            <div class="meta-info">
                <div>
                    <p><strong>Type:</strong> ${devis.typeDevis != null ? devis.typeDevis.nomTypeDevis : 'Non spécifié'}</p>
                    <p><strong>Date:</strong> ${devis.dateDevis}</p>
                </div>
                <div>
                    <p><strong>Client:</strong> ${devis.demande != null ? devis.demande.client.nom : 'Inconnu'}</p>
                    <p><strong>Lieu du projet:</strong> 
                        <c:choose>
                            <c:when test="${devis.demande != null && devis.demande.lieu != null}">
                                ${devis.demande.lieu.nomLieu} (${devis.demande.lieu.district.nomDistrict})
                            </c:when>
                            <c:otherwise>N/A</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <h3>Lignes du Devis</h3>
            <table>
                <thead>
                    <tr>
                        <th>Désignation</th>
                        <th style="text-align: right;">Prix Unitaire</th>
                        <th style="text-align: center;">Quantité</th>
                        <th style="text-align: right;">Total</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${details}" var="line">
                        <c:set var="isRemise" value="${line.prixUnitaire >= 1000000}" />
                        <c:set var="prixFinal" value="${isRemise ? line.prixUnitaire * 0.9 : line.prixUnitaire}" />
                        <tr>
                            <td>
                                ${line.libelle}
                                <c:if test="${isRemise}">
                                    <span class="badge badge-success" style="font-size: 0.7rem; vertical-align: middle; margin-left: 5px; background-color: #2e7d32; color: white; padding: 2px 6px; border-radius: 10px;">-10% Remise</span>
                                </c:if>
                            </td>
                            <td style="text-align: right;">
                                <c:if test="${isRemise}">
                                    <span style="text-decoration: line-through; color: #757575; font-size: 0.9rem;"><fmt:formatNumber value="${line.prixUnitaire}" type="number" /></span><br/>
                                </c:if>
                                <fmt:formatNumber value="${prixFinal}" type="number" /> Ar
                            </td>
                            <td style="text-align: center;">${line.quantite}</td>
                            <td style="text-align: right; font-weight: 600;">
                                <fmt:formatNumber value="${prixFinal * line.quantite}" type="number" /> Ar
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="total-row">
                Montant total du devis: <fmt:formatNumber value="${total}" type="number" /> Ar
            </div>
        </div>
        
        <div style="margin-top: 20px; display: flex; gap: 10px;">
            <form action="${pageContext.request.contextPath}/devis/delete/${devis.id}" method="GET" onsubmit="return confirm('Confirmer la suppression ?');">
                <button type="submit" class="btn btn-danger">Supprimer ce Devis</button>
            </form>
        </div>
    </div>
</body>
</html>
