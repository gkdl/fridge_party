package com.fridge.recipe.repository

import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.RecipeStep
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface RecipeStepRepository : JpaRepository<RecipeStep, Long> {
    fun findByRecipeIdOrderByStepNumber(recipeId: Long): List<RecipeStep>
    fun deleteByRecipe(recipe: Recipe)
    fun deleteAllByRecipe(recipe: Recipe)
    fun findByRecipeId(recipeId: Long): List<RecipeStep>

}