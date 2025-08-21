<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<!-- 히어로 섹션 -->
<section class="hero-section position-relative mb-5">
    <div class="hero-bg rounded-3 overflow-hidden" style="background: linear-gradient(135deg, rgba(76, 175, 80, 0.9) 0%, rgba(56, 142, 60, 0.85) 100%), url('https://images.unsplash.com/photo-1490818387583-1baba5e638af?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') no-repeat center center; background-size: cover; height: 450px;">
        <div class="container h-100 d-flex align-items-center">
            <div class="row w-100">
                <div class="col-lg-6">
                    <div class="hero-content text-white p-4">
                        <h1 class="fw-bold mb-4" style="font-size: 2.8rem;">냉장고 속 재료로<br>맛있는 요리를!</h1>
                        <p class="fs-5 mb-4">냉장고에 있는 재료를 등록하고 맞춤형 레시피를 추천받아보세요. 식재료 관리와 유통기한 체크까지 한번에!</p>
                        <div class="d-flex flex-wrap gap-3">
                            <a href="${pageContext.request.contextPath}/myRefrigerator" class="btn btn-light btn-lg px-4 fw-bold">
                                <i data-feather="archive" class="me-2"></i>냉장고 관리하기
                            </a>
                            <a href="${pageContext.request.contextPath}/recipes" class="btn btn-outline-light btn-lg px-4">
                                <i data-feather="book-open" class="me-2"></i>레시피 둘러보기
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<c:if test="${not empty dbStatus}">
    <div class="alert ${dbStatus eq '연결 성공' ? 'alert-success' : 'alert-danger'} d-flex align-items-center mb-4" role="alert">
        <i data-feather="database" class="me-2"></i>
        <div>
            데이터베이스 상태: ${dbStatus}
        </div>
    </div>
</c:if>

<!-- 주요 기능 섹션 -->
<section class="features-section mb-5">
    <h2 class="section-title mb-4">주요 기능</h2>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100 border-0">
                <div class="card-body text-center p-4">
                    <div class="feature-icon bg-primary bg-opacity-10 rounded-circle p-3 d-inline-flex mb-4" style="width: 80px; height: 80px; justify-content: center; align-items: center;">
                        <i data-feather="archive" style="width: 36px; height: 36px; color: var(--primary-color);"></i>
                    </div>
                    <h3 class="fw-bold">냉장고 관리</h3>
                    <p class="text-muted mb-4">냉장고에 있는 식재료를 등록하고 유통기한을 관리하세요. 알림 설정으로 유통기한 임박 재료도 놓치지 않게!</p>
                    <a href="${pageContext.request.contextPath}/myRefrigerator" class="btn btn-primary">시작하기</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 border-0">
                <div class="card-body text-center p-4">
                    <div class="feature-icon bg-primary bg-opacity-10 rounded-circle p-3 d-inline-flex mb-4" style="width: 80px; height: 80px; justify-content: center; align-items: center;">
                        <i data-feather="search" style="width: 36px; height: 36px; color: var(--primary-color);"></i>
                    </div>
                    <h3 class="fw-bold">레시피 검색</h3>
                    <p class="text-muted mb-4">재료나 요리 이름으로 레시피를 검색하세요. 필터링 기능으로 원하는 조건의 레시피만 찾아볼 수 있어요.</p>
                    <a href="${pageContext.request.contextPath}/recipes" class="btn btn-primary">검색하기</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 border-0">
                <div class="card-body text-center p-4">
                    <div class="feature-icon bg-primary bg-opacity-10 rounded-circle p-3 d-inline-flex mb-4" style="width: 80px; height: 80px; justify-content: center; align-items: center;">
                        <i data-feather="plus-circle" style="width: 36px; height: 36px; color: var(--primary-color);"></i>
                    </div>
                    <h3 class="fw-bold">레시피 등록</h3>
                    <p class="text-muted mb-4">나만의 특별한 레시피를 등록하고 공유하세요. 다른 사용자들과 맛있는 요리 비법을 나눠보세요.</p>
                    <a href="${pageContext.request.contextPath}/addRecipe" class="btn btn-primary">등록하기</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 맞춤 레시피 추천 섹션 -->
