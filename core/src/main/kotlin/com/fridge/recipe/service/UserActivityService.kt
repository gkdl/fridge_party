package com.fridge.recipe.service

import com.fridge.recipe.port.UserActivityPort
import com.fridge.recipe.vo.UserActivityCreateDTO
import com.fridge.recipe.vo.UserActivityDTO
import com.fridge.recipe.vo.UserActivityStatsDTO
import org.springframework.stereotype.Service
import javax.transaction.Transactional

@Service
@Transactional
class UserActivityService(
    private val userActivityPort: UserActivityPort
) {
    fun recordActivity(userId: Long, activityCreateDTO: UserActivityCreateDTO): UserActivityDTO {
        return userActivityPort.recordActivity(userId, activityCreateDTO)
    }

    fun getUserActivityStats(userId: Long): UserActivityStatsDTO {
        return userActivityPort.getUserActivityStats(userId)
    }
}
