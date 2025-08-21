package com.fridge.recipe.repository

import com.fridge.recipe.entity.Favorite
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
interface FavoriteRepository : JpaRepository<Favorite, Long> {
    fun findByUser(user: User, pageable: Pageable): Page<Favorite>
    fun countByRecipe(recipe: Recipe): Int
    fun countByUser(user: User): Int
    fun findByUserAndRecipe(user: User, recipe: Recipe): Optional<Favorite>
    fun existsByUserAndRecipe(user: User, recipe: Recipe): Boolean
    fun deleteByUserAndRecipe(user: User, recipe: Recipe)
    @Query("SELECT f FROM Favorite f WHERE f.user.id = :userId AND f.recipe.id = :recipeId")
    fun findByUserIdAndRecipeId(@Param("userId") userId: Long, @Param("recipeId") recipeId: Long): Optional<Favorite>
}
