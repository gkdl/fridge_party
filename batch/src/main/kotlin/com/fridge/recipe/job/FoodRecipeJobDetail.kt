package com.fridge.recipe.job

import com.fridge.recipe.service.FoodRecipeService
import org.quartz.Job
import org.quartz.JobExecutionContext
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component

/**
 * 식품의약품안전처 레시피 데이터 수집 작업
 * Quartz 스케줄러에 의해 실행됨
 */
// @Component는 제거하고 Job 구현체로만 사용
class FoodRecipeJobDetail : Job {
    private val logger = LoggerFactory.getLogger(FoodRecipeJobDetail::class.java)

    @Autowired
    private lateinit var foodRecipeService: FoodRecipeService

    override fun execute(context: JobExecutionContext) {
        logger.info("식품의약품안전처 레시피 데이터 수집 작업 시작")

        try {
            // 배치 작업 - 페이지 단위로 데이터 수집
            val totalCount = foodRecipeService.fetchAndSaveAllRecipes()
            logger.info("식품의약품안전처 레시피 데이터 수집 작업 완료. 총 ${totalCount}개 레시피 처리")
        } catch (e: Exception) {
            logger.error("식품의약품안전처 레시피 데이터 수집 중 오류 발생: ${e.message}", e)
        }
    }
}