package com.fridge.recipe.vo

/**
 * 유통기한 임박 식재료 활용 팁 DTO
 */
data class ExpiryTipDTO(
    /**
     * 팁 ID
     */
    val id: Long = 0,
    
    /**
     * 재료명
     */
    val ingredientName: String,
    
    /**
     * 재료 활용 팁 내용
     */
    val tipContent: String,
    
    /**
     * 추천 레시피 및 활용법
     */
    val recipeSuggestion: String? = null,
    
    /**
     * 이미지 URL
     */
    val imageUrl: String? = null,
    
    /**
     * 생성 일시 (문자열)
     */
    val createdAt: String? = null
)