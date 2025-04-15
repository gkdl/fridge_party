/**
 * 재료 관련 기능을 처리하는 자바스크립트 파일
 */

// DOM 로드 완료 후 실행
$(document).ready(function() {
    // 재료 검색 자동완성
    $('#ingredientSearch').on('input', function() {
        const query = $(this).val().trim();
        if (query.length < 2) {
            $('#ingredientSearchResults').addClass('d-none');
            return;
        }
        
        searchIngredients(query);
    });
    
    // 재료 검색 버튼 클릭
    $('#searchIngredientBtn').click(function() {
        const query = $('#ingredientSearch').val().trim();
        if (query.length < 2) {
            return;
        }
        
        searchIngredients(query);
    });
    
    // 재료 선택 이벤트
    $(document).on('click', '.ingredient-search-result', function() {
        const id = $(this).data('id');
        const name = $(this).data('name');
        
        $('#ingredientId').val(id);
        $('#ingredientName').val(name);
        $('#ingredientSearchResults').addClass('d-none');
    });
    
    // 재료 저장 버튼 클릭
    $('#saveIngredientBtn').click(function() {
        saveIngredient();
    });
    
    // 재료 편집 버튼 클릭
    $(document).on('click', '.edit-ingredient', function(e) {
        e.preventDefault();
        
        const id = $(this).data('id');
        const name = $(this).data('name');
        const quantity = $(this).data('quantity');
        const unit = $(this).data('unit');
        const expiryDate = $(this).data('expiry');
        
        // 모달 필드 설정
        $('#editIngredientId').val(id);
        $('#editIngredientName').val(name);
        $('#editQuantity').val(quantity);
        $('#editUnit').val(unit);
        
        // 유통기한이 있는 경우 날짜 형식 변환
        if (expiryDate) {
            const date = new Date(expiryDate);
            const formattedDate = date.toISOString().split('T')[0];
            $('#editExpiryDate').val(formattedDate);
        } else {
            $('#editExpiryDate').val('');
        }
        
        // 모달 열기
        $('#editIngredientModal').modal('show');
    });
    
    // 재료 수정 버튼 클릭
    $('#updateIngredientBtn').click(function() {
        updateIngredient();
    });
    
    // 재료 삭제 버튼 클릭
    $(document).on('click', '.delete-ingredient', function(e) {
        e.preventDefault();
        
        if (confirm('이 재료를 정말 삭제하시겠습니까?')) {
            const id = $(this).data('id');
            deleteIngredient(id);
        }
    });
    
    // 레시피 찾기 버튼 클릭
    $('#findRecipesBtn').click(function() {
        // 냉장고 재료 기반으로 레시피 검색 페이지로 이동
        const ingredientIds = [];
        $('.ingredient-card').each(function() {
            ingredientIds.push($(this).data('ingredient-id'));
        });
        
        if (ingredientIds.length === 0) {
            alert('냉장고에 등록된 재료가 없습니다. 재료를 등록한 후 다시 시도해주세요.');
            return;
        }
        
        window.location.href = `/recipes?ingredientIds=${ingredientIds.join(',')}`;
    });
    
    // 추천 레시피 로드
    loadRecommendedRecipes();
    
    // 냉장고 재료 로드
    loadUserIngredients();
});

/**
 * 재료 검색 함수
 * @param {string} query - 검색어
 */
function searchIngredients(query) {
    $.ajax({
        url: `/api/ingredients/search?query=${encodeURIComponent(query)}`,
        type: 'GET',
        success: function(data) {
            let resultsHtml = '';
            
            if (data.length === 0) {
                resultsHtml = '<div class="list-group-item">검색 결과가 없습니다.</div>';
            } else {
                data.forEach(function(ingredient) {
                    resultsHtml += `
                        <div class="list-group-item ingredient-search-result" 
                            data-id="${ingredient.id}" 
                            data-name="${ingredient.name}">
                            ${ingredient.name}
                            ${ingredient.category ? `<small class="text-muted">(${ingredient.category})</small>` : ''}
                        </div>
                    `;
                });
            }
            
            $('#ingredientSearchResultsList').html(resultsHtml);
            $('#ingredientSearchResults').removeClass('d-none');
        },
        error: function(error) {
            console.error('재료 검색 실패', error);
            $('#ingredientSearchResultsList').html('<div class="list-group-item text-danger">재료 검색에 실패했습니다.</div>');
            $('#ingredientSearchResults').removeClass('d-none');
        }
    });
}

