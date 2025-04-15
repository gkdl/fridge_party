package com.fridge.recipe.port

import com.fridge.recipe.vo.*

interface UserActivityPort {
    fun recordActivity(userId: Long, activityCreateDTO: UserActivityCreateDTO): UserActivityDTO

    fun getUserActivityStats(userId: Long): UserActivityStatsDTO
}