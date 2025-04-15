package com.fridge.recipe.entity

import java.time.LocalDateTime
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.Table

/**
 * 유통기한 임박 식재료 활용 팁 모델
 */
@Entity
@Table(name = "expiry_tips")
data class ExpiryTip(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    /**
     * 재료명
     */
    @Column(nullable = false)
    var ingredientName: String,
    
    /**
     * 재료 활용 팁 내용
     */
    @Column(columnDefinition = "TEXT", nullable = false)
    var tipContent: String,
    
    /**
     * 추천 레시피 및 활용법
     */
    @Column(columnDefinition = "TEXT", nullable = true)
    var recipeSuggestion: String? = null,
    
    /**
     * 이미지 URL
     */
    @Column(nullable = true)
    var imageUrl: String? = null,
    
    /**
     * 생성 일시
     */
    @Column(nullable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),
    
    /**
     * 수정 일시
     */
    @Column(nullable = false)
    var updatedAt: LocalDateTime = LocalDateTime.now()
)