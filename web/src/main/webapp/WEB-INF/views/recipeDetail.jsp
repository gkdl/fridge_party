<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="include/header.jsp" />

<style>
    .recipe-step {
        margin-bottom: 2rem;
        border-radius: 0.8rem;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .recipe-step:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    }

    .step-number {
        flex-shrink: 0;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #4CAF50;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 1.2rem;
        box-shadow: 0 2px 5px rgba(0,0,0,0.15);
    }

    .step-content {
        flex-grow: 1;
    }

    .step-title {
        font-size: 1.3rem;
        font-weight: 600;
        color: #333;
        margin-bottom: 0.75rem;
        border-bottom: 2px solid #eee;
        padding-bottom: 0.5rem;
    }

    .step-description {
        font-size: 1.05rem;
        line-height: 1.6;
        color: #444;
    }

    .step-image-container {
        overflow: hidden;
        border-radius: 0.5rem;
        box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }

    .step-image {
        width: 100%;
        max-height: 350px;
        object-fit: cover;
        border-radius: 0.5rem;
        transition: transform 0.4s ease;
    }

    .step-image:hover {
        transform: scale(1.03);
    }

    .cooking-instructions {
        font-size: 1.05rem;
        line-height: 1.6;
    }

    .instructions-list {
        padding-left: 1.5rem;
    }
