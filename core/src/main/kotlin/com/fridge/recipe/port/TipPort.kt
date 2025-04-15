package com.fridge.recipe.port

import com.fridge.recipe.vo.CookingTipDTO
import com.fridge.recipe.vo.ExpiryTipDTO

interface TipPort {
    fun getRandomCookingTips(count: Int): List<CookingTipDTO>

    fun getRandomExpiryTips(count: Int): List<ExpiryTipDTO>
}