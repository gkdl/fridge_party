<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<div class="add-recipe-container">
    <div class="row mb-4">
        <div class="col-md-12">
            <h2>${recipe != null ? '레시피 수정' : '새 레시피 등록'}</h2>
            <p class="text-muted">나만의 레시피를 공유해보세요</p>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-12">
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <form id="recipeForm">
                        <input type="hidden" id="recipeId" value="${recipe != null ? recipe.id : ''}">
                        
                        <div class="mb-3">
                            <label for="title" class="form-label">레시피 제목 *</label>
                            <input type="text" class="form-control" id="title" name="title" required 
                                value="${recipe != null ? recipe.title : ''}">
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">레시피 설명</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${recipe != null ? recipe.description : ''}</textarea>
                            <div class="form-text">레시피에 대한 간단한 설명을 입력해주세요.</div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="cookingTime" class="form-label">조리 시간 (분)</label>
                                <input type="number" class="form-control" id="cookingTime" name="cookingTime" min="1" 
                                    value="${recipe != null ? recipe.cookingTime : ''}">
                            </div>
                            <div class="col-md-6">
                                <label for="servingSize" class="form-label">인분</label>
                                <input type="number" class="form-control" id="servingSize" name="servingSize" min="1" 
                                    value="${recipe != null ? recipe.servingSize : ''}">
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="mainImageFile" class="form-label">대표 이미지</label>
                            <input type="file" class="form-control" id="mainImageFile" name="mainImageFile" accept="image/*">
                            <input type="hidden" id="imageUrl" name="imageUrl" value="${recipe != null ? recipe.imageUrl : ''}">
                            <div class="form-text">완성된 요리 사진을 업로드하세요(대표 이미지로 사용됩니다).</div>
                            <div class="progress mt-2 d-none" id="mainImageProgress">
                                <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                            </div>
                            <div class="mt-2 ${empty recipe.imageUrl ? 'd-none' : ''}" id="mainImagePreview">
                                <img src="${recipe != null ? recipe.imageUrl : ''}" class="img-thumbnail" style="max-height: 200px;" ${empty recipe.imageUrl ? '' : 'data-bs-toggle="modal" data-bs-target="#imagePreviewModal"'}>
                            </div>
                        </div>
                        
                        <!-- 다중 이미지 섹션 -->
                        <div class="mb-3">
                            <label class="form-label">추가 이미지 (최대 5개)</label>
                            <div id="additionalImagesContainer" class="mb-2">
                                <c:if test="${recipe != null && not empty recipe.images}">
                                    <c:forEach items="${recipe.images}" var="image" varStatus="status">

                                        <div class="row image-row mb-2">
                                            <div class="col-md-6">
                                                <input type="url" class="form-control image-url" 
                                                    placeholder="이미지 URL" value="${image.imageUrl}" required>
                                                <input type="hidden" class="image-id" value="${image.id}">
                                            </div>
                                            <div class="col-md-4">
                                                <input type="text" class="form-control image-description" 
                                                    placeholder="이미지 설명(선택사항)" value="${image.description}">
                                            </div>
                                            <div class="col-md-1">
                                                <div class="form-check pt-2">
                                                    <input class="form-check-input image-primary" type="checkbox" 
                                                        ${image.isPrimary ? 'checked' : ''}>
                                                    <label class="form-check-label">대표</label>
                                                </div>
                                            </div>
                                            <div class="col-auto d-flex align-items-center">
                                                <button type="button" class="btn btn-outline-danger btn-sm remove-image">
                                                    <i data-feather="x"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                            <button type="button" id="addImageBtn" class="btn btn-outline-primary">
                                <i data-feather="plus"></i> 이미지 추가
                            </button>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">재료 *</label>
                            <div id="ingredientsContainer" class="mb-2">
                                <c:choose>
                                    <c:when test="${recipe != null && not empty recipe.ingredients}">
                                        <c:forEach items="${recipe.ingredients}" var="ingredient" varStatus="status">
                                            <div class="row ingredient-row mb-2">
                                                <div class="col-md-5">
                                                    <input type="text" class="form-control ingredient-name" 
                                                        placeholder="재료명" value="${ingredient.name}" required>
                                                    <input type="hidden" class="ingredient-id" value="${ingredient.ingredientId}">
                                                </div>
                                                <div class="col-md-3">
                                                    <input type="number" class="form-control ingredient-quantity" 
                                                        placeholder="수량" value="${ingredient.quantity}" step="0.01" min="0" required>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select ingredient-unit">
                                                        <option value="" ${empty ingredient.unit ? 'selected' : ''}>단위</option>
                                                        <option value="g" ${ingredient.unit == 'g' ? 'selected' : ''}>g</option>
                                                        <option value="kg" ${ingredient.unit == 'kg' ? 'selected' : ''}>kg</option>
                                                        <option value="ml" ${ingredient.unit == 'ml' ? 'selected' : ''}>ml</option>
                                                        <option value="L" ${ingredient.unit == 'L' ? 'selected' : ''}>L</option>
                                                        <option value="개" ${ingredient.unit == '개' ? 'selected' : ''}>개</option>
                                                        <option value="조각" ${ingredient.unit == '조각' ? 'selected' : ''}>조각</option>
                                                        <option value="줌" ${ingredient.unit == '줌' ? 'selected' : ''}>줌</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-check pt-2">
                                                        <input class="form-check-input ingredient-optional" type="checkbox" 
                                                            ${ingredient.optional ? 'checked' : ''}>
                                                        <label class="form-check-label">선택사항</label>
                                                    </div>
                                                </div>
                                                <div class="col-auto d-flex align-items-center">
                                                    <button type="button" class="btn btn-outline-danger btn-sm remove-ingredient">
                                                        <i data-feather="x"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
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
                                                    <option value="" ${empty ingredient.unit ? 'selected' : ''}>단위</option>
                                                    <option value="g" ${ingredient.unit == 'g' ? 'selected' : ''}>g</option>
                                                    <option value="kg" ${ingredient.unit == 'kg' ? 'selected' : ''}>kg</option>
                                                    <option value="ml" ${ingredient.unit == 'ml' ? 'selected' : ''}>ml</option>
                                                    <option value="L" ${ingredient.unit == 'L' ? 'selected' : ''}>L</option>
                                                    <option value="개" ${ingredient.unit == '개' ? 'selected' : ''}>개</option>
                                                    <option value="조각" ${ingredient.unit == '조각' ? 'selected' : ''}>조각</option>
                                                    <option value="줌" ${ingredient.unit == '줌' ? 'selected' : ''}>줌</option>
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
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <button type="button" id="addIngredientBtn" class="btn btn-outline-primary">
                                <i data-feather="plus"></i> 재료 추가
                            </button>
                        </div>
                        
                        <!-- 단계별 조리 방법 섹션 -->
                        <div class="mb-3">
                            <label class="form-label">조리 방법 (단계별) *</label>
                            <div id="stepsContainer" class="mb-2">
                                <c:choose>
                                    <c:when test="${recipe != null && not empty recipe.steps}">
                                        <c:forEach items="${recipe.steps}" var="step" varStatus="status">
                                            <div class="card mb-3 recipe-step">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <h5 class="mb-0">단계 ${step.stepNumber}</h5>
                                                    <button type="button" class="btn btn-outline-danger btn-sm remove-step">
                                                        <i data-feather="x"></i>
                                                    </button>
                                                </div>
                                                <div class="card-body">
                                                    <input type="hidden" class="step-id" value="${step.id}">
                                                    <input type="hidden" class="step-number" value="${step.stepNumber}">
                                                    <div class="mb-3">
                                                        <label class="form-label">설명</label>
                                                        <textarea class="form-control step-description" rows="3" required>${step.description}</textarea>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">이미지 (선택사항)</label>
                                                        <input type="file" class="form-control step-image-file" accept="image/*">
                                                        <input type="hidden" class="step-image-url" value="${step.imageUrl}">
                                                        <small class="form-text text-muted">단계별 이미지를 업로드하세요 (권장: 800x600px)</small>
                                                    </div>
                                                    <div class="progress mt-2 d-none step-image-progress">
                                                        <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                                    </div>
                                                    <div class="step-image-preview-container mt-2 ${empty step.imageUrl ? 'd-none' : ''}">
                                                        <img src="${step.imageUrl}" class="img-thumbnail step-image-preview" style="max-height: 200px;" alt="단계 이미지 미리보기" ${empty step.imageUrl ? '' : 'data-bs-toggle="modal" data-bs-target="#imagePreviewModal"'}>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card mb-3 recipe-step">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <h5 class="mb-0">단계 1</h5>
                                                <button type="button" class="btn btn-outline-danger btn-sm remove-step">
                                                    <i data-feather="x"></i>
                                                </button>
                                            </div>
                                            <div class="card-body">
                                                <input type="hidden" class="step-id" value="">
                                                <input type="hidden" class="step-number" value="1">
                                                <div class="mb-3">
                                                    <label class="form-label">설명</label>
                                                    <textarea class="form-control step-description" rows="3" required></textarea>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">이미지 (선택사항)</label>
                                                    <input type="file" class="form-control step-image-file" accept="image/*">
                                                    <input type="hidden" class="step-image-url">
                                                    <small class="form-text text-muted">단계별 이미지를 업로드하세요 (권장: 800x600px)</small>
                                                </div>
                                                <div class="progress mt-2 d-none step-image-progress">
                                                    <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                                </div>
                                                <div class="step-image-preview-container mt-2 d-none">
                                                    <img src="" class="img-thumbnail step-image-preview" style="max-height: 200px;" alt="단계 이미지 미리보기">
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <button type="button" id="addStepBtn" class="btn btn-outline-primary">
                                <i data-feather="plus"></i> 단계 추가
                            </button>
                        </div>
                        
                        <!-- 기존 단일 조리방법 필드 (hidden으로 변경) -->
                        <div class="mb-3 d-none">
                            <label for="instructions" class="form-label">조리 방법 (레거시) *</label>
                            <textarea class="form-control" id="instructions" name="instructions" rows="10">${recipe != null ? recipe.instructions : ''}</textarea>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <button type="button" class="btn btn-secondary" id="cancelBtn">취소</button>
                            <button type="submit" class="btn btn-primary" id="saveRecipeBtn">저장</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="/resources/js/recipe.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log("asdasd")
        feather.replace();
        
        // 재료 자동완성 설정
        setupIngredientAutocomplete();
        
        // 이미지 추가 버튼 이벤트
        $('#addImageBtn').click(function() {
            addImageRow();
        });
        
        // 이미지 삭제 버튼 이벤트
        $(document).on('click', '.remove-image', function() {
            $(this).closest('.image-row').remove();
        });
        
        // 이미지 대표 체크박스 이벤트
        $(document).on('change', '.image-primary', function() {
            if ($(this).is(':checked')) {
                // 다른 체크박스 해제
                $('.image-primary').not(this).prop('checked', false);
            }
        });
        
        // 재료 추가 버튼 이벤트
        $('#addIngredientBtn').click(function() {
            addIngredientRow();
        });
        
        // 재료 삭제 버튼 이벤트
        $(document).on('click', '.remove-ingredient', function() {
            if ($('.ingredient-row').length > 1) {
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
        
        // 단계 추가 버튼 이벤트
        $('#addStepBtn').click(function() {
            addRecipeStep();
        });
        
        // 단계 삭제 버튼 이벤트
        $(document).on('click', '.remove-step', function() {
            if ($('.recipe-step').length > 1) {
                $(this).closest('.recipe-step').remove();
                // 단계 번호 재정렬
                updateStepNumbers();
            } else {
                alert('최소 1개 이상의 조리 단계가 필요합니다.');
            }
        });
        
        // 단계별 이미지 URL 변경 이벤트
        $(document).on('change', '.step-image-url', function() {
            const imageUrl = $(this).val().trim();
            const $previewContainer = $(this).closest('.card-body').find('.step-image-preview-container');
            const $preview = $previewContainer.find('.step-image-preview');
            
            if (imageUrl) {
                $preview.attr('src', imageUrl);
                $previewContainer.removeClass('d-none');
                $preview.attr('data-bs-toggle', 'modal');
                $preview.attr('data-bs-target', '#imagePreviewModal');
            } else {
                $previewContainer.addClass('d-none');
                $preview.removeAttr('data-bs-toggle');
                $preview.removeAttr('data-bs-target');
            }
        });
        
        // 대표 이미지 파일 업로드 이벤트
        $('#mainImageFile').change(function() {
            uploadImage(this, 'recipe', function(imageUrl) {
                $('#imageUrl').val(imageUrl);
                $('#mainImagePreview').removeClass('d-none')
                    .find('img').attr('src', imageUrl)
                    .attr('data-bs-toggle', 'modal')
                    .attr('data-bs-target', '#imagePreviewModal');
            });
        });
        
        // 단계별 이미지 파일 업로드 이벤트
        $(document).on('change', '.step-image-file', function() {
            const $stepImageUrl = $(this).closest('.mb-3').find('.step-image-url');
            const $previewContainer = $(this).closest('.card-body').find('.step-image-preview-container');
            const $preview = $previewContainer.find('.step-image-preview');
            const $progressContainer = $(this).closest('.card-body').find('.step-image-progress');
            
            uploadImage(this, 'step', function(imageUrl) {
                $stepImageUrl.val(imageUrl).trigger('change');
                $preview.attr('src', imageUrl);
                $previewContainer.removeClass('d-none');
                $preview.attr('data-bs-toggle', 'modal');
                $preview.attr('data-bs-target', '#imagePreviewModal');
                $progressContainer.addClass('d-none');
            }, $progressContainer);
        });
        
        // 추가 이미지 파일 업로드 이벤트
        $(document).on('change', '.additional-image-file', function() {
            const $row = $(this).closest('.image-row');
            const $imageUrl = $row.find('.image-url');
            const $progressContainer = $row.find('.additional-image-progress');
            const $preview = $row.find('.additional-image-preview');
            const $previewImg = $preview.find('img');
            
            uploadImage(this, 'recipe', function(imageUrl) {
                $imageUrl.val(imageUrl);
                $previewImg.attr('src', imageUrl);
                $preview.removeClass('d-none');
                $progressContainer.addClass('d-none');
            }, $progressContainer);
        });
    });
    
    // 재료 행 추가 함수
    function addIngredientRow() {
        const newRow = `
            <div class="row ingredient-row mb-2">
                <div class="col-md-5">
                    <input type="text" class="form-control ingredient-name" placeholder="재료명" required>
                    <input type="hidden" class="ingredient-id">
                </div>
                <div class="col-md-3">
                    <input type="number" class="form-control ingredient-quantity" placeholder="수량" step="0.01" min="0" required>
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
    
    // 이미지 행 추가 함수
    function addImageRow() {
        // 최대 5개 제한
        if ($('.image-row').length >= 5) {
            alert('이미지는 최대 5개까지 추가할 수 있습니다.');
            return;
        }
        
        const newRow = `
            <div class="row image-row mb-2">
                <div class="col-md-5">
                    <div class="input-group">
                        <input type="file" class="form-control additional-image-file" accept="image/*">
                        <input type="hidden" class="image-url">
                        <input type="hidden" class="image-id">
                    </div>
                    <div class="progress mt-2 d-none additional-image-progress">
                        <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <input type="text" class="form-control image-description" placeholder="이미지 설명(선택사항)">
                </div>
                <div class="col-md-1">
                    <div class="form-check pt-2">
                        <input class="form-check-input image-primary" type="checkbox">
                        <label class="form-check-label">대표</label>
                    </div>
                </div>
                <div class="col-auto d-flex align-items-center">
                    <button type="button" class="btn btn-outline-danger btn-sm remove-image">
                        <i data-feather="x"></i>
                    </button>
                </div>
                <div class="col-12 mt-2 additional-image-preview d-none">
                    <img src="" class="img-thumbnail" style="max-height: 100px;" alt="추가 이미지 미리보기">
                </div>
            </div>
        `;
        
        $('#additionalImagesContainer').append(newRow);
        feather.replace();
    }
    
    // 재료 자동완성 설정 함수
    function setupIngredientAutocomplete() {
        $('.ingredient-name').each(function() {
            if ($(this).data('autocomplete-initialized')) return;
            
            $(this).data('autocomplete-initialized', true);
            
            $(this).on('input', function() {
                const $input = $(this);
                const query = $input.val().trim();
                
                if (query.length < 2) return;
                
                $.ajax({
                    url: '/api/ingredients/search?query=' + query,
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
        });
    }
    
    // 레시피 단계 추가 함수
    function addRecipeStep() {
        const stepNumber = $('.recipe-step').length + 1;

        const newStep =
            '<div class="card mb-3 recipe-step">' +
            '<div class="card-header d-flex justify-content-between align-items-center">' +
            '<h5 class="mb-0">단계 ' + stepNumber + '</h5>' +
            '    <button type="button" class="btn btn-outline-danger btn-sm remove-step">' +
            '        <i data-feather="x"></i>' +
            '    </button>' +
            '</div>' +
            '    <div class="card-body">' +
            '        <input type="hidden" class="step-id" value="">' +
            '            <input type="hidden" class="step-number" value="' + stepNumber + '">'
            '                <div class="mb-3">' +
            '                    <label class="form-label">설명</label>' +
            '                    <textarea class="form-control step-description" rows="3" required></textarea>' +
            '                </div>' +
            '                <div class="mb-3">' +
            '                    <label class="form-label">이미지 (선택사항)</label>' +
            '                    <input type="file" class="form-control step-image-file" accept="image/*">' +
            '                        <input type="hidden" class="step-image-url">' +
            '                            <small class="form-text text-muted">단계별 이미지를 업로드하세요 (권장: 800x600px)</small>' +
            '                </div>' +
            '                <div class="progress mt-2 d-none step-image-progress">' +
            '                    <div class="progress-bar" role="progressbar" style="width: 0%"></div>' +
            '                </div>' +
            '                <div class="step-image-preview-container mt-2 d-none">' +
            '                    <img src="" class="img-thumbnail step-image-preview" style="max-height: 200px;" alt="단계 이미지 미리보기">' +
            '                </div>' +
            '    </div>' +
            '</div>';

        $('#stepsContainer').append(newStep);
        feather.replace();
    }
    
    // 단계 번호 재정렬 함수
    function updateStepNumbers() {
        $('.recipe-step').each(function(index) {
            const stepNumber = index + 1;
            $(this).find('.card-header h5').text('단계 ' + stepNumber);
            $(this).find('.step-number').val(stepNumber);
        });
    }
    
    // 이미지 업로드 함수
    function uploadImage(fileInput, type, callback, $progressContainer) {
        if (!fileInput.files || !fileInput.files[0]) {
            return;
        }
        
        const file = fileInput.files[0];
        const formData = new FormData();
        formData.append('file', file);
        formData.append('type', type);
        
        // 진행 상황 표시 초기화
        if ($progressContainer) {
            $progressContainer.removeClass('d-none')
                .find('.progress-bar')
                .css('width', '0%')
                .attr('aria-valuenow', 0);
        } else if (type === 'recipe') {
            $('#mainImageProgress').removeClass('d-none')
                .find('.progress-bar')
                .css('width', '0%')
                .attr('aria-valuenow', 0);
        }
        
        $.ajax({
            url: '/api/upload/image',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            xhr: function() {
                const xhr = new window.XMLHttpRequest();
                
                // 업로드 진행 상황 표시
                xhr.upload.addEventListener('progress', function(e) {
                    if (e.lengthComputable) {
                        const percentComplete = (e.loaded / e.total) * 100;
                        const $progressBar = $progressContainer ? 
                            $progressContainer.find('.progress-bar') : 
                            $('#mainImageProgress').find('.progress-bar');
                            
                        $progressBar.css('width', percentComplete + '%')
                            .attr('aria-valuenow', percentComplete);
                    }
                }, false);
                
                return xhr;
            },
            success: function(response) {
                if (response.success) {
                    callback(response.imageUrl);
                } else {
                    alert('이미지 업로드 실패: ' + (response.error || '알 수 없는 오류'));
                    
                    if ($progressContainer) {
                        $progressContainer.addClass('d-none');
                    } else if (type === 'recipe') {
                        $('#mainImageProgress').addClass('d-none');
                    }
                }
            },
            error: function() {
                alert('서버 오류로 이미지 업로드에 실패했습니다.');
                
                if ($progressContainer) {
                    $progressContainer.addClass('d-none');
                } else if (type === 'recipe') {
                    $('#mainImageProgress').addClass('d-none');
                }
            }
        });
    }
</script>

<jsp:include page="include/footer.jsp" />
