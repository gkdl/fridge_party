</div>
</div>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 모바일 하단 액션 바 -->
<div class="d-md-none fixed-bottom bg-white shadow-lg" id="mobile-action-bar">
    <div class="d-flex justify-content-around p-2">
        <a href="/recipes" class="text-center text-decoration-none text-secondary">
            <div class="d-flex flex-column align-items-center">
                <i data-feather="book-open" style="width: 20px; height: 20px;"></i>
                <span class="small mt-1">레시피</span>
            </div>
        </a>
        <a href="/myRefrigerator" class="text-center text-decoration-none text-secondary">
            <div class="d-flex flex-column align-items-center">
                <i data-feather="archive" style="width: 20px; height: 20px;"></i>
                <span class="small mt-1">냉장고</span>
            </div>
        </a>
        <a href="/" class="text-center text-decoration-none text-secondary">
            <div class="d-flex flex-column align-items-center">
                <i data-feather="home" style="width: 20px; height: 20px;"></i>
                <span class="small mt-1">홈</span>
            </div>
        </a>

        <c:if test="${isLoggedIn}">
            <a href="/myFavorites" class="text-center text-decoration-none text-secondary">
                <div class="d-flex flex-column align-items-center">
                    <i data-feather="heart" style="width: 20px; height: 20px;"></i>
                    <span class="small mt-1">즐겨찾기</span>
                </div>
            </a>
            <a href="/myPage" class="text-center text-decoration-none text-secondary">
                <div class="d-flex flex-column align-items-center">
                    <i data-feather="user" style="width: 20px; height: 20px;"></i>
                    <span class="small mt-1">내정보</span>
                </div>
            </a>
        </c:if>
        <c:if test="${!isLoggedIn}">
            <a href="/myFavorites" class="text-center text-decoration-none text-secondary">
                <div class="d-flex flex-column align-items-center">
                    <i data-feather="heart" style="width: 20px; height: 20px;"></i>
                    <span class="small mt-1">즐겨찾기</span>
                </div>
            </a>
            <a href="/login" class="text-center text-decoration-none text-secondary">
                <div class="d-flex flex-column align-items-center">
                    <i data-feather="log-in" style="width: 20px; height: 20px;"></i>
                    <span class="small mt-1">로그인</span>
                </div>
            </a>
        </c:if>
    </div>
</div>

<!-- 모바일 하단 액션바가 있을 때 푸터에 패딩 추가 -->
<style>
    @media (max-width: 767.98px) {
        .footer {
            padding-bottom: 76px;
        }

        /* 메인 컨텐츠 영역도 하단 패딩 추가 */
        .main-content {
            padding-bottom: 80px;
        }
    }
</style>

