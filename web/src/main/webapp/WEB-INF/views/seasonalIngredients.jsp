<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<!-- 계절별 식재료 페이지 헤더 -->
<section class="mb-5">
    <div class="season-header p-4 rounded-3 mb-4" style="background: linear-gradient(135deg, rgba(76, 175, 80, 0.9) 0%, rgba(56, 142, 60, 0.85) 100%), url('https://images.unsplash.com/photo-1466637574441-749b8f19452f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') no-repeat center center; background-size: cover;">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="text-white mb-3">
                        <i class="me-2" data-feather="${currentSeason eq 'SPRING' ? 'sun' : currentSeason eq 'SUMMER' ? 'cloud-rain' : currentSeason eq 'FALL' ? 'cloud' : 'cloud-snow'}"></i>
                        ${seasonKr} 제철 식재료
                    </h1>
                    <p class="text-white mb-4">
                        ${currentSeason eq 'SPRING' ? '봄에는 달콤한 딸기, 아스파라거스, 두릅, 냉이 등 다양한 봄나물이 제철입니다.' : 
                         currentSeason eq 'SUMMER' ? '여름에는 수박, 참외, 토마토, 오이, 가지, 고추 등이 제철이며 풍부하게 공급됩니다.' : 
                         currentSeason eq 'FALL' ? '가을에는 고구마, 밤, 버섯, 단호박, 귤, 배 등 풍성한 수확물이 제철입니다.' : 
                         '겨울에는 무, 배추, 시금치, 대파, 감귤 등이 제철이며 영양이 풍부합니다.'}
                        계절별 제철 식재료를 활용해 영양가 높은 요리를 만들어보세요.
                    </p>
                </div>
                <div class="col-lg-4">
                    <div class="season-selector p-3 bg-white rounded-3 shadow-sm">
                        <h5 class="mb-3">다른 계절 식재료 보기</h5>
                        <div class="d-flex justify-content-between">
                            <a href="/ingredients/seasonal?season=SPRING" class="btn ${currentSeason eq 'SPRING' ? 'btn-primary' : 'btn-outline-primary'} rounded-pill">봄</a>
                            <a href="/ingredients/seasonal?season=SUMMER" class="btn ${currentSeason eq 'SUMMER' ? 'btn-primary' : 'btn-outline-primary'} rounded-pill">여름</a>
                            <a href="/ingredients/seasonal?season=FALL" class="btn ${currentSeason eq 'FALL' ? 'btn-primary' : 'btn-outline-primary'} rounded-pill">가을</a>
                            <a href="/ingredients/seasonal?season=WINTER" class="btn ${currentSeason eq 'WINTER' ? 'btn-primary' : 'btn-outline-primary'} rounded-pill">겨울</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 제철 식재료 섹션 -->
