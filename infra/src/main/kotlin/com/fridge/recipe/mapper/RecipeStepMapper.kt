package com.fridge.recipe.mapper

import com.fridge.recipe.entity.RecipeStep
import com.fridge.recipe.vo.RecipeStepDTO

fun RecipeStep.toDTO(): RecipeStepDTO {
    return RecipeStepDTO(
        id = this.id,
        recipeId = this.recipe.id,
        stepNumber = this.stepNumber,
        imageUrl = this.imageUrl,
        description = this.description,
        createdAt = this.createdAt,
        updatedAt = this.updatedAt
    )
}