<c:if test="${not empty recommendedRecipes}">
    <section class="recommended-recipes-section mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="section-title mb-0">맞춤 레시피 추천</h2>
            <a href="${pageContext.request.contextPath}/recipes?sort=recommended" class="btn btn-sm btn-outline-primary rounded-pill px-3">더보기</a>
        </div>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <c:forEach items="${recommendedRecipes}" var="recipe">
                <div class="col">
                    <div class="card h-100">
                        <div class="position-relative">
                            <c:choose>
                                <c:when test="${not empty recipe.images && recipe.images.size() > 0}">
                                    <img src="${recipe.images[0].imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.images[0].description}">
                                </c:when>
                                <c:otherwise>
                                    <div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                        <i data-feather="camera" class="text-secondary" style="width: 40px; height: 40px;"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <span class="position-absolute top-0 end-0 bg-primary text-white px-3 py-1 m-2 rounded-pill" style="font-size: 12px; font-weight: 500;">
                                ${recipe.cookingTime}분
                            </span>
                        </div>
                        <div class="card-body">
                            <h5 class="card-title fw-bold">${recipe.title}</h5>
                            <div class="d-flex align-items-center mb-3">
                                <div class="rating me-2">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:choose>
                                            <c:when test="${star <= recipe.avgRating}">
                                                <i data-feather="star" class="filled-star" style="width: 16px; height: 16px;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i data-feather="star" class="empty-star" style="width: 16px; height: 16px;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <small class="text-muted">(${recipe.ratingCount})</small>
                            </div>
                            <p class="card-text text-muted mb-3" style="height: 4.5em; overflow: hidden;">${recipe.description}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge rounded-pill bg-light text-primary py-2 px-3">
                                    <i data-feather="users" class="me-1" style="width: 14px; height: 14px;"></i> ${recipe.servingSize}인분
                                </span>
                            </div>
                        </div>
                        <div class="card-footer bg-white border-0 pt-0">
                            <a href="/recipes/${recipe.id}" class="btn btn-outline-primary w-100 rounded-pill">레시피 보기</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
</c:if>

<!-- 인기 레시피 섹션 -->
<section class="popular-recipes-section mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="section-title mb-0">인기 레시피</h2>
        <a href="${pageContext.request.contextPath}/recipes?sort=popular" class="btn btn-sm btn-outline-primary rounded-pill px-3">더보기</a>
    </div>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <c:forEach items="${popularRecipes}" var="recipe">
            <div class="col">
                <div class="card h-100">
                    <div class="position-relative">
                        <c:choose>
                            <c:when test="${ not empty recipe.images && recipe.images.size() > 0}">
                                <img src="${recipe.images[0].imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.title}">
                            </c:when>
                            <c:otherwise>
                                <div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                    <i data-feather="camera" class="text-secondary" style="width: 40px; height: 40px;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <span class="position-absolute top-0 end-0 bg-primary text-white px-3 py-1 m-2 rounded-pill" style="font-size: 12px; font-weight: 500;">
                            ${recipe.cookingTime}분
                        </span>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title fw-bold">${recipe.title}</h5>
                        <div class="d-flex align-items-center mb-3">
                            <div class="rating me-2">
                                <c:forEach begin="1" end="5" var="star">
                                    <c:choose>
                                        <c:when test="${star <= recipe.avgRating}">
                                            <i data-feather="star" class="filled-star" style="width: 16px; height: 16px;"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i data-feather="star" class="empty-star" style="width: 16px; height: 16px;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <small class="text-muted">(${recipe.ratingCount})</small>
                        </div>
                        <p class="card-text text-muted mb-3" style="height: 4.5em; overflow: hidden;">${recipe.description}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="badge rounded-pill bg-light text-primary py-2 px-3">
                                <i data-feather="users" class="me-1" style="width: 14px; height: 14px;"></i> ${recipe.servingSize}인분
                            </span>
                        </div>
                    </div>
                    <div class="card-footer bg-white border-0 pt-0">
                        <a href="/recipes/${recipe.id}" class="btn btn-outline-primary w-100 rounded-pill">레시피 보기</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</section>
