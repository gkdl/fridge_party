package com.fridge.recipe.security

import org.springframework.stereotype.Component
import org.springframework.web.servlet.HandlerInterceptor
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Component
class CustomInterceptor (

): HandlerInterceptor{
    override fun preHandle(request: HttpServletRequest, response: HttpServletResponse, handler: Any): Boolean {
        val isLoggedIn = request.session.getAttribute("userId") != null
        request.setAttribute("isLoggedIn", isLoggedIn)

        return super.preHandle(request, response, handler)
    }
}