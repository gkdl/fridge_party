package com.fridge.recipe.vo

import com.fridge.recipe.enum.Season

data class RecipeDTO(
    val id: Long? = null,
    val title: String,
    val description: String? = null,
    val instructions: String? = null, // 레거시 지원을 위해 유지
    val cookingTime: Int? = null,
    val servingSize: Int? = null,
    val images: List<RecipeImageDTO> = emptyList(), // 다중 이미지 지원
    val steps: List<RecipeStepDTO> = emptyList(), // 단계별 조리법 지원
    val userId: Long,
    val username: String? = null,
    val ingredients: List<RecipeIngredientDTO> = emptyList(),
    val avgRating: Double = 0.0,
    val ratingCount: Int = 0,
    val isFavorite: Boolean = false,
    val category: String? = null,
    val calories: Double? = null,
    val carbohydrate: Double? = null,
    val protein: Double? = null,
    val fat: Double? = null,
    val sodium: Double? = null,
    val season: Season = Season.ALL, // 계절 정보 추가
    val viewCount: Int = 0, // 조회수 정보 추가
    val favoriteCount: Int? = 0

) {
    fun getIsFavorite(): Boolean = isFavorite
}