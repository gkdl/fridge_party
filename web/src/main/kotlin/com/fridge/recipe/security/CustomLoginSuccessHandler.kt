package com.fridge.recipe.security

import com.fridge.recipe.util.JwtUtil
import org.springframework.security.core.Authentication
import org.springframework.security.web.authentication.AuthenticationSuccessHandler
import org.springframework.stereotype.Component
import java.io.IOException
import javax.servlet.http.Cookie
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Component
class CustomLoginSuccessHandler(
    private val jwtUtil: JwtUtil
) : AuthenticationSuccessHandler {
    @Throws(IOException::class)
    override fun onAuthenticationSuccess(
        request: HttpServletRequest,
        response: HttpServletResponse,
        authentication: Authentication
    ) {
        val userDetails = authentication.principal as CustomUserDetails

        val token = jwtUtil.createToken(userDetails.username)

        // JWT 토큰을 쿠키에 저장
        val cookie = Cookie("token", token)
        cookie.path = "/"
        cookie.maxAge = 24 * 60 * 60 // 1일
        cookie.isHttpOnly = false
        response.addCookie(cookie)
        println("쿠키 생성 완료")

        // 세션에도 토큰 정보 저장
        val session = request.getSession(true)
        session.setAttribute("token", token)
        session.setAttribute("userId", userDetails.getId())
        session.maxInactiveInterval = 24 * 60 * 60 // 1일
        println("세션 생성 완료: 세션 ID ${session.id}, 사용자 ID ${userDetails.username}")


        // 기본 성공 URL로 리다이렉트
        response.sendRedirect("/")
    }
}