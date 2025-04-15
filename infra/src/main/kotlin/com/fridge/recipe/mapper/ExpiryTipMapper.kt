package com.fridge.recipe.mapper

import com.fridge.recipe.entity.ExpiryTip
import com.fridge.recipe.vo.ExpiryTipDTO

fun ExpiryTip.toDTO(): ExpiryTipDTO {
    return ExpiryTipDTO(
        id = this.id,
        ingredientName = this.ingredientName,
        tipContent = this.tipContent,
        recipeSuggestion = this.recipeSuggestion,
        imageUrl = this.imageUrl,
        createdAt = this.createdAt.toString()
    )
}