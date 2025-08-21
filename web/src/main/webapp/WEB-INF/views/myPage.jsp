<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<div class="my-page-container">
    <div class="row mb-4">
        <div class="col-md-12">
            <h2>마이페이지</h2>
            <p class="text-muted">내 정보와 활동을 관리할 수 있습니다</p>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-4">
            <div class="card shadow-sm mb-4">
                <div class="card-body text-center">
                    <div class="user-avatar mb-3">
                        <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" class="feather feather-user p-2 bg-light rounded-circle">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </div>
                    <h5>${user.username}</h5>
                    <p class="text-muted">${user.email}</p>
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-outline-primary mb-2" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                            <i data-feather="edit"></i> 프로필 수정
                        </button>
                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                            <i data-feather="lock"></i> 비밀번호 변경
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0">바로가기</h5>
                </div>
                <div class="list-group list-group-flush">
                    <a href="/myRefrigerator" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div><i data-feather="archive"></i> 내 냉장고</div>
                        <span class="badge bg-primary rounded-pill" id="ingredientCount">0</span>
                    </a>
                    <a href="/myRecipes" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div><i data-feather="book"></i> 내 레시피</div>
                        <span class="badge bg-primary rounded-pill" id="myRecipeCount">0</span>
                    </a>
                    <a href="/myFavorites" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div><i data-feather="heart"></i> 즐겨찾기</div>
                        <span class="badge bg-primary rounded-pill" id="favoriteCount">0</span>
                    </a>
                </div>
            </div>
        </div>
        
        <div class="col-md-8">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light">
                    <h5 class="mb-0">활동 요약</h5>
                </div>
                <div class="card-body">
                    <div class="row activity-stats text-center">
                        <div class="col-4">
                            <div class="activity-icon bg-light rounded-circle mx-auto d-flex justify-content-center align-items-center mb-2">
                                <i data-feather="book-open"></i>
                            </div>
                            <h3 id="userRecipeCount">0</h3>
                            <p class="text-muted">등록한 레시피</p>
                        </div>
                        <div class="col-4">
                            <div class="activity-icon bg-light rounded-circle mx-auto d-flex justify-content-center align-items-center mb-2">
                                <i data-feather="star"></i>
                            </div>
                            <h3 id="userRatingCount">0</h3>
                            <p class="text-muted">작성한 평점</p>
                        </div>
                        <div class="col-4">
                            <div class="activity-icon bg-light rounded-circle mx-auto d-flex justify-content-center align-items-center mb-2">
                                <i data-feather="heart"></i>
                            </div>
                            <h3 id="userFavoriteCount">0</h3>
                            <p class="text-muted">즐겨찾기한 레시피</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">최근 등록한 레시피</h5>
                    <a href="/myRecipes" class="btn btn-sm btn-outline-primary">더보기</a>
                </div>
                <div class="card-body">
                    <div id="recentRecipes">
                        <div class="text-center py-3">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">추천 레시피</h5>
                </div>
                <div class="card-body">
                    <div id="recommendedRecipes">
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

<!-- 프로필 수정 모달 -->
<div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editProfileModalLabel">프로필 수정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editProfileForm">
                    <div class="mb-3">
                        <label for="editUsername" class="form-label">이름</label>
                        <input type="text" class="form-control" id="editUsername" name="username" value="${user.username}" required>
                    </div>
                    <div class="mb-3">
                        <label for="editEmail" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="editEmail" name="email" value="${user.email}" readonly>
                        <div class="form-text">이메일은 변경할 수 없습니다.</div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="saveProfileBtn">저장</button>
            </div>
        </div>
    </div>
</div>

<!-- 비밀번호 변경 모달 -->
<div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="changePasswordModalLabel">비밀번호 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="changePasswordForm">
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">현재 비밀번호</label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">새 비밀번호</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        <div class="form-text">8자 이상, 영문, 숫자, 특수문자를 포함해주세요.</div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmNewPassword" class="form-label">새 비밀번호 확인</label>
                        <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="changePasswordBtn">변경</button>
            </div>
        </div>
    </div>
</div>

