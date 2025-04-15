package com.fridge.recipe.repository

import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.User
import com.fridge.recipe.enum.Season
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface RecipeRepository : JpaRepository<Recipe, Long> {
    fun findByUser(user: User, pageable: Pageable): Page<Recipe>
    fun findByTitleContaining(title: String, pageable: Pageable): Page<Recipe>
    
    // 계절별 레시피 검색 기능 추가
    fun findBySeason(season: Season, pageable: Pageable): List<Recipe>
    
    // 현재 계절과 ALL 계절의 레시피를 함께 조회
    @Query("""
        SELECT r FROM Recipe r 
        WHERE r.season = :season OR r.season = 'ALL'
        ORDER BY 
          CASE WHEN r.season = :season THEN 0 ELSE 1 END,
          r.avgRating DESC
    """)
    fun findBySeasonOrAll(@Param("season") season: Season, pageable: Pageable): List<Recipe>
    
    // 특정 태그가 포함된 레시피 검색
    @Query("""
        SELECT r FROM Recipe r 
        WHERE r.tags LIKE %:tag%
    """)
    fun findByTagContaining(@Param("tag") tag: String, pageable: Pageable): List<Recipe>
    
    // 계절과 태그를 함께 고려한 레시피 검색
    @Query("""
        SELECT r FROM Recipe r 
        WHERE (r.season = :season OR r.season = 'ALL')
        AND (r.tags LIKE %:tag%)
        ORDER BY r.avgRating DESC
    """)
    fun findBySeasonAndTagContaining(
            @Param("season") season: Season,
            @Param("tag") tag: String,
            pageable: Pageable
    ): List<Recipe>
    
    @Query("""
        SELECT DISTINCT r FROM Recipe r
        JOIN r.ingredients ri
        WHERE ri.ingredient.id IN (:ingredientIds)
        GROUP BY r.id
        HAVING COUNT(DISTINCT ri.ingredient.id) >= :minCount
    """)
    fun findByIngredientIds(
        @Param("ingredientIds") ingredientIds: List<Long>,
        @Param("minCount") minCount: Long,
        pageable: Pageable
    ): Page<Recipe>
    
    @Query("""
        SELECT r FROM Recipe r
        LEFT JOIN r.ratings rat
        GROUP BY r.id
        ORDER BY AVG(COALESCE(rat.rating, 0)) DESC
    """)
    fun findTopRated(pageable: Pageable): Page<Recipe>

    // 외부 API ID로 레시피 조회
    fun findByExternalId(externalId: String): Optional<Recipe>
}
