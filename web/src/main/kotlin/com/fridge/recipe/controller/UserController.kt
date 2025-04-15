package com.fridge.recipe.controller

import com.fridge.recipe.security.CustomUserDetails
import com.fridge.recipe.service.UserService
import com.fridge.recipe.util.JwtUtil
import com.fridge.recipe.vo.UserRegistrationDTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.core.Authentication
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.*
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Controller
class UserController(
    private val userService: UserService,
    private val jwtUtil: JwtUtil,
) {

    @GetMapping("/login")
    fun loginPage(
        request: HttpServletRequest
    ): String {
        return "login"
    }
    
    @GetMapping("/register")
    fun registerPage(
        request: HttpServletRequest
    ): String {
        return "register"
    }
    
    @GetMapping("/mypage")
    fun myPage(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        request: HttpServletRequest, response: HttpServletResponse,
        model: Model
    ): String {
        try {
            val user = userService.getUserByEmail(userDetails.username)

            model.addAttribute("user", user)
            return "myPage"
        } catch (e: Exception) {
            // 예외 발생 시 로그아웃 처리 후 메인페이지로 리다이렉트
            request.session?.invalidate()
            SecurityContextHolder.clearContext()
            return "redirect:/"
        }
    }

    @PostMapping("/api/auth/register")
    @ResponseBody
    fun register(@RequestBody registrationDTO: UserRegistrationDTO): ResponseEntity<Any> {
        return try {
            val user = userService.registerUser(registrationDTO)
            ResponseEntity.status(HttpStatus.CREATED).body(user)
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(mapOf("error" to e.message))
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(mapOf("error" to "Registration failed"))
        }
    }

}
