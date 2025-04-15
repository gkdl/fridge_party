package com.fridge.recipe.vo

data class RecipeImageCreateDTO(
    val imageUrl: String,
    val isPrimary: Boolean = false,
    val description: String? = null
)