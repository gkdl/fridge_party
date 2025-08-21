package com.fridge.recipe.vo

// 계절별 식재료 가용성 정보를 담는 DTO
data class SeasonalIngredientsDTO(
    val season: String,
    val inSeasonIngredients: List<IngredientDTO>,
    val offSeasonIngredients: List<IngredientDTO>
)
