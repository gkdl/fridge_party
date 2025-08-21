<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<div class="my-refrigerator-container">
    <div class="row mb-4">
        <div class="col-md-6">
            <h2>내 냉장고 관리</h2>
            <p class="text-muted">가지고 있는 재료를 등록하고 관리하세요.</p>
            
            <c:if test="${not empty currentSeason}">
                <div class="d-flex align-items-center mt-3">
                    <span class="badge bg-primary rounded-pill me-2 py-2 px-3 d-inline-flex align-items-center">
                        <i data-feather="${currentSeason eq 'SPRING' ? 'sun' : currentSeason eq 'SUMMER' ? 'cloud-rain' : currentSeason eq 'FALL' ? 'cloud' : 'cloud-snow'}" class="me-1" style="width: 16px; height: 16px;"></i>
                        현재 계절: ${seasonKr}
                    </span>
                    <a href="${pageContext.request.contextPath}/ingredients/seasonal" class="text-decoration-none ms-2">
                        <i data-feather="info" class="me-1" style="width: 16px; height: 16px;"></i>
                        계절별 제철 식재료 보기
                    </a>
                </div>
            </c:if>
        </div>
        <div class="col-md-6 text-md-end">
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addIngredientModal">
                <i data-feather="plus"></i> 재료 추가
            </button>
            <button class="btn btn-success" id="findRecipesBtn">
                <i data-feather="search"></i> 레시피 찾기
            </button>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-12">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light">
                    <ul class="nav nav-tabs card-header-tabs" id="ingredientCategoryTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button" role="tab" aria-controls="all" aria-selected="true">전체</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="seasonal-tab" data-bs-toggle="tab" data-bs-target="#seasonal" type="button" role="tab" aria-controls="seasonal" aria-selected="false">
                                <i data-feather="star" class="me-1" style="width: 14px; height: 14px;"></i>제철 식재료
                            </button>
                        </li>
