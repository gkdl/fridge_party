package com.fridge.recipe.repository

import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.RecipeIngredient
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface RecipeIngredientRepository : JpaRepository<RecipeIngredient, Long> {
    fun findByRecipe(recipe: Recipe): List<RecipeIngredient>
}
