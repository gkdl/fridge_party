package com.fridge.recipe.vo

data class FavoriteDTO(
    val id: Long? = null,
    val userId: Long,
    val recipeId: Long,
    val recipeTitle: String? = null,
    val recipeImageUrl: String? = null,
    val recipeAvgRating: Double? = null
)