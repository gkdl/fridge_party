package com.fridge.recipe.port

import com.fridge.recipe.enum.Season
import com.fridge.recipe.vo.RecipeDTO

interface RecommendationPort {
    fun getRecommendedRecipes(userId: Long, count: Int = 10): List<RecipeDTO>

    fun getSimilarRecipes(recipeId: Long, count: Int = 4, userId: Long? = null): List<RecipeDTO>

    fun getSeasonalRecipes(season: Season? = null, count: Int = 8, userId: Long? = null): List<RecipeDTO>

    fun getCurrentSeason(): Season
}