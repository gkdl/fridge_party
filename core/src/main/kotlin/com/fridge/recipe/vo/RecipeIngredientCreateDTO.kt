package com.fridge.recipe.vo

data class RecipeIngredientCreateDTO(
    val ingredientId: Long? = null,
    val name: String,
    val quantity: String,
    val unit: String? = null,
    val optional: Boolean = false
)
