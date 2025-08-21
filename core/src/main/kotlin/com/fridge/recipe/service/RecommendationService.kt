package com.fridge.recipe.service

import com.fridge.recipe.enum.Season
import com.fridge.recipe.port.RecommendationPort
import com.fridge.recipe.vo.RecipeDTO
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class RecommendationService(
    private val recommendationPort: RecommendationPort
) {
    fun getRecommendedRecipes(userId: Long, count: Int = 10): List<RecipeDTO> {
        return recommendationPort.getRecommendedRecipes(userId, count);
    }

    fun getSimilarRecipes(recipeId: Long, count: Int = 4, userId: Long? = null): List<RecipeDTO> {
        return recommendationPort.getSimilarRecipes(recipeId, count, userId)
    }

    fun getSeasonalRecipes(season: Season? = null, count: Int = 8, userId: Long? = null): List<RecipeDTO> {
        return recommendationPort.getSeasonalRecipes(season, count, userId)
    }
    fun getCurrentSeason(): Season {
        return recommendationPort.getCurrentSeason()
    }
}
