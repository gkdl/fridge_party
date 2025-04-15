package com.fridge.recipe.repository

import com.fridge.recipe.entity.Ingredient
import com.fridge.recipe.entity.User
import com.fridge.recipe.entity.UserIngredient
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface UserIngredientRepository : JpaRepository<UserIngredient, Long> {
    fun findByUser(user: User): List<UserIngredient>
    fun findByUserAndIngredient(user: User, ingredient: Ingredient): Optional<UserIngredient>
    fun deleteByUserAndIngredient(user: User, ingredient: Ingredient)
}
