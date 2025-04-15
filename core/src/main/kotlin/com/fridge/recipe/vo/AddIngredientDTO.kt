package com.fridge.recipe.vo

data class AddIngredientDTO(
    val ingredientId: Long? = null,
    val name: String? = null,
    val quantity: String? = null,
    val unit: String? = null,
    val expiryDate: String? = null,
    val category: String? = null
)