<section class="mb-5">
    <div class="container">
        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center">
                <h2 class="mb-0">
                    <span class="badge bg-primary rounded-pill me-2">
                        <i data-feather="star" style="width: 18px; height: 18px;"></i>
                    </span>
                    ${seasonKr} 제철 식재료
                </h2>
                <c:if test="${not empty inSeasonIngredients}">
                    <span class="badge bg-light text-dark">${seasonalIngredients.inSeasonIngredients.size()}개의 식재료</span>
                </c:if>
            </div>
            <p class="text-muted mt-2">제철 식재료는 맛이 더 풍부하고 영양가가 높으며 상대적으로 가격도 저렴합니다.</p>
        </div>
        
        <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-4">
            <c:forEach items="${seasonalIngredients.inSeasonIngredients}" var="ingredient">
                <div class="col">
                    <div class="card h-100 border-0 shadow-sm">
                        <div class="position-relative">
                            <c:choose>
                                <c:when test="${not empty ingredient.imageUrl}">
                                    <img src="${ingredient.imageUrl}" class="card-img-top ingredient-thumbnail" alt="${ingredient.name}" style="height: 160px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="card-img-top ingredient-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light" style="height: 160px;">
                                        <i data-feather="shopping-bag" class="text-secondary" style="width: 40px; height: 40px;"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <span class="position-absolute top-0 start-0 bg-success text-white px-2 py-1 m-2 rounded-pill d-flex align-items-center" style="font-size: 12px; font-weight: 500;">
                                <i data-feather="check-circle" class="me-1" style="width: 14px; height: 14px;"></i> 제철
                            </span>
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">${ingredient.name}</h5>
                            <c:if test="${not empty ingredient.category}">
                                <span class="badge bg-light text-secondary mb-2">${ingredient.category}</span>
                            </c:if>
                            <p class="card-text small text-muted">
                                <c:choose>
                                    <c:when test="${not empty ingredient.description}">
                                        ${ingredient.description}
                                    </c:when>
                                    <c:otherwise>
                                        ${seasonKr}철 제철 식재료로, 이 시기에 가장 맛과 영양이 풍부합니다.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="card-footer bg-white pt-0 border-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="seasonal-availability">
                                    <span class="badge ${ingredient.springAvailability eq 'HIGH' ? 'bg-success' : ingredient.springAvailability eq 'MEDIUM' ? 'bg-primary' : ingredient.springAvailability eq 'LOW' ? 'bg-warning' : 'bg-light text-muted'} rounded-circle p-1" title="봄"></span>
                                    <span class="badge ${ingredient.summerAvailability eq 'HIGH' ? 'bg-success' : ingredient.summerAvailability eq 'MEDIUM' ? 'bg-primary' : ingredient.summerAvailability eq 'LOW' ? 'bg-warning' : 'bg-light text-muted'} rounded-circle p-1" title="여름"></span>
                                    <span class="badge ${ingredient.fallAvailability eq 'HIGH' ? 'bg-success' : ingredient.fallAvailability eq 'MEDIUM' ? 'bg-primary' : ingredient.fallAvailability eq 'LOW' ? 'bg-warning' : 'bg-light text-muted'} rounded-circle p-1" title="가을"></span>
                                    <span class="badge ${ingredient.winterAvailability eq 'HIGH' ? 'bg-success' : ingredient.winterAvailability eq 'MEDIUM' ? 'bg-primary' : ingredient.winterAvailability eq 'LOW' ? 'bg-warning' : 'bg-light text-muted'} rounded-circle p-1" title="겨울"></span>
                                </div>
                                <button class="btn btn-sm btn-outline-primary add-ingredient" data-id="${ingredient.id}" data-name="${ingredient.name}">
                                    <i data-feather="plus" style="width: 16px; height: 16px;"></i>
                                    냉장고에 추가
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- 다른 계절 식재료 섹션 -->
<section class="mb-5">
    <div class="container">
        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center">
                <h2 class="mb-0">
                    <span class="badge bg-light text-dark rounded-pill me-2">
                        <i data-feather="info" style="width: 18px; height: 18px;"></i>
                    </span>
                    ${seasonKr}에 구할 수 있는 다른 식재료
                </h2>
                <c:if test="${not empty offSeasonIngredients}">
                    <span class="badge bg-light text-dark">${seasonalIngredients.offSeasonIngredients.size()}개의 식재료</span>
                </c:if>
            </div>
            <p class="text-muted mt-2">이 식재료들은 제철은 아니지만 시중에서 구할 수 있습니다.</p>
        </div>
        
        <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-3">
            <c:forEach items="${seasonalIngredients.offSeasonIngredients}" var="ingredient" varStatus="status">
                <c:if test="${status.index < 15}">
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="position-relative">
                                <c:choose>
                                    <c:when test="${not empty ingredient.imageUrl}">
                                        <img src="${ingredient.imageUrl}" class="card-img-top ingredient-thumbnail" alt="${ingredient.name}" style="height: 120px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top ingredient-thumbnail-placeholder d-flex align-items-center justify-content-center bg-light" style="height: 120px;">
                                            <i data-feather="shopping-bag" class="text-secondary" style="width: 30px; height: 30px;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body py-2">
                                <h6 class="card-title mb-1">${ingredient.name}</h6>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="seasonal-availability small">
                                        <span class="badge ${ingredient.springAvailability eq 'HIGH' ? 'bg-success' : ingredient.springAvailability eq 'MEDIUM' ? 'bg-primary' : ingredient.springAvailability eq 'LOW' ? 'bg-warning text-dark' : 'bg-light text-muted'} rounded-circle p-1" title="봄"></span>
                                        <span class="badge ${ingredient.summerAvailability eq 'HIGH' ? 'bg-success' : ingredient.summerAvailability eq 'MEDIUM' ? 'bg-primary' : ingredient.summerAvailability eq 'LOW' ? 'bg-warning text-dark' : 'bg-light text-muted'} rounded-circle p-1" title="여름"></span>
                                        <span class="badge ${ingredient.fallAvailability eq 'HIGH' ? 'bg-success' : ingredient.fallAvailability eq 'MEDIUM' ? 'bg-primary' : ingredient.fallAvailability eq 'LOW' ? 'bg-warning text-dark' : 'bg-light text-muted'} rounded-circle p-1" title="가을"></span>
                                        <span class="badge ${ingredient.winterAvailability eq 'HIGH' ? 'bg-success' : ingredient.winterAvailability eq 'MEDIUM' ? 'bg-primary' : ingredient.winterAvailability eq 'LOW' ? 'bg-warning text-dark' : 'bg-light text-muted'} rounded-circle p-1" title="겨울"></span>
                                    </div>
                                    <button class="btn btn-sm btn-outline-primary add-ingredient" data-id="${ingredient.id}" data-name="${ingredient.name}">
                                        <i data-feather="plus" style="width: 14px; height: 14px;"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
            <c:if test="${seasonalIngredients.offSeasonIngredients.size() > 15}">
                <div class="col">
                    <div class="card h-100 border-0 bg-light d-flex align-items-center justify-content-center">
                        <div class="card-body text-center">
                            <i data-feather="more-horizontal" style="width: 24px; height: 24px;"></i>
                            <p class="mb-0 small">더 보기</p>
                            <a href="#" class="stretched-link"></a>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</section>

