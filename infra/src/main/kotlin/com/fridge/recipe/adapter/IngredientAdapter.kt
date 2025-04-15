package com.fridge.recipe.adapter

import com.fridge.recipe.entity.Ingredient
import com.fridge.recipe.entity.UserIngredient
import com.fridge.recipe.mapper.toDTO
import com.fridge.recipe.port.IngredientPort
import com.fridge.recipe.port.RecipePort
import com.fridge.recipe.repository.*
import com.fridge.recipe.util.DateUtil
import com.fridge.recipe.vo.AddIngredientDTO
import com.fridge.recipe.vo.IngredientDTO
import com.fridge.recipe.vo.RecipeDTO
import com.fridge.recipe.vo.UserIngredientDTO
import org.springframework.cache.annotation.Cacheable
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

@Component
class IngredientAdapter (
    private val userRepository: UserRepository,
    private val userIngredientRepository: UserIngredientRepository,
    private val ingredientRepository: IngredientRepository
) : IngredientPort {
    override fun getUserIngredients(userId: Long): List<UserIngredientDTO> {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        val currentSeason = DateUtil.getCurrentSeason()
        return userIngredientRepository.findByUser(user).map { it.toDTO(currentSeason) }
    }

    override fun searchIngredients(query: String): List<IngredientDTO> {
        val currentSeason = DateUtil.getCurrentSeason()
        return ingredientRepository.findByNameContaining(query).map { it.toDTO(currentSeason) }
    }

    override fun addUserIngredient(userId: Long, addIngredientDTO: AddIngredientDTO): UserIngredientDTO {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("사용자를 찾을 수 없습니다") }

        val ingredient = if (addIngredientDTO.ingredientId != null) {
            // 기존 재료 사용
            addIngredientDTO.ingredientId?.let {
                ingredientRepository.findById(it)
                    .orElseThrow { IllegalArgumentException("재료를 찾을 수 없습니다") }
            }
        } else if (addIngredientDTO.name != null) {
            // 이름으로 재료 찾기 또는 생성
            val existingIngredient = ingredientRepository.findByNameIgnoreCase(addIngredientDTO.name!!)
            if (existingIngredient.isPresent) {
                existingIngredient.get()
            } else {
                // 새 재료 생성
                ingredientRepository.save(Ingredient(
                    name = addIngredientDTO.name!!,
                    category = addIngredientDTO.category
                ))
            }
        } else {
            throw IllegalArgumentException("재료 ID 또는 이름이 필요합니다")
        }

        // 이미 사용자가 동일한 재료를 가지고 있는지 확인
        val existingUserIngredient = userIngredientRepository.findByUserAndIngredient(user, ingredient!!)

        val userIngredient = if (existingUserIngredient.isPresent) {
            // 기존 재료 정보 가져오기
            val existing = existingUserIngredient.get()

            // 새 재료 인스턴스 생성 (data class에서 일반 class로 변경되어 copy() 메서드 없음)
            val updated = UserIngredient(
                id = existing.id,
                user = existing.user,
                ingredient = existing.ingredient,
                quantity = addIngredientDTO.quantity ?: existing.quantity,
                unit = addIngredientDTO.unit ?: existing.unit,
                expiryDate = if (addIngredientDTO.expiryDate != null)
                    LocalDateTime.parse(addIngredientDTO.expiryDate, DateTimeFormatter.ISO_DATE_TIME)
                else existing.expiryDate,
                addedAt = existing.addedAt,
                updatedAt = LocalDateTime.now()
            )
            userIngredientRepository.save(updated)
        } else {
            // 새 사용자 재료 생성
            val newUserIngredient = UserIngredient(
                user = user,
                ingredient = ingredient,
                quantity = addIngredientDTO.quantity,
                unit = addIngredientDTO.unit,
                expiryDate = if (addIngredientDTO.expiryDate != null)
                    LocalDateTime.parse(addIngredientDTO.expiryDate, DateTimeFormatter.ISO_DATE_TIME)
                else null
            )
            userIngredientRepository.save(newUserIngredient)
        }

        val currentSeason = DateUtil.getCurrentSeason()
        return userIngredient.toDTO(currentSeason)
    }
}