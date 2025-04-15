<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../include/header.jsp" />

<div class="container my-5">
    <div class="text-center mb-5">
        <h1 class="display-5 fw-bold">요리 & 식재료 활용 팁</h1>
        <p class="lead text-muted">맛있는 요리를 위한 팁과 유통기한 임박 식재료 활용법을 확인해보세요.</p>
    </div>
    
    <!-- 요리 팁 섹션 -->
    <section class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>요리 팁</h2>
            <a href="/tips/cooking" class="btn btn-outline-primary">더 보기</a>
        </div>
        
        <div class="row">
            <c:forEach items="${cookingTips}" var="tip">
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
                            <h5 class="card-title">${tip.title}</h5>
                            <p class="card-text text-truncate">${tip.content}</p>
                        </div>
                        <div class="card-footer bg-transparent border-0">
                            <a href="/tips/cooking/${tip.id}" class="btn btn-sm btn-outline-primary stretched-link">자세히 보기</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty cookingTips}">
                <div class="col-12">
                    <div class="alert alert-info">
                        등록된 요리 팁이 없습니다.
                    </div>
                </div>
            </c:if>
        </div>
    </section>
    
    <!-- 유통기한 임박 식재료 활용 팁 섹션 -->
    <section>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>유통기한 임박 식재료 활용 팁</h2>
            <a href="/tips/expiry" class="btn btn-outline-primary">더 보기</a>
        </div>
        
        <div class="row">
            <c:forEach items="${expiryTips}" var="tip">
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
            
            <c:if test="${empty expiryTips}">
                <div class="col-12">
                    <div class="alert alert-info">
                        등록된 유통기한 활용 팁이 없습니다.
                    </div>
                </div>
            </c:if>
        </div>
    </section>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();
    });
</script>

<jsp:include page="../include/footer.jsp" />