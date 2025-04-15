package com.fridge.recipe.controller

import com.fridge.recipe.enum.DeviceType
import com.fridge.recipe.service.RecipeService
import com.fridge.recipe.service.TipService
import javax.servlet.http.HttpServletRequest
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import javax.servlet.http.HttpSession

@Controller
class MainController(
    private val recipeService: RecipeService,
    private val tipService: TipService
) {

    @GetMapping("/")
    fun index(model: Model, session: HttpSession): String {
        // 인기 레시피 가져오기
        val popularRecipes = recipeService.getPopularRecipes(6)
        model.addAttribute("popularRecipes", popularRecipes)

        // 최신 레시피 가져오기
        val recentRecipes = recipeService.getRecentRecipes(6)
        model.addAttribute("recentRecipes", recentRecipes)

        // 요리 팁 가져오기 (랜덤)
        val cookingTips = tipService.getRandomCookingTips(3)
        model.addAttribute("cookingTips", cookingTips)

        // 유통기한 팁 가져오기 (랜덤)
        val expiryTips = tipService.getRandomExpiryTips(3)
        model.addAttribute("expiryTips", expiryTips)

        // 사용자 로그인 상태 체크
        val token = session.getAttribute("token") as String?
        val isLoggedIn = token != null || session.getAttribute("userId") != null
        model.addAttribute("isLoggedIn", isLoggedIn)

        return "index"
    }
}