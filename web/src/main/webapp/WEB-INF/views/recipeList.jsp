<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<div class="recipe-list-container">
    <div class="row mb-4">
        <div class="col-md-6">
            <h2>레시피 목록</h2>
            <p class="text-muted">
                <c:choose>
                    <c:when test="${not empty query}">
                        "${query}" 검색 결과
                    </c:when>
                    <c:otherwise>
                        다양한 레시피를 찾아보세요
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        <div class="col-md-6">
            <div class="recipe-filter-options d-flex justify-content-end align-items-center">
                <button class="btn btn-outline-primary me-2" data-bs-toggle="modal" data-bs-target="#filterModal">
                    <i data-feather="filter"></i> 필터
                </button>
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i data-feather="arrow-down"></i> 정렬
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="sortDropdown">
                        <li><a class="dropdown-item" href="#" data-sort="newest">최신순</a></li>
                        <li><a class="dropdown-item" href="#" data-sort="popular">인기순</a></li>
                        <li><a class="dropdown-item" href="#" data-sort="rating">평점순</a></li>
                        <li><a class="dropdown-item" href="#" data-sort="time">조리시간순</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-12">
            <div id="recipeList" class="row row-cols-1 row-cols-md-3 g-4">
                <c:choose>
                    <c:when test="${empty recipes}">
                        <div class="col-12 text-center py-5">
                            <i data-feather="book" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                            <h5 class="text-muted">레시피가 없습니다</h5>
                            <c:choose>
                                <c:when test="${not empty query}">
                                    <p class="text-muted">"${query}"에 대한 검색 결과가 없습니다.</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">다른 조건으로 검색해 보세요.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${recipes}" var="recipe">
                            <div class="col">
                                <div class="card h-100 shadow-sm">
                                    <c:choose>
                                        <c:when test="${not empty recipe.images && recipe.images.size() > 0}">
                                            <img src="${recipe.images[0].imageUrl}" class="card-img-top recipe-thumbnail">
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
                                        <div class="recipe-ingredients-preview">
                                            <small class="text-muted">
                                                <i data-feather="list" class="feather-small"></i> 
                                                <c:forEach items="${recipe.ingredients}" var="ingredient" varStatus="status">
                                                    ${ingredient.name}<c:if test="${not status.last}">, </c:if>
                                                </c:forEach>
                                            </small>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent d-flex justify-content-between align-items-center">
                                        <a href="/recipes/${recipe.id}" class="btn btn-sm btn-outline-primary">레시피 보기</a>
                                        <c:if test="${cookie.token != null}">
                                            <button class="btn btn-sm btn-outline-danger favorite-btn" data-recipe-id="${recipe.id}" data-is-favorite="${recipe.isFavorite}">
                                                <c:choose>
                                                    <c:when test="${recipe.favorite}">
                                                        <i data-feather="heart" class="text-danger filled-heart"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i data-feather="heart" class="empty-heart"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-5">
                    <ul class="pagination justify-content-center">

                        <!-- 맨 처음 페이지로 이동 -->
                        <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                            <c:url var="firstPageUrl" value="/recipes">
                                <c:param name="page" value="0" />
                                <c:if test="${not empty query}">
                                    <c:param name="query" value="${query}" />
                                </c:if>
                            </c:url>
                            <a class="page-link" href="${firstPageUrl}" aria-label="First">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>

                        <!-- 중간 페이지 목록 -->
                        <c:set var="startPage" value="${currentPage - 5}" />
                        <c:set var="endPage" value="${currentPage + 5}" />
                        <c:if test="${startPage < 0}">
                            <c:set var="startPage" value="0" />
                        </c:if>
                        <c:if test="${endPage >= totalPages}">
                            <c:set var="endPage" value="${totalPages - 1}" />
                        </c:if>

                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <c:url var="pageUrl" value="/recipes">
                                    <c:param name="page" value="${i}" />
                                    <c:if test="${not empty query}">
                                        <c:param name="query" value="${query}" />
                                    </c:if>
                                </c:url>
                                <a class="page-link" href="${pageUrl}">${i + 1}</a>
                            </li>
                        </c:forEach>

                        <!-- 맨 마지막 페이지로 이동 -->
                        <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                            <c:url var="lastPageUrl" value="/recipes">
                                <c:param name="page" value="${totalPages - 1}" />
                                <c:if test="${not empty query}">
                                    <c:param name="query" value="${query}" />
                                </c:if>
                            </c:url>
                            <a class="page-link" href="${lastPageUrl}" aria-label="Last">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>

