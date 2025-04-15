package com.fridge.recipe.security.filter

import com.fridge.recipe.repository.UserRepository
import com.fridge.recipe.util.JwtUtil
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import java.io.IOException
import javax.servlet.FilterChain
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

/**
 * JWT 인증 필터
 * 모든 HTTP 요청에 대해 JWT 토큰을 검증하고 인증 정보를 설정
 */
@Component
class JwtAuthenticationFilter(
    private val jwtUtil: JwtUtil,
    private val userRepository: UserRepository
) : OncePerRequestFilter() {

    /**
     * 필터 로직
     * 1. 요청에서 JWT 토큰을 추출
     * 2. 토큰이 유효한 경우 SecurityContext에 인증 정보 설정
     */
    @Throws(ServletException::class, IOException::class)
    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        val tokenFromCookie = getTokenFromCookie(request)
        val tokenFromSession = getTokenFromSession(request)
        val userIdFromSession = getUserIdFromSession(request)
        
        // 토큰이 있는 경우
        if (tokenFromCookie != null || tokenFromSession != null) {
            val token = tokenFromCookie ?: tokenFromSession
            try {
                if (jwtUtil.validateToken(token!!)) {
                    val username = jwtUtil.extractUsername(token)
                    val userOpt = userRepository.findByEmail(username)
                    
                    if (userOpt.isPresent && SecurityContextHolder.getContext().authentication == null) {
                        val user = userOpt.get()
                        // 인증 객체 생성 시 User 자체 대신 사용자 ID를 전달하여 직렬화 문제 방지
                        val userDetails = org.springframework.security.core.userdetails.User(
                            user.email, 
                            user.password, 
                            emptyList()
                        )
                        val authentication = UsernamePasswordAuthenticationToken(
                            userDetails, null, emptyList()
                        )
                        authentication.details = WebAuthenticationDetailsSource().buildDetails(request)
                        // 인증 객체를 저장하기 전에 세션에도 사용자 ID 저장
                        request.getSession(true).setAttribute("userId", user.id)
                        SecurityContextHolder.getContext().authentication = authentication
                    }
                }
            } catch (e: Exception) {
                // 토큰 검증 실패시 인증 컨텍스트는 비워두고 계속 진행
                logger.error("JWT 인증 오류: ${e.message}")
            }
        } 
        // 세션에 userId가 있는 경우
        else if (userIdFromSession != null) {
            try {
                val userOpt = userRepository.findById(userIdFromSession)
                
                if (userOpt.isPresent && SecurityContextHolder.getContext().authentication == null) {
                    val user = userOpt.get()
                    // 인증 객체 생성 시 User 자체 대신 사용자 ID를 전달하여 직렬화 문제 방지
                    val userDetails = org.springframework.security.core.userdetails.User(
                        user.email, 
                        user.password, 
                        emptyList()
                    )
                    val authentication = UsernamePasswordAuthenticationToken(
                        userDetails, null, emptyList()
                    )
                    authentication.details = WebAuthenticationDetailsSource().buildDetails(request)
                    SecurityContextHolder.getContext().authentication = authentication
                }
            } catch (e: Exception) {
                logger.error("세션 인증 오류: ${e.message}")
            }
        }
        
        filterChain.doFilter(request, response)
    }
    
    /**
     * 쿠키에서 토큰 추출
     */
    private fun getTokenFromCookie(request: HttpServletRequest): String? {
        val cookies = request.cookies ?: return null
        
        for (cookie in cookies) {
            if (cookie.name == "token") {
                return cookie.value
            }
        }
        return null
    }
    
    /**
     * 세션에서 토큰 추출
     */
    private fun getTokenFromSession(request: HttpServletRequest): String? {
        val session = request.getSession(false) ?: return null
        return session.getAttribute("token") as? String
    }
    
    /**
     * 세션에서 userId 추출
     */
    private fun getUserIdFromSession(request: HttpServletRequest): Long? {
        val session = request.getSession(false) ?: return null
        return session.getAttribute("userId") as? Long
    }
}