/**
 * 사용자 재료 목록 로드 함수
 */
function loadUserIngredients() {
    $.ajax({
        url: '/api/user/ingredients',
        type: 'GET',
        success: function(data) {
            renderIngredients(data);
        },
        error: function(error) {
            console.error('사용자 재료 로드 실패', error);
            $('#ingredientList').html(`
                <div class="col-12 text-center py-5">
                    <i data-feather="alert-circle" class="text-danger mb-3" style="width: 48px; height: 48px;"></i>
                    <h5 class="text-danger">재료 로드 실패</h5>
                    <p class="text-muted">재료를 불러오는데 실패했습니다. 다시 시도해주세요.</p>
                </div>
            `);
            feather.replace();
        }
    });
}

/**
 * 재료 목록 렌더링 함수
 * @param {Array} ingredients - 재료 목록
 */
function renderIngredients(ingredients) {
    const $ingredientList = $('#ingredientList');
    
    if (ingredients.length === 0) {
        $ingredientList.html(`
            <div class="col-12 text-center py-5">
                <i data-feather="archive" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                <h5 class="text-muted">냉장고가 비어있습니다</h5>
                <p class="text-muted">재료를 추가해 보세요!</p>
            </div>
        `);
    } else {
        let html = '';
        
        ingredients.forEach(function(ingredient) {
            // 유통기한 상태 계산
            const expiryStatus = calculateExpiryStatus(ingredient.expiryDate);
            
            html += `
                <div class="col" data-category="${ingredient.category || '기타'}">
                    <div class="card h-100 ingredient-card" data-ingredient-id="${ingredient.ingredientId}">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="card-title mb-0">${ingredient.ingredientName}</h5>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i data-feather="more-vertical"></i>
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item edit-ingredient" href="#" 
                                               data-id="${ingredient.id}" 
                                               data-name="${ingredient.ingredientName}" 
                                               data-quantity="${ingredient.quantity || ''}" 
                                               data-unit="${ingredient.unit || ''}" 
                                               data-expiry="${ingredient.expiryDate || ''}">수정</a></li>
                                        <li><a class="dropdown-item delete-ingredient" href="#" data-id="${ingredient.id}">삭제</a></li>
                                    </ul>
                                </div>
                            </div>
                            <p class="card-text">
                                <span class="badge bg-primary rounded-pill">${ingredient.quantity || ''} ${ingredient.unit || ''}</span>
                                ${ingredient.expiryDate ? 
                                    `<span class="badge ${expiryStatus.class} rounded-pill expiry-date">
                                        ${expiryStatus.text}
                                    </span>` : 
                                    ''}
                            </p>
                        </div>
                    </div>
                </div>
            `;
        });
        
        $ingredientList.html(html);
    }
    
    feather.replace();
    
    // 카테고리 필터링 초기화
    filterIngredientsByCategory('all');
}

/**
 * 카테고리별 재료 필터링 함수
 * @param {string} category - 카테고리명
 */
function filterIngredientsByCategory(category) {
    if (category === 'all') {
        $('#ingredientList .col').show();
    } else {
        $('#ingredientList .col').hide();
        $(`#ingredientList .col[data-category="${category}"]`).show();
    }
}

/**
 * 재료 저장 함수
 */
function saveIngredient() {
    const name = $('#ingredientName').val().trim();
    if (!name) {
        alert('재료 이름을 입력해주세요.');
        return;
    }
    
    const ingredientData = {
        ingredientId: $('#ingredientId').val() || null,
        name: name,
        quantity: $('#quantity').val() || null,
        unit: $('#unit').val() || null
    };
    
    // 유통기한 처리
    const expiryDate = $('#expiryDate').val();
    if (expiryDate) {
        // ISO 형식으로 변환
        ingredientData.expiryDate = new Date(expiryDate).toISOString();
    }
    
    $.ajax({
        url: '/api/user/ingredients',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(ingredientData),
        success: function(response) {
            // 모달 닫기
            $('#addIngredientModal').modal('hide');
            
            // 폼 초기화
            $('#ingredientId').val('');
            $('#ingredientName').val('');
            $('#quantity').val('');
            $('#unit').val('');
            $('#expiryDate').val('');
            $('#ingredientSearch').val('');
            $('#ingredientSearchResults').addClass('d-none');
            
            // 재료 목록 다시 로드
            loadUserIngredients();
            
            // 추천 레시피 다시 로드
            loadRecommendedRecipes();
            
            alert('재료가 추가되었습니다.');
        },
        error: function(error) {
            console.error('재료 저장 실패', error);
            alert('재료 추가에 실패했습니다.');
        }
    });
}

