package com.fridge.recipe.vo

/**
 * 추천 관련 항목의 가중치 정보를 위한 DTO
 */
data class ItemWeightDTO(
    val itemId: Long,
    val itemTitle: String? = null,
    val weight: Double
)