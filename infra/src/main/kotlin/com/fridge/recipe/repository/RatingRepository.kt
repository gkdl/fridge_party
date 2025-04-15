package com.fridge.recipe.repository

import com.fridge.recipe.entity.Rating
import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.User
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface RatingRepository : JpaRepository<Rating, Long> {
    fun findByUserAndRecipe(user: User, recipe: Recipe): Optional<Rating>

    fun findByRecipe(recipe: Recipe, pageable: Pageable):Page<Rating>

    @Query("SELECT AVG(r.rating) FROM Rating r WHERE r.recipe.id = :recipeId")
    fun getAverageRatingForRecipe(@Param("recipeId") recipeId: Long): Double?
}
