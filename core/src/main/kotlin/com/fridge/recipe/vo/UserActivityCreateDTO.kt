package com.fridge.recipe.vo

import com.fridge.recipe.enum.ActivityType

/**
 * 사용자 활동 생성을 위한 DTO
 */
data class UserActivityCreateDTO(
        val activityType: ActivityType,
        val recipeId: Long? = null,
        val searchQuery: String? = null,
        val weight: Double = 1.0
)