package com.fridge.recipe.adapter

import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.User
import com.fridge.recipe.enum.Season
import com.fridge.recipe.mapper.toDTO
import com.fridge.recipe.port.RecipePort
import com.fridge.recipe.port.RecommendationPort
import com.fridge.recipe.port.TipPort
import com.fridge.recipe.repository.*
import com.fridge.recipe.service.RecipeService
import com.fridge.recipe.util.DateUtil
import com.fridge.recipe.vo.*
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Component
import java.time.LocalDateTime
import javax.transaction.Transactional
import kotlin.math.exp
import kotlin.math.min

@Component
@Transactional
class RecommendationAdapter (
    private val recipeRepository: RecipeRepository,
    private val userRepository: UserRepository,
    private val userIngredientRepository: UserIngredientRepository,
    private val recipePort: RecipePort,
    private val recipeStepRepository: RecipeStepRepository,
    private val recipeImageRepository: RecipeImageRepository,
    private val userActivityRepository: UserActivityRepository,
    private val recipeIngredientRepository: RecipeIngredientRepository,
) : RecommendationPort {
    /**
     * 개인화된 레시피 추천
     * - 사용자의 냉장고 재료
     * - 사용자의 과거 활동 (조회, 평점, 즐겨찾기)
     * - 계절적 요소
     * - 인기 레시피
     * 를 종합적으로 고려하여 추천
     */
    override fun getRecommendedRecipes(userId: Long, count: Int): List<RecipeDTO> {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        // 1. 재료 기반 추천 (30%)
        val ingredientBasedRecipes = getIngredientBasedRecommendations(user, count)

        // 2. 사용자 활동 기반 추천 (30%)
        val activityBasedRecipes = getActivityBasedRecommendations(user, count)

        // 3. 계절 기반 추천 (20%)
        val seasonalRecipes = getSeasonalRecommendations(count, userId)

        // 4. 인기 레시피 추천 (20%)
        val popularRecipes = getPopularRecipes(count, userId)

        // 중복 제거 및 가중치 계산
        val recipeScores = mutableMapOf<Long, Double>()
        val recipeMap = mutableMapOf<Long, RecipeDTO>()

        // 재료 기반 추천에 가중치 부여
        ingredientBasedRecipes.forEachIndexed { index, recipe ->
            val score = 0.3 * (1.0 - index.toDouble() / ingredientBasedRecipes.size)
            recipeScores[recipe.id!!] = score
            recipeMap[recipe.id!!] = recipe
        }

        // 활동 기반 추천에 가중치 부여
        activityBasedRecipes.forEachIndexed { index, recipe ->
            val score = 0.3 * (1.0 - index.toDouble() / activityBasedRecipes.size)
            recipeScores[recipe.id!!] = (recipeScores[recipe.id] ?: 0.0) + score
            recipeMap[recipe.id!!] = recipe
        }

        // 계절 기반 추천에 가중치 부여
        seasonalRecipes.forEachIndexed { index, recipe ->
            val score = 0.2 * (1.0 - index.toDouble() / seasonalRecipes.size)
            recipeScores[recipe.id!!] = (recipeScores[recipe.id] ?: 0.0) + score
            recipeMap[recipe.id!!] = recipe
        }

        // 인기 레시피에 가중치 부여
        popularRecipes.forEachIndexed { index, recipe ->
            val score = 0.2 * (1.0 - index.toDouble() / popularRecipes.size)
            recipeScores[recipe.id!!] = (recipeScores[recipe.id] ?: 0.0) + score
            recipeMap[recipe.id!!] = recipe
        }

        // 점수 기준으로 정렬하여 상위 N개 반환
        val sortedRecipes = recipeScores.entries.sortedByDescending { it.value }
            .take(count)
            .map { recipeMap[it.key]!! }

        // 결과가 count보다 적으면 인기 레시피로 보충
        if (sortedRecipes.size < count) {
            val existingIds = sortedRecipes.map { it.id }
            val additionalRecipes = recipePort.getTopRatedRecipes(0, count - sortedRecipes.size, userId).content
                .filter { it.id !in existingIds }

            return sortedRecipes + additionalRecipes
        }

        return sortedRecipes
    }

    /**
     * 재료 기반 추천
     */
    private fun getIngredientBasedRecommendations(user: User, count: Int): List<RecipeDTO> {
        val userIngredients = userIngredientRepository.findByUser(user)

        if (userIngredients.isEmpty()) {
            return emptyList()
        }

        // 사용자의 재료 ID 목록
        val ingredientIds = userIngredients.map { it.ingredient.id }

        // 유통기한이 임박한 재료에 더 높은 가중치 부여
        val now = LocalDateTime.now()
        val ingredientWeights = userIngredients.associate { userIngredient ->
            val weight = if (userIngredient.expiryDate != null) {
                val daysUntilExpiry = java.time.Duration.between(now, userIngredient.expiryDate).toDays()
                when {
                    daysUntilExpiry <= 0 -> 3.0 // 이미 만료된 재료
                    daysUntilExpiry <= 3 -> 2.0 // 만료가 임박한 재료
                    else -> 1.0 // 일반 재료
                }
            } else {
                1.0 // 유통기한 정보가 없는 재료
            }
            userIngredient.ingredient.id to weight
        }

        // 재료 가중치를 고려한 레시피 검색
        val pageable: Pageable = PageRequest.of(0, count * 2) // 필터링 가능성 고려해 더 많이 조회

        val matchedRecipes = recipeRepository.findByIngredientIds(
            ingredientIds,
            (ingredientIds.size * 0.6).toLong(), // 최소 60% 이상의 재료가 일치하는 레시피
            pageable
        ).content

        // 재료 매칭 점수 계산
        val recipeScores = matchedRecipes.map { recipe ->
            val recipeDto = recipePort.getRecipeById(recipe.id, user.id)

            // 레시피에 포함된 사용자 재료 가중치 합계 계산
            val ingredientScore = recipeDto.ingredients
                .filter { it.ingredientId in ingredientWeights.keys }
                .sumOf { ingredientWeights[it.ingredientId] ?: 1.0 }

            // 평점 점수 (0-5) 계산
            val ratingScore = recipeDto.avgRating

            // 총점 계산 (재료 점수 70%, 평점 30%)
            val totalScore = 0.7 * ingredientScore + 0.3 * ratingScore

            recipeDto to totalScore
        }

        // 점수 기준 정렬
        return recipeScores.sortedByDescending { it.second }
            .take(count)
            .map { it.first }
    }

    /**
     * 사용자 활동 기반 추천 (협업 필터링)
     */
    private fun getActivityBasedRecommendations(user: User, count: Int): List<RecipeDTO> {
        // 사용자 활동 조회 (최대 50개)
        val pageable: Pageable = PageRequest.of(0, 50, org.springframework.data.domain.Sort.by("createdAt").descending())
        val userActivities = userActivityRepository.findByUser(user, pageable).content

        if (userActivities.isEmpty()) {
            return emptyList()
        }

        // 활동 점수 계산
        val recipeScores = mutableMapOf<Long, Double>()
        val now = LocalDateTime.now()

        userActivities.forEach { activity ->
            activity.recipe?.let { recipe ->
                // 시간 감쇠 계수 (오래된 활동일수록 영향력 감소)
                val daysSinceActivity = java.time.Duration.between(activity.createdAt, now).toDays()
                val timeDecay = exp(-0.05 * daysSinceActivity) // 약 2주 후 영향력 50% 감소

                // 가중치와 시간 감쇠를 적용한 점수
                val score = activity.weight * timeDecay
                recipeScores[recipe.id] = (recipeScores[recipe.id] ?: 0.0) + score
            }
        }

        // 점수 기준으로 정렬하여 상위 N개 레시피 ID 추출
        val topRecipeIds = recipeScores.entries
            .sortedByDescending { it.value }
            .take(count)
            .map { it.key }

        // 레시피 세부 정보 조회
        return topRecipeIds.mapNotNull { recipeId ->
            val recipe = recipeRepository.findById(recipeId).orElse(null)
            recipe?.let { recipePort.getRecipeById(it.id, user.id) }
        }
    }

    /**
     * 계절 기반 추천
     */
    private fun getSeasonalRecommendations(count: Int, userId: Long?): List<RecipeDTO> {
        val currentSeason = DateUtil.getCurrentSeason()
        val pageable: Pageable = PageRequest.of(0, count)
        val seasonalRecipes = recipeRepository.findBySeasonOrAll(currentSeason, pageable)

        return seasonalRecipes.map { recipe ->
            if (userId != null) {
                recipePort.getRecipeById(recipe.id, userId)
            } else {
                convertToDTO(recipe)
            }
        }
    }

    /**
     * 인기 레시피 추천
     */
    private fun getPopularRecipes(count: Int, userId: Long?): List<RecipeDTO> {
        return recipePort.getTopRatedRecipes(0, count, userId).content
    }

    // RecommendationService에서 사용할 convertToDTO 메서드 추가
    fun convertToDTO(recipe: Recipe): RecipeDTO {
        val ingredients = recipeIngredientRepository.findByRecipe(recipe)
        val ratingCount = recipe.ratings.size
        val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
            .map { it.toDTO() }

        // 단계별 조리법 로드
        val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
            .map { it.toDTO() }

        return RecipeDTO(
            id = recipe.id,
            title = recipe.title,
            description = recipe.description,
            instructions = recipe.instructions,
            cookingTime = recipe.cookingTime,
            servingSize = recipe.servingSize,
            images = images,
            steps = steps, // 단계별 조리법 추가
            userId = recipe.user.id,
            username = recipe.user.username,
            ingredients = ingredients.map {
                RecipeIngredientDTO(
                    id = it.id,
                    ingredientId = it.ingredient.id,
                    name = it.ingredient.name,
                    quantity = it.quantity.toString(),
                    unit = it.unit,
                    optional = it.optional
                )
            },
            avgRating = recipe.avgRating,
            ratingCount = ratingCount,
            isFavorite = false
        )
    }

    /**
     * 유사한 레시피 추천 (콘텐츠 기반 필터링)
     */
    override fun getSimilarRecipes(recipeId: Long, count: Int, userId: Long?): List<RecipeDTO> {
        val recipe = recipeRepository.findById(recipeId)
            .orElseThrow { IllegalArgumentException("레시피를 찾을 수 없습니다") }

        // 같은 계절의 레시피 우선
        val pageable: Pageable = PageRequest.of(0, count * 3) // 필터링 가능성 고려해 더 많이 조회
        val seasonalRecipes = recipeRepository.findBySeason(recipe.season, pageable)

        // 유사도 점수 계산
        val recipeScores = seasonalRecipes.filter { it.id != recipeId }.map { candidateRecipe ->
            val similarityScore = calculateRecipeSimilarity(recipe, candidateRecipe)

            val recipeDto = if (userId != null) {
                recipePort.getRecipeById(candidateRecipe.id, userId)
            } else {
                convertToDTO(candidateRecipe)
            }

            recipeDto to similarityScore
        }

        // 유사도 점수로 정렬하여 상위 N개 반환
        return recipeScores.sortedByDescending { it.second }
            .take(count)
            .map { it.first }
    }

    /**
     * 두 레시피 간의 유사도 계산 (0-1 사이 값)
     */
    private fun calculateRecipeSimilarity(recipe1: Recipe, recipe2: Recipe): Double {
        var score = 0.0

        // 1. 계절 일치 (25%)
        if (recipe1.season == recipe2.season ||
            recipe1.season == Season.ALL ||
            recipe2.season == Season.ALL) {
            score += 0.25
        }

        // 2. 태그 유사도 (25%)
        val tags1 = recipe1.tags?.split(",")?.map { it.trim().lowercase() } ?: emptyList()
        val tags2 = recipe2.tags?.split(",")?.map { it.trim().lowercase() } ?: emptyList()

        val commonTags = tags1.filter { it in tags2 }
        val tagSimilarity = if (tags1.isEmpty() || tags2.isEmpty()) {
            0.0
        } else {
            commonTags.size.toDouble() / min(tags1.size, tags2.size)
        }
        score += tagSimilarity * 0.25

        // 3. 조리 시간 유사도 (15%)
        val timeSimilarity = if (recipe1.cookingTime != null && recipe2.cookingTime != null) {
            val time1 = recipe1.cookingTime?.toInt() ?: 0
            val time2 = recipe2.cookingTime?.toInt() ?: 0
            val timeDiff = kotlin.math.abs(time1 - time2)
            val maxTime = kotlin.math.max(time1, time2)
            if (maxTime > 0) {
                kotlin.math.max(0.0, 1.0 - timeDiff.toDouble() / maxTime)
            } else {
                1.0
            }
        } else {
            0.5 // 정보 없음
        }
        score += timeSimilarity * 0.15

        // 4. 재료 유사도 (35%)
        val ingredientIds1 = recipe1.ingredients.map { it.ingredient.id }
        val ingredientIds2 = recipe2.ingredients.map { it.ingredient.id }

        val commonIngredients = ingredientIds1.filter { it in ingredientIds2 }
        val ingredientSimilarity = if (ingredientIds1.isEmpty() || ingredientIds2.isEmpty()) {
            0.0
        } else {
            commonIngredients.size.toDouble() / kotlin.math.max(ingredientIds1.size, ingredientIds2.size)
        }
        score += ingredientSimilarity * 0.35

        return score
    }

    /**
     * 현재 계절에 맞는 레시피 추천
     */
    override fun getSeasonalRecipes(season: Season?, count: Int, userId: Long?): List<RecipeDTO> {
        // 계절이 지정되지 않은 경우 현재 월에 따라 자동 지정
        val currentSeason = season ?: getCurrentSeason()

        val pageable: Pageable = PageRequest.of(0, count)
        val seasonalRecipes = recipeRepository.findBySeasonOrAll(currentSeason, pageable)

        return seasonalRecipes.map { recipe ->
            if (userId != null) {
                recipePort.getRecipeById(recipe.id, userId)
            } else {
                convertToDTO(recipe)
            }
        }
    }

    /**
     * 현재 월을 기준으로 계절 판단
     */
    override fun getCurrentSeason(): Season {
        val month = LocalDateTime.now().monthValue

        return when (month) {
            3, 4, 5 -> Season.SPRING   // 봄: 3-5월
            6, 7, 8 -> Season.SUMMER   // 여름: 6-8월
            9, 10, 11 -> Season.FALL   // 가을: 9-11월
            else -> Season.WINTER      // 겨울: 12-2월
        }
    }
}