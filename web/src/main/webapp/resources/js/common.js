/**
 * 공통 JavaScript 함수와 설정
 */

// DOM 로드 완료 후 실행
$(document).ready(function() {
    // URL 파라미터에서 토큰 확인 및 저장
    checkAuthFromUrl();
    
    // 모든 Ajax 요청에 인증 토큰 추가
    setupAjaxInterceptors();

    // 로그인 상태에 따른 UI 업데이트
    updateAuthUI();
    
    // 로그아웃 버튼 이벤트
    $(document).on('click', '#logoutBtn', function(e) {
        e.preventDefault();
        logout();
    });
});

/**
 * Ajax 인터셉터 설정 함수
 * 모든 Ajax 요청에 JWT 토큰 헤더 추가
 */
function setupAjaxInterceptors() {
    $.ajaxSetup({
        beforeSend: function(xhr) {
            // localStorage에서 토큰 가져오기
            const token = localStorage.getItem('authToken');
            if (token) {
                xhr.setRequestHeader('Authorization', 'Bearer ' + token);
            }
        }
    });
    
    // Ajax 오류 응답 처리
    $(document).ajaxError(function(event, jqXHR, settings, thrownError) {
        if (jqXHR.status === 401 || jqXHR.status === 403) {
            // 인증/권한 오류 시 localStorage 토큰 삭제
            const currentPath = window.location.pathname;
            if (currentPath !== '/login' && currentPath !== '/register') {
                console.log('Authentication error. Redirecting to login page.');
                localStorage.removeItem('authToken');
                localStorage.removeItem('userId');
                
                // 로그인 페이지가 아닌 경우에만 리다이렉트
                if (settings.url.indexOf('/api/auth/login') === -1) {
                    window.location.href = '/login';
                }
            }
        }
    });
}

/**
 * 로그인 상태에 따라 UI 업데이트
 */
function updateAuthUI() {
    const token = localStorage.getItem('authToken');
    const userId = localStorage.getItem('userId');
    
    if (token && userId) {
        // 로그인 상태
        $('.auth-logged-in').removeClass('d-none');
        $('.auth-logged-out').addClass('d-none');
        
        // 사용자 정보 로드
        loadUserInfo();
    } else {
        // 로그아웃 상태
        $('.auth-logged-in').addClass('d-none');
        $('.auth-logged-out').removeClass('d-none');
    }
}

/**
 * 사용자 정보 로드
 */
function loadUserInfo() {
    $.ajax({
        url: '/api/user/me',
        type: 'GET',
        success: function(user) {
            if (user && user.username) {
                $('.user-name').text(user.username);
            }
        },
        error: function(xhr) {
            console.error('Failed to load user info:', xhr.responseText);
        }
    });
}

/**
 * URL 파라미터에서 인증 정보 확인 및 저장
 * 소셜 로그인 성공 후 리다이렉트된 페이지에서 토큰을 로컬 스토리지에 저장
 */
function checkAuthFromUrl() {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');
    const userId = urlParams.get('userId');
    
    if (token && userId) {
        console.log('Auth token found in URL, storing in localStorage');
        
        // 로컬 스토리지에 저장
        localStorage.setItem('authToken', token);
        localStorage.setItem('userId', userId);
        
        // URL에서 토큰 파라미터 제거 (보안 강화)
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.delete('token');
        currentUrl.searchParams.delete('userId');
        
        // 파라미터 없는 URL로 변경 (새로고침 없이 브라우저 URL만 변경)
        window.history.replaceState({}, document.title, currentUrl.pathname + currentUrl.search);
    }
}

/**
 * 로그아웃 처리 함수
 */
function logout() {
    $.ajax({
        url: '/api/auth/logout',
        type: 'POST',
        success: function() {
            // 로컬 스토리지에서 인증 정보 삭제
            localStorage.removeItem('authToken');
            localStorage.removeItem('userId');
            
            // 홈페이지로 리다이렉트
            window.location.href = '/';
        },
        error: function(xhr) {
            console.error('로그아웃 실패:', xhr.responseText);
            // 오류가 발생하더라도 로컬 스토리지는 정리
            localStorage.removeItem('authToken');
            localStorage.removeItem('userId');
            window.location.href = '/';
        }
    });
}