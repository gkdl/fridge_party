package com.fridge.recipe.controller

import com.fridge.recipe.enum.Season
import com.fridge.recipe.security.CustomUserDetails
import com.fridge.recipe.service.RecipeService
import com.fridge.recipe.service.RecommendationService
import com.fridge.recipe.service.TipService
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import javax.servlet.http.HttpSession

@Controller
class MainController(
    private val recipeService: RecipeService,
    private val tipService: TipService,
    private val recommendationService: RecommendationService
) {

    @GetMapping("/")
    fun index(
        @AuthenticationPrincipal userDetails: CustomUserDetails?,
        model: Model,
        session: HttpSession
    ): String {
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
        val isLoggedIn = model.getAttribute("isLoggedIn") as? Boolean ?: false

        // 현재 계절 정보 가져오기
        val currentSeason = recommendationService.getCurrentSeason()
        model.addAttribute("currentSeason", currentSeason)

        // 계절별 레시피 가져오기 (현재 계절)
        val seasonalRecipes = recommendationService.getSeasonalRecipes(currentSeason, 6)
        model.addAttribute("seasonalRecipes", seasonalRecipes)

        // 로그인한 사용자일 경우 개인화된 추천 레시피 가져오기
        if (isLoggedIn) {
            val userId = userDetails?.getId()
            try {
               val recommendedRecipes = userId?.let { recommendationService.getRecommendedRecipes(it, 6) }
               model.addAttribute("recommendedRecipes", recommendedRecipes)
            } catch (e: Exception) {
               // 추천 레시피 가져오기 실패해도 계속 진행
               // 로그 출력
               println("사용자 개인화 추천 레시피 조회 실패: ${e.message}")
            }
        }

        // 모든 계절 리스트 추가
        model.addAttribute("seasons", Season.values())
        return "index"
    }
}