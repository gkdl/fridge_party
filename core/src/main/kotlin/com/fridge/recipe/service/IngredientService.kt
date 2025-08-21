package com.fridge.recipe.service

import com.fridge.recipe.enum.Season
import com.fridge.recipe.port.IngredientPort
import com.fridge.recipe.port.RecipePort
import com.fridge.recipe.util.DateUtil
import com.fridge.recipe.vo.*
import org.springframework.stereotype.Service
import javax.transaction.Transactional

@Service
@Transactional
class IngredientService(
    private val ingredientPort: IngredientPort
) {
    fun getUserIngredients(userId: Long): List<UserIngredientDTO> {
        return ingredientPort.getUserIngredients(userId)
    }

    fun searchIngredients(query: String): List<IngredientDTO> {
        return ingredientPort.searchIngredients(query)
    }

    fun addUserIngredient(userId: Long, addIngredientDTO: AddIngredientDTO): UserIngredientDTO {
        return ingredientPort.addUserIngredient(userId, addIngredientDTO)
    }

    fun getSeasonalIngredients(season: Season? = null): SeasonalIngredientsDTO {
        return ingredientPort.getSeasonalIngredients(season)
    }

    fun getUserSeasonalIngredients(userId: Long, season: Season? = null): SeasonalIngredientsDTO {
        return ingredientPort.getUserSeasonalIngredients(userId, season)
    }
}