<!-- 필터 모달 -->
<div class="modal fade" id="filterModal" tabindex="-1" aria-labelledby="filterModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="filterModalLabel">레시피 필터</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="filterForm">
                    <div class="mb-3">
                        <label class="form-label">카테고리</label>
                        <div class="d-flex flex-wrap gap-2">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="한식" id="category1" name="category">
                                <label class="form-check-label" for="category1">한식</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="양식" id="category2" name="category">
                                <label class="form-check-label" for="category2">양식</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="중식" id="category3" name="category">
                                <label class="form-check-label" for="category3">중식</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="일식" id="category4" name="category">
                                <label class="form-check-label" for="category4">일식</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="분식" id="category5" name="category">
                                <label class="form-check-label" for="category5">분식</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="기타" id="category6" name="category">
                                <label class="form-check-label" for="category6">기타</label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">조리 시간</label>
                        <div class="d-flex flex-wrap gap-2">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" value="15" id="time1" name="cookingTime">
                                <label class="form-check-label" for="time1">15분 이내</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" value="30" id="time2" name="cookingTime">
                                <label class="form-check-label" for="time2">30분 이내</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" value="60" id="time3" name="cookingTime">
                                <label class="form-check-label" for="time3">1시간 이내</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" value="0" id="timeAll" name="cookingTime" checked>
                                <label class="form-check-label" for="timeAll">전체</label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="ingredientFilter" class="form-label">재료로 검색</label>
                        <input type="text" class="form-control" id="ingredientFilter" placeholder="재료명 입력" autocomplete="off">
                        <div id="ingredientSuggestions" class="list-group d-none position-absolute"></div>
                        <div id="selectedIngredients" class="selected-ingredients mt-2"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="applyFilterBtn">적용하기</button>
            </div>
        </div>
    </div>
</div>

<script src="/resources/js/recipe.js"></script>


