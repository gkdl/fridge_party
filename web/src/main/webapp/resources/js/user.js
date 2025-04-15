/**
 * 사용자 관련 기능을 처리하는 자바스크립트 파일
 */

// DOM 로드 완료 후 실행
$(document).ready(function() {
    // 로그인 폼 제출 처리
    $('#loginForm').submit(function(e) {
        e.preventDefault();
        
        const email = $('#email').val().trim();
        const password = $('#password').val();
        
        if (!email || !password) {
            showError('#loginAlert', '이메일과 비밀번호를 입력해주세요.');
            return;
        }
        
        $.ajax({
            url: '/api/auth/login',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                email: email,
                password: password
            }),
            success: function(response) {
                console.log("Login success:", response);
                // 로그인 성공 시 토큰을 localStorage에 저장
                if (response.token) {
                    localStorage.setItem('authToken', response.token);
                    localStorage.setItem('userId', response.user.id);
                }
                // 홈페이지로 이동
                window.location.href = '/';
            },
            error: function(xhr) {
                const error = xhr.responseJSON;
                showError('#loginAlert', error.error || '로그인에 실패했습니다.');
            }
        });
    });
    
    // 회원가입 폼 제출 처리
    $('#registerForm').submit(function(e) {
        e.preventDefault();
        
        const username = $('#username').val().trim();
        const email = $('#email').val().trim();
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();
        
        // 필수 입력 검증
        if (!username || !email || !password || !confirmPassword) {
            showError('#registerAlert', '모든 필드를 입력해주세요.');
            return;
        }
        
        // 이메일 형식 검증
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            showError('#registerAlert', '유효한 이메일 주소를 입력해주세요.');
            return;
        }
        
        // 비밀번호 확인
        if (password !== confirmPassword) {
            showError('#registerAlert', '비밀번호가 일치하지 않습니다.');
            return;
        }
        
        // 비밀번호 정책 검사 (간단한 정규식)
        const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
        if (!passwordRegex.test(password)) {
            showError('#registerAlert', '비밀번호는 8자 이상, 영문, 숫자, 특수문자를 포함해야 합니다.');
            return;
        }
        
        // 약관 동의 체크
        if (!$('#agreeTerms').is(':checked')) {
            showError('#registerAlert', '이용약관에 동의해주세요.');
            return;
        }
        
        $.ajax({
            url: '/api/auth/register',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                username: username,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            }),
            success: function(response) {
                // 회원가입 성공 시 로그인 페이지로 이동
                window.location.href = '/login?registered=true';
            },
            error: function(xhr) {
                const error = xhr.responseJSON;
                showError('#registerAlert', error.error || '회원가입에 실패했습니다.');
            }
        });
    });
    
    // 소셜 로그인 버튼 처리
    $('.social-login-btn').click(function() {
        const provider = $(this).data('provider');
        
        // 실제 소셜 로그인 처리
        if (provider === 'google' || provider === 'kakao' || provider === 'naver') {
            window.location.href = `/oauth2/authorize/${provider}?redirect_uri=/`;
        } else {
            // 지원되지 않는 제공자
            alert(`${provider} 로그인은 현재 개발 중입니다.`);
        }
    });
    
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
                console.error('프로필 수정 실패', error);
                alert('프로필 수정에 실패했습니다.');
            }
        });
    });
    
    // 비밀번호 변경 버튼 이벤트
    $('#changePasswordBtn').click(function() {
        const currentPassword = $('#currentPassword').val();
        const newPassword = $('#newPassword').val();
        const confirmNewPassword = $('#confirmNewPassword').val();
        
        if (!currentPassword || !newPassword || !confirmNewPassword) {
            alert('모든 필드를 입력해주세요.');
            return;
        }
        
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
    
    // 마이페이지 로드 시 사용자 정보 불러오기
    if ($('.my-page-container').length > 0) {
        loadUserActivity();
        loadRecentRecipes();
        loadRecommendedRecipes();
    }
    
    // 회원가입 페이지에서 등록 완료 메시지 표시
    if (window.location.pathname === '/login' && getQueryParam('registered') === 'true') {
        showMessage('#loginAlert', '회원가입이 완료되었습니다. 로그인해주세요.', 'success');
    }
});

/**
 * 사용자 활동 정보 로드 함수
 */
function loadUserActivity() {
    $.ajax({
        url: '/api/activities',
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
            console.error('사용자 활동 로드 실패', error);
        }
    });
}

/**
 * 최근 등록한 레시피 로드 함수
 */
