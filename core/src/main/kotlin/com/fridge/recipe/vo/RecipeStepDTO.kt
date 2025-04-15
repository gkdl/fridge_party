package com.fridge.recipe.vo

import java.time.LocalDateTime

// 레시피 단계 응답 DTO
data class RecipeStepDTO(
    val id: Long,
    val recipeId: Long,
    val stepNumber: Int,
    val description: String,
    val imageUrl: String? = null,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)