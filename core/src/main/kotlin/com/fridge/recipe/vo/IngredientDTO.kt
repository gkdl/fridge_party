package com.fridge.recipe.vo

import com.fridge.recipe.enum.IngredientAvailability


data class IngredientDTO(
    val id: Long? = null,
    val name: String,
    val category: String? = null,
    val unit: String? = null,
    val description: String? = null,
    val imageUrl: String? = null,

    // 계절별 가용성 정보
    val springAvailability: String = IngredientAvailability.MEDIUM.name,
    val summerAvailability: String = IngredientAvailability.MEDIUM.name,
    val fallAvailability: String = IngredientAvailability.MEDIUM.name,
    val winterAvailability: String = IngredientAvailability.MEDIUM.name,

    // 현재 계절에 대한 가용성
    val currentSeasonAvailability: String? = null,

    // 제철 여부
    val inSeason: Boolean = false
)