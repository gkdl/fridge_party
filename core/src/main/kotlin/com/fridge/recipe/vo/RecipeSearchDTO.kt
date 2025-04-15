package com.fridge.recipe.vo

data class RecipeSearchDTO(
    val query: String? = null,
    val ingredientIds: List<Long> = emptyList(),
    val category: String? = null,
    val cookingTime: Int? = null,
    val page: Int = 0,
    val size: Int = 10
)
