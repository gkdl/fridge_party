package com.fridge.recipe.repository

import com.fridge.recipe.entity.Ingredient
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface IngredientRepository : JpaRepository<Ingredient, Long> {
    fun findByNameContaining(name: String): List<Ingredient>

    fun findByCategory(category: String): List<Ingredient>
    
    @Query("SELECT i FROM Ingredient i WHERE LOWER(i.name) = LOWER(:name)")
    fun findByNameIgnoreCase(name: String): Optional<Ingredient>
}