<%--                        <li class="nav-item" role="presentation">--%>
<%--                            <button class="nav-link" id="vegetables-tab" data-bs-toggle="tab" data-bs-target="#vegetables" type="button" role="tab" aria-controls="vegetables" aria-selected="false">채소류</button>--%>
<%--                        </li>--%>
<%--                        <li class="nav-item" role="presentation">--%>
<%--                            <button class="nav-link" id="meat-tab" data-bs-toggle="tab" data-bs-target="#meat" type="button" role="tab" aria-controls="meat" aria-selected="false">육류</button>--%>
<%--                        </li>--%>
<%--                        <li class="nav-item" role="presentation">--%>
<%--                            <button class="nav-link" id="seafood-tab" data-bs-toggle="tab" data-bs-target="#seafood" type="button" role="tab" aria-controls="seafood" aria-selected="false">해산물</button>--%>
<%--                        </li>--%>
<%--                        <li class="nav-item" role="presentation">--%>
<%--                            <button class="nav-link" id="dairy-tab" data-bs-toggle="tab" data-bs-target="#dairy" type="button" role="tab" aria-controls="dairy" aria-selected="false">유제품</button>--%>
<%--                        </li>--%>
<%--                        <li class="nav-item" role="presentation">--%>
<%--                            <button class="nav-link" id="other-tab" data-bs-toggle="tab" data-bs-target="#other" type="button" role="tab" aria-controls="other" aria-selected="false">기타</button>--%>
<%--                        </li>--%>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content" id="ingredientCategoryTabsContent">
                        <div class="tab-pane fade show active" id="all" role="tabpanel" aria-labelledby="all-tab">
                            <div id="ingredientList" class="row row-cols-1 row-cols-md-3 g-4">
                                <c:choose>
                                    <c:when test="${empty ingredients}">
                                        <div class="col-12 text-center py-5">
                                            <i data-feather="archive" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                                            <h5 class="text-muted">냉장고가 비어있습니다</h5>
                                            <p class="text-muted">재료를 추가해 보세요!</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${ingredients}" var="ingredient">
                                            <div class="col" data-category="${ingredient.category}">
                                                <div class="card h-100">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                                            <h5 class="card-title mb-0">${ingredient.ingredientName}</h5>
                                                            <div class="dropdown">
                                                                <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                                    <i data-feather="more-vertical"></i>
                                                                </button>
                                                                <ul class="dropdown-menu">
                                                                    <li><a class="dropdown-item edit-ingredient" href="#" data-id="${ingredient.id}" data-name="${ingredient.ingredientName}" data-quantity="${ingredient.quantity}" data-unit="${ingredient.unit}" data-expiry="${ingredient.expiryDate}">수정</a></li>
                                                                    <li><a class="dropdown-item delete-ingredient" href="#" data-id="${ingredient.id}">삭제</a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                        <p class="card-text">
                                                            <span class="badge bg-primary rounded-pill">${ingredient.quantity} ${ingredient.unit != null ? ingredient.unit : ''}</span>
                                                            <c:if test="${not empty ingredient.expiryDate}">
                                                                <span class="badge bg-warning rounded-pill expiry-date" data-date="${ingredient.expiryDate}">
                                                                    유통기한: ${ingredient.expiryDate}
                                                                </span>
                                                            </c:if>
                                                            
                                                            <c:if test="${not empty ingredient.inSeason and ingredient.inSeason == true}">
                                                                <span class="badge bg-success rounded-pill mt-2 d-block w-50">
                                                                    <i data-feather="check-circle" class="me-1" style="width: 14px; height: 14px;"></i>
                                                                    제철 식재료
                                                                </span>
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="seasonal" role="tabpanel" aria-labelledby="seasonal-tab">
                            <div class="seasonal-items">
                                <c:choose>
                                    <c:when test="${empty inSeasonIngredients}">
                                        <div class="col-12 text-center py-5">
                                            <i data-feather="alert-triangle" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                                            <h5 class="text-muted">제철 식재료가 없습니다</h5>
                                            <p class="text-muted">
                                                현재 냉장고에 ${seasonKr} 제철 식재료가 없습니다.<br>
                                                <a href="/ingredients/seasonal" class="text-decoration-none">제철 식재료 보러가기</a>
                                            </p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="row mb-4">
                                            <div class="col-md-12">
                                                <div class="alert alert-success" role="alert">
                                                    <h5 class="alert-heading">
                                                        <i data-feather="info" class="me-2" style="width: 18px; height: 18px;"></i>
                                                        ${seasonKr} 제철 식재료
                                                    </h5>
                                                    <p class="mb-0">제철 식재료는 맛과 영양이 풍부하고 가격도 비교적 저렴합니다. 제철 식재료로 건강한 요리를 만들어보세요!</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row row-cols-1 row-cols-md-3 g-4">
                                            <c:forEach items="${inSeasonIngredients}" var="ingredient">
                                                <div class="col">
                                                    <div class="card h-100 border-success border-2">
                                                        <div class="card-body">
                                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                                <h5 class="card-title mb-0">${ingredient.ingredientName}</h5>
                                                                <div class="dropdown">
                                                                    <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                                        <i data-feather="more-vertical"></i>
                                                                    </button>
                                                                    <ul class="dropdown-menu">
                                                                        <li><a class="dropdown-item edit-ingredient" href="#" data-id="${ingredient.id}" data-name="${ingredient.ingredientName}" data-quantity="${ingredient.quantity}" data-unit="${ingredient.unit}" data-expiry="${ingredient.expiryDate}">수정</a></li>
                                                                        <li><a class="dropdown-item delete-ingredient" href="#" data-id="${ingredient.id}">삭제</a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <p class="card-text">
                                                                <span class="badge bg-primary rounded-pill">${ingredient.quantity} ${ingredient.unit != null ? ingredient.unit : ''}</span>
                                                                <c:if test="${not empty ingredient.expiryDate}">
                                                                    <span class="badge bg-warning rounded-pill expiry-date" data-date="${ingredient.expiryDate}">
                                                                        유통기한: ${ingredient.expiryDate}
                                                                    </span>
                                                                </c:if>
                                                                <span class="badge bg-success rounded-pill mt-2 d-block w-50">
                                                                    <i data-feather="check-circle" class="me-1" style="width: 14px; height: 14px;"></i>
                                                                    제철 식재료
                                                                </span>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