<footer class="footer">
    <div class="footer-top py-5" style="background-color: #292929;">
        <div class="container">
            <div class="row gy-4">
                <div class="col-lg-4 col-md-6">
                    <div class="footer-logo mb-4 d-flex align-items-center">
                        <i data-feather="home" class="text-white me-2" style="width: 28px; height: 28px;"></i>
                        <h5 class="text-white mb-0 fw-bold">Refrigerator Recipe</h5>
                    </div>
                    <p class="text-white-50 mb-4">Create delicious recipes with ingredients in your refrigerator. From ingredient management to recipe recommendations!</p>
                    <div class="d-flex gap-3 mb-4">
                        <a href="#" class="social-link bg-white d-flex align-items-center justify-content-center rounded-circle" style="width: 36px; height: 36px;">
                            <i data-feather="facebook" style="width: 18px; height: 18px; color: #292929;"></i>
                        </a>
                        <a href="#" class="social-link bg-white d-flex align-items-center justify-content-center rounded-circle" style="width: 36px; height: 36px;">
                            <i data-feather="instagram" style="width: 18px; height: 18px; color: #292929;"></i>
                        </a>
                        <a href="#" class="social-link bg-white d-flex align-items-center justify-content-center rounded-circle" style="width: 36px; height: 36px;">
                            <i data-feather="youtube" style="width: 18px; height: 18px; color: #292929;"></i>
                        </a>
                        <a href="#" class="social-link bg-white d-flex align-items-center justify-content-center rounded-circle" style="width: 36px; height: 36px;">
                            <i data-feather="twitter" style="width: 18px; height: 18px; color: #292929;"></i>
                        </a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5 class="text-white fw-bold mb-4">Shortcuts</h5>
                    <ul class="list-unstyled footer-links">
                        <li class="mb-2"><a href="/" class="text-white-50 text-decoration-none">Home</a></li>
                        <li class="mb-2"><a href="/recipes" class="text-white-50 text-decoration-none">Recipe List</a></li>
                        <li class="mb-2"><a href="/myRefrigerator" class="text-white-50 text-decoration-none">My Refrigerator</a></li>
                        <li class="mb-2"><a href="/myFavorites" class="text-white-50 text-decoration-none">Favorites</a></li>
                        <li><a href="/addRecipe" class="text-white-50 text-decoration-none">Add Recipe</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5 class="text-white fw-bold mb-4">Help</h5>
                    <ul class="list-unstyled footer-links">
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">FAQ</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">User Guide</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Contact Us</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none">Feedback</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-6">
                    <h5 class="text-white fw-bold mb-4">Newsletter</h5>
                    <p class="text-white-50 mb-3">Get the latest recipes and cooking tips via email</p>
                    <form class="mb-3">
                        <div class="input-group">
                            <input type="email" class="form-control" placeholder="Email address" style="border-radius: 50px 0 0 50px; height: 46px; border: none;">
                            <button class="btn btn-primary px-3" type="submit" style="border-radius: 0 50px 50px 0; height: 46px; border: none;">Subscribe</button>
                        </div>
                    </form>
                    <div class="d-flex align-items-center text-white-50 gap-2">
                        <i data-feather="shield" style="width: 16px; height: 16px;"></i>
                        <small>Your information is securely protected</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom py-3" style="background-color: #1e1e1e;">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start">
                    <p class="text-white-50 mb-0">&copy; 2025 Refrigerator Recipe. All rights reserved.</p>
                </div>
                <div class="col-md-6 mt-3 mt-md-0">
                    <ul class="list-inline text-center text-md-end mb-0">
                        <li class="list-inline-item"><a href="#" class="text-white-50 text-decoration-none small">Terms of Service</a></li>
                        <li class="list-inline-item ms-3"><a href="#" class="text-white-50 text-decoration-none small">Privacy Policy</a></li>
                        <li class="list-inline-item ms-3"><a href="#" class="text-white-50 text-decoration-none small">Cookie Policy</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</footer>

<script>
    // 로그아웃 처리
    $(document).ready(function() {
        // PC 버전 로그아웃 처리
        $('#logoutBtn').click(function(e) {
            e.preventDefault();
            handleLogout();
        });

        // 모바일 버전 로그아웃 처리
        $('#mobileLogoutBtn').click(function(e) {
            e.preventDefault();
            handleLogout();
        });

        // 로그아웃 공통 함수
        function handleLogout() {
            $.ajax({
                url: '/api/auth/logout',
                type: 'POST',
                success: function(response) {
                    window.location.href = '/';
                },
                error: function(error) {
                    console.error('Logout failed', error);
                    alert('로그아웃에 실패했습니다. 다시 시도해주세요.');
                }
            });
        }

        // Feather 아이콘 초기화 (모바일 하단 액션바 포함)
        feather.replace();

        // 모바일 액션바에서 현재 페이지에 해당하는 아이콘 활성화
        const currentPath = window.location.pathname;
        $('#mobile-action-bar a').each(function() {
            const href = $(this).attr('href');
            // 경로가 정확히 일치하거나, 서브 경로일 경우 (예: /recipes/123은 /recipes와 일치)
            if (currentPath === href || (href !== '/' && currentPath.startsWith(href))) {
                $(this).removeClass('text-secondary').addClass('text-primary');
                $(this).find('i').css('stroke', '#4CAF50'); // 변수 사용 필요시 var(--primary-color)로 변경
            }
        });

        // 호버 효과
        $('.card').hover(
            function() {
                $(this).addClass('shadow-lg');
            },
            function() {
                $(this).removeClass('shadow-lg');
            }
        );

        // 스크롤 애니메이션 - 필요한 경우 AOS 라이브러리 추가
    });
</script>
</body>
</html>
