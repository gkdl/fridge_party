package com.fridge.recipe.service

import com.fridge.recipe.port.IngredientPort
import com.fridge.recipe.port.RecipePort
import com.fridge.recipe.util.DateUtil
import com.fridge.recipe.vo.AddIngredientDTO
import com.fridge.recipe.vo.IngredientDTO
import com.fridge.recipe.vo.RecipeDTO
import com.fridge.recipe.vo.UserIngredientDTO
import org.springframework.stereotype.Service
import javax.transaction.Transactional

@Service
class IngredientService(
    private val ingredientPort: IngredientPort
) {
    @Transactional
    fun getUserIngredients(userId: Long): List<UserIngredientDTO> {
        return ingredientPort.getUserIngredients(userId)
    }

    @Transactional
    fun searchIngredients(query: String): List<IngredientDTO> {
        return ingredientPort.searchIngredients(query)
    }

    @Transactional
    fun addUserIngredient(userId: Long, addIngredientDTO: AddIngredientDTO): UserIngredientDTO {
        return ingredientPort.addUserIngredient(userId, addIngredientDTO)
    }
}