<%--                        <div class="tab-pane fade" id="vegetables" role="tabpanel" aria-labelledby="vegetables-tab">--%>
<%--                            <div class="vegetable-items">--%>
<%--                                <!-- 채소류 아이템이 필터링되어 표시됩니다 -->--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="tab-pane fade" id="meat" role="tabpanel" aria-labelledby="meat-tab">--%>
<%--                            <div class="meat-items">--%>
<%--                                <!-- 육류 아이템이 필터링되어 표시됩니다 -->--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="tab-pane fade" id="seafood" role="tabpanel" aria-labelledby="seafood-tab">--%>
<%--                            <div class="seafood-items">--%>
<%--                                <!-- 해산물 아이템이 필터링되어 표시됩니다 -->--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="tab-pane fade" id="dairy" role="tabpanel" aria-labelledby="dairy-tab">--%>
<%--                            <div class="dairy-items">--%>
<%--                                <!-- 유제품 아이템이 필터링되어 표시됩니다 -->--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="tab-pane fade" id="other" role="tabpanel" aria-labelledby="other-tab">--%>
<%--                            <div class="other-items">--%>
<%--                                <!-- 기타 아이템이 필터링되어 표시됩니다 -->--%>
<%--                            </div>--%>
<%--                        </div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row mt-4">
        <div class="col-md-12">
            <div class="card shadow-sm">
                <div class="card-header bg-light">
                    <h5 class="mb-0">내 재료로 만들 수 있는 추천 레시피</h5>
                </div>
                <div class="card-body">
                    <div id="recommendedRecipes" class="row row-cols-1 row-cols-md-3 g-4">
                        <div class="col-12 text-center py-5" id="loadingRecipes">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="text-muted mt-2">레시피를 찾고 있습니다...</p>
                        </div>
                        <div class="col-12 text-center py-5 d-none" id="noRecipes">
                            <i data-feather="book" class="text-muted mb-3" style="width: 48px; height: 48px;"></i>
                            <h5 class="text-muted">추천 레시피가 없습니다</h5>
                            <p class="text-muted">다양한 재료를 추가하면 더 많은 레시피를 추천받을 수 있습니다!</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 재료 추가 모달 -->
<div class="modal fade" id="addIngredientModal" tabindex="-1" aria-labelledby="addIngredientModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addIngredientModalLabel">재료 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addIngredientForm">
                    <div class="mb-3">
                        <label for="ingredientSearch" class="form-label">재료 검색</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="ingredientSearch" placeholder="재료 이름 입력">
                            <button class="btn btn-outline-secondary" type="button" id="searchIngredientBtn">검색</button>
                        </div>
                    </div>
                    
                    <div class="mb-3 d-none" id="ingredientSearchResults">
                        <label class="form-label">검색 결과</label>
                        <div class="list-group" id="ingredientSearchResultsList"></div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="ingredientName" class="form-label">재료 이름</label>
                        <input type="text" class="form-control" id="ingredientName" name="name" readonly required>
                        <input type="hidden" id="ingredientId" name="ingredientId">
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-8">
                            <label for="quantity" class="form-label">수량</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" step="0.1" min="0">
                        </div>
                        <div class="col-4">
                            <label for="unit" class="form-label">단위</label>
                            <select class="form-select" id="unit" name="unit">
                                <option value="">선택</option>
                                <option value="g">g</option>
                                <option value="kg">kg</option>
                                <option value="ml">ml</option>
                                <option value="L">L</option>
                                <option value="개">개</option>
                                <option value="컵">컵</option>
                                <option value="모">모</option>
                                <option value="알">알</option>
                                <option value="대">대</option>
                                <option value="송이">송이</option>
                                <option value="조각">조각</option>
                                <option value="마리">마리</option>
                                <option value="쪽">쪽</option>
                                <option value="줌">줌</option>
                                <option value="개 분량">개 분량</option>
                                <option value="장">장</option>
                                <option value="단">단</option>
                                <option value="작은술">작은술</option>
                                <option value="큰술">큰술</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="expiryDate" class="form-label">유통기한 (선택)</label>
                        <input type="date" class="form-control" id="expiryDate" name="expiryDate">
                    </div>


