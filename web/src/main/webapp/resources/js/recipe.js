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
                quantity: quantity,
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
        season: $('#season').val(), // 계절 정보 추가
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