<script src="/resources/js/user.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();
        
        // 사용자 활동 정보 로드
        loadUserActivity();
        
        // 최근 등록한 레시피 로드
        loadRecentRecipes();
        
        // 추천 레시피 로드
        loadRecommendedRecipes();
        
        // 프로필 저장 버튼 이벤트
        $('#saveProfileBtn').click(function() {
            const username = $('#editUsername').val().trim();
            
            if (!username) {
                alert('이름을 입력해주세요.');
                return;
            }
            
            $.ajax({
                url: '/api/user/profile',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({
                    username: username
                }),
                success: function(response) {
                    alert('프로필이 수정되었습니다.');
                    window.location.reload();
                },
                error: function(error) {
                    console.error('Failed to update profile', error);
                    alert('프로필 수정에 실패했습니다.');
                }
            });
        });
        
        // 비밀번호 변경 버튼 이벤트
        $('#changePasswordBtn').click(function() {
            const currentPassword = $('#currentPassword').val();
            const newPassword = $('#newPassword').val();
            const confirmNewPassword = $('#confirmNewPassword').val();
            
            // 새 비밀번호 확인
            if (newPassword !== confirmNewPassword) {
                alert('새 비밀번호가 일치하지 않습니다.');
                return;
            }
            
            // 비밀번호 정책 검사 (간단한 정규식)
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
            if (!passwordRegex.test(newPassword)) {
                alert('비밀번호는 8자 이상, 영문, 숫자, 특수문자를 포함해야 합니다.');
                return;
            }
            
            $.ajax({
                url: '/api/user/password',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                    confirmNewPassword: confirmNewPassword
                }),
                success: function(response) {
                    alert('비밀번호가 변경되었습니다.');
                    $('#changePasswordModal').modal('hide');
                    // 폼 초기화
                    $('#changePasswordForm')[0].reset();
                },
                error: function(xhr) {
                    const error = xhr.responseJSON;
                    alert(error.error || '비밀번호 변경에 실패했습니다.');
                }
            });
        });
    });

    // 사용자 활동 정보 로드 함수
    function loadUserActivity() {
        $.ajax({
            url: '/api/activities/stats',
            type: 'GET',
            success: function(response) {
                $('#userRecipeCount').text(response.recipeCount || 0);
                $('#userRatingCount').text(response.ratingCount || 0);
                $('#userFavoriteCount').text(response.favoriteCount || 0);

                // 바로가기 메뉴 카운트 업데이트
                $('#ingredientCount').text(response.ingredientCount || 0);
                $('#myRecipeCount').text(response.recipeCount || 0);
                $('#favoriteCount').text(response.favoriteCount || 0);
            },
            error: function(error) {
                console.error('Failed to load user activity', error);
            }
        });
    }
    
    // 최근 등록한 레시피 로드 함수
    function loadRecentRecipes() {
        $.ajax({
            url: '/api/recipes/user?count=3',
            type: 'GET',
            success: function(response) {
                let recipesHtml = '';
                
                if (response.content.length === 0) {
                    recipesHtml = '<div class="text-center py-3">' +
                        '<i data-feather="book" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>' +
                        '<p class="text-muted">아직 등록한 레시피가 없습니다</p>' +
                        '<a href="/addRecipe" class="btn btn-primary">레시피 등록하기</a>' +
                        '</div>';
                } else {
                    recipesHtml = '<div class="list-group">';
                    response.content.forEach(function(recipe) {
                        var description = recipe.description || '설명 없음';
                        var cookingTime = recipe.cookingTime || '정보 없음';
                        var timeUnit = recipe.cookingTime ? '분' : '';
                        
                        recipesHtml += '<a href="/recipes/' + recipe.id + '" class="list-group-item list-group-item-action">' +
                            '<div class="d-flex w-100 justify-content-between">' +
                            '<h6 class="mb-1">' + recipe.title + '</h6>' +
                            '<small>' +
                            '<div class="rating-stars">' +
                            generateStarRating(recipe.avgRating) +
                            '<span class="text-muted">(' + recipe.ratingCount + ')</span>' +
                            '</div>' +
                            '</small>' +
                            '</div>' +
                            '<p class="mb-1 text-truncate">' + description + '</p>' +
                            '<small class="text-muted">조리시간: ' + cookingTime + ' ' + timeUnit + '</small>' +
                            '</a>';
                    });
                    recipesHtml += '</div>';
                }
                
                $('#recentRecipes').html(recipesHtml);
                feather.replace();
            },
            error: function(error) {
                console.error('Failed to load recent recipes', error);
                $('#recentRecipes').html('<p class="text-danger">레시피 로드에 실패했습니다.</p>');
            }
        });
    }
    
    // 추천 레시피 로드 함수
    function loadRecommendedRecipes() {
        $.ajax({
            url: '/api/recipes/recommended?count=3',
            type: 'GET',
            success: function(response) {
                let recipesHtml = '';
                
                if (response.length === 0) {
                    recipesHtml = '<div class="text-center py-3">' +
                        '<i data-feather="search" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>' +
                        '<p class="text-muted">추천 레시피가 없습니다</p>' +
                        '<p class="text-muted">냉장고에 재료를 등록하면 맞춤 레시피를 추천해드립니다</p>' +
                        '<a href="/myRefrigerator" class="btn btn-primary">냉장고 관리하기</a>' +
                        '</div>';
                } else {
                    recipesHtml = '<div class="row row-cols-1 row-cols-md-3 g-4">';
                    response.forEach(function(recipe) {
                        var recipeHtml = '<div class="col">' + 
                            '<div class="card h-100">';

                        if (recipe.images.length > 0) {
                            recipeHtml += '<img src="' + recipe.images[0].imageUrl + '" class="card-img-top recipe-thumbnail" alt="' + recipe.images[0].description + '">';
                        } else {
                            recipeHtml += '<div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">' + 
                                '<i data-feather="camera" class="text-secondary"></i>' + 
                                '</div>';
                        }
                        
                        recipeHtml += '<div class="card-body">' +
                            '<h6 class="card-title">' + recipe.title + '</h6>' +
                            '<div class="small rating-stars">' +
                            generateStarRating(recipe.avgRating) +
                            '<span class="text-muted">(' + recipe.ratingCount + ')</span>' +
                            '</div>' +
                            '</div>' +
                            '<div class="card-footer bg-transparent">' +
                            '<a href="/recipes/' + recipe.id + '" class="btn btn-sm btn-outline-primary w-100">레시피 보기</a>' +
                            '</div>' +
                            '</div>' +
                            '</div>';
                            
                        recipesHtml += recipeHtml;
                    });
                    recipesHtml += '</div>';
                }
                
                $('#recommendedRecipes').html(recipesHtml);
                feather.replace();
            },
            error: function(error) {
                console.error('Failed to load recommended recipes', error);
                $('#recommendedRecipes').html('<p class="text-danger">추천 레시피 로드에 실패했습니다.</p>');
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
</script>

<jsp:include page="include/footer.jsp" />
