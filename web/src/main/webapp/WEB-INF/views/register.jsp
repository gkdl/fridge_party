<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />

<div class="row justify-content-center">
    <div class="col-md-6 col-lg-4">
        <div class="card shadow-sm my-5">
            <div class="card-body p-4">
                <h3 class="text-center mb-4">회원가입</h3>
                
                <div id="registerAlert" class="alert alert-danger d-none" role="alert"></div>
                
                <form id="registerForm">
                    <div class="mb-3">
                        <label for="username" class="form-label">이름</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">비밀번호</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                        <div class="form-text">8자 이상, 영문, 숫자, 특수문자를 포함해주세요.</div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">비밀번호 확인</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <div class="mb-3 form-check d-flex align-items-center">
                        <input type="checkbox" class="form-check-input me-2" id="agreeTerms" name="agreeTerms" required>
                        <label class="form-check-label mb-0" for="agreeTerms">
                            <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">이용약관</a>에 동의합니다.
                        </label>
                    </div>
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">회원가입</button>
                    </div>
                </form>
                
                <hr class="my-4">
                
<%--                <div class="d-grid gap-2">--%>
<%--                    <button type="button" class="btn btn-warning" id="kakaoLogin">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">--%>
<%--                            <path d="M12 3C6.5 3 2 6.3 2 10.5c0 2.9 1.9 5.5 4.7 6.9-.2.7-.7 2.5-.8 2.9-.1.5.2.5.4.3.2-.1 2.6-1.8 3.7-2.5.7.1 1.3.2 2 .2 5.5 0 10-3.3 10-7.5S17.5 3 12 3z"/>--%>
<%--                        </svg>--%>
<%--                        카카오로 시작하기--%>
<%--                    </button>--%>
<%--                    <button type="button" class="btn btn-success" id="naverLogin">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">--%>
<%--                            <path d="M16.273 12.845L7.376 0H0v24h7.727V11.155L16.624 24H24V0h-7.727v12.845z"/>--%>
<%--                        </svg>--%>
<%--                        네이버로 시작하기--%>
<%--                    </button>--%>
<%--                    <button type="button" class="btn btn-danger" id="googleLogin">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">--%>
<%--                            <path d="M12.545 10.239v3.821h5.445c-.712 2.315-2.647 3.972-5.445 3.972a6.033 6.033 0 110-12.064 5.963 5.963 0 014.23 1.744l2.876-2.746A9.99 9.99 0 0012.545 2C7.021 2 2.543 6.477 2.543 12s4.478 10 10.002 10c8.396 0 10.249-7.85 9.426-11.748l-9.426-.013z"/>--%>
<%--                        </svg>--%>
<%--                        구글로 시작하기--%>
<%--                    </button>--%>
<%--                </div>--%>
                
                <p class="mt-4 text-center">
                    이미 계정이 있으신가요? <a href="/login">로그인</a>
                </p>
            </div>
        </div>
    </div>
</div>

<!-- 이용약관 모달 -->
<div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="termsModalLabel">이용약관</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <h6>이용약관 동의</h6>
                <p>
                    이 약관은 냉장고 레시피 웹사이트의 이용과 관련하여 사이트와 이용자 간의 권리, 의무 및 책임사항을 규정합니다.
                </p>
                <p>
                    1. 회원가입 시 제공한 개인정보는 본인의 동의 없이 제3자에게 제공되지 않습니다.<br>
                    2. 서비스 이용 시 관련 법령 및 약관을 준수해야 합니다.<br>
                    3. 타인의 저작권, 명예 등을 침해하는 게시물을 작성하지 않아야 합니다.<br>
                    4. 서비스 내용 및 이용약관은 사전 공지 없이 변경될 수 있습니다.
                </p>
                
                <h6 class="mt-4">개인정보 처리방침</h6>
                <p>
                    냉장고 레시피는 개인정보보호법, 정보통신망법 등 관련 법령을 준수하며, 회원의 개인정보를 보호하기 위해 노력합니다.
                </p>
                <p>
                    1. 수집하는 개인정보: 이메일, 이름, 비밀번호<br>
                    2. 개인정보의 수집 및 이용목적: 서비스 제공, 계정 관리<br>
                    3. 개인정보의 보유 및 이용기간: 회원 탈퇴 시까지<br>
                    4. 회원은 개인정보 수집 및 이용에 대한 동의를 거부할 권리가 있으나, 이 경우 서비스 이용이 제한될 수 있습니다.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // 회원가입 폼 제출 처리
    $('#registerForm').submit(function(e) {
        e.preventDefault();
        
        const username = $('#username').val();
        const email = $('#email').val();
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();
        
        // 비밀번호 확인
        if (password !== confirmPassword) {
            $('#registerAlert').removeClass('d-none').text('비밀번호가 일치하지 않습니다.');
            return;
        }
        
        // 비밀번호 정책 검사 (간단한 정규식)
        const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
        if (!passwordRegex.test(password)) {
            $('#registerAlert').removeClass('d-none').text('비밀번호는 8자 이상, 영문, 숫자, 특수문자를 포함해야 합니다.');
            return;
        }
        
        $.ajax({
            url: '/api/auth/register',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                username: username,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            }),
            success: function(response) {
                // 회원가입 성공 시 로그인 페이지로 이동
                window.location.href = '/login?registered=true';
            },
            error: function(xhr) {
                const error = xhr.responseJSON;
                $('#registerAlert').removeClass('d-none').text(error.error || '회원가입에 실패했습니다.');
            }
        });
    });
    
    // 소셜 로그인 버튼 처리 (실제 구현은 별도로 필요)
    $('#kakaoLogin, #naverLogin, #googleLogin').click(function() {
        $('#registerAlert').removeClass('d-none').text('소셜 로그인은 현재 개발 중입니다.');
    });
});
</script>

<jsp:include page="include/footer.jsp" />
