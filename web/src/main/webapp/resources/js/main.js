/**
 * 메인 자바스크립트 파일
 * 공통 기능 및 유틸리티 함수 정의
 */

// DOM 로드 완료 후 실행
$(document).ready(function() {
    // Feather 아이콘 초기화
    feather.replace();
    
    // 토스트 메시지 초기화 (존재하는 경우)
    $('.toast').toast('show');
    
    // 로그아웃 처리
    $('#logoutBtn').click(function(e) {
        e.preventDefault();
        
        $.ajax({
            url: '/api/auth/logout',
            type: 'POST',
            success: function(response) {
                window.location.href = '/';
            },
            error: function(error) {
                console.error('로그아웃 실패', error);
                alert('로그아웃 중 오류가 발생했습니다.');
            }
        });
    });
    
    // 검색 폼 제출 처리
    $('.search-form').submit(function(e) {
        const query = $(this).find('input[name="query"]').val().trim();
        if (!query) {
            e.preventDefault();
        }
    });
    
    // 모바일 환경에서 네비게이션 메뉴 클릭 시 자동 닫힘
    $('.navbar-nav>li>a').on('click', function(){
        $('.navbar-collapse').collapse('hide');
    });
});

/**
 * 날짜 형식 변환 함수
 * @param {string} dateString - ISO 형식의 날짜 문자열
 * @returns {string} 형식화된 날짜 문자열
 */
function formatDate(dateString) {
    if (!dateString) return '';
    
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric'
    });
}

/**
 * 날짜 및 시간 형식 변환 함수
 * @param {string} dateString - ISO 형식의 날짜 문자열
 * @returns {string} 형식화된 날짜 및 시간 문자열
 */
function formatDateTime(dateString) {
    if (!dateString) return '';
    
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

/**
 * 유통기한 남은 일수 계산 및 표시 함수
 * @param {string} expiryDateString - ISO 형식의 유통기한 날짜 문자열
 * @returns {Object} 남은 일수 정보 및 상태 클래스
 */
function calculateExpiryStatus(expiryDateString) {
    if (!expiryDateString) {
        return { text: '유통기한 정보 없음', class: 'bg-secondary' };
    }
    
    const expiryDate = new Date(expiryDateString);
    const today = new Date();
    
    // 날짜 비교를 위해 시간 정보 제거
    today.setHours(0, 0, 0, 0);
    expiryDate.setHours(0, 0, 0, 0);
    
    // 남은 일수 계산
    const diffTime = expiryDate.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays < 0) {
        return { text: '유통기한 만료', class: 'bg-danger' };
    } else if (diffDays === 0) {
        return { text: '오늘 만료', class: 'bg-warning' };
    } else if (diffDays <= 3) {
        return { text: `유통기한 ${diffDays}일 남음`, class: 'bg-warning' };
    } else {
        return { text: `유통기한: ${formatDate(expiryDateString)}`, class: 'bg-info' };
    }
}

/**
 * 평점 별 HTML 생성 함수
 * @param {number} rating - 평점 (0-5)
 * @returns {string} 평점 별 HTML
 */
function generateStarRating(rating) {
    if (isNaN(rating)) rating = 0;
    
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

/**
 * 에러 메시지 표시 함수
 * @param {string} selector - 에러 메시지를 표시할 요소 선택자
 * @param {string} message - 표시할 에러 메시지
 */
function showError(selector, message) {
    const $errorEl = $(selector);
    $errorEl.text(message).removeClass('d-none');
    
    // 5초 후 메시지 자동 숨김
    setTimeout(function() {
        $errorEl.addClass('d-none');
    }, 5000);
}

/**
 * URL 쿼리 파라미터 추출 함수
 * @param {string} name - 추출할 파라미터 이름
 * @returns {string|null} 파라미터 값 또는 null
 */
function getQueryParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}
