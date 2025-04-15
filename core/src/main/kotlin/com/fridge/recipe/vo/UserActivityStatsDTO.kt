package com.fridge.recipe.vo


/**
 * 사용자 활동 통계 정보를 위한 DTO
 */
data class UserActivityStatsDTO(
        val viewCount: Int,
        val favoriteCount: Int,
        val ratingCount: Int,
        val searchCount: Int,
        val cookCount: Int,
        val topCategories: List<CategoryCountDTO> = emptyList(),
        val recentSearches: List<String> = emptyList(),
        val topRatedRecipes: List<RecipeDTO> = emptyList()
)