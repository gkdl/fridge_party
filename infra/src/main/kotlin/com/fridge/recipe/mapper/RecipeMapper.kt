package com.fridge.recipe.mapper

import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.RecipeIngredient
import com.fridge.recipe.vo.RecipeDTO
import com.fridge.recipe.vo.RecipeImageDTO
import com.fridge.recipe.vo.RecipeStepDTO

fun Recipe.toDTO(ingredients: List<RecipeIngredient>, isFavorite: Boolean, images: List<RecipeImageDTO>, steps: List<RecipeStepDTO>): RecipeDTO {
    val ratingCount = this.ratings.size

    return RecipeDTO(
        id = this.id,
        title = this.title,
        description = this.description,
        instructions = this.instructions,
        cookingTime = this.cookingTime,
        servingSize = this.servingSize,
        imageUrl = this.imageUrl, // 하위 호환성
        images = images, // 새로운 다중 이미지 필드
        steps = steps, // 단계별 조리법
        userId = this.user.id,
        username = this.user.username,
        ingredients = ingredients.map { it.toDTO() },
        avgRating = this.avgRating,
        ratingCount = ratingCount,
        isFavorite = isFavorite
    )
}