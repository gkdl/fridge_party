package com.fridge.recipe.port

import com.fridge.recipe.vo.RecipeDTO

interface RecommendationPort {
    fun getRecommendedRecipes(userId: Long, count: Int = 10): List<RecipeDTO>

    fun getSimilarRecipes(recipeId: Long, count: Int = 4, userId: Long? = null): List<RecipeDTO>
}