${recipe}
<!-- 계절별 추천 레시피 섹션 -->
<section class="seasonal-recipes-section mb-5">
    <div class="section-header position-relative mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <h2 class="section-title mb-0">계절별 추천 레시피</h2>
            <div class="d-flex align-items-center">
                <c:if test="${not empty currentSeason}">
                    <span class="badge bg-primary rounded-pill px-3 py-2 mt-2">현재 계절:
                        ${currentSeason eq 'SPRING' ? '봄' : currentSeason eq 'SUMMER' ? '여름' : currentSeason eq 'FALL' ? '가을' : '겨울'}
                    </span>
                </c:if>
                <a href="${pageContext.request.contextPath}/recipes?season=${currentSeason}" class="btn btn-sm btn-outline-primary rounded-pill px-3 ms-3">더보기</a>
            </div>
        </div>
    </div>

    <div class="tab-content" id="seasonTabContent">
        <!-- 계절별 레시피 - 봄 -->
        <div class="tab-pane fade ${currentSeason eq 'SPRING' ? 'show active' : ''}" id="spring-recipes" role="tabpanel" aria-labelledby="spring-tab">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="season-feature p-4 bg-light rounded-3 h-100">
                        <h4 class="fw-bold mb-3">봄철 제철 식재료</h4>
                        <p class="text-muted mb-3">달콤한 딸기, 아스파라거스, 두릅, 냉이, 쑥, 봄동 등으로 신선하고 건강한 봄 요리를 준비해보세요.</p>
                        <div class="d-flex flex-wrap">
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">딸기</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">아스파라거스</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">두릅</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">냉이</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">쑥</span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="row row-cols-1 row-cols-md-2 g-4">
                        <c:forEach items="${seasonalRecipes}" var="recipe" varStatus="status">
                            <c:if test="${status.index < 4}">
                                <div class="col">
                                    <div class="card h-100 border-0 shadow-sm">
                                        <div class="position-relative">
                                            <c:choose>
                                                <c:when test="${not empty recipe.images && recipe.images.size() > 0}">
                                                    <img src="${recipe.images[0].imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.images[0].description}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                                        <i data-feather="camera" class="text-secondary" style="width: 40px; height: 40px;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="position-absolute top-0 end-0 bg-primary text-white px-3 py-1 m-2 rounded-pill" style="font-size: 12px; font-weight: 500;">
                                                ${recipe.cookingTime}분
                                            </span>
                                        </div>
                                        <div class="card-body">
                                            <h5 class="card-title fw-bold">${recipe.title}</h5>
                                            <div class="d-flex align-items-center mb-2">
                                                <div class="rating me-2">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <c:choose>
                                                            <c:when test="${star <= recipe.avgRating}">
                                                                <i data-feather="star" class="filled-star" style="width: 14px; height: 14px;"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i data-feather="star" class="empty-star" style="width: 14px; height: 14px;"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                                <small class="text-muted">(${recipe.ratingCount})</small>
                                            </div>
                                            <p class="card-text text-muted mb-3" style="font-size: 0.9rem; height: 2.5em; overflow: hidden;">${recipe.description}</p>
                                            <a href="/recipes/${recipe.id}" class="btn btn-sm btn-outline-primary rounded-pill w-100">레시피 보기</a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- 계절별 레시피 - 여름 -->
        <div class="tab-pane fade ${currentSeason eq 'SUMMER' ? 'show active' : ''}" id="summer-recipes" role="tabpanel" aria-labelledby="summer-tab">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="season-feature p-4 bg-light rounded-3 h-100">
                        <h4 class="fw-bold mb-3">여름철 제철 식재료</h4>
                        <p class="text-muted mb-3">수박, 참외, 토마토, 오이, 가지, 고추 등 더위를 이겨내는 여름 식재료로 시원한 요리를 준비해보세요.</p>
                        <div class="d-flex flex-wrap">
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">수박</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">토마토</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">오이</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">고추</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">옥수수</span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="row row-cols-1 row-cols-md-2 g-4">
                        <c:forEach items="${seasonalRecipes}" var="recipe" varStatus="status">
                            <c:if test="${status.index < 4}">
                                <div class="col">
                                    <div class="card h-100 border-0 shadow-sm">
                                        <div class="position-relative">
                                            <c:choose>
                                                <c:when test="${not empty recipe.images && recipe.images.size() > 0}">
                                                    <img src="${recipe.images[0].imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.images[0].description}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                                        <i data-feather="camera" class="text-secondary" style="width: 40px; height: 40px;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="position-absolute top-0 end-0 bg-primary text-white px-3 py-1 m-2 rounded-pill" style="font-size: 12px; font-weight: 500;">
                                                ${recipe.cookingTime}분
                                            </span>
                                        </div>
                                        <div class="card-body">
                                            <h5 class="card-title fw-bold">${recipe.title}</h5>
                                            <div class="d-flex align-items-center mb-2">
                                                <div class="rating me-2">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <c:choose>
                                                            <c:when test="${star <= recipe.avgRating}">
                                                                <i data-feather="star" class="filled-star" style="width: 14px; height: 14px;"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i data-feather="star" class="empty-star" style="width: 14px; height: 14px;"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                                <small class="text-muted">(${recipe.ratingCount})</small>
                                            </div>
                                            <p class="card-text text-muted mb-3" style="font-size: 0.9rem; height: 2.5em; overflow: hidden;">${recipe.description}</p>
                                            <a href="/recipes/${recipe.id}" class="btn btn-sm btn-outline-primary rounded-pill w-100">레시피 보기</a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 계절별 레시피 - 가을 -->
        <div class="tab-pane fade ${currentSeason eq 'FALL' ? 'show active' : ''}" id="fall-recipes" role="tabpanel" aria-labelledby="fall-tab">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="season-feature p-4 bg-light rounded-3 h-100">
                        <h4 class="fw-bold mb-3">가을철 제철 식재료</h4>
                        <p class="text-muted mb-3">고구마, 밤, 버섯, 단호박, 귤, 배 등 가을의 풍성한 수확물로 영양가 높은 요리를 만들어보세요.</p>
                        <div class="d-flex flex-wrap">
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">고구마</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">밤</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">버섯</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">단호박</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">귤</span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="row row-cols-1 row-cols-md-2 g-4">
                        <c:forEach items="${seasonalRecipes}" var="recipe" varStatus="status">
                            <c:if test="${status.index < 4}">
                                <div class="col">
                                    <div class="card h-100 border-0 shadow-sm">
                                        <div class="position-relative">
                                            <c:choose>
                                                <c:when test="${not empty recipe.images && recipe.images.size() > 0}">
                                                    <img src="${recipe.images[0].imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.images[0].description}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                                        <i data-feather="camera" class="text-secondary" style="width: 40px; height: 40px;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="position-absolute top-0 end-0 bg-primary text-white px-3 py-1 m-2 rounded-pill" style="font-size: 12px; font-weight: 500;">
                                                ${recipe.cookingTime}분
                                            </span>
                                        </div>
                                        <div class="card-body">
                                            <h5 class="card-title fw-bold">${recipe.title}</h5>
                                            <div class="d-flex align-items-center mb-2">
                                                <div class="rating me-2">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <c:choose>
                                                            <c:when test="${star <= recipe.avgRating}">
                                                                <i data-feather="star" class="filled-star" style="width: 14px; height: 14px;"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i data-feather="star" class="empty-star" style="width: 14px; height: 14px;"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                                <small class="text-muted">(${recipe.ratingCount})</small>
                                            </div>
                                            <p class="card-text text-muted mb-3" style="font-size: 0.9rem; height: 2.5em; overflow: hidden;">${recipe.description}</p>
                                            <a href="/recipes/${recipe.id}" class="btn btn-sm btn-outline-primary rounded-pill w-100">레시피 보기</a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 계절별 레시피 - 겨울 -->
        <div class="tab-pane fade ${currentSeason eq 'WINTER' ? 'show active' : ''}" id="winter-recipes" role="tabpanel" aria-labelledby="winter-tab">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="season-feature p-4 bg-light rounded-3 h-100">
                        <h4 class="fw-bold mb-3">겨울철 제철 식재료</h4>
                        <p class="text-muted mb-3">무, 배추, 시금치, 대파, 감귤, 석류 등 겨울철 제철 식재료로 든든하고 따뜻한 요리를 준비해보세요.</p>
                        <div class="d-flex flex-wrap">
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">무</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">배추</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">시금치</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">감귤</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary me-2 mb-2 px-3 py-2 rounded-pill">대파</span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="row row-cols-1 row-cols-md-2 g-4">
                        <c:forEach items="${seasonalRecipes}" var="recipe" varStatus="status">
                            <c:if test="${status.index < 4}">
                                <div class="col">
                                    <div class="card h-100 border-0 shadow-sm">
                                        <div class="position-relative">
                                            <c:choose>
                                                <c:when test="${not empty recipe.images && recipe.images.size() > 0}">
                                                    <img src="${recipe.images[0].imageUrl}" class="card-img-top recipe-thumbnail" alt="${recipe.images[0].description}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="card-img-top recipe-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light">
                                                        <i data-feather="camera" class="text-secondary" style="width: 40px; height: 40px;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="position-absolute top-0 end-0 bg-primary text-white px-3 py-1 m-2 rounded-pill" style="font-size: 12px; font-weight: 500;">
                                                ${recipe.cookingTime}분
                                            </span>
                                        </div>
                                        <div class="card-body">
                                            <h5 class="card-title fw-bold">${recipe.title}</h5>
                                            <div class="d-flex align-items-center mb-2">
                                                <div class="rating me-2">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <c:choose>
                                                            <c:when test="${star <= recipe.avgRating}">
                                                                <i data-feather="star" class="filled-star" style="width: 14px; height: 14px;"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i data-feather="star" class="empty-star" style="width: 14px; height: 14px;"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                                <small class="text-muted">(${recipe.ratingCount})</small>
                                            </div>
                                            <p class="card-text text-muted mb-3" style="font-size: 0.9rem; height: 2.5em; overflow: hidden;">${recipe.description}</p>
                                            <a href="/recipes/${recipe.id}" class="btn btn-sm btn-outline-primary rounded-pill w-100">레시피 보기</a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 유통기한 임박 재료 활용 팁 섹션 -->
