<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chiffre d'Affaires</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <div>
                <h1>Statistiques</h1>
            </div>
            <a href="${pageContext.request.contextPath}/devis" class="btn btn-secondary">
                Retour
            </a>
        </header>

        <div class="card">
            <div class="stats-container">
                <div class="stats-label">Chiffre d'affaires prévisionnel total</div>
                <div class="stats-value">
                    <fmt:formatNumber value="${ca_previsionnel}" type="number" />
                    <span class="stats-currency">Ar</span>
                </div>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 2rem;">
        </div>
    </div>
</body>
</html>
