<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../include/header.jsp" />

<div class="container my-5">
    <div class="row">
        <div class="col-lg-8">
            <article>
                <header class="mb-4">
                    <span class="badge bg-primary mb-2">${tip.ingredientName}</span>
                    <h1 class="fw-bold">${tip.ingredientName} 활용 팁</h1>
                    <div class="text-muted mt-2">
                        <fmt:parseDate value="${tip.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="yyyy년 MM월 dd일" var="formattedDate" />
                        ${formattedDate}에 작성됨
                    </div>
                </header>
                
                <c:if test="${not empty tip.imageUrl}">
                    <figure class="mb-4">
                        <img class="img-fluid rounded" src="${tip.imageUrl}" alt="${tip.ingredientName}">
                    </figure>
                </c:if>
                
                <section class="mb-5 tip-content">
                    <h4>활용 방법</h4>
                    <p>${tip.tipContent}</p>
                    
                    <c:if test="${not empty tip.recipeSuggestion}">
                        <h4 class="mt-4">추천 레시피</h4>
                        <p>${tip.recipeSuggestion}</p>
                    </c:if>
                </section>
            </article>
            
            <div class="card bg-light mb-5">
                <div class="card-body">
                    <h5 class="card-title">이 팁이 도움이 되셨나요?</h5>
                    <p class="card-text">주변 사람들에게 공유하고 함께 유용한 식재료 활용 팁을 나눠보세요!</p>
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
                <div class="card-header">같은 재료 활용 팁</div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty relatedTips}">
                            <c:forEach items="${relatedTips}" var="relatedTip">
                                <div class="mb-3">
                                    <h6><a href="/tips/expiry/${relatedTip.id}" class="text-decoration-none">${relatedTip.ingredientName} 활용법</a></h6>
                                    <p class="text-truncate small text-muted">${relatedTip.tipContent}</p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">같은 재료를 활용한 다른 팁이 없습니다.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="card mb-4">
                <div class="card-header">나의 냉장고 체크</div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${isLoggedIn}">
                            <p>이 재료가 내 냉장고에 있나요?</p>
                            <a href="${pageContext.request.contextPath}/myRefrigerator" class="btn btn-outline-primary">내 냉장고 확인하기</a>
                        </c:when>
                        <c:otherwise>
                            <p>로그인하고 내 냉장고 재료를 관리해보세요!</p>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary">로그인하기</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <div class="mt-4">
        <a href="/tips/expiry" class="btn btn-outline-secondary">
            <i data-feather="arrow-left" class="me-1"></i> 유통기한 팁 목록으로 돌아가기
        </a>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();
        
        // 팁 내용에 줄바꿈 적용
        const tipContents = document.querySelectorAll('.tip-content p');
        tipContents.forEach(content => {
            content.innerHTML = content.textContent.replace(/\n/g, '<br>');
        });
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