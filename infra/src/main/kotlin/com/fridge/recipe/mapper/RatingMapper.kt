package com.fridge.recipe.mapper

import com.fridge.recipe.entity.Rating
import com.fridge.recipe.vo.RatingDTO
import java.time.format.DateTimeFormatter

fun Rating.toDTO(): RatingDTO {
    return RatingDTO(
        id = this.id,
        userId = this.user.id,
        username = this.user.username,
        recipeId = this.recipe.id,
        rating = this.rating,
        comment = this.comment,
        createdAt = this.createdAt.format(DateTimeFormatter.ISO_DATE_TIME)
    )
}