<jsp:include page="include/footer.jsp" />
<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();

        // 즐겨찾기 버튼 이벤트
        $('.favorite-btn').click(function() {
            const recipeId = $(this).data('recipe-id');
            const isFavorite = $(this).data('is-favorite');
            const $button = $(this);

            toggleFavorite(recipeId, isFavorite, $button);
        });

        // 정렬 옵션 이벤트
        $('.dropdown-item[data-sort]').click(function(e) {
            e.preventDefault();
            const sortBy = $(this).data('sort');

            // 현재 URL에서 쿼리 파라미터 가져오기
            const urlParams = new URLSearchParams(window.location.search);

            // 정렬 파라미터 설정
            urlParams.set('sort', sortBy);

            // 페이지는 첫 페이지로 리셋
            urlParams.set('page', 0);

            // 페이지 이동
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        });

        // 필터 적용 버튼 이벤트
        $('#applyFilterBtn').click(function() {
            const urlParams = new URLSearchParams(window.location.search);

            // 카테고리 필터
            const categories = [];
            $('input[name="category"]:checked').each(function() {
                categories.push($(this).val());
            });

            if (categories.length > 0) {
                urlParams.set('category', categories.join(','));
            } else {
                urlParams.delete('category');
            }

            // 조리시간 필터
            const cookingTime = $('input[name="cookingTime"]:checked').val();
            if (cookingTime > 0) {
                urlParams.set('cookingTime', cookingTime);
            } else {
                urlParams.delete('cookingTime');
            }

            // 재료 필터
            const selectedIngredients = [];
            $('.selected-ingredient').each(function() {
                selectedIngredients.push($(this).data('id'));
            });

            if (selectedIngredients.length > 0) {
                urlParams.set('ingredientIds', selectedIngredients.join(','));
            } else {
                urlParams.delete('ingredientIds');
            }

            // 페이지는 첫 페이지로 리셋
            urlParams.set('page', 0);

            // 모달 닫기 및 페이지 이동
            $('#filterModal').modal('hide');
            window.location.href = window.location.pathname + '?' + urlParams.toString();
        });

        // 재료 검색 자동완성
        $('#ingredientFilter').on('input', function() {
            const query = $(this).val().trim();
            if (query.length < 2) {
                $('#ingredientSuggestions').addClass('d-none');
                return;
            }

            $.ajax({
                url: '/api/ingredients/search?query=' + query,
                type: 'GET',
                success: function(data) {
                    let suggestionsHtml = '';

                    if (data.length === 0) {
                        suggestionsHtml = '<div class="list-group-item">검색 결과가 없습니다.</div>';
                    } else {
                        data.forEach(function(ingredient) {
                            suggestionsHtml += `
                                <div class="list-group-item ingredient-suggestion" data-id="${ingredient.id}" data-name="${ingredient.name}">
                                    ${ingredient.name}
                                </div>
                            `;
                        });
                    }

                    $('#ingredientSuggestions').html(suggestionsHtml).removeClass('d-none');
                },
                error: function(error) {
                    console.error('Failed to search ingredients', error);
                    $('#ingredientSuggestions').addClass('d-none');
                }
            });
        });

        // 재료 추천 클릭 이벤트
        $(document).on('click', '.ingredient-suggestion', function() {
            const id = $(this).data('id');
            const name = $(this).data('name');

            // 이미 선택된 재료인지 확인
            if ($('.selected-ingredient[data-id="' + id + '"]').length === 0) {
                const ingredientTag = `
                    <span class="badge bg-primary me-2 mb-2 selected-ingredient" data-id="${id}">
                        ${name} <i class="feather-x remove-ingredient" data-id="${id}"></i>
                    </span>
                `;

                $('#selectedIngredients').append(ingredientTag);
                feather.replace();
            }

            // 입력창 초기화 및 추천 목록 숨기기
            $('#ingredientFilter').val('');
            $('#ingredientSuggestions').addClass('d-none');
        });

        // 선택된 재료 삭제 이벤트
        $(document).on('click', '.remove-ingredient', function(e) {
            e.stopPropagation();
            $(this).parent().remove();
        });

        // 모달이 열릴 때 현재 필터 상태 적용
        $('#filterModal').on('show.bs.modal', function() {
            const urlParams = new URLSearchParams(window.location.search);

            // 카테고리 필터 상태 적용
            const categories = urlParams.get('category');
            if (categories) {
                const categoryArray = categories.split(',');
                categoryArray.forEach(function(category) {
                    $('input[name="category"][value="' + category + '"]').prop('checked', true);
                });
            }

            // 조리시간 필터 상태 적용
            const cookingTime = urlParams.get('cookingTime');
            if (cookingTime) {
                $('input[name="cookingTime"][value="' + cookingTime + '"]').prop('checked', true);
            } else {
                $('#timeAll').prop('checked', true);
            }

            // 재료 필터 상태 적용
            const ingredientIds = urlParams.get('ingredientIds');
            if (ingredientIds) {
                const idArray = ingredientIds.split(',');

                // 각 재료 ID로 재료 정보 조회 및 표시
                idArray.forEach(function(id) {
                    $.ajax({
                        url: '/api/ingredients/' + id,
                        type: 'GET',
                        success: function(ingredient) {
                            const ingredientTag = `
                                <span class="badge bg-primary me-2 mb-2 selected-ingredient" data-id="${ingredient.id}">
                                    ${ingredient.name} <i class="feather-x remove-ingredient" data-id="${ingredient.id}"></i>
                                </span>
                            `;

                            $('#selectedIngredients').append(ingredientTag);
                            feather.replace();
                        },
                        error: function(error) {
                            console.error('Failed to get ingredient info', error);
                        }
                    });
                });
            }
        });
    });

    // 즐겨찾기 토글 함수
    function toggleFavorite(recipeId, isFavorite, $button) {
        $.ajax({
            url: '/api/recipes/' + recipeId + '/favorite',
            type: 'POST',
            success: function(response) {
                if (response.isFavorite) {
                    $button.attr('data-is-favorite', true);
                    $button.html('<i data-feather="heart" class="text-danger filled-heart"></i>');
                } else {
                    $button.attr('data-is-favorite', false);
                    $button.html('<i data-feather="heart" class="empty-heart"></i>');
                }
                feather.replace();

                // 즐겨찾기 추가 활동 기록
                if (typeof recordFavoriteActivity === 'function') {
                    recordFavoriteActivity(recipeId, true);
                }
            },
            error: function(error) {
                console.error('Failed to toggle favorite', error);
                alert('즐겨찾기 등록/해제 중 오류가 발생했습니다.');
            }
        });
    }
</script>

<jsp:include page="include/footer.jsp" />