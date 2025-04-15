package com.fridge.recipe.vo

// 레시피 단계 생성 DTO
data class RecipeStepCreateDTO(
    val stepNumber: Int,
    val description: String,
    val imageUrl: String? = null
)