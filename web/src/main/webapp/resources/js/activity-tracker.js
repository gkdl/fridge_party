/**
 * 사용자 활동 추적 모듈
 * 사용자의 레시피 조회, 평점 등록, 즐겨찾기 추가/삭제, 레시피 검색 등의 활동을 기록
 */

/**
 * 활동 유형 정의
 */
const ActivityType = {
    VIEW_RECIPE: 'VIEW_RECIPE',          // 레시피 조회
    RATE_RECIPE: 'RATE_RECIPE',          // 평점 등록
    FAVORITE_RECIPE: 'FAVORITE_RECIPE',  // 즐겨찾기 추가/삭제
    SEARCH_RECIPE: 'SEARCH_RECIPE',      // 레시피 검색
    COOK_RECIPE: 'COOK_RECIPE',          // 요리 완료 표시
    VIEW_CATEGORY: 'VIEW_CATEGORY'       // 카테고리 조회
};

/**
 * 활동 기록 함수
 * @param {string} activityType - 활동 유형 (ActivityType 참조)
 * @param {number|null} recipeId - 레시피 ID (선택 사항)
 * @param {string|null} searchQuery - 검색어 (선택 사항)
 * @param {number} weight - 가중치 (기본값 1.0)
 * @returns {Promise} - 활동 기록 결과 Promise
 */
function recordActivity(activityType, recipeId = null, searchQuery = null, weight = 1.0) {
    // 로그인한 사용자만 활동 기록
    if (!isUserLoggedIn()) {
        console.log('사용자가 로그인하지 않았습니다. 활동이 기록되지 않습니다.');
        return Promise.resolve(false);
    }
    
    const activityData = {
        activityType: activityType,
        recipeId: recipeId,
        searchQuery: searchQuery,
        weight: weight
    };

    return fetch('/api/activities', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(activityData)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('활동 기록에 실패했습니다.');
        }
        return response.json();
    })
    .then(data => {
        console.log('활동 기록 완료:', data);
        return true;
    })
    .catch(error => {
        console.error('활동 기록 오류:', error);
        return false;
    });
}

/**
 * 레시피 조회 활동 기록 함수 (간소화 버전)
 * @param {number} recipeId - 레시피 ID
 */
function recordViewActivity(recipeId) {
    recordActivity(ActivityType.VIEW_RECIPE, recipeId, null, 1.0);
}

/**
 * 검색 활동 기록 함수
 * @param {string} searchQuery - 검색어
 */
function recordSearchActivity(searchQuery) {
    recordActivity(ActivityType.SEARCH_RECIPE, null, searchQuery, 1.0);
}

/**
 * 즐겨찾기 활동 기록 함수
 * @param {number} recipeId - 레시피 ID
 * @param {boolean} isFavorite - 즐겨찾기 추가 여부
 */
function recordFavoriteActivity(recipeId, isFavorite) {
    // 즐겨찾기 추가 시 가중치 1.5, 삭제 시 가중치 0.5
    const weight = isFavorite ? 1.5 : 0.5;
    recordActivity(ActivityType.FAVORITE_RECIPE, recipeId, null, weight);
}

/**
 * 평점 활동 기록 함수
 * @param {number} recipeId - 레시피 ID
 * @param {number} rating - 평점 (1-5)
 */
function recordRatingActivity(recipeId, rating) {
    // 평점에 따라 가중치 달라지도록 설정 (1점 = 0.5, 5점 = 2.0)
    const weight = 0.5 + (rating - 1) * 0.375;
    recordActivity(ActivityType.RATE_RECIPE, recipeId, null, weight);
}

/**
 * 요리 완료 활동 기록 함수
 * @param {number} recipeId - 레시피 ID
 */
function recordCookActivity(recipeId) {
    // 실제 요리했다는 확실한 신호이므로 가중치 높게 설정
    recordActivity(ActivityType.COOK_RECIPE, recipeId, null, 3.0);
}

/**
 * 카테고리 조회 활동 기록 함수
 * @param {string} category - 카테고리명
 */
function recordCategoryActivity(category) {
    recordActivity(ActivityType.VIEW_CATEGORY, null, category, 0.8);
}

/**
 * 사용자 로그인 여부 확인
 * @returns {boolean} - 로그인 여부
 */
function isUserLoggedIn() {
    // 쿠키 또는 세션 기반 로그인 확인
    return document.cookie.includes('token=') || sessionStorage.getItem('token') || sessionStorage.getItem('userId');
}

/**
 * 사용자 활동 통계 정보 가져오기
 * @returns {Promise} - 활동 통계 정보 Promise
 */
function getUserActivityStats() {
    if (!isUserLoggedIn()) {
        return Promise.resolve(null);
    }
    
    return fetch('/api/activities/stats')
        .then(response => {
            if (!response.ok) {
                throw new Error('활동 통계 조회에 실패했습니다.');
            }
            return response.json();
        })
        .catch(error => {
            console.error('활동 통계 조회 오류:', error);
            return null;
        });
}

// 페이지 로드 시 카테고리 또는 검색어 기반 활동 기록 초기화
document.addEventListener('DOMContentLoaded', function() {
    // URL에서 쿼리 파라미터 분석
    const urlParams = new URLSearchParams(window.location.search);
    
    // 카테고리 파라미터 있을 경우 카테고리 활동 기록
    if (urlParams.has('category')) {
        const category = urlParams.get('category');
        recordCategoryActivity(category);
    }
    
    // 검색어 파라미터 있을 경우 검색 활동 기록
    if (urlParams.has('query')) {
        const query = urlParams.get('query');
        if (query && query.trim() !== '') {
            recordSearchActivity(query);
        }
    }
    
    // 레시피 상세 페이지인 경우 조회 활동 기록 (URL이 /recipes/숫자 형태)
    const path = window.location.pathname;
    const recipeIdMatch = path.match(/\/recipes\/(\d+)$/);
    if (recipeIdMatch && recipeIdMatch[1]) {
        const recipeId = parseInt(recipeIdMatch[1]);
        if (!isNaN(recipeId)) {
            recordViewActivity(recipeId);
        }
    }
});