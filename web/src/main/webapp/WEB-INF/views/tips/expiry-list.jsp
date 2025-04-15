<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../include/header.jsp" />

<div class="container my-5">
    <div class="mb-5">
        <h1 class="fw-bold">유통기한 임박 식재료 활용 팁</h1>
        <p class="lead text-muted">버리기 아까운 식재료를 활용해 맛있는 음식을 만들어보세요!</p>
    </div>
    
    <div class="row mb-4">
        <div class="col-md-6">
            <form action="/tips/expiry" method="get" class="d-flex">
                <input type="text" name="query" class="form-control me-2" placeholder="식재료명으로 검색" value="${searchQuery}">
                <button type="submit" class="btn btn-primary">검색</button>
            </form>
        </div>
    </div>
    
    <div class="row">
        <c:forEach items="${tips}" var="tip">
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm">
                    <c:choose>
                        <c:when test="${not empty tip.imageUrl}">
                            <img src="${tip.imageUrl}" class="card-img-top" alt="${tip.ingredientName}">
                        </c:when>
                        <c:otherwise>
                            <div class="card-img-top bg-light text-center py-5">
                                <i data-feather="clock" style="width: 48px; height: 48px;" class="text-secondary"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body">
                        <span class="badge bg-primary mb-2">${tip.ingredientName}</span>
                        <h5 class="card-title">${tip.ingredientName} 활용법</h5>
                        <p class="card-text text-truncate">${tip.tipContent}</p>
                    </div>
                    <div class="card-footer bg-transparent border-0">
                        <a href="/tips/expiry/${tip.id}" class="btn btn-sm btn-outline-primary stretched-link">자세히 보기</a>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty tips}">
            <div class="col-12">
                <div class="alert alert-info">
                    <c:choose>
                        <c:when test="${not empty searchQuery}">
                            '${searchQuery}'에 대한 검색 결과가 없습니다.
                        </c:when>
                        <c:otherwise>
                            등록된 유통기한 임박 식재료 활용 팁이 없습니다.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>
    
    <div class="mt-4">
        <a href="/tips" class="btn btn-outline-secondary">
            <i data-feather="arrow-left" class="me-1"></i> 팁 메인으로 돌아가기
        </a>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();
    });
</script>

<jsp:include page="../include/footer.jsp" />