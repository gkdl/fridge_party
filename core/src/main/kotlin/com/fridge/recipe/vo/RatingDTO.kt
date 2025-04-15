package com.fridge.recipe.vo

data class RatingDTO(
    val id: Long? = null,
    val userId: Long,
    val username: String? = null,
    val recipeId: Long,
    val rating: Double,
    val comment: String? = null,
    val createdAt: String? = null
)
