package com.fridge.recipe.repository

import com.fridge.recipe.entity.Favorite
import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.User
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface FavoriteRepository : JpaRepository<Favorite, Long> {
    fun findByUser(user: User, pageable: Pageable): Page<Favorite>
    fun findByUserAndRecipe(user: User, recipe: Recipe): Optional<Favorite>
    fun existsByUserAndRecipe(user: User, recipe: Recipe): Boolean
    fun deleteByUserAndRecipe(user: User, recipe: Recipe)
}
