package com.fridge.recipe.vo

data class RatingCreateDTO(
    val recipeId: Long,
    val rating: Double,
    val comment: String? = null
)
