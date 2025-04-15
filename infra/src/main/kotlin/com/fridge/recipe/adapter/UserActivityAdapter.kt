package com.fridge.recipe.adapter

import com.fridge.recipe.entity.UserActivity
import com.fridge.recipe.enum.ActivityType
import com.fridge.recipe.port.RecipePort
import com.fridge.recipe.port.UserActivityPort
import com.fridge.recipe.repository.RecipeRepository
import com.fridge.recipe.repository.UserActivityRepository
import com.fridge.recipe.repository.UserRepository
import com.fridge.recipe.vo.*
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Component
import java.time.format.DateTimeFormatter

@Component
class UserActivityAdapter (
    private val userRepository: UserRepository,
    private val userActivityRepository: UserActivityRepository,
    private val recipeRepository: RecipeRepository,
    private val recipePort: RecipePort
) : UserActivityPort {
    /**
     * 사용자 활동 기록
     */
    override fun recordActivity(userId: Long, activityCreateDTO: UserActivityCreateDTO): UserActivityDTO {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        // 활동 유형에 따라 가중치 조정 (평점, 즐겨찾기 등은 더 높은 가중치)
        val adjustedWeight = when (activityCreateDTO.activityType) {
            ActivityType.VIEW_RECIPE -> 1.0
            ActivityType.FAVORITE -> 3.0
            ActivityType.RATING -> 2.0 + (activityCreateDTO.weight - 1.0) / 4.0 * 3.0 // 평점 1-5를 가중치 2-5로 변환
            ActivityType.SEARCH -> 1.5
            ActivityType.COOK -> 4.0
        }

        val recipe = if (activityCreateDTO.recipeId != null) {
            activityCreateDTO.recipeId?.let { recipeRepository.findById(it).orElse(null) }
        } else {
            null
        }

        val activity = UserActivity(
            user = user,
            activityType = activityCreateDTO.activityType,
            recipe = recipe,
            searchQuery = activityCreateDTO.searchQuery,
            weight = adjustedWeight
        )

        val savedActivity = userActivityRepository.save(activity)

        return UserActivityDTO(
            id = savedActivity.id,
            userId = savedActivity.user.id,
            username = savedActivity.user.username,
            activityType = savedActivity.activityType,
            recipeId = savedActivity.recipe?.id,
            recipeTitle = savedActivity.recipe?.title,
            searchQuery = savedActivity.searchQuery,
            weight = savedActivity.weight,
            createdAt = savedActivity.createdAt.format(DateTimeFormatter.ISO_DATE_TIME)
        )
    }

    /**
     * 사용자의 활동 통계 정보 조회
     */
    override fun getUserActivityStats(userId: Long): UserActivityStatsDTO {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        // 활동 유형별 카운트
        val viewCount = userActivityRepository.countByUserAndActivityType(user, ActivityType.VIEW_RECIPE).toInt()
        val favoriteCount = userActivityRepository.countByUserAndActivityType(user, ActivityType.FAVORITE).toInt()
        val ratingCount = userActivityRepository.countByUserAndActivityType(user, ActivityType.RATING).toInt()
        val searchCount = userActivityRepository.countByUserAndActivityType(user, ActivityType.SEARCH).toInt()
        val cookCount = userActivityRepository.countByUserAndActivityType(user, ActivityType.COOK).toInt()

        // 최근 검색어
        val recentSearchesPageable = PageRequest.of(0, 5, Sort.by("createdAt").descending())
        val recentSearches = userActivityRepository.findRecentSearches(user, recentSearchesPageable)
            .mapNotNull { it.searchQuery }
            .distinct()
            .take(5)

        // 가장 평점이 높은 레시피
        val topRatedRecipesPageable = PageRequest.of(0, 3)
        val topRatedRecipes = recipePort.getTopRatedRecipes(0, 3, userId).content

        return UserActivityStatsDTO(
            viewCount = viewCount,
            favoriteCount = favoriteCount,
            ratingCount = ratingCount,
            searchCount = searchCount,
            cookCount = cookCount,
            recentSearches = recentSearches,
            topRatedRecipes = topRatedRecipes
        )
    }

}