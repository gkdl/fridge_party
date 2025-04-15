<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../include/header.jsp" />

<div class="container my-5">
    <div class="row">
        <div class="col-lg-8">
            <article>
                <header class="mb-4">
                    <h1 class="fw-bold">${tip.title}</h1>
                    <c:if test="${not empty tip.category}">
                        <span class="badge bg-primary">${tip.category}</span>
                    </c:if>
                    <div class="text-muted mt-2">
                        <fmt:parseDate value="${tip.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="yyyy년 MM월 dd일" var="formattedDate" />
                        ${formattedDate}에 작성됨
                    </div>
                </header>
                
                <c:if test="${not empty tip.imageUrl}">
                    <figure class="mb-4">
                        <img class="img-fluid rounded" src="${tip.imageUrl}" alt="${tip.title}">
                    </figure>
                </c:if>
                
                <section class="mb-5 tip-content">
                    <p>${tip.content}</p>
                </section>
            </article>
            
            <div class="card bg-light mb-5">
                <div class="card-body">
                    <h5 class="card-title">이 팁이 도움이 되셨나요?</h5>
                    <p class="card-text">주변 사람들에게 공유하고 함께 유용한 요리 팁을 나눠보세요!</p>
                    <div class="d-flex">
                        <button class="btn btn-outline-primary me-2" onclick="shareFacebook()">
                            <i data-feather="facebook"></i> 페이스북
                        </button>
                        <button class="btn btn-outline-primary me-2" onclick="shareTwitter()">
                            <i data-feather="twitter"></i> 트위터
                        </button>
                        <button class="btn btn-outline-primary" onclick="copyLink()">
                            <i data-feather="link"></i> 링크 복사
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card mb-4">
                <div class="card-header">관련 요리 팁</div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty relatedTips}">
                            <c:forEach items="${relatedTips}" var="relatedTip">
                                <div class="mb-3">
                                    <h6><a href="/tips/cooking/${relatedTip.id}" class="text-decoration-none">${relatedTip.title}</a></h6>
                                    <p class="text-truncate small text-muted">${relatedTip.content}</p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">관련 요리 팁이 없습니다.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="card mb-4">
                <div class="card-header">카테고리</div>
                <div class="card-body">
                    <div class="d-flex flex-column">
                        <a href="/tips/cooking" class="text-decoration-none mb-2">전체</a>
                        <a href="/tips/cooking?category=조리법" class="text-decoration-none mb-2">조리법</a>
                        <a href="/tips/cooking?category=도구" class="text-decoration-none mb-2">도구</a>
                        <a href="/tips/cooking?category=재료준비" class="text-decoration-none mb-2">재료준비</a>
                        <a href="/tips/cooking?category=보관법" class="text-decoration-none">보관법</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="mt-4">
        <a href="/tips/cooking" class="btn btn-outline-secondary">
            <i data-feather="arrow-left" class="me-1"></i> 요리 팁 목록으로 돌아가기
        </a>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();
        
        // 팁 내용에 줄바꿈 적용
        const tipContent = document.querySelector('.tip-content p');
        if (tipContent) {
            tipContent.innerHTML = tipContent.textContent.replace(/\n/g, '<br>');
        }
    });
    
    // 공유 기능
    function shareFacebook() {
        const url = encodeURIComponent(window.location.href);
        const title = encodeURIComponent(document.title);
        window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}&t=${title}`, 
            'facebook-share-dialog', 'width=800,height=600');
    }
    
    function shareTwitter() {
        const url = encodeURIComponent(window.location.href);
        const title = encodeURIComponent(document.title);
        window.open(`https://twitter.com/intent/tweet?url=${url}&text=${title}`, 
            'twitter-share-dialog', 'width=800,height=600');
    }
    
    function copyLink() {
        navigator.clipboard.writeText(window.location.href)
            .then(() => {
                alert('링크가 클립보드에 복사되었습니다!');
            })
            .catch(err => {
                console.error('링크 복사 실패:', err);
                alert('링크 복사에 실패했습니다. 수동으로 URL을 복사해주세요.');
            });
    }
</script>

<jsp:include page="../include/footer.jsp" />