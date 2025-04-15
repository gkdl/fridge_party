package com.fridge.recipe.adapter

import com.fridge.recipe.mapper.toDTO
import com.fridge.recipe.port.TipPort
import com.fridge.recipe.repository.CookingTipRepository
import com.fridge.recipe.repository.ExpiryTipRepository
import com.fridge.recipe.vo.CookingTipDTO
import com.fridge.recipe.vo.ExpiryTipDTO
import org.springframework.stereotype.Component
import kotlin.math.min

@Component
class TipAdapter (
    private val cookingTipRepository: CookingTipRepository,
    private val expiryTipRepository: ExpiryTipRepository
) : TipPort {

    /**
     * 랜덤한 요리 팁을 가져옵니다.
     * @param count 가져올 개수
     * @return 요리 팁 DTO 목록
     */
    override fun getRandomCookingTips(count: Int): List<CookingTipDTO> {
        val allTips = cookingTipRepository.findAll()
        val totalTips = allTips.size

        if (totalTips == 0) return emptyList()

        // 랜덤하게 선택
        val shuffled = allTips.shuffled()
        val selected = shuffled.subList(0, min(count, totalTips))

        return selected.map { it.toDTO() }
    }

    /**
     * 랜덤한 유통기한 임박 식재료 활용 팁을 가져옵니다.
     * @param count 가져올 개수
     * @return 유통기한 팁 DTO 목록
     */
    override fun getRandomExpiryTips(count: Int): List<ExpiryTipDTO> {
        val allTips = expiryTipRepository.findAll()
        val totalTips = allTips.size

        if (totalTips == 0) return emptyList()

        // 랜덤하게 선택
        val shuffled = allTips.shuffled()
        val selected = shuffled.subList(0, min(count, totalTips))

        return selected.map { it.toDTO() }
    }
}