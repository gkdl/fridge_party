<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<div class="my-favorites-container">
    <div class="row mb-4">
        <div class="col-md-8">
            <h2>내 즐겨찾기</h2>
            <p class="text-muted">즐겨찾기한 레시피를 모아볼 수 있습니다</p>
        </div>
        <div class="col-md-4 text-md-end">
            <div class="dropdown">
                <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <i data-feather="arrow-down"></i> 정렬
                </button>
                <ul class="dropdown-menu" aria-labelledby="sortDropdown">
                    <li><a class="dropdown-item" href="#" data-sort="newest">최신순</a></li>
                    <li><a class="dropdown-item" href="#" data-sort="popular">인기순</a></li>
                    <li><a class="dropdown-item" href="#" data-sort="rating">평점순</a></li>
                </ul>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-12">
            <div id="favoritesList" class="row row-cols-1 row-cols-md-3 g-4">
                <c:choose>
                    <c:when test="${empty recipes}">
                        <div class="col-12 text-center py-5">
                            <i data-feather="heart" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                            <h5 class="text-muted">즐겨찾기한 레시피가 없습니다</h5>
                            <p class="text-muted">마음에 드는 레시피를 발견하면 즐겨찾기에 추가해보세요!</p>
                            <a href="/recipes" class="btn btn-primary mt-3">레시피 둘러보기</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${recipes}" var="recipe">
                            <div class="col">
                                <div class="card h-100 shadow-sm">
                                    <c:choose>
                                        <c:when test="${not empty recipe.imageUrl}">
                                            <img src="${recipe.imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-camera text-secondary">
                                                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                                    <circle cx="12" cy="13" r="4"></circle>
                                                </svg>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-body">
                                        <h5 class="card-title">${recipe.title}</h5>
                                        <p class="text-muted">by ${recipe.username}</p>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="rating">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <c:choose>
                                                        <c:when test="${star <= recipe.avgRating}">
                                                            <i data-feather="star" class="text-warning filled-star"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i data-feather="star" class="text-muted empty-star"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <small class="text-muted">(${recipe.ratingCount})</small>
                                            </div>
                                            <small class="text-muted">${recipe.cookingTime}분</small>
                                        </div>
                                        <p class="card-text mt-2">${recipe.description}</p>
                                    </div>
                                    <div class="card-footer bg-transparent d-flex justify-content-between align-items-center">
                                        <a href="/recipes/${recipe.id}" class="btn btn-sm btn-outline-primary">레시피 보기</a>
                                        <button class="btn btn-sm btn-outline-danger remove-favorite" data-recipe-id="${recipe.id}">
                                            <i data-feather="trash-2"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="/resources/js/recipe.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();
        
        // 즐겨찾기 삭제 버튼 이벤트
        $('.remove-favorite').click(function() {
            if (confirm('이 레시피를 즐겨찾기에서 삭제하시겠습니까?')) {
                const recipeId = $(this).data('recipe-id');
                const $card = $(this).closest('.col');
                
                $.ajax({
                    url: '/api/recipes/' + recipeId + '/favorite',
                    type: 'POST',
                    success: function(response) {
                        // 애니메이션과 함께 카드 제거
                        $card.fadeOut(300, function() {
                            $(this).remove();
                            
                            // 남은 레시피가 없는 경우 빈 메시지 표시
                            if ($('#favoritesList .col').length === 0) {
                                const emptyMessage = `
                                    <div class="col-12 text-center py-5">
                                        <i data-feather="heart" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                                        <h5 class="text-muted">즐겨찾기한 레시피가 없습니다</h5>
                                        <p class="text-muted">마음에 드는 레시피를 발견하면 즐겨찾기에 추가해보세요!</p>
                                        <a href="/recipes" class="btn btn-primary mt-3">레시피 둘러보기</a>
                                    </div>
                                `;
                                $('#favoritesList').html(emptyMessage);
                                feather.replace();
                            }
                        });
                    },
                    error: function(error) {
                        console.error('Failed to remove favorite', error);
                        alert('즐겨찾기 삭제에 실패했습니다.');
                    }
                });
            }
        });
        
        // 정렬 옵션 이벤트
        $('.dropdown-item[data-sort]').click(function(e) {
            e.preventDefault();
            const sortBy = $(this).data('sort');
            
            // 현재 URL에서 쿼리 파라미터 가져오기
            const urlParams = new URLSearchParams(window.location.search);
            
            // 정렬 파라미터 설정
            urlParams.set('sort', sortBy);
            
            // 페이지 이동
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        });
    });
</script>

<jsp:include page="include/footer.jsp" />
