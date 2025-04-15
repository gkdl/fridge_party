package com.fridge.recipe.vo

import com.fridge.recipe.enum.ActivityType
import java.time.LocalDateTime

/**
 * 사용자 활동 정보를 주고받기 위한 DTO
 */
data class UserActivityDTO(
        val id: Long? = null,
        val userId: Long,
        val username: String? = null,
        val activityType: ActivityType,
        val recipeId: Long? = null,
        val recipeTitle: String? = null,
        val searchQuery: String? = null,
        val weight: Double,
        val createdAt: String
)