<!-- 계절별 요리 팁 섹션 -->
<section class="mb-5">
    <div class="container">
        <div class="p-4 rounded-3" style="background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);">
            <h2 class="mb-4">${seasonKr} 요리 팁</h2>
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="card h-100 border-0">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i data-feather="star" class="me-2" style="width: 18px; height: 18px;"></i>
                                제철 식재료의 장점
                            </h5>
                            <ul class="mb-0">
                                <li>맛과 영양이 가장 풍부한 상태입니다</li>
                                <li>환경적으로 지속 가능한 선택입니다</li>
                                <li>일반적으로 더 저렴하게 구입할 수 있습니다</li>
                                <li>지역 농산물 시장을 지원합니다</li>
                                <li>요리의 맛과 질을 향상시킵니다</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="card h-100 border-0">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i data-feather="box" class="me-2" style="width: 18px; height: 18px;"></i>
                                식재료 보관 방법
                            </h5>
                            <ul class="mb-0">
                                <li>잎채소: 물기를 제거하고 키친타월로 감싸 보관</li>
                                <li>뿌리채소: 흙을 털어내고 신문지에 감싸 서늘한 곳에 보관</li>
                                <li>과일: 대부분 실온에서 숙성 후 냉장 보관</li>
                                <li>베리류: 씻지 않은 상태로 냉장 보관 후 먹기 직전에 씻기</li>
                                <li>허브: 물에 담가 꽂아두거나 젖은 키친타월로 감싸기</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 제철 재료로 만드는 추천 레시피 -->
