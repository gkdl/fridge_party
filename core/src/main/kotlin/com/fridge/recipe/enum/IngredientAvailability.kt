package com.fridge.recipe.enum

enum class IngredientAvailability {
    HIGH,    // 제철 (풍부하게 공급됨)
    MEDIUM,  // 일반적으로 구할 수 있음
    LOW,     // 구하기 어려움
    NONE     // 해당 계절에 구할 수 없음
}