package com.fridge.recipe.repository

import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.RecipeImage
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface RecipeImageRepository : JpaRepository<RecipeImage, Long> {
    fun findByRecipe(recipe: Recipe): List<RecipeImage>

    fun findByRecipeIdOrderByIsPrimaryDesc(recipeId: Long): List<RecipeImage>

    fun findFirstByRecipeIdAndIsPrimaryTrue(recipeId: Long): RecipeImage?

    fun findByRecipeAndIsPrimaryFalse(recipe: Recipe): List<RecipeImage>

    fun deleteByRecipe(recipe: Recipe)
}