<%--<section class="expiry-tips-section mb-5">--%>
<%--    <div class="p-4 rounded-3" style="background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);">--%>
<%--        <div class="row">--%>
<%--            <div class="col-lg-5 mb-4 mb-lg-0">--%>
<%--                <h2 class="section-title mb-4">유통기한 임박 재료 <br>활용 팁</h2>--%>
<%--                <p class="mb-4">버리기 아까운 식재료, 이렇게 활용해보세요! 냉장고에 방치된 식재료를 활용한 맛있는 요리 아이디어를 소개합니다.</p>--%>
<%--                <div class="d-grid gap-2 d-md-flex">--%>
<%--                    <a href="/tips/ingredients" class="btn btn-primary px-4">더 많은 팁 보기</a>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="col-lg-7">--%>
<%--                <div class="row g-3">--%>
<%--                    <div class="col-md-6">--%>
<%--                        <div class="card h-100 border-0">--%>
<%--                            <div class="card-body">--%>
<%--                                <div class="d-flex mb-3">--%>
<%--                                    <div class="bg-white rounded-3 p-2 me-3">--%>
<%--                                        <i data-feather="shopping-bag" class="text-primary"></i>--%>
<%--                                    </div>--%>
<%--                                    <h5 class="fw-bold mt-1">유통기한 임박 채소</h5>--%>
<%--                                </div>--%>
<%--                                <p class="card-text">시들어가는 채소는 볶음밥, 수프, 죽 등의 요리에 사용하면 맛있게 활용할 수 있어요.</p>--%>
<%--                                <a href="#" class="stretched-link"></a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                    <div class="col-md-6">--%>
<%--                        <div class="card h-100 border-0">--%>
<%--                            <div class="card-body">--%>
<%--                                <div class="d-flex mb-3">--%>
<%--                                    <div class="bg-white rounded-3 p-2 me-3">--%>
<%--                                        <i data-feather="coffee" class="text-primary"></i>--%>
<%--                                    </div>--%>
<%--                                    <h5 class="fw-bold mt-1">남은 우유 활용법</h5>--%>
<%--                                </div>--%>
<%--                                <p class="card-text">유통기한이 다가오는 우유는 팬케이크, 스크램블 에그, 베이킹에 활용해보세요.</p>--%>
<%--                                <a href="#" class="stretched-link"></a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                    <div class="col-md-6">--%>
<%--                        <div class="card h-100 border-0">--%>
<%--                            <div class="card-body">--%>
<%--                                <div class="d-flex mb-3">--%>
<%--                                    <div class="bg-white rounded-3 p-2 me-3">--%>
<%--                                        <i data-feather="pie-chart" class="text-primary"></i>--%>
<%--                                    </div>--%>
<%--                                    <h5 class="fw-bold mt-1">과일 활용 꿀팁</h5>--%>
<%--                                </div>--%>
<%--                                <p class="card-text">더 이상 신선하지 않은 과일은 스무디, 잼, 소스 또는 디저트로 재탄생시키세요.</p>--%>
<%--                                <a href="#" class="stretched-link"></a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                    <div class="col-md-6">--%>
<%--                        <div class="card h-100 border-0">--%>
<%--                            <div class="card-body">--%>
<%--                                <div class="d-flex mb-3">--%>
<%--                                    <div class="bg-white rounded-3 p-2 me-3">--%>
<%--                                        <i data-feather="feather" class="text-primary"></i>--%>
<%--                                    </div>--%>
<%--                                    <h5 class="fw-bold mt-1">남은 고기 재활용</h5>--%>
<%--                                </div>--%>
<%--                                <p class="card-text">전날 요리하고 남은 고기는 샌드위치, 볶음밥, 샐러드의 토핑으로 활용하세요.</p>--%>
<%--                                <a href="#" class="stretched-link"></a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</section>--%>

