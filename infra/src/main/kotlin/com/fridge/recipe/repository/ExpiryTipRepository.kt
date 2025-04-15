package com.fridge.recipe.repository

import com.fridge.recipe.entity.ExpiryTip
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

/**
 * 유통기한 임박 식재료 활용 팁 레포지토리
 */
@Repository
interface ExpiryTipRepository : JpaRepository<ExpiryTip, Long> {
    
    /**
     * 재료명으로 팁 검색
     * @param ingredientName 재료명
     * @param pageable 페이징 정보
     * @return 재료명 검색 결과 팁 목록
     */
    fun findByIngredientNameContainingIgnoreCase(ingredientName: String, pageable: Pageable): Page<ExpiryTip>
    
    /**
     * 특정 재료명과 ID 조건을 만족하는 팁 조회
     * @param ingredientName 재료명
     * @param id 제외할 ID
     * @param pageable 페이징 정보
     * @return 조건을 만족하는 팁 목록
     */
    fun findByIngredientNameAndIdNot(ingredientName: String, id: Long, pageable: Pageable): Page<ExpiryTip>
    
    /**
     * 특정 ID를 제외한 팁 조회
     * @param id 제외할 ID
     * @param pageable 페이징 정보
     * @return 해당 ID를 제외한 팁 목록
     */
    fun findByIdNot(id: Long, pageable: Pageable): Page<ExpiryTip>
    
    /**
     * 재료명 또는 팁 내용에 검색어를 포함하는 팁 조회
     * @param keyword 검색어
     * @param pageable 페이징 정보
     * @return 검색 결과 팁 목록
     */
    fun findByIngredientNameContainingIgnoreCaseOrTipContentContainingIgnoreCase(
        keyword: String, 
        keyword2: String, 
        pageable: Pageable
    ): Page<ExpiryTip>
}