<section class="mb-5">
    <div class="container">
        <div class="mb-4">
            <h2 class="mb-0">${seasonKr} 제철 식재료로 만드는 추천 레시피</h2>
            <p class="text-muted mt-2">계절 특성을 살린 맛있는 레시피를 찾아보세요.</p>
        </div>
        
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="row row-cols-1 row-cols-md-2 g-4">
                    <c:forEach begin="1" end="4" varStatus="loop">
                        <div class="col">
                            <div class="card h-100 border-0 shadow-sm">
                                <div class="position-relative">
                                    <img src="https://via.placeholder.com/400x300?text=SeasonalRecipe${loop.index}" class="card-img-top recipe-thumbnail" alt="계절 레시피">
                                    <span class="position-absolute top-0 start-0 bg-success text-white px-2 py-1 m-2 rounded-pill d-flex align-items-center" style="font-size: 12px; font-weight: 500;">
                                        <i data-feather="check-circle" class="me-1" style="width: 14px; height: 14px;"></i> 제철 재료
                                    </span>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <c:choose>
                                            <c:when test="${currentSeason eq 'SPRING'}">
                                                <c:choose>
                                                    <c:when test="${loop.index eq 1}">봄나물 비빔밥</c:when>
                                                    <c:when test="${loop.index eq 2}">딸기 샐러드</c:when>
                                                    <c:when test="${loop.index eq 3}">냉이 된장국</c:when>
                                                    <c:otherwise>두릅 초무침</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:when test="${currentSeason eq 'SUMMER'}">
                                                <c:choose>
                                                    <c:when test="${loop.index eq 1}">오이냉국</c:when>
                                                    <c:when test="${loop.index eq 2}">토마토 파스타</c:when>
                                                    <c:when test="${loop.index eq 3}">가지 볶음</c:when>
                                                    <c:otherwise>수박 주스</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:when test="${currentSeason eq 'FALL'}">
                                                <c:choose>
                                                    <c:when test="${loop.index eq 1}">버섯 리조또</c:when>
                                                    <c:when test="${loop.index eq 2}">단호박 수프</c:when>
                                                    <c:when test="${loop.index eq 3}">고구마 맛탕</c:when>
                                                    <c:otherwise>배 샐러드</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${loop.index eq 1}">김치찌개</c:when>
                                                    <c:when test="${loop.index eq 2}">시금치 나물</c:when>
                                                    <c:when test="${loop.index eq 3}">대파 전</c:when>
                                                    <c:otherwise>무 된장국</c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </h5>
                                    <div class="d-flex align-items-center mb-2">
                                        <div class="rating me-2">
                                            <c:forEach begin="1" end="5" varStatus="star">
                                                <c:choose>
                                                    <c:when test="${star.index <= 4}">
                                                        <i data-feather="star" class="filled-star" style="width: 14px; height: 14px;"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i data-feather="star" class="empty-star" style="width: 14px; height: 14px;"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <small class="text-muted">(${loop.index * 5 + 10})</small>
                                    </div>
                                    <p class="card-text small mb-3">
                                        <c:choose>
                                            <c:when test="${currentSeason eq 'SPRING'}">
                                                <c:choose>
                                                    <c:when test="${loop.index eq 1}">신선한 봄나물을 활용한 건강한 비빔밥 레시피입니다.</c:when>
                                                    <c:when test="${loop.index eq 2}">제철 딸기의 달콤함이 살아있는 상큼한 샐러드입니다.</c:when>
                                                    <c:when test="${loop.index eq 3}">봄철 제철 나물인 냉이로 만든 영양 가득한 된장국입니다.</c:when>
                                                    <c:otherwise>봄에만 맛볼 수 있는 두릅으로 만든 향긋한 초무침입니다.</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:when test="${currentSeason eq 'SUMMER'}">
                                                <c:choose>
                                                    <c:when test="${loop.index eq 1}">여름 더위를 식혀주는 시원한 오이냉국 레시피입니다.</c:when>
                                                    <c:when test="${loop.index eq 2}">신선한 토마토의 풍미가 가득한 여름철 파스타입니다.</c:when>
                                                    <c:when test="${loop.index eq 3}">여름 제철 가지로 만든 고소한 볶음 요리입니다.</c:when>
                                                    <c:otherwise>시원하고 달콤한 수박으로 만든 건강한 주스입니다.</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:when test="${currentSeason eq 'FALL'}">
                                                <c:choose>
                                                    <c:when test="${loop.index eq 1}">가을 제철 버섯의 풍미가 가득한 크리미한 리조또입니다.</c:when>
                                                    <c:when test="${loop.index eq 2}">달콤하고 진한 단호박으로 만든 부드러운 스프입니다.</c:when>
                                                    <c:when test="${loop.index eq 3}">달콤한 가을 고구마로 만든 전통 간식입니다.</c:when>
                                                    <c:otherwise>가을 제철 배의 아삭함이 돋보이는 상큼한 샐러드입니다.</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${loop.index eq 1}">겨울철 얼큰한 김치찌개로 몸을 따뜻하게 녹여보세요.</c:when>
                                                    <c:when test="${loop.index eq 2}">겨울 제철 시금치로 만든 영양 가득한 나물입니다.</c:when>
                                                    <c:when test="${loop.index eq 3}">겨울에 맛이 좋은 대파로 만든 바삭한 전입니다.</c:when>
                                                    <c:otherwise>겨울 무로 끓인 구수한 된장국입니다.</c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <a href="/recipes/seasonal" class="btn btn-sm btn-outline-primary w-100 rounded-pill">레시피 보기</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card h-100 bg-light border-0">
                    <div class="card-body p-4">
                        <h4 class="mb-4">${seasonKr} 요리 가이드</h4>
                        <p>제철 식재료를 활용한 요리는 맛과 영양 면에서 최고의 선택입니다. 계절별 특성에 맞는 조리법으로 요리해보세요.</p>
                        
                        <h5 class="mt-4 mb-3">추천 조리법</h5>
                        <ul class="ps-3">
                            <c:choose>
                                <c:when test="${currentSeason eq 'SPRING'}">
                                    <li>봄나물은 살짝 데쳐서 향과 식감을 살리세요</li>
                                    <li>냉이, 달래는 된장국에 넣으면 향이 좋습니다</li>
                                    <li>두릅은 데친 후 초고추장과 함께 무쳐보세요</li>
                                    <li>딸기는 가능한 한 신선하게 드세요</li>
                                </c:when>
                                <c:when test="${currentSeason eq 'SUMMER'}">
                                    <li>여름 채소는 신선함을 살려 생으로 드세요</li>
                                    <li>토마토는 살짝 데치면 껍질이 쉽게 벗겨집니다</li>
                                    <li>오이, 가지는 소금에 살짝 절이면 아삭합니다</li>
                                    <li>수박, 참외는 시원하게 냉장 보관했다가 드세요</li>
                                </c:when>
                                <c:when test="${currentSeason eq 'FALL'}">
                                    <li>버섯은 다양한 요리에 활용하기 좋습니다</li>
                                    <li>단호박은 찜, 수프, 말랭이 등으로 활용해보세요</li>
                                    <li>고구마는 쪄서 간식으로 먹거나 요리에 활용하세요</li>
                                    <li>배는 샐러드, 잼, 마리네이드 소스로 활용해보세요</li>
                                </c:when>
                                <c:otherwise>
                                    <li>무, 배추는 김치를 담그는데 최적입니다</li>
                                    <li>시금치는 살짝 데쳐서 나물이나 무침으로 드세요</li>
                                    <li>대파는 각종 찌개, 탕, 전에 활용해보세요</li>
                                    <li>겨울 감귤, 레몬은 비타민C가 풍부합니다</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                        
                        <a href="/tips/seasonal-cooking" class="btn btn-primary w-100 mt-4">자세한 요리 팁 보기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 냉장고에 식재료 추가 모달 -->
