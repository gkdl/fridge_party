package com.fridge.recipe.repository

import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.User
import com.fridge.recipe.entity.UserActivity
import com.fridge.recipe.enum.ActivityType
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import java.time.LocalDateTime

@Repository
interface UserActivityRepository : JpaRepository<UserActivity, Long> {
    
    fun findByUser(user: User, pageable: Pageable): Page<UserActivity>
    
    fun findByUserAndActivityType(user: User, activityType: ActivityType, pageable: Pageable): Page<UserActivity>
    
    fun findByUserAndRecipe(user: User, recipe: Recipe): List<UserActivity>
    
    fun findByUserAndActivityTypeAndRecipe(user: User, activityType: ActivityType, recipe: Recipe): List<UserActivity>
    
    // 특정 기간 내 활동 조회
    fun findByUserAndCreatedAtBetween(user: User, start: LocalDateTime, end: LocalDateTime, pageable: Pageable): Page<UserActivity>
    
    // 사용자의 최근 검색어 조회
    @Query("""
        SELECT ua FROM UserActivity ua 
        WHERE ua.user = :user AND ua.activityType = 'SEARCH' AND ua.searchQuery IS NOT NULL
        ORDER BY ua.createdAt DESC
    """)
    fun findRecentSearches(@Param("user") user: User, pageable: Pageable): List<UserActivity>
    
    // 사용자별 활동 유형 카운트
    @Query("""
        SELECT COUNT(ua) FROM UserActivity ua 
        WHERE ua.user = :user AND ua.activityType = :activityType
    """)
    fun countByUserAndActivityType(@Param("user") user: User, @Param("activityType") activityType: ActivityType): Long
    
    // 사용자가 가장 많이 활동한 레시피 조회 (가중치 기반)
    @Query("""
        SELECT ua.recipe.id, SUM(ua.weight) as totalWeight 
        FROM UserActivity ua 
        WHERE ua.user = :user AND ua.recipe IS NOT NULL
        GROUP BY ua.recipe.id 
        ORDER BY totalWeight DESC
    """)
    fun findMostActiveRecipes(@Param("user") user: User, pageable: Pageable): List<Array<Any>>
    
    // 특정 기간 내 가장 인기 있는 레시피 (모든 사용자)
    @Query("""
        SELECT ua.recipe.id, COUNT(ua) as activityCount 
        FROM UserActivity ua 
        WHERE ua.createdAt BETWEEN :start AND :end AND ua.recipe IS NOT NULL
        GROUP BY ua.recipe.id 
        ORDER BY activityCount DESC
    """)
    fun findTrendingRecipes(
        @Param("start") start: LocalDateTime, 
        @Param("end") end: LocalDateTime, 
        pageable: Pageable
    ): List<Array<Any>>
}