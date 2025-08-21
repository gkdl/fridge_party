<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<div class="row justify-content-center">
    <div class="col-md-6 col-lg-4">
        <div class="card shadow-sm my-5">
            <div class="card-body p-4">
                <h3 class="text-center mb-4">로그인</h3>
                
                <div id="loginAlert" class="alert alert-danger d-none" role="alert"></div>
                
                <form id="loginForm" method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
                    <div class="mb-3">
                        <label for="email" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">비밀번호</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="mb-3 form-check d-flex align-items-center">
                        <input type="checkbox" class="form-check-input me-2" id="rememberMe" name="rememberMe">
                        <label class="form-check-label mb-0" for="rememberMe">로그인 상태 유지</label>
                    </div>
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">로그인</button>
                    </div>
                </form>
                
                <hr class="my-4">
                
<%--                <div class="d-grid gap-2">--%>
<%--                    <button type="button" class="btn btn-warning" id="kakaoLogin">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">--%>
<%--                            <path d="M12 3C6.5 3 2 6.3 2 10.5c0 2.9 1.9 5.5 4.7 6.9-.2.7-.7 2.5-.8 2.9-.1.5.2.5.4.3.2-.1 2.6-1.8 3.7-2.5.7.1 1.3.2 2 .2 5.5 0 10-3.3 10-7.5S17.5 3 12 3z"/>--%>
<%--                        </svg>--%>
<%--                        카카오 로그인--%>
<%--                    </button>--%>
<%--                    <button type="button" class="btn btn-success" id="naverLogin">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">--%>
<%--                            <path d="M16.273 12.845L7.376 0H0v24h7.727V11.155L16.624 24H24V0h-7.727v12.845z"/>--%>
<%--                        </svg>--%>
<%--                        네이버 로그인--%>
<%--                    </button>--%>
<%--                    <button type="button" class="btn btn-danger" id="googleLogin">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">--%>
<%--                            <path d="M12.545 10.239v3.821h5.445c-.712 2.315-2.647 3.972-5.445 3.972a6.033 6.033 0 110-12.064 5.963 5.963 0 014.23 1.744l2.876-2.746A9.99 9.99 0 0012.545 2C7.021 2 2.543 6.477 2.543 12s4.478 10 10.002 10c8.396 0 10.249-7.85 9.426-11.748l-9.426-.013z"/>--%>
<%--                        </svg>--%>
<%--                        구글 로그인--%>
<%--                    </button>--%>
<%--                </div>--%>
                
                <p class="mt-4 text-center">
                    계정이 없으신가요? <a href="/register">회원가입</a>
                </p>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // 로그인 폼 제출 처리
    // $('#loginForm').submit(function(e) {
    //     e.preventDefault();
    //
    //     const email = $('#email').val();
    //     const password = $('#password').val();
    //
    //     $.ajax({
    //         url: '/api/auth/login',
    //         type: 'POST',
    //         contentType: 'application/json',
    //         data: JSON.stringify({
    //             email: email,
    //             password: password
    //         }),
    //         success: function(response) {
    //             // 로그인 성공 시 토큰 저장 및 홈페이지로 이동
    //             console.log("Login success:", response);
    //
    //             // 로컬 스토리지에 사용자 ID와 토큰 저장 (세션 백업용)
    //             localStorage.setItem('userId', response.user.id);
    //             localStorage.setItem('userToken', response.token);
    //
    //             // 홈페이지로 이동
    //             window.location.href = '/';
    //         },
    //         error: function(xhr) {
    //             const error = xhr.responseJSON;
    //             $('#loginAlert').removeClass('d-none').text(error.error || '로그인에 실패했습니다.');
    //         }
    //     });
    // });
    
    // 소셜 로그인 버튼 처리
    $('#kakaoLogin').click(function() {
        window.location.href = '/oauth2/authorize/kakao?redirect_uri=' + encodeURIComponent(window.location.origin);
    });
    
    $('#naverLogin').click(function() {
        window.location.href = '/oauth2/authorize/naver?redirect_uri=' + encodeURIComponent(window.location.origin);
    });
    
    $('#googleLogin').click(function() {
        window.location.href = '/oauth2/authorize/google?redirect_uri=' + encodeURIComponent(window.location.origin);
    });
});
</script>

<jsp:include page="include/footer.jsp" />
