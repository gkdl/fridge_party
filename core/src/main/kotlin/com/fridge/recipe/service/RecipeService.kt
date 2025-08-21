package com.fridge.recipe.service

import com.fridge.recipe.port.RecipePort
import com.fridge.recipe.vo.*
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import javax.transaction.Transactional

@Service
@Transactional
class RecipeService(
    private val recipePort: RecipePort
) {
    fun getPopularRecipes(count: Int): List<RecipeDTO> {
        return recipePort.getPopularRecipes(count)
    }

    fun getRecentRecipes(count: Int): List<RecipeDTO> {
        return recipePort.getRecentRecipes(count)
    }

    fun getTopRatedRecipes(page: Int, size: Int, userId: Long?): Page<RecipeDTO> {
        return recipePort.getTopRatedRecipes(page, size, userId)
    }

    fun getRecipeById(recipeId: Long, userId: Long?): RecipeDTO {
        return recipePort.getRecipeById(recipeId, userId)
    }

    fun updateRecipe(userId: Long, recipeId: Long, recipeUpdateDTO: RecipeCreateDTO): RecipeDTO {
        return recipePort.updateRecipe(userId, recipeId, recipeUpdateDTO)
    }

    fun rateRecipe(userId: Long, ratingCreateDTO: RatingCreateDTO): RatingDTO {
        return recipePort.rateRecipe(userId, ratingCreateDTO)
    }

    fun getRecipeRatings(recipeId: Long, page: Int, size: Int): Page<RatingDTO> {
        return recipePort.getRecipeRatings(recipeId, page, size)
    }

    fun searchRecipes(searchDTO: RecipeSearchDTO, userId: Long?): Page<RecipeDTO> {
        return recipePort.searchRecipes(searchDTO, userId)
    }

    fun getUserRecipesByIdExcept(userId: Long, excludeRecipeId: Long?, limit: Int): Page<RecipeDTO> {
        return recipePort.getUserRecipesByIdExcept(userId, excludeRecipeId, limit)
    }

    fun toggleFavorite(userId: Long, recipeId: Long): Boolean {
        return recipePort.toggleFavorite(userId, recipeId)
    }

    fun getUserFavorites(userId: Long, page: Int, size: Int): Page<RecipeDTO> {
        return recipePort.getUserFavorites(userId, page, size)
    }

    fun createRecipe(userId: Long, recipeCreateDTO: RecipeCreateDTO): RecipeDTO {
        return recipePort.createRecipe(userId, recipeCreateDTO)
    }

    fun getUserRecipes(userId: Long, page: Int, size: Int): Page<RecipeDTO> {
        return recipePort.getUserRecipes(userId, page, size)
    }

    fun deleteRecipe(userId: Long, recipeId: Long) {
        return recipePort.deleteRecipe(userId, recipeId)
    }
}