package com.fridge.recipe.vo

data class RecipeImageDTO(
    val id: Long? = null,
    val recipeId: Long? = null,
    val imageUrl: String,
    val isPrimary: Boolean = false,
    val description: String? = null
){
    fun getIsPrimary(): Boolean = isPrimary
}