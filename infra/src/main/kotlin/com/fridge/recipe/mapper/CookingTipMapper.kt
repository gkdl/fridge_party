package com.fridge.recipe.mapper

import com.fridge.recipe.entity.CookingTip
import com.fridge.recipe.vo.CookingTipDTO

fun CookingTip.toDTO(): CookingTipDTO {
    return CookingTipDTO(
        id = this.id,
        title = this.title,
        content = this.content,
        category = this.category,
        imageUrl = this.imageUrl,
        createdAt = this.createdAt.toString()
    )
}