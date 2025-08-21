package com.fridge.recipe.mapper

import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.RecipeIngredient
import com.fridge.recipe.vo.RecipeDTO
import com.fridge.recipe.vo.RecipeImageDTO
import com.fridge.recipe.vo.RecipeStepDTO

fun Recipe.toDTO(ingredients: List<RecipeIngredient>, isFavorite: Boolean, images: List<RecipeImageDTO>, steps: List<RecipeStepDTO>, favoriteCount:Int): RecipeDTO {
    val ratingCount = this.ratings.size

    return RecipeDTO(
        id = this.id,
        title = this.title,
        description = this.description,
        instructions = this.instructions,
        cookingTime = this.cookingTime,
        servingSize = this.servingSize,
        images = images, // 새로운 다중 이미지 필드
        steps = steps, // 단계별 조리법
        userId = this.user.id,
        username = this.user.username,
        ingredients = ingredients.map { it.toDTO() },
        avgRating = this.avgRating,
        ratingCount = ratingCount,
        isFavorite = isFavorite,
        category = this.category,
        calories = this.calories,
        carbohydrate = this.carbohydrate,
        protein = this.protein,
        fat = this.fat,
        sodium = this.sodium,
        season = this.season, // 계절 정보 추가
        viewCount = 0, // 조회수는 나중에 별도로 로직 필요
        favoriteCount = favoriteCount

    )
}