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

            val favoriteCount = favoriteRepository.countByRecipe(recipe);

            recipe.toDTO(ingredients, false, images, steps, favoriteCount)
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

            val favoriteCount = favoriteRepository.countByRecipe(recipe);

            recipe.toDTO(ingredients, false, images, steps, favoriteCount)
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

            val favoriteCount = favoriteRepository.countByRecipe(recipe);

            recipe.toDTO(ingredients, isFavorite, images, steps, favoriteCount)
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

        val favoriteCount = favoriteRepository.countByRecipe(recipe);

        return recipe.toDTO(ingredients, isFavorite, images, steps, favoriteCount)
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

        val favoriteCount = favoriteRepository.countByRecipe(recipe);

        return recipe.toDTO(recipeIngredients, false, images, steps, favoriteCount)
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

            val favoriteCount = favoriteRepository.countByRecipe(recipe);

            recipe.toDTO(ingredients, isFavorite, images, steps, favoriteCount)
        }
    }

    /**
     * 특정 사용자의 다른 레시피 불러오기 (현재 레시피 제외)
     * @param userId 사용자 ID
     * @param excludeRecipeId 제외할 레시피 ID
     * @param limit 가져올 개수
     * @param viewerUserId 조회 중인 사용자 ID (즐겨찾기 확인용)
     * @return 레시피 목록
     */
    override fun getUserRecipesByIdExcept(userId: Long, excludeRecipeId: Long?, limit: Int): Page<RecipeDTO> {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        val pageable: Pageable = PageRequest.of(0, limit, Sort.by("createdAt").descending())

        val recipes = if (excludeRecipeId != null) {
            // 특정 레시피를 제외하고 조회
            recipeRepository.findByUserAndIdNotIn(user, listOf(excludeRecipeId), pageable)
        } else {
            // 모든 레시피 조회
            recipeRepository.findByUser(user, pageable)
        }

        return recipes.map { recipe ->
            val ingredients = recipeIngredientRepository.findByRecipe(recipe)
            val isFavorite = if (userId != null) {
                favoriteRepository.findByUserIdAndRecipeId(userId, recipe.id).isPresent
            } else {
                false
            }

            val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
                .map { it.toDTO() }

            // 단계별 조리법 로드
            val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
                .map { it.toDTO() }

            val favoriteCount = favoriteRepository.countByRecipe(recipe);

            recipe.toDTO(ingredients, isFavorite, images, steps, favoriteCount)
        }
    }

    override fun toggleFavorite(userId: Long, recipeId: Long): Boolean {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        val recipe = recipeRepository.findById(recipeId)
            .orElseThrow { IllegalArgumentException("레시피를 찾을 수 없습니다") }

        val existingFavorite = favoriteRepository.findByUserAndRecipe(user, recipe)

        return if (existingFavorite.isPresent) {
            // 즐겨찾기 해제
            favoriteRepository.deleteByUserAndRecipe(user, recipe)
            false
        } else {
            // 즐겨찾기 추가
            favoriteRepository.save(Favorite(user = user, recipe = recipe))
            true
        }
    }

    override fun getUserFavorites(userId: Long, page: Int, size: Int): Page<RecipeDTO> {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        val pageable: Pageable = PageRequest.of(page, size, Sort.by("createdAt").descending())

        return favoriteRepository.findByUser(user, pageable).map { favorite ->
            val recipe = favorite.recipe
            val ingredients = recipeIngredientRepository.findByRecipe(recipe)

            val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
                .map { it.toDTO() }

            // 단계별 조리법 로드
            val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
                .map { it.toDTO() }

            val favoriteCount = favoriteRepository.countByRecipe(recipe);

            recipe.toDTO(ingredients, true, images, steps, favoriteCount)
        }
    }

    override fun createRecipe(userId: Long, recipeCreateDTO: RecipeCreateDTO): RecipeDTO {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        val recipe = Recipe(
            title = recipeCreateDTO.title,
            description = recipeCreateDTO.description,
            instructions = recipeCreateDTO.instructions, // 레거시 지원을 위해 유지
            cookingTime = recipeCreateDTO.cookingTime,
            servingSize = recipeCreateDTO.servingSize,
            season = recipeCreateDTO.season, // 계절 정보 추가
            category = recipeCreateDTO.category, // 카테고리 정보 추가
            tags = recipeCreateDTO.tags, // 태그 정보 추가
            user = user
        )

        val savedRecipe = recipeRepository.save(recipe)

        // 레시피 재료 추가
        val recipeIngredients = recipeCreateDTO.ingredients.map { ingredientDTO ->
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
                recipe = savedRecipe,
                ingredient = ingredient,
                quantity = ingredientDTO.quantity,
                unit = ingredientDTO.unit,
                optional = ingredientDTO.optional
            )
        }

        recipeIngredientRepository.saveAll(recipeIngredients)

        // 다중 이미지 추가
        if (recipeCreateDTO.images.isNotEmpty()) {
            val recipeImages = recipeCreateDTO.images.map { imageDTO ->
                RecipeImage(
                    recipe = savedRecipe,
                    imageUrl = imageDTO.imageUrl,
                    isPrimary = imageDTO.isPrimary,
                    description = imageDTO.description
                )
            }
            recipeImageRepository.saveAll(recipeImages)
        }

        // 단계별 조리법 추가
        if (recipeCreateDTO.steps.isNotEmpty()) {
            val recipeSteps = recipeCreateDTO.steps.map { stepDTO ->
                RecipeStep(
                    recipe = savedRecipe,
                    stepNumber = stepDTO.stepNumber,
                    description = stepDTO.description,
                    imageUrl = stepDTO.imageUrl
                )
            }
            recipeStepRepository.saveAll(recipeSteps)
        } else if (recipeCreateDTO.instructions != null) {
            // 기존 instructions 필드가 있으면 단일 단계로 변환 (하위 호환성 지원)
            val step = RecipeStep(
                recipe = savedRecipe,
                stepNumber = 1,
                description = recipeCreateDTO.instructions!!,
                imageUrl = null
            )
            recipeStepRepository.save(step)
        }

        val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
            .map { it.toDTO() }

        // 단계별 조리법 로드
        val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
            .map { it.toDTO() }

        val favoriteCount = favoriteRepository.countByRecipe(recipe);

        return savedRecipe.toDTO(recipeIngredients, false, images, steps, favoriteCount)
    }

    override fun getUserRecipes(userId: Long, page: Int, size: Int): Page<RecipeDTO> {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        val pageable: Pageable = PageRequest.of(page, size, Sort.by("createdAt").descending())

        return recipeRepository.findByUser(user, pageable).map { recipe ->
            val ingredients = recipeIngredientRepository.findByRecipe(recipe)

            val images = recipeImageRepository.findByRecipeIdOrderByIsPrimaryDesc(recipe.id)
                .map { it.toDTO() }

            // 단계별 조리법 로드
            val steps = recipeStepRepository.findByRecipeIdOrderByStepNumber(recipe.id)
                .map { it.toDTO() }

            val favoriteCount = favoriteRepository.countByRecipe(recipe);

            recipe.toDTO(ingredients, true, images, steps, favoriteCount)
        }
    }

    override fun deleteRecipe(userId: Long, recipeId: Long) {
        val recipe = recipeRepository.findById(recipeId)
            .orElseThrow { IllegalArgumentException("레시피를 찾을 수 없습니다") }

        if (recipe.user.id != userId) {
            throw IllegalArgumentException("해당 레시피를 삭제할 권한이 없습니다")
        }

        recipeRepository.delete(recipe)
    }
}