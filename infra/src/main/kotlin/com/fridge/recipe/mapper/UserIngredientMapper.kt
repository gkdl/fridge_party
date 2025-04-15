package com.fridge.recipe.mapper

import com.fridge.recipe.entity.UserIngredient
import com.fridge.recipe.enum.IngredientAvailability
import com.fridge.recipe.enum.Season
import com.fridge.recipe.vo.UserIngredientDTO
import java.time.format.DateTimeFormatter

/**
 * 사용자 재료를 DTO로 변환 (현재 계절 기반)
 */
fun UserIngredient.toDTO(currentSeason: Season): UserIngredientDTO {
    val availability = this.ingredient.getAvailabilityForSeason(currentSeason)
    val inSeason = availability == IngredientAvailability.HIGH

    return UserIngredientDTO(
        id = this.id,
        ingredientId = this.ingredient.id,
        ingredientName = this.ingredient.name,
        quantity = this.quantity,
        unit = this.unit,
        expiryDate = this.expiryDate?.format(DateTimeFormatter.ISO_DATE_TIME),
        category = this.ingredient.category,
        imageUrl = this.ingredient.imageUrl,
        currentSeasonAvailability = availability.name,
        inSeason = inSeason
    )
}