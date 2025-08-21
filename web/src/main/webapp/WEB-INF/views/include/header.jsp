<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>냉장고 레시피</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Feather icons -->
    <link href="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="/resources/css/style.css" rel="stylesheet">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Feather icons JS -->
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <!-- 사용자 활동 추적 JS -->
    <script src="/resources/js/activity-tracker.js"></script>

    <style>
        :root {
            --primary-color: #4CAF50;
            --primary-dark: #388E3C;
            --primary-light: #A5D6A7;
            --accent-color: #FF5722;
            --text-dark: #212121;
            --text-medium: #757575;
            --text-light: #BDBDBD;
            --bg-light: #F9F9F9;
            --warning-color: #FFC107;
            --danger-color: #F44336;
            --success-color: #4CAF50;
        }

        /* 모바일 네비게이션 스타일 */
        .offcanvas-start {
            width: 280px;
        }

        .offcanvas-header {
            border-bottom: 1px solid rgba(0,0,0,0.1);
            padding-top: 1rem;
            padding-bottom: 1rem;
        }

        .offcanvas-body .nav-link {
            border-radius: 4px;
            margin-bottom: 4px;
            padding-top: 10px;
            padding-bottom: 10px;
            transition: all 0.2s ease;
        }

        .offcanvas-body .nav-link:hover,
        .offcanvas-body .nav-link:focus {
            background-color: rgba(76, 175, 80, 0.1);
            color: var(--primary-color);
        }

        /* 모바일 상단 고정 네비게이션 */
        .navbar-brand {
            font-weight: 700;
            color: #333;
        }

        .navbar-brand i {
            vertical-align: middle;
            margin-right: 5px;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            color: var(--text-dark);
            background-color: var(--bg-light);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 2.6;
        }

        .top-bar {
            background-color: var(--primary-dark);
            padding: 6px 0;
            font-size: 14px;
        }

        .top-bar a {
            color: rgba(255, 255, 255, 0.85);
            font-weight: 300;
            margin-left: 15px;
            transition: all 0.2s;
        }

        .top-bar a:hover {
            color: #fff;
            text-decoration: none;
        }

        .header-main {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            padding: 1.5rem 0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .header-main::after {
            content: "";
            position: absolute;
            bottom: -10px;
            left: 0;
            right: 0;
            height: 10px;
            background: linear-gradient(to bottom, rgba(0,0,0,0.1), rgba(0,0,0,0));
        }

        .site-logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        .site-logo:hover {
            color: white;
        }

        .site-logo i {
            margin-right: 12px;
            font-size: 2rem;
        }

        .search-form {
            position: relative;
            max-width: 450px;
        }

        .search-form input {
            border-radius: 50px;
            padding-left: 20px;
            padding-right: 50px;
            border: none;
            height: 48px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            font-size: 16px;
        }

        .search-form button {
            position: absolute;
            right: 5px;
            top: 5px;
            border-radius: 50%;
            width: 38px;
            height: 38px;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--accent-color);
            border: none;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            transition: all 0.2s;
        }

        .search-form button:hover {
            background-color: #E64A19;
            transform: scale(1.05);
        }

        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            padding: 0;
        }

        .navbar .nav-link {
            color: var(--text-dark);
            font-weight: 500;
            padding: 1rem 1.5rem;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }

        .navbar .nav-link:hover, .navbar .nav-link.active {
            color: var(--primary-color);
            border-bottom: 3px solid var(--primary-color);
        }

        .recipe-thumbnail {
            height: 220px;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
        }

        .recipe-thumbnail-placeholder {
            height: 220px;
            border-radius: 8px 8px 0 0;
        }

        .filled-star {
            fill: var(--warning-color);
        }

        .empty-star {
            fill: none;
            stroke: var(--text-light);
        }

        .main-content {
            flex: 1;
            padding: 30px 0;
        }

        .ingredient-badge {
            margin-right: 8px;
            margin-bottom: 8px;
            font-size: 85%;
            border-radius: 50px;
            padding: 5px 12px;
            font-weight: 500;
        }

        .expiry-warning {
            color: var(--danger-color);
            font-weight: bold;
        }

        .expiry-soon {
            color: var(--warning-color);
            font-weight: bold;
        }

        .expiry-good {
            color: var(--success-color);
        }

        footer {
            margin-top: auto;
            background-color: #292929;
            color: #ccc;
        }

        .sidebar {
            position: sticky;
            top: 20px;
        }

        .card {
            border-radius: 8px;
            border: none;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .card-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-dark);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            border-radius: 50px;
            padding: 8px 24px;
            font-weight: 500;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
            border-radius: 50px;
            padding: 8px 24px;
            font-weight: 500;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1, h2, h3, h4, h5, h6 {
            font-weight: 700;
            color: var(--text-dark);
        }

        .section-title {
            position: relative;
            display: inline-block;
            margin-bottom: 1.5rem;
            font-size: 1.8rem;
        }

        .section-title::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: -10px;
            width: 50px;
            height: 4px;
            background-color: var(--accent-color);
            border-radius: 2px;
        }

        @media (max-width: 767.98px) {
            .sidebar {
                position: static;
                margin-bottom: 20px;
            }

            .navbar .nav-link {
                padding: 0.75rem 1rem;
            }

            .site-logo {
                font-size: 1.4rem;
            }

            .search-form input {
                height: 42px;
            }

            .search-form button {
                width: 34px;
                height: 34px;
            }
        }

        /* 매우 작은 모바일 화면 대응 */
        @media (max-width: 359.98px) {
            .site-logo {
                font-size: 1.2rem;
            }

            .site-logo i {
                width: 24px !important;
                height: 24px !important;
            }

            .btn-sm {
                padding: 0.25rem 0.4rem;
            }
        }
    </style>
