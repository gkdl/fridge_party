package com.fridge.recipe.vo

/**
 * 요리 팁 DTO
 */
data class CookingTipDTO(
    /**
     * 팁 ID
     */
    val id: Long = 0,
    
    /**
     * 팁 제목
     */
    val title: String,
    
    /**
     * 팁 내용
     */
    val content: String,
    
    /**
     * 팁 카테고리 (조리법, 도구, 재료준비, 보관법 등)
     */
    val category: String? = null,
    
    /**
     * 이미지 URL
     */
    val imageUrl: String? = null,
    
    /**
     * 생성 일시 (문자열)
     */
    val createdAt: String? = null
)