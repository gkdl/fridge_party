package com.fridge.recipe.mapper

import com.fridge.recipe.entity.RecipeIngredient
import com.fridge.recipe.vo.RecipeIngredientDTO

fun RecipeIngredient.toDTO(): RecipeIngredientDTO {
    return RecipeIngredientDTO(
            id = this.id,
            ingredientId = this.ingredient.id,
            name = this.ingredient.name,
            quantity = this.quantity.toString(),
            unit = this.unit,
            optional = this.optional
    )
}