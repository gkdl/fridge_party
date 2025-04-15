package com.fridge.recipe.repository

import com.fridge.recipe.entity.CookingTip
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

/**
 * 요리 팁 레포지토리
 */
@Repository
interface CookingTipRepository : JpaRepository<CookingTip, Long> {
    
    /**
     * 카테고리별 팁 조회
     * @param category 카테고리
     * @param pageable 페이징 정보
     * @return 카테고리별 팁 목록
     */
    fun findByCategory(category: String, pageable: Pageable): Page<CookingTip>
    
    /**
     * 특정 ID를 제외한 팁 조회
     * @param id 제외할 ID
     * @param pageable 페이징 정보
     * @return 해당 ID를 제외한 팁 목록
     */
    fun findByIdNot(id: Long, pageable: Pageable): Page<CookingTip>
    
    /**
     * 특정 카테고리와 ID 조건을 만족하는 팁 조회
     * @param category 카테고리
     * @param id 제외할 ID
     * @param pageable 페이징 정보
     * @return 조건을 만족하는 팁 목록
     */
    fun findByCategoryAndIdNot(category: String, id: Long, pageable: Pageable): Page<CookingTip>
    
    /**
     * 제목 또는 내용에 검색어를 포함하는 팁 조회
     * @param keyword 검색어
     * @param pageable 페이징 정보
     * @return 검색 결과 팁 목록
     */
    fun findByTitleContainingIgnoreCaseOrContentContainingIgnoreCase(
        keyword: String, 
        keyword2: String, 
        pageable: Pageable
    ): Page<CookingTip>
}