<!-- 요리 팁 & 트릭 섹션 -->
<%--<section class="cooking-tips-section mb-5">--%>
<%--    <div class="d-flex justify-content-between align-items-center mb-4">--%>
<%--        <h2 class="section-title mb-0">요리 팁 & 트릭</h2>--%>
<%--        <a href="/cooking-tips" class="btn btn-sm btn-outline-primary rounded-pill px-3">더보기</a>--%>
<%--    </div>--%>
<%--    --%>
<%--    <div class="row g-4">--%>
<%--        <div class="col-lg-8">--%>
<%--            <div class="row g-4">--%>
<%--                <div class="col-md-6">--%>
<%--                    <div class="card border-0 h-100">--%>
<%--                        <img src="https://via.placeholder.com/600x400?text=CookingTip1" class="card-img-top rounded-3" alt="요리 팁">--%>
<%--                        <div class="card-body px-0">--%>
<%--                            <h5 class="fw-bold mb-2">완벽한 밥 짓는 방법</h5>--%>
<%--                            <p class="text-muted mb-3">쌀과 물의 황금비율부터 불 조절까지, 실패 없는 밥 짓기 노하우</p>--%>
<%--                            <a href="#" class="btn btn-sm btn-outline-primary rounded-pill px-3">자세히 보기</a>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="col-md-6">--%>
<%--                    <div class="card border-0 h-100">--%>
<%--                        <img src="https://via.placeholder.com/600x400?text=CookingTip2" class="card-img-top rounded-3" alt="요리 팁">--%>
<%--                        <div class="card-body px-0">--%>
<%--                            <h5 class="fw-bold mb-2">채소 더 오래 신선하게 보관하기</h5>--%>
<%--                            <p class="text-muted mb-3">채소별 최적의 보관 방법으로 신선도를 2배 높이는 방법</p>--%>
<%--                            <a href="#" class="btn btn-sm btn-outline-primary rounded-pill px-3">자세히 보기</a>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--        <div class="col-lg-4">--%>
<%--            <div class="card border-0 bg-light h-100">--%>
<%--                <div class="card-body p-4">--%>
<%--                    <h4 class="fw-bold mb-4">오늘의 요리 팁</h4>--%>
<%--                    <div class="tip-list">--%>
<%--                        <div class="tip-item d-flex mb-3 pb-3 border-bottom">--%>
<%--                            <div class="tip-icon me-3 bg-white rounded-circle p-2" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">--%>
<%--                                <i data-feather="check" class="text-primary" style="width: 18px; height: 18px;"></i>--%>
<%--                            </div>--%>
<%--                            <div>--%>
<%--                                <h6 class="fw-bold mb-1">소금 활용법</h6>--%>
<%--                                <p class="text-muted small mb-0">소금은 맛을 돋우는 것 외에도 야채의 수분을 제거하거나 달걀 껍질을 쉽게 제거할 때 활용하세요.</p>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="tip-item d-flex mb-3 pb-3 border-bottom">--%>
<%--                            <div class="tip-icon me-3 bg-white rounded-circle p-2" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">--%>
<%--                                <i data-feather="check" class="text-primary" style="width: 18px; height: 18px;"></i>--%>
<%--                            </div>--%>
<%--                            <div>--%>
<%--                                <h6 class="fw-bold mb-1">칼 손질법</h6>--%>
<%--                                <p class="text-muted small mb-0">요리 전후로 칼을 뜨거운 물로 씻고 잘 말려서 보관하면 더 오래 사용할 수 있어요.</p>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="tip-item d-flex mb-3 pb-3 border-bottom">--%>
<%--                            <div class="tip-icon me-3 bg-white rounded-circle p-2" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">--%>
<%--                                <i data-feather="check" class="text-primary" style="width: 18px; height: 18px;"></i>--%>
<%--                            </div>--%>
<%--                            <div>--%>
<%--                                <h6 class="fw-bold mb-1">마늘 손질 꿀팁</h6>--%>
<%--                                <p class="text-muted small mb-0">마늘을 까기 전에 10초간 전자레인지에 돌리면 껍질이 쉽게 벗겨져요.</p>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="tip-item d-flex">--%>
<%--                            <div class="tip-icon me-3 bg-white rounded-circle p-2" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">--%>
<%--                                <i data-feather="check" class="text-primary" style="width: 18px; height: 18px;"></i>--%>
<%--                            </div>--%>
<%--                            <div>--%>
<%--                                <h6 class="fw-bold mb-1">고기 해동법</h6>--%>
<%--                                <p class="text-muted small mb-0">냉장고에서 천천히 해동하면 육즙이 빠져나가지 않고 맛있게 조리할 수 있어요.</p>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</section>--%>