<%--                    <div class="card mb-3 border-primary">--%>
<%--                        <div class="card-header bg-primary text-white">--%>
<%--                            <h6 class="mb-0">계절별 가용성 설정</h6>--%>
<%--                        </div>--%>
<%--                        <div class="card-body">--%>
<%--                            <p class="text-muted small mb-3">이 재료가 각 계절에 얼마나 구하기 쉬운지 설정합니다.</p>--%>
<%--                            <div class="row mb-2">--%>
<%--                                <div class="col-3">--%>
<%--                                    <label class="form-label">봄</label>--%>
<%--                                    <select class="form-select form-select-sm" id="editSpringAvailability" name="springAvailability">--%>
<%--                                        <option value="NONE">없음</option>--%>
<%--                                        <option value="LOW">적음</option>--%>
<%--                                        <option value="MEDIUM">보통</option>--%>
<%--                                        <option value="HIGH">풍부함</option>--%>
<%--                                    </select>--%>
<%--                                </div>--%>
<%--                                <div class="col-3">--%>
<%--                                    <label class="form-label">여름</label>--%>
<%--                                    <select class="form-select form-select-sm" id="editSummerAvailability" name="summerAvailability">--%>
<%--                                        <option value="NONE">없음</option>--%>
<%--                                        <option value="LOW">적음</option>--%>
<%--                                        <option value="MEDIUM">보통</option>--%>
<%--                                        <option value="HIGH">풍부함</option>--%>
<%--                                    </select>--%>
<%--                                </div>--%>
<%--                                <div class="col-3">--%>
<%--                                    <label class="form-label">가을</label>--%>
<%--                                    <select class="form-select form-select-sm" id="editFallAvailability" name="fallAvailability">--%>
<%--                                        <option value="NONE">없음</option>--%>
<%--                                        <option value="LOW">적음</option>--%>
<%--                                        <option value="MEDIUM">보통</option>--%>
<%--                                        <option value="HIGH">풍부함</option>--%>
<%--                                    </select>--%>
<%--                                </div>--%>
<%--                                <div class="col-3">--%>
<%--                                    <label class="form-label">겨울</label>--%>
<%--                                    <select class="form-select form-select-sm" id="editWinterAvailability" name="winterAvailability">--%>
<%--                                        <option value="NONE">없음</option>--%>
<%--                                        <option value="LOW">적음</option>--%>
<%--                                        <option value="MEDIUM">보통</option>--%>
<%--                                        <option value="HIGH">풍부함</option>--%>
<%--                                    </select>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                            <div class="d-flex align-items-center">--%>
<%--                                <span class="badge bg-success me-1"></span> 풍부함--%>
<%--                                <span class="badge bg-primary mx-1"></span> 보통--%>
<%--                                <span class="badge bg-warning mx-1"></span> 적음--%>
<%--                                <span class="badge bg-light text-muted mx-1"></span> 없음--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="saveIngredientBtn">저장</button>
            </div>
        </div>
    </div>
</div>

<!-- 재료 편집 모달 -->
<div class="modal fade" id="editIngredientModal" tabindex="-1" aria-labelledby="editIngredientModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editIngredientModalLabel">재료 편집</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editIngredientForm">
                    <input type="hidden" id="editIngredientId" name="id">
                    <div class="mb-3">
                        <label for="editIngredientName" class="form-label">재료 이름</label>
                        <input type="text" class="form-control" id="editIngredientName" name="name" readonly>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-8">
                            <label for="editQuantity" class="form-label">수량</label>
                            <input type="number" class="form-control" id="editQuantity" name="quantity" step="0.1" min="0">
                        </div>
                        <div class="col-4">
                            <label for="editUnit" class="form-label">단위</label>
                            <select class="form-select" id="editUnit" name="unit">
                                <option value="">선택</option>
                                <option value="g">g</option>
                                <option value="kg">kg</option>
                                <option value="ml">ml</option>
                                <option value="L">L</option>
                                <option value="개">개</option>
                                <option value="컵">컵</option>
                                <option value="모">모</option>
                                <option value="알">알</option>
                                <option value="대">대</option>
                                <option value="송이">송이</option>
                                <option value="조각">조각</option>
                                <option value="마리">마리</option>
                                <option value="쪽">쪽</option>
                                <option value="줌">줌</option>
                                <option value="개 분량">개 분량</option>
                                <option value="장">장</option>
                                <option value="단">단</option>
                                <option value="작은술">작은술</option>
                                <option value="큰술">큰술</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="editExpiryDate" class="form-label">유통기한 (선택)</label>
                        <input type="date" class="form-control" id="editExpiryDate" name="expiryDate">
                    </div>