function loadRecentRecipes() {
    $.ajax({
        url: '/api/recipes/user?page=0&size=3',
        type: 'GET',
        success: function(response) {
            let recipesHtml = '';
            
            if (response.content.length === 0) {
                recipesHtml = `
                    <div class="text-center py-3">
                        <i data-feather="book" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                        <p class="text-muted">아직 등록한 레시피가 없습니다</p>
                        <a href="/addRecipe" class="btn btn-primary">레시피 등록하기</a>
                    </div>
                `;
            } else {
                recipesHtml = '<div class="list-group">';
                response.content.forEach(function(recipe) {
                    recipesHtml += `
                        <a href="/recipes/${recipe.id}" class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1">${recipe.title}</h6>
                                <small>
                                    <div class="rating-stars">
                                        ${generateStarRating(recipe.avgRating)}
                                        <span class="text-muted">(${recipe.ratingCount})</span>
                                    </div>
                                </small>
                            </div>
                            <p class="mb-1 text-truncate">${recipe.description || '설명 없음'}</p>
                            <small class="text-muted">조리시간: ${recipe.cookingTime || '정보 없음'} ${recipe.cookingTime ? '분' : ''}</small>
                        </a>
                    `;
                });
                recipesHtml += '</div>';
            }
            
            $('#recentRecipes').html(recipesHtml);
            feather.replace();
        },
        error: function(error) {
            console.error('최근 레시피 로드 실패', error);
            $('#recentRecipes').html('<p class="text-danger">레시피 로드에 실패했습니다.</p>');
        }
    });
}

/**
 * 추천 레시피 로드 함수
 */
function loadRecommendedRecipes() {
    $.ajax({
        url: '/api/recipes/recommended?count=3',
        type: 'GET',
        success: function(response) {
            let recipesHtml = '';
            
            if (response.length === 0) {
                recipesHtml = `
                    <div class="text-center py-3">
                        <i data-feather="search" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                        <p class="text-muted">추천 레시피가 없습니다</p>
                        <p class="text-muted">냉장고에 재료를 등록하면 맞춤 레시피를 추천해드립니다</p>
                        <a href="/myRefrigerator" class="btn btn-primary">냉장고 관리하기</a>
                    </div>
                `;
            } else {
                recipesHtml = '<div class="row row-cols-1 row-cols-md-3 g-4">';
                response.forEach(function(recipe) {
                    recipesHtml += `
                        <div class="col">
                            <div class="card h-100">
                                ${recipe.imageUrl ? 
                                    `<img src="${recipe.imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.title}">` : 
                                    `<div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                        <i data-feather="camera" class="text-secondary"></i>
                                    </div>`
                                }
                                <div class="card-body">
                                    <h6 class="card-title">${recipe.title}</h6>
                                    <div class="small rating-stars">
                                        ${generateStarRating(recipe.avgRating)}
                                        <span class="text-muted">(${recipe.ratingCount})</span>
                                    </div>
                                </div>
                                <div class="card-footer bg-transparent">
                                    <a href="/recipes/${recipe.id}" class="btn btn-sm btn-outline-primary w-100">레시피 보기</a>
                                </div>
                            </div>
                        </div>
                    `;
                });
                recipesHtml += '</div>';
            }
            
            $('#recommendedRecipes').html(recipesHtml);
            feather.replace();
        },
        error: function(error) {
            console.error('추천 레시피 로드 실패', error);
            $('#recommendedRecipes').html('<p class="text-danger">추천 레시피 로드에 실패했습니다.</p>');
        }
    });
}

/**
 * 에러 메시지 표시 함수
 * @param {string} selector - 에러 메시지를 표시할 요소 선택자
 * @param {string} message - 표시할 에러 메시지
 */
function showError(selector, message) {
    const $alertEl = $(selector);
    $alertEl.removeClass('d-none alert-success').addClass('alert-danger').text(message);
    
    // 5초 후 메시지 자동 숨김
    setTimeout(function() {
        $alertEl.addClass('d-none');
    }, 5000);
}

/**
 * 성공 메시지 표시 함수
 * @param {string} selector - 메시지를 표시할 요소 선택자
 * @param {string} message - 표시할 메시지
 * @param {string} type - 메시지 유형 (success, danger, warning 등)
 */
function showMessage(selector, message, type = 'danger') {
    const $alertEl = $(selector);
    $alertEl.removeClass('d-none alert-danger alert-success alert-warning')
        .addClass(`alert-${type}`).text(message);
    
    // 5초 후 메시지 자동 숨김
    setTimeout(function() {
        $alertEl.addClass('d-none');
    }, 5000);
}
