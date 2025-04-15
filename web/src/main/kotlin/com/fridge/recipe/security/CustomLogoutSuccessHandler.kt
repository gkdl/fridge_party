package com.fridge.recipe.security

import org.springframework.security.core.Authentication
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler
import org.springframework.stereotype.Component
import javax.servlet.http.Cookie
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Component
class CustomLogoutSuccessHandler(

) : LogoutSuccessHandler {
    /**
     * 로그아웃 성공 핸들러
     * 로그아웃 시 쿠키 및 세션 정리
     */

    override fun onLogoutSuccess(
        request: HttpServletRequest?,
        response: HttpServletResponse?,
        authentication: Authentication?
    ) {
        val nonNullRequest = requireNotNull(request) { "Request must not be null" }
        val nonNullResponse = requireNotNull(response) { "Response must not be null" }

        logoutUser(response, request)

        // 리다이렉트
        response.sendRedirect("/")
    }

    /**
     * 로그아웃 처리 유틸리티 함수
     */
    fun logoutUser(response: HttpServletResponse, request: HttpServletRequest) {
        // 쿠키 삭제
        val cookie = Cookie("token", "")
        cookie.path = "/"
        cookie.maxAge = 0
        response.addCookie(cookie)
        println("쿠키 삭제 완료")

        // 세션 무효화
        try {
            val session = request.getSession(false)
            if (session != null) {
                val sessionId = session.id
                session.removeAttribute("token")
                session.removeAttribute("userId")
                session.invalidate()
                println("세션 무효화 완료: 세션 ID $sessionId")
            } else {
                println("로그아웃 - 활성화된 세션이 없음")
            }
        } catch (e: Exception) {
            println("세션 무효화 중 오류 발생: ${e.message}")
            // 세션 무효화 중 오류가 발생해도 로그아웃은 진행
        }
    }
}