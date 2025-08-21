<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<div class="my-recipes-container">
    <div class="row mb-4">
        <div class="col-md-6">
            <h2>내가 등록한 레시피</h2>
            <p class="text-muted">나만의 특별한 레시피 목록입니다.</p>
        </div>
        <div class="col-md-6 text-md-end">
            <a href="/addRecipe" class="btn btn-primary">
                <i data-feather="plus"></i> 레시피 등록
            </a>
        </div>
    </div>

    <!-- 계절별 필터 -->
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <h5 class="mb-3">계절별 레시피 필터</h5>
                    <div class="d-flex flex-wrap gap-2">
                        <button class="btn btn-outline-primary season-filter active" data-season="ALL">
                            전체
                        </button>
                        <button class="btn btn-outline-success season-filter" data-season="SPRING">
                            <i data-feather="sun" class="me-1" style="width: 16px; height: 16px;"></i>
                            봄
                        </button>
                        <button class="btn btn-outline-danger season-filter" data-season="SUMMER">
                            <i data-feather="cloud-rain" class="me-1" style="width: 16px; height: 16px;"></i>
                            여름
                        </button>
                        <button class="btn btn-outline-warning season-filter" data-season="FALL">
                            <i data-feather="cloud" class="me-1" style="width: 16px; height: 16px;"></i>
                            가을
                        </button>
                        <button class="btn btn-outline-info season-filter" data-season="WINTER">
                            <i data-feather="cloud-snow" class="me-1" style="width: 16px; height: 16px;"></i>
                            겨울
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="card shadow-sm">
                <div class="card-body">
                    <!-- 결과 정보 -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <span class="badge bg-primary rounded-pill me-2">총 ${totalCount}개</span>
                            <c:if test="${not empty currentSeason}">
                                <span class="badge bg-success rounded-pill">${currentSeason}철 레시피: ${seasonalCount}개</span>
                            </c:if>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i data-feather="filter" class="me-1" style="width: 14px; height: 14px;"></i>
                                정렬
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="sortDropdown">
                                <li><a class="dropdown-item sort-option" href="#" data-sort="newest">최신순</a></li>
                                <li><a class="dropdown-item sort-option" href="#" data-sort="oldest">오래된순</a></li>
                                <li><a class="dropdown-item sort-option" href="#" data-sort="popular">인기순</a></li>
                                <li><a class="dropdown-item sort-option" href="#" data-sort="rating">평점순</a></li>
                            </ul>
                        </div>
                    </div>

                    <div id="recipeList" class="row row-cols-1 row-cols-md-3 g-4">
                        <c:choose>
                            <c:when test="${empty recipes}">
                                <div class="col-12 text-center py-5">
                                    <i data-feather="clipboard" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                                    <h5 class="text-muted">아직 등록한 레시피가 없습니다</h5>
                                    <p class="text-muted">새로운 레시피를 등록해보세요!</p>
                                    <a href="/addRecipe" class="btn btn-primary mt-3">
                                        <i data-feather="plus" class="me-1" style="width: 16px; height: 16px;"></i>
                                        첫 레시피 등록하기
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${recipes}" var="recipe">
                                    <div class="col recipe-item" data-season="${recipe.season}">
                                        <div class="card h-100 shadow-hover">
                                            <div class="position-relative">
                                                <c:choose>
                                                    <c:when test="${not empty recipe.images && recipe.images.size() > 0}">
                                                        <img src="${recipe.images[0].imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.images[0].description}" style="height: 180px; object-fit: cover;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light" style="height: 180px;">
                                                            <i data-feather="image" class="text-secondary" style="width: 40px; height: 40px;"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:if test="${not empty recipe.season}">
                                                    <span class="position-absolute top-0 end-0 m-2">
                                                        <span class="badge rounded-pill px-2 py-1 ${recipe.season eq 'SPRING' ? 'bg-success' : recipe.season eq 'SUMMER' ? 'bg-danger' : recipe.season eq 'FALL' ? 'bg-warning text-dark' : 'bg-info'}">
                                                            <i data-feather="${recipe.season eq 'SPRING' ? 'sun' : recipe.season eq 'SUMMER' ? 'cloud-rain' : recipe.season eq 'FALL' ? 'cloud' : 'cloud-snow'}" style="width: 14px; height: 14px;"></i>
                                                            ${recipe.season eq 'SPRING' ? '봄' : recipe.season eq 'SUMMER' ? '여름' : recipe.season eq 'FALL' ? '가을' : '겨울'}
                                                        </span>
                                                    </span>
                                                </c:if>
                                            </div>
                                            <div class="card-body">
                                                <h5 class="card-title">${recipe.title}</h5>
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <div class="rating">
                                                        <c:forEach begin="1" end="5" varStatus="loop">
                                                            <i data-feather="star" class="${loop.index <= recipe.avgRating ? 'text-warning' : 'text-muted'}"
                                                               style="width: 16px; height: 16px;"></i>
                                                        </c:forEach>
                                                        <small class="text-muted">(${recipe.ratingCount})</small>
                                                    </div>
                                                    <small class="text-muted">조회 ${recipe.viewCount}</small>
                                                </div>
                                                <p class="card-text small text-truncate">${recipe.description}</p>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="text-muted small">
                                                        <i data-feather="clock" style="width: 14px; height: 14px;"></i>
                                                        ${recipe.cookingTime}분
                                                    </span>
                                                    <span class="text-muted small">
                                                        <i data-feather="users" style="width: 14px; height: 14px;"></i>
                                                        ${recipe.servingSize}인분
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="card-footer bg-transparent border-top-0">
                                                <div class="d-flex justify-content-between">
                                                    <button onclick="goToPage('/recipes/${recipe.id}')" class="btn btn-sm btn-outline-primary">
                                                        <i data-feather="eye" style="width: 14px; height: 14px;"></i>보기
                                                    </button>
                                                    <div class="d-flex ml-auto">
                                                        <button onclick="goToPage('/editRecipe/${recipe.id}')" class="btn btn-sm btn-outline-secondary me-2">
                                                            <i data-feather="edit-2" style="width: 14px; height: 14px;"></i>수정
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-danger delete-recipe" data-id="${recipe.id}">
                                                            <i data-feather="trash-2" style="width: 14px; height: 14px;"></i>삭제
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 페이지네이션 -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 레시피 삭제 확인 모달 -->
<div class="modal fade" id="deleteRecipeModal" tabindex="-1" aria-labelledby="deleteRecipeModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteRecipeModalLabel">레시피 삭제</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>정말로 이 레시피를 삭제하시겠습니까?</p>
                <p class="text-danger">이 작업은 되돌릴 수 없습니다.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">삭제</button>
            </div>
        </div>
    </div>
