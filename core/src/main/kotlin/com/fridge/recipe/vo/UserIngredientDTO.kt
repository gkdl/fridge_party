package com.fridge.recipe.vo

data class UserIngredientDTO(
    val id: Long? = null,
    val ingredientId: Long,
    val ingredientName: String,
    val quantity: String? = null,
    val unit: String? = null,
    val expiryDate: String? = null,
    val category: String? = null,
    val imageUrl: String? = null,

    // 현재 계절에 대한 가용성
    val currentSeasonAvailability: String? = null,

    // 제철 여부
    val inSeason: Boolean = false
)