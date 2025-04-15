    </div>
</div>
    
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
        
        // Feather 아이콘 초기화
        feather.replace();
        
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
