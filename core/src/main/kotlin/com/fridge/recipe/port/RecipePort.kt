package com.fridge.recipe.port

import com.fridge.recipe.vo.*
import org.springframework.data.domain.Page

interface RecipePort {
    fun getPopularRecipes(count: Int): List<RecipeDTO>

    fun getRecentRecipes(count: Int): List<RecipeDTO>

    fun getTopRatedRecipes(page: Int, size: Int, userId: Long?): Page<RecipeDTO>

    fun getRecipeById(recipeId: Long, userId: Long?): RecipeDTO

    fun updateRecipe(userId: Long, recipeId: Long, recipeUpdateDTO: RecipeCreateDTO): RecipeDTO

    fun rateRecipe(userId: Long, ratingCreateDTO: RatingCreateDTO): RatingDTO

    fun getRecipeRatings(recipeId: Long, page: Int, size: Int): Page<RatingDTO>

    fun searchRecipes(searchDTO: RecipeSearchDTO, userId: Long?): Page<RecipeDTO>

}