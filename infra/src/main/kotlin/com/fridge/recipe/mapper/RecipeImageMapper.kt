package com.fridge.recipe.mapper

import com.fridge.recipe.entity.RecipeImage
import com.fridge.recipe.vo.RecipeImageDTO

fun RecipeImage.toDTO(): RecipeImageDTO {
    return RecipeImageDTO(
        id = this.id,
        recipeId = this.recipe.id,
        imageUrl = this.imageUrl,
        isPrimary = this.isPrimary,
        description = this.description
    )
}