/**
 * 재료 수정 함수
 */
function updateIngredient() {
    const id = $('#editIngredientId').val();
    if (!id) {
        alert('오류가 발생했습니다. 페이지를 새로고침한 후 다시 시도해주세요.');
        return;
    }
    
    const ingredientData = {
        id: id,
        name: $('#editIngredientName').val().trim(),
        quantity: $('#editQuantity').val() || null,
        unit: $('#editUnit').val() || null
    };
    
    // 유통기한 처리
    const expiryDate = $('#editExpiryDate').val();
    if (expiryDate) {
        // ISO 형식으로 변환
        ingredientData.expiryDate = new Date(expiryDate).toISOString();
    }
    
    $.ajax({
        url: '/api/user/ingredients',
        type: 'POST', // 동일한 엔드포인트 사용
        contentType: 'application/json',
        data: JSON.stringify(ingredientData),
        success: function(response) {
            // 모달 닫기
            $('#editIngredientModal').modal('hide');
            
            // 재료 목록 다시 로드
            loadUserIngredients();
            
            alert('재료가 수정되었습니다.');
        },
        error: function(error) {
            console.error('재료 수정 실패', error);
            alert('재료 수정에 실패했습니다.');
        }
    });
}

/**
 * 재료 삭제 함수
 * @param {number} id - 재료 ID
 */
function deleteIngredient(id) {
    $.ajax({
        url: `/api/user/ingredients/${id}`,
        type: 'DELETE',
        success: function(response) {
            // 재료 목록 다시 로드
            loadUserIngredients();
            
            // 추천 레시피 다시 로드
            loadRecommendedRecipes();
            
            alert('재료가 삭제되었습니다.');
        },
        error: function(error) {
            console.error('재료 삭제 실패', error);
            alert('재료 삭제에 실패했습니다.');
        }
    });
}

/**
 * 추천 레시피 로드 함수
 */
function loadRecommendedRecipes() {
    $('#loadingRecipes').show();
    $('#noRecipes').addClass('d-none');
    
    $.ajax({
        url: '/api/recipes/recommended',
        type: 'GET',
        success: function(response) {
            $('#loadingRecipes').hide();
            
            if (response.length === 0) {
                $('#noRecipes').removeClass('d-none');
            } else {
                let recipesHtml = '';
                response.forEach(function(recipe) {
                    recipesHtml += `
                        <div class="col">
                            <div class="card h-100 shadow-sm">
                                ${recipe.imageUrl ? 
                                    `<img src="${recipe.imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.title}">` : 
                                    `<div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-camera text-secondary">
                                            <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                            <circle cx="12" cy="13" r="4"></circle>
                                        </svg>
                                    </div>`
                                }
                                <div class="card-body">
                                    <h5 class="card-title">${recipe.title}</h5>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="rating">
                                            ${generateStarRating(recipe.avgRating)}
                                            <small class="text-muted">(${recipe.ratingCount})</small>
                                        </div>
                                        <small class="text-muted">${recipe.cookingTime ? recipe.cookingTime + '분' : '시간 정보 없음'}</small>
                                    </div>
                                    <p class="card-text mt-2">${recipe.description || '설명 정보 없음'}</p>
                                </div>
                                <div class="card-footer bg-transparent">
                                    <a href="/recipes/${recipe.id}" class="btn btn-sm btn-outline-primary w-100">레시피 보기</a>
                                </div>
                            </div>
                        </div>
                    `;
                });
                
                $('#recommendedRecipes').html(recipesHtml);
                feather.replace();
            }
        },
        error: function(error) {
            $('#loadingRecipes').hide();
            $('#noRecipes').removeClass('d-none');
            console.error('추천 레시피 로드 실패', error);
        }
    });
}