</div>

<script>
    function goToPage(url) {
        window.location.href = url;
    }

    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();

        let selectedRecipeId = null;

        // 계절별 필터링
        $('.season-filter').on('click', function() {
            $('.season-filter').removeClass('active');
            $(this).addClass('active');

            const season = $(this).data('season');

            if (season === 'ALL') {
                $('.recipe-item').show();
            } else {
                $('.recipe-item').hide();
                $(`.recipe-item[data-season="${season}"]`).show();

                // 결과가 없는 경우 메시지 표시
                if ($(`.recipe-item[data-season="${season}"]`).length === 0) {
                    if ($('#no-result-message').length === 0) {
                        $('#recipeList').append(`
                            <div id="no-result-message" class="col-12 text-center py-4">
                                <i data-feather="alert-circle" class="text-muted mb-3" style="width: 40px; height: 40px;"></i>
                                <h5 class="text-muted">해당 계절의 레시피가 없습니다</h5>
                                <p class="text-muted">다른 계절을 선택하거나 새 레시피를 등록해보세요.</p>
                            </div>
                        `);
                        feather.replace();
                    }
                } else {
                    $('#no-result-message').remove();
                }
            }
        });

        // 삭제 버튼 클릭 시 모달 표시
        $('.delete-recipe').on('click', function() {
            selectedRecipeId = $(this).data('id');
            $('#deleteRecipeModal').modal('show');
        });

        // 삭제 확인 버튼 클릭 시 레시피 삭제
        $('#confirmDeleteBtn').on('click', function() {
            if (selectedRecipeId) {
                $.ajax({
                    url: `/api/recipes/${selectedRecipeId}`,
                    type: 'DELETE',
                    beforeSend: function(xhr) {
                        const token = localStorage.getItem('token') || getCookie('token');
                        if (token) {
                            xhr.setRequestHeader('Authorization', `Bearer ${token}`);
                        }
                    },
                    success: function() {
                        // 삭제 성공 시 해당 요소 제거
                        $(`.recipe-item .delete-recipe[data-id="${selectedRecipeId}"]`).closest('.recipe-item').remove();
                        $('#deleteRecipeModal').modal('hide');

                        // 모든 레시피가 삭제된 경우 메시지 표시
                        if ($('.recipe-item').length === 0) {
                            $('#recipeList').html(`
                                <div class="col-12 text-center py-5">
                                    <i data-feather="clipboard" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                                    <h5 class="text-muted">아직 등록한 레시피가 없습니다</h5>
                                    <p class="text-muted">새로운 레시피를 등록해보세요!</p>
                                    <a href="/addRecipe" class="btn btn-primary mt-3">
                                        <i data-feather="plus" class="me-1" style="width: 16px; height: 16px;"></i>
                                        첫 레시피 등록하기
                                    </a>
                                </div>
                            `);
                            feather.replace();
                        }
                    },
                    error: function(xhr) {
                        const errorMessage = xhr.responseJSON && xhr.responseJSON.error
                            ? xhr.responseJSON.error
                            : '레시피 삭제 중 오류가 발생했습니다.';

                        alert(errorMessage);
                        $('#deleteRecipeModal').modal('hide');
                    }
                });
            }
        });

        // 정렬 옵션 클릭 시 정렬 처리
        $('.sort-option').on('click', function(e) {
            e.preventDefault();

            const sortBy = $(this).data('sort');
            const $recipeItems = $('.recipe-item').get();

            $recipeItems.sort(function(a, b) {
                const $cardA = $(a).find('.card');
                const $cardB = $(b).find('.card');

                if (sortBy === 'newest') {
                    // 최신순 (ID 기준 내림차순)
                    return $(b).data('id') - $(a).data('id');
                } else if (sortBy === 'oldest') {
                    // 오래된순 (ID 기준 오름차순)
                    return $(a).data('id') - $(b).data('id');
                } else if (sortBy === 'popular') {
                    // 인기순 (조회수 기준 내림차순)
                    return parseInt($(b).find('.text-muted:contains("조회")').text().replace(/[^0-9]/g, '')) -
                        parseInt($(a).find('.text-muted:contains("조회")').text().replace(/[^0-9]/g, ''));
                } else if (sortBy === 'rating') {
                    // 평점순 (별점 기준 내림차순)
                    const ratingA = $(a).find('.rating .text-warning').length;
                    const ratingB = $(b).find('.rating .text-warning').length;
                    return ratingB - ratingA;
                }

                return 0;
            });

            // 정렬된 요소들을 컨테이너에 다시 추가
            const $recipeList = $('#recipeList');
            $.each($recipeItems, function(i, item) {
                $recipeList.append(item);
            });
        });

        // 쿠키 가져오기 함수
        function getCookie(name) {
            const value = `; ${document.cookie}`;
            const parts = value.split(`; ${name}=`);
            if (parts.length === 2) return parts.pop().split(';').shift();
        }
    });
</script>

<jsp:include page="include/footer.jsp" />