</head>
<body>
<div class="top-bar d-none d-md-block">
    <div class="container">
        <div class="d-flex justify-content-end">
            <c:choose>
                <c:when test="${cookie.token != null}">
                    <a href="/myPage">마이페이지</a>
                    <a href="#" id="logoutBtn">로그아웃</a>
                </c:when>
                <c:otherwise>
                    <a href="/login">로그인</a>
                    <a href="/register">회원가입</a>
                </c:otherwise>
            </c:choose>
            <a href="#"><i data-feather="help-circle" class="feather-small"></i> 고객센터</a>
        </div>
    </div>
</div>

<!-- 모바일 메뉴 버튼 영역 -->
<div class="d-md-none bg-light py-2">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <!-- 햄버거 메뉴 버튼 -->
            <button class="btn btn-sm btn-light" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu">
                <i data-feather="menu" style="width: 20px; height: 20px;"></i>
            </button>

            <div class="d-flex">
                <a href="/" class="text-decoration-none text-dark me-2">
                    <i data-feather="archive" style="width: 18px; height: 18px;"></i>
                    <span class="fw-bold">냉장고 레시피</span>
                </a>
            </div>

            <!-- 모바일 검색 버튼 (필요시) -->
            <div>
                <button class="btn btn-sm btn-light" type="button" data-bs-toggle="collapse" data-bs-target="#mobileSearchArea" aria-expanded="false">
                    <i data-feather="search" style="width: 18px; height: 18px;"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 모바일 검색 영역 -->
