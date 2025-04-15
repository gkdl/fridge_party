package com.fridge.recipe.adapter

import com.fridge.recipe.entity.*
import com.fridge.recipe.mapper.toDTO
import com.fridge.recipe.port.RecipePort
import com.fridge.recipe.repository.*
import com.fridge.recipe.vo.*
import org.springframework.cache.annotation.Cacheable
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Component
class RecipeAdapter (
    private val recipeRepository: RecipeRepository,
    private val userRepository: UserRepository,
    private val ingredientRepository: IngredientRepository,
    private val recipeIngredientRepository: RecipeIngredientRepository,
    private val favoriteRepository: FavoriteRepository,
    private val ratingRepository: RatingRepository,
    private val recipeImageRepository: RecipeImageRepository,
    private val recipeStepRepository: RecipeStepRepository
) : RecipePort {

    /**
     * 인기 레시피 가져오기 (평점순)
     * @param count 가져올 레시피 수
     * @return 인기 레시피 리스트
     */
    @Cacheable(value = ["recipes"], key = "'popular_' + #count", unless = "#result.isEmpty()")
    override fun getPopularRecipes(count: Int): List<RecipeDTO> {
        val pageable: Pageable = PageRequest.of(0, count)
        return recipeRepository.findTopRated(pageable).map { recipe ->
            val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
                    .map { it.toDTO() }

            // 단계별 조리법 로드
            val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
                    .map { it.toDTO() }

            val ingredients = recipeIngredientRepository.findByRecipe(recipe)
            recipe.toDTO(ingredients, false, images, steps)
        }.content
    }

    override fun getRecentRecipes(count: Int): List<RecipeDTO> {
        val pageable: Pageable = PageRequest.of(0, count, Sort.by("createdAt").descending())
        return recipeRepository.findAll(pageable).map { recipe ->
            val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
                .map { it.toDTO() }

            // 단계별 조리법 로드
            val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
                .map { it.toDTO() }


            val ingredients = recipeIngredientRepository.findByRecipe(recipe)
            recipe.toDTO(ingredients, false, images, steps)
        }.content
    }

    override fun getTopRatedRecipes(page: Int, size: Int, userId: Long?): Page<RecipeDTO> {
        val pageable: Pageable = PageRequest.of(page, size)

        return recipeRepository.findTopRated(pageable).map { recipe ->
            val ingredients = recipeIngredientRepository.findByRecipe(recipe)
            val isFavorite = if (userId != null) {
                val user = userRepository.findById(userId).orElse(null)
                user?.let { favoriteRepository.existsByUserAndRecipe(it, recipe) } ?: false
            } else {
                false
            }

            val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
                .map { it.toDTO() }

            // 단계별 조리법 로드
            val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
                .map { it.toDTO() }

            recipe.toDTO(ingredients, isFavorite, images, steps)
        }
    }

    override fun getRecipeById(recipeId: Long, userId: Long?): RecipeDTO {
        val recipe = recipeRepository.findById(recipeId)
            .orElseThrow { IllegalArgumentException("레시피를 찾을 수 없습니다") }

        val ingredients = recipeIngredientRepository.findByRecipe(recipe)

        val isFavorite = if (userId != null) {
            val user = userRepository.findById(userId).orElse(null)
            user?.let { favoriteRepository.existsByUserAndRecipe(it, recipe) } ?: false
        } else {
            false
        }

        val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
            .map { it.toDTO() }

        // 단계별 조리법 로드
        val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
            .map { it.toDTO() }

        return recipe.toDTO(ingredients, isFavorite, images, steps)
    }

    override fun updateRecipe(userId: Long, recipeId: Long, recipeUpdateDTO: RecipeCreateDTO): RecipeDTO {
        val recipe = recipeRepository.findById(recipeId).orElseThrow { IllegalArgumentException("레시피를 찾을 수 없습니다") }

        if (recipe.user.id != userId) {
            throw IllegalArgumentException("해당 레시피를 수정할 권한이 없습니다")
        }

        // 레시피 정보 업데이트
        recipe.title = recipeUpdateDTO.title
        recipe.description = recipeUpdateDTO.description
        recipe.instructions = recipeUpdateDTO.instructions // 레거시 지원을 위해 유지
        recipe.cookingTime = recipeUpdateDTO.cookingTime
        recipe.servingSize = recipeUpdateDTO.servingSize
        recipe.imageUrl = recipeUpdateDTO.imageUrl ?: recipe.imageUrl
        recipe.updatedAt = LocalDateTime.now()

        recipeRepository.save(recipe)

        // 기존 재료 삭제
        val existingIngredients = recipeIngredientRepository.findByRecipe(recipe)
        recipeIngredientRepository.deleteAll(existingIngredients)

        // 새 재료 추가
        val recipeIngredients = recipeUpdateDTO.ingredients.map { ingredientDTO ->
            val ingredient = if (ingredientDTO.ingredientId != null) {
                // 기존 재료 사용
                ingredientRepository.findById(ingredientDTO.ingredientId)
                    .orElseThrow { IllegalArgumentException("재료를 찾을 수 없습니다: ${ingredientDTO.name}") }
            } else {
                // 이름으로 재료 찾기 또는 생성
                val existingIngredient = ingredientRepository.findByNameIgnoreCase(ingredientDTO.name)
                if (existingIngredient.isPresent) {
                    existingIngredient.get()
                } else {
                    // 새 재료 생성
                    ingredientRepository.save(Ingredient(name = ingredientDTO.name))
                }
            }

            RecipeIngredient(
                recipe = recipe,
                ingredient = ingredient,
                quantity = ingredientDTO.quantity,
                unit = ingredientDTO.unit,
                optional = ingredientDTO.optional
            )
        }

        recipeIngredientRepository.saveAll(recipeIngredients)

        // 기존 이미지 처리
        val existingImages = recipeImageRepository.findByRecipe(recipe)

        // 새 이미지가 있는 경우 기존 이미지 삭제 후 새 이미지 추가
        if (recipeUpdateDTO.images.isNotEmpty()) {
            recipeImageRepository.deleteAll(existingImages)

            val recipeImages = recipeUpdateDTO.images.map { imageDTO ->
                RecipeImage(
                    recipe = recipe,
                    imageUrl = imageDTO.imageUrl,
                    isPrimary = imageDTO.isPrimary,
                    description = imageDTO.description
                )
            }
            recipeImageRepository.saveAll(recipeImages)
        }
        // 새 단일 이미지만 있고 기존 다중 이미지가 없는 경우
        else if (recipeUpdateDTO.imageUrl != null && existingImages.isEmpty()) {
            val primaryImage = RecipeImage(
                recipe = recipe,
                imageUrl = recipeUpdateDTO.imageUrl!!,
                isPrimary = true
            )
            recipeImageRepository.save(primaryImage)
        }
        // 기존 단일 이미지가 갱신되었고 다중 이미지가 있는 경우
        else if (recipeUpdateDTO.imageUrl != null && recipeUpdateDTO.imageUrl != recipe.imageUrl && existingImages.isNotEmpty()) {
            // 기본(primary) 이미지만 업데이트
            val primaryImage = existingImages.find { it.isPrimary }
            if (primaryImage != null) {
                val updatedPrimaryImage = primaryImage.copy(
                    imageUrl = recipeUpdateDTO.imageUrl!!,
                    updatedAt = LocalDateTime.now()
                )
                recipeImageRepository.save(updatedPrimaryImage)
            } else {
                // 기본 이미지가 없으면 새로 추가
                val newPrimaryImage = RecipeImage(
                    recipe = recipe,
                    imageUrl = recipeUpdateDTO.imageUrl!!,
                    isPrimary = true
                )
                recipeImageRepository.save(newPrimaryImage)
            }
        }

        // 기존 단계별 조리법 삭제
        recipeStepRepository.deleteByRecipe(recipe)

        // 새 단계별 조리법 추가
        if (recipeUpdateDTO.steps.isNotEmpty()) {
            val recipeSteps = recipeUpdateDTO.steps.map { stepDTO ->
                RecipeStep(
                    recipe = recipe,
                    stepNumber = stepDTO.stepNumber,
                    description = stepDTO.description,
                    imageUrl = stepDTO.imageUrl
                )
            }
            recipeStepRepository.saveAll(recipeSteps)
        }

        val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
            .map { it.toDTO() }

        // 단계별 조리법 로드
        val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
            .map { it.toDTO() }

        return recipe.toDTO(recipeIngredients, false, images, steps)
    }

    override fun rateRecipe(userId: Long, ratingCreateDTO: RatingCreateDTO): RatingDTO {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        val recipe = recipeRepository.findById(ratingCreateDTO.recipeId)
            .orElseThrow { IllegalArgumentException("레시피를 찾을 수 없습니다") }

        if (ratingCreateDTO.rating < 1 || ratingCreateDTO.rating > 5) {
            throw IllegalArgumentException("평점은 1-5 사이여야 합니다")
        }

        val existingRating = ratingRepository.findByUserAndRecipe(user, recipe)

        val rating = if (existingRating.isPresent) {
            // 기존 평점 업데이트
            val updated = existingRating.get().copy(
                rating = ratingCreateDTO.rating,
                comment = ratingCreateDTO.comment,
                updatedAt = LocalDateTime.now()
            )
            ratingRepository.save(updated)
        } else {
            // 새 평점 생성
            ratingRepository.save(
                Rating(
                    user = user,
                    recipe = recipe,
                    rating = ratingCreateDTO.rating,
                    comment = ratingCreateDTO.comment
                )
            )
        }

        // 레시피의 평균 평점 업데이트
        val avgRating = ratingRepository.getAverageRatingForRecipe(recipe.id) ?: 0.0
        recipe.avgRating = avgRating
        recipeRepository.save(recipe)

        return rating.toDTO()
    }

    /**
     * 레시피의 평점 목록 조회
     * @param recipeId 레시피 ID
     * @param page 페이지 번호
     * @param size 페이지 크기
     * @return 평점 목록
     */
    override fun getRecipeRatings(recipeId: Long, page: Int, size: Int): Page<RatingDTO> {
        val recipe = recipeRepository.findById(recipeId)
            .orElseThrow { IllegalArgumentException("레시피를 찾을 수 없습니다") }

        val pageable: Pageable = PageRequest.of(page, size, Sort.by("createdAt").descending())

        return ratingRepository.findByRecipe(recipe, pageable).map { rating ->
            rating.toDTO()
        }
    }


    override fun searchRecipes(searchDTO: RecipeSearchDTO, userId: Long?): Page<RecipeDTO> {
        val pageable: Pageable = PageRequest.of(
            searchDTO.page,
            searchDTO.size,
            Sort.by("createdAt").descending()
        )

        val recipes = if (searchDTO.query != null && searchDTO.query!!.isNotBlank()) {
            recipeRepository.findByTitleContaining(searchDTO.query!!, pageable)
        } else if (searchDTO.ingredientIds.isNotEmpty()) {
            // 재료 기반 검색
            recipeRepository.findByIngredientIds(
                searchDTO.ingredientIds,
                (searchDTO.ingredientIds.size * 0.7).toLong(), // 최소 70% 이상의 재료가 일치하는 레시피
                pageable
            )
        } else {
            recipeRepository.findAll(pageable)
        }

        return recipes.map { recipe ->
            val ingredients = recipeIngredientRepository.findByRecipe(recipe)
            val isFavorite = if (userId != null) {
                val user = userRepository.findById(userId).orElse(null)
                user?.let { favoriteRepository.existsByUserAndRecipe(it, recipe) } ?: false
            } else {
                false
            }

            val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
                .map { it.toDTO() }

            // 단계별 조리법 로드
            val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
                .map { it.toDTO() }

            recipe.toDTO(ingredients, isFavorite, images, steps)
        }
    }

}