</style>
<div class="recipe-detail-container">
    <div class="row mb-4">
        <div class="col-md-8">
            <h2>${recipe.title}</h2>
            <p class="text-muted">by ${recipe.username}</p>
        </div>
        <div class="col-md-4 text-md-end">
            <div class="d-flex justify-content-md-end align-items-center">
                <div class="rating-stars me-3">
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
                    <span class="text-muted">(${recipe.ratingCount})</span>
                </div>

                <!-- 로그인한 경우 즐겨찾기 버튼 표시 -->
                <c:if test="${isLoggedIn}">
                    <div class="btn-group">
                        <button class="btn btn-outline-danger favorite-btn" data-recipe-id="${recipe.id}" data-is-favorite="${recipe.isFavorite}">
                            <c:choose>
                                <c:when test="${recipe.isFavorite}">
                                    <i data-feather="heart" class="text-danger filled-heart"></i> 즐겨찾기 해제
                                </c:when>
                                <c:otherwise>
                                    <i data-feather="heart" class="empty-heart"></i> 즐겨찾기 추가
                                </c:otherwise>
                            </c:choose>
                        </button>
                        <button class="btn btn-outline-success cook-complete-btn" data-recipe-id="${recipe.id}">
                            <i data-feather="check-circle"></i> 요리 완료
                        </button>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm mb-4">
                <!-- 이미지 슬라이더 -->
                <div id="recipeImageCarousel" class="carousel slide" data-bs-ride="carousel">
                    <div class="carousel-indicators">
                        <!-- 메인 이미지 + 추가 이미지가 있는 경우 -->
                        <c:if test="${not empty recipe.imageUrl || not empty recipe.images}">
                            <!-- 대표 이미지 인디케이터 -->
                            <button type="button" data-bs-target="#recipeImageCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>

                            <!-- 추가 이미지 인디케이터 -->
                            <c:if test="${not empty recipe.images}">
                                <c:forEach items="${recipe.images}" var="image" varStatus="status">
                                    <button type="button" data-bs-target="#recipeImageCarousel" data-bs-slide-to="${status.index + 1}" aria-label="Slide ${status.index + 2}"></button>
                                </c:forEach>
                            </c:if>
                        </c:if>
                    </div>

                    <div class="carousel-inner">
                        <!-- 이미지가 하나도 없는 경우 -->
                        <c:if test="${empty recipe.imageUrl && empty recipe.images}">
                            <div class="carousel-item active">
                                <div class="card-img-top recipe-detail-image-placeholder d-flex align-items-center justify-content-center bg-light">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-camera text-secondary">
                                        <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                        <circle cx="12" cy="13" r="4"></circle>
                                    </svg>
                                </div>
                            </div>
                        </c:if>

                        <!-- 대표 이미지 -->
                        <c:if test="${not empty recipe.imageUrl}">
                            <div class="carousel-item active">
                                <img src="${recipe.imageUrl}" class="d-block w-100 recipe-detail-image" alt="${recipe.title}">
                                <div class="carousel-caption d-none d-md-block">
                                    <h5>대표 이미지</h5>
                                </div>
                            </div>
                        </c:if>

                        <!-- 추가 이미지 -->
                        <c:if test="${not empty recipe.images}">
                            <c:forEach items="${recipe.images}" var="image" varStatus="status">
                                <div class="carousel-item ${empty recipe.imageUrl && status.index == 0 ? 'active' : ''}">
                                    <img src="${image.imageUrl}" class="d-block w-100 recipe-detail-image" alt="${not empty image.description ? image.description : recipe.title}">
                                    <c:if test="${not empty image.description}">
                                        <div class="carousel-caption d-none d-md-block">
                                            <p>${image.description}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>

                    <!-- 이미지가 2개 이상인 경우에만 컨트롤 표시 -->
                    <c:if test="${(not empty recipe.imageUrl && not empty recipe.images) || (empty recipe.imageUrl && not empty recipe.images && recipe.images.size() > 1)}">
                        <button class="carousel-control-prev" type="button" data-bs-target="#recipeImageCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Previous</span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#recipeImageCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Next</span>
                        </button>
                    </c:if>
                </div>
                <div class="card-body">
                    <p class="card-text">${recipe.description}</p>

                    <div class="recipe-info mb-4">
                        <div class="row">
                            <div class="col-6 col-md-3 text-center">
                                <div class="recipe-info-icon">
                                    <i data-feather="clock"></i>
                                </div>
                                <h6>조리 시간</h6>
                                <p>${recipe.cookingTime != null ? recipe.cookingTime : '정보 없음'} ${recipe.cookingTime != null ? '분' : ''}</p>
                            </div>
                            <div class="col-6 col-md-3 text-center">
                                <div class="recipe-info-icon">
                                    <i data-feather="users"></i>
                                </div>
                                <h6>인분</h6>
                                <p>${recipe.servingSize != null ? recipe.servingSize : '정보 없음'} ${recipe.servingSize != null ? '인분' : ''}</p>
                            </div>
                            <div class="col-6 col-md-3 text-center">
                                <div class="recipe-info-icon">
                                    <i data-feather="star"></i>
                                </div>
                                <h6>평점</h6>
                                <p>${recipe.avgRating != null ? recipe.avgRating : '0'}/5</p>
                            </div>
                            <div class="col-6 col-md-3 text-center">
                                <div class="recipe-info-icon">
                                    <i data-feather="heart"></i>
                                </div>
                                <h6>즐겨찾기</h6>
                                <p>${recipe.favoriteCount != null ? recipe.favoriteCount : '0'}</p>
                            </div>
                        </div>
                    </div>

                    <h5 class="card-title">재료</h5>
                    <ul class="list-group list-group-flush ingredients-list mb-4">
                        <c:forEach items="${recipe.ingredients}" var="ingredient">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span>${ingredient.name}</span>
                                <span class="text-muted">${ingredient.quantity} ${ingredient.unit}</span>
                            </li>
                        </c:forEach>
                    </ul>

                    <h5 class="card-title">조리 방법</h5>
                    <!-- 단계별 조리법이 있는 경우 -->
                    <div class="steps-container mb-4">
                        <c:forEach items="${recipe.steps}" var="step">
                            <div class="recipe-step card mb-4">
                                <div class="card-body">
                                    <div class="d-flex align-items-start">
                                        <div class="step-number me-3">${step.stepNumber}</div>
                                        <div class="step-content flex-grow-1">
                                            <h5 class="step-title">Step ${step.stepNumber}</h5>
                                            <p class="step-description">${step.description}</p>
                                            <c:if test="${not empty step.imageUrl}">
                                                <div class="step-image-container mt-3">
                                                    <img src="${step.imageUrl}" class="step-image img-fluid rounded" alt="조리 단계 이미지">
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <!-- 작성자인 경우 편집/삭제 버튼 표시 -->
                    <c:if test="${isLoggedIn && recipe.userId eq userId}">
                        <div class="d-flex justify-content-end">
                            <a href="/editRecipe/${recipe.id}" class="btn btn-outline-primary me-2">수정</a>
                            <button class="btn btn-outline-danger" id="deleteRecipeBtn" data-recipe-id="${recipe.id}">삭제</button>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 평점 및 리뷰 섹션 -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0">평점 및 리뷰</h5>
                </div>
                <div class="card-body">
                    <c:if test="${isLoggedIn}">
                        <div class="rating-form mb-4">
                            <h6>평점 남기기</h6>
                            <form id="ratingForm">
                                <div class="mb-3">
                                    <div class="rating-input">
                                        <c:forEach begin="1" end="5" var="star">
                                            <span class="rating-star" data-value="${star}">
                                                <i data-feather="star" class="rating-star-icon"></i>
                                            </span>
                                        </c:forEach>
                                        <span class="ms-2 selected-rating">0/5</span>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <textarea class="form-control" id="ratingComment" rows="3" placeholder="리뷰를 작성해주세요 (선택사항)"></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">평점 남기기</button>
                            </form>
                        </div>
                    </c:if>

                    <div class="ratings-list">
                        <h6>리뷰 (${recipe.ratingCount})</h6>
                        <div id="ratingsContainer">
                            <!-- 평점 목록은 AJAX로 로드 -->
                            <div class="text-center py-3">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <!-- 유사한 레시피 추천 -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0">유사한 레시피</h5>
                </div>
                <div class="card-body">
                    <div id="similarRecipes">
                        <div class="text-center py-3">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 냉장고 재료 체크리스트 -->
            <c:if test="${isLoggedIn}">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">내 냉장고 재료</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted">이 레시피에 필요한 재료 중 내 냉장고에 있는 재료</p>
                        <div id="refrigeratorIngredients">
                            <div class="text-center py-3">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- 작성자의 다른 레시피 -->
            <div class="card shadow-sm">
                <div class="card-header bg-light">
                    <h5 class="mb-0">${recipe.username}님의 다른 레시피</h5>
                </div>
                <div class="card-body">
                    <div id="authorOtherRecipes">
                        <div class="text-center py-3">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/recipe.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();

        // 레시피 조회 활동 기록
        const recipeId = ${recipe.id};
        recordViewActivity(recipeId);

        // 이미지 캐러셀 초기화
        new bootstrap.Carousel(document.querySelector('#recipeImageCarousel'));

        // 평점 선택 이벤트
        $('.rating-star').click(function() {
            const value = $(this).data('value');
            $('.selected-rating').text(value + '/5');

            // 별점 시각적 표시
            $('.rating-star').each(function(index) {
                if (index < value) {
                    $(this).find('svg').addClass('text-warning');
                } else {
                    $(this).find('svg').removeClass('text-warning');
                }
            });

            // 선택된 평점 저장
            $(this).closest('form').data('rating', value);
        });

        // 평점 제출
        $('#ratingForm').submit(function(e) {
            e.preventDefault();

            const rating = $(this).data('rating');
            if (!rating) {
                alert('평점을 선택해주세요.');
                return;
            }

            const comment = $('#ratingComment').val();

            $.ajax({
                url: '/api/recipes/' + recipeId + '/rate',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    rating: rating,
                    comment: comment
                }),
                success: function(response) {
                    alert('평점이 등록되었습니다.');
                    // 페이지 새로고침
                    window.location.reload();
                },
                error: function(error) {
                    console.error('Failed to rate recipe', error);
                    alert('평점 등록에 실패했습니다.');
                }
            });
        });

        // 즐겨찾기 버튼 이벤트
        $('.favorite-btn').click(function() {
            const recipeId = $(this).data('recipe-id');
            const isFavorite = $(this).data('is-favorite');
            const $button = $(this);

            toggleFavorite(recipeId, isFavorite, $button);
        });

        // 레시피 삭제 이벤트
        $('#deleteRecipeBtn').click(function() {
            if (confirm('정말 이 레시피를 삭제하시겠습니까?')) {
                const recipeId = $(this).data('recipe-id');

                $.ajax({
                    url: '/api/recipes/' + recipeId,
                    type: 'DELETE',
                    success: function(response) {
                        alert('레시피가 삭제되었습니다.');
                        window.location.href = '/myRecipes';
                    },
                    error: function(error) {
                        console.error('Failed to delete recipe', error);
                        alert('레시피 삭제에 실패했습니다.');
                    }
                });
            }
        });

        // 평점 목록 로드
        loadRatings(recipeId);

        // 유사한 레시피 로드
        loadSimilarRecipes(recipeId);

        // 작성자의 다른 레시피 로드
        loadAuthorOtherRecipes(${recipe.userId}, recipeId);

        // 로그인한 경우 냉장고 재료 체크
        <c:if test="${isLoggedIn}">
            loadRefrigeratorIngredients(recipeId);

            // 요리 완료 버튼 이벤트
            $('.cook-complete-btn').click(function() {
                if (confirm('이 레시피로 요리를 완료하셨나요? 추천 시스템에 반영됩니다.')) {
                    // 요리 완료 활동 기록
                    recordCookActivity(recipeId);
                    alert('요리 완료가 기록되었습니다!');
                }
            });
        </c:if>
    });

    // 평점 목록 로드 함수
    function loadRatings(recipeId) {
        $.ajax({
            url: '/api/recipes/' + recipeId + '/ratings',
            type: 'GET',
            success: function(response) {
                let ratingsHtml = '';

                if (response.content.length === 0) {
                    ratingsHtml = '<p class="text-center text-muted">아직 리뷰가 없습니다.</p>';
                } else {
                    response.forEach(function(rating) {
                        let starsHtml = '';
                        for (let i = 1; i <= 5; i++) {
                            if (i <= rating.rating) {
                                starsHtml += '<i data-feather="star" class="text-warning filled-star"></i>';
                            } else {
                                starsHtml += '<i data-feather="star" class="text-muted empty-star"></i>';
                            }
                        }

                        ratingsHtml += `
                            <div class="card mb-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div>
                                            <strong>${rating.username}</strong>
                                            <div class="rating-stars">
                                                ${starsHtml}
                                            </div>
                                        </div>
                                        <%--<small class="text-muted">${formatDate(rating.createdAt)}</small>--%>
                                    </div>
                                    <p class="card-text">${rating.comment || '코멘트 없음'}</p>
                                </div>
                            </div>
                        `;
                    });
                }

                $('#ratingsContainer').html(ratingsHtml);
                feather.replace();
            },
            error: function(error) {
                console.error('Failed to load ratings', error);
                $('#ratingsContainer').html('<p class="text-center text-danger">리뷰를 불러오는데 실패했습니다.</p>');
            }
        });
    }

    // 유사한 레시피 로드 함수
    function loadSimilarRecipes(recipeId) {
        $.ajax({
            url: '/api/recipes/'+ recipeId +'/similar?count=3',
            type: 'GET',
            success: function(response) {
                let recipesHtml = '';

                if (response.length === 0) {
                    recipesHtml = '<p class="text-center text-muted">유사한 레시피가 없습니다.</p>';
                } else {
                    response.forEach(function(recipe) {
                        const imageHtml = recipe.imageUrl
                            ? `<img src="${recipe.imageUrl}" class="img-fluid rounded-start" alt="${recipe.title}">`
                                        : `<div class="img-fluid rounded-start bg-light d-flex align-items-center justify-content-center" style="height: 100%;">
                                <i data-feather="camera" class="text-secondary"></i>
                           </div>`;

                        recipesHtml +=
                            '<div class="card mb-3">' +
                                '<div class="row g-0">' +
                                    '<div class="col-4">' +
                                        imageHtml +
                                    '</div>' +
                                    '<div class="col-8">' +
                                        '<div class="card-body p-2">' +
                                            '<h6 class="card-title">' + recipe.title + '</h6>' +
                                            '<div class="small rating-stars">' +
                                                generateStarRating(recipe.avgRating) +
                                                '<span class="text-muted">(' + recipe.ratingCount + ')</span>' +
                                            '</div>' +
                                            '<a href="/recipes/' + recipe.id + '" class="stretched-link"></a>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>';
                    });
                }

                $('#similarRecipes').html(recipesHtml);
                feather.replace();
            },
            error: function(error) {
                console.error('Failed to load similar recipes', error);
                $('#similarRecipes').html('<p class="text-center text-danger">레시피를 불러오는데 실패했습니다.</p>');
            }
        });
    }

    // 작성자의 다른 레시피 로드 함수
    function loadAuthorOtherRecipes(userId, currentRecipeId) {
        $.ajax({
            url: '/api/recipes/user/' + userId + '?count=3&exclude=' + currentRecipeId,
            type: 'GET',
            success: function(response) {
                let recipesHtml = '';
                if (response.length === 0) {
                    recipesHtml = '<p class="text-center text-muted">다른 레시피가 없습니다.</p>';
                } else {
                    response.forEach(function(recipe) {
                        const imageHtml = recipe.imageUrl
                            ? `<img src="${recipe.imageUrl}" class="img-fluid rounded-start" alt="${recipe.title}">`
                            : `<div class="img-fluid rounded-start bg-light d-flex align-items-center justify-content-center" style="height: 100%;">
                                    <i data-feather="camera" class="text-secondary"></i>
                               </div>`;

                        recipesHtml +=
                            '<div class="card mb-3">' +
                                '<div class="row g-0">' +
                                    '<div class="col-4">' +
                                        imageHtml +
                                    '</div>' +
                                    '<div class="col-8">' +
                                        '<div class="card-body p-2">' +
                                            '<h6 class="card-title">' + recipe.title + '</h6>' +
                                            '<div class="small rating-stars">' +
                                                generateStarRating(recipe.avgRating) +
                                                '<span class="text-muted">(' + recipe.ratingCount + ')</span>' +
                                            '</div>' +
                                            '<a href="/recipes/' + recipe.id + '" class="stretched-link"></a>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>';
                    });
                }

                $('#authorOtherRecipes').html(recipesHtml);
                feather.replace();
            },
            error: function(error) {
                console.error('Failed to load author\'s other recipes', error);
                $('#authorOtherRecipes').html('<p class="text-center text-danger">레시피를 불러오는데 실패했습니다.</p>');
            }
        });
    }

    // 냉장고 재료 체크 함수
    function loadRefrigeratorIngredients(recipeId) {
        $.ajax({
            url: '/api/user/ingredients',
            type: 'GET',
            success: function(userIngredients) {
                // 레시피 재료 이름 목록 가져오기
                const recipeIngredients = [];
                <c:forEach items="${recipe.ingredients}" var="ingredient">
                    recipeIngredients.push({
                        id: ${ingredient.ingredientId},
                        name: "${ingredient.name}",
                        quantity: ${ingredient.quantity},
                        unit: "${ingredient.unit}"
                    });
                </c:forEach>

                // 냉장고 재료와 레시피 재료 비교
                let ingredientsHtml = '<ul class="list-group list-group-flush">';

                recipeIngredients.forEach(function(recipeIng) {
                    // 냉장고에 해당 재료가 있는지 확인
                    const hasIngredient = userIngredients.some(function(userIng) {
                        return userIng.ingredientId === recipeIng.id;
                    });
                    ingredientsHtml +=
                        '<li class="list-group-item d-flex justify-content-between align-items-center">' +
                        '<span>' + recipeIng.name + '</span>' +
                        '<span>' +
                            (hasIngredient
                                ? '<span class="badge bg-success rounded-pill">있음</span>'
                                : '<span class="badge bg-danger rounded-pill">없음</span>') +
                        '</span>' +
                    '</li>';
                });

                ingredientsHtml += '</ul>';
                $('#refrigeratorIngredients').html(ingredientsHtml);
            },
            error: function(error) {
                console.error('Failed to load user ingredients', error);
                $('#refrigeratorIngredients').html('<p class="text-center text-danger">냉장고 재료를 불러오는데 실패했습니다.</p>');
            }
        });
    }

    // 즐겨찾기 토글 함수
    function toggleFavorite(recipeId, isFavorite, $button) {
        $.ajax({
            url: '/api/recipes/' + recipeId + '/favorite',
            type: 'POST',
            success: function(response) {
                if (response.isFavorite) {
                    $button.data('is-favorite', true);
                    $button.html('<i data-feather="heart" class="text-danger filled-heart"></i> 즐겨찾기 해제');
                } else {
                    $button.data('is-favorite', false);
                    $button.html('<i data-feather="heart" class="empty-heart"></i> 즐겨찾기 추가');
                }
                feather.replace();
            },
            error: function(error) {
                console.error('Failed to toggle favorite', error);
                alert('즐겨찾기 등록/해제 중 오류가 발생했습니다.');
            }
        });
    }

    // 평점 별 생성 함수
    function generateStarRating(rating) {
        let stars = '';
        for (let i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars += '<i data-feather="star" class="text-warning filled-star"></i>';
            } else {
                stars += '<i data-feather="star" class="text-muted empty-star"></i>';
            }
        }
        return stars;
    }

    // 날짜 형식 변환 함수
    function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('ko-KR', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }
</script>

<jsp:include page="include/footer.jsp" />
