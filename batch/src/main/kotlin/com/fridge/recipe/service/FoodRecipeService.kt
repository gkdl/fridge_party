package com.fridge.recipe.service


import com.fasterxml.jackson.annotation.JsonProperty
import com.fridge.recipe.FoodApiResponse
import com.fridge.recipe.FoodRecipeDTO
import com.fridge.recipe.FoodRecipeWrapper
import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.RecipeImage
import com.fridge.recipe.entity.RecipeStep
import com.fridge.recipe.enum.RecipeCategory
import com.fridge.recipe.repository.*
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.reactive.function.client.WebClient
import java.time.LocalDateTime
import java.util.*

@Service
class FoodRecipeService(
    private val recipeRepository: RecipeRepository,
    private val recipeImageRepository: RecipeImageRepository,
    private val recipeStepRepository: RecipeStepRepository,
    private val recipeIngredientRepository: RecipeIngredientRepository,
    private val userRepository: UserRepository,
    private val ingredientParser: IngredientParser
) {
    private val logger = LoggerFactory.getLogger(FoodRecipeService::class.java)

    // 식품의약품안전처 API 키
    @Value("\${food.api.key}")
    private lateinit var apiKey: String

    // 시스템 관리자 ID
    @Value("\${system.admin.id:1}")
    private var systemAdminId: Long = 1L

    // API 기본 URL
    private val apiBaseUrl = "https://openapi.foodsafetykorea.go.kr/api"

    // 서비스 코드
    private val serviceCode = "COOKRCP01"

    // 한 페이지당 결과 수
    private val pageSize = 100

    // 웹 클라이언트
    private val webClient = WebClient.builder().build()

    /**
     * 모든 레시피 데이터를 수집하여 저장
     * @return 처리된 총 레시피 수
     */
    @Transactional
    fun fetchAndSaveAllRecipes(): Int {
        var startIndex = 1
        var totalProcessedRecipes = 0
        var hasMoreData = true

        logger.info("식품의약품안전처 레시피 데이터 수집 시작")

        while (hasMoreData) {
            logger.info("레시피 데이터 페이지 처리 중: 시작 인덱스 = $startIndex, 페이지 크기 = $pageSize")

            val response = fetchRecipePage(startIndex, pageSize)

            if (response != null) {
                val recipes = response.cookRecipe.recipes
                val totalCount = response.cookRecipe.totalCount.toIntOrNull() ?: 0

                logger.info("페이지 응답 처리 중: ${recipes.size}개 레시피, 전체 ${totalCount}개 중")

                // 페이지 내 모든 레시피 처리
                for (recipeDTO in recipes) {
                    try {
                        saveOrUpdateRecipe(recipeDTO)
                    } catch (e: Exception) {
                        logger.error("레시피 저장 중 오류 발생, 레시피 ID: ${recipeDTO.recipeId}, 오류: ${e.message}", e)
                    }
                }

                totalProcessedRecipes += recipes.size

                // 다음 페이지 존재 여부 확인
                startIndex += pageSize
                hasMoreData = totalProcessedRecipes < totalCount && recipes.isNotEmpty()

                logger.info("페이지 처리 완료: 현재까지 $totalProcessedRecipes 개 레시피 처리됨")
            } else {
                logger.warn("API 응답이 null입니다. 데이터 수집을 중단합니다.")
                hasMoreData = false
            }
        }

        logger.info("식품의약품안전처 레시피 데이터 수집 완료: 총 $totalProcessedRecipes 개 레시피 처리됨")
        return totalProcessedRecipes
    }

    /**
     * 레시피 페이지 데이터 조회
     */
    private fun fetchRecipePage(startIndex: Int, pageSize: Int): FoodApiResponse? {
        //https://openapi.foodsafetykorea.go.kr/api/565fe1f3fd7e44bfa7d0/COOKRCP01/json/1/1000
        val url = "$apiBaseUrl/$apiKey/$serviceCode/json/$startIndex/${startIndex + pageSize - 1}"
        //val url = "https://openapi.foodsafetykorea.go.kr/api/565fe1f3fd7e44bfa7d0/COOKRCP01/json/1/5/RCP_NM=방울토마토 소박이"
        logger.info("API 호출: $url")

        return try {
            webClient.get()
                .uri(url)
                .retrieve()
                .bodyToMono(FoodApiResponse::class.java)
                .block()
        } catch (e: Exception) {
            logger.error("API 호출 중 오류 발생: ${e.message}", e)
            null
        }
    }

    /**
     * 레시피를 DB에 저장 또는 업데이트
     */
    @Transactional
    fun saveOrUpdateRecipe(recipeDTO: FoodRecipeDTO) {
        // 이미 존재하는지 확인 (외부 API ID로 조회)
        val existingRecipe = recipeRepository.findByExternalId(recipeDTO.recipeId)

        // 시스템 관리자 (작성자) 정보 조회
        val admin = userRepository.findById(systemAdminId).orElse(null)
            ?: throw IllegalStateException("시스템 관리자 계정을 찾을 수 없습니다 (ID: $systemAdminId)")

        // 카테고리 결정
        val category = determineCategory(recipeDTO.recipeCategory, recipeDTO.cookingMethod)

        if (existingRecipe.isPresent) {
            // 기존 레시피 업데이트
            val recipe = existingRecipe.get()
            recipe.title = recipeDTO.recipeName
            recipe.description = recipeDTO.ingredients ?: ""
            recipe.category = category.name
            recipe.cookingTime = estimateCookingTime(recipeDTO)
            recipe.difficulty = estimateDifficulty(recipeDTO)
            recipe.servingSize = extractServings(recipeDTO.ingredients)
            recipe.updatedAt = LocalDateTime.now()

            // 영양 정보 업데이트
            recipe.calories = recipeDTO.calories?.toDoubleOrNull()
            recipe.carbohydrate = recipeDTO.carbohydrate?.toDoubleOrNull()
            recipe.protein = recipeDTO.protein?.toDoubleOrNull()
            recipe.fat = recipeDTO.fat?.toDoubleOrNull()
            recipe.sodium = recipeDTO.sodium?.toDoubleOrNull()

            recipeRepository.save(recipe)

            // 기존 이미지 삭제 전에 기본 이미지 처리
            var primaryImageDeleted = false
            if (recipe.primaryImageUrl != recipeDTO.mainImageUrl) {
                recipe.primaryImageUrl = recipeDTO.mainImageUrl
                primaryImageDeleted = true
            }

            // 기존 이미지와 조리 단계 삭제 (주 이미지 보존)
            if (!primaryImageDeleted) {
                val images = recipeImageRepository.findByRecipeAndIsPrimaryFalse(recipe)
                recipeImageRepository.deleteAll(images)
            } else {
                recipeImageRepository.deleteByRecipe(recipe)
            }

            // 조리 단계 삭제
            recipeStepRepository.deleteByRecipe(recipe)

            // 메인 이미지 저장
            saveMainImage(recipe, recipeDTO.mainImageUrl)

            // 조리 단계 저장
            saveRecipeSteps(recipe, recipeDTO)

            // 기존 레시피 재료 삭제
            val existingIngredients = recipeIngredientRepository.findByRecipe(recipe)
            recipeIngredientRepository.deleteAll(existingIngredients)

            // 레시피 재료 파싱 및 저장
            val recipeIngredients = ingredientParser.parseAndSaveRecipeIngredients(recipe, recipeDTO.ingredients)
            logger.info("레시피 ID: ${recipe.id}, ${recipeIngredients.size}개의 재료 파싱 및 저장 완료")

            logger.info("레시피 업데이트 완료: ID ${recipe.id}, 외부 ID ${recipe.externalId}")
        } else {
            // 새 레시피 생성
            val recipe = Recipe(
                title = recipeDTO.recipeName,
                description = recipeDTO.ingredients ?: "",
                category = category.name,
                cookingTime = estimateCookingTime(recipeDTO),
                difficulty = estimateDifficulty(recipeDTO),
                servingSize = extractServings(recipeDTO.ingredients),
                user = admin,
                externalId = recipeDTO.recipeId,
                calories = recipeDTO.calories?.toDoubleOrNull(),
                carbohydrate = recipeDTO.carbohydrate?.toDoubleOrNull(),
                protein = recipeDTO.protein?.toDoubleOrNull(),
                fat = recipeDTO.fat?.toDoubleOrNull(),
                sodium = recipeDTO.sodium?.toDoubleOrNull(),
                primaryImageUrl = recipeDTO.mainImageUrl
            )

            val savedRecipe = recipeRepository.save(recipe)

            // 메인 이미지 저장
            saveMainImage(savedRecipe, recipeDTO.mainImageUrl)

            // 조리 단계 저장
            saveRecipeSteps(savedRecipe, recipeDTO)

            // 레시피 재료 파싱 및 저장
            val recipeIngredients = ingredientParser.parseAndSaveRecipeIngredients(savedRecipe, recipeDTO.ingredients)
            logger.info("레시피 ID: ${savedRecipe.id}, ${recipeIngredients.size}개의 재료 파싱 및 저장 완료")

            logger.info("새 레시피 저장 완료: ID ${savedRecipe.id}, 외부 ID ${savedRecipe.externalId}")
        }
    }

    /**
     * 메인 이미지 저장
     */
    private fun saveMainImage(recipe: Recipe, imageUrl: String?) {
        if (!imageUrl.isNullOrBlank()) {
            val mainImage = RecipeImage(
                recipe = recipe,
                imageUrl = imageUrl,
                isPrimary = true
            )
            recipeImageRepository.save(mainImage)
        }
    }

    /**
     * 조리 단계 저장
     */
    private fun saveRecipeSteps(recipe: Recipe, recipeDTO: FoodRecipeDTO) {
        val steps = recipeDTO.getValidSteps()

        steps.forEachIndexed { index, (description, imageUrl) ->
            val step = RecipeStep(
                recipe = recipe,
                stepNumber = index + 1,
                description = description,
                imageUrl = imageUrl
            )
            recipeStepRepository.save(step)
        }
    }

    /**
     * 카테고리 결정
     */
    private fun determineCategory(categoryStr: String?, cookingMethod: String?): RecipeCategory {
        val category = categoryStr?.trim()?.lowercase(Locale.getDefault())
        val method = cookingMethod?.trim()?.lowercase(Locale.getDefault())

        return when {
            category?.contains("밥") == true || category?.contains("죽") == true || category?.contains("면") == true -> RecipeCategory.RICE_NOODLES
            category?.contains("국") == true || category?.contains("찌개") == true || category?.contains("탕") == true -> RecipeCategory.SOUP_STEW
            category?.contains("반찬") == true -> RecipeCategory.SIDE_DISH
            category?.contains("일품") == true -> RecipeCategory.MAIN_DISH
            category?.contains("후식") == true || category?.contains("음료") == true || category?.contains("간식") == true -> RecipeCategory.DESSERT
            category?.contains("샐러드") == true -> RecipeCategory.SALAD
            method?.contains("볶음") == true -> RecipeCategory.SIDE_DISH
            method?.contains("구이") == true -> RecipeCategory.MAIN_DISH
            method?.contains("찜") == true -> RecipeCategory.MAIN_DISH
            method?.contains("튀김") == true -> RecipeCategory.SIDE_DISH
            else -> RecipeCategory.OTHER
        }
    }

    /**
     * 조리 시간 추정
     */
    private fun estimateCookingTime(recipeDTO: FoodRecipeDTO): Int {
        val steps = recipeDTO.getValidSteps()

        // 조리 단계 수에 따라 시간 추정 (평균 5분/단계)
        return steps.size * 5
    }

    /**
     * 난이도 추정
     */
    private fun estimateDifficulty(recipeDTO: FoodRecipeDTO): String {
        val steps = recipeDTO.getValidSteps()

        return when {
            steps.size <= 3 -> "쉬움"
            steps.size <= 7 -> "보통"
            else -> "어려움"
        }
    }

    /**
     * 인분 수 추출
     */
    private fun extractServings(ingredients: String?): Int {
        if (ingredients == null) return 2

        // "1~2인분", "2인분" 등의 패턴 찾기
        val servingPattern = "(\\d+)\\s*인분".toRegex()
        val match = servingPattern.find(ingredients)

        return match?.groupValues?.getOrNull(1)?.toIntOrNull() ?: 2
    }
}