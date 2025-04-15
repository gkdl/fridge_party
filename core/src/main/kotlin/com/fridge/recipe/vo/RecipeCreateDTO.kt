package com.fridge.recipe.vo

data class RecipeCreateDTO(
    val title: String,
    val description: String? = null,
    val instructions: String? = null, // 레거시 지원을 위해 유지
    val cookingTime: Int? = null,
    val servingSize: Int? = null,
    val imageUrl: String? = null, // 기존 호환성 유지
    val images: List<RecipeImageCreateDTO> = emptyList(), // 다중 이미지 지원
    val steps: List<RecipeStepCreateDTO> = emptyList(), // 단계별 조리법 지원
    val ingredients: List<RecipeIngredientCreateDTO> = emptyList()
)
