/**
 * 레시피 관련 기능을 처리하는 자바스크립트 파일
 */

// DOM 로드 완료 후 실행
$(document).ready(function() {
    // 레시피 검색 폼 처리
    $('#recipeSearchForm').submit(function(e) {
        e.preventDefault();
        const query = $('#searchQuery').val().trim();
        if (query) {
            // 검색 활동 기록
            if (typeof recordSearchActivity === 'function') {
                recordSearchActivity(query);
            }
            
            window.location.href = `/recipes?query=${encodeURIComponent(query)}`;
        }
    });
    
    // 즐겨찾기 토글 버튼 이벤트
    $(document).on('click', '.favorite-btn', function() {
        const recipeId = $(this).data('recipe-id');
        toggleFavorite(recipeId, $(this));
    });
    
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
        
        const recipeId = window.location.pathname.split('/').pop();
        const rating = $(this).data('rating');
        if (!rating) {
            alert('평점을 선택해주세요.');
            return;
        }
        
        const comment = $('#ratingComment').val();
        
        $.ajax({
            url: `/api/recipes/${recipeId}/rate`,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                rating: rating,
                comment: comment
            }),
            success: function(response) {
                // 평점 활동 기록
                if (typeof recordRatingActivity === 'function') {
                    recordRatingActivity(recipeId, rating);
                }
                
                alert('평점이 등록되었습니다.');
                // 페이지 새로고침
                window.location.reload();
            },
            error: function(error) {
                console.error('레시피 평가 실패', error);
                alert('평점 등록에 실패했습니다.');
            }
        });
    });
    
    // 레시피 삭제 버튼 이벤트
    $('#deleteRecipeBtn').click(function() {
        if (confirm('정말 이 레시피를 삭제하시겠습니까?')) {
            const recipeId = $(this).data('recipe-id');
            
            $.ajax({
                url: `/api/recipes/${recipeId}`,
                type: 'DELETE',
                success: function(response) {
                    alert('레시피가 삭제되었습니다.');
                    window.location.href = '/myRecipes';
                },
                error: function(error) {
                    console.error('레시피 삭제 실패', error);
                    alert('레시피 삭제에 실패했습니다.');
                }
            });
        }
    });
    
    // 재료 입력 자동완성
    setupIngredientAutocomplete();
    
    // 재료 추가 버튼 이벤트
    $('#addIngredientBtn').click(function() {
        addIngredientRow();
    });
    
    // 재료 삭제 버튼 이벤트
    $(document).on('click', '.remove-ingredient', function() {
        const $ingredientRows = $('.ingredient-row');
        if ($ingredientRows.length > 1) {
            $(this).closest('.ingredient-row').remove();
        } else {
            alert('최소 1개 이상의 재료가 필요합니다.');
        }
    });
    
    // 취소 버튼 이벤트
    $('#cancelBtn').click(function() {
        if (confirm('작성 중인 내용이 저장되지 않습니다. 정말 취소하시겠습니까?')) {
            window.history.back();
        }
    });
    
    // 레시피 폼 제출
    $('#recipeForm').submit(function(e) {
        e.preventDefault();
        saveRecipe();
    });
});

/**
 * 즐겨찾기 토글 함수
 * @param {number} recipeId - 레시피 ID
 * @param {jQuery} $button - 즐겨찾기 버튼 jQuery 객체
 */
function toggleFavorite(recipeId, $button) {
    $.ajax({
        url: `/api/recipes/${recipeId}/favorite`,
        type: 'POST',
        success: function(response) {
            if (response.isFavorite) {
                $button.data('is-favorite', true);
                if ($button.hasClass('btn')) {
                    $button.html('<i data-feather="heart" class="text-danger filled-heart"></i> 즐겨찾기 해제');
                } else {
                    $button.html('<i data-feather="heart" class="text-danger filled-heart"></i>');
                }
                
                // 즐겨찾기 추가 활동 기록
                if (typeof recordFavoriteActivity === 'function') {
                    recordFavoriteActivity(recipeId, true);
                }
            } else {
                $button.data('is-favorite', false);
                if ($button.hasClass('btn')) {
                    $button.html('<i data-feather="heart" class="empty-heart"></i> 즐겨찾기 추가');
                } else {
                    $button.html('<i data-feather="heart" class="empty-heart"></i>');
                }
            }
            feather.replace();
        },
        error: function(error) {
            console.error('즐겨찾기 토글 실패', error);
            alert('즐겨찾기 등록/해제 중 오류가 발생했습니다.');
        }
    });
}

