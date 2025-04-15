package com.fridge.recipe.vo

/**
 * 카테고리별 카운트를 위한 DTO
 */
data class CategoryCountDTO(
    val category: String,
    val count: Int
)