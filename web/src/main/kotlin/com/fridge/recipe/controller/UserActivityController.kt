package com.fridge.recipe.controller

import com.fridge.recipe.enum.ActivityType
import com.fridge.recipe.security.CustomUserDetails
import com.fridge.recipe.service.UserActivityService
import com.fridge.recipe.vo.UserActivityCreateDTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*

@Controller
@RequestMapping("/api/activities")
class UserActivityController(
    private val userActivityService: UserActivityService
) {
    
    /**
     * 사용자 활동 기록 API
     */
    @PostMapping
    @ResponseBody
    fun recordActivity(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @RequestBody activityCreateDTO: UserActivityCreateDTO
    ): ResponseEntity<Any> {
        return try {
            val activity = userActivityService.recordActivity(userDetails.getId(), activityCreateDTO)
            ResponseEntity.ok(activity)
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(mapOf("error" to "활동 기록을 저장하는데 실패했습니다: ${e.message}"))
        }
    }
    
    /**
     * 사용자 활동 통계 조회 API
     */
    @GetMapping("/stats")
    @ResponseBody
    fun getUserActivityStats(
        @AuthenticationPrincipal userDetails: CustomUserDetails
    ): ResponseEntity<Any> {
        return try {
            val stats = userActivityService.getUserActivityStats(userDetails.getId())
            ResponseEntity.ok(stats)
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(mapOf("error" to "활동 통계를 조회하는데 실패했습니다: ${e.message}"))
        }
    }
    
    /**
     * 특정 레시피 조회 활동 기록 간소화 API
     */
    @PostMapping("/view/{recipeId}")
    @ResponseBody
    fun recordViewActivity(
        @AuthenticationPrincipal userDetails: CustomUserDetails,
        @PathVariable recipeId: Long,
    ): ResponseEntity<Any> {
        val activityDTO = UserActivityCreateDTO(
            activityType = ActivityType.VIEW_RECIPE,
            recipeId = recipeId
        )
        
        return try {
            userActivityService.recordActivity(userDetails.getId(), activityDTO)
            ResponseEntity.ok(mapOf("success" to true))
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(mapOf("error" to "활동 기록을 저장하는데 실패했습니다"))
        }
    }
}