<!-- 요리 팁 & 트릭 섹션 -->
<section class="tips-section mb-5">
    <div class="row g-4">
        <div class="col-md-6">
            <div class="card border-0 bg-light">
                <div class="card-body p-4">
                    <div class="tips-header mb-4">
                        <div class="tips-icon bg-primary bg-opacity-10 rounded-circle p-3 d-inline-flex mb-3" style="width: 70px; height: 70px; justify-content: center; align-items: center;">
                            <i data-feather="book-open" style="width: 32px; height: 32px; color: var(--primary-color);"></i>
                        </div>
                        <h2 class="fw-bold">요리 팁 & 트릭</h2>
                        <p class="text-muted">맛있는 요리를 위한 유용한 정보들</p>
                    </div>
                    
                    <div class="tips-list mb-4">
                        <c:forEach items="${cookingTips}" var="tip" varStatus="status">
                            <c:if test="${status.index < 3}">
                                <div class="tip-item mb-3 pb-3 ${status.index < 2 ? 'border-bottom' : ''}">
                                    <div class="d-flex">
                                        <c:if test="${not empty tip.category}">
                                            <span class="badge bg-primary me-2 align-self-start">${tip.category}</span>
                                        </c:if>
                                        <h5 class="mb-2 flex-grow-1">${tip.title}</h5>
                                    </div>
                                    <p class="text-muted mb-1 text-truncate">${tip.content}</p>
                                    <a href="/tips/cooking/${tip.id}" class="btn-link text-decoration-none">자세히 보기 <i data-feather="arrow-right" style="width: 14px; height: 14px;"></i></a>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    
                    <c:if test="${empty cookingTips}">
                        <div class="alert alert-info">등록된 요리 팁이 없습니다.</div>
                    </c:if>
                    
                    <a href="/tips" class="btn btn-primary rounded-pill px-4">
                        모든 팁 보기
                    </a>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="card border-0 bg-light">
                <div class="card-body p-4">
                    <div class="tips-header mb-4">
                        <div class="tips-icon bg-primary bg-opacity-10 rounded-circle p-3 d-inline-flex mb-3" style="width: 70px; height: 70px; justify-content: center; align-items: center;">
                            <i data-feather="clock" style="width: 32px; height: 32px; color: var(--primary-color);"></i>
                        </div>
                        <h2 class="fw-bold">유통기한 임박 재료 활용 팁</h2>
                        <p class="text-muted">버리기 아까운 식재료 현명하게 활용하기</p>
                    </div>
                    
                    <div class="tips-list mb-4">
                        <c:forEach items="${expiryTips}" var="tip" varStatus="status">
                            <c:if test="${status.index < 3}">
                                <div class="tip-item mb-3 pb-3 ${status.index < 2 ? 'border-bottom' : ''}">
                                    <div class="d-flex">
                                        <span class="badge bg-primary me-2 align-self-start">${tip.ingredientName}</span>
                                        <h5 class="mb-2 flex-grow-1">${tip.ingredientName} 활용법</h5>
                                    </div>
                                    <p class="text-muted mb-1 text-truncate">${tip.tipContent}</p>
                                    <a href="/tips/expiry/${tip.id}" class="btn-link text-decoration-none">자세히 보기 <i data-feather="arrow-right" style="width: 14px; height: 14px;"></i></a>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    
                    <c:if test="${empty expiryTips}">
                        <div class="alert alert-info">등록된 유통기한 활용 팁이 없습니다.</div>
                    </c:if>
                    
                    <a href="/tips/expiry" class="btn btn-primary rounded-pill px-4">
                        모든 팁 보기
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="include/footer.jsp" />