/**
 * 레시피 저장 함수
 */
function saveRecipe() {
    // 필수 값 검증
    if (!$('#title').val().trim()) {
        alert('레시피 제목을 입력해주세요.');
        $('#title').focus();
        return;
    }

    // 단계별 조리방법 검증
    let stepsValid = true;
    $('.step-description').each(function() {

        if (!$(this).val().trim()) {
            stepsValid = false;
            $(this).focus();
            return false; // 루프 중단
        }
    });

    if (!stepsValid) {
        alert('모든 조리 단계에 설명을 입력해주세요.');
        return;
    }

    // 재료 정보 수집
    const ingredients = [];
    $('.ingredient-row').each(function() {
        const name = $(this).find('.ingredient-name').val().trim();
        const quantity = $(this).find('.ingredient-quantity').val();

        if (name && quantity) {
            ingredients.push({
                ingredientId: $(this).find('.ingredient-id').val() || null,
                name: name,
                quantity: parseFloat(quantity),
                unit: $(this).find('.ingredient-unit').val(),
                optional: $(this).find('.ingredient-optional').is(':checked')
            });
        }
    });

    if (ingredients.length === 0) {
        alert('최소 1개 이상의 재료를 입력해주세요.');
        return;
    }

    // 이미지 정보 수집
    const images = [];
    $('.image-row').each(function() {
        const imageUrl = $(this).find('.image-url').val().trim();
        if (imageUrl) {
            images.push({
                id: $(this).find('.image-id').val() || null,
                imageUrl: imageUrl,
                description: $(this).find('.image-description').val().trim(),
                isPrimary: $(this).find('.image-primary').is(':checked')
            });
        }
    });

    // 단계별 조리방법 수집
    const steps = [];
    $('.recipe-step').each(function(index) {
        const stepNumber = index + 1;
        const description = $(this).find('.step-description').val().trim();
        const imageUrl = $(this).find('.step-image-url').val().trim();
        const stepId = $(this).find('.step-id').val() || null;

        steps.push({
            id: stepId,
            stepNumber: stepNumber,
            description: description,
            imageUrl: imageUrl || null
        });
    });

    // 레시피 데이터 구성
    const recipeData = {
        title: $('#title').val().trim(),
        description: $('#description').val().trim(),
        instructions: $('.step-description').map(function() { return $(this).val().trim(); }).get().join('\n\n'), // 단계별 설명을 통합
        cookingTime: $('#cookingTime').val() ? parseInt($('#cookingTime').val()) : null,
        servingSize: $('#servingSize').val() ? parseInt($('#servingSize').val()) : null,
        imageUrl: $('#imageUrl').val().trim(),
        images: images,
        ingredients: ingredients,
        steps: steps
    };

    // 레시피 저장 또는 업데이트
    const recipeId = $('#recipeId').val();
    const url = recipeId ? '/api/recipes/' + recipeId : '/api/recipes';
    const method = recipeId ? 'PUT' : 'POST';

    $.ajax({
        url: url,
        type: method,
        contentType: 'application/json',
        data: JSON.stringify(recipeData),
        success: function(response) {
            alert(recipeId ? '레시피가 수정되었습니다.' : '레시피가 등록되었습니다.');
            window.location.href = '/recipes/' + response.id;
        },
        error: function(error) {
            console.error('Failed to save recipe', error);
            alert('레시피 저장에 실패했습니다.');
        }
    });
}

/**
 * 레시피 평점 목록 로드 함수
 * @param {number} recipeId - 레시피 ID
 */