<div class="collapse d-md-none" id="mobileSearchArea">
    <div class="container py-2">
        <form action="/recipes" method="get">
            <div class="input-group">
                <input type="search" class="form-control" placeholder="레시피 또는 재료 검색" name="query">
                <button class="btn btn-success" type="submit">
                    <i data-feather="search" style="width: 16px; height: 16px;"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<div class="header-main">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-7 col-sm-8 col-md-3 mb-3 mb-md-0 d-none d-lg-block">
                <a href="/" class="site-logo">
                    <i data-feather="archive" style="width: 28px; height: 28px;"></i>
                    <span class="d-none d-sm-inline">냉장고 레시피</span>
                    <span class="d-inline d-sm-none">냉레</span>
                </a>
            </div>

            <!-- 검색 폼 -->
            <div class="col-md-6 mt-3 mt-md-0">
                <form class="search-form mx-auto" action="/recipes" method="get">
                    <input class="form-control" type="search" placeholder="레시피 또는 재료 검색..." name="query" aria-label="Search">
                    <button class="btn btn-primary" type="submit">
                        <i data-feather="search" style="width: 18px; height: 18px;"></i>
                    </button>
                </form>
            </div>

            <!-- PC 액션 버튼 -->
            <div class="col-md-3 d-none d-md-block text-end">
                <c:choose>
                    <c:when test="${cookie.token != null || sessionScope.token != null || sessionScope.userId != null}">
                        <a href="/myRefrigerator" class="btn btn-outline-light me-2">
                            <i data-feather="archive"></i> 나의 냉장고
                        </a>
                        <a href="/addRecipe" class="btn btn-outline-light">
                            <i data-feather="edit-3"></i> 레시피 등록
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="/login" class="btn btn-outline-light me-2">
                            <i data-feather="log-in"></i> 로그인
                        </a>
                        <a href="/register" class="btn btn-light">
                            <i data-feather="user-plus"></i> 회원가입
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- 좌측에서 나타나는 사이드바 메뉴 (모바일) -->
<div class="offcanvas offcanvas-start d-lg-none" tabindex="-1" id="sidebarMenu" aria-labelledby="sidebarMenuLabel">
    <div class="offcanvas-header" style="background-color: var(--primary-color); color: white;">
        <h5 class="offcanvas-title" id="sidebarMenuLabel">냉장고 레시피</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link py-2" href="/">
                    <i data-feather="home" class="me-2" style="width: 18px; height: 18px;"></i>
                    홈
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2" href="/recipes">
                    <i data-feather="book-open" class="me-2" style="width: 18px; height: 18px;"></i>
                    레시피
                </a>
            </li>

            <c:if test="${cookie.token != null || sessionScope.token != null || sessionScope.userId != null}">
                <li class="nav-item">
                    <a class="nav-link py-2" href="/myRefrigerator">
                        <i data-feather="archive" class="me-2" style="width: 18px; height: 18px;"></i>
                        내 냉장고
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link py-2" href="/myRecipes">
                        <i data-feather="file-text" class="me-2" style="width: 18px; height: 18px;"></i>
                        내 레시피
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link py-2" href="/myFavorites">
                        <i data-feather="heart" class="me-2" style="width: 18px; height: 18px;"></i>
                        즐겨찾기
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link py-2" href="/myPage">
                        <i data-feather="user" class="me-2" style="width: 18px; height: 18px;"></i>
                        내 정보
                    </a>
                </li>
            </c:if>

            <li class="nav-item">
                <a class="nav-link py-2" href="/tips">
                    <i data-feather="info" class="me-2" style="width: 18px; height: 18px;"></i>
                    요리 팁
                </a>
            </li>

            <c:if test="${cookie.token != null || sessionScope.token != null || sessionScope.userId != null}">
                <li class="nav-item">
                    <a class="nav-link py-2" href="#" id="sidebarLogoutBtn">
                        <i data-feather="log-out" class="me-2" style="width: 18px; height: 18px;"></i>
                        로그아웃
                    </a>
                </li>
            </c:if>

            <c:if test="${cookie.token == null && sessionScope.token == null && sessionScope.userId == null}">
                <li class="nav-item">
                    <a class="nav-link py-2" href="/login">
                        <i data-feather="log-in" class="me-2" style="width: 18px; height: 18px;"></i>
                        로그인
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link py-2" href="/register">
                        <i data-feather="user-plus" class="me-2" style="width: 18px; height: 18px;"></i>
                        회원가입
                    </a>
                </li>
            </c:if>
        </ul>
    </div>
</div>

