package com.fridge.recipe.controller

import com.fridge.recipe.enum.Season
import com.fridge.recipe.security.CustomUserDetails
import com.fridge.recipe.service.IngredientService
import com.fridge.recipe.util.DateUtil
import com.fridge.recipe.vo.AddIngredientDTO
import com.fridge.recipe.vo.IngredientDTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.*
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Controller
class IngredientController(
    private val ingredientService: IngredientService,
) {

    @GetMapping("/myRefrigerator")
    fun myRefrigeratorPage(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @CookieValue(name = "token", required = false) token: String?,
        model: Model,
        request: HttpServletRequest,
        response: HttpServletResponse
    ): String {
        try {
            val userIngredients = ingredientService.getUserIngredients(userDetails.getId())

            // 현재 계절 정보 추가
            val currentSeason = DateUtil.getCurrentSeason()
            model.addAttribute("currentSeason", currentSeason.name)
            model.addAttribute("seasonKr",
                when(currentSeason) {
                    Season.SPRING -> "봄"
                    Season.SUMMER -> "여름"
                    Season.FALL -> "가을"
                    Season.WINTER -> "겨울"
                    else -> "계절 미지정"
                }
            )

            // 사용자 재료 중 제철 재료와 아닌 재료 구분
            val (inSeasonIngredients, offSeasonIngredients) = userIngredients.partition { it.inSeason }
            model.addAttribute("ingredients", userIngredients)
            model.addAttribute("inSeasonIngredients", inSeasonIngredients)
            model.addAttribute("offSeasonIngredients", offSeasonIngredients)

            // 로그 추가하여 디버깅
            println("Loading myRefrigerator page for user: $userDetails.getId()")
            return "myRefrigerator"
        } catch (e: IllegalArgumentException) {
            // 사용자를 찾을 수 없는 경우 로그아웃 처리 후 메인페이지로 리다이렉트
            request.session?.invalidate()
            SecurityContextHolder.clearContext()
            return "redirect:/"
        }

    }

    @GetMapping("/api/user/ingredients")
    @ResponseBody
    fun getUserIngredients(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        request: HttpServletRequest,
    ): ResponseEntity<Any> {
        return try {
            val ingredients = ingredientService.getUserIngredients(userDetails.getId())
            ResponseEntity.ok(ingredients)
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(mapOf("error" to "Invalid token"))
        }
    }

    @GetMapping("/api/ingredients/search")
    @ResponseBody
    fun searchIngredients(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @RequestParam query: String
    ): ResponseEntity<List<IngredientDTO>> {
        val ingredients = ingredientService.searchIngredients(query)
        return ResponseEntity.ok(ingredients)
    }

    @PostMapping("/api/user/ingredients")
    @ResponseBody
    fun addUserIngredient(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @RequestBody addIngredientDTO: AddIngredientDTO,
        request: HttpServletRequest
    ): ResponseEntity<Any> {
        return try {
            val ingredient = ingredientService.addUserIngredient(userDetails.getId(), addIngredientDTO)
            ResponseEntity.status(HttpStatus.CREATED).body(ingredient)
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(mapOf("error" to e.message))
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(mapOf("error" to "Failed to add ingredient"))
        }
    }


}