function loadRatings(recipeId) {
    $.ajax({
        url: `/api/recipes/${recipeId}/ratings`,
        type: 'GET',
        success: function(response) {
            let ratingsHtml = '';
            
            if (response.length === 0) {
                ratingsHtml = '<p class="text-center text-muted">아직 리뷰가 없습니다.</p>';
            } else {
                response.forEach(function(rating) {
                    let starsHtml = generateStarRating(rating.rating);
                    
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
                                    <small class="text-muted">${formatDateTime(rating.createdAt)}</small>
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
            console.error('평점 목록 로드 실패', error);
            $('#ratingsContainer').html('<p class="text-center text-danger">리뷰를 불러오는데 실패했습니다.</p>');
        }
    });
}

/**
 * 재료 행 추가 함수
 */
function addIngredientRow() {
    const newRow = `
        <div class="row ingredient-row mb-2">
            <div class="col-md-5">
                <input type="text" class="form-control ingredient-name" placeholder="재료명" required>
                <input type="hidden" class="ingredient-id">
            </div>
            <div class="col-md-3">
                <input type="number" class="form-control ingredient-quantity" placeholder="수량" step="0.1" min="0" required>
            </div>
            <div class="col-md-2">
                <select class="form-select ingredient-unit">
                    <option value="" selected>단위</option>
                    <option value="g">g</option>
                    <option value="kg">kg</option>
                    <option value="ml">ml</option>
                    <option value="L">L</option>
                    <option value="개">개</option>
                    <option value="조각">조각</option>
                    <option value="줌">줌</option>
                </select>
            </div>
            <div class="col-md-2">
                <div class="form-check pt-2">
                    <input class="form-check-input ingredient-optional" type="checkbox">
                    <label class="form-check-label">선택사항</label>
                </div>
            </div>
            <div class="col-auto d-flex align-items-center">
                <button type="button" class="btn btn-outline-danger btn-sm remove-ingredient">
                    <i data-feather="x"></i>
                </button>
            </div>
        </div>
    `;
    
    $('#ingredientsContainer').append(newRow);
    feather.replace();
    setupIngredientAutocomplete();
}

/**
 * 재료 자동완성 설정 함수
 */
function setupIngredientAutocomplete() {
    $('.ingredient-name').each(function() {
        if ($(this).data('autocomplete-initialized')) return;
        
        $(this).data('autocomplete-initialized', true);
        
        $(this).on('input', function() {
            const $input = $(this);
            const query = $input.val().trim();
            
            if (query.length < 2) {
                // 자동완성 드롭다운 숨기기
                if ($input.next('.autocomplete-dropdown').length) {
                    $input.next('.autocomplete-dropdown').hide();
                }
                return;
            }
            
            $.ajax({
                url: `/api/ingredients/search?query=${encodeURIComponent(query)}`,
                type: 'GET',
                success: function(data) {
                    if (data.length === 0) return;
                    
                    // 자동완성 UI 생성
                    let $dropdown = $input.next('.autocomplete-dropdown');
                    
                    if (!$dropdown.length) {
                        $dropdown = $('<div class="autocomplete-dropdown position-absolute bg-white shadow-sm rounded p-2 mt-1 z-index-1000"></div>');
                        $input.after($dropdown);
                    }
                    
                    let suggestionsHtml = '';
                    data.slice(0, 5).forEach(function(ingredient) {
                        suggestionsHtml += `
                            <div class="autocomplete-item p-2" 
                                data-id="${ingredient.id}" 
                                data-name="${ingredient.name}">
                                ${ingredient.name}
                            </div>
                        `;
                    });
                    
                    $dropdown.html(suggestionsHtml).show();
                }
            });
        });
    });
    
    // 자동완성 항목 클릭 이벤트
    $(document).on('click', '.autocomplete-item', function() {
        const id = $(this).data('id');
        const name = $(this).data('name');
        
        const $row = $(this).closest('.ingredient-row');
        $row.find('.ingredient-name').val(name);
        $row.find('.ingredient-id').val(id);
        
        $(this).parent('.autocomplete-dropdown').hide();
    });
    
    // 다른 곳 클릭 시 자동완성 닫기
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.autocomplete-dropdown, .ingredient-name').length) {
            $('.autocomplete-dropdown').hide();
        }
    });
}

/**
 * 유사한 레시피 로드 함수
 * @param {number} recipeId - 레시피 ID
 */