<!-- 데스크톱용 네비게이션 (LG 이상에서만 표시) -->
<nav class="navbar navbar-expand-lg d-none d-lg-block">
    <div class="container">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <i data-feather="menu"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <!-- 모든 사용자에게 표시되는 공통 메뉴 -->
                <li class="nav-item">
                    <a class="nav-link" href="/">홈</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/recipes">레시피</a>
                </li>

                <!-- 로그인한 사용자에게만 표시되는 메뉴 - PC -->
                <c:if test="${cookie.token != null || sessionScope.token != null || sessionScope.userId != null}">
                    <li class="nav-item d-none d-lg-block">
                        <a class="nav-link" href="/myRefrigerator">
                            <i data-feather="archive" class="me-1" style="width: 16px; height: 16px;"></i>내 냉장고
                        </a>
                    </li>
                    <li class="nav-item d-none d-lg-block">
                        <a class="nav-link" href="/myFavorites">
                            <i data-feather="heart" class="me-1" style="width: 16px; height: 16px;"></i>즐겨찾기
                        </a>
                    </li>
                    <li class="nav-item d-none d-lg-block">
                        <a class="nav-link" href="/addRecipe">
                            <i data-feather="edit-3" class="me-1" style="width: 16px; height: 16px;"></i>레시피 등록
                        </a>
                    </li>
                    <li class="nav-item d-none d-lg-block">
                        <a class="nav-link" href="/myPage">
                            <i data-feather="user" class="me-1" style="width: 16px; height: 16px;"></i>마이페이지
                        </a>
                    </li>

                    <!-- 모바일 드롭다운 메뉴 -->
                    <li class="nav-item dropdown d-lg-none">
                        <a class="nav-link dropdown-toggle" href="#" id="userMenuDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i data-feather="user" class="me-1" style="width: 16px; height: 16px;"></i>내 메뉴
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="userMenuDropdown">
                            <li><a class="dropdown-item" href="/myRefrigerator"><i data-feather="archive" class="me-2" style="width: 16px; height: 16px;"></i>내 냉장고</a></li>
                            <li><a class="dropdown-item" href="/myFavorites"><i data-feather="heart" class="me-2" style="width: 16px; height: 16px;"></i>즐겨찾기</a></li>
                            <li><a class="dropdown-item" href="/addRecipe"><i data-feather="edit-3" class="me-2" style="width: 16px; height: 16px;"></i>레시피 등록</a></li>
                            <li><a class="dropdown-item" href="/myPage"><i data-feather="user" class="me-2" style="width: 16px; height: 16px;"></i>마이페이지</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="#" id="mobileNavLogoutBtn"><i data-feather="log-out" class="me-2" style="width: 16px; height: 16px;"></i>로그아웃</a></li>
                        </ul>
                    </li>
                </c:if>

                <!-- 로그인하지 않은 사용자에게만 표시되는 메뉴 -->
                <c:if test="${cookie.token == null && sessionScope.token == null && sessionScope.userId == null}">
                    <li class="nav-item">
                        <a class="nav-link" href="/login">
                            <i data-feather="log-in" class="me-1" style="width: 16px; height: 16px;"></i>로그인
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/register">
                            <i data-feather="user-plus" class="me-1" style="width: 16px; height: 16px;"></i>회원가입
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<!-- 로그인한 사용자를 위한 로그아웃 스크립트 -->
<c:if test="${cookie.token != null || sessionScope.token != null || sessionScope.userId != null}">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 로그아웃 함수
        function logout() {
            console.log('로그아웃 함수 실행');

            // 토큰 쿠키 삭제
            document.cookie = 'token=; Max-Age=0; path=/;';
            console.log('쿠키 삭제됨');

            // 로컬 스토리지 데이터 삭제
            localStorage.removeItem('userId');
            localStorage.removeItem('userToken');
            console.log('로컬 스토리지 데이터 삭제됨');

            // 세션 만료를 위한 서버 호출
            fetch('/api/auth/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
                .then(response => {
                    console.log('로그아웃 API 응답:', response.status);
                    return response.json();
                })
                .then(data => {
                    console.log('로그아웃 성공:', data);
                    // 메시지 표시 후 홈으로 리디렉션
                    alert('로그아웃 되었습니다.');
                    window.location.href = '/';
                })
                .catch(error => {
                    console.error('로그아웃 중 오류 발생:', error);
                    // 오류가 발생해도 로그아웃은 진행
                    alert('로그아웃 되었습니다.');
                    window.location.href = '/';
                });
        }

        // 로그아웃 버튼 이벤트 리스너 등록
        const logoutBtn = document.getElementById('logoutBtn');
        const mobileLogoutBtn = document.getElementById('mobileLogoutBtn');
        const mobileNavLogoutBtn = document.getElementById('mobileNavLogoutBtn');
        const sidebarLogoutBtn = document.getElementById('sidebarLogoutBtn');

        if (logoutBtn) {
            logoutBtn.addEventListener('click', function(e) {
                e.preventDefault();
                logout();
            });
        }

        if (mobileLogoutBtn) {
            mobileLogoutBtn.addEventListener('click', function(e) {
                e.preventDefault();
                logout();
            });
        }

        if (mobileNavLogoutBtn) {
            mobileNavLogoutBtn.addEventListener('click', function(e) {
                e.preventDefault();
                logout();
            });
        }

        if (sidebarLogoutBtn) {
            sidebarLogoutBtn.addEventListener('click', function(e) {
                e.preventDefault();
                logout();
            });
        }

        // Feather 아이콘 초기화
        if (typeof feather !== 'undefined') {
            feather.replace();
        }

        // 모바일 환경에서 오프캔버스 메뉴 설정
        var offcanvasToggle = document.querySelector('[data-bs-toggle="offcanvas"]');
        var offcanvasElement = document.getElementById('sidebarMenu');

        if (offcanvasToggle && offcanvasElement) {
            // 부트스트랩 오프캔버스 수동 초기화
            var offcanvas = new bootstrap.Offcanvas(offcanvasElement);

            // 오프캔버스 내 링크 클릭 시 자동으로 닫기
            var offcanvasLinks = offcanvasElement.querySelectorAll('.nav-link');
            offcanvasLinks.forEach(function(link) {
                link.addEventListener('click', function() {
                    // 페이지 이동인 경우 지연 닫기
                    if (link.getAttribute('href') !== '#' && !link.getAttribute('href').startsWith('#')) {
                        setTimeout(function() {
                            offcanvas.hide();
                        }, 150);
                    }
                });
            });
        }
    });
</script>
</c:if>

<div class="main-content">
    <div class="container">
        <!-- 여기에 각 페이지의 내용이 들어갑니다 -->
