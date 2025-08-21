package com.fridge.recipe.port

import com.fridge.recipe.enum.Season
import com.fridge.recipe.vo.AddIngredientDTO
import com.fridge.recipe.vo.IngredientDTO
import com.fridge.recipe.vo.SeasonalIngredientsDTO
import com.fridge.recipe.vo.UserIngredientDTO

interface IngredientPort {
    fun getUserIngredients(userId: Long): List<UserIngredientDTO>

    fun searchIngredients(query: String): List<IngredientDTO>

    fun addUserIngredient(userId: Long, addIngredientDTO: AddIngredientDTO): UserIngredientDTO

    fun getSeasonalIngredients(season: Season? = null): SeasonalIngredientsDTO

    fun getUserSeasonalIngredients(userId: Long, season: Season? = null): SeasonalIngredientsDTO
}