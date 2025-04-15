package com.fridge.recipe.controller

import com.fridge.recipe.enum.ActivityType
import com.fridge.recipe.security.CustomUserDetails
import com.fridge.recipe.service.RecipeService
import com.fridge.recipe.service.RecommendationService
import com.fridge.recipe.service.UserActivityService
import com.fridge.recipe.vo.RatingCreateDTO
import com.fridge.recipe.vo.RecipeCreateDTO
import com.fridge.recipe.vo.RecipeSearchDTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.*
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Controller
class RecipeController(
    private val recipeService: RecipeService,
    private val recommendationService: RecommendationService,
    private val userActivityService: UserActivityService

) {
    @GetMapping("/api/recipes/recommended")
    @ResponseBody
    fun getRecommendedRecipes(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @RequestParam(required = false, defaultValue = "10") count: Int,
        @CookieValue(name = "token", required = false) token: String?
    ): ResponseEntity<Any> {
        return try {
            val recipes = recommendationService.getRecommendedRecipes(userDetails.getId(), count)
            ResponseEntity.ok(recipes)
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(mapOf("error" to "Failed to fetch recommended recipes"))
        }
    }

    @PutMapping("/api/recipes/{recipeId}")
    @ResponseBody
    fun updateRecipe(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @PathVariable recipeId: Long,
        @RequestBody recipeUpdateDTO: RecipeCreateDTO,
        @CookieValue(name = "token", required = false) token: String?
    ): ResponseEntity<Any> {
        if (token == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(mapOf("error" to "Not authenticated"))
        }

        return try {
            val recipe = recipeService.updateRecipe(userDetails.getId(), recipeId, recipeUpdateDTO)
            ResponseEntity.ok(recipe)
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(mapOf("error" to e.message))
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(mapOf("error" to "Failed to update recipe"))
        }
    }

    @GetMapping("/recipes/{recipeId}")
    fun recipeDetailPage(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @PathVariable recipeId: Long,
        model: Model
    ): String {
        try {
            val recipe = recipeService.getRecipeById(recipeId, userDetails.getId())
            model.addAttribute("recipe", recipe)
            model.addAttribute("isLoggedIn", true)
            return "recipeDetail"
        } catch (e: IllegalArgumentException) {
            // 레시피를 찾을 수 없는 경우 레시피 목록으로 리다이렉트
            return "redirect:/recipes"
        } catch (e: Exception) {
            return "redirect:/logout"
        }
    }

    /**
     * 유사한 레시피 추천 API
     */
    @GetMapping("/api/recipes/{recipeId}/similar")
    @ResponseBody
    fun getSimilarRecipes(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @PathVariable recipeId: Long,
        @RequestParam(required = false, defaultValue = "4") count: Int,
    ): ResponseEntity<Any> {
        return try {
            val recipes = recommendationService.getSimilarRecipes(recipeId, count, userDetails.getId())
            ResponseEntity.ok(recipes)
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(mapOf("error" to "유사한 레시피를 찾는데 실패했습니다: ${e.message}"))
        }
    }

    @PostMapping("/api/recipes/{recipeId}/rating")
    @ResponseBody
    fun rateRecipe(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @PathVariable recipeId: Long,
        @RequestBody ratingDTO: RatingCreateDTO,
    ): ResponseEntity<Any> {
        try {
            // recipeId와 DTO의 recipeId 일치 확인
            val ratingCreateDTO = ratingDTO.copy(recipeId = recipeId)
            val rating = recipeService.rateRecipe(userDetails.getId(), ratingCreateDTO)

            return ResponseEntity.ok(rating)
        } catch (e: IllegalArgumentException) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(mapOf("error" to e.message))
        } catch (e: Exception) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(mapOf("error" to "평점 등록에 실패했습니다"))
        }
    }

    /**
     * 레시피 평점 목록 조회 API
     * @param recipeId 레시피 ID
     * @return 평점 목록
     */
    @GetMapping("/api/recipes/{recipeId}/ratings")
    @ResponseBody
    fun getRecipeRatings(
        @PathVariable recipeId: Long,
        @RequestParam(required = false, defaultValue = "0") page: Int,
        @RequestParam(required = false, defaultValue = "10") size: Int,
    ): ResponseEntity<Any> {
        return try {
            val ratings = recipeService.getRecipeRatings(recipeId, page, size)
            ResponseEntity.ok(ratings)
        } catch (e: IllegalArgumentException) {
            ResponseEntity.status(HttpStatus.NOT_FOUND).body(mapOf("error" to e.message))
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(mapOf("error" to "평점 목록을 불러오는데 실패했습니다"))
        }
    }

    @GetMapping("/editRecipe/{recipeId}")
    fun editRecipePage(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @PathVariable recipeId: Long,
        model: Model,
    ): String {

        try {
            try {
                val recipe = recipeService.getRecipeById(recipeId, userDetails.getId())

                // 레시피 소유자만 편집 가능
                if (recipe.userId != userDetails.getId()) {
                    return "redirect:/recipes/${recipeId}"
                }

                model.addAttribute("recipe", recipe)
                return "addRecipe"
            } catch (e: IllegalArgumentException) {
                return "redirect:/"
            }
        } catch (e: Exception) {
            return "redirect:/"
        }
    }


    @GetMapping("/recipes")
    fun recipesPage(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @RequestParam(required = false) query: String?,
        @RequestParam(required = false, defaultValue = "0") page: Int,
        model: Model,
        request: HttpServletRequest
    ): String {

        val searchDTO = RecipeSearchDTO(
            query = query,
            page = page,
            size = 12
        )

        val recipes = recipeService.searchRecipes(searchDTO, userDetails.getId())
        model.addAttribute("recipes", recipes.content)
        model.addAttribute("currentPage", page)
        model.addAttribute("totalPages", recipes.totalPages)
        model.addAttribute("query", query)
        model.addAttribute("isLoggedIn", true)

        return "recipeList"
    }
}