<div class="modal fade" id="addIngredientModal" tabindex="-1" aria-labelledby="addIngredientModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addIngredientModalLabel">냉장고에 재료 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addIngredientForm">
                    <input type="hidden" id="ingredientId" name="ingredientId">
                    <div class="mb-3">
                        <label for="ingredientName" class="form-label">재료명</label>
                        <input type="text" class="form-control" id="ingredientName" name="name" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="quantity" class="form-label">수량</label>
                        <input type="number" class="form-control" id="quantity" name="quantity" min="0" step="0.1">
                    </div>
                    <div class="mb-3">
                        <label for="unit" class="form-label">단위</label>
                        <select class="form-select" id="unit" name="unit">
                            <option value="개">개</option>
                            <option value="g">g</option>
                            <option value="kg">kg</option>
                            <option value="ml">ml</option>
                            <option value="L">L</option>
                            <option value="컵">컵</option>
                            <option value="스푼">스푼</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="expiryDate" class="form-label">유통기한</label>
                        <input type="date" class="form-control" id="expiryDate" name="expiryDate">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="saveIngredient">저장</button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Feather 아이콘 초기화
        feather.replace();
        
        // 냉장고에 재료 추가 모달 이벤트
        const addIngredientBtns = document.querySelectorAll('.add-ingredient');
        const addIngredientModal = new bootstrap.Modal(document.getElementById('addIngredientModal'));
        
        addIngredientBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const ingredientId = this.getAttribute('data-id');
                const ingredientName = this.getAttribute('data-name');
                
                document.getElementById('ingredientId').value = ingredientId;
                document.getElementById('ingredientName').value = ingredientName;
                
                addIngredientModal.show();
            });
        });
        
        // 재료 저장 이벤트
        document.getElementById('saveIngredient').addEventListener('click', function() {
            const form = document.getElementById('addIngredientForm');
            const formData = new FormData(form);
            
            const expiryDate = formData.get('expiryDate');
            let formattedExpiryDate = null;
            
            if (expiryDate) {
                // 날짜 형식 변환 (YYYY-MM-DD -> ISO 형식)
                formattedExpiryDate = new Date(expiryDate + 'T00:00:00').toISOString();
            }
            
            const data = {
                ingredientId: formData.get('ingredientId'),
                quantity: formData.get('quantity'),
                unit: formData.get('unit'),
                expiryDate: formattedExpiryDate
            };
            
            fetch('/api/user/ingredients', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('재료 추가에 실패했습니다');
                }
                return response.json();
            })
            .then(data => {
                // 성공 후 모달 닫기
                addIngredientModal.hide();
                
                // 성공 알림
                alert('냉장고에 재료가 추가되었습니다');
                
                // 필요시 폼 초기화
                form.reset();
            })
            .catch(error => {
                console.error('Error:', error);
                alert(error.message);
            });
        });
    });
</script>

<jsp:include page="include/footer.jsp" />