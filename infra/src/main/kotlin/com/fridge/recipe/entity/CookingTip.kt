package com.fridge.recipe.entity

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.Table
import java.time.LocalDateTime

/**
 * 요리 팁 모델
 */
@Entity
@Table(name = "cooking_tips")
data class CookingTip(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    /**
     * 팁 제목
     */
    @Column(nullable = false)
    var title: String,
    
    /**
     * 팁 내용
     */
    @Column(columnDefinition = "TEXT", nullable = false)
    var content: String,
    
    /**
     * 팁 카테고리 (조리법, 도구, 재료준비, 보관법 등)
     */
    @Column(nullable = true)
    var category: String? = null,
    
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