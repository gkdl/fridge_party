package com.fridge.recipe.vo

data class RecipeIngredientDTO(
    val id: Long? = null,
    val ingredientId: Long,
    val name: String,
    val quantity: String,
    val unit: String? = null,
    val optional: Boolean = false
)