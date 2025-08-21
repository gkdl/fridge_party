package com.fridge.recipe.vo

import com.fridge.recipe.enum.Season

data class RecipeCreateDTO(
    val title: String,
    val description: String? = null,
    val instructions: String? = null, // 레거시 지원을 위해 유지
    val cookingTime: Int? = null,
    val servingSize: Int? = null,
    val images: List<RecipeImageCreateDTO> = emptyList(), // 다중 이미지 지원
    val steps: List<RecipeStepCreateDTO> = emptyList(), // 단계별 조리법 지원
    val ingredients: List<RecipeIngredientCreateDTO> = emptyList(),
    val season: Season = Season.ALL, // 계절 정보 추가
    val category: String? = null, // 카테고리 정보 추가
    val tags: String? = null // 태그 정보 추가
)