<%--                    <div class="card mb-3 border-primary">--%>
<%--                        <div class="card-header bg-primary text-white">--%>
<%--                            <h6 class="mb-0">계절별 가용성 설정</h6>--%>
<%--                        </div>--%>
<%--                        <div class="card-body">--%>
<%--                            <p class="text-muted small mb-3">이 재료가 각 계절에 얼마나 구하기 쉬운지 설정합니다.</p>--%>
<%--                            <div class="row mb-2">--%>
<%--                                <div class="col-3">--%>
<%--                                    <label class="form-label">봄</label>--%>
<%--                                    <select class="form-select form-select-sm" id="editSpringAvailability" name="springAvailability">--%>
<%--                                        <option value="NONE">없음</option>--%>
<%--                                        <option value="LOW">적음</option>--%>
<%--                                        <option value="MEDIUM">보통</option>--%>
<%--                                        <option value="HIGH">풍부함</option>--%>
<%--                                    </select>--%>
<%--                                </div>--%>
<%--                                <div class="col-3">--%>
<%--                                    <label class="form-label">여름</label>--%>
<%--                                    <select class="form-select form-select-sm" id="editSummerAvailability" name="summerAvailability">--%>
<%--                                        <option value="NONE">없음</option>--%>
<%--                                        <option value="LOW">적음</option>--%>
<%--                                        <option value="MEDIUM">보통</option>--%>
<%--                                        <option value="HIGH">풍부함</option>--%>
<%--                                    </select>--%>
<%--                                </div>--%>
<%--                                <div class="col-3">--%>
<%--                                    <label class="form-label">가을</label>--%>
<%--                                    <select class="form-select form-select-sm" id="editFallAvailability" name="fallAvailability">--%>
<%--                                        <option value="NONE">없음</option>--%>
<%--                                        <option value="LOW">적음</option>--%>
<%--                                        <option value="MEDIUM">보통</option>--%>
<%--                                        <option value="HIGH">풍부함</option>--%>
<%--                                    </select>--%>
<%--                                </div>--%>
<%--                                <div class="col-3">--%>
<%--                                    <label class="form-label">겨울</label>--%>
<%--                                    <select class="form-select form-select-sm" id="editWinterAvailability" name="winterAvailability">--%>
<%--                                        <option value="NONE">없음</option>--%>
<%--                                        <option value="LOW">적음</option>--%>
<%--                                        <option value="MEDIUM">보통</option>--%>
<%--                                        <option value="HIGH">풍부함</option>--%>
<%--                                    </select>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                            <div class="d-flex align-items-center">--%>
<%--                                <span class="badge bg-success me-1"></span> 풍부함--%>
<%--                                <span class="badge bg-primary mx-1"></span> 보통--%>
<%--                                <span class="badge bg-warning mx-1"></span> 적음--%>
<%--                                <span class="badge bg-light text-muted mx-1"></span> 없음--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="updateIngredientBtn">저장</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/ingredient.js"></script>
<script>
    // Feather 아이콘 초기화
    document.addEventListener('DOMContentLoaded', function() {
        feather.replace();
        
        // 재료 카테고리 탭 필터링
        const filterIngredients = function(category) {
            if (category === 'all') {
                $('#ingredientList .col').show();
            } else {
                $('#ingredientList .col').hide();
                $('#ingredientList .col[data-category="' + category + '"]').show();
            }
        };
        
        // 카테고리 탭 이벤트 리스너
        $('#vegetables-tab').click(function() {
            filterIngredients('채소류');
        });
        
        $('#meat-tab').click(function() {
            filterIngredients('육류');
        });
        
        $('#seafood-tab').click(function() {
            filterIngredients('해산물');
        });
        
        $('#dairy-tab').click(function() {
            filterIngredients('유제품');
        });
        
        $('#other-tab').click(function() {
            filterIngredients('기타');
        });
        
        $('#all-tab').click(function() {
            filterIngredients('all');
        });
        
        // 제철 식재료 탭
        $('#seasonal-tab').click(function() {
            // 전체 재료 숨기기
            $('#ingredientList .col').hide();
            // 제철 식재료만 표시
            $('#ingredientList .col').each(function() {
                if ($(this).find('.badge.bg-success:contains("제철 식재료")').length > 0) {
                    $(this).show();
                }
            });
        });
        
        // 추천 레시피 로드
        loadRecommendedRecipes();
        
        // 레시피 찾기 버튼 이벤트
        $('#findRecipesBtn').click(function() {
            // 냉장고 재료 기반으로 레시피 검색 페이지로 이동
            const ingredientIds = [];
            <c:forEach items="${ingredients}" var="ingredient">
                ingredientIds.push(${ingredient.ingredientId});
            </c:forEach>
            
            window.location.href = '/recipes?ingredientIds=' + ingredientIds.join(',');
        });
    });
    
    // 유통기한 표시 형식 조정
    document.querySelectorAll('.expiry-date').forEach(function(item) {
        const dateStr = item.getAttribute('data-date');
        const date = new Date(dateStr);
        const today = new Date();
        
        // 유통기한까지 남은 일수 계산
        const diffTime = date - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        
        if (diffDays < 0) {
            item.classList.remove('bg-warning');
            item.classList.add('bg-danger');
            item.textContent = '유통기한 만료';
        } else if (diffDays <= 3) {
            item.textContent = '유통기한 ' + diffDays + '일 남음';
        } else {
            item.textContent = '유통기한: ' + date.toLocaleDateString();
        }
    });
    
    // 추천 레시피 로드 함수
    function loadRecommendedRecipes() {
        $.ajax({
            url: '/api/recipes/recommended',
            type: 'GET',
            success: function(response) {
                $('#loadingRecipes').hide();
                
                if (response.length === 0) {
                    $('#noRecipes').removeClass('d-none');
                } else {
                    $('#noRecipes').addClass('d-none');
                    
                    let recipesHtml = '';
                    response.forEach(function(recipe) {
                        var recipeHtml = '<div class="col">' +
                            '<div class="card h-100 shadow-sm">';
                        
                        if (recipe.images != null && recipe.images.length > 0) {
                            recipeHtml += '<img src="' + recipe.images[0].imageUrl + '" class="card-img-top recipe-thumbnail" alt="' + recipe.images[0].description + '">';
                        } else {
                            recipeHtml += '<div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">' +
                                '<svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-camera text-secondary">' +
                                '<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>' +
                                '<circle cx="12" cy="13" r="4"></circle>' +
                                '</svg>' +
                                '</div>';
                        }
                        
                        recipeHtml += '<div class="card-body">' +
                            '<h5 class="card-title">' + recipe.title + '</h5>' +
                            '<div class="d-flex justify-content-between align-items-center">' +
                            '<div class="rating">' +
                            generateStarRating(recipe.avgRating) +
                            '<small class="text-muted">(' + recipe.ratingCount + ')</small>' +
                            '</div>' +
                            '<small class="text-muted">' + (recipe.cookingTime ? recipe.cookingTime + '분' : '시간 정보 없음') + '</small>' +
                            '</div>' +
                            '<p class="card-text mt-2">' + (recipe.description || '설명 정보 없음') + '</p>' +
                            '</div>' +
                            '<div class="card-footer bg-transparent">' +
                            '<a href="/recipes/' + recipe.id + '" class="btn btn-sm btn-outline-primary w-100">레시피 보기</a>' +
                            '</div>' +
                            '</div>' +
                            '</div>';
                            
                        recipesHtml += recipeHtml;
                    });
                    
                    $('#recommendedRecipes').html(recipesHtml);
                    feather.replace();
                }
            },
            error: function(error) {
                $('#loadingRecipes').hide();
                $('#noRecipes').removeClass('d-none');
                console.error('Failed to load recommended recipes', error);
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
