package com.fridge.recipe.util

import com.fridge.recipe.enum.Season
import java.time.LocalDateTime

object DateUtil {
    fun getCurrentSeason(): Season {
        val month = LocalDateTime.now().monthValue

        return when (month) {
            3, 4, 5 -> Season.SPRING   // 봄: 3-5월
            6, 7, 8 -> Season.SUMMER   // 여름: 6-8월
            9, 10, 11 -> Season.FALL   // 가을: 9-11월
            else -> Season.WINTER      // 겨울: 12-2월
        }
    }
}