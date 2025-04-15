package com.fridge.recipe.service

import com.fridge.recipe.port.IngredientPort
import com.fridge.recipe.port.RecipePort
import com.fridge.recipe.port.RecommendationPort
import com.fridge.recipe.vo.RecipeDTO
import com.fridge.recipe.vo.UserIngredientDTO
import org.springframework.stereotype.Service

@Service
class RecommendationService(
    private val recommendationPort: RecommendationPort
) {
    fun getRecommendedRecipes(userId: Long, count: Int = 10): List<RecipeDTO> {
        return recommendationPort.getRecommendedRecipes(userId, count);
    }

    fun getSimilarRecipes(recipeId: Long, count: Int = 4, userId: Long? = null): List<RecipeDTO> {
        return recommendationPort.getSimilarRecipes(recipeId, count, userId)
    }
}
