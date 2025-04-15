package com.fridge.recipe.vo

data class RecipeDTO(
    val id: Long? = null,
    val title: String,
    val description: String? = null,
    val instructions: String? = null, // 레거시 지원을 위해 유지
    val cookingTime: Int? = 0,
    val servingSize: Int? = 0,
    val imageUrl: String? = null, // 기존 호환성 유지
    val images: List<RecipeImageDTO> = emptyList(), // 다중 이미지 지원
    val steps: List<RecipeStepDTO> = emptyList(), // 단계별 조리법 지원
    val userId: Long,
    val username: String? = null,
    val ingredients: List<RecipeIngredientDTO> = emptyList(),
    val avgRating: Double = 0.0,
    val ratingCount: Int = 0,
    val isFavorite: Boolean = false,
    val favoriteCount: Int? = 0
) {
    fun getIsFavorite(): Boolean = isFavorite
}