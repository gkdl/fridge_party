package com.fridge.recipe.mapper

import com.fridge.recipe.entity.Ingredient
import com.fridge.recipe.enum.IngredientAvailability
import com.fridge.recipe.enum.Season
import com.fridge.recipe.vo.IngredientDTO

/**
 * 재료를 DTO로 변환 (현재 계절 기반)
 */
fun Ingredient.toDTO(currentSeason: Season): IngredientDTO {
    val availability = this.getAvailabilityForSeason(currentSeason)
    val inSeason = availability == IngredientAvailability.HIGH

    return IngredientDTO(
        id = this.id,
        name = this.name,
        category = this.category,
        unit = this.unit,
        description = this.description,
        springAvailability = this.springAvailability.name,
        summerAvailability = this.summerAvailability.name,
        fallAvailability = this.fallAvailability.name,
        winterAvailability = this.winterAvailability.name,
        currentSeasonAvailability = availability.name,
        inSeason = inSeason
    )
}