function loadSimilarRecipes(recipeId) {
    $.ajax({
        url: `/api/recipes/similar?recipeId=${recipeId}&count=3`,
        type: 'GET',
        success: function(response) {
            let recipesHtml = '';
            
            if (response.length === 0) {
                recipesHtml = '<p class="text-center text-muted">유사한 레시피가 없습니다.</p>';
            } else {
                response.forEach(function(recipe) {
                    recipesHtml += `
                        <div class="card mb-3">
                            <div class="row g-0">
                                <div class="col-4">
                                    ${recipe.imageUrl ? 
                                        `<img src="${recipe.imageUrl}" class="img-fluid rounded-start" alt="${recipe.title}">` : 
                                        `<div class="img-fluid rounded-start bg-light d-flex align-items-center justify-content-center" style="height: 100%;">
                                            <i data-feather="camera" class="text-secondary"></i>
                                        </div>`
                                    }
                                </div>
                                <div class="col-8">
                                    <div class="card-body p-2">
                                        <h6 class="card-title">${recipe.title}</h6>
                                        <div class="small rating-stars">
                                            ${generateStarRating(recipe.avgRating)}
                                            <span class="text-muted">(${recipe.ratingCount})</span>
                                        </div>
                                        <a href="/recipes/${recipe.id}" class="stretched-link"></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;
                });
            }
            
            $('#similarRecipes').html(recipesHtml);
            feather.replace();
        },
        error: function(error) {
            console.error('유사한 레시피 로드 실패', error);
            $('#similarRecipes').html('<p class="text-center text-danger">레시피를 불러오는데 실패했습니다.</p>');
        }
    });
}

/**
 * 작성자의 다른 레시피 로드 함수
 * @param {number} userId - 사용자 ID
 * @param {number} currentRecipeId - 현재 레시피 ID (제외할 항목)
 */
function loadAuthorOtherRecipes(userId, currentRecipeId) {
    $.ajax({
        url: `/api/recipes/user/${userId}?count=3&exclude=${currentRecipeId}`,
        type: 'GET',
        success: function(response) {
            let recipesHtml = '';
            
            if (response.length === 0) {
                recipesHtml = '<p class="text-center text-muted">다른 레시피가 없습니다.</p>';
            } else {
                response.forEach(function(recipe) {
                    recipesHtml += `
                        <div class="card mb-3">
                            <div class="row g-0">
                                <div class="col-4">
                                    ${recipe.imageUrl ? 
                                        `<img src="${recipe.imageUrl}" class="img-fluid rounded-start" alt="${recipe.title}">` : 
                                        `<div class="img-fluid rounded-start bg-light d-flex align-items-center justify-content-center" style="height: 100%;">
                                            <i data-feather="camera" class="text-secondary"></i>
                                        </div>`
                                    }
                                </div>
                                <div class="col-8">
                                    <div class="card-body p-2">
                                        <h6 class="card-title">${recipe.title}</h6>
                                        <div class="small rating-stars">
                                            ${generateStarRating(recipe.avgRating)}
                                            <span class="text-muted">(${recipe.ratingCount})</span>
                                        </div>
                                        <a href="/recipes/${recipe.id}" class="stretched-link"></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;
                });
            }
            
            $('#authorOtherRecipes').html(recipesHtml);
            feather.replace();
        },
        error: function(error) {
            console.error('작성자의 다른 레시피 로드 실패', error);
            $('#authorOtherRecipes').html('<p class="text-center text-danger">레시피를 불러오는데 실패했습니다.</p>');
        }
    });
}

/**
 * 냉장고 재료 체크 함수
 * @param {number} recipeId - 레시피 ID
 */
function loadRefrigeratorIngredients(recipeId) {
    $.ajax({
        url: '/api/user/ingredients',
        type: 'GET',
        success: function(userIngredients) {
            // 레시피 재료 가져오기
            $.ajax({
                url: `/api/recipes/${recipeId}`,
                type: 'GET',
                success: function(recipe) {
                    // 냉장고 재료와 레시피 재료 비교
                    let ingredientsHtml = '<ul class="list-group list-group-flush">';
                    
                    recipe.ingredients.forEach(function(recipeIng) {
                        // 냉장고에 해당 재료가 있는지 확인
                        const hasIngredient = userIngredients.some(function(userIng) {
                            return userIng.ingredientId === recipeIng.ingredientId;
                        });
                        
                        ingredientsHtml += `
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span>${recipeIng.name}</span>
                                <span>
                                    ${hasIngredient ? 
                                        '<span class="badge bg-success rounded-pill">있음</span>' : 
                                        '<span class="badge bg-danger rounded-pill">없음</span>'}
                                </span>
                            </li>
                        `;
                    });
                    
                    ingredientsHtml += '</ul>';
                    $('#refrigeratorIngredients').html(ingredientsHtml);
                },
                error: function(error) {
                    console.error('레시피 로드 실패', error);
                    $('#refrigeratorIngredients').html('<p class="text-center text-danger">레시피 정보를 불러오는데 실패했습니다.</p>');
                }
            });
        },
        error: function(error) {
            console.error('사용자 재료 로드 실패', error);
            $('#refrigeratorIngredients').html('<p class="text-center text-danger">냉장고 재료를 불러오는데 실패했습니다.</p>');
        }
    });
}
