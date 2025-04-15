package com.fridge.recipe.entity

import com.fridge.recipe.enum.ActivityType
import javax.persistence.*
import java.time.LocalDateTime

/**
 * 사용자 활동 기록 모델
 * 사용자의 다양한 활동(레시피 조회, 즐겨찾기, 평점 등록, 검색)을 저장하여
 * 개인화된 추천 시스템에 활용
 */
@Entity
@Table(name = "user_activities")
data class UserActivity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    val user: User,

    @Enumerated(EnumType.STRING)
    @Column(name = "activity_type", nullable = false)
    val activityType: ActivityType,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipe_id")
    val recipe: Recipe? = null,

    @Column(name = "search_query")
    val searchQuery: String? = null,
    
    // 활동에 대한 가중치 (예: 평점 값, 즐겨찾기는 높은 가중치 등)
    @Column(name = "weight")
    val weight: Double = 1.0,

    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now()
)