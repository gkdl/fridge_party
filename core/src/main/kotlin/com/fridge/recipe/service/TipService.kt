package com.fridge.recipe.service

import com.fridge.recipe.port.TipPort
import com.fridge.recipe.vo.CookingTipDTO
import com.fridge.recipe.vo.ExpiryTipDTO
import org.springframework.stereotype.Service

@Service
class TipService(
    private val tpPort: TipPort
) {
    fun getRandomCookingTips(count: Int): List<CookingTipDTO> {
        return tpPort.getRandomCookingTips(count)
    }

    fun getRandomExpiryTips(count: Int): List<ExpiryTipDTO> {
        return tpPort.getRandomExpiryTips(count)
    }
}
