<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../include/header.jsp" />

<div class="container my-5">
    <div class="mb-5">
        <h1 class="fw-bold">요리 팁 <c:if test="${category != '전체'}"><small class="text-muted"> - ${category}</small></c:if></h1>
        <p class="lead text-muted">맛있는 요리를 위한 유용한 정보를 확인해보세요.</p>
    </div>
    
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="d-flex">
                <a href="/tips/cooking" class="btn btn-sm ${category == '전체' ? 'btn-primary' : 'btn-outline-primary'} me-2">전체</a>
                <a href="/tips/cooking?category=조리법" class="btn btn-sm ${category == '조리법' ? 'btn-primary' : 'btn-outline-primary'} me-2">조리법</a>
                <a href="/tips/cooking?category=도구" class="btn btn-sm ${category == '도구' ? 'btn-primary' : 'btn-outline-primary'} me-2">도구</a>
                <a href="/tips/cooking?category=재료준비" class="btn btn-sm ${category == '재료준비' ? 'btn-primary' : 'btn-outline-primary'} me-2">재료준비</a>
                <a href="/tips/cooking?category=보관법" class="btn btn-sm ${category == '보관법' ? 'btn-primary' : 'btn-outline-primary'}">보관법</a>
            </div>
        </div>
    </div>
    
    <div class="row">
        <c:forEach items="${tips}" var="tip">
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm">
                    <c:choose>
                        <c:when test="${not empty tip.imageUrl}">
                            <img src="${tip.imageUrl}" class="card-img-top" alt="${tip.title}">
                        </c:when>
                        <c:otherwise>
                            <div class="card-img-top bg-light text-center py-5">
                                <i data-feather="book-open" style="width: 48px; height: 48px;" class="text-secondary"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body">
                        <c:if test="${not empty tip.category}">
                            <span class="badge bg-primary mb-2">${tip.category}</span>
                        </c:if>
                        <h5 class="card-title">${tip.title}</h5>
                        <p class="card-text text-truncate">${tip.content}</p>
                    </div>
                    <div class="card-footer bg-transparent border-0">
                        <a href="/tips/cooking/${tip.id}" class="btn btn-sm btn-outline-primary stretched-link">자세히 보기</a>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty tips}">
            <div class="col-12">
                <div class="alert alert-info">
                    <c:choose>
                        <c:when test="${category != '전체'}">
                            해당 카테고리에 등록된 요리 팁이 없습니다.
                        </c:when>
                        <c:otherwise>
                            등록된 요리 팁이 없습니다.
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